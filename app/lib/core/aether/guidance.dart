import 'dart:convert';

import 'guidance_mode.dart';

export 'guidance_mode.dart';

class GuidanceContext {
  const GuidanceContext({
    required this.now,
    required this.firstName,
    required this.activeKcal,
    required this.steps,
    required this.sessions,
    required this.zodiac,
    required this.lifePath,
    required this.mode,
    this.lifestyle = const {},
    this.symbolicContext = const {},
  });

  final DateTime now;
  final String? firstName;
  final double activeKcal;
  final int steps;
  final int sessions;
  final String zodiac;
  final int lifePath;
  final GuidanceMode mode;
  final Map<String, Object?> lifestyle;
  final Map<String, Object?> symbolicContext;

  String get fingerprint => [
        now.toLocal().toIso8601String().substring(0, 10),
        activeKcal.round(),
        steps ~/ 500,
        sessions,
        zodiac,
        lifePath,
        mode.name,
        lifestyle.toString(),
        symbolicContext.toString(),
      ].join(':');
}

class AetherGuidance {
  const AetherGuidance({
    required this.sentences,
    required this.generatedAt,
    required this.source,
    required this.contextFingerprint,
  });

  final List<String> sentences;
  final DateTime generatedAt;
  final String source;
  final String contextFingerprint;

  String toJson() => jsonEncode({
        'sentences': sentences,
        'generatedAt': generatedAt.toUtc().toIso8601String(),
        'source': source,
        'contextFingerprint': contextFingerprint,
      });

  factory AetherGuidance.fromJson(String value) {
    final json = jsonDecode(value) as Map<String, Object?>;
    final sentences = (json['sentences'] as List).cast<String>();
    if (sentences.isEmpty || sentences.length > 5) {
      throw const FormatException('Guidance must contain 1–5 sentences');
    }
    return AetherGuidance(
      sentences: sentences,
      generatedAt: DateTime.parse(json['generatedAt']! as String).toUtc(),
      source: json['source']! as String,
      contextFingerprint: json['contextFingerprint']! as String,
    );
  }
}

abstract interface class GuidanceProvider {
  Future<AetherGuidance> generate(GuidanceContext context);
}

class FallbackGuidanceProvider implements GuidanceProvider {
  const FallbackGuidanceProvider({
    required this.primary,
    this.fallback = const LocalGuidanceProvider(),
  });

  final GuidanceProvider primary;
  final GuidanceProvider fallback;

  @override
  Future<AetherGuidance> generate(GuidanceContext context) async {
    try {
      return await primary.generate(context);
    } on Object {
      return fallback.generate(context);
    }
  }
}

class LocalGuidanceProvider implements GuidanceProvider {
  const LocalGuidanceProvider();

  @override
  Future<AetherGuidance> generate(GuidanceContext context) async {
    final greeting = context.firstName == null
        ? 'Begin with what your body is showing you today.'
        : '${context.firstName}, begin with what your body is showing you today.';
    final movement = switch ((context.steps, context.activeKcal)) {
      (< 1500, < 100) =>
        'A short walk is the clearest next step; keep the effort easy enough to leave you restored.',
      (< 5000, _) =>
        'You have begun to move. Another calm stretch of walking would build the day without forcing it.',
      _ =>
        'Your movement already has substance. Protect recovery before adding more intensity.',
    };
    final symbolic = switch (context.mode) {
      GuidanceMode.grounded =>
        'Choose one useful action and make it small enough to complete.',
      GuidanceMode.balanced =>
        'Your ${context.zodiac} pattern and life path ${context.lifePath} are a lens for reflection, not a command: choose one useful action you can complete.',
      GuidanceMode.immersive =>
        'Let the ${context.zodiac} current and life path ${context.lifePath} frame the question, while the evidence from your body decides the action.',
    };
    return AetherGuidance(
      sentences: [greeting, movement, symbolic],
      generatedAt: context.now.toUtc(),
      source: 'local',
      contextFingerprint: context.fingerprint,
    );
  }
}

int calculateLifePath(DateTime dob) {
  var value = '${dob.year}${dob.month.toString().padLeft(2, '0')}'
          '${dob.day.toString().padLeft(2, '0')}'
      .split('')
      .map(int.parse)
      .fold<int>(0, (sum, digit) => sum + digit);
  while (value > 9 && value != 11 && value != 22 && value != 33) {
    value = value
        .toString()
        .split('')
        .map(int.parse)
        .fold<int>(0, (sum, digit) => sum + digit);
  }
  return value;
}
