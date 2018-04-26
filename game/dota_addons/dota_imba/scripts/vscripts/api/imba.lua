-- Copyright (C) 2018  The Dota IMBA Development Team
-- Api Interface for Dota IMBA

require("api/api")

api.imba = {
	matchmaking = {},
	internals = {},
	data = {},
	ready = false,
	config = {
		event_timer_interval = 2
	},
	events = {
		queue = {}
	}
}

function api.imba.events.initialize()
	log.info("Initializing events system")
	Timers:CreateTimer(api.imba.config.event_timer_interval, function ()
		api.imba.events.cycle()
		return api.imba.config.event_timer_interval
	end)
end

function api.imba.events.cycle()
	log.debug("Flushing event queue")

	-- copy and clear queue
	local queue = api.imba.events.queue
	api.imba.events.queue = {}

	log.debug("Sending " .. tostring(table.getn(queue)) .. " events")

	api.request(api.endpoints.imba.game.events, {
		id = api.imba.data.id,
		events = queue
	}, function (error, data)
		if not error then
			log.debug("Events successfully saved")
		else
			log.warn("Saving events failed")
		end
	end)
end

function api.imba.register(callback)

	log.info("Initializing IMBA Api")

	local cheat_enabled = false
	if CustomNetTables:GetTableValue("game_options", "game_count").value == 0 then
		cheat_enabled = true
	end

	-- register data
	local register_data = {
		match_id = tonumber(tostring(GameRules:GetMatchID())),
		map = GetMapName(),
		dedicated = IsDedicatedServer(),
		players = api.imba.internals.get_all_valid_players(),
		cheat_mode = cheat_enabled
	}

	-- register game
	api.request(api.endpoints.imba.game.register, register_data, function (error, data)
		if error then
			log.error("Critical API error: Cannot register game!")
			if callback ~= nil then
				callback(true)
			end
		else
			api.imba.data = data

			log.debug("Register with server successful, Game ID: #" .. tostring(api.imba.data.id))
			if callback ~= nil then
				callback(false)
			end
			api.imba.ready = true

			-- start events system
			api.imba.events.initialize()
		end
	end)

end

function api.imba.event(code, data, quiet)
	if quiet == nil then
		log.debug("Queueing event #" .. code)
	end

	local real_content = json.null
	if data ~= nil then
		real_content = data
	end

	table.insert(api.imba.events.queue, {
		event = tonumber(code),
		content = real_content,
		time = {
			frames = tonumber(GetFrameCount()),
			server_time = tonumber(Time()),
			dota_time = tonumber(GameRules:GetDOTATime(true, true)),
			game_time = tonumber(GameRules:GetGameTime()),
			server_system_date_time = tostring(GetSystemDate()) .. " " .. tostring(GetSystemTime()),
		}
	})
end

