import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_ble/universal_ble.dart';

import '../../core/arcana/zodiac.dart';
import '../../core/arcana/animated_arcana_card.dart';
import '../../core/aether/guidance_mode.dart';
import '../../core/controls.dart';
import '../../core/energy/energy.dart';
import '../../core/health/health_hub.dart';
import '../../core/health/health_providers.dart';
import '../../core/live/bluetooth_permissions.dart';
import '../../core/profile.dart';
import '../../core/theme.dart';
import '../../core/tokens.dart';
import '../../core/widgets.dart';

String _formatUtcOffset(int minutes) {
  final sign = minutes < 0 ? '−' : '+';
  final absolute = minutes.abs();
  final hours = (absolute ~/ 60).toString().padLeft(2, '0');
  final remainder = (absolute % 60).toString().padLeft(2, '0');
  return 'UTC$sign$hours:$remainder';
}

/// Onboarding — spec 05, skeleton version.
/// Pages: Welcome · DOB · Arcana reveal · Body · Done.
/// M1 finishes: constellation-forming DOB picker, Rive flip, permissions,
/// source connection cards, persistence.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _page = PageController();
  DateTime? _dob;
  Sex _sex = Sex.unspecified;
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _birthPlaceCtrl = TextEditingController();
  final _birthLatitudeCtrl = TextEditingController();
  final _birthLongitudeCtrl = TextEditingController();
  final _sources = <String>{};
  bool _haptics = true;
  bool _flash = true;
  bool _healthReady = false;
  bool _bluetoothReady = false;
  bool _settingUpConnection = false;
  String? _connectionMessage;
  TimeOfDay? _birthTime;
  late int _birthUtcOffsetMinutes;
  double? _birthLatitude;
  double? _birthLongitude;
  GuidanceMode _guidanceMode = GuidanceMode.immersive;
  bool _resolvingBirthPlace = false;
  String? _birthPlaceError;

  @override
  void initState() {
    super.initState();
    _birthUtcOffsetMinutes = DateTime.now().timeZoneOffset.inMinutes;
    _lifecycleObserver;
  }

  late final AppLifecycleListener _lifecycleObserver = AppLifecycleListener(
    onResume: () async {
      if (_bluetoothReady || _settingUpConnection) return;
      final scan = await Permission.bluetoothScan.isGranted;
      final connect = await Permission.bluetoothConnect.isGranted;
      if (scan && connect && mounted) await _enableBluetooth();
    },
  );

  @override
  void dispose() {
    _lifecycleObserver.dispose();
    _page.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    _firstNameCtrl.dispose();
    _birthPlaceCtrl.dispose();
    _birthLatitudeCtrl.dispose();
    _birthLongitudeCtrl.dispose();
    super.dispose();
  }

  void _next() => _page.nextPage(
      duration: EterMotion.durStandard, curve: EterMotion.easeAir);

  bool _bodyIsValid() {
    final weight = double.tryParse(_weightCtrl.text.replaceAll(',', '.'));
    return _dob != null && weight != null && weight > 0;
  }

  Profile _profile() {
    final weight = double.parse(_weightCtrl.text.replaceAll(',', '.'));
    final height = double.tryParse(_heightCtrl.text.replaceAll(',', '.'));
    return Profile(
      dob: _dob!,
      sex: _sex,
      weightKg: weight,
      heightCm: height,
      hapticsEnabled: _haptics,
      flashEnabled: _flash,
      connectedSources: Set.unmodifiable(_sources),
      firstName: _firstNameCtrl.text.trim().isEmpty
          ? null
          : _firstNameCtrl.text.trim(),
      guidanceMode: _guidanceMode,
      birthTimeMinutes: _birthTime == null
          ? null
          : _birthTime!.hour * 60 + _birthTime!.minute,
      birthUtcOffsetMinutes: _birthTime == null ? null : _birthUtcOffsetMinutes,
      birthPlace: _birthPlaceCtrl.text.trim().isEmpty
          ? null
          : _birthPlaceCtrl.text.trim(),
      birthLatitude: _birthLatitude,
      birthLongitude: _birthLongitude,
    );
  }

  Future<void> _resolveBirthPlaceAndContinue() async {
    final query = _birthPlaceCtrl.text.trim();
    if (query.length < 2 || _birthTime == null) {
      setState(() => _birthPlaceError =
          'Enter a birthplace and birth time to calculate the natal chart.');
      return;
    }
    setState(() {
      _resolvingBirthPlace = true;
      _birthPlaceError = null;
    });
    try {
      final locations = await locationFromAddress(query);
      if (locations.isEmpty) throw StateError('No location');
      if (!mounted) return;
      setState(() {
        _birthLatitude = locations.first.latitude;
        _birthLongitude = locations.first.longitude;
      });
      _next();
    } catch (_) {
      if (mounted) {
        setState(() => _birthPlaceError =
            'That birthplace could not be resolved. Check the city and country, or enter its coordinates below.');
      }
    } finally {
      if (mounted) setState(() => _resolvingBirthPlace = false);
    }
  }

  void _useManualCoordinatesAndContinue() {
    final latitude =
        double.tryParse(_birthLatitudeCtrl.text.trim().replaceAll(',', '.'));
    final longitude =
        double.tryParse(_birthLongitudeCtrl.text.trim().replaceAll(',', '.'));
    if (latitude == null ||
        longitude == null ||
        latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      setState(() => _birthPlaceError =
          'Enter a latitude from −90 to 90 and longitude from −180 to 180.');
      return;
    }
    setState(() {
      _birthLatitude = latitude;
      _birthLongitude = longitude;
      _birthPlaceError = null;
    });
    _next();
  }

  void _complete() {
    if (!_bodyIsValid()) return;
    ref.read(profileProvider.notifier).complete(_profile());
  }

  Future<void> _connectHealth() async {
    setState(() {
      _settingUpConnection = true;
      _connectionMessage = null;
    });
    try {
      final hub = ref.read(healthHubProvider);
      var state = await hub.permissionState();
      if (state != HealthPermissionState.granted) {
        state = await hub.requestPermissions();
      }
      if (state != HealthPermissionState.granted) {
        throw StateError('Health permission was not granted');
      }
      final now = DateTime.now();
      final localStart = DateTime(now.year, now.month, now.day);
      final result = await ref
          .read(healthIngestServiceProvider)
          .syncDay(dayStartUtc: localStart.toUtc());
      if (!mounted) return;
      setState(() {
        _healthReady = true;
        _sources.add('Health Connect');
        _connectionMessage = result.recordsRead == 0
            ? 'Health Connect is ready. No records were available today yet.'
            : 'Imported ${result.steps} steps and ${result.activeKcal.round()} active kcal.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _connectionMessage =
            'Allow Steps, Heart rate, and Active calories in Health Connect, then retry.';
      });
    } finally {
      if (mounted) setState(() => _settingUpConnection = false);
    }
  }

  Future<void> _enableBluetooth() async {
    setState(() {
      _settingUpConnection = true;
      _connectionMessage = null;
    });
    try {
      final permission = await ensureBluetoothPermissions();
      if (permission != BluetoothPermissionResult.granted) {
        if (!mounted) return;
        setState(() {
          _connectionMessage = permission ==
                  BluetoothPermissionResult.openedSettings
              ? 'Allow Nearby devices for Eter, then return here and tap again.'
              : 'Bluetooth permission could not be opened. Retry to continue.';
        });
        return;
      }
      // A short real scan verifies that the Bluetooth adapter and platform
      // permissions are usable; selecting a powered sensor happens in Live.
      await UniversalBle.startScan();
      await Future<void>.delayed(const Duration(milliseconds: 900));
      await UniversalBle.stopScan();
      if (!mounted) return;
      setState(() {
        _bluetoothReady = true;
        _sources.add('Bluetooth heart-rate sensor');
        _connectionMessage =
            'Bluetooth is ready. Pair a broadcasting sensor from Live.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _connectionMessage =
            'Bluetooth is unavailable. Turn Bluetooth on, then retry.';
      });
    } finally {
      if (mounted) setState(() => _settingUpConnection = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SkyBackground(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: EterColors.mist0.withValues(alpha: 0.12)),
            SafeArea(
              child: PageView(
                controller: _page,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _pad(_WelcomePage(onBegin: _next)),
                  _pad(_DobPage(
                    dob: _dob,
                    onPicked: (d) => setState(() => _dob = d),
                    onNext: _next,
                  )),
                  _pad(_SymbolicSetupPage(
                    firstNameController: _firstNameCtrl,
                    birthPlaceController: _birthPlaceCtrl,
                    birthLatitudeController: _birthLatitudeCtrl,
                    birthLongitudeController: _birthLongitudeCtrl,
                    birthTime: _birthTime,
                    utcOffsetMinutes: _birthUtcOffsetMinutes,
                    mode: _guidanceMode,
                    resolving: _resolvingBirthPlace,
                    error: _birthPlaceError,
                    onTime: (value) => setState(() => _birthTime = value),
                    onUtcOffset: (value) =>
                        setState(() => _birthUtcOffsetMinutes = value),
                    onMode: (value) => setState(() => _guidanceMode = value),
                    onNext: _resolveBirthPlaceAndContinue,
                    onManualCoordinates: _useManualCoordinatesAndContinue,
                  )),
                  _pad(_dob == null
                      ? const SizedBox.shrink()
                      : _ArcanaRevealPage(
                          zodiac: Zodiac.fromDate(_dob!), onNext: _next)),
                  _pad(_BodyPage(
                    sex: _sex,
                    onSex: (s) => setState(() => _sex = s),
                    weightCtrl: _weightCtrl,
                    heightCtrl: _heightCtrl,
                    onDone: () {
                      if (_bodyIsValid()) _next();
                    },
                  )),
                  _pad(_ConnectionsPage(
                    healthReady: _healthReady,
                    bluetoothReady: _bluetoothReady,
                    busy: _settingUpConnection,
                    message: _connectionMessage,
                    onHealth: _connectHealth,
                    onBluetooth: _enableBluetooth,
                    onNext: _healthReady && _bluetoothReady ? _next : null,
                  )),
                  _pad(_AlertsPage(
                    haptics: _haptics,
                    flash: _flash,
                    onHaptics: (value) => setState(() => _haptics = value),
                    onFlash: (value) => setState(() => _flash = value),
                    onNext: _next,
                  )),
                  _pad(_dob == null || !_bodyIsValid()
                      ? const SizedBox.shrink()
                      : _DonePage(profile: _profile(), onDone: _complete)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pad(Widget child) => Padding(
      padding: const EdgeInsets.all(EterSpace.s32),
      child: Center(child: child));
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.onBegin});
  final VoidCallback onBegin;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final night = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Commissioned hero plate (STATIC_ASSET_REQUESTS.md §A).
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(EterSpace.rChip),
            border: Border.all(
              color: EterColors.aura500.withValues(alpha: night ? 0.5 : 0.35),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/art/onboarding-hero.webp',
            height: 240,
            width: 160, // master is 2:3 (1200x1800); both dims stay fixed
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            semanticLabel: 'An eight-pointed star above an open palm',
          ),
        ),
        const SizedBox(height: EterSpace.s32),
        Text('Eter', style: text.displayLarge?.copyWith(fontSize: 56)),
        const SizedBox(height: EterSpace.s8),
        Text('Measure the body. Read the pattern.', style: text.bodyLarge),
        const SizedBox(height: EterSpace.s32),
        EterAction(
          label: 'Begin',
          emphasis: EterActionEmphasis.primary,
          onPressed: onBegin,
        ),
      ],
    );
  }
}

