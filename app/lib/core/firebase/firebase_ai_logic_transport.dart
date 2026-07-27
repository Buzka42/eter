import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';

import '../aether/ai_contract.dart';

/// No-server Aether transport using Firebase AI Logic's protected Gemini proxy.
///
/// The Gemini Developer API backend supports a free tier. App Check should be
/// enforced in the Firebase console before distributing a production build.
class FirebaseAiLogicTransport implements AetherTransport {
  FirebaseAiLogicTransport({
    this.modelName = const String.fromEnvironment(
      'ETER_GEMINI_MODEL',
      defaultValue: 'gemini-2.5-flash-lite',
    ),
  });

  final String modelName;

  @override
  Future<Map<String, Object?>> invoke(Map<String, Object?> request) async {
    final task = request['task'];
    final schema = switch (task) {
      'daily_guidance' => _guidanceSchema,
      'estimate_meal' => _mealSchema,
      'classify_journal_entry' => _journalSchema,
      'compose_vessel' => _vesselSchema,
      'synthesize_insights' => _insightsSchema,
      _ => throw AetherProtocolException('Unsupported Aether task: $task'),
    };
    final model = FirebaseAI.googleAI().generativeModel(
      model: modelName,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: schema,
        temperature: 0.35,
        maxOutputTokens: 1200,
      ),
    );
    final response = await model.generateContent([
      Content.text(
        '${_systemInstruction(task, request['mode'])}'
        '\n\nINPUT:\n${jsonEncode(request)}',
      ),
    ]).timeout(const Duration(seconds: 25));
    final text = response.text;
    if (text == null || text.trim().isEmpty) {
      throw const AetherProtocolException('The model returned no content');
    }
    final decoded = jsonDecode(text);
    if (decoded is! Map) {
      throw const AetherProtocolException('The model returned invalid JSON');
    }
    return Map<String, Object?>.from(decoded);
  }
}

String _systemInstruction(Object? task, Object? mode) {
  if (task == 'estimate_meal') {
    return '''
You are Eter's conservative text-only nutrition estimator. Estimate only what
the user stated, expose assumptions, use ordinary food portions, and lower
confidence when quantity or preparation is unclear. Never invent precision.
Return schemaVersion 1 and model "$task".''';
  }
  if (task == 'classify_journal_entry') {
    return '''
You are Eter's journal extraction engine. Convert the user's prose into one or
more factual segments: food, activity, strength, mood, stress, recovery, sleep,
or note. Preserve ambiguity through conservative estimates and confidence.
For activity, estimate total activeKcal using the supplied weight and described
duration/intensity; do not use or emit MET values. For strength, recognize
exercises and any stated sets/reps/weights, and set needsUserDetail whenever
set-by-set detail is incomplete. Never add an event the user did not state.
Understand the supplied locale. Return schemaVersion 1 and model "$task".''';
  }
  if (task == 'compose_vessel') {
    return '''
You are composing Eter's one-time Vessel reading from a deterministic natal
chart and life-path matrix. Write one concise reflective passage for each
supplied planet/luminary/angle and each house, then a closing synthesis.
Symbolism is a lens, never fate, diagnosis, evidence, or a command. Never invent
positions, aspects, house cusps, or numbers. Return schemaVersion 1 and model
"$task".''';
  }
  if (task == 'synthesize_insights') {
    return '''
You phrase Eter's deterministic correlation candidates in clear, cautious
language. You receive only a summary, coefficient, sample size, and window.
Preserve every number and direction exactly. Never imply causation and never
invent a mechanism, value, or underlying observation. Return one phrasing per
key, schemaVersion 1, and model "$task".''';
  }
  final weighting = switch (mode) {
    'grounded' => '''
Grounded mode: physical data must lead and determine every recommendation.
Symbolic context may colour at most one closing clause. Never let symbolism
explain a number and never use fated or compulsory language.''',
    'immersive' => '''
Immersive mode: symbolic framing may lead, but physical data must ground the
meaning and determine the concrete action. Symbolism is reflective, not fate.''',
    _ => '''
Balanced mode: physical data leads, with symbolic framing woven through as a
reflective lens rather than evidence or fate.''',
  };
  return '''
You are Eter's daily wellbeing companion. Synthesize the supplied recent health,
lifestyle, natal-chart and life-path context into precise, gentle guidance.
Physical health and recovery take priority. Symbolic data is reflective context,
never fate, diagnosis, or evidence. Give 1-4 short sentences plus one concrete,
safe primaryAction. Do not diagnose, prescribe, shame, or make certainty claims.
Return schemaVersion 1 and model "$task".
$weighting''';
}

