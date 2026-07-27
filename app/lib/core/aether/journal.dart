import 'dart:convert';

import 'ai_contract.dart';

enum JournalSegmentKind {
  food,
  activity,
  strength,
  mood,
  stress,
  recovery,
  sleep,
  note,
}

sealed class JournalSegment {
  const JournalSegment(this.kind);

  final JournalSegmentKind kind;

  Map<String, Object?> toJson();

  static JournalSegment fromJson(Map<String, Object?> json) {
    final rawKind = json['kind'];
    final kind = JournalSegmentKind.values
        .where((value) => value.name == rawKind)
        .firstOrNull;
    if (kind == null) {
      throw AetherProtocolException('Unsupported journal segment: $rawKind');
    }
    return switch (kind) {
      JournalSegmentKind.food => FoodJournalSegment.fromJson(json),
      JournalSegmentKind.activity => ActivityJournalSegment.fromJson(json),
      JournalSegmentKind.strength => StrengthJournalSegment.fromJson(json),
      JournalSegmentKind.mood ||
      JournalSegmentKind.stress ||
      JournalSegmentKind.recovery =>
        RatingJournalSegment.fromJson(kind, json),
      JournalSegmentKind.sleep => SleepJournalSegment.fromJson(json),
      JournalSegmentKind.note => NoteJournalSegment.fromJson(json),
    };
  }
}

class FoodJournalSegment extends JournalSegment {
  const FoodJournalSegment({
    required this.items,
    required this.confidence,
  }) : super(JournalSegmentKind.food);

  final List<MealItemEstimate> items;
  final double confidence;

  factory FoodJournalSegment.fromJson(Map<String, Object?> json) {
    final rawItems = json['items'];
    if (rawItems is! List || rawItems.isEmpty || rawItems.length > 30) {
      throw const AetherProtocolException('Food requires 1–30 items');
    }
    final confidence = journalNumber(json, 'confidence');
    if (confidence < 0 || confidence > 1) {
      throw const AetherProtocolException('Confidence must be 0–1');
    }
    return FoodJournalSegment(
      items: rawItems
          .map((item) => MealItemEstimate.fromJson(
                Map<String, Object?>.from(item as Map),
              ))
          .toList(growable: false),
      confidence: confidence,
    );
  }

  @override
  Map<String, Object?> toJson() => {
        'kind': kind.name,
        'items': items.map((item) => item.toJson()).toList(),
        'confidence': confidence,
      };
}

class ActivityJournalSegment extends JournalSegment {
  const ActivityJournalSegment({
    required this.name,
    required this.durationMinutes,
    required this.intensity,
    required this.activeKcal,
    required this.confidence,
  }) : super(JournalSegmentKind.activity);

  final String name;
  final int durationMinutes;
  final String intensity;
  final double activeKcal;
  final double confidence;

  factory ActivityJournalSegment.fromJson(Map<String, Object?> json) {
    final duration = journalInteger(json, 'durationMinutes', min: 1, max: 1440);
    final kcal = journalNumber(json, 'activeKcal');
    final confidence = journalNumber(json, 'confidence');
    if (kcal < 0 || kcal > 10000 || confidence < 0 || confidence > 1) {
      throw const AetherProtocolException('Invalid activity estimate');
    }
    return ActivityJournalSegment(
      name: journalString(json, 'name'),
      durationMinutes: duration,
      intensity: journalString(json, 'intensity'),
      activeKcal: kcal,
      confidence: confidence,
    );
  }

  @override
  Map<String, Object?> toJson() => {
        'kind': kind.name,
        'name': name,
        'durationMinutes': durationMinutes,
        'intensity': intensity,
        'activeKcal': activeKcal,
        'confidence': confidence,
      };
}

class StrengthSetEstimate {
  const StrengthSetEstimate({required this.reps, this.weightKg});

  final int reps;
  final double? weightKg;

  factory StrengthSetEstimate.fromJson(Map<String, Object?> json) {
    final weight = json['weightKg'];
    if (weight != null && (weight is! num || weight < 0 || weight > 1000)) {
      throw const AetherProtocolException('Invalid strength weight');
    }
    return StrengthSetEstimate(
      reps: journalInteger(json, 'reps', min: 1, max: 1000),
      weightKg: (weight as num?)?.toDouble(),
    );
  }

  Map<String, Object?> toJson() => {'reps': reps, 'weightKg': weightKg};
}

class StrengthExerciseEstimate {
  const StrengthExerciseEstimate({required this.name, required this.sets});

  final String name;
  final List<StrengthSetEstimate> sets;

  factory StrengthExerciseEstimate.fromJson(Map<String, Object?> json) {
    final rawSets = json['sets'];
    if (rawSets is! List || rawSets.length > 100) {
      throw const AetherProtocolException('Invalid strength sets');
    }
    return StrengthExerciseEstimate(
      name: journalString(json, 'name'),
      sets: rawSets
          .map((set) => StrengthSetEstimate.fromJson(
                Map<String, Object?>.from(set as Map),
              ))
          .toList(growable: false),
    );
  }

