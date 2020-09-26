ListenToGameEvent("npc_spawned", function(keys)
	local hero = EntIndexToHScript(keys.entindex)

	if hero:IsRealHero() and not hero.tooltips_init then
		local ability_values = {}
		ability_values["cooldown"] = {}
		ability_values["manacost"] = {}
		ability_values["specials"] = {}

		for i = 0, 24 do
			local ability = hero:GetAbilityByIndex(i)

			if ability then
				ability_values["cooldown"][i] = GetAbilityCooldown(ability:GetAbilityName())
				ability_values["manacost"][i] = GetAbilityManaCost(ability:GetAbilityName())
				ability_values["specials"][i] = GetAbilitySpecials(ability:GetAbilityName())
			end
		end

		CustomNetTables:SetTableValue("player_table", "tooltips_"..hero:GetPlayerID(), ability_values)

		hero.tooltips_init = true
	end
end, nil)
