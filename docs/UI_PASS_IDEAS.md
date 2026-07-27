# Eter — full UI pass: ideas and direction

**Status:** answers received (§6); implementation in progress per §7.
**Author:** Claude Opus 5, 27 July 2026. **Handoff to:** Kimi K3.
**Evidence:** 34 golden screenshots in `artifacts/ui-pass/screens/`, copied from
`app/test/atlas/goldens/`. Every claim below names the screenshot and/or the
`file:line` it came from.

---

## 1. Direction, as decided by the product owner

These answers are authoritative. Where an idea below conflicts with one, the
answer wins.

| Question | Decision |
|---|---|
| How far may ideas go? | **Both tiers, clearly separated.** Every flow gets Tier 1 (safe, land now) and Tier 2 (restructure, bigger bet). |
| What does "minimalistic" mean here? | **Minimal by default, rich on moments.** Everyday surfaces (log, balance, timeline) become plain and efficient; ritual moments (onboarding, arcana reveal, milestones) stay lavish. |
| Where to concentrate? | **Everything — full pass.** Daily flows, first-run/identity, navigation/shell, settings and edge states. |
| How prescriptive? | **Rationale + specifics.** State problem, reasoning, and a concrete proposal with paths and tokens; leave final visual judgement to the implementer. |
| Is the single-scroll IA sacred? | **Keep one scroll, add fast access.** Preserve the continuous surface; add a way to jump between sections rather than forcing linear traversal. |
| Day Sky (light theme)? | **Fix contrast, keep parity.** First-class theme; audit against WCAG, strengthen labels, note where it needs its own art direction. |
| What opens the app? | **Time-of-day dependent.** Prose leads in the morning when there is little data; the day's state leads later once there is something to report. |

### The overriding aesthetic directive

> "Completely stray away from the button 'pill' format that's typical of AI slop
> UI. Pinpoint elements where the AI look is still visible and make it PREMIUM."

This outranks everything else in this document. Section 3 is dedicated to it and
should be read first. Where a Tier 1 idea elsewhere says "keep the existing
control", Section 3 overrides it.

---

## 2. What Eter actually is, structurally

Worth stating because it constrains every idea. Per `features/shell/shell.dart:8`
there are exactly **two destinations**: the continuous Aether surface, and The
Sanctum (settings). Onboarding is a separate first-run flow. There is no tab bar.

The Aether surface renders in this fixed order
(`features/aether/aether_screen.dart:645-712`):

1. `PulseBlock` — live heart-rate / session entry
2. `JournalComposer` — the log, the app's primary input
3. "The day in numbers" — three figures (`:651-677`)
4. Three ring gauges (`:679-703`)
5. `ScalesSection` — the balance (`main_sections.dart:30`)
6. `TimelineSparkline` (`main_sections.dart:73`)
7. Patterns, when present (`:708`)
8. The Vessel — life-path and zodiac cards (`vessel_section.dart`)
9. The companion / hero arcana card (`aether_screen.dart:862`)

There is also an existing **register system** (`core/register.dart:18`):
`grounded` / `balanced` / `immersive`, gating `showsOrnament`,
`showsCompanionCard`, `showsHeroCard`, `showsAmbientMotion`. This already
implements a mysticism dial — but as one **global user setting**, not per-surface.
That distinction drives idea **C10**.

### A caveat about the screenshots — read before judging any icon

The goldens render **without the Material icon font**, so every icon appears as
an empty square (tofu). The squares beside "BEGIN SESSION", inside the Log, in
Sanctum rows and in the Live ring are **not** a design flaw — they are missing
glyphs in the test environment. Do not "fix" them. Any genuine iconography
critique below is derived from source (`Icons.add`, `Icons.mic_none`, etc.), not
from the images.

---

## 3. The AI-slop audit — where the generic look still shows

This is the priority section. Each item names what reads as machine-generated and
what premium would look like instead.

### A1. The capsule button is the single biggest tell — and the fix is already in the codebase

`core/controls.dart:175` builds every primary and secondary action with
`BorderRadius.circular(999)`: a full stadium capsule, 52 px tall, 32 px
horizontal padding, gold hairline border. This is the exact shape language of
generated UI. It appears as "ADD TO TODAY"
(`../artifacts/ui-pass/screens/log_typing_night.png`), "BEGIN SESSION"
(`dashboard_immersive.png`, `live_night.png`), and — worse — as a **filled
sky-blue** capsule for "Begin" in onboarding (`onboarding_night.png`), which
comes from `core/theme.dart:112` setting `shape: const StadiumBorder()` globally
on `elevatedButtonTheme` with a `sky400` fill.

