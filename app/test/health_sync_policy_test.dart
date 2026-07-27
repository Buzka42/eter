import 'package:eter/core/health/sync_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = HealthSyncPolicy();
  final now = DateTime.utc(2026, 7, 26, 12);

  HealthSyncDecision decide(
    HealthSyncState? state, {
    bool profileReady = true,
    bool permissionGranted = true,
  }) =>
      policy.decide(
        now: now,
        state: state,
        profileReady: profileReady,
        permissionGranted: permissionGranted,
      );

  group('Readiness', () {
    test('no profile means there is nothing to sync', () {
      expect(decide(null, profileReady: false).verdict,
          HealthSyncVerdict.notReady);
    });

    test('missing permission means there is nothing to read', () {
      expect(decide(null, permissionGranted: false).verdict,
          HealthSyncVerdict.notReady);
    });

    test('readiness is checked before freshness', () {
      final fresh = HealthSyncState(
        lastAttempt: now.subtract(const Duration(minutes: 1)),
        lastSync: now.subtract(const Duration(minutes: 1)),
      );
      expect(decide(fresh, permissionGranted: false).verdict,
          HealthSyncVerdict.notReady);
    });
  });

  group('Freshness', () {
    test('a first sync always runs', () {
      expect(decide(null).shouldRun, isTrue);
      expect(decide(const HealthSyncState()).shouldRun, isTrue);
    });

    test('a recent success suppresses another sync', () {
      final state = HealthSyncState(
        lastAttempt: now.subtract(const Duration(minutes: 10)),
        lastSync: now.subtract(const Duration(minutes: 10)),
      );
      final decision = decide(state);
      expect(decision.verdict, HealthSyncVerdict.tooSoon);
      expect(decision.nextAttempt, now.add(const Duration(minutes: 20)));
    });

    test('a stale success allows a sync', () {
      final state = HealthSyncState(
        lastAttempt: now.subtract(const Duration(minutes: 31)),
        lastSync: now.subtract(const Duration(minutes: 31)),
      );
      expect(decide(state).shouldRun, isTrue);
    });

    test('the boundary itself is due, not early', () {
      final state = HealthSyncState(
        lastAttempt: now.subtract(const Duration(minutes: 30)),
        lastSync: now.subtract(const Duration(minutes: 30)),
      );
      expect(decide(state).shouldRun, isTrue);
    });
  });

  group('Backoff after failure', () {
    test('the first failure is retried quickly', () {
      final state = HealthSyncState(
        lastAttempt: now.subtract(const Duration(minutes: 6)),
        lastSync: now.subtract(const Duration(minutes: 8)),
        failed: true,
      );
      expect(decide(state).shouldRun, isTrue);
    });

    test('a failure retried too soon backs off', () {
      final state = HealthSyncState(
        lastAttempt: now.subtract(const Duration(minutes: 2)),
        lastSync: now.subtract(const Duration(minutes: 4)),
        failed: true,
      );
      final decision = decide(state);
      expect(decision.verdict, HealthSyncVerdict.backingOff);
      expect(decision.nextAttempt, now.add(const Duration(minutes: 3)));
    });

    test('a longer outage spreads retries out', () {
      // Four hours without a success: the next retry waits two hours from the
      // last attempt rather than five minutes.
      final state = HealthSyncState(
        lastAttempt: now.subtract(const Duration(minutes: 30)),
        lastSync: now.subtract(const Duration(hours: 4, minutes: 30)),
        failed: true,
      );
      final decision = decide(state);
      expect(decision.verdict, HealthSyncVerdict.backingOff);
      expect(
          decision.nextAttempt, now.add(const Duration(hours: 1, minutes: 30)));
    });

    test('backoff never exceeds the maximum', () {
      final state = HealthSyncState(
        lastAttempt: now.subtract(const Duration(days: 1)),
        lastSync: now.subtract(const Duration(days: 30)),
        failed: true,
      );
      expect(decide(state).shouldRun, isTrue,
          reason: 'a day has passed and the cap is six hours');

      final justFailed = HealthSyncState(
        lastAttempt: now.subtract(const Duration(hours: 1)),
        lastSync: now.subtract(const Duration(days: 30)),
        failed: true,
      );
      final decision = decide(justFailed);
      expect(decision.nextAttempt, now.add(const Duration(hours: 5)));
    });

    test('a failure with no prior success uses the first retry', () {
      final state = HealthSyncState(
        lastAttempt: now.subtract(const Duration(minutes: 1)),
        failed: true,
      );
      final decision = decide(state);
      expect(decision.verdict, HealthSyncVerdict.backingOff);
      expect(decision.nextAttempt, now.add(const Duration(minutes: 4)));
    });

    test('a success after failures restores the ordinary interval', () {
      final state = HealthSyncState(
        lastAttempt: now.subtract(const Duration(minutes: 5)),
        lastSync: now.subtract(const Duration(minutes: 5)),
      );
      final decision = decide(state);
      expect(decision.verdict, HealthSyncVerdict.tooSoon);
      expect(decision.nextAttempt, now.add(const Duration(minutes: 25)));
    });
  });
}
