import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/controls.dart';
import '../../core/aether/guidance.dart';
import '../../core/aether/guidance_service.dart';
import '../../core/aether/lifestyle.dart';
import '../../core/aether/pattern_engine.dart';
import '../../core/arcana/animated_arcana_card.dart';
import '../../core/arcana/zodiac.dart';
import '../../core/arcana/zodiac.dart' as zodiac show Element;
import '../../core/clock.dart';
import '../../core/db/app_database.dart';
import '../../core/energy/energy.dart';
import '../../core/profile.dart';
import '../../core/register.dart';
import '../../core/symbolic/natal_chart.dart';
import '../../core/theme.dart';
import '../../core/tokens.dart';
import '../../core/widgets.dart';
import '../home/home_providers.dart';
import '../live/live_screen.dart';
import 'journal_composer.dart';
import 'main_sections.dart';
import 'vessel_section.dart';

final guidanceServiceProvider = Provider(
  (ref) => GuidanceService(
    database: ref.watch(databaseProvider),
    provider: ref.watch(aetherGuidanceProvider),
  ),
);

final aetherGuidanceProvider = Provider<GuidanceProvider>(
  (_) => const LocalGuidanceProvider(),
);

final currentGuidanceProvider = FutureProvider<AetherGuidance>((ref) async {
  final profile = ref.watch(profileProvider);
  final day = ref.watch(dayStateProvider).value ?? DayState.initial;
  if (profile == null) throw StateError('A profile is required for guidance');
  final lifestyle = await LifestyleService(ref.watch(databaseProvider))
      .summarizeRecent(now: DateTime.now());
  final patternEngine = PatternEngine(ref.watch(databaseProvider));
  await patternEngine.recompute(now: DateTime.now());
  final patterns =
      await ref.watch(databaseProvider).loadActivePatternCandidates();
  final symbolicContext = <String, Object?>{
    'lifePath': calculateLifePath(profile.dob),
  };
  if (profile.hasCompleteBirthChartInput) {
    final birthMinutes = profile.birthTimeMinutes!;
    final chart = NatalChartEngine().calculate(
      NatalInput(
        localDateTime: DateTime(
          profile.dob.year,
          profile.dob.month,
          profile.dob.day,
          birthMinutes ~/ 60,
          birthMinutes % 60,
        ),
        utcOffsetMinutes: profile.birthUtcOffsetMinutes!,
        latitude: profile.birthLatitude!,
        longitude: profile.birthLongitude!,
      ),
    );
    symbolicContext['natalChart'] = chart.toGuidanceSummary();
  }
  final context = GuidanceContext(
    now: DateTime.now(),
    firstName: profile.firstName,
    activeKcal: day.activeKcal,
    steps: day.steps,
    sessions: day.sessions,
    zodiac: profile.zodiac.name,
    lifePath: calculateLifePath(profile.dob),
    mode: profile.guidanceMode,
    symbolicContext: symbolicContext,
    lifestyle: {
      ...lifestyle.toJson(),
      'patterns': [
        for (final pattern in patterns)
          {
            'summary': pattern.summary,
            'confidence': pattern.confidence,
            'evidence': patternEvidence(pattern),
          },
      ],
    },
  );
  return ref.watch(guidanceServiceProvider).guidanceForOpen(context);
});

/// Energy consumed today, summed from confirmed nutrition entries.
final _intakeTodayProvider = StreamProvider<double>((ref) {
  final database = ref.watch(databaseProvider);
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  return database
      .watchNutritionEntries(start, start.add(const Duration(days: 1)))
      .map((rows) => rows.fold<double>(0, (sum, row) => sum + row.kcal));
});

final _activePatternsProvider = FutureProvider(
  (ref) => ref.watch(databaseProvider).loadActivePatternCandidates(),
);

/// The cinematic guidance moment. A single calm surface: the day's guidance
/// revealed sentence by sentence, with the instrument dashboard unfolding
/// below for those who want to investigate. Grounded mode strips ornament
/// and motion down to a plain reading.
class AetherScreen extends ConsumerWidget {
  const AetherScreen({super.key, required this.onOpenFeatures});

