import 'package:drift/native.dart';
import 'package:eter/core/aether/lifestyle.dart';
import 'package:eter/core/aether/pattern_engine.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('patterns wait for seven distinct days and remain non-causal', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final lifestyle = LifestyleService(database);
    final engine = PatternEngine(database);
    final now = DateTime.utc(2026, 7, 24, 12);

    for (var day = 1; day <= 6; day++) {
      final at = now.subtract(Duration(days: day));
      await lifestyle.recordDuration(
        LifestyleKind.sleep,
        300 + day * 30,
        at: at,
      );
      await lifestyle.recordRating(
        LifestyleKind.mood,
        1 + day * .5,
        at: at,
      );
    }
    expect(await engine.recompute(now: now), 0);

    await lifestyle.recordDuration(
      LifestyleKind.sleep,
      540,
      at: now.subtract(const Duration(days: 7)),
    );
    await lifestyle.recordRating(
      LifestyleKind.mood,
      4.5,
      at: now.subtract(const Duration(days: 7)),
    );

    expect(await engine.recompute(now: now), 1);
    final patterns = await database.loadActivePatternCandidates();
    expect(patterns, hasLength(1));
    expect(patterns.single.summary, contains('tends'));
    expect(patternEvidence(patterns.single)['causal'], isFalse);
  });
}
