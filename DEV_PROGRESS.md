# Development Progress

## Current
- Branch: `dev`
- Version: `1.11.0-dev`
- Current Stage 2 implementation head before this handoff update: `1cd5026eae00e9ef0b405301a5f971d69f6e3fbb`
- Stable baseline: `main` / `1.11.0` at `8c520ca1335f6de23409c2b94dd7b7e8a52c2b09`
- Goal: Convert the addon-owned UI from `PallyPower.xml` to Lua in staged parity-preserving steps, then separately modernize the legacy frame-naming/getglobal machinery after an explicit runtime-tested XML-free baseline is established.
- Current scope boundary: This is a UI construction/refactor project only. Preserve runtime behaviour, appearance, compatibility contracts, data formats and optional-extension semantics unless a later request explicitly changes them.

## Current Design / Development Contract

### Architecture / Ownership
- Current runtime is mixed Lua/XML: `PallyPower.lua` owns core logic, `PallyPowerUI.lua` now constructs the Stage 2 standalone UI, and `PallyPower.xml` still owns the large Advanced Options, Buff Bar and Assignment UI sections.
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
- The Stage 1 frozen parity manifest is `docs/XML_UI_PARITY_MANIFEST.md`, captured from `PallyPower.xml` blob `9cc53b2921a3a0749e1fb8f5bd26d29487b9fad2` at pre-Stage-1 head `c0950332d1c6e32c315ae7a44620cb05a53f2010`.
- `PallyPower.xml`: approximately 2,845 lines.
- `PallyPower.lua`: approximately 6,962 lines.
- Exact manifest counts: 9 custom virtual templates, 39 Frames, 77 Buttons, 19 CheckButtons, 2 Sliders, 3 EditBoxes, 1 StatusBar, 81 Textures and 59 FontStrings; 281 total UI objects, 277 named objects, and 149 XML script handlers.
- At the frozen pre-migration baseline, `PallyPower.lua` created only three frames directly, confirming that this is a substantial UI-construction migration rather than a loader cleanup.
- Lua contains 118 `getglobal()` call sites; the frozen manifest records 55 distinct dynamic argument expressions, including generated families such as:
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
- Lua constructor/factory functions are not XML virtual templates. While any remaining XML object still uses `inherits="PP...Template"`, keep that virtual XML template definition available; do not remove it merely because an equivalent Lua factory exists. Remove a custom virtual XML template only when all of its XML consumers have also moved to Lua.
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
- `1cd5026` - Migrate the Stage 2 standalone UI to Lua and add Lua equivalents for all nine custom virtual templates.
- `000fcc2` - Record the completed Stage 1 scaffold and Stage 2 handoff boundary.
- `f6ee37e` - Freeze the XML UI parity manifest and add the Stage 1 Lua UI scaffold.
- `c095033` - Document the staged XML-to-Lua migration plan.
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
- Stage 1 remains the frozen parity/scaffold baseline at `f6ee37e4ed644dd1841d84918595530f5a2c36d6`; `docs/XML_UI_PARITY_MANIFEST.md` remains unchanged and authoritative for the migration.
- Stage 2 is implemented at `1cd5026eae00e9ef0b405301a5f971d69f6e3fbb`.
- `PallyPowerUI.lua` now contains Lua factory/constructor equivalents for all nine addon-owned virtual XML templates while the corresponding virtual XML template definitions remain in `PallyPower.xml` for their still-XML-backed consumers.
- The scaling frame, minimap/preset UI, warning dialog and save-preset dialog are now constructed live from Lua with the existing global names, `$parent` expansions, Blizzard template inheritance, scripts, click registration, sizing, anchors, backdrop/texture/font settings and visibility semantics preserved.
- `PallyPower.xml` still owns the Advanced Options, Buff Bar and Assignment UI. `PallyPower.xml` remains in the TOC and no naming/getglobal cleanup has begun.
- No Stage 2 in-game smoke test was performed. This is permitted by the staged plan; the required hard runtime checkpoint remains the complete XML-free Stage 6 commit.
- Not every optional client-extension / legacy-client combination has an individually documented runtime result.
- The exact stable `main` release tree was not separately documented as an in-game test after promotion; it inherits the tested runtime code from the approved `1.11.0-dev` source, with promotion changes limited to release metadata/presentation and development-document removal.

