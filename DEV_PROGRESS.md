# Development Progress

## Current
- Branch: `dev`
- Version: `1.11.1-dev`
- Stage 6 accepted runtime implementation: `69ebb9d0a7a1aba95f4fe0dd448c3a21dde97047`
- Current implementation head before Stage 7 work: `1188304105d38fd4172acc9c43b8f6f47ea6c30f`
- Current branch head before this Stage 7 handoff update: `8a9df831f5c7c74d6c3f9e9a24e8d33d8882bee6`
- Stage 6 acceptance/status commit: `51847fc58ad5cba1fa4734c1a7017fdb62915cc2`
- Stable baseline: `main` / `1.11.0` at `8c520ca1335f6de23409c2b94dd7b7e8a52c2b09`
- Goal: Convert the addon-owned UI from `PallyPower.xml` to Lua in staged parity-preserving steps, then separately modernize the legacy frame-naming/getglobal machinery after an explicit runtime-tested XML-free baseline is established.
- Current scope boundary: This is a UI construction/refactor project only. Preserve runtime behaviour, appearance, compatibility contracts, data formats and optional-extension semantics unless a later request explicitly changes them.

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
- After the XML-free baseline passes runtime testing, a second refactor phase may replace repeated generated-name/global lookups with Lua-owned frame tables/references.
- During naming cleanup, retain compatibility aliases for any global whose external compatibility status is uncertain.
- Keep the familiar PallyPower workflow and compatibility focus.
- Aura/Judgement assignment micro-icon clusters remain removed while assignment icons/tooltips remain.
- Judgement capability ranks remain mapped through the underlying Wisdom/Light/Crusader Seal ranks.
- HoJ/LoH/DI utility indicators retain the current softened green/red/grey state tints.

## Recent Relevant Commits
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
- `Bindings.xml` remains intentionally separate and unchanged; no naming/getglobal cleanup has begun.
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

## Current Issues
- No Stage 6 XML-to-Lua parity regression is currently known. Exact runtime implementation `69ebb9d0a7a1aba95f4fe0dd448c3a21dde97047` passed startup and broad AQ40 raid use with no behavioral differences noticed by the user.
- No known post-parity UI defect remains from the previously deferred Scan1/Scan2 border issue; fix `1188304105d38fd4172acc9c43b8f6f47ea6c30f` is compiler-checked and user-verified.
- Optional compatibility-path coverage is not exhaustively documented per client/extension combination.

## Testing

### Last Runtime Test
- Version/commit: `1.11.1-dev` / runtime implementation `1188304105d38fd4172acc9c43b8f6f47ea6c30f`; later handoff commit `8a9df831f5c7c74d6c3f9e9a24e8d33d8882bee6` changed documentation only.
- Focus: Advanced Options Scan1/Scan2 post-parity border correction.
- Result: user confirms the Advanced Options issue is fixed in game.
- Acceptance: the deferred scan EditBox visual defect is closed. Stage 7 may now begin.

### Next Runtime Test
- Stage 7 runtime test is not yet defined because no Stage 7 runtime delta has been implemented.
- After the first Stage 7 naming/reference refactor slice, test only the indexed families changed by that slice plus normal startup/reload.

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

### Stage 7 - Post-Validation Naming / Reference Refactor — IN PROGRESS
- Stage 6 and the deferred Scan1/Scan2 correction are user-accepted, so Stage 7 is unblocked.
- First perform a narrow access-pattern audit of the existing 118 `getglobal()` call sites / 55 frozen dynamic expressions, then replace only clear repeated indexed UI families with Lua-owned references/tables where practical.
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
Begin Stage 7 with a narrow lookup audit only. Inventory the current dynamic `getglobal()` call sites in `PallyPower.lua` by family and access pattern, then implement the smallest coherent reference-table slice for repeated indexed UI families (expected candidates: player rows, class columns, Buff Bar buttons). Preserve every existing named global as a compatibility alias, do not change behavior/data/protocol, and do not modernize legacy callback semantics in the same slice. Run the real Lua 5.0.2 compiler check and define a focused runtime regression test for exactly the families changed.
