-- PallyPowerVanilla UI construction helpers.
-- Stage 2: small standalone UI sections are now constructed here while the
-- larger Buff Bar, Assignment and Advanced Options sections remain XML-backed.

PallyPowerUI = PallyPowerUI or {}

function PallyPowerUI.ResolveName(parent, name)
	if not name then
		return nil
	end

	if string.sub(name, 1, 7) == "$parent" and parent and parent.GetName then
		local parentName = parent:GetName()
		if parentName then
			return parentName .. string.sub(name, 8)
		end
	end

	return name
end

function PallyPowerUI.CreateFrame(frameType, name, parent, inherits)
	return CreateFrame(frameType, PallyPowerUI.ResolveName(parent, name), parent, inherits)
end

function PallyPowerUI.CreateTexture(parent, name, layer, file)
	local texture = parent:CreateTexture(PallyPowerUI.ResolveName(parent, name), layer)
	if file then
		texture:SetTexture(file)
	end
	return texture
end

function PallyPowerUI.CreateFontString(parent, name, layer, inherits)
	return parent:CreateFontString(PallyPowerUI.ResolveName(parent, name), layer, inherits)
end

function PallyPowerUI.SetSize(region, width, height)
	if width then
		region:SetWidth(width)
	end
	if height then
		region:SetHeight(height)
	end
	return region
end

function PallyPowerUI.SetPoint(region, point, relativeTo, relativePoint, x, y)
	region:SetPoint(point, relativeTo, relativePoint, x or 0, y or 0)
	return region
end


-- ============================================================================
-- STAGE 2 TEMPLATE FACTORIES
-- ============================================================================
-- These functions mirror the nine addon-owned virtual XML templates. The XML
-- virtual templates intentionally remain defined while later XML objects still
-- inherit from them.

function PallyPowerUI.SetBackdrop(frame, bgFile, edgeFile, tile, tileSize, edgeSize, left, right, top, bottom)
	frame:SetBackdrop({
		bgFile = bgFile,
		edgeFile = edgeFile,
		tile = tile,
		tileSize = tileSize,
		edgeSize = edgeSize,
		insets = {
			left = left or 0,
			right = right or 0,
			top = top or 0,
			bottom = bottom or 0,
		},
	})
	return frame
end

function PallyPowerUI.SetFontStyle(fontString, height, outline)
	local font, currentHeight, flags = fontString:GetFont()
	if font then
		if outline == "THICK" then
			flags = "THICKOUTLINE"
		elseif outline == "NORMAL" then
			flags = "OUTLINE"
		end
		fontString:SetFont(font, height or currentHeight, flags)
	end
	return fontString
end

function PallyPowerUI.CreatePPResizeGripTemplate(name, parent)
	local button = PallyPowerUI.CreateFrame("Button", name, parent)
	PallyPowerUI.SetSize(button, 16, 16)
	button:SetScript("OnMouseDown", function()
		PallyPower_StartScaling(arg1)
	end)
	button:SetScript("OnMouseUp", function()
		PallyPower_StopScaling(arg1)
	end)
	button:SetNormalTexture("Interface\\AddOns\\PallyPowerVanilla\\artwork\\PallyPower-ResizeGrip")
	button:SetHighlightTexture("Interface\\AddOns\\PallyPowerVanilla\\artwork\\PallyPower-ResizeGrip")
	button:GetHighlightTexture():SetBlendMode("ADD")
	return button
end

function PallyPowerUI.CreatePPAssignmentCellTemplate(name, parent)
	local button = PallyPowerUI.CreateFrame("Button", name, parent)
	local icon

	PallyPowerUI.SetSize(button, 80, 54)

	icon = PallyPowerUI.CreateTexture(button, "$parentIcon", "OVERLAY", "Interface\\AddOns\\PallyPowerVanilla\\artwork\\Icons\\Spell_Holy_SealOfWisdom")
	PallyPowerUI.SetSize(icon, 32, 32)
	PallyPowerUI.SetPoint(icon, "TOPLEFT", button, "TOPLEFT", 24, -20)

	button:SetScript("OnLoad", function()
		PallyPowerGridButton_OnLoad(this)
		this:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	end)
	button:SetScript("OnClick", function()
		PallyPowerGridButton_OnClick(this, arg1)
	end)
	button:SetScript("OnEnter", function()
		PallyPowerGridButton_OnEnter(this)
	end)
	button:SetScript("OnLeave", function()
		PallyPowerGridButton_OnLeave(this)
	end)
	button:SetScript("OnMouseWheel", function()
		PallyPowerGridButton_OnMouseWheel(this, arg1)
	end)

	PallyPowerGridButton_OnLoad(button)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	return button
