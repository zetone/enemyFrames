
local playerFaction
-- TIMERS
local refreshUnits = true
local ktInterval, ktEndtime = 3, 0
local rtMenuInterval, rtMenuEndtime = 5, 0
-- LISTS
local playerList = {}
local unitLimit = 15
local units = {}
local raidTargets = {}
local raidIcons, raidIconsN = {[1] = 'skull', [2] = 'moon', [3] = 'square', [4] = 'triangle'}, 4

local moduiLoaded = false
local enabled = false

MOUSEOVERUNINAME = nil
---

------------ UI ELEMENTS ------------------
local TEXTURE = [[Interface\AddOns\enemyFrames\globals\resources\barTexture.tga]]
local BACKDROP = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],}
local enemyFactionColor

local 	enemyFrame = CreateFrame('Frame', 'enemyFrameDisplay', UIParent)
		enemyFrame:SetFrameStrata("BACKGROUND")
		enemyFrame:SetPoint('CENTER', UIParent, UIParent:GetHeight()/3, UIParent:GetHeight()/3)		
		enemyFrame:SetHeight(20)
		
		--enemyFrame:SetBackdrop(BACKDROP)
		--enemyFrame:SetBackdropColor(0, 0, 0, .6)
		
		enemyFrame:SetMovable(true)
		enemyFrame:EnableMouse(true)
		enemyFrame:SetClampedToScreen(true)
		
		enemyFrame:SetScript('OnDragStart', function() if ENEMYFRAMESPLAYERDATA['frameMovable'] then this:StartMoving() end end)
		enemyFrame:SetScript('OnDragStop', function() if ENEMYFRAMESPLAYERDATA['frameMovable'] then  this:StopMovingOrSizing() end end)
		enemyFrame:RegisterForDrag('LeftButton')
	
		
		enemyFrame.Title = enemyFrame:CreateFontString(nil, 'OVERLAY')
		enemyFrame.Title:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')		
		enemyFrame.Title:SetPoint('CENTER', enemyFrame, 0, 1)
		
		enemyFrame.totalPlayers = enemyFrame:CreateFontString(nil, 'OVERLAY')
		enemyFrame.totalPlayers:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
		enemyFrame.totalPlayers:SetPoint('RIGHT', enemyFrame, 'RIGHT', -4, 1)
		
		
		enemyFrame.spawnText = enemyFrame:CreateFontString(nil, 'OVERLAY')
		enemyFrame.spawnText:SetFont(STANDARD_TEXT_FONT, 16, 'OUTLINE')
		enemyFrame.spawnText:SetPoint('LEFT', enemyFrame, 'LEFT', 8, 1)		
		
		enemyFrame.spawnText.Button = CreateFrame('Button', nil, enemyFrame)
		enemyFrame.spawnText.Button:SetHeight(15)	enemyFrame.spawnText.Button:SetWidth(15)
		enemyFrame.spawnText.Button:SetPoint('CENTER', enemyFrame.spawnText, 'CENTER')
		enemyFrame.spawnText.Button:SetScript('OnEnter', function()
			enemyFrame.spawnText:SetTextColor(.9, .9, .4)
			GameTooltip:SetOwner(this, 'ANCHOR_TOPRIGHT', -30, -30)
			GameTooltip:SetText(this.tt)
			GameTooltip:Show()
		end)
		enemyFrame.spawnText.Button:SetScript('OnLeave', function()
			enemyFrame.spawnText:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
			GameTooltip:Hide()
		end)
		
			
		-- top frame
		
		enemyFrame.top = CreateFrame('Frame', nil, enemyFrame)
		enemyFrame.top:SetFrameLevel(0)
		enemyFrame.top:ClearAllPoints()		
		enemyFrame.top:SetHeight(enemyFrame:GetHeight())
		enemyFrame.top:SetBackdrop(BACKDROP)
		enemyFrame.top:SetBackdropColor(0, 0, 0, .6)
		
		-- bottom frame
		enemyFrame.bottom = CreateFrame('Frame', nil, enemyFrame)
		--enemyFrame.bottom:SetFrameStrata("BACKGROUND")
		enemyFrame.bottom:SetFrameLevel(0)
		enemyFrame.bottom:ClearAllPoints()		
		enemyFrame.bottom:SetHeight(enemyFrame:GetHeight())
		
		enemyFrame.bottom:SetBackdrop(BACKDROP)
		enemyFrame.bottom:SetBackdropColor(0, 0, 0, .6)
		
		-- settings button
		enemyFrame.bottom.settings = CreateFrame('Button', nil, enemyFrame.bottom)
		enemyFrame.bottom.settings:SetHeight(20)	enemyFrame.bottom.settings:SetWidth(20)
		enemyFrame.bottom.settings:SetPoint('RIGHT', enemyFrame.bottom, 'RIGHT', -6, 1)	
		
		enemyFrame.bottom.settings.text = enemyFrame.bottom.settings:CreateFontString(nil, 'OVERLAY')
		enemyFrame.bottom.settings.text:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
		enemyFrame.bottom.settings.text:SetText('S')
		
		enemyFrame.bottom.settings:SetScript('OnEnter', function()
			enemyFrame.bottom.settings.text:SetTextColor(.9, .9, .4)
			
			GameTooltip:SetOwner(this, 'ANCHOR_TOPRIGHT', -10, -60)
			GameTooltip:SetText('settings menu')
			GameTooltip:Show()
		end)
		enemyFrame.bottom.settings:SetScript('OnLeave', function()
			enemyFrame.bottom.settings.text:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
			GameTooltip:Hide()
		end)
		enemyFrame.bottom.settings:SetScript('OnClick', function()
												if enabled then setupSettings() end
												end)
		
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
		
		----- raidTarget
		enemyFrame.raidTargetFrame = CreateFrame('Frame', nil, enemyFrame)
		enemyFrame.raidTargetFrame:SetFrameLevel(2)
		enemyFrame.raidTargetFrame:SetHeight(36)	enemyFrame.raidTargetFrame:SetWidth(36)
		enemyFrame.raidTargetFrame:SetPoint('CENTER', UIParent,'CENTER', 0, 160)
		enemyFrame.raidTargetFrame:Hide()

		enemyFrame.raidTargetFrame.text = enemyFrame.raidTargetFrame:CreateFontString(nil, 'OVERLAY')
		enemyFrame.raidTargetFrame.text:SetFont(STANDARD_TEXT_FONT, 18, 'OUTLINE')
		enemyFrame.raidTargetFrame.text:SetTextColor(.8, .8, .8, .8)
		enemyFrame.raidTargetFrame.text:SetPoint('CENTER', enemyFrame.raidTargetFrame)
		enemyFrame.raidTargetFrame.text:SetText('Player')
	
		enemyFrame.raidTargetFrame.iconl = enemyFrame.raidTargetFrame:CreateTexture(nil, 'OVERLAY')
		enemyFrame.raidTargetFrame.iconl:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
		enemyFrame.raidTargetFrame.iconl:SetTexCoord(.75, 1, 0.25, .5)
		enemyFrame.raidTargetFrame.iconl:SetHeight(36)	enemyFrame.raidTargetFrame.iconl:SetWidth(36)
		enemyFrame.raidTargetFrame.iconl:SetPoint('RIGHT', enemyFrame.raidTargetFrame.text, 'LEFT', -6, 0)
		
		enemyFrame.raidTargetFrame.iconr = enemyFrame.raidTargetFrame:CreateTexture(nil, 'OVERLAY')
		enemyFrame.raidTargetFrame.iconr:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
		enemyFrame.raidTargetFrame.iconr:SetTexCoord(.75, 1, 0.25, .5)
		enemyFrame.raidTargetFrame.iconr:SetHeight(36)	enemyFrame.raidTargetFrame.iconr:SetWidth(36)
		enemyFrame.raidTargetFrame.iconr:SetPoint('LEFT', enemyFrame.raidTargetFrame.text, 'RIGHT', 6, 0)

		-- raidTarget menu
		local rtMenuIconsize = 26
		enemyFrame.raidTargetMenu = CreateFrame('Frame', nil, enemyFrame)
		enemyFrame.raidTargetMenu:SetFrameLevel(2)
		enemyFrame.raidTargetMenu:SetHeight(rtMenuIconsize+4)	enemyFrame.raidTargetMenu:SetWidth(rtMenuIconsize*raidIconsN+10)
		enemyFrame.raidTargetMenu:SetBackdrop(BACKDROP)
		enemyFrame.raidTargetMenu:SetBackdropColor(0, 0, 0, .6)
		--enemyFrame.raidTargetMenu:SetPoint('CENTER', UIParent,'CENTER', 0, 160)
		enemyFrame.raidTargetMenu:Hide()
		
		enemyFrame.raidTargetMenu.icons = {}
		for j = 1, raidIconsN, 1 do
			enemyFrame.raidTargetMenu.icons[j] = CreateFrame('Button', 'enemyFrame.raidTargetMenu.icons'..j, enemyFrame.raidTargetMenu)
			enemyFrame.raidTargetMenu.icons[j]:SetHeight(rtMenuIconsize)	enemyFrame.raidTargetMenu.icons[j]:SetWidth(rtMenuIconsize)
			enemyFrame.raidTargetMenu.icons[j]:SetPoint('LEFT', j == 1 and enemyFrame.raidTargetMenu or enemyFrame.raidTargetMenu.icons[j-1], j == 1 and 'LEFT' or 'RIGHT', 2, 0)
			enemyFrame.raidTargetMenu.icons[j].id = j
			
			enemyFrame.raidTargetMenu.icons[j].tex = enemyFrame.raidTargetMenu.icons[j]:CreateTexture(nil, 'OVERLAY')
			enemyFrame.raidTargetMenu.icons[j].tex:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
			enemyFrame.raidTargetMenu.icons[j].tex:SetAlpha(.6)
			local tCoords = RAID_TARGET_TCOORDS[raidIcons[j]]
			enemyFrame.raidTargetMenu.icons[j].tex:SetTexCoord(tCoords[1], tCoords[2], tCoords[3], tCoords[4])
			enemyFrame.raidTargetMenu.icons[j].tex:SetAllPoints()
			
			enemyFrame.raidTargetMenu.icons[j]:SetScript('OnEnter', function() 
															_G['enemyFrame.raidTargetMenu.icons'..this.id].tex:SetAlpha(1)
														end)
														
			enemyFrame.raidTargetMenu.icons[j]:SetScript('OnLeave', function() 
															_G['enemyFrame.raidTargetMenu.icons'..this.id].tex:SetAlpha(.6)
														end)							
		end

		