  Map<String, Object?> toJson() => {
        'name': name,
        'sets': sets.map((set) => set.toJson()).toList(),
      };
}

class StrengthJournalSegment extends JournalSegment {
  const StrengthJournalSegment({
    required this.exercises,
    required this.needsUserDetail,
  }) : super(JournalSegmentKind.strength);

  final List<StrengthExerciseEstimate> exercises;
  final bool needsUserDetail;

  factory StrengthJournalSegment.fromJson(Map<String, Object?> json) {
    final raw = json['exercises'];
    if (raw is! List || raw.isEmpty || raw.length > 50) {
      throw const AetherProtocolException(
        'Strength requires 1–50 exercises',
      );
    }
    final needsDetail = json['needsUserDetail'];
    if (needsDetail is! bool) {
      throw const AetherProtocolException('Invalid needsUserDetail');
    }
    return StrengthJournalSegment(
      exercises: raw
          .map((exercise) => StrengthExerciseEstimate.fromJson(
                Map<String, Object?>.from(exercise as Map),
              ))
          .toList(growable: false),
      needsUserDetail: needsDetail,
    );
  }

  @override
  Map<String, Object?> toJson() => {
        'kind': kind.name,
        'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
        'needsUserDetail': needsUserDetail,
      };
}

class RatingJournalSegment extends JournalSegment {
  const RatingJournalSegment(super.kind, {required this.value});

  final int value;

  factory RatingJournalSegment.fromJson(
    JournalSegmentKind kind,
    Map<String, Object?> json,
  ) =>
      RatingJournalSegment(
        kind,
        value: journalInteger(json, 'value', min: 1, max: 5),
      );

  @override
  Map<String, Object?> toJson() => {'kind': kind.name, 'value': value};
}

class SleepJournalSegment extends JournalSegment {
  const SleepJournalSegment({required this.hours})
      : super(JournalSegmentKind.sleep);

  final double hours;

  factory SleepJournalSegment.fromJson(Map<String, Object?> json) {
    final hours = journalNumber(json, 'hours');
    if (hours <= 0 || hours > 24) {
      throw const AetherProtocolException('Sleep must be within 0–24 hours');
    }
    return SleepJournalSegment(hours: hours);
  }

  @override
  Map<String, Object?> toJson() => {'kind': kind.name, 'hours': hours};
}

class NoteJournalSegment extends JournalSegment {
  const NoteJournalSegment({required this.text})
      : super(JournalSegmentKind.note);

  final String text;

  factory NoteJournalSegment.fromJson(Map<String, Object?> json) =>
      NoteJournalSegment(text: journalString(json, 'text', maximum: 2000));

  @override
  Map<String, Object?> toJson() => {'kind': kind.name, 'text': text};
}

class JournalExtraction {
  const JournalExtraction({
    required this.segments,
    required this.model,
    required this.schemaVersion,
  });

  final List<JournalSegment> segments;
  final String model;
  final int schemaVersion;

  bool get needsUserDetail => segments
      .whereType<StrengthJournalSegment>()
      .any((segment) => segment.needsUserDetail);

  factory JournalExtraction.fromJson(Map<String, Object?> json) {
    if (json['schemaVersion'] != 1) {
      throw const AetherProtocolException(
        'Unsupported journal response schema',
      );
    }
    final rawSegments = json['segments'];
    if (rawSegments is! List ||
        rawSegments.isEmpty ||
        rawSegments.length > 30) {
      throw const AetherProtocolException(
        'Journal extraction requires 1–30 segments',
      );
    }
    return JournalExtraction(
      segments: rawSegments
          .map((segment) => JournalSegment.fromJson(
                Map<String, Object?>.from(segment as Map),
              ))
          .toList(growable: false),
      model: journalString(json, 'model'),
      schemaVersion: 1,
    );
  }

  Map<String, Object?> toJsonMap() => {
        'schemaVersion': schemaVersion,
        'segments': segments.map((segment) => segment.toJson()).toList(),
        'model': model,
      };

  String encode() => jsonEncode(toJsonMap());
}

String journalString(
  Map<String, Object?> json,
  String key, {
  int maximum = 500,
}) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty || value.length > maximum) {
    throw AetherProtocolException('Invalid $key');
  }
  return value.trim();
}

double journalNumber(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! num || !value.toDouble().isFinite) {
    throw AetherProtocolException('Invalid $key');
  }
  return value.toDouble();
}

int journalInteger(
  Map<String, Object?> json,
  String key, {
  required int min,
  required int max,
}) {
  final value = json[key];
  if (value is! int || value < min || value > max) {
    throw AetherProtocolException('Invalid $key');
  }
  return value;
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
