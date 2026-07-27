import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../energy/energy.dart';
import '../energy/energy.dart' as energy;
import '../aether/guidance_mode.dart';
import '../profile.dart';

part 'app_database.g.dart';

@DataClassName('ProfileRow')
class Profiles extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  DateTimeColumn get dob => dateTime()();
  TextColumn get sex => text()();
  RealColumn get weightKg => real()();
  RealColumn get heightCm => real().nullable()();
  TextColumn get units => text()();
  BoolColumn get hapticsEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get flashEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get nutritionEnabled =>
      boolean().withDefault(const Constant(false))();
  TextColumn get connectedSourcesJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get firstName => text().nullable()();
  TextColumn get guidanceMode =>
      text().withDefault(const Constant('balanced'))();
  IntColumn get birthTimeMinutes => integer().nullable()();
  IntColumn get birthUtcOffsetMinutes => integer().nullable()();
  TextColumn get birthPlace => text().nullable()();
  RealColumn get birthLatitude => real().nullable()();
  RealColumn get birthLongitude => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('DaySummaryRow')
class DaySummaries extends Table {
  TextColumn get date => text()();
  RealColumn get activeKcal => real().withDefault(const Constant(0))();
  RealColumn get basalKcal => real().withDefault(const Constant(0))();
  RealColumn get intakeKcal => real().nullable()();
  IntColumn get steps => integer().withDefault(const Constant(0))();
  IntColumn get sessionsCount => integer().withDefault(const Constant(0))();
  IntColumn get milestonesFired => integer().withDefault(const Constant(0))();
  IntColumn get lastMilestoneIndex =>
      integer().withDefault(const Constant(0))();
  BoolColumn get recalibrated => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {date};
}

@DataClassName('RawBucketRow')
class RawBuckets extends Table {
  DateTimeColumn get minuteUtc => dateTime()();
  TextColumn get source => text()();
  RealColumn get activeKcal => real()();
  IntColumn get steps => integer().nullable()();
  RealColumn get avgHr => real().nullable()();
  IntColumn get hrSampleCount => integer().withDefault(const Constant(0))();
  IntColumn get priority => integer()();
  TextColumn get externalId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {source, minuteUtc};
}

@DataClassName('MinuteBucketRow')
class MinuteBuckets extends Table {
  DateTimeColumn get minuteUtc => dateTime()();
  RealColumn get activeKcal => real()();
  IntColumn get steps => integer().nullable()();
  RealColumn get avgHr => real().nullable()();
  TextColumn get winningSource => text()();
  TextColumn get provenance => text()();

  @override
  Set<Column<Object>> get primaryKey => {minuteUtc};
}

@DataClassName('IntegrationRow')
class Integrations extends Table {
  TextColumn get vendor => text()();
  TextColumn get status => text()();
  DateTimeColumn get lastAttempt => dateTime().nullable()();
  DateTimeColumn get lastSync => dateTime().nullable()();
  TextColumn get changesToken => text().nullable()();
  IntColumn get recordsToday => integer().withDefault(const Constant(0))();
  TextColumn get diagnosticsJson => text().withDefault(const Constant('{}'))();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {vendor};
}

@DataClassName('StrengthWorkoutRow')
class StrengthWorkouts extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();
  RealColumn get bodyWeightKgAtTime => real()();
  TextColumn get exercisesJson => text()();
  RealColumn get fallbackKcal => real()();
  RealColumn get finalKcal => real()();
  TextColumn get method => text().withDefault(const Constant('fallback'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('WeightEntryRow')
class WeightEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get recordedAt => dateTime()();
  RealColumn get kg => real()();
  TextColumn get source => text().withDefault(const Constant('manual'))();
}

@DataClassName('NutritionEntryRow')
class NutritionEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get recordedAt => dateTime()();
  RealColumn get kcal => real()();
  RealColumn get proteinG => real().nullable()();
  RealColumn get carbsG => real().nullable()();
  RealColumn get fatG => real().nullable()();
  TextColumn get meal => text()();
  TextColumn get source => text().withDefault(const Constant('eter'))();
  TextColumn get metadataJson => text().withDefault(const Constant('{}'))();
}

