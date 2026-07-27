import 'package:drift/native.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('weight entries append without changing historical day totals',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await db.recordDayTotal(date: '2026-07-22', activeKcal: 420);
    await db.addWeightEntry(
      kg: 80,
      recordedAt: DateTime.utc(2026, 7, 22),
    );
    await db.addWeightEntry(
      kg: 79.4,
      recordedAt: DateTime.utc(2026, 7, 23),
    );

    final entries = await db.select(db.weightEntries).get();
    final day = await db.select(db.daySummaries).getSingle();
    expect(entries.map((row) => row.kg), containsAll([80, 79.4]));
    expect(day.activeKcal, 420);
  });
}
