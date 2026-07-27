# Current state

Last reassessed: 27 July 2026

## Product shape

The application now has two primary destinations:

1. **Aether** — guidance, compact Pulse state, Journal, daily health numbers,
   engraved balance scales, hourly timeline, patterns, Vessel, and Arcana.
2. **The Sanctum** — profile, appearance and guidance mode, health
   permissions, sensor pairing/forgetting, and account controls.

The former standalone Log, Balance, and Timeline destinations have been
absorbed into Aether. Manual activity accepts duration and user/device-supplied
active energy; the old fixed calorie table is gone.

## Data and privacy

- Drift/SQLite is the canonical local store.
- Schema version 18 contains health aggregates, nutrition/activity/lifestyle
  data, Journal entries, and birth-input-keyed Vessel readings.
- Journal prose stays local. Only the explicit classification request sends
  prose to the configured AI transport.
- Health evidence and deterministic calculations remain authoritative.
- Pattern summaries are descriptive and marked non-causal.
- Firestore rules are owner-only, schema-validating, and default-deny.

## Journal

- Typed and on-device speech transcription.
- One bounded classification call per entry.
- Validated segment types: food, activity, strength, mood, stress, recovery,
  sleep, and note.
- Canonical writes are transactional; transient classification failures remain
  retryable.
- Strength segments can request set/repetition/load details.

## Symbolic system

- Grounded, Balanced, and Immersive modes scale symbolic content and AI
  instructions.
- Natal-chart calculation and life-path calculation are deterministic.
- The Vessel is cached by a deterministic birth-input hash.
- The Vessel UI uses two layered slots:
  - life-path Major Arcana floating over a Moon field;
  - sun-sign Golden Dawn Arcana floating over a Sun field.
- All 22 Major Arcana have paired Dawn/Night static production masters.
- Existing motion coverage remains partial and falls back to static art.

## Firebase

- Project: `eter-39165`
- Android package: `com.eterhealth.eter`
- Configured services: Firebase Authentication, Firestore, Firebase AI Logic.
- Android debug and beta signing fingerprints are registered.
- Runtime identifiers are supplied through ignored Dart defines in
  `app/tool/run-configured.ps1`.
- Console-only outstanding work: confirm Google sign-in end to end and register,
  observe, then enforce App Check.

## Verification snapshot

- Flutter tests: 109 passing.
- Static analysis: clean.
- Populated database migration from schema 16 is covered.
- Journal protocol, privacy boundary, Vessel cache, Arcana mapping, asset paths,
  visual atlas, health aggregation, and pattern behavior are covered.
- Android release APK and AAB build successfully with the beta signing key.

## Known risks

- Firebase App Check is not yet enforced.
- Google sign-in still needs a real-account/device acceptance pass.
- Background Health Connect execution has not been observed on physical
  hardware.
- iOS HealthKit, signing, and Core Haptics require a macOS/Xcode device pass.
- Several existing Arcana videos need regeneration or additional device review.
- Flutter reports a future Kotlin Gradle Plugin migration warning for several
  plugins.
- Release build reports that Cupertino icon glyphs are referenced without a
  bundled Cupertino icon font; audit or remove those references.

