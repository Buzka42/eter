import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_providers.dart';
import '../profile.dart';
import 'profile_cloud_mirror.dart';

/// Mirrors the small, non-health profile document after authenticated changes.
class ProfileCloudSync extends ConsumerStatefulWidget {
  const ProfileCloudSync({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ProfileCloudSync> createState() => _ProfileCloudSyncState();
}

class _ProfileCloudSyncState extends ConsumerState<ProfileCloudSync> {
  String? _lastWrite;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authSessionProvider).valueOrNull;
    final profile = ref.watch(profileProvider);
    if (session != null && profile != null) {
      final fingerprint = [
        session.uid,
        profile.firstName,
        profile.dob.toIso8601String(),
        profile.weightKg,
        profile.heightCm,
        profile.units.name,
        profile.guidanceMode.name,
        profile.birthTimeMinutes,
        profile.birthUtcOffsetMinutes,
        profile.birthPlace,
        profile.birthLatitude,
        profile.birthLongitude,
      ].join('|');
      if (_lastWrite != fingerprint) {
        _lastWrite = fingerprint;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ProfileCloudMirror()
              .save(uid: session.uid, profile: profile)
              .onError((_, __) {});
        });
      }
    }
    return widget.child;
  }
}
