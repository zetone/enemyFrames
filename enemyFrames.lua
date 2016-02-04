
local playerFaction
-- TIMERS
local refreshUnits = true
local ktInterval, ktEndtime = 3, 0
-- LISTS
local playerList = {}
local unitLimit, unitGroup = 15, 5
local units = {}

local visible = true
local moduiLoaded = false
local enabled = false

local killTargetName = ''
---

------------ UI ELEMENTS ------------------
local TEXTURE = [[Interface\AddOns\enemyFrames\globals\resources\barTexture.tga]]
local BACKDROP = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],}
local defaultIcon = 'rank'
local enemyFactionColor

local frameMovable = true
local 	enemyFrame = CreateFrame('Frame', 'enemyFrameDisplay', UIParent)
		enemyFrame:SetFrameStrata("BACKGROUND")
		enemyFrame:SetPoint('CENTER', UIParent)		
		enemyFrame:SetHeight(20)
		
		enemyFrame:SetBackdrop(BACKDROP)
		enemyFrame:SetBackdropColor(0, 0, 0, .6)
		
		enemyFrame:SetMovable(true)
		enemyFrame:EnableMouse(true)
		enemyFrame:SetClampedToScreen(true)
		
		enemyFrame:SetScript('OnDragStart', function() if frameMovable then this:StartMoving() end end)
		enemyFrame:SetScript('OnDragStop', function() if frameMovable then  this:StopMovingOrSizing() end end)
		enemyFrame:RegisterForDrag('LeftButton')
		
		enemyFrame.Title = enemyFrame:CreateFontString(nil, 'OVERLAY')
		enemyFrame.Title:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')		
		
		enemyFrame.totalPlayers = enemyFrame:CreateFontString(nil, 'OVERLAY')
		enemyFrame.totalPlayers:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
		
		enemyFrame.spawnText = enemyFrame:CreateFontString(nil, 'OVERLAY')
		enemyFrame.spawnText:SetFont(STANDARD_TEXT_FONT, 16, 'OUTLINE')
		enemyFrame.spawnText:SetText('-')
		
		enemyFrame.spawnText.Button = CreateFrame('Button', nil, enemyFrame)
		enemyFrame.spawnText.Button:SetHeight(15)	enemyFrame.spawnText.Button:SetWidth(15)
		
		-- bottom frame
		enemyFrame.bottom = CreateFrame('Frame', nil, enemyFrame)
		--enemyFrame.bottom:SetFrameStrata("BACKGROUND")
		enemyFrame.bottom:SetFrameLevel(0)
		enemyFrame.bottom:ClearAllPoints()		
		enemyFrame.bottom:SetHeight(enemyFrame:GetHeight())
		
		enemyFrame.bottom:SetBackdrop(BACKDROP)
		enemyFrame.bottom:SetBackdropColor(0, 0, 0, .6)
		
		-- setttings button


		
		--enemyFrame.bottom:Hide()
		-- class
		enemyFrame.bottom.classButton = CreateFrame('Button', nil, enemyFrame.bottom)
		enemyFrame.bottom.classButton:SetHeight(enemyFrame:GetHeight()-6)	enemyFrame.bottom.classButton:SetWidth(enemyFrame:GetHeight()-4)
		enemyFrame.bottom.classButton:SetPoint('LEFT', enemyFrame.bottom, 'LEFT', 8, 0)
		
		enemyFrame.bottom.classIcon = enemyFrame.bottom.classButton:CreateTexture(nil, 'ARTWORK')
		enemyFrame.bottom.classIcon:SetAllPoints()
		enemyFrame.bottom.classIcon:SetTexture(GET_DEFAULT_ICON('class', 'WARRIOR'))
		enemyFrame.bottom.classIcon:SetTexCoord(.1, .9, .25, .75)
		
		-- rank
		enemyFrame.bottom.rankButton = CreateFrame('Button', nil, enemyFrame.bottom)
		enemyFrame.bottom.rankButton:SetHeight(enemyFrame:GetHeight()-6)	enemyFrame.bottom.rankButton:SetWidth(enemyFrame:GetHeight()-4)
		enemyFrame.bottom.rankButton:SetPoint('LEFT', enemyFrame.bottom.classButton, 'RIGHT', 8, 0)
		
		enemyFrame.bottom.rankIcon = enemyFrame.bottom.rankButton:CreateTexture(nil, 'ARTWORK')
		enemyFrame.bottom.rankIcon:SetAllPoints()
		enemyFrame.bottom.rankIcon:SetTexture(GET_DEFAULT_ICON('rank', 10))
		enemyFrame.bottom.rankIcon:SetTexCoord(.1, .9, .25, .75)
		
		-- race
		enemyFrame.bottom.raceButton = CreateFrame('Button', nil, enemyFrame.bottom)
		enemyFrame.bottom.raceButton:SetHeight(enemyFrame:GetHeight()-6)	enemyFrame.bottom.raceButton:SetWidth(enemyFrame:GetHeight()-4)
		enemyFrame.bottom.raceButton:SetPoint('LEFT', enemyFrame.bottom.rankButton, 'RIGHT', 8, 0)
		
		enemyFrame.bottom.raceIcon = enemyFrame.bottom.raceButton:CreateTexture(nil, 'ARTWORK')
		enemyFrame.bottom.raceIcon:SetAllPoints()
		enemyFrame.bottom.raceIcon:SetTexCoord(.1, .9, .25, .75)
		
		----- killTarget
		enemyFrame.killTargetFrame = CreateFrame('Frame', nil, enemyFrame)
		enemyFrame.killTargetFrame:SetFrameLevel(2)
		enemyFrame.killTargetFrame:SetHeight(36)	enemyFrame.killTargetFrame:SetWidth(36)
		enemyFrame.killTargetFrame:SetPoint('CENTER', UIParent, 0, 150)
		enemyFrame.killTargetFrame:Hide()

		enemyFrame.killTargetFrame.text = enemyFrame.killTargetFrame:CreateFontString(nil, 'OVERLAY')
		enemyFrame.killTargetFrame.text:SetFont(STANDARD_TEXT_FONT, 18, 'OUTLINE')
		enemyFrame.killTargetFrame.text:SetTextColor(.8, .8, .8, .8)
		enemyFrame.killTargetFrame.text:SetPoint('CENTER', killTargetFrame)
		enemyFrame.killTargetFrame.text:SetText('Player')
	
		enemyFrame.killTargetFrame.iconl = enemyFrame.killTargetFrame:CreateTexture(nil, 'OVERLAY')
		enemyFrame.killTargetFrame.iconl:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
		enemyFrame.killTargetFrame.iconl:SetTexCoord(.75, 1, 0.25, .5)
		enemyFrame.killTargetFrame.iconl:SetHeight(36)	enemyFrame.killTargetFrame.iconl:SetWidth(36)
		enemyFrame.killTargetFrame.iconl:SetPoint('RIGHT', enemyFrame.killTargetFrame.text, 'LEFT', -6, 0)
		
		enemyFrame.killTargetFrame.iconr = enemyFrame.killTargetFrame:CreateTexture(nil, 'OVERLAY')
		enemyFrame.killTargetFrame.iconr:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
		enemyFrame.killTargetFrame.iconr:SetTexCoord(.75, 1, 0.25, .5)
		enemyFrame.killTargetFrame.iconr:SetHeight(36)	enemyFrame.killTargetFrame.iconr:SetWidth(36)
		enemyFrame.killTargetFrame.iconr:SetPoint('LEFT', enemyFrame.killTargetFrame.text, 'RIGHT', 6, 0)

		
