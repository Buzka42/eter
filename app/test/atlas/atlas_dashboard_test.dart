import 'package:drift/native.dart';
import 'package:eter/core/aether/guidance_mode.dart';
import 'package:eter/core/clock.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:eter/core/energy/energy.dart';
import 'package:eter/core/profile.dart';
import 'package:eter/core/register.dart';
import 'package:eter/core/theme.dart';
import 'package:eter/features/aether/aether_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Captures the Aether dashboard — everything below the guidance moment.
/// `atlas_test.dart` only ever records first viewports, so the folded-in
/// gauges, the hero card and the pattern rows were invisible to review.
/// Regenerate with:
///   flutter test test/atlas/atlas_dashboard_test.dart --update-goldens
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

  final todayAt14 = () {
    final t = DateTime.now();
    return DateTime(t.year, t.month, t.day, 14);
  }();

  Future<void> capture(WidgetTester tester, GuidanceMode mode) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final register = EterRegister.fromGuidanceMode(mode);
    final night = register != EterRegister.grounded;
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await db.addNutritionEntry(
        kcal: 420, meal: 'Skyr with berries and oats', recordedAt: todayAt14);
    await db.savePatternCandidate(
      key: 'sleep-steps',
      summary: 'Days with over 7 h of sleep average 1,900 more steps.',
      evidence: const {'windowDays': 14, 'samples': 11},
      confidence: 0.72,
    );

    Widget app() => ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            initialProfileProvider.overrideWithValue(Profile(
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
            )),
            nowProvider.overrideWithValue(() => todayAt14),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: EterTheme.day(),
            darkTheme: EterTheme.night(),
            themeMode: night ? ThemeMode.dark : ThemeMode.light,
            home: EterRegisterScope(
              register: register,
              child: Scaffold(body: AetherScreen(onOpenFeatures: () {})),
            ),
          ),
        );

    // Warm-up pass so bundled artwork resolves off the real event loop; its
    // frames are discarded. Same reasoning as atlas_test.dart.
    await tester.pumpWidget(app());
    await tester.pump();
    final cache = PaintingBinding.instance.imageCache;
    for (var attempt = 0; attempt < 40; attempt++) {
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump();
      if (cache.pendingImageCount == 0 && attempt >= 2) break;
    }
    await tester.pumpWidget(const SizedBox());
    await tester.pump();

    await tester.pumpWidget(app());
    await tester.pump();
    await tester.pump(const Duration(seconds: 12));

    await tester.drag(
        find.byType(SingleChildScrollView).first, const Offset(0, -844));
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 3));

    tester.takeException();
    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/dashboard_${mode.name}.png'));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('atlas: dashboard (immersive)',
      (tester) => capture(tester, GuidanceMode.immersive));

  testWidgets('atlas: dashboard (grounded)',
      (tester) => capture(tester, GuidanceMode.grounded));
}
