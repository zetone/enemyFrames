
local playerFaction
-- TIMERS
local refreshUnits = true
-- LISTS
local nearbyUnitsInfo = {}
local unitLimit, unitGroup = 40, 5
local units = {}
local visible = true
local moduiLoaded = false
---

------------ UI ELEMENTS ------------------
local TEXTURE = [[Interface\AddOns\enemyFrames\globals\barTexture.tga]]
local BACKDROP = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],}
local factionRGB = {['Alliance'] = {['r'] = 0, ['g'] = .68, ['b'] = .94}, ['Horde'] = {['r'] = 1, ['g'] = .1, ['b'] = .1}}
local playerFactionColor

local frameMovable = true
local 	enemyFrame = CreateFrame('Frame', 'enemyFrame', UIParent)
		enemyFrame:SetFrameStrata("BACKGROUND")
		--enemyFrame:ClearAllPoints()
		enemyFrame:SetPoint('CENTER', UIParent)
		
		enemyFrame:SetHeight(20)
		
		--enemyFrame.background = enemyFrame:CreateTexture()
		--enemyFrame.background:SetTexture(0,0,0,0.3)
		--enemyFrame.background:SetAllPoints() 
		enemyFrame:SetBackdrop(BACKDROP)
		enemyFrame:SetBackdropColor(0, 0, 0, .4)
		
		--modSkin(enemyFrame, 13)
		--modSkinColor(enemyFrame, .2, .2, .2)
		
		enemyFrame:SetMovable(true)
		enemyFrame:EnableMouse(true)
		enemyFrame:ClampedToScreen(true)
		
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
		--enemyFrame.spawnButton:SetAllPoints()
		enemyFrame.spawnText.Button:SetHeight(15)	enemyFrame.spawnText.Button:SetWidth(15)

		
local unitWidth, unitHeight = 65, 30
for i = 1, unitLimit do
	-- health statusbar
	units[i] = CreateFrame('StatusBar', nil, enemyFrame)
	units[i]:SetFrameLevel(0)
	--units[i]:SetStatusBarTexture(TEXTURE)
	units[i]:SetWidth(unitWidth)	units[i]:SetHeight(unitHeight*.70)
	units[i]:SetMinMaxValues(0, 100)
	
	local pos = math.mod(i,unitGroup)
	if pos == 1 then
		if i == 1 then	
			units[i]:SetPoint('TOPLEFT', enemyFrame, 'BOTTOMLEFT', 0, -6)
		else			
			units[i]:SetPoint('TOPLEFT', units[i-unitGroup].cc, 'TOPRIGHT', 6, 1)
		end			
	else
		units[i]:SetPoint('TOPLEFT', units[i-1].castbar.icon, 'BOTTOMLEFT', 0, -6)
	end		
	
	units[i]:SetBackdrop(BACKDROP)
	units[i]:SetBackdropColor(0, 0, 0, .4)
	
--	modSkin(units[i], 8)
--	modSkinPadding(units[i], 1)
	
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
	--units[i].castbar:SetStatusBarTexture(TEXTURE)
	units[i].castbar:SetHeight(unitHeight*.30)
	units[i].castbar:SetWidth(unitWidth - (units[i].castbar:GetHeight()))	
--	units[i].castbar:SetMinMaxValues(0, 100)
	units[i].castbar:SetStatusBarColor(1, .4, 0)
	units[i].castbar:SetPoint('TOPLEFT', units[i], 'BOTTOMLEFT', units[i].castbar:GetHeight(), -3)
	
	units[i].castbar:SetBackdrop(BACKDROP)
	units[i].castbar:SetBackdropColor(0, 0, 0, .4)
	