local unitWidth, unitHeight, castBarHeight, ccIconWidth, ccIconHeight = 64, 20, 10, 28, 24
for i = 1, unitLimit,1 do
	-- health statusbar
	units[i] = CreateFrame('StatusBar', 'enemyFrameUnit'..i, enemyFrame)
	units[i]:SetFrameLevel(0)
	units[i]:SetStatusBarTexture(TEXTURE)
	units[i]:SetWidth(unitWidth)	units[i]:SetHeight(unitHeight)
	units[i]:SetMinMaxValues(0, 100)
	--[[
	local pos = math.mod(i,unitGroup)
	if pos == 1 then
		if i == 1 then	
			units[i]:SetPoint('TOPLEFT', enemyFrame, 'BOTTOMLEFT', 0, -6)
		else			
			units[i]:SetPoint('TOPLEFT', units[i-unitGroup].cc, 'TOPRIGHT', 6, 1)
		end			
	else
		units[i]:SetPoint('TOPLEFT', units[i-1].castbar.icon, 'BOTTOMLEFT', 1, -6)
	end	]]--	
	
	--if i == 1 then	
	--	units[i]:SetPoint('TOPLEFT', enemyFrame, 'BOTTOMLEFT', 0, -6)
	--else			
	--	units[i]:SetPoint('TOPLEFT', units[i-1].castbar.iconborder, 'BOTTOMLEFT', 1, -6)
	--end	
	--units[i]:SetPoint('TOPLEFT', enemyFrame, 'BOTTOMLEFT', 0, -(6 + unitHeight + castBarHeight)*(i-1)+6)
	
	units[i]:SetBackdrop(BACKDROP)
	units[i]:SetBackdropColor(0, 0, 0, .6)
	
	--[[
	-- mana statusbar
	units[i].manabar = CreateFrame('StatusBar', nil, units[i])
	units[i].manabar:SetFrameLevel(1)
	units[i].manabar:SetStatusBarTexture(TEXTURE)
	units[i].manabar:SetHeight(unitHeight*.10)
	units[i].manabar:SetWidth(unitWidth)	
	units[i].manabar:SetMinMaxValues(0, 100)	
	units[i].manabar:SetPoint('TOPLEFT', units[i], 'BOTTOMLEFT', 0, 2)
	
	units[i].manabar:SetBackdrop(BACKDROP)
	units[i].manabar:SetBackdropColor(0, 0, 0)
	]]--
	--modSkin(units[i].manabar, 8)
	--modSkinPadding(units[i].manabar, 1)
	--modSkinColor(units[i].manabar, .2, .2, .2)
	
	-- cast bar --
	units[i].castbar = CreateFrame('StatusBar', nil, units[i])
	units[i].castbar:SetFrameLevel(0)
	units[i].castbar:SetStatusBarTexture(TEXTURE)
	units[i].castbar:SetHeight(castBarHeight)
	units[i].castbar:SetWidth(unitWidth - (units[i].castbar:GetHeight()))	
	units[i].castbar:SetStatusBarColor(1, .4, 0)
	units[i].castbar:SetPoint('TOPRIGHT', units[i], 'BOTTOMRIGHT', 0, -3)
	
	units[i].castbar:SetBackdrop(BACKDROP)
	units[i].castbar:SetBackdropColor(0, 0, 0, .6)
	
	
	units[i].castbar.iconborder = CreateFrame('Frame', nil, units[i].castbar)
	units[i].castbar.iconborder:SetWidth(units[i].castbar:GetHeight()+1)	units[i].castbar.iconborder:SetHeight(units[i].castbar:GetHeight()+1)
	units[i].castbar.iconborder:SetPoint('RIGHT', units[i].castbar, 'LEFT')
	
	units[i].castbar.icon = units[i].castbar.iconborder:CreateTexture(nil, 'ARTWORK')
	units[i].castbar.icon:SetTexture([[Interface\Icons\Inv_misc_gem_sapphire_01]])
	units[i].castbar.icon:SetTexCoord(.078, .92, .079, .937)
	units[i].castbar.icon:SetAllPoints()
	units[i].castbar.icon:SetPoint('CENTER', units[i].castbar.iconborder, 'CENTER')
	
	units[i].castbar.text = units[i].castbar:CreateFontString(nil, 'OVERLAY')
	units[i].castbar.text:SetTextColor(1, 1, 1)
	units[i].castbar.text:SetFont(STANDARD_TEXT_FONT, 8)
	units[i].castbar.text:SetShadowOffset(1, -1)
	units[i].castbar.text:SetShadowColor(0, 0, 0)
	units[i].castbar.text:SetPoint('LEFT', units[i].castbar, 'LEFT', 2, 1)
	units[i].castbar.text:SetText('Entangling Roots')
	units[i].castbar.text:SetText(string.sub(units[i].castbar.text:GetText(), 1, 11))
	
	--[[
	units[i].castbar.timer = units[i].castbar:CreateFontString(nil, 'OVERLAY')
	units[i].castbar.timer:SetFont(STANDARD_TEXT_FONT, 8)
	units[i].castbar.timer:SetTextColor(1, 1, 1)
	units[i].castbar.timer:SetShadowOffset(1, -1)
	units[i].castbar.timer:SetShadowColor(0, 0, 0)
	units[i].castbar.timer:SetPoint('LEFT', units[i].castbar, 'RIGHT', 2, 1)
	units[i].castbar.timer:SetText('1.5')]]--
	--------------

	units[i].name = units[i]:CreateFontString(nil, 'OVERLAY')
	units[i].name:SetFont(STANDARD_TEXT_FONT, 11, 'OUTLINE')
	units[i].name:SetTextColor(.8, .8, .8, .8)
	units[i].name:SetPoint('CENTER', units[i])	
	units[i].name:SetText('Player' .. i)
	
	---- KILL TARGET
	units[i].killTarget = CreateFrame('Frame', nil, units[i])
	units[i].killTarget:SetWidth(ccIconWidth-2) units[i].killTarget:SetHeight(ccIconHeight-2)
	units[i].killTarget:SetPoint('CENTER', units[i],'TOPRIGHT', 0, -6)
	units[i].killTarget:SetFrameLevel(2)
	
	units[i].killTarget.icon = units[i].killTarget:CreateTexture(nil, 'ARTWORK')
	units[i].killTarget.icon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	units[i].killTarget.icon:SetTexCoord(.75, 1, 0.25, .5)
	units[i].killTarget.icon:SetAllPoints()
	
	
	---- CC ------
	units[i].cc = CreateFrame('Frame', nil, units[i])
	units[i].cc:SetWidth(ccIconWidth) units[i].cc:SetHeight(ccIconHeight)
	units[i].cc:SetPoint('TOPLEFT', units[i],'TOPRIGHT', 4, -1)

	units[i].cc.icon = units[i].cc:CreateTexture(nil, 'ARTWORK')
	units[i].cc.icon:SetTexture([[Interface\characterframe\TEMPORARYPORTRAIT-MALE-ORC]])
	units[i].cc.icon:SetAllPoints()
	units[i].cc.icon:SetTexCoord(.1, .9, .25, .75)
	
	units[i].cc.bg = units[i].cc:CreateTexture(nil, 'BACKGROUND')
	units[i].cc.bg:SetTexture(0, 0, 0, .6)
	units[i].cc.bg:SetAllPoints()

	units[i].cc.duration = units[i].cc:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
	units[i].cc.duration:SetFont(STANDARD_TEXT_FONT, 12)
	units[i].cc.duration:SetTextColor(1, 1, 1)
	units[i].cc.duration:SetShadowOffset(1, -1)
	units[i].cc.duration:SetShadowColor(0, 0, 0)
	units[i].cc.duration:SetPoint('CENTER', units[i].cc, 'BOTTOM', 0, -4)
	units[i].cc.duration:SetText('1.4')
	
	------- EXTRAS
	units[i].Button = CreateFrame('Button', nil, units[i])
	units[i].Button:SetAllPoints()
	units[i].Button:SetPoint('CENTER', units[i])
	units[i].Button:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
