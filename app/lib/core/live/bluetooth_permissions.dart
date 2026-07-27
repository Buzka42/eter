import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:universal_ble/universal_ble.dart';

enum BluetoothPermissionResult {
  granted,
  openedSettings,
  denied,
}

/// Requests the platform permissions required for BLE central mode.
///
/// Android may stop presenting its permission sheet after repeated denial.
/// When that happens, take the user directly to Eter's system settings page
/// rather than leaving them to navigate there manually.
Future<BluetoothPermissionResult> ensureBluetoothPermissions() async {
  if (!Platform.isAndroid) {
    await UniversalBle.requestPermissions();
    return BluetoothPermissionResult.granted;
  }

  final currentScan = await Permission.bluetoothScan.status;
  final currentConnect = await Permission.bluetoothConnect.status;
  if (currentScan.isGranted && currentConnect.isGranted) {
    return BluetoothPermissionResult.granted;
  }

  final results = await <Permission>[
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
  ].request();
  final scan = results[Permission.bluetoothScan];
  final connect = results[Permission.bluetoothConnect];
  if ((scan?.isGranted ?? false) && (connect?.isGranted ?? false)) {
    return BluetoothPermissionResult.granted;
  }

  final opened = await openAppSettings();
  return opened
      ? BluetoothPermissionResult.openedSettings
      : BluetoothPermissionResult.denied;
}
