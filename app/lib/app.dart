import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/profile.dart';
import 'core/register.dart';
import 'core/theme.dart';
import 'core/health/resume_sync.dart';
import 'core/firebase/profile_cloud_sync.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/auth_gate.dart';
import 'features/shell/shell.dart';

final _routerProvider = Provider<GoRouter>((ref) {
  // Rebuilt when onboarding completes (profile flips null -> value).
  final onboarded = ref.watch(profileProvider) != null;
  return GoRouter(
    initialLocation: onboarded ? '/' : '/onboarding',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const EterShell()),
      GoRoute(
          path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    ],
    redirect: (context, state) {
      final atOnboarding = state.matchedLocation == '/onboarding';
      if (!onboarded && !atOnboarding) return '/onboarding';
      if (onboarded && atOnboarding) return '/';
      return null;
    },
  );
});

class EterApp extends ConsumerWidget {
  const EterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(_routerProvider);
    // Before onboarding completes there is no mode yet; the welcome sequence
    // is the mystical pitch, so it opens in the immersive register.
    final mode = ref.watch(profileProvider)?.guidanceMode;
    final register = mode == null
        ? EterRegister.immersive
        : EterRegister.fromGuidanceMode(mode);
    return MaterialApp.router(
      title: 'Eter',
      debugShowCheckedModeBanner: false,
      theme: EterTheme.day(),
      darkTheme: EterTheme.night(),
      // The register owns the theme. Grounded is a daylight instrument and
      // immersive is a night sky; letting the OS override either produced the
      // two combinations neither was designed for — gold ornament on a white
      // screen, and a plain grey reading on black.
      themeMode: switch (register) {
        EterRegister.grounded => ThemeMode.light,
        EterRegister.immersive => ThemeMode.dark,
        EterRegister.balanced => ThemeMode.system,
      },
      routerConfig: router,
      builder: (context, child) => EterRegisterScope(
        register: register,
        child: AuthGate(
          child: ProfileCloudSync(
            child: HealthResumeSync(
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