local unitWidth, unitHeight, castBarHeight, ccIconWidth, ccIconHeight, manaBarHeight = 64, 24, 10, 28, 24, 4
local leftSpacing = 15
for i = 1, unitLimit,1 do
	-- health statusbar
	units[i] = CreateFrame('StatusBar', 'enemyFrameUnit'..i, enemyFrame)
	units[i]:SetFrameLevel(0)
	units[i]:SetStatusBarTexture(TEXTURE)
	units[i]:SetWidth(unitWidth)	units[i]:SetHeight(unitHeight)
	units[i]:SetMinMaxValues(0, 100)
	
	units[i]:SetBackdrop(BACKDROP)
	units[i]:SetBackdropColor(0, 0, 0, .6)
	
	
	-- mana statusbar
	units[i].manabar = CreateFrame('StatusBar', nil, units[i])
	units[i].manabar:SetFrameLevel(1)
	units[i].manabar:SetStatusBarTexture(TEXTURE)
	units[i].manabar:SetHeight(manaBarHeight)
	units[i].manabar:SetWidth(unitWidth)		
	units[i].manabar:SetPoint('TOPLEFT', units[i], 'BOTTOMLEFT', 0, -1)
	
	units[i].manabar:SetBackdrop(BACKDROP)
	units[i].manabar:SetBackdropColor(0, 0, 0)
	
	
	-- cast bar --
	units[i].castbar = CreateFrame('StatusBar', nil, units[i])
	units[i].castbar:SetFrameLevel(0)
	units[i].castbar:SetStatusBarTexture(TEXTURE)
	units[i].castbar:SetHeight(castBarHeight)
	units[i].castbar:SetWidth((unitWidth + ccIconWidth + 4) - (units[i].castbar:GetHeight()))	
	units[i].castbar:SetStatusBarColor(1, .4, 0)
	units[i].castbar:SetPoint('TOPLEFT', units[i], 'BOTTOMLEFT', units[i].castbar:GetHeight(), -3)
	
	units[i].castbar:SetBackdrop(BACKDROP)
	units[i].castbar:SetBackdropColor(0, 0, 0, .6)
	
	
	units[i].castbar.iconborder = CreateFrame('Frame', nil, units[i].castbar)
	units[i].castbar.iconborder:SetWidth(units[i].castbar:GetHeight()+1)	units[i].castbar.iconborder:SetHeight(units[i].castbar:GetHeight()+1)
	units[i].castbar.iconborder:SetPoint('RIGHT', units[i].castbar, 'LEFT')
	
	units[i].castbar.icon = units[i].castbar.iconborder:CreateTexture(nil, 'ARTWORK')
	units[i].castbar.icon:SetTexCoord(.078, .92, .079, .937)
	units[i].castbar.icon:SetAllPoints()
	units[i].castbar.icon:SetPoint('CENTER', units[i].castbar.iconborder, 'CENTER')
	
	units[i].castbar.text = units[i].castbar:CreateFontString(nil, 'OVERLAY')
	units[i].castbar.text:SetTextColor(1, 1, 1)
	units[i].castbar.text:SetFont(STANDARD_TEXT_FONT, 8)
	units[i].castbar.text:SetShadowOffset(1, -1)
	units[i].castbar.text:SetShadowColor(0, 0, 0)
	units[i].castbar.text:SetPoint('LEFT', units[i].castbar, 'LEFT', 2, 1)
	
	
	--[[
	units[i].castbar.timer = units[i].castbar:CreateFontString(nil, 'OVERLAY')
	units[i].castbar.timer:SetFont(STANDARD_TEXT_FONT, 8)
	units[i].castbar.timer:SetTextColor(1, 1, 1)
	units[i].castbar.timer:SetShadowOffset(1, -1)
	units[i].castbar.timer:SetShadowColor(0, 0, 0)
	units[i].castbar.timer:SetPoint('LEFT', units[i].castbar, 'RIGHT', 2, 1)
	units[i].castbar.timer:SetText('1.5s')]]--
	--------------

	units[i].name = units[i]:CreateFontString(nil, 'OVERLAY')
	units[i].name:SetFont(STANDARD_TEXT_FONT, 11, 'OUTLINE')
	units[i].name:SetTextColor(.8, .8, .8, .8)
	units[i].name:SetPoint('CENTER', units[i])	
	
	
	---- RAID TARGET
	units[i].raidTarget = CreateFrame('Frame', nil, units[i])
	units[i].raidTarget:SetWidth(ccIconWidth-2) units[i].raidTarget:SetHeight(ccIconHeight-2)
	units[i].raidTarget:SetPoint('CENTER', units[i],'TOPRIGHT', 0, -4)
	units[i].raidTarget:SetFrameLevel(2)
	
	units[i].raidTarget.icon = units[i].raidTarget:CreateTexture(nil, 'ARTWORK')
	units[i].raidTarget.icon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	units[i].raidTarget.icon:SetAllPoints()
	
	
	---- CC ------
	units[i].cc = CreateFrame('Frame', nil, units[i])
	units[i].cc:SetWidth(ccIconWidth) units[i].cc:SetHeight(ccIconHeight)
	units[i].cc:SetPoint('TOPLEFT', units[i],'TOPRIGHT', 4, -1)

	units[i].cc.icon = units[i].cc:CreateTexture(nil, 'ARTWORK')
	units[i].cc.icon:SetAllPoints()
	units[i].cc.icon:SetTexCoord(.1, .9, .25, .75)
	
	units[i].cc.bg = units[i].cc:CreateTexture(nil, 'BACKGROUND')
	units[i].cc.bg:SetTexture(0, 0, 0, .6)
	units[i].cc.bg:SetAllPoints()

	units[i].cc.duration = units[i].cc:CreateFontString(nil, 'OVERLAY')--, 'GameFontNormalSmall')
	units[i].cc.duration:SetFont(STANDARD_TEXT_FONT, 13)
	units[i].cc.duration:SetTextColor(.9, .9, .2, 1)
	units[i].cc.duration:SetShadowOffset(1, -2)
	units[i].cc.duration:SetShadowColor(0, 0, 0)
	units[i].cc.duration:SetPoint('BOTTOMRIGHT', units[i].cc, 'BOTTOMRIGHT', 12, 2)
	
	
	------- EXTRAS
	units[i].Button = CreateFrame('Button', nil, units[i])
	units[i].Button:SetAllPoints()
	units[i].Button:SetPoint('CENTER', units[i])
	units[i].Button:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
	units[i].Button.index = i
	units[i].Button.mo = false