@DataClassName('LiveSessionRow')
class LiveSessions extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();
  TextColumn get sourceId => text()();
  TextColumn get hrSeriesJson => text()();
  RealColumn get finalKcal => real()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('RememberedSensorRow')
class RememberedSensors extends Table {
  TextColumn get deviceId => text()();
  TextColumn get name => text()();
  BoolColumn get paired => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastConnected => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {deviceId};
}

@DataClassName('GuidanceCacheRow')
class GuidanceCache extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  DateTimeColumn get generatedAt => dateTime()();
  TextColumn get contextFingerprint => text()();
  TextColumn get contentJson => text()();
  TextColumn get source => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('LifestyleEntryRow')
class LifestyleEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get recordedAt => dateTime()();
  TextColumn get kind => text()();
  RealColumn get value => real().nullable()();
  RealColumn get durationMinutes => real().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('self-report'))();
}

@DataClassName('PatternCandidateRow')
class PatternCandidates extends Table {
  TextColumn get key => text()();
  DateTimeColumn get computedAt => dateTime()();
  TextColumn get summary => text()();
  TextColumn get evidenceJson => text()();
  RealColumn get confidence => real()();
  TextColumn get status => text().withDefault(const Constant('active'))();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// A journal entry as the user wrote or spoke it, plus whatever Aether made of
/// it.
///
/// The prose is the source of truth for what was said; the extraction is a
/// derived interpretation that the user can correct. Both are kept so a
/// correction can re-derive rather than guess, and both stay on this device —
/// journal text is never mirrored to Firestore.
@DataClassName('JournalEntryRow')
class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime()();
  // `text` is also Drift's text-column builder, so the Dart getter must have a
  // different name. The persisted column remains exactly `text` as specified.
  TextColumn get entryText => text().named('text')();

  /// `typed` or `spoken`. Spoken entries came through on-device speech
  /// recognition, so they carry transcription error the user may want to fix.
  TextColumn get source => text().withDefault(const Constant('typed'))();

  /// `pending` — written but not yet classified (offline, or queued).
  /// `classified` — extraction applied to the other tables.
  /// `needsDetail` — classified, but something (strength sets) wants the user.
  /// `failed` — extraction rejected; the prose is still safe.
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get extractionJson => text().nullable()();
  TextColumn get model => text().nullable()();

  /// Set once the derived rows have been written, so a retry cannot double-log
  /// the same meal into `NutritionEntries`.
  DateTimeColumn get appliedAt => dateTime().nullable()();
}

@DataClassName('VesselReadingRow')
class VesselReadings extends Table {
  TextColumn get inputHash => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get contentJson => text()();
  TextColumn get model => text()();

  @override
  Set<Column<Object>> get primaryKey => {inputHash};
}

class DayTotalUpdate {
  const DayTotalUpdate({required this.row, required this.newMilestones});
  final DaySummaryRow row;
  final int newMilestones;
}

