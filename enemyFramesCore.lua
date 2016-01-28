
local playerFaction
local bgs = {['Warsong Gulch'] = 10, 
			 ['Arathi Basin'] = 15, 
			 --['Alterac Valley'] = 40
			 }
-- TIMERS
local playerListInterval, playerListRefresh, enemyNearbyInterval, enemyNearbyRefresh = 30, 0, 1, 0
local nextPlayerCheck = 4
local refreshUnits = true
-- LISTS
local nearbyUnitsInfo = {}
local playerList = {}
local targetQueue = {}


--- GLOBAL ACCESS ---
function ENEMYFRAMESCOREGetUnitsInfo()
	local list = {}
	if refreshUnits then	
		for k, v in pairs(playerList) do	
			local p 
			if nearbyUnitsInfo[v['name']] then				
				p = nearbyUnitsInfo[v['name']]
				p['nearby'] = true					
			else
				p = v
				p['nearby'] = false
			end
			list[v['name']] = p
		end
		refreshUnits = false
	else
		return nil
	end
	return list
end
---------------------

local function fillPlayerList()
	local f
	local gotData = false
	playerList = {}
	refreshUnits = true
	if UnitFactionGroup('player') == 'Alliance' then f = 0 else f = 1 end
	for i=1, GetNumBattlefieldScores() do
		name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class = GetBattlefieldScore(i)
		if faction == f then
			playerList[name] = {['name'] = name, ['class'] = string.upper(class)}
			gotData = true
		end
	end	

	return gotData
end

-- confirm hostile nearbyPlayers
local function addNearbyPlayers(players, isTarget)
	local nextCheck = GetTime() + nextPlayerCheck
	
	for k, v in pairs(players) do
		if playerList[v] then
			if nearbyUnitsInfo[v] == nil then		refreshUnits =  true		nearbyUnitsInfo[v] = playerList[v]	end
			nearbyUnitsInfo[v]['nextCheck'] = nextCheck
		end
	end
end

local function verifyUnitInfo(unit)
	if UnitExists(unit) and UnitIsPlayer(unit) then
		addNearbyPlayers({UnitName(unit)}, true)
	end

	-- update unit's stats
	if nearbyUnitsInfo[UnitName(unit)] then		
		nearbyUnitsInfo[UnitName(unit)]['health'] 	= UnitHealth(unit)
		nearbyUnitsInfo[UnitName(unit)]['mana'] 	= UnitMana(unit)
		refreshUnits = true
	end
end

--	attempt to get enemy info from raid's targets
local function getRaidMembersTarget()
	local numRaidMembers = GetNumRaidMembers()
	
	for i = 1, numRaidMembers, 1 do
		verifyUnitInfo('raid' .. i .. 'target')
	end
end