**The antidote already exists.** The same file's `quiet` emphasis
(`controls.dart:144-169`) renders letterspaced caps above a **1 px rule that
grows from 28 px to 44 px on press**. No capsule, no fill, no border. That is an
editorial, couture-catalogue gesture and it is genuinely premium. It is currently
reserved for tertiary actions.

**Idea A1 (Tier 1, highest value in this document):** invert the hierarchy.
Promote the rule-and-caps treatment to be *the* Eter action language at all
emphases, and delete the capsule entirely.

- Primary: caps label, heavier letterspacing (1.8), rule at full label width, and
  a gold rule instead of a neutral one. Optionally a second hairline 3 px below
  for "double rule" emphasis — a classic engraving device that costs nothing and
  reads expensive.
- Secondary: today's `quiet` treatment unchanged.
- Tertiary: label only, rule appears on press/focus.
- Remove `shape: const StadiumBorder()` from `theme.dart:112` and stop using
  `ElevatedButton` in onboarding; route it through `EterAction`.
- Keep the 52 px minimum **hit target** via padding — losing the capsule must not
  shrink the touch area (`controls.dart:179`).

Focus and disabled states need designing, since a border no longer carries them:
suggest focus = rule thickens to 2 px plus a 1 px gold underscore offset; disabled
= label at `labelMuted` alpha .5 with no rule (already the pattern at `:164`).

### A2. Glassmorphism panels

`GlassCard` (`core/widgets.dart:10`) is a translucent fill with a 20 px radius
(`rCard`, `tokens.dart:68`) and a 32 px blur shadow (`tokens.dart:84`). Frosted
translucent cards at ~20 px radius are the defining cliché of 2020s generated
interfaces. Visible in `dashboard_immersive.png` (Pulse), `balance_night.png`
(Scales), `settings_night.png` (every group).

**Idea A2 (Tier 1):** replace containment-by-fill with containment-by-rule.
Drop the translucent panel; define groups with a single hairline top rule, the
existing letterspaced caps label, and generous space. Where a surface must be
distinguished from the starfield for legibility, use a very low-alpha flat scrim
(no blur, no border) and reduce the radius sharply — 20 px reads app-like, 2–4 px
or a true square reads printed. The engraved plate is Eter's motif; plates have
edges, not rounded glass.

Keep one exception: the arcana card itself should stay rounded and lifted. It is
a physical card, and `rChip` (12 px) is right for it.

### A3. Ring gauges

Three donut gauges reading `0% ACTIVE`, `0 STEPS`, `0 SESSIONS`
(`aether_screen.dart:679-703`, seen in `dashboard_immersive.png`) are the stock
fitness-app component. They are also redundant — see **C1**.

**Idea A3 (Tier 2):** delete the ring row outright. If a progress signal is
wanted, express it in the app's own vocabulary: a thin arc on the existing
`AuraRing`, or a horizontal engraved scale rule with a single gold tick at the
current value. A straight ruled scale is more legible than a donut at this size
and looks like an instrument rather than a widget.

### A4. Uniform radii everywhere

`tokens.dart:68` defines `rChip 12, rCard 20, rSheet 28`. Everything in the app
lands on one of three rounded values, which is what makes generated UI feel
plasticky. Premium print design mixes **sharp** and **soft** deliberately.

**Idea A4 (Tier 1):** add `rNone = 0` and use it as the default for panels,
inputs, dividers and scrims; reserve rounding for objects that are physically
card-like. Keep `rSheet` for modal sheets.

### A5. Centred, symmetric stacks

Onboarding (`onboarding_night.png`) is a dead-centre column: card, title,
subtitle, button, all centred, evenly spaced. Live (`live_night.png`) centres its
ring in a card. Centred symmetry is the default output of layout generators.

**Idea A5 (Tier 2):** commit to an asymmetric editorial grid — content on a left
axis with a wide right margin, the way the guidance prose already works
(`aether_balanced_night.png`, which is the most premium screen in the app
precisely because it is left-aligned ragged-right serif with real margin). Centre
only the arcana card, which earns it as a ritual object.

### A6. Placeholder em-dashes and bare zeros

`— BPM` and `0:00 / 0 kcal / Estimated` in the Pulse block
(`dashboard_immersive.png`), and a white dash inside the Live ring
(`live_night.png`). Em-dash-as-placeholder is a generated-UI habit; it tells the
user nothing and looks unfinished.

**Idea A6 (Tier 1):** when there is no sensor and no session, do not render
metric slots at all. Replace the whole block with one line of intent — "Begin a
session" — and let the metrics appear only once they mean something. See **C6**.

### A7. What is already premium — protect it

Do not touch these while chasing the brief:

- The serif display type and the ragged-right prose setting
  (`aether_balanced_night.png`). This is the best thing in the UI.
