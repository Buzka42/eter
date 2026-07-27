import 'package:drift/native.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:eter/core/energy/energy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('raw ingest replay is idempotent and canonical winner is persisted',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final minute = DateTime.utc(2026, 7, 23, 18);
    final batch = [
      MinuteBucket(
        minuteUtc: minute,
        activeKcal: 5,
        sourceId: 'health-connect',
        priority: SourcePriority.hub,
      ),
      MinuteBucket(
        minuteUtc: minute,
        activeKcal: 4,
        sourceId: 'strength',
        priority: SourcePriority.manualStrength,
      ),
    ];

    await db.ingestRawBuckets(batch);
    await db.ingestRawBuckets(batch);
    final total = await db.recomputeMinuteWinners(
      DateTime.utc(2026, 7, 23),
      DateTime.utc(2026, 7, 24),
    );

    expect(await db.select(db.rawBuckets).get().then((v) => v.length), 2);
    expect(total, 4);
    final winner = await db.select(db.minuteBuckets).getSingle();
    expect(winner.winningSource, 'strength');
    expect(winner.activeKcal, 4);
  });

  test('recompute replaces an old winner after corrected source data',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final minute = DateTime.utc(2026, 7, 23, 18);
    await db.ingestRawBuckets([
      MinuteBucket(
        minuteUtc: minute,
        activeKcal: 5,
        sourceId: 'hub',
        priority: SourcePriority.hub,
      )
    ]);
    await db.recomputeMinuteWinners(
        minute, minute.add(const Duration(minutes: 1)));
    await db.ingestRawBuckets([
      MinuteBucket(
        minuteUtc: minute,
        activeKcal: 3,
        sourceId: 'strap',
        priority: SourcePriority.liveStrap,
      )
    ]);
    await db.recomputeMinuteWinners(
        minute, minute.add(const Duration(minutes: 1)));

    final winner = await db.select(db.minuteBuckets).getSingle();
    expect(winner.winningSource, 'strap');
    expect(winner.activeKcal, 3);
  });
}
