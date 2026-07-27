import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:universal_ble/universal_ble.dart';

import '../../core/controls.dart';
import '../../core/aether/guidance_mode.dart';
import '../../core/db/app_database.dart';
import '../../core/health/health_hub.dart';
import '../../core/health/health_providers.dart';
import '../../core/profile.dart';
import '../../core/register.dart';
import '../../core/theme.dart';
import '../../core/tokens.dart';
import '../../core/widgets.dart';
import '../live/live_screen.dart';

final _integrationsProvider = StreamProvider((ref) {
  return ref.watch(databaseProvider).watchIntegrations();
});

final _weightEntriesProvider = StreamProvider((ref) {
  return ref.watch(databaseProvider).watchWeightEntries();
});

final _rememberedSensorsProvider = StreamProvider((ref) {
  return ref.watch(databaseProvider).watchRememberedSensors();
});

final _patternsProvider = StreamProvider((ref) {
  return ref.watch(databaseProvider).watchPatternCandidates();
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final integrations = ref.watch(_integrationsProvider).value ?? const [];
    final weights = ref.watch(_weightEntriesProvider).value ?? const [];
    final sensors = ref.watch(_rememberedSensorsProvider).value ??
        const <RememberedSensorRow>[];
    final patterns =
        ref.watch(_patternsProvider).value ?? const <PatternCandidateRow>[];
    // The Sanctum is settings — an instrument surface, plain at any register
    // (C10).
    return SurfaceIntentScope(
      intent: SurfaceIntent.plain,
      child: SkyBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(EterSpace.gutter, EterSpace.s24,
                EterSpace.gutter, EterSpace.s64),
            children: [
              _SettingsHeader(profile: profile),
              const SizedBox(height: EterSpace.s32),
              if (profile != null) ...[
                const _SectionLabel('ARCANA'),
                _SettingsPanel(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          profile.zodiac
                              .cardAssetFor(Theme.of(context).brightness),
                          width: 54,
                          height: 80,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      const SizedBox(width: EterSpace.s16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${profile.zodiac.arcana} · ${profile.zodiac.numeral}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            // The resting figure used to be repeated here and in
                            // the Body weight row on the same screen (§5.13). It
                            // is a measurement, not an identity, so it lives with
                            // the body — this card carries the arcana alone.
                            Text(
                              profile.zodiac.label,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: EterSpace.s12),
                      ElementMedallion(profile.zodiac.element, size: 40),
                    ],
                  ),
                ),
                const SizedBox(height: EterSpace.s24),
                const _SectionLabel('MEASUREMENTS'),
                _SettingsPanel(
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Body weight'),
                        subtitle: Text(
                          '${profile.weightKg.toStringAsFixed(1)} kg · '
                          '${profile.rmr.round()} resting kcal'
                          '${profile.rmrIsApproximate ? ' (estimated)' : ''}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _addWeight(context, ref, profile),
                        ),
                      ),
                      if (weights.length >= 2) ...[
                        // An unlabelled trend line does not say what span it
                        // covers (§5.13).
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'LAST 30 DAYS',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                        SizedBox(
                          height: 72,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: _WeightSparkline(
                              weights
                                  .take(30)
                                  .toList()
                                  .reversed
                                  .map((row) => row.kg)
                                  .toList(),
                              // Not the element accent. A fire sign painted the
                              // weight trend in salmon, which was both the
                              // loudest colour in the app and a false alarm
                              // signal on a line that means nothing good or bad.
                              // Trend data is neutral instrument colour.
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? EterColors.sky300
                                  : EterColors.sky500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: EterSpace.s24),
                const _SectionLabel('HEALTH SOURCES'),
                _SettingsPanel(
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Sync health data'),
                        subtitle: const Text('Health Connect · Apple Health'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _syncHealth(context, ref),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Resync date range'),
                        subtitle: const Text('Up to 30 days'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _resyncRange(context, ref),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Pair a heart-rate sensor'),
                        subtitle: const Text('Scan and connect nearby devices'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: (context) => const FractionallySizedBox(
                            heightFactor: .92,
                            child: LiveScreen(),
                          ),
                        ),
                      ),
                      if (sensors.isNotEmpty) const Divider(height: 1),
                      for (final sensor in sensors)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(sensor.name),
                          subtitle: Text(sensor.paired
                              ? 'Paired heart-rate sensor'
                              : 'Remembered heart-rate sensor'),
                          trailing: TextButton(
                            onPressed: () =>
                                _forgetSensor(context, ref, sensor),
                            child: const Text('Forget'),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: EterSpace.s24),
                const _SectionLabel('EXPERIENCE'),
                _SettingsPanel(
                  child: Column(children: [
                    _ToggleRow(
                      title: 'Haptic milestones',
                      subtitle: 'A subtle pulse at progress thresholds',
                      value: profile.hapticsEnabled,
                      onChanged: (value) =>
                          _update(ref, profile, hapticsEnabled: value),
                    ),
                    _ToggleRow(
                      title: 'Nutrition tracking',
                      subtitle: 'Show intake and balance details',
                      value: profile.nutritionEnabled,
                      onChanged: (value) =>
                          _update(ref, profile, nutritionEnabled: value),
                    ),
                    _ToggleRow(
                      title: 'Progress flash',
                      subtitle: 'A brief visual milestone',
                      value: profile.flashEnabled,
                      onChanged: (value) =>
                          _update(ref, profile, flashEnabled: value),
                    ),
                  ]),
                ),
                const SizedBox(height: EterSpace.s24),
                const _SectionLabel('AETHER'),
                _SettingsPanel(
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Guidance style'),
                        subtitle: Text(profile.guidanceMode.name),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _chooseGuidanceMode(
                          context,
                          ref,
                          profile,
                        ),
                      ),
                      const Divider(height: 1),
                      if (patterns.isEmpty)
                        const ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Learned patterns'),
                          subtitle: Text(
                            'Aether starts looking for inspectable patterns after seven days.',
                          ),
                        )
                      else
                        for (final pattern in patterns)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(pattern.summary),
                            subtitle: Text(
                              'Association · ${(pattern.confidence * 100).round()}% confidence',
                            ),
                            trailing: TextButton(
                              onPressed: () => ref
                                  .read(databaseProvider)
                                  .setPatternStatus(pattern.key, 'dismissed'),
                              child: const Text('Dismiss'),
                            ),
                          ),
                      if (patterns.isNotEmpty)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                ref.read(databaseProvider).resetPatterns(),
                            child: const Text('Reset personalization'),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: EterSpace.s24),
                const _SectionLabel('RECORDS'),
                _SettingsPanel(
                  child: integrations.isEmpty
                      ? const ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('No health import yet'),
                          subtitle: Text(
                            'Sync once to inspect source and freshness.',
                          ),
                        )
                      : Column(
                          children: [
                            for (final source in integrations)
                              _IntegrationDiagnostics(source: source),
                          ],
                        ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _chooseGuidanceMode(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    final mode = await showDialog<GuidanceMode>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Guidance style'),
        children: [
          for (final mode in GuidanceMode.values)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, mode),
              child: Row(
                children: [
                  Expanded(child: Text(mode.name)),
                  if (mode == profile.guidanceMode)
                    const Icon(Icons.check, size: 18),
                ],
              ),
            ),
        ],
      ),
    );
    if (mode == null) return;
    ref.read(profileProvider.notifier).update(
          profile.copyWith(guidanceMode: mode),
        );
  }

  Future<void> _forgetSensor(
    BuildContext context,
    WidgetRef ref,
    RememberedSensorRow sensor,
  ) async {
    try {
      await UniversalBle.disconnect(sensor.deviceId);
    } catch (_) {
      // It may already be disconnected.
    }
    if (sensor.paired) {
      try {
        await UniversalBle.unpair(
          sensor.deviceId,
          timeout: const Duration(seconds: 12),
        );
      } catch (_) {
        // Some broadcast-only sensors cannot be removed from the system bond
        // list; forgetting the Eter record must still succeed.
      }
    }
    await ref.read(databaseProvider).forgetSensor(sensor.deviceId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${sensor.name} forgotten.')),
    );
  }

  Future<void> _addWeight(
      BuildContext context, WidgetRef ref, Profile profile) async {
    final controller =
        TextEditingController(text: profile.weightKg.toStringAsFixed(1));
    final kg = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add body weight'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(suffixText: 'kg'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, double.tryParse(controller.text)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (kg == null || kg < 25 || kg > 350) return;
    await ref.read(databaseProvider).addWeightEntry(kg: kg);
    ref.read(profileProvider.notifier).update(profile.copyWith(weightKg: kg));
  }

  Future<void> _syncHealth(BuildContext context, WidgetRef ref) async {
    try {
      final hub = ref.read(healthHubProvider);
      var permission = await hub.permissionState();
      if (permission != HealthPermissionState.granted) {
        permission = await hub.requestPermissions();
      }
      if (!context.mounted) return;
      if (permission != HealthPermissionState.granted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Health access needs both Health Connect and physical-activity permission.'),
        ));
        return;
      }
      final now = DateTime.now();
      final dayStart = DateTime(now.year, now.month, now.day).toUtc();
      final result = await ref
          .read(healthIngestServiceProvider)
          .syncDay(dayStartUtc: dayStart);
      if (!context.mounted) return;
      final detail = result.recordsRead == 0
          ? 'No records were available today. In Health Connect, confirm Garmin Connect is allowed to write Steps and Active calories.'
          : '${result.steps} steps · ${result.activeKcal.round()} active kcal';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Health sync complete · $detail'),
      ));
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Health sync failed. Re-open Health Connect permissions for Eter, allow Steps, Heart rate, and Active calories, then retry.',
        ),
      ));
    }
  }

  Future<void> _resyncRange(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 29)),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: now.subtract(const Duration(days: 6)),
        end: now,
      ),
    );
    if (range == null) return;
    try {
      final hub = ref.read(healthHubProvider);
      if (await hub.permissionState() != HealthPermissionState.granted) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Grant Health Connect access before resyncing.'),
          ),
        );
        return;
      }
      final result = await ref.read(healthIngestServiceProvider).syncRange(
            startDayUtc: range.start.toUtc(),
            endDayUtcInclusive: range.end.toUtc(),
          );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Resynced ${result.days} days · ${result.recordsRead} records',
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date-range resync failed.')),
      );
    }
  }

  void _update(WidgetRef ref, Profile profile,
      {bool? hapticsEnabled, bool? flashEnabled, bool? nutritionEnabled}) {
    ref.read(profileProvider.notifier).update(profile.copyWith(
          hapticsEnabled: hapticsEnabled,
          flashEnabled: flashEnabled,
          nutritionEnabled: nutritionEnabled,
        ));
  }
}