end

-- function for settings use
local function setccIcon(p)
	local d = p == 'class' and 'WARRIOR' or p == 'rank' and 6 or p == 'portrait' and ( playerFaction == 'Alliance' and 'MALE-ORC' or 'MALE-HUMAN')
	for i = 1, unitLimit do
		units[i].cc.icon:SetTexture(GET_DEFAULT_ICON(p, d))
	end
end
 
 if not enabled then setccIcon(defaultIcon)	end
 
local function arrangeUnits()
	unitGroup = 5--ENEMYFRAMESPLAYERDATA['groupsize']
	
	for i = 1, unitLimit do	
		if ENEMYFRAMESPLAYERDATA['layout'] == 'horizontal' then
			if i == 1 then	
				units[i]:SetPoint('TOPLEFT', enemyFrame, 'BOTTOMLEFT', 0, -6)
			else			
				units[i]:SetPoint('TOPLEFT', units[i-1].cc, 'TOPRIGHT', 6, 1)
			end	
		end
		if ENEMYFRAMESPLAYERDATA['layout'] == 'block' then
			local pos = math.mod(i,unitGroup)
			if pos == 1 then
				if i == 1 then	
					units[i]:SetPoint('TOPLEFT', enemyFrame, 'BOTTOMLEFT', 0, -6)
				else			
					units[i]:SetPoint('TOPLEFT', units[i-unitGroup].cc, 'TOPRIGHT', 6, 1)
				end			
			else
				units[i]:SetPoint('TOPLEFT', units[i-1].castbar.iconborder, 'BOTTOMLEFT', 1, -6)
			end	
		end
		if ENEMYFRAMESPLAYERDATA['layout'] == 'vertical' then
			if i == 1 then	
				units[i]:SetPoint('TOPLEFT', enemyFrame, 'BOTTOMLEFT', 0, -6)
			else			
				units[i]:SetPoint('TOPLEFT', units[i-1].castbar.iconborder, 'BOTTOMLEFT', 1, -6)
			end	
		end
	end
