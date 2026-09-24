# Development Progress

## Current
- Branch: `dev`
- Version: `1.11.0-dev`
- Current development head before this handoff update: `2c434b6efb57923219abbbdfa719435d0659dde7`
- Stable baseline: `main` / `1.11.0` at `8c520ca1335f6de23409c2b94dd7b7e8a52c2b09`
- Goal: Convert the addon-owned UI from `PallyPower.xml` to Lua in staged parity-preserving steps, then separately modernize the legacy frame-naming/getglobal machinery after an explicit runtime-tested XML-free baseline is established.
- Current scope boundary: This is a UI construction/refactor project only. Preserve runtime behaviour, appearance, compatibility contracts, data formats and optional-extension semantics unless a later request explicitly changes them.

## Current Design / Development Contract

### Architecture / Ownership
- Current runtime is mixed Lua/XML: `PallyPower.lua` owns core logic and `PallyPower.xml` owns most addon UI construction.
- Target architecture for the first migration phase:
  - `locales/enUS.lua`
  - `PallyPower.lua`
  - `PallyPowerUI.lua`
  - `Bindings.xml`
- `PallyPowerUI.lua` should replace addon-owned UI/layout XML one-for-one. Do not fold the converted UI directly into `PallyPower.lua`; keeping a separate Lua chunk preserves the existing logic/UI separation and reduces Lua 5.0 top-level local-pressure risk.
- `Bindings.xml` remains intentionally. Vanilla WoW discovers it specially for normal Key Bindings UI integration; it is not part of the addon-owned UI/layout migration.
- `PallyPowerVanilla.toc` remains the addon metadata/version source of truth.
- User-facing localization remains in `locales/enUS.lua`.
- Existing artwork hierarchy remains unchanged.
- Optional Nampower and UnitXP paths remain capability/enable-gated enhancements; normal addon operation must retain the native/non-DLL path.

### Invariants
- Target WoW 1.12.1 / Interface 11200 / Lua 5.0.
- Backward compatibility is a hard requirement throughout this refactor.
- Preserve existing PallyPower SavedVariables, assignment data model, addon communication protocol, VERSION semantics, public/global compatibility functions and keybinding action names.
- Preserve `PallyPower_Version` as the compatibility global used by the existing VERSION wire protocol even though the TOC is the canonical version source.
- Preserve existing user-visible behaviour, appearance, sizing, positioning, movement/scaling, tooltips, options, presets, dialogs, Buff Bar semantics, assignment semantics and Judgement behaviour during XML-to-Lua parity work.
- Preserve native-client operation and current Nampower/UnitXP fallback/enhancement behaviour.
- Do not redesign SavedVariables, communication formats, artwork hierarchy, keybinding semantics, assignment model or feature behaviour as part of the UI conversion.
- Do not remove legacy global frame names or dynamic `getglobal()` lookup behaviour during the XML-to-Lua parity phase.
- A runtime-tested XML-free commit is a hard checkpoint before starting naming/reference cleanup.
- Stable `main` and active `dev` may differ in release-only metadata/presentation files; compare them during promotion rather than replacing one tree blindly.

### Protocol / Data Model
- Current per-character SavedVariables are `PallyPower_Assignments`, `PallyPower_AuraAssignments`, `PallyPower_SealAssignments`, `PallyPower_RFAssignments`, `PallyPower_NormalAssignments`, `PP_PerUser`, and `PP_Presets`.
- Existing PallyPower communication formats remain unchanged structurally.
- Assignment storage remains backward-compatible with older PallyPower SavedVariables and behaviour.
- UI construction must not alter protocol/data-model ownership.