end


-- function for settings use
local function defaultVisuals()
	for i = 1, unitLimit do
		units[i].castbar.icon:SetTexture([[Interface\Icons\Inv_misc_gem_sapphire_01]])
		units[i].castbar.text:SetText('Entangling Roots')
		units[i].castbar.text:SetText(string.sub(units[i].castbar.text:GetText(), 1, 18))
		
		units[i].name:SetText('Player' .. i)
		
		units[i].raidTarget.icon:SetTexCoord(.75, 1, 0.25, .5)
		
		units[i].cc.icon:SetTexture([[Interface\characterframe\TEMPORARYPORTRAIT-MALE-ORC]])
		units[i].cc.duration:SetText('1.4')
		
		units[i]:Show()
	end
end

local function optionals()
	for i = 1, unitLimit do
		-- display player's names
		if not ENEMYFRAMESPLAYERDATA['displayNames'] then
			units[i].name:Hide()
		else
			units[i].name:Show()
		end
		
		-- display mana bar
		if not ENEMYFRAMESPLAYERDATA['displayManabar'] then
			units[i]:SetHeight(unitHeight)
			units[i].name:SetPoint('CENTER', units[i])
			units[i].manabar:Hide()
			units[i].castbar:SetPoint('TOPLEFT', units[i], 'BOTTOMLEFT', units[i].castbar:GetHeight(), -3)
		else
			units[i]:SetHeight(unitHeight - manaBarHeight)
			units[i].name:SetPoint('CENTER', units[i])
			units[i].manabar:Show()
			units[i].castbar:SetPoint('TOPLEFT', units[i].manabar, 'BOTTOMLEFT', units[i].castbar:GetHeight(), -3)
		end
	end
