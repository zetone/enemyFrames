
local Cast 			= {} 		local casts 	= {}
local Heal 			= {} 		local heals		= {}
local InstaBuff 	= {} 		local iBuffs 	= {}
local buff 			= {} 		local buffList 	= {}
local dead 			= {} 		local deadList = {}
Cast.__index   		= modcast
Heal.__index   		= Heal
InstaBuff.__index 	= InstaBuff
buff.__index 		= buff
dead.__index 		= dead


Cast.create = function(caster, spell, info, timeMod, time, inv)
	local acnt = {}
	setmetatable(acnt, modcast)
	acnt.caster     = caster
	acnt.spell      = spell
	acnt.icon       = info['icon']
	acnt.timeStart  = time
	acnt.timeEnd    = time + info['casttime']*timeMod
	acnt.tick	    = info['tick'] and info['tick'] or 0 
	--if info[3] then
	acnt.nextTick	= info['tick'] and time + acnt.tick or acnt.timeEnd 
	acnt.inverse    = inv	
	return acnt
end

Heal.create = function(n, no, crit, time)
   local acnt = {}
   setmetatable(acnt,Heal)
   acnt.target    = n
   acnt.amount    = no
   acnt.crit      = crit
   acnt.timeStart = time
   acnt.timeEnd   = time + 2
   acnt.y         = 0
   return acnt
end

InstaBuff.create = function(c, b, list, time)
   local acnt = {}
   setmetatable(acnt,InstaBuff)
   acnt.caster    	= c
   acnt.spell      	= b
   acnt.timeMod 	= list['mod']
   acnt.spellList 	= list['list']
   acnt.timeStart	= time
   acnt.timeEnd   	= time + 10	--planned obsolescence
   return acnt
end

buff.create = function(tar, t, buffType, time)
	local acnt     = {}
	setmetatable(acnt, buff)
	acnt.target    	= tar
	acnt.caster    	= tar	-- facilitate entry removal
	acnt.spell      = t
	acnt.icon      	= buffType['icon']
	acnt.timeStart 	= time
	acnt.timeEnd   	= time + buffType['duration']
	acnt.prio		= buffType['prio'] and buffType['prio'] or 0
	acnt.border		= buffType['type'] and RGB_BORDER_DEBUFFS_COLOR[buffType['type']] or {.2, .2, .2}	-- border rgb values depending on type of buff/debuff
	return acnt
end

local removeExpiredTableEntries = function(tab)
	local i = 1
	for k, v in pairs(tab) do
		if GetTime() > v.timeEnd then
			table.remove(tab, i)
		end
		i = i + 1
	end
end
local tableMaintenance = function(reset)
	if reset then
		casts = {} heals = {} iBuffs = {} buffList = {}
	else
		-- CASTS -- casts have different removal parameter
		local i = 1
		for k, v in pairs(casts) do
			if GetTime() > v.timeEnd or GetTime() > v.nextTick then	-- channeling cast verification
				table.remove(casts, i)
			end
			i = i + 1
		end
		-- HEALS
		removeExpiredTableEntries(heals)
		--  CASTING SPEED BUFFS
		removeExpiredTableEntries(iBuffs)
		-- BUFFS / DEBUFFS
		removeExpiredTableEntries(buffList)
	end
end

local removeDoubleCast = function(caster)
	local k = 1
	for i, j in casts do
		if j.caster == caster then table.remove(casts, k) end
		k = k + 1
	end
end

local checkForChannels = function(caster, spell)
	local k = 1
	for i, j in casts do
		if j.caster == caster and j.spell == spell and SPELLINFO_CHANNELED_SPELLCASTS_TO_TRACK[spell] ~= nil then 
			j.nextTick = j.nextTick + j.tick
			return true 
		end
		k = k + 1
	end
	return false
end

