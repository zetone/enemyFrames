	-------------------------------------------------------------------------------
	local _, class = UnitClass'player'
	if class ~= 'ROGUE' then return end
	-------------------------------------------------------------------------------
	UseActionAHone = UseAction
	function UseAction( slot, checkFlags, checkSelf )
		print('one')
		UseActionAH( slot, checkFlags, checkSelf )

	end
	UseActionAHtwo = UseAction
	function UseAction( slot, checkFlags, checkSelf )
		print('two')
		UseActionAHtwo( slot, checkFlags, checkSelf )
	end
	-------------------------------------------------------------------------------