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
    final sourceId = sourceIdFor(name: name, startUtc: startUtc);

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

  /// The bucket source written for a logged activity.
  ///
  /// Deliberately derivable rather than stored: undoing a journal reading has
  /// to find the very rows that reading created, and recomputing the id from
  /// the same inputs keeps the two sides from drifting apart.
  static String sourceIdFor({required String name, required DateTime startUtc}) {
    final safeName = name
        .toLowerCase()
        .replaceAll(RegExp('[^a-z0-9]+'), '-')
        .replaceAll(RegExp('(^-|-\$)'), '');
    return 'journal-${safeName.isEmpty ? 'activity' : safeName}'
        '-${startUtc.microsecondsSinceEpoch}';
  }

  /// The first minute an activity of [durationMinutes] ending at [endedAt]
  /// occupies. Shared with [log] so undo lands on the same bucket range.
  static DateTime startUtcFor({
    required DateTime endedAt,
    required int durationMinutes,
  }) =>
      _floorMinuteUtc(endedAt.toUtc())
          .subtract(Duration(minutes: durationMinutes));

  static DateTime _floorMinuteUtc(DateTime value) => DateTime.utc(
        value.year,
        value.month,
        value.day,
        value.hour,
        value.minute,
      );

  DateTime _floorMinute(DateTime value) => DateTime.utc(
        value.year,
        value.month,
        value.day,
        value.hour,
        value.minute,
      );
}
