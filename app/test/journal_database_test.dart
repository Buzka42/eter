import 'dart:io';

import 'package:drift/native.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('journal row persists and extraction state updates', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final id = await db.addJournalEntry(
      text: 'Porridge, a walk, and I felt calm.',
      source: 'typed',
      createdAt: DateTime.utc(2026, 7, 27, 7),
    );
    await db.saveJournalExtraction(
      id: id,
      status: 'classified',
      extractionJson: '{"segments":[]}',
      model: 'fixture',
      appliedAt: DateTime.utc(2026, 7, 27, 7, 1),
    );

    final row = await db.select(db.journalEntries).getSingle();
    expect(row.entryText, contains('Porridge'));
    expect(row.status, 'classified');
    expect(row.model, 'fixture');
    expect(row.appliedAt, isNotNull);
  });

  test('pending entries are returned oldest first', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await db.addJournalEntry(
      text: 'second',
      createdAt: DateTime.utc(2026, 7, 27, 9),
    );
    await db.addJournalEntry(
      text: 'first',
      createdAt: DateTime.utc(2026, 7, 27, 8),
    );

    final rows = await db.pendingJournalEntries();
    expect(rows.map((row) => row.entryText), ['first', 'second']);
  });

  test('populated v16 database migrates without losing existing data',
      () async {
    final directory = await Directory.systemTemp.createTemp('eter-v16-');
    addTearDown(() async {
      if (directory.existsSync()) {
        await directory.delete(recursive: true);
      }
    });
    final file = File('${directory.path}${Platform.pathSeparator}eter.sqlite');

    final fixture = AppDatabase(NativeDatabase(file));
    await fixture.customStatement(
      'CREATE TABLE migration_fixture (id INTEGER PRIMARY KEY, value TEXT NOT NULL)',
    );
    await fixture.customStatement(
      "INSERT INTO migration_fixture (id, value) VALUES (1, 'preserved')",
    );
    await fixture.customStatement('DROP TABLE journal_entries');
    await fixture.customStatement('DROP TABLE vessel_readings');
    await fixture.customStatement('PRAGMA user_version = 16');
    await fixture.close();

    final migrated = AppDatabase(NativeDatabase(file));
    addTearDown(migrated.close);
    final preserved = await migrated
        .customSelect('SELECT value FROM migration_fixture WHERE id = 1')
        .getSingle();
    expect(preserved.read<String>('value'), 'preserved');

    await migrated.addJournalEntry(
      text: 'The migrated journal is writable.',
      createdAt: DateTime.utc(2026, 7, 27),
    );
    expect(await migrated.select(migrated.journalEntries).get(), hasLength(1));
  });
}