  final VoidCallback onOpenFeatures;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guidance = ref.watch(currentGuidanceProvider);
    final profile = ref.watch(profileProvider);
    final mode = profile?.guidanceMode ?? GuidanceMode.immersive;
    return SkyBackground(
      child: SafeArea(
        bottom: false,
        child: guidance.when(
          loading: () =>
              _GuidanceLoading(mystical: mode != GuidanceMode.grounded),
          error: (_, __) => _GuidanceExperience(
            guidance: AetherGuidance(
              sentences: const [
                'Begin with the body: breathe, drink some water, and choose one manageable action.',
                'Your records remain available even while Aether is offline.',
              ],
              generatedAt: DateTime.now(),
              source: 'emergency-local',
              contextFingerprint: 'emergency',
            ),
            mode: mode,
            onCheckIn: () => _openCheckIn(context, ref),
            onOpenFeatures: onOpenFeatures,
          ),
          data: (value) => _GuidanceExperience(
            guidance: value,
            mode: mode,
            onCheckIn: () => _openCheckIn(context, ref),
            onOpenFeatures: onOpenFeatures,
          ),
        ),
      ),
    );
  }

  Future<void> _openCheckIn(BuildContext context, WidgetRef ref) async {
    var mood = 3.0;
    var stress = 3.0;
    var recovery = 3.0;
    final reflection = TextEditingController();
    final save = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            EterSpace.gutter,
            EterSpace.s24,
            EterSpace.gutter,
            MediaQuery.viewInsetsOf(context).bottom + EterSpace.s24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('A brief check-in',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: EterSpace.s16),
              _RatingRow(
                label: 'Mood',
                value: mood,
                onChanged: (value) => setSheetState(() => mood = value),
              ),
              _RatingRow(
                label: 'Stress',
                value: stress,
                onChanged: (value) => setSheetState(() => stress = value),
              ),
              _RatingRow(
                label: 'Recovery',
                value: recovery,
                onChanged: (value) => setSheetState(() => recovery = value),
              ),
              TextField(
                controller: reflection,
                minLines: 2,
                maxLines: 5,
                maxLength: 4000,
                decoration: const InputDecoration(
                  labelText: 'What is most present today? (optional)',
                ),
              ),
              const SizedBox(height: EterSpace.s16),
              EterAction(
                label: 'Save check-in',
                emphasis: EterActionEmphasis.primary,
                expand: true,
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ),
      ),
    );
    try {
      if (save != true) return;
      final service = LifestyleService(ref.read(databaseProvider));
      final now = DateTime.now();
      await Future.wait([
        service.recordRating(LifestyleKind.mood, mood, at: now),
        service.recordRating(LifestyleKind.stress, stress, at: now),
        service.recordRating(LifestyleKind.recovery, recovery, at: now),
        if (reflection.text.trim().isNotEmpty)
          service.recordReflection(reflection.text, at: now),
      ]);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check-in saved for Aether’s next guidance.'),
        ),
      );
    } finally {
      reflection.dispose();
    }
  }
}

class _GuidanceLoading extends StatefulWidget {
  const _GuidanceLoading({required this.mystical});

  final bool mystical;

  @override
  State<_GuidanceLoading> createState() => _GuidanceLoadingState();
}