- Section headers: short gold dash, letterspaced caps, hairline rule to the
  right (`settings_night.png`). Editorial and correct.
- `OrnamentDivider`, `StarOrnament`, `ElementMedallion` (`widgets.dart:258-330`).
- The commissioned card artwork and its new motion loops. A source comment at
  `aether_screen.dart:880` already notes the art was shipping at 64×104 px,
  "smaller than the app icon" — that instinct was right and should govern.

---

## 4. Cross-cutting problems

### C1. The day's three numbers are rendered six times

On one scroll: intake appears as the "Taken in" figure (`aether_screen.dart:653`)
and again as "TAKEN IN" on the Scales (`balance_night.png`). Burn appears as
"Moved" (`:659`), as the "Active" gauge (`:682`), and as "SPENT" on the Scales.
Steps appears as a figure (`:671`) **and** as a gauge (`:688`) — the same value
twice, 32 px apart, in `dashboard_immersive.png`.

**Tier 1:** delete the gauge row (also **A3**); it duplicates two of the three
figures. **Tier 2:** decide the single canonical home for each quantity — figures
for magnitude, Scales for the intake-versus-burn *relationship*, timeline for
distribution over time — and let each number appear exactly once.

### C2. Three words for one quantity

The same burn figure is "Moved" (`:661`), "SPENT" (`balance_night.png`), "Active"
(`:684`), and `burn` in code (`main_sections.dart:44`). Intake is "Taken in" and
"TAKEN IN". Inconsistent lexicon reads careless.

**Tier 1:** fix one vocabulary and apply it everywhere including code
identifiers. Recommend **Taken in / Moved** as user-facing (warmer, non-clinical,
already dominant) and rename `burn` to `moved` in the providers.

### C3. Six full-width section headers, each costing a line plus 48 px

`THE PULSE`, `THE LOG`, `THE DAY IN NUMBERS`, `THE SCALES`, `DAY TIMELINE`,
`THE VESSEL` — with `EterSpace.s48` between nearly every section
(`aether_screen.dart:648, 678, 704, 706`). Uniform 48 px rhythm means *no*
hierarchy: everything is equally important, so nothing is. Note also that
`DAY TIMELINE` breaks the `THE …` pattern (`main_sections.dart:107`).

**Tier 1:** two-tier spacing — 48 px between major movements, 24 px within one.
Drop headers where the content is self-evident (the Scales graphic needs no
"THE SCALES" above it). **Tier 2:** if the "THE …" naming is kept, make it
universal; otherwise drop the definite article everywhere.

### C4. Content runs to the screen edge and clips

Measured, not guessed: in `log_typing_night.png` and `log_extracted_night.png`
there are lit pixels in the **final column** (x = 389 of 390) at rows 155–170.
The "38/5000" counter and the right edge of the action are cut off. Same pattern
on the timeline header in `timeline_night.png`. The composer row at
`journal_composer.dart:189-206` has no horizontal padding of its own and the
counter is `maxLength: 5000` decoration (`:181`) sitting flush right.

**Tier 1:** ensure every row inside the surface respects `EterSpace.gutter`, and
verify with a golden that no lit pixel occupies the outer 8 px. This is a bug,
not a preference.

### C5. Empty and zero are indistinguishable — and the copy is risky

`balance_empty_night.png` shows `0 TAKEN IN`, `828 SPENT`, and the sentence
"−828 kcal · a lighter balance today" (`main_sections.dart:62`). That string is
generated whenever `net < 0`, including when the user simply has not logged food
yet. Describing "ate nothing" as *a lighter balance today* is, in a calorie app,
an endorsement the product should not make.

**Tier 1 (treat as correctness, not polish):** branch on *whether intake was
logged at all*, not on the sign of `net`. With no entries, show "Nothing logged
yet" and suppress the net verdict entirely. Review the positive string too —
"well fueled" at `+202` is fine, but the negative branch needs a neutral,
non-approving phrasing when the deficit is real.

### C6. Zero-states render full instrument panels

Pulse shows `0:00 / 0 kcal / Estimated` and `— BPM`; gauges show `0% / 0 / 0`;
the timeline draws a flat line with "0 active min" and a large void
(`timeline_night.png`). A first-run user sees a dashboard of zeros.

**Tier 1:** per-section empty states using the existing `EmptyStateOrnament`
(`widgets.dart:120`) and the existing empty art (`empty-balance.png`,
`empty-ledger.png`, `empty-timeline.png` in `app/assets/art/`, currently
underused). One line of intent beats a grid of zeros.

### C7. Redundant status copy stacked in prose

