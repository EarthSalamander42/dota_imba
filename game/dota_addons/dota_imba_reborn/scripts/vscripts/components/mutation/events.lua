ListenToGameEvent('npc_spawned', function(keys)
	local npc = EntIndexToHScript(keys.entindex)

	if not npc:IsRealHero() then
		if not npc.first_spawn_mutation then
			npc.first_spawn_mutation = true

			if IMBA_MUTATION["terrain"] == "speed_freaks" then
				npc:AddNewModifier(npc, nil, "modifier_mutation_speed_freaks", {projectile_speed = IMBA_MUTATION_SPEED_FREAKS_PROJECTILE_SPEED, movespeed_pct = IMBA_MUTATION_SPEED_FREAKS_MOVESPEED_PCT, max_movespeed = IMBA_MUTATION_SPEED_FREAKS_MAX_MOVESPEED})
			end
		end

		return
	end

	local hero = npc

	if hero:GetUnitName() == FORCE_PICKED_HERO then return end

	if hero.first_spawn_mutation == true then
--		print("Mutation: On Hero Respawned")

		if IMBA_MUTATION["positive"] == "teammate_resurrection" then
			if hero.tombstone_fx then
				ParticleManager:DestroyParticle(hero.tombstone_fx, false)
				ParticleManager:ReleaseParticleIndex(hero.tombstone_fx)
				hero.tombstone_fx = nil
			end

			Timers:CreateTimer(FrameTime(), function()
				if IsNearFountain(hero:GetAbsOrigin(), 1200) == false and hero.reincarnation == false and not hero:IsTempestDouble() then
					hero:SetHealth(hero:GetHealth() * 50 / 100)
					hero:SetMana(hero:GetMana() * 50 / 100)
				end

				hero:CenterCameraOnEntity(hero)
				hero.reincarnation = false
			end)
		end

		if IMBA_MUTATION["negative"] == "all_random_deathmatch" then
			if not hero:IsImbaReincarnating() then
				Mutation:ARDMReplacehero(hero)
				return
			else
--				print("hero is reincarnating, don't change hero!")
				return
			end
		end
	else
--		print("Mutation: On Hero First Spawn")
		hero.first_spawn_mutation = true

		hero:AddNewModifier(hero, nil, "modifier_frantic", {}):SetStackCount(IMBA_FRANTIC_VALUE)

		if IMBA_MUTATION["positive"] == "killstreak_power" then
			hero:AddNewModifier(hero, nil, "modifier_mutation_kill_streak_power", {})
		elseif IMBA_MUTATION["positive"] == "super_blink" then
			if not hero:IsIllusion() and not hero:IsClone() then
				hero:AddItemByName("item_imba_blink"):SetSellable(false)
			end
		elseif IMBA_MUTATION["positive"] == "pocket_roshan" then
			if not hero:IsIllusion() and not hero:IsClone() then
				hero:AddItemByName("item_pocket_roshan")
			end
		elseif IMBA_MUTATION["positive"] == "pocket_tower" then
			if not hero:IsIllusion() and not hero:IsClone() then
				hero:AddItemByName("item_pocket_tower")
			end
		elseif IMBA_MUTATION["positive"] == "greed_is_good" then
			hero:AddNewModifier(hero, nil, "modifier_mutation_greed_is_good", {})
		elseif IMBA_MUTATION["positive"] == "teammate_resurrection" then
			hero.reincarnation = false
		elseif IMBA_MUTATION["positive"] == "super_fervor" then
			hero:AddNewModifier(hero, nil, "modifier_mutation_super_fervor", {})
		elseif IMBA_MUTATION["positive"] == "slark_mode" then
			hero:AddNewModifier(hero, nil, "modifier_mutation_shadow_dance", {})
		elseif IMBA_MUTATION["positive"] == "damage_reduction" then
			hero:AddNewModifier(hero, nil, "modifier_mutation_damage_reduction", {})
		end

		if IMBA_MUTATION["negative"] == "death_explosion" then
			hero:AddNewModifier(hero, nil, "modifier_mutation_death_explosion", {})
		elseif IMBA_MUTATION["negative"] == "no_health_bar" then
			hero:AddNewModifier(hero, nil, "modifier_no_health_bar", {})
		elseif IMBA_MUTATION["negative"] == "defense_of_the_ants" then
			hero:AddNewModifier(hero, nil, "modifier_mutation_ants", {})
		elseif IMBA_MUTATION["negative"] == "stay_frosty" then
			hero:AddNewModifier(hero, nil, "modifier_mutation_stay_frosty", {})
		elseif IMBA_MUTATION["negative"] == "monkey_business" then
			hero:AddNewModifier(hero, nil, "modifier_mutation_monkey_business", {})
		elseif IMBA_MUTATION["negative"] == "alien_incubation" then
			hero:AddNewModifier(hero, nil, "modifier_mutation_alien_incubation", {})
		end

		if IMBA_MUTATION["terrain"] == "speed_freaks" then
			hero:AddNewModifier(hero, nil, "modifier_mutation_speed_freaks", {projectile_speed = IMBA_MUTATION_SPEED_FREAKS_PROJECTILE_SPEED, movespeed_pct = _G.IMBA_MUTATION_SPEED_FREAKS_MOVESPEED_PCT, max_movespeed = IMBA_MUTATION_SPEED_FREAKS_MAX_MOVESPEED})
		elseif IMBA_MUTATION["terrain"] == "river_flows" then
			hero:AddNewModifier(hero, nil, "modifier_mutation_river_flows", {})
		end
	end
end, nil)