class _GuidanceLoadingState extends State<_GuidanceLoading>
    with SingleTickerProviderStateMixin {
  AnimationController? _pulse;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animate = widget.mystical &&
        !MediaQuery.disableAnimationsOf(context) &&
        !eterRunningTests();
    if (animate && _pulse == null) {
      _pulse = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1600),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final pulse = _pulse;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.mystical)
            pulse == null
                ? const StarOrnament(size: 22)
                : FadeTransition(
                    opacity: Tween(begin: 0.35, end: 1.0).animate(
                      CurvedAnimation(parent: pulse, curve: EterMotion.easeAir),
                    ),
                    child: const StarOrnament(size: 22),
                  ),
          const SizedBox(height: EterSpace.s24),
          Text(
            widget.mystical
                ? 'Aether is listening…'
                : 'Preparing your guidance…',
            style: text.headlineSmall?.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

/// The full guidance experience: the moment itself, then the instruments.
class _GuidanceExperience extends StatefulWidget {
  const _GuidanceExperience({
    required this.guidance,
    required this.mode,
    required this.onCheckIn,
    required this.onOpenFeatures,
  });

  final AetherGuidance guidance;
  final GuidanceMode mode;
  final VoidCallback onCheckIn;
  final VoidCallback onOpenFeatures;

  @override
  State<_GuidanceExperience> createState() => _GuidanceExperienceState();
}

/// The movements of the single scroll, in order. The rail is a chapter index
/// for them (§5.3): one hairline tick and one letterspaced initial each.
enum _Movement {
  opening('A', 'The opening'),
  pulse('P', 'The Pulse'),
  log('L', 'The Log'),
  day('D', 'The day in numbers'),
  vessel('V', 'The Vessel');

  const _Movement(this.initial, this.label);
  final String initial;
  final String label;
}

class _GuidanceExperienceState extends State<_GuidanceExperience> {
  final _scroll = ScrollController();
  final _movementKeys = {
    for (final movement in _Movement.values) movement: GlobalKey(),
  };
  Timer? _timer;
  int _visible = 0;

  bool get _mystical => widget.mode != GuidanceMode.grounded;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reveal = widget.mode == GuidanceMode.immersive &&
        !MediaQuery.disableAnimationsOf(context);
    if (!reveal) {
      _showAll();
    } else if (_timer == null && _visible == 0) {
      _timer = Timer.periodic(EterMotion.durSentence, (timer) {
        if (!mounted) return;
        setState(() => _visible++);
        if (_visible >= widget.guidance.sentences.length) timer.cancel();
      });
    }
  }

  void _showAll() {
    _timer?.cancel();
    _timer = null;
    if (_visible != widget.guidance.sentences.length && mounted) {
      setState(() => _visible = widget.guidance.sentences.length);
    } else {
      _visible = widget.guidance.sentences.length;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          SingleChildScrollView(
            controller: _scroll,
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  key: _movementKeys[_Movement.opening],
                  height: constraints.maxHeight,
                  child: _GuidanceMoment(
                    guidance: widget.guidance,
                    visible: _visible,
                    mystical: _mystical,
                    onReveal: () => setState(_showAll),
                    onOpenFeatures: widget.onOpenFeatures,
                    onDescend: () => _scroll.animateTo(
                      constraints.maxHeight,
                      duration: EterMotion.durReveal,
                      curve: EterMotion.easeAir,
                    ),
                  ),
                ),
                _Dashboard(
                  mode: widget.mode,
                  onCheckIn: widget.onCheckIn,
                  onOpenFeatures: widget.onOpenFeatures,
                  movementKeys: _movementKeys,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: _SectionRail(
              scroll: _scroll,
              keys: _movementKeys,
              movements: [
                for (final movement in _Movement.values)
                  if (movement != _Movement.vessel || _mystical) movement,
              ],
              onJump: _jumpTo,
            ),
          ),
        ],
      ),
    );
  }

  /// Scrolls a movement to the top of the viewport. The offsets are read from
  /// the live render tree rather than tracked, so they stay correct as
  /// sections change height (the Log expands, the Timeline unfolds).
  void _jumpTo(_Movement movement) {
    final context = _movementKeys[movement]?.currentContext;
    if (context == null) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final target = _scroll.offset +
        box.localToGlobal(Offset.zero).dy -
        MediaQuery.paddingOf(this.context).top;
    _scroll.animateTo(
      target.clamp(0.0, _scroll.position.maxScrollExtent),
      duration: EterMotion.durStandard,
      curve: EterMotion.easeAir,
    );
  }
}

/// A chapter index for the single scroll, not a tab bar: a hairline tick and
/// a letterspaced initial per movement at the right margin, the current one
/// gold. It answers "fast access" without fragmenting the surface (§5.3).
///
/// It lives inside the 24 px gutter so it never sits over content. That caps
/// each target at 24 px wide — under the 48 px guidance — so the rows are
/// given the full 48 px of height to compensate, and every movement stays
/// reachable by scrolling regardless.
class _SectionRail extends StatefulWidget {
  const _SectionRail({
    required this.scroll,
    required this.keys,
    required this.movements,
    required this.onJump,
  });

  final ScrollController scroll;
  final Map<_Movement, GlobalKey> keys;

  /// Passed in rather than derived from which keys happen to be mounted: on
  /// the first build nothing below the fold has been laid out yet, so the
  /// rail would show only the movements it could already see.
  final List<_Movement> movements;
  final void Function(_Movement) onJump;