end

-- use modui to reskin some ui elements
local function moduiReSkin()
	TEXTURE = [[Interface\AddOns\modui\statusbar\texture\sb.tga]]
	
	-- enemyFrame
	modSkin(enemyFrame, 13)
	modSkinColor(enemyFrame, .2, .2, .2)
	
	modSkin(enemyFrame.bottom, 13)
	modSkinColor(enemyFrame.bottom, .2, .2, .2)
	
	-- individual unit ui
	for i = 1, unitLimit do
		-- health bar
		units[i]:SetStatusBarTexture(TEXTURE)
		modSkin(units[i], 8)
		modSkinPadding(units[i], 1)
		
		-- castbar
		units[i].castbar:SetStatusBarTexture(TEXTURE)
		units[i].castbar:SetStatusBarColor(1, .4, 0)
		modSkin(units[i].castbar, 8)
		modSkinPadding(units[i].castbar, 1)
		modSkinColor(units[i].castbar, .2, .2, .2)
		
		-- castbar icon
		modSkin(units[i].castbar.iconborder, 6)
		modSkinPadding(units[i].castbar.iconborder, 1)
		modSkinColor(units[i].castbar.iconborder, .2, .2, .2)
		
		-- cc icon
		modSkin(units[i].cc, 10)
		modSkinPadding(units[i].cc, 2)
	end
	
	moduiLoaded = true
