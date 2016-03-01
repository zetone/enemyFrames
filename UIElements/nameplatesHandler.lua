
local refreshInterval, nextRefresh = 1/60, 0

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
	local raidTargets = ENEMYFRAMECOREGetRaidTarget()
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
			
			if not plate.raidTarget then
				-- set killtarget icon
				plate.raidTarget = plate:CreateTexture(nil, 'OVERLAY')
				plate.raidTarget:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
				plate.raidTarget:SetHeight(38)	plate.raidTarget:SetWidth(38)
				plate.raidTarget:SetPoint('BOTTOM', name, 'TOP', 0, 5)
			end
			if raidTargets[n] then 
				local tCoords = RAID_TARGET_TCOORDS[raidTargets[n]['icon']]
				plate.raidTarget:SetTexCoord(tCoords[1], tCoords[2], tCoords[3], tCoords[4])
				plate.raidTarget:Show() 
			else plate.raidTarget:Hide() end
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
		nextRefresh = nextRefresh - arg1
		if nextRefresh < 0 then
			namePlateHandlerOnUpdate()
			nextRefresh = refreshInterval
		end
	end)
end
	
local function eventHandler()
	f:SetScript('OnUpdate', nil)
end
	
f:RegisterEvent'PLAYER_ENTERING_WORLD'
f:RegisterEvent'ZONE_CHANGED_NEW_AREA'
f:SetScript('OnEvent', eventHandler)