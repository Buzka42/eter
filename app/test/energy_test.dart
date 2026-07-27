import 'package:eter/core/energy/energy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RMR — Mifflin-St Jeor (spec 05)', () {
    test('worked example: male 80kg 180cm 30y = 1780', () {
      expect(rmrKcalPerDay(sex: Sex.male, weightKg: 80, heightCm: 180, age: 30),
          1780);
    });
    test('female 60kg 165cm 25y = 1345.25', () {
      expect(
          rmrKcalPerDay(sex: Sex.female, weightKg: 60, heightCm: 165, age: 25),
          closeTo(1345.25, 0.001));
    });
    test('per-minute rate', () {
      expect(rmrPerMin(1780), closeTo(1.236, 0.001));
    });
  });

  group('Keytel HR→kcal/min (spec 07)', () {
    test('worked example: male 80kg 30y HR140 = 13.19', () {
      expect(keytelKcalPerMin(sex: Sex.male, hr: 140, weightKg: 80, age: 30),
          closeTo(13.19, 0.01));
    });
    test('female 65kg 28y HR140 = 8.62', () {
      expect(keytelKcalPerMin(sex: Sex.female, hr: 140, weightKg: 65, age: 28),
          closeTo(8.62, 0.01));
    });
    test('session floor below HR90 clamps to 1.2× resting', () {
      final v = sessionKcalPerMin(
          sex: Sex.male,
          hr: 60,
          weightKg: 80,
          age: 30,
          restingKcalPerMin: 1.236);
      expect(v, closeTo(1.2 * 1.236, 0.001));
    });
    test('Tanaka HRmax and zones', () {
      expect(hrMaxTanaka(30), 187);
      expect(hrZone(80, 187), 0); // <50%
      expect(hrZone(100, 187), 1); // 53%
      expect(hrZone(140, 187), 3); // 74.8%
      expect(hrZone(175, 187), 5); // 93.5%
    });
  });

  group('Home burn state (spec 06)', () {
    test('worked example: 14 active kcal in five minutes pulses', () {
      final resting = rmrPerMin(1780);
      expect(
        burnRatePerMin(
          trailingFiveMinuteActiveKcal: 14,
          restingKcalPerMin: resting,
        ),
        closeTo(4.036, 0.001),
      );
      expect(
        pulseThreshold(restingKcalPerMin: resting),
        closeTo(1.854, 0.001),
      );
      expect(
        shouldPulse(
          trailingFiveMinuteActiveKcal: 14,
          restingKcalPerMin: resting,
        ),
        isTrue,
      );
    });

    test('cloud fill clamps over-goal glow range at 1.25', () {
      expect(cloudFill(activeKcal: 250, activeGoal: 500), 0.5);
      expect(cloudFill(activeKcal: 1000, activeGoal: 500), 1.25);
      expect(cloudFill(activeKcal: -20, activeGoal: 500), 0);
    });
  });

  group('MET fallback (spec 08)', () {
    test('worked example: 80kg squats 4×8, 120s rest → 33.26 with EPOC', () {
      final ex = exerciseFallbackKcal(
        metHint: 6.0,
        weightKg: 80,
        sets: 4,
        repsPerSet: 8,
        restSecPerGap: 120,
      );
      expect(ex, closeTo(31.08, 0.01));
      expect(applyEpoc(ex), closeTo(33.26, 0.01));
    });
    test('technique factors match spec table', () {
      expect(techniqueFactor(SetTechnique.normal), 1.00);
      expect(techniqueFactor(SetTechnique.superset), 1.15);
      expect(techniqueFactor(SetTechnique.dropSet), 1.12);
      expect(techniqueFactor(SetTechnique.restPause), 1.10);
      expect(techniqueFactor(SetTechnique.eccentric), 1.08);
    });
    test('blend rule: ≥70% HR coverage → 0.6·HR + 0.4·AI (spec 12)', () {
      expect(
          blendFinalKcal(
              keytelSessionKcal: 300,
              aiKcal: 400,
              fallbackKcal: 250,
              hrCoveragePct: 70),
          closeTo(0.6 * 300 + 0.4 * 400, 0.001));
      expect(
          blendFinalKcal(
              keytelSessionKcal: 300,
              aiKcal: 400,
              fallbackKcal: 250,
              hrCoveragePct: 69.9),
          400);
      expect(
          blendFinalKcal(
              keytelSessionKcal: null,
              aiKcal: null,
              fallbackKcal: 250,
              hrCoveragePct: 0),
          250);
    });
  });
}
