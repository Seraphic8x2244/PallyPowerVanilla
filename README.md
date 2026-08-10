# PallyPowerVanilla

PallyPowerVanilla is a modernised, compatibility-focused fork of
**PallyPower** for World of Warcraft 1.12.1.

The aim is to preserve the familiar PallyPower experience and
compatibility with existing versions while improving the addon for
modern Vanilla clients and servers.

  --------------------------------------------------------------------------
  Buff Bar                            Blessing Management
  ----------------------------------- --------------------------------------
  ![Buff                              ![Blessing
  Bar](github-images/150-1.png)       Management](github-images/150-2.png)

  --------------------------------------------------------------------------

## Project Goals

### Modernisation

Improve PallyPower without changing what makes it PallyPower.

This includes a cleaner, more intuitive interface and replacing
inherited assumptions or hardcoded behaviour where the 1.12.1 client can
provide the information directly.

### Compatibility

Support a broad range of World of Warcraft 1.12.1-based clients and
servers rather than targeting the behaviour of one particular server.

PallyPowerVanilla retains the existing PallyPower assignment and
communication system, allowing it to continue working alongside older
compatible PallyPower versions.

## Fork Changes

-   **Dynamic Blessing data** --- Blessing durations and mana costs are
    determined from the player's learned spells rather than hardcoded
    values.
-   **Dynamic talent detection** --- relevant Paladin talents are
    detected from the client rather than relying on hardcoded talent
    positions.
-   **UI overhaul** --- the Buff Bar, Blessing Management and options
    interfaces have been reorganised to make common controls more visual
    and intuitive.
-   **Optional client enhancements** --- enhanced client functionality
    such as UnitXP_SP3 is used when available without being required.

### UI Overhaul

Common controls are kept close at hand, while less frequently used
settings have been moved into **Advanced Options**.

![Advanced Options](github-images/150-3.png)

## How to Use

PallyPowerVanilla works like PallyPower. Existing PallyPower users
should find the assignment system immediately familiar.

-   **Left-click** a blessing to cast a Greater Blessing.
-   **Right-click** to cast a normal Blessing.
-   **Middle-click** a player in Blessing Management to mark them as a
    tank.
-   Assignments continue to communicate with compatible older versions
    of PallyPower.

## Credits

PallyPowerVanilla builds on many years of PallyPower development.

**Original PallyPower:**\
Sneakyfoot, Aznamir, Gnarf, Blackoz and contributors.

**Vanilla / Turtle WoW development:**\
CosminPOP, Azgaardian, madScripting, ivanovlk, TheRealFayz and other
contributors.

**PallyPowerVanilla:**\
Seraphic8x2244

Development of PallyPowerVanilla makes extensive use of AI-assisted
coding.