class _IntegrationDiagnostics extends StatelessWidget {
  const _IntegrationDiagnostics({required this.source});

  final IntegrationRow source;

  @override
  Widget build(BuildContext context) {
    final decoded = jsonDecode(source.diagnosticsJson) as Map<String, Object?>;
    final sources = (decoded['sources'] as List?)?.cast<String>() ?? const [];
    final steps = decoded['stepsRecords'] as int? ?? 0;
    final heart = decoded['heartRateRecords'] as int? ?? 0;
    final energy = decoded['energyRecords'] as int? ?? 0;
    final synced = source.lastSync?.toLocal();
    final age = synced == null ? null : DateTime.now().difference(synced);
    final stale = age != null && age > const Duration(hours: 6);
    final state = source.status == 'failed'
        ? 'Import failed'
        : source.status == 'empty'
            ? 'Permission granted · no records'
            : stale
                ? 'Import stale'
                : 'Import current';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      // The decorative leading icons are gone from every row (§5.13); a glyph
      // here now means something is wrong. A healthy import says so in words
      // and needs no badge.
      leading: source.status == 'failed'
          ? const Icon(Icons.error_outline)
          : stale
              ? const Icon(Icons.schedule)
              : null,
      title: Text(state),
      subtitle: Text([
        'Steps $steps · heart rate $heart · energy $energy',
        if (sources.isNotEmpty) 'Source: ${sources.join(', ')}',
        if (synced != null)
          'Last sync: ${synced.toIso8601String().substring(0, 16).replaceFirst('T', ' ')}',
      ].join('\n')),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.profile});
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sanctum', style: text.displayMedium),
              const SizedBox(height: 3),
              Text(
                'Your body, records, and ritual settings.',
                style: text.bodyMedium,
              ),
            ],
          ),
        ),
        if (profile != null)
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: EterColors.aura500.withValues(alpha: .12),
              border: Border.all(
                color: EterColors.aura500.withValues(alpha: .52),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              profile!.zodiac.numeral,
              style: text.labelSmall?.copyWith(
                color: EterColors.aura700,
                letterSpacing: .8,
              ),
            ),
          ),
      ],
    );
  }
}

