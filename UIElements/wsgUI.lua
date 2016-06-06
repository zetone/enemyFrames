	-------------------------------------------------------------------------------
	local flagCarriers = {}
	local fcHealth = {}
	local sentAnnoucement, healthWarnings = false, {10, 30, 50}
	local nextAnnouncement = 0
	-------------------------------------------------------------------------------
	local h = UIParent:CreateFontString(nil, 'OVERLAY')
    h:SetFontObject(GameFontNormalSmall)
    h:SetTextColor(RGB_FACTION_COLORS['Alliance']['r'], RGB_FACTION_COLORS['Alliance']['g'], RGB_FACTION_COLORS['Alliance']['b'])
    h:SetJustifyH'LEFT'
	h:SetText('horde')
	
	local hh = UIParent:CreateFontString(nil, 'OVERLAY')
    hh:SetFontObject(GameFontNormalSmall)
	--hh:SetTextColor(.59, .98, .59)
    hh:SetJustifyH'RIGHT'
    hh:SetPoint('LEFT', h, 'RIGHT', 2, 0)

	
    local a = UIParent:CreateFontString(nil, 'OVERLAY')
    a:SetFontObject(GameFontNormalSmall)
	a:SetTextColor(RGB_FACTION_COLORS['Horde']['r'], RGB_FACTION_COLORS['Horde']['g'], RGB_FACTION_COLORS['Horde']['b'])
    a:SetJustifyH'LEFT'
	a:SetText('alliance')
	
	local ah = UIParent:CreateFontString(nil, 'OVERLAY')
    ah:SetFontObject(GameFontNormalSmall)
	--ah:SetTextColor(.59, .98, .59)
    ah:SetJustifyH'RIGHT'
    ah:SetPoint('LEFT', a, 'RIGHT', 2, 0)
	-------------------------------------------------------------------------------
	WSGUIupdateFC = function(fc)
		flagCarriers = fc
		
		if flagCarriers['Alliance'] then
			a:SetText(flagCarriers['Alliance'])
		else
			a:SetText('')
			ah:SetText('')
			fcHealth['Alliance'] = nil
		end
		
		if flagCarriers['Horde'] then
			h:SetText(flagCarriers['Horde'])
		else
			h:SetText('')
			hh:SetText('')
			fcHealth['Horde'] = nil
		end
	end
	-------------------------------------------------------------------------------
	local w = 100
	local efcLowHealth = function()
		local f = UnitFactionGroup'player'
		local x = UnitFactionGroup'player' == 'Alliance' and 'Horde' or 'Alliance'

		local now = GetTime()
		if flagCarriers[f] and fcHealth[f]  then
			for i = 1, tlength(healthWarnings) do
				if fcHealth[f] < healthWarnings[i]  then
					if (not sentAnnoucement or healthWarnings[i] < w) and now > nextAnnouncement then
						nextAnnouncement = now + 3
						w = healthWarnings[i]
						--print('EFC has less than '..healthWarnings[i]..'%! Get ready to cap!')
						local msgb = flagCarriers[x] and ' Get ready to cap!' or ''
						SendChatMessage('EFC is less than '..healthWarnings[i]..'%!'.. msgb, 'BATTLEGROUND')
						sentAnnoucement = true
					end
					return
				end
			end
		end
		sentAnnoucement = false
	end
	-------------------------------------------------------------------------------
	local function round(num, idp)
		local mult = 10^(idp or 0)
		return math.floor(num * mult + 0.5) / mult
	end
	local getPerc = function(unit)
		return round(((UnitHealth(unit) * 100) / UnitHealthMax(unit)), 1)
	end
	-------------------------------------------------------------------------------
	WSGUIupdateFChealth = function(unit)
		if unit then
			if UnitName(unit) == flagCarriers['Alliance'] then
				fcHealth['Alliance'] = getPerc(unit)
				ah:SetText(fcHealth['Alliance']..'%')
			end
			if UnitName(unit) == flagCarriers['Horde'] then
				fcHealth['Horde'] = getPerc(unit)
				hh:SetText(fcHealth['Horde']..'%')
			end
		end
		
		if ENEMYFRAMESPLAYERDATA['efcBGannouncement'] then
			efcLowHealth()
		end
	end
	-------------------------------------------------------------------------------
	WSGUIinit = function()
		local hb = _G['AlwaysUpFrame1DynamicIconButton']
		h:SetPoint('LEFT', hb, 'RIGHT', 4, 2)
		h:Show()
		h:SetText('')
		hh:Show()		
		hh:SetText('')
		
		local ab = _G['AlwaysUpFrame2DynamicIconButton']
		a:SetPoint('LEFT', ab, 'RIGHT', 4, 2)
		a:Show()
		a:SetText('')			
		ah:Show()
		ah:SetText('')
	end
	-------------------------------------------------------------------------------
	local f = CreateFrame'Frame'
	f:RegisterEvent'ZONE_CHANGED_NEW_AREA'
	f:RegisterEvent'PLAYER_ENTERING_WORLD'
	f:SetScript('OnEvent', function()
		--h:Hide()
		hh:Hide()
		--a:Hide()
		ah:Hide()
		flagCarriers = {}
	end)
	-------------------------------------------------------------------------------