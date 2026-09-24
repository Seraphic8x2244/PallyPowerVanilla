# XML UI Parity Manifest

Frozen Stage 1 reference for the `PallyPower.xml` -> `PallyPowerUI.lua` migration. This is a parity contract, not a second development-status document; live project state remains in `DEV_PROGRESS.md`.

- Source branch/head: `dev` / `c0950332d1c6e32c315ae7a44620cb05a53f2010`
- XML blob: `9cc53b2921a3a0749e1fb8f5bd26d29487b9fad2`
- Lua blob used for lookup-contract audit: `c0901bb34370ccc36c217908f9cd91c9444c2425`
- Objects: 281 total / 277 named
- Script handlers: 149
- Custom virtual templates: 9
- Explicit `RegisterForClicks` sites: 8

## Object counts

- Button: 77
- CheckButton: 19
- EditBox: 3
- FontString: 59
- Frame: 39
- Slider: 2
- StatusBar: 1
- Texture: 81

## Custom virtual templates

- `PPResizeGripTemplate` (Button, XML line 5)
- `PPAssignmentCellTemplate` (Button, XML line 20)
- `PPPlayerOverrideTemplate` (Button, XML line 62)
- `PPClassColumnTemplate` (Frame, XML line 113)
- `PPSpecialColumnTemplate` (Frame, XML line 271)
- `PPBuffBarBlessingTemplate` (Button, XML line 292)
- `PPBuffBarSpecialTemplate` (Button, XML line 396)
- `PPBuffBarCombinedSelfTemplate` (Frame, XML line 436)
- `PPPaladinRowTemplate` (Frame, XML line 454)

## Explicit click registration

- XML line 20 `PPAssignmentCellTemplate`: `RegisterForClicks("LeftButtonUp", "RightButtonUp")`
- XML line 62 `PPPlayerOverrideTemplate`: `RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp")`
- XML line 292 `PPBuffBarBlessingTemplate`: `RegisterForClicks("LeftButtonUp", "RightButtonUp")`
- XML line 396 `PPBuffBarSpecialTemplate`: `RegisterForClicks("LeftButtonUp", "RightButtonUp")`
- XML line 443 `$parentAura`: `RegisterForClicks("LeftButtonUp", "RightButtonUp")`
- XML line 444 `$parentRF`: `RegisterForClicks("LeftButtonUp", "RightButtonUp")`
- XML line 450 `$parentSeal`: `RegisterForClicks("LeftButtonUp", "RightButtonUp")`
- XML line 2761 `PallyPowerMinimapButton`: `RegisterForClicks("LeftButtonUp", "RightButtonUp")`

## Dynamic `getglobal()` name contracts

These expressions are frozen for the parity phase. Generated Lua objects must keep resolving the same names until the post-runtime-test naming cleanup stage.

- Lua line 275: `getglobal("PallyPowerSpellScanTooltipTextLeft" .. i)`
- Lua line 276: `getglobal("PallyPowerSpellScanTooltipTextRight" .. i)`
- Lua line 693: `getglobal("PallyPowerFramePlayer" .. pnum .. "Name")`
- Lua line 755: `getglobal("PallyPowerFramePlayer" .. i)`
- Lua line 756: `getglobal("PallyPowerFramePlayer" .. i .. "ClassA")`
- Lua line 757: `getglobal("PallyPowerFramePlayer" .. i .. "ClassJ")`
- Lua line 1884: `getglobal("PallyPowerBuffBarBuff" .. i)`
- Lua line 1887: `getglobal(btn:GetName() .. "Time")`
- Lua line 1888: `getglobal(btn:GetName() .. "Time2")`
- Lua line 2450: `getglobal("PallyPowerFrameClass" .. i)`
- Lua line 2464: `getglobal("PallyPowerFramePlayer" .. i .. "Name")`
- Lua line 2465: `getglobal("PallyPowerFramePlayer" .. i .. "InGroup")`
- Lua line 2470: `getglobal("PallyPowerFramePlayer" .. i .. "IconHOJ")`
- Lua line 2485: `getglobal("PallyPowerFramePlayer" .. i .. "IconLH")`
- Lua line 2500: `getglobal("PallyPowerFramePlayer" .. i .. "IconDI")`
- Lua line 2515: `getglobal("PallyPowerFramePlayer" .. i .. "Symbols")`
- Lua line 2522: `getglobal("PallyPowerFramePlayer" .. i .. "Icon" .. id)`
- Lua line 2523: `getglobal("PallyPowerFramePlayer" .. i .. "Skill" .. id)`
- Lua line 2538: `getglobal("PallyPowerFramePlayer" .. i .. "Class" .. id .. "Icon")`
- Lua line 2546: `getglobal("PallyPowerFramePlayer" .. i .. "ClassAIcon")`
- Lua line 2553: `getglobal("PallyPowerFramePlayer" .. i .. "ClassSIcon")`
- Lua line 2562: `getglobal("PallyPowerFramePlayer" .. i .. "ClassJIcon")`
- Lua line 2578: `getglobal("PallyPowerFramePlayer" .. i .. "ClassR")`
- Lua line 2579: `getglobal("PallyPowerFramePlayer" .. i .. "ClassRIcon")`
- Lua line 2580: `getglobal("PallyPowerFramePlayer" .. i .. "ClassRNoRF")`
- Lua line 2611: `getglobal(pbnt)`
- Lua line 2629: `getglobal(pbnt .. "Text")`
- Lua line 2635: `getglobal(pbnt .. "Icon")`
- Lua line 2662: `getglobal("PallyPowerFrameClassGroup" .. i .. "Line")`
- Lua line 2738: `getglobal(btn:GetName() .. "Text")`
- Lua line 2770: `getglobal(plbtn:GetName() .. "Text")`
- Lua line 2849: `getglobal(btnName .. "Text")`
- Lua line 2871: `getglobal(btn:GetName() .. "ClassIcon")`
- Lua line 2872: `getglobal(btn:GetName() .. "BuffIcon")`
- Lua line 2954: `getglobal("PallyPowerBuffBar" .. kind .. "BuffIcon")`
- Lua line 2955: `getglobal("PallyPowerBuffBarSelfCombined" .. kind .. "BuffIcon")`
- Lua line 2961: `getglobal("PallyPowerBuffBar" .. kind)`
- Lua line 2962: `getglobal("PallyPowerBuffBarSelfCombined" .. kind)`
- Lua line 2977: `getglobal(frame:GetName() .. "Aura")`
- Lua line 2977: `getglobal(frame:GetName() .. "RF")`
- Lua line 2977: `getglobal(frame:GetName() .. "Seal")`
- Lua line 3099: `getglobal("PallyPowerBuffBarBuff"..i)`
- Lua line 3099: `getglobal("PallyPowerBuffBarBuff"..(i-1))`
- Lua line 3230: `getglobal("PallyPowerBuffBarBuff" .. BuffNum .. "ClassIcon")`
- Lua line 3233: `getglobal("PallyPowerBuffBarBuff" .. BuffNum .. "BuffIcon")`
- Lua line 3235: `getglobal("PallyPowerBuffBarBuff" .. BuffNum)`
- Lua line 3238: `getglobal("PallyPowerBuffBarBuff" .. BuffNum .. "Text")`
- Lua line 3239: `getglobal("PallyPowerBuffBarBuff" .. BuffNum .. "Time")`
- Lua line 3240: `getglobal("PallyPowerBuffBarBuff" .. BuffNum .. "Time2")`
- Lua line 3342: `getglobal("PallyPowerBuffBarBuff" .. rest)`
- Lua line 3439: `getglobal("GameTooltipTextLeft" .. line)`
- Lua line 3440: `getglobal("GameTooltipTextRight" .. line)`
- Lua line 5911: `getglobal("PallyPowerBuffBarBuff" .. classbtn)`
- Lua line 6336: `getglobal("PallyPowerBuffBarBuff" .. i .. "Text")`
- Lua line 6849: `getglobal("PALLYPOWER_TEXT_WARNING_" .. type)`

## Object manifest

