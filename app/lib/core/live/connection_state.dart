enum SensorConnectionPhase {
  bluetoothOff,
  idle,
  searching,
  connecting,
  connected,
  receiving,
  stale,
  disconnected,
  reconnecting,
  failed,
}

class ReconnectPolicy {
  const ReconnectPolicy({
    this.maximumAttempts = 5,
    this.initialDelay = const Duration(seconds: 1),
    this.maximumDelay = const Duration(seconds: 16),
  });

  final int maximumAttempts;
  final Duration initialDelay;
  final Duration maximumDelay;

  Duration? delayForAttempt(int attempt) {
    if (attempt < 1 || attempt > maximumAttempts) return null;
    final multiplier = 1 << (attempt - 1);
    final milliseconds = initialDelay.inMilliseconds * multiplier;
    return Duration(
      milliseconds: milliseconds.clamp(
        initialDelay.inMilliseconds,
        maximumDelay.inMilliseconds,
      ),
    );
  }
}

extension SensorConnectionPhaseCopy on SensorConnectionPhase {
  String get label => switch (this) {
        SensorConnectionPhase.bluetoothOff => 'Bluetooth off',
        SensorConnectionPhase.idle => 'No sensor selected',
        SensorConnectionPhase.searching => 'Searching',
        SensorConnectionPhase.connecting => 'Connecting',
        SensorConnectionPhase.connected => 'Connected · waiting for data',
        SensorConnectionPhase.receiving => 'Receiving',
        SensorConnectionPhase.stale => 'Connected · signal stale',
        SensorConnectionPhase.disconnected => 'Disconnected',
        SensorConnectionPhase.reconnecting => 'Reconnecting',
        SensorConnectionPhase.failed => 'Connection failed',
      };
}
