-- Development-only performance instrumentation for the PPV 2.0 rewrite.
-- Loaded only from the dev TOC. Profiling is disabled until /ppvperf start.

local PPVPerf = {
    active = false,
    label = nil,
    startedAt = nil,
    stoppedAt = nil,
    startGC = nil,
    stopGC = nil,
    stats = {},
    events = {},
    sent = {},
    received = {},
    sentMessages = 0,
    receivedMessages = 0,
    sentBytes = 0,
    receivedBytes = 0,
    originals = {},
    wrappersInstalled = false
}

local PPVPerf_TargetOrder = {
    "PallyPower_OnUpdate",
    "PallyPowerGrid_Update",
    "PallyPower_UpdateUI",
    "PallyPower_ScanRaid",
    "PallyPower_ScanSpells",
    "PallyPower_ScanInventory",
    "PallyPower_AutoBless",
    "PallyPower_SendSelf",
    "PallyPower_SendMessage",
    "PallyPower_ParseMessage",
    "PallyPower_OnEvent"
}

local PPVPerf_EventOrder = {
    "PLAYER_AURAS_CHANGED",
    "RAID_ROSTER_UPDATE",
    "PARTY_MEMBERS_CHANGED",
    "CHAT_MSG_ADDON",
    "SPELLS_CHANGED",
    "PLAYER_ENTERING_WORLD"
}

local PPVPerf_EventFilter = {}
for _, eventName in ipairs(PPVPerf_EventOrder) do
    PPVPerf_EventFilter[eventName] = true
end

local function PPVPerf_Now()
    if type(debugprofilestop) == "function" then
        return debugprofilestop()
    end
    return GetTime() * 1000
end

local function PPVPerf_GC()
    if type(gcinfo) == "function" then
        return gcinfo()
    end
    return nil
end

local function PPVPerf_Print(message)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("PPV PERF: " .. message)
    end
end

local function PPVPerf_Increment(map, key)
    if not key or key == "" then key = "?" end
    map[key] = (map[key] or 0) + 1
end

local function PPVPerf_MessageType(message)
    if type(message) ~= "string" then return "?" end
    local _, _, messageType = string.find(message, "^([^ ]+)")
    return messageType or "?"
end

local function PPVPerf_Record(name, startedAt)
    local elapsed = PPVPerf_Now() - startedAt
    if elapsed < 0 then elapsed = 0 end

    local stat = PPVPerf.stats[name]
    if not stat then
        stat = { calls = 0, total = 0, max = 0 }
        PPVPerf.stats[name] = stat
    end

    stat.calls = stat.calls + 1
    stat.total = stat.total + elapsed
    if elapsed > stat.max then stat.max = elapsed end
end

local function PPVPerf_Wrap0(name, func)
    return function()
        local startedAt = PPVPerf_Now()
        local r1, r2, r3, r4 = func()
        PPVPerf_Record(name, startedAt)
        return r1, r2, r3, r4
    end
end

local function PPVPerf_Wrap1(name, func)
    return function(a1)
        local startedAt = PPVPerf_Now()
        local r1, r2, r3, r4 = func(a1)
        PPVPerf_Record(name, startedAt)
        return r1, r2, r3, r4
    end
end

local function PPVPerf_Wrap2(name, func)
    return function(a1, a2)
        local startedAt = PPVPerf_Now()
        local r1, r2, r3, r4 = func(a1, a2)
        PPVPerf_Record(name, startedAt)
        return r1, r2, r3, r4
    end
end

local function PPVPerf_WrapSendMessage(func)
    return function(message)
        PPVPerf.sentMessages = PPVPerf.sentMessages + 1
        if type(message) == "string" then
            PPVPerf.sentBytes = PPVPerf.sentBytes + string.len(message)
        end
        PPVPerf_Increment(PPVPerf.sent, PPVPerf_MessageType(message))

        local startedAt = PPVPerf_Now()
        local r1, r2, r3, r4 = func(message)
        PPVPerf_Record("PallyPower_SendMessage", startedAt)
        return r1, r2, r3, r4
    end