  @override
  State<_SectionRail> createState() => _SectionRailState();
}

class _SectionRailState extends State<_SectionRail> {
  @override
  void initState() {
    super.initState();
    // Offsets are unknown until the first layout completes; without this the
    // rail cannot tell which movement is at the top until the user scrolls.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  /// The movement occupying the top of the viewport: the last one whose top
  /// edge has passed the fold.
  _Movement? _active(BuildContext context) {
    const fold = 140.0;
    _Movement? current;
    for (final movement in widget.movements) {
      final target = widget.keys[movement]?.currentContext;
      if (target == null) continue;
      final box = target.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      if (box.localToGlobal(Offset.zero).dy <= fold) current = movement;
    }
    return current;
  }

  @override
  Widget build(BuildContext context) {
    final ink = EterInk.of(context);
    final text = Theme.of(context).textTheme;
    final gold = Theme.of(context).brightness == Brightness.dark
        ? EterColors.aura300
        : EterColors.aura700;
    return AnimatedBuilder(
      animation: widget.scroll,
      builder: (context, _) {
        final active = _active(context);
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final movement in widget.movements)
              Semantics(
                button: true,
                label: 'Jump to ${movement.label}',
                child: InkWell(
                  onTap: () => widget.onJump(movement),
                  child: SizedBox(
                    width: 24,
                    height: 48,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          movement.initial,
                          style: text.labelSmall?.copyWith(
                            color: movement == active ? gold : ink.labelMuted,
                            letterSpacing: 1.6,
                          ),
                        ),
                        const SizedBox(height: EterSpace.s4),
                        AnimatedContainer(
                          duration: EterMotion.durMicro,
                          width: movement == active ? 14 : 8,
                          height: 1,
                          color: movement == active ? gold : ink.line,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// The hour after which the morning reading stops leading the opening and is
/// demoted in place beneath the day's state (Q1, decided 27 July 2026).
const int _readingLeadsUntilHour = 11;

/// The first viewport: date eyebrow, ornament, revealed guidance, source
/// caption, and a single quiet invitation to descend. No visible chrome.
class _GuidanceMoment extends ConsumerWidget {
  const _GuidanceMoment({
    required this.guidance,
    required this.visible,
    required this.mystical,
    required this.onReveal,
    required this.onOpenFeatures,
    required this.onDescend,
  });

  final AetherGuidance guidance;
  final int visible;
  final bool mystical;
  final VoidCallback onReveal;
  final VoidCallback onOpenFeatures;
  final VoidCallback onDescend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final night = Theme.of(context).brightness == Brightness.dark;
    final dateLine =
        DateFormat('EEEE, d MMMM').format(DateTime.now()).toUpperCase();
    final revealed = visible >= guidance.sentences.length;

    // Q1: the morning reading leads on first view; once the day is properly
    // under way the reading is no longer the most useful thing on the screen,
    // so a one-line state summary takes the top slot and the reading moves
    // beneath it. The trigger is the clock, not whether data has arrived — a
    // day with nothing logged by 14:00 is exactly when the state line is worth
    // reading.
    final now = ref.watch(nowProvider)();
    final demoted = now.hour >= _readingLeadsUntilHour;
    final day = ref.watch(dayStateProvider).value ?? DayState.initial;
    final intake = ref.watch(_intakeTodayProvider).value ?? 0;
    final profile = ref.watch(profileProvider);
    final burned = profile == null
        ? day.activeKcal
        : burnedSoFarToday(
            restingKcalPerMin: profile.restingKcalPerMin,
            activeKcal: day.activeKcal,
            now: now,
          );
    // Two quantities, not three: at display size a third wrapped the line, and
    // steps already has a figure of its own on the dashboard (C1).
    final stateLine = '${intake.round()} eaten · ${burned.round()} burned';
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          EterSpace.gutter, EterSpace.s16, EterSpace.gutter, EterSpace.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  mystical ? '✦  $dateLine' : dateLine,
                  // C8 — this line sits on bare sky with no plate to lift it.
                  // Measured on the Day Sky photograph: aura700 gold reaches
                  // only 1.15:1 and the default secondary ink600 2.15:1, both
                  // far under AA; ink900 makes 4.77:1. Day therefore keeps the
                  // ✦ as its ornament signature but drops the gold ink. Night
                  // sky is dark enough for aura300 to stand.
                  style: text.labelSmall?.copyWith(
                    color: night
                        ? (mystical ? EterColors.aura300 : null)
                        : EterColors.ink900,
                  ),
                ),
              ),
              _GhostMenuButton(onPressed: onOpenFeatures),
            ],
          ),
          if (demoted) ...[
            const SizedBox(height: EterSpace.s32),
            Text(stateLine, style: text.displaySmall?.copyWith(height: 1.3)),
            const SizedBox(height: EterSpace.s32),
          ] else
            const Spacer(flex: 3),
          if (mystical) ...[
            const OrnamentDivider(),
            const SizedBox(height: EterSpace.s32),
          ],
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: revealed ? null : onReveal,
            child: Semantics(
              liveRegion: true,
              label: guidance.sentences.join(' '),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < guidance.sentences.length; i++)
                    AnimatedOpacity(
                      opacity: i < visible ? 1 : 0,
                      duration: EterMotion.durReveal,
                      curve: EterMotion.easeAir,
                      child: AnimatedSlide(
                        offset:
                            i < visible ? Offset.zero : const Offset(0, 0.08),
                        duration: EterMotion.durReveal,
                        curve: EterMotion.easeAir,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: EterSpace.s24),
                          child: Text(
                            guidance.sentences[i],
                            // Demoted, the reading is no longer the hero: it
                            // steps down a size so the state line above it
                            // leads.
                            style: (demoted
                                    ? text.bodyLarge
                                    : i == 0
                                        ? text.displaySmall
                                        : text.headlineSmall)
                                ?.copyWith(height: 1.42),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!revealed)
            Align(
              alignment: Alignment.centerLeft,
              child: EterAction(
                label: 'Reveal guidance',
                emphasis: EterActionEmphasis.quiet,
                onPressed: onReveal,
              ),
            ),
          // Was flex 4 against the 3 above, which pinned the footer to the
          // bottom of the viewport and left the prose stranded in a void
          // (§5.4). At 2 the block sits optically centred and the caption
          // stays with what it captions.
          const Spacer(flex: 2),
          Text(
            // Any on-device source, not just the one literally named 'local':
            // the offline fallback is 'emergency-local', and an exact match
            // had this caption claiming Aether composed a reading it never
            // saw. Provenance copy has to be true or it is worse than absent.
            guidance.source.endsWith('local')
                ? 'Composed privately on this device'
                : 'Composed by Aether',
            // Also on bare sky (C8): ink600 measures 2.15:1 on Day.
            style: text.labelSmall?.copyWith(
              color: night ? null : EterColors.ink900,
            ),
          ),
          const SizedBox(height: EterSpace.s16),
          Center(child: _DescendHint(onTap: onDescend)),
        ],
      ),
    );
  }
}