local checkforCastTimeModBuffs = function(caster, spell)
	local k = 1
	for i, j in iBuffs do
		if j.caster == caster then 
			if j.spellList[1] ~= 'all' then
				local a, lastT = 1, 1		
				for b, c in j.spellList do
					if c == spell then
						if lastT ~= 0 then			-- priority to buffs that proc instant cast
							lastT = j.timeMod
						end
					end
				end
				return lastT
			else
				return j.timeMod
			end
			--return false
		end
		k = k + 1
	end
	return 1
end

local newCast = function(caster, spell, channel)
	local time = GetTime()
	local info = nil
	
	if channel then
		if SPELLINFO_CHANNELED_HEALS_SPELLCASTS_TO_TRACK[spell] ~= nil then info = SPELLINFO_CHANNELED_HEALS_SPELLCASTS_TO_TRACK[spell]
		elseif SPELLINFO_CHANNELED_SPELLCASTS_TO_TRACK[spell] ~= nil then info = SPELLINFO_CHANNELED_SPELLCASTS_TO_TRACK[spell] end
	else
		if SPELLINFO_SPELLCASTS_TO_TRACK[spell] ~= nil then info = SPELLINFO_SPELLCASTS_TO_TRACK[spell] 
		elseif SPELLINFO_TRADECASTS_TO_TRACK[spell] ~= nil then info = SPELLINFO_TRADECASTS_TO_TRACK[spell] end
	end
	if info ~= nil then
		if not checkForChannels(caster, spell) then
			removeDoubleCast(caster)
			local tMod = checkforCastTimeModBuffs(caster, spell)
			if  tMod > 0 then
				local n = Cast.create(caster, spell, info, tMod, time, channel)
				table.insert(casts, n)
			end
		end
	end

end

local newHeal = function(n, no, crit)
	local time = GetTime()
	local h = Heal.create(n, no, crit, time)
	table.insert(heals, h)
end

local newIBuff = function(caster, buff)
	local time = GetTime()
	local b = InstaBuff.create(caster, buff, SPELLINFO_TIME_MODIFIER_BUFFS_TO_TRACK[buff], time)
	table.insert(iBuffs, b)
end

local function newbuff(tar, t)
	local time = GetTime()
	local n = buff.create(tar, t, SPELLINFO_BUFFS_TO_TRACK[t], time)
	table.insert(buffList, n)
end

local newDead =  function(caster)
	local time = GetTime()
	local n = dead.create(caster, time)
	table.insert(deadList, n)
end

-----handleCast subfunctions-----------------------------------------------
---------------------------------------------------------------------------
local forceHideTableItem = function(tab, caster, spell)
	local time = GetTime()
	for k, v in pairs(tab) do
		if (time < v.timeEnd) and (v.caster == caster) then
			if (spell ~= nil) then if v.spell == spell then	v.timeEnd = time - 10000 end 
			else
				v.timeEnd = time - 10000 -- force hide
			end
		end
	end
end

local CastCraftPerform = function()
	local cast = '(.+) begins to cast (.+).' 						local fcast = string.find(arg1, cast)
	local craft = '(.+) -> (.+).' 									local fcraft = string.find(arg1, craft)
	local perform = '(.+) performs (.+).' 							local fperform = string.find(arg1, perform)
	local bperform = '(.+) begins to perform (.+).' 				local fbperform = string.find(arg1, bperform)
	
	if fcast or fcraft then
		local m = fcast and cast or fcraft and craft or fperform and perform
		local c = gsub(arg1, m, '%1')
		local s = gsub(arg1, m, '%2')
		newCast(c, s, false)
		--print(arg1)
		
	elseif fperform or fbperform then
		local m = fperform and perform or fbperform and bperform
		local c = gsub(arg1, m, '%1')
		local s = gsub(arg1, m, '%2')
		newCast(c, s, true)
	end
	
	return fcast or fcraftor or fperform
end