end

local function PPVPerf_WrapParseMessage(func)
    return function(sender, message)
        PPVPerf.receivedMessages = PPVPerf.receivedMessages + 1
        if type(message) == "string" then
            PPVPerf.receivedBytes = PPVPerf.receivedBytes + string.len(message)
        end
        PPVPerf_Increment(PPVPerf.received, PPVPerf_MessageType(message))

        local startedAt = PPVPerf_Now()
        local r1, r2, r3, r4 = func(sender, message)
        PPVPerf_Record("PallyPower_ParseMessage", startedAt)
        return r1, r2, r3, r4
    end
end

local function PPVPerf_WrapOnEvent(func)
    return function(eventName, eventArg1)
        if PPVPerf_EventFilter[eventName] then
            PPVPerf_Increment(PPVPerf.events, eventName)
        end

        local startedAt = PPVPerf_Now()
        local r1, r2, r3, r4 = func(eventName, eventArg1)
        PPVPerf_Record("PallyPower_OnEvent", startedAt)
        return r1, r2, r3, r4
    end
end

local function PPVPerf_InstallWrappers()
    if PPVPerf.wrappersInstalled then return true end

    local required = {
        PallyPower_OnUpdate = PallyPower_OnUpdate,
        PallyPowerGrid_Update = PallyPowerGrid_Update,
        PallyPower_UpdateUI = PallyPower_UpdateUI,
        PallyPower_ScanRaid = PallyPower_ScanRaid,
        PallyPower_ScanSpells = PallyPower_ScanSpells,
        PallyPower_ScanInventory = PallyPower_ScanInventory,
        PallyPower_AutoBless = PallyPower_AutoBless,
        PallyPower_SendSelf = PallyPower_SendSelf,
        PallyPower_SendMessage = PallyPower_SendMessage,
        PallyPower_ParseMessage = PallyPower_ParseMessage,
        PallyPower_OnEvent = PallyPower_OnEvent
    }

    for name, func in pairs(required) do
        if type(func) ~= "function" then
            PPVPerf_Print("cannot start; missing function " .. name)
            return false
        end
        PPVPerf.originals[name] = func
    end

    PallyPower_OnUpdate = PPVPerf_Wrap1("PallyPower_OnUpdate", PPVPerf.originals.PallyPower_OnUpdate)
    PallyPowerGrid_Update = PPVPerf_Wrap1("PallyPowerGrid_Update", PPVPerf.originals.PallyPowerGrid_Update)
    PallyPower_UpdateUI = PPVPerf_Wrap0("PallyPower_UpdateUI", PPVPerf.originals.PallyPower_UpdateUI)
    PallyPower_ScanRaid = PPVPerf_Wrap0("PallyPower_ScanRaid", PPVPerf.originals.PallyPower_ScanRaid)
    PallyPower_ScanSpells = PPVPerf_Wrap0("PallyPower_ScanSpells", PPVPerf.originals.PallyPower_ScanSpells)
    PallyPower_ScanInventory = PPVPerf_Wrap0("PallyPower_ScanInventory", PPVPerf.originals.PallyPower_ScanInventory)
    PallyPower_AutoBless = PPVPerf_Wrap1("PallyPower_AutoBless", PPVPerf.originals.PallyPower_AutoBless)
    PallyPower_SendSelf = PPVPerf_Wrap0("PallyPower_SendSelf", PPVPerf.originals.PallyPower_SendSelf)
    PallyPower_SendMessage = PPVPerf_WrapSendMessage(PPVPerf.originals.PallyPower_SendMessage)
    PallyPower_ParseMessage = PPVPerf_WrapParseMessage(PPVPerf.originals.PallyPower_ParseMessage)
    PallyPower_OnEvent = PPVPerf_WrapOnEvent(PPVPerf.originals.PallyPower_OnEvent)

    PPVPerf.wrappersInstalled = true
    return true
end

local function PPVPerf_RemoveWrappers()
    if not PPVPerf.wrappersInstalled then return end

    for name, func in pairs(PPVPerf.originals) do
        if type(func) == "function" then
            _G[name] = func
        end
    end

    PPVPerf.wrappersInstalled = false
