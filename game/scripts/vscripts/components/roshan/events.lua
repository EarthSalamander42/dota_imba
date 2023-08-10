function Roshan:OnNPCSpawned(keys)
	local spawnedUnit = EntIndexToHScript(keys.entindex)

	if spawnedUnit then
		if spawnedUnit:GetClassname() == "npc_dota_roshan" then
			-- remove the default roshan abilities (bonus health and damage over time)
			if spawnedUnit:HasAbility("roshan_inherent_buffs") then
				spawnedUnit:RemoveAbility("roshan_inherent_buffs")
				spawnedUnit:AddAbility("roshan_inherent_buffs_custom")
			end

			-- remove the default roshan abilities (bonus armor over time)
			if spawnedUnit:HasAbility("roshan_devotion") then
				spawnedUnit:RemoveAbility("roshan_devotion")
			end
		end
	end
end