### XML-to-Lua Audit
- `PallyPower.xml`: approximately 2,845 lines.
- `PallyPower.lua`: approximately 6,962 lines.
- XML currently defines 9 custom virtual templates, 39 Frames, 77 Buttons, 19 CheckButtons, 2 Sliders, 3 EditBoxes, 1 StatusBar, 81 Textures and 59 FontStrings.
- XML contains approximately 276 named UI objects and 139 script handlers.
- `PallyPower.lua` currently creates only three frames directly, so this is a substantial UI-construction migration rather than a loader cleanup.
- Lua contains roughly 118 `getglobal()` lookups, including dynamically generated families such as:
  - `PallyPowerFramePlayer..i.."Name"`
  - `PallyPowerFramePlayer..i.."ClassJIcon"`
  - `PallyPowerBuffBarBuff..i.."Time"`
- These generated names are part of the current internal contract for the parity phase and must continue to resolve exactly until the later naming-machinery refactor.
- The nine custom XML templates to replace with Lua constructors/factories are:
  - `PPResizeGripTemplate`
  - `PPAssignmentCellTemplate`
  - `PPPlayerOverrideTemplate`
  - `PPClassColumnTemplate`
  - `PPSpecialColumnTemplate`
  - `PPBuffBarBlessingTemplate`
  - `PPBuffBarSpecialTemplate`
  - `PPBuffBarCombinedSelfTemplate`
  - `PPPaladinRowTemplate`
- Major XML sections:
  - Buff Bar: about 166 lines.
  - Assignment frame: about 924 lines and the highest-risk migration area.
  - Scaling frame: about 7 lines.
  - Advanced Options: about 717 lines.
  - Minimap/presets: about 23 lines.
  - Warning dialog: about 18 lines.
  - Save-preset dialog: about 41 lines.
- `PallyPowerFrame` XML `OnLoad` currently calls `PallyPower_OnLoad()`, which registers the main event set on that frame. Lua construction must preserve the effective startup order and ensure that call still runs with the intended frame as `this`.
- Blizzard-owned templates such as `OptionsCheckButtonTemplate`, `OptionsSliderTemplate`, `UIDropDownMenuTemplate`, `UIPanelCloseButton` and `GameMenuButtonTemplate` may continue to be used through `CreateFrame(..., templateName)`.
- `PallyPower.lua` already has substantial top-level local usage. Avoid a single giant constructor block or a large increase in top-level locals; use scoped constructor/factory functions inside `PallyPowerUI.lua`.

### Active Decisions
- The user has explicitly approved replacing addon-owned XML UI with Lua.
- This migration is parity-first, not a visual redesign or feature rewrite.
- The XML-free UI must be runtime-tested before legacy naming/getglobal cleanup starts.
- After the XML-free baseline passes runtime testing, a second refactor phase may replace repeated generated-name/global lookups with Lua-owned frame tables/references.
- During naming cleanup, retain compatibility aliases for any global whose external compatibility status is uncertain.
- Keep the familiar PallyPower workflow and compatibility focus.
- Aura/Judgement assignment micro-icon clusters remain removed while assignment icons/tooltips remain.
- Judgement capability ranks remain mapped through the underlying Wisdom/Light/Crusader Seal ranks.
- HoJ/LoH/DI utility indicators retain the current softened green/red/grey state tints.

## Recent Relevant Commits
- `2c434b6` - Migrate development docs to the current VanillaTemplate workflow.
- `f434e20` - Record the `1.11.0` stable release back on `dev`.
- `c43d049` - Record user approval of the tested `1.11.0-dev` state for stable promotion.
- `62662b4` - Record the focused Judgement/tint retest state.
- `07883db` - Fix Judgement rank mapping and soften HoJ/LoH/DI status tints.
- `8c520ca` - Final stable `main` tree for `1.11.0` after removing development-only progress documentation.

## Completed / User-Verified
- The addon loads and runs in game on the target environment.
- The prior VanillaTemplate-style structural migration and localization cleanup are working.
- Existing XML + Lua runtime architecture is the current known-good baseline.
- Aura/Judgement assignment micro-icon cleanup is working while assignment icons/tooltips remain.
- Judgement capability ranks match the corresponding underlying Seal ranks.
- HoJ/LoH/DI ready/unavailable/unknown state tinting works with the softened colours.
- Obsolete contributor tooltip text is removed; contributor credits remain in README.
- Stable `main` `1.11.0` was promoted after user approval of the tested development state.

