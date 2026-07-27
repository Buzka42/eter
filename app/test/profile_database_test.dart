import 'package:drift/native.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:eter/core/energy/energy.dart';
import 'package:eter/core/profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('profile and settings survive a Drift round trip', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final original = Profile(
      dob: DateTime(1990, 8, 1),
      sex: Sex.male,
      weightKg: 80,
      heightCm: 180,
      hapticsEnabled: false,
      connectedSources: const {'Polar', 'Health hub'},
    );

    await database.saveProfile(original);
    final restored = await database.loadProfile();

    expect(restored, isNotNull);
    expect(restored!.dob, DateTime(1990, 8, 1));
    expect(restored.sex, Sex.male);
    expect(restored.weightKg, 80);
    expect(restored.heightCm, 180);
    expect(restored.hapticsEnabled, isFalse);
    expect(restored.flashEnabled, isTrue);
    expect(restored.connectedSources, {'Health hub', 'Polar'});
    expect(restored.rmr, greaterThan(1600));
  });

  test('saving again updates the singleton profile', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.saveProfile(Profile(
      dob: DateTime(1990, 8, 1),
      sex: Sex.male,
      weightKg: 80,
    ));
    await database.saveProfile(Profile(
      dob: DateTime(1990, 8, 1),
      sex: Sex.male,
      weightKg: 82,
    ));

    expect((await database.loadProfile())!.weightKg, 82);
    expect(await database.select(database.profiles).get().then((v) => v.length),
        1);
  });

  test('remembered heart-rate sensors can be restored and forgotten', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await database.rememberSensor(
      deviceId: 'AA:BB:CC:DD:EE:FF',
      name: 'Garmin HR',
      paired: true,
    );
    final restored = await database.getRememberedSensors();
    expect(restored, hasLength(1));
    expect(restored.single.name, 'Garmin HR');
    expect(restored.single.paired, isTrue);

    await database.forgetSensor(restored.single.deviceId);
    expect(await database.getRememberedSensors(), isEmpty);
  });
}
