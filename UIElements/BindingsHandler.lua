
	-- Binding Variables
	BINDING_HEADER_EFKHEADER 	= "Enemy Frames Keybinds"
	BINDING_NAME_SETKT 			= "Set KillTarget"
	BINDING_NAME_GETKT 			= "Target KillTarget"
	
	
	
	function setKTbind()
		if UnitExists'target' then
			ENEMYFRAMECORESendKillTarget(UnitName'target')
		end
	end
	
	function getKTbind()
		TargetByName(ENEMYFRAMECOREGetKillTarget(), true)
	end