end

function PallyPowerUI.CreatePPPlayerOverrideTemplate(name, parent)
	local button = PallyPowerUI.CreateFrame("Button", name, parent)
	local text
	local icon

	PallyPowerUI.SetSize(button, 84, 13)
	button:EnableMouse(true)

	text = PallyPowerUI.CreateFontString(button, "$parentText", "OVERLAY", "GameFontHighlightSmall")
	PallyPowerUI.SetSize(text, 78, 13)
	PallyPowerUI.SetPoint(text, "LEFT", button, "LEFT", 2, 0)
	text:SetText("PlayerButton")
	text:SetJustifyH("LEFT")

	icon = PallyPowerUI.CreateTexture(button, "$parentIcon", "OVERLAY", "Interface\\AddOns\\PallyPowerVanilla\\artwork\\Icons\\Spell_Holy_SealOfWisdom")
	PallyPowerUI.SetSize(icon, 12, 12)
	PallyPowerUI.SetPoint(icon, "TOPRIGHT", text, "TOPRIGHT", -2, 0)

	button:SetScript("OnLoad", function()
		this:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp")
	end)
	button:SetScript("OnClick", function()
		PallyPowerPlayerButton_OnClick(this, arg1)
	end)
	button:SetScript("OnEnter", function()
		PallyPowerPlayerButton_OnEnter(this)
	end)
	button:SetScript("OnLeave", function()
		PallyPowerPlayerButton_OnLeave(this)
	end)
	button:SetScript("OnMouseWheel", function()
		PallyPowerPlayerButton_OnMouseWheel(this, arg1)
	end)

	button:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp")
	return button
end

