# Development Progress

## Current
- Branch: `dev`
- Version: `1.11.14-dev`
- Stage 6 accepted runtime implementation: `69ebb9d0a7a1aba95f4fe0dd448c3a21dde97047`
- Stage 7 first-slice Lua implementation: `ceec82cbbee32d430101b2f76dd4b1d4232c1a20`
- Stage 7 first-slice user-tested build: `03f988f66b912381585a5b487ed16ad7a68b14da` (`1.11.2-dev`)
- Stage 7 second-slice runtime implementation: `4a31fcb795b5e01d23d8cfe55ba42d1596709014` (`1.11.3-dev`)
- Stage 7 second-slice user-tested build: `4a31fcb795b5e01d23d8cfe55ba42d1596709014` (`1.11.3-dev`)
- Stage 7 third-slice runtime implementation: `4b817936e403bc455663a7c89909ccbd7e3615a8` (`1.11.4-dev`)
- Stage 7 third-slice user-tested build: `4b817936e403bc455663a7c89909ccbd7e3615a8` (`1.11.4-dev`)
- Stage 7 fourth-slice runtime implementation: `d3dd69006e619ff8d26318ec0b970b440ab784dc` (`1.11.5-dev`)
- Stage 7 fourth-slice user-tested build: `d3dd69006e619ff8d26318ec0b970b440ab784dc` (`1.11.5-dev`)
- Stage 7 fifth-slice runtime implementation: `98f0ecbdc7cb77749041d288b3b511cf6381b173` (`1.11.6-dev`)
- Stage 7 fifth-slice user-tested build: `98f0ecbdc7cb77749041d288b3b511cf6381b173` (`1.11.6-dev`)
- Stage 7 sixth-slice runtime implementation: `c5d4eb0f8cca41d590a491ea31094d09c6aeec1b` (`1.11.7-dev`)
- Stage 7 sixth-slice user-tested build: `c5d4eb0f8cca41d590a491ea31094d09c6aeec1b` (`1.11.7-dev`)
- Stage 7 seventh-slice runtime implementation: `57ed6a69dd3660c3d0348b7e0288cc84d00d0836` (`1.11.8-dev`)
- Stage 7 seventh-slice user-tested build: `57ed6a69dd3660c3d0348b7e0288cc84d00d0836` (`1.11.8-dev`)
- Stage 7 eighth-slice runtime implementation: `915c61ac624e571e6d07cc092abefc4bd4003e7d` (`1.11.9-dev`)
- Stage 7 eighth-slice user-tested build: `915c61ac624e571e6d07cc092abefc4bd4003e7d` (`1.11.9-dev`)
- Stage 7 ninth-slice runtime implementation: `177a980a97cffc1cad22746dfea0490f40e89ca6` (`1.11.10-dev`)
- Stage 7 ninth-slice user-tested build: `177a980a97cffc1cad22746dfea0490f40e89ca6` (`1.11.10-dev`)
- Post-Stage-7 consolidated cleanup runtime implementation: `3fb5aa00086aa509c6df8fc47a3a1d7c712cd182` (`1.11.11-dev`)
- NoRF overlay corrective runtime implementation: `2e6a8e5bd3a78c9960146ed35bc31900a58f744a` (`1.11.12-dev`)
- NoRF direct-icon-tint corrective runtime implementation: `833881ebdcefe7f59e7b8b7d9d18157ea7356172` (`1.11.13-dev`)
- RF/Judgement grid-wheel routing corrective runtime implementation: `d0a44be85627a05d3c4e621fc490b44f951d88da` (`1.11.14-dev`)
- Branch head before this handoff update: `d0a44be85627a05d3c4e621fc490b44f951d88da`
- Stage 6 acceptance/status commit: `51847fc58ad5cba1fa4734c1a7017fdb62915cc2`
- Stable baseline: `main` / `1.11.0` at `8c520ca1335f6de23409c2b94dd7b7e8a52c2b09`
- Goal: Convert the addon-owned UI from `PallyPower.xml` to Lua in staged parity-preserving steps, then separately modernize the legacy frame-naming/getglobal machinery after an explicit runtime-tested XML-free baseline is established.
- Current scope boundary: Stage 7 is complete. The consolidated post-Stage-7 cleanup is largely user-verified from `1.11.11-dev`. `1.11.12-dev` made the NoRF overlay visible but exposed a mouse-wheel regression while the visible overlay was present. `1.11.13-dev` removes that extra visible overlay region entirely and implements NoRF by tinting the existing RF icon itself; only this rendering/input delta requires immediate retest. Preserve compatibility globals and existing assignment/comms formats.

## Current Design / Development Contract

### Architecture / Ownership
- Current addon-owned UI runtime is XML-free: `PallyPower.lua` owns core logic and `PallyPowerUI.lua` constructs the standalone UI, Advanced Options, Buff Bar and Assignment UI. `PallyPower.xml` and all nine addon-owned virtual XML template definitions are removed; `PallyPowerVanilla.toc` now loads only the locale and two Lua runtime files.
- Stage 6 runtime architecture:
  - `locales/enUS.lua`
  - `PallyPower.lua`
  - `PallyPowerUI.lua`
  - `Bindings.xml`
- `PallyPowerUI.lua` should replace addon-owned UI/layout XML one-for-one. Do not fold the converted UI directly into `PallyPower.lua`; keeping a separate Lua chunk preserves the existing logic/UI separation and reduces Lua 5.0 top-level local-pressure risk.
- `Bindings.xml` remains intentionally. Vanilla WoW discovers it specially for normal Key Bindings UI integration; it is not part of the addon-owned UI/layout migration.
- `PallyPowerVanilla.toc` remains the addon metadata/version source of truth.
- Development-version communication rule: if `ADDON_VERSION` contains the `-dev` suffix, `PallyPower_SendVersion()` must not send the `VERSION ...` addon message. Dev builds still participate in all normal PallyPower assignment/state communications; only version advertisement is suppressed. Keep the version-communication code in place behind this runtime check.
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
- At the frozen XML baseline, `PallyPowerFrame` `OnLoad` called `PallyPower_OnLoad()`, which registers the main event set on that frame. Stage 5 preserves that contract by temporarily binding global `this` to the Lua-created `PallyPowerFrame` for the constructor-time `PallyPower_OnLoad()` call, then restoring the prior `this` value.
- Blizzard-owned templates such as `OptionsCheckButtonTemplate`, `OptionsSliderTemplate`, `UIDropDownMenuTemplate`, `UIPanelCloseButton` and `GameMenuButtonTemplate` may continue to be used through `CreateFrame(..., templateName)`.
- All nine addon-owned custom template contracts are now owned by Lua constructor/factory functions. Stage 6 removed the final six Assignment virtual XML definitions together with `PallyPower.xml`; no runtime XML object inherits from an addon-owned `PP...Template`.
- `PallyPower.lua` already has substantial top-level local usage. Avoid a single giant constructor block or a large increase in top-level locals; use scoped constructor/factory functions inside `PallyPowerUI.lua`.

### Active Decisions
- The user has explicitly approved replacing addon-owned XML UI with Lua.
- This migration is parity-first, not a visual redesign or feature rewrite.
- The XML-free UI must be runtime-tested before legacy naming/getglobal cleanup starts.
- Stage 7 now replaces repeated generated-name/global lookups with Lua-owned frame references/tables in small runtime-tested slices.
- During naming cleanup, retain compatibility aliases for any global whose external compatibility status is uncertain.
- Keep the familiar PallyPower workflow and compatibility focus.
- Aura/Judgement assignment micro-icon clusters remain removed while assignment icons/tooltips remain.
- Judgement capability ranks remain mapped through the underlying Wisdom/Light/Crusader Seal ranks.
- HoJ/LoH/DI utility indicators retain the current softened green/red/grey state tints.