## Static / Automated Checks
- Prior static audit found no stale legacy locale paths.
- Remaining literal XML text values were identified as placeholders/sample values rather than untranslated UI labels.
- Existing Nampower and UnitXP calls remain behind their existing capability/enable checks.
- Frozen manifest coverage remains 281 XML UI objects, 277 named objects, 149 XML script handlers, 8 explicit `RegisterForClicks` sites and 55 distinct dynamic `getglobal()` argument expressions.
- Focused Stage 2 parity review against `docs/XML_UI_PARITY_MANIFEST.md` confirmed all nine Lua template factory equivalents are present and all nine matching virtual XML template definitions remain available because each still has XML inheritance consumers.
- Focused Stage 2 parity review confirmed the four migrated standalone roots are absent from XML and recreated in Lua, including their explicit globals plus `$parent`-generated warning/save child globals.
- The large Advanced Options, Buff Bar and Assignment frame roots remain XML-backed; the Stage 2 implementation diff changes only `PallyPowerUI.lua` and `PallyPower.xml`.
- Stage 2 retained the existing scaling `OnUpdate`, minimap click/tooltip/dropdown initialization, warning/save dialog scripts and click registration semantics; constructor-time work corresponding to XML `OnLoad` is explicitly performed where required.
- Stage 2 adds no naming/reference cleanup and does not modify `PallyPower.lua`, the TOC, locales, SavedVariables, protocol, keybindings, Nampower or UnitXP logic.
- `PallyPowerUI.lua` has no obvious post-Lua-5.0 syntax patterns such as `#`, `goto`, `string.gmatch`, `table.pack` or `table.unpack`; new constructor locals are function-scoped rather than added as top-level locals.
- Canonical real Lua 5.0.2 compiler validation passed for the exact Stage 2 Lua blobs using VanillaTemplate `tools/lua50/check_lua50.sh`: `PallyPower.lua` blob `c0901bb34370ccc36c217908f9cd91c9444c2425`, `PallyPowerUI.lua` blob `5af0a16be251864b069323edd73b511c0ffc4a30`, and `locales/enUS.lua` blob `a6a022b5a540bf4c99d61754f72bea7421471eeb`. Validation run `36010438496` completed successfully with `Lua 5.0.2 syntax check passed: 3 file(s).`
- The temporary VanillaTemplate validation branch was reset to the VanillaTemplate baseline after the successful check; no validation workflow was added to PallyPowerVanilla `dev`.

## Current Issues
- No known release-blocking runtime issues.
- The live UI is intentionally mixed during the staged migration: the Stage 2 standalone sections are Lua-backed while Advanced Options, Buff Bar and Assignment remain XML-backed.
- Stage 2 has passed static parity and the real Lua 5.0.2 compiler check but has not been tested in game.
- Optional compatibility-path coverage is not exhaustively documented per client/extension combination.

## Testing

### Last Runtime Test
- Version/commit: `1.11.0-dev` / `62662b49f90ebe6dc734904f2e90f50867319e13` was the branch state immediately before the documentation-only approval commit recorded the user's successful focused retest.
- Passed: general addon/UI operation, Aura/Judgement cleanup, corrected Judgement ranks, and softened HoJ/LoH/DI status colours; the user reported most broader smoke checks working.
- Failed: no known release-blocking failures.
- Not tested/documented exhaustively: every optional client-extension / legacy-client combination.

### Stage 2 Validation State
- Static parity review: passed for the documented Stage 2 boundary.
- Real Lua 5.0.2 compiler check: passed for all three runtime Lua files.
- In-game smoke test: not performed.
- Blocking runtime test: none required at Stage 2; continue to Stage 3 without claiming runtime validation.

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

### Stage 1 - Freeze Parity Contract and Scaffold — COMPLETE at `f6ee37e`
- Frozen `docs/XML_UI_PARITY_MANIFEST.md` records object names/types/parents, dimensions, anchors, frame properties, backdrops, regions, inheritance, click registration and all script bodies.
- Dynamic `getglobal()` naming expressions are frozen for the parity phase.
- `PallyPowerUI.lua` is loaded but constructs no live UI; helper functions cover XML `$parent` name expansion plus basic frame/texture/font-string construction, sizing and anchoring.
- No XML was removed or changed in Stage 1.

### Stage 2 - Convert Custom Templates and Small Standalone UI — COMPLETE at `1cd5026`
- Lua factory/constructor equivalents exist for all nine custom virtual templates.
- Scaling frame, minimap/preset UI, warning dialog and save-preset dialog now construct live from Lua.
- Existing global/generated names, `$parent` expansion, handlers, click registration, anchors, sizes and appearance contracts were preserved against the frozen manifest.
- All nine custom virtual XML template definitions remain in `PallyPower.xml` because later XML sections still inherit from them.
- Focused static parity and the canonical Lua 5.0.2 compiler check passed; no Stage 2 in-game test was required or performed.

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
Start Stage 3 on `dev` from the Stage 2 implementation baseline `1cd5026eae00e9ef0b405301a5f971d69f6e3fbb`: migrate only the Advanced Options UI from `PallyPower.xml` into `PallyPowerUI.lua`, preserving every existing control global/name, Blizzard template inheritance, `$parent` expansion, script handler, anchor, size, appearance, option persistence and Lua 5.0/WoW 1.12.1 runtime semantic. Keep every custom virtual XML template definition required by the still-XML-backed Buff Bar or Assignment UI, do not migrate those later sections yet, do not remove `PallyPower.xml`, and do not begin naming/getglobal cleanup. After Stage 3, perform focused static parity against the frozen manifest and rerun the canonical real Lua 5.0.2 compiler check. The hard user runtime checkpoint remains the complete XML-free Stage 6 commit.
