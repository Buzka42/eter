import 'package:eter/core/timeline/sport_suggestions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Boxing habit ranks first on Thursday near the usual time', () {
    final target = DateTime(2026, 7, 23, 18, 15); // Thursday
    final history = <SportTagEvent>[
      for (var weeks = 1; weeks <= 6; weeks++) ...[
        SportTagEvent(
          sport: 'Boxing',
          startedAt:
              target.subtract(Duration(days: 7 * weeks + 2, minutes: 15)),
          durationMinutes: 60,
        ),
        SportTagEvent(
          sport: 'Boxing',
          startedAt: target.subtract(Duration(days: 7 * weeks, minutes: 15)),
          durationMinutes: 60,
        ),
      ],
      SportTagEvent(
        sport: 'Running',
        startedAt: target.subtract(const Duration(days: 3, hours: 12)),
        durationMinutes: 30,
      ),
    ];
    expect(
      rankSports(
        blockStart: target,
        blockMinutes: 55,
        history: history,
      ).first,
      'Boxing',
    );
  });
}
