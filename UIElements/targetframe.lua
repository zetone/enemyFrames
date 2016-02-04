
	local killTargetName = ''

	local killTargetFrame = CreateFrame('Frame', nil, TargetFrame)
	killTargetFrame:SetFrameLevel(2)
	killTargetFrame:SetHeight(36)	killTargetFrame:SetWidth(36)
	killTargetFrame:SetPoint('CENTER', TargetPortrait, 'TOP')
	killTargetFrame:Hide()
	
	killTargetFrame.icon = killTargetFrame:CreateTexture(nil, 'OVERLAY')
	killTargetFrame.icon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	killTargetFrame.icon:SetTexCoord(.75, 1, 0.25, .5)
	killTargetFrame.icon:SetAllPoints()
	
	local function killTargetOnUpdate()
		local kt = ENEMYFRAMECOREGetKillTarget()

		if kt and UnitExists'target' and UnitName'target' == kt then
			killTargetFrame:Show()
		else
			killTargetFrame:Hide()
		end

	end

	local f = CreateFrame'Frame'
	
	function targetframeInit()
		f:SetScript('OnUpdate', killTargetOnUpdate())
	end


	local function eventHandler()
		f:SetScript('OnUpdate', nil)
	end
		
	f:RegisterEvent'PLAYER_ENTERING_WORLD'
	f:RegisterEvent'ZONE_CHANGED_NEW_AREA'
	f:SetScript('OnEvent', eventHandler)