local GainFadeAfflict = function()
	local gain = '(.+) gains (.+).' 								local fgain = string.find(arg1, gain)
	local fade = '(.+) fades from (.+).'							local ffade = string.find(arg1, fade)
	local afflict = '(.+) is afflicted by (.+).' 					local fafflict = string.find(arg1, afflict)
	local rem = '(.+)\'s (.+) is removed'							local frem = string.find(arg1, rem)
	
	-- start channeling based on buffs (evocation, first aid, ..)
	if fgain then
		local m = gain
		local c = gsub(arg1, m, '%1')
		local s = gsub(arg1, m, '%2')
		
		-- buffs/debuffs to be displayed
		if SPELLINFO_BUFFS_TO_TRACK[s] then
			newbuff(c, s)
		end
		
		-- self-cast buffs that interrupt cast (blink, ice block ...)
		if SPELLINFO_INTERRUPTS_TO_TRACK[s] then
			forceHideTableItem(casts, c, nil)
		end
		-- specific channeled spells (evocation ...)
		if SPELLINFO_CHANNELED_SPELLCASTS_TO_TRACK[s] then
			newCast(c, s, true)
		end
		-- buffs that alter spell casting speed
		if SPELLINFO_TIME_MODIFIER_BUFFS_TO_TRACK[s] then
			newIBuff(c, s)
		end
	
	-- end channeling based on buffs (evocation ..)
	elseif ffade then
		local m = fade
		local c = gsub(arg1, m, '%2')
		local s = gsub(arg1, m, '%1')
		
		-- buffs/debuffs to be displayed
		if SPELLINFO_BUFFS_TO_TRACK[s] then
			forceHideTableItem(buffList, c, s)
		end
		
		if SPELLINFO_CHANNELED_SPELLCASTS_TO_TRACK[s] then
			forceHideTableItem(casts, c, nil)
		end
		
		if SPELLINFO_TIME_MODIFIER_BUFFS_TO_TRACK[s] then
			forceHideTableItem(iBuffs, c, s)
		end
		
	-- cast-interruting CC
	elseif fafflict then
		local m = afflict
		local c = gsub(arg1, m, '%1')
		local s = gsub(arg1, m, '%2')
		
		-- debuffs to be displayed
		if SPELLINFO_BUFFS_TO_TRACK[s] then
			newbuff(c, s)
		end
		
		-- spell interrupting debuffs (stuns, incapacitate ...)
		if SPELLINFO_INTERRUPTS_TO_TRACK[s] then
			forceHideTableItem(casts, c, nil)
		end
		-- debuffs that slow spellcasting speed (tongues ...)
		if SPELLINFO_TIME_MODIFIER_BUFFS_TO_TRACK[s] then
			newIBuff(c, s)
		end
		
	elseif frem then
		local m = rem
		local c = gsub(arg1, m, '%1')
		local s = gsub(arg1, m, '%2')
		
		-- buffs/debuffs to be displayed
		if SPELLINFO_BUFFS_TO_TRACK[s] then
			forceHideTableItem(buffList, c, s)
		end
		
		if SPELLINFO_TIME_MODIFIER_BUFFS_TO_TRACK[s] then
			forceHideTableItem(iBuffs, c, s)
		end
	end
	
	return fgain or ffade or fafflict or frem
end

