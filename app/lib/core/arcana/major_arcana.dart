import 'package:flutter/material.dart';

import 'zodiac.dart';

enum MajorArcana {
  fool(0, 'The Fool', '0', 'the-fool', true, true),
  magician(1, 'The Magician', 'I', 'the-magician', true, true),
  highPriestess(2, 'The High Priestess', 'II', 'the-high-priestess', true, true),
  empress(3, 'The Empress', 'III', 'the-empress', true, true),
  emperor(4, 'The Emperor', 'IV', 'the-emperor', true, true),
  hierophant(5, 'The Hierophant', 'V', 'the-hierophant', true, true),
  lovers(6, 'The Lovers', 'VI', 'the-lovers', true, true),
  chariot(7, 'The Chariot', 'VII', 'the-chariot', true, true),
  strength(8, 'Strength', 'VIII', 'strength', true, true),
  hermit(9, 'The Hermit', 'IX', 'the-hermit', true, true),
  wheelOfFortune(10, 'Wheel of Fortune', 'X', 'wheel-of-fortune', true, true),
  justice(11, 'Justice', 'XI', 'justice', true, true),
  hangedMan(12, 'The Hanged Man', 'XII', 'the-hanged-man', true, true),
  death(13, 'Death', 'XIII', 'death', true, true),
  temperance(14, 'Temperance', 'XIV', 'temperance', true, true),
  devil(15, 'The Devil', 'XV', 'the-devil', true, true),
  tower(16, 'The Tower', 'XVI', 'the-tower', true, true),
  star(17, 'The Star', 'XVII', 'the-star', true, true),
  moon(18, 'The Moon', 'XVIII', 'the-moon', true, true),
  sun(19, 'The Sun', 'XIX', 'the-sun', true, true),
  judgement(20, 'Judgement', 'XX', 'judgement', true, true),
  world(21, 'The World', 'XXI', 'the-world', true, true);

  const MajorArcana(
    this.number,
    this.title,
    this.numeral,
    this.assetSlug,
    this.hasProductionArt,
    this.hasNightLoop,
  );

  final int number;
  final String title;
  final String numeral;
  final String assetSlug;
  final bool hasProductionArt;

  /// Whether an approved Night Sky motion loop ships for this card. Only Night
  /// Sky has loops; Day Sky has none (spec 04, STAGE-15-AUDIT.md). Kept as data
  /// so a card renders static until its loop passes the closure gate.
  final bool hasNightLoop;

  String assetFor(Brightness brightness) => hasProductionArt
      ? 'assets/art/cards/$assetSlug-${brightness == Brightness.dark ? 'dark' : 'light'}.webp'
      : 'assets/art/card-back-v2-${brightness == Brightness.dark ? 'dark' : 'light'}.webp';

  /// Night Sky loop, or null when the card has no approved loop. Callers must
  /// keep rendering [assetFor] underneath: the static art is mandatory and the
  /// loop only ever composites on top (DEVELOPMENT.md).
  String? nightLoopFor(Brightness brightness) =>
      hasNightLoop && brightness == Brightness.dark
          ? 'assets/art/animations/$assetSlug-dark.mp4'
          : null;

  static MajorArcana forLifePath(int lifePath) => switch (lifePath) {
        1 => magician,
        2 => highPriestess,
        3 => empress,
        4 => emperor,
        5 => hierophant,
        6 => lovers,
        7 => chariot,
        8 => strength,
        9 => hermit,
        11 => justice,
        22 => fool,
        _ => throw ArgumentError.value(lifePath, 'lifePath'),
      };

  static MajorArcana forZodiac(Zodiac zodiac) => switch (zodiac) {
        Zodiac.aries => emperor,
        Zodiac.taurus => hierophant,
        Zodiac.gemini => lovers,
        Zodiac.cancer => chariot,
        Zodiac.leo => strength,
        Zodiac.virgo => hermit,
        Zodiac.libra => justice,
        Zodiac.scorpio => death,
        Zodiac.sagittarius => temperance,
        Zodiac.capricorn => devil,
        Zodiac.aquarius => star,
        Zodiac.pisces => moon,
      };
}