| XML line | Type | Name | Containing object | Explicit parent | Inherits | Virtual | Layer | Size | Anchors | Backdrop | Other attrs | Region/control details | Scripts |
|---:|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | Button | `PPResizeGripTemplate` | `(Ui root)` |  |  | yes |  | 16x16 |  |  |  | NormalTexture(file=Interface\AddOns\PallyPowerVanilla\artwork\PallyPower-ResizeGrip); HighlightTexture(alphaMode=ADD; file=Interface\AddOns\PallyPowerVanilla\artwork\PallyPower-ResizeGrip) | OnMouseDown, OnMouseUp |
| 20 | Button | `PPAssignmentCellTemplate` | `(Ui root)` |  |  | yes |  | 80x54 |  |  |  |  | OnLoad, OnClick, OnEnter, OnLeave, OnMouseWheel |
| 26 | Texture | `$parentIcon` | `PPAssignmentCellTemplate` |  |  |  | OVERLAY | 32x32 | TOPLEFT->(implicit):(same)@24,-20 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Spell_Holy_SealOfWisdom |  |
| 62 | Button | `PPPlayerOverrideTemplate` | `(Ui root)` |  |  | yes |  | 84x13 |  |  | enableMouse=true; hidden=false |  | OnLoad, OnClick, OnEnter, OnLeave, OnMouseWheel |
| 68 | FontString | `$parentText` | `PPPlayerOverrideTemplate` |  | GameFontHighlightSmall |  | OVERLAY | 78x13 | LEFT->(implicit):(same)@2,0 |  | justifyH=LEFT; text=PlayerButton |  |  |
| 80 | Texture | `$parentIcon` | `PPPlayerOverrideTemplate` |  |  |  | OVERLAY | 12x12 | TOPRIGHT->$parentText:TOPRIGHT@-2,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Spell_Holy_SealOfWisdom |  |
| 113 | Frame | `PPClassColumnTemplate` | `(Ui root)` |  |  | yes |  | 84x26 |  |  | enableMouse=true |  |  |
| 119 | Texture | `$parentLine` | `PPClassColumnTemplate` |  |  |  |  | 2x212 | TOPLEFT->(implicit):(same)@0,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 134 | Button | `$parentPlayerButton1` | `PPClassColumnTemplate` |  | PPPlayerOverrideTemplate |  |  |  | TOPLEFT->(implicit):(same)@3,0 |  |  |  |  |
| 143 | Button | `$parentPlayerButton2` | `PPClassColumnTemplate` |  | PPPlayerOverrideTemplate |  |  |  | TOPLEFT->(implicit):(same)@3,-13 |  |  |  |  |
| 152 | Button | `$parentPlayerButton3` | `PPClassColumnTemplate` |  | PPPlayerOverrideTemplate |  |  |  | TOPLEFT->(implicit):(same)@3,-26 |  |  |  |  |
| 161 | Button | `$parentPlayerButton4` | `PPClassColumnTemplate` |  | PPPlayerOverrideTemplate |  |  |  | TOPLEFT->(implicit):(same)@3,-39 |  |  |  |  |
| 170 | Button | `$parentPlayerButton5` | `PPClassColumnTemplate` |  | PPPlayerOverrideTemplate |  |  |  | TOPLEFT->(implicit):(same)@3,-52 |  |  |  |  |
| 179 | Button | `$parentPlayerButton6` | `PPClassColumnTemplate` |  | PPPlayerOverrideTemplate |  |  |  | TOPLEFT->(implicit):(same)@3,-65 |  |  |  |  |
| 188 | Button | `$parentPlayerButton7` | `PPClassColumnTemplate` |  | PPPlayerOverrideTemplate |  |  |  | TOPLEFT->(implicit):(same)@3,-78 |  |  |  |  |
| 197 | Button | `$parentPlayerButton8` | `PPClassColumnTemplate` |  | PPPlayerOverrideTemplate |  |  |  | TOPLEFT->(implicit):(same)@3,-91 |  |  |  |  |
| 206 | Button | `$parentPlayerButton9` | `PPClassColumnTemplate` |  | PPPlayerOverrideTemplate |  |  |  | TOPLEFT->(implicit):(same)@3,-104 |  |  |  |  |
| 215 | Button | `$parentPlayerButton10` | `PPClassColumnTemplate` |  | PPPlayerOverrideTemplate |  |  |  | TOPLEFT->(implicit):(same)@3,-117 |  |  |  |  |
| 224 | Button | `$parentPlayerButton11` | `PPClassColumnTemplate` |  | PPPlayerOverrideTemplate |  |  |  | TOPLEFT->(implicit):(same)@3,-130 |  |  |  |  |
| 233 | Button | `$parentPlayerButton12` | `PPClassColumnTemplate` |  | PPPlayerOverrideTemplate |  |  |  | TOPLEFT->(implicit):(same)@3,-143 |  |  |  |  |
| 242 | Button | `$parentPlayerButton13` | `PPClassColumnTemplate` |  | PPPlayerOverrideTemplate |  |  |  | TOPLEFT->(implicit):(same)@3,-156 |  |  |  |  |
| 251 | Button | `$parentPlayerButton14` | `PPClassColumnTemplate` |  | PPPlayerOverrideTemplate |  |  |  | TOPLEFT->(implicit):(same)@3,-169 |  |  |  |  |
| 260 | Button | `$parentPlayerButton15` | `PPClassColumnTemplate` |  | PPPlayerOverrideTemplate |  |  |  | TOPLEFT->(implicit):(same)@3,-182 |  |  |  |  |
| 271 | Frame | `PPSpecialColumnTemplate` | `(Ui root)` |  |  | yes |  | 84x26 |  |  |  |  |  |
| 277 | Texture | `$parentLine` | `PPSpecialColumnTemplate` |  |  |  |  | 2x212 | TOPLEFT->(implicit):(same)@0,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 292 | Button | `PPBuffBarBlessingTemplate` | `(Ui root)` |  |  | yes |  | 90x30 |  | bgFile=Interface\Tooltips\UI-Tooltip-Background; edgeFile=Interface\Tooltips\UI-Tooltip-Border; tile=true; tileSize=8; edgeSize=8; insets=bottom=2; left=2; right=2; top=3 |  |  | OnLoad, OnClick, OnEnter, OnLeave, OnMouseWheel |
| 309 | FontString | `$parentTime` | `PPBuffBarBlessingTemplate` |  | GameFontHighlightSmall |  | OVERLAY | 28x10 | TOPRIGHT->(implicit):(same)@-5,-2 |  | justifyH=RIGHT; text=10:00 | fontHeight=11 |  |
| 324 | FontString | `$parentTime2` | `PPBuffBarBlessingTemplate` |  | GameFontNormalSmall |  | OVERLAY | 28x10 | BOTTOMRIGHT->(implicit):(same)@-5,1 |  | justifyH=RIGHT; text=10:00 | fontHeight=11 |  |
| 339 | FontString | `$parentText` | `PPBuffBarBlessingTemplate` |  | GameFontHighlightSmall |  | OVERLAY | 28x10 | BOTTOMRIGHT->(implicit):(same)@-2,1 |  | justifyH=RIGHT; text=99 |  |  |
| 351 | Texture | `$parentClassIcon` | `PPBuffBarBlessingTemplate` |  |  |  | OVERLAY | 24x24 | LEFT->(implicit):(same)@3,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Paladin |  |
| 363 | Texture | `$parentBuffIcon` | `PPBuffBarBlessingTemplate` |  |  |  | OVERLAY | 24x24 | LEFT->(implicit):(same)@33,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Spell_Holy_SealOfWisdom |  |
| 396 | Button | `PPBuffBarSpecialTemplate` | `(Ui root)` |  |  | yes |  | 90x30 |  | bgFile=Interface\Tooltips\UI-Tooltip-Background; edgeFile=Interface\Tooltips\UI-Tooltip-Border; tile=true; tileSize=8; edgeSize=8; insets=bottom=2; left=2; right=2; top=3 |  |  | OnLoad, OnClick, OnMouseWheel |
| 413 | Texture | `$parentBuffIcon` | `PPBuffBarSpecialTemplate` |  |  |  | OVERLAY | 24x24 | CENTER->(implicit):(same)@0,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Spell_Holy_SealOfFury |  |
| 436 | Frame | `PPBuffBarCombinedSelfTemplate` | `(Ui root)` |  |  | yes |  | 90x30 |  | bgFile=Interface\Tooltips\UI-Tooltip-Background; edgeFile=Interface\Tooltips\UI-Tooltip-Border; tile=true; tileSize=8; edgeSize=8; insets=bottom=2; left=2; right=2; top=3 |  |  |  |
| 443 | Button | `$parentAura` | `PPBuffBarCombinedSelfTemplate` |  |  |  |  | 28x26 | LEFT->(implicit):(same)@1,0 | bgFile=Interface\Tooltips\UI-Tooltip-Background; insets=bottom=0; left=0; right=0; top=0 |  |  | OnLoad, OnClick |
| 443 | Texture | `$parentBuffIcon` | `$parentAura` |  |  |  | OVERLAY | 22x22 | CENTER->(implicit):(same)@0,0 |  |  | file=Interface\Icons\Spell_Holy_DevotionAura |  |
| 444 | Button | `$parentRF` | `PPBuffBarCombinedSelfTemplate` |  |  |  |  | 28x26 | LEFT->(implicit):(same)@31,0 | bgFile=Interface\Tooltips\UI-Tooltip-Background; insets=bottom=0; left=0; right=0; top=0 |  |  | OnLoad, OnClick |
| 444 | Texture | `$parentBuffIcon` | `$parentRF` |  |  |  | OVERLAY | 22x22 | CENTER->(implicit):(same)@0,0 |  |  | file=Interface\Icons\Spell_Holy_SealOfFury |  |
| 444 | FontString | `$parentNoRF` | `$parentRF` |  | GameFontNormalLarge |  | OVERLAY | 24x24 | CENTER->$parentBuffIcon:CENTER@0,0 |  | hidden=true; justifyH=CENTER; justifyV=MIDDLE; outline=THICK; text=X | color=b=0; g=0; r=1; fontHeight=20 |  |
| 450 | Button | `$parentSeal` | `PPBuffBarCombinedSelfTemplate` |  |  |  |  | 28x26 | LEFT->(implicit):(same)@61,0 | bgFile=Interface\Tooltips\UI-Tooltip-Background; insets=bottom=0; left=0; right=0; top=0 |  |  | OnLoad, OnClick |
| 450 | Texture | `$parentBuffIcon` | `$parentSeal` |  |  |  | OVERLAY | 22x22 | CENTER->(implicit):(same)@0,0 |  |  | file=Interface\Icons\Spell_Holy_SealOfWisdom |  |
| 454 | Frame | `PPPaladinRowTemplate` | `(Ui root)` |  |  | yes |  | 1288x76 |  |  |  |  |  |
| 461 | FontString | `$parentName` | `PPPaladinRowTemplate` |  | GameFontNormalLarge |  | OVERLAY | 92x20 | TOPLEFT->(implicit):(same)@4,-3 |  | justifyH=LEFT; text=SomePally$parent |  |  |
| 465 | FontString | `$parentSymbols` | `PPPaladinRowTemplate` |  | GameFontHighlightSmall |  | OVERLAY | 24x16 | TOPLEFT->(implicit):(same)@82,-27 |  | justifyH=RIGHT; text=999 |  |  |
| 469 | Texture | `$parentSymbolIcon` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 16x16 | TOPLEFT->(implicit):(same)@107,-27 |  |  | file=Interface\Icons\INV_Misc_SymbolofKings_01 |  |
| 473 | Texture | `$parentIcon0` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 16x16 | TOPLEFT->(implicit):(same)@4,-52 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Spell_Holy_SealOfWisdom |  |
| 485 | Texture | `$parentIcon1` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 16x16 | TOPLEFT->(implicit):(same)@24,-52 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Spell_Holy_FistOfJustice |  |
| 497 | Texture | `$parentIcon2` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 16x16 | TOPLEFT->(implicit):(same)@44,-52 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Spell_Holy_SealOfSalvation |  |
| 509 | Texture | `$parentIcon3` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 16x16 | TOPLEFT->(implicit):(same)@64,-52 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Spell_Holy_PrayerOfHealing02 |  |
| 521 | Texture | `$parentIcon4` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 16x16 | TOPLEFT->(implicit):(same)@84,-52 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Spell_Magic_MageArmor |  |
| 533 | Texture | `$parentIcon5` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 16x16 | TOPLEFT->(implicit):(same)@104,-52 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Spell_Nature_LightningShield |  |
| 545 | Texture | `$parentLine` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 1x2 | TOPLEFT->(implicit):(same)@0,2; TOPRIGHT->(implicit):(same)@-12,2 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 552 | Texture | `$parentLineA` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 2x76 | TOPLEFT->(implicit):(same)@127,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 564 | Texture | `$parentLine2` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 2x76 | TOPLEFT->$parentLineA:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 576 | Texture | `$parentLineJ` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 2x76 | TOPLEFT->$parentLine2:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 580 | Texture | `$parentLine3` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 2x76 | TOPLEFT->$parentLineJ:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 592 | Texture | `$parentLine4` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 2x76 | TOPLEFT->$parentLine3:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 604 | Texture | `$parentLine5` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 2x76 | TOPLEFT->$parentLine4:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 616 | Texture | `$parentLine6` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 2x76 | TOPLEFT->$parentLine5:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 628 | Texture | `$parentLine7` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 2x76 | TOPLEFT->$parentLine6:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 640 | Texture | `$parentLine8` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 2x76 | TOPLEFT->$parentLine7:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 652 | Texture | `$parentLine9` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 2x76 | TOPLEFT->$parentLine8:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 664 | Texture | `$parentLine10` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 2x76 | TOPLEFT->$parentLine9:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 676 | Texture | `$parentLine11` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 2x76 | TOPLEFT->$parentLine10:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 688 | Texture | `$parentLine12` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 2x76 | TOPLEFT->$parentLine11:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 700 | Texture | `$parentLine13` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 2x76 | TOPLEFT->$parentLine12:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 712 | FontString | `$parentSkill0` | `PPPaladinRowTemplate` |  | GameFontNormalSmall |  | OVERLAY | 26x16 | CENTER->$parentIcon0:CENTER@0,0 |  | justifyH=CENTER; justifyV=MIDDLE; outline=THICK; text= | color=b=1; g=1; r=1 |  |
| 717 | FontString | `$parentSkill1` | `PPPaladinRowTemplate` |  | GameFontNormalSmall |  | OVERLAY | 26x16 | CENTER->$parentIcon1:CENTER@0,0 |  | justifyH=CENTER; justifyV=MIDDLE; outline=THICK; text= | color=b=1; g=1; r=1 |  |
| 722 | FontString | `$parentSkill2` | `PPPaladinRowTemplate` |  | GameFontNormalSmall |  | OVERLAY | 26x16 | CENTER->$parentIcon2:CENTER@0,0 |  | justifyH=CENTER; justifyV=MIDDLE; outline=THICK; text= | color=b=1; g=1; r=1 |  |
| 727 | FontString | `$parentSkill3` | `PPPaladinRowTemplate` |  | GameFontNormalSmall |  | OVERLAY | 26x16 | CENTER->$parentIcon3:CENTER@0,0 |  | justifyH=CENTER; justifyV=MIDDLE; outline=THICK; text= | color=b=1; g=1; r=1 |  |
| 732 | FontString | `$parentSkill4` | `PPPaladinRowTemplate` |  | GameFontNormalSmall |  | OVERLAY | 26x16 | CENTER->$parentIcon4:CENTER@0,0 |  | justifyH=CENTER; justifyV=MIDDLE; outline=THICK; text= | color=b=1; g=1; r=1 |  |
| 737 | FontString | `$parentSkill5` | `PPPaladinRowTemplate` |  | GameFontNormalSmall |  | OVERLAY | 26x16 | CENTER->$parentIcon5:CENTER@0,0 |  | justifyH=CENTER; justifyV=MIDDLE; outline=THICK; text= | color=b=1; g=1; r=1 |  |
| 742 | FontString | `$parentInGroup` | `PPPaladinRowTemplate` |  | GameFontNormalSmall |  | OVERLAY | 20x14 | TOPLEFT->(implicit):(same)@103,-4 |  | justifyH=RIGHT; text= |  |  |
| 746 | Texture | `$parentIconHOJ` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 16x16 | TOPLEFT->(implicit):(same)@4,-27 |  |  | file=Interface\Icons\Spell_Holy_SealOfMight |  |
| 750 | Texture | `$parentIconLH` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 16x16 | TOPLEFT->(implicit):(same)@24,-27 |  |  | file=Interface\Icons\Spell_Holy_LayOnHands |  |
| 754 | Texture | `$parentIconDI` | `PPPaladinRowTemplate` |  |  |  | OVERLAY | 16x16 | TOPLEFT->(implicit):(same)@44,-27 |  |  | file=Interface\Icons\Spell_Nature_TimeStop |  |
| 762 | Button | `$parentBlessingHover` | `PPPaladinRowTemplate` |  |  |  |  | 124x20 | TOPLEFT->(implicit):(same)@2,-48 |  | enableMouse=true |  | OnEnter, OnLeave |
| 775 | Button | `$parentClassA` | `PPPaladinRowTemplate` |  | PPAssignmentCellTemplate |  |  |  | TOPLEFT->(implicit):(same)@129,-10 |  |  |  | OnEnter, OnLeave |
| 792 | Button | `$parentClassR` | `PPPaladinRowTemplate` |  | PPAssignmentCellTemplate |  |  |  | TOPLEFT->$parentClassA:TOPLEFT@82,0 |  |  |  |  |
| 800 | FontString | `$parentNoRF` | `$parentClassR` |  | GameFontNormalLarge |  | OVERLAY | 24x24 | CENTER->$parentIcon:CENTER@0,0 |  | hidden=true; justifyH=CENTER; justifyV=MIDDLE; outline=THICK; text=X | color=b=0; g=0; r=1; fontHeight=20 |  |
| 809 | Button | `$parentClassS` | `PPPaladinRowTemplate` |  | PPAssignmentCellTemplate |  |  |  | TOPLEFT->$parentClassA:TOPLEFT@164,0 |  |  |  | OnEnter, OnLeave |
| 824 | Button | `$parentClassJ` | `PPPaladinRowTemplate` |  | PPAssignmentCellTemplate |  |  |  | TOPLEFT->$parentClassA:TOPLEFT@246,0 |  |  |  | OnEnter, OnLeave |
| 839 | Button | `$parentClass0` | `PPPaladinRowTemplate` |  | PPAssignmentCellTemplate |  |  |  | TOPLEFT->$parentClassA:TOPLEFT@328,0 |  |  |  |  |
| 846 | Button | `$parentClass1` | `PPPaladinRowTemplate` |  | PPAssignmentCellTemplate |  |  |  | TOPLEFT->$parentClass0:TOPRIGHT@2,0 |  |  |  |  |
| 855 | Button | `$parentClass2` | `PPPaladinRowTemplate` |  | PPAssignmentCellTemplate |  |  |  | TOPLEFT->$parentClass1:TOPRIGHT@2,0 |  |  |  |  |
| 864 | Button | `$parentClass3` | `PPPaladinRowTemplate` |  | PPAssignmentCellTemplate |  |  |  | TOPLEFT->$parentClass2:TOPRIGHT@2,0 |  |  |  |  |
| 873 | Button | `$parentClass4` | `PPPaladinRowTemplate` |  | PPAssignmentCellTemplate |  |  |  | TOPLEFT->$parentClass3:TOPRIGHT@2,0 |  |  |  |  |
| 882 | Button | `$parentClass5` | `PPPaladinRowTemplate` |  | PPAssignmentCellTemplate |  |  |  | TOPLEFT->$parentClass4:TOPRIGHT@2,0 |  |  |  |  |
| 891 | Button | `$parentClass6` | `PPPaladinRowTemplate` |  | PPAssignmentCellTemplate |  |  |  | TOPLEFT->$parentClass5:TOPRIGHT@2,0 |  |  |  |  |
| 900 | Button | `$parentClass7` | `PPPaladinRowTemplate` |  | PPAssignmentCellTemplate |  |  |  | TOPLEFT->$parentClass6:TOPRIGHT@2,0 |  |  |  |  |
| 909 | Button | `$parentClass8` | `PPPaladinRowTemplate` |  | PPAssignmentCellTemplate |  |  |  | TOPLEFT->$parentClass7:TOPRIGHT@2,0 |  |  |  |  |
| 918 | Button | `$parentClass9` | `PPPaladinRowTemplate` |  | PPAssignmentCellTemplate |  |  |  | TOPLEFT->$parentClass8:TOPRIGHT@2,0 |  |  |  |  |
| 933 | Frame | `PallyPowerBuffBar` | `(Ui root)` | UIParent |  |  |  | 90x390 | LEFT->(implicit):(same)@0,0 |  | enableMouse=true; frameStrata=LOW; movable=true; toplevel=true |  | OnUpdate |
| 941 | Button | `$parentTitle` | `PallyPowerBuffBar` |  |  |  |  | 300x16 | TOPLEFT->(implicit):(same)@0,0 | bgFile=Interface\Tooltips\UI-Tooltip-Background; edgeFile=Interface\Tooltips\UI-Tooltip-Border; tile=true; tileSize=8; edgeSize=8; insets=bottom=2; left=2; right=2; top=3 |  |  | OnEnter, OnLeave, OnMouseDown, OnMouseUp |
| 959 | FontString | `$parentText` | `$parentTitle` |  | GameFontNormal |  | OVERLAY | 86x18 | CENTER->(implicit):(same)@0,0 |  | justifyH=CENTER; text=PALLYPOWER_UI_TITLE | fontHeight=14 |  |
| 996 | Button | `$parentRF` | `PallyPowerBuffBar` |  | PPBuffBarSpecialTemplate |  |  |  | TOPLEFT->$parentAura:BOTTOMLEFT@0,0 |  |  |  |  |
| 1002 | FontString | `$parentNoRF` | `$parentRF` |  | GameFontNormalLarge |  | OVERLAY | 24x24 | CENTER->$parentBuffIcon:CENTER@0,0 |  | hidden=true; justifyH=CENTER; justifyV=MIDDLE; outline=THICK; text=X | color=b=0; g=0; r=1; fontHeight=20 |  |
| 1011 | Button | `$parentAura` | `PallyPowerBuffBar` |  | PPBuffBarSpecialTemplate |  |  |  | TOPLEFT->$parentTitle:BOTTOMLEFT@0,0 |  |  |  |  |
| 1016 | Button | `$parentSeal` | `PallyPowerBuffBar` |  | PPBuffBarSpecialTemplate |  |  |  | TOPLEFT->$parentAura:BOTTOMLEFT@0,0 |  |  |  |  |
| 1022 | Frame | `$parentSelfCombined` | `PallyPowerBuffBar` |  | PPBuffBarCombinedSelfTemplate |  |  |  | TOPLEFT->$parentTitle:BOTTOMLEFT@0,0 |  | hidden=true |  |  |
| 1025 | Button | `$parentJudgement` | `PallyPowerBuffBar` |  | PPBuffBarSpecialTemplate |  |  |  | TOPLEFT->$parentSeal:BOTTOMLEFT@0,0 |  | hidden=true |  | OnClick, OnEnter, OnLeave |
| 1029 | FontString | `$parentTime` | `$parentJudgement` |  | GameFontHighlightSmall |  | OVERLAY | 50x15 | TOPRIGHT->(implicit):(same)@-6,-4 |  | justifyH=CENTER; justifyV=MIDDLE; text= | fontHeight=11 |  |
| 1034 | FontString | `$parentDebug` | `$parentJudgement` |  | GameFontNormalSmall |  | OVERLAY | 78x12 | LEFT->$parent:RIGHT@4,0 |  | justifyH=LEFT; text= | color=b=1; g=1; r=1 |  |
| 1042 | StatusBar | `$parentDurationBar` | `$parentJudgement` |  |  |  |  | 62x4 | BOTTOMRIGHT->(implicit):(same)@2,5 |  | defaultValue=0; maxValue=1; minValue=0 | BarTexture(file=Interface\\TargetingFrame\\UI-StatusBar); BarColor(b=1; g=1; r=1) |  |
| 1053 | Button | `$parentBuff1` | `PallyPowerBuffBar` |  | PPBuffBarBlessingTemplate |  |  |  | TOPLEFT->$parentTitle:BOTTOMLEFT@0,0 |  |  |  |  |
| 1058 | Button | `$parentBuff2` | `PallyPowerBuffBar` |  | PPBuffBarBlessingTemplate |  |  |  | TOPLEFT->$parentBuff1:BOTTOMLEFT@0,0 |  |  |  |  |
| 1061 | Button | `$parentBuff3` | `PallyPowerBuffBar` |  | PPBuffBarBlessingTemplate |  |  |  | TOPLEFT->$parentBuff2:BOTTOMLEFT@0,0 |  |  |  |  |
| 1064 | Button | `$parentBuff4` | `PallyPowerBuffBar` |  | PPBuffBarBlessingTemplate |  |  |  | TOPLEFT->$parentBuff3:BOTTOMLEFT@0,0 |  |  |  |  |
| 1067 | Button | `$parentBuff5` | `PallyPowerBuffBar` |  | PPBuffBarBlessingTemplate |  |  |  | TOPLEFT->$parentBuff4:BOTTOMLEFT@0,0 |  |  |  |  |
| 1070 | Button | `$parentBuff6` | `PallyPowerBuffBar` |  | PPBuffBarBlessingTemplate |  |  |  | TOPLEFT->$parentBuff5:BOTTOMLEFT@0,0 |  |  |  |  |
| 1073 | Button | `$parentBuff7` | `PallyPowerBuffBar` |  | PPBuffBarBlessingTemplate |  |  |  | TOPLEFT->$parentBuff6:BOTTOMLEFT@0,0 |  |  |  |  |
| 1076 | Button | `$parentBuff8` | `PallyPowerBuffBar` |  | PPBuffBarBlessingTemplate |  |  |  | TOPLEFT->$parentBuff7:BOTTOMLEFT@0,0 |  |  |  |  |
| 1079 | Button | `$parentBuff9` | `PallyPowerBuffBar` |  | PPBuffBarBlessingTemplate |  |  |  | TOPLEFT->$parentBuff8:BOTTOMLEFT@0,0 |  |  |  |  |
| 1082 | Button | `$parentBuff10` | `PallyPowerBuffBar` |  | PPBuffBarBlessingTemplate |  |  |  | TOPLEFT->$parentBuff9:BOTTOMLEFT@0,0 |  |  |  |  |
| 1085 | Button | `$parentResizeButton` | `PallyPowerBuffBar` |  | PPResizeGripTemplate |  |  |  | BOTTOMRIGHT->(implicit):(same)@1,-1 |  |  |  |  |
| 1102 | Frame | `PallyPowerFrame` | `(Ui root)` | UIParent |  |  |  | 1292x980 | TOPLEFT->UIParent:BOTTOMLEFT@400,400 | bgFile=Interface\Tooltips\UI-Tooltip-Background; edgeFile=Interface\Tooltips\UI-Tooltip-Border; tile=true; tileSize=16; edgeSize=16; insets=bottom=5; left=5; right=5; top=5 | enableMouse=true; hidden=true; movable=true; toplevel=true |  | OnLoad, OnEvent, OnMouseUp, OnMouseDown, OnHide |
| 1126 | Texture | `$parentHeaderSeparator` | `PallyPowerFrame` |  |  |  |  | 1x2 | TOPLEFT->(implicit):(same)@7,-28; TOPRIGHT->(implicit):(same)@-7,-28 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1133 | Texture | `$parentFooterSeparator` | `PallyPowerFrame` |  |  |  |  | 1x2 | BOTTOMLEFT->(implicit):(same)@7,28; BOTTOMRIGHT->(implicit):(same)@-7,28 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1140 | Texture | `$parentLineA` | `PallyPowerFrame` |  |  |  |  | 2x56 | TOPLEFT->(implicit):(same)@135,-30 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1144 | Texture | `$parentLineR` | `PallyPowerFrame` |  |  |  |  | 2x56 | TOPLEFT->$parentLineA:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1148 | Texture | `$parentLineS` | `PallyPowerFrame` |  |  |  |  | 2x56 | TOPLEFT->$parentLineR:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1152 | Texture | `$parentLineJ` | `PallyPowerFrame` |  |  |  |  | 2x56 | TOPLEFT->$parentLineS:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1156 | Texture | `$parentLine2` | `PallyPowerFrame` |  |  |  |  | 2x56 | TOPLEFT->$parentLineJ:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1160 | Texture | `$parentLine3` | `PallyPowerFrame` |  |  |  |  | 2x56 | TOPLEFT->$parentLine2:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1172 | Texture | `$parentLine4` | `PallyPowerFrame` |  |  |  |  | 2x56 | TOPLEFT->$parentLine3:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1184 | Texture | `$parentLine5` | `PallyPowerFrame` |  |  |  |  | 2x56 | TOPLEFT->$parentLine4:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1196 | Texture | `$parentLine6` | `PallyPowerFrame` |  |  |  |  | 2x56 | TOPLEFT->$parentLine5:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1208 | Texture | `$parentLine7` | `PallyPowerFrame` |  |  |  |  | 2x56 | TOPLEFT->$parentLine6:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1220 | Texture | `$parentLine8` | `PallyPowerFrame` |  |  |  |  | 2x56 | TOPLEFT->$parentLine7:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1232 | Texture | `$parentLine9` | `PallyPowerFrame` |  |  |  |  | 2x56 | TOPLEFT->$parentLine8:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1244 | Texture | `$parentLine10` | `PallyPowerFrame` |  |  |  |  | 2x56 | TOPLEFT->$parentLine9:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1256 | Texture | `$parentLine11` | `PallyPowerFrame` |  |  |  |  | 2x56 | TOPLEFT->$parentLine10:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1268 | Texture | `$parentLine12` | `PallyPowerFrame` |  |  |  |  | 2x56 | TOPLEFT->$parentLine11:(same)@82,0 |  |  | file=Interface\Tooltips\UI-Tooltip-Background |  |
| 1280 | Texture | `$parentClassA` | `PallyPowerFrame` |  |  |  |  | 32x32 | TOPLEFT->$parentLineA:(same)@26,-12 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Spell_Holy_AuraMastery |  |
| 1292 | Texture | `$parentClassS` | `PallyPowerFrame` |  |  |  |  | 32x32 | TOPLEFT->$parentLineS:(same)@26,-12 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Ability_Thunderbolt |  |
| 1304 | Texture | `$parentClassJ` | `PallyPowerFrame` |  |  |  |  | 32x32 | TOPLEFT->$parentLineJ:(same)@26,-12 |  |  | file=Interface\Icons\Spell_Holy_RighteousFury |  |
| 1308 | Texture | `$parentClassR` | `PallyPowerFrame` |  |  |  |  | 32x32 | TOPLEFT->$parentLineR:(same)@26,-12 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Spell_Holy_SealOfFury |  |
| 1320 | Texture | `$parentClass0` | `PallyPowerFrame` |  |  |  |  | 32x32 | TOPLEFT->$parentLine2:(same)@26,-12 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Warrior |  |
| 1332 | Texture | `$parentClass1` | `PallyPowerFrame` |  |  |  |  | 32x32 | TOPLEFT->$parentClass0:(same)@82,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Rogue |  |
| 1344 | Texture | `$parentClass2` | `PallyPowerFrame` |  |  |  |  | 32x32 | TOPLEFT->$parentClass1:(same)@82,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Priest |  |
| 1356 | Texture | `$parentClass3` | `PallyPowerFrame` |  |  |  |  | 32x32 | TOPLEFT->$parentClass2:(same)@82,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Druid |  |
| 1368 | Texture | `$parentClass4` | `PallyPowerFrame` |  |  |  |  | 32x32 | TOPLEFT->$parentClass3:(same)@82,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Paladin |  |
| 1380 | Texture | `$parentClass5` | `PallyPowerFrame` |  |  |  |  | 32x32 | TOPLEFT->$parentClass4:(same)@82,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Hunter |  |
| 1392 | Texture | `$parentClass6` | `PallyPowerFrame` |  |  |  |  | 32x32 | TOPLEFT->$parentClass5:(same)@82,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Mage |  |
| 1404 | Texture | `$parentClass7` | `PallyPowerFrame` |  |  |  |  | 32x32 | TOPLEFT->$parentClass6:(same)@82,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Warlock |  |
| 1416 | Texture | `$parentClass8` | `PallyPowerFrame` |  |  |  |  | 32x32 | TOPLEFT->$parentClass7:(same)@82,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Shaman |  |
| 1428 | Texture | `$parentClass9` | `PallyPowerFrame` |  |  |  |  | 32x32 | TOPLEFT->$parentClass8:(same)@82,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Pet |  |
| 1443 | Button | `$parentAuraEye` | `PallyPowerFrame` |  |  |  |  | 18x18 | BOTTOMRIGHT->$parentClassA:BOTTOMRIGHT@1,-1 |  |  |  | OnClick, OnEnter, OnLeave |
| 1446 | Texture | `$parentIcon` | `$parentAuraEye` |  |  |  | ARTWORK | 18x18 | CENTER->(implicit):(same)@0,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\UI\Visibility-On |  |
| 1449 | Button | `$parentRFEye` | `PallyPowerFrame` |  |  |  |  | 18x18 | BOTTOMRIGHT->$parentClassR:BOTTOMRIGHT@1,-1 |  |  |  | OnClick, OnEnter, OnLeave |
| 1452 | Texture | `$parentIcon` | `$parentRFEye` |  |  |  | ARTWORK | 18x18 | CENTER->(implicit):(same)@0,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\UI\Visibility-On |  |
| 1455 | Button | `$parentSealEye` | `PallyPowerFrame` |  |  |  |  | 18x18 | BOTTOMRIGHT->$parentClassS:BOTTOMRIGHT@1,-1 |  |  |  | OnClick, OnEnter, OnLeave |
| 1458 | Texture | `$parentIcon` | `$parentSealEye` |  |  |  | ARTWORK | 18x18 | CENTER->(implicit):(same)@0,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\UI\Visibility-On |  |
| 1461 | Button | `$parentJudgementEye` | `PallyPowerFrame` |  |  |  |  | 18x18 | BOTTOMRIGHT->$parentClassJ:BOTTOMRIGHT@1,-1 |  |  |  | OnClick, OnEnter, OnLeave |
| 1464 | Texture | `$parentIcon` | `$parentJudgementEye` |  |  |  | ARTWORK | 18x18 | CENTER->(implicit):(same)@0,0 |  |  | file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\UI\Visibility-On |  |
| 1467 | Button | `$parentTitle` | `PallyPowerFrame` |  |  |  |  | 640x20 | TOPLEFT->(implicit):(same)@8,-7 |  |  |  | OnEnter, OnLeave, OnMouseDown, OnMouseUp, OnUpdate |
| 1480 | FontString | `$parentText` | `$parentTitle` |  | GameFontNormalLarge |  | OVERLAY | 420x18 | LEFT->(implicit):(same)@8,0 |  | justifyH=LEFT; text=PALLYPOWER_UI_ASSIGNMENTS_TITLE |  |  |
| 1512 | Button | `$parentCloseButton` | `PallyPowerFrame` |  |  |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-6,-6 |  |  | NormalTexture(file=Interface\AddOns\PallyPowerVanilla\artwork\close.tga); HighlightTexture(alphaMode=ADD; file=Interface\Buttons\ButtonHilight-Square) | OnClick |
| 1532 | CheckButton | `FreeAssignOptionChk` | `PallyPowerFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | BOTTOMRIGHT->(implicit):(same)@-104,6 |  |  |  | OnShow, OnClick, OnEnter, OnLeave |
| 1543 | FontString | `PallyPowerFrameTitleFreeAssignText` | `FreeAssignOptionChk` |  | GameFontHighlightSmall |  | OVERLAY | 92x16 | LEFT->FreeAssignOptionChk:RIGHT@2,0 |  | justifyH=LEFT; text=PALLYPOWER_FREEASSIGN |  |  |
| 1574 | CheckButton | `PP_UI_SmartButton` | `PallyPowerFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | BOTTOMRIGHT->FreeAssignOptionChk:BOTTOMLEFT@-118,0 |  |  |  | OnShow, OnClick |
| 1585 | FontString | `PP_UI_SmartLabel` | `PP_UI_SmartButton` |  | GameFontHighlightSmall |  | OVERLAY | 75x16 | LEFT->PP_UI_SmartButton:RIGHT@2,0 |  | justifyH=LEFT; text=PALLYPOWER_OPTIONS_SMARTBUFFS |  |  |
| 1608 | Button | `$parentRefresh` | `PallyPowerFrame` |  |  |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-29,-6 |  |  | NormalTexture(file=Interface\AddOns\PallyPowerVanilla\artwork\rotate.tga); HighlightTexture(alphaMode=ADD; file=Interface\Buttons\ButtonHilight-Square) | OnClick |
| 1628 | Button | `$parentResizeButton` | `PallyPowerFrame` |  | PPResizeGripTemplate |  |  |  | BOTTOMRIGHT->(implicit):(same)@1,-1 |  |  |  |  |
| 1637 | Button | `$parentClear` | `PallyPowerFrame` |  |  |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-52,-6 |  |  | NormalTexture(file=Interface\AddOns\PallyPowerVanilla\artwork\bin.tga); HighlightTexture(alphaMode=ADD; file=Interface\Buttons\ButtonHilight-Square) | OnClick |
| 1657 | Button | `$parentOptions` | `PallyPowerFrame` |  |  |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-75,-6 |  |  | NormalTexture(file=Interface\AddOns\PallyPowerVanilla\artwork\config.tga); HighlightTexture(alphaMode=ADD; file=Interface\Buttons\ButtonHilight-Square) | OnClick |
| 1677 | Button | `$parentResetPosition` | `PallyPowerFrame` |  |  |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-98,-6 |  |  | NormalTexture(file=Interface\AddOns\PallyPowerVanilla\artwork\position.tga); HighlightTexture(alphaMode=ADD; file=Interface\Buttons\ButtonHilight-Square) | OnClick |
| 1709 | Button | `PP_UI_LockButton` | `PallyPowerFrame` |  |  |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-213,-6 |  |  | NormalTexture(file=Interface\AddOns\PallyPowerVanilla\artwork\lock.tga); HighlightTexture(alphaMode=ADD; file=Interface\Buttons\ButtonHilight-Square) |  |
| 1726 | Button | `PP_UI_VerboseButton` | `PallyPowerFrame` |  |  |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-190,-6 |  |  | NormalTexture(file=Interface\AddOns\PallyPowerVanilla\artwork\text.tga); HighlightTexture(alphaMode=ADD; file=Interface\Buttons\ButtonHilight-Square) |  |
| 1743 | Button | `PP_UI_SoundButton` | `PallyPowerFrame` |  |  |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-167,-6 |  |  | NormalTexture(file=Interface\AddOns\PallyPowerVanilla\artwork\sound.tga); HighlightTexture(alphaMode=ADD; file=Interface\Buttons\ButtonHilight-Square) |  |
| 1760 | Button | `PP_UI_OrientationButton` | `PallyPowerFrame` |  |  |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-144,-6 |  |  | NormalTexture(file=Interface\AddOns\PallyPowerVanilla\artwork\orientation.tga); HighlightTexture(alphaMode=ADD; file=Interface\Buttons\ButtonHilight-Square) |  |
| 1778 | Button | `PP_UI_FeedbackButton` | `PallyPowerFrame` |  |  |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-121,-6 |  |  | NormalTexture(file=Interface\AddOns\PallyPowerVanilla\artwork\announce.tga); HighlightTexture(alphaMode=ADD; file=Interface\Buttons\ButtonHilight-Square) |  |
| 1795 | Button | `$parentPresets` | `PallyPowerFrame` |  | GameMenuButtonTemplate |  |  | 86x22 | TOPLEFT->(implicit):(same)@28,-47 |  | text=PALLYPOWER_PRESETS |  | OnClick |
| 1810 | Frame | `$parentClassGroupA` | `PallyPowerFrame` |  | PPSpecialColumnTemplate |  |  |  | TOPLEFT->$parentClassA:BOTTOMLEFT@-26,-12 |  |  |  |  |
| 1819 | Frame | `$parentClassGroupR` | `PallyPowerFrame` |  | PPSpecialColumnTemplate |  |  |  | TOPLEFT->$parentClassR:BOTTOMLEFT@-26,-12 |  |  |  |  |
| 1828 | Frame | `$parentClassGroupS` | `PallyPowerFrame` |  | PPSpecialColumnTemplate |  |  |  | TOPLEFT->$parentClassS:BOTTOMLEFT@-26,-12 |  |  |  |  |
| 1837 | Frame | `$parentClassGroupJ` | `PallyPowerFrame` |  | PPSpecialColumnTemplate |  |  |  | TOPLEFT->$parentClassJ:BOTTOMLEFT@-26,-12 |  |  |  |  |
| 1840 | CheckButton | `$parentJudgementFailedRefresh` | `PallyPowerFrame` |  | UICheckButtonTemplate |  |  | 20x20 | TOPRIGHT->$parentClassJ:TOPRIGHT@9,9 |  |  |  | OnClick, OnEnter, OnLeave |
| 1853 | Frame | `$parentClassGroup1` | `PallyPowerFrame` |  | PPClassColumnTemplate |  |  |  | TOPLEFT->$parentClass0:BOTTOMLEFT@-26,-12 |  |  |  |  |
| 1862 | Frame | `$parentClassGroup2` | `PallyPowerFrame` |  | PPClassColumnTemplate |  |  |  | TOPLEFT->$parentClass1:BOTTOMLEFT@-26,-12 |  |  |  |  |
| 1871 | Frame | `$parentClassGroup3` | `PallyPowerFrame` |  | PPClassColumnTemplate |  |  |  | TOPLEFT->$parentClass2:BOTTOMLEFT@-26,-12 |  |  |  |  |
| 1880 | Frame | `$parentClassGroup4` | `PallyPowerFrame` |  | PPClassColumnTemplate |  |  |  | TOPLEFT->$parentClass3:BOTTOMLEFT@-26,-12 |  |  |  |  |
| 1889 | Frame | `$parentClassGroup5` | `PallyPowerFrame` |  | PPClassColumnTemplate |  |  |  | TOPLEFT->$parentClass4:BOTTOMLEFT@-26,-12 |  |  |  |  |
| 1898 | Frame | `$parentClassGroup6` | `PallyPowerFrame` |  | PPClassColumnTemplate |  |  |  | TOPLEFT->$parentClass5:BOTTOMLEFT@-26,-12 |  |  |  |  |
| 1907 | Frame | `$parentClassGroup7` | `PallyPowerFrame` |  | PPClassColumnTemplate |  |  |  | TOPLEFT->$parentClass6:BOTTOMLEFT@-26,-12 |  |  |  |  |
| 1916 | Frame | `$parentClassGroup8` | `PallyPowerFrame` |  | PPClassColumnTemplate |  |  |  | TOPLEFT->$parentClass7:BOTTOMLEFT@-26,-12 |  |  |  |  |
| 1925 | Frame | `$parentClassGroup9` | `PallyPowerFrame` |  | PPClassColumnTemplate |  |  |  | TOPLEFT->$parentClass8:BOTTOMLEFT@-26,-12 |  |  |  |  |
| 1934 | Frame | `$parentClassGroup10` | `PallyPowerFrame` |  | PPClassColumnTemplate |  |  |  | TOPLEFT->$parentClass9:BOTTOMLEFT@-26,-12 |  |  |  |  |
| 1943 | Frame | `$parentPlayer1` | `PallyPowerFrame` |  | PPPaladinRowTemplate |  |  |  | TOPLEFT->PallyPowerFrameClassGroup1:BOTTOM@-336,-174 |  |  |  |  |
| 1952 | Frame | `$parentPlayer2` | `PallyPowerFrame` |  | PPPaladinRowTemplate |  |  |  | TOPLEFT->$parentPlayer1:BOTTOMLEFT@0,0 |  |  |  |  |
| 1957 | Frame | `$parentPlayer3` | `PallyPowerFrame` |  | PPPaladinRowTemplate |  |  |  | TOPLEFT->$parentPlayer2:BOTTOMLEFT@0,0 |  |  |  |  |
| 1962 | Frame | `$parentPlayer4` | `PallyPowerFrame` |  | PPPaladinRowTemplate |  |  |  | TOPLEFT->$parentPlayer3:BOTTOMLEFT@0,0 |  |  |  |  |
| 1967 | Frame | `$parentPlayer5` | `PallyPowerFrame` |  | PPPaladinRowTemplate |  |  |  | TOPLEFT->$parentPlayer4:BOTTOMLEFT@0,0 |  |  |  |  |
| 1972 | Frame | `$parentPlayer6` | `PallyPowerFrame` |  | PPPaladinRowTemplate |  |  |  | TOPLEFT->$parentPlayer5:BOTTOMLEFT@0,0 |  |  |  |  |
| 1977 | Frame | `$parentPlayer7` | `PallyPowerFrame` |  | PPPaladinRowTemplate |  |  |  | TOPLEFT->$parentPlayer6:BOTTOMLEFT@0,0 |  |  |  |  |
| 1982 | Frame | `$parentPlayer8` | `PallyPowerFrame` |  | PPPaladinRowTemplate |  |  |  | TOPLEFT->$parentPlayer7:BOTTOMLEFT@0,0 |  |  |  |  |
| 1987 | Frame | `$parentPlayer9` | `PallyPowerFrame` |  | PPPaladinRowTemplate |  |  |  | TOPLEFT->$parentPlayer8:BOTTOMLEFT@0,0 |  |  |  |  |
| 1992 | Frame | `$parentPlayer10` | `PallyPowerFrame` |  | PPPaladinRowTemplate |  |  |  | TOPLEFT->$parentPlayer9:BOTTOMLEFT@0,0 |  |  |  |  |
| 1997 | Frame | `$parentPlayer11` | `PallyPowerFrame` |  | PPPaladinRowTemplate |  |  |  | TOPLEFT->$parentPlayer10:BOTTOMLEFT@0,0 |  |  |  |  |
| 2002 | Frame | `$parentPlayer12` | `PallyPowerFrame` |  | PPPaladinRowTemplate |  |  |  | TOPLEFT->$parentPlayer11:BOTTOMLEFT@0,0 |  |  |  |  |
| 2026 | Frame | `PallyPower_ScalingFrame` | `(Ui root)` |  |  |  |  |  |  |  | hidden=true |  | OnUpdate |
| 2036 | Frame | `PallyPower_OptionsFrame` | `(Ui root)` | UIParent |  |  |  | 400x490 | CENTER->UIParent:CENTER@0,65 | bgFile=Interface\Tooltips\UI-Tooltip-Background; edgeFile=Interface\Tooltips\UI-Tooltip-Border; tile=true; tileSize=16; edgeSize=16; insets=bottom=5; left=5; right=5; top=5 | enableMouse=true; frameStrata=DIALOG; hidden=true; movable=true; toplevel=true |  | OnLoad |
| 2058 | FontString | `$parentTitle` | `PallyPower_OptionsFrame` |  | GameFontNormalLarge |  | OVERLAY | 300x16 | TOP->(implicit):(same)@0,-10 |  | text=PALLYPOWER_UI_ADVANCED_TITLE | color=b=0.73; g=0.55; r=0.96 |  |
| 2071 | FontString | `PP_UI_AdvancedMinimapHeader` | `PallyPower_OptionsFrame` |  | GameFontNormal |  | OVERLAY | 180x16 | TOPLEFT->(implicit):(same)@10,-38 |  | justifyH=LEFT; text=PALLYPOWER_UI_SECTION_MINIMAP | color=b=0.73; g=0.55; r=0.96 |  |
| 2076 | FontString | `PP_UI_AdvancedVisualHeader` | `PallyPower_OptionsFrame` |  | GameFontNormal |  | OVERLAY | 180x16 | TOPLEFT->(implicit):(same)@10,-125 |  | justifyH=LEFT; text=PALLYPOWER_UI_SECTION_VISUAL | color=b=0.73; g=0.55; r=0.96 |  |
| 2081 | FontString | `PP_UI_AdvancedLayoutHeader` | `PallyPower_OptionsFrame` |  | GameFontNormal |  | OVERLAY | 180x16 | TOPLEFT->(implicit):(same)@10,-224 |  | justifyH=LEFT; text=PALLYPOWER_UI_SECTION_LAYOUT | color=b=0.73; g=0.55; r=0.96 |  |
| 2086 | FontString | `PP_UI_AdvancedScanningHeader` | `PallyPower_OptionsFrame` |  | GameFontNormal |  | OVERLAY | 180x16 | TOPLEFT->(implicit):(same)@10,-337 |  | justifyH=LEFT; text=PALLYPOWER_UI_SECTION_SCANNING | color=b=0.73; g=0.55; r=0.96 |  |
| 2091 | FontString | `PP_UI_NampowerLabel` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 180x16 | TOPLEFT->(implicit):(same)@18,-440 |  | justifyH=LEFT; text=PALLYPOWER_UI_NAMPOWER |  |  |
| 2099 | FontString | `PP_UI_NampowerState` | `PallyPower_OptionsFrame` |  | GameFontNormal |  | OVERLAY | 150x16 | TOPRIGHT->(implicit):(same)@-30,-440 |  | justifyH=RIGHT |  |  |
| 2107 | FontString | `PP_UI_UnitXPLabel` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 180x16 | TOPLEFT->(implicit):(same)@18,-465 |  | justifyH=LEFT; text=PALLYPOWER_UI_UNITXP_SP3 |  |  |
| 2115 | FontString | `PP_UI_UnitXPState` | `PallyPower_OptionsFrame` |  | GameFontNormal |  | OVERLAY | 150x16 | TOPRIGHT->(implicit):(same)@-30,-465 |  | justifyH=RIGHT |  |  |
| 2123 | FontString | `$parentOption1` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 300x16 | TOPLEFT->(implicit):(same)@18,-365 |  | justifyH=LEFT; text=PALLYPOWER_UI_SCAN_UNITFRAMES_EVERY |  |  |
| 2131 | FontString | `$parentOption2` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 300x16 | TOPLEFT->(implicit):(same)@18,-390 |  | justifyH=LEFT; text=PALLYPOWER_UI_UNITS_SCANNED_PER_FRAME |  |  |
| 2139 | FontString | `$parentOption3` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 200x16 | TOPLEFT->(implicit):(same)@7,-75 |  | justifyH=LEFT; text=PALLYPOWER_OPTIONS_FEEDBACK_CHAT |  |  |
| 2151 | FontString | `$parentOption4` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 200x16 | TOPLEFT->(implicit):(same)@7,-100 |  | justifyH=LEFT; text=PALLYPOWER_OPTIONS_SMARTBUFFS |  |  |
| 2163 | FontString | `$parentOption5` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 300x16 | TOPLEFT->(implicit):(same)@7,-125 |  | justifyH=LEFT; text=PALLYPOWER_OPTIONS_LOCK |  |  |
| 2175 | FontString | `$parentOption6` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 300x16 | TOPLEFT->(implicit):(same)@7,-150 |  | justifyH=LEFT; text=PALLYPOWER_OPTIONS_RF |  |  |
| 2187 | FontString | `$parentOption7` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 300x16 | TOPLEFT->(implicit):(same)@7,-175 |  | justifyH=LEFT; text=PALLYPOWER_OPTIONS_AURA |  |  |
| 2199 | FontString | `$parentOption7a` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 300x16 | TOPLEFT->(implicit):(same)@7,-200 |  | justifyH=LEFT; text=PALLYPOWER_OPTIONS_SEAL |  |  |
| 2211 | FontString | `$parentOption8` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 300x16 | TOPLEFT->(implicit):(same)@18,-62 |  | justifyH=LEFT; text=PALLYPOWER_UI_SHOW_BUTTON |  |  |
| 2219 | FontString | `$parentOption9` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 300x16 | TOPLEFT->(implicit):(same)@18,-87 |  | justifyH=LEFT; text=PALLYPOWER_UI_BUTTON_POSITION |  |  |
| 2227 | FontString | `$parentOption10` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 300x16 | TOPLEFT->(implicit):(same)@7,-275 |  | justifyH=LEFT; text=PALLYPOWER_OPTIONS_PLAY_SOUND |  |  |
| 2239 | FontString | `$parentOption11` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 300x16 | TOPLEFT->(implicit):(same)@7,-300 |  | justifyH=LEFT; text=PALLYPOWER_OPTIONS_HORIZONTAL_LAYOUT |  |  |
| 2251 | FontString | `$parentOption12` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 300x16 | TOPLEFT->(implicit):(same)@18,-204 |  | justifyH=LEFT; text=PALLYPOWER_UI_HIDE_BLIZZARD_AURA_FRAME |  |  |
| 2259 | FontString | `$parentOption13` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 300x16 | TOPLEFT->(implicit):(same)@7,-350 |  | justifyH=LEFT; text=PALLYPOWER_OPTIONS_USE_UNITXP_SP3_LOS |  |  |
| 2271 | FontString | `$parentOption14` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 300x16 | TOPLEFT->(implicit):(same)@18,-149 |  | justifyH=LEFT; text=PALLYPOWER_OPTIONS_USE_HDICONS |  |  |
| 2279 | FontString | `$parentCombineSelfBuffsLabel` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 260x16 | TOPLEFT->(implicit):(same)@18,-252 |  | justifyH=LEFT; text=PALLYPOWER_UI_COMBINE_SELF_BUFFS |  |  |
| 2283 | FontString | `$parentSelfBuffsAboveHeaderLabel` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 260x16 | TOPLEFT->(implicit):(same)@18,-277 |  | justifyH=LEFT; text=PALLYPOWER_UI_SELF_BUFFS_ABOVE_HEADER |  |  |
| 2287 | FontString | `$parentJudgementAboveHeaderLabel` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 260x16 | TOPLEFT->(implicit):(same)@18,-302 |  | justifyH=LEFT; text=PALLYPOWER_UI_JUDGEMENT_ABOVE_HEADER |  |  |
| 2291 | FontString | `$parentVerboseJudgementRefreshLabel` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 260x16 | TOPLEFT->(implicit):(same)@18,-415 |  | justifyH=LEFT; text=PALLYPOWER_UI_VERBOSE_JUDGEMENT_REFRESH |  |  |
| 2299 | FontString | `$parentOption15` | `PallyPower_OptionsFrame` |  | GameFontHighlight |  | OVERLAY | 300x16 | TOPLEFT->(implicit):(same)@18,-174 |  | justifyH=LEFT; text=PALLYPOWER_OPTIONS_TRANSPARENCY |  |  |
| 2310 | Button | `$parentCloseButton` | `PallyPower_OptionsFrame` |  | UIPanelCloseButton |  |  |  | TOPRIGHT->(implicit):(same)@2,2 |  |  |  |  |
| 2319 | EditBox | `$parentScan1` | `PallyPower_OptionsFrame` |  |  |  |  | 34x20 | TOPRIGHT->(implicit):(same)@-30,-363 |  | enableMouse=true; letters=8; numeric=true |  | OnShow, OnTabPressed, OnEditFocusLost, OnChar, OnEnterPressed, OnEscapePressed, OnTextChanged |
| 2328 | Texture | `$parentLeft` | `$parentScan1` |  |  |  | BACKGROUND | -30x-363 | LEFT->(implicit):(same)@0,0 |  |  | file=Interface\Common\Common-Input-Border; tex=bottom=0.625; left=0; right=0.0625; top=0 |  |
| 2337 | Texture | `$parentRight` | `$parentScan1` |  |  |  | BACKGROUND | -30x-363 | RIGHT->(implicit):(same)@0,0 |  |  | file=Interface\Common\Common-Input-Border; tex=bottom=0.625; left=0.9375; right=1; top=0 |  |
| 2346 | Texture | `$parentMiddle` | `$parentScan1` |  |  |  | BACKGROUND | -30x-363 | LEFT->$parentLeft:RIGHT@0,0; RIGHT->$parentRight:LEFT@0,0 |  |  | file=Interface\Common\Common-Input-Border; tex=bottom=0.625; left=0.0625; right=0.9375; top=0 |  |
| 2383 | FontString | `(unnamed)` | `$parentScan1` |  | ChatFontNormal |  |  |  |  |  |  |  |  |
| 2385 | EditBox | `$parentScan2` | `PallyPower_OptionsFrame` |  |  |  |  | 34x20 | TOPRIGHT->(implicit):(same)@-30,-388 |  | enableMouse=true; letters=8; numeric=true |  | OnShow, OnTabPressed, OnEditFocusLost, OnChar, OnEnterPressed, OnEscapePressed, OnTextChanged |
| 2394 | Texture | `$parentLeft` | `$parentScan2` |  |  |  | BACKGROUND | -30x-388 | LEFT->(implicit):(same)@0,0 |  |  | file=Interface\Common\Common-Input-Border; tex=bottom=0.625; left=0; right=0.0625; top=0 |  |
| 2403 | Texture | `$parentRight` | `$parentScan2` |  |  |  | BACKGROUND | -30x-388 | RIGHT->(implicit):(same)@0,0 |  |  | file=Interface\Common\Common-Input-Border; tex=bottom=0.625; left=0.9375; right=1; top=0 |  |
| 2412 | Texture | `$parentMiddle` | `$parentScan2` |  |  |  | BACKGROUND | -30x-388 | LEFT->$parentLeft:RIGHT@0,0; RIGHT->$parentRight:LEFT@0,0 |  |  | file=Interface\Common\Common-Input-Border; tex=bottom=0.625; left=0.0625; right=0.9375; top=0 |  |
| 2449 | FontString | `(unnamed)` | `$parentScan2` |  | ChatFontNormal |  |  |  |  |  |  |  |  |
| 2451 | CheckButton | `$parentCombineSelfBuffs` | `PallyPower_OptionsFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-30,-250 |  |  |  | OnShow, OnClick |
| 2456 | CheckButton | `$parentSelfBuffsAboveHeader` | `PallyPower_OptionsFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-30,-275 |  |  |  | OnShow, OnClick |
| 2461 | CheckButton | `$parentJudgementAboveHeader` | `PallyPower_OptionsFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-30,-300 |  |  |  | OnShow, OnClick |
| 2466 | CheckButton | `$parentVerboseJudgementRefresh` | `PallyPower_OptionsFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-30,-413 |  |  |  | OnShow, OnClick |
| 2482 | CheckButton | `$parentFeedback` | `PallyPower_OptionsFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-5,-75 |  |  |  | OnShow, OnClick |
| 2502 | CheckButton | `$parentSmart` | `PallyPower_OptionsFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-5,-100 |  |  |  | OnShow, OnClick |
| 2522 | CheckButton | `FramesLockedOptionChk` | `PallyPower_OptionsFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-5,-125 |  |  |  | OnShow, OnClick |
| 2542 | CheckButton | `RighteousFuryOptionChk` | `PallyPower_OptionsFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-5,-150 |  |  |  | OnShow, OnClick |
| 2562 | CheckButton | `AuraOptionChk` | `PallyPower_OptionsFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-5,-175 |  |  |  | OnShow, OnClick |
| 2582 | CheckButton | `SealOptionChk` | `PallyPower_OptionsFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-5,-200 |  |  |  | OnShow, OnClick |
| 2602 | CheckButton | `MinimapButtonOptionChk` | `PallyPower_OptionsFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-30,-62 |  |  |  | OnShow, OnClick |
| 2618 | Slider | `MinimapButtonOptionSlider` | `PallyPower_OptionsFrame` |  | OptionsSliderTemplate |  |  | 210x16 | TOPRIGHT->(implicit):(same)@-30,-87 |  |  |  | OnLoad, OnValueChanged |
| 2636 | CheckButton | `PlaySoundOptionChk` | `PallyPower_OptionsFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-5,-275 |  |  |  | OnShow, OnClick |
| 2656 | CheckButton | `HorizontalLayoutOptionChk` | `PallyPower_OptionsFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-5,-300 |  |  |  | OnShow, OnClick |
| 2676 | CheckButton | `HideBlizzardFrameOptionChk` | `PallyPower_OptionsFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-30,-204 |  |  |  | OnShow, OnClick |
| 2692 | CheckButton | `UseUnitXPSP3OptionChk` | `PallyPower_OptionsFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-5,-350 |  |  |  | OnShow, OnClick |
| 2712 | CheckButton | `UseHDIconsOptionChk` | `PallyPower_OptionsFrame` |  | OptionsCheckButtonTemplate |  |  | 20x20 | TOPRIGHT->(implicit):(same)@-30,-149 |  |  |  | OnShow, OnClick |
| 2728 | Slider | `TransparencyOptionSlider` | `PallyPower_OptionsFrame` |  | OptionsSliderTemplate |  |  | 210x16 | TOPRIGHT->(implicit):(same)@-30,-174 |  |  |  | OnLoad, OnValueChanged |
| 2757 | Frame | `PallyPowerMinimapButtonFrame` | `(Ui root)` | Minimap |  |  |  | 32x32 | TOPLEFT->Minimap:RIGHT@2,0 |  | enableMouse=true; frameStrata=LOW; hidden=true |  | OnEvent |
| 2761 | Button | `PallyPowerMinimapButton` | `PallyPowerMinimapButtonFrame` |  |  |  |  | 32x32 | TOPLEFT->(implicit):(same)@0,0 |  |  | NormalTexture(file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Minimap); PushedTexture(file=Interface\AddOns\PallyPowerVanilla\artwork\Icons\Minimap_Down); HighlightTexture(alphaMode=ADD; file=Interface\Minimap\UI-Minimap-ZoomButton-Highlight) | OnLoad, OnClick, OnEnter, OnLeave |
| 2774 | Frame | `PallyPowerMinimapPresetsDropDown` | `PallyPowerMinimapButtonFrame` |  | UIDropDownMenuTemplate |  |  |  |  |  | hidden=true |  | OnLoad |
| 2781 | Frame | `PallyPowerWarningFrame` | `(Ui root)` | UIParent |  |  |  | 350x135 | CENTER->(implicit):(same)@0,0 | bgFile=Interface\DialogFrame\UI-DialogBox-Background; edgeFile=Interface\DialogFrame\UI-DialogBox-Border; tile=true; tileSize=32; edgeSize=32; insets=bottom=11; left=11; right=12; top=12 | enableMouse=true; frameStrata=DIALOG; hidden=true; movable=true; toplevel=true |  | OnShow, OnHide |
| 2789 | Texture | `$parentHeaderTexture` | `PallyPowerWarningFrame` |  |  |  | ARTWORK | 256x64 | TOP->(implicit):(same)@0,12 |  |  | file=Interface\DialogFrame\UI-DialogBox-Header |  |
| 2790 | FontString | `$parentTitle` | `PallyPowerWarningFrame` |  | GameFontNormal |  | ARTWORK |  | TOP->$parentHeaderTexture:(same)@0,-14 |  | text=PALLYPOWER_TEXT_WARNING |  |  |
| 2791 | FontString | `$parentText` | `PallyPowerWarningFrame` |  | GameFontNormal |  | ARTWORK | 300x64 | CENTER->(implicit):(same)@0,10 |  | justifyH=CENTER; justifyV=CENTER; text= |  |  |
| 2794 | Button | `$parentOkayButton` | `PallyPowerWarningFrame` |  | GameMenuButtonTemplate |  |  | 70x21 | BOTTOM->(implicit):(same)@-42,20 |  | text=PALLYPOWER_TEXT_OK |  | OnClick |
| 2795 | Button | `$parentCancelButton` | `PallyPowerWarningFrame` |  | GameMenuButtonTemplate |  |  | 70x21 | BOTTOM->(implicit):(same)@42,20 |  | text=PALLYPOWER_TEXT_CANCEL |  | OnClick |
| 2800 | Frame | `PallyPowerSaveMenu` | `(Ui root)` | UIParent |  |  |  | 350x135 | CENTER->(implicit):(same)@0,0 | bgFile=Interface\DialogFrame\UI-DialogBox-Background; edgeFile=Interface\DialogFrame\UI-DialogBox-Border; tile=true; tileSize=32; edgeSize=32; insets=bottom=11; left=11; right=12; top=12 | enableMouse=true; frameStrata=DIALOG; hidden=true; movable=true; toplevel=true |  | OnShow, OnHide |
| 2806 | Texture | `$parentHeaderTexture` | `PallyPowerSaveMenu` |  |  |  | ARTWORK | 256x64 | TOP->(implicit):(same)@0,12 |  |  | file=Interface\DialogFrame\UI-DialogBox-Header |  |
| 2807 | FontString | `$parentTitle` | `PallyPowerSaveMenu` |  | GameFontNormal |  | ARTWORK |  | TOP->$parentHeaderTexture:(same)@0,-14 |  | text=PALLYPOWER_TEXT_SAVENEW |  |  |
| 2808 | FontString | `$parentEditing` | `PallyPowerSaveMenu` |  | GameFontNormal |  | ARTWORK |  | TOP->(implicit):(same)@0,-25 |  | text=PALLYPOWER_TEXT_NEWNAME |  |  |
| 2809 | FontString | `$parentHelp` | `PallyPowerSaveMenu` |  | GameFontNormal |  | ARTWORK |  | TOP->(implicit):(same)@0,-75 |  | hidden=true; text=PALLYPOWER_TEXT_ALREADYEXISTS |  |  |
| 2812 | EditBox | `$parentNameEB` | `PallyPowerSaveMenu` |  |  |  |  | 250x32 | TOP->(implicit):(same)@0,-40 |  | historyLines=0; letters=250 |  | OnShow, OnEnterPressed, OnTextChanged, OnEscapePressed |
| 2815 | Texture | `$parentLeft` | `$parentNameEB` |  |  |  | BACKGROUND | 65x32 | LEFT->(implicit):(same)@-10,0 |  |  | file=Interface\ChatFrame\UI-ChatInputBorder-Left; tex=bottom=1.0; left=0; right=0.2539; top=0 |  |
| 2816 | Texture | `$parentRight` | `$parentNameEB` |  |  |  | BACKGROUND | 25x32 | RIGHT->(implicit):(same)@10,0 |  |  | file=Interface\ChatFrame\UI-ChatInputBorder-Right; tex=bottom=1.0; left=0.9; right=1.0; top=0 |  |
| 2817 | Texture | `(unnamed)` | `$parentNameEB` |  |  |  | BACKGROUND | 5x32 | LEFT->$parentLeft:RIGHT@0,0; RIGHT->$parentRight:LEFT@0,0 |  |  | file=Interface\ChatFrame\UI-ChatInputBorder-Left; tex=bottom=1.0; left=0.29296875; right=1.0; top=0 |  |
| 2834 | FontString | `(unnamed)` | `$parentNameEB` |  | ChatFontNormal |  |  |  |  |  |  |  |  |
| 2836 | Button | `$parentOkayButton` | `PallyPowerSaveMenu` |  | GameMenuButtonTemplate |  |  | 70x21 | BOTTOM->(implicit):(same)@-42,20 |  | text=PALLYPOWER_TEXT_OK |  | OnClick |
| 2837 | Button | `$parentCancelButton` | `PallyPowerSaveMenu` |  | GameMenuButtonTemplate |  |  | 70x21 | BOTTOM->(implicit):(same)@42,20 |  | text=PALLYPOWER_TEXT_CANCEL |  | OnClick |

## Script bodies

Every XML script handler is captured below so later Lua `SetScript` wiring can be compared handler-for-handler before `PallyPower.xml` is removed.


### XML line 5 — `PPResizeGripTemplate`

- **OnMouseDown:** `PallyPower_StartScaling(arg1)`
- **OnMouseUp:** `PallyPower_StopScaling(arg1)`

### XML line 20 — `PPAssignmentCellTemplate`

- **OnLoad:** `PallyPowerGridButton_OnLoad(this); this:RegisterForClicks("LeftButtonUp", "RightButtonUp"); --[[this:EnableMouseWheel(1)]]`
- **OnClick:** `PallyPowerGridButton_OnClick(this, arg1)`
- **OnEnter:** `PallyPowerGridButton_OnEnter(this)`
- **OnLeave:** `PallyPowerGridButton_OnLeave(this)`
- **OnMouseWheel:** `PallyPowerGridButton_OnMouseWheel(this, arg1)`

### XML line 62 — `PPPlayerOverrideTemplate`

- **OnLoad:** `this:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp"); --[[this:EnableMouseWheel(1);]]`
- **OnClick:** `PallyPowerPlayerButton_OnClick(this, arg1);`
- **OnEnter:** `PallyPowerPlayerButton_OnEnter(this);`
- **OnLeave:** `PallyPowerPlayerButton_OnLeave(this);`
- **OnMouseWheel:** `PallyPowerPlayerButton_OnMouseWheel(this, arg1);`

