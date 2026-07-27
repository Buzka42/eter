# Build plan

This plan replaces the historical milestone and phase documents. Work is
ordered by release risk rather than by screen.

## Release definition

The next candidate is ready for broader beta when authentication, App Check,
background health sync, and privacy behavior have been demonstrated on real
devices and no critical accessibility or performance issue remains.

## P0 — release blockers

### 1. Firebase trust boundary

- Complete Google sign-in on an Android device using the beta certificate.
- Register an App Check debug token, inspect valid traffic, then enable Play
  Integrity for beta builds.
- Enforce App Check for Firebase AI Logic only after valid beta traffic is
  visible.
- Re-audit and emulator-test Firestore rules before external distribution.

Acceptance:

- Sign-in succeeds after reinstall and upgrade.
- Invalid App Check requests fail; valid beta builds continue to classify
  Journal entries and compose guidance.
- One account cannot read or write another account's documents.

### 2. Physical-device health reliability

- Observe Health Connect foreground import and background worker execution.
- Verify denial, partial permission, revoked permission, and no-provider paths.
- Confirm deduplication and day-boundary behavior across timezone changes.
- Complete Play Console justification for background health permission.

Acceptance:

- A scheduled background job is witnessed and logged on hardware.
- Replaying the same records does not change totals.
- Revoking access leaves the app usable and does not create misleading data.

### 3. Release privacy and failure behavior

- Verify Journal prose never enters Firestore, analytics, crash reports, pattern
  synthesis payloads, or non-classification AI calls.
- Exercise offline, timeout, invalid-schema, quota, and auth-expired paths.
- Add a user-facing local Journal retention/delete control.
- Review copy so symbolic language never implies diagnosis, certainty, or fate.

Acceptance:

- Automated privacy tests cover every AI task.
- The app remains usable offline and preserves retryable local work.
- Account deletion and local-data deletion have clear, separately confirmed
  effects.

## P1 — beta quality

### 4. Vessel interaction and motion

- Add deliberate tap/focus behavior for each layered slot.
- Present the selected card and its reading without expanding the full dashboard
  excessively.
- Animate foreground cards independently from stationary backgrounds.
- Respect reduced motion and retain static fallback for every card.
- Regenerate missing/failed loops only after the static interaction is approved.

Acceptance:

- All life-path values and zodiac signs select the correct card.
- No card animation shifts or scales its background field.
- Reduced-motion mode performs no ambient card movement.

### 5. Accessibility and layout

- Test dynamic type, screen reader order, contrast, switch access, and 320–600dp
  widths.
- Fix release warning for Cupertino icon font references.
- Confirm Journal editing, strength detail, sensor pairing, and layered Vessel
  cards are usable without gestures alone.

Acceptance:

- No clipped essential content at 200% text scale.
- Every control has a meaningful accessible label and focus order.

### 6. Performance and package size

- Profile cold start, first Aether render, Drift migration, and image decode on a
  mid-range physical Android device.
- Produce Play delivery estimates from the AAB.
- Decide whether lossless card masters remain outside packaging and whether
  additional WebP tuning is worthwhile.
- Migrate affected plugins to Android's built-in Kotlin support when upstream
  versions permit.

Acceptance:

- No sustained jank during dashboard scroll or card reveal.
- Store-delivered size and startup metrics are recorded for the release.

## P2 — platform completion

### 7. iOS

- Configure the Firebase iOS app and `GoogleService-Info.plist`.
- Complete Apple sign-in capability and provider setup.
- Verify HealthKit permissions/import on hardware.
- Implement and test native Core Haptics patterns.
- Build and archive using a controlled signing configuration.

### 8. Wearable expansion

- Keep the canonical health pipeline independent of vendor APIs.
- Add Garmin, Fitbit, Polar, or Huawei only after sandbox access and a concrete
  product need.
- Require provenance, deduplication, revocation, and privacy review per source.

## Working rules

- Drift remains the local source of truth.
- Journal prose is local-only except during explicit classification.
- Deterministic health and chart calculations are never replaced by generative
  output.
- AI responses must be schema-validated and bounded.
- Symbolic content scales with guidance mode and remains non-diagnostic.
- A release cannot be called complete solely because tests pass; required
  physical-device observations must be recorded.