end
local function setccIcon(p)
	local d = p == 'class' and 'WARRIOR' or p == 'rank' and 6 or p == 'portrait' and ( playerFaction == 'Alliance' and 'MALE-ORC' or 'MALE-HUMAN')
	for i = 1, unitLimit do
		units[i].cc.icon:SetTexture(GET_DEFAULT_ICON(p, d))
	end
end
 
 --if not enabled then setccIcon(defaultIcon)	end
 
local function arrangeUnits()
	local unitGroup = ENEMYFRAMESPLAYERDATA['groupsize']
	
	-- adjust title
	if playerFaction == 'Alliance' then 
		enemyFrame.Title:SetText(ENEMYFRAMESPLAYERDATA['layout'] == 'vertical' and 'H' or 'Horde')
	else 
		enemyFrame.Title:SetText(ENEMYFRAMESPLAYERDATA['layout'] == 'vertical' and 'A' or 'Alliance')
	end
	
	for i = 1, unitLimit do	
		if i == 1 then	
				units[i]:SetPoint('TOPLEFT', enemyFrame, 'BOTTOMLEFT', 0, -4)
		else
			if i > unitGroup then
				if ENEMYFRAMESPLAYERDATA['layout'] == 'hblock' then
					units[i]:SetPoint('TOPLEFT', units[i-unitGroup].castbar.iconborder, 'BOTTOMLEFT', 1, -5)
				else
					units[i]:SetPoint('TOPLEFT', units[i-unitGroup].cc, 'TOPRIGHT', leftSpacing, 1)
				end
			else
				if ENEMYFRAMESPLAYERDATA['layout'] == 'hblock' then
					units[i]:SetPoint('TOPLEFT', units[i-1].cc, 'TOPRIGHT', leftSpacing, 1)					
				else
					units[i]:SetPoint('TOPLEFT', units[i-1].castbar.iconborder, 'BOTTOMLEFT', 1, -5)
				end
			end
		end	
	end