class _DobPage extends StatelessWidget {
  const _DobPage(
      {required this.dob, required this.onPicked, required this.onNext});
  final DateTime? dob;
  final ValueChanged<DateTime> onPicked;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('When were you born?',
            style: text.displayMedium, textAlign: TextAlign.center),
        const SizedBox(height: EterSpace.s8),
        Text('Your card — and your energy math — begin here.',
            style: text.bodyMedium, textAlign: TextAlign.center),
        const SizedBox(height: EterSpace.s32),
        EterAction(
          label: dob == null
              ? 'Choose date'
              : DateFormat('d MMMM yyyy').format(dob!),
          onPressed: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime(now.year - 25),
              firstDate: DateTime(now.year - 100),
              lastDate: DateTime(now.year - 16), // age gate, spec 16
            );
            if (picked != null) onPicked(picked);
          },
        ),
        const SizedBox(height: EterSpace.s48),
        if (dob != null)
          EterAction(
            label: 'Continue',
            emphasis: EterActionEmphasis.primary,
            onPressed: onNext,
          ),
      ],
    );
  }
}

class _SymbolicSetupPage extends StatelessWidget {
  const _SymbolicSetupPage({
    required this.firstNameController,
    required this.birthPlaceController,
    required this.birthLatitudeController,
    required this.birthLongitudeController,
    required this.birthTime,
    required this.utcOffsetMinutes,
    required this.mode,
    required this.resolving,
    required this.error,
    required this.onTime,
    required this.onUtcOffset,
    required this.onMode,
    required this.onNext,
    required this.onManualCoordinates,
  });

