
--local msgPrefix = {'BGEFKT',}

function sendMSG(d)
	d = UnitName'player' .. '/' .. d
	SendAddonMessage('BGEFKT', d, 'BATTLEGROUND')
end

local function eventHandler()
	local m = '(.+)/(.+)'
	if arg1 == 'BGEFKT' then
		local p = gsub(arg2, m, '%1')
		local t = gsub(arg2, m, '%2')
		--print(p .. ' sets ' .. t .. ' as killtarget')
		if p ~= UnitName'player' then
			ENEMYFRAMECORESetKillTarget(p, t)
		end
	end
end

local f = CreateFrame'frame'
f:RegisterEvent'CHAT_MSG_ADDON'

f:SetScript('OnEvent', eventHandler)