## Recent Relevant Commits
- `d0a44be` - Fix grid mouse-wheel routing for RF/Judgement by mapping `R`/`J` tokens before numeric coercion; bump to `1.11.14-dev`.
- `833881e` - Remove the separate visible NoRF overlay region and tint the existing RF icon directly for NoRF; restore normal icon tint when cycling away and bump to `1.11.13-dev`.
- `2e6a8e5` - Fix the invisible NoRF overlay by using a true solid red texture with alpha instead of tinting `UI-Tooltip-Background`; preserve the hidden legacy named X regions and bump to `1.11.12-dev`.
- `145b0ec` - Sync the updated development rulebook; current canonical compiler validation is Lua 5.0.3. No addon runtime files changed.
- `3fb5aa0` - Bundle the post-Stage-7 runtime cleanups into `1.11.11-dev`: suppress VERSION advertisement on `-dev`, unify internal Paladin-state reads on `PP_IsPally` while retaining `IsPally`, restore RF/Judgement preset loading/saving, live-refresh override tooltips, enable/fix mouse-wheel cycling, and replace the visible NoRF X with red icon overlays while preserving legacy named X regions hidden.
- `0cfdf96` - Close Stage 7 after the final compatibility-bound `getglobal()` audit; no addon runtime files changed.
- `177a980` - Replace the eight self-buff/special-layout `getglobal()` lookups with constructor-owned direct references and bump the testable build to `1.11.10-dev`.
- `47ad76b` - Accept the eighth Stage 7 Judgement-child runtime test and note the observed return of the duration bar; no addon runtime files changed.
- `915c61a` - Replace the five Judgement Buff Bar child `getglobal()` lookups with constructor-owned direct child references and bump the testable build to `1.11.9-dev`.
- `34f86f7` - Accept the seventh Stage 7 special-button runtime test and broaden the deferred mouse-wheel investigation; no addon runtime files changed.
- `57ed6a6` - Replace the five fixed Buff Bar RF/Aura/Seal identity `getglobal()` comparisons with direct `PallyPowerUIRefs.buffSpecialButtons` references and bump the testable build to `1.11.8-dev`.
- `f535339` - Accept the sixth Stage 7 constructor-icon runtime test and record the deferred NoRF red-overlay visual cleanup; no addon runtime files changed.
- `c5d4eb0` - Replace the two remaining `PallyPowerUI.lua` constructor icon-anchor `getglobal()` lookups with direct constructor-owned icon references, preserve generated globals, and bump the testable build to `1.11.7-dev`.
- `a842f45` - Record deferred override-tooltip live-refresh and player-button mouse-wheel follow-ups; no addon runtime files changed.
- `c910f16` - Accept the fifth Stage 7 player-text runtime test and document the legacy tooltip/mouse-wheel observations; no addon runtime files changed.
- `98f0ecb` - Replace the three class-group player-button generated `Text` `getglobal()` reads with the constructor-owned `ppText` reference and bump the testable build to `1.11.6-dev`.
- `b487db4` - Accept the fourth Stage 7 Save Preset runtime test and unblock the fifth lookup slice; no addon runtime files changed.
- `cc7242f` - Document the fourth Stage 7 compiler provenance and focused Save Preset runtime-test gate; no addon runtime files changed.
- `d3dd690` - Replace the three Save Preset dialog `OkayButton` `getglobal()` lookups with one constructor-owned direct reference, preserve global `PallyPowerSaveMenuOkayButton`, and bump the testable build to `1.11.5-dev`.
- `4b81793` - Replace the two constructor-time dialog HeaderTexture `getglobal()` lookups with direct local texture references while preserving the generated named textures.
- `ce404cd` - Bump the Stage 7 testable build to `1.11.4-dev` before the third-slice runtime change.
- `88c4812` - Accept the Stage 7 second-slice Buff Bar root-reference runtime test and document the pre-existing test-mode visibility mismatch.
- `aa8f924` - Document the Stage 7 second-slice compiler provenance and focused runtime-test gate; no addon runtime files changed.
- `4a31fcb` - Add a direct `PallyPowerUIRefs.buffBar` root reference, replace the three fixed `getglobal("PallyPowerBuffBar")` visibility lookups, preserve the named global, and bump the testable build to `1.11.3-dev`.
- `1cbbd4f` - Sync the canonical development rulebook, including the canonical Lua 5.0.2 compiler-check requirement; no addon runtime files changed.
- `8ec8217` - Fix and clarify the new addon build-versioning rule in `dev_rulebook.md`; each new testable build must increment the numeric TOC version.
- `03f988f` - Bump the Stage 7 testable build to `1.11.2-dev`; runtime Lua is unchanged from `ceec82c`.
- `ceec82c` - Remove the last player-row name parsing from the first Stage 7 indexed-reference slice.
- `9c73559` through `259437c` / `524664a` / `31d82e1` - Add and consume Lua-owned indexed references for player rows, class columns/player buttons and Buff Bar blessing buttons while preserving named globals and legacy behavior.
- `1188304` - Fix the pre-existing Advanced Options Scan1/Scan2 input-border distortion by replacing malformed negative texture dimensions with Vanilla `Common-Input-Border` geometry only.
- `51847fc` - Accept Stage 6 after the full AQ40 parity run and unblock the previously deferred scan EditBox border fix.
- `ca5c7cb` - Record the corrected XML-free startup success and the broader AQ40 runtime gate that remained pending.
- `69ebb9d` - Fix the XML-free save-dialog startup failure by omitting the invalid Lua `SetHistoryLines(0)` replay, remove temporary startup diagnostics, and bump development version to `1.11.1-dev`.
- `f071281` - Narrow temporary Stage 6 diagnostics to the four standalone constructors after the first diagnostic run identified the standalone phase.
- `52f6d2d` - Add temporary Stage 6 startup diagnostics that catch and print the first failing root UI-construction phase/error directly to chat.
- `772472b` - Fix the XML-free Buff Bar constructor-time `OnLoad` context by binding legacy global `this` to the Lua-created blessing/special button during the manual replay.
- `a526f54` - Complete the XML-free Stage 6 parity baseline by removing `PallyPower.xml` and its TOC entry while keeping runtime logic, names and lookup contracts unchanged.
- `ac0c28b` - Migrate the Assignment UI from XML to Lua while retaining `PallyPower.xml` and the six Assignment virtual templates for the Stage 6 boundary.
- `87dbe79` - Migrate the Buff Bar UI from XML to Lua and remove the three Buff-Bar-only XML virtual templates.
- `4d55d79` - Separate the Stage 3 Advanced Options construction entry point from the Stage 2 standalone wrapper.
- `02cbc11` - Migrate the Advanced Options UI from XML to Lua.
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
- Stage 6 XML-free parity is user-accepted on exact runtime implementation `69ebb9d0a7a1aba95f4fe0dd448c3a21dde97047` (`1.11.1-dev`). During a full AQ40 raid the user reported that PallyPower behaved exactly as before and no differences or regressions were noticed throughout the run. This is the required broad real-raid parity acceptance; it does not claim that every optional DLL/client combination was separately exercised.
- Post-Stage-6 Advanced Options Scan1/Scan2 border correction `1188304105d38fd4172acc9c43b8f6f47ea6c30f` is user-verified fixed in game. The previously stretched scan EditBox borders now render correctly.
- Stage 7 first-slice build `03f988f66b912381585a5b487ed16ad7a68b14da` (`1.11.2-dev`) is user-verified in live group/raid use. The user reports PallyPower is working as expected; the Assignment UI and Buff Bar are visibly populated, and live blessing-state tracking correctly detected a tank warrior removing Salvation.
- Stage 7 second-slice build `4a31fcb795b5e01d23d8cfe55ba42d1596709014` (`1.11.3-dev`) is user-verified for the changed Buff Bar root-reference path on a warrior: the Buff Bar remains hidden normally, `/pp` still opens Assignments, and `/pp test prot` visibly shows the Buff Bar before the existing normal UI update immediately hides it again. The blink proves the new direct root reference executes the show path successfully; the subsequent hide is existing test-mode/visibility behavior, not a reference failure.
- Stage 7 third-slice build `4b817936e403bc455663a7c89909ccbd7e3615a8` (`1.11.4-dev`) is user-verified: the preset UI works normally, including the New Save dialog and existing preset Save/Delete warning paths, with no header/title/layout or control regression observed.