end

-- check if modui loaded first		
if IsAddOnLoaded'modui' then
	moduiReSkin()
end

local function showHideUnits()
	if visible then
		for j=1, unitLimit, 1 do
			units[j]:SetAlpha(1)
		end
		enemyFrame.bottom:SetAlpha(1)
	else
		for j=1, unitLimit, 1 do
			units[j]:SetAlpha(0)
		end
		enemyFrame.bottom:SetAlpha(0)
	end
end

local function SetupTitle(maxUnits)
	-- get player's faction
	playerFaction = UnitFactionGroup('player')
	
	if playerFaction == 'Alliance' then 
		enemyFactionColor = RGB_FACTION_COLORS['Horde']
		enemyFrame.Title:SetText('Horde')
	else 
		enemyFactionColor = RGB_FACTION_COLORS['Alliance']
		enemyFrame.Title:SetText('Alliance')		
	end
	
	enemyFrame.Title:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
	enemyFrame.spawnText:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
	enemyFrame.totalPlayers:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
		
	-- width of the draggable frame
	local rows = maxUnits / ENEMYFRAMESPLAYERDATA['groupsize']
	enemyFrame:SetWidth((unitWidth + ccIconWidth)*rows +  8*rows)
	
	enemyFrame.Title:SetPoint('CENTER', enemyFrame, 0, 1)
	enemyFrame.totalPlayers:SetPoint('RIGHT', enemyFrame, 'RIGHT', -4, 1)
	enemyFrame.spawnText:SetPoint('LEFT', enemyFrame, 'LEFT', 8, 1)
	enemyFrame.spawnText.Button:SetPoint('CENTER', enemyFrame.spawnText, 'CENTER')
	enemyFrame.spawnText.Button:SetScript('OnClick', function()
			local t, tt
			if visible then
				t = '+'
				tt = 'Show'
				visible = false
			else
				t = '-'
				tt = 'Hide'				
				visible = true
			end
			enemyFrame.spawnText:SetText(t)
			showHideUnits()
		end)
		
	-- bottom frame
	enemyFrame.bottom:SetWidth(enemyFrame:GetWidth())
	--enemyFrame.bottom:SetPoint('CENTER', enemyFrame, 0, -((unitHeight + castBarHeight + 15) * unitGroup))
	enemyFrame.bottom:SetPoint('TOPLEFT', units[maxUnits < ENEMYFRAMESPLAYERDATA['groupsize'] and maxUnits or ENEMYFRAMESPLAYERDATA['groupsize']].castbar.icon, 'BOTTOMLEFT', 1, -6)
	
	if defaultIcon == 'class' then
		enemyFrame.bottom.classIcon:SetBlendMode('BLEND')
		enemyFrame.bottom.classIcon:SetVertexColor(1, 1, 1)
		enemyFrame.bottom.rankIcon:SetBlendMode('ADD')
		enemyFrame.bottom.rankIcon:SetVertexColor(.3, .3, .3)
		enemyFrame.bottom.raceIcon:SetBlendMode('ADD')
		enemyFrame.bottom.raceIcon:SetVertexColor(.3, .3, .3)
	elseif defaultIcon == 'rank' then
		enemyFrame.bottom.classIcon:SetBlendMode('ADD')
		enemyFrame.bottom.classIcon:SetVertexColor(.3, .3, .3)
		enemyFrame.bottom.rankIcon:SetBlendMode('BLEND')
		enemyFrame.bottom.rankIcon:SetVertexColor(1, 1, 1)
		enemyFrame.bottom.raceIcon:SetBlendMode('ADD')
		enemyFrame.bottom.raceIcon:SetVertexColor(.3, .3, .3)
	else
		enemyFrame.bottom.classIcon:SetBlendMode('ADD')
		enemyFrame.bottom.classIcon:SetVertexColor(.3, .3, .3)
		enemyFrame.bottom.rankIcon:SetBlendMode('ADD')
		enemyFrame.bottom.rankIcon:SetVertexColor(.3, .3, .3)
		enemyFrame.bottom.raceIcon:SetBlendMode('BLEND')
		enemyFrame.bottom.raceIcon:SetVertexColor(1, 1, 1)
	end
	
	-- class/rank/race buttons
	enemyFrame.bottom.classButton:SetScript('OnClick', function()
			defaultIcon = 'class'
			ENEMYFRAMESPLAYERDATA['defaultIcon'] = 'class'
			
			enemyFrame.bottom.classIcon:SetBlendMode('BLEND')
			enemyFrame.bottom.classIcon:SetVertexColor(1, 1, 1)
			enemyFrame.bottom.rankIcon:SetBlendMode('ADD')
			enemyFrame.bottom.rankIcon:SetVertexColor(.3, .3, .3)
			enemyFrame.bottom.raceIcon:SetBlendMode('ADD')
			enemyFrame.bottom.raceIcon:SetVertexColor(.3, .3, .3)
			
			if not enabled then setccIcon(defaultIcon)	end
		end)
	
	enemyFrame.bottom.rankButton:SetScript('OnClick', function()
			defaultIcon = 'rank'
			ENEMYFRAMESPLAYERDATA['defaultIcon'] = 'rank'
			
			enemyFrame.bottom.classIcon:SetBlendMode('ADD')
			enemyFrame.bottom.classIcon:SetVertexColor(.3, .3, .3)
			enemyFrame.bottom.rankIcon:SetBlendMode('BLEND')
			enemyFrame.bottom.rankIcon:SetVertexColor(1, 1, 1)
			enemyFrame.bottom.raceIcon:SetBlendMode('ADD')
			enemyFrame.bottom.raceIcon:SetVertexColor(.3, .3, .3)
			
			if not enabled then setccIcon(defaultIcon)	end
		end)
		
	local r = playerFaction == 'Alliance' and 'MALE-ORC' or 'MALE-HUMAN'
	enemyFrame.bottom.raceIcon:SetTexture(GET_DEFAULT_ICON('portrait', r))
	enemyFrame.bottom.raceButton:SetScript('OnClick', function()
			defaultIcon = 'portrait'
			ENEMYFRAMESPLAYERDATA['defaultIcon'] = 'portrait'

						
			enemyFrame.bottom.classIcon:SetBlendMode('ADD')
			enemyFrame.bottom.classIcon:SetVertexColor(.3, .3, .3)
			enemyFrame.bottom.rankIcon:SetBlendMode('ADD')
			enemyFrame.bottom.rankIcon:SetVertexColor(.3, .3, .3)
			enemyFrame.bottom.raceIcon:SetBlendMode('BLEND')
			enemyFrame.bottom.raceIcon:SetVertexColor(1, 1, 1)
			
			if not enabled then setccIcon(defaultIcon)	end
		end)
	