function PallyPowerUI.CreatePPClassColumnTemplate(name, parent)
	local frame = PallyPowerUI.CreateFrame("Frame", name, parent)
	local line
	local i
	local button

	PallyPowerUI.SetSize(frame, 84, 26)
	frame:EnableMouse(true)

	line = PallyPowerUI.CreateTexture(frame, "$parentLine", "ARTWORK", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(line, 2, 212)
	PallyPowerUI.SetPoint(line, "TOPLEFT", frame, "TOPLEFT", 0, 0)

	for i = 1, 15 do
		button = PallyPowerUI.CreatePPPlayerOverrideTemplate("$parentPlayerButton" .. i, frame)
		PallyPowerUI.SetPoint(button, "TOPLEFT", frame, "TOPLEFT", 3, -13 * (i - 1))
	end

	return frame
end

function PallyPowerUI.CreatePPSpecialColumnTemplate(name, parent)
	local frame = PallyPowerUI.CreateFrame("Frame", name, parent)
	local line

	PallyPowerUI.SetSize(frame, 84, 26)

	line = PallyPowerUI.CreateTexture(frame, "$parentLine", "ARTWORK", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(line, 2, 212)
	PallyPowerUI.SetPoint(line, "TOPLEFT", frame, "TOPLEFT", 0, 0)

	return frame
end

function PallyPowerUI.CreatePPBuffBarBlessingTemplate(name, parent)
	local button = PallyPowerUI.CreateFrame("Button", name, parent)
	local region

	PallyPowerUI.SetSize(button, 90, 30)
	PallyPowerUI.SetBackdrop(
		button,
		"Interface\\Tooltips\\UI-Tooltip-Background",
		"Interface\\Tooltips\\UI-Tooltip-Border",
		true, 8, 8, 2, 2, 3, 2
	)

	region = PallyPowerUI.CreateFontString(button, "$parentTime", "OVERLAY", "GameFontHighlightSmall")
	PallyPowerUI.SetSize(region, 28, 10)
	PallyPowerUI.SetPoint(region, "TOPRIGHT", button, "TOPRIGHT", -5, -2)
	region:SetText("10:00")
	region:SetJustifyH("RIGHT")
	PallyPowerUI.SetFontStyle(region, 11)

	region = PallyPowerUI.CreateFontString(button, "$parentTime2", "OVERLAY", "GameFontNormalSmall")
	PallyPowerUI.SetSize(region, 28, 10)
	PallyPowerUI.SetPoint(region, "BOTTOMRIGHT", button, "BOTTOMRIGHT", -5, 1)
	region:SetText("10:00")
	region:SetJustifyH("RIGHT")
	PallyPowerUI.SetFontStyle(region, 11)

	region = PallyPowerUI.CreateFontString(button, "$parentText", "OVERLAY", "GameFontHighlightSmall")
	PallyPowerUI.SetSize(region, 28, 10)
	PallyPowerUI.SetPoint(region, "BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 1)
	region:SetText("99")
	region:SetJustifyH("RIGHT")

	region = PallyPowerUI.CreateTexture(button, "$parentClassIcon", "OVERLAY", "Interface\\AddOns\\PallyPowerVanilla\\artwork\\Icons\\Paladin")
	PallyPowerUI.SetSize(region, 24, 24)
	PallyPowerUI.SetPoint(region, "LEFT", button, "LEFT", 3, 0)

	region = PallyPowerUI.CreateTexture(button, "$parentBuffIcon", "OVERLAY", "Interface\\AddOns\\PallyPowerVanilla\\artwork\\Icons\\Spell_Holy_SealOfWisdom")
	PallyPowerUI.SetSize(region, 24, 24)
	PallyPowerUI.SetPoint(region, "LEFT", button, "LEFT", 33, 0)

	button:SetScript("OnLoad", function()
		PallyPowerBuffButton_OnLoad(this)
		this:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	end)
	button:SetScript("OnClick", function()
		PallyPowerBuffButton_OnClick(this, arg1)
	end)
	button:SetScript("OnEnter", function()
		PallyPowerBuffButton_OnEnter(this)
	end)
	button:SetScript("OnLeave", function()
		PallyPowerBuffButton_OnLeave(this)
	end)
	button:SetScript("OnMouseWheel", function()
		PallyPowerBuffBarButton_OnMouseWheel(this, arg1)
	end)

	PallyPowerBuffButton_OnLoad(button)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	return button
end

function PallyPowerUI.CreatePPBuffBarSpecialTemplate(name, parent)
	local button = PallyPowerUI.CreateFrame("Button", name, parent)
	local icon

	PallyPowerUI.SetSize(button, 90, 30)
	PallyPowerUI.SetBackdrop(
		button,
		"Interface\\Tooltips\\UI-Tooltip-Background",
		"Interface\\Tooltips\\UI-Tooltip-Border",
		true, 8, 8, 2, 2, 3, 2
	)

	icon = PallyPowerUI.CreateTexture(button, "$parentBuffIcon", "OVERLAY", "Interface\\AddOns\\PallyPowerVanilla\\artwork\\Icons\\Spell_Holy_SealOfFury")
	PallyPowerUI.SetSize(icon, 24, 24)
	PallyPowerUI.SetPoint(icon, "CENTER", button, "CENTER", 0, 0)

	button:SetScript("OnLoad", function()
		PallyPowerBuffButton_OnLoad(this)
		this:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	end)
	button:SetScript("OnClick", function()
		PallyPowerBuffButton_OnClick(this, arg1)
	end)
	button:SetScript("OnMouseWheel", function()
		PallyPowerBuffBarButton_OnMouseWheel(this, arg1)
	end)

	PallyPowerBuffButton_OnLoad(button)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	return button
end

function PallyPowerUI.CreatePPBuffBarCombinedSelfButton(name, parent, x, textureFile, clickFrame, addNoRF)
	local button = PallyPowerUI.CreateFrame("Button", name, parent)
	local icon
	local noRF

	PallyPowerUI.SetSize(button, 28, 26)
	PallyPowerUI.SetPoint(button, "LEFT", parent, "LEFT", x, 0)
	PallyPowerUI.SetBackdrop(button, "Interface\\Tooltips\\UI-Tooltip-Background", nil, nil, nil, nil, 0, 0, 0, 0)

	icon = PallyPowerUI.CreateTexture(button, "$parentBuffIcon", "OVERLAY", textureFile)
	PallyPowerUI.SetSize(icon, 22, 22)
	PallyPowerUI.SetPoint(icon, "CENTER", button, "CENTER", 0, 0)

	if addNoRF then
		noRF = PallyPowerUI.CreateFontString(button, "$parentNoRF", "OVERLAY", "GameFontNormalLarge")
		PallyPowerUI.SetSize(noRF, 24, 24)
		PallyPowerUI.SetPoint(noRF, "CENTER", icon, "CENTER", 0, 0)
		noRF:SetText("X")
		noRF:SetJustifyH("CENTER")
		noRF:SetJustifyV("MIDDLE")
		PallyPowerUI.SetFontStyle(noRF, 20, "THICK")
		noRF:SetTextColor(1, 0, 0)
		noRF:Hide()
	end

	button:SetScript("OnLoad", function()
		this:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	end)
	button:SetScript("OnClick", function()
		PallyPowerBuffButton_OnClick(clickFrame(), arg1)
	end)

	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	return button
end

function PallyPowerUI.CreatePPBuffBarCombinedSelfTemplate(name, parent)
	local frame = PallyPowerUI.CreateFrame("Frame", name, parent)

	PallyPowerUI.SetSize(frame, 90, 30)
	PallyPowerUI.SetBackdrop(
		frame,
		"Interface\\Tooltips\\UI-Tooltip-Background",
		"Interface\\Tooltips\\UI-Tooltip-Border",
		true, 8, 8, 2, 2, 3, 2
	)

	PallyPowerUI.CreatePPBuffBarCombinedSelfButton(
		"$parentAura", frame, 1,
		"Interface\\Icons\\Spell_Holy_DevotionAura",
		function() return PallyPowerBuffBarAura end,
		false
	)
	PallyPowerUI.CreatePPBuffBarCombinedSelfButton(
		"$parentRF", frame, 31,
		"Interface\\Icons\\Spell_Holy_SealOfFury",
		function() return PallyPowerBuffBarRF end,
		true
	)
	PallyPowerUI.CreatePPBuffBarCombinedSelfButton(
		"$parentSeal", frame, 61,
		"Interface\\Icons\\Spell_Holy_SealOfWisdom",
		function() return PallyPowerBuffBarSeal end,
		false
	)

	return frame
end

function PallyPowerUI.CreatePPPaladinRowRankIcon(frame, id, x, textureFile)
	local icon = PallyPowerUI.CreateTexture(frame, "$parentIcon" .. id, "OVERLAY", textureFile)
	PallyPowerUI.SetSize(icon, 16, 16)
	PallyPowerUI.SetPoint(icon, "TOPLEFT", frame, "TOPLEFT", x, -52)
	return icon
end

function PallyPowerUI.CreatePPPaladinRowSkill(frame, id)
	local skill = PallyPowerUI.CreateFontString(frame, "$parentSkill" .. id, "OVERLAY", "GameFontNormalSmall")
	local icon = getglobal(frame:GetName() .. "Icon" .. id)
	PallyPowerUI.SetSize(skill, 26, 16)
	PallyPowerUI.SetPoint(skill, "CENTER", icon, "CENTER", 0, 0)
	skill:SetText("")
	skill:SetJustifyH("CENTER")
	skill:SetJustifyV("MIDDLE")
	PallyPowerUI.SetFontStyle(skill, nil, "THICK")
	skill:SetTextColor(1, 1, 1)
	return skill
end

function PallyPowerUI.CreatePPPaladinRowAssignment(frame, suffix)
	return PallyPowerUI.CreatePPAssignmentCellTemplate("$parentClass" .. suffix, frame)
end

function PallyPowerUI.CreatePPPaladinRowTemplate(name, parent)
	local frame = PallyPowerUI.CreateFrame("Frame", name, parent)
	local region
	local previous
	local i
	local cell

	PallyPowerUI.SetSize(frame, 1288, 76)

	region = PallyPowerUI.CreateFontString(frame, "$parentName", "OVERLAY", "GameFontNormalLarge")
	PallyPowerUI.SetSize(region, 92, 20)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 4, -3)
	region:SetText("SomePally$parent")
	region:SetJustifyH("LEFT")

	region = PallyPowerUI.CreateFontString(frame, "$parentSymbols", "OVERLAY", "GameFontHighlightSmall")
	PallyPowerUI.SetSize(region, 24, 16)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 82, -27)
	region:SetText("999")
	region:SetJustifyH("RIGHT")

	region = PallyPowerUI.CreateTexture(frame, "$parentSymbolIcon", "OVERLAY", "Interface\\Icons\\INV_Misc_SymbolofKings_01")
	PallyPowerUI.SetSize(region, 16, 16)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 107, -27)

	PallyPowerUI.CreatePPPaladinRowRankIcon(frame, 0, 4, "Interface\\AddOns\\PallyPowerVanilla\\artwork\\Icons\\Spell_Holy_SealOfWisdom")
	PallyPowerUI.CreatePPPaladinRowRankIcon(frame, 1, 24, "Interface\\AddOns\\PallyPowerVanilla\\artwork\\Icons\\Spell_Holy_FistOfJustice")
	PallyPowerUI.CreatePPPaladinRowRankIcon(frame, 2, 44, "Interface\\AddOns\\PallyPowerVanilla\\artwork\\Icons\\Spell_Holy_SealOfSalvation")
	PallyPowerUI.CreatePPPaladinRowRankIcon(frame, 3, 64, "Interface\\AddOns\\PallyPowerVanilla\\artwork\\Icons\\Spell_Holy_PrayerOfHealing02")
	PallyPowerUI.CreatePPPaladinRowRankIcon(frame, 4, 84, "Interface\\AddOns\\PallyPowerVanilla\\artwork\\Icons\\Spell_Magic_MageArmor")
	PallyPowerUI.CreatePPPaladinRowRankIcon(frame, 5, 104, "Interface\\AddOns\\PallyPowerVanilla\\artwork\\Icons\\Spell_Nature_LightningShield")

	region = PallyPowerUI.CreateTexture(frame, "$parentLine", "OVERLAY", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(region, 1, 2)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 0, 2)
	PallyPowerUI.SetPoint(region, "TOPRIGHT", frame, "TOPRIGHT", -12, 2)

	previous = PallyPowerUI.CreateTexture(frame, "$parentLineA", "OVERLAY", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(previous, 2, 76)
	PallyPowerUI.SetPoint(previous, "TOPLEFT", frame, "TOPLEFT", 127, 0)

	region = PallyPowerUI.CreateTexture(frame, "$parentLine2", "OVERLAY", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(region, 2, 76)
	PallyPowerUI.SetPoint(region, "TOPLEFT", previous, "TOPLEFT", 82, 0)
	previous = region

	region = PallyPowerUI.CreateTexture(frame, "$parentLineJ", "OVERLAY", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(region, 2, 76)
	PallyPowerUI.SetPoint(region, "TOPLEFT", previous, "TOPLEFT", 82, 0)
	previous = region

	for i = 3, 13 do
		region = PallyPowerUI.CreateTexture(frame, "$parentLine" .. i, "OVERLAY", "Interface\\Tooltips\\UI-Tooltip-Background")
		PallyPowerUI.SetSize(region, 2, 76)
		PallyPowerUI.SetPoint(region, "TOPLEFT", previous, "TOPLEFT", 82, 0)
		previous = region
	end

	for i = 0, 5 do
		PallyPowerUI.CreatePPPaladinRowSkill(frame, i)
	end

	region = PallyPowerUI.CreateFontString(frame, "$parentInGroup", "OVERLAY", "GameFontNormalSmall")
	PallyPowerUI.SetSize(region, 20, 14)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 103, -4)
	region:SetText("")
	region:SetJustifyH("RIGHT")

	region = PallyPowerUI.CreateTexture(frame, "$parentIconHOJ", "OVERLAY", "Interface\\Icons\\Spell_Holy_SealOfMight")
	PallyPowerUI.SetSize(region, 16, 16)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 4, -27)

	region = PallyPowerUI.CreateTexture(frame, "$parentIconLH", "OVERLAY", "Interface\\Icons\\Spell_Holy_LayOnHands")
	PallyPowerUI.SetSize(region, 16, 16)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 24, -27)

	region = PallyPowerUI.CreateTexture(frame, "$parentIconDI", "OVERLAY", "Interface\\Icons\\Spell_Nature_TimeStop")
	PallyPowerUI.SetSize(region, 16, 16)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 44, -27)

	region = PallyPowerUI.CreateFrame("Button", "$parentBlessingHover", frame)
	PallyPowerUI.SetSize(region, 124, 20)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 2, -48)
	region:EnableMouse(true)
	region:SetScript("OnEnter", function()
		PallyPower_ShowBlessingCapabilities(this)
	end)
	region:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	cell = PallyPowerUI.CreatePPPaladinRowAssignment(frame, "A")
	PallyPowerUI.SetPoint(cell, "TOPLEFT", frame, "TOPLEFT", 129, -10)
	cell:SetScript("OnEnter", function()
		PallyPower_ShowAuraCapabilities(this)
	end)
	cell:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	cell = PallyPowerUI.CreatePPPaladinRowAssignment(frame, "R")
	PallyPowerUI.SetPoint(cell, "TOPLEFT", getglobal(frame:GetName() .. "ClassA"), "TOPLEFT", 82, 0)
	region = PallyPowerUI.CreateFontString(cell, "$parentNoRF", "OVERLAY", "GameFontNormalLarge")
	PallyPowerUI.SetSize(region, 24, 24)
	PallyPowerUI.SetPoint(region, "CENTER", getglobal(cell:GetName() .. "Icon"), "CENTER", 0, 0)
	region:SetText("X")
	region:SetJustifyH("CENTER")
	region:SetJustifyV("MIDDLE")
	PallyPowerUI.SetFontStyle(region, 20, "THICK")
	region:SetTextColor(1, 0, 0)
	region:Hide()

	cell = PallyPowerUI.CreatePPPaladinRowAssignment(frame, "S")
	PallyPowerUI.SetPoint(cell, "TOPLEFT", getglobal(frame:GetName() .. "ClassA"), "TOPLEFT", 164, 0)
	cell:SetScript("OnEnter", function()
		PallyPower_ShowAllSealCapabilities(this)
	end)
	cell:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	cell = PallyPowerUI.CreatePPPaladinRowAssignment(frame, "J")
	PallyPowerUI.SetPoint(cell, "TOPLEFT", getglobal(frame:GetName() .. "ClassA"), "TOPLEFT", 246, 0)
	cell:SetScript("OnEnter", function()
		PallyPower_ShowSealCapabilities(this)
	end)
	cell:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	cell = PallyPowerUI.CreatePPPaladinRowAssignment(frame, "0")
	PallyPowerUI.SetPoint(cell, "TOPLEFT", getglobal(frame:GetName() .. "ClassA"), "TOPLEFT", 328, 0)
	previous = cell
	for i = 1, 9 do
		cell = PallyPowerUI.CreatePPPaladinRowAssignment(frame, tostring(i))
		PallyPowerUI.SetPoint(cell, "TOPLEFT", previous, "TOPRIGHT", 2, 0)
		previous = cell
	end

	return frame
