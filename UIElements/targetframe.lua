	-------------------------------------------------------------------------------
	local raidTargetFrame = CreateFrame('Frame', nil, TargetFrame)
	raidTargetFrame:SetFrameLevel(2)
	raidTargetFrame:SetHeight(36)	raidTargetFrame:SetWidth(36)
	raidTargetFrame:SetPoint('CENTER', TargetPortrait, 'TOP')
	
	raidTargetFrame.icon = raidTargetFrame:CreateTexture(nil, 'OVERLAY')
	raidTargetFrame.icon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	raidTargetFrame.icon:SetAllPoints()
	-------------------------------------------------------------------------------
	local refreshInterval, nextRefresh = 1/60, 0
	local TEXTURE = [[Interface\AddOns\modui\statusbar\texture\sb.tga]]
    local BACKDROP = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],}
	
	TargetFrame.cast = CreateFrame('StatusBar', 'enemyFramesTargetFrameCastbar', TargetFrame)
    TargetFrame.cast:SetStatusBarTexture(TEXTURE)
    TargetFrame.cast:SetStatusBarColor(1, .4, 0)
    TargetFrame.cast:SetBackdrop(BACKDROP)
    TargetFrame.cast:SetBackdropColor(0, 0, 0)
    TargetFrame.cast:SetHeight(10)
    TargetFrame.cast:SetPoint('LEFT', TargetFrame, 32, 0)
    TargetFrame.cast:SetPoint('RIGHT', TargetFrame, -50, 0)
    TargetFrame.cast:SetPoint('TOP', TargetFrame, 'BOTTOM', 0, -2)
	
	TargetFrame.cast:SetPoint('TOP', TargetFrame, 'BOTTOM', 0, -45)
    TargetFrame.cast:SetValue(0)
    TargetFrame.cast:Hide()
	
	TargetFrame.cast:SetMovable(true) TargetFrame.cast:SetUserPlaced(true)
	TargetFrame.cast:SetClampedToScreen(true)
	TargetFrame.cast:RegisterForDrag'LeftButton' TargetFrame.cast:EnableMouse(true)
	local castbarmoveable = false
	TargetFrame.cast:SetScript('OnDragStart', function() if castbarmoveable then this:StartMoving() end end)
	TargetFrame.cast:SetScript('OnDragStop', function() if castbarmoveable then this:StopMovingOrSizing() end end)
	
	TargetFrame.cast.border = CreateBorder(nil, TargetFrame.cast, 6.5, 1/8.5)
	TargetFrame.cast.border:SetPadding(2.5, 1.7)

    TargetFrame.cast.text = TargetFrame.cast:CreateFontString(nil, 'OVERLAY')
    TargetFrame.cast.text:SetTextColor(1, 1, 1)
    TargetFrame.cast.text:SetFont(STANDARD_TEXT_FONT, 11, 'OUTLINE')
    --TargetFrame.cast.text:SetShadowOffset(1, -1)
    TargetFrame.cast.text:SetShadowColor(0, 0, 0)
    TargetFrame.cast.text:SetPoint('LEFT', TargetFrame.cast, 2, .5)
    TargetFrame.cast.text:SetText('drag-me')

    TargetFrame.cast.timer = TargetFrame.cast:CreateFontString(nil, 'OVERLAY')
    TargetFrame.cast.timer:SetTextColor(1, 1, 1)
    TargetFrame.cast.timer:SetFont(STANDARD_TEXT_FONT, 9, 'OUTLINE')
    --TargetFrame.cast.timer:SetShadowOffset(1, -1)
    TargetFrame.cast.timer:SetShadowColor(0, 0, 0)
    TargetFrame.cast.timer:SetPoint('RIGHT', TargetFrame.cast, -1, .5)
    TargetFrame.cast.timer:SetText'3.5s'

    TargetFrame.cast.icon = TargetFrame.cast:CreateTexture(nil, 'OVERLAY', nil, 7)
    TargetFrame.cast.icon:SetWidth(18) TargetFrame.cast.icon:SetHeight(16)
    TargetFrame.cast.icon:SetPoint('RIGHT', TargetFrame.cast, 'LEFT', -8, 0)
    TargetFrame.cast.icon:SetTexCoord(.1, .9, .15, .85)
	TargetFrame.cast.icon:SetTexture([[Interface\Icons\Inv_misc_gem_sapphire_01]])
	
	local ic = CreateFrame('Frame', nil, TargetFrame.cast)
    ic:SetAllPoints(TargetFrame.cast.icon)
	
	TargetFrame.cast.icon.border = CreateBorder(nil, ic, 12.8)
	TargetFrame.cast.icon.border:SetPadding(1)
	-------------------------------------------------------------------------------
	local function round(num, idp)
		local mult = 10^(idp or 0)
		return math.floor(num * mult + 0.5) / mult
	end
	local getTimerLeft = function(tEnd)
		local t = tEnd - GetTime()
		if t > 3 then return round(t, 0) else return round(t, 1) end
	end
	-------------------------------------------------------------------------------
	local showCast = function()
		if castbarmoveable then
			TargetFrame.cast:Show()
		else
			TargetFrame.cast:Hide()
		end
		if UnitExists'target' then
			local v = SPELLCASTINGCOREgetCast(UnitName'target')
			if v ~= nil then
				if GetTime() < v.timeEnd then
					TargetFrame.cast:SetMinMaxValues(0, v.timeEnd - v.timeStart)
					if v.inverse then
						TargetFrame.cast:SetValue(mod((v.timeEnd - GetTime()), v.timeEnd - v.timeStart))
					else
						TargetFrame.cast:SetValue(mod((GetTime() - v.timeStart), v.timeEnd - v.timeStart))					
					end
					
					TargetFrame.cast.text:SetText(v.spell)
					TargetFrame.cast.timer:SetText(getTimerLeft(v.timeEnd)..'s')
					TargetFrame.cast.icon:SetTexture(v.icon)
					TargetFrame.cast:Show()
					
				end
			end
		end
    end
	local castbarFrame = CreateFrame'Frame'
	castbarFrame:SetScript('OnUpdate', function()
		nextRefresh = nextRefresh - arg1
		if nextRefresh < 0 then
			if ENEMYFRAMESPLAYERDATA['targetFrameCastbar'] then
				showCast()
			else
				TargetFrame.cast:Hide()
			end
			nextRefresh = refreshInterval			
		end
	end)
	
	function TARGETFRAMECASTBARsettings(b)
		castbarmoveable = b
	end
	-------------------------------------------------------------------------------
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
	-------------------------------------------------------------------------------
	local f = CreateFrame'Frame'	
	function targetframeInit()
		f:SetScript('OnUpdate', raidTargetOnUpdate)
		raidTargetFrame:Show()
	end
	-------------------------------------------------------------------------------
	local function eventHandler()
		f:SetScript('OnUpdate', nil)
		raidTargetFrame:Hide()
	end
	-------------------------------------------------------------------------------
	f:RegisterEvent'PLAYER_ENTERING_WORLD'
	f:RegisterEvent'ZONE_CHANGED_NEW_AREA'
	f:SetScript('OnEvent', eventHandler)
	