end

local function PPVPerf_Reset()
    PPVPerf.stats = {}
    PPVPerf.events = {}
    PPVPerf.sent = {}
    PPVPerf.received = {}
    PPVPerf.sentMessages = 0
    PPVPerf.receivedMessages = 0
    PPVPerf.sentBytes = 0
    PPVPerf.receivedBytes = 0
    PPVPerf.startedAt = nil
    PPVPerf.stoppedAt = nil
    PPVPerf.startGC = nil
    PPVPerf.stopGC = nil
    PPVPerf.label = nil
end

local function PPVPerf_Start(label)
    if PPVPerf.active then
        PPVPerf_Print("already running; stop or reset first")
        return
    end
    if not PPVPerf_InstallWrappers() then return end

    PPVPerf_Reset()
    PPVPerf.active = true
    PPVPerf.label = (label and label ~= "") and label or "baseline"
    PPVPerf.startGC = PPVPerf_GC()
    PPVPerf.startedAt = PPVPerf_Now()
    PPVPerf_Print("started [" .. PPVPerf.label .. "]")
end

local function PPVPerf_Stop()
    if not PPVPerf.active then
        PPVPerf_Print("not running")
        return
    end

    PPVPerf.stoppedAt = PPVPerf_Now()
    PPVPerf.stopGC = PPVPerf_GC()
    PPVPerf.active = false
    PPVPerf_RemoveWrappers()
    PPVPerf_Print("stopped [" .. (PPVPerf.label or "baseline") .. "]")
end

local function PPVPerf_SortedKeys(map)
    local keys = {}
    for key in pairs(map) do
        table.insert(keys, key)
    end
    table.sort(keys)
    return keys
end

local function PPVPerf_ReportCounterMap(label, map)
    local keys = PPVPerf_SortedKeys(map)
    if table.getn(keys) == 0 then
        PPVPerf_Print(label .. ": none")
        return
    end

    local parts = {}
    for _, key in ipairs(keys) do
        table.insert(parts, key .. "=" .. map[key])
    end
    PPVPerf_Print(label .. ": " .. table.concat(parts, ", "))
end

local function PPVPerf_Report()
    local endedAt = PPVPerf.stoppedAt
    if PPVPerf.active then endedAt = PPVPerf_Now() end

    if not PPVPerf.startedAt or not endedAt then
        PPVPerf_Print("no captured run")
        return
    end

    local elapsedSeconds = (endedAt - PPVPerf.startedAt) / 1000
    local gcEnd = PPVPerf.stopGC
    if PPVPerf.active then gcEnd = PPVPerf_GC() end

    local addonVersion = GetAddOnMetadata("PallyPowerVanilla", "Version") or "?"
    local header = string.format(
        "[%s] version=%s duration=%.2fs timer=%s",
        PPVPerf.label or "baseline",
        addonVersion,
        elapsedSeconds,
        type(debugprofilestop) == "function" and "debugprofilestop" or "GetTime"
    )
    if PPVPerf.startGC and gcEnd then
        header = header .. string.format(" gc=%+.0fKB", gcEnd - PPVPerf.startGC)
    end
    PPVPerf_Print(header)
    PPVPerf_Print(string.format(
        "context: raid=%d party=%d assignment=%s scanfreq=%s scanperframe=%s nampower=%s unitxp=%s",
        GetNumRaidMembers(),
        GetNumPartyMembers(),
        PallyPowerFrame and PallyPowerFrame:IsVisible() and "open" or "closed",
        tostring(PP_PerUser and PP_PerUser.scanfreq or "?"),
        tostring(PP_PerUser and PP_PerUser.scanperframe or "?"),
        (PP_ExtensionCapabilities and PP_ExtensionCapabilities.nampowerAuraAPIUsable) and "on" or "off",
        (PP_UnitXPDllLoaded and PP_PerUser and PP_PerUser.useunitxp_sp3) and "on" or "off"
    ))

    for _, name in ipairs(PPVPerf_TargetOrder) do
        local stat = PPVPerf.stats[name]
        if stat and stat.calls > 0 then
            PPVPerf_Print(string.format(
                "%s calls=%d total=%.3fms avg=%.3fms max=%.3fms",
                name,
                stat.calls,
                stat.total,
                stat.total / stat.calls,
                stat.max
            ))
        end
    end

    local eventParts = {}
    for _, eventName in ipairs(PPVPerf_EventOrder) do
        local count = PPVPerf.events[eventName]
        if count and count > 0 then
            table.insert(eventParts, eventName .. "=" .. count)
        end
    end
    if table.getn(eventParts) > 0 then
        PPVPerf_Print("events: " .. table.concat(eventParts, ", "))
    else
        PPVPerf_Print("events: none")
    end

    PPVPerf_Print(string.format(
        "comms: sent=%d/%dB received=%d/%dB",
        PPVPerf.sentMessages,
        PPVPerf.sentBytes,
        PPVPerf.receivedMessages,
        PPVPerf.receivedBytes
    ))
    PPVPerf_ReportCounterMap("sent types", PPVPerf.sent)
    PPVPerf_ReportCounterMap("received types", PPVPerf.received)
    PPVPerf_Print("timings are inclusive; nested rows must not be summed")
