import 'dart:convert';

import '../db/app_database.dart';
import 'lifestyle.dart';

class PatternEngine {
  const PatternEngine(this.database);

  final AppDatabase database;

  Future<int> recompute({required DateTime now}) async {
    final end = now.toUtc().add(const Duration(milliseconds: 1));
    final start = end.subtract(const Duration(days: 30));
    final rows = await database.loadLifestyleEntries(start, end);
    final dayRows = await database.loadDaySummaries(start, end);
    final nutritionRows = await database.loadNutritionEntries(start, end);
    final minuteRows = await database.loadMinuteBuckets(start, end);
    final distinctDays = rows
        .map((row) {
          final local = row.recordedAt.toLocal();
          return '${local.year}-${local.month}-${local.day}';
        })
        .toSet()
        .length;
    if (distinctDays < 7) return 0;

    final byDay = <String, List<LifestyleEntryRow>>{};
    for (final row in rows) {
      final local = row.recordedAt.toLocal();
      final key = '${local.year}-${local.month}-${local.day}';
      byDay.putIfAbsent(key, () => []).add(row);
    }
    final summaries = {for (final row in dayRows) row.date: row};
    final intakeByDay = <String, double>{};
    for (final row in nutritionRows) {
      final key = _dayKey(row.recordedAt);
      intakeByDay[key] = (intakeByDay[key] ?? 0) + row.kcal;
    }
    final restingHrByDay = <String, double>{};
    for (final row in minuteRows) {
      final hr = row.avgHr;
      if (hr == null || hr < 35 || hr > 140) continue;
      final key = _dayKey(row.minuteUtc);
      final current = restingHrByDay[key];
      if (current == null || hr < current) restingHrByDay[key] = hr;
    }

    var saved = 0;
    final sleepMood = _pairedDailyValues(
      byDay,
      LifestyleKind.sleep,
      LifestyleKind.mood,
      durationAsHours: true,
    );
    if (sleepMood.length >= 5) {
      final correlation = _pearson(sleepMood);
      if (correlation.abs() >= .35) {
        await database.savePatternCandidate(
          key: 'sleep-mood',
          summary: correlation > 0
              ? 'Higher reported mood tends to appear after longer sleep.'
              : 'Higher reported mood has recently appeared after shorter sleep.',
          confidence: _confidence(correlation, sleepMood.length),
          evidence: {
            'kind': 'correlation',
            'sampleDays': sleepMood.length,
            'coefficient': correlation,
            'windowDays': 30,
            'causal': false,
          },
          computedAt: now,
        );
        saved++;
      }
    }

    final stressRecovery = _pairedDailyValues(
      byDay,
      LifestyleKind.stress,
      LifestyleKind.recovery,
    );
    if (stressRecovery.length >= 5) {
      final correlation = _pearson(stressRecovery);
      if (correlation.abs() >= .35) {
        await database.savePatternCandidate(
          key: 'stress-recovery',
          summary: correlation < 0
              ? 'Higher stress reports tend to coincide with lower recovery.'
              : 'Stress and recovery reports have recently moved together.',
          confidence: _confidence(correlation, stressRecovery.length),
          evidence: {
            'kind': 'correlation',
            'sampleDays': stressRecovery.length,
            'coefficient': correlation,
            'windowDays': 30,
            'causal': false,
          },
          computedAt: now,
        );
        saved++;
      }
    }

    final trainingSleep = <(double, double)>[];
    final trainingRestingHr = <(double, double)>[];
    final sleepNextSteps = <(double, double)>[];
    final sleepNextActive = <(double, double)>[];
    final stepsMood = <(double, double)>[];
    final intakeRecovery = <(double, double)>[];
    final orderedKeys = summaries.keys.toList()..sort();
    for (var index = 0; index < orderedKeys.length; index++) {
      final key = orderedKeys[index];
      final summary = summaries[key]!;
      final lifestyleRows = byDay[key] ?? const [];
      final sleep = _dailyValue(
        lifestyleRows,
        LifestyleKind.sleep,
        durationAsHours: true,
      );
      final mood = _dailyValue(lifestyleRows, LifestyleKind.mood);
      final recovery = _dailyValue(lifestyleRows, LifestyleKind.recovery);
      final trained = summary.activeKcal >= 150 ? 1.0 : 0.0;
      if (sleep != null) trainingSleep.add((trained, sleep));
      final resting = restingHrByDay[key];
      if (resting != null) trainingRestingHr.add((trained, resting));
      if (mood != null) stepsMood.add((summary.steps.toDouble(), mood));
      final intake = intakeByDay[key];
      if (intake != null && recovery != null) {
        intakeRecovery.add((intake, recovery));
      }
      if (sleep != null && index + 1 < orderedKeys.length) {
        final next = summaries[orderedKeys[index + 1]]!;
        sleepNextSteps.add((sleep, next.steps.toDouble()));
        sleepNextActive.add((sleep, next.activeKcal));
      }
    }
    saved += await _saveCorrelation(
      key: 'training-sleep',
      pairs: trainingSleep,
      positive: 'Training days tend to coincide with longer reported sleep.',
      negative: 'Training days tend to coincide with shorter reported sleep.',
      now: now,
    );
    saved += await _saveCorrelation(
      key: 'training-resting-hr',
      pairs: trainingRestingHr,
      positive:
          'Training days tend to coincide with a higher daily resting-HR proxy.',
      negative:
          'Training days tend to coincide with a lower daily resting-HR proxy.',
      now: now,
    );
    saved += await _saveCorrelation(
      key: 'sleep-next-steps',
      pairs: sleepNextSteps,
      positive: 'Longer sleep tends to precede more next-day steps.',
      negative: 'Longer sleep tends to precede fewer next-day steps.',
      now: now,
    );
    saved += await _saveCorrelation(
      key: 'sleep-next-active',
      pairs: sleepNextActive,
      positive: 'Longer sleep tends to precede more next-day active energy.',
      negative: 'Longer sleep tends to precede less next-day active energy.',
      now: now,
    );
    saved += await _saveCorrelation(
      key: 'steps-mood',
      pairs: stepsMood,
      positive: 'Higher-step days tend to coincide with higher reported mood.',
      negative: 'Higher-step days tend to coincide with lower reported mood.',
      now: now,
    );
    saved += await _saveCorrelation(
      key: 'intake-recovery',
      pairs: intakeRecovery,
      positive:
          'Higher recorded intake tends to coincide with higher reported recovery.',
      negative:
          'Higher recorded intake tends to coincide with lower reported recovery.',
      now: now,
    );
    return saved;
  }

