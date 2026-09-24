# Development Progress

## Current
- Branch: `dev`
- Version: `1.11.0-dev`
- Development head entering this documentation migration: `f434e20a007732ab712bad4ec6d3d70bea2d5c84`
- Stable baseline: `main` / `1.11.0` at `8c520ca1335f6de23409c2b94dd7b7e8a52c2b09`
- Goal: Maintain PallyPowerVanilla for WoW 1.12.1 while preserving its mature PallyPower-compatible runtime architecture.
- Current scope boundary: Documentation/workflow migration only. Do not change addon runtime behaviour as part of this migration.

## Current Design / Development Contract

### Architecture / Ownership
- Preserve the established mixed Lua/XML architecture: `PallyPower.lua` owns the main runtime logic and `PallyPower.xml` defines the existing UI; do not convert the UI to Lua or split the addon into modules without an explicit future decision.
- `PallyPowerVanilla.toc` remains the addon metadata/version source of truth.
- User-facing localization lives in `locales/enUS.lua`; the legacy locale path has been retired.
- Existing artwork hierarchy is intentionally preserved.
- Optional Nampower and UnitXP paths remain capability/enable-gated enhancements; normal addon operation must continue to have a native/non-DLL path.

### Invariants
- Target WoW 1.12.1 / Interface 11200 / Lua 5.0.
- Preserve compatibility with existing PallyPower clients, SavedVariables and addon communication unless a future change explicitly redefines those contracts.
- Do not redesign SavedVariables, communication formats, artwork hierarchy, XML/Lua ownership, or module structure as incidental cleanup.
- `PallyPower_Version` remains the compatibility global used by the existing VERSION wire protocol even though the TOC is the canonical version source.
- Stable `main` and active `dev` are allowed to differ in release-only metadata/presentation files; compare them during promotion rather than replacing one tree blindly.

### Protocol / Data Model
- Current per-character SavedVariables are `PallyPower_Assignments`, `PallyPower_AuraAssignments`, `PallyPower_SealAssignments`, `PallyPower_RFAssignments`, `PallyPower_NormalAssignments`, `PP_PerUser`, and `PP_Presets`.
- Existing PallyPower communication formats remain unchanged structurally.
- Assignment storage has been modernised/consolidated while retaining compatibility with older PallyPower SavedVariables and behaviour.

### Active Decisions
- Keep the familiar PallyPower workflow and compatibility focus; prefer targeted maintenance over a large architectural rewrite.
- Aura/Judgement assignment micro-icon clusters stay removed while assignment icons/tooltips remain.
- Judgement capability ranks map through the underlying Wisdom/Light/Crusader Seal ranks.
- HoJ/LoH/DI utility indicators use softened green/red/grey state tints.
- Prefer major new feature investment in the spiritual successor rather than a broad XML-to-Lua rewrite of PallyPowerVanilla.

## Recent Relevant Commits
- `f434e20` - Record the `1.11.0` stable release back on `dev`.
- `c43d049` - Record user approval of the tested `1.11.0-dev` state for stable promotion.
- `62662b4` - Record the focused Judgement/tint retest state.
- `07883db` - Fix Judgement rank mapping and soften HoJ/LoH/DI status tints.
- `8c520ca` - Final stable `main` tree for `1.11.0` after removing development-only progress documentation.

## Completed / User-Verified
- The addon loads and runs in game on the target environment.
- The prior VanillaTemplate-style structural migration and localization cleanup are working.
- Existing XML + Lua runtime architecture is preserved.
- Aura/Judgement assignment micro-icon cleanup is working while assignment icons/tooltips remain.
- Judgement capability ranks now match the corresponding underlying Seal ranks.
- HoJ/LoH/DI ready/unavailable/unknown state tinting works with the softened colours.
- Obsolete contributor tooltip text is removed; contributor credits remain in README.
- Stable `main` `1.11.0` was promoted after user approval of the tested development state.

## Implemented / Awaiting Runtime Test
- No known release-blocking runtime work is awaiting test.
- Not every optional client-extension / legacy-client combination has an individually documented runtime result.
- The exact stable `main` release tree was not separately documented as an in-game test after promotion; it inherits the tested runtime code from the approved `1.11.0-dev` source, with promotion changes limited to release metadata/presentation and development-document removal.

## Static / Automated Checks
- Prior static audit found no stale legacy locale paths.
- Prior static audit found no obvious Lua 5.1-only syntax such as `#`, `string.gmatch`, `table.pack`/`table.unpack`, or `goto`.
- Remaining literal XML text values were identified as placeholders/sample values rather than untranslated UI labels.
- Existing Nampower and UnitXP calls remain behind their existing capability/enable checks.
- This workflow migration changes development documentation only; no runtime files are intentionally modified.

## Current Issues
- No known release-blocking issues.
- Optional compatibility-path coverage is not exhaustively documented per client/extension combination.

## Testing

### Last Runtime Test
- Version/commit: `1.11.0-dev` / `62662b49f90ebe6dc734904f2e90f50867319e13` was the branch state immediately before the documentation-only approval commit recorded the user's successful focused retest.
- Passed: general addon/UI operation, Aura/Judgement cleanup, corrected Judgement ranks, and softened HoJ/LoH/DI status colours; the user reported most broader smoke checks working.
- Failed: no known release-blocking failures.
- Not tested/documented exhaustively: every optional client-extension / legacy-client combination.

### Next Runtime Test
- No specific runtime retest is required for this documentation-only migration.
- On the next runtime change, test the changed behaviour on `dev` and bind the result to the exact tested version/commit.

## Planned / Next Work
- Keep active development on `dev`.
- Begin the next development cycle only when a concrete runtime or maintenance request is made.
- Before the next stable promotion, compare `dev` and `main` and preserve intentional release-only differences.

## Deferred / Out of Scope
- Artwork flattening or renaming.
- XML-to-Lua UI conversion.
- Module split or architecture rewrite.
- SavedVariables redesign.
- Communication protocol redesign.

## Release / Promotion Notes
- Current stable baseline: `main` / `1.11.0` at `8c520ca1335f6de23409c2b94dd7b7e8a52c2b09`.
- Main-only or release-only content to preserve: stable TOC Title/Version metadata and the README release heading/version. At the verified baseline, `main` says README `v1.11.0` while `dev` still says `v1.10.20`; treat that as release-flow divergence to reconcile deliberately during a future promotion.
- Stable `main` excludes development progress/status documentation; future promotion should continue to keep development-only handoff material off the stable branch.
- Known validation debt accepted for release: the exact promoted stable tree did not receive a separately documented in-game run after release-only metadata/presentation/doc-removal changes.
- External/runtime prerequisites: none required. Nampower and UnitXP are optional enhancements, not hard dependencies.

## Exact Next Step
No runtime code change is pending. When new work is requested, resume on `dev`, verify the live branch head against this handoff, keep the existing architecture/protocol boundaries unless the request explicitly changes them, and update this file before the next handoff or promotion.
