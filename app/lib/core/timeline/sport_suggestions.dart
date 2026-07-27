import 'dart:math' as math;

class SportTagEvent {
  const SportTagEvent({
    required this.sport,
    required this.startedAt,
    required this.durationMinutes,
  });

  final String sport;
  final DateTime startedAt;
  final int durationMinutes;
}

List<String> rankSports({
  required DateTime blockStart,
  required int blockMinutes,
  required Iterable<SportTagEvent> history,
}) {
  final events = history.toList(growable: false);
  if (events.isEmpty) return _coldStart(blockMinutes);
  final sports = events.map((event) => event.sport).toSet();
  final total = events.length + sports.length;
  final scores = <String, double>{};
  for (final sport in sports) {
    final tagged = events.where((event) => event.sport == sport).toList();
    final frequency = (tagged.length + 1) / total;
    final latest = tagged
        .map((event) => event.startedAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final days = blockStart.difference(latest).inHours.abs() / 24;
    final recency = math.exp(-days / 14);
    final comparable = tagged
        .where((event) => _isWeekend(event.startedAt) == _isWeekend(blockStart))
        .toList();
    final sample = comparable.isEmpty ? tagged : comparable;
    final medianMinute = _median(
      sample.map((event) => event.startedAt.hour * 60 + event.startedAt.minute),
    );
    final startMinute = blockStart.hour * 60 + blockStart.minute;
    final timeMatch = (startMinute - medianMinute).abs() <= 90 ? 1.0 : 0.0;
    final medianDuration =
        _median(sample.map((event) => event.durationMinutes)).clamp(1, 1440);
    final durationMatch =
        1 - math.min(1, (blockMinutes - medianDuration).abs() / medianDuration);
    final context = 0.6 * timeMatch + 0.4 * durationMatch;
    scores[sport] = 0.5 * frequency + 0.3 * recency + 0.2 * context;
  }
  final ranked = scores.keys.toList()
    ..sort((a, b) {
      final byScore = scores[b]!.compareTo(scores[a]!);
      return byScore == 0 ? a.compareTo(b) : byScore;
    });
  return ranked;
}

bool _isWeekend(DateTime value) =>
    value.weekday == DateTime.saturday || value.weekday == DateTime.sunday;

double _median(Iterable<int> values) {
  final sorted = values.toList()..sort();
  final middle = sorted.length ~/ 2;
  return sorted.length.isOdd
      ? sorted[middle].toDouble()
      : (sorted[middle - 1] + sorted[middle]) / 2;
}

List<String> _coldStart(int minutes) {
  if (minutes < 25) return const ['HIIT', 'Strength', 'Running'];
  if (minutes <= 70) return const ['Running', 'Cycling', 'Walking'];
  return const ['Walking', 'Hiking', 'Cycling'];
}
