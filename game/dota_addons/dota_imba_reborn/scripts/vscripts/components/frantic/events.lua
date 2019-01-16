ListenToGameEvent('npc_spawned', function(keys)
--	print("Frantic: On NPC Spawned")
	local npc = EntIndexToHScript(keys.entindex)

	if not npc:IsRealHero() then
--		if not npc.first_spawn_frantic then
--			npc.first_spawn_frantic = true
--		end

		return
	end

	local hero = npc

	if hero:GetUnitName() == FORCE_PICKED_HERO then return end

	if hero.first_spawn_frantic == true then
--		print("Frantic: On Hero Respawned")
	else
--		print("Frantic: On Hero First Spawn")
		hero.first_spawn_frantic = true

		hero:AddNewModifier(hero, nil, "modifier_frantic", {}):SetStackCount(IMBA_FRANTIC_VALUE)
	end
end, nil)
