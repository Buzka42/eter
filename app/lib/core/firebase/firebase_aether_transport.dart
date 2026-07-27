import 'package:cloud_functions/cloud_functions.dart';

import '../aether/ai_contract.dart';

class FirebaseAetherTransport implements AetherTransport {
  FirebaseAetherTransport({
    FirebaseFunctions? functions,
    this.callableName = 'aether',
  }) : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;
  final String callableName;

  @override
  Future<Map<String, Object?>> invoke(Map<String, Object?> request) async {
    final result = await _functions
        .httpsCallable(
          callableName,
          options: HttpsCallableOptions(
            timeout: const Duration(seconds: 25),
          ),
        )
        .call<Map<String, Object?>>(request);
    return Map<String, Object?>.from(result.data);
  }
}
