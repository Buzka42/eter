import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../core/aether/ai_contract.dart';
import '../../core/aether/journal.dart';
import '../../core/aether/journal_service.dart';
import '../../core/controls.dart';
import '../../core/profile.dart';
import '../../core/tokens.dart';
import '../log/strength_workout_screen.dart';

final aetherClientProvider = Provider<AetherClient?>((_) => null);

class JournalComposer extends ConsumerStatefulWidget {
  const JournalComposer({
    super.key,
    this.initiallyExpanded = false,
    this.initialText = '',
    this.initialMessage,
    this.initialExtraction,
  });

  final bool initiallyExpanded;
  final String initialText;
  final String? initialMessage;

  /// Seeds the post-submit reading, so the atlas can capture the state the
  /// user sees after an entry is classified.
  final JournalExtraction? initialExtraction;

  @override
  ConsumerState<JournalComposer> createState() => _JournalComposerState();
}

class _JournalComposerState extends ConsumerState<JournalComposer> {
  late final TextEditingController _controller;
  final _speech = SpeechToText();
  late bool _expanded;
  bool _saving = false;
  bool _listening = false;
  bool _spokenDraft = false;
  bool _showPrivacy = false;
  String? _message;

  /// What the classifier understood from the last entry. Held so the Log can
  /// show its working (Q6) instead of asking the user to trust "Entry
  /// classified".
  JournalExtraction? _extraction;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _expanded = widget.initiallyExpanded;
    _message = widget.initialMessage;
    _extraction = widget.initialExtraction;
  }

  @override
  void dispose() {
    _speech.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_listening) {
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }
    final available = await _speech.initialize();
    if (!available || !mounted) {
      setState(() => _message = 'Voice transcription is unavailable.');
      return;
    }
    setState(() {
      _listening = true;
      _spokenDraft = true;
      _message = 'Listening on this device…';
    });
    await _speech.listen(
      onResult: (result) {
        _controller.text = result.recognizedWords;
        _controller.selection = TextSelection.collapsed(
          offset: _controller.text.length,
        );
        if (result.finalResult && mounted) {
          setState(() {
            _listening = false;
            _message = 'Transcript ready to edit.';
          });
        }
      },
    );
  }

  Future<void> _save() async {
    final profile = ref.read(profileProvider);
    final client = ref.read(aetherClientProvider);
    final text = _controller.text.trim();
    if (profile == null || text.length < 2 || _saving) return;
    if (client == null) {
      setState(() => _message =
          'A configured connection is needed to classify this entry.');
      return;
    }
    setState(() {
      _saving = true;
      _message = 'Aether is reading the entry once…';
      _extraction = null;
    });
    try {
      final result = await JournalService(
        database: ref.read(databaseProvider),
        client: client,
      ).saveAndClassify(
        text: text,
        profile: profile,
        source: _spokenDraft ? 'spoken' : 'typed',
        locale: Localizations.localeOf(context).toLanguageTag(),
      );
      if (!mounted) return;
      _controller.clear();
      _spokenDraft = false;
      final strength = result.extraction.segments
          .whereType<StrengthJournalSegment>()
          .firstOrNull;
      setState(() {
        _saving = false;
        _extraction = result.extraction;
        // The receipt below now says what was added, so the confirmation only
        // has to say that something was.
        _message = strength?.needsUserDetail == true
            ? 'Added to today. Complete the strength sets.'
            : 'Added to today.';
      });
      if (strength?.needsUserDetail == true) {
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) => FractionallySizedBox(
            heightFactor: .92,
            child: StrengthWorkoutScreen(
              initialExerciseNames:
                  strength!.exercises.map((item) => item.name).toList(),
            ),
          ),
        );
      }
    } on Object {
      if (mounted) {
        setState(() {
          _saving = false;
          _message =
              'Saved locally, but classification failed. Retry is available.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(EterSpace.s12),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: EterSpace.s8),
            child: Row(
              children: [
                Expanded(child: Text('THE LOG', style: textTheme.labelSmall)),
                // The privacy note is reassurance, and permanent reassurance
                // is noise (C7) — it now sits behind this affordance.
                IconButton(
                  tooltip: 'How this entry is handled',
                  visualDensity: VisualDensity.compact,
                  onPressed: () =>
                      setState(() => _showPrivacy = !_showPrivacy),
                  icon: const Icon(Icons.info_outline, size: 18),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          alignment: Alignment.topCenter,
          child: !_expanded
              // Collapsed, the Log was a header over an empty screen and
              // nothing told a first-time user that the app's primary verb
              // lived here (§5.6). The example doubles as the invitation and
              // as the only clue to what the field understands.
              ? InkWell(
                  onTap: () => setState(() => _expanded = true),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 48),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(bottom: EterSpace.s8),
                    child: Text(
                      'I had oats, walked for half an hour, and felt…',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: EterInk.of(context).labelMuted),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: EterSpace.s12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _controller,
                        minLines: 3,
                        maxLines: 8,
                        maxLength: 5000,
                        textCapitalization: TextCapitalization.sentences,
                        // No labelText: it floated above the field and hid the
                        // example behind it (§5.6). The example is the only
                        // thing that tells a first-time user what the field
                        // understands, so it stays visible as ghost text.
                        decoration: const InputDecoration(
                          hintText:
                              'I had oats, walked for half an hour, and felt…',
                        ),
                      ),
                      Row(
                        children: [
                          // A bare mic glyph gave no label and a small target
                          // (§5.6). As an EterAction it carries a word and the
                          // system's 52 px hit box.
                          EterAction(
                            label: _listening ? 'Stop' : 'Dictate',
                            emphasis: EterActionEmphasis.quiet,
                            icon: _listening ? Icons.stop : Icons.mic_none,
                            onPressed: _saving ? null : _toggleListening,
                          ),
                          const Spacer(),
                          EterAction(
                            label: _saving ? 'Reading…' : 'Add to today',
                            onPressed: _saving ? null : _save,
                          ),
                        ],
                      ),
                      // A confirmation is a *response*, not a label, so it
                      // arrives in the meaning-carrying ink and animates in —
                      // otherwise it reads as boilerplate (C7).
                      AnimatedSwitcher(
                        duration: EterMotion.durStandard,
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SizeTransition(
                            sizeFactor: animation,
                            alignment: Alignment.topCenter,
                            child: child,
                          ),
                        ),
                        child: _message == null
                            ? const SizedBox.shrink()
                            : Padding(
                                key: ValueKey(_message),
                                padding:
                                    const EdgeInsets.only(top: EterSpace.s8),
                                child: Text(
                                  _message!,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: EterInk.of(context).lineStrong,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      ),
                      if (_extraction != null)
                        _ExtractionReading(_extraction!),
                      if (_showPrivacy) ...[
                        const SizedBox(height: EterSpace.s8),
                        Text(
                          'Audio stays on this device. Prose is sent once for '
                          'extraction; later guidance sees totals only.',
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

/// One understood item: what it was, and what it counted for.
@immutable
class _ReadingLine {
  const _ReadingLine(this.label, this.value);
  final String label;
  final String value;
}

/// The Log showing its working (§5.6 Tier 2, Q6). "Entry classified and added
/// to today" asked the user to trust an unseen classifier with their day's
/// numbers; this lists what it actually understood, so a wrong reading is
/// visible at the moment it is made rather than discovered later in the totals.
class _ExtractionReading extends StatelessWidget {
  const _ExtractionReading(this.extraction);

  final JournalExtraction extraction;

  static String _kcal(double value) => '${value.round()} kcal';

  List<_ReadingLine> _lines() {
    final lines = <_ReadingLine>[];
    for (final segment in extraction.segments) {
      switch (segment) {
        case FoodJournalSegment(:final items):
          for (final item in items) {
            lines.add(_ReadingLine(
              item.portion.isEmpty
                  ? item.name
                  : '${item.name} · ${item.portion}',
              _kcal(item.kcal),
            ));
          }
        case ActivityJournalSegment(
            :final name,
            :final durationMinutes,
            :final activeKcal
          ):
          lines.add(_ReadingLine(
            '$name · $durationMinutes min',
            _kcal(activeKcal),
          ));
        case StrengthJournalSegment(:final exercises, :final needsUserDetail):
          lines.add(_ReadingLine(
            exercises.map((exercise) => exercise.name).join(', '),
            needsUserDetail ? 'sets needed' : 'strength',
          ));
        case SleepJournalSegment(:final hours):
          lines.add(_ReadingLine('Sleep', '${_trim(hours)} h'));
        case RatingJournalSegment(:final kind, :final value):
          lines.add(_ReadingLine(_titleCase(kind.name), '$value/5'));
        // A note carries no quantity, so it changes nothing to check.
        case NoteJournalSegment():
          break;
      }
    }
    return lines;
  }

  static String _trim(double value) => value == value.roundToDouble()
      ? '${value.round()}'
      : value.toStringAsFixed(1);

  static String _titleCase(String value) =>
      value[0].toUpperCase() + value.substring(1);

  @override
  Widget build(BuildContext context) {
    final lines = _lines();
    if (lines.isEmpty) return const SizedBox.shrink();
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: EterSpace.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EterRule(label: 'Read as'),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(top: EterSpace.s8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(child: Text(line.label, style: text.bodyMedium)),
                  const SizedBox(width: EterSpace.s12),
                  Text(line.value, style: text.titleSmall),
                ],
              ),
            ),
          // Deliberately no "correct this" line: there is currently no edit or
          // delete path for a nutrition or activity row anywhere in the app,
          // and copy that offers one it cannot honour is worse than silence.
          // Making the reading *visible* is the half of Q6 that can ship
          // today; making it correctable needs a real edit path first.
        ],
      ),
    );
  }
}