end

local function PPVPerf_Status()
    if PPVPerf.active then
        PPVPerf_Print("running [" .. (PPVPerf.label or "baseline") .. "]")
    elseif PPVPerf.startedAt then
        PPVPerf_Print("stopped [" .. (PPVPerf.label or "baseline") .. "]; use /ppvperf report")
    else
        PPVPerf_Print("idle; use /ppvperf start <label>")
    end
end

local function PPVPerf_Help()
    PPVPerf_Print("/ppvperf start <label> - reset and begin profiling")
    PPVPerf_Print("/ppvperf stop - stop profiling and remove wrappers")
    PPVPerf_Print("/ppvperf report - print the current/last capture")
    PPVPerf_Print("/ppvperf reset - clear the last capture")
    PPVPerf_Print("/ppvperf status - show profiler state")
end

SLASH_PPVPERF1 = "/ppvperf"
SlashCmdList["PPVPERF"] = function(message)
    local command, rest
    message = message or ""
    _, _, command, rest = string.find(message, "^%s*(%S*)%s*(.-)%s*$")
    command = string.lower(command or "")

    if command == "start" then
        PPVPerf_Start(rest)
    elseif command == "stop" then
        PPVPerf_Stop()
    elseif command == "report" then
        PPVPerf_Report()
    elseif command == "reset" then
        if PPVPerf.active then PPVPerf_Stop() end
        PPVPerf_Reset()
        PPVPerf_Print("reset")
    elseif command == "status" then
        PPVPerf_Status()
    else
        PPVPerf_Help()
    end
end


-- ============================================================================
-- DEVELOPMENT DIAGNOSTICS PANEL
-- /pp debug opens one compact, copyable snapshot instead of dumping to chat.
-- This file is dev-only and is excluded from stable releases.
-- ============================================================================

local PPV_DebugFrame = nil
local PPV_DebugEditBox = nil
local PPV_DebugLastGeneration = nil
local PPV_DebugLastPlayerStats = nil

local function PPV_DebugYesNo(value)
    if value then return "yes" end
    return "no"
end

local function PPV_DebugCount(map)
    local count = 0
    if not map then return 0 end
    for _ in pairs(map) do
        count = count + 1
    end
    return count
end

local function PPV_DebugSortedNumericKeys(map)
    local keys = {}
    if map then
        for key, value in pairs(map) do
            if type(key) == "number" and value then
                table.insert(keys, key)
            end
        end
    end
    table.sort(keys)
    return keys
end

local function PPV_DebugJoinNumbers(keys)
    if table.getn(keys) == 0 then return "none" end
    local parts = {}
    for _, value in ipairs(keys) do
        table.insert(parts, tostring(value))
    end
    return table.concat(parts, ",")
