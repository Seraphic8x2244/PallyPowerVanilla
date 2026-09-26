-- PallyPowerVanilla UI construction helpers.
-- Stage 6: all addon-owned UI is constructed here; PallyPower.xml has been removed.

PallyPowerUI = PallyPowerUI or {}
PallyPowerUIRefs = {
	playerRows = {},
	classIcons = {},
	classHeaderButtons = {},
	classGroups = {},
	openClassFlyout = nil,
	specialGroups = {},
	assignmentLinkers = {},
	buffButtons = {},
	buffSpecialButtons = {},
	buffCombinedSelf = nil,
	buffBar = nil,
}

PallyPowerUI.AssignmentLayout = {
	-- Retained only for hidden legacy separator compatibility objects.
	COLUMN_WIDTH = 82,
	CELL_SIZE = 32,
	ROW_HEIGHT = 44,
	PALADIN_INFO_WIDTH = 184,
	LEFT_MARGIN = 8,
	FIRST_ASSIGNMENT_GAP = 25,
	HEADER_ICON_TOP = 42,
	HEADER_BASE_HEIGHT = 90,
	PLAYER_LABEL_HEIGHT = 13,
	FOOTER_HEIGHT = 30,
	SELF_BUFF_SPACING_DEFAULT = 6,
	CLASS_SPACING_DEFAULT = 24,
	SPACING_MAX = 50,
	FLYOUT_WIDTH = 120,
	FLYOUT_INSET = 4,
	FLYOUT_GAP = 4,
}
PallyPowerUI.AssignmentLayout.SELF_BUFF_PITCH =
	PallyPowerUI.AssignmentLayout.CELL_SIZE + PallyPowerUI.AssignmentLayout.SELF_BUFF_SPACING_DEFAULT
PallyPowerUI.AssignmentLayout.CLASS_PITCH =
	PallyPowerUI.AssignmentLayout.CELL_SIZE + PallyPowerUI.AssignmentLayout.CLASS_SPACING_DEFAULT
PallyPowerUI.AssignmentLayout.ASSIGNMENT_ICON_LEFT =
	PallyPowerUI.AssignmentLayout.PALADIN_INFO_WIDTH + PallyPowerUI.AssignmentLayout.FIRST_ASSIGNMENT_GAP
PallyPowerUI.AssignmentLayout.ASSIGNMENT_ICON_TOP =
	(PallyPowerUI.AssignmentLayout.ROW_HEIGHT - PallyPowerUI.AssignmentLayout.CELL_SIZE) / 2
PallyPowerUI.AssignmentLayout.ROW_WIDTH =
	PallyPowerUI.AssignmentLayout.PALADIN_INFO_WIDTH +
	PallyPowerUI.AssignmentLayout.FIRST_ASSIGNMENT_GAP +
	PallyPowerUI.AssignmentLayout.CELL_SIZE +
	(3 * PallyPowerUI.AssignmentLayout.SELF_BUFF_PITCH) +
	(10 * PallyPowerUI.AssignmentLayout.CLASS_PITCH) +
	PallyPowerUI.AssignmentLayout.FIRST_ASSIGNMENT_GAP
PallyPowerUI.AssignmentLayout.FRAME_WIDTH =
	(2 * PallyPowerUI.AssignmentLayout.LEFT_MARGIN) + PallyPowerUI.AssignmentLayout.ROW_WIDTH
PallyPowerUI.AssignmentLayout.HEADER_FIRST_ICON_LEFT =
	PallyPowerUI.AssignmentLayout.LEFT_MARGIN + PallyPowerUI.AssignmentLayout.ASSIGNMENT_ICON_LEFT

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
-- These functions mirror the nine addon-owned virtual XML templates from the
-- frozen parity baseline. The XML definitions are removed; Lua factories own them.

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

function PallyPowerUI.SetBorderColor(frame, r, g, b, a)
	if not frame or not frame.ppBorderTextures then return end
	local i
	for i = 1, 4 do
		frame.ppBorderTextures[i]:SetVertexColor(r, g, b, a or 1)
	end
end