### XML line 292 — `PPBuffBarBlessingTemplate`

- **OnLoad:** `PallyPowerBuffButton_OnLoad(this); this:RegisterForClicks("LeftButtonUp", "RightButtonUp") --[[this:EnableMouseWheel(1)]]`
- **OnClick:** `PallyPowerBuffButton_OnClick(this, arg1)`
- **OnEnter:** `PallyPowerBuffButton_OnEnter(this)`
- **OnLeave:** `PallyPowerBuffButton_OnLeave(this)`
- **OnMouseWheel:** `PallyPowerBuffBarButton_OnMouseWheel(this, arg1)`

### XML line 396 — `PPBuffBarSpecialTemplate`

- **OnLoad:** `PallyPowerBuffButton_OnLoad(this); this:RegisterForClicks("LeftButtonUp", "RightButtonUp") --[[this:EnableMouseWheel(1)]]`
- **OnClick:** `PallyPowerBuffButton_OnClick(this, arg1)`
- **OnMouseWheel:** `PallyPowerBuffBarButton_OnMouseWheel(this, arg1)`

### XML line 443 — `$parentAura`

- **OnLoad:** `this:RegisterForClicks("LeftButtonUp", "RightButtonUp")`
- **OnClick:** `PallyPowerBuffButton_OnClick(PallyPowerBuffBarAura, arg1)`