Live states "No sensor selected", then "Pair a sensor or begin with an estimate",
then "No sensor selected. Estimated sessions remain available."
(`live_night.png`) — three overlapping sentences about one condition. The Log
carries a permanent two-line privacy notice (`journal_composer.dart:212-216`)
plus transient feedback rendered as identical `bodySmall` text (`:209`), so
"Entry classified and added to today." is visually indistinguishable from
boilerplate (`log_extracted_night.png`).

**Tier 1:** one status line per condition. Give transient confirmations a
distinct treatment (gold, brief, animated in) so they read as *response* rather
than *label*. Move the privacy notice behind an info affordance, or show it once
on first use and not for every subsequent entry — it is reassurance, and
permanent reassurance becomes noise.

### C8. Day Sky contrast

Per the decision, Day Sky is first-class. In `dashboard_grounded.png` and
`aether_grounded_day.png` the caps labels and body text are pale grey over
cloud photography with varying local luminance.

**Tier 1:** measure every text-on-cloud pair against WCAG AA (4.5:1 body, 3:1
large) and darken the Day Sky ink tokens until they pass. Because the background
is a *photograph*, a fixed colour cannot pass everywhere — either add a subtle
flat scrim behind text blocks (no blur; see **A2**) or commission a Day Sky plate
with a calmer upper region, as was already done for Night Sky per
`STAGE-13.5-LOOP-LOG.md`. Note also that Day Sky has **no** card animations at
all (`animated_arcana_card.dart:69`); with 25 Night Sky loops shipped, that gap
is now conspicuous and should be an explicit product decision rather than a
silent absence.

### C9. Two identical affordances for different meanings

`Icons.add` / `Icons.remove` toggles expansion in both the Vessel
(`vessel_section.dart:70`) and the Timeline (`main_sections.dart:116`), while
`+` conventionally means *create*. In an app whose primary verb is "add to
today", a `+` that means "expand" is a genuine mis-signal.

**Tier 1:** use a chevron or a hairline caret for disclosure and reserve `+` for
creation.

### C10. The register dial is global, but the decision is contextual

`core/register.dart:18` gates ornament, companion card, hero card and ambient
motion on one app-wide setting. The chosen direction — *minimal by default, rich
on moments* — is inherently **per-surface**: the Log should be plain even for a
user who wants immersion, and the arcana reveal should be lavish even for a user
who wants restraint. A single global dial cannot express that, which is why the
three guidance registers currently differ by only one paragraph of wording (5.4).

**Tier 2:** re-frame the register as a *ceiling* rather than a *level*. Each
surface declares its own intended richness — `plain` for Log, numbers, Scales,
Timeline; `ritual` for onboarding, arcana reveal, Vessel, milestones — and the
user's register caps how far the ritual surfaces are allowed to go.
`grounded` then means "even the ritual moments stay quiet", while `immersive`
means "let them sing", and no setting can make the Log ornate. This preserves
user control (Q3) while making the default behaviour correct.

Concretely: keep `EterRegister`, add a `SurfaceIntent` enum consulted alongside
it, and replace direct `showsOrnament` checks with a resolver taking both. The
call sites to migrate are `aether_screen.dart:666` and `:883`,
`main_sections.dart`, and `vessel_section.dart`.

---

## 5. Flow-by-flow

### 5.1 Onboarding — `onboarding_night.png`, `onboarding_day.png`
Card, wordmark, "Measure the body. Read the pattern.", Begin.

- **Problems:** filled sky-blue capsule on a night screen (**A1**); dead-centre
  stack (**A5**); the card reads as an empty dark rectangle at this size, wasting
  the best asset in the product.
- **Tier 1:** route Begin through `EterAction`; left-align the type on the same
  axis the guidance prose uses; enlarge the card and let its new loop animate —
  this is precisely a "rich moment".
- **Tier 2:** make first-run the app's one true set-piece: card breathing in
  mist, wordmark resolving from fine gold dust, single ruled action. The intro
  brief in `archive/documentation-2026-07-27/assets/HIGGSFIELD_MOTION_BRIEF.md`
  already specifies a 6 s intro reveal that was never produced — worth revisiting
  now the pipeline is proven (68 credits remain).

### 5.2 Auth — `auth_gate.dart`
No golden exists. **Tier 1:** add one to the atlas; an unscreenshotted flow is an
unreviewed flow.

### 5.3 Shell and navigation — `shell.dart`
`IndexedStack` of Aether and Sanctum; Sanctum overlays a `filledTonal`
`IconButton` back control at top-left (`shell.dart:36`).

- **Problems:** a Material `filledTonal` circle is another generic tell (**A1**);
  entering Sanctum is a full-surface swap with no transition, at odds with the
  "gust" transition the motion spec mandates (spec 04 §3).