end

-- ============================================================================
-- STAGE 2 STANDALONE UI
-- ============================================================================

function PallyPowerUI.CreateScalingFrame()
	local frame = CreateFrame("Frame", "PallyPower_ScalingFrame")
	frame:Hide()
	frame:SetScript("OnUpdate", function()
		PallyPower_ScalingFrame_OnUpdate(arg1)
	end)
	return frame
end

function PallyPowerUI.CreateMinimapPresetUI()
	local frame = CreateFrame("Frame", "PallyPowerMinimapButtonFrame", Minimap)
	local button
	local dropdown

	frame:SetWidth(32)
	frame:SetHeight(32)
	frame:SetPoint("TOPLEFT", Minimap, "RIGHT", 2, 0)
	frame:EnableMouse(true)
	frame:SetFrameStrata("LOW")
	frame:Hide()

	button = CreateFrame("Button", "PallyPowerMinimapButton", frame)
	button:SetWidth(32)
	button:SetHeight(32)
	button:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	button:SetNormalTexture("Interface\\AddOns\\PallyPowerVanilla\\artwork\\Icons\\Minimap")
	button:SetPushedTexture("Interface\\AddOns\\PallyPowerVanilla\\artwork\\Icons\\Minimap_Down")
	button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	button:GetHighlightTexture():SetBlendMode("ADD")
	button:SetScript("OnLoad", function()
		this:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	end)
	button:SetScript("OnClick", function()
		PallyPower_MinimapButton_OnClick(arg1)
	end)
	button:SetScript("OnEnter", function()
		PallyPower_ShowCredits()
	end)
	button:SetScript("OnLeave", function()
		HideUIPanel(GameTooltip)
	end)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	dropdown = CreateFrame("Frame", "PallyPowerMinimapPresetsDropDown", frame, "UIDropDownMenuTemplate")
	dropdown:Hide()
	dropdown:SetScript("OnLoad", function()
		PallyPower_Minimap_PresetsDropDown_OnLoad()
	end)
	UIDropDownMenu_Initialize(dropdown, PallyPower_Minimap_PresetsDropDown_Initialize, "MENU")

	frame:SetScript("OnEvent", function()
		PallyPower_MinimapButton_UpdatePosition()
	end)

	return frame
