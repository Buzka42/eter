import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'arcana/zodiac.dart';
import 'aether/guidance_mode.dart';
import 'db/app_database.dart';
import 'energy/energy.dart';

/// User profile persisted locally via Drift and mirrored to Firestore after
/// authentication. Raw health history remains local.
class Profile {
  const Profile({
    required this.dob,
    required this.sex,
    required this.weightKg,
    this.heightCm,
    this.units = MeasurementUnits.metric,
    this.hapticsEnabled = true,
    this.flashEnabled = true,
    this.nutritionEnabled = false,
    this.connectedSources = const {},
    this.firstName,
    this.guidanceMode = GuidanceMode.immersive,
    this.birthTimeMinutes,
    this.birthUtcOffsetMinutes,
    this.birthPlace,
    this.birthLatitude,
    this.birthLongitude,
  });

  final DateTime dob;
  final Sex sex;
  final double weightKg;
  final double? heightCm; // null → weight-only RMR approximation, spec 05
  final MeasurementUnits units;
  final bool hapticsEnabled;
  final bool flashEnabled;
  final bool nutritionEnabled;
  final Set<String> connectedSources;
  final String? firstName;
  final GuidanceMode guidanceMode;
  final int? birthTimeMinutes;
  final int? birthUtcOffsetMinutes;
  final String? birthPlace;
  final double? birthLatitude;
  final double? birthLongitude;

  bool get hasCompleteBirthChartInput =>
      birthTimeMinutes != null &&
      birthUtcOffsetMinutes != null &&
      birthLatitude != null &&
      birthLongitude != null;

  Zodiac get zodiac => Zodiac.fromDate(dob);

  int get age {
    final now = DateTime.now();
    var a = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      a--;
    }
    return a;
  }

  /// Mifflin-St Jeor; height fallback estimates 170 cm and flags approximate.
  double get rmr => rmrKcalPerDay(
        sex: sex,
        weightKg: weightKg,
        heightCm: heightCm ?? 170,
        age: age,
      );

  bool get rmrIsApproximate => heightCm == null || sex == Sex.unspecified;

  double get restingKcalPerMin => rmrPerMin(rmr);

  Profile copyWith({
    DateTime? dob,
    Sex? sex,
    double? weightKg,
    double? heightCm,
    MeasurementUnits? units,
    bool? hapticsEnabled,
    bool? flashEnabled,
    bool? nutritionEnabled,
    Set<String>? connectedSources,
    String? firstName,
    GuidanceMode? guidanceMode,
    int? birthTimeMinutes,
    int? birthUtcOffsetMinutes,
    String? birthPlace,
    double? birthLatitude,
    double? birthLongitude,
  }) =>
      Profile(
        dob: dob ?? this.dob,
        sex: sex ?? this.sex,
        weightKg: weightKg ?? this.weightKg,
        heightCm: heightCm ?? this.heightCm,
        units: units ?? this.units,
        hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
        flashEnabled: flashEnabled ?? this.flashEnabled,
        nutritionEnabled: nutritionEnabled ?? this.nutritionEnabled,
        connectedSources: connectedSources ?? this.connectedSources,
        firstName: firstName ?? this.firstName,
        guidanceMode: guidanceMode ?? this.guidanceMode,
        birthTimeMinutes: birthTimeMinutes ?? this.birthTimeMinutes,
        birthUtcOffsetMinutes:
            birthUtcOffsetMinutes ?? this.birthUtcOffsetMinutes,
        birthPlace: birthPlace ?? this.birthPlace,
        birthLatitude: birthLatitude ?? this.birthLatitude,
        birthLongitude: birthLongitude ?? this.birthLongitude,
      );
}

enum MeasurementUnits { metric, imperial }

/// null → not onboarded (router redirects to /onboarding).
final profileProvider = NotifierProvider<ProfileNotifier, Profile?>(
  ProfileNotifier.new,
);

final initialProfileProvider = Provider<Profile?>((_) => null);
final databaseProvider =
    Provider<AppDatabase>((_) => throw StateError('Database not initialized'));

/// The user's zodiac element, driving accent color throughout the UI.
/// Falls back to Air before onboarding completes.
final elementProvider = Provider<Element>(
  (ref) => ref.watch(profileProvider)?.zodiac.element ?? Element.air,
);

class ProfileNotifier extends Notifier<Profile?> {
  @override
  Profile? build() => ref.watch(initialProfileProvider);

  void complete(Profile p) {
    state = p;
    ref.read(databaseProvider).saveProfile(p);
  }

  void update(Profile p) {
    state = p;
    ref.read(databaseProvider).saveProfile(p);
  }
}