/// The only persistent chrome on the guidance surface: a hairline gold
/// circle holding three dots. Opens the instrument index.
class _GhostMenuButton extends StatelessWidget {
  const _GhostMenuButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final night = Theme.of(context).brightness == Brightness.dark;
    // Grounded is a plain instrument: the ring and glyph are ink, not gold.
    final ornament = EterRegister.of(context).showsOrnament;
    final line = ornament
        ? EterColors.aura500.withValues(alpha: night ? 0.65 : 0.5)
        : EterColors.ink400.withValues(alpha: 0.7);
    final glyph = ornament
        ? (night ? EterColors.aura300 : EterColors.aura700)
        : EterColors.ink600;
    return Semantics(
      button: true,
      label: 'Open The Sanctum',
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: line),
          ),
          child: Icon(Icons.more_horiz, size: 18, color: glyph),
        ),
      ),
    );
  }
}

/// A thin descending thread with a chevron, bobbing gently until touched.
class _DescendHint extends StatefulWidget {
  const _DescendHint({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_DescendHint> createState() => _DescendHintState();
}

class _DescendHintState extends State<_DescendHint>
    with SingleTickerProviderStateMixin {
  AnimationController? _bob;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animate =
        !MediaQuery.disableAnimationsOf(context) && !eterRunningTests();
    if (animate && _bob == null) {
      _bob = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2200),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _bob?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final night = Theme.of(context).brightness == Brightness.dark;
    final color = (night ? EterColors.nightText3 : EterColors.ink400)
        .withValues(alpha: 0.9);
    final thread = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 1,
            height: 26,
            color: EterColors.aura500.withValues(alpha: 0.4)),
        Icon(Icons.keyboard_arrow_down, size: 18, color: color),
      ],
    );
    final bob = _bob;
    return Semantics(
      button: true,
      label: 'Scroll to today’s instruments',
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(EterSpace.s16),
        child: Padding(
          padding: const EdgeInsets.all(EterSpace.s8),
          child: bob == null
              ? thread
              : AnimatedBuilder(
                  animation: bob,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, 4 * bob.value),
                    child: child,
                  ),
                  child: thread,
                ),
        ),
      ),
    );
  }
}