local HitsCrits = function()
	local hits = '(.+)\'s (.+) hits (.+) for (.+)' 					local fhits = string.find(arg1, hits)
	local crits = '(.+)\'s (.+) crits (.+) for (.+)' 				local fcrits = string.find(arg1, crits)
	local absb = '(.+)\'s (.+) is absorbed by (.+).'				local fabsb = string.find(arg1, absb)
	
	local phits = 'Your (.+) hits (.+) for (.+)' 					local fphits = string.find(arg1, phits)
	local pcrits = 'Your (.+) crits (.+) for (.+)' 					local fpcrits = string.find(arg1, pcrits)	
	local pabsb = 'Your (.+) is absorbed by (.+).'					local fpabsb = string.find(arg1, pabsb)
	
	--local fails = "(.+)'s (.+) fails."								local ffails = string.find(arg1, fails)		
	-- other hits/crits
	if fhits or fcrits or fabsb then
		local m = fhits and hits or fcrits and crits or fabsb and absb
		local c = gsub(arg1, m, '%1')
		local s = gsub(arg1, m, '%2')
		local t = gsub(arg1, m, '%3')
		
		-- instant spells that cancel casted ones
		if SPELLINFO_INSTANT_SPELLCASTS_TO_TRACK[s] then 
			forceHideTableItem(casts, c, nil)
		end
		
		if SPELLINFO_CHANNELED_SPELLCASTS_TO_TRACK[s] then
			newCast(c, s, true)
		end			
		
		-- interrupt dmg spell
		if SPELLINFO_INTERRUPTS_TO_TRACK[s] then
			forceHideTableItem(casts, t, nil)
		end
	end
	
	-- self hits/crits
	if fphits or fpcrits or fpabsb then
		local m = fphits and phits or fpcrits and pcrits or fpabsb and pabsb
		local s = gsub(arg1, m, '%1')
		local t = gsub(arg1, m, '%2')
		
		-- interrupt dmg spell
		if SPELLINFO_INTERRUPTS_TO_TRACK[s] then
			forceHideTableItem(casts, t, nil)
		end
	end
	
	return fhits or fcrits or fphits or fpcrits or fabsb or fpabsb --or ffails
end

local channelDot = function()
	local channelDot = "(.+) suffers (.+) from (.+)'s (.+)."		local fchannelDot = string.find(arg1, channelDot)
	local pchannelDot = "You suffer (.+) from (.+)'s (.+)."			local fpchannelDot = string.find(arg1, pchannelDot)
			
	local channelDotRes = "(.+)'s (.+) was resisted by (.+)."		local fchannelDotRes = string.find(arg1, channelDotRes)
	local pchannelDotRes = "(.+)'s (.+) was resisted."				local fpchannelDotRes = string.find(arg1, pchannelDotRes)
	
	local MDrain = "(.+)\'s (.+) drains (.+) Mana from"				local fMDrain = string.find(arg1, MDrain)
	
	-- channeling dmg spells on other (mind flay, life drain(?))
	if fchannelDot then
		local m = channelDot
		local c = gsub(arg1, m, '%3')
		local s = gsub(arg1, m, '%4')
		local t = gsub(arg1, m, '%1')
		
		if SPELLINFO_CHANNELED_SPELLCASTS_TO_TRACK[s] then
			newCast(c, s, true)
		end			
	end
	
	-- channeling dmg spells on self (mind flay, life drain(?))
	if fpchannelDot then
		local m = pchannelDot
		local c = gsub(arg1, m, '%2')
		local s = gsub(arg1, m, '%3')
		
		if SPELLINFO_CHANNELED_SPELLCASTS_TO_TRACK[s] then
			newCast(c, s, true)
		end			
	end
	
	-- resisted channeling dmg spells (arcane missiles)
	if fchannelDotRes or fpchannelDotRes then
		local m = fchannelDotRes and channelDotRes or fpchannelDotRes and pchannelDotRes
		local c = gsub(arg1, m, '%1')
		local s = gsub(arg1, m, '%2')
		
		if SPELLINFO_CHANNELED_SPELLCASTS_TO_TRACK[s] then
			newCast(c, s, true)
		end			
	end
	
	-- drain mana 
	if fMDrain then
		local m = MDrain
		local c = gsub(arg1, m, '%1')
		local s = gsub(arg1, m, '%2')
		
		if SPELLINFO_CHANNELED_SPELLCASTS_TO_TRACK[s] then
			newCast(c, s, true)
		end	
	end
	return fchannelDot or fpchannelDot or fchannelDotRes or fpchannelDotRes or fMDrain
end