## Implemented / Awaiting Runtime Test
- Stage 1 remains the frozen parity/scaffold baseline at `f6ee37e4ed644dd1841d84918595530f5a2c36d6`; `docs/XML_UI_PARITY_MANIFEST.md` remains unchanged and authoritative for the migration.
- Stage 2 remains implemented at `1cd5026eae00e9ef0b405301a5f971d69f6e3fbb`.
- Stage 3 remains implemented at `4d55d79d9c4fd908d31375f1d6b01c8e1e960b2c`; the implementation began at `02cbc118e88a654fe59ec9bd966717499fa4b094` and the follow-up commit cleanly separated the Stage 3 construction entry point from the Stage 2 wrapper.
- Stage 4 is implemented at `87dbe794ce50e915d8e0a31c263c23d48b1c6dfe`.
- Stage 5 is implemented at `ac0c28b2fe913b5ea0f313bf011e678a6923c6e1`.
- Stage 6 XML-free baseline `a526f5486cf421b35506bab5cb50068a75bb1a6e` received its first user runtime test via branch head `d5feca644fbe4774ff6b201364fbcaa309d9034f` (docs-only delta after `a526f548`) and failed at startup parity: the addon was loaded, but no PallyPower UI was visible and `/pp` did not work.
- Targeted parity fix `772472b1c2cb47827ad8e17e9f5720da19615f45` was user-retested via docs-only head `64036ac295d58726e591fcfec72472eb4267b85a` and did **not** restore startup: the addon still appeared in the in-game addon list, but no PallyPower UI was visible and `/pp` still did not work. Therefore the earlier Buff Bar `this` issue was real but not the only startup blocker.
- Diagnostic runtime `52f6d2d10d7a8a8fa5a9f1ac3ef88c8a9ab61fdd` identified the failure inside the standalone phase; the user's full error then pinpointed `PallyPowerUI.lua:1112`, `PallyPowerSaveMenuNameEB:SetHistoryLines(0)`. XML accepted `historyLines="0"`, but the 1.12.1 Lua setter rejected the zero value at runtime.
- A finer standalone diagnostic `f0712815e04f1bf997b00f95a99229138419499d` was prepared, but the exact failing line was already supplied by the user, so the diagnostic scaffolding was removed in the real fix rather than retained.
- Corrective runtime `69ebb9d0a7a1aba95f4fe0dd448c3a21dde97047` removes only the invalid `SetHistoryLines(0)` replay, restores direct non-diagnostic construction, and bumps the addon to `1.11.1-dev`. Focused user retest passed the startup gate: the addon loads visibly, `/pp` works, and the migrated UI appears correct on initial inspection. Stage 6 subsequently passed the AQ40 parity test and is user-accepted.
- `PallyPowerUI.lua` contains Lua factory/constructor equivalents for all nine addon-owned virtual XML templates and constructs every addon-owned UI section: standalone UI, Advanced Options, Buff Bar and Assignment UI.
- The Buff Bar migration preserves the root/title globals, Aura/RF/Seal controls, hidden combined-self and Judgement controls, generated `PallyPowerBuffBarBuff1..10` families and their child names, status bar, inherited click/tooltip/mouse-wheel behavior, movement/scaling hooks, OnUpdate, layout anchors and visibility semantics.
- The Assignment migration preserves `PallyPowerFrame`, the ten class columns, four special columns, twelve Paladin row families, assignment cells, capability-hover regions, quick controls, eye controls, Judgement failed-refresh control, resize behavior, generated child globals and existing dynamic `getglobal()` naming contracts.
- `PallyPower_OnLoad()` is still executed against the intended main Assignment frame by temporarily binding global `this` to the Lua-created `PallyPowerFrame`; the root `OnEvent`, mouse, hide and title `OnUpdate` handlers retain the legacy `event`/`this`/`arg1` semantics.
- `PallyPower.xml` and all nine custom virtual XML template definitions are now removed; the TOC loads `locales/enUS.lua`, `PallyPower.lua` and `PallyPowerUI.lua` only.
- `Bindings.xml` remains intentionally separate and unchanged.
- Stage 7 first slice is implemented: `PallyPowerUIRefs` owns deterministic references for player rows, class icons/groups, class-group player buttons and Buff Bar blessing buttons; legacy named globals are still created unchanged as compatibility aliases.
- Stage 7 second slice is implemented at `4a31fcb795b5e01d23d8cfe55ba42d1596709014`: `PallyPowerUIRefs.buffBar` now owns the Buff Bar root reference, and the three fixed root show/hide lookups use that direct reference. The constructor still creates global `PallyPowerBuffBar` unchanged for compatibility.
- Stage 7 third slice is implemented at `4b817936e403bc455663a7c89909ccbd7e3615a8` (`1.11.4-dev`): `CreateWarningDialog()` and `CreateSavePresetDialog()` retain their generated `$parentHeaderTexture` named globals, but each title now anchors directly to the texture object just created instead of resolving that object back through `getglobal()`.
- Stage 7 fourth slice is implemented at `d3dd69006e619ff8d26318ec0b970b440ab784dc` (`1.11.5-dev`): `CreateSavePresetDialog()` retains the named global `PallyPowerSaveMenuOkayButton`, captures that freshly created button in local `okayButton`, and its existing `OnTextChanged` callback now uses the direct reference for the blank/new-name/existing-name enable-state branches. Legacy `this` callback semantics and save/overwrite behavior are unchanged.
- Stages 2 through 5 were not tested independently in game. Stage 6 startup has now produced three useful runtime results: the original XML-free baseline failed before initialization, the `772472b` Buff Bar `this` fix still failed startup, and diagnostic runtime `52f6d2d` localized the remaining failure to the save-dialog `SetHistoryLines(0)` replay. Corrective runtime `69ebb9d0a7a1aba95f4fe0dd448c3a21dde97047` subsequently passed focused startup testing and a full AQ40 raid parity run; Stage 6 is now user-accepted.
- Not every optional client-extension / legacy-client combination has an individually documented runtime result.
- The exact stable `main` release tree was not separately documented as an in-game test after promotion; it inherits the tested runtime code from the approved `1.11.0-dev` source, with promotion changes limited to release metadata/presentation and development-document removal.

