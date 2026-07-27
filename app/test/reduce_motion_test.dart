import 'package:drift/native.dart';
import 'package:eter/core/aether/guidance_mode.dart';
import 'package:eter/core/arcana/animated_arcana_card.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:eter/core/energy/energy.dart';
import 'package:eter/core/profile.dart';
import 'package:eter/core/register.dart';
import 'package:eter/core/theme.dart';
import 'package:eter/features/aether/vessel_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Calm Mode is the OS "remove animations" setting, and every looping surface
/// has to opt out of its own motion — nothing central enforces it. A golden
/// cannot catch a regression here, because video never plays in a widget test
/// either way, so the guarantee is asserted directly: under
/// `disableAnimations` no card is handed a video to play (§5.14).
void main() {
  Profile profile() => Profile(
        dob: DateTime(1990, 8, 1, 9, 42),
        sex: Sex.female,
        weightKg: 68,
        heightCm: 172,
        firstName: 'Atlas',
        nutritionEnabled: true,
        guidanceMode: GuidanceMode.immersive,
      );

  Future<void> pumpVessel(
    WidgetTester tester, {
    required bool reduceMotion,
  }) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          initialProfileProvider.overrideWithValue(profile()),
        ],
        child: MaterialApp(
          darkTheme: EterTheme.night(),
          themeMode: ThemeMode.dark,
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: reduceMotion),
            child: const EterRegisterScope(
              register: EterRegister.immersive,
              child: Scaffold(
                body: SingleChildScrollView(
                  child: VesselSection(initiallyExpanded: true),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  List<ArcanaCardMedia> cards(WidgetTester tester) =>
      tester.widgetList<ArcanaCardMedia>(find.byType(ArcanaCardMedia)).toList();

  testWidgets('Calm Mode plays no card loops in the Vessel', (tester) async {
    await pumpVessel(tester, reduceMotion: true);
    final media = cards(tester);
    expect(media, isNotEmpty, reason: 'the Vessel should render its slots');
    for (final card in media) {
      expect(
        card.videoPath,
        isNull,
        reason: 'a card was handed a loop to play while Calm Mode was on',
      );
    }
  });

  testWidgets('the Vessel does play loops when motion is allowed',
      (tester) async {
    await pumpVessel(tester, reduceMotion: false);
    final media = cards(tester);
    expect(media, isNotEmpty);
    // Guards the test itself: if the slots stopped offering loops at all, the
    // assertion above would pass for the wrong reason.
    expect(
      media.any((card) => card.videoPath != null),
      isTrue,
      reason: 'no slot offered a loop, so the Calm Mode check proves nothing',
    );
  });
}
