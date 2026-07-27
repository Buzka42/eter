/// Decides when a health sync may run.
///
/// The rule lives here, apart from the widget that reacts to app resume and
/// from whatever schedules work in the background, so both ask the same
/// question and so the answer can be tested without a database, a plugin or a
/// running app.
library;

/// What the last sync attempt left behind.
class HealthSyncState {
  const HealthSyncState({this.lastAttempt, this.lastSync, this.failed = false});

  /// When a sync was last tried, successful or not.
  final DateTime? lastAttempt;

  /// When a sync last completed.
  final DateTime? lastSync;

  /// Whether the most recent attempt ended in failure.
  final bool failed;
}

enum HealthSyncVerdict {
  /// Nothing blocks a sync and enough time has passed.
  run,

  /// The app has no profile or no permission, so there is nothing to read.
  notReady,

  /// A sync ran recently enough that another would only cost battery.
  tooSoon,

  /// The last attempt failed and its backoff has not elapsed.
  backingOff,
}

class HealthSyncDecision {
  const HealthSyncDecision(this.verdict, {this.nextAttempt});

  final HealthSyncVerdict verdict;

  /// The earliest time a sync would be allowed, when one is not allowed now.
  final DateTime? nextAttempt;

  bool get shouldRun => verdict == HealthSyncVerdict.run;
}

class HealthSyncPolicy {
  const HealthSyncPolicy({
    this.minimumInterval = const Duration(minutes: 30),
    this.firstRetry = const Duration(minutes: 5),
    this.maximumRetry = const Duration(hours: 6),
  });

  /// How long a successful sync stays fresh.
  final Duration minimumInterval;

  /// How soon to retry after the first failure.
  final Duration firstRetry;

  /// The longest gap between retries during a sustained outage.
  final Duration maximumRetry;

  HealthSyncDecision decide({
    required DateTime now,
    required HealthSyncState? state,
    required bool profileReady,
    required bool permissionGranted,
  }) {
    if (!profileReady || !permissionGranted) {
      return const HealthSyncDecision(HealthSyncVerdict.notReady);
    }
    final attempt = state?.lastAttempt;
    if (state == null || attempt == null) {
      return const HealthSyncDecision(HealthSyncVerdict.run);
    }

    if (state.failed) {
      final next = attempt.add(_retryDelay(state, attempt));
      return next.isAfter(now)
          ? HealthSyncDecision(HealthSyncVerdict.backingOff, nextAttempt: next)
          : const HealthSyncDecision(HealthSyncVerdict.run);
    }

    final next = attempt.add(minimumInterval);
    return next.isAfter(now)
        ? HealthSyncDecision(HealthSyncVerdict.tooSoon, nextAttempt: next)
        : const HealthSyncDecision(HealthSyncVerdict.run);
  }

  /// Retries spread out the longer the outage lasts.
  ///
  /// The gap since the last success stands in for a failure counter, so a
  /// brief hiccup is retried promptly while a provider that has been down for
  /// hours is not polled every few minutes. No counter has to be stored, and
  /// the first success resets the spacing on its own.
  Duration _retryDelay(HealthSyncState state, DateTime attempt) {
    final success = state.lastSync;
    if (success == null || !attempt.isAfter(success)) return firstRetry;
    final outage = attempt.difference(success);
    final half = Duration(microseconds: outage.inMicroseconds ~/ 2);
    if (half < firstRetry) return firstRetry;
    if (half > maximumRetry) return maximumRetry;
    return half;
  }
}