end

-- use modui to reskin some ui elements
local function moduiReSkin()
	TEXTURE = [[Interface\AddOns\modui\statusbar\texture\sb.tga]]
	
	-- enemyFrame
	modSkin(enemyFrame.top, 13)
	modSkinColor(enemyFrame.top, .2, .2, .2)
	
	modSkin(enemyFrame.bottom, 13)
	modSkinColor(enemyFrame.bottom, .2, .2, .2)
	
	modSkin(enemyFrame.raidTargetMenu, 8)
	modSkinColor(enemyFrame.raidTargetMenu, .2, .2, .2)
	
	-- individual unit ui
	for i = 1, unitLimit do
		-- health bar
		units[i]:SetStatusBarTexture(TEXTURE)
		modSkin(units[i], 8)
		modSkinPadding(units[i], 1)
		
		-- mana bar
		units[i].manabar:SetStatusBarTexture(TEXTURE)
		--modSkin(units[i].manabar, 8)
		--modSkinPadding(units[i].manabar, 1)
		--modSkinColor(units[i].manabar, .2, .2, .2)
		
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
		modSkin(units[i].cc, 12)
		modSkinPadding(units[i].cc, 2)
	end
	
	moduiLoaded = true
end

-- check if modui loaded first		
if IsAddOnLoaded'modui' then
	moduiReSkin()
end

local function showHideBars()
	if ENEMYFRAMESPLAYERDATA['frameMovable'] then
		enemyFrame.spawnText.Button.tt = 'lock'
		enemyFrame.top:SetAlpha(1)
		enemyFrame.bottom:SetAlpha(1)
		enemyFrame.spawnText:SetText('-')		
	else
		enemyFrame.spawnText.Button.tt = 'unlock'
		enemyFrame.top:SetAlpha(0)
		enemyFrame.bottom:SetAlpha(0)
		enemyFrame.spawnText:SetText('+')
	end
end

