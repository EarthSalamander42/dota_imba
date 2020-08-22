ListenToGameEvent('npc_spawned', function(keys)
	local npc = EntIndexToHScript(keys.entindex)

	if npc and not npc.first_spawn and npc:IsRealHero() then
		npc.first_spawn = true

		local abilities = {}

		for i = 0, npc:GetAbilityCount() - 1 do
			local ability = npc:GetAbilityByIndex(i)

			if ability then
				table.insert(abilities, i, string.gsub(ability:GetAbilityName(), "imba_", ""))
			end
		end

		CustomGameEventManager:Send_ServerToAllClients("vanilla_abilities_"..npc:entindex(), abilities)
	end
end, nil)
