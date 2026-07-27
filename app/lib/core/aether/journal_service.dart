import '../activity/manual_activity_service.dart';
import '../db/app_database.dart';
import '../profile.dart';
import 'ai_contract.dart';
import 'journal.dart';

class JournalSaveResult {
  const JournalSaveResult({
    required this.entryId,
    required this.extraction,
  });

  final int entryId;
  final JournalExtraction extraction;
}

/// Persists prose locally, sends it once for extraction, then writes only the
/// validated structured interpretation into Eter's existing data tables.
///
/// No later guidance or synthesis request receives [text]. If classification
/// cannot run, the pending row remains available for an explicit retry.
class JournalService {
  const JournalService({
    required this.database,
    required this.client,
  });

  final AppDatabase database;
  final AetherClient client;

  Future<JournalSaveResult> saveAndClassify({
    required String text,
    required Profile profile,
    String source = 'typed',
    String locale = 'en',
    DateTime? createdAt,
  }) async {
    final timestamp = createdAt ?? DateTime.now();
    final id = await database.addJournalEntry(
      text: text.trim(),
      source: source,
      createdAt: timestamp,
    );
    try {
      final extraction = await client.classifyJournalEntry(
        text: text,
        weightKg: profile.weightKg,
        units: profile.units.name,
        locale: locale,
      );
      await _apply(
        id: id,
        createdAt: timestamp,
        extraction: extraction,
      );
      return JournalSaveResult(entryId: id, extraction: extraction);
    } on AetherProtocolException {
      await database.saveJournalExtraction(id: id, status: 'failed');
      rethrow;
    } on Object {
      // Connectivity and transient Firebase failures deliberately leave the
      // entry pending for a later retry.
      rethrow;
    }
  }

  /// Undoes a reading the user says is wrong.
  ///
  /// Removes every row the extraction wrote and recomputes the day, then
  /// marks the entry `discarded` rather than `pending` so the retry loop
  /// cannot quietly apply the same wrong reading again. The prose itself is
  /// kept: the user is rejecting the interpretation, not their own writing.
  Future<void> undo({
    required int entryId,
    required DateTime createdAt,
    required JournalExtraction extraction,
  }) async {
    final sources = <String>[
      for (final segment in extraction.segments)
        if (segment is ActivityJournalSegment)
          ManualActivityService.sourceIdFor(
            name: segment.name,
            startUtc: ManualActivityService.startUtcFor(
              endedAt: createdAt,
              durationMinutes: segment.durationMinutes,
            ),
          ),
    ];
    await database.transaction(() async {
      await database.revertJournalEntryRows(
        entryId: entryId,
        createdAt: createdAt,
        activitySources: sources,
      );
      await database.saveJournalExtraction(id: entryId, status: 'discarded');
    });
    // Deleting raw buckets does not by itself change the winning minute or the
    // day total, so both are rebuilt for the affected day.
    final localDay = DateTime(createdAt.year, createdAt.month, createdAt.day);
    final dayStartUtc = localDay.toUtc();
    final active = await database.recomputeMinuteWinners(
      dayStartUtc,
      localDay.add(const Duration(days: 1)).toUtc(),
    );
    await database.recordDayTotal(
      date: dayStartUtc.toIso8601String().substring(0, 10),
      activeKcal: active,
    );
  }

  Future<int> retryPending({
    required Profile profile,
    String locale = 'en',
  }) async {
    var classified = 0;
    for (final row in await database.pendingJournalEntries()) {
      if (row.entryText.trim().isEmpty) continue;
      try {
        final extraction = await client.classifyJournalEntry(
          text: row.entryText,
          weightKg: profile.weightKg,
          units: profile.units.name,
          locale: locale,
        );
        await _apply(
          id: row.id,
          createdAt: row.createdAt,
          extraction: extraction,
        );
        classified++;
      } on AetherProtocolException {
        await database.saveJournalExtraction(
          id: row.id,
          status: 'failed',
        );
      } on Object {
        break;
      }
    }
    return classified;
  }

  Future<void> _apply({
    required int id,
    required DateTime createdAt,
    required JournalExtraction extraction,
  }) =>
      database.transaction(() async {
        for (final segment in extraction.segments) {
          switch (segment) {
            case FoodJournalSegment():
              for (final item in segment.items) {
                await database.addNutritionEntry(
                  kcal: item.kcal,
                  proteinG: item.proteinG,
                  carbsG: item.carbsG,
                  fatG: item.fatG,
                  meal: item.name,
                  recordedAt: createdAt,
                  source: 'journal',
                  metadata: {
                    'journalEntryId': id,
                    'portion': item.portion,
                    'confidence': segment.confidence,
                  },
                );
              }
            case ActivityJournalSegment():
              await ManualActivityService(database).log(
                name: segment.name,
                durationMinutes: segment.durationMinutes,
                activeKcal: segment.activeKcal,
                endedAt: createdAt,
              );
            case RatingJournalSegment():
              await database.addLifestyleEntry(
                kind: segment.kind.name,
                value: segment.value.toDouble(),
                recordedAt: createdAt,
                source: 'journal',
              );
            case SleepJournalSegment():
              await database.addLifestyleEntry(
                kind: segment.kind.name,
                durationMinutes: segment.hours * 60,
                recordedAt: createdAt,
                source: 'journal',
              );
            case NoteJournalSegment():
              await database.addLifestyleEntry(
                kind: 'reflection',
                note: segment.text,
                recordedAt: createdAt,
                source: 'journal',
              );
            case StrengthJournalSegment():
              // Strength is intentionally not guessed into a completed
              // workout. The prefilled set sheet owns the final write.
              break;
          }
        }
        await database.saveJournalExtraction(
          id: id,
          status: extraction.needsUserDetail ? 'needsDetail' : 'classified',
          extractionJson: extraction.encode(),
          model: extraction.model,
          appliedAt: DateTime.now().toUtc(),
        );
        await database.clearGuidanceCache();
      });
}
