function Mutation:RevealAllMap(duration)
	GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)

	if duration then
		Timers:CreateTimer(duration, function()
			GameRules:GetGameModeEntity():SetFogOfWarDisabled(false)
		end)
	end
end

function Mutation:SpawnRandomItem()
	local selectedItem

	if GameRules:GetDOTATime(false, false) > IMBA_MUTATION_AIRDROP_ITEM_TIER_3_MINUTES * 60 then
		selectedItem = Mutation.tier4[RandomInt(1, #Mutation.tier4)].k
	elseif GameRules:GetDOTATime(false, false) > IMBA_MUTATION_AIRDROP_ITEM_TIER_2_MINUTES * 60 then
		selectedItem = Mutation.tier3[RandomInt(1, #Mutation.tier3)].k
	elseif GameRules:GetDOTATime(false, false) > IMBA_MUTATION_AIRDROP_ITEM_TIER_1_MINUTES * 60 then
		selectedItem = Mutation.tier2[RandomInt(1, #Mutation.tier2)].k
	else
		selectedItem = Mutation.tier1[RandomInt(1, #Mutation.tier1)].k
	end

	--	print("Selected item:", selectedItem)

	local pos = RandomVector(IMBA_MUTATION_AIRDROP_MAP_SIZE)
	AddFOWViewer(2, pos, IMBA_MUTATION_AIRDROP_ITEM_SPAWN_RADIUS, IMBA_MUTATION_AIRDROP_ITEM_SPAWN_DELAY + IMBA_MUTATION_AIRDROP_ITEM_VISION_LINGER, false)
	AddFOWViewer(3, pos, IMBA_MUTATION_AIRDROP_ITEM_SPAWN_RADIUS, IMBA_MUTATION_AIRDROP_ITEM_SPAWN_DELAY + IMBA_MUTATION_AIRDROP_ITEM_VISION_LINGER, false)
	GridNav:DestroyTreesAroundPoint(pos, IMBA_MUTATION_AIRDROP_ITEM_SPAWN_RADIUS, false)

	local particle_dummy = CreateUnitByName("npc_dummy_unit", pos, true, nil, nil, 6)
	local particle_arena_fx = ParticleManager:CreateParticle("particles/hero/centaur/centaur_hoof_stomp_arena.vpcf", PATTACH_ABSORIGIN_FOLLOW, particle_dummy)
	ParticleManager:SetParticleControl(particle_arena_fx, 0, pos)
	ParticleManager:SetParticleControl(particle_arena_fx, 1, Vector(IMBA_MUTATION_AIRDROP_ITEM_SPAWN_RADIUS + 45, 1, 1))

	local particle = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_timer.vpcf", PATTACH_ABSORIGIN_FOLLOW, particle_dummy)
	ParticleManager:SetParticleControl(particle, 1, Vector(IMBA_MUTATION_AIRDROP_ITEM_SPAWN_DELAY, 0, 0))
	ParticleManager:SetParticleControl(particle, 3, pos)
	ParticleManager:ReleaseParticleIndex(particle)

	Timers:CreateTimer(IMBA_MUTATION_AIRDROP_ITEM_SPAWN_DELAY, function()
		local item = CreateItem(selectedItem, nil, nil)
		item.airdrop = true
		-- print("Item Name:", selectedItem, pos)

		local drop = CreateItemOnPositionSync(pos, item)

		CustomGameEventManager:Send_ServerToAllClients("item_has_spawned", { spawn_location = pos })
		EmitGlobalSound("powerup_05")

		ParticleManager:DestroyParticle(particle_arena_fx, false)
		ParticleManager:ReleaseParticleIndex(particle_arena_fx)

		particle_dummy:ForceKill(false)
	end)

	CustomGameEventManager:Send_ServerToAllClients("item_will_spawn", { spawn_location = pos })
	EmitGlobalSound("powerup_03")
end

function Mutation:UpdatePanorama()
	if IMBA_MUTATION["positive"] == "killstreak_power" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["positive"], { _G.IMBA_MUTATION_KILLSTREAK_POWER, "%" })
	elseif IMBA_MUTATION["positive"] == "slark_mode" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["positive"], { _G.IMBA_MUTATION_SLARK_MODE_HEALTH_REGEN, _G.IMBA_MUTATION_SLARK_MODE_MANA_REGEN })
	elseif IMBA_MUTATION["positive"] == "ultimate_level" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["positive"], { IMBA_MUTATION_ULTIMATE_LEVEL })
	end

	if IMBA_MUTATION["negative"] == "death_explosion" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["negative"], { _G.IMBA_MUTATION_DEATH_EXPLOSION_DAMAGE })
	elseif IMBA_MUTATION["negative"] == "defense_of_the_ants" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["negative"], { _G.IMBA_MUTATION_DEFENSE_OF_THE_ANTS_SCALE, "%" })
	elseif IMBA_MUTATION["negative"] == "monkey_business" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["negative"], { _G.IMBA_MUTATION_MONKEY_BUSINESS_DELAY, "s" })
	elseif IMBA_MUTATION["negative"] == "all_random_deathmatch" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["negative"], { IMBA_MUTATION_ARDM_RESPAWN_SCORE[2], IMBA_MUTATION_ARDM_RESPAWN_SCORE[3] })
	end

	-- shows undefined on panorama for reasons
	--	if IMBA_MUTATION["terrain"] == "airdrop" then
	--		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["terrain"], {IMBA_MUTATION_AIRDROP_TIMER})
	--	elseif IMBA_MUTATION["terrain"] == "danger_zone" then
	--		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["terrain"], {IMBA_MUTATION_DANGER_ZONE_TIMER})
	--	elseif IMBA_MUTATION["terrain"] == "fast_runes" then
	if IMBA_MUTATION["terrain"] == "fast_runes" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["terrain"], { RUNE_SPAWN_TIME, BOUNTY_RUNE_SPAWN_TIME })
	elseif IMBA_MUTATION["terrain"] == "river_flows" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["terrain"], { _G.IMBA_MUTATION_RIVER_FLOWS_MOVESPEED })
	elseif IMBA_MUTATION["terrain"] == "speed_freaks" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["terrain"], { _G.IMBA_MUTATION_SPEED_FREAKS_MOVESPEED_PCT, "%" })
	elseif IMBA_MUTATION["terrain"] == "tug_of_war" then
		CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["terrain"], { IMBA_MUTATION_TUG_OF_WAR_DEATH_COUNT })
	end

	CustomGameEventManager:Send_ServerToAllClients("update_mutations", {})