@DriftDatabase(
  tables: [
    Profiles,
    DaySummaries,
    RawBuckets,
    MinuteBuckets,
    Integrations,
    StrengthWorkouts,
    WeightEntries,
    NutritionEntries,
    LiveSessions,
    RememberedSensors,
    GuidanceCache,
    LifestyleEntries,
    PatternCandidates,
    JournalEntries,
    VesselReadings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 18;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) await m.createTable(daySummaries);
          if (from < 3) {
            await m.createTable(rawBuckets);
            await m.createTable(minuteBuckets);
          }
          if (from < 4) await m.createTable(integrations);
          if (from < 5) await m.createTable(strengthWorkouts);
          if (from < 6) await m.createTable(weightEntries);
          if (from < 7) {
            await m.addColumn(profiles, profiles.nutritionEnabled);
            await m.createTable(nutritionEntries);
          }
          if (from < 8) await m.createTable(liveSessions);
          if (from < 9) await m.createTable(rememberedSensors);
          if (from < 10) await m.createTable(guidanceCache);
          if (from < 11) {
            await m.addColumn(integrations, integrations.lastAttempt);
            await m.addColumn(integrations, integrations.diagnosticsJson);
            await m.addColumn(integrations, integrations.lastError);
          }
          if (from < 12) await m.createTable(lifestyleEntries);
          if (from < 13) {
            await m.addColumn(nutritionEntries, nutritionEntries.metadataJson);
          }
          if (from < 14) {
            await m.addColumn(profiles, profiles.firstName);
            await m.addColumn(profiles, profiles.guidanceMode);
            await m.addColumn(profiles, profiles.birthTimeMinutes);
            await m.addColumn(profiles, profiles.birthPlace);
            await m.addColumn(profiles, profiles.birthLatitude);
            await m.addColumn(profiles, profiles.birthLongitude);
          }
          if (from < 15) await m.createTable(patternCandidates);
          if (from < 16) {
            await m.addColumn(profiles, profiles.birthUtcOffsetMinutes);
          }
          if (from < 17) await m.createTable(journalEntries);
          if (from < 18) await m.createTable(vesselReadings);
        },
      );

  Future<void> savePatternCandidate({
    required String key,
    required String summary,
    required Map<String, Object?> evidence,
    required double confidence,
    DateTime? computedAt,
  }) =>
      into(patternCandidates).insertOnConflictUpdate(
        PatternCandidatesCompanion.insert(
          key: key,
          computedAt: computedAt ?? DateTime.now().toUtc(),
          summary: summary,
          evidenceJson: jsonEncode(evidence),
          confidence: confidence.clamp(0, 1),
        ),
      );

  Future<int> addJournalEntry({
    required String text,
    String source = 'typed',
    DateTime? createdAt,
  }) =>
      into(journalEntries).insert(
        JournalEntriesCompanion.insert(
          createdAt: createdAt ?? DateTime.now().toUtc(),
          entryText: text,
          source: Value(source),
        ),
      );

  Stream<List<JournalEntryRow>> watchJournalEntries({int limit = 50}) =>
      (select(journalEntries)
            ..orderBy([(row) => OrderingTerm.desc(row.createdAt)])
            ..limit(limit))
          .watch();

  /// Entries written while offline, oldest first, so a batch keeps its order.
  Future<List<JournalEntryRow>> pendingJournalEntries({int limit = 10}) =>
      (select(journalEntries)
            ..where((row) => row.status.equals('pending'))
            ..orderBy([(row) => OrderingTerm.asc(row.createdAt)])
            ..limit(limit))
          .get();

  Future<void> saveJournalExtraction({
    required int id,
    required String status,
    String? extractionJson,
    String? model,
    DateTime? appliedAt,
  }) =>
      (update(journalEntries)..where((row) => row.id.equals(id))).write(
        JournalEntriesCompanion(
          status: Value(status),
          extractionJson: Value(extractionJson),
          model: Value(model),
          appliedAt: Value(appliedAt),
        ),
      );

  /// Journal prose is pruned once its extraction has been applied and the
  /// retention window has passed. The derived rows in the other tables — and so
  /// every statistic — are unaffected; only the free text goes.
  Future<int> pruneJournalProse({required DateTime before}) =>
      (update(journalEntries)
            ..where((row) =>
                row.appliedAt.isNotNull() &
                row.createdAt.isSmallerThanValue(before) &
                row.entryText.equals('').not()))
          .write(const JournalEntriesCompanion(entryText: Value('')));

  Stream<List<PatternCandidateRow>> watchPatternCandidates() =>
      (select(patternCandidates)
            ..where((row) => row.status.equals('active'))
            ..orderBy([(row) => OrderingTerm.desc(row.confidence)]))
          .watch();

  Future<List<PatternCandidateRow>> loadActivePatternCandidates() =>
      (select(patternCandidates)
            ..where((row) => row.status.equals('active'))
            ..orderBy([(row) => OrderingTerm.desc(row.confidence)]))
          .get();

  Future<void> setPatternStatus(String key, String status) =>
      (update(patternCandidates)..where((row) => row.key.equals(key))).write(
        PatternCandidatesCompanion(status: Value(status)),
      );

  Future<void> resetPatterns() => delete(patternCandidates).go();

  Future<int> addLifestyleEntry({
    required String kind,
    double? value,
    double? durationMinutes,
    String? note,
    DateTime? recordedAt,
    String source = 'self-report',
  }) =>
      into(lifestyleEntries).insert(
        LifestyleEntriesCompanion.insert(
          recordedAt: recordedAt ?? DateTime.now(),
          kind: kind,
          value: Value(value),
          durationMinutes: Value(durationMinutes),
          note: Value(note),
          source: Value(source),
        ),
      );

  Future<List<LifestyleEntryRow>> loadLifestyleEntries(
    DateTime start,
    DateTime end,
  ) =>
      (select(lifestyleEntries)
            ..where((row) =>
                row.recordedAt.isBiggerOrEqualValue(start) &
                row.recordedAt.isSmallerThanValue(end))
            ..orderBy([(row) => OrderingTerm.asc(row.recordedAt)]))
          .get();

  Stream<List<LifestyleEntryRow>> watchLifestyleEntries(
    DateTime start,
    DateTime end,
  ) =>
      (select(lifestyleEntries)
            ..where((row) =>
                row.recordedAt.isBiggerOrEqualValue(start) &
                row.recordedAt.isSmallerThanValue(end))
            ..orderBy([(row) => OrderingTerm.asc(row.recordedAt)]))
          .watch();

  Future<GuidanceCacheRow?> loadLatestGuidance() =>
      (select(guidanceCache)..where((row) => row.id.equals(1)))
          .getSingleOrNull();

  Future<void> saveGuidance({
    required DateTime generatedAt,
    required String contextFingerprint,
    required String contentJson,
    required String source,
  }) =>
      into(guidanceCache).insertOnConflictUpdate(
        GuidanceCacheCompanion.insert(
          id: const Value(1),
          generatedAt: generatedAt.toUtc(),
          contextFingerprint: contextFingerprint,
          contentJson: contentJson,
          source: source,
        ),
      );

  Future<int> clearGuidanceCache() => delete(guidanceCache).go();

  Future<VesselReadingRow?> loadVesselReading(String inputHash) =>
      (select(vesselReadings)..where((row) => row.inputHash.equals(inputHash)))
          .getSingleOrNull();

  Future<void> saveVesselReading({
    required String inputHash,
    required String contentJson,
    required String model,
    DateTime? createdAt,
  }) =>
      into(vesselReadings).insertOnConflictUpdate(
        VesselReadingsCompanion.insert(
          inputHash: inputHash,
          createdAt: createdAt ?? DateTime.now().toUtc(),
          contentJson: contentJson,
          model: model,
        ),
      );

  Future<void> saveStrengthWorkout(StrengthWorkoutsCompanion workout) =>
      into(strengthWorkouts).insertOnConflictUpdate(workout);

  Future<int> addWeightEntry({
    required double kg,
    DateTime? recordedAt,
    String source = 'manual',
  }) =>
      into(weightEntries).insert(WeightEntriesCompanion.insert(
        recordedAt: recordedAt ?? DateTime.now(),
        kg: kg,
        source: Value(source),
      ));

  Stream<List<WeightEntryRow>> watchWeightEntries({int limit = 365}) =>
      (select(weightEntries)
            ..orderBy([(row) => OrderingTerm.desc(row.recordedAt)])
            ..limit(limit))
          .watch();

  Future<void> ingestRawBuckets(Iterable<energy.MinuteBucket> buckets) async {
    await batch((batch) {
      for (final bucket in buckets) {
        batch.insert(
          rawBuckets,
          RawBucketsCompanion.insert(
            minuteUtc: bucket.minuteUtc.toUtc(),
            source: bucket.sourceId,
            activeKcal: bucket.activeKcal,
            priority: bucket.priority.index,
            hrSampleCount: Value(bucket.hrSampleCount),
            steps: Value(bucket.steps),
            avgHr: Value(bucket.avgHr),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Rebuilds canonical minute winners for a UTC half-open range. Raw replay
  /// is harmless because ingest uses the natural (source, minute) key.
  Future<double> recomputeMinuteWinners(
      DateTime startUtc, DateTime endUtc) async {
    final raw = await (select(rawBuckets)
          ..where((t) =>
              t.minuteUtc.isBiggerOrEqualValue(startUtc.toUtc()) &
              t.minuteUtc.isSmallerThanValue(endUtc.toUtc())))
        .get();
    final winners = energy.dedupe(raw.map((row) => energy.MinuteBucket(
          minuteUtc: row.minuteUtc.toUtc(),
          activeKcal: row.activeKcal,
          sourceId: row.source,
          priority: energy.SourcePriority.values[row.priority],
          hrSampleCount: row.hrSampleCount,
          steps: row.steps,
          avgHr: row.avgHr,
        )));
    await transaction(() async {
      await (delete(minuteBuckets)
            ..where((t) =>
                t.minuteUtc.isBiggerOrEqualValue(startUtc.toUtc()) &
                t.minuteUtc.isSmallerThanValue(endUtc.toUtc())))
          .go();
      await batch((batch) {
        for (final winner in winners.values) {
          batch.insert(
            minuteBuckets,
            MinuteBucketsCompanion.insert(
              minuteUtc: winner.minuteUtc,
              activeKcal: winner.activeKcal,
              winningSource: winner.sourceId,
              provenance: winner.sourceId,
              steps: Value(winner.steps),
              avgHr: Value(winner.avgHr),
            ),
          );
        }
      });
    });
    return energy.dailyTotalKcal(winners);
  }

  Stream<List<MinuteBucketRow>> watchMinuteBuckets(
          DateTime startUtc, DateTime endUtc) =>
      (select(minuteBuckets)
            ..where((t) =>
                t.minuteUtc.isBiggerOrEqualValue(startUtc.toUtc()) &
                t.minuteUtc.isSmallerThanValue(endUtc.toUtc()))
            ..orderBy([(t) => OrderingTerm.asc(t.minuteUtc)]))
          .watch();

  Future<List<MinuteBucketRow>> loadMinuteBuckets(
    DateTime startUtc,
    DateTime endUtc,
  ) =>
      (select(minuteBuckets)
            ..where((row) =>
                row.minuteUtc.isBiggerOrEqualValue(startUtc) &
                row.minuteUtc.isSmallerThanValue(endUtc))
            ..orderBy([(row) => OrderingTerm.asc(row.minuteUtc)]))
          .get();

  Future<void> recordIntegrationSync({
    required String vendor,
    required String status,
    required int recordsToday,
    String? changesToken,
    DateTime? syncedAt,
    Map<String, Object?> diagnostics = const {},
    String? error,
  }) =>
      into(integrations).insertOnConflictUpdate(
        IntegrationsCompanion.insert(
          vendor: vendor,
          status: status,
          lastAttempt: Value(DateTime.now().toUtc()),
          lastSync: Value(syncedAt?.toUtc() ?? DateTime.now().toUtc()),
          changesToken: Value(changesToken),
          recordsToday: Value(recordsToday),
          diagnosticsJson: Value(jsonEncode(diagnostics)),
          lastError: Value(error),
        ),
      );

  Future<void> recordIntegrationFailure({
    required String vendor,
    required String status,
    required String error,
  }) async {
    final previous = await (select(integrations)
          ..where((row) => row.vendor.equals(vendor)))
        .getSingleOrNull();
    await into(integrations).insertOnConflictUpdate(
      IntegrationsCompanion.insert(
        vendor: vendor,
        status: status,
        lastAttempt: Value(DateTime.now().toUtc()),
        lastSync: Value(previous?.lastSync),
        changesToken: Value(previous?.changesToken),
        recordsToday: Value(previous?.recordsToday ?? 0),
        diagnosticsJson: Value(previous?.diagnosticsJson ?? '{}'),
        lastError: Value(error),
      ),
    );
  }

  Stream<List<IntegrationRow>> watchIntegrations() =>
      (select(integrations)..orderBy([(t) => OrderingTerm.asc(t.vendor)]))
          .watch();

  Future<IntegrationRow?> loadIntegration(String vendor) =>
      (select(integrations)..where((row) => row.vendor.equals(vendor)))
          .getSingleOrNull();

  Future<Profile?> loadProfile() async {
    final row = await select(profiles).getSingleOrNull();
    if (row == null) return null;
    return Profile(
      dob: row.dob,
      sex: Sex.values.byName(row.sex),
      weightKg: row.weightKg,
      heightCm: row.heightCm,
      units: MeasurementUnits.values.byName(row.units),
      hapticsEnabled: row.hapticsEnabled,
      flashEnabled: row.flashEnabled,
      nutritionEnabled: row.nutritionEnabled,
      connectedSources: Set<String>.from(
        (jsonDecode(row.connectedSourcesJson) as List).cast<String>(),
      ),
      firstName: row.firstName,
      guidanceMode: GuidanceMode.values.byName(row.guidanceMode),
      birthTimeMinutes: row.birthTimeMinutes,
      birthUtcOffsetMinutes: row.birthUtcOffsetMinutes,
      birthPlace: row.birthPlace,
      birthLatitude: row.birthLatitude,
      birthLongitude: row.birthLongitude,
    );
  }

  Future<void> saveProfile(Profile profile) =>
      into(profiles).insertOnConflictUpdate(
        ProfilesCompanion.insert(
          id: const Value(1),
          dob: profile.dob,
          sex: profile.sex.name,
          weightKg: profile.weightKg,
          heightCm: Value(profile.heightCm),
          units: profile.units.name,
          hapticsEnabled: Value(profile.hapticsEnabled),
          flashEnabled: Value(profile.flashEnabled),
          nutritionEnabled: Value(profile.nutritionEnabled),
          connectedSourcesJson:
              Value(jsonEncode(profile.connectedSources.toList()..sort())),
          firstName: Value(profile.firstName),
          guidanceMode: Value(profile.guidanceMode.name),
          birthTimeMinutes: Value(profile.birthTimeMinutes),
          birthUtcOffsetMinutes: Value(profile.birthUtcOffsetMinutes),
          birthPlace: Value(profile.birthPlace),
          birthLatitude: Value(profile.birthLatitude),
          birthLongitude: Value(profile.birthLongitude),
        ),
      );

  Future<int> addNutritionEntry({
    required double kcal,
    required String meal,
    double? proteinG,
    double? carbsG,
    double? fatG,
    DateTime? recordedAt,
    String source = 'eter',
    Map<String, Object?> metadata = const {},
  }) =>
      into(nutritionEntries).insert(NutritionEntriesCompanion.insert(
        recordedAt: recordedAt ?? DateTime.now(),
        kcal: kcal,
        proteinG: Value(proteinG),
        carbsG: Value(carbsG),
        fatG: Value(fatG),
        meal: meal,
        source: Value(source),
        metadataJson: Value(jsonEncode(metadata)),
      ));

  Stream<List<NutritionEntryRow>> watchNutritionEntries(
    DateTime start,
    DateTime end,
  ) =>
      (select(nutritionEntries)
            ..where((row) =>
                row.recordedAt.isBiggerOrEqualValue(start) &
                row.recordedAt.isSmallerThanValue(end))
            ..orderBy([(row) => OrderingTerm.asc(row.recordedAt)]))
          .watch();

  Future<List<NutritionEntryRow>> loadNutritionEntries(
    DateTime start,
    DateTime end,
  ) =>
      (select(nutritionEntries)
            ..where((row) =>
                row.recordedAt.isBiggerOrEqualValue(start) &
                row.recordedAt.isSmallerThanValue(end))
            ..orderBy([(row) => OrderingTerm.asc(row.recordedAt)]))
          .get();

  Future<List<DaySummaryRow>> loadDaySummaries(
    DateTime start,
    DateTime end,
  ) =>
      (select(daySummaries)
            ..where((row) =>
                row.date.isBiggerOrEqualValue(
                  start.toLocal().toIso8601String().substring(0, 10),
                ) &
                row.date.isSmallerThanValue(
                  end.toLocal().toIso8601String().substring(0, 10),
                ))
            ..orderBy([(row) => OrderingTerm.asc(row.date)]))
          .get();

  Future<void> saveLiveSession(LiveSessionsCompanion session) =>
      into(liveSessions).insertOnConflictUpdate(session);

  Future<void> rememberSensor({
    required String deviceId,
    required String name,
    required bool paired,
  }) =>
      into(rememberedSensors).insertOnConflictUpdate(
        RememberedSensorsCompanion.insert(
          deviceId: deviceId,
          name: name,
          paired: Value(paired),
          lastConnected: Value(DateTime.now().toUtc()),
        ),
      );

  Stream<List<RememberedSensorRow>> watchRememberedSensors() =>
      (select(rememberedSensors)
            ..orderBy([(row) => OrderingTerm.desc(row.lastConnected)]))
          .watch();

  Future<List<RememberedSensorRow>> getRememberedSensors() =>
      (select(rememberedSensors)
            ..orderBy([(row) => OrderingTerm.desc(row.lastConnected)]))
          .get();

  Future<void> forgetSensor(String deviceId) =>
      (delete(rememberedSensors)..where((row) => row.deviceId.equals(deviceId)))
          .go();

  /// Atomically records the deduped total and advances the persisted milestone
  /// index. Replaying the same total cannot produce another crossing.
  Future<DayTotalUpdate> recordDayTotal({
    required String date,
    required double activeKcal,
    int? steps,
    double milestoneStepKcal = 100,
  }) =>
      transaction(() async {
        final previous = await (select(daySummaries)
              ..where((t) => t.date.equals(date)))
            .getSingleOrNull();
        final oldKcal = previous?.activeKcal ?? 0;
        final oldIndex = previous?.lastMilestoneIndex ?? 0;
        final reached =
            milestoneStepKcal > 0 ? activeKcal ~/ milestoneStepKcal : oldIndex;
        final rising = activeKcal > oldKcal;
        final nextIndex = rising && reached > oldIndex ? reached : oldIndex;
        final crossings = nextIndex - oldIndex;
        final row = DaySummaryRow(
          date: date,
          activeKcal: activeKcal,
          basalKcal: previous?.basalKcal ?? 0,
          intakeKcal: previous?.intakeKcal,
          steps: steps ?? previous?.steps ?? 0,
          sessionsCount: previous?.sessionsCount ?? 0,
          milestonesFired: (previous?.milestonesFired ?? 0) + crossings,
          lastMilestoneIndex: nextIndex,
          recalibrated: activeKcal < oldKcal,
        );
        await into(daySummaries).insertOnConflictUpdate(row);
        return DayTotalUpdate(row: row, newMilestones: crossings);
      });
}

LazyDatabase _openConnection() => LazyDatabase(() async {
      final directory = await getApplicationDocumentsDirectory();
      return NativeDatabase.createInBackground(
          File(p.join(directory.path, 'eter.sqlite')));
    });
