import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/aether/ai_contract.dart';
import 'core/aether/guidance.dart';
import 'core/auth/auth_gateway.dart';
import 'core/auth/auth_providers.dart';
import 'core/db/app_database.dart';
import 'core/firebase/firebase_aether_transport.dart';
import 'core/firebase/firebase_ai_logic_transport.dart';
import 'core/firebase/firebase_runtime.dart';
import 'core/profile.dart';
import 'features/aether/aether_screen.dart';
import 'features/aether/journal_composer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebase = await FirebaseRuntime.initialize();
  final database = AppDatabase();
  runApp(_EterBootstrap(database: database, firebase: firebase));
}

class _EterBootstrap extends StatefulWidget {
  const _EterBootstrap({
    required this.database,
    required this.firebase,
  });
  final AppDatabase database;
  final FirebaseRuntime firebase;

  @override
  State<_EterBootstrap> createState() => _EterBootstrapState();
}

class _EterBootstrapState extends State<_EterBootstrap> {
  late final Future<Profile?> _profile = widget.database.loadProfile();

  @override
  Widget build(BuildContext context) {
    const transport = String.fromEnvironment(
      'ETER_AETHER_TRANSPORT',
      defaultValue: 'ai_logic',
    );
    return FutureBuilder<Profile?>(
      future: _profile,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: const Color(0xFFF6F3EC),
              body: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    radius: 1.2,
                    colors: [Color(0xFFFFFCF6), Color(0xFFE8EEF2)],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/art/app-icon-air.webp',
                          width: 92,
                          height: 92,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'ETER',
                        style: TextStyle(
                          fontFamily: 'Marcellus',
                          fontSize: 18,
                          letterSpacing: 5,
                          color: Color(0xFF1C2B3A),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const SizedBox(
                        width: 36,
                        child: LinearProgressIndicator(
                          minHeight: 1,
                          backgroundColor: Color(0x33D4AF6A),
                          color: Color(0xFFD4AF6A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        final client = widget.firebase.configured
            ? AetherClient(
                transport == 'functions'
                    ? FirebaseAetherTransport()
                    : FirebaseAiLogicTransport(),
              )
            : null;
        return ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(widget.database),
            initialProfileProvider.overrideWithValue(snapshot.data),
            authGatewayProvider.overrideWithValue(
              widget.firebase.configured
                  ? FirebaseAuthGateway()
                  : const UnconfiguredAuthGateway(),
            ),
            if (widget.firebase.configured)
              aetherClientProvider.overrideWithValue(client),
            if (widget.firebase.configured)
              aetherGuidanceProvider.overrideWithValue(
                FallbackGuidanceProvider(
                  primary: RemoteGuidanceProvider(client!),
                ),
              ),
          ],
          child: const EterApp(),
        );
      },
    );
  }
}
