import 'package:drift/native.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('nutrition entries persist with source attribution', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final at = DateTime(2026, 7, 23, 13);
    await db.addNutritionEntry(
      kcal: 650,
      meal: 'Lunch',
      proteinG: 32,
      source: 'MyFitnessPal',
      recordedAt: at,
    );
    final row = await db.select(db.nutritionEntries).getSingle();
    expect(row.kcal, 650);
    expect(row.meal, 'Lunch');
    expect(row.proteinG, 32);
    expect(row.source, 'MyFitnessPal');
  });
}