  final TextEditingController firstNameController;
  final TextEditingController birthPlaceController;
  final TextEditingController birthLatitudeController;
  final TextEditingController birthLongitudeController;
  final TimeOfDay? birthTime;
  final int utcOffsetMinutes;
  final GuidanceMode mode;
  final bool resolving;
  final String? error;
  final ValueChanged<TimeOfDay> onTime;
  final ValueChanged<int> onUtcOffset;
  final ValueChanged<GuidanceMode> onMode;
  final VoidCallback onNext;
  final VoidCallback onManualCoordinates;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('How should Aether meet you?',
              style: text.displayMedium, textAlign: TextAlign.center),
          const SizedBox(height: EterSpace.s8),
          Text(
            'Birth time and place are used for deterministic chart calculations. Health evidence always takes priority.',
            style: text.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: EterSpace.s24),
          TextField(
            controller: firstNameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'First name'),
          ),
          const SizedBox(height: EterSpace.s12),
          TextField(
            controller: birthPlaceController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Birthplace',
              hintText: 'City, country',
            ),
          ),
          const SizedBox(height: EterSpace.s12),
          OutlinedButton.icon(
            onPressed: () async {
              final value = await showTimePicker(
                context: context,
                initialTime: birthTime ?? const TimeOfDay(hour: 12, minute: 0),
              );
              if (value != null) onTime(value);
            },
            icon: const Icon(Icons.schedule),
            label: Text(
              birthTime == null
                  ? 'Choose birth time'
                  : 'Birth time ${birthTime!.format(context)}',
            ),
          ),
          const SizedBox(height: EterSpace.s12),
          DropdownButtonFormField<int>(
            initialValue: utcOffsetMinutes,
            decoration: const InputDecoration(
              labelText: 'Birthplace UTC offset',
              helperText: 'Use the offset that applied on your birth date.',
            ),
            items: [
              for (var minutes = -12 * 60; minutes <= 14 * 60; minutes += 30)
                DropdownMenuItem(
                  value: minutes,
                  child: Text(_formatUtcOffset(minutes)),
                ),
            ],
            onChanged: (value) {
              if (value != null) onUtcOffset(value);
            },
          ),
          const SizedBox(height: EterSpace.s16),
          SegmentedButton<GuidanceMode>(
            segments: const [
              ButtonSegment(
                value: GuidanceMode.grounded,
                label: Text('Grounded'),
              ),
              ButtonSegment(
                value: GuidanceMode.balanced,
                label: Text('Balanced'),
              ),
              ButtonSegment(
                value: GuidanceMode.immersive,
                label: Text('Immersive'),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (selection) => onMode(selection.single),
            // The check icon takes enough width from the selected segment to
            // break "Immersive" across two lines; the segment's fill already
            // shows which mode is chosen.
            showSelectedIcon: false,
          ),
          const SizedBox(height: EterSpace.s8),
          Text(
            mode == GuidanceMode.immersive
                ? 'Symbolic language and Arcana will be more visible.'
                : mode == GuidanceMode.grounded
                    ? 'Practical health and habit guidance stays foremost.'
                    : 'Health evidence and symbolic reflection share the frame.',
            style: text.bodySmall,
            textAlign: TextAlign.center,
          ),
          if (error != null) ...[
            const SizedBox(height: EterSpace.s12),
            Text(
              error!,
              style: const TextStyle(color: EterColors.danger),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: EterSpace.s12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: birthLatitudeController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                      hintText: '52.2297',
                    ),
                  ),
                ),
                const SizedBox(width: EterSpace.s12),
                Expanded(
                  child: TextField(
                    controller: birthLongitudeController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                      hintText: '21.0122',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: EterSpace.s12),
            OutlinedButton(
              onPressed: onManualCoordinates,
              child: const Text('Use coordinates'),
            ),
          ],
          const SizedBox(height: EterSpace.s24),
          FilledButton(
            onPressed: resolving ? null : onNext,
            child: Text(resolving ? 'Finding birthplace…' : 'Continue'),
          ),
        ],
      ),
    );
  }
}

