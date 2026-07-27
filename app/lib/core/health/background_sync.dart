/// Scheduled health sync that runs while the app is closed.
///
/// Resume sync only fires when someone opens the app, so a day of wearable
/// data can sit unread until then. This registers a periodic OS job that
/// performs the same token-based read, so the ledger is current when the app
/// is next opened rather than being caught up on the spot.
library;

import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import '../db/app_database.dart';
import 'carp_health_hub.dart';
import 'health_hub.dart';
import 'ingest_service.dart';
import 'sync_policy.dart';

/// Unique name for the periodic job, kept stable so re-registering replaces
/// the existing schedule rather than stacking another copy of it.
const String healthBackgroundSyncTask = 'eter.health.periodic-sync';

/// Android enforces a fifteen-minute floor on periodic work; asking for less
/// silently gets this anyway. The policy inside the task decides whether a
/// given firing actually reads anything.
const Duration healthBackgroundSyncInterval = Duration(minutes: 30);

/// Registers the periodic job. Safe to call on every launch.
Future<void> registerHealthBackgroundSync({
  Duration frequency = healthBackgroundSyncInterval,
}) async {
  if (!defaultTargetPlatform.isMobile) return;
  await Workmanager().initialize(healthBackgroundSyncDispatcher);
  await Workmanager().registerPeriodicTask(
    healthBackgroundSyncTask,
    healthBackgroundSyncTask,
    frequency: frequency,
    // Replace rather than keep, so a changed interval takes effect instead of
    // leaving an old schedule running forever.
    existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    constraints: Constraints(
      networkType: NetworkType.notRequired,
      requiresBatteryNotLow: true,
    ),
  );
}

/// Cancels the periodic job, for when health access is revoked or declined.
Future<void> cancelHealthBackgroundSync() async {
  if (!defaultTargetPlatform.isMobile) return;
  await Workmanager().cancelByUniqueName(healthBackgroundSyncTask);
}

@pragma('vm:entry-point')
void healthBackgroundSyncDispatcher() {
  Workmanager().executeTask((taskName, _) async {
    if (taskName != healthBackgroundSyncTask) return true;
    return runHealthBackgroundSync();
  });
}

/// Performs one scheduled sync.
///
/// This runs in its own isolate with no widget tree and no providers, so it
/// opens its own database handle and closes it again. Returning true keeps the
/// schedule healthy: a failed read is already recorded as a diagnostics row and
/// retried under the policy, and reporting failure to the OS would only add a
/// second, competing backoff on top of it.
@visibleForTesting
Future<bool> runHealthBackgroundSync({
  AppDatabase? database,
  HealthHub? hub,
  HealthSyncPolicy policy = const HealthSyncPolicy(),
  DateTime? now,
}) async {
  final owned = database == null;
  final db = database ?? AppDatabase();
  try {
    final health = hub ?? CarpHealthHub();
    final profile = await db.loadProfile();
    final granted = profile != null &&
        await health.permissionState() == HealthPermissionState.granted;
    final previous = await db.loadIntegration('health-hub');
    final decision = policy.decide(
      now: now?.toUtc() ?? DateTime.now().toUtc(),
      state: previous == null
          ? null
          : HealthSyncState(
              lastAttempt: previous.lastAttempt,
              lastSync: previous.lastSync,
              failed: previous.status == 'failed',
            ),
      profileReady: profile != null,
      permissionGranted: granted,
    );
    if (!decision.shouldRun) return true;

    final today = now?.toLocal() ?? DateTime.now();
    await HealthIngestService(database: db, hub: health).syncDay(
      dayStartUtc: DateTime(today.year, today.month, today.day).toUtc(),
      changesToken: previous?.changesToken,
    );
    return true;
  } catch (_) {
    // syncDay already wrote the failure row the policy reads next time.
    return true;
  } finally {
    if (owned) await db.close();
  }
}

extension on TargetPlatform {
  bool get isMobile =>
      this == TargetPlatform.android || this == TargetPlatform.iOS;
}
