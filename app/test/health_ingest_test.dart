import 'package:drift/native.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:eter/core/health/health_hub.dart';
import 'package:eter/core/health/ingest_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

void main() {
  test('fake hub sync is end-to-end idempotent', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final day = DateTime.utc(2026, 7, 23);
    final hub = FakeHealthHub(records: [
      HealthMinuteRecord(
        minuteUtc: day.add(const Duration(hours: 8)),
        activeKcal: 60,
        sourceId: 'health-connect',
        steps: 820,
        avgHr: 94,
        hrSampleCount: 1,
      ),
      HealthMinuteRecord(
        minuteUtc: day.add(const Duration(hours: 8, minutes: 1)),
        activeKcal: 55,
        sourceId: 'health-connect',
        steps: 640,
      ),
    ]);
    final service = HealthIngestService(database: db, hub: hub);

    final first = await service.syncDay(dayStartUtc: day);
    final replay = await service.syncDay(
      dayStartUtc: day,
      changesToken: first.changesToken,
    );

    expect(first.activeKcal, 115);
    expect(first.steps, 1460);
    expect(first.newMilestones, 1);
    expect(replay.activeKcal, 115);
    expect(replay.steps, 1460);
    expect(replay.newMilestones, 0);
    expect(replay.changesToken, 'fake-2');
    expect(await db.select(db.rawBuckets).get().then((v) => v.length), 2);
    final summary = await db.select(db.daySummaries).getSingle();
    expect(summary.steps, 1460);
    final minutes = await db.select(db.minuteBuckets).get();
    expect(minutes.first.avgHr, 94);
    final integration = await db.select(db.integrations).getSingle();
    expect(integration.status, 'connected');
    expect(integration.recordsToday, 2);
    expect(integration.status, 'connected');
    expect(integration.diagnosticsJson, contains('stepsRecords'));
    expect(integration.changesToken, 'fake-2');
  });

  for (final scenario in [
    (
      name: 'steps-only',
      record: HealthMinuteRecord(
        minuteUtc: _testMinute,
        activeKcal: 0,
        sourceId: 'garmin',
        steps: 600,
      ),
      expected: const {
        'stepsRecords': 1,
        'heartRateRecords': 0,
        'energyRecords': 0
      },
    ),
    (
      name: 'heart-rate-only',
      record: HealthMinuteRecord(
        minuteUtc: _testMinute,
        activeKcal: 0,
        sourceId: 'garmin',
        avgHr: 72,
        hrSampleCount: 1,
      ),
      expected: const {
        'stepsRecords': 0,
        'heartRateRecords': 1,
        'energyRecords': 0
      },
    ),
    (
      name: 'energy-only',
      record: HealthMinuteRecord(
        minuteUtc: _testMinute,
        activeKcal: 12,
        sourceId: 'garmin',
      ),
      expected: const {
        'stepsRecords': 0,
        'heartRateRecords': 0,
        'energyRecords': 1
      },
    ),
  ]) {
    test('partial vendor data remains explicit: ${scenario.name}', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final service = HealthIngestService(
        database: db,
        hub: FakeHealthHub(records: [scenario.record]),
      );

      await service.syncDay(dayStartUtc: DateTime.utc(2026, 7, 23));

      final integration = await db.select(db.integrations).getSingle();
      final diagnostics =
          jsonDecode(integration.diagnosticsJson) as Map<String, dynamic>;
      for (final entry in scenario.expected.entries) {
        expect(diagnostics[entry.key], entry.value);
      }
    });
  }
}

final _testMinute = DateTime.utc(2026, 7, 23, 8);
