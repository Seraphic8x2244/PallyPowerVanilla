PALLYPOWER_SMALLBLESSING = 0
PALLYPOWER_GREATERBLESSING = 1

-- Existing hardcoded values are retained only as a fallback if tooltip parsing fails.
PallyPower_ManaCostTable = {
    [0] = { -- Wisdom
        [0] = { [14] = 30, [24] = 45, [34] = 65, [44] = 90, [54] = 115, [60] = 125 },
        [1] = { [54] = 230, [60] = 250 },
    },
    [1] = { -- Might
        [0] = { [4] = 20, [12] = 30, [22] = 45, [32] = 60, [42] = 85, [52] = 110, [60] = 130 },
        [1] = { [52] = 220, [60] = 260 },
    },
    [2] = { -- Salvation
        [0] = { [26] = 120 },
        [1] = { [60] = 241 },
    },
    [3] = { -- Light
        [0] = { [40] = 85, [50] = 110, [60] = 135 },
        [1] = { [60] = 260 },
    },
    [4] = { -- Kings
        [0] = { [20] = 120 },
        [1] = { [60] = 226 },
    },
    [5] = { -- Sanctuary
        [0] = { [20] = 60, [40] = 85, [50] = 110, [60] = 135 },
        [1] = { [60] = 241 },
    },
}

PallyPower_DynamicManaCostTable = {}

-- Hidden tooltip used to read the spell data presented by the current client.
local PallyPowerSpellScanTooltip = CreateFrame(
    "GameTooltip",
    "PallyPowerSpellScanTooltip",
    UIParent,
    "GameTooltipTemplate"
)
PallyPowerSpellScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")

local function PallyPower_FirstNumber(text)
    if not text then return nil end
    local _, _, value = string.find(text, "(%d+)")
    if value then return tonumber(value) end
    return nil
end

local function PallyPower_LastNumber(text)
    if not text then return nil end
    local value = nil
    for number in string.gfind(text, "(%d+)") do
        value = tonumber(number)
    end
    return value
end

function PallyPower_ReadBlessingTooltip(spellIndex)
    if not spellIndex then return nil, nil end

    PallyPowerSpellScanTooltip:ClearLines()
    PallyPowerSpellScanTooltip:SetSpell(spellIndex, BOOKTYPE_SPELL)

    local manaLine = getglobal("PallyPowerSpellScanTooltipTextLeft2")
    local descriptionLine = getglobal("PallyPowerSpellScanTooltipTextLeft4")

    local mana = nil
    local durationMinutes = nil

    if manaLine then
        mana = PallyPower_FirstNumber(manaLine:GetText())
    end
    if descriptionLine then
        durationMinutes = PallyPower_LastNumber(descriptionLine:GetText())
    end

    if durationMinutes then
        return mana, durationMinutes * 60
    end
    return mana, nil
end

-- RankInfo["idsmall"] and ["id"] have already been resolved by PallyPower_ScanSpells
-- to the highest learned normal and Greater Blessing spellbook entries.
function PallyPower_UpdateBlessingSpellData(RankInfo)
    if not RankInfo then return end

    PallyPower_DynamicManaCostTable = {}

    local normalDuration = nil
    local greaterDuration = nil

    for blessing = 0, 5 do
        local info = RankInfo[blessing]
        if info then
            PallyPower_DynamicManaCostTable[blessing] = {}

            if info["idsmall"] then
                local mana, duration = PallyPower_ReadBlessingTooltip(info["idsmall"])
                if mana then
                    PallyPower_DynamicManaCostTable[blessing][PALLYPOWER_SMALLBLESSING] = mana
                end
                if duration and not normalDuration then
                    normalDuration = duration
                end
            end

            -- Until a Greater Blessing is found, id == idsmall.
            if info["id"] and info["idsmall"] and info["id"] ~= info["idsmall"] then
                local mana, duration = PallyPower_ReadBlessingTooltip(info["id"])
                if mana then
                    PallyPower_DynamicManaCostTable[blessing][PALLYPOWER_GREATERBLESSING] = mana
                end
                if duration and not greaterDuration then
                    greaterDuration = duration
                end
            end
        end
    end

    if normalDuration then
        PALLYPOWER_NORMALBLESSINGDURATION = normalDuration
    end
    if greaterDuration then
        PALLYPOWER_GREATERBLESSINGDURATION = greaterDuration
    end
end

-- Prefer live spellbook data. Fall back to the existing hardcoded table if parsing fails.
function PallyPower_HasEnoughMana(blessing, type)
    local currentMana = UnitMana("player")

    local dynamicTypes = PallyPower_DynamicManaCostTable[blessing]
    local dynamicCost = dynamicTypes and dynamicTypes[type]
    if dynamicCost then
        return not currentMana or dynamicCost <= currentMana
    end

    local level = UnitLevel("player")
    local types = PallyPower_ManaCostTable[blessing]
    if not types or not types[type] then return true end

    local costTable = types[type]
    local manaCost = 0
    for lvl, cost in pairs(costTable) do
        if level >= lvl and cost > manaCost then
            manaCost = cost
        end
    end

    if currentMana and manaCost > currentMana then
        return false
    else
        return true
    end
end