end

function PallyPowerUI.CreateWarningDialog()
	local frame = CreateFrame("Frame", "PallyPowerWarningFrame", UIParent)
	local region
	local button

	frame:SetWidth(350)
	frame:SetHeight(135)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:SetToplevel(true)
	frame:SetFrameStrata("DIALOG")
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:Hide()
	PallyPowerUI.SetBackdrop(
		frame,
		"Interface\\DialogFrame\\UI-DialogBox-Background",
		"Interface\\DialogFrame\\UI-DialogBox-Border",
		true, 32, 32, 11, 12, 12, 11
	)

	region = PallyPowerUI.CreateTexture(frame, "$parentHeaderTexture", "ARTWORK", "Interface\\DialogFrame\\UI-DialogBox-Header")
	PallyPowerUI.SetSize(region, 256, 64)
	PallyPowerUI.SetPoint(region, "TOP", frame, "TOP", 0, 12)

	region = PallyPowerUI.CreateFontString(frame, "$parentTitle", "ARTWORK", "GameFontNormal")
	PallyPowerUI.SetPoint(region, "TOP", getglobal(frame:GetName() .. "HeaderTexture"), "TOP", 0, -14)
	region:SetText(PALLYPOWER_TEXT_WARNING)

	region = PallyPowerUI.CreateFontString(frame, "$parentText", "ARTWORK", "GameFontNormal")
	PallyPowerUI.SetSize(region, 300, 64)
	PallyPowerUI.SetPoint(region, "CENTER", frame, "CENTER", 0, 10)
	region:SetText("")
	region:SetJustifyH("CENTER")
	region:SetJustifyV("CENTER")

	button = CreateFrame("Button", "PallyPowerWarningFrameOkayButton", frame, "GameMenuButtonTemplate")
	button:SetWidth(70)
	button:SetHeight(21)
	button:SetPoint("BOTTOM", frame, "BOTTOM", -42, 20)
	button:SetText(PALLYPOWER_TEXT_OK)
	button:SetScript("OnClick", function()
		PallyPower_Warning_Okay()
	end)

	button = CreateFrame("Button", "PallyPowerWarningFrameCancelButton", frame, "GameMenuButtonTemplate")
	button:SetWidth(70)
	button:SetHeight(21)
	button:SetPoint("BOTTOM", frame, "BOTTOM", 42, 20)
	button:SetText(PALLYPOWER_TEXT_CANCEL)
	button:SetScript("OnClick", function()
		HideUIPanel(this:GetParent())
	end)

	frame:SetScript("OnShow", function()
		PlaySound("UChatScrollButton")
	end)
	frame:SetScript("OnHide", function()
		PlaySound("UChatScrollButton")
	end)

	return frame