end

local function PPV_DebugFindPlayerRecord()
    local state = PP_RaidAuraState
    local playerName = UnitName("player")
    if not state or not state.records or not playerName then return nil, nil end

    for unitID, record in pairs(state.records) do
        if record and record.stats and record.stats.name == playerName then
            return unitID, record
        end
    end
    return nil, nil
end

local function PPV_DebugCurrentBuffSummary()
    local classes = 0
    local units = 0
    local visible = 0

    if CurrentBuffs then
        for _, members in pairs(CurrentBuffs) do
            classes = classes + 1
            for _, stats in pairs(members) do
                units = units + 1
                if stats and stats.visible then visible = visible + 1 end
            end
        end
    end

    return classes, units, visible
end

local function PPV_DebugDiffClasses()
    local affected = {}
    local state = PP_RaidAuraState
    if state and state.diffs then
        for _, diff in pairs(state.diffs) do
            if diff.oldClassID ~= nil then affected[diff.oldClassID] = true end
            if diff.newClassID ~= nil then affected[diff.newClassID] = true end
        end
    end
    return PPV_DebugJoinNumbers(PPV_DebugSortedNumericKeys(affected))
end

local function PPV_DebugBuildReport()
    local lines = {}
    local version = GetAddOnMetadata("PallyPowerVanilla", "Version") or "?"
    local playerName = UnitName("player") or "?"
    local _, classToken = UnitClass("player")
    local state = PP_RaidAuraState
    local generation = state and state.generation or 0
    local classes, units, visible = PPV_DebugCurrentBuffSummary()
    local playerUnitID, playerRecord = PPV_DebugFindPlayerRecord()
    local playerStats = playerRecord and playerRecord.stats or nil
    local identity = "first refresh"
    local generationDelta = "n/a"

    if PPV_DebugLastGeneration ~= nil then
        generationDelta = tostring(generation - PPV_DebugLastGeneration)
        if PPV_DebugLastPlayerStats == nil or playerStats == nil then
            identity = (PPV_DebugLastPlayerStats == playerStats) and "same" or "changed"
        elseif PPV_DebugLastPlayerStats == playerStats then
            identity = "same"
        else
            identity = "changed"
        end
    end

    table.insert(lines, "PallyPowerVanilla Development Diagnostics")
    table.insert(lines, "Version: " .. version .. "    Time: " .. date("%H:%M:%S"))
    table.insert(lines, "Character: " .. playerName .. " / " .. tostring(classToken or "?") .. "    Test profile: " .. tostring(PP_TestMode or "off"))
    table.insert(lines, "Group: raid=" .. tostring(GetNumRaidMembers()) .. " party=" .. tostring(GetNumPartyMembers()) .. "    Assignment=" .. (PallyPowerFrame and PallyPowerFrame:IsVisible() and "open" or "closed"))
    table.insert(lines, "Buff Bar: " .. (PallyPowerBuffBar and PallyPowerBuffBar:IsVisible() and "visible" or "hidden") .. "    Layout test: " .. tostring(PP_AssignmentLayoutTest or "off"))
    table.insert(lines, "")
    table.insert(lines, "Persistent raid aura state")
    table.insert(lines, "Generation: " .. tostring(generation) .. " (delta since Refresh: " .. generationDelta .. ")    scanning=" .. PPV_DebugYesNo(state and state.scanning) .. " changed=" .. PPV_DebugYesNo(state and state.changed))
    table.insert(lines, "Records: " .. tostring(state and PPV_DebugCount(state.records) or 0) .. "    CurrentBuffs: classes=" .. tostring(classes) .. " units=" .. tostring(units) .. " visible=" .. tostring(visible))
    table.insert(lines, "Last sweep diffs: " .. tostring(state and PPV_DebugCount(state.diffs) or 0) .. "    affected classes=" .. PPV_DebugDiffClasses())
    table.insert(lines, "Player record: " .. tostring(playerUnitID or "none") .. " class=" .. tostring(playerRecord and playerRecord.classID or "n/a") .. "    identity=" .. identity)
    local playerBlessings = {}
    if playerStats then
        for buffID, active in pairs(playerStats) do
            if type(buffID) == "number" and buffID >= 0 and buffID <= 5 and active then
                playerBlessings[buffID] = true
            end
        end
    end
    table.insert(lines, "Player persistent Blessing IDs: " .. PPV_DebugJoinNumbers(PPV_DebugSortedNumericKeys(playerBlessings)))
    table.insert(lines, "")
    table.insert(lines, "Local player aura state")
    table.insert(lines, "Blessing IDs: " .. PPV_DebugJoinNumbers(PPV_DebugSortedNumericKeys(PP_LocalAuraState and PP_LocalAuraState.blessings)) .. "    RF=" .. PPV_DebugYesNo(PP_LocalAuraState and PP_LocalAuraState.rfActive))
    table.insert(lines, "")
    table.insert(lines, "Runtime")
    table.insert(lines, "Scan: next=" .. tostring(PP_NextScan or "?") .. "s interval=" .. tostring(PP_PerUser and PP_PerUser.scanfreq or "?") .. "s per-frame=" .. tostring(PP_PerUser and PP_PerUser.scanperframe or "?"))
    local ext = PP_ExtensionCapabilities or {}
    table.insert(lines, "Extensions")
    table.insert(lines, "Nampower: detected=" .. PPV_DebugYesNo(ext.nampowerDetected) .. " versionFn=" .. PPV_DebugYesNo(ext.nampowerVersionFunctionPresent) .. " version=" .. tostring(ext.nampowerVersion or "n/a"))
    table.insert(lines, "  GetUnitField=" .. PPV_DebugYesNo(ext.getUnitFieldPresent) .. " GetSpellRecField=" .. PPV_DebugYesNo(ext.getSpellRecFieldPresent) .. " aura API usable=" .. PPV_DebugYesNo(ext.nampowerAuraAPIUsable))
    table.insert(lines, "SuperWoW: detected=" .. PPV_DebugYesNo(ext.superWoWDetected) .. " version=" .. tostring(ext.superWoWVersion or "n/a"))
    table.insert(lines, "  SpellInfo=" .. PPV_DebugYesNo(ext.spellInfoPresent) .. " SetAutoloot=" .. PPV_DebugYesNo(ext.setAutolootPresent) .. " player GUID returned=" .. PPV_DebugYesNo(ext.playerGUIDReturned) .. " GUID-unit usable=" .. PPV_DebugYesNo(ext.guidUnitUsable))
    table.insert(lines, "UnitXP: detected=" .. PPV_DebugYesNo(PP_UnitXPDllLoaded) .. " enabled=" .. PPV_DebugYesNo(PP_PerUser and PP_PerUser.useunitxp_sp3))
    table.insert(lines, "Assignment dirty: roster=" .. PPV_DebugYesNo(PP_AssignmentUIDirty and PP_AssignmentUIDirty.roster) .. " capabilities=" .. PPV_DebugYesNo(PP_AssignmentUIDirty and PP_AssignmentUIDirty.capabilities) .. " assignments=" .. PPV_DebugYesNo(PP_AssignmentUIDirty and PP_AssignmentUIDirty.assignments) .. " layout=" .. PPV_DebugYesNo(PP_AssignmentUIDirty and PP_AssignmentUIDirty.layout))
    table.insert(lines, "Profiler: " .. (PPVPerf.active and ("running [" .. tostring(PPVPerf.label or "baseline") .. "]") or "idle") .. "    Memory=" .. tostring(PallyPower_ShowMemoryUsage and PallyPower_ShowMemoryUsage() or "?") .. " MB")
    table.insert(lines, "")
    table.insert(lines, "Test commands: /pp test prot, holy, ret, off")
    table.insert(lines, "               /pp test layout bridge, tail, off")
    table.insert(lines, "               /pp test unitxp on, off, toggle")

    PPV_DebugLastGeneration = generation
    PPV_DebugLastPlayerStats = playerStats

    return table.concat(lines, "\n")