## Static / Automated Checks
- Prior static audit found no stale legacy locale paths.
- Remaining literal XML text values were identified as placeholders/sample values rather than untranslated UI labels.
- Existing Nampower and UnitXP calls remain behind their existing capability/enable checks.
- Frozen manifest coverage remains 281 XML UI objects, 277 named objects, 149 XML script handlers, 8 explicit `RegisterForClicks` sites and 55 distinct dynamic `getglobal()` argument expressions.
- Focused Stage 2 parity review against `docs/XML_UI_PARITY_MANIFEST.md` confirmed all nine Lua template factory equivalents are present and all nine matching virtual XML template definitions remain available because each still has XML inheritance consumers.
- Focused Stage 2 parity review confirmed the four migrated standalone roots are absent from XML and recreated in Lua, including their explicit globals plus `$parent`-generated warning/save child globals.
- Stage 2 left the large Advanced Options, Buff Bar and Assignment frame roots XML-backed; Stage 3 moved only Advanced Options to Lua while Buff Bar and Assignment remain XML-backed.
- Stage 2 retained the existing scaling `OnUpdate`, minimap click/tooltip/dropdown initialization, warning/save dialog scripts and click registration semantics; constructor-time work corresponding to XML `OnLoad` is explicitly performed where required.
- Stage 2 adds no naming/reference cleanup and does not modify `PallyPower.lua`, the TOC, locales, SavedVariables, protocol, keybindings, Nampower or UnitXP logic.
- `PallyPowerUI.lua` has no obvious post-Lua-5.0 syntax patterns such as `#`, `goto`, `string.gmatch`, `table.pack` or `table.unpack`; new constructor locals are function-scoped rather than added as top-level locals.
- Canonical real Lua 5.0.2 compiler validation passed for the exact Stage 2 Lua blobs using VanillaTemplate `tools/lua50/check_lua50.sh`: `PallyPower.lua` blob `c0901bb34370ccc36c217908f9cd91c9444c2425`, `PallyPowerUI.lua` blob `5af0a16be251864b069323edd73b511c0ffc4a30`, and `locales/enUS.lua` blob `a6a022b5a540bf4c99d61754f72bea7421471eeb`. Validation run `36010438496` completed successfully with `Lua 5.0.2 syntax check passed: 3 file(s).`
- The temporary VanillaTemplate validation branch was reset to the VanillaTemplate baseline after the successful Stage 2 check; no validation workflow was added to PallyPowerVanilla `dev`.
- Focused Stage 3 parity review against `docs/XML_UI_PARITY_MANIFEST.md` passed for all 59 Advanced Options object rows and all 21 script-bearing Advanced Options entries. The XML root is absent, all documented names/`$parent` families and Blizzard inheritance paths are recreated in Lua, and the documented layout, backdrop, scan persistence, checkbox handlers and slider ranges/steps are represented.
- Stage 3 preserves all nine custom virtual XML template definitions, keeps the Buff Bar and Assignment XML roots intact, keeps `PallyPower.xml` in the TOC, and leaves `Bindings.xml` present.
- The Stage 3 delta from handoff `72ea9db3c6d8beea0c2ff6941f45da6faf662221` through implementation `4d55d79d9c4fd908d31375f1d6b01c8e1e960b2c` changes only `PallyPowerUI.lua` and `PallyPower.xml`; it does not modify `PallyPower.lua`, locales, TOC metadata, SavedVariables, protocol, keybindings, Nampower or UnitXP logic.
- Canonical real Lua 5.0.2 compiler validation passed for the exact Stage 3 runtime Lua payload at `4d55d79d9c4fd908d31375f1d6b01c8e1e960b2c` using VanillaTemplate `tools/lua50/check_lua50.sh`. Validation run `36015896723` completed successfully with `Lua 5.0.2 syntax check passed: 3 file(s).`
- The temporary Stage 3 VanillaTemplate validation PR was closed and branch `validate-pallypower-stage3` was reset to VanillaTemplate baseline `9093fac60f210dedd87d5e2d0f265a97494f999f`; no validation workflow or checker payload was added to PallyPowerVanilla `dev`.
- Focused Stage 4 parity review against `docs/XML_UI_PARITY_MANIFEST.md` passed for all 39 frozen Buff Bar/template object rows and all 8 script-bearing Buff Bar/template entries. The Buff Bar XML root and the three Buff-Bar-only virtual templates are absent, the Assignment XML root and its six required virtual templates remain, and the documented generated names, anchors, visibility, status bar, tooltip/click/mouse-wheel handlers, movement/scaling hooks and root OnUpdate are represented in Lua.
- The Stage 4 delta from handoff `3ebcbf62a72f4b50e03d87bd3da143a9e633bc30` through implementation `87dbe794ce50e915d8e0a31c263c23d48b1c6dfe` changes only `PallyPowerUI.lua` and `PallyPower.xml`; it does not modify `PallyPower.lua`, locales, TOC metadata, SavedVariables, protocol, keybindings, Nampower or UnitXP logic.
- Canonical real Lua 5.0.2 compiler validation passed for the exact Stage 4 runtime Lua payload at `87dbe794ce50e915d8e0a31c263c23d48b1c6dfe` using VanillaTemplate `tools/lua50/check_lua50.sh`. Validation run `36017508901` completed successfully with `Lua 5.0.2 syntax check passed: 3 file(s).` Exact checked blobs were `PallyPower.lua` `c0901bb34370ccc36c217908f9cd91c9444c2425`, `PallyPowerUI.lua` `c37dbf6b332cd8b3b40314fb959e514ec5b75f79`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`.
- Temporary VanillaTemplate validation PR `#2` was closed and branch `validate-pallypower-stage4` was reset to baseline `9093fac60f210dedd87d5e2d0f265a97494f999f`; no validation workflow or checker payload was added to PallyPowerVanilla `dev`.
- Focused Stage 5 parity review against `docs/XML_UI_PARITY_MANIFEST.md` passed for all 85 frozen Assignment-root object rows and all 15 script-bearing Assignment-root entries. The `PallyPowerFrame` XML root is absent, all ten class headers/groups, four special groups, twelve Paladin rows, generated assignment-cell/override children, quick controls, visibility controls, capability hooks, resize hooks and root/title callback contracts are represented in Lua, while all six Assignment virtual-template definitions remain in XML as required by the Stage 5 boundary.
- The Stage 5 delta from handoff `459da65c364c49a28274013b8490cddc61030be8` through implementation `ac0c28b2fe913b5ea0f313bf011e678a6923c6e1` changes only `PallyPowerUI.lua` and `PallyPower.xml`; it does not modify `PallyPower.lua`, locales, TOC metadata, SavedVariables, protocol, keybindings, Nampower or UnitXP logic.
- Canonical real Lua 5.0.2 compiler validation passed for the exact Stage 5 runtime Lua payload at `ac0c28b2fe913b5ea0f313bf011e678a6923c6e1` using VanillaTemplate `tools/lua50/check_lua50.sh`. Validation run `36019415153` completed successfully with `Lua 5.0.2 syntax check passed: 3 file(s).` Exact checked blobs were `PallyPower.lua` `c0901bb34370ccc36c217908f9cd91c9444c2425`, `PallyPowerUI.lua` `ad65a7cb202a02b3329fa2c081f42c7a19519f89`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`.
- Temporary VanillaTemplate validation PR `#3` was closed and branch `validate-pallypower-stage5` was reset to baseline `9093fac60f210dedd87d5e2d0f265a97494f999f`; no validation workflow or checker payload was added to PallyPowerVanilla `dev`.
- Full Stage 6 static parity review passed against the frozen manifest across all migrated sections: all 281 object rows / 277 named-object contracts, all 149 XML script-handler contracts, all 8 explicit click-registration sites and all 55 frozen dynamic `getglobal()` argument expressions are accounted for in the Lua runtime.
- Generated digit-indexed name families were verified through their Lua loops/factories; the `Scan1`/`Scan2` edit boxes and warning/save-dialog full-name equivalents were checked explicitly, and the four frozen unnamed objects remain intentionally unnamed.
- All 55 frozen dynamic `getglobal()` expressions remain unchanged in `PallyPower.lua` blob `c0901bb34370ccc36c217908f9cd91c9444c2425`; Stage 6 performs no naming/reference cleanup.
- All nine addon-owned template symbols are now represented only by Lua factory definitions/calls. No runtime custom XML inheritance dependency remains, so the six retained Assignment virtual-template definitions could be removed with `PallyPower.xml`.
- The frozen 8 XML `RegisterForClicks` sites are represented by the Lua assignment-cell, player-override, Buff-Bar blessing, Buff-Bar special, combined-self-button and minimap constructors; the combined-self helper constructs the Aura, RF and Seal click targets separately.
- Legacy `this` / `arg1` / `event` callback semantics remain represented, including the constructor-time temporary `this = PallyPowerFrame` binding around `PallyPower_OnLoad()`.
- The Stage 6 implementation delta from handoff `d104de65beced2ebb5633fbb35a509b0b048dcf3` to `a526f5486cf421b35506bab5cb50068a75bb1a6e` removes `PallyPower.xml`, removes its single TOC loader entry and updates only stale comments in `PallyPowerUI.lua`; `PallyPower.lua`, locales, SavedVariables, protocol logic and `Bindings.xml` are unchanged.
- Canonical real Lua 5.0.2 compiler validation passed for the exact Stage 6 XML-free runtime payload at `a526f5486cf421b35506bab5cb50068a75bb1a6e` using VanillaTemplate `tools/lua50/check_lua50.sh`. Validation run `36020971505`, job `107705462122`, completed successfully with `Lua 5.0.2 syntax check passed: 3 file(s).` Exact checked blobs were `PallyPower.lua` `c0901bb34370ccc36c217908f9cd91c9444c2425`, `PallyPowerUI.lua` `11abee7a56c02bc32e43f03493b448411e20b4a4`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`.
- Temporary VanillaTemplate validation PR `#4` was closed and branch `validate-pallypower-stage6` was reset to baseline `9093fac60f210dedd87d5e2d0f265a97494f999f`; no validation workflow or checker payload was added to PallyPowerVanilla `dev`.
- After the failed XML-free runtime test, static diagnosis confirmed `PallyPowerBuffButton_OnLoad(btn)` still reads global `this` rather than `btn`, while both Lua Buff Bar factories replayed that handler directly without an XML-created `this` context. The `772472b` fix adds only scoped `oldThis` save/bind/restore around those two manual calls; the delta from `d5feca` to `772472b` is only 8 added lines in `PallyPowerUI.lua`, with no core/data/protocol/naming changes.
- Canonical real Lua 5.0.2 compiler validation passed for the exact corrected runtime payload at `772472b1c2cb47827ad8e17e9f5720da19615f45` using VanillaTemplate `tools/lua50/check_lua50.sh`. Validation run `36028081406`, job `107729602032`, completed successfully with `Lua 5.0.2 syntax check passed: 3 file(s).` Exact checked blobs were `PallyPower.lua` `c0901bb34370ccc36c217908f9cd91c9444c2425`, `PallyPowerUI.lua` `e8a298efbdcaf44150741018dabe42a7ee5404ad`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`.
- Temporary VanillaTemplate validation PR `#5` was closed and branch `validate-pallypower-stage6-runtimefix` was reset to baseline `9093fac60f210dedd87d5e2d0f265a97494f999f`; no validation workflow or checker payload was added to PallyPowerVanilla `dev`.
- Diagnostic runtime `52f6d2d10d7a8a8fa5a9f1ac3ef88c8a9ab61fdd` passed the canonical Lua 5.0.2 checker in validation run `36033072945`, job `107746362682`.
- User diagnostic output localized the remaining startup failure to the save-preset EditBox construction at former line 1112: `PallyPowerSaveMenuNameEB:SetHistoryLines(0)`. The XML source used `historyLines="0"`; the corrective Lua implementation now relies on the EditBox default instead of invoking the runtime setter with zero.
- Canonical real Lua 5.0.2 compiler validation passed for exact corrective runtime `69ebb9d0a7a1aba95f4fe0dd448c3a21dde97047` (`1.11.1-dev`) in VanillaTemplate run `36034849466`, job `107752246481`, with `Lua 5.0.2 syntax check passed: 3 file(s).` Exact checked blobs were `PallyPower.lua` `c0901bb34370ccc36c217908f9cd91c9444c2425`, `PallyPowerUI.lua` `7356b0da541792025e6616c2f7a15af83223b668`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`.
- Focused scan-border fix `1188304105d38fd4172acc9c43b8f6f47ea6c30f` changes only the three `Common-Input-Border` texture sizes inside `CreateAdvancedOptionsScanEditBox()`: left/right to `8x20` and middle to `10x20`. EditBox size, anchors, option keys, scripts, focus behavior and persistence code are unchanged. These dimensions match Blizzard's Vanilla input-border geometry and later PallyPower sources.
- Canonical real Lua 5.0.2 compiler validation passed for exact scan-border runtime `1188304105d38fd4172acc9c43b8f6f47ea6c30f` in VanillaTemplate run `36072313858`, job `107875827489`, with `Lua 5.0.2 syntax check passed: 3 file(s).` Exact checked blobs were `PallyPower.lua` `c0901bb34370ccc36c217908f9cd91c9444c2425`, `PallyPowerUI.lua` `9011850d46ccb77b4d51000933e8e1f9be373d72`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`. Temporary validation PR `#8` was closed and branch `validate-pallypower-scan-border` was reset to VanillaTemplate baseline `b37a6c56c15a58d8001771b3e4947643e74753c1`.
- Stage 7 first-slice static audit reduced `PallyPower.lua` `getglobal()` call sites from 115 at the pre-slice audit to 34, with **zero** remaining indexed `PallyPowerFramePlayer...`, `PallyPowerFrameClass...` or `PallyPowerBuffBarBuff...` lookups. `PallyPowerUI.lua` has 7 remaining unrelated `getglobal()` sites. Player-row identity for the migrated capability/assignment paths no longer parses generated frame names.
- All legacy generated/named globals for the migrated families are still created by the Lua constructors, preserving compatibility aliases while internal code consumes direct references.
- Canonical real Lua 5.0.2 compiler validation passed for Stage 7 Lua implementation `ceec82cbbee32d430101b2f76dd4b1d4232c1a20` in VanillaTemplate run `36073299444`, job `107878884438`, with `Lua 5.0.2 syntax check passed: 3 file(s).` Exact checked blobs were `PallyPower.lua` `7579ef9aaca44ebd90b4d70e7feb11292a1d4192`, `PallyPowerUI.lua` `688b596811cc10d40922a22969d633e606d41aac`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`. Temporary validation PR `#9` was closed and `validate-pallypower-stage7-refs` was reset to VanillaTemplate baseline `b37a6c56c15a58d8001771b3e4947643e74753c1`.
- Test build `03f988f66b912381585a5b487ed16ad7a68b14da` changes only the TOC version after that compiler-checked Lua payload, so it carries the same checked Lua blobs with runtime metadata/version now `1.11.2-dev`.
- Fresh Stage 7 audit at handoff `9d92831fb02006acbde6af0e2f6b9626c0478914` reconfirmed exactly 34 `getglobal()` call sites in `PallyPower.lua` and 7 in `PallyPowerUI.lua`. The smallest coherent repeated family was the fixed Buff Bar root lookup used three times for non-Paladin/test-mode visibility.
- Second-slice runtime `4a31fcb795b5e01d23d8cfe55ba42d1596709014` replaces only those three core lookups with `PallyPowerUIRefs.buffBar`, adds the root reference when `PallyPowerBuffBar` is constructed, preserves the legacy named global, and bumps the TOC to `1.11.3-dev`. The remaining counts are 31 `getglobal()` call sites in `PallyPower.lua` and 7 in `PallyPowerUI.lua`, with zero remaining exact `getglobal("PallyPowerBuffBar")` sites.
- Canonical real Lua 5.0.2 compiler validation passed for exact second-slice runtime `4a31fcb795b5e01d23d8cfe55ba42d1596709014` in VanillaTemplate run `36147538369`, job `108112335854`, with `Lua 5.0.2 syntax check passed: 3 file(s).` Exact checked blobs were `PallyPower.lua` `7ebf68682308051ae3d352be684470bf4b8b8c93`, `PallyPowerUI.lua` `eb196fb231a338ba998667943c6cf5a72798ae5e`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`. Temporary validation PR `#10` was closed and `validate-pallypower-stage7-buffbar-root` was reset to VanillaTemplate baseline `b37a6c56c15a58d8001771b3e4947643e74753c1`.
- Fresh third-slice audit started from 31 `getglobal()` lines in `PallyPower.lua` and 7 in `PallyPowerUI.lua`. The smallest coherent repeated family was the two constructor-time `$parentHeaderTexture` lookups shared by the warning and save-preset dialogs; both are immediately available as the just-created texture object and require no compatibility-global removal.
- Third-slice runtime `4b817936e403bc455663a7c89909ccbd7e3615a8` removes only those two UI lookup lines and leaves 31 `getglobal()` lines in `PallyPower.lua` and 5 in `PallyPowerUI.lua`. Generated globals `PallyPowerWarningFrameHeaderTexture` and `PallyPowerSaveMenuHeaderTexture` remain created unchanged.
- Canonical real Lua 5.0.2 compiler validation passed for exact third-slice runtime `4b817936e403bc455663a7c89909ccbd7e3615a8` in VanillaTemplate run `36155647148`, job `108139408037`, with `Lua 5.0.2 syntax check passed: 3 file(s).` Exact checked blobs were `PallyPower.lua` `7ebf68682308051ae3d352be684470bf4b8b8c93`, `PallyPowerUI.lua` `0c13474f87cfd7025e19d5d71daec4c67b3dac1d`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`. Temporary validation PR `#11` was closed and `validate-pallypower-stage7-dialog-headers` was reset to VanillaTemplate baseline `b37a6c56c15a58d8001771b3e4947643e74753c1`.
- Fourth-slice audit at handoff `e5e3929f67b95f44fad0233bdde15e3691baabf0` grouped the remaining 31 `getglobal()` lines in `PallyPower.lua` into tooltip/template-generated regions (8 lines), Judgement Buff Bar children (5), class-group player-name text children (3), generated self-buff/special children and layout (8), fixed special-button identity comparisons (5), and dynamic warning-localization lookup (2). The 5 `PallyPowerUI.lua` lines split into two constructor icon anchors and three repeated Save Preset `OkayButton` accesses.
- The smallest coherent repeated family was the three Save Preset `OkayButton` accesses. Runtime `d3dd69006e619ff8d26318ec0b970b440ab784dc` replaces only those three lookups with local `okayButton`, preserves named global `PallyPowerSaveMenuOkayButton`, and leaves 31 `getglobal()` lines in `PallyPower.lua` and 2 in `PallyPowerUI.lua`.
- Canonical real Lua 5.0.2 compiler validation passed for exact fourth-slice runtime `d3dd69006e619ff8d26318ec0b970b440ab784dc` (`1.11.5-dev`) in VanillaTemplate run `36161957113`, job `108160419066`, with `Lua 5.0.2 syntax check passed: 3 file(s).` Exact checked blobs were `PallyPower.lua` `7ebf68682308051ae3d352be684470bf4b8b8c93`, `PallyPowerUI.lua` `a192458cabb41719f5feb0b122732bf08b2d304a`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`. Temporary validation PR `#12` was closed and `validate-pallypower-stage7-save-okay` was reset to VanillaTemplate baseline `b37a6c56c15a58d8001771b3e4947643e74753c1`.

