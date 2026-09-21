# Development Progress

## Current
- Branch: `dev`
- Version: `1.11.0-dev` (migration target)
- Goal: Migrate PallyPowerVanilla to the VanillaTemplate development structure without changing runtime architecture or artwork hierarchy.

## Recent Commits
- `4bd4f50` - Remove one-shot artwork rename workflow (migration baseline on master)
- Development guide added on `dev`.

## Completed / Verified
- Existing `master` v1.10.20 retained as the stable migration baseline.
- `dev` created from current `master`.
- VanillaTemplate development contract adopted.

## Implemented / Awaiting Test
- None yet.

## Current Issues
- Legacy repository structure does not yet match the current addon development standard.
- Version metadata is not fully centralized.
- Locale file/path uses the old `Locale/localization-enUS.lua` layout.
- Some user-facing strings remain embedded in Lua/XML.

## Testing

### Last Test
- Version/commit: v1.10.20 / `4bd4f50`
- Passed: Existing stable baseline only; no migration changes tested yet.
- Failed: None recorded.
- Not tested: All migration changes.

### Next Test
- Load the migrated dev build in WoW 1.12.1 and verify clean startup, SavedVariables, main UI, assignments, buff bar, keybindings, minimap button, sound, addon communication, and optional extension fallbacks.

## Planned / To-do
- Update dev TOC metadata while keeping filename `PallyPowerVanilla.toc`.
- Make the TOC the single source of truth for addon version metadata.
- Move `Locale/localization-enUS.lua` to `locales/enUS.lua`.
- Audit genuine user-facing hardcoded strings and move appropriate strings into `locales/enUS.lua`.
- Perform a static Vanilla 1.12.1 / Lua 5.0 compatibility audit.
- Preserve `PallyPower.xml`, `Bindings.xml`, SavedVariables, communication formats, and existing runtime architecture.

## Ideas / Backlog
- Revisit artwork hierarchy separately after this migration is stable.

## Deferred
- Artwork flattening or renaming.
- XML-to-Lua UI conversion.
- Module split or architecture rewrite.
- SavedVariables redesign.
- Communication protocol redesign.

## Exact Next Step
Update `PallyPowerVanilla.toc` for the dev branch and centralize addon/version metadata without changing compatibility behaviour.