### XML line 444 — `$parentRF`

- **OnLoad:** `this:RegisterForClicks("LeftButtonUp", "RightButtonUp")`
- **OnClick:** `PallyPowerBuffButton_OnClick(PallyPowerBuffBarRF, arg1)`

### XML line 450 — `$parentSeal`

- **OnLoad:** `this:RegisterForClicks("LeftButtonUp", "RightButtonUp")`
- **OnClick:** `PallyPowerBuffButton_OnClick(PallyPowerBuffBarSeal, arg1)`

### XML line 762 — `$parentBlessingHover`

- **OnEnter:** `PallyPower_ShowBlessingCapabilities(this)`
- **OnLeave:** `GameTooltip:Hide()`

### XML line 775 — `$parentClassA`

- **OnEnter:** `PallyPower_ShowAuraCapabilities(this)`
- **OnLeave:** `GameTooltip:Hide()`

### XML line 809 — `$parentClassS`

- **OnEnter:** `PallyPower_ShowAllSealCapabilities(this)`
- **OnLeave:** `GameTooltip:Hide()`

### XML line 824 — `$parentClassJ`

- **OnEnter:** `PallyPower_ShowSealCapabilities(this)`
- **OnLeave:** `GameTooltip:Hide()`

### XML line 933 — `PallyPowerBuffBar`