## Current Issues
- No Stage 6 parity regression is known; Stage 6 remains accepted on `69ebb9d0a7a1aba95f4fe0dd448c3a21dde97047`.
- The Advanced Options Scan1/Scan2 border correction remains user-verified fixed on `1188304105d38fd4172acc9c43b8f6f47ea6c30f`.
- Stage 7 first slice is user-verified on `1.11.2-dev` / `03f988f66b912381585a5b487ed16ad7a68b14da`; no regression is currently known in the migrated indexed-reference families.
- Stage 7 second slice is user-verified on `1.11.3-dev` / `4a31fcb795b5e01d23d8cfe55ba42d1596709014`; no regression is known in the Buff Bar root-reference change. The proposed non-Paladin `/pp test prot` persistence check was invalid because test mode sets `PP_IsPally = true` while `PallyPower_UpdateUI()` still gates Buff Bar visibility on legacy `IsPally == 1`, so a non-Paladin test profile is immediately hidden by the pre-existing update path. Do not fold that legacy flag mismatch into Stage 7 naming cleanup.
- Stage 7 third slice is compiler-checked and user-verified on `1.11.4-dev` / `4b817936e403bc455663a7c89909ccbd7e3615a8`; no regression is known in the two dialog-header anchor changes.
- Stage 7 fourth slice is compiler-checked and user-verified on `1.11.5-dev` / `d3dd69006e619ff8d26318ec0b970b440ab784dc`; the blank/new/existing-name OK-button state paths and Save/overwrite/Cancel behavior all worked as described.
- Stage 7 fifth slice is compiler-checked and user-verified on `1.11.6-dev` / `98f0ecbdc7cb77749041d288b3b511cf6381b173`. Left-click cycling and right-click clearing both target the correct displayed player, and the Buff Bar correctly resolves the selected player override. The hover tooltip still resolves correctly after re-entering the player button.
- Fifth-slice runtime observations exposed two legacy UX behaviors that are not caused by the `ppText` reference change: an already-open player override tooltip does not refresh immediately when the override changes and instead updates on re-entry; player-button mouse-wheel cycling appears nonfunctional in current runtime despite the registered handler. Do not treat either as a Stage 7 regression or fold a behavior fix into naming/reference cleanup.
- Stage 7 sixth slice is compiler-checked and user-verified on `1.11.7-dev` / `c5d4eb0f8cca41d590a491ea31094d09c6aeec1b`. RF cycling and the NoRF indicator both work in the assignment row and Buff Bar exactly as before; the constructor-reference change introduced no observed regression.
- Stage 7 seventh slice is compiler-checked and user-verified on `1.11.8-dev` / `57ed6a69dd3660c3d0348b7e0288cc84d00d0836`. RF, Aura and Seal button behavior all worked as expected, confirming the direct special-button identity references preserved click routing.
- Runtime testing also confirmed mouse-wheel cycling is nonfunctional on the Buff Bar as well as player override buttons. Treat this as a broader pre-existing mouse-wheel/input issue, not a seventh-slice regression.
- Stage 7 eighth slice is compiler-checked and user-verified on `1.11.9-dev` / `915c61ac624e571e6d07cc092abefc4bd4003e7d`. Judgement tracking behaved correctly in runtime, including the assigned icon and tracker display. The user also observed that the duration bar is visibly present again on this build. Because the slice was intended as reference-only cleanup and the previous generated global should have resolved the same StatusBar, record that as an observed improvement rather than an established causal fix until compared against the prior build if needed.
- Stage 7 ninth slice is compiler-checked and user-verified on `1.11.10-dev` / `177a980a97cffc1cad22746dfea0490f40e89ca6`. Separate and combined self-buff modes, Aura/RF/Seal icons and backdrop states, clicking, the existing NoRF indicator, and horizontal/vertical geometry all passed runtime validation.
- Stage 7 final audit is complete: the remaining 10 `getglobal()` calls are intentional template/dynamic compatibility lookups and are not candidates for further naming cleanup. Stage 7 closes with nine user-verified runtime slices; no tenth runtime delta is needed.
- Tentative runtime observation on `1.11.11-dev`: user may be seeing a short hitch when many raid/party members become buffed in a burst. This is not yet established as a regression. Static review found no new per-member work in the mass-buff/raid-scan path from the consolidated cleanup; the existing scanner still defaults to `scanperframe = 1` and completes with the normal `PallyPower_UpdateUI()` refresh. Reproduce before changing performance behavior.
- Post-Stage-7 consolidated cleanup runtime results on exact `1.11.11-dev` / `3fb5aa00086aa509c6df8fc47a3a1d7c712cd182`: RF/Judgement preset restore passed; player override tooltip now updates immediately and player-button mouse-wheel works; mouse-wheel cycling works everywhere tested; normal Paladin operation appears good. The NoRF state logic still cycled correctly, but the new translucent red overlay was not visible. Non-Paladin `/pp test` remains untested. Dev VERSION advertisement suppression remains statically verified but has not received a separate peer-client runtime observation.
- Runtime result on exact `1.11.12-dev` / `2e6a8e5bd3a78c9960146ed35bc31900a58f744a`: the solid red NoRF overlay became visibly effective, but mouse-wheel cycling then stopped working. The user correctly identified that this build placed a separate visible region over the existing RF icon rather than tinting the icon itself. This is treated as the regression boundary even though Vanilla texture regions would normally be expected not to consume mouse input.
- `1.11.13-dev` / `833881ebdcefe7f59e7b8b7d9d18157ea7356172` removes the separate runtime overlay regions and instead applies `SetVertexColor(1, 0.2, 0.2)` directly to the existing RF icon for explicit NoRF, restoring `SetVertexColor(1, 1, 1)` when cycling away. The legacy named NoRF X font strings remain created and hidden. All existing `EnableMouseWheel(true)` calls and wheel handlers remain unchanged from the known-good `1.11.11-dev` path.
- Runtime result on exact `1.11.13-dev`: direct RF icon tint works. Mouse-wheeling the RF grid cell reaches the handler but errors at former line 6334 (`class = class + 0`) because `btn.ppClass` is string token `R`; the grid wheel handler only translated `A`/`S`, unlike the click handler which already translated `A`/`S`/`R`/`J`. This is a latent wheel-routing bug exposed now that input reaches the RF cell.
- `1.11.14-dev` / `d0a44be85627a05d3c4e621fc490b44f951d88da` adds the missing `R -> PALLYPOWER_RF_CLASS` and `J -> PALLYPOWER_JUDGEMENT_CLASS` mappings before numeric coercion. Forward/backward cycle functions already handle both special classes, so no other routing behavior changed.
- Grid-wheel routing real Lua 5.0.3 validation passed in VanillaTemplate run `36234922168`, job `108384839215`, validation commit `8a86d588b8662c97ba4f1f2a3dfcd87866e2adb2`: self-test passed and `Lua 5.0.3 syntax check passed: 3 file(s).` Temporary validation PR #21 was closed and reset to the current VanillaTemplate baseline afterward.
- Direct-icon-tint real Lua 5.0.3 validation passed in VanillaTemplate run `36233568448`, job `108381141981`, validation commit `237a13d5f39237a2dde6442130900064e50f90ca`: self-test passed and `Lua 5.0.3 syntax check passed: 3 file(s).` Checked blobs were `PallyPower.lua` `db3b4717128e61b005bb683b04bb19a481e792ec`, `PallyPowerUI.lua` `4f6052e8b9c0ee8bbb2a1af553ad0834b9367205`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`. Temporary validation PR #20 was closed and its branch reset to the current VanillaTemplate baseline afterward.
- NoRF corrective real Lua 5.0.3 validation passed in VanillaTemplate run `36230916118`, job `108373778622`, validation commit `d158f9614e88119983e161c70893971bb20d40c3`: self-test passed and `Lua 5.0.3 syntax check passed: 3 file(s).` Checked blobs were `PallyPower.lua` `ed64b58b56aea6a055b8aaecce5bceb7457d11b0`, `PallyPowerUI.lua` `a534bb816a36859ee3c422af3b0b888c163d24ef`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`. Temporary validation PR #19 was closed and its branch reset to the current VanillaTemplate baseline afterward.
- Consolidated build real Lua 5.0.2 validation passed in VanillaTemplate run `36190224173`, job `108253302916`, validation commit `f9f35d0b147dd4fd92aff1575a8efbd7bde39f12`: self-test passed and `Lua 5.0.2 syntax check passed: 3 file(s).` Checked blobs were `PallyPower.lua` `ed64b58b56aea6a055b8aaecce5bceb7457d11b0`, `PallyPowerUI.lua` `682544c161244e8cc32be94ca43ce0894ebd4467`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`. Temporary validation PR #18 was closed and its branch reset to the VanillaTemplate baseline afterward.
- Remaining `getglobal()` lines after the ninth slice: 10 in `PallyPower.lua`, 0 in `PallyPowerUI.lua`.
- Ninth-slice real Lua 5.0.2 validation passed in VanillaTemplate run `36185293881`, job `108237076001`, validation commit `1cd6f271d8dd89d969af0a226a892e520a86e7e7`: self-test passed and `Lua 5.0.2 syntax check passed: 3 file(s).` Checked blobs were `PallyPower.lua` `17a4dd211faa193489846128f2dc9d0f0f123d48`, `PallyPowerUI.lua` `18aef63feaaf9564c881b31864f36dbcedf92c75`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`. Temporary validation PR #17 was closed and its branch reset to the VanillaTemplate baseline afterward.
- Eighth-slice real Lua 5.0.2 validation passed in VanillaTemplate run `36182659540`, job `108228502232`, validation commit `52d59c523bd4332914d939e3b48a9ac4d301432e`: self-test passed and `Lua 5.0.2 syntax check passed: 3 file(s).` Checked blobs were `PallyPower.lua` `cc9eb05acbcd2b15cf82bd36add1810ffb74423d`, `PallyPowerUI.lua` `9594c27bc9ca9d3ac335f7456742442c86d3bce9`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`. Temporary validation PR #16 was closed and its branch reset to the VanillaTemplate baseline afterward.
- Seventh-slice real Lua 5.0.2 validation passed in VanillaTemplate run `36181282331`, job `108223996529`, validation commit `8e4a7d97d933d0dc3f2b1b60827fffc958fc1429`: self-test passed and `Lua 5.0.2 syntax check passed: 3 file(s).` Checked blobs were `PallyPower.lua` `58c4b441cc47fb1d3e92b28d699804272b4c4566`, `PallyPowerUI.lua` `f59b2cacaf6eaa7e3c91e8fe669d41c7c1fdb052`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`. Temporary validation PR #15 was closed and its branch reset to the VanillaTemplate baseline afterward.
- Sixth-slice real Lua 5.0.2 validation passed in VanillaTemplate run `36167908788`, job `108180052218`, validation commit `b62e2c1d8984ef7b2e4a251306ea5fa84ca7b2e4`: self-test passed and `Lua 5.0.2 syntax check passed: 3 file(s).` Checked blobs were `PallyPower.lua` `66972463993b7e77d158d9d2f809ffe14a296f82`, `PallyPowerUI.lua` `404cd584f512b68b5e1b6b4f9d691040c9b9a65d`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`. Temporary validation PR #14 was closed and its branch reset to the VanillaTemplate baseline afterward.
- Fifth-slice real Lua 5.0.2 validation passed in VanillaTemplate run `36165111196`, job `108170839722`, validation commit `607c2075248ef3fde391d288fe19654983e7c672`: self-test passed and `Lua 5.0.2 syntax check passed: 3 file(s).` Checked blobs were `PallyPower.lua` `66972463993b7e77d158d9d2f809ffe14a296f82`, `PallyPowerUI.lua` `a192458cabb41719f5feb0b122732bf08b2d304a`, and `locales/enUS.lua` `a6a022b5a540bf4c99d61754f72bea7421471eeb`. Temporary validation PR #13 was closed and its branch reset to the VanillaTemplate baseline afterward.
- Optional compatibility-path coverage is not exhaustively documented per client/extension combination.

## Testing

### Last Runtime Test
- Version/build: `1.11.13-dev` / runtime build `833881ebdcefe7f59e7b8b7d9d18157ea7356172`.
- Result: direct NoRF tint works. Mouse-wheeling the RF grid cell throws a string-arithmetic error because the wheel handler does not translate `R`/`J` class tokens before numeric conversion.
- Correction: `1.11.14-dev` maps `R` and `J` exactly like the existing click handler; this delta is compiler-checked and awaits focused runtime retest.

### Next Runtime Test
1. On `1.11.14-dev` / `d0a44be85627a05d3c4e621fc490b44f951d88da`, mouse-wheel the RF assignment-grid cell in both directions. Confirm it cycles RF states with no Lua error and the direct red tint still appears for explicit NoRF.
2. Mouse-wheel the Judgement assignment-grid cell once to confirm the same newly added `J` routing works without error.
3. Spot-check one normal numeric class cell to ensure its existing wheel path still works.
4. Non-Paladin `/pp test` and peer VERSION suppression remain independent outstanding checks.

### Stage 2 Validation State
- Static parity review: passed for the documented Stage 2 boundary.
- Real Lua 5.0.2 compiler check: passed for all three runtime Lua files.
- In-game smoke test: not performed.
- Blocking runtime test: none required at Stage 2; Stage 3 subsequently completed without claiming runtime validation.

### Stage 3 Validation State
- Static parity review: passed for all 59 frozen Advanced Options object rows and all 21 script-bearing Advanced Options entries.
- Real Lua 5.0.2 compiler check: passed for all three runtime Lua files at implementation `4d55d79d9c4fd908d31375f1d6b01c8e1e960b2c` in validation run `36015896723`.
- In-game smoke test: not performed.
- Blocking runtime test: none required at Stage 3; Stage 4 subsequently completed without claiming runtime validation.

### Stage 4 Validation State
- Static parity review: passed for all 39 frozen Buff Bar/template object rows and all 8 script-bearing Buff Bar/template entries.
- Real Lua 5.0.2 compiler check: passed for all three runtime Lua files at implementation `87dbe794ce50e915d8e0a31c263c23d48b1c6dfe` in validation run `36017508901`.
- In-game smoke test: not performed.
- Blocking runtime test: none required at Stage 4; Stage 5 subsequently completed without claiming runtime validation.

### Stage 5 Validation State
- Static parity review: passed for all 85 frozen Assignment-root object rows and all 15 script-bearing Assignment-root entries.
- Real Lua 5.0.2 compiler check: passed for all three runtime Lua files at implementation `ac0c28b2fe913b5ea0f313bf011e678a6923c6e1` in validation run `36019415153`.
- In-game smoke test: not performed.
- Blocking runtime test: none required at Stage 5; Stage 6 subsequently completed without claiming runtime validation.

### Stage 6 Validation State
- Full static parity review: passed against all 281 frozen object rows / 277 named-object contracts, all 149 script-handler contracts, all 8 explicit click-registration sites and all 55 dynamic `getglobal()` expressions.
- Original XML-free compiler check: passed for all three runtime Lua files at `a526f5486cf421b35506bab5cb50068a75bb1a6e` in validation run `36020971505`.
- First in-game XML-free smoke test: failed on branch head `d5feca644fbe4774ff6b201364fbcaa309d9034f` / runtime payload `a526f5486cf421b35506bab5cb50068a75bb1a6e`; addon loaded, but UI visibility and `/pp` initialization failed.
- Corrective implementation `772472b1c2cb47827ad8e17e9f5720da19615f45` restored XML-style `this` context for Buff Bar constructor-time `OnLoad` replay only; its real Lua 5.0.2 compiler check passed in validation run `36028081406`, job `107729602032`.
- Second in-game startup test: failed on docs-only head `64036ac295d58726e591fcfec72472eb4267b85a` / runtime payload `772472b1c2cb47827ad8e17e9f5720da19615f45`; addon remained listed but no UI was visible and `/pp` still did not work.
- Diagnostic implementation `52f6d2d10d7a8a8fa5a9f1ac3ef88c8a9ab61fdd` successfully localized the remaining failure to standalone construction; user output then pinpointed `PallyPowerSaveMenuNameEB:SetHistoryLines(0)` at former line 1112. Its real Lua 5.0.2 compiler check passed in validation run `36033072945`, job `107746362682`.
- Corrective implementation `69ebb9d0a7a1aba95f4fe0dd448c3a21dde97047` removes the invalid zero-history Lua setter, removes temporary diagnostic wrappers, and bumps version to `1.11.1-dev`.
- Corrective real Lua 5.0.2 compiler check: passed for all three runtime Lua files in validation run `36034849466`, job `107752246481`, with `Lua 5.0.2 syntax check passed: 3 file(s).`
- Focused startup retest: passed on exact corrective runtime `69ebb9d0a7a1aba95f4fe0dd448c3a21dde97047` (`1.11.1-dev`): UI visible and `/pp` working.
- Broad AQ40 runtime checkpoint: passed on exact runtime `69ebb9d0a7a1aba95f4fe0dd448c3a21dde97047`; the user reports normal full-raid use behaved exactly as before with no differences noticed.
- Stage 6 acceptance: **ACCEPTED** on `69ebb9d0a7a1aba95f4fe0dd448c3a21dde97047`. Stage 7 is no longer blocked by the Stage 6 gate, but the now-unblocked pre-existing scan EditBox border defect should be corrected first as the next focused task.

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
- At the Stage 2 checkpoint all nine custom virtual XML template definitions remained because later XML sections still inherited from them; Stage 4 later removed the three Buff-Bar-only definitions after their final XML consumers migrated.
- Focused static parity and the canonical Lua 5.0.2 compiler check passed; no Stage 2 in-game test was required or performed.

### Stage 3 - Convert Advanced Options — COMPLETE at `4d55d79`
- Advanced Options root, labels, checkboxes, sliders, editboxes, generated child names, Blizzard template inheritance and script handlers are recreated in Lua.
- Existing control globals and persistence semantics remain intact for current runtime references.
- Focused manifest parity and the canonical Lua 5.0.2 compiler check passed; no Stage 3 in-game test was required or performed.

### Stage 4 - Convert Buff Bar — COMPLETE at `87dbe79`
- The full Buff Bar is constructed in Lua using the existing blessing/special/combined-self factories.
- All child names used by current `getglobal()` code, including generated blessing-button families, remain intact.
- OnUpdate, movement/scaling, status-bar, tooltip, click, mouse-wheel, layout and visibility behaviour are represented against the frozen manifest.
- The three Buff-Bar-only XML virtual templates and the Buff Bar XML root were removed; Assignment XML and all templates it still consumes remain.
- Focused manifest parity and the canonical Lua 5.0.2 compiler check passed; no Stage 4 in-game test was required or performed.

### Stage 5 - Convert Assignment UI Last — COMPLETE at `ac0c28b`
- `PallyPowerFrame`, ten class columns, four special columns, twelve Paladin rows, assignment cells, capability regions, quick controls and resize behaviour now construct from Lua.
- Exact generated global names and the existing `this`/`arg1`/`event` callback contracts remain represented for the parity phase.
- `PallyPower_OnLoad()` is invoked once with `this` bound to the intended Lua-created main frame so its event registration and initialization remain attached to `PallyPowerFrame`.
- `PallyPower.xml` and the six Assignment virtual-template definitions remain deliberately present for Stage 6 removal; naming/getglobal cleanup has not begun.
- Focused manifest parity and the canonical Lua 5.0.2 compiler check passed; no Stage 5 in-game test was required or performed.

### Stage 6 - Complete XML-Free Parity Baseline — COMPLETE / USER-ACCEPTED at runtime `69ebb9d`
- Full static parity review passed against the frozen XML manifest across all migrated UI sections.
- All expected named-object families and all 55 frozen dynamic lookup expressions remain represented without naming/getglobal cleanup.
- All frozen script-handler and click-registration contracts are represented in Lua, including legacy `this` / `arg1` / `event` semantics.
- `PallyPower.xml` and the final six Assignment virtual-template definitions were removed together with the XML TOC loader entry.
- `Bindings.xml` remains intentionally unchanged for normal Vanilla keybinding discovery.
- Canonical real Lua 5.0.2 compiler validation passed for the exact XML-free runtime payload in run `36020971505`.
- The first XML-free runtime test and the `772472b` corrective retest both failed before normal startup completed. Diagnostic runtime `52f6d2d` then exposed the save-dialog `SetHistoryLines(0)` failure. Corrective runtime `69ebb9d` removes that invalid Lua replay, removes diagnostic scaffolding, passes the real Lua 5.0.2 compiler check, passes the focused startup retest with visible UI and working `/pp`, and passed the subsequent full AQ40 parity run with no behavioral differences noticed. Stage 6 is user-accepted.

### Stage 7 - Post-Validation Naming / Reference Refactor — COMPLETE / NINE SLICES USER-VERIFIED
- First slice owns deterministic references through global compatibility table `PallyPowerUIRefs` for player rows, class icons/groups, class-group player buttons and Buff Bar blessing buttons.
- Core indexed access for those families now uses direct Lua references; assignment-cell row/class identity is attached directly instead of parsed back out of generated frame names.
- All legacy global frame/region names continue to be created unchanged. This slice intentionally leaves unrelated tooltip globals, special-control globals and arbitrary name-derived lookups alone.
- Keep compatibility globals/aliases wherever external use is possible or uncertain.
- Do not combine this stage with behaviour, data-model or protocol changes.
- First-slice runtime acceptance is complete on `1.11.2-dev`.
- Second slice owns only the Buff Bar root reference: three fixed internal root visibility lookups now use `PallyPowerUIRefs.buffBar`, while global `PallyPowerBuffBar` remains available unchanged.
- The second slice is compiler-checked and user-verified on `1.11.3-dev`. The non-Paladin test-profile blink is explained by the pre-existing `PP_IsPally` versus `IsPally` visibility split and is not part of this naming/reference slice.
- Third slice owns only the two constructor-time dialog header anchors: the warning and save-preset titles now anchor directly to their freshly created header texture objects, while the generated named texture globals remain intact.
- The third slice is compiler-checked and user-verified on `1.11.4-dev`. The preset UI paths tested normally, so Stage 7 may continue with a fresh audit of the remaining lookup families.
- Fourth slice owns only the three Save Preset `OkayButton` state lookups inside the existing name-field `OnTextChanged` callback. The constructor now keeps a direct local reference while global `PallyPowerSaveMenuOkayButton` remains intact; callback style and behavior are unchanged. The slice is compiler-checked and user-verified on `1.11.5-dev`.
- Fifth-slice audit regrouped the remaining lookups after the fourth slice. The smallest clean repeated family that required no new stored state was the three class-group player-button generated `Text` reads: all three buttons already carry the exact constructor-owned font string as `ppText`. The two remaining UI constructor icon-anchor lookups were left alone because only one currently has an existing direct child reference.
- Fifth slice therefore changes only those three player-name reads in mouse-wheel, click and hover paths to `btn.ppText` / `plbtn.ppText`. All generated `...Text` globals remain intact for compatibility. The slice is compiler-checked and user-verified on `1.11.6-dev`; click/clear targeting and Buff Bar override resolution passed. Tooltip live-refresh and mouse-wheel cycling are legacy behavior observations, not fifth-slice regressions.
- Sixth-slice audit deliberately leaves the two dynamic warning-localization lookups alone: current internal callers use `SAVE`/`DELETE`, but the dynamic global lookup remains an open compatibility surface and should not be narrowed to a hard-coded map during Stage 7.
- Sixth slice instead owns the two remaining constructor icon-anchor lookups in `PallyPowerUI.lua`. The assignment RF NoRF overlay now anchors to the already-existing `cell.ppIcon`; the Buff Bar special-button factory stores its created icon as `button.ppBuffIcon`, and the RF NoRF overlay anchors to that direct reference. Generated icon globals remain intact. The slice is compiler-checked and user-verified on `1.11.7-dev`.
- Seventh slice owns the five fixed Buff Bar RF/Aura/Seal identity comparisons used by special-button click routing and Buff Bar mouse-wheel class routing. `PallyPowerUIRefs.buffSpecialButtons` now retains the three constructor-owned button references; named globals remain intact. The slice is compiler-checked and user-verified on `1.11.8-dev`; all three button actions worked as expected. Mouse-wheel cycling remains a separate pre-existing input issue.
- Eighth slice owns the five Judgement Buff Bar child lookups: debug text, countdown text, duration bar at both access sites, and the Judgement icon. The Judgement button and its children are retained directly from construction while all generated globals remain intact. The separate Judgement target-scan tooltip lookup is deliberately not part of this slice. The slice is compiler-checked and user-verified on `1.11.9-dev`; the user also observed the duration bar visible again, recorded without claiming the reference cleanup intentionally fixed it.
- Ninth slice owns the eight addon-owned self-buff/special-layout lookups. Separate Aura/RF/Seal buttons use the existing `buffSpecialButtons` references; the combined self-buff frame and its three child slots are now retained directly; icon/NoRF children are stored on their buttons; special-button geometry reads `btn.ppBuffIcon`. Generated globals and all behavior/appearance contracts remain intact. The slice is compiler-checked and user-verified on `1.11.10-dev`.
- Final Stage 7 audit completed after the ninth-slice runtime pass. `PallyPowerUI.lua` remains at zero `getglobal()` calls. The remaining 10 core lookups are intentionally preserved compatibility-bound/name-based interfaces rather than unfinished addon-owned UI references: `GameTooltipTemplate`-generated spell-scan regions (5), `GameTooltipTemplate`-generated Judgement target-scan text (1), Blizzard-owned `GameTooltipTextLeft/Right...` regions (2), and dynamic `PALLYPOWER_TEXT_WARNING_<type>` localization lookup (2). Replacing these merely to reach zero would either depend on unstable region-order inspection or narrow an intentionally dynamic global contract.
- Stage 7 is therefore complete at user-tested runtime `1.11.10-dev` / `177a980a97cffc1cad22746dfea0490f40e89ca6`; no tenth runtime slice is required. The final audit/documentation changes do not alter addon runtime and therefore do not require another TOC version bump or compiler run.

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
Runtime-test exact build `d0a44be85627a05d3c4e621fc490b44f951d88da` (`1.11.14-dev`) using items 1-3 above. The key gate is that RF and Judgement grid mouse-wheel routing no longer errors and RF direct tint remains correct. Do not repeat the already-passed preset/tooltip/normal-Paladin paths unless a regression appears. Non-Paladin `/pp test` and peer VERSION suppression remain independent outstanding checks.