end

local function drawUnits(list)
			
	playerList = list
	local i, nearU = 1, 0
	for k,v in pairs(playerList) do
		local colour = RAID_CLASS_COLORS[v['class']]
		local powerColor = GET_RGB_POWER_COLORS_BY_CLASS(v['class'])
		
		-- hightlight nearby unit
		if v['nearby'] then		
			units[i]:SetStatusBarColor(colour.r, colour.g, colour.b)
			units[i].name:SetTextColor(colour.r, colour.g, colour.b)			
			--units[i].manabar:SetStatusBarColor(powerColor[1], powerColor[2], powerColor[3])			
			units[i].cc.icon:SetVertexColor(1, 1, 1, 1)
						
			nearU = nearU + 1
		else
			units[i]:SetStatusBarColor(colour.r / 2, colour.g / 2, colour.b / 2, .6)
			--units[i].manabar:SetStatusBarColor(powerColor[1] / 2, powerColor[2] / 2, powerColor[3] / 2)
			units[i].name:SetTextColor(colour.r / 2, colour.g / 2, colour.b / 2, .6)			
			units[i].cc.icon:SetVertexColor(.4, .4, .4, .6)
		end
		-- hightlight fc
		if v['fc'] then
			units[i].cc.icon:SetVertexColor(1, 1, 1, 1)
		end
		
		units[i].name:SetText(v['name'])
		units[i].name:SetText(string.sub(units[i].name:GetText(), 1, 7))
		
		-- button function to target unit
		units[i].Button.tar = v['name']
		units[i].Button:SetScript('OnClick', function()	if arg1 == 'LeftButton'  then  	TargetByName(this.tar, true)			end
														if arg1 == 'RightButton' then	enemyFrame.killTargetFrame:Hide()
																						ENEMYFRAMECORESendKillTarget(this.tar)	end
														end)
		
		units[i]:Show()
		i = i + 1
	end
	
	for j=i, unitLimit, 1 do
		if units[j]:IsShown() then
			units[j]:Hide()
		end
	end

	enemyFrame.totalPlayers:SetText(nearU .. ' / ' .. i-1)
