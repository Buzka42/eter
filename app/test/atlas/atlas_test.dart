import 'package:drift/native.dart';
import 'package:eter/core/aether/guidance_mode.dart';
import 'package:eter/core/aether/ai_contract.dart';
import 'package:eter/core/aether/journal.dart';
import 'package:eter/core/arcana/animated_arcana_card.dart';
import 'package:eter/core/arcana/zodiac.dart';
import 'package:eter/core/arcana/zodiac.dart' as arcana;
import 'package:eter/core/clock.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:eter/core/energy/energy.dart';
import 'package:eter/core/profile.dart';
import 'package:eter/core/register.dart';
import 'package:eter/core/theme.dart';
import 'package:eter/core/tokens.dart';
import 'package:eter/core/widgets.dart';
import 'package:eter/features/aether/aether_screen.dart';
import 'package:eter/features/aether/journal_composer.dart';
import 'package:eter/features/aether/main_sections.dart';
import 'package:eter/features/aether/vessel_section.dart';
import 'package:eter/features/live/live_screen.dart';
import 'package:eter/features/onboarding/onboarding_screen.dart';
import 'package:eter/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// UI atlas capture harness (Phase 2, stage 12).
///
/// Renders every primary surface against reproducible in-memory fixture data
/// at a phone viewport in both themes and writes golden PNGs that double as
/// the pre/post redesign atlas. Regenerate with:
///   flutter test test/atlas/atlas_test.dart --update-goldens
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Future<void> family(String name, List<String> assets) {
      final loader = FontLoader(name);
      for (final asset in assets) {
        loader.addFont(rootBundle.load(asset));
      }
      return loader.load();
    }

    await Future.wait([
      family('Cormorant Garamond', const [
        'assets/fonts/CormorantGaramond-Light.ttf',
        'assets/fonts/CormorantGaramond-Regular.ttf',
        'assets/fonts/CormorantGaramond-Medium.ttf',
        'assets/fonts/CormorantGaramond-Italic.ttf',
        'assets/fonts/CormorantGaramond-MediumItalic.ttf',
      ]),
      family('Inter', const [
        'assets/fonts/Inter-Regular.ttf',
        'assets/fonts/Inter-Medium.ttf',
        'assets/fonts/Inter-SemiBold.ttf',
        'assets/fonts/Inter-Bold.ttf',
        'assets/fonts/Inter-ExtraBold.ttf',
      ]),
    ]);
  });

  // A fixed instant today: stable within a run and across reruns, while the
  // surfaces still show a plausible mid-afternoon state.
  final todayAt14 = () {
    final t = DateTime.now();
    return DateTime(t.year, t.month, t.day, 14);
  }();

  Profile fixtureProfile({GuidanceMode mode = GuidanceMode.balanced}) =>
      Profile(
        dob: DateTime(1990, 8, 1, 9, 42),
        sex: Sex.female,
        weightKg: 68,
        heightCm: 172,
        firstName: 'Atlas',
        nutritionEnabled: true,
        guidanceMode: mode,
        birthTimeMinutes: 9 * 60 + 42,
        birthUtcOffsetMinutes: 120,
        birthPlace: 'Krakow, Poland',
        birthLatitude: 50.0647,
        birthLongitude: 19.9450,
      );

  Future<AppDatabase> seedDatabase() async {
    final database = AppDatabase(NativeDatabase.memory());
    // Fixed clock times, not offsets from the current instant. Surfaces that
    // render relative timestamps drew a different string on every run, so
    // captures drifted by a few pixels between one run and the next.
    final now = todayAt14;
    await database.addWeightEntry(
        kg: 68.4, recordedAt: now.subtract(const Duration(days: 2)));
    await database.addWeightEntry(
        kg: 68.0, recordedAt: now.subtract(const Duration(days: 1)));
    await database.addWeightEntry(kg: 67.8, recordedAt: now);
    await database.addNutritionEntry(
      kcal: 420,
      meal: 'Skyr with berries and oats',
      proteinG: 32,
      carbsG: 44,
      fatG: 9,
      recordedAt: now.subtract(const Duration(hours: 5)),
    );
    await database.addNutritionEntry(
      kcal: 610,
      meal: 'Chicken, rice and salad bowl',
      proteinG: 41,
      carbsG: 58,
      fatG: 18,
      recordedAt: now.subtract(const Duration(hours: 2)),
    );
    await database.recordIntegrationSync(
      vendor: 'health-connect',
      status: 'ok',
      recordsToday: 1240,
    );
    await database.savePatternCandidate(
      key: 'sleep-steps',
      summary: 'Days with over 7 h of sleep average 1,900 more steps.',
      evidence: const {'windowDays': 14, 'samples': 11},
      confidence: 0.72,
    );
    return database;
  }

  /// Section widgets own no horizontal padding; in-app the dashboard's gutter
  /// provides it (aether_screen.dart). Capturing them bare rendered content
  /// clipped at the screen edge that never occurs on device, so section
  /// captures are wrapped in the same gutter.
  Widget inGutter(Widget child) => Scaffold(
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: EterSpace.gutter),
          child: child,
        ),
      );

  Future<void> capture(
    WidgetTester tester,
    String name,
    Widget screen, {
    Profile? profile,
    AppDatabase? database,
    bool seed = true,
    bool settle = false,
    DateTime? now,
  }) async {
    // Mirrors app.dart: the register is installed at the root from the
    // profile's guidance mode, and every surface reads its ornament level
    // from there rather than from Theme.brightness.
    final register = profile == null
        ? EterRegister.immersive
        : EterRegister.fromGuidanceMode(profile.guidanceMode);
    // 390x844 logical at 1x. Software rasterization of backdrop blur is the
    // dominant capture cost, so physical pixels stay minimal; the atlas is
    // for layout/composition review, not pixel-density review.
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final brightness in [Brightness.light, Brightness.dark]) {
      final db = database ??
          (seed ? await seedDatabase() : AppDatabase(NativeDatabase.memory()));
      addTearDown(db.close);
      Widget app() => ProviderScope(
            overrides: [
              databaseProvider.overrideWithValue(db),
              initialProfileProvider.overrideWithValue(profile),
              // Surfaces that derive figures from the time of day render
              // differently one minute later, so the atlas pins the clock.
              nowProvider.overrideWithValue(() => now ?? todayAt14),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: EterTheme.day(),
              darkTheme: EterTheme.night(),
              themeMode: brightness == Brightness.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              // The production shell provides the Scaffold/Material ancestor;
              // the atlas mirrors that context.
              home: EterRegisterScope(
                register: register,
                child: Scaffold(body: screen),
              ),
            ),
          );

      // Asset images decode on the real event loop, which the fake-async zone
      // never flushes, so the surface has to be mounted once in real time for
      // artwork to resolve at all. Doing that inside the captured sequence
      // made every capture depend on how much real time happened to pass:
      // animations advanced by a wall-clock amount that varied run to run, and
      // goldens differed by a few pixels each time. So this pass is a warm-up
      // whose frames are thrown away — it exists only to fill the image cache.
      await tester.pumpWidget(app());
      await tester.pump();
      // Wait on the image cache rather than on a fixed delay. A cold run
      // decodes slower than a warm one, and a guessed duration that is long
      // enough on the second run leaves artwork half-loaded on the first,
      // which is its own source of run-to-run difference.
      final cache = PaintingBinding.instance.imageCache;
      for (var attempt = 0; attempt < 40; attempt++) {
        await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 50)));
        await tester.pump();
        if (cache.pendingImageCount == 0 && attempt >= 2) break;
      }
      await tester.pumpWidget(const SizedBox());
      await tester.pump();

      // The captured pass. Every frame from here is fake time only, so the
      // same input always produces the same picture: artwork resolves straight
      // from the warmed cache without another real-time window.
      await tester.pumpWidget(app());
      await tester.pump();
      for (var i = 0; i < 3; i++) {
        await tester.pump(const Duration(milliseconds: 700));
      }
      // Let any progressive reveal timers run to completion so no timer is
      // pending when the tree is disposed between variants.
      await tester.pump(const Duration(seconds: 12));
      // A single large jump starts an animation whose data only just arrived
      // but does not advance it, so late starters need their own frames to
      // reach an end value.
      for (final step in const [
        Duration(milliseconds: 400),
        Duration(seconds: 1),
        Duration(seconds: 2),
      ]) {
        await tester.pump(step);
      }
      if (settle) await tester.pumpAndSettle(const Duration(seconds: 2));
      final suffix = brightness == Brightness.dark ? 'night' : 'day';
      // Clear anything recorded while pumping first. The atlas records
      // surfaces as they are, so a transient layout defect must not abort
      // capture of the remaining theme variant — but this has to happen
      // before the comparison, not after. Taking the exception afterwards
      // also swallowed golden mismatches, which left the whole atlas unable
      // to fail: every capture passed no matter what it rendered.
      tester.takeException();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/${name}_$suffix.png'),
      );
      // Unmount the fixture and flush disposal work: drift schedules a
      // zero-duration close timer when the provider container is disposed,
      // which must fire before the test body ends or the binding fails the
      // run on a pending timer.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    }
  }

  testWidgets('atlas: aether (balanced)', (tester) async {
    await capture(
      tester,
      'aether_balanced',
      AetherScreen(onOpenFeatures: () {}),
      profile: fixtureProfile(),
    );
  });

  testWidgets('atlas: aether (immersive)', (tester) async {
    await capture(
      tester,
      'aether_immersive',
      AetherScreen(onOpenFeatures: () {}),
      profile: fixtureProfile(mode: GuidanceMode.immersive),
    );
  });

  // Q1 gives the opening two states. The fixtures above run at 14:00, where
  // the reading is demoted beneath the day's state line; this one runs before
  // the 11:00 threshold, where the reading still leads.
  testWidgets('atlas: aether (morning)', (tester) async {
    await capture(
      tester,
      'aether_morning',
      AetherScreen(onOpenFeatures: () {}),
      profile: fixtureProfile(mode: GuidanceMode.immersive),
      now: DateTime(todayAt14.year, todayAt14.month, todayAt14.day, 8),
    );
  });

  testWidgets('atlas: aether (grounded)', (tester) async {
    await capture(
      tester,
      'aether_grounded',
      AetherScreen(onOpenFeatures: () {}),
      profile: fixtureProfile(mode: GuidanceMode.grounded),
    );
  });

  testWidgets('atlas: log', (tester) async {
    await capture(
      tester,
      'log',
      inGutter(const JournalComposer()),
      profile: fixtureProfile(),
    );
  });

  testWidgets('atlas: log typing', (tester) async {
    await capture(
      tester,
      'log_typing',
      inGutter(const JournalComposer(
        initiallyExpanded: true,
        initialText: 'Oats, a thirty minute walk, mood four.',
      )),
      profile: fixtureProfile(),
    );
  });

  testWidgets('atlas: log extracted', (tester) async {
    await capture(
      tester,
      'log_extracted',
      inGutter(const JournalComposer(
        initiallyExpanded: true,
        initialMessage: 'Added to today.',
        initialExtraction: JournalExtraction(
          model: 'atlas-fixture',
          schemaVersion: 1,
          segments: [
            FoodJournalSegment(
              confidence: 0.9,
              items: [
                MealItemEstimate(
                  name: 'Oats',
                  portion: 'a bowl',
                  kcal: 320,
                  proteinG: 11,
                  carbsG: 54,
                  fatG: 6,
                ),
              ],
            ),
            ActivityJournalSegment(
              name: 'Walk',
              durationMinutes: 30,
              intensity: 'easy',
              activeKcal: 140,
              confidence: 0.8,
            ),
            RatingJournalSegment(JournalSegmentKind.mood, value: 4),
          ],
        ),
      )),
      profile: fixtureProfile(),
    );
  });

  testWidgets('atlas: log needs detail', (tester) async {
    await capture(
      tester,
      'log_needs_detail',
      inGutter(const JournalComposer(
        initiallyExpanded: true,
        initialMessage: 'Other details saved. Complete the strength sets.',
      )),
      profile: fixtureProfile(),
    );
  });

  testWidgets('atlas: vessel', (tester) async {
    await capture(
      tester,
      'vessel',
      inGutter(const VesselSection(initiallyExpanded: true)),
      profile: fixtureProfile(mode: GuidanceMode.immersive),
    );
  });

  testWidgets('atlas: live', (tester) async {
    await capture(tester, 'live', const LiveScreen(),
        profile: fixtureProfile());
  });

  testWidgets('atlas: balance', (tester) async {
    await capture(tester, 'balance', inGutter(const ScalesSection()),
        profile: fixtureProfile());
  });

  testWidgets('atlas: balance (empty)', (tester) async {
    await capture(tester, 'balance_empty', inGutter(const ScalesSection()),
        profile: fixtureProfile(), seed: false);
  });

  testWidgets('atlas: timeline', (tester) async {
    await capture(tester, 'timeline', inGutter(const TimelineSparkline()),
        profile: fixtureProfile());
  });

  testWidgets('atlas: settings', (tester) async {
    await capture(tester, 'settings', const SettingsScreen(),
        profile: fixtureProfile());
  });

  testWidgets('atlas: onboarding', (tester) async {
    await capture(tester, 'onboarding', const OnboardingScreen(),
        profile: null);
  });

  // The screen captures above wrap each surface in a bare Scaffold and render
  // painted backgrounds, so none of them contain a single bundled bitmap. That
  // let an artwork format change pass the whole atlas byte-for-byte while the
  // app showed an error box on a device. These two capture the artwork itself.

  testWidgets('atlas: arcana card art', (tester) async {
    await capture(
      tester,
      'arcana_card',
      const Center(
        child: SizedBox(
          width: 360,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Back and front together: the card back master and one card
              // master, both of which are bundled images.
              AnimatedArcanaCard(zodiac: Zodiac.aquarius, width: 150),
              AnimatedArcanaCard(
                  zodiac: Zodiac.aquarius, revealed: true, width: 150),
            ],
          ),
        ),
      ),
      profile: fixtureProfile(),
    );
  });

  testWidgets('atlas: sky background', (tester) async {
    await capture(
      tester,
      'sky_background',
      const SkyBackground(
        child: Center(child: ElementMedallion(arcana.Element.air, size: 96)),
      ),
      profile: fixtureProfile(),
    );
  });
}
