-- PallyPowerVanilla 2.0 Step 2
-- Cached owner for local spellbook/talent capability discovery.
-- Legacy callers continue to enter through PallyPower_ScanSpells().

PallyPowerSpellCatalog = {
    cache = nil,
    dirty = true,
    generation = 0,
    invalidatedBy = "startup"
}

local function PP_SpellCatalogBuild()
    local RankInfo = {}
    local AuraRankInfo = {}
    local SealRankInfo = {}
    local cooldownSpellIDs = {}
    local localizedBuffNameToID = {}
    local discoveredSealIcons = {}
    local hasRighteousFuryCapability = false
    local righteousFurySpellName = nil
    local i = 1

    while true do
        local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)
        local spellTexture = GetSpellTexture(i, BOOKTYPE_SPELL)

        if not spellName then
            break
        end

        -- Language-neutral utility detection; preserve localized name for casting.
        if spellTexture and string.find(spellTexture, "Spell_Holy_SealOfFury") then
            hasRighteousFuryCapability = true
            righteousFurySpellName = spellName
        end

        if spellTexture == PallyPower_DivineItervention then
            cooldownSpellIDs["DivineIntervention"] = i
        end
        if spellTexture == PallyPower_LayOnHandsIcon then
            cooldownSpellIDs["LayOnHands"] = i
        end
        if spellTexture == PallyPower_HammerOfJusticeIcon then
            cooldownSpellIDs["HammerOfJustice"] = i
        end

        if not spellRank or spellRank == "" then
            spellRank = PallyPower_Rank1
        end

        local _, _, aura = string.find(spellName, PallyPower_AuraSpellSearch)
        if aura then
            for id, name in PallyPower_AuraID do
                if name == aura then
                    local _, _, rank = string.find(spellRank, PallyPower_RankSearch)
                    if AuraRankInfo[id] and spellRank < AuraRankInfo[id]["rank"] then
                    else
                        AuraRankInfo[id] = {}
                        AuraRankInfo[id]["rank"] = rank
                        AuraRankInfo[id]["id"] = i
                        AuraRankInfo[id]["name"] = name
                        AuraRankInfo[id]["talent"] = 0
                    end
                end
            end
        end

        local _, _, seal = string.find(spellName, PallyPower_SealSpellSearch)
        if seal then
            for id, name in PallyPower_SealID do
                if name == seal then
                    local _, _, rank = string.find(spellRank, PallyPower_RankSearch)
                    if SealRankInfo[id] and spellRank < SealRankInfo[id]["rank"] then
                    else
                        SealRankInfo[id] = {}
                        SealRankInfo[id]["rank"] = rank
                        SealRankInfo[id]["id"] = i
                        SealRankInfo[id]["name"] = name
                        SealRankInfo[id]["talent"] = 0
                        if spellTexture then
                            discoveredSealIcons[id] = spellTexture
                        end
                    end
                end
            end
        end

        local _, _, bless = string.find(spellName, PallyPower_BlessingSpellSearch)
        if bless then
            local greaterBless, _ = string.find(spellName, PallyPower_Greater)
            for id, name in PallyPower_BlessingID do
                if name == bless and not greaterBless then
                    local _, _, rank = string.find(spellRank, PallyPower_RankSearch)
                    if RankInfo[id] and spellRank < RankInfo[id]["rank"] then
                    else
                        RankInfo[id] = {}
                        RankInfo[id]["rank"] = rank
                        RankInfo[id]["id"] = i
                        RankInfo[id]["idsmall"] = i
                        RankInfo[id]["name"] = name
                        RankInfo[id]["spellname"] = spellName
                        RankInfo[id]["talent"] = 0
                        localizedBuffNameToID[spellName] = id
                    end
                end
            end
        end

        if RegularBlessings == false then
            local _, _, greaterCandidate = string.find(spellName, PallyPower_BlessingSpellSearch)
            if greaterCandidate then
                local greaterBless, _ = string.find(spellName, PallyPower_Greater)
                for id, name in PallyPower_BlessingID do
                    if name == greaterCandidate and greaterBless then
                        local _, _, rank = string.find(spellRank, PallyPower_RankSearch)
                        if RankInfo[id] and spellRank < RankInfo[id]["rank"] then
                        else
                            RankInfo[id]["id"] = i
                            RankInfo[id]["name"] = name
                            localizedBuffNameToID[spellName] = id
                        end
                    end
                end
            end
        end

        i = i + 1
    end

    -- Static spell metadata and talent-derived capability belong to the cache.
    if PallyPower_UpdateBlessingSpellData then
        PallyPower_UpdateBlessingSpellData(RankInfo)
    end
    if PallyPower_UpdateImprovedBlessingTalents then
        PallyPower_UpdateImprovedBlessingTalents(RankInfo)
    end
    if PallyPower_UpdateImprovedAuraTalents then
        PallyPower_UpdateImprovedAuraTalents(AuraRankInfo)
    end

    local judgementInfo = {}
    if PallyPower_BuildJudgementCapability then
        judgementInfo = PallyPower_BuildJudgementCapability(SealRankInfo)
    end

    return {
        rankInfo = RankInfo,
        auraRankInfo = AuraRankInfo,
        sealRankInfo = SealRankInfo,
        judgementInfo = judgementInfo,
        cooldownSpellIDs = cooldownSpellIDs,
        localizedBuffNameToID = localizedBuffNameToID,
        sealIcons = discoveredSealIcons,
        hasRighteousFury = hasRighteousFuryCapability,
        righteousFurySpellName = righteousFurySpellName
    }
end

function PallyPowerSpellCatalog:Invalidate(reason)
    self.dirty = true
    self.invalidatedBy = reason or "unspecified"
end

function PallyPowerSpellCatalog:Get()
    if self.dirty or not self.cache then
        self.cache = PP_SpellCatalogBuild()
        self.dirty = false
        self.generation = self.generation + 1
    end
    return self.cache
end

function PallyPowerSpellCatalog:RefreshCooldowns(catalog)
    catalog = catalog or self:Get()
    local RankInfo = catalog.rankInfo
    local cooldownSpellIDs = catalog.cooldownSpellIDs

    if cooldownSpellIDs["DivineIntervention"] then
        RankInfo["DivineIntervention"] =
            (GetSpellCooldown(cooldownSpellIDs["DivineIntervention"], BOOKTYPE_SPELL) == 0)
    else
        RankInfo["DivineIntervention"] = nil
    end

    if cooldownSpellIDs["LayOnHands"] then
        RankInfo["LayOnHands"] =
            (GetSpellCooldown(cooldownSpellIDs["LayOnHands"], BOOKTYPE_SPELL) == 0)
    else
        RankInfo["LayOnHands"] = nil
    end

    if cooldownSpellIDs["HammerOfJustice"] then
        RankInfo["HammerOfJustice"] =
            (GetSpellCooldown(cooldownSpellIDs["HammerOfJustice"], BOOKTYPE_SPELL) == 0)
    else
        RankInfo["HammerOfJustice"] = nil
    end

    return RankInfo
end

function PallyPower_InvalidateSpellCatalog(reason)
    PallyPowerSpellCatalog:Invalidate(reason)
end