final _guidanceSchema = Schema.object(properties: {
  'schemaVersion': Schema.integer(),
  'sentences': Schema.array(
    items: Schema.string(),
    minItems: 1,
    maxItems: 4,
  ),
  'primaryAction': Schema.string(),
  'model': Schema.string(),
});

final _mealSchema = Schema.object(properties: {
  'schemaVersion': Schema.integer(),
  'items': Schema.array(
    minItems: 1,
    maxItems: 30,
    items: Schema.object(properties: {
      'name': Schema.string(),
      'portion': Schema.string(),
      'kcal': Schema.number(),
      'proteinG': Schema.number(),
      'carbsG': Schema.number(),
      'fatG': Schema.number(),
    }),
  ),
  'confidence': Schema.number(),
  'assumptions': Schema.array(items: Schema.string(), maxItems: 10),
  'model': Schema.string(),
});

final _journalSchema = Schema.object(properties: {
  'schemaVersion': Schema.integer(),
  'segments': Schema.array(
    minItems: 1,
    maxItems: 30,
    items: Schema.object(properties: {
      'kind': Schema.enumString(enumValues: [
        'food',
        'activity',
        'strength',
        'mood',
        'stress',
        'recovery',
        'sleep',
        'note',
      ]),
      'items': Schema.array(
        nullable: true,
        maxItems: 30,
        items: Schema.object(properties: {
          'name': Schema.string(),
          'portion': Schema.string(),
          'kcal': Schema.number(),
          'proteinG': Schema.number(),
          'carbsG': Schema.number(),
          'fatG': Schema.number(),
        }),
      ),
      'confidence': Schema.number(nullable: true),
      'name': Schema.string(nullable: true),
      'durationMinutes': Schema.integer(nullable: true),
      'intensity': Schema.string(nullable: true),
      'activeKcal': Schema.number(nullable: true),
      'exercises': Schema.array(
        nullable: true,
        maxItems: 50,
        items: Schema.object(properties: {
          'name': Schema.string(),
          'sets': Schema.array(
            maxItems: 100,
            items: Schema.object(properties: {
              'reps': Schema.integer(),
              'weightKg': Schema.number(nullable: true),
            }),
          ),
        }),
      ),
      'needsUserDetail': Schema.boolean(nullable: true),
      'value': Schema.integer(nullable: true),
      'hours': Schema.number(nullable: true),
      'text': Schema.string(nullable: true),
    }),
  ),
  'model': Schema.string(),
});

final _vesselSchema = Schema.object(properties: {
  'schemaVersion': Schema.integer(),
  'passages': Schema.array(
    minItems: 8,
    maxItems: 24,
    items: Schema.object(properties: {
      'key': Schema.string(),
      'title': Schema.string(),
      'reading': Schema.string(),
    }),
  ),
  'synthesis': Schema.string(),
  'model': Schema.string(),
});

final _insightsSchema = Schema.object(properties: {
  'schemaVersion': Schema.integer(),
  'insights': Schema.array(
    maxItems: 20,
    items: Schema.object(properties: {
      'key': Schema.string(),
      'phrasing': Schema.string(),
    }),
  ),
  'model': Schema.string(),
});
