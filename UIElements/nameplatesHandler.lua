
local timerRefresh, timerInterval = 0, (1/60)
local killTargetName = ''

local isPlate = function(frame)     -- GO FISH
	local overlayRegion = frame:GetRegions()
	if not overlayRegion or overlayRegion:GetObjectType() ~= 'Texture'
	or overlayRegion:GetTexture() ~= [[Interface\Tooltips\Nameplate-Border]] then
		return false
	end
	return true
end

local f = CreateFrame'Frame'
    
local function namePlateHandlerOnUpdate()
	local nt, nmo = UnitName'target', UnitName'mouseover'
	local list = {}
	local frames = {WorldFrame:GetChildren()}
	for _, plate in ipairs(frames) do
		if isPlate(plate) and plate:IsVisible() then
			local health = plate:GetChildren()
			local _, _, name = plate:GetRegions()
			local n, h = name:GetText(), health:GetValue()
			-- redudant to include target and mouseover units
			if n ~= nt and n ~= nmo then
				list[n] = {['name'] = n, ['health'] = h}
			end
			
			if not plate.killTarget then
				-- set killtarget icon
				plate.killTarget = plate:CreateTexture(nil, 'OVERLAY')
				plate.killTarget:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
				plate.killTarget:SetTexCoord(.75, 1, 0.25, .5)
				plate.killTarget:SetHeight(38)	plate.killTarget:SetWidth(38)
				plate.killTarget:SetPoint('BOTTOM', name, 'TOP', 0, 5)
			end
			if n ~= killTargetName then plate.killTarget:Hide() end
		end
	end
	
	-- check if table is not empty
	if next(list) ~= nil then
		ENEMYFRAMECORESetPlayersData(list)
	end
end

-- global access
function namePlatesHandlerInit()
	f:SetScript('OnUpdate', function()
		local now = GetTime()
		if now > timerRefresh then
			namePlateHandlerOnUpdate()
			timerRefresh = now + timerInterval
		end
	end)
end

function namePlatesHandlerSetKillTarget(kt)
	killTargetName = kt
end
	
local function eventHandler()
	f:SetScript('OnUpdate', nil)
end
	
f:RegisterEvent'PLAYER_ENTERING_WORLD'
f:RegisterEvent'ZONE_CHANGED_NEW_AREA'
f:SetScript('OnEvent', eventHandler)