- **OnUpdate:** `PallyPower_OnUpdate(arg1);`

### XML line 941 — `$parentTitle`

- **OnEnter:** `PallyPower_ShowVersionTooltip()`
- **OnLeave:** `HideUIPanel(GameTooltip);`
- **OnMouseDown:** `PallyPowerBuffBar_MouseDown(arg1)`
- **OnMouseUp:** `PallyPowerBuffBar_MouseUp()`

### XML line 1025 — `$parentJudgement`

- **OnClick:** `-- tracker only`
- **OnEnter:** `PallyPower_JudgementTracker_OnEnter(this)`
- **OnLeave:** `GameTooltip:Hide()`

### XML line 1102 — `PallyPowerFrame`

- **OnLoad:** `PallyPower_OnLoad();`
- **OnEvent:** `PallyPower_OnEvent(event,arg1);`
- **OnMouseUp:** `PallyPowerFrame_MouseUp()`
- **OnMouseDown:** `PallyPowerFrame_MouseDown(arg1)`
- **OnHide:** `if (this.isMoving) then this:StopMovingOrSizing(); this.isMoving = false; end`

### XML line 1443 — `$parentAuraEye`

- **OnClick:** `PallyPower_AuraEye_OnClick()`
- **OnEnter:** `PallyPower_VisibilityEye_OnEnter(this, PALLYPOWER_TOOLTIP_AURA_ON_BUFF_BAR)`
- **OnLeave:** `GameTooltip:Hide()`

