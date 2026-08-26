# PallyPowerVanilla v1.10.8

PallyPowerVanilla is a modernised, compatibility-focused fork of **PallyPower** for World of Warcraft 1.12.1

The aim is to preserve the familiar PallyPower experience and compatibility with existing versions while improving the addon for modern Vanilla clients and servers.



## Project Goals

- **Modernisation** — improve PallyPower without changing what makes it PallyPower, with a cleaner interface and less reliance on inherited hardcoded behaviour.
- **Compatibility** — support a broad range of World of Warcraft 1.12.1-based clients and servers while retaining compatibility with the existing PallyPower ecosystem.

## Fork Changes

- Ground up rewrite of the addon, with a familiar look
- 100% backwards compatible
- No hard-coded durations, ranks, values, timer or talents. Dynamic look up as best as can reasonably be done
- BuffBar Changes
  - Fixed Horizontal Layout
  - Fixed fragile timers
  - Selfbuffs can now but collapse into one box and/or moved above the header
  - Left click for Greater Blessings - lesser if you don't have the spells or symbol of kings
  - Right click for Lesser Blessings
  - Added a judgement assignment and tracker, infers durations based on judgement cast and successful autoattacks. Supports dodge/parry refreshing judgements for _certain private server builds_
  ![Updated Buffbar](github-images/pp_buffbar-1-10-8)
- Assignment Changes
  - Most of the "quick" options are now toggle buttons
  - Middle-click to set a player as a tank
  - Advanced controls moved into the old settings window
  - You can assign the same aura to multiple paladins
  - You can assign NOT righteous fury
  - Seal assignment left for historical purposes...
  - Visual Aura and Judgement summaries for ranks and talents
    ![Updated Assignments](github-images/pp_assignments-1-10-8)

## Credits

PallyPowerVanilla builds on many years of PallyPower development.

**Original PallyPower:**  
Sneakyfoot, Aznamir, Gnarf, Blackoz and contributors.

**Vanilla / Turtle WoW development:**  
CosminPOP, Azgaardian, madScripting, ivanovlk, TheRealFayz and other contributors.

**PallyPowerVanilla:**  
Seraphic8x2244

Development of PallyPowerVanilla makes use of AI-assisted coding.