/// Card flip reveal — simplified version of spec 04 §4 (Rive lands in M1).
class _ArcanaRevealPage extends StatefulWidget {
  const _ArcanaRevealPage({required this.zodiac, required this.onNext});
  final Zodiac zodiac;
  final VoidCallback onNext;

  @override
  State<_ArcanaRevealPage> createState() => _ArcanaRevealPageState();
}

class _ArcanaRevealPageState extends State<_ArcanaRevealPage> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final z = widget.zodiac;
    // The card and its revealed caption are taller than a short viewport, so
    // this scrolls once the keyboard, a small screen or a large text scale
    // takes the room away, and stays centred whenever there is room.
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedArcanaCard(
                zodiac: z,
                revealed: _revealed,
                onReveal: () => setState(() => _revealed = true),
              ),
              const SizedBox(height: EterSpace.s24),
              AnimatedOpacity(
                duration: EterMotion.durEmphasis,
                opacity: _revealed ? 1 : 0,
                child: Column(
                  children: [
                    Text('Born under ${z.label}', style: text.bodyLarge),
                    Text('${z.arcana} · ${z.numeral}',
                        style: text.displayMedium),
                    Text(z.subtitle, style: text.labelSmall),
                    const SizedBox(height: EterSpace.s16),
                    ElementMedallion(z.element, size: 48),
                    const SizedBox(height: EterSpace.s8),
                    Text('${z.element.label} element', style: text.labelSmall),
                    const SizedBox(height: EterSpace.s24),
                    EterAction(
                      label: 'Continue',
                      emphasis: EterActionEmphasis.primary,
                      onPressed: widget.onNext,
                    ),
                  ],
                ),
              ),
              if (!_revealed) Text('Tap the card', style: text.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _BodyPage extends StatelessWidget {
  const _BodyPage({
    required this.sex,
    required this.onSex,
    required this.weightCtrl,
    required this.heightCtrl,
    required this.onDone,
  });
  final Sex sex;
  final ValueChanged<Sex> onSex;
  final TextEditingController weightCtrl;
  final TextEditingController heightCtrl;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Your measurements', style: text.displayMedium),
          const SizedBox(height: EterSpace.s8),
          Text('Weight is required — it anchors every calorie formula.',
              style: text.bodyMedium, textAlign: TextAlign.center),
          const SizedBox(height: EterSpace.s24),
          SegmentedButton<Sex>(
            segments: const [
              ButtonSegment(value: Sex.female, label: Text('Female')),
              ButtonSegment(value: Sex.male, label: Text('Male')),
              ButtonSegment(value: Sex.unspecified, label: Text('Skip')),
            ],
            selected: {sex},
            onSelectionChanged: (s) => onSex(s.first),
          ),
          const SizedBox(height: EterSpace.s16),
          TextField(
            controller: weightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
                labelText: 'Weight (kg)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: EterSpace.s16),
          TextField(
            controller: heightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
                labelText: 'Height (cm) — optional',
                border: OutlineInputBorder()),
          ),
          const SizedBox(height: EterSpace.s32),
          EterAction(
            label: 'Continue',
            emphasis: EterActionEmphasis.primary,
            onPressed: onDone,
          ),
        ],
      ),
    );
  }
}

