import '../db/app_database.dart';
import '../energy/energy.dart';

class ManualActivityResult {
  const ManualActivityResult({
    required this.activeKcal,
    required this.newMilestones,
  });

  final double activeKcal;
  final int newMilestones;
}

class ManualActivityService {
  const ManualActivityService(this.database);

  final AppDatabase database;

  Future<ManualActivityResult> log({
    required String name,
    required int durationMinutes,
    required double activeKcal,
    DateTime? endedAt,
  }) async {
    if (durationMinutes < 1 || durationMinutes > 1440) {
      throw ArgumentError.value(
        durationMinutes,
        'durationMinutes',
        'Must be between 1 and 1440',
      );
    }
    if (!activeKcal.isFinite || activeKcal < 0 || activeKcal > 10000) {
      throw ArgumentError.value(
        activeKcal,
        'activeKcal',
        'Must be within 0–10000',
      );
    }

    final end = endedAt ?? DateTime.now();
    final endMinuteUtc = _floorMinute(end.toUtc());
    final startUtc = endMinuteUtc.subtract(Duration(minutes: durationMinutes));
    final kcalPerMinute = activeKcal / durationMinutes;
    final safeName = name
        .toLowerCase()
        .replaceAll(RegExp('[^a-z0-9]+'), '-')
        .replaceAll(RegExp('(^-|-\$)'), '');
    final sourceId =
        'journal-${safeName.isEmpty ? 'activity' : safeName}-${startUtc.microsecondsSinceEpoch}';

    await database.ingestRawBuckets(List.generate(
      durationMinutes,
      (index) => MinuteBucket(
        minuteUtc: startUtc.add(Duration(minutes: index)),
        activeKcal: kcalPerMinute,
        sourceId: sourceId,
        priority: SourcePriority.manualStrength,
      ),
    ));

    final localDay = DateTime(end.year, end.month, end.day);
    final dayStartUtc = localDay.toUtc();
    final dayEndUtc = localDay.add(const Duration(days: 1)).toUtc();
    final active =
        await database.recomputeMinuteWinners(dayStartUtc, dayEndUtc);
    final update = await database.recordDayTotal(
      date: dayStartUtc.toIso8601String().substring(0, 10),
      activeKcal: active,
    );
    return ManualActivityResult(
      activeKcal: activeKcal,
      newMilestones: update.newMilestones,
    );
  }

  DateTime _floorMinute(DateTime value) => DateTime.utc(
        value.year,
        value.month,
        value.day,
        value.hour,
        value.minute,
      );
}
