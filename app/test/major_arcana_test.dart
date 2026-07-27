import 'dart:io';

import 'package:eter/core/arcana/major_arcana.dart';
import 'package:eter/core/arcana/zodiac.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('life paths select their own Major Arcana', () {
    expect(MajorArcana.forLifePath(1), MajorArcana.magician);
    expect(MajorArcana.forLifePath(2), MajorArcana.highPriestess);
    expect(MajorArcana.forLifePath(3), MajorArcana.empress);
    expect(MajorArcana.forLifePath(11), MajorArcana.justice);
    expect(MajorArcana.forLifePath(22), MajorArcana.fool);
  });

  test('every zodiac sign preserves its Golden Dawn correspondence', () {
    expect(MajorArcana.forZodiac(Zodiac.aries), MajorArcana.emperor);
    expect(MajorArcana.forZodiac(Zodiac.cancer), MajorArcana.chariot);
    expect(MajorArcana.forZodiac(Zodiac.scorpio), MajorArcana.death);
    expect(MajorArcana.forZodiac(Zodiac.pisces), MajorArcana.moon);
  });

  test('the catalog covers the complete Major Arcana', () {
    expect(MajorArcana.values, hasLength(22));
    expect(
      MajorArcana.values.map((card) => card.number).toSet(),
      Set<int>.from(List<int>.generate(22, (index) => index)),
    );
  });

  test('every Major Arcana has a light and dark production master', () {
    for (final card in MajorArcana.values) {
      expect(card.hasProductionArt, isTrue, reason: card.title);
      expect(File(card.assetFor(Brightness.light)).existsSync(), isTrue,
          reason: '${card.title} light');
      expect(File(card.assetFor(Brightness.dark)).existsSync(), isTrue,
          reason: '${card.title} dark');
    }
  });
}
