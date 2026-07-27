import 'package:drift/native.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:eter/core/energy/energy.dart';
import 'package:eter/core/health/background_sync.dart';
import 'package:eter/core/health/health_hub.dart';
import 'package:eter/core/health/sync_policy.dart';
import 'package:eter/core/profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final profile = Profile(
    dob: DateTime.utc(1990, 1, 1),
    sex: Sex.female,
    weightKg: 62,
  );
  final day = DateTime.utc(2026, 7, 26, 9);

  Future<AppDatabase> database({bool withProfile = true}) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    if (withProfile) await db.saveProfile(profile);
    return db;
  }

  FakeHealthHub hubWithMinute() => FakeHealthHub(records: [
        HealthMinuteRecord(
          minuteUtc: DateTime.utc(2026, 7, 26, 8),
          activeKcal: 42,
          sourceId: 'health-connect',
          steps: 500,
        ),
      ]);

  test('a scheduled run ingests without the app being open', () async {
    final db = await database();
    final hub = hubWithMinute();

    expect(await runHealthBackgroundSync(database: db, hub: hub, now: day),
        isTrue);

    expect(hub.reads, 1);
    final summary = await db.select(db.daySummaries).getSingle();
    expect(summary.steps, 500);
    final integration = await db.select(db.integrations).getSingle();
    expect(integration.status, 'connected');
    expect(integration.changesToken, 'fake-1');
  });

  test('the stored token is passed to the next scheduled read', () async {
    final db = await database();
    final hub = hubWithMinute();

    await runHealthBackgroundSync(database: db, hub: hub, now: day);
    // Timed from the attempt the database recorded, far enough ahead that
    // freshness no longer blocks the second run.
    final attempt = await db
        .select(db.integrations)
        .getSingle()
        .then((r) => r.lastAttempt!);
    await runHealthBackgroundSync(
      database: db,
      hub: hub,
      now: attempt.add(const Duration(hours: 2)),
    );

    expect(hub.reads, 2);
    expect(hub.lastChangesToken, 'fake-1');
  });

  test('a fresh sync is skipped rather than repeated', () async {
    final db = await database();
    final hub = hubWithMinute();

    await runHealthBackgroundSync(database: db, hub: hub, now: day);
    // The database stamps the attempt with its own clock, so the second
    // firing is timed against what was actually recorded.
    final attempt = await db
        .select(db.integrations)
        .getSingle()
        .then((r) => r.lastAttempt!);
    await runHealthBackgroundSync(
      database: db,
      hub: hub,
      now: attempt.add(const Duration(minutes: 5)),
    );

    expect(hub.reads, 1, reason: 'the second firing was inside the interval');
  });

  test('no profile means no read', () async {
    final db = await database(withProfile: false);
    final hub = hubWithMinute();

    expect(await runHealthBackgroundSync(database: db, hub: hub, now: day),
        isTrue);
    expect(hub.reads, 0);
  });

  test('revoked permission means no read', () async {
    final db = await database();
    final hub = hubWithMinute()..permission = HealthPermissionState.denied;

    expect(await runHealthBackgroundSync(database: db, hub: hub, now: day),
        isTrue);
    expect(hub.reads, 0);
  });

  test('a failed read is reported as handled and recorded for backoff',
      () async {
    final db = await database();
    final hub = ThrowingHealthHub();

    expect(
      await runHealthBackgroundSync(database: db, hub: hub, now: day),
      isTrue,
      reason: 'failing to the OS would stack a second backoff on the policy',
    );

    final integration = await db.select(db.integrations).getSingle();
    expect(integration.status, 'failed');

    // The policy, not the OS, decides when to try again.
    final decision = const HealthSyncPolicy().decide(
      now: integration.lastAttempt!.add(const Duration(minutes: 1)),
      state: HealthSyncState(
        lastAttempt: integration.lastAttempt,
        lastSync: integration.lastSync,
        failed: true,
      ),
      profileReady: true,
      permissionGranted: true,
    );
    expect(decision.verdict, HealthSyncVerdict.backingOff);
  });
}

class ThrowingHealthHub implements HealthHub {
  @override
  Future<HealthPermissionState> permissionState() async =>
      HealthPermissionState.granted;

  @override
  Future<HealthPermissionState> requestPermissions() async =>
      HealthPermissionState.granted;

  @override
  Future<HealthReadBatch> readChanges({
    required DateTime startUtc,
    required DateTime endUtc,
    String? changesToken,
  }) async =>
      throw StateError('Health Connect unavailable');
}
