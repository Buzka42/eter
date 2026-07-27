/// Pure milestone crossing logic shared by ingest and UI (specs 06 and 15).
class MilestoneCrossing {
  const MilestoneCrossing({
    required this.previousIndex,
    required this.currentIndex,
    required this.newCrossings,
  });

  final int previousIndex;
  final int currentIndex;
  final int newCrossings;

  bool get crossed => newCrossings > 0;
}

MilestoneCrossing calculateMilestoneCrossing({
  required double previousActiveKcal,
  required double currentActiveKcal,
  required int lastFiredIndex,
  required double stepKcal,
}) {
  if (stepKcal <= 0 || currentActiveKcal <= previousActiveKcal) {
    return MilestoneCrossing(
      previousIndex: lastFiredIndex,
      currentIndex: lastFiredIndex,
      newCrossings: 0,
    );
  }
  final reachedIndex = currentActiveKcal ~/ stepKcal;
  final nextIndex =
      reachedIndex > lastFiredIndex ? reachedIndex : lastFiredIndex;
  return MilestoneCrossing(
    previousIndex: lastFiredIndex,
    currentIndex: nextIndex,
    newCrossings: nextIndex - lastFiredIndex,
  );
}
