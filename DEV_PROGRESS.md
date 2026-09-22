# Development Progress

## Current
- Branch: `dev`
- Version: `1.11.0-dev`
- Stable branch/version: `main` / `1.11.0`
- Stable commit: `8c520ca1335f6de23409c2b94dd7b7e8a52c2b09`
- Goal: Maintain PallyPowerVanilla for WoW 1.12.1 using the VanillaTemplate development structure while preserving the mature runtime architecture.
- State: `1.11.0` promoted to stable `main` after user approval and in-game testing.

## Recent Commits
- `07883db` - Fix Judgement rank mapping and soften HoJ/LoH/DI status tints.
- `62662b4` - Document focused retest state.
- `c43d049` - Approve `1.11.0` stable promotion on `dev`.
- `6c0e11d` - Set stable TOC metadata to `1.11.0` on `main`.
- `8f352fd` - Update README to v1.11.0 on `main`.
- `8c520ca` - Final stable `main` tree after removing development-only progress documentation.

## Completed / User Verified
- Structural migration to the VanillaTemplate conventions is complete.
- Addon loads and runs in game.
- Existing XML + Lua architecture is preserved.
- TOC remains `PallyPowerVanilla.toc`.
- TOC is the version source of truth.
- Locale path is `locales/enUS.lua`.
- Aura/Judgement assignment micro-icon clusters are removed while their assignment icons and tooltips remain.
- Judgement capability ranks now map to the correct underlying Wisdom/Light/Crusader Seal ranks.
- HoJ/LoH/DI utility indicators show green when ready, red when known unavailable/on cooldown, and grey when state is unknown, using softened tints.
- Obsolete contributor tooltip line removed; credits remain in README.
- Stable `main` contains `PallyPowerVanilla` / `1.11.0` metadata and excludes `DEV_GUIDE.md` / `DEV_PROGRESS.md`.
- Artwork hierarchy, SavedVariables and communication formats were not deliberately redesigned.

## Implemented / Awaiting Test
- No known release-blocking work.
- Not every optional client-extension/legacy-client combination has a separately documented test result.

## Current Issues
- No known release-blocking issues.
- GitHub repository default branch is still `master`; stable code now lives on `main`.

## Testing

### Last Test
- Version: `1.11.0-dev` immediately before stable promotion.
- Passed: general addon/UI operation, Aura/Judgement cleanup, corrected Judgement ranks, softened HoJ/LoH/DI status colours, plus most broader smoke checks reported by the user.
- Failed: no known release-blocking failures.

### Next Test
- Normal use of stable `1.11.0`; investigate only if a release-specific regression is reported.

## Planned / To-do
- Use `dev` for the next development cycle.
- Decide whether to change the GitHub repository default branch from legacy `master` to stable `main`.

## Ideas / Backlog
- Revisit artwork hierarchy separately if worthwhile.
- Prefer new feature investment in the spiritual successor rather than a large XML-to-Lua refactor of PallyPower.

## Deferred
- Artwork flattening or renaming.
- XML-to-Lua UI conversion.
- Module split or architecture rewrite.
- SavedVariables redesign.
- Communication protocol redesign.

## Exact Next Step
No code change is required for `1.11.0`. If desired, change the repository default branch from legacy `master` to stable `main`; otherwise begin the next development cycle on `dev` only when new work is requested.
