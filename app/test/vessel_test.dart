import 'package:drift/native.dart';
import 'package:eter/core/aether/vessel.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Vessel response is bounded and round-trips', () {
    final reading = VesselReading.fromJson({
      'schemaVersion': 1,
      'passages': [
        for (var index = 0; index < 8; index++)
          {
            'key': 'position-$index',
            'title': 'Position $index',
            'reading': 'A reflective, non-fated passage.',
          },
      ],
      'synthesis': 'A closing synthesis.',
      'model': 'fixture',
    });

    expect(VesselReading.decode(reading.encode()).passages, hasLength(8));
  });

  test('Vessel reading is stored once by birth-input hash', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await db.saveVesselReading(
      inputHash: 'birth-hash',
      contentJson: '{"content":"fixture"}',
      model: 'fixture',
    );
    await db.saveVesselReading(
      inputHash: 'birth-hash',
      contentJson: '{"content":"same-input"}',
      model: 'fixture-2',
    );

    expect(await db.select(db.vesselReadings).get(), hasLength(1));
    expect(
      (await db.loadVesselReading('birth-hash'))?.model,
      'fixture-2',
    );
  });
}
