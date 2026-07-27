import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_gateway.dart';
import '../../core/auth/auth_providers.dart';
import '../../core/firebase/firebase_runtime.dart';
import '../../core/theme.dart';
import '../../core/tokens.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gateway = ref.watch(authGatewayProvider);
    if (!gateway.configured) {
      return FirebaseRuntime.allowUnconfiguredAuth
          ? child
          : const _FirebaseConfigurationRequired();
    }
    return ref.watch(authSessionProvider).when(
          loading: () => const _AuthLoading(),
          error: (error, _) => _SignInScreen(initialError: error.toString()),
          data: (session) => session == null ? const _SignInScreen() : child,
        );
  }
}

class _AuthLoading extends StatelessWidget {
  const _AuthLoading();

  @override
  Widget build(BuildContext context) => const ColoredBox(
        color: EterColors.night900,
        child: Center(child: CircularProgressIndicator()),
      );
}

class _FirebaseConfigurationRequired extends StatelessWidget {
  const _FirebaseConfigurationRequired();

  @override
  Widget build(BuildContext context) => SkyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(EterSpace.gutter),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Account service is not configured',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: EterSpace.s16),
                const Text(
                  'This beta requires an Eter account. Reinstall a build made '
                  'with the Firebase project identifiers and enabled Google '
                  'and Apple providers.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
}

class _SignInScreen extends ConsumerStatefulWidget {
  const _SignInScreen({this.initialError});
  final String? initialError;

  @override
  ConsumerState<_SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<_SignInScreen> {
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _error = widget.initialError;
  }

  Future<void> _run(Future<AuthSession> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on Object catch (error) {
      if (mounted) setState(() => _error = _friendly(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gateway = ref.read(authGatewayProvider);
    return SkyBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(EterSpace.gutter),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/art/app-icon-air.webp',
                  width: 96,
                  height: 96,
                ),
              ),
              const SizedBox(height: EterSpace.s24),
              Text(
                'Your guidance, kept with you',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: EterSpace.s12),
              const Text(
                'Sign in to protect your profile and carry Eter between devices.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: EterSpace.s32),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed:
                      _busy ? null : () => _run(gateway.signInWithGoogle),
                  icon: const Icon(Icons.account_circle_outlined),
                  label: const Text('Continue with Google'),
                ),
              ),
              const SizedBox(height: EterSpace.s12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : () => _run(gateway.signInWithApple),
                  icon: const Icon(Icons.apple),
                  label: const Text('Continue with Apple'),
                ),
              ),
              if (_busy) ...[
                const SizedBox(height: EterSpace.s16),
                const LinearProgressIndicator(),
              ],
              if (_error != null) ...[
                const SizedBox(height: EterSpace.s16),
                Text(
                  _error!,
                  style: const TextStyle(color: EterColors.danger),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: EterSpace.s24),
              Text(
                'Health records remain local unless a later consent screen '
                'explicitly says otherwise.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _friendly(Object error) {
    final value = error.toString().toLowerCase();
    if (value.contains('cancel')) return 'Sign-in was cancelled.';
    if (value.contains('network')) {
      return 'A network connection is required to sign in.';
    }
    return 'Sign-in could not be completed. Check the provider configuration '
        'and try again.';
  }
}
