require('components/battlepass/donator')
require('components/battlepass/experience')
require('components/battlepass/imbattlepass')

ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		GetPlayerInfoIXP() -- Add a class later
		Imbattlepass:Init() -- Initialize Battle Pass		
	end
end, nil)

ListenToGameEvent('npc_spawned', function(event)
	local npc = EntIndexToHScript(event.entindex)

	if npc:IsRealHero() then
		CustomGameEventManager:Send_ServerToAllClients("override_hero_image", {
			hero_name = string.gsub(npc:GetUnitName(), "npc_dota_hero_", ""),
		})
	end
end, nil)
