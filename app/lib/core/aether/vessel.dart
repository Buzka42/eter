import 'dart:convert';

import 'ai_contract.dart';

class VesselPassage {
  const VesselPassage({
    required this.key,
    required this.title,
    required this.reading,
  });

  final String key;
  final String title;
  final String reading;

  factory VesselPassage.fromJson(Map<String, Object?> json) => VesselPassage(
        key: _boundedString(json, 'key', 60),
        title: _boundedString(json, 'title', 100),
        reading: _boundedString(json, 'reading', 1200),
      );

  Map<String, Object?> toJson() =>
      {'key': key, 'title': title, 'reading': reading};
}

class VesselReading {
  const VesselReading({
    required this.passages,
    required this.synthesis,
    required this.model,
  });

  final List<VesselPassage> passages;
  final String synthesis;
  final String model;

  factory VesselReading.fromJson(Map<String, Object?> json) {
    if (json['schemaVersion'] != 1) {
      throw const AetherProtocolException('Unsupported Vessel schema');
    }
    final raw = json['passages'];
    if (raw is! List || raw.length < 8 || raw.length > 24) {
      throw const AetherProtocolException(
        'The Vessel requires 8–24 passages',
      );
    }
    return VesselReading(
      passages: raw
          .map((item) => VesselPassage.fromJson(
                Map<String, Object?>.from(item as Map),
              ))
          .toList(growable: false),
      synthesis: _boundedString(json, 'synthesis', 2400),
      model: _boundedString(json, 'model', 200),
    );
  }

  String encode() => jsonEncode({
        'schemaVersion': 1,
        'passages': passages.map((item) => item.toJson()).toList(),
        'synthesis': synthesis,
        'model': model,
      });

  factory VesselReading.decode(String encoded) =>
      VesselReading.fromJson(Map<String, Object?>.from(jsonDecode(encoded)));
}

String _boundedString(
  Map<String, Object?> json,
  String key,
  int maximum,
) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty || value.length > maximum) {
    throw AetherProtocolException('Invalid Vessel $key');
  }
  return value.trim();
}
