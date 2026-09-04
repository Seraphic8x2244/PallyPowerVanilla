# PallyPowerVanilla v1.10.19

PallyPowerVanilla is a modernised, compatibility-focused fork of **PallyPower** for World of Warcraft 1.12.1.

The aim is to preserve the familiar PallyPower experience and compatibility with existing versions while improving the addon for modern Vanilla clients and servers.

## Project Goals

- **Modernisation** — improve PallyPower without changing what makes it PallyPower, with a cleaner interface and less reliance on inherited hardcoded behaviour.
- **Compatibility** — support a broad range of World of Warcraft 1.12.1-based clients and servers while retaining compatibility with the existing PallyPower ecosystem.

## Fork Changes

- Major rewrite and modernisation of the original addon while keeping the familiar PallyPower workflow.
- Backwards compatible with existing PallyPower clients and communication.
- Dynamic spell, rank, mana, range and duration handling where practical, with Vanilla-safe fallbacks.
- Improved compatibility with modern Vanilla clients and optional enhancements such as Nampower and UnitXP without requiring them.

### Buff Bar

- Fixed horizontal layout and rebuilt the Buff Bar layout system.
- More reliable Blessing timers, including separate class-wide and individual Blessing tracking.
- Self buffs can be collapsed into one box and/or moved above the header.
- Left click casts Greater Blessings where possible, automatically falling back to normal Blessings when Greater is unavailable or no Symbol of Kings is available.
- Right click casts normal Blessings.
- Compact status tooltips show counts for players who have, need, are out of range, or are dead.
- Added Judgement assignment and tracking, including inferred refreshes from successful attacks.
- Judgement duration is read from the relevant Seal tooltip, allowing client-side talent and item-set modifiers to be respected automatically.
- Optional support for servers where dodges/parries refresh Judgements.

![Updated Buffbar](github-images/pp_buffbar-1-10-8.png)

### Assignment Management

- Most quick options are now toggle buttons.
- Middle-click a player to mark or unmark them as a tank.
- Advanced controls moved into the Advanced Options window.
- Multiple Paladins can be assigned the same Aura.
- Supports explicit **No Righteous Fury** assignments.
- Seal assignment remains available for historical/compatibility purposes.
- Added visual Aura and Judgement capability summaries for ranks and talents.
- Improved handling of large raid rosters and class lists.
- Assignment storage has been consolidated while retaining compatibility with older SavedVariables and PallyPower behaviour.

![Updated Assignments](github-images/pp_assignments-1-10-8.png)

## Compatibility

PallyPowerVanilla is designed for **World of Warcraft 1.12.1-based clients**.

The addon does not require SuperWoW, Nampower or UnitXP. Where supported, optional APIs can be used to improve range, line-of-sight and aura detection while retaining a stock-client fallback.

## Credits

PallyPowerVanilla builds on many years of PallyPower development.

**Original PallyPower:**  
Sneakyfoot, Aznamir, Gnarf, Blackoz and contributors.

**Vanilla / Turtle WoW development:**  
CosminPOP, Azgaardian, madScripting, ivanovlk, TheRealFayz and other contributors.

**PallyPowerVanilla:**  
Seraphic8x2244

Development of PallyPowerVanilla makes use of AI-assisted coding.
