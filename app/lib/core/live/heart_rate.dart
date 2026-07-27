class HeartRateMeasurement {
  const HeartRateMeasurement({
    required this.bpm,
    this.energyExpended,
    this.rrIntervals = const [],
  });

  final int bpm;
  final int? energyExpended;
  final List<double> rrIntervals;
}

/// Parses Bluetooth SIG Heart Rate Measurement characteristic (0x2A37).
HeartRateMeasurement parseHeartRateMeasurement(List<int> bytes) {
  if (bytes.length < 2) {
    throw const FormatException('Heart-rate packet is too short');
  }
  final flags = bytes[0];
  final uint16 = flags & 0x01 != 0;
  var offset = 1;
  if (uint16 && bytes.length < 3) {
    throw const FormatException('Missing 16-bit heart rate');
  }
  final bpm = uint16 ? bytes[offset] | (bytes[offset + 1] << 8) : bytes[offset];
  offset += uint16 ? 2 : 1;
  final hasContact = flags & 0x04 != 0;
  final contactDetected = flags & 0x02 != 0;
  if (hasContact && !contactDetected) {
    throw const FormatException('Sensor contact is not detected');
  }
  int? energy;
  if (flags & 0x08 != 0) {
    if (bytes.length < offset + 2) {
      throw const FormatException('Missing energy expended value');
    }
    energy = bytes[offset] | (bytes[offset + 1] << 8);
    offset += 2;
  }
  final rr = <double>[];
  if (flags & 0x10 != 0) {
    while (bytes.length >= offset + 2) {
      final raw = bytes[offset] | (bytes[offset + 1] << 8);
      rr.add(raw / 1024);
      offset += 2;
    }
  }
  if (bpm < 20 || bpm > 250) {
    throw FormatException('Implausible heart rate: $bpm');
  }
  return HeartRateMeasurement(
    bpm: bpm,
    energyExpended: energy,
    rrIntervals: rr,
  );
}