--	modSkin(units[i].castbar, 8)
--	modSkinPadding(units[i].castbar, 1)
--	modSkinColor(units[i].castbar, .2, .2, .2)
	
	units[i].castbar.iconborder = CreateFrame('Frame', nil, units[i].castbar)
	units[i].castbar.iconborder:SetWidth(units[i].castbar:GetHeight()+1)	units[i].castbar.iconborder:SetHeight(units[i].castbar:GetHeight()+1)
	units[i].castbar.iconborder:SetPoint('RIGHT', units[i].castbar, 'LEFT')
	
	--modSkin(units[i].castbar.iconborder, 6)
	--modSkinPadding(units[i].castbar.iconborder, 1)
	--modSkinColor(units[i].castbar.iconborder, .2, .2, .2)
	
	units[i].castbar.icon = units[i].castbar.iconborder:CreateTexture()
	units[i].castbar.icon:SetTexture([[Interface\Icons\Inv_misc_gem_sapphire_01]])
	units[i].castbar.icon:SetTexCoord(.078, .92, .079, .937)
	--units[i].castbar.icon:SetWidth(units[i].castbar:GetHeight()+1)	units[i].castbar.icon:SetHeight(units[i].castbar:GetHeight()+1)
	units[i].castbar.icon:SetAllPoints()
	units[i].castbar.icon:SetPoint('CENTER', units[i].castbar.iconborder, 'CENTER')
	
	units[i].castbar.text = units[i].castbar:CreateFontString(nil, 'OVERLAY')
	units[i].castbar.text:SetTextColor(1, 1, 1)
	units[i].castbar.text:SetFont(STANDARD_TEXT_FONT, 8)
	units[i].castbar.text:SetShadowOffset(1, -1)
	units[i].castbar.text:SetShadowColor(0, 0, 0)
	units[i].castbar.text:SetPoint('LEFT', units[i].castbar, 'LEFT', 3, 2)
	
	units[i].castbar.timer = units[i].castbar:CreateFontString(nil, 'OVERLAY')
	units[i].castbar.timer:SetFont(STANDARD_TEXT_FONT, 8)
	units[i].castbar.timer:SetTextColor(1, 1, 1)
	units[i].castbar.timer:SetShadowOffset(1, -1)
	units[i].castbar.timer:SetShadowColor(0, 0, 0)
	units[i].castbar.timer:SetPoint('RIGHT', units[i].castbar, 'RIGHT', -2, 1)
	units[i].castbar.timer:SetText('1.5s')
	--------------

	units[i].name = units[i]:CreateFontString(nil, 'OVERLAY')
	units[i].name:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
	units[i].name:SetTextColor(.8, .8, .8, .8)
	units[i].name:SetPoint('CENTER', units[i])	
	
	---- CC ------
	units[i].cc = CreateFrame('Frame', nil, units[i])
	units[i].cc:SetWidth(25) units[i].cc:SetHeight(22)
	units[i].cc:SetPoint('TOPLEFT', units[i],'TOPRIGHT', 4, -1)
	
	--modSkin(units[i].cc, 10)
	--modSkinPadding(units[i].cc, 2)

	units[i].cc.icon = units[i].cc:CreateTexture(nil, 'ARTWORK')
	units[i].cc.icon:SetAllPoints()
	units[i].cc.icon:SetTexCoord(.1, .9, .25, .75)

	units[i].cc.duration = units[i].cc:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
	units[i].cc.duration:SetFont(STANDARD_TEXT_FONT, 12)
	units[i].cc.duration:SetTextColor(1, 1, 1)
	units[i].cc.duration:SetShadowOffset(1, -1)
	units[i].cc.duration:SetShadowColor(0, 0, 0)
	units[i].cc.duration:SetPoint('CENTER', units[i].cc, 'BOTTOM', 0, -4)
	--[[
	units[i].cc = units[i]:CreateTexture(nil, 'ARTWORK')
	units[i].cc:SetTexture([[Interface\Icons\IconLarge_Mage]])
	--units[i].cc:SetTexCoord(.078, .92, .079, .937)
	units[i].cc:SetTexCoord(.1, .9, .25, .75)
	units[i].cc:SetWidth(25)	units[i].cc:SetHeight(15)
	units[i].cc:SetPoint('TOPLEFT', units[i],'TOPRIGHT', 4, 0)]]--
	
	------- EXTRAS
	units[i].Button = CreateFrame('Button', nil, units[i])
	units[i].Button:SetAllPoints()
	units[i].Button:SetPoint('CENTER', units[i])
