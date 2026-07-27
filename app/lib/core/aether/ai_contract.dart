import 'dart:convert';

import 'guidance.dart';
import 'journal.dart';
import 'safety_policy.dart';
import 'vessel.dart';

class AetherRequest {
  const AetherRequest({
    required this.schemaVersion,
    required this.task,
    required this.context,
    required this.mode,
  });

  final int schemaVersion;
  final String task;
  final Map<String, Object?> context;
  final GuidanceMode mode;

  Map<String, Object?> toJson() => {
        'schemaVersion': schemaVersion,
        'task': task,
        'mode': mode.name,
        'context': context,
      };
}

abstract interface class AetherTransport {
  Future<Map<String, Object?>> invoke(Map<String, Object?> request);
}

class AetherProtocolException implements Exception {
  const AetherProtocolException(this.message);
  final String message;

  @override
  String toString() => 'AetherProtocolException: $message';
}

class MealItemEstimate {
  const MealItemEstimate({
    required this.name,
    required this.portion,
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final String name;
  final String portion;
  final double kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;

  factory MealItemEstimate.fromJson(Map<String, Object?> json) {
    final name = _requiredString(json, 'name');
    final portion = _requiredString(json, 'portion');
    return MealItemEstimate(
      name: name,
      portion: portion,
      kcal: _nonNegativeNumber(json, 'kcal', maximum: 5000),
      proteinG: _nonNegativeNumber(json, 'proteinG', maximum: 500),
      carbsG: _nonNegativeNumber(json, 'carbsG', maximum: 1000),
      fatG: _nonNegativeNumber(json, 'fatG', maximum: 500),
    );
  }

  Map<String, Object?> toJson() => {
        'name': name,
        'portion': portion,
        'kcal': kcal,
        'proteinG': proteinG,
        'carbsG': carbsG,
        'fatG': fatG,
      };
}

class MealEstimate {
  const MealEstimate({
    required this.items,
    required this.confidence,
    required this.assumptions,
    required this.model,
    required this.schemaVersion,
  });

  final List<MealItemEstimate> items;
  final double confidence;
  final List<String> assumptions;
  final String model;
  final int schemaVersion;

  double get kcal => items.fold<double>(0, (sum, item) => sum + item.kcal);
  double get proteinG =>
      items.fold<double>(0, (sum, item) => sum + item.proteinG);
  double get carbsG => items.fold<double>(0, (sum, item) => sum + item.carbsG);
  double get fatG => items.fold<double>(0, (sum, item) => sum + item.fatG);

  factory MealEstimate.fromJson(Map<String, Object?> json) {
    final schema = json['schemaVersion'];
    if (schema != 1) {
      throw AetherProtocolException('Unsupported meal schema: $schema');
    }
    final rawItems = json['items'];
    if (rawItems is! List || rawItems.isEmpty || rawItems.length > 30) {
      throw const AetherProtocolException('Meal requires 1–30 items');
    }
    final confidence = _number(json, 'confidence');
    if (confidence < 0 || confidence > 1) {
      throw const AetherProtocolException('Confidence must be 0–1');
    }
    final assumptions = json['assumptions'];
    if (assumptions is! List || assumptions.length > 10) {
      throw const AetherProtocolException('Invalid assumptions');
    }
    return MealEstimate(
      items: rawItems
          .map((item) => MealItemEstimate.fromJson(
                Map<String, Object?>.from(item as Map),
              ))
          .toList(growable: false),
      confidence: confidence,
      assumptions: assumptions.map((item) => item.toString()).toList(),
      model: _requiredString(json, 'model'),
      schemaVersion: schema as int,
    );
  }

  String toJson() => jsonEncode({
        'schemaVersion': schemaVersion,
        'items': items.map((item) => item.toJson()).toList(),
        'confidence': confidence,
        'assumptions': assumptions,
        'model': model,
      });
}

class AetherClient {
  const AetherClient(
    this.transport, {
    this.safetyPolicy = const AetherSafetyPolicy(),
  });
  final AetherTransport transport;
  final AetherSafetyPolicy safetyPolicy;

  Future<AetherGuidance> generateGuidance({
    required GuidanceContext context,
  }) async {
    final symbolicContext = context.mode == GuidanceMode.grounded
        ? <String, Object?>{
            if (context.symbolicContext.containsKey('lifePath'))
              'lifePath': context.symbolicContext['lifePath'],
            'sunSign': context.zodiac,
          }
        : context.symbolicContext;
    final response = await transport.invoke(
      AetherRequest(
        schemaVersion: 1,
        task: 'daily_guidance',
        context: {
          'timestamp': context.now.toUtc().toIso8601String(),
          'firstName': context.firstName,
          'activeKcal': context.activeKcal,
          'steps': context.steps,
          'sessions': context.sessions,
          'zodiac': context.zodiac,
          'lifePath': context.lifePath,
          'lifestyle': context.lifestyle,
          'symbolicContext': symbolicContext,
        },
        mode: context.mode,
      ).toJson(),
    );
    if (response['schemaVersion'] != 1) {
      throw const AetherProtocolException(
        'Unsupported guidance response schema',
      );
    }
    final rawSentences = response['sentences'];
    if (rawSentences is! List ||
        rawSentences.isEmpty ||
        rawSentences.length > 4) {
      throw const AetherProtocolException('Guidance requires 1–4 sentences');
    }
    final sentences = rawSentences.map((value) {
      if (value is! String || value.trim().isEmpty || value.length > 600) {
        throw const AetherProtocolException('Invalid guidance sentence');
      }
      return value.trim();
    }).toList(growable: false);
    final action = _requiredString(response, 'primaryAction');
    safetyPolicy.validateGuidance(
      sentences: sentences,
      primaryAction: action,
      mode: context.mode,
    );
    return AetherGuidance(
      sentences: [...sentences, action],
      generatedAt: context.now.toUtc(),
      source: _requiredString(response, 'model'),
      contextFingerprint: context.fingerprint,
    );
  }

  Future<MealEstimate> estimateMeal({
    required String description,
    required String units,
  }) async {
    final cleaned = description.trim();
    if (cleaned.length < 3 || cleaned.length > 2000) {
      throw RangeError.range(cleaned.length, 3, 2000, 'description length');
    }
    final response = await transport.invoke(
      AetherRequest(
        schemaVersion: 1,
        task: 'estimate_meal',
        mode: GuidanceMode.grounded,
        context: {
          'description': cleaned,
          'units': units,
        },
      ).toJson(),
    );
    return MealEstimate.fromJson(response);
  }

  /// The one and only Aether call allowed to receive journal prose.
  ///
  /// Guidance and insight synthesis are deliberately separate methods whose
  /// payloads are constructed from deterministic aggregates only.
  Future<JournalExtraction> classifyJournalEntry({
    required String text,
    required double weightKg,
    required String units,
    required String locale,
  }) async {
    final cleaned = text.trim();
    if (cleaned.length < 2 || cleaned.length > 5000) {
      throw RangeError.range(cleaned.length, 2, 5000, 'journal text length');
    }
    final response = await transport.invoke(
      AetherRequest(
        schemaVersion: 1,
        task: 'classify_journal_entry',
        mode: GuidanceMode.grounded,
        context: {
          'journalText': cleaned,
          'weightKg': weightKg,
          'units': units,
          'locale': locale,
        },
      ).toJson(),
    );
    return JournalExtraction.fromJson(response);
  }

  Future<VesselReading> composeVessel({
    required Map<String, Object?> natalChart,
    required Map<String, Object?> lifePathMatrix,
  }) async {
    final response = await transport.invoke(
      AetherRequest(
        schemaVersion: 1,
        task: 'compose_vessel',
        mode: GuidanceMode.immersive,
        context: {
          'natalChart': natalChart,
          'lifePathMatrix': lifePathMatrix,
        },
      ).toJson(),
    );
    return VesselReading.fromJson(response);
  }

  /// Rephrases deterministic candidates. Only the listed aggregate evidence
  /// fields cross the boundary; raw series and journal prose cannot.
  Future<List<Map<String, String>>> synthesizeInsights({
    required List<Map<String, Object?>> candidates,
  }) async {
    final sanitized = [
      for (final candidate in candidates)
        {
          'key': candidate['key'],
          'summary': candidate['summary'],
          'coefficient': candidate['coefficient'],
          'n': candidate['n'],
          'window': candidate['window'],
        },
    ];
    final response = await transport.invoke(
      AetherRequest(
        schemaVersion: 1,
        task: 'synthesize_insights',
        mode: GuidanceMode.grounded,
        context: {'candidates': sanitized},
      ).toJson(),
    );
    if (response['schemaVersion'] != 1 || response['insights'] is! List) {
      throw const AetherProtocolException('Invalid insight synthesis');
    }
    return (response['insights']! as List).map((raw) {
      final item = Map<String, Object?>.from(raw as Map);
      return {
        'key': _requiredString(item, 'key'),
        'phrasing': _requiredString(item, 'phrasing'),
      };
    }).toList(growable: false);
  }
}

class RemoteGuidanceProvider implements GuidanceProvider {
  const RemoteGuidanceProvider(this.client);
  final AetherClient client;

  @override
  Future<AetherGuidance> generate(GuidanceContext context) =>
      client.generateGuidance(context: context);
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty || value.length > 500) {
    throw AetherProtocolException('Invalid $key');
  }
  return value.trim();
}

double _number(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! num || !value.toDouble().isFinite) {
    throw AetherProtocolException('Invalid $key');
  }
  return value.toDouble();
}

double _nonNegativeNumber(
  Map<String, Object?> json,
  String key, {
  required double maximum,
}) {
  final value = _number(json, key);
  if (value < 0 || value > maximum) {
    throw AetherProtocolException('$key outside accepted range');
  }
  return value;
}