## Implemented / Awaiting Runtime Test
- No XML-to-Lua conversion code has been implemented yet.
- No naming/getglobal cleanup has been implemented yet.
- Not every optional client-extension / legacy-client combination has an individually documented runtime result.
- The exact stable `main` release tree was not separately documented as an in-game test after promotion; it inherits the tested runtime code from the approved `1.11.0-dev` source, with promotion changes limited to release metadata/presentation and development-document removal.

## Static / Automated Checks
- Prior static audit found no stale legacy locale paths.
- Prior static audit found no obvious Lua 5.1-only syntax such as `#`, `string.gmatch`, `table.pack`/`table.unpack`, or `goto`.
- Remaining literal XML text values were identified as placeholders/sample values rather than untranslated UI labels.
- Existing Nampower and UnitXP calls remain behind their existing capability/enable checks.
- XML-to-Lua planning audit completed against current `dev`; no runtime files were changed by that audit.

## Current Issues
- No known release-blocking runtime issues.
- The UI remains XML-backed and the new migration has not started.
- Optional compatibility-path coverage is not exhaustively documented per client/extension combination.

## Testing

### Last Runtime Test
- Version/commit: `1.11.0-dev` / `62662b49f90ebe6dc734904f2e90f50867319e13` was the branch state immediately before the documentation-only approval commit recorded the user's successful focused retest.
- Passed: general addon/UI operation, Aura/Judgement cleanup, corrected Judgement ranks, and softened HoJ/LoH/DI status colours; the user reported most broader smoke checks working.
- Failed: no known release-blocking failures.
- Not tested/documented exhaustively: every optional client-extension / legacy-client combination.

### Required XML-Free Runtime Checkpoint
After the complete addon-owned XML UI has been migrated and `PallyPower.xml` has been removed, but before naming/reference cleanup begins, runtime-test the exact XML-free commit for:
- clean load and `/reload` with no Lua/UI errors;
- Buff Bar appearance, vertical/horizontal layouts, movement, scaling and transparency;
- Blessing buttons, Aura/RF/Seal controls, combined self buffs and Judgement tracker/duration display;
- Assignment frame appearance and all 12 Paladin rows;
- class/special assignments, player overrides, capability icons and tooltips;
- quick controls and eye/visibility controls;
- Advanced Options checkboxes, sliders, editboxes and option persistence;
- minimap button and preset dropdown;
- save/delete warning and preset dialogs;
- SavedVariables/presets loading unchanged;
- assignment reporting, cast/failure feedback and VERSION communication;
- normal keybindings through retained `Bindings.xml`;
- stock/native-client operation without optional DLLs;
- Nampower and UnitXP enhanced paths when available.

Only after the user confirms that exact XML-free commit should naming/getglobal cleanup begin.

### Naming-Cleanup Runtime Checkpoint
After generated-name/global lookup cleanup:
- repeat the relevant full UI/runtime regression pass;
- specifically verify every player-row, class-column and Buff Bar indexed lookup path;
- preserve compatibility aliases where external/global use cannot be ruled out.

## Planned / Next Work

### Stage 1 - Freeze Parity Contract and Scaffold
- Build an explicit parity manifest from current `PallyPower.xml`: object names, types, parents, dimensions, anchors, strata, visibility, backdrops, regions, inherited Blizzard templates, click registration and scripts.
- Record the dynamic `getglobal()` naming families that must continue to resolve.
- Add `PallyPowerUI.lua` to the dev architecture without changing runtime behaviour.
- Implement small scoped Lua constructor helpers suitable for Lua 5.0; avoid excessive top-level locals.
- Do not remove any XML yet until equivalent constructors are proven structurally.

### Stage 2 - Convert Custom Templates and Small Standalone UI
- Convert the nine custom virtual XML templates into Lua constructor/factory functions.
- Convert the scaling frame, warning dialog, save-preset dialog and minimap/preset UI first.
- Preserve all generated names and existing script semantics exactly.
- Static-check parity before moving to larger sections.