ListenToGameEvent('player_connect_full', function(keys)
	local entIndex = keys.index + 1
	local ply = EntIndexToHScript(entIndex)
	local playerID = ply:GetPlayerID()

	-- Reinitialize the player's pick screen panorama, if necessary
	Timers:CreateTimer(function()
--		print(PlayerResource:GetSelectedHeroEntity(playerID))

		if PlayerResource:GetSelectedHeroEntity(playerID) then
			if IsMutationMap() then
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "send_mutations", IMBA_MUTATION)
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "update_mutations", {})
			end
		else
--			print("Not fully reconnected yet:", playerID)
			return 0.1
		end
	end)
end, nil)

ListenToGameEvent('entity_killed', function(keys)
--	print("Mutation: On Hero Dead")

	-- The Unit that was killed
	local killed_unit = EntIndexToHScript(keys.entindex_killed)
	if not killed_unit then return end

	if not killed_unit:IsRealHero() then
		if IMBA_MUTATION["terrain"] == "tug_of_war" then
			if killed_unit:GetUnitName() == "npc_dota_mutation_golem" then
				IMBA_MUTATION_TUG_OF_WAR_DEATH_COUNT = IMBA_MUTATION_TUG_OF_WAR_DEATH_COUNT + 1
				CustomNetTables:SetTableValue("mutations", IMBA_MUTATION["terrain"], {IMBA_MUTATION_TUG_OF_WAR_DEATH_COUNT})
				CustomGameEventManager:Send_ServerToAllClients("update_mutations", {})
			end
		end

		return
	end

	local hero = killed_unit

	-- The Killing entity
	local killer = nil

	if keys.entindex_attacker then
		killer = EntIndexToHScript(keys.entindex_attacker)
	end

	if IMBA_MUTATION["positive"] == "teammate_resurrection" then
		local newItem = CreateItem("item_tombstone", hero, hero)
		newItem:SetPurchaseTime(0)
		newItem:SetPurchaser(hero)

		local tombstone = SpawnEntityFromTableSynchronous("dota_item_tombstone_drop", {})
		tombstone:SetContainedItem(newItem)
		tombstone:SetAngles(0, RandomFloat(0, 360), 0)
		--FindClearSpaceForUnit(tombstone, hero:GetAbsOrigin(), true)

		hero.tombstone_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/holdout_borrowed_time_"..hero:GetTeamNumber()..".vpcf", PATTACH_ABSORIGIN_FOLLOW, tombstone)

		if hero:IsImbaReincarnating() then
--			print("Hero is reincarnating!")
			hero.reincarnation = true
		end
	end

	if IMBA_MUTATION["negative"] == "all_random_deathmatch" then
		if hero:IsImbaReincarnating() then print("hero is reincarnating, don't count down respawn count!") return end
		IMBA_MUTATION_ARDM_RESPAWN_SCORE[hero:GetTeamNumber()] = IMBA_MUTATION_ARDM_RESPAWN_SCORE[hero:GetTeamNumber()] - 1

		if IMBA_MUTATION_ARDM_RESPAWN_SCORE[hero:GetTeamNumber()] < 0 then
			IMBA_MUTATION_ARDM_RESPAWN_SCORE[hero:GetTeamNumber()] = 0
		end

		if IMBA_MUTATION_ARDM_RESPAWN_SCORE[hero:GetTeamNumber()] == 0 then
--			print("hero respawn disabled!")
			hero:SetRespawnsDisabled(true)
			hero:SetTimeUntilRespawn(-1)

			local end_game = true
			Timers:CreateTimer(1.0, function()
				for _, alive_hero in pairs(HeroList:GetAllHeroes()) do
					if hero:GetTeamNumber() == alive_hero:GetTeamNumber() then
						if alive_hero:IsAlive() then
--							print("A hero is still alive!")
							end_game = false
							break
						end
					end
				end

				-- if everyone is dead, end the game
				if end_game == true then
					if hero:GetTeamNumber() == 2 then
						GAME_WINNER_TEAM = 3
						GameRules:SetGameWinner(3)
					elseif hero:GetTeamNumber() == 3 then
						GAME_WINNER_TEAM = 2
						GameRules:SetGameWinner(2)
					end
				end
			end)
		end

		CustomNetTables:SetTableValue("mutations", IMBA_MUTATION["negative"], {IMBA_MUTATION_ARDM_RESPAWN_SCORE[2], IMBA_MUTATION_ARDM_RESPAWN_SCORE[3]})
		CustomGameEventManager:Send_ServerToAllClients("update_mutations", {})
	end

--	if IMBA_MUTATION["negative"] == "death_gold_drop" then
--		local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, 30)
--		local random_int = RandomInt(30, 60)
--		local newItem = CreateItem("item_bag_of_gold", nil, nil)
--		newItem:SetPurchaseTime(0)
--		newItem:SetCurrentCharges(random_int * game_time)

--		local drop = CreateItemOnPositionSync(hero:GetAbsOrigin(), newItem)
--		local dropTarget = hero:GetAbsOrigin() + RandomVector(RandomFloat( 50, 150 ))
--		newItem:LaunchLoot(true, 300, 0.75, dropTarget)
--		EmitSoundOn("Dungeon.TreasureItemDrop", hero)
--	end
end, nil)