/// The instrument dashboard beneath the moment: today's figures, the daily
/// card as a small companion, observed patterns, the wider sky, and the
/// quiet actions. Everything expansive lives here, never in the moment.
class _Dashboard extends ConsumerWidget {
  const _Dashboard({
    required this.mode,
    required this.onCheckIn,
    required this.onOpenFeatures,
    required this.movementKeys,
  });

  final GuidanceMode mode;
  final VoidCallback onCheckIn;
  final VoidCallback onOpenFeatures;
  final Map<_Movement, GlobalKey> movementKeys;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final day = ref.watch(dayStateProvider).value ?? DayState.initial;
    final intake = ref.watch(_intakeTodayProvider).value ?? 0;
    final patterns = ref.watch(_activePatternsProvider).value ?? const [];
    final element = ref.watch(elementProvider);
    final mystical = mode != GuidanceMode.grounded;
    final register = EterRegister.of(context);
    // Same definition as the Scales below, so "Burned" is one quantity on this
    // scroll rather than two (C2).
    final burned = profile == null
        ? day.activeKcal
        : burnedSoFarToday(
            restingKcalPerMin: profile.restingKcalPerMin,
            activeKcal: day.activeKcal,
            now: ref.watch(nowProvider)(),
          );

    // C10: the dashboard is instruments. Everything here is plain whatever the
    // user's register, and the ritual moments below opt back in explicitly.
    return SurfaceIntentScope(
      intent: SurfaceIntent.plain,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            EterSpace.gutter, EterSpace.s32, EterSpace.gutter, EterSpace.s48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PulseBlock(),
            const SizedBox(height: EterSpace.s32),
            const JournalComposer(),
            const SizedBox(height: EterSpace.s48),
            KeyedSubtree(
              key: movementKeys[_Movement.day],
              child: const _SectionHeader(label: 'The day in numbers'),
            ),
            const SizedBox(height: EterSpace.s24),
            Row(
              children: [
                _Figure(
                  value: intake,
                  label: 'Eaten',
                  unit: 'kcal',
                ),
                const _FigureDivider(),
                _Figure(
                  value: burned,
                  label: 'Burned',
                  unit: 'kcal',
                  // The element accent is a mystical signature, so it resolves
                  // like every other ornament (C10). The figures are an
                  // instrument, so no register paints one fire-orange among
                  // plain ink ones.
                  accentElement: element,
                ),
                const _FigureDivider(),
                _Figure(
                  value: day.steps.toDouble(),
                  label: 'Steps',
                  unit: '',
                ),
              ],
            ),
            // The ring-gauge row was deleted (C1/A3): Active and Steps restated
            // two of the three figures 32 px above, and the donut is the stock
            // fitness-app component the aesthetic directive rules out.
            // Figures, Scales and Timeline are one movement — the day's
            // quantities — so they breathe at 24 (C3). The 48s are reserved for
            // boundaries between movements.
            const SizedBox(height: EterSpace.s24),
            const ScalesSection(),
            const SizedBox(height: EterSpace.s24),
            const TimelineSparkline(),
            if (patterns.isNotEmpty) ...[
              const SizedBox(height: EterSpace.s48),
              const _SectionHeader(label: 'What Aether has noticed'),
              const SizedBox(height: EterSpace.s16),
              for (final pattern in patterns.take(3))
                Padding(
                  padding: const EdgeInsets.only(bottom: EterSpace.s16),
                  child: _PatternRow(pattern: pattern),
                ),
            ],
            // The moments. These declare ritual intent, so the register decides
            // how far they go — and grounded still keeps them quiet.
            SurfaceIntentScope(
              intent: SurfaceIntent.ritual,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (mystical && profile != null) ...[
                    const SizedBox(height: EterSpace.s48),
                    const _SectionHeader(label: 'The wider sky'),
                    const SizedBox(height: EterSpace.s16),
                    _WiderSky(profile: profile),
                  ],
                  if (mystical) ...[
                    const SizedBox(height: EterSpace.s48),
                    VesselSection(onOpenSanctum: onOpenFeatures),
                  ],
                  if (register.showsCompanionCard && profile != null) ...[
                    const SizedBox(height: EterSpace.s48),
                    _SectionHeader(
                        label: register.showsHeroCard
                            ? 'The card for today'
                            : 'Your companion card'),
                    const SizedBox(height: EterSpace.s24),
                    _CompanionCard(zodiac: profile.zodiac),
                  ],
                ],
              ),
            ),
            const SizedBox(height: EterSpace.s48),
            Center(
              child: Wrap(
                spacing: EterSpace.s24,
                runSpacing: EterSpace.s8,
                alignment: WrapAlignment.center,
                children: [
                  _GhostAction(label: 'Check in', onTap: onCheckIn),
                  _GhostAction(label: 'Settings', onTap: onOpenFeatures),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final night = Theme.of(context).brightness == Brightness.dark;
    // C10: the register grants ornament, the surface decides whether it wants
    // any. Instrument headers sit in a plain scope and stay unstarred even in
    // the immersive register.
    final ornament = showsOrnamentHere(context);
    return Row(
      children: [
        if (ornament)
          Padding(
            padding: const EdgeInsets.only(right: EterSpace.s12),
            child: StarOrnament(
              size: 11,
              color: EterColors.aura500.withValues(alpha: night ? 0.9 : 0.75),
            ),
          ),
        Text(label.toUpperCase(), style: text.labelSmall),
        const SizedBox(width: EterSpace.s16),
        Expanded(
          child: Container(
            height: 1,
            color: EterColors.aura500.withValues(alpha: night ? 0.28 : 0.2),
          ),
        ),
      ],
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({
    required this.value,
    required this.label,
    required this.unit,
    this.accentElement,
  });

  final double value;
  final String label;
  final String unit;

  /// Resolved here rather than by the caller: the caller's context sits above
  /// the SurfaceIntentScope it returns, so it would read the ambient intent
  /// instead of its own and paint the accent on a plain surface.
  final zodiac.Element? accentElement;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final element = accentElement;
    final accent = element != null && showsOrnamentHere(context)
        ? element.accentFor(Theme.of(context).brightness)
        : null;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The unit rides with the figure. Folding it into the label produced
          // "TAKEN IN KCAL", which wrapped to two lines in a three-column row
          // and pushed the columns out of alignment with each other.
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: CountUpText(
                  value,
                  style: text.headlineLarge?.copyWith(
                    fontSize: 30,
                    height: 1.1,
                    color: accent,
                  ),
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 3),
                Text(unit, style: text.labelSmall),
              ],
            ],
          ),
          const SizedBox(height: EterSpace.s4),
          Text(label.toUpperCase(), style: text.labelSmall),
        ],
      ),
    );
  }
}

