import 'package:eter/core/live/connection_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reconnect policy is bounded exponential backoff', () {
    const policy = ReconnectPolicy();
    expect(policy.delayForAttempt(1), const Duration(seconds: 1));
    expect(policy.delayForAttempt(2), const Duration(seconds: 2));
    expect(policy.delayForAttempt(3), const Duration(seconds: 4));
    expect(policy.delayForAttempt(4), const Duration(seconds: 8));
    expect(policy.delayForAttempt(5), const Duration(seconds: 16));
    expect(policy.delayForAttempt(6), isNull);
  });
}
