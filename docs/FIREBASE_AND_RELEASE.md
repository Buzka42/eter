# Firebase and release operations

## Firebase project

- Project ID: `eter-39165`
- Android package: `com.eterhealth.eter`
- Firestore region: `eur3`
- Enabled product paths: Authentication, Firestore, Firebase AI Logic

Rules deploy from the repository root:

```powershell
npx -y firebase-tools@latest deploy --only firestore:rules,firestore:indexes
```

Review `firestore.rules` before every broad release. Do not assume a successful
deployment proves the policy matches the product's current data model.

## Remaining console work

1. Confirm Google provider configuration and complete real-device sign-in.
2. Register App Check debug traffic.
3. Configure Play Integrity for the beta certificate.
4. Observe valid requests before enabling enforcement.
5. Enforce Firebase AI Logic only after the beta path is verified.

## Current release

Version: `0.2.0+5000`

| Artifact | Size | SHA-256 |
|---|---:|---|
| `artifacts/Eter-0.2.0+5000-release.apk` | 155,494,076 bytes | `2D2C2375C33B968EC4C6CC97C4410B2E4A119FE1F12AD6B89707713872420250` |
| `artifacts/Eter-0.2.0+5000-release.aab` | 158,223,664 bytes | `3891583AECB194E1800FDA6922D4280E6BA819CFB1981D45E9256C0443DEA241` |

APK verification:

- Signature scheme v2: verified
- Signature scheme v3: verified
- Signer: `CN=Eter Beta, OU=Mobile, O=Eter, C=PL`
- Certificate SHA-256:
  `7841D5FD4533552A8877F0222E7192FC0FEE846F3906923A97C5D971D45528DB`

The active artifacts directory contains only this release pair. Previous
distributables are recoverably stored under
`archive/binaries-before-0.2.0/`.

## Release checklist

- Increment `version` in `app/pubspec.yaml`.
- Run tests and analysis.
- Build APK and AAB with the configured helper.
- Verify the APK signature and hashes.
- Install as both clean install and upgrade from the last beta.
- Complete P0 device checks from `BUILD_PLAN.md`.
- Copy only the approved pair into `artifacts/`.
- Archive superseded distributables; do not leave ambiguous “latest” files.

