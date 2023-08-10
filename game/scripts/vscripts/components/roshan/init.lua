if not Roshan then
	Roshan = class({})

	require("components/roshan/events")

	Roshan.bonusMinuteBuff = 1200.0 -- 20 minutes

	-- ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(Roshan, 'OnGameRulesStateChange'), Roshan)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(Roshan, 'OnNPCSpawned'), Roshan)
	-- ListenToGameEvent('entity_killed', Dynamic_Wrap(Roshan, 'OnEntityKilled'), Roshan)
end

function Roshan:GetBuffTime()
	return Roshan.bonusMinuteBuff
end