end

-- use modui to reskin some ui elements
local function reSkinUI()
	TEXTURE = [[Interface\AddOns\modui\statusbar\texture\sb.tga]]
	
	-- enemyFrame
	modSkin(enemyFrame, 13)
	modSkinColor(enemyFrame, .2, .2, .2)
	
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
	reSkinUI()
end

local function showhideUnits()
	if visible then
		for j=1, unitLimit, 1 do
			units[j]:SetAlpha(1)--Hide()
		end
	else
		for j=1, unitLimit, 1 do
			units[j]:SetAlpha(0)--:Show()
		end
	end
end

local function SetupTitle(maxUnits)
	-- get player's opposing faction
	playerFaction = UnitFactionGroup('player')
	

	if playerFaction == 'Alliance' then 
		playerFactionColor = factionRGB['Horde']
		enemyFrame.Title:SetText('Horde')
	else 
		playerFactionColor = factionRGB['Alliance']
		enemyFrame.Title:SetText('Alliance')		
	end
	
	enemyFrame.Title:SetTextColor(playerFactionColor['r'], playerFactionColor['g'], playerFactionColor['b'], .9)
	enemyFrame.spawnText:SetTextColor(playerFactionColor['r'], playerFactionColor['g'], playerFactionColor['b'], .9)
	enemyFrame.totalPlayers:SetTextColor(playerFactionColor['r'], playerFactionColor['g'], playerFactionColor['b'], .9)
		
	-- width of the draggable frame
	local rows = maxUnits / unitGroup
	enemyFrame:SetWidth(98*rows)
	
	enemyFrame.Title:SetPoint('CENTER', enemyFrame)
	enemyFrame.totalPlayers:SetPoint('RIGHT', enemyFrame, 'RIGHT', -4, 0)
	enemyFrame.spawnText:SetPoint('LEFT', enemyFrame, 'LEFT', 8, 0)
	enemyFrame.spawnText.Button:SetPoint('CENTER', enemyFrame.spawnText, 'CENTER')
	enemyFrame.spawnText.Button:SetScript('OnClick', function()
			local t
			if visible then
				t = '+'
				visible = false
			else
				t = '-' 
				visible = true
			end
			enemyFrame.spawnText:SetText(t)
			showhideUnits()
		end)
		
end

local function drawUnits(list)
			
	nearbyUnitsInfo = list
	local i, nearU = 1, 0
	for k,v in pairs(nearbyUnitsInfo) do
		local colour = RAID_CLASS_COLORS[v['class']]
		local powerColor = GET_RGB_POWER_COLORS_BY_CLASS(v['class'])
		
		if v['nearby'] then		
			units[i]:SetStatusBarColor(colour.r, colour.g, colour.b)
			units[i].name:SetTextColor(colour.r, colour.g, colour.b)			
			--units[i].manabar:SetStatusBarColor(powerColor[1], powerColor[2], powerColor[3])			
			units[i].cc.icon:SetVertexColor(1, 1, 1, 1)
						
			nearU = nearU + 1
		else
			units[i]:SetStatusBarColor(colour.r / 2, colour.g / 2, colour.b / 2, .6)
			-- 100% hp when not near
			units[i]:SetValue(100)
			--units[i].manabar:SetStatusBarColor(powerColor[1] / 2, powerColor[2] / 2, powerColor[3] / 2)
			units[i].name:SetTextColor(colour.r / 2, colour.g / 2, colour.b / 2, .6)			
			units[i].cc.icon:SetVertexColor(.4, .4, .4, .6)
		end
		
		units[i].name:SetText(v['name'])
		units[i].name:SetText(string.sub(units[i].name:GetText(), 1, 7))
		
		-- button function to target unit
		units[i].Button.tar = v['name']
		units[i].Button:SetScript('OnClick', function()	TargetByName(this.tar, true)	end)
		
		units[i]:Show()
		i = i + 1
	end
	
	for j=i, unitLimit, 1 do
		units[j]:Hide()
	end

	enemyFrame.totalPlayers:SetText(nearU .. ' / ' .. i-1)
