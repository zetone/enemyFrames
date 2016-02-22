
local playerFaction
local bgs = {['Warsong Gulch'] = 10, 
			 ['Arathi Basin'] = 15, 
			 --['Alterac Valley'] = 40
			 }
-- TIMERS
local playerListInterval, playerListRefresh, enemyNearbyInterval, enemyNearbyRefresh = 45, 0, .3, 0
local raidMemberIndex = 1
local playerOutdoorLastseen = 60
local insideBG = false
local nextPlayerCheck = 5	-- timer since last seen in seconds
local refreshUnits = true
-- LISTS
local playerList = {}
local raidTargets = {}

local nearbyList, notnearbyList = {}, {}
-- 

local function fillPlayerList()
	local f
	local gotData = false
	local l = {}
	
	if UnitFactionGroup('player') == 'Alliance' then f = 0 else f = 1 end
	-- get opposing faction players
	for i=1, GetNumBattlefieldScores() do
		local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class = GetBattlefieldScore(i)
		if faction == f then
			race = race == 'Undead' and 'SCOURGE' or race == 'Night Elf' and 'nightelf' or race
			l[name] = {['name'] = name, ['class'] = string.upper(class), ['rank'] = rank-4, ['race'] = string.upper(race), ['sex'] = 'MALE'} -- rank starts at -4 apparently
			gotData = true
		end
	end	
	
	-- add new players
	for i, v in pairs(l) do
		if playerList[v['name']] == nil then	
			playerList[v['name']] 			 = v 
			playerList[v['name']]['refresh'] = true			
			refreshUnits = true 
		end
	end
	-- remove aabsent players
	for i, v in pairs(playerList) do
		--v['refresh'] = true
		if l[v['name']] == nil then	
			playerList[v['name']] = nil	
				
			refreshUnits = true 
		end
	end

	return gotData
end

-- confirm hostile nearbyPlayers
local function addNearbyPlayers(players)
	local nextCheck = GetTime() + nextPlayerCheck
	local nextSeen	= GetTime() + playerOutdoorLastseen
	
	
	for k, v in pairs(players) do
		--if insideBG then
			if playerList[v['name']] then
				--if not playerList[v['name']]['nearby'] or playerList[v['name']]['health'] 	~= v['health'] or playerList[v['name']]['mana'] ~= v['mana'] then
					refreshUnits = true
					
					playerList[v['name']]['health'] 	= v['health']
					
					if v['mmaxhealth']	then	playerList[v['name']]['maxhealth'] 	= v['maxhealth']		end
					if v['mana']	then		playerList[v['name']]['mana'] 		= v['mana']				end
					if v['maxmana']	then		playerList[v['name']]['maxmana'] 	= v['maxmana']			end

					if v['sex']	then			playerList[v['name']]['sex']		= v['sex'] 				end
					
				--end

				playerList[v['name']]['nextCheck'] 	= nextCheck
				playerList[v['name']]['nearby'] 	= true			
				
			--end
		else
			refreshUnits = true
			playerList[v['name']] = v
			
			playerList[v['name']]['nextCheck'] 	= nextCheck
			playerList[v['name']]['nearby'] 	= true
			if not insideBG then
				playerList[v['name']]['lastSeen']	= nextSeen 
			end
		end
	end
end

local function getRankbyTitle(title)
	local n = '(.+) (.+)'

	if string.find(title, n) then
		return RANK_BY_TITLE[gsub(title, n, '%1')]
	end
	return -1
end

local function verifyUnitInfo(unit)
	if UnitExists(unit) and UnitIsPlayer(unit) and UnitIsEnemy(unit, 'player') then
		local u = {}
		u['name']		= UnitName(unit)
		u['class']		= string.upper(UnitClass(unit))
		u['rank']		= getRankbyTitle(UnitPVPName(unit))
		local r = UnitRace(unit)
		u['race']		= r == 'Undead' and 'SCOURGE' or r == 'Night Elf' and 'NIGHTELF' or string.upper(r)
		u['health'] 	= UnitHealth(unit)
		u['maxhealth'] 	= UnitHealthMax(unit)
		u['mana'] 		= UnitMana(unit)
		u['maxmana']	= UnitManaMax(unit)
		local s = UnitSex(unit)
		u['sex']		= (s == 1 or s == 2) and 'MALE' or s == 3 and 'FEMALE' 

		addNearbyPlayers({u})
	end
