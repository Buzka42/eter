import 'package:eter/core/energy/energy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final hourStart = DateTime.utc(2026, 7, 12, 18);
  DateTime minute(int i) => hourStart.add(Duration(minutes: i));

  group('Deduplication (spec 11 worked test)', () {
    test('manual strength (260) beats hub (300) for the same hour → 260', () {
      final raw = <MinuteBucket>[
        for (var i = 0; i < 60; i++)
          MinuteBucket(
              minuteUtc: minute(i),
              activeKcal: 300 / 60,
              sourceId: 'healthconnect',
              priority: SourcePriority.hub),
        for (var i = 0; i < 60; i++)
          MinuteBucket(
              minuteUtc: minute(i),
              activeKcal: 260 / 60,
              sourceId: 'eter-strength',
              priority: SourcePriority.manualStrength),
      ];
      final total = dailyTotalKcal(dedupe(raw));
      expect(total, closeTo(260, 0.001)); // not 560, not 300
    });

    test('replaying the same batch twice changes nothing (idempotency)', () {
      final batch = [
        for (var i = 0; i < 30; i++)
          MinuteBucket(
              minuteUtc: minute(i),
              activeKcal: 4,
              sourceId: 'garmin-api',
              priority: SourcePriority.vendorDirect),
      ];
      final once = dailyTotalKcal(dedupe(batch));
      final twice = dailyTotalKcal(dedupe([...batch, ...batch]));
      expect(twice, once);
    });

    test('same priority tie → higher HR density wins, never higher kcal', () {
      final a = MinuteBucket(
          minuteUtc: minute(0),
          activeKcal: 9.0, // higher kcal but sparse HR
          sourceId: 'watch-b',
          priority: SourcePriority.hub,
          hrSampleCount: 1);
      final b = MinuteBucket(
          minuteUtc: minute(0),
          activeKcal: 5.0,
          sourceId: 'watch-a',
          priority: SourcePriority.hub,
          hrSampleCount: 12);
      final winner = dedupe([a, b])[minute(0)]!;
      expect(winner.sourceId, 'watch-a');
    });

    test('full tie → alphabetically stable source id', () {
      final a = MinuteBucket(
          minuteUtc: minute(0),
          activeKcal: 9.0,
          sourceId: 'zeta',
          priority: SourcePriority.hub);
      final b = MinuteBucket(
          minuteUtc: minute(0),
          activeKcal: 5.0,
          sourceId: 'alpha',
          priority: SourcePriority.hub);
      expect(dedupe([a, b])[minute(0)]!.sourceId, 'alpha');
      expect(dedupe([b, a])[minute(0)]!.sourceId, 'alpha');
    });

    test('live strap outranks everything', () {
      final buckets = [
        MinuteBucket(
            minuteUtc: minute(0),
            activeKcal: 12,
            sourceId: 'polar-h10',
            priority: SourcePriority.liveStrap),
        MinuteBucket(
            minuteUtc: minute(0),
            activeKcal: 10,
            sourceId: 'watch',
            priority: SourcePriority.liveWatchSession),
        MinuteBucket(
            minuteUtc: minute(0),
            activeKcal: 8,
            sourceId: 'hub',
            priority: SourcePriority.hub),
      ];
      expect(dailyTotalKcal(dedupe(buckets)), 12);
    });
  });
}
