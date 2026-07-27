import 'ai_contract.dart';

/// Deterministic development fallback. Firebase replaces this transport without
/// changing meal screens, persistence, validation, or tests.
class DevelopmentAetherTransport implements AetherTransport {
  const DevelopmentAetherTransport();

  static const _foods = <String, MealItemEstimate>{
    'egg': MealItemEstimate(
      name: 'Egg',
      portion: '1 large',
      kcal: 72,
      proteinG: 6.3,
      carbsG: .4,
      fatG: 4.8,
    ),
    'banana': MealItemEstimate(
      name: 'Banana',
      portion: '1 medium',
      kcal: 105,
      proteinG: 1.3,
      carbsG: 27,
      fatG: .4,
    ),
    'apple': MealItemEstimate(
      name: 'Apple',
      portion: '1 medium',
      kcal: 95,
      proteinG: .5,
      carbsG: 25,
      fatG: .3,
    ),
    'chicken': MealItemEstimate(
      name: 'Chicken breast',
      portion: '150 g cooked',
      kcal: 248,
      proteinG: 46.5,
      carbsG: 0,
      fatG: 5.4,
    ),
    'rice': MealItemEstimate(
      name: 'Rice',
      portion: '1 cup cooked',
      kcal: 205,
      proteinG: 4.3,
      carbsG: 44.5,
      fatG: .4,
    ),
    'yogurt': MealItemEstimate(
      name: 'Greek yogurt',
      portion: '200 g',
      kcal: 146,
      proteinG: 20,
      carbsG: 7.8,
      fatG: 3.8,
    ),
  };

  @override
  Future<Map<String, Object?>> invoke(Map<String, Object?> request) async {
    if (request['task'] != 'estimate_meal') {
      throw const AetherProtocolException('Unsupported development task');
    }
    final context = Map<String, Object?>.from(request['context']! as Map);
    final description = context['description'].toString().toLowerCase();
    final matches = <MealItemEstimate>[];
    for (final entry in _foods.entries) {
      if (description.contains(entry.key)) matches.add(entry.value);
    }
    if (matches.isEmpty) {
      matches.add(const MealItemEstimate(
        name: 'Meal estimate',
        portion: '1 described serving',
        kcal: 400,
        proteinG: 20,
        carbsG: 45,
        fatG: 15,
      ));
    }
    return {
      'schemaVersion': 1,
      'items': matches.map((item) => item.toJson()).toList(),
      'confidence': matches.length == 1 && matches.first.name == 'Meal estimate'
          ? .25
          : .55,
      'assumptions': const [
        'Standard portions were assumed where quantities were missing.',
        'Preparation fats and sauces may change the result.',
      ],
      'model': 'local-development-fallback',
    };
  }
}