end


--	attempt to get enemy info from raid's targets
-- 	check one every frame rather than all every other frame
local function getRaidMembersTarget()
	local numRaidMembers = UnitInRaid('player') and GetNumRaidMembers() or GetNumPartyMembers() 
	if numRaidMembers == 0 then return end
	
	verifyUnitInfo('raid' .. raidMemberIndex .. 'target')

	raidMemberIndex = raidMemberIndex < numRaidMembers and raidMemberIndex + 1 or 1
end

-- update unit info: casts, cc, inactive
local function updatePlayerListInfo()
	local nextCheck = GetTime() + nextPlayerCheck

	for k, v in pairs(playerList) do
		local c, b = v['castinfo'], v['buff'] 
		v['castinfo'] 	= SPELLCASTINGCOREgetCast(v['name'])
		v['buff'] 		= SPELLCASTINGCOREgetPrioBuff(v['name'], 1)[1]
		
		if v['castinfo'] or v['buff'] then	
			v['nextCheck'] 	= nextCheck	
			-- set health to 100 for newly seen players
			if v['nearby'] == false then	v['health'] = v['maxhealth'] and v['maxhealth'] or 100	v['mana'] = v['maxmana'] and v['maxmana'] or 100	refreshUnits 	= true	v['refresh'] 	= true	end
			v['nearby'] 	= true
			
			--refreshUnits 	= true
		--else
			-- check if a cast or buff is recently gone
		---	if c ~= nil or b ~= nil then
		--		v['refresh'] 	= true
				--refreshUnits 	= true
		--	end
		end
		
		-- remove inactive player
		if v['nextCheck'] and v['nearby'] then
			if GetTime() > v['nextCheck'] then	
				refreshUnits 	= true 	
				v['nearby'] 	= false
				v['health']		= v['maxhealth'] and v['maxhealth'] or 100
				v['mana'] 		= v['class'] == 'WARRIOR' and 0 or v['maxmana'] and v['maxmana']  or 100
				v['refresh'] 	= true 
			end	
		end
		
		-- outdoors
		if not insideBG then
			if GetTime() > v['lastSeen'] then
				playerList[v['name']] 	= nil
				refreshUnits 			= true
			end
		end
		
	end
end

local function removeRaidTarget(tar, icon)
	-- one icon one target
	for k, v in pairs(raidTargets) do
		if v['icon'] == icon or v['name'] == tar then
			raidTargets[v['name']] = nil
		end
	end
end

local function verifynearbylist( p)
	for k, v in pairs(nearbyList) do
		if v['name'] == p['name'] then
			return k
		end
	end
	return 0
end

local function orderByClass(l, e)
	for j, v in pairs(l) do
		if e['class'] < v['class'] or (e['class'] == v['class'] and e['name'] < v['name']) then
			table.insert(l, j, e)
			return l
		end
	end
	table.insert(l, e)
	return l
end

local function orderUnitsforOutput()
	local list, listb = {}, {}
	-- order nearby units first -- this loop avoid units jumping from hopping around in the unit matrix
	local i = 1
	local nSize = tlength(nearbyList)
	
	for k, v in pairs(playerList) do
		if v['nearby'] then
			i = verifynearbylist(v)
			if i ~= 0  then
				nearbyList[i] = v
			else
				table.insert(nearbyList, v)
			end
		else
			i = verifynearbylist(v)
			if i ~= 0 then table.remove(nearbyList, i)	end
			listb = orderByClass(listb, v)
		end
	end
	
	-- maintain same order
	for k, v in pairs(nearbyList) do
		table.insert(list, v)
	end
	for k, v in pairs(listb) do
		table.insert(list, v)
	end
	
	return list