end

function Mutation:DeathExplosionDamage()
	local damage = _G.IMBA_MUTATION_DEATH_EXPLOSION_DAMAGE
	local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, _G.IMBA_MUTATION_DEATH_EXPLOSION_MAX_MINUTES)

	game_time = game_time * _G.IMBA_MUTATION_DEATH_EXPLOSION_DAMAGE_INCREASE_PER_MIN
	CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["negative"], { damage + game_time })
	CustomGameEventManager:Send_ServerToAllClients("update_mutations", {})
end

function Mutation:MutationTimer()
	if IMBA_MUTATION_TIMER == nil then
		if IMBA_MUTATION["terrain"] == "danger_zone" then
			IMBA_MUTATION_TIMER = IMBA_MUTATION_DANGER_ZONE_TIMER
		elseif IMBA_MUTATION["terrain"] == "airdrop" then
			IMBA_MUTATION_TIMER = IMBA_MUTATION_AIRDROP_TIMER
		end
	end

	IMBA_MUTATION_TIMER = IMBA_MUTATION_TIMER - 1

	if IMBA_MUTATION_TIMER == 10 then
		if IMBA_MUTATION["terrain"] == "airdrop" then
			CustomGameEventManager:Send_ServerToAllClients("timer_alert", { true })
		end
	elseif IMBA_MUTATION_TIMER == 0 then
		if IMBA_MUTATION["terrain"] == "danger_zone" then
			IMBA_MUTATION_TIMER = IMBA_MUTATION_DANGER_ZONE_TIMER - 1
		elseif IMBA_MUTATION["terrain"] == "airdrop" then
			IMBA_MUTATION_TIMER = IMBA_MUTATION_AIRDROP_TIMER - 1
			CustomGameEventManager:Send_ServerToAllClients("timer_alert", { false })
		end
	end

	local t = IMBA_MUTATION_TIMER
	local minutes = math.floor(t / 60)
	local seconds = t - (minutes * 60)
	local m10 = math.floor(minutes / 10)
	local m01 = minutes - (m10 * 10)
	local s10 = math.floor(seconds / 10)
	local s01 = seconds - (s10 * 10)
	local broadcast_gametimer =
	{
		timer_minute_10 = m10,
		timer_minute_01 = m01,
		timer_second_10 = s10,
		timer_second_01 = s01,
	}

	CustomNetTables:SetTableValue("mutation_info", IMBA_MUTATION["terrain"], broadcast_gametimer)
	CustomGameEventManager:Send_ServerToAllClients("update_mutations", {})
end