local function SetupFrames(maxUnits)
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
	local col = ENEMYFRAMESPLAYERDATA['layout'] == 'hblock' and 5 or maxUnits / ENEMYFRAMESPLAYERDATA['groupsize']
	enemyFrame:SetWidth((unitWidth + ccIconWidth + 5)*col +  leftSpacing*(col-1))
	
	enemyFrame.top:SetWidth(enemyFrame:GetWidth())
	enemyFrame.top:SetPoint('CENTER', enemyFrame)
	
	
	enemyFrame.spawnText.Button:SetScript('OnClick', function()
			if ENEMYFRAMESPLAYERDATA['frameMovable'] then
				ENEMYFRAMESPLAYERDATA['frameMovable'] = false
			else	
				ENEMYFRAMESPLAYERDATA['frameMovable'] = true
			end
			showHideBars()
			GameTooltip:SetOwner(this, 'ANCHOR_TOPRIGHT', -30, -60)
			GameTooltip:SetText(this.tt)
			GameTooltip:Show()
		end)
		
	showHideBars()
	
	-- bottom frame
	enemyFrame.bottom:SetWidth(enemyFrame:GetWidth())
	--enemyFrame.bottom:SetPoint('CENTER', enemyFrame, 0, -((unitHeight + castBarHeight + 15) * unitGroup))
	local unitPointBottom = ENEMYFRAMESPLAYERDATA['layout'] == 'hblock' and maxUnits - 4 or maxUnits < ENEMYFRAMESPLAYERDATA['groupsize'] and maxUnits or ENEMYFRAMESPLAYERDATA['groupsize']
	enemyFrame.bottom:SetPoint('TOPLEFT', units[unitPointBottom].castbar.icon, 'BOTTOMLEFT', 1, -6)
	
	if ENEMYFRAMESPLAYERDATA['defaultIcon'] == 'class' then
		enemyFrame.bottom.classIcon:SetBlendMode('BLEND')
		enemyFrame.bottom.classIcon:SetVertexColor(1, 1, 1)
		enemyFrame.bottom.rankIcon:SetBlendMode('ADD')
		enemyFrame.bottom.rankIcon:SetVertexColor(.3, .3, .3)
		enemyFrame.bottom.raceIcon:SetBlendMode('ADD')
		enemyFrame.bottom.raceIcon:SetVertexColor(.3, .3, .3)
	elseif ENEMYFRAMESPLAYERDATA['defaultIcon'] == 'rank' then
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
			
			ENEMYFRAMESPLAYERDATA['defaultIcon'] = 'class'
			
			enemyFrame.bottom.classIcon:SetBlendMode('BLEND')
			enemyFrame.bottom.classIcon:SetVertexColor(1, 1, 1)
			enemyFrame.bottom.rankIcon:SetBlendMode('ADD')
			enemyFrame.bottom.rankIcon:SetVertexColor(.3, .3, .3)
			enemyFrame.bottom.raceIcon:SetBlendMode('ADD')
			enemyFrame.bottom.raceIcon:SetVertexColor(.3, .3, .3)
			
			if not enabled then setccIcon('class')	end
		end)
	
	enemyFrame.bottom.rankButton:SetScript('OnClick', function()
			ENEMYFRAMESPLAYERDATA['defaultIcon'] = 'rank'
			
			enemyFrame.bottom.classIcon:SetBlendMode('ADD')
			enemyFrame.bottom.classIcon:SetVertexColor(.3, .3, .3)
			enemyFrame.bottom.rankIcon:SetBlendMode('BLEND')
			enemyFrame.bottom.rankIcon:SetVertexColor(1, 1, 1)
			enemyFrame.bottom.raceIcon:SetBlendMode('ADD')
			enemyFrame.bottom.raceIcon:SetVertexColor(.3, .3, .3)
			
			if not enabled then setccIcon('rank')	end
		end)
		
	local r = playerFaction == 'Alliance' and 'MALE-ORC' or 'MALE-HUMAN'
	enemyFrame.bottom.raceIcon:SetTexture(GET_DEFAULT_ICON('portrait', r))
	enemyFrame.bottom.raceButton:SetScript('OnClick', function()
			ENEMYFRAMESPLAYERDATA['defaultIcon'] = 'portrait'

						
			enemyFrame.bottom.classIcon:SetBlendMode('ADD')
			enemyFrame.bottom.classIcon:SetVertexColor(.3, .3, .3)
			enemyFrame.bottom.rankIcon:SetBlendMode('ADD')
			enemyFrame.bottom.rankIcon:SetVertexColor(.3, .3, .3)
			enemyFrame.bottom.raceIcon:SetBlendMode('BLEND')
			enemyFrame.bottom.raceIcon:SetVertexColor(1, 1, 1)
			
			if not enabled then setccIcon('portrait')	end
		end)
	
	
	enemyFrame.bottom.settings.text:SetPoint('RIGHT', enemyFrame.bottom, 'RIGHT', -6, 1)
	enemyFrame.bottom.settings.text:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'], .9)
		
end

--spawn raidtarget menu
local function spawnRTMenu(b, target)
	enemyFrame.raidTargetMenu:SetPoint('TOP', b,'BOTTOM', rtMenuIconsize/2, 0)
	if enemyFrame.raidTargetMenu.target and enemyFrame.raidTargetMenu.target == target and rtMenuEndtime > GetTime() then
			enemyFrame.raidTargetMenu:Hide()
			return
	end
	
	enemyFrame.raidTargetMenu.target = target
	enemyFrame.raidTargetMenu:Show()
	rtMenuEndtime = GetTime() + rtMenuInterval
	
	for j = 1, raidIconsN, 1 do
		enemyFrame.raidTargetMenu.icons[j]:SetScript('OnClick', function()
			ENEMYFRAMECORESendRaidTarget(raidIcons[this.id], target)
			enemyFrame.raidTargetMenu:Hide()
			rtMenuEndtime = 0
		end)
	end
end

local function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end
local getTimerLeft = function(tEnd)
	local t = tEnd - GetTime()
	if t > 3 then return round(t, 0) else return round(t, 1) end
end

