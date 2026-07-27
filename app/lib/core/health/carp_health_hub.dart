import 'dart:io';

import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

import 'health_hub.dart';

class CarpHealthHub implements HealthHub {
  CarpHealthHub({Health? client}) : _health = client ?? Health();

  final Health _health;
  bool _configured = false;

  static const _types = [
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
  ];

  Future<void> _configure() async {
    if (_configured) return;
    await _health.configure();
    _configured = true;
  }

  @override
  Future<HealthPermissionState> permissionState() async {
    try {
      await _configure();
      final granted = await _health.hasPermissions(_types);
      if (Platform.isAndroid &&
          !await Permission.activityRecognition.isGranted) {
        return HealthPermissionState.denied;
      }
      return granted == true
          ? HealthPermissionState.granted
          : HealthPermissionState.denied;
    } catch (_) {
      return HealthPermissionState.unavailable;
    }
  }

  @override
  Future<HealthPermissionState> requestPermissions() async {
    try {
      await _configure();
      if (Platform.isAndroid) {
        final activity = await Permission.activityRecognition.request();
        if (!activity.isGranted) return HealthPermissionState.denied;
      }
      final granted = await _health.requestAuthorization(_types);
      return granted
          ? HealthPermissionState.granted
          : HealthPermissionState.denied;
    } catch (_) {
      return HealthPermissionState.unavailable;
    }
  }

  @override
  Future<HealthReadBatch> readChanges({
    required DateTime startUtc,
    required DateTime endUtc,
    String? changesToken,
  }) async {
    await _configure();
    final points = await _health.getHealthDataFromTypes(
      types: _types,
      startTime: startUtc.toLocal(),
      endTime: endUtc.toLocal(),
    );
    final records = <String, _MutableHealthMinute>{};
    for (final point in _health.removeDuplicates(points)) {
      if (point.value is! NumericHealthValue) continue;
      final value = (point.value as NumericHealthValue).numericValue.toDouble();
      final source = point.sourceId.isEmpty ? point.sourceName : point.sourceId;
      final start = _floorMinute(point.dateFrom.toUtc());
      final end = point.dateTo.toUtc();
      final count = end.isAfter(start)
          ? ((end.difference(start).inSeconds + 59) ~/ 60).clamp(1, 1440)
          : 1;
      for (var index = 0; index < count; index++) {
        final minute = start.add(Duration(minutes: index));
        final key = '$source|${minute.toIso8601String()}';
        final record = records.putIfAbsent(
          key,
          () => _MutableHealthMinute(minute: minute, source: source),
        );
        switch (point.type) {
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            record.activeKcal += value / count;
            break;
          case HealthDataType.STEPS:
            final base = value.floor() ~/ count;
            final remainder = value.floor() % count;
            record.steps += base + (index < remainder ? 1 : 0);
            break;
          case HealthDataType.HEART_RATE:
            record.hrTotal += value;
            record.hrSamples++;
            break;
          default:
            break;
        }
      }
    }
    return HealthReadBatch(
      records: records.values
          .map((record) => record.freeze())
          .toList(growable: false),
    );
  }

  DateTime _floorMinute(DateTime value) => DateTime.utc(
        value.year,
        value.month,
        value.day,
        value.hour,
        value.minute,
      );
}

class _MutableHealthMinute {
  _MutableHealthMinute({required this.minute, required this.source});
  final DateTime minute;
  final String source;
  double activeKcal = 0;
  int steps = 0;
  double hrTotal = 0;
  int hrSamples = 0;

  HealthMinuteRecord freeze() => HealthMinuteRecord(
        minuteUtc: minute,
        activeKcal: activeKcal,
        sourceId: source,
        steps: steps == 0 ? null : steps,
        avgHr: hrSamples == 0 ? null : hrTotal / hrSamples,
        hrSampleCount: hrSamples,
      );
}