end

local function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end
local getTimerLeft = function(tEnd)
	local t = tEnd - GetTime()
	if t > 5 then return round(t, 0) else return round(t, 1) end
end
	
local function SetDefaultIconTex(p)
	--return v['rank'] < 0 and  GET_PORTRAIT_ICON(v['portrait']) or _G['GET_'..string.upper(defaultIcon)..'_ICON'](v[defaultIcon])
	p['portrait']	= p['sex'] .. '-' .. p['race']
	local d = defaultIcon
	if d == 'rank' and p['rank'] < 0 then d = 'portrait' end
	return GET_DEFAULT_ICON(d, p[d])
end

-- health, castbar, cc etc
local function updateUnits()
	local i = 1
	
	for k, v in pairs(playerList) do
		-- target indicator
		if UnitName'target' == v['name'] then
			if moduiLoaded then
				modSkinColor(units[i], enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'])
			end
			units[i]:SetBackdropColor(enemyFactionColor['r'] - .6, enemyFactionColor['g'] - .6, enemyFactionColor['b'] - .6, .6)
		else
			if moduiLoaded then
				modSkinColor(units[i], .2, .2, .2)
			end
			units[i]:SetBackdropColor(0, 0, 0, .6)
		end
		-- castbar
		local castInfo = v['castinfo']--
		units[i].castbar:Hide()
		if castInfo ~= nil then
			units[i].castbar:SetMinMaxValues(0, castInfo.timeEnd - castInfo.timeStart)
			
			if castInfo.inverse then
				units[i].castbar:SetValue(mod((castInfo.timeEnd - GetTime()), castInfo.timeEnd - castInfo.timeStart))
			else
				units[i].castbar:SetValue(mod((GetTime() - castInfo.timeStart), castInfo.timeEnd - castInfo.timeStart))					
			end
			units[i].castbar.text:SetText(castInfo.spell)
			units[i].castbar.text:SetText(string.sub(units[i].castbar.text:GetText(), 1, 11))
			--units[i].castbar.timer:SetText(getTimerLeft(castInfo.timeEnd))--..'s')
			units[i].castbar.icon:SetTexture(castInfo.icon)
			units[i].castbar:Show()		
		end
		
		units[i]:SetValue(v['health'] and v['health'] or not v['nearby'] and 100 or 100)
		--if v['health'] 	then 	units[i]:SetValue(v['health']) 			end
		--if v['mana']	then	units[i].manabar:SetValue(v['mana'])	end
		
		-- KILL TARGET
		if killTargetName == v['name'] then
			units[i].killTarget:Show()
		else
			units[i].killTarget:Hide()
		end
		
		-- CC type
		local b = v['buff']--
		if b ~= nil then
			units[i].cc.icon:SetTexture(b.icon)
			units[i].cc.duration:SetText(getTimerLeft(b.timeEnd))
			local r, g, b = b.border[1], b.border[2], b.border[3]
			if moduiLoaded then modSkinColor(units[i].cc, r, g, b) end
		else
			-- signal FC or class / rank
			units[i].cc.icon:SetTexture(v['fc'] and SPELLINFO_WSG_FLAGS[playerFaction]['icon'] or SetDefaultIconTex(v))
			-- show target player portrait
			if UnitName('target') == v['name'] and not v['fc'] and defaultIcon == 'portrait' then
				SetPortraitTexture(units[i].cc.icon, 'target')
			end

			if moduiLoaded then modSkinColor(units[i].cc, .2, .2, .2)	end
			units[i].cc.duration:SetText('')
		end
		
		i = i + 1
		if i > unitLimit then return end
	end
	
	-- killTarget
	if ktEndtime < GetTime() then
		enemyFrame.killTargetFrame:Hide()
	end