### Stage 3 - Convert Advanced Options
- Reproduce all Advanced Options labels, checkboxes, sliders, editboxes, Blizzard template inheritance and script handlers in Lua.
- Preserve existing control globals because runtime code currently references them directly.
- Perform focused static and in-game option checks if useful during development, but do not treat partial testing as the final XML-free checkpoint.

### Stage 4 - Convert Buff Bar
- Recreate blessing/special/combined-self templates and the full Buff Bar in Lua.
- Preserve all child names used by current `getglobal()` code.
- Preserve OnUpdate, movement/scaling, status-bar, tooltip and click behaviour exactly.

### Stage 5 - Convert Assignment UI Last
- Recreate `PallyPowerFrame`, ten class columns, four special columns, twelve Paladin rows, assignment cells, capability regions, quick controls and resize behaviour.
- Preserve exact generated global names and `this`/`arg1` semantics during parity migration.
- Ensure `PallyPower_OnLoad()` still registers events on the intended main frame.
- This is the highest-risk stage and should be completed before removing the XML loader.

### Stage 6 - Complete XML-Free Parity Baseline
- Perform a full static parity review against the frozen XML manifest.
- Verify all expected named objects and dynamic lookup families resolve.
- Verify all XML scripts have equivalent `SetScript` handlers.
- Verify Lua 5.0 compatibility and local-variable limits.
- Remove `PallyPower.xml` and its TOC entry only after full parity.
- Keep `Bindings.xml`.
- Commit the complete XML-free parity state as a coherent development checkpoint.
- Stop here for the required user runtime test. Do not begin naming machinery cleanup before user approval of this exact commit.

### Stage 7 - Post-Validation Naming / Reference Refactor
- After the XML-free commit passes runtime testing, replace repeated string-built/global UI lookups with Lua-owned frame references/tables where practical.
- Likely structures include indexed player rows, class columns and Buff Bar button arrays, but design the exact tables from actual access patterns rather than imposing a speculative abstraction.
- Keep compatibility globals/aliases wherever external use is possible or uncertain.
- Do not combine this stage with behaviour, data-model or protocol changes.
- Runtime-test again before treating this cleaner internal architecture as stable.

## Deferred / Out of Scope
- Artwork flattening or renaming.
- SavedVariables redesign.
- Communication protocol redesign.
- Keybinding-system redesign or removal of `Bindings.xml`.
- Visual redesign of Buff Bar, assignment UI or Advanced Options.
- Feature expansion unrelated to the migration.
- Broader module split beyond the deliberate `PallyPowerUI.lua` separation.
- Modernizing legacy `this`/`arg1` callback style before the XML-free parity checkpoint.

## Release / Promotion Notes
- Current stable baseline: `main` / `1.11.0` at `8c520ca1335f6de23409c2b94dd7b7e8a52c2b09`.
- Main-only or release-only content to preserve: stable TOC Title/Version metadata and the README release heading/version. At the verified baseline, `main` says README `v1.11.0` while `dev` still says `v1.10.20`; reconcile deliberately during a future promotion.
- Stable `main` excludes development progress/status documentation.
- Known validation debt accepted for the current release: the exact promoted stable tree did not receive a separately documented in-game run after release-only metadata/presentation/doc-removal changes.
- External/runtime prerequisites: none required. Nampower and UnitXP are optional enhancements, not hard dependencies.
- Do not promote the XML-to-Lua branch merely because static parity passes; the complete XML-free commit requires user runtime validation first.

## Exact Next Step
Start Stage 1 on `dev`: verify the live head against this handoff, build the frozen XML parity manifest from the current `PallyPower.xml`, add the initial `PallyPowerUI.lua` scaffolding/constructor helpers without changing runtime behaviour, and preserve every existing UI global/name contract. Do not start naming/getglobal cleanup until the complete XML-free parity commit has passed the required user runtime test.
