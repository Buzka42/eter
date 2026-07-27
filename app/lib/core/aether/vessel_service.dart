import 'dart:convert';

import '../db/app_database.dart';
import '../profile.dart';
import '../symbolic/natal_chart.dart';
import 'ai_contract.dart';
import 'guidance.dart';
import 'vessel.dart';

class VesselService {
  const VesselService({
    required this.database,
    required this.client,
  });

  final AppDatabase database;
  final AetherClient client;

  Future<VesselReading> readingFor(Profile profile) async {
    if (!profile.hasCompleteBirthChartInput) {
      throw StateError('Complete birth data is required for The Vessel');
    }
    final hash = vesselBirthInputHash(profile);
    final cached = await database.loadVesselReading(hash);
    if (cached != null) return VesselReading.decode(cached.contentJson);

    final minutes = profile.birthTimeMinutes!;
    final chart = NatalChartEngine().calculate(
      NatalInput(
        localDateTime: DateTime(
          profile.dob.year,
          profile.dob.month,
          profile.dob.day,
          minutes ~/ 60,
          minutes % 60,
        ),
        utcOffsetMinutes: profile.birthUtcOffsetMinutes!,
        latitude: profile.birthLatitude!,
        longitude: profile.birthLongitude!,
      ),
    );
    final reading = await client.composeVessel(
      natalChart: chart.toJson(),
      lifePathMatrix: {
        'lifePath': calculateLifePath(profile.dob),
        'birthDateDigits': [
          for (final value
              in '${profile.dob.year}${profile.dob.month.toString().padLeft(2, '0')}${profile.dob.day.toString().padLeft(2, '0')}'
                  .split(''))
            int.parse(value),
        ],
      },
    );
    await database.saveVesselReading(
      inputHash: hash,
      contentJson: reading.encode(),
      model: reading.model,
    );
    return reading;
  }
}

String vesselBirthInputHash(Profile profile) {
  final input = [
    profile.dob.toIso8601String(),
    profile.birthTimeMinutes,
    profile.birthUtcOffsetMinutes,
    profile.birthPlace,
    profile.birthLatitude,
    profile.birthLongitude,
  ].join('|');
  var hash = 0xcbf29ce484222325;
  for (final byte in utf8.encode(input)) {
    hash ^= byte;
    hash = (hash * 0x100000001b3) & 0x7fffffffffffffff;
  }
  return hash.toRadixString(16).padLeft(16, '0');
}