### XML line 1449 — `$parentRFEye`

- **OnClick:** `PallyPower_RFEye_OnClick()`
- **OnEnter:** `PallyPower_VisibilityEye_OnEnter(this, PALLYPOWER_TOOLTIP_RF_ON_BUFF_BAR)`
- **OnLeave:** `GameTooltip:Hide()`

### XML line 1455 — `$parentSealEye`

- **OnClick:** `PallyPower_SealEye_OnClick()`
- **OnEnter:** `PallyPower_VisibilityEye_OnEnter(this, PALLYPOWER_TOOLTIP_SEAL_ON_BUFF_BAR)`
- **OnLeave:** `GameTooltip:Hide()`

### XML line 1461 — `$parentJudgementEye`

- **OnClick:** `PallyPower_JudgementEye_OnClick()`
- **OnEnter:** `PallyPower_VisibilityEye_OnEnter(this, PALLYPOWER_TOOLTIP_JUDGEMENT_ON_BUFF_BAR)`
- **OnLeave:** `GameTooltip:Hide()`

### XML line 1467 — `$parentTitle`

- **OnEnter:** `PallyPower_ShowVersionTooltip()`
- **OnLeave:** `HideUIPanel(GameTooltip);`
- **OnMouseDown:** `PallyPowerFrame_MouseDown(arg1)`
- **OnMouseUp:** `PallyPowerFrame_MouseUp()`
- **OnUpdate:** `PallyPowerGrid_Update(arg1)`

