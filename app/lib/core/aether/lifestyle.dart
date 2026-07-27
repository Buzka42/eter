import '../db/app_database.dart';

enum LifestyleKind {
  sleep,
  recovery,
  stress,
  mood,
  meditation,
  breathwork,
  reflection,
}

class LifestyleSummary {
  const LifestyleSummary({
    required this.windowStart,
    required this.windowEnd,
    required this.averages,
    required this.totalMinutes,
    required this.reflections,
  });

  final DateTime windowStart;
  final DateTime windowEnd;
  final Map<LifestyleKind, double> averages;
  final Map<LifestyleKind, double> totalMinutes;
  final List<String> reflections;

  Map<String, Object?> toJson() => {
        'windowStart': windowStart.toUtc().toIso8601String(),
        'windowEnd': windowEnd.toUtc().toIso8601String(),
        'averages': {
          for (final entry in averages.entries) entry.key.name: entry.value,
        },
        'totalMinutes': {
          for (final entry in totalMinutes.entries) entry.key.name: entry.value,
        },
        'reflections': reflections,
      };
}

class LifestyleService {
  const LifestyleService(this.database);

  final AppDatabase database;

  Future<void> recordRating(
    LifestyleKind kind,
    double value, {
    DateTime? at,
    String? note,
  }) async {
    if (!const {
      LifestyleKind.recovery,
      LifestyleKind.stress,
      LifestyleKind.mood,
    }.contains(kind)) {
      throw ArgumentError.value(kind, 'kind', 'Rating kind required');
    }
    if (value < 1 || value > 5) {
      throw RangeError.range(value, 1, 5, 'value');
    }
    await database.addLifestyleEntry(
      kind: kind.name,
      value: value,
      note: _cleanNote(note),
      recordedAt: at,
    );
  }

  Future<void> recordDuration(
    LifestyleKind kind,
    double minutes, {
    DateTime? at,
    String? note,
    String source = 'self-report',
  }) async {
    if (!const {
      LifestyleKind.sleep,
      LifestyleKind.meditation,
      LifestyleKind.breathwork,
    }.contains(kind)) {
      throw ArgumentError.value(kind, 'kind', 'Duration kind required');
    }
    if (minutes <= 0 || minutes > 1440) {
      throw RangeError.value(minutes, 'minutes', 'Must be between 0 and 1440');
    }
    await database.addLifestyleEntry(
      kind: kind.name,
      durationMinutes: minutes,
      note: _cleanNote(note),
      recordedAt: at,
      source: source,
    );
  }

  Future<void> recordReflection(String text, {DateTime? at}) async {
    final cleaned = text.trim();
    if (cleaned.isEmpty || cleaned.length > 4000) {
      throw RangeError.range(cleaned.length, 1, 4000, 'text length');
    }
    await database.addLifestyleEntry(
      kind: LifestyleKind.reflection.name,
      note: cleaned,
      recordedAt: at,
    );
  }

  Future<LifestyleSummary> summarizeRecent({
    required DateTime now,
    Duration window = const Duration(days: 3),
    int maximumReflections = 3,
  }) async {
    final end = now.toUtc().add(const Duration(milliseconds: 1));
    final start = end.subtract(window);
    final rows = await database.loadLifestyleEntries(start, end);
    final values = <LifestyleKind, List<double>>{};
    final durations = <LifestyleKind, double>{};
    final reflections = <String>[];
    for (final row in rows) {
      final kind = LifestyleKind.values
          .where((value) => value.name == row.kind)
          .firstOrNull;
      if (kind == null) continue;
      if (row.value case final value?) {
        values.putIfAbsent(kind, () => []).add(value);
      }
      if (row.durationMinutes case final minutes?) {
        durations[kind] = (durations[kind] ?? 0) + minutes;
      }
      if (kind == LifestyleKind.reflection &&
          row.note != null &&
          reflections.length < maximumReflections) {
        reflections.add(row.note!);
      }
    }
    return LifestyleSummary(
      windowStart: start,
      windowEnd: end,
      averages: {
        for (final entry in values.entries)
          entry.key: entry.value.fold<double>(0, (sum, value) => sum + value) /
              entry.value.length,
      },
      totalMinutes: durations,
      reflections: reflections,
    );
  }

  String? _cleanNote(String? note) {
    final value = note?.trim();
    if (value == null || value.isEmpty) return null;
    return value.length <= 1000 ? value : value.substring(0, 1000);
  }
}
