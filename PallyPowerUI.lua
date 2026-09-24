-- PallyPowerVanilla UI construction helpers.
-- Stage 1 scaffold only: PallyPower.xml still constructs the live UI.
-- Keep this file side-effect free apart from defining the PallyPowerUI helper namespace
-- until later migration stages replace XML sections one-for-one.

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
