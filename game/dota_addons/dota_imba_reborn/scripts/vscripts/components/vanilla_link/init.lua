ListenToGameEvent('npc_spawned', function(keys)
	local npc = EntIndexToHScript(keys.entindex)

	if npc and not npc.first_spawn and npc:IsRealHero() and npc == PlayerResource:GetPlayer(npc:GetPlayerID()):GetAssignedHero() then
		npc.first_spawn = true

		local abilities = {}

		for i = 0, npc:GetAbilityCount() - 1 do
			local ability = npc:GetAbilityByIndex(i)

			if ability then
				local vanilla_ability_name = string.gsub(ability:GetAbilityName(), "imba_", "")
				table.insert(abilities, i, vanilla_ability_name)
				npc:AddAbility(vanilla_ability_name)
				local vanilla_ability = npc:FindAbilityByName(vanilla_ability_name)
				if vanilla_ability then
					vanilla_ability:SetHidden(true)
				else
					print("Vanilla ability not found:", vanilla_ability_name)
					return
				end
			end
		end

		CustomGameEventManager:Send_ServerToAllClients("vanilla_abilities_"..npc:GetPlayerID(), abilities)
	end
end, nil)