/// A settings toggle. Replaces `SwitchListTile`, whose filled Material pill
/// was the heaviest object on the Sanctum and the one control that never
/// picked up the register's line-work.
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: EterSpace.s8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.bodyLarge),
                const SizedBox(height: 2),
                Text(subtitle, style: text.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: EterSpace.s16),
          EterToggle(
            value: value,
            onChanged: onChanged,
            semanticLabel: title,
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding:
            const EdgeInsets.only(left: EterSpace.s8, bottom: EterSpace.s8),
        child: Row(
          children: [
            Container(width: 20, height: 1, color: EterColors.aura500),
            const SizedBox(width: EterSpace.s8),
            Text(label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? EterColors.aura300
                          : EterColors.aura700,
                      letterSpacing: 1.4,
                    )),
            const SizedBox(width: EterSpace.s8),
            Expanded(
              child: Container(
                height: 1,
                color: EterColors.aura500.withValues(alpha: .28),
              ),
            ),
          ],
        ),
      );
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Was a radius-16 card with an all-round gold border and a drop shadow —
    // the last survivor of the styling A2/A4 removed everywhere else, missed
    // because that pass only rewrote GlassCard. It is a plate like the rest.
    return EterPlate(
      padding: const EdgeInsets.fromLTRB(
          EterSpace.s16, EterSpace.s12, EterSpace.s16, EterSpace.s12),
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );
  }
}

class _WeightSparkline extends CustomPainter {
  const _WeightSparkline(this.values, {required this.color});
  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final range = (max - min).abs() < .1 ? 1 : max - min;
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = i * size.width / (values.length - 1);
      final y = size.height -
          EterSpace.s8 -
          (values[i] - min) / range * (size.height - EterSpace.s16);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_WeightSparkline old) =>
      old.values != values || old.color != color;
}