class _ConnectionsPage extends StatelessWidget {
  const _ConnectionsPage({
    required this.healthReady,
    required this.bluetoothReady,
    required this.busy,
    required this.message,
    required this.onHealth,
    required this.onBluetooth,
    required this.onNext,
  });

  final bool healthReady;
  final bool bluetoothReady;
  final bool busy;
  final String? message;
  final VoidCallback onHealth;
  final VoidCallback onBluetooth;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            Text('Connect your signals',
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: EterSpace.s8),
            const Text(
              'Eter needs health records and sensor access before it can measure your day.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: EterSpace.s32),
            _SetupTile(
              icon: Icons.health_and_safety_outlined,
              title: 'Health Connect',
              subtitle: healthReady
                  ? 'Authorized and initial sync complete'
                  : 'Steps, heart rate, and active calories',
              ready: healthReady,
              busy: busy,
              onTap: onHealth,
            ),
            const SizedBox(height: EterSpace.s12),
            _SetupTile(
              icon: Icons.bluetooth_searching,
              title: 'Live heart-rate sensors',
              subtitle: bluetoothReady
                  ? 'Nearby-device access verified'
                  : 'Chest straps and watch broadcast mode',
              ready: bluetoothReady,
              busy: busy,
              onTap: onBluetooth,
            ),
            if (message != null) ...[
              const SizedBox(height: EterSpace.s16),
              Text(message!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: EterSpace.s32),
            EterAction(
              label:
                  onNext == null ? 'Complete both connections' : 'Continue',
              emphasis: EterActionEmphasis.primary,
              onPressed: busy ? null : onNext,
            ),
          ],
        ),
      );
}

