	-------------------------------------------------------------------------------
	local raidTargetFrame = CreateFrame('Frame', nil, TargetFrame)
	raidTargetFrame:SetFrameLevel(2)
	raidTargetFrame:SetHeight(36)	raidTargetFrame:SetWidth(36)
	raidTargetFrame:SetPoint('CENTER', TargetPortrait, 'TOP')
	
	raidTargetFrame.icon = raidTargetFrame:CreateTexture(nil, 'OVERLAY')
	raidTargetFrame.icon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	raidTargetFrame.icon:SetAllPoints()
	-------------------------------------------------------------------------------
	local flagCarriers = {}
	-------------------------------------------------------------------------------
	local refreshInterval, nextRefresh = 1/60, 0
	local TEXTURE = [[Interface\AddOns\enemyFrames\globals\resources\barTexture.tga]]
    local BACKDROP = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],}
	
	TargetFrame.cast = CreateFrame('StatusBar', 'enemyFramesTargetFrameCastbar', TargetFrame)
    TargetFrame.cast:SetStatusBarTexture(TEXTURE)
    TargetFrame.cast:SetStatusBarColor(1, .4, 0)
    TargetFrame.cast:SetBackdrop(BACKDROP)
    TargetFrame.cast:SetBackdropColor(0, 0, 0)
    TargetFrame.cast:SetHeight(10)
	TargetFrame.cast:SetWidth(160)
	--TargetFrame.cast:ClearAllPoints()
	TargetFrame.cast:SetPoint('LEFT', TargetFrame, 'LEFT', 26, -45)
	
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
	
	TargetFrame.IntegratedCastBar = CreateFrame('StatusBar', 'enemyFramesTargetFrameCastbar', TargetFrame)
    TargetFrame.IntegratedCastBar:SetStatusBarTexture(TEXTURE)
    TargetFrame.IntegratedCastBar:SetStatusBarColor(1, .4, 0)
    --TargetFrame.IntegratedCastBar:SetBackdrop(BACKDROP)
    TargetFrame.IntegratedCastBar:SetBackdropColor(0, 0, 0, .5)
	TargetFrame.IntegratedCastBar:SetPoint('TOPLEFT', TargetFrameNameBackground, 'TOPLEFT')
	TargetFrame.IntegratedCastBar:SetPoint('BOTTOMRIGHT', TargetFrameNameBackground, 'BOTTOMRIGHT')
	TargetFrame.IntegratedCastBar:SetFrameLevel(1)
	
	TargetFrame.IntegratedCastBar.bg = TargetFrame.IntegratedCastBar:CreateTexture(nil, 'ARTWORK')
	TargetFrame.IntegratedCastBar.bg:SetTexture(0, 0, 0, .7)
	TargetFrame.IntegratedCastBar.bg:SetAllPoints()	
	
	TargetFrame.IntegratedCastBar.spellText = TargetFrame.IntegratedCastBar:CreateFontString(nil, 'OVERLAY')
    TargetFrame.IntegratedCastBar.spellText:SetTextColor(1, 1, 1)
    TargetFrame.IntegratedCastBar.spellText:SetFont(STANDARD_TEXT_FONT, 10, 'OUTLINE')
    TargetFrame.IntegratedCastBar.spellText:SetShadowColor(0, 0, 0)
    TargetFrame.IntegratedCastBar.spellText:SetPoint('LEFT', TargetFrame.IntegratedCastBar, 2, .5)
    TargetFrame.IntegratedCastBar.spellText:SetText('Polymorph') 
	
	TargetFrame.IntegratedCastBar.timer = TargetFrame.IntegratedCastBar:CreateFontString(nil, 'OVERLAY')
    TargetFrame.IntegratedCastBar.timer:SetTextColor(1, 1, 1)
    TargetFrame.IntegratedCastBar.timer:SetFont(STANDARD_TEXT_FONT, 8, 'OUTLINE')
    TargetFrame.IntegratedCastBar.timer:SetShadowColor(0, 0, 0)
    TargetFrame.IntegratedCastBar.timer:SetPoint('RIGHT', TargetFrame.IntegratedCastBar, -2, .5)
    TargetFrame.IntegratedCastBar.timer:SetText'3.5s'
	
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
			if ENEMYFRAMESPLAYERDATA['targetFrameCastbar'] then
				TargetFrame.cast:Show()
			else
				TargetFrame.cast:Hide()
			end
			if ENEMYFRAMESPLAYERDATA['integratedTargetFrameCastbar'] then
				TargetFrame.IntegratedCastBar:Show()
				TargetName:Hide()	
			else
				TargetFrame.IntegratedCastBar:Hide()
				TargetName:Show()
			end		
		else
			TargetFrame.cast:Hide()
			TargetFrame.IntegratedCastBar:Hide()
			TargetName:Show()
		end
		if UnitExists'target' then
			local v = SPELLCASTINGCOREgetCast(UnitName'target')
			if v ~= nil then
				if GetTime() < v.timeEnd then
					TargetFrame.cast:SetMinMaxValues(0, v.timeEnd - v.timeStart)
					TargetFrame.IntegratedCastBar:SetMinMaxValues(0, v.timeEnd - v.timeStart)
					if v.inverse then
						TargetFrame.cast:SetValue(mod((v.timeEnd - GetTime()), v.timeEnd - v.timeStart))
						TargetFrame.IntegratedCastBar:SetValue(mod((v.timeEnd - GetTime()), v.timeEnd - v.timeStart))
					else
						TargetFrame.cast:SetValue(mod((GetTime() - v.timeStart), v.timeEnd - v.timeStart))
						TargetFrame.IntegratedCastBar:SetValue(mod((GetTime() - v.timeStart), v.timeEnd - v.timeStart))				
					end
					
					TargetFrame.cast.text:SetText(string.sub(v.spell, 1, 17))
					TargetFrame.IntegratedCastBar.spellText:SetText(string.sub(v.spell, 1, 14))
					TargetFrame.cast.timer:SetText(getTimerLeft(v.timeEnd)..'s')
					TargetFrame.IntegratedCastBar.timer:SetText(getTimerLeft(v.timeEnd)..'s')
					TargetFrame.cast.icon:SetTexture(v.icon)
					-- border colors
					TargetFrame.cast.icon.border:SetColor(v.borderClr[1], v.borderClr[2], v.borderClr[3])
					TargetFrame.cast.border:SetColor(v.borderClr[1], v.borderClr[2], v.borderClr[3])
					--
					if ENEMYFRAMESPLAYERDATA['targetFrameCastbar'] then
						TargetFrame.cast:Show()
					end
					if ENEMYFRAMESPLAYERDATA['integratedTargetFrameCastbar'] then
						TargetFrame.IntegratedCastBar:Show()
						TargetName:Hide()							
					end	
				end
			end
		end
    end
	-------------------------------------------------------------------------------
	TARGETFRAMEsetFC = function(fc)
		flagCarriers = fc	
	end
	-------------------------------------------------------------------------------
	local portraitDebuff = CreateFrame('Frame', 'TargetPortraitDebuff', TargetFrame)
	portraitDebuff:SetFrameLevel(0)
	portraitDebuff:SetPoint('TOPLEFT', TargetPortrait, 'TOPLEFT', 7, -2)
	portraitDebuff:SetPoint('BOTTOMRIGHT', TargetPortrait, 'BOTTOMRIGHT', -5.5, 4)
	
	-- circle texture
	portraitDebuff.bgText = TargetFrame:CreateTexture(nil, 'OVERLAY')
	portraitDebuff.bgText:SetPoint('TOPLEFT', TargetPortrait, 'TOPLEFT', 3, -4.5)
	portraitDebuff.bgText:SetPoint('BOTTOMRIGHT', TargetPortrait, 'BOTTOMRIGHT', -4, 3)
	portraitDebuff.bgText:SetVertexColor(.3, .3, .3)
	portraitDebuff.bgText:SetTexture([[Interface\AddOns\enemyFrames\globals\resources\portraitBg.tga]])
	-- debuff texture
	portraitDebuff.debuffText = TargetFrame:CreateTexture()
	portraitDebuff.debuffText:SetPoint('TOPLEFT', TargetPortrait, 'TOPLEFT', 7.5, -8)
	portraitDebuff.debuffText:SetPoint('BOTTOMRIGHT', TargetPortrait, 'BOTTOMRIGHT', -7.5, 4.5)	
	portraitDebuff.debuffText:SetTexCoord(.12, .88, .12, .88)
	-- duration text
	local portraitDurationFrame = CreateFrame('Frame', nil, TargetFrame)
	portraitDurationFrame:SetAllPoints()
	portraitDurationFrame:SetFrameLevel(2)
	
	portraitDebuff.duration = portraitDurationFrame:CreateFontString(nil, 'OVERLAY')--, 'GameFontNormalSmall')
	portraitDebuff.duration:SetFont(STANDARD_TEXT_FONT, 13, 'OUTLINE')
	portraitDebuff.duration:SetTextColor(.9, .9, .2, 1)
	portraitDebuff.duration:SetShadowOffset(1, -1)
	portraitDebuff.duration:SetShadowColor(0, 0, 0)
	portraitDebuff.duration:SetPoint('CENTER', TargetPortrait, 'CENTER', 0, -7)
	-- cooldown spiral
	portraitDebuff.cd = CreateCooldown(portraitDebuff, 1.054, true)
	portraitDebuff.cd:SetAlpha(1)
	-------------------------------------------------------------------------------
	local a, maxa, b, c = .002, .058, 0, 1
	local showPortraitDebuff = function()
		if UnitExists'target' then
			local xtFaction = UnitFactionGroup'target' == 'Alliance' and 'Horde' or 'Alliance'
			local prioBuff = SPELLCASTINGCOREgetPrioBuff(UnitName'target', 1)[1]

			if prioBuff ~= nil then
				local d = 1
				if b > maxa then c = -1 end
				if b < 0 then c = 1 end
				b = b + a * c 
				d = -b 
				
				--portraitDebuff.debuffText:SetTexCoord(.12+b, .88+d, .12+d, .88+b)
			
				portraitDebuff.debuffText:SetTexture(prioBuff.icon)
				portraitDebuff.duration:SetText(getTimerLeft(prioBuff.timeEnd))
				portraitDebuff.bgText:Show()
				portraitDebuff.cd:SetTimers(prioBuff.timeStart, prioBuff.timeEnd)
				portraitDebuff.cd:Show()
				
				local br, bg, bb = prioBuff.border[1], prioBuff.border[2], prioBuff.border[3]
				portraitDebuff.bgText:SetVertexColor(br, bg, bb)
				
			elseif UnitName'target' == flagCarriers[xtFaction] then
				portraitDebuff.debuffText:SetTexture(SPELLINFO_WSG_FLAGS[xtFaction]['icon'])
				portraitDebuff.bgText:Show()
				portraitDebuff.duration:SetText('')
				portraitDebuff.cd:Hide()
				portraitDebuff.bgText:SetVertexColor(.1, .1, .1)
				
			else
				portraitDebuff.cd:Hide()				
				portraitDebuff.debuffText:SetTexture()
				portraitDebuff.duration:SetText('')
				portraitDebuff.bgText:Hide()
			end			
		end
	end
	-------------------------------------------------------------------------------
	local castbarFrame = CreateFrame'Frame'
	castbarFrame:SetScript('OnUpdate', function()
		nextRefresh = nextRefresh - arg1
		if nextRefresh < 0 then
			if ENEMYFRAMESPLAYERDATA['targetFrameCastbar'] or ENEMYFRAMESPLAYERDATA['integratedTargetFrameCastbar'] then
				showCast()				
			else
				TargetFrame.cast:Hide()
				TargetFrame.IntegratedCastBar:Hide()	
				TargetName:Show()				
			end
			if ENEMYFRAMESPLAYERDATA['targetPortraitDebuff'] then
				showPortraitDebuff()				
			else
				portraitDebuff.cd:Hide()				
				portraitDebuff.debuffText:SetTexture()
				portraitDebuff.duration:SetText('')
				portraitDebuff.bgText:Hide()
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
		flagCarriers = {}
		f:SetScript('OnUpdate', nil)
		raidTargetFrame:Hide()
	end
	-------------------------------------------------------------------------------
	f:RegisterEvent'PLAYER_ENTERING_WORLD'
	f:RegisterEvent'ZONE_CHANGED_NEW_AREA'
	f:SetScript('OnEvent', eventHandler)
	