class _FigureDivider extends StatelessWidget {
  const _FigureDivider();

  @override
  Widget build(BuildContext context) {
    final night = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 1,
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: EterSpace.s16),
      color: showsOrnamentHere(context)
          ? EterColors.aura500.withValues(alpha: night ? 0.3 : 0.22)
          : (night ? EterColors.night700 : EterColors.sky200),
    );
  }
}

/// The daily card, demoted to a quiet companion: small, still, and only
/// opening into the full reveal when explicitly asked.
class _CompanionCard extends StatefulWidget {
  const _CompanionCard({required this.zodiac});

  final Zodiac zodiac;

  @override
  State<_CompanionCard> createState() => _CompanionCardState();
}

class _CompanionCardState extends State<_CompanionCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final night = Theme.of(context).brightness == Brightness.dark;
    final z = widget.zodiac;

    // Immersive treats the card as the centre of the surface. The commissioned
    // artwork is the best thing in the app and it was shipping at 64x104 px
    // beside a heading — smaller than the app icon.
    if (EterRegister.of(context).showsHeroCard) {
      return Column(
        children: [
          Center(
            child: GestureDetector(
              onTap: () => setState(() => _open = !_open),
              child: AnimatedArcanaCard(
                zodiac: z,
                revealed: _open,
                width: 232,
              ),
            ),
          ),
          const SizedBox(height: EterSpace.s24),
          Text(z.arcana, style: text.displaySmall),
          const SizedBox(height: EterSpace.s4),
          Text(
            '${z.numeral} · ${z.subtitle}'.toUpperCase(),
            style: text.labelSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: EterSpace.s12),
          EterAction(
            label: _open ? 'Fold away' : 'Turn the card',
            emphasis: EterActionEmphasis.quiet,
            onPressed: () => setState(() => _open = !_open),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(EterSpace.rChip),
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: EterSpace.s8),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: EterColors.aura500
                          .withValues(alpha: night ? 0.5 : 0.35),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    z.cardAssetFor(Theme.of(context).brightness),
                    width: 64,
                    height: 104,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: EterSpace.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(z.arcana, style: text.titleLarge),
                      const SizedBox(height: EterSpace.s4),
                      Text(
                        '${z.numeral} · ${z.subtitle}'.toUpperCase(),
                        style: text.labelSmall,
                      ),
                      const SizedBox(height: EterSpace.s8),
                      Text(
                        _open ? 'Fold away' : 'Unfold the card',
                        style: text.labelLarge?.copyWith(
                          color:
                              night ? EterColors.aura300 : EterColors.aura700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: EterMotion.durEmphasis,
          curve: EterMotion.easeAir,
          alignment: Alignment.topCenter,
          child: _open
              ? Padding(
                  padding: const EdgeInsets.only(top: EterSpace.s16),
                  child: Center(
                    child: AnimatedArcanaCard(
                      zodiac: z,
                      revealed: true,
                      width: 168,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _PatternRow extends StatelessWidget {
  const _PatternRow({required this.pattern});

  final PatternCandidateRow pattern;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final night = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: EterColors.aura500.withValues(alpha: night ? 0.8 : 0.6),
            ),
          ),
        ),
        const SizedBox(width: EterSpace.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pattern.summary, style: text.bodyLarge),
              const SizedBox(height: EterSpace.s4),
              Text(
                'An observed correlation, not a cause'.toUpperCase(),
                style: text.labelSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Life path, sign, element and — with a complete birth chart — the
/// Sun/Moon/Ascendant line. Deterministic, inspectable, never medical.
class _WiderSky extends StatelessWidget {
  const _WiderSky({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final lines = <String>[
      'Life path ${calculateLifePath(profile.dob)} · ${profile.zodiac.label} · ${profile.zodiac.element.label}',
    ];
    if (profile.hasCompleteBirthChartInput) {
      final birthMinutes = profile.birthTimeMinutes!;
      final chart = NatalChartEngine().calculate(
        NatalInput(
          localDateTime: DateTime(
            profile.dob.year,
            profile.dob.month,
            profile.dob.day,
            birthMinutes ~/ 60,
            birthMinutes % 60,
          ),
          utcOffsetMinutes: profile.birthUtcOffsetMinutes!,
          latitude: profile.birthLatitude!,
          longitude: profile.birthLongitude!,
        ),
      );
      lines.add(
        'Sun in ${chart.sun.sign} · Moon in ${chart.moon.sign} · Rising ${chart.ascendant.sign}',
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElementMedallion(profile.zodiac.element, size: 64),
        const SizedBox(width: EterSpace.s16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: EterSpace.s8),
                  child: Text(
                    line,
                    style: text.headlineSmall
                        ?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A quiet text action with a gold underline that feels typed, not tapped.
class _GhostAction extends StatelessWidget {
  const _GhostAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final night = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(EterSpace.s8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: EterSpace.s8, vertical: EterSpace.s12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: text.labelLarge),
            const SizedBox(height: EterSpace.s4),
            Container(
              width: 22,
              height: 1,
              color: EterColors.aura500.withValues(alpha: night ? 0.7 : 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SizedBox(width: 72, child: Text(label)),
          Expanded(
            child: EterSlider(
              value: value,
              min: 1,
              max: 5,
              divisions: 4,
              semanticFormatter: (value) => value.round().toString(),
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 20,
            child: Text(value.round().toString()),
          ),
        ],
      );
}
