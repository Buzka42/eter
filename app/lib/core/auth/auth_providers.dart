import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_gateway.dart';

final authGatewayProvider = Provider<AuthGateway>(
  (_) => const UnconfiguredAuthGateway(),
);

final authSessionProvider = StreamProvider<AuthSession?>(
  (ref) => ref.watch(authGatewayProvider).authStateChanges(),
);
