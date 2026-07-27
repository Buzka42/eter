import 'package:eter/core/aether/ai_contract.dart';
import 'package:eter/core/aether/development_transport.dart';
import 'package:eter/core/aether/guidance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('meal response is structured, bounded, and totaled', () async {
    const client = AetherClient(DevelopmentAetherTransport());
    final result = await client.estimateMeal(
      description: 'Chicken and rice',
      units: 'metric',
    );

    expect(result.items, hasLength(2));
    expect(result.kcal, closeTo(453, .01));
    expect(result.confidence, inInclusiveRange(0, 1));
    expect(result.assumptions, isNotEmpty);
  });

  test('invalid remote nutrition values fail closed', () {
    expect(
      () => MealEstimate.fromJson({
        'schemaVersion': 1,
        'items': [
          {
            'name': 'Impossible',
            'portion': 'one',
            'kcal': -1,
            'proteinG': 0,
            'carbsG': 0,
            'fatG': 0,
          }
        ],
        'confidence': 2,
        'assumptions': [],
        'model': 'test',
      }),
      throwsA(isA<AetherProtocolException>()),
    );
  });

  test('structured unsafe guidance fails closed', () async {
    final client = AetherClient(_UnsafeTransport());
    final context = GuidanceContext(
      now: DateTime.utc(2026, 7, 24),
      firstName: 'A',
      activeKcal: 0,
      steps: 0,
      sessions: 0,
      zodiac: 'Leo',
      lifePath: 1,
      mode: GuidanceMode.balanced,
    );

    expect(
      () => client.generateGuidance(context: context),
      throwsA(anything),
    );
  });
}

class _UnsafeTransport implements AetherTransport {
  @override
  Future<Map<String, Object?>> invoke(Map<String, Object?> request) async => {
        'schemaVersion': 1,
        'sentences': ['Push through the pain to make progress.'],
        'primaryAction': 'Train harder.',
        'model': 'unsafe-test',
      };
}
