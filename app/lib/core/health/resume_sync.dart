import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../profile.dart';
import '../theme.dart';
import 'background_sync.dart';
import 'health_hub.dart';
import 'health_providers.dart';
import 'sync_policy.dart';

class HealthResumeSync extends ConsumerStatefulWidget {
  const HealthResumeSync({
    super.key,
    required this.child,
    this.policy = const HealthSyncPolicy(),
  });

  final Widget child;
  final HealthSyncPolicy policy;

  @override
  ConsumerState<HealthResumeSync> createState() => _HealthResumeSyncState();
}

class _HealthResumeSyncState extends ConsumerState<HealthResumeSync>
    with WidgetsBindingObserver {
  bool _syncing = false;
  bool? _scheduled;

  /// Keeps the periodic background job in step with permission.
  ///
  /// Registering costs nothing to repeat, but scheduling work that can only
  /// fail is worse than not scheduling it, so the job exists exactly while
  /// health data can actually be read.
  Future<void> _updateBackgroundSchedule(bool granted) async {
    if (eterRunningTests() || _scheduled == granted) return;
    _scheduled = granted;
    try {
      if (granted) {
        await registerHealthBackgroundSync();
      } else {
        await cancelHealthBackgroundSync();
      }
    } catch (_) {
      // A device that refuses to schedule work still syncs on resume.
      _scheduled = null;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncIfDue());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _syncIfDue();
  }

  Future<void> _syncIfDue() async {
    if (_syncing) return;
    _syncing = true;
    try {
      final profileReady = ref.read(profileProvider) != null;
      final hub = ref.read(healthHubProvider);
      final granted = profileReady &&
          await hub.permissionState() == HealthPermissionState.granted;
      final database = ref.read(databaseProvider);
      final previous = await database.loadIntegration('health-hub');
      final decision = widget.policy.decide(
        now: DateTime.now().toUtc(),
        state: previous == null
            ? null
            : HealthSyncState(
                lastAttempt: previous.lastAttempt,
                lastSync: previous.lastSync,
                failed: previous.status == 'failed',
              ),
        profileReady: profileReady,
        permissionGranted: granted,
      );
      await _updateBackgroundSchedule(granted);
      if (!decision.shouldRun) return;
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day).toUtc();
      await ref.read(healthIngestServiceProvider).syncDay(
            dayStartUtc: start,
            changesToken: previous?.changesToken,
          );
    } catch (_) {
      // The diagnostics row captures failure. Resume sync is never disruptive.
    } finally {
      _syncing = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