  Future<int> _saveCorrelation({
    required String key,
    required List<(double, double)> pairs,
    required String positive,
    required String negative,
    required DateTime now,
  }) async {
    if (pairs.length < 5) return 0;
    final correlation = _pearson(pairs);
    if (correlation.abs() < .35) return 0;
    await database.savePatternCandidate(
      key: key,
      summary: correlation >= 0 ? positive : negative,
      confidence: _confidence(correlation, pairs.length),
      evidence: {
        'kind': 'correlation',
        'sampleDays': pairs.length,
        'coefficient': correlation,
        'windowDays': 30,
        'causal': false,
      },
      computedAt: now,
    );
    return 1;
  }

  String _dayKey(DateTime value) {
    final local = value.toLocal();
    return '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }

  List<(double, double)> _pairedDailyValues(
    Map<String, List<LifestyleEntryRow>> byDay,
    LifestyleKind first,
    LifestyleKind second, {
    bool durationAsHours = false,
  }) {
    final result = <(double, double)>[];
    for (final rows in byDay.values) {
      final a = _dailyValue(rows, first, durationAsHours: durationAsHours);
      final b = _dailyValue(rows, second);
      if (a != null && b != null) result.add((a, b));
    }
    return result;
  }

  double? _dailyValue(
    List<LifestyleEntryRow> rows,
    LifestyleKind kind, {
    bool durationAsHours = false,
  }) {
    final matching = rows.where((row) => row.kind == kind.name).toList();
    if (matching.isEmpty) return null;
    final values = durationAsHours
        ? matching
            .map((row) => (row.durationMinutes ?? 0) / 60)
            .where((value) => value > 0)
            .toList()
        : matching.map((row) => row.value).whereType<double>().toList();
    if (values.isEmpty) return null;
    return values.fold<double>(0, (sum, value) => sum + value) / values.length;
  }

  double _pearson(List<(double, double)> pairs) {
    final meanX =
        pairs.fold<double>(0, (sum, pair) => sum + pair.$1) / pairs.length;
    final meanY =
        pairs.fold<double>(0, (sum, pair) => sum + pair.$2) / pairs.length;
    var numerator = 0.0;
    var xSquare = 0.0;
    var ySquare = 0.0;
    for (final pair in pairs) {
      final x = pair.$1 - meanX;
      final y = pair.$2 - meanY;
      numerator += x * y;
      xSquare += x * x;
      ySquare += y * y;
    }
    if (xSquare == 0 || ySquare == 0) return 0;
    return numerator / (xSquare * ySquare).sqrt();
  }

  double _confidence(double correlation, int samples) =>
      (correlation.abs() * (samples / 14).clamp(.35, 1)).clamp(0, 1);
}

extension on double {
  double sqrt() {
    if (this <= 0) return 0;
    var estimate = this / 2;
    for (var i = 0; i < 12; i++) {
      estimate = (estimate + this / estimate) / 2;
    }
    return estimate;
  }
}

Map<String, Object?> patternEvidence(PatternCandidateRow row) =>
    Map<String, Object?>.from(jsonDecode(row.evidenceJson) as Map);