end

local function decimal_round(n, dp)      -- ROUND TO 1 DECIMAL PLACE
	 local shift = 10^(dp or 0)
	 return math.floor(n*shift + .5)/shift
 end
local getTimerLeft = function(tEnd)
	local t = tEnd - GetTime()
	if t > 5 then return decimal_round(t, 0) else return decimal_round(t, 1) end
end
	
-- health, castbar, cc etc
local function updateUnits()
	local i = 1
	
	for k, v in pairs(nearbyUnitsInfo) do
		-- target indicator
		if moduiLoaded then
			if UnitName'target' == v['name'] then
				modSkinColor(units[i], playerFactionColor['r'], playerFactionColor['g'], playerFactionColor['b'])
			else
				modSkinColor(units[i], .2, .2, .2)
			end
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
			units[i].castbar.text:SetText(string.sub(units[i].castbar.text:GetText(), 1, 8))
			units[i].castbar.timer:SetText(getTimerLeft(castInfo.timeEnd))--..'s')
			units[i].castbar.icon:SetTexture(castInfo.icon)
			units[i].castbar:Show()		
		end
		
		if v['health'] 	then 	units[i]:SetValue(v['health']) 			end
		--if v['mana']	then	units[i].manabar:SetValue(v['mana'])	end
		
		-- CC type
		local b = v['buff']--
		if b ~= nil then
			units[i].cc.icon:SetTexture(b.icon)
			units[i].cc.duration:SetText(getTimerLeft(b.timeEnd))
			local r, g, b = b.border[1], b.border[2], b.border[3]
			if moduiLoaded then modSkinColor(units[i].cc, r, g, b) end
		else
			units[i].cc.icon:SetTexture(GET_CLASS_ICON(v['class']))
			if moduiLoaded then modSkinColor(units[i].cc, .2, .2, .2)	end
			units[i].cc.duration:SetText('')
		end
		
		i = i + 1
		if i > unitLimit then return end
	end
end

---######################################--

local function enemyFramesOnUpdate()
	-- get updated units from core
	local list = ENEMYFRAMESCOREGetUnitsInfo()
	-- if theres anything to update do so
	if list then 	drawUnits(list) end
	
	-- update units
	if visible then updateUnits()	end
end

-- DUMMY FRAME
local f = CreateFrame('Frame', 'enemyFrameDisplay', UIParent)
f:RegisterEvent'PLAYER_ENTERING_WORLD'
f:RegisterEvent'ZONE_CHANGED_NEW_AREA'
f:RegisterEvent'ADDON_LOADED'

--- GLOBAL ACCESS ---
function ENEMYFRAMESInitialize(maxUnits)
		
	if maxUnits then
		--SetUIComponents()
		SetupTitle(maxUnits)
		
		enemyFrame:Show()
		f:SetScript('OnUpdate', enemyFramesOnUpdate)
	else
		f:SetScript('OnUpdate', nil)
	end
end
---------------------

local function eventHandler()
	if event == 'PLAYER_ENTERING_WORLD' or event == 'ZONE_CHANGED_NEW_AREA' then
		--enemyFrame:Hide()
		--
	elseif event == 'ADDON_LOADED' then
		if arg1 == 'modui' then
			reSkinUI()
		end
	end
end
--f:SetScript('OnEvent', eventHandler)


SLASH_ENEMYFRAMES1 = '/efd'
SlashCmdList["ENEMYFRAMES"] = function(msg)
	--print('tt0')
	enemyFrame:Show()
end


