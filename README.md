# PallyPowerVanilla for World of Warcraft 1.12.1

PallyPowerVanilla is a maintenance and compatibility fork of PallyPowerTW for World of Warcraft clients based on the 1.12.1 API.

The project aims to retain the improvements made by PallyPowerTW while removing server-specific assumptions where practical, allowing the addon to work across a broader range of Vanilla 1.12.1 environments.

## Compatibility

PallyPowerVanilla targets World of Warcraft 1.12.1-based clients rather than any specific server.

Blessing mana costs and durations are determined dynamically from the player's learned spells instead of relying on server-specific hardcoded values. Improved Blessing talent bonuses are detected from the client's talent data rather than assuming a fixed server-specific talent layout.

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
* The Buff Bar header provides quick controls for frame locking, printing assignments to party/raid chat, blessing-expiry sound, and changing Buff Bar orientation.
* The **Advanced** panel contains less frequently used display and scanning options.

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
* Righteous Fury tracking on the Buff Bar.
* Direct Aura and Blessing assignment from the Buff Bar.
* Horizontal and vertical Buff Bar layouts.
* Optional sound notification when Blessings expire.
* Optional hiding of the Blizzard Aura frame.
* Solo buff-frame support.
* Hunter pet support.
* `/pp report` for displaying class, assignment and Aura information.
* Synchronised assignment changes without requiring Party Leader or Raid Assistant privileges.
* Spanish localisation by Nuevemasnueve.

## Version 1.50

PallyPowerVanilla 1.50 is a compatibility and interface update focused on keeping the addon useful across 1.12.1-based clients while making the existing PallyPower controls easier to understand.

### Compatibility and detection

* Blessing mana costs are dynamically determined from the highest learned spell rank.
* Normal and Greater Blessing durations are dynamically determined from learned spell data.
* Improved Blessing of Might and Improved Blessing of Wisdom bonuses are detected from talent information instead of fixed talent-tree positions.
* Might and Wisdom talent detection is independent, supporting both separate Vanilla talents and combined talent implementations used by some 1.12.1-based clients.
* UnitXP_SP3 detection no longer relies on the unsupported `PP_AutoEnabledUnitXP` CVar.
* UnitXP_SP3 state is stored using PallyPower SavedVariables and the enhanced range/line-of-sight checks are enabled when the extension is detected.
* UnitXP_SP3 status and unit-frame scanning controls are shown in Advanced Options.

### Interface

* Reorganised the Buff Bar header with compact icon controls for:
  * locking/unlocking frames;
  * printing current assignments to party/raid chat;
  * blessing-expiry sound;
  * switching between vertical and horizontal layouts.
* Reworked Blessing Management into a more compact XML-defined layout while retaining the existing assignment model.
* Smart Buffs and Free Assignment controls are available directly in Blessing Management.
* The active-Paladin capability area now presents:
  * Lay on Hands and Divine Intervention cooldown tracking;
  * Aura talent information;
  * Blessing ranks and talent improvements;
  * Symbol of Kings count.
* Aura and Seal visibility controls are integrated into their respective assignment headers.
* Less frequently used settings have been moved into **PallyPower - Advanced Options**.
* The assignment-report button is a one-shot action rather than a toggle.
* Buff Bar orientation icons indicate the layout the button will switch to.

### Behaviour preserved

The 1.50 interface work does not replace the underlying PallyPower assignment model or communication protocol. Blessing, Aura and Seal assignments continue to use the inherited PallyPower synchronisation behaviour.

## Known Limitations

PallyPowerVanilla is intended to support a broad range of 1.12.1-based clients, but custom clients and server-specific spell or talent changes can still expose assumptions inherited from older PallyPower versions.

If a compatibility problem is found, please include the client/server environment and any relevant error output when reporting it.

## Lineage and Credits

PallyPowerVanilla is a fork of PallyPowerTW by TheRealFayz, itself based on the work of earlier PallyPower authors and contributors.

Credit for the original addon, its design and inherited code belongs to their respective authors and contributors.

PallyPowerVanilla is maintained by Seraphic8x2244 as a compatibility and maintenance fork. Development of this fork makes extensive use of AI-assisted coding.
