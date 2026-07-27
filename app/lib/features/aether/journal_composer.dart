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
  });

  final bool initiallyExpanded;
  final String initialText;
  final String? initialMessage;

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
  String? _message;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _expanded = widget.initiallyExpanded;
    _message = widget.initialMessage;
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
        _message = strength?.needsUserDetail == true
            ? 'Other details saved. Complete the strength sets.'
            : 'Entry classified and added to today.';
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: EterSpace.s8),
            child: Row(
              children: [
                Expanded(child: Text('THE LOG', style: textTheme.labelSmall)),
                Icon(_expanded ? Icons.remove : Icons.add, size: 18),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          alignment: Alignment.topCenter,
          child: !_expanded
              ? const SizedBox.shrink()
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
                        decoration: const InputDecoration(
                          hintText:
                              'I had oats, walked for half an hour, and felt…',
                          labelText: 'Write naturally',
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            tooltip: _listening
                                ? 'Stop transcription'
                                : 'Transcribe on device',
                            onPressed: _saving ? null : _toggleListening,
                            icon: Icon(
                              _listening ? Icons.stop : Icons.mic_none,
                            ),
                          ),
                          const Spacer(),
                          EterAction(
                            label: _saving ? 'Reading…' : 'Add to today',
                            onPressed: _saving ? null : _save,
                          ),
                        ],
                      ),
                      if (_message != null) ...[
                        const SizedBox(height: EterSpace.s8),
                        Text(_message!, style: textTheme.bodySmall),
                      ],
                      const SizedBox(height: EterSpace.s8),
                      Text(
                        'Audio stays on this device. Prose is sent once for '
                        'extraction; later guidance sees totals only.',
                        style: textTheme.bodySmall,
                      ),
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
