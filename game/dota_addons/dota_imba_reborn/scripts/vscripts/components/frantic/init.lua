LinkLuaModifier("modifier_frantic", "components/modifiers/mutation/modifier_frantic.lua", LUA_MODIFIER_MOTION_NONE )

ListenToGameEvent('game_rules_state_change', function()
	-- Minor delay is required as the "custom game difficulty" is not initialized on the exact frame of game rule state change
	Timers:CreateTimer(FrameTime(), function()
		--	print("Gamemode:", GameMode:GetCustomGamemode())
		
		-- If Super Frantic is not selected, do not run the remaining code
		if GameMode:GetCustomGamemode() ~= 3 then
			return
		end

		-- Apply frantic logic at the Hero Selection screen
		if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
			require("components/frantic/settings")
			require('components/frantic/events')
		end
	end)
end, nil)