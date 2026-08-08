# PallyPowerVanilla for World of Warcraft 1.12.1

PallyPowerVanilla is a maintenance and compatibility fork of PallyPowerTW for World of Warcraft clients based on the 1.12.1 API.

The project aims to retain the improvements made by PallyPowerTW while removing server-specific assumptions where practical, allowing the addon to work across a broader range of Vanilla 1.12.1 environments.

## Compatibility

PallyPowerVanilla targets World of Warcraft 1.12.1-based clients rather than any specific server.

Blessing mana costs and durations are determined dynamically from the player's learned spells instead of relying on server-specific hardcoded values.

Optional client extensions are detected when available and should not prevent the addon from operating when absent.

### Optional Dependencies

* [Nampower](https://gitea.com/avitasia/nampower) — enhanced spell and aura functionality.
* [UnitXP_SP3](https://codeberg.org/konaka/UnitXP_SP3) — enhanced range and line-of-sight information.
* **SuperWoW** — enhanced unit and GUID functionality where supported.

## Installation

1. Download the repository as a ZIP.
2. Extract it into your `World of Warcraft\Interface\AddOns` directory.
3. Ensure the addon folder is named `PallyPowerVanilla`.

The resulting structure should contain:

`Interface\AddOns\PallyPowerVanilla\PallyPowerVanilla.toc`

## Usage

* **Left-click** a blessing to cast a Greater Blessing.
* **Right-click** to cast a normal Blessing.
* Individual Blessings, Greater Blessings, Auras and Seals can be configured through the assignment interface.
* Players can be marked as tanks from the assignment grid using the middle mouse button.
* Hunter pets share the Warrior class for Greater Blessing purposes. PallyPowerVanilla handles differing Warrior and pet assignments separately.

## Features

* Greater and normal Blessing management.
* Individual Blessing assignments.
* Aura assignments and management.
* Seal assignments for each Paladin.
* Assignment presets, including Auras.
* Automatic assignment-grid adjustment when Paladins join or leave the group.
* Tank assignments and synchronisation between Paladins.
* Raid icon assignment and removal for marked tanks when the player has the appropriate group permissions.
* pfUI tank-assignment integration when pfUI is available.
* Optional pfUI HD icons.
* UnitXP_SP3 line-of-sight and range checking when available.
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
* Spanish localisation by Nuevemasnueve.

## PallyPowerVanilla Changes

### Current Development Version

* Blessing mana costs are dynamically determined from the highest learned spell rank.
* Blessing durations are dynamically determined from learned spell data.
* Removed reliance on the unsupported `PP_AutoEnabledUnitXP` CVar.
* UnitXP automatic-enable state is stored using PallyPower SavedVariables.

Further compatibility work is focused on identifying and removing remaining assumptions specific to individual 1.12.1 server implementations.

## Known Limitations

Some inherited functionality remains specific to v+ environments and is being reviewed for broader 1.12.1 compatibility.

In particular, detection of talents that improve individual Blessings requires further compatibility work.

## Lineage and Credits

PallyPowerVanilla is a fork of PallyPowerTW by TheRealFayz, itself based on the work of earlier PallyPower authors and contributors.

Credit for the original addon, its design and inherited code belongs to their respective authors and contributors.

PallyPowerVanilla is maintained as a compatibility and maintenance fork. Development of this fork makes extensive use of AI-assisted coding.