### XML line 1512 — `$parentCloseButton`

- **OnClick:** `HideUIPanel(this:GetParent());`

### XML line 1532 — `FreeAssignOptionChk`

- **OnShow:** `if (PP_PerUser.freeassign) then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PP_PerUser.freeassign = this:GetChecked(); PallyPower_FreeAssignOption();`
- **OnEnter:** `GameTooltip:SetOwner(this, "ANCHOR_BOTTOM"); GameTooltip:SetText(PALLYPOWER_FREEASSIGN_DESC); GameTooltip:Show();`
- **OnLeave:** `GameTooltip:Hide();`

### XML line 1574 — `PP_UI_SmartButton`

- **OnShow:** `this:SetChecked(PP_PerUser.smartbuffs);`
- **OnClick:** `PallyPower_OptionsFrameSmart:SetChecked(this:GetChecked()); PallyPower_SmartBuffsOption();`

### XML line 1608 — `$parentRefresh`

- **OnClick:** `PallyPower_Refresh()`

### XML line 1637 — `$parentClear`

- **OnClick:** `PallyPower_ConfirmClear()`

### XML line 1657 — `$parentOptions`

- **OnClick:** `PallyPower_Options()`

### XML line 1677 — `$parentResetPosition`

- **OnClick:** `PallyPower_ResetPosition()`

