# Development and testing

## Requirements

- Flutter compatible with Dart `>=3.6.0 <4.0.0`
- Android SDK with API 36 tooling for the current Android build
- Java 17
- Firebase CLI only for Firebase administration and rule deployment

## Local setup

```powershell
cd app
flutter pub get
flutter test
flutter analyze lib test
```

Configured Firebase runs use the ignored helper:

```powershell
./tool/run-configured.ps1
```

Do not commit `tool/run-configured.ps1`, `android/key.properties`, keystores, or
platform service configuration containing private identifiers.

## Build commands

```powershell
# Configured debug APK
./tool/run-configured.ps1 -BuildOnly

# Signed configured release APK
./tool/run-configured.ps1 -Release

# Signed configured Play bundle
./tool/run-configured.ps1 -Bundle
```

## Test expectations

Before a release:

1. Run the complete Flutter test suite.
2. Run static analysis over `lib` and `test`.
3. Regenerate goldens only for intentional UI changes, then inspect them.
4. Verify every runtime asset path.
5. Build both release APK and AAB.
6. Verify APK signing certificates and schemes.
7. Perform required physical-device acceptance from `BUILD_PLAN.md`.

## Generated art

Runtime card art is WebP under `app/assets/art/cards/`. Lossless PNG generation
masters are retained under `app/assets/art/masters/` and are not declared as
Flutter assets. Planetary Vessel backgrounds live under
`app/assets/art/vessel/`.

Static fallback is mandatory. Animation files must never be the only rendering
path, and reduced-motion settings must disable ambient movement.

