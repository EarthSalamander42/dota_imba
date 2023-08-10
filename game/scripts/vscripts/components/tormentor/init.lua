if not Tormentors then
	Tormentors = class({})

	require("components/tormentor/events")

	Tormentors.spawnLocation = {}
	Tormentors.vanillaSpawnerName = {}
	Tormentors.vanillaSpawnerName[DOTA_TEAM_GOODGUYS] = "sentinel_base_radiant"
	Tormentors.vanillaSpawnerName[DOTA_TEAM_BADGUYS] = "sentinel_base_dire"
	Tormentors.deaths = {}
	Tormentors.initialDeaths = 0

	if IsInToolsMode() then
		Tormentors.spawnTime = 10.0
	else
		Tormentors.spawnTime = 1200.0
	end

	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(Tormentors, 'OnGameRulesStateChange'), Tormentors)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(Tormentors, 'OnNPCSpawned'), Tormentors)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(Tormentors, 'OnEntityKilled'), Tormentors)
end

function Tormentors:Init()
	-- iterate from team 2 to team 3
	for iTeam = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		local team_spawner = Entities:FindByName(nil, Tormentors.vanillaSpawnerName[iTeam])

		if team_spawner and team_spawner.GetAbsOrigin then
			Tormentors.spawnLocation[iTeam] = team_spawner:GetAbsOrigin()
			Tormentors.deaths[iTeam] = 0

			-- Set Tormentor level
			if Tormentors.initialDeaths > 0 then
				Tormentors:SetDeaths(iTeam, Tormentors.initialDeaths)
			end
		end
	end
end

function Tormentors:GetDeaths(iTeam)
	return Tormentors.deaths[iTeam] or 0
end

function Tormentors:SetDeaths(iTeam, iDeaths)
	Tormentors.deaths[iTeam] = iDeaths
end

function Tormentors:IncrementDeaths(iTeam)
	Tormentors.deaths[iTeam] = Tormentors.deaths[iTeam] + 1
end