end

local function enemyFramesOnUpdate()
	-- get updated units from core
	local list = ENEMYFRAMESCOREGetUnitsInfo()
	-- if theres anything to update do so
	if list then 	drawUnits(list) end
	
	-- update units
	if visible then updateUnits()	
		killTargetName = ENEMYFRAMECOREGetKillTarget()	
	end
end


--- GLOBAL ACCESS ---
function ENEMYFRAMESAnnounceKT(kt)
	enemyFrame.killTargetFrame.text:SetText(kt['name'])
	enemyFrame.killTargetFrame.text:SetTextColor(RAID_CLASS_COLORS[kt['class']].r, RAID_CLASS_COLORS[kt['class']].g, RAID_CLASS_COLORS[kt['class']].b)
	enemyFrame.killTargetFrame:Show()
	ktEndtime = GetTime() + ktInterval
end

function ENEMYFRAMESInitialize(maxUnits)
		
	if maxUnits then
		defaultIcon = ENEMYFRAMESPLAYERDATA['defaultIcon']
		SetupTitle(maxUnits)
		arrangeUnits()
		enabled = true
		
		enemyFrame:Show()
		enemyFrame:SetScript('OnUpdate', enemyFramesOnUpdate)
	else
		enemyFrame:SetScript('OnUpdate', nil)
	end
end

function ENEMYFRAMESsettings()
	SetupTitle(15)
	arrangeUnits()
end
---------------------

local function eventHandler()
	if event == 'PLAYER_ENTERING_WORLD' or event == 'ZONE_CHANGED_NEW_AREA' then
		enabled = false
		enemyFrame:Hide()
		--
	elseif event == 'ADDON_LOADED' then
		if arg1 == 'modui' then
			moduiReSkin()
		end
	end
end

enemyFrame:RegisterEvent'PLAYER_ENTERING_WORLD'
enemyFrame:RegisterEvent'ZONE_CHANGED_NEW_AREA'
enemyFrame:RegisterEvent'ADDON_LOADED'
enemyFrame:SetScript('OnEvent', eventHandler)


SLASH_ENEMYFRAMES1 = '/efd'
SlashCmdList["ENEMYFRAMES"] = function(msg)
	SetupTitle(15)
	arrangeUnits()
	enemyFrame:Show()	

	enemyFrame:SetScale(ENEMYFRAMESPLAYERDATA['scale'])
	--[[
	icon = UIParent:CreateTexture(nil, 'ARTWORK')
	icon:SetTexture(GET_RANK_ICON(7))
	icon:SetHeight(16)	icon:SetWidth(16)
	icon:SetPoint('CENTER', UIParent)]]--
end


