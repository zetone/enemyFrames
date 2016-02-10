
local msgPrefix = {['RT'] = 'BGEFRT', ['EFC'] = 'BGEFEFC'}

function sendMSG(typ, d, icon)
	d = UnitName'player' .. '/' .. d .. '/' .. icon
	SendAddonMessage(msgPrefix[typ], d, 'BATTLEGROUND')
end

local function eventHandler()
	local prefix = 'BGEF(.+)'			local fprefix = string.find(arg1, prefix)
	
	if fprefix then
		local comm = gsub(arg1, prefix, '%1')
		
		-- raid targets
		if  comm == 'RT' then
			local m = '(.+)/(.+)/(.+)'	local fm = string.find(arg2, m)
			
			if fm then
				local sender 	= gsub(arg2, m, '%1')
				local target 	= gsub(arg2, m, '%2')
				local icon 		= gsub(arg2, m, '%3')
				--print(sender .. ' sets ' .. icon .. ' on ' .. target)
				ENEMYFRAMECORESetRaidTarget(sender, target, icon)
			end
		end
		
		-- seen EFC
		if  comm == 'EFC' then
			local m = '(.+)'	local fm = string.find(arg2, m)
			
			if fm then
				local sender = gsub(arg2, m, '%1')
				print(sender .. ' has seen EFC')
				
			end
		end
	end
	
end

local f = CreateFrame'frame'
f:RegisterEvent'CHAT_MSG_ADDON'

f:SetScript('OnEvent', eventHandler)