function api.imba.complete(callback)

	if not api.imba.ready then
		log.error("Cannot complete game which is not registered correctly")
		callback(true)
	end

	-- general
	local complete_data = {
		id = api.imba.data.id,
		winner = tonumber(GAME_WINNER_TEAM),
		results = {}
	}

    -- print a stack trace if we dont have a winner
    if complete_data.winner == 0 then
        log.error("Winner is 0")
    end
    
	-- results
	for id = 0, DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetConnectionState(id) ~= 1 then

			local data = {
				player = PlayerResource:GetPlayer(id),
				steamid = tostring(PlayerResource:GetSteamID(id)),
				hero = PlayerResource:GetPickedHero(id),
				hero_name = json.null,
				items = {}
			}

			-- hero entity and items
			if data.hero == nil then
				log.warn("Hero for player " .. data.steamid .. " is nil")
			else
				data.hero_name = tostring(data.hero:GetUnitName())

				-- 6 inventory + 3 backpack + 6 stash = 15 total
				for slot = 0, 14 do
					local item = data.hero:GetItemInSlot(slot)
					if item ~= nil then
						table.insert(data.items, tostring(item:GetAbilityName()))
					end
				end
			end

			-- final result
			table.insert(complete_data.results, {
				steamid = data.steamid,
				hero = data.hero_name,
				aegis_pickups = tonumber(PlayerResource:GetAegisPickups(id)),
				assists = tonumber(PlayerResource:GetAssists(id)),
				claimed_denies = tonumber(PlayerResource:GetClaimedDenies(id)),
				claimed_farm = tonumber(PlayerResource:GetClaimedFarm(id, true)),
				claimed_misses = tonumber(PlayerResource:GetClaimedMisses(id)),
				connection_state = tonumber(PlayerResource:GetConnectionState(id)),
				creep_damage_taken = tonumber(PlayerResource:GetCreepDamageTaken(id)),
				deaths = tonumber(PlayerResource:GetDeaths(id)),
				denies = tonumber(PlayerResource:GetDenies(id)),
				gold = tonumber(PlayerResource:GetGold(id)),
				gold_lost_to_death = tonumber(PlayerResource:GetGoldLostToDeath(id)),
				gold_per_minute = tonumber(PlayerResource:GetGoldPerMin(id)),
				gold_spent_on_buybacks = tonumber(PlayerResource:GetGoldSpentOnBuybacks(id)),
				gold_spent_on_consumables = tonumber(PlayerResource:GetGoldSpentOnConsumables(id)),
				gold_spent_on_items = tonumber(PlayerResource:GetGoldSpentOnItems(id)),
				gold_spent_on_support = tonumber(PlayerResource:GetGoldSpentOnSupport(id)),
				healing = tonumber(PlayerResource:GetHealing(id)),
				hero_damage_taken = tonumber(PlayerResource:GetHeroDamageTaken(id)),
				kills = tonumber(PlayerResource:GetKills(id)),
				last_hit_multikill = tonumber(PlayerResource:GetLastHitMultikill(id)),
				last_hits = tonumber(PlayerResource:GetLastHits(id)),
				last_hit_streak = tonumber(PlayerResource:GetLastHitStreak(id)),
				level = tonumber(PlayerResource:GetLevel(id)),
				misses = tonumber(PlayerResource:GetMisses(id)),
				nearby_creep_deaths = tonumber(PlayerResource:GetNearbyCreepDeaths(id)),
				consumables_purchased = tonumber(PlayerResource:GetNumConsumablesPurchased(id)),
				items_purchased = tonumber(PlayerResource:GetNumItemsPurchased(id)),
				player_name = tostring(PlayerResource:GetPlayerName(id)),
				raw_player_damage = tonumber(PlayerResource:GetRawPlayerDamage(id)),
				reliable_gold = tonumber(PlayerResource:GetReliableGold(id)),
				roshan_kills = tonumber(PlayerResource:GetRoshanKills(id)),
				rune_pickups = tonumber(PlayerResource:GetRunePickups(id)),
				streak = tonumber(PlayerResource:GetStreak(id)),
				stuns = tonumber(PlayerResource:GetStuns(id)),
				total_earned_gold = tonumber(PlayerResource:GetTotalEarnedGold(id)),
				total_earned_xp = tonumber(PlayerResource:GetTotalEarnedXP(id)),
				total_gold_spent = tonumber(PlayerResource:GetTotalGoldSpent(id)),
				tower_damage_taken = tonumber(PlayerResource:GetTowerDamageTaken(id)),
				tower_kills = tonumber(PlayerResource:GetTowerKills(id)),
				unreliable_gold = tonumber(PlayerResource:GetUnreliableGold(id)),
				xp_per_minute = tonumber(PlayerResource:GetXPPerMin(id)),
				team = tonumber(PlayerResource:GetTeam(id)),
				valid_player = PlayerResource:IsValidPlayer(id),
				has_randomed = PlayerResource:HasRandomed(id),
				has_repicked = false, -- PlayerResource:HasRepicked(id),
				valid_team_player = PlayerResource:IsValidTeamPlayer(id),
				id = id,
				items = data.items
			})
		end
	end


	-- complete game
	log.info("Completing game " .. tostring(api.imba.data.id))
	api.request(api.endpoints.imba.game.complete, complete_data, function (error, data)
		if error then
			log.error("Game cannot be completed!")
			callback(true)
		else
			log.info("Game successfully completed")
			callback(false, data.players)
		end
	end)
end

function api.imba.load_logging_configuration(callback) 
	api.request(api.endpoints.imba.meta.logging_configuration, nil, function (error, data) 
		-- only update logging configuraiton when the request was successful
		if not error then
			callback(data)
		end
	end)
