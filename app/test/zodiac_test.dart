import 'package:eter/core/arcana/zodiac.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Zodiac boundaries (spec 05 acceptance criteria)', () {
    test('Apr 19 → Aries · Apr 20 → Taurus', () {
      expect(Zodiac.fromDate(DateTime(1990, 4, 19)), Zodiac.aries);
      expect(Zodiac.fromDate(DateTime(1990, 4, 20)), Zodiac.taurus);
    });
    test('Jan 19 → Capricorn · Jan 20 → Aquarius', () {
      expect(Zodiac.fromDate(DateTime(1990, 1, 19)), Zodiac.capricorn);
      expect(Zodiac.fromDate(DateTime(1990, 1, 20)), Zodiac.aquarius);
    });
    test(
        'Feb 18 → Aquarius · Feb 19 → Pisces · Mar 20 → Pisces · Mar 21 → Aries',
        () {
      expect(Zodiac.fromDate(DateTime(1990, 2, 18)), Zodiac.aquarius);
      expect(Zodiac.fromDate(DateTime(1990, 2, 19)), Zodiac.pisces);
      expect(Zodiac.fromDate(DateTime(1990, 3, 20)), Zodiac.pisces);
      expect(Zodiac.fromDate(DateTime(1990, 3, 21)), Zodiac.aries);
    });
    test('Dec 21 → Sagittarius · Dec 22 → Capricorn', () {
      expect(Zodiac.fromDate(DateTime(1990, 12, 21)), Zodiac.sagittarius);
      expect(Zodiac.fromDate(DateTime(1990, 12, 22)), Zodiac.capricorn);
    });
    test('worked example: 1990-08-01 → Leo / Strength VIII / Fire', () {
      final z = Zodiac.fromDate(DateTime(1990, 8, 1));
      expect(z, Zodiac.leo);
      expect(z.arcana, 'Strength');
      expect(z.numeral, 'VIII');
      expect(z.element, Element.fire);
    });
  });

  test('Golden Dawn arcana mapping spot checks', () {
    expect(Zodiac.aquarius.arcana, 'The Star');
    expect(Zodiac.scorpio.arcana, 'Death');
    expect(Zodiac.scorpio.subtitle, 'Card of Transformation');
    expect(Zodiac.capricorn.subtitle, 'Card of Ambition');
  });
}
