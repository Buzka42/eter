import 'package:drift/native.dart';
import 'package:eter/core/aether/lifestyle.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('recent lifestyle summary is bounded and structured', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final service = LifestyleService(database);
    final now = DateTime.utc(2026, 7, 24, 12);

    await service.recordRating(
      LifestyleKind.mood,
      3,
      at: now.subtract(const Duration(days: 1)),
    );
    await service.recordRating(
      LifestyleKind.mood,
      5,
      at: now.subtract(const Duration(hours: 2)),
    );
    await service.recordDuration(
      LifestyleKind.sleep,
      450,
      at: now.subtract(const Duration(hours: 8)),
      source: 'health-connect',
    );
    await service.recordReflection(
      'A quiet morning helped.',
      at: now.subtract(const Duration(minutes: 1)),
    );
    await service.recordReflection(
      'This is outside the requested window.',
      at: now.subtract(const Duration(days: 4)),
    );

    final summary = await service.summarizeRecent(now: now);

    expect(summary.averages[LifestyleKind.mood], 4);
    expect(summary.totalMinutes[LifestyleKind.sleep], 450);
    expect(summary.reflections, ['A quiet morning helped.']);
  });

  test('rating validation rejects false precision and invalid ranges',
      () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final service = LifestyleService(database);

    expect(
      () => service.recordRating(LifestyleKind.mood, 6),
      throwsRangeError,
    );
    expect(
      () => service.recordRating(LifestyleKind.sleep, 3),
      throwsArgumentError,
    );
  });
}
