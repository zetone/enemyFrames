
local msgPrefix = {'BGEFKT',}

function sendMSG(d)
	d = UnitName'player' .. '/' .. d
	SendAddonMessage(msgPrefix[1], d, 'BATTLEGROUND')
end

local function eventHandler()
	local m = '(.+)/(.+)'
	if msgPrefix[arg1] then
		print(arg2)
		local p = gsub(arg2, m, '%1')
		local t = gsub(arg2, m, '%2')
		
		ENEMYFRAMECORESetKillTarget(p, t)
	end
end

local f = CreateFrame'frame'
f:RegisterEvent'CHAT_MSG_ADDON'

f:SetScript('OnEvent', eventHandler)