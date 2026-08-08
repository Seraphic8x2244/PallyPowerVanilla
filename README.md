# PallyPowerVanilla for World of Warcraft (1.12.1)
PallyPowerVanilla is a fork of PallyPowerTW focused on compatibility with
World of Warcraft 1.12.1-based clients.

The project aims to retain the improvements made by PallyPowerTW while
removing assumptions tied to any one server where practical.

## Lineage and Credits

PallyPowerVanilla is a fork of PallyPowerTW by TheRealFayz, itself based on
the work of earlier PallyPower authors and contributors.

Credit for the original addon, its design, and inherited code belongs to
their respective authors and contributors.

PallyPowerVanilla is maintained as a compatibility and maintenance fork.
Development of this fork makes extensive use of AI-assisted coding.

## Compatibility

PallyPowerVanilla targets World of Warcraft clients based on the 1.12.1 API.

The goal is broad compatibility rather than targeting a specific private
server.

The addon should degrade gracefully when optional extensions are unavailable.

## Optional Dependencies
[Nampower](https://gitea.com/avitasia/nampower) Provides enhanced spell/aura functionality when available.
[UnitXP_SP3](https://codeberg.org/konaka/UnitXP_SP3) Provides enhanced range and line-of-sight information.
[SuperWoW] Used for enhanced unit/GUID functionality where supported.

## Fork Changes
Blessing duration and mana cost is now done via lookup, rather than hardcoded to support any 1.12.1 client.

## Please note!
> - Use your Left mouse button to do a Greater Blessing!
> - Use your Right mouse button to do Normal (10 min) Blessings!
> - Hunter pets and Warrors share same class so if you use Greater blessings it will affect both Warriors and Pets ( not a bug )
> - Currently "[Patch FR] Turtle WoW en français + Pack de voix française corrigé pour VoiceOver" is not supported. PPTW does not work correctly when this mod is installed

## How to install 
Download the zip file and rename to PallyPowerVanilla

## Additional info -> https://github.com/ivanovlk/PallyPowerTW/wiki/PallyPowerTW-Addon-Wiki

### Whats new:
- Assign/Clear raid icon when player is marked as tank if we are Raid leader/Assist or party leader
- Allow assignments of seals for each paladin. Very usefull for boss fights
- GB is not allowed on pets if pets and warriors has different blessings assigned
- If Warriors and pets have same assignment -> mark both of them as blessed when using GB
- Update tank assignment in pfUI ( if available )
- Allow to mark a player as a tank (and sync) in Assignment grid (middle mouse button click at player name below the class icon)
- When a paladin leaves the party assignment grid is adjusted
- Optional usage of PFUI HD Icons (option can be found in settings. Default use regular icons)
- Make use of UnitXP_SP3 line of sight check (if available) and mana check before cast (mana check still under construction)
- Allow saving Assignment presets like "All Salvation", "All Kings" and so on. Including Auras.
- Fixed nasty memory leak in Assignment grid
- /pp report to display full class/assignment list and aura
- Hide Blizzard aura frame option ( Why ? Bacuse, I like it hidden and use PallyPower for aura management )
- Allow change between horizontal or vertical layout for BuffBar
- Allow others to change your blessings without being Party Leader / Raid Assistant.
- Support for individual blessings
- Support for Auras
- Righteous fury on the buff bar
- Left click for Greater blessings / right click for "small" blessings. 
- If Individual blessings are selected small buffs are applied with Right click
- Don't allow Individual blessings without global blessings. Also do not allow Global and Individual blessings to be the same 
- Change Aura and Blessing assignment direclty via Buff Bar
- Play sound when blessings expire
- Included an option to change between Regular Blessings and Greater Blessings.
- Shows the buff frame when solo
- Included Pet in the buff table
- Show the max rank of each blessing each paladin has available + if they have talents that buff the blessing (specific to v+)
- Show the correct duration to each blessing based on v+ duration
- Added Spanish localization by Nuevemasnueve

### Changelog
- 08.08.26 - Added dynamic lookup in spellbook for blessing cost and duration
- 25.08.25 - If Salvation is assigned, user is tank, and no individual blessings, do not count against nneed ( So the buffbar button stays green even with tank missing Salvation)
- 25.08.25 - Assign/Clear raid icon when player is marked as tank if we are Raid leader/Assist or party leader
- 22.08.25 - Allow assignments of seals for each paladin
- 22.08.25 - Mark as tank reflects to pfUI tank assignment (if available). Don't allow GB on pets if Warriors assignment ~= pets assignment. If Same assignment -> Mark both as GBlessed
- 09.08.25 - Warriors and hunter pets share same class so if they have same blessing assigned and you cast greater blessing PP marks both warriors and pets as blessed in buff bar
- 15.07.25 - Fix: When casting Greater Blessings and several targets are out of range addon assumes they got the buff and does not allow to re-cast GB. 
Now those targets are correctly marked as Need blessing and allow re-cast of GB.
- 15.07.25 - Aura assignment is also saved in Presets 
- 15.07.25 - Allow mark of player as a tank and sync with other paladins
