import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_ble/universal_ble.dart';

import '../../core/controls.dart';
import '../../core/db/app_database.dart';
import '../../core/energy/energy.dart';
import '../../core/live/heart_rate.dart';
import '../../core/live/bluetooth_permissions.dart';
import '../../core/live/connection_state.dart';
import '../../core/profile.dart';
import '../../core/theme.dart';
import '../../core/tokens.dart';
import '../../core/widgets.dart';

class LiveScreen extends ConsumerStatefulWidget {
  const LiveScreen({super.key, this.compact = false});

  final bool compact;

  @override
  ConsumerState<LiveScreen> createState() => _LiveScreenState();
}

class PulseBlock extends LiveScreen {
  const PulseBlock({super.key}) : super(compact: true);
}

class _LiveScreenState extends ConsumerState<LiveScreen> {
  static const _service = '180D';
  static const _measurement = '2A37';
  static const _batteryService = '180F';
  static const _batteryLevel = '2A19';
  static const _reconnectPolicy = ReconnectPolicy();

  final Map<String, BleDevice> _devices = {};
  final Map<String, RememberedSensorRow> _remembered = {};
  final List<Map<String, Object>> _samples = [];
  StreamSubscription<BleDevice>? _scanSubscription;
  StreamSubscription<List<int>>? _heartSubscription;
  StreamSubscription<bool>? _connectionSubscription;
  StreamSubscription<AvailabilityState>? _availabilitySubscription;
  Timer? _timer;
  Timer? _packetTimeout;
  Timer? _reconnectTimer;
  BleDevice? _sensor;
  DateTime? _startedAt;
  int _elapsedSeconds = 0;
  int? _bpm;
  int? _batteryPercent;
  DateTime? _lastPacketAt;
  double _kcal = 0;
  bool _scanning = false;
  bool _connecting = false;
  String? _message;
  SensorConnectionPhase _phase = SensorConnectionPhase.idle;
  int _reconnectAttempt = 0;
  bool _disposing = false;
  bool _canAutoReconnect = false;

  bool get _active => _startedAt != null;

  @override
  void initState() {
    super.initState();
    if (eterRunningTests()) {
      // BLE platform channels do not exist under flutter_test; the atlas
      // captures the idle surface without touching the BLE stack.
      return;
    }
    _availabilitySubscription = UniversalBle.availabilityStream.listen((state) {
      if (!mounted) return;
      if (state == AvailabilityState.poweredOff) {
        _packetTimeout?.cancel();
        _reconnectTimer?.cancel();
        setState(() {
          _phase = SensorConnectionPhase.bluetoothOff;
          _bpm = null;
          _message = 'Turn Bluetooth on to use a live heart-rate sensor.';
        });
      } else if (state == AvailabilityState.poweredOn &&
          _phase == SensorConnectionPhase.bluetoothOff) {
        setState(() {
          _phase = SensorConnectionPhase.idle;
          _message = null;
        });
      }
    });
    Future<void>.microtask(_restoreRememberedSensors);
  }

  Future<void> _restoreRememberedSensors() async {
    final rows = await ref.read(databaseProvider).getRememberedSensors();
    if (!mounted) return;
    for (final row in rows) {
      _remembered[row.deviceId] = row;
      _devices[row.deviceId] = BleDevice(
        deviceId: row.deviceId,
        name: row.name,
        paired: row.paired,
      );
    }
    setState(() {});
    try {
      final system = await UniversalBle.getSystemDevices(
        withServices: const [_service],
        timeout: const Duration(seconds: 8),
      );
      if (!mounted) return;
      for (final device in system) {
        _devices[device.deviceId] = device;
      }
      setState(() {});
    } catch (_) {
      // Remembered entries remain available for an explicit reconnect.
    }
  }

  @override
  void dispose() {
    _disposing = true;
    _timer?.cancel();
    _packetTimeout?.cancel();
    _scanSubscription?.cancel();
    _heartSubscription?.cancel();
    _connectionSubscription?.cancel();
    _availabilitySubscription?.cancel();
    _reconnectTimer?.cancel();
    if (!eterRunningTests()) {
      UniversalBle.stopScan();
      final sensor = _sensor;
      if (sensor != null) UniversalBle.disconnect(sensor.deviceId);
    }
    super.dispose();
  }

