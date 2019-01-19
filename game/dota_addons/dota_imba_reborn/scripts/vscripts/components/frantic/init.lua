LinkLuaModifier("modifier_frantic", "components/modifiers/mutation/modifier_frantic.lua", LUA_MODIFIER_MOTION_NONE )

ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_HERO_SELECTION then
--		print("Gamemode:", GameRules:GetCustomGameDifficulty())
		if GameRules:GetCustomGameDifficulty() ~= 3 then
			return
		else
			require("components/frantic/settings")
			require('components/frantic/events')
		end		
	end
end, nil)
