import '../db/app_database.dart';
import 'health_hub.dart';

class HealthSyncResult {
  const HealthSyncResult({
    required this.activeKcal,
    required this.recordsRead,
    required this.steps,
    required this.newMilestones,
    required this.changesToken,
  });

  final double activeKcal;
  final int recordsRead;
  final int steps;
  final int newMilestones;
  final String? changesToken;
}

class HealthRangeSyncResult {
  const HealthRangeSyncResult({
    required this.days,
    required this.recordsRead,
    required this.activeKcal,
    required this.steps,
  });

  final int days;
  final int recordsRead;
  final double activeKcal;
  final int steps;
}

class HealthIngestService {
  const HealthIngestService({required this.database, required this.hub});
  final AppDatabase database;
  final HealthHub hub;

  Future<HealthRangeSyncResult> syncRange({
    required DateTime startDayUtc,
    required DateTime endDayUtcInclusive,
    int maximumDays = 30,
  }) async {
    final start = DateTime.utc(
      startDayUtc.year,
      startDayUtc.month,
      startDayUtc.day,
    );
    final end = DateTime.utc(
      endDayUtcInclusive.year,
      endDayUtcInclusive.month,
      endDayUtcInclusive.day,
    );
    if (end.isBefore(start)) {
      throw ArgumentError('End day must not precede start day');
    }
    final days = end.difference(start).inDays + 1;
    if (days > maximumDays) {
      throw RangeError.range(days, 1, maximumDays, 'days');
    }
    var records = 0;
    var active = 0.0;
    var steps = 0;
    for (var offset = 0; offset < days; offset++) {
      final result = await syncDay(
        dayStartUtc: start.add(Duration(days: offset)),
      );
      records += result.recordsRead;
      active += result.activeKcal;
      steps += result.steps;
    }
    return HealthRangeSyncResult(
      days: days,
      recordsRead: records,
      activeKcal: active,
      steps: steps,
    );
  }

  Future<HealthSyncResult> syncDay({
    required DateTime dayStartUtc,
    String? changesToken,
    double milestoneStepKcal = 100,
  }) async {
    final end = dayStartUtc.toUtc().add(const Duration(days: 1));
    try {
      final batch = await hub.readChanges(
        startUtc: dayStartUtc.toUtc(),
        endUtc: end,
        changesToken: changesToken,
      );
      await database.ingestRawBuckets(batch.records.map((r) => r.toBucket()));
      final active = await database.recomputeMinuteWinners(dayStartUtc, end);
      final steps = batch.records.fold<int>(
        0,
        (total, record) => total + (record.steps ?? 0),
      );
      final date = dayStartUtc.toUtc().toIso8601String().substring(0, 10);
      final update = await database.recordDayTotal(
        date: date,
        activeKcal: active,
        steps: steps,
        milestoneStepKcal: milestoneStepKcal,
      );
      final sources = batch.records.map((record) => record.sourceId).toSet()
        ..removeWhere((source) => source.isEmpty);
      final stepsRecords =
          batch.records.where((record) => record.steps != null).length;
      final heartRateRecords =
          batch.records.where((record) => record.avgHr != null).length;
      final energyRecords =
          batch.records.where((record) => record.activeKcal > 0).length;
      await database.recordIntegrationSync(
        vendor: 'health-hub',
        status: batch.records.isEmpty ? 'empty' : 'connected',
        recordsToday: batch.records.length,
        changesToken: batch.nextChangesToken,
        diagnostics: {
          'stepsRecords': stepsRecords,
          'heartRateRecords': heartRateRecords,
          'energyRecords': energyRecords,
          'sources': sources.toList()..sort(),
        },
      );
      return HealthSyncResult(
        activeKcal: active,
        recordsRead: batch.records.length,
        steps: steps,
        newMilestones: update.newMilestones,
        changesToken: batch.nextChangesToken,
      );
    } catch (error) {
      await database.recordIntegrationFailure(
        vendor: 'health-hub',
        status: 'failed',
        error: error.runtimeType.toString(),
      );
      rethrow;
    }
  }
}