### XML line 1795 — `$parentPresets`

- **OnClick:** `PallyPower_PresetsClick()`

### XML line 1840 — `$parentJudgementFailedRefresh`

- **OnClick:** `PallyPower_JudgementFailedRefreshOption()`
- **OnEnter:** `PallyPower_JudgementFailedRefresh_OnEnter(this)`
- **OnLeave:** `GameTooltip:Hide()`

### XML line 2026 — `PallyPower_ScalingFrame`

- **OnUpdate:** `PallyPower_ScalingFrame_OnUpdate(arg1)`

### XML line 2036 — `PallyPower_OptionsFrame`

- **OnLoad:** `PallyPower_SetFrameBackdropColor(this)`

### XML line 2319 — `$parentScan1`

- **OnShow:** `this:SetNumeric(1); this:SetText(PP_PerUser.scanfreq);`
- **OnTabPressed:** `PallyPower_OptionsFrameScan2:SetFocus();`
- **OnEditFocusLost:** `this:HighlightText(0, 0);`
- **OnChar:** ``
- **OnEnterPressed:** `PallyPower_OptionsFrameScan2:SetFocus();`
- **OnEscapePressed:** `this:GetParent():Hide();`
- **OnTextChanged:** `if (this:GetNumber() &gt; 0) then PallyPower_SetOption("scanfreq", this:GetNumber()); end`

### XML line 2385 — `$parentScan2`

- **OnShow:** `this:SetNumeric(1); this:SetText(PP_PerUser.scanperframe);`
- **OnTabPressed:** `PallyPower_OptionsFrameScan1:SetFocus();`
- **OnEditFocusLost:** `this:HighlightText(0, 0);`
- **OnChar:** ``
- **OnEnterPressed:** `PallyPower_OptionsFrameScan1:SetFocus();`
- **OnEscapePressed:** `this:GetParent():Hide();`
- **OnTextChanged:** `if (this:GetNumber() &gt; 0) then PallyPower_SetOption("scanperframe", this:GetNumber()); end`

### XML line 2451 — `$parentCombineSelfBuffs`

- **OnShow:** `if PP_PerUser.combineselfbuffs then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PallyPower_CombineSelfBuffsOption()`

### XML line 2456 — `$parentSelfBuffsAboveHeader`

- **OnShow:** `if PP_PerUser.selfbuffsaboveheader then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PallyPower_SelfBuffsAboveHeaderOption()`

### XML line 2461 — `$parentJudgementAboveHeader`

- **OnShow:** `if PP_PerUser.judgementaboveheader then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PallyPower_JudgementAboveHeaderOption()`

### XML line 2466 — `$parentVerboseJudgementRefresh`

- **OnShow:** `if PP_PerUser.verbose_judgement_refresh then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PallyPower_VerboseJudgementRefreshOption()`

### XML line 2482 — `$parentFeedback`

- **OnShow:** `if (PP_PerUser.chatfeedback) then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PP_PerUser.chatfeedback = this:GetChecked()`

### XML line 2502 — `$parentSmart`

- **OnShow:** `if (PP_PerUser.smartbuffs) then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PP_PerUser.smartbuffs = this:GetChecked()`

### XML line 2522 — `FramesLockedOptionChk`

- **OnShow:** `if (PP_PerUser.frameslocked) then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PP_PerUser.frameslocked = this:GetChecked(); PallyPower_FramesLockedOption();`

### XML line 2542 — `RighteousFuryOptionChk`

- **OnShow:** `if (PP_PerUser.showrfbutton) then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PP_PerUser.showrfbutton = this:GetChecked(); PallyPower_RighteousFuryOption();`

### XML line 2562 — `AuraOptionChk`

- **OnShow:** `if (PP_PerUser.showaurabutton) then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PP_PerUser.showaurabutton = this:GetChecked(); PallyPower_AuraOption();`

### XML line 2582 — `SealOptionChk`

- **OnShow:** `if (PP_PerUser.showsealbutton) then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PP_PerUser.showsealbutton = this:GetChecked(); PallyPower_SealOption();`

### XML line 2602 — `MinimapButtonOptionChk`

- **OnShow:** `if (PP_PerUser.minimapbuttonshow) then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PP_PerUser.minimapbuttonshow = this:GetChecked(); PallyPower_MinimapButtonOption();`

### XML line 2618 — `MinimapButtonOptionSlider`

- **OnLoad:** `MinimapButtonOptionSlider:SetMinMaxValues(0,360); MinimapButtonOptionSlider:SetValueStep(1);`
- **OnValueChanged:** `PP_PerUser.minimapbuttonpos = MinimapButtonOptionSlider:GetValue(); PallyPower_MinimapButton_UpdatePosition();`

### XML line 2636 — `PlaySoundOptionChk`

- **OnShow:** `if (PP_PerUser.playsoundwhen0) then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PP_PerUser.playsoundwhen0 = this:GetChecked(); PallyPower_PlaySoundOption();`

### XML line 2656 — `HorizontalLayoutOptionChk`

- **OnShow:** `if (PP_PerUser.horizontal) then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PP_PerUser.horizontal = this:GetChecked(); PallyPower_HorizontalLayoutOption();`

### XML line 2676 — `HideBlizzardFrameOptionChk`

- **OnShow:** `if (PP_PerUser.hideblizzaura) then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PP_PerUser.hideblizzaura = this:GetChecked(); PallyPower_HideBlizzardAuraFrameOption();`

### XML line 2692 — `UseUnitXPSP3OptionChk`

- **OnShow:** `if (PP_PerUser.useunitxp_sp3) then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PP_PerUser.useunitxp_sp3 = this:GetChecked(); PallyPower_UseUnitXPSP3Option();`

### XML line 2712 — `UseHDIconsOptionChk`

- **OnShow:** `if (PP_PerUser.usehdicons) then this:SetChecked(true) else this:SetChecked(false) end`
- **OnClick:** `PP_PerUser.usehdicons = this:GetChecked(); PallyPower_UseHDIconsOption();`

### XML line 2728 — `TransparencyOptionSlider`

- **OnLoad:** `TransparencyOptionSlider:SetMinMaxValues(0,1); TransparencyOptionSlider:SetValueStep(0.05);`
- **OnValueChanged:** `PP_PerUser.transparency = TransparencyOptionSlider:GetValue(); PallyPower_AdjustTransparency();`

### XML line 2757 — `PallyPowerMinimapButtonFrame`

- **OnEvent:** `PallyPower_MinimapButton_UpdatePosition();`

### XML line 2761 — `PallyPowerMinimapButton`

- **OnLoad:** `this:RegisterForClicks("LeftButtonUp", "RightButtonUp");`
- **OnClick:** `PallyPower_MinimapButton_OnClick(arg1);`
- **OnEnter:** `PallyPower_ShowCredits()`
- **OnLeave:** `HideUIPanel(GameTooltip);`

### XML line 2774 — `PallyPowerMinimapPresetsDropDown`

- **OnLoad:** `PallyPower_Minimap_PresetsDropDown_OnLoad();`

### XML line 2781 — `PallyPowerWarningFrame`

- **OnShow:** `PlaySound("UChatScrollButton");`
- **OnHide:** `PlaySound("UChatScrollButton");`

### XML line 2794 — `$parentOkayButton`

- **OnClick:** `PallyPower_Warning_Okay();`

### XML line 2795 — `$parentCancelButton`

- **OnClick:** `HideUIPanel(this:GetParent());`

### XML line 2800 — `PallyPowerSaveMenu`

- **OnShow:** `PlaySound("UChatScrollButton");`
- **OnHide:** `PlaySound("UChatScrollButton");`

### XML line 2812 — `$parentNameEB`

- **OnShow:** `this:SetFocus();`
- **OnEnterPressed:** `PallyPower_SaveMenu_Save(PallyPowerSaveMenuNameEB:GetText());`
- **OnTextChanged:** `if ( this:GetText() == "" ) then getglobal(this:GetParent():GetName() .. "OkayButton"):Disable(); PallyPowerSaveMenuHelp:SetText(PALLYPOWER_TEXT_MUSTENTER); PallyPowerSaveMenuHelp:Show(); elseif ( PallyPower_SetExists(this:GetText()) ) then getglobal(this:GetParent():GetName() .. "OkayButton"):Enable(); PallyPowerSaveMenuHelp:SetText(PALLYPOWER_TEXT_OVERWRITE); PallyPowerSaveMenuHelp:Show(); else getglobal(this:GetParent():GetName() .. "OkayButton"):Enable(); PallyPowerSaveMenuHelp:Hide(); end`
- **OnEscapePressed:** `HideUIPanel(this:GetParent());`

### XML line 2836 — `$parentOkayButton`

- **OnClick:** `PallyPower_SaveMenu_Save(PallyPowerSaveMenuNameEB:GetText());`

### XML line 2837 — `$parentCancelButton`

- **OnClick:** `HideUIPanel(this:GetParent());`

## Stage 1 parity rules

- `PallyPower.xml` remains loaded and authoritative during Stage 1; the new Lua scaffold must not construct or replace any UI yet.
- Preserve every named global, `$parent` expansion, inherited template relationship, anchor, size, frame property, region, texture/font detail, backdrop, script handler, and explicit click registration recorded above.
- Preserve all dynamic `getglobal()` expressions above until the complete XML-free parity commit passes the required user runtime checkpoint.
- `Bindings.xml` is outside this manifest and remains intentionally XML-based for the Vanilla keybinding UI.