- **Tier 1:** replace with a ruled text back-affordance; apply the gust
  transition.
- **Tier 2 (implements "keep one scroll, add fast access"):** a slim persistent
  rail — a vertical column of hairline ticks with letterspaced initials at the
  right margin, one per movement, current section's tick gold. Tapping jumps.
  Editorial (a chapter index), not a tab bar, and it directly answers the fast
  access decision without fragmenting the surface.

### 5.4 The opening — `aether_balanced_night.png`, `aether_immersive_night.png`, `aether_grounded_day.png`
Date, ornament divider, three paragraphs of composed prose, "Composed privately
on this device".

- **Observation:** the three registers differ in **one paragraph's wording only**.
  Reasonable, but it means the register dial's visible payoff here is small.
- **Problems:** prose ends around y≈560 of 844 and the rest is void; the footer
  sits alone at the bottom. Beautiful but under-composed.
- **Tier 1:** tighten the void; let the prose block sit optically centred with
  the footer closer to it.
- **Tier 2 (implements the time-of-day decision):** before ~11:00 or when the day
  has no logged data, prose leads as it does now. Later, a compact one-line state
  summary takes the top slot and the reading moves beneath it. This needs a
  defined threshold — see open question **Q1**.

### 5.5 Pulse — `dashboard_immersive.png`, `live_night.png`
- **Problems:** **A6** (placeholder metrics), **C7** (triple status copy), **A2**
  (glass panel), **A1** (capsule).
- **Tier 1:** collapse to one intent line plus one ruled action until a session
  exists. Move "Sensor pairing and forgetting live in The Sanctum" out of the
  card — it is documentation, not interface.
- **Tier 2:** merge Pulse and the Live screen. They show the same state at two
  fidelities (`live_screen.dart:490` and `:579` both render Begin/Finish),
  which is duplicated logic and a duplicated mental model.

### 5.6 The Log — `log_night.png`, `log_typing_night.png`, `log_needs_detail_night.png`, `log_extracted_night.png`
The primary input. Currently: label "Write naturally", text field, mic
`IconButton`, capsule action, feedback line, permanent privacy notice.

- **Problems:** **C4** (clipping — real bug), **C7** (undifferentiated feedback,
  permanent notice), **A1** (capsule). The collapsed state
  (`log_night.png`) is an entirely blank screen with a header — a first-time user
  cannot tell the app's central feature exists. Discoverability is the deepest
  issue: a free-text NLP field with only "Write naturally" as guidance gives no
  clue about what it understands (food? mood? sets? sleep?). The placeholder at
  `:185` — "I had oats, walked for half an hour, and felt…" — is good and is
  hidden behind the label.
- **Tier 1:** fix the clipping; surface the example placeholder permanently as
  ghost text; differentiate confirmations; demote the privacy notice; give the
  mic a real label and target.
