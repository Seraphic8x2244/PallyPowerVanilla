# Development Progress

## Current
- Branch: `dev`
- Version: `1.11.0-dev`
- Goal: Migrate PallyPowerVanilla to the VanillaTemplate development structure without changing runtime architecture or artwork hierarchy.
- State: First in-game migration/UI test passed; utility tint strength and Judgement rank reporting are under review.

## Recent Commits
- `4bd4f50` - Stable v1.10.20 migration baseline on `master`.
- `ca606aa` - Refresh migration handoff state after interrupted development pass.
- `c465616` / `a8837b9` - Localize remaining control tooltips and wire Lua usages.
- `b3b03a9` - Localize PallyPower XML labels.
- `fe7caff` / `ddc3890` - Localize capability/Judgement tooltip fragments.
- `d62e2e5` / `bd56cd0` - Localize assignment reports and player-facing cast feedback.

## Completed / Verified
- Existing `master` v1.10.20 retained unchanged as the stable migration baseline.
- `dev` created from current `master`.
- VanillaTemplate development contract adopted in `DEV_GUIDE.md`.
- `PallyPowerVanilla.toc` filename preserved.
- Dev TOC metadata set to `PallyPowerVanilla-dev` / `1.11.0-dev`.
- TOC is the source of truth for the addon version in Lua.
- Existing `PallyPower_Version` compatibility global retained for the VERSION wire protocol.
- Locale moved from `Locale/localization-enUS.lua` to `locales/enUS.lua`.
- Locale/version load-order issue identified and corrected.
- Player-facing modern UI, XML labels, tooltips, assignment report labels and cast-failure feedback moved to locale constants.
- Artwork hierarchy is unchanged.
- `PallyPower.xml`, `Bindings.xml`, SavedVariables and addon communication formats are unchanged structurally.
- Static audit found no stale legacy locale paths.
- Static audit found no obvious Lua 5.1-only syntax such as `#`, `string.gmatch`, `table.pack/unpack`, or `goto`.
- Remaining literal XML text values are placeholders/sample values rather than UI labels.
- Existing Nampower and UnitXP calls remain behind their existing capability/enable checks.

## Implemented / Awaiting Test
- Paladin HoJ/LoH/DI icons now show green when ready, red when known unavailable/on cooldown, and grey when cooldown state is unknown.
- Aura and Judgement capability micro-icon clusters removed; assignment icons and hover tooltips preserved.
- Entire `1.11.0-dev` structural migration.
- Version metadata centralization.
- Locale path migration and localization cleanup.
- XML label localization.
- TOC-derived version in credits/version tooltip.

## Current Issues
- Migration changes have not yet been tested in game.
- Obsolete `PallyPower_Credits5` tooltip line removed; contributor credits remain in README.

## Testing

### Last Test
- Version/commit: `1.11.0-dev` / current `dev`
- Passed: Addon loads and runs in game; assignment-grid Aura/Judgement cleanup renders correctly; general UI is working.
- Observed: HoJ/LoH/DI colour tint is visually too strong; Judgement tooltip/rank reporting does not match the correct Seal rank reporting.
- Not yet fully verified: complete regression matrix including compatibility paths.

### Next Test
Install/run `dev` as `PallyPowerVanilla` on WoW 1.12.1 and verify:
- Addon loads with no Lua/XML errors.
- Existing SavedVariables and presets load.
- Buff Bar opens and updates.
- Blessing Management and Advanced Options open correctly.
- Localized labels/tooltips render instead of constant names.
- Assignment reporting works.
- Blessing cast/failure feedback renders correctly.
- Keybindings and minimap button work.
- Standard/HD artwork and expiry sound still resolve from the unchanged hierarchy.
- Addon VERSION communication still works with existing PallyPower clients.
- Native operation works with no optional DLLs.
- Nampower and UnitXP enhanced paths still work when present.

## Planned / To-do
- Run the first in-game migration/UI test, including HoJ/LoH/DI ready/not-ready colours.
- Fix only migration regressions found by that test.
- Re-run static audit after any fixes.
- After user verification, decide whether `1.11.0` is ready to promote to stable `main`.

## Ideas / Backlog
- Revisit artwork hierarchy separately after this migration is stable.
- First in-game test of the accumulated `1.11.0-dev` migration/UI cleanup.

## Deferred
- Artwork flattening or renaming.
- XML-to-Lua UI conversion.
- Module split or architecture rewrite.
- SavedVariables redesign.
- Communication protocol redesign.

## Exact Next Step
Soften HoJ/LoH/DI readiness tinting without fading the icons, trace Judgement capability rank data against Seal capability data, fix the incorrect Judgement rank source, then statically verify before user retest.