local function SetDefaultIconTex(p)
	--return v['rank'] < 0 and  GET_PORTRAIT_ICON(v['portrait']) or _G['GET_'..string.upper(defaultIcon)..'_ICON'](v[defaultIcon])
	p['portrait']	= p['sex'] .. '-' .. p['race']
	local d = ENEMYFRAMESPLAYERDATA['defaultIcon']
	if d == 'rank' and p['rank'] < 0 then d = 'portrait' end
	return GET_DEFAULT_ICON(d, p[d])
end

local function drawUnits(list)
			
	playerList = list
	local i, nearU = 1, 0
	
	for k,v in pairs(playerList) do
		-- set for redrawn
		--if v['refresh'] then
			--print(v['name'] .. ' refresh true')
			local colour = RAID_CLASS_COLORS[v['class']]
			local powerColor = GET_RGB_POWER_COLORS_BY_CLASS(v['class'])
			
			-- hightlight nearby unit
			if v['nearby'] then		
				units[i]:SetStatusBarColor(colour.r, colour.g, colour.b)
				if not units[i].Button.mo then
					units[i].name:SetTextColor(colour.r, colour.g, colour.b)	
				end			
				units[i].manabar:SetStatusBarColor(powerColor[1], powerColor[2], powerColor[3])			
				units[i].cc.icon:SetVertexColor(1, 1, 1, 1)
				
				units[i].Button:SetScript('OnEnter', function()	
					units[this.index].name:SetTextColor(enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'])	
					this.mo = true
					MOUSEOVERUNINAME = this.tar
				end)
				units[i].Button:SetScript('OnLeave', function()
					units[this.index].name:SetTextColor(colour.r, colour.g, colour.b)
					this.mo = false
					MOUSEOVERUNINAME = nil
				end)
							
			else
				units[i]:SetStatusBarColor(colour.r / 2, colour.g / 2, colour.b / 2, .6)
				units[i].manabar:SetStatusBarColor(powerColor[1] / 2, powerColor[2] / 2, powerColor[3] / 2)
				if not units[i].Button.mo then
					units[i].name:SetTextColor(colour.r / 2, colour.g / 2, colour.b / 2, .6)
				end		
				units[i].cc.icon:SetVertexColor(.4, .4, .4, .6)
				
				units[i].Button:SetScript('OnEnter', nil)
				units[i].Button:SetScript('OnLeave', function()
					units[this.index].name:SetTextColor(colour.r / 2, colour.g / 2, colour.b / 2, .6)
					this.mo = false
				end)
			end
					
			units[i].name:SetText(v['name'])
			units[i].name:SetText(string.sub(units[i].name:GetText(), 1, 7))
			
			-- button function to target unit
			units[i].Button.tar = v['name']
			units[i].Button:SetScript('OnClick', function()	if arg1 == 'LeftButton'  then  	TargetByName(this.tar, true)			end
															if arg1 == 'RightButton' then	--enemyFrame.raidTargetFrame:Hide()
															spawnRTMenu(this, this.tar)	end
																							--ENEMYFRAMECORESendRaidTarget('skull', this.tar)	end
															end)
			
			-- hp & mana
			units[i]:SetValue(v['health'] and v['health'] or not v['nearby'] and 100 or 100)
			units[i].manabar:SetMinMaxValues(0, v['maxmana'] and v['maxmana'] or 100)
			units[i].manabar:SetValue(v['mana'] and v['mana'] or not (v['nearby'] and v['maxmana']) and v['maxmana'] or 100)
			

			
			units[i]:Show()
		--end
		
		nearU = v['nearby'] and nearU + 1 or nearU
		i = i + 1
	end
	
	for j=i, unitLimit, 1 do
		if units[j]:IsShown() then
			units[j]:Hide()
		end
	end

	enemyFrame.totalPlayers:SetText(nearU .. ' / ' .. i-1)
end

-- target indicator, raid icons, optionals
local function updateUnits()
	-- killTarget announcement
	if ktEndtime < GetTime() then
		enemyFrame.raidTargetFrame:Hide()
	end
	-- raidicons menu
	if rtMenuEndtime < GetTime() then
		enemyFrame.raidTargetMenu:Hide()
	end
	
	local i = 1
	
	for k, v in pairs(playerList) do
		
		-- target indicator
		if UnitName'target' == v['name'] then
			if moduiLoaded then
				modSkinColor(units[i], enemyFactionColor['r'], enemyFactionColor['g'], enemyFactionColor['b'])
			end
			units[i]:SetBackdropColor(enemyFactionColor['r'] - .6, enemyFactionColor['g'] - .6, enemyFactionColor['b'] - .6, .6)
			
			-- show target player portrait
			if v['buff'] == nil and not v['fc'] and ENEMYFRAMESPLAYERDATA['defaultIcon'] == 'portrait' then
				SetPortraitTexture(units[i].cc.icon, 'target')
			end
		else
			if moduiLoaded then
				modSkinColor(units[i], .2, .2, .2)
			end
			units[i]:SetBackdropColor(0, 0, 0, .6)
		end

		
		-- castbar
		local castInfo = SPELLCASTINGCOREgetCast(v['name'])--v['castinfo']--
		units[i].castbar:Hide()
		if castInfo ~= nil then
			units[i].castbar:SetMinMaxValues(0, castInfo.timeEnd - castInfo.timeStart)
			
			if castInfo.inverse then
				units[i].castbar:SetValue(mod((castInfo.timeEnd - GetTime()), castInfo.timeEnd - castInfo.timeStart))
			else
				units[i].castbar:SetValue(mod((GetTime() - castInfo.timeStart), castInfo.timeEnd - castInfo.timeStart))					
			end
			units[i].castbar.text:SetText(castInfo.spell)
			units[i].castbar.text:SetText(string.sub(units[i].castbar.text:GetText(), 1, 18))
			--units[i].castbar.timer:SetText(getTimerLeft(castInfo.timeEnd))--..'s')
			units[i].castbar.icon:SetTexture(castInfo.icon)
			units[i].castbar:Show()		
		end
			
		-- CC type
		local b = SPELLCASTINGCOREgetPrioBuff(v['name'])--v['buff']--
		if b ~= nil then
			units[i].cc.icon:SetTexture(b.icon)
			units[i].cc.duration:SetText(getTimerLeft(b.timeEnd))
			local r, g, b = b.border[1], b.border[2], b.border[3]
			if moduiLoaded then modSkinColor(units[i].cc, r, g, b) end
		else
			-- signal FC or class / rank
			units[i].cc.icon:SetTexture(v['fc'] and SPELLINFO_WSG_FLAGS[playerFaction]['icon'] or SetDefaultIconTex(v))
			-- hightlight fc
			if v['fc'] then
				units[i].cc.icon:SetVertexColor(1, 1, 1, 1)
			end
			

			if moduiLoaded then modSkinColor(units[i].cc, .2, .2, .2)	end
			units[i].cc.duration:SetText('')
		end
		
		-- RAID ICON
		if raidTargets[v['name']] then
			local tCoords = RAID_TARGET_TCOORDS[raidTargets[v['name']]['icon']]
			units[i].raidTarget.icon:SetTexCoord(tCoords[1], tCoords[2], tCoords[3], tCoords[4])
			units[i].raidTarget:Show()
		else
			units[i].raidTarget:Hide()
		end	
		
		if not v['nearby'] then
			if ENEMYFRAMESPLAYERDATA['displayOnlyNearby'] then units[i]:Hide()	else units[i]:Show() end
		end
				
		i = i + 1
		if i > unitLimit then return end
	end
