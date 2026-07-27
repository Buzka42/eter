import 'package:drift/native.dart';
import 'package:eter/core/aether/ai_contract.dart';
import 'package:eter/core/aether/guidance_mode.dart';
import 'package:eter/core/aether/journal.dart';
import 'package:eter/core/aether/journal_service.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:eter/core/energy/energy.dart';
import 'package:eter/core/profile.dart';
import 'package:flutter_test/flutter_test.dart';

/// Undo deletes rows the user's day is built from, so the guarantee is not
/// "it runs" but "it removes exactly what the reading added and nothing
/// else" (Q6).
class _FixedClient implements AetherClient {
  _FixedClient(this.extraction);
  final JournalExtraction extraction;

  @override
  Future<JournalExtraction> classifyJournalEntry({
    required String text,
    required double weightKg,
    required String units,
    String locale = 'en',
  }) async =>
      extraction;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late AppDatabase database;

  final profile = Profile(
    dob: DateTime(1990, 8, 1),
    sex: Sex.female,
    weightKg: 68,
    heightCm: 172,
    firstName: 'Atlas',
    nutritionEnabled: true,
    guidanceMode: GuidanceMode.balanced,
  );

  const extraction = JournalExtraction(
    model: 'test',
    schemaVersion: 1,
    segments: [
      FoodJournalSegment(
        confidence: 0.9,
        items: [
          MealItemEstimate(
            name: 'Oats',
            portion: 'a bowl',
            kcal: 320,
            proteinG: 11,
            carbsG: 54,
            fatG: 6,
          ),
        ],
      ),
      ActivityJournalSegment(
        name: 'Walk',
        durationMinutes: 30,
        intensity: 'easy',
        activeKcal: 140,
        confidence: 0.8,
      ),
      RatingJournalSegment(JournalSegmentKind.mood, value: 4),
    ],
  );

  setUp(() => database = AppDatabase(NativeDatabase.memory()));
  tearDown(() => database.close());

  Future<int> nutritionCount() async =>
      (await database.select(database.nutritionEntries).get()).length;
  Future<int> lifestyleCount() async =>
      (await database.select(database.lifestyleEntries).get()).length;
  Future<int> bucketCount() async =>
      (await database.select(database.rawBuckets).get()).length;

  test('undo removes exactly what the reading added', () async {
    final service = JournalService(
      database: database,
      client: _FixedClient(extraction),
    );
    final at = DateTime.now();

    // A meal the user recorded by hand, which undo must not touch.
    await database.addNutritionEntry(kcal: 500, meal: 'Logged by hand');

    final result = await service.saveAndClassify(
      text: 'oats and a walk',
      profile: profile,
      createdAt: at,
    );

    expect(await nutritionCount(), 2, reason: 'the reading added a meal');
    expect(await lifestyleCount(), 1, reason: 'the reading added a mood');
    expect(await bucketCount(), 30, reason: 'a 30 minute walk is 30 buckets');

    await service.undo(
      entryId: result.entryId,
      createdAt: at,
      extraction: result.extraction,
    );

    expect(await nutritionCount(), 1,
        reason: 'the hand-logged meal must survive');
    final survivor =
        (await database.select(database.nutritionEntries).get()).single;
    expect(survivor.meal, 'Logged by hand');
    expect(await lifestyleCount(), 0);
    expect(await bucketCount(), 0);

    // The number the user actually sees. Deleting raw buckets does not by
    // itself rebuild the winning minutes or the day total, so this is the
    // assertion that the recompute really runs.
    final day = await (database.select(database.daySummaries)).get();
    for (final summary in day) {
      expect(summary.activeKcal, 0,
          reason: 'the walk is still counted in the day total');
    }
  });

  test('an undone entry keeps its prose and is not retried', () async {
    final service = JournalService(
      database: database,
      client: _FixedClient(extraction),
    );
    final at = DateTime.now();
    final result = await service.saveAndClassify(
      text: 'oats and a walk',
      profile: profile,
      createdAt: at,
    );

    await service.undo(
      entryId: result.entryId,
      createdAt: at,
      extraction: result.extraction,
    );

    final entry = (await database.select(database.journalEntries).get()).single;
    expect(entry.entryText, 'oats and a walk',
        reason: 'the user rejected the reading, not their own writing');
    expect(entry.status, 'discarded');

    // The retry loop must not re-apply the reading that was just rejected.
    expect(await database.pendingJournalEntries(), isEmpty);
    expect(await service.retryPending(profile: profile), 0);
    expect(await nutritionCount(), 0);
  });
}
