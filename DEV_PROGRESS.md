# Development Progress

## Current
- Branch: `dev`
- Version: `1.11.0-dev`
- Goal: Migrate PallyPowerVanilla to the VanillaTemplate development structure without changing runtime architecture or artwork hierarchy.

## Recent Commits
- `4bd4f50` - Stable v1.10.20 migration baseline on `master`.
- `2f85dce` - Add development guide.
- `ef87e51` - Add migration progress tracking.
- `40e6082` - Start PallyPowerVanilla 1.11.0 development.
- `a7b2429` - Centralize addon version metadata.
- `7a2e037` / `dc2a546` / `fa941df` - Move enUS locale to the standard `locales/enUS.lua` path and update the TOC.
- `8d31aab` / `81b1f3c` - Fix locale/version load ordering and use TOC-derived version in credits.
- `46c3432` and following interrupted-pass write - Add modern UI/status locale constants and wire the Lua usages.

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
- Artwork hierarchy, XML/Lua architecture, SavedVariables and communication format remain unchanged.

## Implemented / Awaiting Test
- Lua user-facing modern UI/status strings have been moved to locale constants.
- TOC/version metadata migration.
- Locale path migration.
- Credits/version tooltip now reads the TOC-derived version.

## Current Issues
- A set of user-facing labels remains hardcoded in `PallyPower.xml`.
- Two assignment-control tooltip strings remain hardcoded in Lua.
- Migration changes have not yet been tested in game.

## Testing

### Last Test
- Version/commit: v1.10.20 / `4bd4f50`
- Passed: Existing stable baseline only.
- Failed: None recorded.
- Not tested: All `1.11.0-dev` migration changes.

### Next Test
- Load `1.11.0-dev` in WoW 1.12.1 and verify clean startup, SavedVariables, main UI, assignments, buff bar, keybindings, minimap button, sound, addon communication and optional extension fallbacks.

## Planned / To-do
- Replace genuine user-facing hardcoded XML labels with existing/new `locales/enUS.lua` constants.
- Localize the remaining assignment-control tooltips in Lua.
- Re-audit Lua/XML for player-facing hardcoded strings without touching diagnostic/internal strings.
- Perform a static Vanilla 1.12.1 / Lua 5.0 compatibility audit.
- Prepare a concise in-game migration test checklist.

## Ideas / Backlog
- Revisit artwork hierarchy separately after this migration is stable.

## Deferred
- Artwork flattening or renaming.
- XML-to-Lua UI conversion.
- Module split or architecture rewrite.
- SavedVariables redesign.
- Communication protocol redesign.

## Exact Next Step
Wire the remaining player-facing XML labels and assignment-control tooltip text to `locales/enUS.lua`, then perform a static migration audit.
