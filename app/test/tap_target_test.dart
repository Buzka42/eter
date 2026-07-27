import 'package:drift/native.dart';
import 'package:eter/core/aether/guidance_mode.dart';
import 'package:eter/core/db/app_database.dart';
import 'package:eter/core/energy/energy.dart';
import 'package:eter/core/profile.dart';
import 'package:eter/core/register.dart';
import 'package:eter/core/theme.dart';
import 'package:eter/features/aether/journal_composer.dart';
import 'package:eter/features/aether/main_sections.dart';
import 'package:eter/features/aether/vessel_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The disclosure headers are a caps label beside an 18 px chevron, which laid
/// out at roughly 34 px — comfortably under the 48 px minimum, and easy to
/// reintroduce by adjusting padding. These pin the control heights (§5.14).
void main() {
  const minimum = 48.0;

  Profile profile() => Profile(
        dob: DateTime(1990, 8, 1, 9, 42),
        sex: Sex.female,
        weightKg: 68,
        heightCm: 172,
        firstName: 'Atlas',
        nutritionEnabled: true,
        guidanceMode: GuidanceMode.immersive,
      );

  Future<AppDatabase> pump(WidgetTester tester, Widget section) async {
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
          home: EterRegisterScope(
            register: EterRegister.immersive,
            child: Scaffold(
              body: SingleChildScrollView(child: section),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    return database;
  }

  /// The Timeline watches a Drift stream whose timer outlives the widget tree
  /// and trips the binding's `!timersPending` check. Unmounting the section
  /// disposes the provider and cancels the subscription before teardown runs.
  Future<void> teardown(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  }

  /// Measures the disclosure control itself: the innermost [InkWell] wrapping
  /// the section's caps label. Measuring every [InkWell] on the surface would
  /// also catch ones inside composed widgets that this test does not own.
  void expectHeaderTarget(WidgetTester tester, String caps) {
    final header = find
        .ancestor(of: find.text(caps), matching: find.byType(InkWell))
        .first;
    expect(header, findsOneWidget, reason: '$caps should sit in a tappable row');
    expect(
      tester.getSize(header).height,
      greaterThanOrEqualTo(minimum),
      reason: '$caps has a ${tester.getSize(header).height}px tap target',
    );
  }

  testWidgets('the Log header meets the minimum tap target', (tester) async {
    await pump(tester, const JournalComposer());
    expectHeaderTarget(tester, 'THE LOG');
    await teardown(tester);
  });

  testWidgets('the Timeline header meets the minimum tap target',
      (tester) async {
    await pump(tester, const TimelineSparkline());
    expectHeaderTarget(tester, 'THE TIMELINE');
    await teardown(tester);
  });

  testWidgets('the Vessel header meets the minimum tap target', (tester) async {
    await pump(tester, const VesselSection());
    expectHeaderTarget(tester, 'THE VESSEL');
    await teardown(tester);
  });
}
