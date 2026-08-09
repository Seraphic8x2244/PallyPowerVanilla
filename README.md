# PallyPowerVanilla for World of Warcraft 1.12.1

PallyPowerVanilla is a maintenance and compatibility fork of PallyPowerTW for World of Warcraft clients based on the 1.12.1 API.

The project aims to retain the improvements made by PallyPowerTW while removing server-specific assumptions where practical, allowing the addon to work across a broader range of Vanilla 1.12.1 environments.

## Compatibility

PallyPowerVanilla targets World of Warcraft 1.12.1-based clients rather than any specific server.

Where possible, game data is discovered from the client instead of relying on hardcoded values or server-specific talent layouts.

Current compatibility improvements include:

* Dynamic Blessing mana-cost detection from the highest learned spell rank.
* Dynamic normal and Greater Blessing duration detection.
* Dynamic Improved Blessing of Might and Improved Blessing of Wisdom talent detection.
* Independent Might and Wisdom talent detection, supporting both separate Vanilla talents and combined v+ talent implementations.
* Vanilla-safe UnitXP_SP3 detection and SavedVariable handling.

### Optional Client Extensions

PallyPowerVanilla supports several common 1.12.1 client extensions when available:

* [Nampower](https://gitea.com/avitasia/nampower) — enhanced spell and aura functionality.
* [UnitXP_SP3](https://codeberg.org/konaka/UnitXP_SP3) — enhanced range and line-of-sight information.
* **SuperWoW** — enhanced unit and GUID functionality where supported.

These extensions are optional. PallyPowerVanilla is intended to fall back gracefully when they are unavailable.

## Installation

1. Download the repository as a ZIP.
2. Extract it into `World of Warcraft\Interface\AddOns`.
3. Ensure the addon folder is named `PallyPowerVanilla`.

The resulting path should contain:

`Interface\AddOns\PallyPowerVanilla\PallyPowerVanilla.toc`

## Usage

* **Left-click** a Blessing to cast a Greater Blessing.
* **Right-click** to cast a normal Blessing.
* Individual Blessings, Greater Blessings, Auras and Seals can be configured through the assignment interface.
* Players can be marked as tanks from the assignment grid using the middle mouse button.
* Hunter pets share the Warrior class for Greater Blessing purposes. PallyPowerVanilla handles differing Warrior and pet assignments separately.

## Features

* Regular and Greater Blessing management.
* Individual Blessing assignments.
* Aura and Seal assignments.
* Assignment presets, including Auras.
* Automatic assignment-grid adjustment when Paladins join or leave the group.
* Tank assignments and synchronisation between Paladins.
* Raid icon assignment and removal for marked tanks when the player has the appropriate group permissions.
* pfUI tank-assignment integration when pfUI is available.
* Optional pfUI HD icons.
* UnitXP_SP3 range and line-of-sight checking when available.
* Mana checking before casting.
* Righteous Fury tracking on the buff bar.
* Direct Aura and Blessing assignment from the buff bar.
* Horizontal and vertical buff-bar layouts.
* Optional sound notification when Blessings expire.
* Optional hiding of the Blizzard Aura frame.
* Solo buff-frame support.
* Hunter pet support.
* `/pp report` for displaying class, assignment and Aura information.
* Synchronised assignment changes without requiring Party Leader or Raid Assistant privileges.

## Version 1.40

PallyPowerVanilla 1.40 establishes the initial general-purpose 1.12.1 compatibility fork.

Changes from the inherited PallyPowerTW code include:

* Renamed and cleaned the addon for PallyPowerVanilla.
* Removed server-specific hardcoded Blessing mana costs during normal operation.
* Added dynamic Blessing mana-cost detection from the highest learned rank.
* Added dynamic normal and Greater Blessing duration detection.
* Replaced the hardcoded Improved Blessings talent position with independent talent-tooltip detection for Might and Wisdom.
* Removed reliance on the unsupported `PP_AutoEnabledUnitXP` CVar.
* UnitXP_SP3 automatic-enable state is stored using PallyPower SavedVariables.
* Retained the existing PallyPower addon communication protocol for compatibility with other PallyPower users.

Further compatibility work will continue to replace inherited language- or server-specific assumptions where practical.

## Lineage and Credits

PallyPowerVanilla is a fork of PallyPowerTW by TheRealFayz, itself based on the work of earlier PallyPower authors and contributors.

Credit for the original addon, its design and inherited code belongs to their respective authors and contributors.

PallyPowerVanilla is maintained by Seraphic8x2244 as a compatibility and maintenance fork. Development of this fork makes extensive use of AI-assisted coding.
