import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/aether/guidance.dart';
import '../../core/aether/vessel.dart';
import '../../core/aether/vessel_service.dart';
import '../../core/arcana/animated_arcana_card.dart';
import '../../core/arcana/major_arcana.dart';
import '../../core/controls.dart';
import '../../core/profile.dart';
import '../../core/register.dart';
import '../../core/tokens.dart';
import 'journal_composer.dart';

class VesselSection extends ConsumerStatefulWidget {
  const VesselSection({
    super.key,
    this.initiallyExpanded = false,
    this.onOpenSanctum,
  });

  /// Lets the "add birth time and place" prompt actually go there.
  final VoidCallback? onOpenSanctum;

  final bool initiallyExpanded;

  @override
  ConsumerState<VesselSection> createState() => _VesselSectionState();
}

class _VesselSectionState extends ConsumerState<VesselSection> {
  late bool _expanded;
  Future<VesselReading>? _reading;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  void _toggle(Profile profile) {
    setState(() {
      _expanded = !_expanded;
      if (_expanded && _reading == null) {
        final client = ref.read(aetherClientProvider);
        if (client != null && profile.hasCompleteBirthChartInput) {
          _reading = VesselService(
            database: ref.read(databaseProvider),
            client: client,
          ).readingFor(profile);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!EterRegister.of(context).showsOrnament) {
      return const SizedBox.shrink();
    }
    final profile = ref.watch(profileProvider);
    if (profile == null) return const SizedBox.shrink();
    final text = Theme.of(context).textTheme;
    final brightness = Theme.of(context).brightness;
    final suffix = brightness == Brightness.dark ? 'night' : 'dawn';
    final lifePath = calculateLifePath(profile.dob);
    final lifePathCard = MajorArcana.forLifePath(lifePath);
    final zodiacCard = MajorArcana.forZodiac(profile.zodiac);
    // The Vessel is a ritual moment, and declares so itself rather than
    // relying on where it happens to be mounted (C10).
    return SurfaceIntentScope(
      intent: SurfaceIntent.ritual,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _toggle(profile),
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: EterSpace.s8),
              child: Row(
                children: [
                  Expanded(child: Text('THE VESSEL', style: text.labelSmall)),
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
            duration: const Duration(milliseconds: 320),
            alignment: Alignment.topCenter,
            child: !_expanded
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      const SizedBox(height: EterSpace.s16),
                      Row(
                        children: [
                          Expanded(
                            child: _VesselCardSlot(
                              background: 'assets/art/vessel/moon-$suffix.png',
                              card: lifePathCard,
                              eyebrow: 'LIFE PATH $lifePath',
                            ),
                          ),
                          const SizedBox(width: EterSpace.s12),
                          Expanded(
                            child: _VesselCardSlot(
                              background: 'assets/art/vessel/sun-$suffix.png',
                              card: zodiacCard,
                              eyebrow:
                                  '${profile.zodiac.label.toUpperCase()} SUN',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: EterSpace.s16),
                      if (!profile.hasCompleteBirthChartInput)
                        _VesselPrompt(
                          title: 'Your chart is waiting',
                          message: 'Your birth time and place complete it.',
                          actionLabel: widget.onOpenSanctum == null
                              ? null
                              : 'Add them in The Sanctum',
                          onAction: widget.onOpenSanctum,
                        )
                      else if (_reading == null)
                        const _VesselPrompt(
                          title: 'Your two anchors',
                          message:
                              'Connect Aether to compose your saved interpretation.',
                        )
                      else
                        FutureBuilder<VesselReading>(
                          future: _reading,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(
                                'The Vessel could not be composed yet.',
                                style: text.bodyMedium,
                              );
                            }
                            final reading = snapshot.data;
                            if (reading == null) {
                              return const Padding(
                                padding: EdgeInsets.all(EterSpace.s24),
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final passage in reading.passages) ...[
                                  Text(passage.title, style: text.titleLarge),
                                  const SizedBox(height: EterSpace.s4),
                                  Text(passage.reading, style: text.bodyLarge),
                                  const SizedBox(height: EterSpace.s16),
                                ],
                                Text('SYNTHESIS', style: text.labelSmall),
                                const SizedBox(height: EterSpace.s8),
                                Text(
                                  reading.synthesis,
                                  style: text.bodyLarge?.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _VesselPrompt extends StatelessWidget {
  const _VesselPrompt({
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;

  /// A prompt that names a destination should be able to reach it (§5.10);
  /// without these it is a dead end telling the user to go and find it.
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final actionLabel = this.actionLabel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: text.titleLarge),
        const SizedBox(height: EterSpace.s4),
        Text(message, style: text.bodyMedium),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: EterSpace.s12),
          EterAction(label: actionLabel, onPressed: onAction),
        ],
      ],
    );
  }
}

class _VesselCardSlot extends StatelessWidget {
  const _VesselCardSlot({
    required this.background,
    required this.card,
    required this.eyebrow,
  });

  final String background;
  final MajorArcana card;
  final String eyebrow;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 0.82,
          child: ClipRRect(
            borderRadius: BorderRadius.zero,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                Image.asset(background, fit: BoxFit.cover),
                ColoredBox(
                  color: Colors.black.withValues(
                    alpha: brightness == Brightness.dark ? 0.24 : 0.06,
                  ),
                ),
                Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.55,
                    child: Transform.translate(
                      offset: const Offset(0, -4),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(EterSpace.rChip),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x66000000),
                              blurRadius: 18,
                              offset: Offset(0, 9),
                            ),
                          ],
                        ),
                        child: AspectRatio(
                          aspectRatio: 1 / 1.485,
                          child: LayoutBuilder(
                            builder: (context, constraints) => ArcanaCardMedia(
                              path: card.assetFor(brightness),
                              videoPath: MediaQuery.disableAnimationsOf(context)
                                  ? null
                                  : card.nightLoopFor(brightness),
                              lightOverlay: brightness == Brightness.light,
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: EterSpace.s8),
        Text(eyebrow, style: text.labelSmall),
        const SizedBox(height: EterSpace.s4),
        Text(
          '${card.title} · ${card.numeral}',
          style: text.bodyMedium,
          maxLines: 2,
        ),
      ],
    );
  }
}
