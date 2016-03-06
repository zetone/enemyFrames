	-------------------------------------------------------------------------------
	local refreshInterval, nextRefresh = 1/60, 0
	local f = CreateFrame'Frame'
	-------------------------------------------------------------------------------
	local isPlate = function(frame)     
		local overlayRegion = frame:GetRegions()
		if not overlayRegion or overlayRegion:GetObjectType() ~= 'Texture'
		or overlayRegion:GetTexture() ~= [[Interface\Tooltips\Nameplate-Border]] then
			return false
		end
		return true
	end
	-------------------------------------------------------------------------------
	local addRaidTarget = function(plate, n, raidTargets)
		local _, _, name = plate:GetRegions()
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
		else 
			plate.raidTarget:Hide() 
		end
	end
	-------------------------------------------------------------------------------
	local addClassColor = function(health, class)	
		local colour = RAID_CLASS_COLORS[class]
		health:SetStatusBarColor(colour.r, colour.g, colour.b)
	end
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
	local TEXTURE = [[Interface\AddOns\enemyFrames\globals\resources\barTexture.tga]]
	local BACKDROP = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],}
	local addCastbar = function(plate, name)
		if not plate.castBar then
			local health = plate:GetChildren()
			
			plate.castBar = CreateFrame('StatusBar', nil, plate)
			plate.castBar:SetStatusBarTexture(TEXTURE)
			plate.castBar:SetStatusBarColor(1, .4, 0)
			plate.castBar:SetBackdrop(BACKDROP)
			plate.castBar:SetBackdropColor(0, 0, 0)
			plate.castBar:SetHeight(8)
			plate.castBar:SetPoint('LEFT', plate, 24, 0)
			plate.castBar:SetPoint('RIGHT', plate, -4, 0)
			plate.castBar:SetPoint('TOP', health, 'BOTTOM', 0, -12)

			plate.castBar.text = plate.castBar:CreateFontString(nil, 'OVERLAY')
			plate.castBar.text:SetTextColor(1, 1, 1)
			plate.castBar.text:SetFont(STANDARD_TEXT_FONT, 10)
			plate.castBar.text:SetShadowOffset(1, -1)
			plate.castBar.text:SetShadowColor(0, 0, 0)
			plate.castBar.text:SetPoint('LEFT', plate.castBar, 2, 0)

			plate.castBar.timer = plate.castBar:CreateFontString(nil, 'OVERLAY')
			plate.castBar.timer:SetTextColor(1, 1, 1)
			plate.castBar.timer:SetFont(STANDARD_TEXT_FONT, 9)
			plate.castBar.timer:SetPoint('RIGHT', plate.castBar)

			plate.castBar.icon = plate.castBar:CreateTexture(nil, 'OVERLAY')--'OVERLAY', nil, 7)
			plate.castBar.icon:SetWidth(14) plate.castBar.icon:SetHeight(14)
			plate.castBar.icon:SetTexCoord(.078, .92, .079, .937)	
			plate.castBar.icon:SetPoint('RIGHT', plate.castBar, 'LEFT', -5, 0)
			
			plate.castBar.icon.border = CreateFrame('Frame', nil, plate.castBar)
			plate.castBar.icon.border:SetWidth(plate.castBar.icon:GetWidth()+4) plate.castBar.icon.border:SetHeight(plate.castBar.icon:GetHeight()+4)
			plate.castBar.icon.border:SetPoint('CENTER', plate.castBar.icon)
			
			if IsAddOnLoaded'modui' then
				--TEXTURE = [[Interface\AddOns\modui\statusbar\texture\sb.tga]]
				plate.cast:SetStatusBarTexture([[Interface\AddOns\modui\statusbar\texture\sb.tga]])
				
				modSkin(plate.castBar.icon.border, 8)
				modSkinColor(plate.castBar.icon.border, .2, .2, .2)
			end
		end

		plate.castBar:Hide()

		local castInfo = SPELLCASTINGCOREgetCast(name)
		if castInfo then
			if GetTime() < castInfo.timeEnd then
				plate.castBar:SetMinMaxValues(0, castInfo.timeEnd - castInfo.timeStart)
				if castInfo.inverse then
					plate.castBar:SetValue(mod((castInfo.timeEnd - GetTime()), castInfo.timeEnd - castInfo.timeStart))
				else
					plate.castBar:SetValue(mod((GetTime() - castInfo.timeStart), castInfo.timeEnd - castInfo.timeStart))					
				end
				plate.castBar.text:SetText(castInfo.spell)
				plate.castBar.timer:SetText(getTimerLeft(castInfo.timeEnd)..'s')
				plate.castBar.icon:SetTexture(castInfo.icon)
				plate.castBar:SetAlpha(plate:GetAlpha())
				plate.castBar:Show()
			end
		end

	end
	-------------------------------------------------------------------------------
	local addBuffs = function(plate, name)
		local maxBuffs = 3
		
		if not plate.buffs then			
			plate.buffs = {}
			for i = 1, maxBuffs do
				local buffWidth, buffHeight = 24, 16
				
				plate.buffs[i] = CreateFrame('Frame', 'NamePlateBuff'..i, plate)
				plate.buffs[i]:SetWidth(buffWidth) plate.buffs[i]:SetHeight(buffHeight)
				
				if i == 1 then
					plate.buffs[i]:SetPoint('BOTTOMLEFT', plate, 'TOPLEFT', 5, -2)
				else
					plate.buffs[i]:SetPoint('LEFT', plate.buffs[i-1], 'RIGHT', 7, 0)
				end
								
				if IsAddOnLoaded'modui' then
					modSkin(plate.buffs[i], 14.5)
					modSkinPadding(plate.buffs[i], 2)
				end

				plate.buffs[i].icon = plate.buffs[i]:CreateTexture(nil, 'ARTWORK')
				plate.buffs[i].icon:SetAllPoints()
				plate.buffs[i].icon:SetTexCoord(.1, .9, .25, .75)

				plate.buffs[i].duration = plate.buffs[i]:CreateFontString(nil, 'OVERLAY')--, 'GameFontNormalSmall')
				plate.buffs[i].duration:SetFont(STANDARD_TEXT_FONT, 10, 'OUTLINE')
				plate.buffs[i].duration:SetTextColor(1, 1, 1)
				plate.buffs[i].duration:SetPoint('CENTER', plate.buffs[i], 'BOTTOM', 0, -2)
			end
			print('adddind buffs')
		end
		
        local v = SPELLCASTINGCOREgetPrioBuff(name, maxBuffs)
        for i = 1, maxBuffs do
            plate.buffs[i]:Hide()
        end

		for i, e in pairs(v) do
			plate.buffs[i]:Show()
			plate.buffs[i].icon:SetTexture(e.icon)
			plate.buffs[i].duration:SetText(getTimerLeft(e.timeEnd))
			if IsAddOnLoaded'modui' then
				local r, g, b = e.border[1], e.border[2], e.border[3]
				modSkinColor(plate.buffs[i], r, g, b)
			end
			
		end

	end
	-------------------------------------------------------------------------------
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
				-- fills a list to help display accurate health values of enemies with visible plates
				-- redudant to include target and mouseover units
				if n ~= nt and n ~= nmo then
					list[n] = {['name'] = n, ['health'] = h}
				end
				
				-- add additional nameplate elements
				local player = ENEMYFRAMECOREgetPlayer(n)
				if player then
					-- raid target
					addRaidTarget(plate, player['name'], raidTargets)
					-- class colors
					addClassColor(health, player['class'])
					-- castbars	--either all or enemies only
					--addCastbar(plate, SPELLCASTINGCOREgetCast(n))--player['castinfo'])
				end
				-- everyone's casts
				addCastbar(plate, n)
				-- everyone's auras
				addBuffs(plate, n)
			end
		end
		
		-- check if table is not empty
		if next(list) ~= nil then
			ENEMYFRAMECORESetPlayersData(list)
		end
	end
	-------------------------------------------------------------------------------
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
	-------------------------------------------------------------------------------
	local function eventHandler()
		f:SetScript('OnUpdate', nil)
	end
		
	f:RegisterEvent'PLAYER_ENTERING_WORLD'
	f:RegisterEvent'ZONE_CHANGED_NEW_AREA'
	f:SetScript('OnEvent', eventHandler)
	-------------------------------------------------------------------------------