end

local function enemyFramesOnUpdate()
	-- get updated units from core
	local list = ENEMYFRAMESCOREGetUnitsInfo()
	-- if theres anything new to draw do so
	if list then 	drawUnits(list)	--ENEMYFRAMESCOREListRefreshed()
	end
	-- update units
	--if visible then 
	raidTargets = ENEMYFRAMECOREGetRaidTarget()
	updateUnits()
	--end
end


--- GLOBAL ACCESS ---
function ENEMYFRAMESAnnounceRT(rt, p)
	raidTargets = rt
	enemyFrame.raidTargetFrame.text:SetText(p['name'])
	enemyFrame.raidTargetFrame.text:SetTextColor(RAID_CLASS_COLORS[p['class']].r, RAID_CLASS_COLORS[p['class']].g, RAID_CLASS_COLORS[p['class']].b)
	
	local tCoords = RAID_TARGET_TCOORDS[raidTargets[p['name']]['icon']]
	enemyFrame.raidTargetFrame.iconl:SetTexCoord(tCoords[1], tCoords[2], tCoords[3], tCoords[4])
	enemyFrame.raidTargetFrame.iconr:SetTexCoord(tCoords[1], tCoords[2], tCoords[3], tCoords[4])
	
	enemyFrame.raidTargetFrame:Show()
	ktEndtime = GetTime() + ktInterval
end

function ENEMYFRAMESInitialize(maxUnits)
		
	if maxUnits then
		SetupFrames(maxUnits)
		arrangeUnits()
		optionals()
		enabled = true
		
		enemyFrame:Show()
		enemyFrame:SetScript('OnUpdate', enemyFramesOnUpdate)
	else
		enemyFrame:SetScript('OnUpdate', nil)
	end
end

function ENEMYFRAMESsettings()
	optionals()
	if not enabled then
		SetupFrames(15)
		defaultVisuals()
		setccIcon(ENEMYFRAMESPLAYERDATA['defaultIcon'])
	end
	arrangeUnits()
end
---------------------

local function eventHandler()
	if event == 'PLAYER_ENTERING_WORLD' or event == 'ZONE_CHANGED_NEW_AREA' and enabled then
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
end


