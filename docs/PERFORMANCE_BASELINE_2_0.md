# PallyPowerVanilla 2.0 Performance Baseline

This document defines the repeatable Step 1 baseline used to compare later 2.0 performance work. It measures the existing 1.11.39 execution model with development-only instrumentation; it does not change or optimize gameplay/UI behavior.

## Instrumentation

Development builds load `Debug.lua`, but profiling is disabled by default. When disabled, the existing runtime functions are not wrapped.

Commands:

- `/ppvperf start <label>` — clears the previous capture, installs the profiling wrappers and starts a run.
- `/ppvperf stop` — stops the run and restores the original runtime functions.
- `/ppvperf report` — prints the current or most recent capture.
- `/ppvperf reset` — clears the previous capture.
- `/ppvperf status` — shows whether profiling is active.

The report records inclusive call count, total time, average time and maximum call time for these existing paths:

- `PallyPower_OnUpdate`
- `PallyPowerGrid_Update`
- `PallyPower_UpdateUI`
- `PallyPower_ScanRaid`
- `PallyPower_ScanSpells`
- `PallyPower_ScanInventory`
- `PallyPower_AutoBless`
- `PallyPower_SendSelf`
- `PallyPower_SendMessage`
- `PallyPower_ParseMessage`
- `PallyPower_OnEvent`

It also records the relevant aura/roster/addon-message event counts, sent/received PLPWR message counts and bytes, message types, elapsed run time, scan settings, group size, Assignment-window visibility, optional Nampower/UnitXP state and the Lua memory delta reported by `gcinfo()` when available.

Timings are inclusive. Nested rows overlap and must not be added together. The `gcinfo()` delta is whole-UI Lua memory context, not PallyPower-only allocation accounting.

## Comparison Rules

For a before/after comparison:

1. Use the same character, client, addon set, PallyPower settings and optional extension state.
2. Keep raid/party composition as close as practical to the baseline run.
3. Keep `scanfreq` and `scanperframe` unchanged unless the scenario explicitly records a different value.
4. Start profiling only for the measured window and stop it immediately afterwards.
5. Compare the same named metric across builds. Do not compare the sum of all timing rows.
6. Record the exact addon version/commit that produced each capture. Runtime validation belongs to that exact build.
7. Prefer repeated runs when conditions are noisy; retain all results rather than selecting only the best run.

## Baseline Scenarios

### B1 — Idle raid, Assignment closed

Purpose: measure the ordinary Buff Bar/update loop plus natural periodic reconciliation without Assignment rendering.

1. Join the target raid composition; 40 players is preferred for the final raid baseline.
2. Close the Assignment window.
3. Do not cast, change assignments, move raid members or deliberately trigger roster/comms activity.
4. Run `/ppvperf start B1-idle-raid`.
5. Leave the client idle for 60 seconds.
6. Run `/ppvperf stop`, then `/ppvperf report`.

Record the full report. `PallyPower_OnUpdate`, natural `PallyPower_ScanRaid` activity and scan-completion `PallyPower_UpdateUI` are the primary comparison rows.

### B2 — Idle raid, Assignment open

Purpose: isolate the cost added by the current per-frame Assignment renderer.

1. Keep the same raid and settings as B1.
2. Open the Assignment window and leave it untouched.
3. Run `/ppvperf start B2-assignment-open`.
4. Leave the client idle for 60 seconds.
5. Run `/ppvperf stop`, then `/ppvperf report`.

`PallyPowerGrid_Update` is the primary comparison row. Compare B2 against B1 from the same build/session where possible.

### B3 — Receiving Blessings

Purpose: measure the current local aura-event/full-UI-refresh path.

1. Close the Assignment window.
2. Have another Paladin alternate two learned single-target Blessings on the profiling character so that each cast changes the active Blessing.
3. Run `/ppvperf start B3-receive-blessings` immediately before the first cast.
4. Receive 20 Blessing changes.
5. Run `/ppvperf stop`, then `/ppvperf report`.
6. Verify the report shows the expected `PLAYER_AURAS_CHANGED` activity; if unrelated aura changes dominated the run, repeat it.

`PLAYER_AURAS_CHANGED` and `PallyPower_UpdateUI` are the primary comparison metrics.

### B4 — Repeated AutoBless

Purpose: measure the current AutoBless hot path, including its hidden capability/inventory/comms work.

1. Use a stable group/assignment setup with enough eligible targets for 20 successful AutoBless attempts.
2. Close the Assignment window unless a later comparison intentionally tests it open.
3. Run `/ppvperf start B4-autobless`.
4. Invoke AutoBless 20 times at a normal usable cadence.
5. Run `/ppvperf stop`, then `/ppvperf report`.
6. Confirm `PallyPower_AutoBless calls=20`. If not, rerun the scenario.

The important relationship is AutoBless calls versus `PallyPower_ScanSpells`, `PallyPower_ScanInventory`, `PallyPower_SendSelf` and sent PLPWR messages.

### B5 — Periodic raid scan

Purpose: measure one or more complete current raid reconciliation cycles separately from deliberate casting/assignment activity.

1. Use the target raid composition with the Assignment window closed.
2. Record the reported `scanfreq` and `scanperframe` values; do not change them during the run.
3. Run `/ppvperf start B5-raid-scan`.
4. Remain idle until at least one natural scan has completed and its completion `PallyPower_UpdateUI` has occurred. A 60-second window is the default when the configured scan frequency is 10 seconds or less.
5. Run `/ppvperf stop`, then `/ppvperf report`.

Use `PallyPower_ScanRaid` total/call count together with `PallyPower_ScanInventory` and `PallyPower_UpdateUI` to compare the scan lifecycle. With `scanperframe=1`, a full 40-player scan is expected to span many `PallyPower_ScanRaid` calls rather than one call.

### B6 — Roster update burst

Purpose: measure the current roster-event cascade without changing its behavior.

1. Use a raid with at least two subgroups and a raid leader/assistant able to move a member.
2. Run `/ppvperf start B6-roster`.
3. Move one member between two subgroups five times, waiting for each move to register before the next.
4. Run `/ppvperf stop`, then `/ppvperf report`.
5. Record the actual `RAID_ROSTER_UPDATE` count. If it differs materially between comparison runs, repeat until the event count is comparable.

Compare `PallyPower_OnEvent`, `PallyPower_ScanSpells`, `PallyPower_SendSelf`, `PallyPower_ScanRaid` and sent-message counts.

### B7 — Communication burst

Purpose: measure inbound PLPWR parsing and the downstream invalidation work caused by a controlled assignment-message burst.

1. Keep the profiling client otherwise idle and close its Assignment window.
2. Use a second PallyPower client in the same party/raid.
3. Run `/ppvperf start B7-comms` on the profiling client.
4. On the second client, perform 20 assignment changes that send normal PLPWR assignment messages.
5. Run `/ppvperf stop`, then `/ppvperf report`.
6. Verify the received message-type counts show the intended assignment traffic and record any additional protocol messages that occurred during the window.

`PallyPower_ParseMessage`, `CHAT_MSG_ADDON`, received message counts/types and any resulting scan/UI work are the primary comparison metrics.

## Step 1 Result State

Step 1 establishes the instrumentation and procedure only. No in-game baseline numbers are manufactured from static analysis. Baseline result rows should be added to the development handoff only after they have actually been captured in the target WoW 1.12.1 environment and tied to the exact tested build.