end

--- GLOBAL ACCESS ---
function ENEMYFRAMESCOREGetUnitsInfo()
	if refreshUnits then
		refreshUnits = false
		return orderUnitsforOutput()--playerList
	end
	return nil
end
-- player list drawn
function ENEMYFRAMESCOREListRefreshed()
	for k, v in pairs(playerList) do
		v['refresh'] = false
	end
end

function ENEMYFRAMECOREUpdateFlagCarriers(fc)
	for k, v in pairs(playerList) do
		-- no carriers
		local f = v['fc']
		if fc[playerFaction] == nil then
			v['fc'] = false
		else
			v['fc'] = (v['name'] == fc[playerFaction]) and true or false
		end
		-- refresh if player's fc status changed
		v['refresh'] = f ~= v['fc'] and true or false
	end
	refreshUnits = true
end

function ENEMYFRAMECORESetPlayersData(list)
	if insideBG then
		addNearbyPlayers(list)
	end
	--local l = {}
	--for k, v in pairs(list) do
	--	if playerList[k] then
	--		l[k] = v
	--	end
	--end
	--addNearbyPlayers(l)
end

-- raid target functions
function  ENEMYFRAMECORESendRaidTarget(icon, name)
	if name == nil or (raidTargets[name] and raidTargets[name]['icon'] == icon) then
		name = 0
	end
	
	sendMSG('RT', name, icon)
	ENEMYFRAMECORESetRaidTarget(nil, name, icon)
end

function  ENEMYFRAMECORESetRaidTarget(sender, tar, icon)
	removeRaidTarget(tar, icon)
	
	if playerList[tar] then
		raidTargets[tar] = {['name'] = tar, ['icon'] = icon}
		if sender ~= nil and sender ~= UnitName'player' then
			ENEMYFRAMESAnnounceRT(raidTargets, playerList[tar])
		end
	end
end

function  ENEMYFRAMECOREGetRaidTarget()
	return raidTargets
end

function ENEMYFRAMECOREGetRaidTargetbyIcon(icon)
	for k, v in pairs(raidTargets) do
		if v['icon'] == icon then
			return v['name']
		end
	end
end
--
--#################--
---------------------

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
	
	-- hide if no horde while outdoors
	 if not _G['enemyFramesSettings']:IsShown() then		
		if not insideBG then
			if tlength(playerList) == 0 then				
					_G['enemyFrameDisplay']:Hide()
			else
				_G['enemyFrameDisplay']:Show()
			end
		end
	end
end

-- DUMMY FRAME
local f = CreateFrame('Frame', 'enemyFramesCore', UIParent)

local function initializeValues()
	insideBG = false
	playerFaction = UnitFactionGroup('player')
		
	playerList = {}
	raidTargets = {}
	nearbyList, notnearbyList = {}, {}
	
	local maxUnits = bgs[GetZoneText()] and bgs[GetZoneText()] or ENEMYFRAMESPLAYERDATA['enableOutdoors'] and 15 or nil
	if maxUnits then
		--
		insideBG = bgs[GetZoneText()] and true or false
		
		if insideBG then f:RegisterEvent'UPDATE_BATTLEFIELD_SCORE'	end
		f:SetScript('OnUpdate', enemyFramesCoreOnUpdate)
		-- enable ui elements
		ENEMYFRAMESInitialize(maxUnits, insideBG)
		namePlatesHandlerInit()
		targetframeInit()
		bindingsInit()
	else
		f:UnregisterEvent'UPDATE_BATTLEFIELD_SCORE'
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
	end
end


f:RegisterEvent'PLAYER_ENTERING_WORLD'
f:RegisterEvent'ZONE_CHANGED_NEW_AREA'


f:SetScript('OnEvent', eventHandler)

SLASH_ENEMYFRAMECORE1 = '/efc'
SlashCmdList["ENEMYFRAMECORE"] = function(msg)
end

