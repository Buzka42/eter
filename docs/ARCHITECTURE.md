# Architecture

## Runtime layers

```text
Flutter UI / Riverpod providers
        |
Domain services and validated contracts
        |
Drift local database (canonical state)
        |
Platform health, sensors, and optional Firebase transports
```

## Local persistence

`AppDatabase` is the authoritative store. Writes from Journal classification,
manual logging, health import, and strength details converge on canonical
nutrition/activity/lifestyle tables. Journal source text and extraction state
are retained separately. Vessel readings are keyed by deterministic birth-input
hash so identical inputs do not trigger repeated composition.

## AI boundary

`AetherClient` exposes bounded tasks including daily guidance, Journal
classification, insight synthesis, and Vessel composition. Each task has a
dedicated request and response schema. Journal prose is accepted only by the
classification task. Invalid, oversized, or out-of-range responses fail
validation before database writes.

Firebase AI Logic is the configured primary transport. Offline/local templates
remain available where appropriate.

## Health boundary

Platform records are normalized into canonical minute/day aggregates with
source attribution and replay-safe identifiers. Manual entries enter the same
pipeline. Calculations and sensor evidence take priority over symbolic content.

## Symbolic boundary

- Zodiac-to-Arcana uses explicit Golden Dawn mappings.
- Life path preserves master values 11 and 22.
- Natal-chart calculation is deterministic and requires complete birth inputs.
- The full Major Arcana catalog is typed and asset-backed.
- Vessel backgrounds and floating cards are separate render layers.
- Grounded mode minimizes symbolic payloads and rejects fated language.

## Firebase data

Firestore is not the canonical health store. Current rules allow authenticated
owners to access only their own strictly validated user documents; unmatched
paths are denied. Rules and indexes live at the repository root.

## Key locations

- `app/lib/core/db/` — Drift schema and persistence
- `app/lib/core/aether/` — AI contracts, guidance, Journal, Vessel
- `app/lib/core/arcana/` — zodiac and complete Major Arcana catalog
- `app/lib/features/aether/` — primary surface and layered Vessel UI
- `app/lib/features/settings/` — Sanctum and sensor management
- `app/test/` — logic, database, privacy, asset, and UI atlas tests
- `firestore.rules` — deployed Firestore policy

