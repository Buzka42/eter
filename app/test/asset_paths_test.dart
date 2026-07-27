import 'dart:io';

import 'package:eter/core/arcana/zodiac.dart' as arcana;
import 'package:eter/core/arcana/zodiac.dart' show Zodiac;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Asset paths that the app builds at runtime cannot be found by searching the
/// source for literals, so changing an image's format or name can leave a
/// broken reference that only shows up as an error box on a device. These
/// check that every path the app can construct resolves to a real file.
void main() {
  File assetFile(String path) => File('${Directory.current.path}/$path');

  group('Constructed asset paths resolve', () {
    test('every Arcana card exists in both themes', () {
      for (final zodiac in Zodiac.values) {
        for (final brightness in Brightness.values) {
          final path = zodiac.cardAssetFor(brightness);
          expect(assetFile(path).existsSync(), isTrue,
              reason: '$path is missing for ${zodiac.name}');
        }
      }
    });

    test('every element medallion exists', () {
      for (final element in arcana.Element.values) {
        final path = element.medallionAsset;
        expect(assetFile(path).existsSync(), isTrue,
            reason: '$path is missing');
      }
    });

    test('both sky backgrounds exist', () {
      // Mirrors the interpolation in theme.dart, which is the reference that
      // broke when the backgrounds became WebP.
      for (final night in [true, false]) {
        final path = 'assets/art/bg-air-${night ? 'dark-v3' : 'light-v5'}.webp';
        expect(assetFile(path).existsSync(), isTrue,
            reason: '$path is missing');
      }
    });

    test('every bundled Arcana motion loop exists', () {
      for (final zodiac in Zodiac.values) {
        final path = 'assets/art/animations/${zodiac.assetSlug}-dark.mp4';
        expect(assetFile(path).existsSync(), isTrue,
            reason: '$path is missing');
      }
    });
  });

  test('every asset declared in pubspec exists', () {
    final pubspec =
        File('${Directory.current.path}/pubspec.yaml').readAsLinesSync();
    final start = pubspec.indexWhere((line) => line.trim() == 'assets:');
    expect(start, greaterThan(-1), reason: 'pubspec declares no assets');

    final declared = <String>[];
    for (final line in pubspec.skip(start + 1)) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
      if (!trimmed.startsWith('- ')) break;
      declared.add(trimmed.substring(2).trim());
    }
    expect(declared, isNotEmpty);

    for (final entry in declared) {
      final path = '${Directory.current.path}/$entry';
      final exists = entry.endsWith('/')
          ? Directory(path).existsSync()
          : File(path).existsSync();
      expect(exists, isTrue, reason: '$entry is declared but missing');
    }
  });

  test('no PNG master is bundled alongside its WebP replacement', () {
    // The masters live in an undeclared directory on purpose. A stray PNG next
    // to a bundled WebP would ship both copies and undo the size saving.
    final bundled = Directory('${Directory.current.path}/assets/art/cards');
    final strays = bundled
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.png'))
        .map((file) => file.uri.pathSegments.last)
        .toList();
    expect(strays, isEmpty, reason: 'PNG masters belong in assets/art/masters');
  });
}
