import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/activity/manual_activity_service.dart';
import '../../core/controls.dart';
import '../../core/db/app_database.dart';
import '../../core/energy/energy.dart';
import '../../core/profile.dart';
import '../../core/strength/strength_workout.dart';
import '../../core/theme.dart';
import '../../core/tokens.dart';
import '../../core/widgets.dart';

class StrengthWorkoutScreen extends ConsumerStatefulWidget {
  const StrengthWorkoutScreen({
    super.key,
    this.initialExerciseNames = const [],
  });

  final List<String> initialExerciseNames;

  @override
  ConsumerState<StrengthWorkoutScreen> createState() =>
      _StrengthWorkoutScreenState();
}

class _StrengthWorkoutScreenState extends ConsumerState<StrengthWorkoutScreen> {
  final _startedAt = DateTime.now();
  final List<StrengthExercise> _exercises = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    for (final name in widget.initialExerciseNames) {
      final matches = exerciseCatalog.where(
        (item) =>
            item.name.toLowerCase() == name.toLowerCase() ||
            item.id.toLowerCase() == name.toLowerCase(),
      );
      if (matches.isNotEmpty) {
        _exercises.add(
          StrengthExercise(
            definition: matches.first,
            sets: const [StrengthSet()],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider)!;
    final estimate = strengthWorkoutKcal(_exercises, profile.weightKg);
    return SkyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Strength workout'),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(
              EterSpace.gutter, EterSpace.s16, EterSpace.gutter, EterSpace.s64),
          children: [
            for (var i = 0; i < _exercises.length; i++) ...[
              _ExerciseCard(
                exercise: _exercises[i],
                onChanged: (value) => setState(() => _exercises[i] = value),
                onDelete: () => setState(() => _exercises.removeAt(i)),
              ),
              const SizedBox(height: EterSpace.s12),
            ],
            EterAction(
              label: 'Add exercise',
              onPressed: _addExercise,
              icon: Icons.add,
            ),
            const SizedBox(height: EterSpace.s16),
            EterPlate(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.auto_awesome),
                title: const Text('Quick estimate'),
                subtitle: const Text('Local MET estimate including EPOC'),
                trailing: Text('${estimate.round()} kcal'),
              ),
            ),
            const SizedBox(height: EterSpace.s24),
            EterAction(
              label: _saving ? 'Saving…' : 'Finish workout',
              emphasis: EterActionEmphasis.primary,
              busy: _saving,
              onPressed:
                  _saving || _exercises.isEmpty ? null : () => _finish(profile),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addExercise() async {
    final definition = await showModalBottomSheet<ExerciseDefinition>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          children: [
            for (final item in exerciseCatalog)
              ListTile(
                title: Text(item.name),
                subtitle: Text('${item.met} MET'),
                onTap: () => Navigator.pop(context, item),
              ),
          ],
        ),
      ),
    );
    if (definition == null) return;
    setState(() => _exercises.add(StrengthExercise(
          definition: definition,
          sets: const [StrengthSet()],
        )));
  }

  Future<void> _finish(Profile profile) async {
    setState(() => _saving = true);
    final endedAt = DateTime.now();
    final estimate = strengthWorkoutKcal(_exercises, profile.weightKg);
    final minutes = endedAt.difference(_startedAt).inMinutes.clamp(1, 240);
    final id = 'strength-${_startedAt.microsecondsSinceEpoch}';
    await ref.read(databaseProvider).saveStrengthWorkout(
          StrengthWorkoutsCompanion.insert(
            id: id,
            startedAt: _startedAt,
            endedAt: endedAt,
            bodyWeightKgAtTime: profile.weightKg,
            exercisesJson: encodeExercises(_exercises),
            fallbackKcal: estimate,
            finalKcal: estimate,
            method: const Value('fallback'),
          ),
        );
    await ManualActivityService(ref.read(databaseProvider)).log(
      name: id,
      durationMinutes: minutes,
      activeKcal: estimate,
      endedAt: endedAt,
    );
    if (mounted) Navigator.pop(context);
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.exercise,
    required this.onChanged,
    required this.onDelete,
  });
  final StrengthExercise exercise;
  final ValueChanged<StrengthExercise> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => EterPlate(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(exercise.definition.name,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline)),
              ],
            ),
            for (var i = 0; i < exercise.sets.length; i++)
              _SetRow(
                set: exercise.sets[i],
                index: i,
                onChanged: (set) {
                  final sets = [...exercise.sets]..[i] = set;
                  onChanged(StrengthExercise(
                    definition: exercise.definition,
                    sets: sets,
                    supersetGroup: exercise.supersetGroup,
                  ));
                },
              ),
            TextButton.icon(
              onPressed: () {
                final sets = [...exercise.sets, exercise.sets.last];
                onChanged(StrengthExercise(
                  definition: exercise.definition,
                  sets: sets,
                  supersetGroup: exercise.supersetGroup,
                ));
              },
              icon: const Icon(Icons.add),
              label: const Text('Add set'),
            ),
          ],
        ),
      );
}

class _SetRow extends StatelessWidget {
  const _SetRow(
      {required this.set, required this.index, required this.onChanged});
  final StrengthSet set;
  final int index;
  final ValueChanged<StrengthSet> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: EterSpace.s4),
        child: Row(
          children: [
            Text('${index + 1}'),
            IconButton(
              onPressed: () =>
                  onChanged(set.copyWith(reps: (set.reps - 1).clamp(1, 100))),
              icon: const Icon(Icons.remove),
            ),
            Text('${set.reps} reps'),
            IconButton(
              onPressed: () => onChanged(set.copyWith(reps: set.reps + 1)),
              icon: const Icon(Icons.add),
            ),
            const Spacer(),
            DropdownButton<SetTechnique>(
              value: set.technique,
              items: [
                for (final value in SetTechnique.values)
                  DropdownMenuItem(
                    value: value,
                    child: Text(value.name),
                  ),
              ],
              onChanged: (value) => onChanged(set.copyWith(technique: value)),
            ),
          ],
        ),
      );
}