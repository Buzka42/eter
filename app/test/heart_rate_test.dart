import 'package:eter/core/live/heart_rate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses 8-bit heart rate with RR intervals', () {
    final result =
        parseHeartRateMeasurement([0x10, 140, 0x00, 0x04, 0x00, 0x02]);
    expect(result.bpm, 140);
    expect(result.rrIntervals, [1, .5]);
  });

  test('parses 16-bit heart rate and energy', () {
    final result = parseHeartRateMeasurement([0x09, 0x8c, 0x00, 0x2a, 0x00]);
    expect(result.bpm, 140);
    expect(result.energyExpended, 42);
  });
}