class _SetupTile extends StatelessWidget {
  const _SetupTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.ready,
    required this.busy,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool ready;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          leading: Icon(icon,
              color: ready ? EterColors.success : EterColors.aura700),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: ready
              ? const Icon(Icons.check_circle, color: EterColors.success)
              : const Icon(Icons.chevron_right),
          onTap: busy || ready ? null : onTap,
        ),
      );
}

class _AlertsPage extends StatelessWidget {
  const _AlertsPage(
      {required this.haptics,
      required this.flash,
      required this.onHaptics,
      required this.onFlash,
      required this.onNext});
  final bool haptics;
  final bool flash;
  final ValueChanged<bool> onHaptics;
  final ValueChanged<bool> onFlash;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Feel each milestone',
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center),
        const SizedBox(height: EterSpace.s8),
        const Text('Every 100 kcal of effort, Eter breathes with you.',
            textAlign: TextAlign.center),
        const SizedBox(height: EterSpace.s24),
        SwitchListTile(
            value: haptics,
            onChanged: onHaptics,
            title: const Text('Vibration')),
        SwitchListTile(
            value: flash,
            onChanged: onFlash,
            title: const Text('Screen flash')),
        const Text(
            'The flash is soft and rate-limited. Turn it off if you are sensitive to visual flashes.',
            textAlign: TextAlign.center),
        const SizedBox(height: EterSpace.s32),
        EterAction(
          label: 'Continue',
          emphasis: EterActionEmphasis.primary,
          onPressed: onNext,
        ),
      ]);
}

class _DonePage extends StatelessWidget {
  const _DonePage({required this.profile, required this.onDone});
  final Profile profile;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElementMedallion(profile.zodiac.element, size: 88),
        const SizedBox(height: EterSpace.s24),
        Text('Your profile is ready',
            style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: EterSpace.s12),
        Text(
            'Your body burns ~${profile.rmr.round()} kcal at rest. Everything above it, we track precisely.',
            textAlign: TextAlign.center),
        if (profile.rmrIsApproximate) ...[
          const SizedBox(height: EterSpace.s12),
          Text('Approximate · ${_precisionHint(profile)}'),
        ],
        const SizedBox(height: EterSpace.s32),
        EterAction(
          label: 'Enter Eter',
          emphasis: EterActionEmphasis.primary,
          onPressed: onDone,
        ),
      ]);

  String _precisionHint(Profile profile) {
    final missingHeight = profile.heightCm == null;
    final missingSex = profile.sex == Sex.unspecified;
    if (missingHeight && missingSex) {
      return 'add height and sex later for greater precision.';
    }
    if (missingHeight) return 'add height later for greater precision.';
    return 'add sex later for greater precision.';
  }
}