  Future<void> _scan() async {
    if (_scanning) {
      await UniversalBle.stopScan();
      if (mounted) setState(() => _scanning = false);
      if (mounted) setState(() => _phase = SensorConnectionPhase.idle);
      return;
    }
    try {
      final permission = await ensureBluetoothPermissions();
      if (permission != BluetoothPermissionResult.granted) {
        if (!mounted) return;
        setState(() {
          _scanning = false;
          _message = permission == BluetoothPermissionResult.openedSettings
              ? 'Allow Nearby devices for Eter, then return and scan again.'
              : 'Bluetooth permission could not be opened. Retry to continue.';
        });
        return;
      }
      _devices.clear();
      await _scanSubscription?.cancel();
      _scanSubscription = UniversalBle.scanStream.listen((device) {
        final advertisesHeartRate = device.services.any(
          (uuid) =>
              BleUuidParser.string(uuid) == BleUuidParser.string(_service),
        );
        if ((device.name?.isEmpty ?? true) && !advertisesHeartRate) return;
        if (!mounted) return;
        setState(() => _devices[device.deviceId] = device);
      });
      // Many chest straps and Garmin broadcast sessions put the Heart Rate
      // service in a secondary advertisement. A service-filtered Android scan
      // silently excludes them, so discover broadly and verify GATT on connect.
      await UniversalBle.startScan();
      setState(() {
        _scanning = true;
        _phase = SensorConnectionPhase.searching;
        _message = null;
      });
      Future<void>.delayed(const Duration(seconds: 12), () async {
        if (!_scanning) return;
        await UniversalBle.stopScan();
        if (mounted) setState(() => _scanning = false);
        if (mounted && _sensor == null) {
          setState(() => _phase = SensorConnectionPhase.idle);
        }
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _scanning = false;
          _phase = SensorConnectionPhase.failed;
          _message = 'Bluetooth access is needed to find a heart-rate sensor.';
        });
      }
    }
  }

  Future<void> _connect(BleDevice device, {bool reconnecting = false}) async {
    _reconnectTimer?.cancel();
    setState(() {
      _sensor = device;
      _canAutoReconnect = false;
      _connecting = true;
      _phase = reconnecting
          ? SensorConnectionPhase.reconnecting
          : SensorConnectionPhase.connecting;
      _message = null;
    });
    try {
      await UniversalBle.stopScan();
      await UniversalBle.connect(device.deviceId);
      await _connectionSubscription?.cancel();
      _connectionSubscription =
          UniversalBle.connectionStream(device.deviceId).listen((connected) {
        if (connected || !mounted || _sensor?.deviceId != device.deviceId) {
          return;
        }
        _packetTimeout?.cancel();
        setState(() {
          _bpm = null;
          _phase = SensorConnectionPhase.disconnected;
          _message = 'Sensor disconnected. Tap it to reconnect.';
        });
        if (!_disposing && _canAutoReconnect) _scheduleReconnect(device);
      });
      final services = await UniversalBle.discoverServices(
        device.deviceId,
        timeout: const Duration(seconds: 12),
      );
      BleService? heartService;
      BleCharacteristic? heartCharacteristic;
      BleService? batteryService;
      BleCharacteristic? batteryCharacteristic;
      for (final service in services) {
        if (service.uuid == BleUuidParser.string(_batteryService)) {
          batteryService = service;
          for (final characteristic in service.characteristics) {
            if (characteristic.uuid == BleUuidParser.string(_batteryLevel)) {
              batteryCharacteristic = characteristic;
              break;
            }
          }
        }
        if (service.uuid != BleUuidParser.string(_service)) continue;
        heartService = service;
        for (final characteristic in service.characteristics) {
          if (characteristic.uuid == BleUuidParser.string(_measurement)) {
            heartCharacteristic = characteristic;
            break;
          }
        }
      }
      if (heartService == null || heartCharacteristic == null) {
        await UniversalBle.disconnect(device.deviceId);
        throw const FormatException('No standard heart-rate service');
      }
      var paired = false;
      try {
        paired = await UniversalBle.isPaired(
              device.deviceId,
              timeout: const Duration(seconds: 6),
            ) ??
            false;
        if (!paired) {
          await UniversalBle.pair(
            device.deviceId,
            timeout: const Duration(seconds: 15),
          );
          paired = true;
        }
      } catch (_) {
        // Most chest straps and Garmin Broadcast Heart Rate sessions do not
        // require bonding. Continue with a standards-based GATT subscription.
      }
      _heartSubscription = UniversalBle.characteristicValueStream(
        device.deviceId,
        heartCharacteristic.uuid,
      ).listen((bytes) {
        try {
          final sample = parseHeartRateMeasurement(bytes);
          if (!mounted) return;
          setState(() {
            _bpm = sample.bpm;
            _lastPacketAt = DateTime.now();
            _phase = SensorConnectionPhase.receiving;
            _message = null;
          });
          _armPacketTimeout(device);
          if (_active) {
            _samples.add({
              'second': _elapsedSeconds,
              'bpm': sample.bpm,
            });
          }
        } on FormatException {
          // Ignore malformed packets; the next notification replaces them.
        }
      });
      await UniversalBle.subscribeNotifications(
        device.deviceId,
        heartService.uuid,
        heartCharacteristic.uuid,
      );
      _canAutoReconnect = true;
      if (batteryService != null && batteryCharacteristic != null) {
        try {
          final bytes = await UniversalBle.read(
            device.deviceId,
            batteryService.uuid,
            batteryCharacteristic.uuid,
          );
          if (bytes.isNotEmpty) {
            _batteryPercent = bytes.first.clamp(0, 100);
          }
        } catch (_) {
          _batteryPercent = null;
        }
      }
      await ref.read(databaseProvider).rememberSensor(
            deviceId: device.deviceId,
            name: (device.name?.isNotEmpty ?? false)
                ? device.name!
                : 'Heart-rate sensor',
            paired: paired,
          );
      _packetTimeout?.cancel();
      _armPacketTimeout(device);
      if (mounted) {
        setState(() {
          _sensor = device;
          _phase = SensorConnectionPhase.connected;
          _reconnectAttempt = 0;
          _connecting = false;
          _scanning = false;
          _message = paired
              ? 'Paired and waiting for live heart rate…'
              : 'Connected and waiting for live heart rate…';
        });
      }
    } on FormatException {
      if (mounted) {
        setState(() {
          _sensor = null;
          _connecting = false;
          _phase = SensorConnectionPhase.failed;
          _message =
              'This device is visible, but it is not broadcasting the standard heart-rate service. Enable Broadcast Heart Rate on the watch or sensor, then scan again.';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _connecting = false;
          _phase = SensorConnectionPhase.failed;
          _message =
              'Connection failed. Make sure the sensor is awake, not connected to another app, and broadcasting heart rate.';
        });
      }
      if (reconnecting && !_disposing) _scheduleReconnect(device);
    }
  }

  void _armPacketTimeout(BleDevice device) {
    _packetTimeout?.cancel();
    _packetTimeout = Timer(const Duration(seconds: 10), () {
      if (!mounted || _sensor?.deviceId != device.deviceId) return;
      setState(() {
        _phase = SensorConnectionPhase.stale;
        _message =
            'Connected, but heart-rate data is stale. On Garmin, keep Broadcast Heart Rate open.';
      });
    });
  }

  void _scheduleReconnect(BleDevice device) {
    final attempt = _reconnectAttempt + 1;
    final delay = _reconnectPolicy.delayForAttempt(attempt);
    if (delay == null) {
      if (mounted) {
        setState(() {
          _phase = SensorConnectionPhase.failed;
          _message = 'Automatic reconnect stopped. Tap the sensor to retry.';
        });
      }
      return;
    }
    _reconnectAttempt = attempt;
    if (mounted) {
      setState(() {
        _phase = SensorConnectionPhase.reconnecting;
        _message =
            'Reconnecting in ${delay.inSeconds} second${delay.inSeconds == 1 ? '' : 's'}…';
      });
    }
    _reconnectTimer = Timer(delay, () {
      if (!_disposing && mounted) _connect(device, reconnecting: true);
    });
  }

  void _start() {
    final profile = ref.read(profileProvider);
    if (profile == null) return;
    _samples.clear();
    setState(() {
      _startedAt = DateTime.now();
      _elapsedSeconds = 0;
      _kcal = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final hr = (_bpm ?? 75).toDouble();
      final perMinute = sessionKcalPerMin(
        sex: profile.sex,
        hr: hr,
        weightKg: profile.weightKg,
        age: profile.age,
        restingKcalPerMin: profile.restingKcalPerMin,
      );
      setState(() {
        _elapsedSeconds++;
        _kcal += perMinute / 60;
      });
    });
  }

  Future<void> _finish() async {
    final startedAt = _startedAt;
    if (startedAt == null) return;
    _timer?.cancel();
    final endedAt = DateTime.now();
    await ref.read(databaseProvider).saveLiveSession(
          LiveSessionsCompanion.insert(
            id: '${startedAt.millisecondsSinceEpoch}',
            startedAt: startedAt.toUtc(),
            endedAt: endedAt.toUtc(),
            sourceId: _sensor?.deviceId ?? 'estimated',
            hrSeriesJson: jsonEncode(_samples),
            finalKcal: _kcal,
          ),
        );
    if (!mounted) return;
    setState(() {
      _startedAt = null;
      _message =
          'Session sealed · ${_formatTime(_elapsedSeconds)} · ${_kcal.round()} kcal';
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final text = Theme.of(context).textTheme;
    final zone = profile == null || _bpm == null
        ? 0
        : hrZone(_bpm!.toDouble(), hrMaxTanaka(profile.age));
    if (widget.compact) {
      return EterPlate(
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.favorite, color: EterColors.elemFire),
                const SizedBox(width: EterSpace.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('THE PULSE', style: text.labelSmall),
                      Text(_phase.label, style: text.titleMedium),
                    ],
                  ),
                ),
                Text(
                  '${_bpm ?? '—'} BPM',
                  style: text.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: EterSpace.s16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Metric('TIME', _formatTime(_elapsedSeconds)),
                _Metric('ENERGY', '${_kcal.round()} kcal'),
                _Metric('SOURCE', _sensor == null ? 'Estimated' : 'Zone $zone'),
              ],
            ),
            const SizedBox(height: EterSpace.s16),
            EterAction(
              label: _active ? 'Finish session' : 'Begin session',
              emphasis: EterActionEmphasis.primary,
              icon: _active ? Icons.stop_outlined : Icons.play_arrow_outlined,
              onPressed: _active
                  ? _finish
                  : _sensor != null && _phase != SensorConnectionPhase.receiving
                      ? null
                      : _start,
            ),
            if (_sensor == null)
              Padding(
                padding: const EdgeInsets.only(top: EterSpace.s8),
                child: Text(
                  'Sensor pairing and forgetting live in The Sanctum.',
                  style: text.bodySmall,
                ),
              ),
          ],
        ),
      );
    }
    return SkyBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            EterSpace.gutter,
            EterSpace.s24,
            EterSpace.gutter,
            132,
          ),
          children: [
            Text('Live Session', style: text.displayMedium),
            Text(_phase.label, style: text.titleMedium),
            Text(
              _active
                  ? 'Heart rate and energy in real time'
                  : 'Pair a sensor or begin with an estimate',
              style: text.bodyMedium,
            ),
            const SizedBox(height: EterSpace.s24),
            EterPlate(
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: EterMotion.durStandard,
                    width: 148,
                    height: 148,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: EterColors.aura500,
                        width: _active ? 3 : 1,
                      ),
                      boxShadow: _active
                          ? [
                              BoxShadow(
                                color:
                                    EterColors.aura500.withValues(alpha: .28),
                                blurRadius: 32,
                                spreadRadius: 4,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.favorite,
                              color: EterColors.elemFire),
                          Text('${_bpm ?? '—'}', style: text.headlineLarge),
                          Text(_bpm == null ? 'BPM' : 'ZONE $zone',
                              style: text.labelSmall),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: EterSpace.s24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _Metric('TIME', _formatTime(_elapsedSeconds)),
                      _Metric('ENERGY', '${_kcal.round()} kcal'),
                      _Metric('SOURCE',
                          _sensor == null ? 'Estimated' : 'Heart rate'),
                    ],
                  ),
                  const SizedBox(height: EterSpace.s24),
                  EterAction(
                    label: _active ? 'Finish session' : 'Begin session',
                    emphasis: EterActionEmphasis.primary,
                    icon: _active
                        ? Icons.stop_outlined
                        : Icons.play_arrow_outlined,
                    onPressed: _active
                        ? _finish
                        : _sensor != null &&
                                _phase != SensorConnectionPhase.receiving
                            ? null
                            : _start,
                  ),
                ],
              ),
            ),
            const SizedBox(height: EterSpace.s24),
            Row(
              children: [
                Expanded(
                    child: Text('HEART-RATE SOURCE', style: text.labelSmall)),
                EterAction(
                  label: _scanning ? 'Stop' : 'Find sensor',
                  emphasis: EterActionEmphasis.quiet,
                  icon: _scanning
                      ? Icons.stop_outlined
                      : Icons.bluetooth_searching,
                  onPressed: _connecting ? null : _scan,
                ),
              ],
            ),
            if (_sensor != null)
              _SensorTile(
                device: _sensor!,
                connected: _phase == SensorConnectionPhase.connected ||
                    _phase == SensorConnectionPhase.receiving ||
                    _phase == SensorConnectionPhase.stale,
                batteryPercent: _batteryPercent,
                lastPacketAt: _lastPacketAt,
                onTap: null,
              )
            else
              ..._devices.values.map(
                (device) => _SensorTile(
                  device: device,
                  connected: false,
                  remembered: _remembered.containsKey(device.deviceId),
                  onTap: _connecting ? null : () => _connect(device),
                ),
              ),
            if (_devices.isEmpty && _sensor == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: EterSpace.s16),
                child: Text(
                  _scanning
                      ? 'Listening for nearby heart-rate services…'
                      : 'No sensor selected. Estimated sessions remain available.',
                  style: text.bodyMedium,
                ),
              ),
            if (_message != null) ...[
              const SizedBox(height: EterSpace.s16),
              Text(_message!, style: text.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }

  static String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '$minutes:${remainder.toString().padLeft(2, '0')}';
  }
}

class _Metric extends StatelessWidget {
  const _Metric(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      );
}

class _SensorTile extends StatelessWidget {
  const _SensorTile({
    required this.device,
    required this.connected,
    this.remembered = false,
    this.batteryPercent,
    this.lastPacketAt,
    required this.onTap,
  });
  final BleDevice device;
  final bool connected;
  final bool remembered;
  final int? batteryPercent;
  final DateTime? lastPacketAt;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          connected ? Icons.bluetooth_connected : Icons.bluetooth,
          color: connected ? EterColors.success : null,
        ),
        title: Text((device.name?.isNotEmpty ?? false)
            ? device.name!
            : 'Heart-rate sensor'),
        subtitle: Text(connected
            ? [
                'Connected',
                if (batteryPercent != null) 'battery $batteryPercent%',
                if (lastPacketAt != null)
                  'last packet ${lastPacketAt!.toLocal().toIso8601String().substring(11, 19)}',
              ].join(' · ')
            : remembered
                ? 'Remembered · tap to reconnect'
                : '${device.rssi ?? '—'} dBm · tap to connect'),
        trailing: connected ? const Icon(Icons.check) : const Icon(Icons.add),
        onTap: onTap,
      );
}