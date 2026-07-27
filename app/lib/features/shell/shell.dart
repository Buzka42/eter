import 'package:flutter/material.dart';

import '../../core/controls.dart';
import '../../core/milestone_flash.dart';
import '../../core/tokens.dart';
import '../aether/aether_screen.dart';
import '../settings/settings_screen.dart';

/// Eter has two destinations: the continuous main surface and The Sanctum.
/// Onboarding remains a separate first-run flow.
class EterShell extends StatefulWidget {
  const EterShell({super.key});

  @override
  State<EterShell> createState() => _EterShellState();
}

class _EterShellState extends State<EterShell> {
  var _sanctumOpen = false;

  @override
  Widget build(BuildContext context) {
    // The Sanctum used to appear by swapping an IndexedStack index, which is
    // instant and unannounced. The theme already carries Eter's "gust" —
    // lift and fade on EterMotion.easeAir — but it only applies to pushed
    // routes, so this surface never saw it (§5.3). The same motion is applied
    // here directly, over a Stack rather than a switcher so that Aether keeps
    // its scroll position underneath.
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = reduceMotion ? Duration.zero : EterMotion.durStandard;
    return Scaffold(
      body: MilestoneListener(
        child: PopScope(
          // The Sanctum is a place you come back from; system back should
          // return to Aether rather than leave the app.
          canPop: !_sanctumOpen,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) setState(() => _sanctumOpen = false);
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              AetherScreen(
                onOpenFeatures: () => setState(() => _sanctumOpen = true),
              ),
              IgnorePointer(
                ignoring: !_sanctumOpen,
                child: ExcludeSemantics(
                  excluding: !_sanctumOpen,
                  child: AnimatedOpacity(
                    opacity: _sanctumOpen ? 1 : 0,
                    duration: duration,
                    curve: EterMotion.easeAir,
                    child: AnimatedSlide(
                      offset: _sanctumOpen ? Offset.zero : const Offset(0, .025),
                      duration: duration,
                      curve: EterMotion.easeAir,
                      child: Stack(
                        children: [
                          const Positioned.fill(child: SettingsScreen()),
                          SafeArea(
                            child: Padding(
                              // The action's own 8px inset is folded in so the
                              // label lands on the gutter, not the rule on it.
                              padding: const EdgeInsets.only(
                                  left: EterSpace.gutter - EterSpace.s8,
                                  top: EterSpace.s8),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: EterAction(
                                  label: 'Aether',
                                  icon: Icons.arrow_back,
                                  onPressed: () =>
                                      setState(() => _sanctumOpen = false),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