- **Tier 2:** make the Log the app's centre of gravity rather than the second
  section. Since it is the primary verb, consider a persistent composer affordance
  anchored at the surface's foot that expands on focus. Also consider showing the
  *extraction result* inline after submit ("oats → 320 kcal · walk 30 min → 140
  kcal") so the classifier is legible and correctable — currently the user is
  told "Entry classified" and must trust it. That trust gap matters more than
  any visual change in this document.

### 5.7 The day in numbers — `dashboard_immersive.png`, `dashboard_grounded.png`
- **Problems:** **C1** (Steps twice), **A3** (rings), **C2** (lexicon).
- **Tier 1:** delete the gauge row; keep three figures. The comment at
  `aether_screen.dart:810-812` documents a real past wrapping bug — preserve the
  unit-rides-with-figure fix when touching this.
- **Tier 2:** reduce to two figures plus the relationship, since Scales already
  expresses intake-versus-burn; consider Steps living in the timeline instead.

### 5.8 The Scales — `balance_night.png`, `balance_empty_night.png`
The engraved balance is genuinely distinctive and on-brand.

- **Problems:** **C5** (empty-state copy — the most important single fix in this
  document), **C2** (SPENT vs Moved), **A2** (glass panel).
- **Tier 1:** as **C5**; unify labels; remove the panel and let the engraving sit
  on the field.
- **Tier 2:** the tilt is `(net / 600 * 6).clamp(-6, 6)` (`main_sections.dart:57`)
  — an undocumented 600 kcal constant mapping to 6°. Make it a named token and
  consider tilting against the user's actual target rather than a magic number.

### 5.9 Timeline — `timeline_night.png`
24 hourly buckets, collapsible 72 → 220 px.

- **Problems:** header clipped (**C4**); no axis, labels or scale — the sparkline
  is unreadable as data (`_SparkPainter`, `main_sections.dart:138`); flat line at
  zero with a large void; "0 active min" as a zero-state.
- **Tier 1:** empty state; hairline hour ticks at 06/12/18 with letterspaced caps;
  respect the gutter.
- **Tier 2:** when expanded it should become a real chart — value axis, peak
  annotation, and the day's phases. Note that a project `dataviz` skill exists
  and should be consulted before drawing this.

### 5.10 The Vessel — `vessel_day.png`, `vessel_night.png`
Two card slots (life path, zodiac sun), eyebrow labels, then a composed reading.

- **Now animated:** as of stage 15 both slots play Night Sky loops
  (`vessel_section.dart`, this session's change). All 22 arcana have loops.
- **Problems:** `+`-as-disclosure (**C9**); the prompt copy "Add birth time and
  place in The Sanctum to reveal it" is a dead end — it names a destination but
  does not link to it.
- **Tier 1:** make that prompt a ruled action that navigates to the relevant
  Sanctum row.
- **Tier 2:** the Vessel is a "rich moment" and should be the surface's climax,
  not a mid-scroll accordion — consider giving it a full-bleed movement.

### 5.11 The arcana card — `arcana_card_night.png`, `arcana_card_day.png`
- **Observation:** the golden shows back and front side by side. The card back's
  right edge shows a thin misaligned gold line worth checking against the v2
  master — possibly a real plate seam.
- **Problems:** in non-immersive registers the card is small; the source comment
  at `:880-882` already argues it was too small.
- **Tier 1:** verify the back-plate edge; ensure the loop plays in every register
  that shows the card.
- **Tier 2:** the reveal is the one moment spec 04 §4 specifies in full detail
  (lift, 3D flip, light burst at 90°, 40 gold particles, letterspaced title).
  Confirm the shipped reveal matches that spec; if not, this is the highest-value
  "rich moment" in the app.

### 5.12 Live — `live_night.png`, `live_day.png`
- **Problems:** **A6**, **C7**, **A1**, **A5**, plus duplicated session controls
  (`live_screen.dart:490` and `:579`).
- **Tier 1/2:** as 5.5 — strong candidate for merging into Pulse.

### 5.13 The Sanctum — `settings_night.png`, `settings_day.png`
The best-structured screen: ruled section headers, grouped rows, an Arcana
summary card, a weight sparkline.

- **Problems:** "1419 resting kcal" appears twice on one screen — in the Arcana
  card and the Body weight row; the weight sparkline has no axis or date range;
  every row carries leading *and* trailing icons, which at eight rows is
  sixteen glyphs of chrome (**A2**, minimalism).
- **Tier 1:** de-duplicate the resting figure; drop leading icons and let the
  label carry the row; add "last 30 days" to the sparkline.
- **Tier 2:** the header says "Your body, records, and ritual settings" — three
  categories currently interleaved across five groups. Consider ordering the page
  to those three, and check whether "Resync date range · Up to 30 days" belongs
  in a preferences list at all.

### 5.14 Edge states, motion and accessibility
- **Reduce motion:** honoured for card loops (`animated_arcana_card.dart:67`) and
  registers (`showsAmbientMotion`). **Tier 1:** verify Calm Mode reaches *all*
  new loops including the Vessel slots added this session, and add a golden for
  reduce-motion so it cannot silently regress.
- **Empty art:** `empty-balance.png`, `empty-ledger.png`, `empty-timeline.png`
  exist and are barely used — see **C6**.
- **Errors:** the only error path visible is "The Vessel could not be composed
  yet." (`vessel_section.dart:122`). **Tier 1:** audit failure states across
  network-dependent surfaces; add goldens.
- **Tap targets:** the mic `IconButton` and disclosure toggles should be verified
  at ≥48 px.

---

## 6. Product-owner answers — decided 27 July 2026

These are now authoritative; they change implementation as noted.

- **Q1 — time-of-day opening.** *Prose displays once every time it is generated
  in the morning; after ~11:00 it is demoted in place on the dashboard.* So the
  morning reading still leads on first view; once the day is past ~11:00 the
  compact state line takes the top slot and the reading moves beneath it. The
  trigger is the clock (~11:00), not data presence.
- **Q2 — primary action ink.** *Follow `EterInk`.* Gold rule + caps in the
  ornament registers, plain ink in grounded — the existing `EterInk.of`
  resolution already implements exactly this split, so A1 adds no new colour
  logic.
- **Q3 — register model.** *Ceiling + `SurfaceIntent`* per **C10** (Tier 2).
  Everyday surfaces always plain; ritual surfaces rich up to the user's
  register.
- **Q4 — Day Sky animation parity.** *Yes, commission later.* Not part of this
  pass (~308 credits, 68 remain); record it as an explicit planned decision
  rather than a silent absence.
- **Q5 — lexicon.** *Eaten / Burned* is canonical (not Taken in / Moved). Apply
  to every user-facing surface. Code identifiers `intake` and `burn` already
  map 1:1 onto these labels, so no provider rename — the mismatch the audit
  flagged (`Moved`/`SPENT`/`Active` for one quantity) disappears with the
  labels.
- **Q6 — extraction trust.** *Yes — inline result.* After submit, the Log shows
  what the classifier extracted ("oats → 320 kcal · walk 30 min → 140 kcal")
  inline, correctable. Highest-priority Tier 2 item.

---

## 7. Suggested sequencing for implementation

1. **Correctness first:** **C4** (edge clipping) and **C5** (empty-state copy).
   Both are defects, not preferences.
2. **The aesthetic directive:** **A1** (kill the capsule), then **A4**, **A2**.
   A1 touches `controls.dart`, `theme.dart` and every call site, and will
   invalidate most goldens — do it in one deliberate pass, and review the
   regenerated goldens by eye rather than blind-updating them.
3. **Subtraction:** **C1**/**A3** (delete the gauge row), **C3** (spacing and
   headers), **C7** (status copy).
4. **Consistency:** **C2** (lexicon), **C9** (disclosure icon), **C8** (Day Sky
   contrast).
5. **Empty states:** **C6** with the existing art.
6. **Then the Tier 2 restructures**, in this order of value: 5.6 (Log as centre
   and extraction trust), 5.3 (fast-access rail), 5.5/5.12 (merge Pulse and
   Live), 5.4 (time-of-day opening), 5.10/5.11 (ritual moments).

### A note on goldens

The atlas is this project's main safety net for UI and it is good. Two habits
worth keeping: never run `--update-goldens` without looking at the diff (this
session's one golden change was verified as a deliberate resampling improvement
before being accepted), and add goldens for the flows that currently have none —
auth, reduce-motion, and error states. An unscreenshotted surface is an
unreviewed one.

---

## 8. Implementation status — Tier 1 complete, 27 July 2026

All Tier 1 items in the §7 sequencing are implemented, analyzer-clean and
covered by regenerated goldens reviewed by eye.

| Item | Done | Note |
|---|---|---|
| C4 edge clipping | yes | `inGutter()` wrapper; clipping was harness-only |
| C5 empty/zero copy | yes | verdict branches on `entries.isEmpty` |
| A1 capsule killed | yes | `EterAction` caps+rule at all emphases; `elevatedButtonTheme` removed |
| A4 radii | yes | `rCard` deleted; plates square, `rChip` kept for card-like art |
| A2 glassmorphism | yes | `GlassCard` → `EterPlate`: flat scrim, hairline top rule, no blur |
| C1 / A3 gauge row | yes | ring row deleted outright |
| C3 spacing/headers | yes | figures+Scales+Timeline are one movement at 24; `THE SCALES` dropped; `DAY TIMELINE` → `THE TIMELINE` |
| C7 status copy | yes | Log confirmation now gold + animated; privacy note behind an info affordance; Live's third sentence reduced to the scan |
| C2 lexicon | yes | **Eaten / Burned** on figures and both Scales pans |
| C9 disclosure | yes | chevrons in Log, Timeline, Vessel; `+` reserved for creation |
| C8 Day Sky contrast | yes | see measurements below |
| C6 / A6 empty states | yes | Pulse drops metric slots when dormant; Timeline and Scales use `EmptyStateOrnament` with the commissioned art |

### C8 — measured, not estimated

Contrast computed against the Day Sky photograph itself (`sky_background_day.png`),
using the 1st/5th-percentile-darkest pixel as the realistic worst case:

- **On a plate.** The day scrim was raised `mist0` α 0.30 → **0.68**. `ink600`
  goes 3.25:1 → **4.83:1**, `ink900` → 10.7:1. Night at α 0.45 already measured
  14.5:1 / 8.3:1 and was left alone.
- **Darkening the token was rejected.** For `ink600` to pass on *bare* sky it had
  to reach `#25303B` — all but identical to `ink900` — which erases the
  secondary tier entirely.
- **On bare sky.** `ink900` passes everywhere (4.77:1 worst case), so the prose
  reading is safe. `ink600` (2.15:1) and `aura700` gold (**1.15:1** — effectively
  invisible) do not. The two bare-sky captions on the guidance screen now use
  `ink900` on Day; the ✦ is kept as the ornament signature in place of gold ink.

### Known remaining

- **Gold line-work on Day Sky** (the ornament rule on the guidance screen) sits
  at roughly the same 1.15:1 as the gold text did. It is decorative rather than
  informational, so it is not an AA failure, but it is close to invisible on a
  bright sky and deserves a deliberate decision.
- `EngravedGauge` (`instruments.dart`) is now unreferenced after C1/A3.
- Tier 2 is untouched: 5.6 (Log as centre / extraction trust, the highest-value
  item per Q6), 5.3, 5.5+5.12, 5.4, 5.10+5.11, and C10's `SurfaceIntent`.

### Tier 2 progress — 5.6, the Log

The Q6 item ("the trust gap matters more than any visual change in this
document") is now half shipped, and the half that shipped is the visible half.

- **The reading is shown.** After submit the Log lists what the classifier
  actually understood — `Oats · a bowl → 320 kcal`, `Walk · 30 min → 140 kcal`,
  `Mood → 4/5` — under a `READ AS` rule, instead of asserting "Entry classified
  and added to today." A wrong reading is now visible at the moment it is made
  rather than discovered later in the day's totals.
- **Discoverability.** Collapsed, the Log was a header over an empty screen. The
  example prose now shows as a muted invitation and is itself the tap target, so
  the app's primary verb is visible from the dashboard.
- **Ghost text.** `labelText` floated above the field and hid the example behind
  it; the example is now permanent `hintText`.
- **The mic** is an `EterAction` with the word "Dictate" and the system's 52 px
  target, not a bare glyph.
- **Atlas.** `JournalComposer` gained an `initialExtraction` seam alongside the
  existing `initialText`/`initialMessage`, so `log_extracted` captures the real
  post-submit state rather than a message string.

**Not shipped: correction.** There is currently no edit or delete path for a
nutrition or activity row anywhere in the app — no `updateNutritionEntry`, no
delete, no per-entry UI. Copy offering correction was written and then removed
rather than ship a promise the app cannot honour. Making the reading correctable
needs that edit path built first (database methods that can reverse an applied
extraction, plus an entry-level UI), which is a data-layer change rather than a
UI pass item.

### Still open in Tier 2

5.3 (fast-access rail), 5.5 + 5.12 (merge Pulse and Live), 5.4 (time-of-day
opening per Q1), 5.10 + 5.11 (ritual moments), C10 (`SurfaceIntent` per Q3), and
the persistent foot-anchored composer half of 5.6.

---

## 9. Tier 2 complete — 27 July 2026

Everything in the §7 sequencing is now implemented. `flutter analyze` is
clean and 116 tests pass, including three new non-golden tests.

| Item | What landed |
|---|---|
| 5.6 Log | Extraction shown under a `READ AS` rule; collapsed Log advertises itself; ghost text; "Dictate" |
| 5.13 Sanctum | Resting figure de-duplicated; leading icons dropped; sparkline labelled; `_SettingsPanel` → `EterPlate` |
| 5.10 Vessel | The prompt reaches the Sanctum instead of naming it |
| 5.4 Opening | Reading leads before 11:00, demoted beneath a state line after (Q1); void tightened |
| C10 | `SurfaceIntent` ceiling model (Q3) |
| 5.14 | Calm Mode asserted; tap targets raised to 48 px and pinned |
| 5.3 | Gust applied to the Sanctum; section rail at the right margin |
| 5.5 + 5.12 | One session, one surface |

### Two things worth knowing

- **`showsOrnamentHere` must be called below the scope.** A widget that
  returns a `SurfaceIntentScope` cannot resolve intent with its own build
  context — that context sits above the scope it is creating, so it reads the
  ambient value. This bit `_Dashboard`'s figure accent once; the fix is to
  resolve in a child widget, as `_Figure` now does.
- **The atlas shows 827 where the Scales show 828.** Both read the same
  `burnedSoFarToday`; the figure animates through `CountUpText` and the
  capture lands a frame before it settles. It is deterministic, not flaky,
  but do not read the atlas figures as exact.

### Genuinely still open

- **Correction of an extracted reading (the other half of Q6).** There is no
  edit or delete path for a nutrition or activity row anywhere in the app.
  This needs database methods that can reverse an applied extraction plus an
  entry-level UI — a data-layer change, not a UI pass item, and one that
  deletes user data, so it wants its own scoped work.
- **Gold line-work on Day Sky** measures ~1.15:1. Decorative rather than
  informational, so not an AA failure, but close to invisible on a bright
  sky. Either commission the calmer Day Sky plate (§C8) or accept it
  deliberately.
- **Q4 Day Sky card loops** remain uncommissioned by decision, not oversight.
- **Error-state goldens** for network-dependent surfaces (§5.14) are still
  absent; only the Vessel has a visible failure path.
- **5.6's foot-anchored persistent composer** was not attempted: it changes
  shell layout rather than the Log, and the discoverability problem it was
  meant to solve is addressed by the collapsed-state invitation.
