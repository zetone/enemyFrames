
	local raidTargetFrame = CreateFrame('Frame', nil, TargetFrame)
	raidTargetFrame:SetFrameLevel(2)
	raidTargetFrame:SetHeight(36)	raidTargetFrame:SetWidth(36)
	raidTargetFrame:SetPoint('CENTER', TargetPortrait, 'TOP')
	--raidTargetFrame:Hide()
	
	raidTargetFrame.icon = raidTargetFrame:CreateTexture(nil, 'OVERLAY')
	raidTargetFrame.icon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	--raidTargetFrame.icon:SetTexCoord(.75, 1, 0.25, .5)
	raidTargetFrame.icon:SetAllPoints()
	
	local function raidTargetOnUpdate()
		local rt = ENEMYFRAMECOREGetRaidTarget()

		if UnitExists'target' and rt[UnitName'target'] then
			local tCoords = RAID_TARGET_TCOORDS[rt[UnitName'target']['icon']]
			raidTargetFrame.icon:SetTexCoord(tCoords[1], tCoords[2], tCoords[3], tCoords[4])
			raidTargetFrame:Show()
		else
			raidTargetFrame:Hide()
		end

	end

	local f = CreateFrame'Frame'	
	function targetframeInit()
		raidTargetFrame:Show()
	end

	local function eventHandler()
		raidTargetFrame:Hide()
	end
		
	f:RegisterEvent'PLAYER_ENTERING_WORLD'
	f:RegisterEvent'ZONE_CHANGED_NEW_AREA'
	f:SetScript('OnEvent', eventHandler)
	
	f:SetScript('OnUpdate', raidTargetOnUpdate)