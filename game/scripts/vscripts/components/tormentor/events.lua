function Tormentors:OnGameRulesStateChange()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		Tormentors:Init()
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("Tormentors:spawn"), function()
			-- iterate from team 2 to team 3
			for iTeam = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
				local tormentor = CreateUnitByName("npc_dota_miniboss_custom", Tormentors.spawnLocation[iTeam], true, nil, nil, DOTA_TEAM_NEUTRALS)
				tormentor.tormentorTeam = iTeam

				if iTeam == DOTA_TEAM_BADGUYS then
					tormentor:SetMaterialGroup("1")
				end
			end
		end, Tormentors.spawnTime)
	end
end

function Tormentors:OnNPCSpawned(keys)
	local spawnedUnit = EntIndexToHScript(keys.entindex)

	if spawnedUnit then
		-- Check if real tormentor spawned
		if spawnedUnit:GetUnitName() == "npc_dota_miniboss" then
			-- hide the unit
			spawnedUnit:AddNoDraw()

			-- move the unit to a far away location.
			local position = Vector(20000, 0, 0) and spawnedUnit:GetTeam() == DOTA_TEAM_GOODGUYS or Vector(-20000, 0, 0)
			spawnedUnit:SetAbsOrigin(position)

			-- removing abilities is required to remove lingering effects
			spawnedUnit:RemoveAbility("miniboss_unyielding_shield")
			spawnedUnit:RemoveAbility("miniboss_reflect")

			-- UTIL_Remove(spawnedUnit) -- crashes the game
		end
	end
end

function Tormentors:OnEntityKilled(keys)
	local killedUnit = EntIndexToHScript(keys.entindex_killed)

	if killedUnit and killedUnit:GetUnitName() == "npc_dota_miniboss_custom" then
		-- increment deaths
		local tormentorTeam = killedUnit.tormentorTeam
		Tormentors:IncrementDeaths(tormentorTeam)

		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("Tormentors:respawn"), function()
			local tormentor = CreateUnitByName("npc_dota_miniboss_custom", Tormentors.spawnLocation[tormentorTeam], true, nil, nil, DOTA_TEAM_NEUTRALS)
			tormentor.tormentorTeam = tormentorTeam

			if tormentorTeam == DOTA_TEAM_BADGUYS then
				tormentor:SetMaterialGroup("1")
			end
		end, Tormentors.spawnTime)
	end
end
