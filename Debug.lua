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
        PP_NampowerAPI and "on" or "off",
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
