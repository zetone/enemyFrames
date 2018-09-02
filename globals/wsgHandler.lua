	-------------------------------------------------------------------------------
	local flagCarriers, fcTemp = {}, {}
	-------------------------------------------------------------------------------
	local eventHandler = function()

		if event ~= 'RAID_ROSTER_UPDATE' then
			-- Flag for Alliance flag for horde. thanks blizzard
			local pick 	= 'The (.+) (.+) was picked up by (.+)!'
			local drop 	= 'The (.+) (.+) was dropped by (.+)!'
			local score = 'captured the (.+) (.+)!'
			
			if string.find(arg1, pick) then
				local flag 		= gsub(arg1, pick, '%1')
				local carrier 	= gsub(arg1, pick, '%3')
				
				flagCarriers[flag] = carrier
			end
			
			if string.find(arg1, drop) then
				local flag 		= gsub(arg1, drop, '%1')
				
				flagCarriers[flag] = nil
			end
			
			if string.find(arg1, score) then
				flagCarriers = {}
			end
			
			ENEMYFRAMECOREUpdateFlagCarriers(flagCarriers)
		else
			fcTemp['Alliance'] = flagCarriers['Alliance'] 	and flagCarriers['Alliance'] 	or ' '
			fcTemp['Horde']    = flagCarriers['Horde'] 		and flagCarriers['Horde'] 		or ' '
			
			sendMSG('EFC', fcTemp['Alliance'], fcTemp['Horde'], true)
		end
	end
	-------------------------------------------------------------------------------
	local f = CreateFrame'Frame'
	f:RegisterEvent'PLAYER_ENTERING_WORLD'
	f:RegisterEvent'ZONE_CHANGED_NEW_AREA'
	f:RegisterEvent'CHAT_MSG_BG_SYSTEM_ALLIANCE' 
	f:RegisterEvent'CHAT_MSG_BG_SYSTEM_HORDE'
	f:RegisterEvent'RAID_ROSTER_UPDATE'
	f:SetScript('OnEvent', function()	if event == 'PLAYER_ENTERING_WORLD' or event == 'ZONE_CHANGED_NEW_AREA' then	flagCarriers = {}
										else	eventHandler()	end
							end)
	-------------------------------------------------------------------------------