import 'package:drift/native.dart';
import 'package:eter/core/activity/manual_activity_service.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('manual activity enters the canonical pipeline and replay is safe',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final service = ManualActivityService(db);
    final endedAt = DateTime(2026, 7, 23, 12);

    final first = await service.log(
      name: 'Walk',
      durationMinutes: 30,
      activeKcal: 147,
      endedAt: endedAt,
    );
    final replay = await service.log(
      name: 'Walk',
      durationMinutes: 30,
      activeKcal: 147,
      endedAt: endedAt,
    );

    expect(first.activeKcal, closeTo(147, 0.001));
    expect(replay.activeKcal, closeTo(147, 0.001));
    expect(
        await db.select(db.rawBuckets).get().then((rows) => rows.length), 30);
    expect(
      await db.select(db.minuteBuckets).get().then((rows) => rows.length),
      30,
    );
    expect(
      await db
          .select(db.daySummaries)
          .getSingle()
          .then((row) => row.activeKcal),
      closeTo(147, 0.001),
    );
  });
}