function PallyPowerUI.CreateIconBorderFrame(parent, icon, width, height, frameType)
	local border = PallyPowerUI.CreateFrame(frameType or "Frame", nil, parent)
	local top
	local bottom
	local left
	local right

	PallyPowerUI.SetSize(border, width, height)
	PallyPowerUI.SetPoint(border, "CENTER", icon, "CENTER", 0, 0)
	border.ppIcon = icon
	border.ppBorderTextures = {}

	top = PallyPowerUI.CreateTexture(border, nil, "OVERLAY", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(top, width, 1)
	PallyPowerUI.SetPoint(top, "TOP", border, "TOP", 0, 0)
	border.ppBorderTextures[1] = top

	bottom = PallyPowerUI.CreateTexture(border, nil, "OVERLAY", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(bottom, width, 1)
	PallyPowerUI.SetPoint(bottom, "BOTTOM", border, "BOTTOM", 0, 0)
	border.ppBorderTextures[2] = bottom

	left = PallyPowerUI.CreateTexture(border, nil, "OVERLAY", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(left, 1, height)
	PallyPowerUI.SetPoint(left, "LEFT", border, "LEFT", 0, 0)
	border.ppBorderTextures[3] = left

	right = PallyPowerUI.CreateTexture(border, nil, "OVERLAY", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(right, 1, height)
	PallyPowerUI.SetPoint(right, "RIGHT", border, "RIGHT", 0, 0)
	border.ppBorderTextures[4] = right

	PallyPowerUI.SetBorderColor(border, 0, 0, 0, 1)
	return border
end

function PallyPowerUI.CreateClassHeaderButton(parent, classID, icon, color)
	local button = PallyPowerUI.CreateIconBorderFrame(parent, icon, 32, 32, "Button")
	local glow = {}
	local i
	local edge

	button.ppClass = classID
	button.ppClassColor = color
	button.ppGlowTextures = glow
	button:RegisterForClicks("LeftButtonUp")

	for i = 1, 4 do
		edge = PallyPowerUI.CreateTexture(button, nil, "OVERLAY", "Interface\\Tooltips\\UI-Tooltip-Background")
		edge:SetVertexColor(color[1], color[2], color[3], 1)
		edge:SetBlendMode("ADD")
		glow[i] = edge
	end
	PallyPowerUI.SetSize(glow[1], 32, 2)
	PallyPowerUI.SetPoint(glow[1], "TOP", button, "TOP", 0, 0)
	PallyPowerUI.SetSize(glow[2], 32, 2)
	PallyPowerUI.SetPoint(glow[2], "BOTTOM", button, "BOTTOM", 0, 0)
	PallyPowerUI.SetSize(glow[3], 2, 32)
	PallyPowerUI.SetPoint(glow[3], "LEFT", button, "LEFT", 0, 0)
	PallyPowerUI.SetSize(glow[4], 2, 32)
	PallyPowerUI.SetPoint(glow[4], "RIGHT", button, "RIGHT", 0, 0)
	for i = 1, 4 do glow[i]:Hide() end

	button:SetScript("OnClick", function()
		PallyPowerUI.ToggleClassFlyout(this.ppClass)
	end)
	button:SetScript("OnEnter", function()
		local j
		for j = 1, 4 do this.ppGlowTextures[j]:Show() end
		GameTooltip:SetOwner(this, "ANCHOR_TOP")
		GameTooltip:SetText(PALLYPOWER_TOOLTIP_CLASS_OVERRIDES, 1, 1, 1)
		GameTooltip:AddLine(PALLYPOWER_TOOLTIP_CLASS_OVERRIDES_DESC, 0.9, 0.9, 0.9, 1)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function()
		local j
		for j = 1, 4 do this.ppGlowTextures[j]:Hide() end
		GameTooltip:Hide()
	end)

	PallyPowerUIRefs.classHeaderButtons[classID] = button
	return button
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
	button:SetNormalTexture("Interface\\AddOns\\PallyPowerVanilla\\assets\\PallyPower-ResizeGrip.tga")
	button:SetHighlightTexture("Interface\\AddOns\\PallyPowerVanilla\\assets\\PallyPower-ResizeGrip.tga")
	button:GetHighlightTexture():SetBlendMode("ADD")
	return button
end

function PallyPowerUI.CreatePPAssignmentCellTemplate(name, parent)
	local button = PallyPowerUI.CreateFrame("Button", name, parent)
	local icon

	PallyPowerUI.SetSize(button, 32, 32)
	button:EnableMouseWheel(true)

	icon = PallyPowerUI.CreateTexture(button, "$parentIcon", "OVERLAY", "Interface\\Icons\\Spell_Holy_SealOfWisdom")
	PallyPowerUI.SetSize(icon, 32, 32)
	PallyPowerUI.SetPoint(icon, "TOPLEFT", button, "TOPLEFT", 0, 0)
	button.ppIcon = icon
	button.ppIconBorder = PallyPowerUI.CreateIconBorderFrame(button, icon, 32, 32)
	button.ppIconBorder:Hide()

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
	button:EnableMouseWheel(true)

	text = PallyPowerUI.CreateFontString(button, "$parentText", "OVERLAY", "GameFontHighlightSmall")
	PallyPowerUI.SetSize(text, 63, 13)
	PallyPowerUI.SetPoint(text, "LEFT", button, "LEFT", 19, 0)
	text:SetText("PlayerButton")
	text:SetJustifyH("LEFT")

	icon = PallyPowerUI.CreateTexture(button, "$parentIcon", "OVERLAY", "Interface\\Icons\\Spell_Holy_SealOfWisdom")
	PallyPowerUI.SetSize(icon, 12, 12)
	PallyPowerUI.SetPoint(icon, "LEFT", button, "LEFT", 5, 0)
	button.ppText = text
	button.ppIcon = icon
	button.ppIconBorder = PallyPowerUI.CreateIconBorderFrame(button, icon, 12, 12)
	button.ppIconBorder:Hide()

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

function PallyPowerUI.AlignPlayerOverrideContent(button)
	if not button or not button.ppText or not button.ppIcon then
		return
	end

	local buttonWidth = button:GetWidth() or 84
	local iconWidth = 12
	local gap = 2
	local minimumInset = 2
	local textWidth = 0

	if button.ppText.GetStringWidth then
		textWidth = button.ppText:GetStringWidth() or 0
	end

	local availableTextWidth = buttonWidth - iconWidth - gap - (2 * minimumInset)
	if availableTextWidth < 1 then
		availableTextWidth = 1
	end
	if textWidth > availableTextWidth then
		textWidth = availableTextWidth
	end

	local contentWidth = iconWidth
	if textWidth > 0 then
		contentWidth = contentWidth + gap + textWidth
	end

	local left = math.floor((buttonWidth - contentWidth) / 2)
	if left < minimumInset then
		left = minimumInset
	end

	button.ppIcon:ClearAllPoints()
	PallyPowerUI.SetPoint(button.ppIcon, "LEFT", button, "LEFT", left, 0)

	button.ppText:ClearAllPoints()
	PallyPowerUI.SetPoint(button.ppText, "LEFT", button.ppIcon, "RIGHT", gap, 0)
	button.ppText:SetWidth(buttonWidth - left - iconWidth - gap - minimumInset)
	button.ppText:SetJustifyH("LEFT")
end

function PallyPowerUI.CreatePPClassColumnTemplate(name, parent)
	local layout = PallyPowerUI.AssignmentLayout
	local frame = PallyPowerUI.CreateFrame("Frame", name, parent)
	local line
	local i
	local button

	PallyPowerUI.SetSize(frame, layout.FLYOUT_WIDTH, 1)
	frame:EnableMouse(false)
	PallyPowerUI.SetBackdrop(
		frame,
		"Interface\\Tooltips\\UI-Tooltip-Background",
		"Interface\\Tooltips\\UI-Tooltip-Border",
		true, 8, 8, 3, 3, 3, 3
	)
	frame:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
	frame:SetBackdropBorderColor(0.35, 0.35, 0.35, 1)
	frame:SetFrameStrata("DIALOG")
	frame.ppPlayerCount = 0
	frame:Hide()

	line = PallyPowerUI.CreateTexture(frame, "$parentLine", "ARTWORK", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(line, 1, 1)
	PallyPowerUI.SetPoint(line, "TOPLEFT", frame, "TOPLEFT", 0, 0)
	frame.ppLine = line
	line:Hide()
	frame.playerButtons = {}

	for i = 1, 15 do
		button = PallyPowerUI.CreatePPPlayerOverrideTemplate("$parentPlayerButton" .. i, frame)
		button:SetWidth(layout.FLYOUT_WIDTH - (2 * layout.FLYOUT_INSET))
		PallyPowerUI.SetPoint(
			button, "BOTTOMLEFT", frame, "BOTTOMLEFT",
			layout.FLYOUT_INSET,
			layout.FLYOUT_INSET + (layout.PLAYER_LABEL_HEIGHT * (i - 1))
		)
		frame.playerButtons[i] = button
	end

	return frame
end

function PallyPowerUI.UpdateClassFlyout(group, playerCount)
	local layout = PallyPowerUI.AssignmentLayout
	local count = playerCount or 0
	local height = (2 * layout.FLYOUT_INSET) + (count * layout.PLAYER_LABEL_HEIGHT)

	group.ppPlayerCount = count
	if height < 1 then height = 1 end
	group:SetHeight(height)

	if count <= 0 and group:IsShown() then
		group:Hide()
		if PallyPowerUIRefs.openClassFlyout == group then
			PallyPowerUIRefs.openClassFlyout = nil
		end
	end
end

function PallyPowerUI.ToggleClassFlyout(classID)
	local refs = PallyPowerUIRefs
	local group = refs.classGroups[classID + 1]

	if refs.openClassFlyout then
		local previous = refs.openClassFlyout
		refs.openClassFlyout = nil
		previous:Hide()
		if previous == group then
			return
		end
	end

	if group and group.ppPlayerCount and group.ppPlayerCount > 0 then
		group:Show()
		refs.openClassFlyout = group
	end
end

function PallyPowerUI.CreatePPSpecialColumnTemplate(name, parent)
	local frame = PallyPowerUI.CreateFrame("Frame", name, parent)
	local line

	PallyPowerUI.SetSize(frame, 84, 26)

	line = PallyPowerUI.CreateTexture(frame, "$parentLine", "ARTWORK", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(line, 2, 212)
	PallyPowerUI.SetPoint(line, "TOPLEFT", frame, "TOPLEFT", 0, 0)
	frame.ppLine = line
	line:Hide()

	return frame
end

function PallyPowerUI.CreatePPBuffBarBlessingTemplate(name, parent)
	local button = PallyPowerUI.CreateFrame("Button", name, parent)
	local region
	local oldThis

	PallyPowerUI.SetSize(button, 90, 30)
	button:EnableMouseWheel(true)
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
	button.ppTime = region

	region = PallyPowerUI.CreateFontString(button, "$parentTime2", "OVERLAY", "GameFontNormalSmall")
	PallyPowerUI.SetSize(region, 28, 10)
	PallyPowerUI.SetPoint(region, "BOTTOMRIGHT", button, "BOTTOMRIGHT", -5, 1)
	region:SetText("10:00")
	region:SetJustifyH("RIGHT")
	PallyPowerUI.SetFontStyle(region, 11)
	button.ppTime2 = region

	region = PallyPowerUI.CreateFontString(button, "$parentText", "OVERLAY", "GameFontHighlightSmall")
	PallyPowerUI.SetSize(region, 28, 10)
	PallyPowerUI.SetPoint(region, "BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 1)
	region:SetText("99")
	region:SetJustifyH("RIGHT")
	button.ppText = region

	region = PallyPowerUI.CreateTexture(button, "$parentClassIcon", "OVERLAY", "Interface\\AddOns\\PallyPowerVanilla\\assets\\class-paladin.tga")
	PallyPowerUI.SetSize(region, 24, 24)
	PallyPowerUI.SetPoint(region, "LEFT", button, "LEFT", 3, 0)
	button.ppClassIcon = region

	region = PallyPowerUI.CreateTexture(button, "$parentBuffIcon", "OVERLAY", "Interface\\Icons\\Spell_Holy_SealOfWisdom")
	PallyPowerUI.SetSize(region, 24, 24)
	PallyPowerUI.SetPoint(region, "LEFT", button, "LEFT", 33, 0)
	button.ppBuffIcon = region

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

	oldThis = this
	this = button
	PallyPowerBuffButton_OnLoad(button)
	this = oldThis
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	return button
end

function PallyPowerUI.CreatePPBuffBarSpecialTemplate(name, parent)
	local button = PallyPowerUI.CreateFrame("Button", name, parent)
	local icon
	local oldThis

	PallyPowerUI.SetSize(button, 90, 30)
	button:EnableMouseWheel(true)
	PallyPowerUI.SetBackdrop(
		button,
		"Interface\\Tooltips\\UI-Tooltip-Background",
		"Interface\\Tooltips\\UI-Tooltip-Border",
		true, 8, 8, 2, 2, 3, 2
	)

	icon = PallyPowerUI.CreateTexture(button, "$parentBuffIcon", "OVERLAY", "Interface\\Icons\\Spell_Holy_SealOfFury")
	PallyPowerUI.SetSize(icon, 24, 24)
	PallyPowerUI.SetPoint(icon, "CENTER", button, "CENTER", 0, 0)
	button.ppBuffIcon = icon

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

	oldThis = this
	this = button
	PallyPowerBuffButton_OnLoad(button)
	this = oldThis
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
	button.ppBuffIcon = icon

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
        button.ppLegacyNoRF = noRF
        button.ppNoRF = noRF
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

	frame.ppSlots = {}
	frame.ppSlots.Aura = PallyPowerUI.CreatePPBuffBarCombinedSelfButton(
		"$parentAura", frame, 1,
		"Interface\\Icons\\Spell_Holy_DevotionAura",
		function() return PallyPowerBuffBarAura end,
		false
	)
	frame.ppSlots.RF = PallyPowerUI.CreatePPBuffBarCombinedSelfButton(
		"$parentRF", frame, 31,
		"Interface\\Icons\\Spell_Holy_SealOfFury",
		function() return PallyPowerBuffBarRF end,
		true
	)
	frame.ppSlots.Seal = PallyPowerUI.CreatePPBuffBarCombinedSelfButton(
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
	PallyPowerUI.SetPoint(icon, "TOPLEFT", frame, "TOPLEFT", x, -25)
	frame.ppRankIcons = frame.ppRankIcons or {}
	frame.ppRankIcons[id] = icon
	return icon
end

function PallyPowerUI.CreatePPPaladinRowSkill(frame, id)
	local skill = PallyPowerUI.CreateFontString(frame, "$parentSkill" .. id, "OVERLAY", "GameFontNormalSmall")
	local icon = frame.ppRankIcons and frame.ppRankIcons[id]
	PallyPowerUI.SetSize(skill, 26, 16)
	PallyPowerUI.SetPoint(skill, "CENTER", icon, "CENTER", 0, 0)
	skill:SetText("")
	skill:SetJustifyH("CENTER")
	skill:SetJustifyV("MIDDLE")
	PallyPowerUI.SetFontStyle(skill, nil, "THICK")
	skill:SetTextColor(1, 1, 1)
	frame.ppSkills = frame.ppSkills or {}
	frame.ppSkills[id] = skill
	return skill
end

function PallyPowerUI.CreatePPPaladinRowAssignment(frame, suffix)
	local cell = PallyPowerUI.CreatePPAssignmentCellTemplate("$parentClass" .. suffix, frame)
	cell.ppRow = frame
	cell.ppClass = suffix
	return cell
end

function PallyPowerUI.CreatePPPaladinRowTemplate(name, parent)
	local layout = PallyPowerUI.AssignmentLayout
	local frame = PallyPowerUI.CreateFrame("Frame", name, parent)
	local region
	local previous
	local i
	local cell

	PallyPowerUI.SetSize(frame, layout.ROW_WIDTH, layout.ROW_HEIGHT)

	region = PallyPowerUI.CreateFontString(frame, "$parentName", "OVERLAY", "GameFontNormalLarge")
	PallyPowerUI.SetSize(region, 100, 20)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 24, -1)
	region:SetText("SomePally$parent")
	region:SetJustifyH("LEFT")
	frame.ppName = region

	region = PallyPowerUI.CreateFontString(frame, "$parentSymbols", "OVERLAY", "GameFontHighlightSmall")
	PallyPowerUI.SetSize(region, 38, 16)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 124, -25)
	region:SetText("999")
	region:SetJustifyH("LEFT")
	frame.ppSymbols = region

	region = PallyPowerUI.CreateTexture(frame, "$parentSymbolIcon", "OVERLAY", "Interface\\Icons\\INV_Misc_SymbolofKings_01")
	PallyPowerUI.SetSize(region, 16, 16)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 164, -25)
	frame.ppSymbolIcon = region

	PallyPowerUI.CreatePPPaladinRowRankIcon(frame, 0, 4, "Interface\\Icons\\Spell_Holy_SealOfWisdom")
	PallyPowerUI.CreatePPPaladinRowRankIcon(frame, 1, 24, "Interface\\Icons\\Spell_Holy_FistOfJustice")
	PallyPowerUI.CreatePPPaladinRowRankIcon(frame, 2, 44, "Interface\\Icons\\Spell_Holy_SealOfSalvation")
	PallyPowerUI.CreatePPPaladinRowRankIcon(frame, 3, 64, "Interface\\Icons\\Spell_Holy_PrayerOfHealing02")
	PallyPowerUI.CreatePPPaladinRowRankIcon(frame, 4, 84, "Interface\\Icons\\Spell_Magic_MageArmor")
	PallyPowerUI.CreatePPPaladinRowRankIcon(frame, 5, 104, "Interface\\Icons\\Spell_Nature_LightningShield")

	-- Keep legacy named line regions for compatibility, but remove their presentation.
	region = PallyPowerUI.CreateTexture(frame, "$parentLine", "OVERLAY", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(region, 1, 1)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 0, 0)
	region:Hide()

	previous = PallyPowerUI.CreateTexture(frame, "$parentLineA", "OVERLAY", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(previous, 1, 1)
	PallyPowerUI.SetPoint(previous, "TOPLEFT", frame, "TOPLEFT", layout.PALADIN_INFO_WIDTH, 0)
	previous:Hide()

	region = PallyPowerUI.CreateTexture(frame, "$parentLine2", "OVERLAY", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(region, 1, 1)
	PallyPowerUI.SetPoint(region, "TOPLEFT", previous, "TOPLEFT", layout.COLUMN_WIDTH, 0)
	region:Hide()
	previous = region

	region = PallyPowerUI.CreateTexture(frame, "$parentLineJ", "OVERLAY", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(region, 1, 1)
	PallyPowerUI.SetPoint(region, "TOPLEFT", previous, "TOPLEFT", layout.COLUMN_WIDTH, 0)
	region:Hide()
	previous = region

	for i = 3, 13 do
		region = PallyPowerUI.CreateTexture(frame, "$parentLine" .. i, "OVERLAY", "Interface\\Tooltips\\UI-Tooltip-Background")
		PallyPowerUI.SetSize(region, 1, 1)
		PallyPowerUI.SetPoint(region, "TOPLEFT", previous, "TOPLEFT", layout.COLUMN_WIDTH, 0)
		region:Hide()
		previous = region
	end

	for i = 0, 5 do
		PallyPowerUI.CreatePPPaladinRowSkill(frame, i)
	end

	region = PallyPowerUI.CreateFontString(frame, "$parentInGroup", "OVERLAY", "GameFontNormalSmall")
	PallyPowerUI.SetSize(region, 18, 14)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 4, -3)
	region:SetText("")
	region:SetJustifyH("LEFT")
	frame.ppInGroup = region

	region = PallyPowerUI.CreateTexture(frame, "$parentIconHOJ", "OVERLAY", "Interface\\Icons\\Spell_Holy_SealOfMight")
	PallyPowerUI.SetSize(region, 16, 16)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 128, -2)
	frame.ppHOJ = region

	region = PallyPowerUI.CreateTexture(frame, "$parentIconLH", "OVERLAY", "Interface\\Icons\\Spell_Holy_LayOnHands")
	PallyPowerUI.SetSize(region, 16, 16)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 146, -2)
	frame.ppLH = region

	region = PallyPowerUI.CreateTexture(frame, "$parentIconDI", "OVERLAY", "Interface\\Icons\\Spell_Nature_TimeStop")
	PallyPowerUI.SetSize(region, 16, 16)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 164, -2)
	frame.ppDI = region
	frame.ppAssignments = {}

	region = PallyPowerUI.CreateFrame("Button", "$parentBlessingHover", frame)
	region.ppRow = frame
	PallyPowerUI.SetSize(region, 118, 18)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 3, -24)
	region:EnableMouse(true)
	region:SetScript("OnEnter", function()
		PallyPower_ShowBlessingCapabilities(this)
	end)
	region:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	cell = PallyPowerUI.CreatePPPaladinRowAssignment(frame, "A")
	frame.ppAssignments.A = cell
	cell.ppRow = frame
	PallyPowerUI.SetPoint(cell, "TOPLEFT", frame, "TOPLEFT", layout.ASSIGNMENT_ICON_LEFT, -layout.ASSIGNMENT_ICON_TOP)
	cell:SetScript("OnEnter", function()
		PallyPower_ShowAuraCapabilities(this)
	end)
	cell:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	cell = PallyPowerUI.CreatePPPaladinRowAssignment(frame, "R")
	frame.ppAssignments.R = cell
	cell.ppRow = frame
	PallyPowerUI.SetPoint(cell, "TOPLEFT", frame.ppAssignments.A, "TOPLEFT", layout.SELF_BUFF_PITCH, 0)
	region = PallyPowerUI.CreateFontString(cell, "$parentNoRF", "OVERLAY", "GameFontNormalLarge")
	PallyPowerUI.SetSize(region, 24, 24)
	PallyPowerUI.SetPoint(region, "CENTER", cell.ppIcon, "CENTER", 0, 0)
	region:SetText("X")
	region:SetJustifyH("CENTER")
	region:SetJustifyV("MIDDLE")
	PallyPowerUI.SetFontStyle(region, 20, "THICK")
	region:SetTextColor(1, 0, 0)
	region:Hide()
	cell.ppLegacyNoRF = region
	cell.ppNoRF = region

	cell = PallyPowerUI.CreatePPPaladinRowAssignment(frame, "S")
	frame.ppAssignments.S = cell
	cell.ppRow = frame
	PallyPowerUI.SetPoint(cell, "TOPLEFT", frame.ppAssignments.R, "TOPLEFT", layout.SELF_BUFF_PITCH, 0)
	cell:SetScript("OnEnter", function()
		PallyPower_ShowAllSealCapabilities(this)
	end)
	cell:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	cell = PallyPowerUI.CreatePPPaladinRowAssignment(frame, "J")
	frame.ppAssignments.J = cell
	cell.ppRow = frame
	PallyPowerUI.SetPoint(cell, "TOPLEFT", frame.ppAssignments.S, "TOPLEFT", layout.SELF_BUFF_PITCH, 0)
	cell:SetScript("OnEnter", function()
		PallyPower_ShowSealCapabilities(this)
	end)
	cell:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	cell = PallyPowerUI.CreatePPPaladinRowAssignment(frame, "0")
	frame.ppAssignments[0] = cell
	cell.ppRow = frame
	PallyPowerUI.SetPoint(cell, "TOPLEFT", frame.ppAssignments.J, "TOPLEFT", layout.CLASS_PITCH, 0)
	previous = cell
	for i = 1, 9 do
		cell = PallyPowerUI.CreatePPPaladinRowAssignment(frame, tostring(i))
		frame.ppAssignments[i] = cell
		cell.ppRow = frame
		PallyPowerUI.SetPoint(cell, "TOPLEFT", previous, "TOPLEFT", layout.CLASS_PITCH, 0)
		previous = cell
	end

	return frame
end

function PallyPowerUI.CreateAssignmentLinker(frame, key, r, g, b)
	local linker = PallyPowerUI.CreateTexture(frame, nil, "ARTWORK", "Interface\\Tooltips\\UI-Tooltip-Background")
	local fade = PallyPowerUI.CreateTexture(frame, nil, "ARTWORK", "Interface\\Tooltips\\UI-Tooltip-Background")
	linker:SetWidth(8)
	linker:SetVertexColor(r, g, b)
	linker.ppLinkR = r
	linker.ppLinkG = g
	linker.ppLinkB = b
	linker.ppFade = fade
	linker:Hide()
	fade:SetWidth(8)
	fade:Hide()
	PallyPowerUIRefs.assignmentLinkers[key] = linker
	return linker
end

function PallyPowerUI.NormalizeAssignmentLinkWidth(value)
	local width = tonumber(value) or 8
	width = math.floor(width + 0.5)
	if width < 1 then width = 1 end
	if width > 16 then width = 16 end
	return width
end

function PallyPowerUI.SetAssignmentLinkWidth(value)
	local width = PallyPowerUI.NormalizeAssignmentLinkWidth(value)
	local key
	local linker
	for key, linker in pairs(PallyPowerUIRefs.assignmentLinkers) do
		linker:SetWidth(width)
		if linker.ppFade then linker.ppFade:SetWidth(width) end
	end
	return width
end

function PallyPowerUI.NormalizeAssignmentSpacing(value, defaultValue)
	local spacing = tonumber(value)
	if spacing == nil then spacing = defaultValue end
	spacing = math.floor(spacing + 0.5)
	if spacing < 0 then spacing = 0 end
	if spacing > PallyPowerUI.AssignmentLayout.SPACING_MAX then
		spacing = PallyPowerUI.AssignmentLayout.SPACING_MAX
	end
	return spacing
end

function PallyPowerUI.ApplyAssignmentSpacing()
	local layout = PallyPowerUI.AssignmentLayout
	local selfSpacing = PallyPowerUI.NormalizeAssignmentSpacing(
		PP_PerUser and PP_PerUser.assignmentselfbuffspacing,
		layout.SELF_BUFF_SPACING_DEFAULT
	)
	local classSpacing = PallyPowerUI.NormalizeAssignmentSpacing(
		PP_PerUser and PP_PerUser.assignmentclassspacing,
		layout.CLASS_SPACING_DEFAULT
	)
	local refs = PallyPowerUIRefs
	local specialKeys = {"A", "R", "S", "J"}
	local specialOffset
	local classOffset
	local i
	local j
	local key
	local icon
	local previousIcon
	local group
	local row
	local cell
	local button

	layout.SELF_BUFF_SPACING = selfSpacing
	layout.CLASS_SPACING = classSpacing
	layout.SELF_BUFF_PITCH = layout.CELL_SIZE + selfSpacing
	layout.CLASS_PITCH = layout.CELL_SIZE + classSpacing
	layout.ASSIGNMENT_ICON_LEFT = layout.PALADIN_INFO_WIDTH + layout.FIRST_ASSIGNMENT_GAP
	layout.ROW_WIDTH =
		layout.PALADIN_INFO_WIDTH +
		layout.FIRST_ASSIGNMENT_GAP +
		layout.CELL_SIZE +
		(3 * layout.SELF_BUFF_PITCH) +
		(10 * layout.CLASS_PITCH) +
		layout.FIRST_ASSIGNMENT_GAP
	layout.FRAME_WIDTH = (2 * layout.LEFT_MARGIN) + layout.ROW_WIDTH
	layout.HEADER_FIRST_ICON_LEFT = layout.LEFT_MARGIN + layout.ASSIGNMENT_ICON_LEFT

	if layout.APPLIED_SELF_BUFF_SPACING == selfSpacing
		and layout.APPLIED_CLASS_SPACING == classSpacing then
		if PallyPowerFrame then
			PallyPowerFrame:SetWidth(layout.FRAME_WIDTH)
		end
		return selfSpacing, classSpacing
	end

	layout.APPLIED_SELF_BUFF_SPACING = selfSpacing
	layout.APPLIED_CLASS_SPACING = classSpacing

	if not PallyPowerFrame then
		return selfSpacing, classSpacing
	end

	icon = refs.classIcons.A
	if icon then
		icon:ClearAllPoints()
		PallyPowerUI.SetPoint(icon, "TOPLEFT", PallyPowerFrame, "TOPLEFT", layout.HEADER_FIRST_ICON_LEFT, -layout.HEADER_ICON_TOP)
	end

	previousIcon = icon
	for i = 2, 4 do
		key = specialKeys[i]
		icon = refs.classIcons[key]
		if icon and previousIcon then
			icon:ClearAllPoints()
			PallyPowerUI.SetPoint(icon, "TOPLEFT", previousIcon, "TOPLEFT", layout.SELF_BUFF_PITCH, 0)
		end
		previousIcon = icon
	end

	for i = 0, 9 do
		icon = refs.classIcons[i]
		if icon and previousIcon then
			icon:ClearAllPoints()
			PallyPowerUI.SetPoint(icon, "TOPLEFT", previousIcon, "TOPLEFT", layout.CLASS_PITCH, 0)
		end
		previousIcon = icon
	end

	specialOffset = (layout.SELF_BUFF_PITCH - layout.CELL_SIZE) / 2
	for i = 1, 4 do
		key = specialKeys[i]
		group = refs.specialGroups[key]
		icon = refs.classIcons[key]
		if group and icon then
			group:SetWidth(layout.SELF_BUFF_PITCH)
			group:ClearAllPoints()
			PallyPowerUI.SetPoint(group, "TOPLEFT", icon, "BOTTOMLEFT", -specialOffset, -12)
		end
	end

	classOffset = (layout.CLASS_PITCH - layout.CELL_SIZE) / 2
	for i = 1, 10 do
		group = refs.classGroups[i]
		icon = refs.classIcons[i - 1]
		if group and icon then
			group:SetWidth(layout.FLYOUT_WIDTH)
			group:ClearAllPoints()
			PallyPowerUI.SetPoint(group, "BOTTOM", icon, "TOP", 0, layout.FLYOUT_GAP)
			for j = 1, 15 do
				button = group.playerButtons and group.playerButtons[j]
				if button then
					button:SetWidth(layout.FLYOUT_WIDTH - (2 * layout.FLYOUT_INSET))
					button:ClearAllPoints()
					PallyPowerUI.SetPoint(
						button, "BOTTOMLEFT", group, "BOTTOMLEFT",
						layout.FLYOUT_INSET,
						layout.FLYOUT_INSET + (layout.PLAYER_LABEL_HEIGHT * (j - 1))
					)
					PallyPowerUI.AlignPlayerOverrideContent(button)
				end
			end
		end
	end

	for i = 1, 12 do
		row = refs.playerRows[i]
		if row and row.ppAssignments then
			row:SetWidth(layout.ROW_WIDTH)
			cell = row.ppAssignments.A
			if cell then
				cell:ClearAllPoints()
				PallyPowerUI.SetPoint(cell, "TOPLEFT", row, "TOPLEFT", layout.ASSIGNMENT_ICON_LEFT, -layout.ASSIGNMENT_ICON_TOP)
			end
			previousIcon = cell
			for j = 2, 4 do
				key = specialKeys[j]
				cell = row.ppAssignments[key]
				if cell and previousIcon then
					cell:ClearAllPoints()
					PallyPowerUI.SetPoint(cell, "TOPLEFT", previousIcon, "TOPLEFT", layout.SELF_BUFF_PITCH, 0)
				end
				previousIcon = cell
			end
			for j = 0, 9 do
				cell = row.ppAssignments[j]
				if cell and previousIcon then
					cell:ClearAllPoints()
					PallyPowerUI.SetPoint(cell, "TOPLEFT", previousIcon, "TOPLEFT", layout.CLASS_PITCH, 0)
				end
				previousIcon = cell
			end
		end
	end

	PallyPowerFrame:SetWidth(layout.FRAME_WIDTH)
	return selfSpacing, classSpacing
end

function PallyPowerUI.UpdateAssignmentLinkers(numPallys)
	local columns = {"A", "R", "S", "J", 0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
	local width = PallyPowerUI.NormalizeAssignmentLinkWidth(
		PP_PerUser and PP_PerUser.assignmentlinkwidth or 8
	)
	local i
	local rowIndex
	local key
	local linker
	local fade
	local headerIcon
	local lowestIcon
	local lastVisibleIcon
	local row
	local cell
	local icon
	local texture

	for i = 1, 14 do
		key = columns[i]
		linker = PallyPowerUIRefs.assignmentLinkers[key]
		fade = linker and linker.ppFade
		headerIcon = PallyPowerUIRefs.classIcons[key]
		lowestIcon = nil
		lastVisibleIcon = nil

		for rowIndex = 1, numPallys do
			row = PallyPowerUIRefs.playerRows[rowIndex]
			cell = row and row.ppAssignments and row.ppAssignments[key]
			icon = cell and cell.ppIcon
			if icon then
				lastVisibleIcon = icon
				texture = icon:GetTexture()
				if texture and texture ~= "" then
					lowestIcon = icon
					if cell.ppIconBorder then cell.ppIconBorder:Show() end
				elseif cell.ppIconBorder then
					cell.ppIconBorder:Hide()
				end
			end
		end

		if linker and headerIcon and lowestIcon then
			linker:ClearAllPoints()
			linker:SetWidth(width)
			linker:SetVertexColor(linker.ppLinkR, linker.ppLinkG, linker.ppLinkB)
			linker:SetAlpha(1)
			PallyPowerUI.SetPoint(linker, "TOP", headerIcon, "CENTER", 0, 0)
			PallyPowerUI.SetPoint(linker, "BOTTOM", lowestIcon, "CENTER", 0, 0)
			linker:Show()
			if fade then fade:Hide() end
		elseif linker and headerIcon and lastVisibleIcon and numPallys > 0 then
			linker:ClearAllPoints()
			linker:SetWidth(width)
			linker:SetVertexColor(0.35, 0.35, 0.35)
			linker:SetAlpha(0.75)
			PallyPowerUI.SetPoint(linker, "TOP", headerIcon, "CENTER", 0, 0)
			PallyPowerUI.SetPoint(linker, "BOTTOM", lastVisibleIcon, "TOP", 0, 0)
			linker:Show()

			if fade then
				fade:ClearAllPoints()
				fade:SetWidth(width)
				PallyPowerUI.SetPoint(fade, "TOP", lastVisibleIcon, "TOP", 0, 0)
				PallyPowerUI.SetPoint(fade, "BOTTOM", lastVisibleIcon, "BOTTOM", 0, 0)
				fade:SetGradientAlpha(
					"VERTICAL",
					0.35, 0.35, 0.35, 0,
					0.35, 0.35, 0.35, 0.75
				)
				fade:Show()
			end
		elseif linker then
			linker:Hide()
			if fade then fade:Hide() end
		end
	end

	for rowIndex = numPallys + 1, 12 do
		row = PallyPowerUIRefs.playerRows[rowIndex]
		if row and row.ppAssignments then
			for i = 1, 14 do
				cell = row.ppAssignments[columns[i]]
				if cell and cell.ppIconBorder then cell.ppIconBorder:Hide() end
			end
		end
	end
end

function PallyPowerUI.UpdateAssignmentGeometry(numPallys, numMaxClass)
	local layout = PallyPowerUI.AssignmentLayout
	PallyPowerUI.ApplyAssignmentSpacing()
	local headerHeight = layout.HEADER_BASE_HEIGHT
	local i

	PallyPowerFrame:SetWidth(layout.FRAME_WIDTH)
	PallyPowerFrame:SetHeight(headerHeight + (numPallys * layout.ROW_HEIGHT) + layout.FOOTER_HEIGHT)

	PallyPowerUIRefs.playerRows[1]:ClearAllPoints()
	PallyPowerUI.SetPoint(
		PallyPowerUIRefs.playerRows[1], "TOPLEFT",
		PallyPowerFrame, "TOPLEFT",
		layout.LEFT_MARGIN, -headerHeight
	)

	for i = 1, 12 do
		if i <= numPallys then
			PallyPowerUIRefs.playerRows[i]:Show()
		else
			PallyPowerUIRefs.playerRows[i]:Hide()
		end
	end

	PallyPowerUI.UpdateAssignmentLinkers(numPallys)
end

-- ============================================================================
-- STAGE 5 ASSIGNMENT UI
-- ============================================================================

function PallyPowerUI.CreateAssignmentToolbarButton(frame, name, x, textureFile, onClick)
	local button = PallyPowerUI.CreateFrame("Button", name, frame)
	local texture

	PallyPowerUI.SetSize(button, 20, 20)
	PallyPowerUI.SetPoint(button, "TOPRIGHT", frame, "TOPRIGHT", x, -6)

	button:SetNormalTexture(textureFile)
	texture = button:GetNormalTexture()
	texture:ClearAllPoints()
	PallyPowerUI.SetSize(texture, 18, 18)
	PallyPowerUI.SetPoint(texture, "CENTER", button, "CENTER", 0, 0)

	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
	texture = button:GetHighlightTexture()
	texture:SetBlendMode("ADD")

	if onClick then
		button:SetScript("OnClick", onClick)
	end

	return button
end

function PallyPowerUI.CreateAssignmentEyeButton(frame, name, relativeTo, onClick, tooltipText)
	local button = PallyPowerUI.CreateFrame("Button", name, frame)
	local icon

	PallyPowerUI.SetSize(button, 18, 18)
	PallyPowerUI.SetPoint(button, "BOTTOMRIGHT", relativeTo, "BOTTOMRIGHT", 1, -1)

	icon = PallyPowerUI.CreateTexture(
		button, "$parentIcon", "ARTWORK",
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\visibility-on.tga"
	)
	PallyPowerUI.SetSize(icon, 18, 18)
	PallyPowerUI.SetPoint(icon, "CENTER", button, "CENTER", 0, 0)

	button:SetScript("OnClick", onClick)
	button:SetScript("OnEnter", function()
		PallyPower_VisibilityEye_OnEnter(this, tooltipText)
	end)
	button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	return button
end

function PallyPowerUI.CreateAssignmentUI()
	local layout = PallyPowerUI.AssignmentLayout
	local frame = PallyPowerUI.CreateFrame("Frame", "PallyPowerFrame", UIParent)
	local region
	local previous
	local button
	local checkButton
	local label
	local group
	local row
	local oldThis
	local classTextures = {
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\class-warrior.tga",
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\class-rogue.tga",
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\class-priest.tga",
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\class-druid.tga",
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\class-paladin.tga",
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\class-hunter.tga",
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\class-mage.tga",
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\class-warlock.tga",
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\class-shaman.tga",
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\class-pet.tga",
	}
	local classLinkColors = {
		{0.78, 0.61, 0.43},
		{1.00, 0.96, 0.41},
		{1.00, 1.00, 1.00},
		{1.00, 0.49, 0.04},
		{0.96, 0.55, 0.73},
		{0.67, 0.83, 0.45},
		{0.41, 0.80, 0.94},
		{0.58, 0.51, 0.79},
		{0.00, 0.44, 0.87},
		{0.78, 0.61, 0.43},
	}
	local color
	local i

	PallyPowerUI.SetSize(frame, layout.FRAME_WIDTH, 980)
	PallyPowerUI.SetPoint(frame, "TOPLEFT", UIParent, "BOTTOMLEFT", 400, 400)
	frame:SetToplevel(true)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:Hide()
	PallyPowerUI.SetBackdrop(
		frame,
		"Interface\\Tooltips\\UI-Tooltip-Background",
		"Interface\\Tooltips\\UI-Tooltip-Border",
		true, 16, 16, 5, 5, 5, 5
	)

	PallyPowerUI.CreateAssignmentLinker(frame, "A", 0.96, 0.55, 0.73)
	PallyPowerUI.CreateAssignmentLinker(frame, "R", 0.96, 0.55, 0.73)
	PallyPowerUI.CreateAssignmentLinker(frame, "S", 0.96, 0.55, 0.73)
	PallyPowerUI.CreateAssignmentLinker(frame, "J", 0.96, 0.55, 0.73)
	for i = 0, 9 do
		color = classLinkColors[i + 1]
		PallyPowerUI.CreateAssignmentLinker(frame, i, color[1], color[2], color[3])
	end

	-- Preserve legacy named separator regions as hidden compatibility objects.
	region = PallyPowerUI.CreateTexture(frame, "$parentHeaderSeparator", "ARTWORK", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(region, 1, 1)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 0, 0)
	region:Hide()

	region = PallyPowerUI.CreateTexture(frame, "$parentFooterSeparator", "ARTWORK", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(region, 1, 1)
	PallyPowerUI.SetPoint(region, "BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
	region:Hide()

	previous = PallyPowerUI.CreateTexture(frame, "$parentLineA", "ARTWORK", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(previous, 1, 1)
	PallyPowerUI.SetPoint(previous, "TOPLEFT", frame, "TOPLEFT", 0, 0)
	previous:Hide()

	region = PallyPowerUI.CreateTexture(frame, "$parentLineR", "ARTWORK", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(region, 1, 1)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 0, 0)
	region:Hide()
	previous = region

	region = PallyPowerUI.CreateTexture(frame, "$parentLineS", "ARTWORK", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(region, 1, 1)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 0, 0)
	region:Hide()
	previous = region

	region = PallyPowerUI.CreateTexture(frame, "$parentLineJ", "ARTWORK", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(region, 1, 1)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 0, 0)
	region:Hide()
	previous = region

	region = PallyPowerUI.CreateTexture(frame, "$parentLine2", "ARTWORK", "Interface\\Tooltips\\UI-Tooltip-Background")
	PallyPowerUI.SetSize(region, 1, 1)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 0, 0)
	region:Hide()
	previous = region

	for i = 3, 12 do
		region = PallyPowerUI.CreateTexture(frame, "$parentLine" .. i, "ARTWORK", "Interface\\Tooltips\\UI-Tooltip-Background")
		PallyPowerUI.SetSize(region, 1, 1)
		PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", 0, 0)
		region:Hide()
		previous = region
	end

	region = PallyPowerUI.CreateTexture(
		frame, "$parentClassA", "ARTWORK",
		"Interface\\Icons\\Spell_Holy_AuraMastery"
	)
	PallyPowerUI.SetSize(region, 32, 32)
	PallyPowerUI.SetPoint(region, "TOPLEFT", frame, "TOPLEFT", layout.HEADER_FIRST_ICON_LEFT, -layout.HEADER_ICON_TOP)
	PallyPowerUIRefs.classIcons.A = region
	PallyPowerUI.CreateIconBorderFrame(frame, region, 32, 32)

	region = PallyPowerUI.CreateTexture(
		frame, "$parentClassR", "ARTWORK",
		"Interface\\Icons\\Spell_Holy_SealOfFury"
	)
	PallyPowerUI.SetSize(region, 32, 32)
	PallyPowerUI.SetPoint(region, "TOPLEFT", PallyPowerUIRefs.classIcons.A, "TOPLEFT", layout.SELF_BUFF_PITCH, 0)
	PallyPowerUIRefs.classIcons.R = region
	PallyPowerUI.CreateIconBorderFrame(frame, region, 32, 32)

	region = PallyPowerUI.CreateTexture(
		frame, "$parentClassS", "ARTWORK",
		"Interface\\Icons\\Ability_Thunderbolt"
	)
	PallyPowerUI.SetSize(region, 32, 32)
	PallyPowerUI.SetPoint(region, "TOPLEFT", PallyPowerUIRefs.classIcons.R, "TOPLEFT", layout.SELF_BUFF_PITCH, 0)
	PallyPowerUIRefs.classIcons.S = region
	PallyPowerUI.CreateIconBorderFrame(frame, region, 32, 32)

	region = PallyPowerUI.CreateTexture(
		frame, "$parentClassJ", "ARTWORK",
		"Interface\\Icons\\Spell_Holy_RighteousFury"
	)
	PallyPowerUI.SetSize(region, 32, 32)
	PallyPowerUI.SetPoint(region, "TOPLEFT", PallyPowerUIRefs.classIcons.S, "TOPLEFT", layout.SELF_BUFF_PITCH, 0)
	PallyPowerUIRefs.classIcons.J = region
	PallyPowerUI.CreateIconBorderFrame(frame, region, 32, 32)

	for i = 0, 9 do
		region = PallyPowerUI.CreateTexture(frame, "$parentClass" .. i, "ARTWORK", classTextures[i + 1])
		PallyPowerUI.SetSize(region, 32, 32)
		if i == 0 then
			PallyPowerUI.SetPoint(
				region, "TOPLEFT",
				PallyPowerUIRefs.classIcons.J,
				"TOPLEFT", layout.CLASS_PITCH, 0
			)
		else
			PallyPowerUI.SetPoint(
				region, "TOPLEFT",
				PallyPowerUIRefs.classIcons[i - 1],
				"TOPLEFT", layout.CLASS_PITCH, 0
			)
		end
		PallyPowerUIRefs.classIcons[i] = region
		PallyPowerUI.CreateClassHeaderButton(frame, i, region, classLinkColors[i + 1])
	end

	PallyPowerUI.CreateAssignmentEyeButton(
		frame, "$parentAuraEye", PallyPowerFrameClassA,
		function() PallyPower_AuraEye_OnClick() end,
		PALLYPOWER_TOOLTIP_AURA_ON_BUFF_BAR
	)
	PallyPowerUI.CreateAssignmentEyeButton(
		frame, "$parentRFEye", PallyPowerFrameClassR,
		function() PallyPower_RFEye_OnClick() end,
		PALLYPOWER_TOOLTIP_RF_ON_BUFF_BAR
	)
	PallyPowerUI.CreateAssignmentEyeButton(
		frame, "$parentSealEye", PallyPowerFrameClassS,
		function() PallyPower_SealEye_OnClick() end,
		PALLYPOWER_TOOLTIP_SEAL_ON_BUFF_BAR
	)
	PallyPowerUI.CreateAssignmentEyeButton(
		frame, "$parentJudgementEye", PallyPowerFrameClassJ,
		function() PallyPower_JudgementEye_OnClick() end,
		PALLYPOWER_TOOLTIP_JUDGEMENT_ON_BUFF_BAR
	)

	button = PallyPowerUI.CreateFrame("Button", "$parentTitle", frame)
	PallyPowerUI.SetSize(button, 640, 20)
	PallyPowerUI.SetPoint(button, "TOPLEFT", frame, "TOPLEFT", 8, -7)

	label = PallyPowerUI.CreateFontString(button, "$parentText", "OVERLAY", "GameFontNormalLarge")
	PallyPowerUI.SetSize(label, 420, 18)
	PallyPowerUI.SetPoint(label, "LEFT", button, "LEFT", 8, 0)
	label:SetText(PALLYPOWER_UI_ASSIGNMENTS_TITLE)
	label:SetJustifyH("LEFT")

	button:SetScript("OnEnter", function()
		PallyPower_ShowVersionTooltip()
	end)
	button:SetScript("OnLeave", function()
		HideUIPanel(GameTooltip)
	end)
	button:SetScript("OnMouseDown", function()
		PallyPowerFrame_MouseDown(arg1)
	end)
	button:SetScript("OnMouseUp", function()
		PallyPowerFrame_MouseUp()
	end)
	button:SetScript("OnUpdate", function()
		PallyPowerGrid_Update(arg1)
	end)

	PallyPowerUI.CreateAssignmentToolbarButton(
		frame, "$parentCloseButton", -6,
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\close.tga",
		function() HideUIPanel(this:GetParent()) end
	)

	checkButton = PallyPowerUI.CreateFrame("CheckButton", "FreeAssignOptionChk", frame, "OptionsCheckButtonTemplate")
	PallyPowerUI.SetSize(checkButton, 20, 20)
	PallyPowerUI.SetPoint(checkButton, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", -104, 6)

	label = PallyPowerUI.CreateFontString(checkButton, "PallyPowerFrameTitleFreeAssignText", "OVERLAY", "GameFontHighlightSmall")
	PallyPowerUI.SetSize(label, 92, 16)
	PallyPowerUI.SetPoint(label, "LEFT", checkButton, "RIGHT", 2, 0)
	label:SetText(PALLYPOWER_FREEASSIGN)
	label:SetJustifyH("LEFT")

	checkButton:SetScript("OnShow", function()
		if PP_PerUser.freeassign then this:SetChecked(true) else this:SetChecked(false) end
	end)
	checkButton:SetScript("OnClick", function()
		PP_PerUser.freeassign = this:GetChecked()
		PallyPower_FreeAssignOption()
	end)
	checkButton:SetScript("OnEnter", function()
		GameTooltip:SetOwner(this, "ANCHOR_BOTTOM")
		GameTooltip:SetText(PALLYPOWER_FREEASSIGN_DESC)
		GameTooltip:Show()
	end)
	checkButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	checkButton = PallyPowerUI.CreateFrame("CheckButton", "PP_UI_SmartButton", frame, "OptionsCheckButtonTemplate")
	PallyPowerUI.SetSize(checkButton, 20, 20)
	PallyPowerUI.SetPoint(checkButton, "BOTTOMRIGHT", FreeAssignOptionChk, "BOTTOMLEFT", -118, 0)

	label = PallyPowerUI.CreateFontString(checkButton, "PP_UI_SmartLabel", "OVERLAY", "GameFontHighlightSmall")
	PallyPowerUI.SetSize(label, 75, 16)
	PallyPowerUI.SetPoint(label, "LEFT", checkButton, "RIGHT", 2, 0)
	label:SetText(PALLYPOWER_OPTIONS_SMARTBUFFS)
	label:SetJustifyH("LEFT")

	checkButton:SetScript("OnShow", function()
		this:SetChecked(PP_PerUser.smartbuffs)
	end)
	checkButton:SetScript("OnClick", function()
		PallyPower_OptionsFrameSmart:SetChecked(this:GetChecked())
		PallyPower_SmartBuffsOption()
	end)

	PallyPowerUI.CreateAssignmentToolbarButton(
		frame, "$parentRefresh", -29,
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\rotate.tga",
		function() PallyPower_Refresh() end
	)

	button = PallyPowerUI.CreatePPResizeGripTemplate("$parentResizeButton", frame)
	PallyPowerUI.SetPoint(button, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)

	PallyPowerUI.CreateAssignmentToolbarButton(
		frame, "$parentClear", -52,
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\bin.tga",
		function() PallyPower_ConfirmClear() end
	)
	PallyPowerUI.CreateAssignmentToolbarButton(
		frame, "$parentOptions", -75,
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\config.tga",
		function() PallyPower_Options() end
	)
	PallyPowerUI.CreateAssignmentToolbarButton(
		frame, "$parentResetPosition", -98,
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\position.tga",
		function() PallyPower_ResetPosition() end
	)

	PallyPowerUI.CreateAssignmentToolbarButton(
		frame, "PP_UI_LockButton", -213,
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\lock.tga"
	)
	PallyPowerUI.CreateAssignmentToolbarButton(
		frame, "PP_UI_VerboseButton", -190,
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\text.tga"
	)
	PallyPowerUI.CreateAssignmentToolbarButton(
		frame, "PP_UI_SoundButton", -167,
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\sound.tga"
	)
	PallyPowerUI.CreateAssignmentToolbarButton(
		frame, "PP_UI_OrientationButton", -144,
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\orientation.tga"
	)
	PallyPowerUI.CreateAssignmentToolbarButton(
		frame, "PP_UI_FeedbackButton", -121,
		"Interface\\AddOns\\PallyPowerVanilla\\assets\\announce.tga"
	)

	button = PallyPowerUI.CreateFrame("Button", "$parentPresets", frame, "GameMenuButtonTemplate")
	PallyPowerUI.SetSize(button, 86, 22)
	PallyPowerUI.SetPoint(button, "TOPLEFT", frame, "TOPLEFT", 28, -47)
	button:SetText(PALLYPOWER_PRESETS)
	button:SetScript("OnClick", function()
		PallyPower_PresetsClick()
	end)

	group = PallyPowerUI.CreatePPSpecialColumnTemplate("$parentClassGroupA", frame)
	PallyPowerUI.SetPoint(group, "TOPLEFT", PallyPowerFrameClassA, "BOTTOMLEFT", -25, -12)
	PallyPowerUIRefs.specialGroups.A = group

	group = PallyPowerUI.CreatePPSpecialColumnTemplate("$parentClassGroupR", frame)
	PallyPowerUI.SetPoint(group, "TOPLEFT", PallyPowerFrameClassR, "BOTTOMLEFT", -25, -12)
	PallyPowerUIRefs.specialGroups.R = group

	group = PallyPowerUI.CreatePPSpecialColumnTemplate("$parentClassGroupS", frame)
	PallyPowerUI.SetPoint(group, "TOPLEFT", PallyPowerFrameClassS, "BOTTOMLEFT", -25, -12)
	PallyPowerUIRefs.specialGroups.S = group

	group = PallyPowerUI.CreatePPSpecialColumnTemplate("$parentClassGroupJ", frame)
	PallyPowerUI.SetPoint(group, "TOPLEFT", PallyPowerFrameClassJ, "BOTTOMLEFT", -25, -12)
	PallyPowerUIRefs.specialGroups.J = group

	checkButton = PallyPowerUI.CreateFrame("CheckButton", "$parentJudgementFailedRefresh", frame, "UICheckButtonTemplate")
	PallyPowerUI.SetSize(checkButton, 20, 20)
	PallyPowerUI.SetPoint(checkButton, "TOPRIGHT", PallyPowerFrameClassJ, "TOPRIGHT", 9, 9)
	checkButton:SetScript("OnClick", function()
		PallyPower_JudgementFailedRefreshOption()
	end)
	checkButton:SetScript("OnEnter", function()
		PallyPower_JudgementFailedRefresh_OnEnter(this)
	end)
	checkButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	for i = 1, 10 do
		group = PallyPowerUI.CreatePPClassColumnTemplate("$parentClassGroup" .. i, frame)
		PallyPowerUI.SetPoint(
			group, "BOTTOM",
			PallyPowerUIRefs.classIcons[i - 1],
			"TOP", 0, layout.FLYOUT_GAP
		)
		PallyPowerUIRefs.classGroups[i] = group
	end

	for i = 1, 12 do
		row = PallyPowerUI.CreatePPPaladinRowTemplate("$parentPlayer" .. i, frame)
		row.ppIndex = i
		PallyPowerUIRefs.playerRows[i] = row
		if i == 1 then
			PallyPowerUI.SetPoint(
				row, "TOPLEFT", frame, "TOPLEFT",
				layout.LEFT_MARGIN, -layout.HEADER_BASE_HEIGHT
			)
		else
			PallyPowerUI.SetPoint(
				row, "TOPLEFT",
				PallyPowerUIRefs.playerRows[i - 1],
				"BOTTOMLEFT", 0, 0
			)
		end
	end

	PallyPowerUI.ApplyAssignmentSpacing()

	frame:SetScript("OnEvent", function()
		PallyPower_OnEvent(event, arg1)
	end)
	frame:SetScript("OnMouseUp", function()
		PallyPowerFrame_MouseUp()
	end)
	frame:SetScript("OnMouseDown", function()
		PallyPowerFrame_MouseDown(arg1)
	end)
	frame:SetScript("OnHide", function()
		if this.isMoving then
			this:StopMovingOrSizing()
			this.isMoving = false
		end
	end)

	-- XML supplied the implicit global 'this' while PallyPower_OnLoad() registered
	-- events. Recreate that exact context once for the Lua-created main frame.
	oldThis = this
	this = frame
	PallyPower_OnLoad()
	this = oldThis

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
	button:SetNormalTexture("Interface\\AddOns\\PallyPowerVanilla\\assets\\minimap.tga")
	button:SetPushedTexture("Interface\\AddOns\\PallyPowerVanilla\\assets\\minimap-down.tga")
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
	local okayButton

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
	local headerTexture = region

	region = PallyPowerUI.CreateFontString(frame, "$parentTitle", "ARTWORK", "GameFontNormal")
	PallyPowerUI.SetPoint(region, "TOP", headerTexture, "TOP", 0, -14)
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
	local headerTexture = region

	region = PallyPowerUI.CreateFontString(frame, "$parentTitle", "ARTWORK", "GameFontNormal")
	PallyPowerUI.SetPoint(region, "TOP", headerTexture, "TOP", 0, -14)
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
			okayButton:Disable()
			PallyPowerSaveMenuHelp:SetText(PALLYPOWER_TEXT_MUSTENTER)
			PallyPowerSaveMenuHelp:Show()
		elseif PallyPower_SetExists(this:GetText()) then
			okayButton:Enable()
			PallyPowerSaveMenuHelp:SetText(PALLYPOWER_TEXT_OVERWRITE)
			PallyPowerSaveMenuHelp:Show()
		else
			okayButton:Enable()
			PallyPowerSaveMenuHelp:Hide()
		end
	end)
	editBox:SetScript("OnEscapePressed", function()
		HideUIPanel(this:GetParent())
	end)

	button = CreateFrame("Button", "PallyPowerSaveMenuOkayButton", frame, "GameMenuButtonTemplate")
	okayButton = button
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

-- ============================================================================
-- STAGE 3 ADVANCED OPTIONS UI
-- ============================================================================

function PallyPowerUI.CreateAdvancedOptionsLabel(frame, name, inherits, text, width, height, point, x, y, justifyH, r, g, b)
	local label = PallyPowerUI.CreateFontString(frame, name, "OVERLAY", inherits)

	PallyPowerUI.SetSize(label, width, height)
	PallyPowerUI.SetPoint(label, point, frame, point, x, y)
	if text then
		label:SetText(text)
	end
	if justifyH then
		label:SetJustifyH(justifyH)
	end
	if r then
		label:SetTextColor(r, g, b)
	end

	return label
end

function PallyPowerUI.CreateAdvancedOptionsScanEditBox(frame, suffix, y, optionKey, focusOther)
	local editBox = PallyPowerUI.CreateFrame("EditBox", "$parent" .. suffix, frame)
	local left
	local right
	local middle

	PallyPowerUI.SetSize(editBox, 34, 20)
	PallyPowerUI.SetPoint(editBox, "TOPRIGHT", frame, "TOPRIGHT", -30, y)
	editBox:EnableMouse(true)
	editBox:SetMaxLetters(8)
	editBox:SetNumeric(1)
	editBox:SetFontObject(ChatFontNormal)

	left = PallyPowerUI.CreateTexture(editBox, "$parentLeft", "BACKGROUND", "Interface\\Common\\Common-Input-Border")
	PallyPowerUI.SetSize(left, 8, 20)
	PallyPowerUI.SetPoint(left, "LEFT", editBox, "LEFT", 0, 0)
	left:SetTexCoord(0, 0.0625, 0, 0.625)

	right = PallyPowerUI.CreateTexture(editBox, "$parentRight", "BACKGROUND", "Interface\\Common\\Common-Input-Border")
	PallyPowerUI.SetSize(right, 8, 20)
	PallyPowerUI.SetPoint(right, "RIGHT", editBox, "RIGHT", 0, 0)
	right:SetTexCoord(0.9375, 1, 0, 0.625)

	middle = PallyPowerUI.CreateTexture(editBox, "$parentMiddle", "BACKGROUND", "Interface\\Common\\Common-Input-Border")
	PallyPowerUI.SetSize(middle, 10, 20)
	PallyPowerUI.SetPoint(middle, "LEFT", left, "RIGHT", 0, 0)
	PallyPowerUI.SetPoint(middle, "RIGHT", right, "LEFT", 0, 0)
	middle:SetTexCoord(0.0625, 0.9375, 0, 0.625)

	editBox:SetScript("OnShow", function()
		this:SetNumeric(1)
		this:SetText(PP_PerUser[optionKey])
	end)
	editBox:SetScript("OnTabPressed", function()
		focusOther()
	end)
	editBox:SetScript("OnEditFocusLost", function()
		this:HighlightText(0, 0)
	end)
	editBox:SetScript("OnChar", function()
	end)
	editBox:SetScript("OnEnterPressed", function()
		focusOther()
	end)
	editBox:SetScript("OnEscapePressed", function()
		this:GetParent():Hide()
	end)
	editBox:SetScript("OnTextChanged", function()
		if this:GetNumber() > 0 then
			PallyPower_SetOption(optionKey, this:GetNumber())
		end
	end)

	return editBox
end

function PallyPowerUI.CreateAdvancedOptionsCheckButton(frame, name, x, y, onShow, onClick)
	local button = PallyPowerUI.CreateFrame("CheckButton", name, frame, "OptionsCheckButtonTemplate")

	PallyPowerUI.SetSize(button, 20, 20)
	PallyPowerUI.SetPoint(button, "TOPRIGHT", frame, "TOPRIGHT", x, y)
	button:SetScript("OnShow", onShow)
	button:SetScript("OnClick", onClick)

	return button
end

function PallyPowerUI.CreateAdvancedOptionsUI()
PallyPowerUI.CreateBuffBarUI()
	local frame = PallyPowerUI.CreateFrame("Frame", "PallyPower_OptionsFrame", UIParent)
	local button
	local slider

	PallyPowerUI.SetSize(frame, 400, 555)
	PallyPowerUI.SetPoint(frame, "CENTER", UIParent, "CENTER", 0, 65)
	frame:SetToplevel(true)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetFrameStrata("DIALOG")
	frame:Hide()
	PallyPowerUI.SetBackdrop(
		frame,
		"Interface\\Tooltips\\UI-Tooltip-Background",
		"Interface\\Tooltips\\UI-Tooltip-Border",
		true, 16, 16, 5, 5, 5, 5
	)

	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentTitle", "GameFontNormalLarge", PALLYPOWER_UI_ADVANCED_TITLE,
		300, 16, "TOP", 0, -10, nil, 0.96, 0.55, 0.73
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "PP_UI_AdvancedMinimapHeader", "GameFontNormal", PALLYPOWER_UI_SECTION_MINIMAP,
		180, 16, "TOPLEFT", 10, -38, "LEFT", 0.96, 0.55, 0.73
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "PP_UI_AdvancedVisualHeader", "GameFontNormal", PALLYPOWER_UI_SECTION_VISUAL,
		180, 16, "TOPLEFT", 10, -125, "LEFT", 0.96, 0.55, 0.73
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "PP_UI_AdvancedLayoutHeader", "GameFontNormal", PALLYPOWER_UI_SECTION_LAYOUT,
		180, 16, "TOPLEFT", 10, -224, "LEFT", 0.96, 0.55, 0.73
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "PP_UI_AdvancedScanningHeader", "GameFontNormal", PALLYPOWER_UI_SECTION_SCANNING,
		180, 16, "TOPLEFT", 10, -397, "LEFT", 0.96, 0.55, 0.73
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "PP_UI_NampowerLabel", "GameFontHighlight", PALLYPOWER_UI_NAMPOWER,
		180, 16, "TOPLEFT", 18, -500, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "PP_UI_NampowerState", "GameFontNormal", nil,
		150, 16, "TOPRIGHT", -30, -500, "RIGHT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "PP_UI_UnitXPLabel", "GameFontHighlight", PALLYPOWER_UI_UNITXP_SP3,
		180, 16, "TOPLEFT", 18, -525, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "PP_UI_UnitXPState", "GameFontNormal", nil,
		150, 16, "TOPRIGHT", -30, -525, "RIGHT"
	)

	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentOption1", "GameFontHighlight", PALLYPOWER_UI_SCAN_UNITFRAMES_EVERY,
		300, 16, "TOPLEFT", 18, -425, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentOption2", "GameFontHighlight", PALLYPOWER_UI_UNITS_SCANNED_PER_FRAME,
		300, 16, "TOPLEFT", 18, -450, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentOption3", "GameFontHighlight", PALLYPOWER_OPTIONS_FEEDBACK_CHAT,
		200, 16, "TOPLEFT", 7, -75, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentOption4", "GameFontHighlight", PALLYPOWER_OPTIONS_SMARTBUFFS,
		200, 16, "TOPLEFT", 7, -100, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentOption5", "GameFontHighlight", PALLYPOWER_OPTIONS_LOCK,
		300, 16, "TOPLEFT", 7, -125, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentOption6", "GameFontHighlight", PALLYPOWER_OPTIONS_RF,
		300, 16, "TOPLEFT", 7, -150, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentOption7", "GameFontHighlight", PALLYPOWER_OPTIONS_AURA,
		300, 16, "TOPLEFT", 7, -175, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentOption7a", "GameFontHighlight", PALLYPOWER_OPTIONS_SEAL,
		300, 16, "TOPLEFT", 7, -200, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentOption8", "GameFontHighlight", PALLYPOWER_UI_SHOW_BUTTON,
		300, 16, "TOPLEFT", 18, -62, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentOption9", "GameFontHighlight", PALLYPOWER_UI_BUTTON_POSITION,
		300, 16, "TOPLEFT", 18, -87, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentOption10", "GameFontHighlight", PALLYPOWER_OPTIONS_PLAY_SOUND,
		300, 16, "TOPLEFT", 7, -275, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentOption11", "GameFontHighlight", PALLYPOWER_OPTIONS_HORIZONTAL_LAYOUT,
		300, 16, "TOPLEFT", 7, -300, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentOption12", "GameFontHighlight", PALLYPOWER_UI_HIDE_BLIZZARD_AURA_FRAME,
		300, 16, "TOPLEFT", 18, -204, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentOption13", "GameFontHighlight", PALLYPOWER_OPTIONS_USE_UNITXP_SP3_LOS,
		300, 16, "TOPLEFT", 7, -410, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentCombineSelfBuffsLabel", "GameFontHighlight", PALLYPOWER_UI_COMBINE_SELF_BUFFS,
		260, 16, "TOPLEFT", 18, -252, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentSelfBuffsAboveHeaderLabel", "GameFontHighlight", PALLYPOWER_UI_SELF_BUFFS_ABOVE_HEADER,
		260, 16, "TOPLEFT", 18, -277, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentJudgementAboveHeaderLabel", "GameFontHighlight", PALLYPOWER_UI_JUDGEMENT_ABOVE_HEADER,
		260, 16, "TOPLEFT", 18, -302, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentAssignmentLinkWidthLabel", "GameFontHighlight", PALLYPOWER_UI_ASSIGNMENT_LINK_WIDTH,
		180, 16, "TOPLEFT", 18, -319, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentAssignmentSelfBuffSpacingLabel", "GameFontHighlight", PALLYPOWER_UI_ASSIGNMENT_SELF_BUFF_SPACING,
		180, 16, "TOPLEFT", 18, -344, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentAssignmentClassSpacingLabel", "GameFontHighlight", PALLYPOWER_UI_ASSIGNMENT_CLASS_SPACING,
		180, 16, "TOPLEFT", 18, -369, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentVerboseJudgementRefreshLabel", "GameFontHighlight", PALLYPOWER_UI_VERBOSE_JUDGEMENT_REFRESH,
		260, 16, "TOPLEFT", 18, -475, "LEFT"
	)
	PallyPowerUI.CreateAdvancedOptionsLabel(
		frame, "$parentOption15", "GameFontHighlight", PALLYPOWER_OPTIONS_TRANSPARENCY,
		300, 16, "TOPLEFT", 18, -174, "LEFT"
	)

	button = PallyPowerUI.CreateFrame("Button", "$parentCloseButton", frame, "UIPanelCloseButton")
	PallyPowerUI.SetPoint(button, "TOPRIGHT", frame, "TOPRIGHT", 2, 2)

	PallyPowerUI.CreateAdvancedOptionsScanEditBox(
		frame, "Scan1", -423, "scanfreq",
		function() PallyPower_OptionsFrameScan2:SetFocus() end
	)
	PallyPowerUI.CreateAdvancedOptionsScanEditBox(
		frame, "Scan2", -448, "scanperframe",
		function() PallyPower_OptionsFrameScan1:SetFocus() end
	)

	PallyPowerUI.CreateAdvancedOptionsCheckButton(
		frame, "$parentCombineSelfBuffs", -30, -250,
		function()
			if PP_PerUser.combineselfbuffs then this:SetChecked(true) else this:SetChecked(false) end
		end,
		function()
			PallyPower_CombineSelfBuffsOption()
		end
	)
	PallyPowerUI.CreateAdvancedOptionsCheckButton(
		frame, "$parentSelfBuffsAboveHeader", -30, -275,
		function()
			if PP_PerUser.selfbuffsaboveheader then this:SetChecked(true) else this:SetChecked(false) end
		end,
		function()
			PallyPower_SelfBuffsAboveHeaderOption()
		end
	)
	PallyPowerUI.CreateAdvancedOptionsCheckButton(
		frame, "$parentJudgementAboveHeader", -30, -300,
		function()
			if PP_PerUser.judgementaboveheader then this:SetChecked(true) else this:SetChecked(false) end
		end,
		function()
			PallyPower_JudgementAboveHeaderOption()
		end
	)
	PallyPowerUI.CreateAdvancedOptionsCheckButton(
		frame, "$parentVerboseJudgementRefresh", -30, -473,
		function()
			if PP_PerUser.verbose_judgement_refresh then this:SetChecked(true) else this:SetChecked(false) end
		end,
		function()
			PallyPower_VerboseJudgementRefreshOption()
		end
	)
	PallyPowerUI.CreateAdvancedOptionsCheckButton(
		frame, "$parentFeedback", -5, -75,
		function()
			if PP_PerUser.chatfeedback then this:SetChecked(true) else this:SetChecked(false) end
		end,
		function()
			PP_PerUser.chatfeedback = this:GetChecked()
		end
	)
	PallyPowerUI.CreateAdvancedOptionsCheckButton(
		frame, "$parentSmart", -5, -100,
		function()
			if PP_PerUser.smartbuffs then this:SetChecked(true) else this:SetChecked(false) end
		end,
		function()
			PP_PerUser.smartbuffs = this:GetChecked()
		end
	)
	PallyPowerUI.CreateAdvancedOptionsCheckButton(
		frame, "FramesLockedOptionChk", -5, -125,
		function()
			if PP_PerUser.frameslocked then this:SetChecked(true) else this:SetChecked(false) end
		end,
		function()
			PP_PerUser.frameslocked = this:GetChecked()
			PallyPower_FramesLockedOption()
		end
	)
	PallyPowerUI.CreateAdvancedOptionsCheckButton(
		frame, "RighteousFuryOptionChk", -5, -150,
		function()
			if PP_PerUser.showrfbutton then this:SetChecked(true) else this:SetChecked(false) end
		end,
		function()
			PP_PerUser.showrfbutton = this:GetChecked()
			PallyPower_RighteousFuryOption()
		end
	)
	PallyPowerUI.CreateAdvancedOptionsCheckButton(
		frame, "AuraOptionChk", -5, -175,
		function()
			if PP_PerUser.showaurabutton then this:SetChecked(true) else this:SetChecked(false) end
		end,
		function()
			PP_PerUser.showaurabutton = this:GetChecked()
			PallyPower_AuraOption()
		end
	)
	PallyPowerUI.CreateAdvancedOptionsCheckButton(
		frame, "SealOptionChk", -5, -200,
		function()
			if PP_PerUser.showsealbutton then this:SetChecked(true) else this:SetChecked(false) end
		end,
		function()
			PP_PerUser.showsealbutton = this:GetChecked()
			PallyPower_SealOption()
		end
	)
	PallyPowerUI.CreateAdvancedOptionsCheckButton(
		frame, "MinimapButtonOptionChk", -30, -62,
		function()
			if PP_PerUser.minimapbuttonshow then this:SetChecked(true) else this:SetChecked(false) end
		end,
		function()
			PP_PerUser.minimapbuttonshow = this:GetChecked()
			PallyPower_MinimapButtonOption()
		end
	)

	slider = PallyPowerUI.CreateFrame("Slider", "MinimapButtonOptionSlider", frame, "OptionsSliderTemplate")
	PallyPowerUI.SetSize(slider, 210, 16)
	PallyPowerUI.SetPoint(slider, "TOPRIGHT", frame, "TOPRIGHT", -30, -87)
	slider:SetScript("OnLoad", function()
		MinimapButtonOptionSlider:SetMinMaxValues(0, 360)
		MinimapButtonOptionSlider:SetValueStep(1)
	end)
	slider:SetScript("OnValueChanged", function()
		PP_PerUser.minimapbuttonpos = MinimapButtonOptionSlider:GetValue()
		PallyPower_MinimapButton_UpdatePosition()
	end)
	MinimapButtonOptionSlider:SetMinMaxValues(0, 360)
	MinimapButtonOptionSlider:SetValueStep(1)

	PallyPowerUI.CreateAdvancedOptionsCheckButton(
		frame, "PlaySoundOptionChk", -5, -275,
		function()
			if PP_PerUser.playsoundwhen0 then this:SetChecked(true) else this:SetChecked(false) end
		end,
		function()
			PP_PerUser.playsoundwhen0 = this:GetChecked()
			PallyPower_PlaySoundOption()
		end
	)
	PallyPowerUI.CreateAdvancedOptionsCheckButton(
		frame, "HorizontalLayoutOptionChk", -5, -300,
		function()
			if PP_PerUser.horizontal then this:SetChecked(true) else this:SetChecked(false) end
		end,
		function()
			PP_PerUser.horizontal = this:GetChecked()
			PallyPower_HorizontalLayoutOption()
		end
	)
	PallyPowerUI.CreateAdvancedOptionsCheckButton(
		frame, "HideBlizzardFrameOptionChk", -30, -204,
		function()
			if PP_PerUser.hideblizzaura then this:SetChecked(true) else this:SetChecked(false) end
		end,
		function()
			PP_PerUser.hideblizzaura = this:GetChecked()
			PallyPower_HideBlizzardAuraFrameOption()
		end
	)
	PallyPowerUI.CreateAdvancedOptionsCheckButton(
		frame, "UseUnitXPSP3OptionChk", -5, -410,
		function()
			if PP_PerUser.useunitxp_sp3 then this:SetChecked(true) else this:SetChecked(false) end
		end,
		function()
			PP_PerUser.useunitxp_sp3 = this:GetChecked()
			PallyPower_UseUnitXPSP3Option()
		end
	)
	slider = PallyPowerUI.CreateFrame("Slider", "TransparencyOptionSlider", frame, "OptionsSliderTemplate")
	PallyPowerUI.SetSize(slider, 210, 16)
	PallyPowerUI.SetPoint(slider, "TOPRIGHT", frame, "TOPRIGHT", -30, -174)
	slider:SetScript("OnLoad", function()
		TransparencyOptionSlider:SetMinMaxValues(0, 1)
		TransparencyOptionSlider:SetValueStep(0.05)
	end)
	slider:SetScript("OnValueChanged", function()
		PP_PerUser.transparency = TransparencyOptionSlider:GetValue()
		PallyPower_AdjustTransparency()
	end)
	TransparencyOptionSlider:SetMinMaxValues(0, 1)
	TransparencyOptionSlider:SetValueStep(0.05)

	slider = PallyPowerUI.CreateFrame("Slider", "AssignmentLinkWidthSlider", frame, "OptionsSliderTemplate")
	PallyPowerUI.SetSize(slider, 140, 16)
	PallyPowerUI.SetPoint(slider, "TOPRIGHT", frame, "TOPRIGHT", -30, -319)
	slider:SetMinMaxValues(1, 16)
	slider:SetValueStep(1)
	if AssignmentLinkWidthSliderLow then AssignmentLinkWidthSliderLow:SetText("1") end
	if AssignmentLinkWidthSliderHigh then AssignmentLinkWidthSliderHigh:SetText("16") end
	if AssignmentLinkWidthSliderText then AssignmentLinkWidthSliderText:SetText("8") end
	slider:SetScript("OnShow", function()
		local width = PallyPowerUI.NormalizeAssignmentLinkWidth(
			PP_PerUser and PP_PerUser.assignmentlinkwidth or 8
		)
		this:SetValue(width)
		if AssignmentLinkWidthSliderText then
			AssignmentLinkWidthSliderText:SetText(tostring(width))
		end
	end)
	slider:SetScript("OnValueChanged", function()
		local width = PallyPowerUI.NormalizeAssignmentLinkWidth(this:GetValue())
		PP_PerUser.assignmentlinkwidth = width
		if AssignmentLinkWidthSliderText then
			AssignmentLinkWidthSliderText:SetText(tostring(width))
		end
		PallyPowerUI.SetAssignmentLinkWidth(width)
	end)

	slider = PallyPowerUI.CreateFrame("Slider", "AssignmentSelfBuffSpacingSlider", frame, "OptionsSliderTemplate")
	PallyPowerUI.SetSize(slider, 140, 16)
	PallyPowerUI.SetPoint(slider, "TOPRIGHT", frame, "TOPRIGHT", -30, -344)
	slider:SetMinMaxValues(0, 50)
	slider:SetValueStep(1)
	if AssignmentSelfBuffSpacingSliderLow then AssignmentSelfBuffSpacingSliderLow:SetText("0") end
	if AssignmentSelfBuffSpacingSliderHigh then AssignmentSelfBuffSpacingSliderHigh:SetText("50") end
	if AssignmentSelfBuffSpacingSliderText then AssignmentSelfBuffSpacingSliderText:SetText("6") end
	slider:SetScript("OnShow", function()
		local spacing = PallyPowerUI.NormalizeAssignmentSpacing(
			PP_PerUser and PP_PerUser.assignmentselfbuffspacing,
			PallyPowerUI.AssignmentLayout.SELF_BUFF_SPACING_DEFAULT
		)
		this:SetValue(spacing)
		if AssignmentSelfBuffSpacingSliderText then
			AssignmentSelfBuffSpacingSliderText:SetText(tostring(spacing))
		end
	end)
	slider:SetScript("OnValueChanged", function()
		local spacing = PallyPowerUI.NormalizeAssignmentSpacing(
			this:GetValue(),
			PallyPowerUI.AssignmentLayout.SELF_BUFF_SPACING_DEFAULT
		)
		PP_PerUser.assignmentselfbuffspacing = spacing
		if AssignmentSelfBuffSpacingSliderText then
			AssignmentSelfBuffSpacingSliderText:SetText(tostring(spacing))
		end
		PallyPowerUI.ApplyAssignmentSpacing()
	end)

	slider = PallyPowerUI.CreateFrame("Slider", "AssignmentClassSpacingSlider", frame, "OptionsSliderTemplate")
	PallyPowerUI.SetSize(slider, 140, 16)
	PallyPowerUI.SetPoint(slider, "TOPRIGHT", frame, "TOPRIGHT", -30, -369)
	slider:SetMinMaxValues(0, 50)
	slider:SetValueStep(1)
	if AssignmentClassSpacingSliderLow then AssignmentClassSpacingSliderLow:SetText("0") end
	if AssignmentClassSpacingSliderHigh then AssignmentClassSpacingSliderHigh:SetText("50") end
	if AssignmentClassSpacingSliderText then AssignmentClassSpacingSliderText:SetText("24") end
	slider:SetScript("OnShow", function()
		local spacing = PallyPowerUI.NormalizeAssignmentSpacing(
			PP_PerUser and PP_PerUser.assignmentclassspacing,
			PallyPowerUI.AssignmentLayout.CLASS_SPACING_DEFAULT
		)
		this:SetValue(spacing)
		if AssignmentClassSpacingSliderText then
			AssignmentClassSpacingSliderText:SetText(tostring(spacing))
		end
	end)
	slider:SetScript("OnValueChanged", function()
		local spacing = PallyPowerUI.NormalizeAssignmentSpacing(
			this:GetValue(),
			PallyPowerUI.AssignmentLayout.CLASS_SPACING_DEFAULT
		)
		PP_PerUser.assignmentclassspacing = spacing
		if AssignmentClassSpacingSliderText then
			AssignmentClassSpacingSliderText:SetText(tostring(spacing))
		end
		PallyPowerUI.ApplyAssignmentSpacing()
	end)

	frame:SetScript("OnLoad", function()
		PallyPower_SetFrameBackdropColor(this)
	end)
	PallyPower_SetFrameBackdropColor(frame)

	return frame
end

-- ============================================================================
-- STAGE 4 BUFF BAR UI
-- ============================================================================

function PallyPowerUI.CreateBuffBarUI()
	local frame = PallyPowerUI.CreateFrame("Frame", "PallyPowerBuffBar", UIParent)
	PallyPowerUIRefs.buffBar = frame
	local title
	local region
	local button
	local statusBar
	local previous
	local i

	PallyPowerUI.SetSize(frame, 90, 390)
	PallyPowerUI.SetPoint(frame, "LEFT", UIParent, "LEFT", 0, 0)
	frame:SetToplevel(true)
	frame:SetMovable(true)
	frame:SetFrameStrata("LOW")
	frame:EnableMouse(true)

	title = PallyPowerUI.CreateFrame("Button", "$parentTitle", frame)
	PallyPowerUI.SetSize(title, 300, 16)
	PallyPowerUI.SetPoint(title, "TOPLEFT", frame, "TOPLEFT", 0, 0)
	PallyPowerUI.SetBackdrop(
		title,
		"Interface\\Tooltips\\UI-Tooltip-Background",
		"Interface\\Tooltips\\UI-Tooltip-Border",
		true, 8, 8, 2, 2, 3, 2
	)

	region = PallyPowerUI.CreateFontString(title, "$parentText", "OVERLAY", "GameFontNormal")
	PallyPowerUI.SetSize(region, 86, 18)
	PallyPowerUI.SetPoint(region, "CENTER", title, "CENTER", 0, 0)
	region:SetText(PALLYPOWER_UI_TITLE)
	region:SetJustifyH("CENTER")
	PallyPowerUI.SetFontStyle(region, 14)

	title:SetScript("OnEnter", function()
		PallyPower_ShowVersionTooltip()
	end)
	title:SetScript("OnLeave", function()
		HideUIPanel(GameTooltip)
	end)
	title:SetScript("OnMouseDown", function()
		PallyPowerBuffBar_MouseDown(arg1)
	end)
	title:SetScript("OnMouseUp", function()
		PallyPowerBuffBar_MouseUp()
	end)

	button = PallyPowerUI.CreatePPBuffBarSpecialTemplate("$parentAura", frame)
	PallyPowerUIRefs.buffSpecialButtons.Aura = button
	PallyPowerUI.SetPoint(button, "TOPLEFT", title, "BOTTOMLEFT", 0, 0)

	button = PallyPowerUI.CreatePPBuffBarSpecialTemplate("$parentRF", frame)
	PallyPowerUIRefs.buffSpecialButtons.RF = button
	PallyPowerUI.SetPoint(button, "TOPLEFT", PallyPowerBuffBarAura, "BOTTOMLEFT", 0, 0)
	region = PallyPowerUI.CreateFontString(button, "$parentNoRF", "OVERLAY", "GameFontNormalLarge")
	PallyPowerUI.SetSize(region, 24, 24)
	PallyPowerUI.SetPoint(region, "CENTER", button.ppBuffIcon, "CENTER", 0, 0)
	region:SetText("X")
	region:SetJustifyH("CENTER")
	region:SetJustifyV("MIDDLE")
	PallyPowerUI.SetFontStyle(region, 20, "THICK")
	region:SetTextColor(1, 0, 0)
	region:Hide()
    button.ppLegacyNoRF = region
    button.ppNoRF = region

	button = PallyPowerUI.CreatePPBuffBarSpecialTemplate("$parentSeal", frame)
	PallyPowerUIRefs.buffSpecialButtons.Seal = button
	PallyPowerUI.SetPoint(button, "TOPLEFT", PallyPowerBuffBarAura, "BOTTOMLEFT", 0, 0)

	button = PallyPowerUI.CreatePPBuffBarCombinedSelfTemplate("$parentSelfCombined", frame)
	PallyPowerUIRefs.buffCombinedSelf = button
	PallyPowerUI.SetPoint(button, "TOPLEFT", title, "BOTTOMLEFT", 0, 0)
	button:Hide()

	button = PallyPowerUI.CreatePPBuffBarSpecialTemplate("$parentJudgement", frame)
	PallyPowerUIRefs.buffSpecialButtons.Judgement = button
	PallyPowerUI.SetPoint(button, "TOPLEFT", PallyPowerBuffBarSeal, "BOTTOMLEFT", 0, 0)
	button:Hide()

	region = PallyPowerUI.CreateFontString(button, "$parentTime", "OVERLAY", "GameFontHighlightSmall")
	PallyPowerUI.SetSize(region, 50, 15)
	PallyPowerUI.SetPoint(region, "TOPRIGHT", button, "TOPRIGHT", -6, -4)
	region:SetText("")
	region:SetJustifyH("CENTER")
	region:SetJustifyV("MIDDLE")
	PallyPowerUI.SetFontStyle(region, 11)
	button.ppTime = region

	region = PallyPowerUI.CreateFontString(button, "$parentDebug", "OVERLAY", "GameFontNormalSmall")
	PallyPowerUI.SetSize(region, 78, 12)
	PallyPowerUI.SetPoint(region, "LEFT", button, "RIGHT", 4, 0)
	region:SetText("")
	region:SetJustifyH("LEFT")
	region:SetTextColor(1, 1, 1)
	button.ppDebug = region

	statusBar = PallyPowerUI.CreateFrame("StatusBar", "$parentDurationBar", button)
	PallyPowerUI.SetSize(statusBar, 62, 4)
	PallyPowerUI.SetPoint(statusBar, "BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, 5)
	statusBar:SetMinMaxValues(0, 1)
	statusBar:SetValue(0)
	statusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	statusBar:SetStatusBarColor(1, 1, 1)
	button.ppDurationBar = statusBar

	button:SetScript("OnClick", function()
	end)
	button:SetScript("OnEnter", function()
		PallyPower_JudgementTracker_OnEnter(this)
	end)
	button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	for i = 1, 10 do
		button = PallyPowerUI.CreatePPBuffBarBlessingTemplate("$parentBuff" .. i, frame)
		PallyPowerUIRefs.buffButtons[i] = button
		if i == 1 then
			PallyPowerUI.SetPoint(button, "TOPLEFT", title, "BOTTOMLEFT", 0, 0)
		else
			PallyPowerUI.SetPoint(button, "TOPLEFT", previous, "BOTTOMLEFT", 0, 0)
		end
		previous = button
	end

	button = PallyPowerUI.CreatePPResizeGripTemplate("$parentResizeButton", frame)
	PallyPowerUI.SetPoint(button, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)

	frame:SetScript("OnUpdate", function()
		PallyPower_OnUpdate(arg1)
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
PallyPowerUI.CreateAdvancedOptionsUI()
PallyPowerUI.CreateAssignmentUI()
