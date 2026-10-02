# PallyPowerVanilla 2.0 Performance / Architecture Audit

Date: 2026-10-02  
Audit branch: `dev`  
Stable runtime baseline: `1.11.39` / `fb4e960751b87ba2077c4277ec93325f65c39ed7`  
Audit scope start: `d7fea63073a385cb6e4edb748685ad37581f6760`

This is a static architecture/performance audit of the current 1.11.39 implementation. It does not represent an in-game benchmark or profiler result. Runtime code was not changed during the audit.

## Executive Summary

The largest performance problem is not one expensive Lua primitive. It is accumulated execution-model debt: unrelated operations are coupled together, full state/UI refreshes are used as generic invalidation, and work that should be event-driven is repeated every frame or every cast attempt.

The 2.0 rewrite should therefore be a core ownership rewrite rather than a collection of local optimizations.

The most important architectural rule for 2.0 is:

> Events and actions mutate canonical state, mark precise dirty domains, and render/reconcile only the affected domains. No gameplay action should implicitly rescan unrelated state or rebuild unrelated UI.

The 3.0 ClassicAPI line should reuse the same 2.0 core and simplify its platform layer. It should not require a second architecture rewrite.

## Highest-Priority Findings

### P0 — AutoBless rescans the whole local capability model on every invocation

`PallyPower_AutoBless()` begins with:

```lua
local rankInfo = PallyPower_ScanSpells()
```

The returned value is unused.

`PallyPower_ScanSpells()` performs much more than spell lookup:

- walks the player spellbook;
- reads spell names/textures and parses ranks;
- rebuilds blessing/aura/seal capability tables;
- reads blessing tooltip data for mana/range/duration;
- scans relevant talents;
- updates local capability state;
- when already initialized, calls `PallyPower_SendSelf()`;
- calls `PallyPower_ScanInventory()`.

Therefore a blessing hotkey can perform spellbook scanning, tooltip parsing, talent scanning, bag scanning and a communication burst before attempting the cast.

**2.0 target:** a cached `SpellCatalog` rebuilt only on relevant lifecycle changes. Casting reads immutable cached capability data and has no capability-scan, bag-scan or communication side effects.

### P0 — Assignment UI is effectively fully re-rendered every frame

The Assignment UI has an `OnUpdate` handler that calls `PallyPowerGrid_Update()`.

While visible, that function repeatedly:

- rewrites class/special textures;
- renders every Paladin row;
- writes cooldown/rank/capability cells;
- rewrites all assignment cells;
- iterates all class/player override rows;
- hides every unused player slot;
- realigns player content;
- updates flyouts;
- recalculates assignment geometry/linkers;
- refreshes preset dirty state.

This is unnecessary work when nothing changed.

**2.0 target:** event/dirty-driven Assignment rendering. Roster changes, capability messages, assignment mutations and layout-setting changes invalidate only their relevant view domains. No Assignment `OnUpdate` renderer.

### P0 — Local aura changes call the monolithic full UI refresh synchronously

`PLAYER_AURAS_CHANGED` calls `PallyPower_UpdateUI()` directly after the RF/Salvation logic.

A local Blessing landing can therefore synchronously trigger the whole Buff Bar rebuild in the same frame. This is a direct match for the reported “people gaining Blessings causes a frametime spike” symptom when the local player receives one.

**2.0 target:** one lightweight local-aura snapshot/update that changes only RF/Aura/Seal/Blessing state affected by the event.

### P0 — `PallyPower_UpdateUI()` is a god refresh

The current full refresh mixes:

- static UI state;
- layout/geometry;
- local RF/Aura/Seal scans;
- Judgement tracker state;
- assignment traversal;
- class/member buff aggregation;
- timers;
- frame visibility;
- textures, text, colors and bar dimensions.

This means a small state change often pays for unrelated work.

It also allocates new transient tables such as `btn.need`, `btn.have`, `btn.range` and `btn.dead` on refresh. Hidden buttons even replace scalar identity fields such as `classID` / `buffID` with fresh empty tables.

**2.0 target:** split state calculation from rendering and split rendering by dirty domain:
- BuffBar layout;
- local self-buffs;
- per-class blessing aggregate;
- timer text;
- Judgement;
- static controls.

### P0 — Post-cast scan completion ends with another synchronous full refresh

Successful blessing casts set `PP_NextScan = 1`. The raid scan is spread over frames, but its final frame performs:

```lua
PallyPower_ScanInventory()
PallyPower_UpdateUI()
```