local channelHeal = function()
	local hot = '(.+) gains (.+) health from (.+)\'s (.+).'			local fhot = string.find(arg1, hot)
	local phot = 'You gain (.+) health from (.+)\'s (.+).'			local fphot = string.find(arg1, phot)
	
	if fhot then
		local m = fhot and hot or fphot and phot
		local c = fhot and gsub(arg1, m, '%3') or fphot and gsub(arg1, m, '%2')
		local s = fhot and gsub(arg1, m, '%4') or fphot and gsub(arg1, m, '%3')
		local t = fhot and gsub(arg1, m, '%1') or nil
		
		if SPELLINFO_CHANNELED_HEALS_SPELLCASTS_TO_TRACK[s] then
			newCast(c, s, true)
		end	
	end
end

local playerDeath = function()
	local dies	= '(.+) dies.'				local fdies		= string.find(arg1, dies)
	
	if fdies then
		local c = gsub(arg1, dies, '%1')
		
		forceHideTableItem(casts, c, nil)
		forceHideTableItem(buffList, c, nil)
		
		-- send dead player data
		ENEMYFRAMECORESetPlayersData({[c] = {['name'] = c, ['health']  = 0}})
	end
	
	return fdies
end

local fear = function()
	local fear = '(.+) attempts to run away in fear!' 				local ffear = string.find(arg1, fear)
	
	if ffear then
		local t = arg2			
		forceHideTableItem(casts, t)	
	end
	
	return ffear
end

----------------------------------------------------------------------------
local handleCast = function()
	if not CastCraftPerform() then
		if not GainFadeAfflict() then
			if not HitsCrits() then
				if not channelDot() then
					if not channelHeal() then
						if not playerDeath() then
							fear()
						end
					end
				end
			end
		end
	end
end

local handleHeal = function()
	local h   = 'Your (.+) heals (.+) for (.+).'
	local c   = 'Your (.+) critically heals (.+) for (.+).'
	local hot = '(.+) gains (.+) health from your (.+).'
	local totemHot = '(.+) gains (.+) health from (.+)\'s (.+).'
	
	if string.find(arg1, h) or string.find(arg1, c) then
		local n  = gsub(arg1, h, '%2')
		local no = gsub(arg1, h, '%3')
		newHeal(n, no, string.find(arg1, c) and 1 or 0)
	elseif string.find(arg1, hot) or string.find(arg1, totemHot)  then
		local m = string.find(arg1, hot) and hot or  string.find(arg1, totemHot) and totemHot			
		local n  = gsub(arg1, m, '%1')
		local no = gsub(arg1, m, '%2')
		newHeal(n, no, 0)
	end
end



-- GLOBAL ACCESS FUNCTIONS
SPELLCASTINGCOREgetCast = function(caster)
	if caster == nil then return nil end
	for k, v in pairs(casts) do
		if v.caster == caster then
			return v
		end
	end
	return nil
end

SPELLCASTINGCOREgetHeal = function(target)
	for k, v in pairs(heals) do
		if v.target == target then
			return v
		end
	end
	return nil
end

SPELLCASTINGCOREgetPrioBuff = function(name)
	local b = nil
	local p = -1
	for j, e in ipairs(buffList) do
		if e.target == name then
			if e.prio > p then
				b = e 
				p = e.prio 
			end
		end
	end
	return b
end

SPELLCASTINGCOREgetBuffs = function(name)
	local list = {}
	for j, e in ipairs(buffList) do
		if e.target == name then
			table.insert(list, e)
		end
	end
	return list
end

SPELLCASTINGCOREgetActivePlayers = function()
end

-------------------------------------


local f = CreateFrame'Frame'
f:SetScript('OnUpdate', function()
	tableMaintenance(false)
end)

f:RegisterEvent'PLAYER_ENTERING_WORLD'
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

f:SetScript('OnEvent', function()
	if event == 'PLAYER_ENTERING_WORLD' then
		tableMaintenance(true)
	elseif event == 'CHAT_MSG_SPELL_SELF_BUFF' or event == 'CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS' then--or event == 'CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS' then
		handleHeal()
	else handleCast()  end
end)

--
	
SLASH_PROCESSCAST1 = '/pct'
SlashCmdList["PROCESSCAST"] = function(msg)

end