end

function api.imba.internals.get_all_valid_players()
	local players = {}
	for id = 0, DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(id) then
			table.insert(players, tostring(PlayerResource:GetSteamID(id)))
		end
	end
	return players
end

function api.imba.get_donators()
	return api.imba.data.donators
end

function api.imba.is_donator(steamid)
	if api.imba.data.donators == nil then
		log.warn("is_donator called but donators are not available. yet?")
		return false
	end

	for i = 1, #api.imba.data.donators do
		if tostring(steamid) == api.imba.data.donators[i] then
			local player = api.imba.get_player_info(steamid)
			local status
			local xp_mult
			if player then
				print("Donator Status:", player.donator_status)
				print("Donator XP Boosters:", player.xp_multiplier)
				status =  player.donator_status
				xp_mult = player.xp_multiplier
			end

			return status
		end
	end
end

function api.imba.get_developers()
	if api.imba.data.developers == nil then
		log.warn("is_developer called but developers are not available. yet?")
		return false
	end

	return api.imba.data.developers
end

function api.imba.is_developer(steamid)
	if api.imba.data.developers == nil then
		log.warn("is_developer called but developers are not available. yet?")
		return false
	end

	for i = 1, #api.imba.data.developers do
		if tostring(steamid) == api.imba.data.developers[i] then
			return true
		end
	end
end

function api.imba.get_player_info(steamid)
	if api.imba.data.players == nil then
		log.warn("get_player_info called but players are not available. yet?")
		return nil
	end

	for i = 1, #api.imba.data.players do
		if tostring(steamid) == api.imba.data.players[i].steamid then
			return api.imba.data.players[i]
		end
	end

	return nil
end

function api.imba.hero_is_disabled(entity)
	if api.imba.data.disabled_heroes == nil then
		log.warn("hero_is_disabled called but disabled_heroes are not available. yet?")
		return false
	end

	for i = 1, #api.imba.data.disabled_heroes do
		if tostring(entity) == api.imba.data.disabled_heroes[i] then
			return true
		end
	end

	return false
end

function api.imba.get_rankings_xp()
	if api.imba.data.rankings == nil then
		log.warn("get_rankings_xp called but rankings are not available. yet?")
		return nil
	end

	return api.imba.data.rankings.xp
end

function api.imba.get_rankings_imr5v5()
	if api.imba.data.rankings == nil then
		log.warn("get_rankings_imr5v5 called but rankings are not available. yet?")
		return nil
	end

	return api.imba.data.rankings.imr5v5
end

function api.imba.get_rankings_imr10v10()
	if api.imba.data.rankings == nil then
		log.warn("get_rankings_imr10v10 called but rankings are not available. yet?")
		return nil
	end

	return api.imba.data.rankings.imr10v10
end

function api.imba.get_rankings_level1v1()
	if api.imba.data.rankings == nil then
		log.warn("get_rankings_level1v1 called but rankings are not available. yet?")
		return nil
	end

	return api.imba.data.rankings.level1v1
end

function api.imba.get_companions()
	if api.imba.data.companions == nil then
		log.warn("get_companions called but companions are not available. yet?")
	end

	return api.imba.data.companions
end

api.imba.matchmaking = {}

function api.imba.matchmaking.imr_5v5_random(players, callback)

	local data = {
		players = players
	}

	log.info("Sending Matchmaking Request for 5v5 Random")
	api.request(api.endpoints.imba.matchmaking.imr_5v5_random, data, function (error, data)
		if error then
			log.error("Matchmaking Request failed")
			callback({
				ok = false,
				data = data
			})
		else
			log.info("Matchmaking Request for 5v5 Random successful")
			callback({
				ok = true,
				data = data
			})
		end
	end)
end

function api.imba.matchmaking.imr_10v10_teams(players, combinations, callback)

	local data = {
		players = players,
		team_combinations = combinations
	}

	api.request(api.endpoints.imba.matchmaking.imr_10v10_teams, data, function (error, data)
		if error then
			log.error("Matchmaking Request failed")
			callback({
				ok = false,
				data = data
			})
		else
			log.info("Matchmaking Request for 10v10 Teams successful")
			callback({
				ok = true,
				data = data
			})
		end
	end)

end