That creates a second Blessing-correlated cost roughly one second after casting.

**2.0 target:** scan one unit, diff that unit’s persistent aura record, update only affected class aggregate(s), and render only those class buttons. Inventory scanning must be independently invalidated.

## Assignment UI Hot-Path Debt

### Repeated hidden-slot writes

For every class, unused player slots are reset every frame. With ten classes and fifteen fixed slots, an empty/sparse raid can still cause hundreds of widget calls per frame (`SetTexture`, `Hide`, `SetFrameStrata`, `SetAlpha`).

Only transition a slot when its populated/visible state actually changes.

### O(Paladins × raid size) subgroup lookup per frame

Each Paladin row calls `PallyPower_GetPlayerGroupID(name)`, which scans `GetRaidRosterInfo` until the name is found.

Cache `subgroupByName` / `subgroupByGUID` when the roster changes.

### Geometry and linker recalculation per frame

`UpdateAssignmentGeometry()` and `UpdateAssignmentLinkers()` repeatedly touch anchors, widths, visibility and gradients. Linker code also allocates a fresh column-key table each call.

Geometry should only invalidate on:
- number/order of visible Paladins;
- assignment layout settings;
- assignment cells affecting linker extent.

### Per-member text measurement/reanchoring per frame

`AlignPlayerOverrideContent()` calls `GetStringWidth`, clears anchors and rewrites anchors/widths.

Run it only when the displayed name or button width changes.

### Preset state is refreshed in the frame loop

`PallyPower_PresetsRefreshState()` is called from `PallyPowerGrid_Update()`. Preset presentation is currently intentionally hidden, making this especially wasteful.

Refresh preset state on preset/assignment mutation or explicit UI open only.

## Scan / State Model Debt

### `PP_NextScan` owns too many meanings

The same scalar is used as:

- periodic raid scan timer;
- generic dirty flag;
- short debounce;
- post-cast reconciliation delay;
- response to roster/comms/death/login/UI options.

This causes unrelated changes to collapse into “do a full raid scan.”

Replace it with explicit dirty domains and independent deadlines.

### Raid scan rebuilds an entire temporary tree

Each scan cycle allocates `PP_Scanners`, `PP_ScanInfo`, per-class maps and per-unit records, then swaps `CurrentBuffs`.

Use persistent records keyed by stable identity. A scan updates one record and produces a diff.

### Queue-front removal shifts the scan array

The scan repeatedly removes index 1. Use an integer cursor rather than shifting the remaining array.

### Fallback aura scanning calls `UnitBuff` twice per aura

Several loops use `UnitBuff(...)` in both the loop condition and body. Store the result from a single call.

### Local self-state scans the same aura set multiple ways

A full UI update separately determines:
- Righteous Fury;
- assigned Aura;
- assigned Seal.

Generate one local aura snapshot and derive all self-buff truth from it.

### “visible” conflates several concepts

`stats.visible = UnitIsVisible(unit)` is subsequently treated as “range/away,” while casting has separate range and LoS concepts.

The state model should distinguish:
- connected;
- client-visible/synced;
- alive;
- spell range known/in range;
- LoS known/in LoS.

## Timer / OnUpdate Debt

The main Buff Bar `OnUpdate`:

- advances pending blessing transaction timing;
- updates timer text every second;
- updates Judgement visual state;
- advances AutoBless selection timeout;
- advances Judgement scan deadline;
- restores auto-self-cast;
- advances raid scan deadline;
- iterates every class timer every frame;
- iterates every individual-player timer every frame.

The class/player blessing timers should be stored as absolute expiration timestamps instead of decrementing every frame.

The display layer can calculate `expiresAt - now` only when text needs refreshing.

Class-level timer display aggregates (newest/shortest individual timer) should be maintained when timer state changes rather than rescanning all class members every second.

## Cast-Path Debt

### Click casting and AutoBless duplicate large amounts of logic

Both paths independently implement:

- normal vs Greater selection;
- recent-cast protection;
- individual overrides;
- pet behavior;
- candidate iteration;
- range/LoS checks;
- Salvation-on-tank guard;
- targeting/casting;
- timer transactions;
- post-cast state.

Create one `CastPlanner` and one `CastExecutor`. UI click and hotkey paths only supply policy/input.

### Candidate construction allocates on every attempt

The fallback path constructs a new array and one table per candidate. The UnitXP path adds distance/LoS fields and sorts the whole list.

A reusable candidate buffer is enough. If the goal is “first/nearest viable target,” the system does not necessarily need a complete sort.