end

local function PPV_DebugRefresh()
    if PPV_DebugEditBox then
        PPV_DebugEditBox:SetText(PPV_DebugBuildReport())
        PPV_DebugEditBox:SetCursorPosition(0)
        PPV_DebugEditBox:ClearFocus()
    end
end

local function PPV_DebugCreateButton(parent, textValue, width, x, onClick)
    local button = CreateFrame("Button", nil, parent, "GameMenuButtonTemplate")
    button:SetWidth(width)
    button:SetHeight(24)
    button:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", x, 14)
    button:SetText(textValue)
    button:SetScript("OnClick", onClick)
    return button
end

local function PPV_DebugCreateFrame()
    if PPV_DebugFrame then return end

    local frame = CreateFrame("Frame", "PallyPowerDevelopmentDebugFrame", UIParent)
    frame:SetWidth(680)
    frame:SetHeight(470)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function() this:StartMoving() end)
    frame:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 },
    })
    frame:SetBackdropColor(0, 0, 0, 1)

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", frame, "TOP", 0, -18)
    title:SetText("PallyPowerVanilla - Development Debug")

    local hint = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    hint:SetPoint("TOPLEFT", frame, "TOPLEFT", 28, -45)
    hint:SetText("Refresh captures a new snapshot. Select All, then Ctrl+C to copy.")

    local textFrame = CreateFrame("Frame", nil, frame)
    textFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 24, -66)
    textFrame:SetWidth(632)
    textFrame:SetHeight(350)
    textFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 12,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    textFrame:SetBackdropColor(0.02, 0.02, 0.02, 1)
    textFrame:SetBackdropBorderColor(0.45, 0.45, 0.45, 1)

    -- Keep the copyable report clipped inside its panel. The report can grow
    -- beyond the visible area as diagnostics are added, so host the multiline
    -- EditBox in Vanilla's standard scroll-frame template rather than allowing
    -- the EditBox text to draw over the controls below it.
    local scrollFrame = CreateFrame("ScrollFrame", "PallyPowerDevelopmentDebugScrollFrame", textFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", textFrame, "TOPLEFT", 10, -10)
    scrollFrame:SetWidth(586)
    scrollFrame:SetHeight(330)

    local editBox = CreateFrame("EditBox", "PallyPowerDevelopmentDebugText", scrollFrame)
    editBox:SetWidth(566)
    editBox:SetHeight(620)
    editBox:SetMultiLine(true)
    editBox:SetAutoFocus(false)
    editBox:SetMaxLetters(20000)
    editBox:SetFontObject(ChatFontNormal)
    editBox:SetTextColor(1, 1, 1)
    editBox:SetJustifyH("LEFT")
    editBox:SetJustifyV("TOP")
    editBox:EnableMouse(true)
    editBox:SetScript("OnEscapePressed", function()
        this:ClearFocus()
        if PPV_DebugFrame then PPV_DebugFrame:Hide() end
    end)
    scrollFrame:SetScrollChild(editBox)
    PPV_DebugEditBox = editBox

    PPV_DebugCreateButton(frame, "Refresh", 90, 28, function()
        PPV_DebugRefresh()
    end)
    PPV_DebugCreateButton(frame, "Select All", 100, 128, function()
        if PPV_DebugEditBox then
            PPV_DebugEditBox:SetFocus()
            PPV_DebugEditBox:HighlightText()
        end
    end)
    PPV_DebugCreateButton(frame, "Close", 90, 238, function()
        if PPV_DebugEditBox then PPV_DebugEditBox:ClearFocus() end
        if PPV_DebugFrame then PPV_DebugFrame:Hide() end
    end)

    PPV_DebugFrame = frame
    frame:Hide()
end

function PPV_Debug_Show()
    PPV_DebugCreateFrame()
    PPV_DebugRefresh()
    PPV_DebugFrame:Show()
end

function PPV_Debug_Hide()
    if PPV_DebugEditBox then PPV_DebugEditBox:ClearFocus() end
    if PPV_DebugFrame then PPV_DebugFrame:Hide() end
end
