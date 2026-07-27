import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

class FirebaseRuntime {
  const FirebaseRuntime._({
    required this.configured,
    this.app,
    this.reason,
  });

  final bool configured;
  final FirebaseApp? app;
  final String? reason;

  static const allowUnconfiguredAuth = bool.fromEnvironment(
    'ETER_ALLOW_UNCONFIGURED_AUTH',
    defaultValue: true,
  );

  static Future<FirebaseRuntime> initialize() async {
    final options = _optionsForCurrentPlatform();
    if (options == null) {
      return const FirebaseRuntime._(
        configured: false,
        reason: 'Firebase platform identifiers are not configured.',
      );
    }
    final app = await Firebase.initializeApp(options: options);
    await FirebaseAppCheck.instance.activate(
      providerAndroid: kDebugMode
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
      providerApple: kDebugMode
          ? const AppleDebugProvider()
          : const AppleAppAttestProvider(),
    );
    return FirebaseRuntime._(configured: true, app: app);
  }

  static FirebaseOptions? _optionsForCurrentPlatform() {
    const apiKey = String.fromEnvironment('ETER_FIREBASE_API_KEY');
    const projectId = String.fromEnvironment('ETER_FIREBASE_PROJECT_ID');
    const senderId = String.fromEnvironment('ETER_FIREBASE_SENDER_ID');
    if (apiKey.isEmpty || projectId.isEmpty || senderId.isEmpty) return null;

    final appId = switch (defaultTargetPlatform) {
      TargetPlatform.android =>
        const String.fromEnvironment('ETER_FIREBASE_ANDROID_APP_ID'),
      TargetPlatform.iOS =>
        const String.fromEnvironment('ETER_FIREBASE_IOS_APP_ID'),
      _ => const String.fromEnvironment('ETER_FIREBASE_APP_ID'),
    };
    if (appId.isEmpty) return null;

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: senderId,
      projectId: projectId,
      authDomain: const String.fromEnvironment(
        'ETER_FIREBASE_AUTH_DOMAIN',
        defaultValue: '',
      ),
      storageBucket: const String.fromEnvironment(
        'ETER_FIREBASE_STORAGE_BUCKET',
        defaultValue: '',
      ),
      iosBundleId: defaultTargetPlatform == TargetPlatform.iOS
          ? const String.fromEnvironment(
              'ETER_FIREBASE_IOS_BUNDLE_ID',
              defaultValue: 'com.eterhealth.eter',
            )
          : null,
    );
  }
}
