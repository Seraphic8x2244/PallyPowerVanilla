# Development Progress

## Current
- Branch: `dev`
- Version: `1.11.0-dev`
- Goal: Migrate PallyPowerVanilla to the VanillaTemplate development structure without changing runtime architecture or artwork hierarchy.
- State: User reports the accumulated migration/UI fixes working and has approved `1.11.0` for stable promotion to `main`.

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
- No release-blocking items remain. Some optional compatibility-path smoke checks are not individually documented, but the user has tested most of the release and considers it stable enough to ship.

## Current Issues
- No known release-blocking issues.
- Obsolete `PallyPower_Credits5` tooltip line removed; contributor credits remain in README.

## Testing

### Last Test
- Version/commit: `1.11.0-dev` / current `dev`
- Passed: Addon loads and runs in game; Aura/Judgement cleanup works; Judgement ranks now match Seal ranks; HoJ/LoH/DI state tinting works with the softened colours; user reports most broader smoke checks tested.
- Failed: No known release-blocking failures.
- Not individually documented: every optional compatibility-path combination.

### Next Test
- Stable `main` release smoke test only if a packaging/release-specific issue appears.

## Planned / To-do
- Promote tested `dev` state to stable `main` as `1.11.0`.
- Keep `dev` available for subsequent development.

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
Create stable `main` from the approved `dev` state, set TOC/README version to `1.11.0`, exclude development-only docs from `main`, then record the stable commit back in this handoff.
