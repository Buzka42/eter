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
  Widget build(BuildContext context) => Scaffold(
        body: MilestoneListener(
          child: IndexedStack(
            index: _sanctumOpen ? 1 : 0,
            sizing: StackFit.expand,
            children: [
              AetherScreen(
                onOpenFeatures: () => setState(() => _sanctumOpen = true),
              ),
              Stack(
                children: [
                  const Positioned.fill(child: SettingsScreen()),
                  SafeArea(
                    child: Padding(
                      // The action's own 8px inset is folded in so the label
                      // lands on the gutter, not the rule on it.
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
            ],
          ),
        ),
      );
}
