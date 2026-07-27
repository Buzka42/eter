import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/instruments.dart';
import '../../core/arcana/zodiac.dart';
import '../../core/clock.dart';
import '../../core/profile.dart';
import '../../core/tokens.dart';
import '../../core/widgets.dart';
import '../home/home_providers.dart';

final _timelineBucketsProvider = StreamProvider((ref) {
  final now = ref.watch(nowProvider)();
  final start = DateTime(now.year, now.month, now.day).toUtc();
  return ref
      .watch(databaseProvider)
      .watchMinuteBuckets(start, start.add(const Duration(days: 1)));
});

final _nutritionTodayProvider = StreamProvider((ref) {
  final now = ref.watch(nowProvider)();
  final start = DateTime(now.year, now.month, now.day);
  return ref
      .watch(databaseProvider)
      .watchNutritionEntries(start, start.add(const Duration(days: 1)));
});

class ScalesSection extends ConsumerWidget {
  const ScalesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    if (profile == null || !profile.nutritionEnabled) {
      return const SizedBox.shrink();
    }
    final entries = ref.watch(_nutritionTodayProvider).value ?? const [];
    final day = ref.watch(dayStateProvider).value ?? DayState.initial;
    final intake = entries.fold<double>(0, (sum, row) => sum + row.kcal);
    final now = ref.watch(nowProvider)();
    final burn = profile.restingKcalPerMin * (now.hour * 60 + now.minute) +
        day.activeKcal;
    final net = intake - burn;
    // The verdict branches on whether intake was logged at all, never on the
    // sign of net alone: with no entries "−828 kcal" only means the morning
    // passed, and calling that "a lighter balance today" endorses not eating.
    // A real deficit gets a factual phrasing, not approval.
    final verdict = entries.isEmpty
        ? 'Nothing logged yet'
        : '${net >= 0 ? '+' : '−'}${net.abs().round()} kcal · '
            '${net >= 0 ? 'well fueled' : 'more burned than eaten'}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // No 'THE SCALES' header (C3): the balance graphic names itself, and
        // the plate's hairline top rule already marks where the section starts.
        EterPlate(
          child: Column(
            children: [
              // C6: with nothing eaten yet the balance can only slam to one
              // side, which reads as a verdict rather than an absence. The
              // instrument appears once there are two quantities to weigh.
              if (entries.isEmpty)
                const EmptyStateOrnament(
                  asset: 'assets/art/empty-balance.png',
                  caption: 'Log something eaten and the scales will settle.',
                  width: 180,
                )
              else ...[
                EngravedBalance(
                  intake: intake,
                  burn: burn,
                  tilt: (net / 600 * 6).clamp(-6, 6),
                ),
                const SizedBox(height: EterSpace.s16),
                Text(
                  verdict,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class TimelineSparkline extends ConsumerStatefulWidget {
  const TimelineSparkline({super.key});

  @override
  ConsumerState<TimelineSparkline> createState() => _TimelineSparklineState();
}

class _TimelineSparklineState extends ConsumerState<TimelineSparkline> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final rows = ref.watch(_timelineBucketsProvider).value ?? const [];
    final values = List<double>.filled(24, 0);
    for (final row in rows) {
      values[row.minuteUtc.toLocal().hour] += row.activeKcal;
    }
    final accent = ref
            .watch(profileProvider)
            ?.zodiac
            .element
            .accentFor(Theme.of(context).brightness) ??
        EterColors.sky500;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: EterSpace.s8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'THE TIMELINE',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                if (rows.isNotEmpty)
                  Text(
                    '${rows.length} active min',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                const SizedBox(width: EterSpace.s8),
                // Chevron, not +/− (C9): '+' means create everywhere else in
                // an app whose primary verb is "add to today".
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
        // C6: a flat line above "0 active min" is a void pretending to be a
        // chart. Until there is movement to draw, show the commissioned empty
        // ornament and one line of intent instead.
        if (rows.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: EterSpace.s8),
            child: Center(
              child: EmptyStateOrnament(
                asset: 'assets/art/empty-timeline.png',
                caption: 'Movement will trace itself here through the day.',
                width: 180,
              ),
            ),
          )
        else
          SizedBox(
            height: _expanded ? 220 : 72,
            width: double.infinity,
            child: CustomPaint(
              painter: _SparkPainter(
                values: values,
                accent: accent,
                night: Theme.of(context).brightness == Brightness.dark,
                expanded: _expanded,
              ),
            ),
          ),
      ],
    );
  }
}

class _SparkPainter extends CustomPainter {
  const _SparkPainter({
    required this.values,
    required this.accent,
    required this.night,
    required this.expanded,
  });

  final List<double> values;
  final Color accent;
  final bool night;
  final bool expanded;

  @override
  void paint(Canvas canvas, Size size) {
    final baseline = Paint()
      ..color = night ? EterColors.night700 : EterColors.sky200
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height - 8),
      Offset(size.width, size.height - 8),
      baseline,
    );
    final maximum = math.max(1.0, values.reduce(math.max));
    final path = Path();
    for (var index = 0; index < values.length; index++) {
      final x = index / (values.length - 1) * size.width;
      final y = size.height -
          8 -
          (values[index] / maximum) * (size.height - (expanded ? 32 : 18));
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = expanded ? 2 : 1.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_SparkPainter oldDelegate) =>
      oldDelegate.values != values ||
      oldDelegate.expanded != expanded ||
      oldDelegate.night != night;
}