-- find hostile players by combat log actions 
-- not being used atm
--[[
local function processCombatLog()
	-- spells
	local cast 			= '(.+) begins to cast (.+).' 					local fcast 		= string.find(arg1, cast)
	-- heals
	local heal			= '(.+)\' (.+) heals (.+) for (.+)'				local fheal 		= string.find(arg1, heal)
	local cheal   		= '(.+)\' (.+) critically heals (.+) for (.+).'	local fcheal 		= string.find(arg1, cheal)
	local hot 			= '(.+) gains (.+) health from (.+)\'s (.+).'	local fhot			= string.find(arg1, hot)
	-- auras
	local gain 			= '(.+) gains (.+).' 							local fgain 		= string.find(arg1, gain)
	local fade 			= '(.+) fades from (.+).'						local ffade 		= string.find(arg1, fade)
	local afflict 		= '(.+) is afflicted by (.+).' 					local fafflict 		= string.find(arg1, afflict)
	local rem 			= '(.+)\'s (.+) is removed'						local frem 			= string.find(arg1, rem)
	-- hits/crits
	local hits 			= '(.+)\'s (.+) hits (.+) for (.+)' 			local fhits 		= string.find(arg1, hits)
	local crits 		= '(.+)\'s (.+) crits (.+) for (.+)' 			local fcrits 		= string.find(arg1, crits)
	local absb 			= '(.+)\'s (.+) is absorbed by (.+).'			local fabsb 		= string.find(arg1, absb)
	-- player hits/crits
	local phits 		= 'Your (.+) hits (.+) for (.+)' 				local fphits 		= string.find(arg1, phits)
	local pcrits 		= 'Your (.+) crits (.+) for (.+)' 				local fpcrits 		= string.find(arg1, pcrits)	
	local pabsb 		= 'Your (.+) is absorbed by (.+).'				local fpabsb 		= string.find(arg1, pabsb)
	-- dots
	local channelDot 	= "(.+) suffers (.+) from (.+)'s (.+)."			local fchannelDot 	= string.find(arg1, channelDot)
	local pchannelDot 	= "You suffer (.+) from (.+)'s (.+)."			local fpchannelDot 	= string.find(arg1, pchannelDot)
	-- white damage
	local wHit			= '(.+) hits (.+).'								local fwHit			= string.find(arg1, wHit)
	local wMiss			= '(.+) misses (.+).'							local fwMiss		= string.find(arg1, wMiss)
	local pwHit			= '(.+) hit (.+).'								local fpwHit		= string.find(arg1, pwHit)
	local pwMiss		= '(.+) miss (.+).'								local fpwMiss		= string.find(arg1, pwMiss)
	-- player dies
	local dies			= '(.+) dies.'									local fdies		= string.find(arg1, dies)
	
	
	local m, c, t, s = nil, nil, nil, nil
	if fcast or fgain or ffade or fafflict then
		m = fcast and cast or fgain and gain or ffade and fade or fafflict and afflict	
		c = gsub(arg1, m, '%1')
		s = gsub(arg1, m, '%2')
	elseif fheal or fcheal or fhot then
		m = fheal and heal or fcheal and cheal or fhot and hot
		c = fhot and gsub(arg1, m, '%3') or gsub(arg1, m, '%1')
		s = fhot and gsub(arg1, m, '%1') or gsub(arg1, m, '%3')
	elseif fhits or fcrits or fabsb then
		m = fhits and hits or fcrits and crits or fabsb and absb
		c = gsub(arg1, m, '%1')
		t = gsub(arg1, m, '%3')
	elseif fphits or fpcrits or fpabsb then
		m = fphits and phits or fpcrits and pcrits or fpabsb and pabsb
		t = gsub(arg1, m, '%2')
	elseif fchannelDot or fpchannelDot then
		m = fchannelDot and channelDot or fpchannelDot and pchannelDot
		c = fchannelDot and gsub(arg1, m, '%3') or gsub(arg1, m, '%2')
		t = fchannelDot and gsub(arg1, m, '%1') or nil
	elseif fies then
		m = dies
		c = gsub(arg1, m, '%1')
	end
	
	--addNearbyPlayers({c, t}, false)
end
--]]
-- update unit info: casts, cc, inactive
local function updatePlayerListInfo()
	local nextCheck = GetTime() + nextPlayerCheck

	for k, v in pairs(nearbyUnitsInfo) do
		v['castinfo'] 	= SPELLCASTINGCOREgetCast(v['name'])
		v['buff'] 		= SPELLCASTINGCOREgetPrioBuff(v['name'])
		
		if v['castinfo'] or v['buff'] then	nearbyUnitsInfo[v['name']]['nextCheck'] = nextCheck	end
		
		--if not v['health'] 	then 	v['health'] = 100 end
		--if not v['mana'] 	then 	v['mana'] 	= 100 end
	end
	--[[
	for k, v in pairs(playerList) do
		v['castinfo'] 	= SPELLCASTINGCOREgetCast(v['name'])
		v['buff'] 		= SPELLCASTINGCOREgetPrioBuff(v['name'])
		
		if v['castinfo'] or v['buff'] then	
			if nearbyUnitsInfo[v['name']] --~= nil then
		--[[		addNearbyPlayers({v['name']}, true)
			else
				nearbyUnitsInfo[v['name']]--['nextCheck'] = nextCheck	
			--	nearbyUnitsInfo[v['name']]['castinfo'] = v['castinfo']	nearbyUnitsInfo[v['name']]['buff'] = v['buff']
			--[[	refreshUnits = true
			end
		end
	end]]--
	
	-- remove inactive players
	for k,v in pairs(nearbyUnitsInfo) do
		if GetTime() > v['nextCheck'] then	
			refreshUnits = true 	
			nearbyUnitsInfo[v['name']] = nil
		end		
	end
end

local function enemyFramesCoreOnUpdate()
	-- get battleground members on UPDATE_BATTLEFIELD_SCORE
	RequestBattlefieldScoreData()

	-- use target & mouseover to further populate list
	verifyUnitInfo('target')
	verifyUnitInfo('mouseover')
	
	-- check raid targets every enemyNearbyInterval seconds
	local now = GetTime()
	if now > enemyNearbyRefresh then
		getRaidMembersTarget()		
		enemyNearbyRefresh = now + enemyNearbyInterval
	end	
	
	-- update player list
	-- add casts/buffs 
	-- remove inactive players
	updatePlayerListInfo()	
end

-- DUMMY FRAME
local f = CreateFrame('Frame', 'enemyFramesCore', UIParent)

local function initializeValues()
	playerFaction = UnitFactionGroup('player')
		
	playerList = {}
	nearbyUnitsInfo = {}
	
	local maxUnits = bgs[GetZoneText()]
	if maxUnits then
		f:SetScript('OnUpdate', enemyFramesCoreOnUpdate)
		-- enable ui elements
		ENEMYFRAMESInitialize(maxUnits)
	else
		-- nil value to disable ui elements
		ENEMYFRAMESInitialize(nil)
		f:SetScript('OnUpdate', nil)
	end
end

local function eventHandler()
	if event == 'PLAYER_ENTERING_WORLD' or event == 'ZONE_CHANGED_NEW_AREA' then
		initializeValues()
	elseif event == 'UPDATE_BATTLEFIELD_SCORE' then
		local now = GetTime()
		-- fill player list
		if now > playerListRefresh then
			if fillPlayerList()	then
				playerListRefresh = now + playerListInterval
			end
		end	
	--elseif event == 'PLAYER_TARGET_CHANGED' then
	--	addCurrentTarget('target')
	--else
	--	processCombatLog()
	end
end


f:RegisterEvent'PLAYER_ENTERING_WORLD'
f:RegisterEvent'ZONE_CHANGED_NEW_AREA'
f:RegisterEvent'UPDATE_BATTLEFIELD_SCORE'

--f:RegisterEvent'PLAYER_TARGET_CHANGED'
--[[
f:RegisterEvent'CHAT_MSG_COMBAT_SELF_HITS'
f:RegisterEvent'CHAT_MSG_COMBAT_SELF_MISSES'
f:RegisterEvent'CHAT_MSG_COMBAT_PARTY_HITS'
f:RegisterEvent'CHAT_MSG_COMBAT_PARTY_MISSES'
f:RegisterEvent'CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS'
f:RegisterEvent'CHAT_MSG_COMBAT_FRIENDLYPLAYER_MISSES'
f:RegisterEvent'CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS'
f:RegisterEvent'CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES'
f:RegisterEvent'CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS'
f:RegisterEvent'CHAT_MSG_SPELL_SELF_BUFF'
f:RegisterEvent'CHAT_MSG_SPELL_SELF_DAMAGE'
f:RegisterEvent'CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE'
f:RegisterEvent'CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF'
f:RegisterEvent'CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE'
f:RegisterEvent'CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF'
f:RegisterEvent'CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE'
f:RegisterEvent'CHAT_MSG_SPELL_CREATURE_VS_PARTY_BUFF'
f:RegisterEvent'CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE'
f:RegisterEvent'CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF'
f:RegisterEvent'CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE'
f:RegisterEvent'CHAT_MSG_SPELL_PARTY_BUFF'
f:RegisterEvent'CHAT_MSG_SPELL_PARTY_DAMAGE'    
f:RegisterEvent'CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS'
f:RegisterEvent'CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS'
f:RegisterEvent'CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE'
f:RegisterEvent'CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE'
f:RegisterEvent'CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS'
f:RegisterEvent'CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE'
f:RegisterEvent'CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS'
f:RegisterEvent'CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE'    
f:RegisterEvent'CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE'
f:RegisterEvent'CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS'
f:RegisterEvent'CHAT_MSG_SPELL_BREAK_AURA'
f:RegisterEvent'CHAT_MSG_SPELL_AURA_GONE_OTHER'
f:RegisterEvent'CHAT_MSG_COMBAT_HOSTILE_DEATH'
]]--

f:SetScript('OnEvent', eventHandler)

SLASH_ENEMYFRAMECORE1 = '/efc'
SlashCmdList["ENEMYFRAMECORE"] = function(msg)
	for k, v in pairs(playerList) do
		print(v['name'])
	end
end

