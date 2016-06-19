	-------------------------------------------------------------------------------
	local _, class = UnitClass'player'
	if class ~= 'ROGUE' then return end
	-------------------------------------------------------------------------------
	local processDebuff = function(tar, spell, cp)
		local b = SPELLCASTINGCOREqueueBuff(tar, spell, cp)
		if b then 	
			--b = UnitInBattleground('player') and true or false
			sendMSG('BF', tar..'/'..spell, cp, IsInsideBG())	
		end
	end
	-------------------------------------------------------------------------------
	local AHTooltip = CreateFrame("GameTooltip","RAHTooltip",UIParent,"GameTooltipTemplate")
	AHTooltip:SetOwner(UIParent,"ANCHOR_NONE")
	-------------------------------------------------------------------------------
	UseActionAHone = UseAction
	function UseAction( slot, checkFlags, checkSelf )
		AHTooltip:ClearLines()
		AHTooltip:SetAction(slot)
		local spellName = RAHTooltipTextLeft1:GetText()
		
		local cp = GetComboPoints()
		if cp > 0 and UnitExists'target' then
			processDebuff(UnitName'target', spellName, cp)
		end

		UseActionAH( slot, checkFlags, checkSelf )
	end
	-------------------------------------------------------------------------------
	local eventHandler = function()
	end
	local f = CreateFrame'Frame'
	f:RegisterEvent'SPELLCAST_FAILED'
	f:RegisterEvent'SPELLCAST_INTERRUPTED'
	f:RegisterEvent'SPELLCAST_START'
	f:RegisterEvent'SPELLCAST_STOP'
	f:SetScript('OnEvent', eventHandler)
	-------------------------------------------------------------------------------