end

function PallyPowerUI.CreateSavePresetDialog()
	local frame = CreateFrame("Frame", "PallyPowerSaveMenu", UIParent)
	local region
	local editBox
	local left
	local right
	local middle
	local button

	frame:SetWidth(350)
	frame:SetHeight(135)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:SetToplevel(true)
	frame:SetFrameStrata("DIALOG")
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:Hide()
	PallyPowerUI.SetBackdrop(
		frame,
		"Interface\\DialogFrame\\UI-DialogBox-Background",
		"Interface\\DialogFrame\\UI-DialogBox-Border",
		true, 32, 32, 11, 12, 12, 11
	)

	region = PallyPowerUI.CreateTexture(frame, "$parentHeaderTexture", "ARTWORK", "Interface\\DialogFrame\\UI-DialogBox-Header")
	PallyPowerUI.SetSize(region, 256, 64)
	PallyPowerUI.SetPoint(region, "TOP", frame, "TOP", 0, 12)

	region = PallyPowerUI.CreateFontString(frame, "$parentTitle", "ARTWORK", "GameFontNormal")
	PallyPowerUI.SetPoint(region, "TOP", getglobal(frame:GetName() .. "HeaderTexture"), "TOP", 0, -14)
	region:SetText(PALLYPOWER_TEXT_SAVENEW)

	region = PallyPowerUI.CreateFontString(frame, "$parentEditing", "ARTWORK", "GameFontNormal")
	PallyPowerUI.SetPoint(region, "TOP", frame, "TOP", 0, -25)
	region:SetText(PALLYPOWER_TEXT_NEWNAME)

	region = PallyPowerUI.CreateFontString(frame, "$parentHelp", "ARTWORK", "GameFontNormal")
	PallyPowerUI.SetPoint(region, "TOP", frame, "TOP", 0, -75)
	region:SetText(PALLYPOWER_TEXT_ALREADYEXISTS)
	region:Hide()

	editBox = CreateFrame("EditBox", "PallyPowerSaveMenuNameEB", frame)
	editBox:SetWidth(250)
	editBox:SetHeight(32)
	editBox:SetPoint("TOP", frame, "TOP", 0, -40)
	editBox:SetHistoryLines(0)
	editBox:SetMaxLetters(250)
	editBox:SetFontObject(ChatFontNormal)

	left = PallyPowerUI.CreateTexture(editBox, "$parentLeft", "BACKGROUND", "Interface\\ChatFrame\\UI-ChatInputBorder-Left")
	PallyPowerUI.SetSize(left, 65, 32)
	PallyPowerUI.SetPoint(left, "LEFT", editBox, "LEFT", -10, 0)
	left:SetTexCoord(0, 0.2539, 0, 1.0)

	right = PallyPowerUI.CreateTexture(editBox, "$parentRight", "BACKGROUND", "Interface\\ChatFrame\\UI-ChatInputBorder-Right")
	PallyPowerUI.SetSize(right, 25, 32)
	PallyPowerUI.SetPoint(right, "RIGHT", editBox, "RIGHT", 10, 0)
	right:SetTexCoord(0.9, 1.0, 0, 1.0)

	middle = PallyPowerUI.CreateTexture(editBox, nil, "BACKGROUND", "Interface\\ChatFrame\\UI-ChatInputBorder-Left")
	PallyPowerUI.SetSize(middle, 5, 32)
	PallyPowerUI.SetPoint(middle, "LEFT", left, "RIGHT", 0, 0)
	PallyPowerUI.SetPoint(middle, "RIGHT", right, "LEFT", 0, 0)
	middle:SetTexCoord(0.29296875, 1.0, 0, 1.0)

	editBox:SetScript("OnShow", function()
		this:SetFocus()
	end)
	editBox:SetScript("OnEnterPressed", function()
		PallyPower_SaveMenu_Save(PallyPowerSaveMenuNameEB:GetText())
	end)
	editBox:SetScript("OnTextChanged", function()
		if this:GetText() == "" then
			getglobal(this:GetParent():GetName() .. "OkayButton"):Disable()
			PallyPowerSaveMenuHelp:SetText(PALLYPOWER_TEXT_MUSTENTER)
			PallyPowerSaveMenuHelp:Show()
		elseif PallyPower_SetExists(this:GetText()) then
			getglobal(this:GetParent():GetName() .. "OkayButton"):Enable()
			PallyPowerSaveMenuHelp:SetText(PALLYPOWER_TEXT_OVERWRITE)
			PallyPowerSaveMenuHelp:Show()
		else
			getglobal(this:GetParent():GetName() .. "OkayButton"):Enable()
			PallyPowerSaveMenuHelp:Hide()
		end
	end)
	editBox:SetScript("OnEscapePressed", function()
		HideUIPanel(this:GetParent())
	end)

	button = CreateFrame("Button", "PallyPowerSaveMenuOkayButton", frame, "GameMenuButtonTemplate")
	button:SetWidth(70)
	button:SetHeight(21)
	button:SetPoint("BOTTOM", frame, "BOTTOM", -42, 20)
	button:SetText(PALLYPOWER_TEXT_OK)
	button:SetScript("OnClick", function()
		PallyPower_SaveMenu_Save(PallyPowerSaveMenuNameEB:GetText())
	end)

	button = CreateFrame("Button", "PallyPowerSaveMenuCancelButton", frame, "GameMenuButtonTemplate")
	button:SetWidth(70)
	button:SetHeight(21)
	button:SetPoint("BOTTOM", frame, "BOTTOM", 42, 20)
	button:SetText(PALLYPOWER_TEXT_CANCEL)
	button:SetScript("OnClick", function()
		HideUIPanel(this:GetParent())
	end)

	frame:SetScript("OnShow", function()
		PlaySound("UChatScrollButton")
	end)
	frame:SetScript("OnHide", function()
		PlaySound("UChatScrollButton")
	end)

	return frame
end

function PallyPowerUI.CreateStage2StandaloneUI()
	PallyPowerUI.CreateScalingFrame()
	PallyPowerUI.CreateMinimapPresetUI()
	PallyPowerUI.CreateWarningDialog()
	PallyPowerUI.CreateSavePresetDialog()
end

PallyPowerUI.CreateStage2StandaloneUI()
