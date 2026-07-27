import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/energy/energy.dart';
import '../../core/profile.dart';

class DayState {
  const DayState({
    required this.activeKcal,
    required this.burnRatePerMin,
    required this.pulsing,
    required this.milestonesFired,
    required this.steps,
    required this.sessions,
    required this.recalibrated,
  });

  final double activeKcal;
  final double burnRatePerMin;
  final bool pulsing;
  final int milestonesFired;
  final int steps;
  final int sessions;
  final bool recalibrated;

  static const initial = DayState(
    activeKcal: 0,
    burnRatePerMin: 0,
    pulsing: false,
    milestonesFired: 0,
    steps: 0,
    sessions: 0,
    recalibrated: false,
  );
}

const kMilestoneStepKcal = 100.0;
const kActiveGoalKcal = 500.0;
const kPulseMultiplier = 1.5;

/// Home now reads only canonical, deduplicated Drift rows. Platform health
/// adapters and manual sessions feed the same ingest pipeline (specs 02/06/11).
final dayStateProvider = StreamProvider<DayState>((ref) {
  final database = ref.watch(databaseProvider);
  final profile = ref.watch(profileProvider);
  final now = DateTime.now();
  final localStart = DateTime(now.year, now.month, now.day);
  final startUtc = localStart.toUtc();
  final endUtc = localStart.add(const Duration(days: 1)).toUtc();

  return database.watchMinuteBuckets(startUtc, endUtc).asyncMap((rows) async {
    final current = DateTime.now().toUtc();
    final trailingStart = current.subtract(const Duration(minutes: 5));
    final active = rows.fold<double>(0, (sum, row) => sum + row.activeKcal);
    final trailing = rows
        .where((row) => !row.minuteUtc.isBefore(trailingStart))
        .fold<double>(0, (sum, row) => sum + row.activeKcal);
    final resting = profile?.restingKcalPerMin ?? 1.24;
    final date = startUtc.toIso8601String().substring(0, 10);
    final summary = await (database.select(database.daySummaries)
          ..where((t) => t.date.equals(date)))
        .getSingleOrNull();
    return DayState(
      activeKcal: active,
      burnRatePerMin: burnRatePerMin(
        trailingFiveMinuteActiveKcal: trailing,
        restingKcalPerMin: resting,
      ),
      pulsing: shouldPulse(
        trailingFiveMinuteActiveKcal: trailing,
        restingKcalPerMin: resting,
        multiplier: kPulseMultiplier,
      ),
      milestonesFired: summary?.milestonesFired ?? 0,
      steps: summary?.steps ?? 0,
      sessions: summary?.sessionsCount ?? 0,
      recalibrated: summary?.recalibrated ?? false,
    );
  });
});
