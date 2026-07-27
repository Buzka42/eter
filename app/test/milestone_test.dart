import 'package:drift/native.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:eter/core/energy/milestones.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pure milestone logic crosses only while rising', () {
    final crossing = calculateMilestoneCrossing(
      previousActiveKcal: 99,
      currentActiveKcal: 201,
      lastFiredIndex: 0,
      stepKcal: 100,
    );
    expect(crossing.newCrossings, 2);
    expect(crossing.currentIndex, 2);
    expect(
        calculateMilestoneCrossing(
          previousActiveKcal: 201,
          currentActiveKcal: 190,
          lastFiredIndex: 2,
          stepKcal: 100,
        ).newCrossings,
        0);
  });

  test('persisted milestone fires exactly once across replay and correction',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final first = await db.recordDayTotal(date: '2026-07-23', activeKcal: 250);
    final replay = await db.recordDayTotal(date: '2026-07-23', activeKcal: 250);
    final correction =
        await db.recordDayTotal(date: '2026-07-23', activeKcal: 180);
    final risingAgain =
        await db.recordDayTotal(date: '2026-07-23', activeKcal: 205);

    expect(first.newMilestones, 2);
    expect(replay.newMilestones, 0);
    expect(correction.newMilestones, 0);
    expect(correction.row.recalibrated, isTrue);
    expect(risingAgain.newMilestones, 0);
    expect(risingAgain.row.lastMilestoneIndex, 2);
  });
}
