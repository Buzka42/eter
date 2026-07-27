import 'package:flutter/widgets.dart';

import 'aether/guidance_mode.dart';

/// How much ornament a surface is allowed to carry.
///
/// Guidance mode used to control only the wording of the daily reading, while
/// every surface decided its own ornament from `Theme.brightness`. That let
/// grounded mode still render gold dividers, star ornaments and a companion
/// card, and let immersive mode fall back to plain rules whenever the OS was
/// in light mode. The register makes it one decision, taken once at the root:
///
/// * [grounded] — a plain instrument. Sunny day sky, no gold, no ornament, no
///   card. Always light.
/// * [balanced] — the middle reading. Follows the system theme.
/// * [immersive] — the full mystical register. Astrophotography night sky,
///   gold line-work, the Arcana card as the centre of the surface. Always dark.
enum EterRegister {
  grounded,
  balanced,
  immersive;

  static EterRegister fromGuidanceMode(GuidanceMode mode) => switch (mode) {
        GuidanceMode.grounded => EterRegister.grounded,
        GuidanceMode.balanced => EterRegister.balanced,
        GuidanceMode.immersive => EterRegister.immersive,
      };

  /// Gold hairlines, star ornaments and engraved dividers.
  bool get showsOrnament => this != EterRegister.grounded;

  /// The Arcana card appears at all. Grounded shows the card only at launch
  /// and never again, so every in-app placement is suppressed.
  bool get showsCompanionCard => this != EterRegister.grounded;

  /// The Arcana card is the centre of the surface rather than a companion
  /// beside a heading — full width, revealable, the thing the eye lands on.
  bool get showsHeroCard => this == EterRegister.immersive;

  /// Ambient motion: the drifting air field, the twinkle, the slow reveal.
  bool get showsAmbientMotion => this != EterRegister.grounded;

  /// Roughly the "how mystical, 1–10" dial, for tuning opacities against a
  /// single number rather than scattering per-widget constants.
  double get ornamentIntensity => switch (this) {
        EterRegister.grounded => 0.2,
        EterRegister.balanced => 0.5,
        EterRegister.immersive => 0.7,
      };

  static EterRegister of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<EterRegisterScope>();
    return scope?.register ?? EterRegister.balanced;
  }
}

/// How rich a given surface *wants* to be, independent of the user's setting.
///
/// The register alone could not express the chosen direction — minimal by
/// default, rich on moments — because that decision is per-surface, not
/// per-app: the Log should stay plain even for someone who wants immersion,
/// and the arcana reveal should sing even for someone who wants restraint
/// (§4 C10). Pairing the two makes the register a *ceiling* rather than a
/// level: `grounded` means "even the ritual moments stay quiet", `immersive`
/// means "let them sing", and no setting can make an instrument ornate.
enum SurfaceIntent {
  /// Everyday instruments: the Log, the figures, the Scales, the Timeline,
  /// the Sanctum. Never ornamented, whatever the register.
  plain,

  /// Moments: the opening reading, onboarding, the arcana reveal, the Vessel,
  /// milestones. Ornamented as far as the register permits.
  ritual,
}

/// The intent of the nearest enclosing surface. Defaults to [SurfaceIntent
/// .ritual] so that surfaces which have not been classified keep their
/// existing appearance rather than silently going plain.
SurfaceIntent surfaceIntentOf(BuildContext context) =>
    context.dependOnInheritedWidgetOfExactType<SurfaceIntentScope>()?.intent ??
    SurfaceIntent.ritual;

/// Whether ornament may be drawn here: the register's permission capped by
/// what this surface actually wants. This is the resolver that replaces bare
/// `EterRegister.of(context).showsOrnament` checks.
bool showsOrnamentHere(BuildContext context) =>
    surfaceIntentOf(context) == SurfaceIntent.ritual &&
    EterRegister.of(context).showsOrnament;

/// Declares the intent of everything beneath it.
class SurfaceIntentScope extends InheritedWidget {
  const SurfaceIntentScope({
    super.key,
    required this.intent,
    required super.child,
  });

  final SurfaceIntent intent;

  @override
  bool updateShouldNotify(SurfaceIntentScope oldWidget) =>
      oldWidget.intent != intent;
}

/// Publishes the active [EterRegister] to the whole tree. Installed once, at
/// the root, from the profile's guidance mode.
class EterRegisterScope extends InheritedWidget {
  const EterRegisterScope({
    super.key,
    required this.register,
    required super.child,
  });

  final EterRegister register;

  @override
  bool updateShouldNotify(EterRegisterScope oldWidget) =>
      oldWidget.register != register;
}