### String-joined lists are used as membership tests

Examples construct strings with `table.concat` and then `string.find` to test whether a player/unit occurs in `need` or `LastCastOn`.

This allocates strings and is semantically weaker than exact membership. Use sets keyed by unit/name/GUID.

### Debug logging allocates even when no logger is active

The LoS/distance helpers construct concatenated debug strings before the helper checks whether `OGAALogger` exists.

Guard formatting itself behind the debug/logger condition.

### Repeated identity/API calls

Hot casting repeatedly calls `UnitName("player")`, `UnitName(unit)`, and similar APIs when the roster/candidate record already has that data.

Cache player identity and use canonical roster records.

## Spell / Inventory / Capability Debt

### Capability discovery is coupled to normal gameplay

Spell discovery should be a lifecycle operation, not a cast operation.

### Tooltip parsing is repeated when capability is rebuilt

Blessing cost/range/duration are read through a hidden tooltip. For stock 1.12 compatibility this can remain a fallback, but the results should be cached until the spellbook/talent/equipment state that affects them changes.

### Inventory scanning is coupled to raid scans and spell scans

`PallyPower_ScanInventory()` walks bags and string-matches item links. Symbol count should be invalidated by bag/inventory events, not every aura reconciliation or spell refresh.

## Communications / Protocol Debt

### `PallyPower_SendSelf()` is a multi-packet burst

One full self broadcast can emit:
- `SELF`;
- `SYMCOUNT`;
- `COOLDOWNS`;
- `FREEASSIGN`;
- `ASELF`;
- `SSELF`;
- `JSELF`;
- `RFCAP`;
- legacy `RFSELF`;
- `RFSELF2`;
- one `TANK` message per tank.

This is acceptable as a compatibility full-state response, but it is currently triggered too indirectly.

### Spell scan can send state, and roster change can send it twice

Once initialized, `PallyPower_ScanSpells()` calls `PallyPower_SendSelf()`.

The roster-change handler then explicitly calls `PallyPower_SendSelf()` again.

Scanning/caching functions must not perform network I/O as a hidden side effect.

### Parser is a long series of independent pattern tests

`PallyPower_ParseMessage()` checks roughly forty command/pattern forms through a large conditional chain.

Parse the command token once and dispatch to a handler table. Keep the legacy wire format unchanged behind a `LegacyProtocol` adapter.

### REQ/full-state fanout should be coalesced

Roster changes can cause multiple clients to issue `REQ`, and peers can answer with full multi-message state bursts.

Preserve compatibility but coalesce redundant same-state work and eliminate duplicate sends. Any throttling/delay must be based on measured protocol/runtime needs, not guessed.

## Persistence / Legacy Compatibility Debt

The assignment migration already places special assignment data inside `PallyPower_Assignments[name]`, but inherited code continues to access separate globals through metatable proxy tables.

That is a useful migration bridge, not a good 2.0 internal model.

Create one canonical `AssignmentStore`. Legacy SavedVariables/proxy names should exist only at the import/export or compatibility boundary.

The TOC still declares multiple historical assignment SavedVariables; 2.0 can preserve migration from them without treating them as separate live state owners.

## Global Namespace / Maintainability Debt

There are many global state tables and some accidental global writes in function bodies (examples include message/cast/scan temporaries). This makes side effects hard to reason about and makes refactors fragile.

2.0 should use one deliberate addon namespace (for example `PP`) and explicitly exported legacy entry points only.

Because the stock target remains Lua 5.0.3, module/file boundaries should also avoid the parser/compiler local/upvalue limits documented in the project rulebook.

## Correctness Smells Worth Fixing During the Rewrite

- The Assignment code comments that Paladin row 1 is always the local player but iterates a map without an explicit ordering model.
- Texture/name matching is used in several aura/capability paths where an ID mapping would be safer.
- Some old XML-ownership comments remain after the Lua UI migration and no longer describe reality.
- Hidden/dormant feature code still participates in runtime refresh paths.

## 2.0 Target Architecture

2.0 should remain a native WoW 1.12.1 / Lua 5.0-compatible addon with no DLL hard requirement.

Recommended ownership boundaries:

| Component | Owns |
| --- | --- |
| `Core/EventRouter` | Translate WoW events/actions into state mutations and dirty flags |
| `Scheduler` | Coalesced dirty flushes and real deadlines; no generic scan timer |
| `Platform` | Capability facade for stock API and optional extensions |
| `RosterStore` | Stable unit/name/class/subgroup identity snapshot |
| `SpellCatalog` | Cached local spells, ranks, costs, ranges, talents and capability |
| `AuraStore` | Persistent per-unit blessing state and class aggregates |
| `AssignmentStore` | Canonical assignment model plus migration boundary |
| `TimerStore` | Absolute blessing/Judgement expirations and aggregates |
| `CastPlanner` | Pure selection/eligibility decision |
| `CastExecutor` | Target/cast operation and resulting state events |
| `LegacyProtocol` | Existing PLPWR wire encode/decode |
| `BuffBarRenderer` | Diff-based Buff Bar view |
| `AssignmentRenderer` | Dirty/event-driven management view |

Core rules:

1. No UI renderer runs every frame.
2. No cast path rescans spellbook, bags or protocol state.
3. No scan completion performs a generic full UI rebuild.
4. Timer state uses absolute timestamps.
5. Every expensive cache has an explicit invalidation source.
6. Rendering compares desired state to the last rendered state before calling WoW frame APIs.
7. Legacy wire/SavedVariable compatibility is translated at boundaries, not allowed to dictate internal structure.
8. Core code asks for capabilities, not named DLLs.

## Suggested 2.0 Implementation Sequence

1. Establish baseline runtime scenarios and profiling/instrumentation.
2. Introduce the scheduler/dirty-domain model and cached `SpellCatalog`; remove spell scanning from AutoBless.
3. Replace Assignment `OnUpdate` rendering with explicit invalidation.
4. Split `PallyPower_UpdateUI()` into independent Buff Bar domains.
5. Convert timers to expiration timestamps.
6. Replace full-tree aura scans with persistent unit records and class diffs.
7. Separate inventory invalidation from aura/spell scanning.
8. Unify click/AutoBless through `CastPlanner` / `CastExecutor`.
9. Isolate legacy protocol parsing/sending and remove duplicate/implicit broadcasts.
10. Move assignment storage to one canonical internal store with legacy import/export adapters.
11. Profile 40-player raid behavior and compatibility paths before promotion.

## 3.0 ClassicAPI Direction

3.0 should reuse the 2.0 state/core/render architecture and replace the multi-provider platform layer with a mandatory ClassicAPI provider.

For PallyPowerVanilla's current uses, ClassicAPI exposes direct replacements for the extension roles now supplied by optional Nampower/SuperWoW/UnitXP paths:

| Current PPV need | Current extension path | ClassicAPI direction |
| --- | --- | --- |
| stable unit GUID / GUID-addressable units | SuperWoW-style GUID path | `UnitGUID`, GUID unit tokens, `UnitTokenFromGUID` |
| aura spell identity | Nampower `GetUnitField(..., "aura")` + spell-record lookup | `C_UnitAuras` and aura `spellId` |
| spell metadata/range | tooltip / extension fallbacks | `GetSpellInfo`, `C_Spell`, `C_Spell.IsSpellInRange` |
| world distance | UnitXP `distanceBetween` | `UnitDistanceSquared` |
| line of sight | UnitXP `inSight` | `UnitInLineOfSight` |

This means 3.0 can plausibly delete PPV's own Nampower, SuperWoW and UnitXP integration branches for the functionality PPV currently consumes. It does **not** imply ClassicAPI replaces every feature of those projects globally.

3.0 should prefer spell IDs and GUIDs as canonical identity and should avoid mixing competing global implementations such as `UnitPosition` when a direct ClassicAPI primitive (`UnitDistanceSquared`, `UnitInLineOfSight`, `C_Spell.IsSpellInRange`) answers the actual question.

A future 3.0 investigation should verify whether ClassicAPI unit-aura events are sufficiently complete/reliable for all raid units to eliminate periodic reconciliation completely. Until verified in the target client/server matrix, retain a low-frequency reconciliation path rather than assuming event coverage.

## Recommended Relationship Between 2.0 and 3.0

Do not write two cores.

2.0 should build the clean state machine, scheduling, rendering, casting and protocol architecture behind a small platform interface.

3.0 then becomes mostly deletion/simplification:

- require ClassicAPI;
- remove stock/legacy extension providers;
- replace texture/name fallbacks with spell-ID aura queries;
- replace UnitXP range/LoS with ClassicAPI primitives;
- replace SuperWoW GUID handling with ClassicAPI identity;
- optionally modernize API/script-handler usage where it materially improves the addon.

The architectural investment therefore happens once, in 2.0.
