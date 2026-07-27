import 'package:eter/core/symbolic/natal_chart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('deterministic natal chart', () {
    final engine = NatalChartEngine();
    final input = NatalInput(
      localDateTime: DateTime(1990, 8, 1, 12, 0),
      utcOffsetMinutes: 120,
      latitude: 52.2297,
      longitude: 21.0122,
    );

    test('produces a complete bounded chart', () {
      final chart = engine.calculate(input);

      expect(
          chart.positions.map((position) => position.name),
          containsAll([
            'Sun',
            'Moon',
            'Mercury',
            'Venus',
            'Mars',
            'Jupiter',
            'Saturn',
            'Uranus',
            'Neptune',
            'Pluto',
            'North Node',
            'Ascendant',
            'Midheaven',
          ]));
      expect(chart.houseCusps, hasLength(12));
      expect(
        chart.positions.every(
          (position) => position.longitude >= 0 && position.longitude < 360,
        ),
        isTrue,
      );
      expect(chart.sun.sign, 'Leo');
      expect(chart.houseSystem, 'equal');
      expect(chart.toGuidanceSummary().toString().length, lessThan(6000));
    });

    test('is deterministic and converts local birth time to UTC', () {
      final first = engine.calculate(input);
      final second = engine.calculate(input);

      expect(first.toJson(), second.toJson());
      expect(first.calculatedAtUtc, DateTime.utc(1990, 8, 1, 10));
    });

    test('rejects invalid coordinates and UTC offsets', () {
      expect(
        () => engine.calculate(NatalInput(
          localDateTime: DateTime(2000),
          utcOffsetMinutes: 0,
          latitude: 91,
          longitude: 0,
        )),
        throwsRangeError,
      );
      expect(
        () => engine.calculate(NatalInput(
          localDateTime: DateTime(2000),
          utcOffsetMinutes: 15 * 60,
          latitude: 0,
          longitude: 0,
        )),
        throwsRangeError,
      );
    });
  });
}
