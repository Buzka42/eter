import 'dart:convert';

import '../energy/energy.dart';

class ExerciseDefinition {
  const ExerciseDefinition(this.id, this.name, this.met);
  final String id;
  final String name;
  final double met;
}

const exerciseCatalog = [
  ExerciseDefinition('squat', 'Back Squat', 6),
  ExerciseDefinition('deadlift', 'Deadlift', 6),
  ExerciseDefinition('bench', 'Bench Press', 6),
  ExerciseDefinition('row', 'Barbell Row', 6),
  ExerciseDefinition('press', 'Overhead Press', 6),
  ExerciseDefinition('pullup', 'Pull-up', 4.5),
  ExerciseDefinition('curl', 'Biceps Curl', 3.5),
  ExerciseDefinition('leg_press', 'Leg Press', 4),
];

class StrengthSet {
  const StrengthSet({
    this.reps = 8,
    this.loadKg = 20,
    this.rpe = 7,
    this.technique = SetTechnique.normal,
    this.restAfterSec = 120,
  });

  final int reps;
  final double loadKg;
  final double rpe;
  final SetTechnique technique;
  final int restAfterSec;

  StrengthSet copyWith({
    int? reps,
    double? loadKg,
    double? rpe,
    SetTechnique? technique,
    int? restAfterSec,
  }) =>
      StrengthSet(
        reps: reps ?? this.reps,
        loadKg: loadKg ?? this.loadKg,
        rpe: rpe ?? this.rpe,
        technique: technique ?? this.technique,
        restAfterSec: restAfterSec ?? this.restAfterSec,
      );

  Map<String, Object> toJson() => {
        'reps': reps,
        'loadKg': loadKg,
        'rpe': rpe,
        'technique': technique.name,
        'restAfterSec': restAfterSec,
      };
}

class StrengthExercise {
  const StrengthExercise({
    required this.definition,
    required this.sets,
    this.supersetGroup,
  });

  final ExerciseDefinition definition;
  final List<StrengthSet> sets;
  final String? supersetGroup;

  double fallbackKcal(double weightKg) {
    var total = 0.0;
    for (final set in sets) {
      final workSeconds =
          set.reps * (3 + (set.technique == SetTechnique.eccentric ? 4 : 0));
      final activeMinutes = (workSeconds + set.restAfterSec * .35) / 60;
      final technique =
          supersetGroup == null ? set.technique : SetTechnique.superset;
      total += metKcalPerMin(met: definition.met, weightKg: weightKg) *
          activeMinutes *
          techniqueFactor(technique);
    }
    return total;
  }

  Map<String, Object?> toJson() => {
        'exerciseId': definition.id,
        'name': definition.name,
        'met': definition.met,
        'supersetGroup': supersetGroup,
        'sets': sets.map((set) => set.toJson()).toList(),
      };
}

double strengthWorkoutKcal(
  Iterable<StrengthExercise> exercises,
  double weightKg,
) =>
    applyEpoc(exercises.fold(
      0,
      (total, exercise) => total + exercise.fallbackKcal(weightKg),
    ));

String encodeExercises(Iterable<StrengthExercise> exercises) =>
    jsonEncode(exercises.map((exercise) => exercise.toJson()).toList());
