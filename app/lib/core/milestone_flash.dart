import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/home/home_providers.dart';
import 'arcana/zodiac.dart';
import 'haptics.dart';
import 'profile.dart';
import 'tokens.dart';

class MilestoneFlash extends StatelessWidget {
  const MilestoneFlash({super.key, required this.elementColor});
  final Color elementColor;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration =
        reduceMotion ? const Duration(milliseconds: 500) : EterMotion.durReveal;
    return IgnorePointer(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: duration,
        curve: Curves.linear,
        builder: (context, t, _) {
          if (reduceMotion) {
            final envelope = t < 0.2 ? t / 0.2 : (1 - t) / 0.8;
            return ColoredBox(
              color: elementColor.withValues(alpha: envelope * 0.25),
            );
          }
          final opacity = switch (t) {
            < 0.10 => t / 0.10 * 0.92,
            < 0.167 => 0.92,
            < 0.422 => 0.92 - ((t - 0.167) / 0.255 * 0.47),
            _ => (0.45 * (1 - t) / 0.578).clamp(0.0, 0.45),
          };
          final color = t < 0.167 ? EterColors.mist0 : elementColor;
          return ColoredBox(color: color.withValues(alpha: opacity));
        },
      ),
    );
  }
}

/// Fires the milestone celebration — the "breath" haptic and the element
/// flash — whenever the day's milestone count increases.
///
/// This lived inside HomeScreen, so folding that screen into the Aether
/// dashboard silently killed the feature: the database went on counting
/// crossings and nothing in the app reacted. It belongs at the shell, above
/// any one surface, so a milestone reached while the Ledger or the Pulse is
/// open still registers.
class MilestoneListener extends ConsumerStatefulWidget {
  const MilestoneListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<MilestoneListener> createState() => _MilestoneListenerState();
}

class _MilestoneListenerState extends ConsumerState<MilestoneListener> {
  DateTime? _lastFlashAt;

  void _onMilestone() {
    final profile = ref.read(profileProvider);
    if (profile?.hapticsEnabled ?? true) {
      EterHaptics.milestone();
    }
    final now = DateTime.now();
    final mayFlash = _lastFlashAt == null ||
        now.difference(_lastFlashAt!) >= const Duration(seconds: 60);
    if (!(profile?.flashEnabled ?? true) || !mayFlash) return;
    _lastFlashAt = now;
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: MilestoneFlash(
          elementColor: profile?.zodiac.element.accent ?? EterColors.sky300,
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(EterMotion.durReveal, entry.remove);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(dayStateProvider, (previous, next) {
      final before = previous?.value;
      final after = next.value;
      if (before != null &&
          after != null &&
          after.milestonesFired > before.milestonesFired) {
        _onMilestone();
      }
    });
    return widget.child;
  }
}
