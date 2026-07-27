import '../energy/energy.dart';

enum HealthPermissionState { unknown, granted, denied, unavailable }

class HealthMinuteRecord {
  const HealthMinuteRecord({
    required this.minuteUtc,
    required this.activeKcal,
    required this.sourceId,
    this.steps,
    this.avgHr,
    this.hrSampleCount = 0,
    this.externalId,
  });

  final DateTime minuteUtc;
  final double activeKcal;
  final String sourceId;
  final int? steps;
  final double? avgHr;
  final int hrSampleCount;
  final String? externalId;

  MinuteBucket toBucket() => MinuteBucket(
        minuteUtc: minuteUtc.toUtc(),
        activeKcal: activeKcal,
        sourceId: sourceId,
        priority: SourcePriority.hub,
        hrSampleCount: hrSampleCount,
        steps: steps,
        avgHr: avgHr,
      );
}

class HealthReadBatch {
  const HealthReadBatch({required this.records, this.nextChangesToken});
  final List<HealthMinuteRecord> records;
  final String? nextChangesToken;
}

/// Platform-neutral contract. HealthKit and Health Connect adapters remain
/// replaceable and tests never need platform channels (specs 02 and 11).
abstract interface class HealthHub {
  Future<HealthPermissionState> permissionState();
  Future<HealthPermissionState> requestPermissions();
  Future<HealthReadBatch> readChanges({
    required DateTime startUtc,
    required DateTime endUtc,
    String? changesToken,
  });
}

class FakeHealthHub implements HealthHub {
  FakeHealthHub({
    this.permission = HealthPermissionState.granted,
    List<HealthMinuteRecord> records = const [],
  }) : _records = List.of(records);

  HealthPermissionState permission;
  final List<HealthMinuteRecord> _records;
  int reads = 0;

  /// The token handed to the most recent read, so a test can prove the caller
  /// resumed from where the last sync stopped.
  String? lastChangesToken;

  void add(HealthMinuteRecord record) => _records.add(record);

  @override
  Future<HealthPermissionState> permissionState() async => permission;

  @override
  Future<HealthPermissionState> requestPermissions() async => permission;

  @override
  Future<HealthReadBatch> readChanges({
    required DateTime startUtc,
    required DateTime endUtc,
    String? changesToken,
  }) async {
    reads++;
    lastChangesToken = changesToken;
    return HealthReadBatch(
      records: _records
          .where((r) =>
              !r.minuteUtc.isBefore(startUtc) && r.minuteUtc.isBefore(endUtc))
          .toList(growable: false),
      nextChangesToken: 'fake-$reads',
    );
  }
}
