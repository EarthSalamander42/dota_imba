function GameMode:OnDisconnect(keys)
	-- GetConnectionState values:
	-- 0 - no connection
	-- 1 - bot connected
	-- 2 - player connected
	-- 3 - bot/player disconnected.

	-- Typical keys:
	-- PlayerID: 2
	-- name: Zimberzimber
	-- networkid: [U:1:95496383]
	-- reason: 2
	-- splitscreenplayer: -1
	-- userid: 7
	-- xuid: 76561198055762111

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player disconnect/abandon logic
	-------------------------------------------------------------------------------------------------

	-- If the game hasn't started, or has already ended, do nothing
	if (GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME) or (GameRules:State_Get() < DOTA_GAMERULES_STATE_PRE_GAME) then
		return nil
			-- Else, start tracking player's reconnect/abandon state
	else
		-- Fetch player's player and hero information
		local player_id = keys.PlayerID
		local player_name = keys.name
		local hero = PlayerResource:GetPickedHero(player_id)
		local hero_name = PlayerResource:GetPickedHeroName(player_id)
		local line_duration = 7

		-- Start tracking
		print("started keeping track of player "..player_id.."'s connection state")
		ApiEvent(ApiEventCodes.PlayerDisconnected, { tostring(PlayerResource:GetSteamID(player_id)) })

		local disconnect_time = 0
		Timers:CreateTimer(1, function()
			-- Keep track of time disconnected
			disconnect_time = disconnect_time + 1

			-- If the player has abandoned the game, set his gold to zero and distribute passive gold towards its allies
			if disconnect_time >= ABANDON_TIME then
				-- Abandon message
				Notifications:BottomToAll({hero = hero_name, duration = line_duration})
				Notifications:BottomToAll({text = player_name.." ", duration = line_duration, continue = true})
				Notifications:BottomToAll({text = "#imba_player_abandon_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})
				PlayerResource:SetHasAbandonedDueToLongDisconnect(player_id, true)
				print("player "..player_id.." has abandoned the game.")

				ApiEvent(ApiEventCodes.PlayerAbandoned, { tostring(PlayerResource:GetSteamID(player_id)) })

				-- Start redistributing this player's gold to its allies
				PlayerResource:StartAbandonGoldRedistribution(player_id)
				-- If the player has reconnected, stop tracking connection state every second
			elseif PlayerResource:GetConnectionState(player_id) == 2 then

			-- Else, keep tracking connection state
			else
				print("tracking player "..player_id.."'s connection state, disconnected for "..disconnect_time.." seconds.")
				return 1
			end
		end)
	end
end

function GameMode:OnGameRulesStateChange(keys)
	-- This internal handling is used to set up main barebones functions
	GameMode:_OnGameRulesStateChange(keys)

	local new_state = GameRules:State_Get()
	CustomNetTables:SetTableValue("game_options", "game_state", {state = new_state})

	-------------------------------------------------------------------------------------------------
	-- IMBA: Pick screen stuff
	-------------------------------------------------------------------------------------------------
	if new_state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		ApiEvent(ApiEventCodes.EnteredHeroSelection)
		HeroSelection:HeroListPreLoad()

		-- get the IXP of everyone (ignore bot)
		GetPlayerInfoIXP()
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Start-of-pre-game stuff
	-------------------------------------------------------------------------------------------------
	if new_state == DOTA_GAMERULES_STATE_PRE_GAME then
		ApiEvent(ApiEventCodes.EnteredPreGame)

		-- Initialize Battle Pass
		Imbattlepass:Init()

		-- Shows various info to devs in pub-game to find lag issues
		ImbaNetGraph(10.0)

		-- Initialize rune spawners
		InitRunes()

		local donators_steamid = {}
		local donators = GetDonators()
		if #donators then
			for i = 1, #donators do
				table.insert(donators_steamid, donators[i].steamId64)
			end
		end

		CustomNetTables:SetTableValue("game_options", "donators", {donators = donators_steamid})

		-------------------------------------------------------------------------------------------------
		-- IMBA: Custom maximum level EXP tables adjustment
		-------------------------------------------------------------------------------------------------
		local max_level = tonumber(CustomNetTables:GetTableValue("game_options", "max_level")["1"])
		if max_level and max_level > 25 then
			for i = 26, max_level do
				XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i-1] + 3500
				GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
			end
		end

		Timers:CreateTimer(2.0, function()
			for _, hero in pairs(HeroList:GetAllHeroes()) do
				if IsDeveloper(hero:GetPlayerID()) then
					hero.has_graph = true
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "show_netgraph", {})
--					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "show_netgraph_heronames", {})
				end

				local donators = GetDonators()
				for k, v in pairs(donators) do
					CustomNetTables:SetTableValue("player_table", tostring(hero:GetPlayerID()), {
						companion_model = donators[k].model,
						companion_enabled = donators[k].enabled,
						Lvl = CustomNetTables:GetTableValue("player_table", tostring(hero:GetPlayerID())).Lvl,
					})
				end
			end

			if GetMapName() == "imba_overthrow" then
				CustomGameEventManager:Send_ServerToAllClients("imbathrow_topbar", {imbathrow = true})
			else
				CustomGameEventManager:Send_ServerToAllClients("imbathrow_topbar", {imbathrow = false})
			end
		end)
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Game started (horn sounded)
	-------------------------------------------------------------------------------------------------
	if new_state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		ApiEvent(ApiEventCodes.StartedGame)

		Timers:CreateTimer(60, function()
			StartGarbageCollector()
			--			DefineLosingTeam()
			return 60
		end)

		if GetMapName() ~= "imba_standard" then
			if RandomInt(1, 100) > 25 then
				Timers:CreateTimer(RandomInt(5, 10) * 60, function()
					local pos = {}
					pos[1] = Vector(6446, -6979, 1496)
					pos[2] = Vector(RandomInt(-6000, 0), RandomInt(7150, 7300), 1423)
					pos[3] = Vector(RandomInt(-1000, 2000), RandomInt(6900, 7200), 1440)
					pos[4] = Vector(7041, -6263, 1461)
					local pos = pos[4]

					GridNav:DestroyTreesAroundPoint(pos, 80, false)
					local item = CreateItem("item_the_caustic_finale", nil, nil)
					local drop = CreateItemOnPositionSync(pos, item)
				end)
			end
		end

		if GetMapName() == "imba_overthrow" then
			countdownEnabled = true
			CustomGameEventManager:Send_ServerToAllClients( "show_timer", {} )
			DoEntFire( "center_experience_ring_particles", "Start", "0", 0, self, self  )
			Timers:CreateTimer(function()
				CountdownTimer()
				self:ThinkGoldDrop() -- TODO: Enable this
				self:ThinkSpecialItemDrop()
				if nCOUNTDOWNTIMER == 30 then
					CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
				end
				if nCOUNTDOWNTIMER <= 0 then
					--Check to see if there's a tie
					if isGameTied == false then
						GameRules:SetCustomVictoryMessage( m_VictoryMessages[leadingTeam] )
						GameMode:EndGame( leadingTeam )
						countdownEnabled = false
						return nil
					else
						TEAM_KILLS_TO_WIN = leadingTeamScore + 1
						local broadcast_killcount =
							{
								killcount = TEAM_KILLS_TO_WIN
							}
						CustomGameEventManager:Send_ServerToAllClients( "overtime_alert", broadcast_killcount )
					end
				end
				return 1.0
			end)
		end
	end

	if new_state == DOTA_GAMERULES_STATE_POST_GAME then
		-- call imba api
		ApiEvent(ApiEventCodes.EnteredPostGame)

		ImbaApiFrontendGameComplete(function (players)
			ApiPrint("Game complete request successful!")

			-- calculate levels
			local xpInfo = {}

			for k, v in pairs(players) do

				local level = GetXPLevelByXp(v.xp)
				local title = GetTitleIXP(level)
				local color = GetTitleColorIXP(title, true)
				local progress = GetXpProgressToNextLevel(v.xp)

				if level and title and color and progress then
					xpInfo[k] = {
						level = level,
						title = title,
						color = color,
						progress = progress
					}
				end
			end

			CustomGameEventManager:Send_ServerToAllClients("end_game", {
				players = players,
				xp_info = xpInfo,
				info = {
					winner = GAME_WINNER_TEAM,
					gameid = GetApiGameId()
				}
			})

			ApiPrint("Done sending Event")
		end)

		CustomNetTables:SetTableValue("game_options", "game_count", {value = 0})
	end
end

dummy_created_count = 0

function GameMode:OnNPCSpawned(keys)
	GameMode:_OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)
	local normal_xp = npc:GetDeathXP()
	local greeviling = false

	if npc then
		------------------------------
		-- UnitSpawned Api Event
		------------------------------

		local player = "-1"
		if npc:IsRealHero() and npc:GetPlayerID() then
			player = PlayerResource:GetSteamID(npc:GetPlayerID())
		end

		ApiEvent(ApiEventCodes.UnitSpawned, {
			tostring(npc:GetUnitName()),
			tostring(player)
		})

--		npc:AddNewModifier(npc, nil, "modifier_river", {})

		if greeviling == true and RandomInt(1, 100) > 85 then
			if string.find(npc:GetUnitName(), "dota_creep") then
				local material_group = tostring(RandomInt(0, 8))
				npc.is_greevil = true
				if string.find(npc:GetUnitName(), "ranged") then
					npc:SetModel("models/courier/greevil/greevil_flying.vmdl")
					npc:SetOriginalModel("models/courier/greevil/greevil_flying.vmdl")
				else
					npc:SetModel("models/courier/greevil/greevil.vmdl")
					npc:SetOriginalModel("models/courier/greevil/greevil.vmdl")
				end
				npc:SetMaterialGroup(material_group)
				npc.eyes = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_eyes.vmdl"})
				npc.ears = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_ears"..RandomInt(1, 2)..".vmdl"})
				if RandomInt(1, 100) > 80 then
					npc.feathers = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_feathers.vmdl"})
					npc.feathers:FollowEntity(npc, true)
				end
				npc.hair = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_hair"..RandomInt(1, 2)..".vmdl"})
				npc.horns = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_horns"..RandomInt(1, 4)..".vmdl"})
				npc.nose = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_nose"..RandomInt(1, 3)..".vmdl"})
				npc.tail = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_tail"..RandomInt(1, 4)..".vmdl"})
				npc.teeth = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_teeth"..RandomInt(1, 4)..".vmdl"})
				npc.wings = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/courier/greevil/greevil_wings"..RandomInt(1, 4)..".vmdl"})

				-- lock to bone
				npc.eyes:SetMaterialGroup(material_group)
				npc.eyes:FollowEntity(npc, true)
				npc.ears:SetMaterialGroup(material_group)
				npc.ears:FollowEntity(npc, true)
				npc.hair:FollowEntity(npc, true)
				npc.horns:SetMaterialGroup(material_group)
				npc.horns:FollowEntity(npc, true)
				npc.nose:SetMaterialGroup(material_group)
				npc.nose:FollowEntity(npc, true)
				npc.tail:SetMaterialGroup(material_group)
				npc.tail:FollowEntity(npc, true)
				npc.teeth:SetMaterialGroup(material_group)
				npc.teeth:FollowEntity(npc, true)
				npc.wings:SetMaterialGroup(material_group)
				npc.wings:FollowEntity(npc, true)
			elseif string.find(npc:GetUnitName(), "_siege") then
				npc:SetModel("models/creeps/mega_greevil/mega_greevil.vmdl")
				npc:SetOriginalModel("models/creeps/mega_greevil/mega_greevil.vmdl")
				npc:SetModelScale(2.75)
			end
		end

		-- Valve Illusion bug to prevent respawning
		if npc:IsIllusion() and not npc:HasModifier("modifier_illusion_manager_out_of_world") and not npc:HasModifier("modifier_illusion_manager") then
			if npc.illusion == true then
				UTIL_Remove(npc)
			end
			npc.illusion = true
			return
		elseif npc:IsTempestDouble() then
			UTIL_Remove(npc)
			return
		end

		-- monkey king fix, do not spawn the 14 monkeys
		if npc:GetUnitName() == "npc_dota_hero_monkey_king" then
			if TRUE_MK_HAS_SPAWNED then
				return nil
			else
				TRUE_MK_HAS_SPAWNED = true
			end
		end

		if npc:IsCourier() then
			if not npc:HasModifier("modifier_courier_hack") then
				npc:AddNewModifier(courier, nil, "modifier_courier_hack", {})
			end

			if npc.first_spawn == true then
				CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", {
					type = "generic",
					text = "#custom_toast_CourierRespawned",
					teamColor = npc:GetTeam(),
					team = npc:GetTeam(),
					courier = true,
				})
			end
			npc.first_spawn = true
		end
	end

	if npc:GetUnitName() == "npc_dummy_unit" or npc:GetUnitName() == "npc_dummy_unit_perma" then
		dummy_created_count = dummy_created_count +1
	end

	if npc:IsRealHero() then
		if not npc.first_spawn then
			if npc:GetUnitName() == "npc_dota_hero_troll_warlord" then
				npc:SwapAbilities("imba_troll_warlord_whirling_axes_ranged", "imba_troll_warlord_whirling_axes_melee", true, false)
				npc:SwapAbilities("imba_troll_warlord_whirling_axes_ranged", "imba_troll_warlord_whirling_axes_melee", false, true)
				npc:SwapAbilities("imba_troll_warlord_whirling_axes_ranged", "imba_troll_warlord_whirling_axes_melee", true, false)
			end

			if IsDonator(npc) ~= false then
				if HeroSelection.playerPickState[npc:GetPlayerID()] and HeroSelection.playerPickState[npc:GetPlayerID()].pick_state ~= "selecting_hero" then
					if npc:GetUnitName() ~= "npc_dota_hero_wisp" or npc.is_real_wisp then
						Timers:CreateTimer(2.0, function()
							if tostring(PlayerResource:GetSteamID(npc:GetPlayerID())) == "76561198015161808" then
								DonatorCompanion(npc:GetPlayerID(), "npc_imba_donator_companion_cookies")
							elseif tostring(PlayerResource:GetSteamID(npc:GetPlayerID())) == "76561198003571172" then
								DonatorCompanion(npc:GetPlayerID(), "npc_imba_donator_companion_baumi")
							elseif tostring(PlayerResource:GetSteamID(npc:GetPlayerID())) == "76561198014254115" then
								DonatorCompanion(npc:GetPlayerID(), "npc_imba_donator_companion_icefrog")
							elseif tostring(PlayerResource:GetSteamID(npc:GetPlayerID())) == "76561198014254115" then
								DonatorCompanion(npc:GetPlayerID(), "npc_imba_donator_companion_admiral_bulldog")
							elseif tostring(PlayerResource:GetSteamID(npc:GetPlayerID())) == "76561198021465788" then
								DonatorCompanion(npc:GetPlayerID(), "npc_imba_donator_companion_suthernfriend")
							else
								DonatorCompanion(npc:GetPlayerID(), IsDonator(npc))
							end
						end)
					end
				end
			end

			local deathEffects = npc:Attribute_GetIntValue( "effectsID", -1 )
			if deathEffects ~= -1 then
				ParticleManager:DestroyParticle( deathEffects, true )
				npc:DeleteAttribute( "effectsID" )
			end

			if npc:GetUnitName() == "npc_dota_hero_storegga" then
				npc:SetModel("models/creeps/ice_biome/storegga/storegga.vmdl")
				npc:SetOriginalModel("models/creeps/ice_biome/storegga/storegga.vmdl")
			end

			if HeroSelection.playerPickState[npc:GetPlayerID()] and HeroSelection.playerPickState[npc:GetPlayerID()].pick_state == "selecting_hero" then
				RestrictAndHideHero(npc)
			end

			npc.first_spawn = true
		end

		-- fix for killed with Ghost Revenant immolation
		if npc:HasModifier("modifier_ghost_revenant_ghost_immolation_debuff") then
			npc:RemoveModifierByName("modifier_ghost_revenant_ghost_immolation_debuff")
			Timers:CreateTimer(0.2, function()
				npc:SetHealth(100000)
			end)
		end

		Timers:CreateTimer(1, function() -- Silencer fix
			if npc:HasModifier("modifier_silencer_int_steal") then
				npc:RemoveModifierByName("modifier_silencer_int_steal")
			end
		end)
	end

	if npc:GetUnitName() == "npc_dota_hero_witch_doctor" then
		if npc:IsAlive() and npc:HasTalent("special_bonus_imba_witch_doctor_6") then
			if not npc:HasModifier("modifier_imba_voodoo_restoration") then
				npc:AddNewModifier(npc, npc:GetAbilityByIndex(1), "modifier_imba_voodoo_restoration", {})
			end
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Arc Warden clone handling
	-------------------------------------------------------------------------------------------------
	if npc:FindAbilityByName("arc_warden_tempest_double") and not npc.first_tempest_double_cast and npc:IsRealHero() then
		if HeroSelection.playerPickState[npc:GetPlayerID()].pick_state ~= "selecting_hero" then
			npc.first_tempest_double_cast = true
			local tempest_double_ability = npc:FindAbilityByName("arc_warden_tempest_double")
			tempest_double_ability:SetLevel(4)
			Timers:CreateTimer(0.1, function()
				if not npc:HasModifier("modifier_arc_warden_tempest_double") then
					tempest_double_ability:CastAbility()
					tempest_double_ability:SetLevel(1)
				end
			end)
		end
	end

	if npc:HasModifier("modifier_arc_warden_tempest_double") then

		-- List of modifiers which carry over from the main hero to the clone
		local clone_shared_buffs = {
			"modifier_imba_moon_shard_stacks_dummy",
			"modifier_imba_moon_shard_consume_1",
			"modifier_imba_moon_shard_consume_2",
			"modifier_imba_moon_shard_consume_3",
			"modifier_item_imba_soul_of_truth"
		}

		-- Iterate through the main hero's potential modifiers
		local main_hero = npc:GetOwner():GetAssignedHero()
		for _, shared_buff in pairs(clone_shared_buffs) do

			-- If the main hero has this modifier, copy it to the clone
			if main_hero:HasModifier(shared_buff) then
				local shared_buff_modifier = main_hero:FindModifierByName(shared_buff)
				local shared_buff_ability = shared_buff_modifier:GetAbility()

				-- If a source ability was found, use it
				if shared_buff_ability then
					shared_buff_ability:ApplyDataDrivenModifier(main_hero, npc, shared_buff, {})

					-- Else, it's a consumable item modifier. Create a dummy item to use the ability from.
				else
					-- Moon Shard
					if string.find(shared_buff, "moon_shard") then

						-- Create dummy item
						local dummy_item = CreateItem("item_imba_moon_shard", npc, npc)
						main_hero:AddItem(dummy_item)

						-- Fetch dummy item's ability handle
						for i = 0, 11 do
							local current_item = main_hero:GetItemInSlot(i)
							if current_item and current_item:GetName() == "item_imba_moon_shard" then
								current_item:ApplyDataDrivenModifier(main_hero, npc, shared_buff, {})
								break
							end
						end
						main_hero:RemoveItem(dummy_item)
					end

					-- Soul of Truth
					if shared_buff == "modifier_item_imba_soul_of_truth" then

						-- Create dummy item
						local dummy_item = CreateItem("item_imba_soul_of_truth", npc, npc)
						main_hero:AddItem(dummy_item)

						-- Fetch dummy item's ability handle
						for i = 0, 11 do
							local current_item = main_hero:GetItemInSlot(i)
							if current_item and current_item:GetName() == "item_imba_soul_of_truth" then
								current_item:ApplyDataDrivenModifier(main_hero, npc, shared_buff, {})
								break
							end
						end
						main_hero:RemoveItem(dummy_item)
					end
				end

				-- Apply any stacks if relevant
				if main_hero:GetModifierStackCount(shared_buff, nil) > 0 then
					npc:SetModifierStackCount(shared_buff, main_hero, main_hero:GetModifierStackCount(shared_buff, nil))
				end
			end
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Buyback penalty removal
	-------------------------------------------------------------------------------------------------
	Timers:CreateTimer(0.1, function()
		if (not npc:IsNull()) and npc:HasModifier("modifier_buyback_gold_penalty") then
			npc:RemoveModifierByName("modifier_buyback_gold_penalty")
		end
	end)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Negative Vengeance Aura removal
	-------------------------------------------------------------------------------------------------
	if npc.vengeance_aura_target then
		npc.vengeance_aura_target:RemoveModifierByName("modifier_imba_command_aura_negative_aura")
		npc.vengeance_aura_target = nil
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Creep stats adjustment
	-------------------------------------------------------------------------------------------------
	if not npc:IsHero() and not npc:IsOwnedByAnyPlayer() and not npc:IsBuilding() and not npc:IsNeutralUnitType() then
		-- Add passive buff to lane creeps
		if string.find(npc:GetUnitName(), "dota_creep") then
			npc:AddNewModifier(npc, nil, "modifier_imba_creep_power", {})
		end
	end
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
--local damagebits = keys.damagebits -- This might always be 0 and therefore useless
--if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
--local entCause = EntIndexToHScript(keys.entindex_attacker)
--local entVictim = EntIndexToHScript(keys.entindex_killed)
--end
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
	local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
	--local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	--local player = PlayerResource:GetPlayer(keys.PlayerID)
	local itemname = keys.itemname

	if heroEntity:IsHero() and itemname == "item_bag_of_gold" then
		-- Pick up the gold
		GoldPickup(keys)
	end
end

-- A player has reconnected to the game. This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)
	PrintTable(keys)
end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
	local plyID = keys.PlayerID
	if not plyID then return end
	local hero = PlayerResource:GetSelectedHeroEntity(plyID)
	local itemName = keys.itemname
	local itemcost = keys.itemcost

	ApiEvent(ApiEventCodes.ItemPurchased, {
		tostring(keys.itemname),
		tostring(hero:GetUnitName()),
		tostring(PlayerResource:GetSteamID(plyID))
	})
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
	local player = keys.PlayerID
	local abilityname = keys.abilityname
	if not abilityname then return end

	local hero = PlayerResource:GetSelectedHeroEntity(player)
	if not hero then return end


	local abilityUsed = hero:FindAbilityByName(abilityname)
	if not abilityUsed then return end

	if abilityname == "rubick_spell_steal" then
		local target = abilityUsed:GetCursorTarget()
		hero.spellStealTarget = target
	end

	local meepo_table = Entities:FindAllByName("npc_dota_hero_meepo")
	if hero:GetUnitName() == "npc_dota_hero_meepo" then
		for m = 1, #meepo_table do
			if meepo_table[m]:IsClone() then
				if abilityname == "item_sphere" then
					local duration = abilityname:GetSpecialValueFor("block_cooldown")
					meepo_table[m]:AddNewModifier(meepo_table[m], ability, "modifier_item_sphere_target", {duration = duration})
				end
			end
		end
	end

	-- API
	ApiEvent(ApiEventCodes.AbilityUsed, {
		tostring(hero:GetUnitName()),
		tostring(abilityname),
		tostring(PlayerResource:GetSteamID(keys.PlayerID))
	})

	-------------------------------------------------------------------------------------------------
	-- IMBA: Remote Mines adjustment
	-------------------------------------------------------------------------------------------------

	-- if abilityname == "techies_remote_mines" then

	-- 	local mine_caster = player:GetAssignedHero()
	-- 	Timers:CreateTimer(0.01, function()
	-- 		local nearby_units = FindUnitsInRadius(mine_caster:GetTeamNumber(), mine_caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- 		for _,unit in pairs(nearby_units) do

	-- 			-- Only operate on remotes which need setup
	-- 			if unit.needs_remote_mine_setup then

	-- 				-- Add extra abilities
	-- 				unit:AddAbility("imba_techies_minefield_teleport")
	-- 				unit:AddAbility("imba_techies_remote_auto_creep")
	-- 				unit:AddAbility("imba_techies_remote_auto_hero")
	-- 				local minefield_teleport = unit:FindAbilityByName("imba_techies_minefield_teleport")
	-- 				local auto_creep = unit:FindAbilityByName("imba_techies_remote_auto_creep")
	-- 				local auto_hero = unit:FindAbilityByName("imba_techies_remote_auto_hero")
	-- 				auto_creep:SetLevel(1)
	-- 				auto_hero:SetLevel(1)

	-- 				-- Enable minefield teleport if the caster has a scepter
	-- 				local scepter = HasScepter(mine_caster)
	-- 				if scepter then
	-- 					minefield_teleport:SetLevel(1)
	-- 				end

	-- 				-- Toggle abilities on according to the current caster setting
	-- 				if mine_caster.auto_hero_exploding then
	-- 					auto_hero:ToggleAbility()
	-- 				elseif mine_caster.auto_creep_exploding then
	-- 					auto_creep:ToggleAbility()
	-- 				end

	-- 				-- Set this mine's setup as done
	-- 				unit.needs_remote_mine_setup = nil
	-- 			end
	-- 		end
	-- 	end)
	-- end

end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
	local abilityname = keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
	local newName = keys.newname
	local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
	local player = EntIndexToHScript(keys.player)
	local hero = player:GetAssignedHero()
	local abilityname = keys.abilityname

	-- If it the ability is Homing Missiles, wait a bit and set count to 1
	if abilityname == "gyrocopter_homing_missile" then
		Timers:CreateTimer(1, function()
			-- Find homing missile modifier
			local modifier_charges = player:GetAssignedHero():FindModifierByName("modifier_gyrocopter_homing_missile_charge_counter")
			if modifier_charges then
				modifier_charges:SetStackCount(3)
			end
		end)
	end

	if hero ~= nil then

		ApiEvent(ApiEventCodes.AbilityLearned, {
			tostring(abilityname),
			tostring(hero:GetUnitName()),
			tostring(PlayerResource:GetSteamID(player:GetPlayerID()))
		})
	end
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
	local abilityname = keys.abilityname
	local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
	local player = EntIndexToHScript(keys.player)
	local hero = player:GetAssignedHero()
	local hero_level = hero:GetLevel()

	-------------------------------------------------------------------------------------------------
	-- IMBA: Hero experience bounty adjustment
	-------------------------------------------------------------------------------------------------
	hero:SetCustomDeathXP(HERO_XP_BOUNTY_PER_LEVEL[hero_level])

	ApiEvent(ApiEventCodes.HeroLevelUp, {
		tostring(hero:GetUnitName()),
		tostring(hero_level),
		tostring(PlayerResource:GetSteamID(player:GetPlayerID()))
	})

	if hero:GetUnitName() == "npc_dota_hero_invoker" then
		if hero_level == 6 or hero_level == 12 or hero_level == 18 then
			local ab = hero:FindAbilityByName("invoker_invoke")
			ab:SetLevel(ab:GetLevel() +1)
		end
	end

	if hero_level >= 26 then
		if not hero:HasModifier("modifier_imba_war_veteran_"..hero:GetPrimaryAttribute()) then
			hero:AddNewModifier(hero, nil, "modifier_imba_war_veteran_"..hero:GetPrimaryAttribute(), {})
		end

		hero:SetModifierStackCount("modifier_imba_war_veteran_"..hero:GetPrimaryAttribute(), hero, hero:GetLevel() -25)
		hero:SetAbilityPoints(hero:GetAbilityPoints() -1)
	end
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
	if keys.PlayerID == -1 then return end
	local isFirstBlood = keys.FirstBlood == 1
	local isHeroKill = keys.HeroKill == 1
	local isTowerKill = keys.TowerKill == 1
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local killedEnt = EntIndexToHScript(keys.EntKilled)

	if isFirstBlood then
		player:GetAssignedHero().kill_hero_bounty = 0
		Timers:CreateTimer(FrameTime() * 2, function()
			CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", {
				type = "kill",
				killerPlayer = keys.PlayerID,
				victimPlayer = killedEnt:GetPlayerID(),
				firstblood = true,
				gold = CustomNetTables:GetTableValue("player_table", tostring(keys.PlayerID)).hero_kill_bounty,
			})
		end)
		return
	elseif isHeroKill then
		if not player:GetAssignedHero().killstreak then player:GetAssignedHero().killstreak = 0 end
		player:GetAssignedHero().killstreak = player:GetAssignedHero().killstreak +1
	end
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
	local treeX = keys.tree_x
	local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated(keys)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local rune = keys.rune

	PrintTable(rune)

	--[[ Rune Can be one of the following types
	DOTA_RUNE_DOUBLEDAMAGE
	DOTA_RUNE_HASTE
	DOTA_RUNE_HAUNTED
	DOTA_RUNE_ILLUSION
	DOTA_RUNE_INVISIBILITY
	DOTA_RUNE_BOUNTY
	DOTA_RUNE_MYSTERY
	DOTA_RUNE_RAPIER
	DOTA_RUNE_REGENERATION
	DOTA_RUNE_SPOOKY
	DOTA_RUNE_TURBO
	]]
end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)

	local hero_entity = EntIndexToHScript(keys.heroindex)
	local player_id = hero_entity:GetPlayerID()
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)

	-- Typical keys:
	-- herokills: 6
	-- killer_userid: 0
	-- splitscreenplayer: -1
	-- teamnumber: 2
	-- victim_userid: 7
	-- killer id will be -1 in case of a non-player owned killer (e.g. neutrals, towers, etc.)

	local killer_id = keys.killer_userid
	local victim_id = keys.victim_userid
	local killer_team = keys.teamnumber
	local nTeamKills = keys.herokills

	-- Overthrow
	if GetMapName() == "imba_overthrow" then
		local nKillsRemaining = TEAM_KILLS_TO_WIN - nTeamKills
		local broadcast_kill_event =
			{
				killer_id = keys.killer_userid,
				team_id = keys.teamnumber,
				team_kills = nTeamKills,
				kills_remaining = nKillsRemaining,
				victory = 0,
				close_to_victory = 0,
				very_close_to_victory = 0,
			}

		if nKillsRemaining <= 0 then
			GameRules:SetCustomVictoryMessage( m_VictoryMessages[killer_team] )
			GAME_WINNER_TEAM = killer_team
			GameRules:SetGameWinner( killer_team )
			broadcast_kill_event.victory = 1
		elseif nKillsRemaining == 1 then
			EmitGlobalSound( "ui.npe_objective_complete" )
			broadcast_kill_event.very_close_to_victory = 1
		elseif nKillsRemaining <= CLOSE_TO_VICTORY_THRESHOLD then
			EmitGlobalSound( "ui.npe_objective_given" )
			broadcast_kill_event.close_to_victory = 1
		end
		CustomGameEventManager:Send_ServerToAllClients( "kill_event", broadcast_kill_event )
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Comeback gold logic
	-------------------------------------------------------------------------------------------------
	--	UpdateComebackBonus(1, killer_team)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Deathstreak logic
	-------------------------------------------------------------------------------------------------
	if PlayerResource:IsValidPlayerID(killer_id) and PlayerResource:IsValidPlayerID(victim_id) then
		PlayerResource:ResetDeathstreak(killer_id)
		PlayerResource:IncrementDeathstreak(victim_id)

		-- Show Deathstreak message
		local victim_hero_name = PlayerResource:GetPickedHeroName(victim_id)
		local victim_player_name = PlayerResource:GetPlayerName(victim_id)
		local victim_death_streak = PlayerResource:GetDeathstreak(victim_id)
		local line_duration = 7

		if victim_death_streak then
			if victim_death_streak >= 3 then
				Notifications:BottomToAll({hero = victim_hero_name, duration = line_duration})
				Notifications:BottomToAll({text = victim_player_name.." ", duration = line_duration, continue = true})
			end

			if victim_death_streak == 3 then
				Notifications:BottomToAll({text = "#imba_deathstreak_3", duration = line_duration, continue = true})
			elseif victim_death_streak == 4 then
				Notifications:BottomToAll({text = "#imba_deathstreak_4", duration = line_duration, continue = true})
			elseif victim_death_streak == 5 then
				Notifications:BottomToAll({text = "#imba_deathstreak_5", duration = line_duration, continue = true})
			elseif victim_death_streak == 6 then
				Notifications:BottomToAll({text = "#imba_deathstreak_6", duration = line_duration, continue = true})
			elseif victim_death_streak == 7 then
				Notifications:BottomToAll({text = "#imba_deathstreak_7", duration = line_duration, continue = true})
			elseif victim_death_streak == 8 then
				Notifications:BottomToAll({text = "#imba_deathstreak_8", duration = line_duration, continue = true})
			elseif victim_death_streak == 9 then
				Notifications:BottomToAll({text = "#imba_deathstreak_9", duration = line_duration, continue = true})
			elseif victim_death_streak >= 10 then
				Notifications:BottomToAll({text = "#imba_deathstreak_10", duration = line_duration, continue = true})
			end
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Rancor logic
	-------------------------------------------------------------------------------------------------

	-- Victim stack loss
	local victim_hero = PlayerResource:GetPickedHero(victim_id)
	if victim_hero and victim_hero:HasModifier("modifier_imba_rancor") then
		local current_stacks = victim_hero:GetModifierStackCount("modifier_imba_rancor", VENGEFUL_RANCOR_CASTER)
		if current_stacks <= 2 then
			victim_hero:RemoveModifierByName("modifier_imba_rancor")
		else
			victim_hero:SetModifierStackCount("modifier_imba_rancor", VENGEFUL_RANCOR_CASTER, current_stacks - math.floor(current_stacks / 2) - 1)
		end
	end

	-- Killer stack gain
	if victim_hero and VENGEFUL_RANCOR and PlayerResource:IsImbaPlayer(killer_id) and killer_team ~= VENGEFUL_RANCOR_TEAM then
		local eligible_rancor_targets = FindUnitsInRadius(victim_hero:GetTeamNumber(), victim_hero:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		if eligible_rancor_targets[1] then
			local rancor_stacks = 1

			-- Double stacks if the killed unit was Venge
			if victim_hero == VENGEFUL_RANCOR_CASTER then
				rancor_stacks = rancor_stacks * 2
			end

			-- Add stacks and play particle effect
			AddStacks(VENGEFUL_RANCOR_ABILITY, VENGEFUL_RANCOR_CASTER, eligible_rancor_targets[1], "modifier_imba_rancor", rancor_stacks, true)
			local rancor_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_negative_aura.vpcf", PATTACH_ABSORIGIN, eligible_rancor_targets[1])
			ParticleManager:SetParticleControl(rancor_pfx, 0, eligible_rancor_targets[1]:GetAbsOrigin())
			ParticleManager:SetParticleControl(rancor_pfx, 1, VENGEFUL_RANCOR_CASTER:GetAbsOrigin())
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Vengeance Aura logic
	-------------------------------------------------------------------------------------------------

	if victim_hero and PlayerResource:IsImbaPlayer(killer_id) then
		local vengeance_aura_ability = victim_hero:FindAbilityByName("imba_vengeful_command_aura")
		local killer_hero = PlayerResource:GetPickedHero(killer_id)
		if vengeance_aura_ability and vengeance_aura_ability:GetLevel() > 0 then
			vengeance_aura_ability:ApplyDataDrivenModifier(victim_hero, killer_hero, "modifier_imba_command_aura_negative_aura", {})
			victim_hero.vengeance_aura_target = killer_hero
		end
	end
end

function GameMode:SetRespawnTime( killedTeam, killed_unit, extraTime )
	--print("Setting time for respawn")
	print(killedTeam, leadingTeam, isGameTied)
	if killedTeam == leadingTeam and isGameTied == false then
		killed_unit:SetTimeUntilRespawn( 20 + extraTime )
	else
		killed_unit:SetTimeUntilRespawn( 10 + extraTime )
	end
end

-- An entity died
function GameMode:OnEntityKilled( keys )
	GameMode:_OnEntityKilled( keys )

	-- The Unit that was killed
	local killed_unit = EntIndexToHScript( keys.entindex_killed )

	-- The Killing entity
	local killer = nil

	if keys.entindex_attacker then
		killer = EntIndexToHScript( keys.entindex_attacker )
	end

	if killed_unit then

		------------------------------------------------
		-- Api Event Unit Killed
		------------------------------------------------

		killedUnitName = tostring(killed_unit:GetUnitName())
		if (killedUnitName ~= "") then

			killedPlayer = "-1"

			if killed_unit:IsRealHero() and killed_unit:GetPlayerID() then
				killedPlayerId = killed_unit:GetPlayerID()
				killedPlayer = PlayerResource:GetSteamID(killedPlayerId)
			end

			killerUnitName = "-1"
			killerPlayer = "-1"
			if (killer ~= nil) then
				killerUnitName = tostring(killer:GetUnitName())
				if (killer:IsRealHero() and killer:GetPlayerID()) then
					killerPlayerId = killer:GetPlayerID()
					killerPlayer = PlayerResource:GetSteamID(killerPlayerId)
				end
			end

			ApiEvent(ApiEventCodes.UnitKilled, {
				tostring(killerUnitName),
				tostring(killerPlayer),
				tostring(killedUnitName),
				tostring(killedPlayer)
			})

		end

		-------------------------------------------------------------------------------------------------
		-- IMBA: Ancient destruction detection
		-------------------------------------------------------------------------------------------------
		if killed_unit:GetUnitName() == "npc_dota_badguys_fort" then
			GAME_WINNER_TEAM = 2
		elseif killed_unit:GetUnitName() == "npc_dota_goodguys_fort" then
			GAME_WINNER_TEAM = 3
		end

		-------------------------------------------------------------------------------------------------
		-- IMBA: Respawn timer setup
		-------------------------------------------------------------------------------------------------
		local reincarnation_death = false
		if killed_unit:HasModifier("modifier_imba_reincarnation") then
			local wk_mod = killed_unit:FindModifierByName("modifier_imba_reincarnation")
			reincarnation_death = (wk_mod.can_die == false)
		end

		if killed_unit:HasModifier("modifier_special_bonus_reincarnation") then
			if not killed_unit.undying_respawn_timer or killed_unit.undying_respawn_timer == 0 then
				print(killed_unit:FindModifierByName("modifier_special_bonus_reincarnation"):GetDuration())
				killed_unit:SetTimeUntilRespawn(5)
				killed_unit.undying_respawn_timer = 200
				return
			end
		end

		if killed_unit:GetUnitName() == "npc_dota_hero_meepo" then
			if killed_unit:GetCloneSource() and killed_unit:GetCloneSource():HasModifier("modifier_item_imba_aegis") then
				local meepo_table = Entities:FindAllByName("npc_dota_hero_meepo")
				if meepo_table then
					for i = 1, #meepo_table do
						if meepo_table[i]:IsClone() then
							meepo_table[i]:SetRespawnsDisabled(true)
							meepo_table[i]:GetCloneSource():SetTimeUntilRespawn(killed_unit:GetCloneSource():FindModifierByName("modifier_item_imba_aegis").reincarnate_time)
							meepo_table[i]:GetCloneSource():RemoveModifierByName("modifier_item_imba_aegis")
						else
							meepo_table[i]:SetTimeUntilRespawn(killed_unit:FindModifierByName("modifier_item_imba_aegis").reincarnate_time)
							return
						end
					end
				end
			elseif killed_unit:HasModifier("modifier_item_imba_aegis") then
				killed_unit:SetTimeUntilRespawn(killed_unit:FindModifierByName("modifier_item_imba_aegis").reincarnate_time)
			end
		end

		if reincarnation_death then
			killed_unit:SetTimeUntilRespawn(killed_unit:FindModifierByName("modifier_imba_reincarnation").reincarnate_delay)
		elseif killed_unit:HasModifier("modifier_item_imba_aegis") then
			killed_unit:SetTimeUntilRespawn(killed_unit:FindModifierByName("modifier_item_imba_aegis").reincarnate_time)
		elseif killed_unit:IsRealHero() and killed_unit:GetPlayerID() and (PlayerResource:IsImbaPlayer(killed_unit:GetPlayerID()) or (GameRules:IsCheatMode() == true) ) then
			if GetMapName() ~= "imba_overthrow" then
				-- Calculate base respawn timer, capped at 60 seconds
				local hero_level = math.min(killed_unit:GetLevel(), 25)
				local respawn_time = HERO_RESPAWN_TIME_PER_LEVEL[hero_level]
				-- Calculate respawn timer reduction due to talents and modifiers
				respawn_time = respawn_time * killed_unit:GetRespawnTimeModifier_Pct() * 0.01
				respawn_time = math.max(respawn_time + killed_unit:GetRespawnTimeModifier(),0)
				-- Fetch decreased respawn timer due to Bloodstone charges
				if killed_unit.bloodstone_respawn_reduction and (respawn_time > 0) then
					respawn_time = math.max( respawn_time - killed_unit.bloodstone_respawn_reduction, 0)
				end

				-- Set up the respawn timer, include meepo fix
				if killed_unit:GetUnitName() == "npc_dota_hero_meepo" then
					KillMeepos()
				else
					if killed_unit:HasModifier("modifier_imba_reapers_scythe_respawn") then
						local reaper_scythe = killer:FindAbilityByName("imba_necrolyte_reapers_scythe"):GetSpecialValueFor("respawn_increase")
						print("ignore respawn time limit")
						print(reaper_scythe)
						respawn_time = HERO_RESPAWN_TIME_PER_LEVEL[hero_level] + reaper_scythe
					elseif respawn_time > HERO_RESPAWN_TIME_PER_LEVEL[25] then
						respawn_time = HERO_RESPAWN_TIME_PER_LEVEL[25]
					end

					-- divide the respawn time by 2 for frantic mode
					if IMBA_FRANTIC_MODE_ON then
						killed_unit:SetTimeUntilRespawn(respawn_time * IMBA_FRANTIC_VALUE)
					else
						killed_unit:SetTimeUntilRespawn(respawn_time)
					end
				end
			end

			if GetMapName() == "imba_overthrow" then
				allSpawned = true
				--print("Hero has been killed")
				--Add extra time if killed by Necro Ult
				if keys.entindex_inflictor ~= nil then
					local inflictor_index = keys.entindex_inflictor
					if inflictor_index ~= nil then
						local ability = EntIndexToHScript( keys.entindex_inflictor )
						if ability ~= nil then
							if ability:GetAbilityName() ~= nil then
								if ability:GetAbilityName() == "necrolyte_reapers_scythe" then
									print("Killed by Necro Ult")
									extraTime = 20
								end
							end
						end
					end
				end

				if killer:GetTeam() ~= killed_unit:GetTeam() then
					--print("Granting killer xp")
					if killed_unit:GetTeam() == leadingTeam and isGameTied == false then
						local memberID = killed_unit:GetPlayerID()
						PlayerResource:ModifyGold( memberID, 500, true, 0 )
						killed_unit:AddExperience( 100, 0, false, false )
						local name = killed_unit:GetClassname()
						local victim = killed_unit:GetClassname()
						local kill_alert =
							{
								hero_id = killed_unit:GetClassname()
							}
						CustomGameEventManager:Send_ServerToAllClients( "kill_alert", kill_alert )
					else
						killed_unit:AddExperience( 50, 0, false, false )
					end

					local broadcast_team_points =
						{
							radiant = GetTeamHeroKills(2),
							dire = GetTeamHeroKills(3),
							custom_1 = GetTeamHeroKills(6),
							custom_2 = GetTeamHeroKills(7),
							custom_3 = GetTeamHeroKills(8),
						}

					CustomGameEventManager:Send_ServerToAllClients( "team_points", broadcast_team_points )
				end
				--Granting XP to all heroes who assisted
				local allHeroes = HeroList:GetAllHeroes()
				for _,attacker in pairs( allHeroes ) do
					--print(killed_unit:GetNumAttackers())
					for i = 0, killed_unit:GetNumAttackers() - 1 do
						if attacker == killed_unit:GetAttacker( i ) then
							--print("Granting assist xp")
							attacker:AddExperience( 25, 0, false, false )
						end
					end
				end
				if killed_unit:GetRespawnTime() > 10 then
					print("Hero has long respawn time")
					if killed_unit:IsReincarnating() == true then
						print("Set time for Wraith King respawn disabled")
					else
						GameMode:SetRespawnTime( killed_unit:GetTeamNumber(), killed_unit, 0 )
					end
				else
					GameMode:SetRespawnTime( killed_unit:GetTeamNumber(), killed_unit, 0 )
				end
			end
		end

		-- Check if the dying unit was a player-controlled hero
		if killed_unit:IsRealHero() and killed_unit:GetPlayerID() then

			-- Buyback parameters
			local player_id = killed_unit:GetPlayerID()
			local hero_level = killed_unit:GetLevel()
			local game_time = GameRules:GetDOTATime(false, true)

			-- Calculate buyback cost
			local level_based_cost = math.min(hero_level * hero_level, 625) * BUYBACK_COST_PER_LEVEL
			if hero_level > 25 then
				level_based_cost = level_based_cost + BUYBACK_COST_PER_LEVEL_AFTER_25 * (hero_level - 25)
			end
			local buyback_cost = BUYBACK_BASE_COST + level_based_cost + game_time * BUYBACK_COST_PER_SECOND
			local custom_gold_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "bounty_multiplier")["1"])
			buyback_cost = buyback_cost * (custom_gold_bonus / 100)
			-- Setup buyback cooldown
			local buyback_cooldown = 0
			-- if BUYBACK_COOLDOWN_ENABLED and game_time > BUYBACK_COOLDOWN_START_POINT then
			-- 	buyback_cooldown = math.min(BUYBACK_COOLDOWN_GROW_FACTOR * (game_time - BUYBACK_COOLDOWN_START_POINT), BUYBACK_COOLDOWN_MAXIMUM)
			-- end
			buyback_cooldown = 90

			-- #7 Talent Vengeful Spirit - Decreased respawn time & cost
			if killed_unit:HasTalent("special_bonus_imba_vengefulspirit_7") then
				buyback_cost = buyback_cost * (1 - (killed_unit:FindSpecificTalentValue("special_bonus_imba_vengefulspirit_7", "buyback_cost_pct") * 0.01))
				buyback_cooldown = buyback_cooldown * (1 - (killed_unit:FindSpecificTalentValue("special_bonus_imba_vengefulspirit_7", "buyback_cooldown_pct") * 0.01))
			end

			-- Update buyback cost
			PlayerResource:SetCustomBuybackCost(player_id, buyback_cost)
			PlayerResource:SetCustomBuybackCooldown(player_id, buyback_cooldown)
		end

		local gold_bounty = 200
		if killed_unit:GetUnitName() == "npc_dota_badguys_healers" then
			gold_bounty = 125
		end

		-- ready to use
		if killed_unit:IsBuilding() then
			if killer:IsRealHero() then
				CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", {
					type = "kill",
					killerPlayer = killer:GetPlayerID(),
					victimUnitName = killed_unit:GetUnitName(),
					gold = gold_bounty,
				})
			else
				CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", {
					type = "generic",
					text = "#custom_toast_TeamKilled",
					victimUnitName = killed_unit:GetUnitName(),
					teamColor = killer:GetTeam(),
					team = killer:GetTeam(),
					gold = gold_bounty,
				})
			end
		elseif killed_unit:IsCourier() then
			CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", {
				type = "generic",
				text = "#custom_toast_CourierKilled",
				teamColor = killed_unit:GetTeam(),
				team = killed_unit:GetTeam(),
				courier = true,
			})

		elseif killed_unit:GetUnitName() == "npc_imba_roshan" then
			CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", {
				type = "kill",
				teamColor = killer:GetTeam(),
				team = killer:GetTeam(),
				victimUnitName = killed_unit:GetUnitName(),
				roshan = true,
				gold = 150,
			})
		end

		if killer:IsRealHero() then
			if killer == killed_unit then
				CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", {
					type = "kill",
					victimUnitName = killed_unit:GetUnitName(),
				})
				return
			elseif killed_unit:IsRealHero() and killer:GetTeamNumber() == killed_unit:GetTeamNumber() then
				CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", {
					type = "kill",
					killerPlayer = killer:GetPlayerID(),
					victimPlayer = killed_unit:GetPlayerID(),
					victimUnitName = killed_unit:GetUnitName(),
				})
			elseif killed_unit:IsRealHero() and killer:GetTeamNumber() ~= killed_unit:GetTeamNumber() then
				print("Killers:", killed_unit:GetNumAttackers())
				PrintTable(killed_unit:GetAttacker(0))

				local streak = {}
				streak[3] = "Killing spree"
				streak[4] = "Dominating"
				streak[5] = "Mega kill"
				streak[6] = "Unstoppable"
				streak[7] = "Wicked sick"
				streak[8] = "Monster kill"
				streak[9] = "Godlike"
				streak[10] = "Beyond Godlike"

				killer.kill_hero_bounty = 0
				Timers:CreateTimer(FrameTime() * 2, function()
					CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", {
						type = "kill",
						killerPlayer = killer:GetPlayerID(),
						victimPlayer = killed_unit:GetPlayerID(),
						gold = CustomNetTables:GetTableValue("player_table", tostring(killer:GetPlayerID())).hero_kill_bounty,
						variables = {
							["{kill_streak}"] = streak[math.min(killer.killstreak, 10)]
						}
					})
				end)
			end
		elseif killer:IsTower() then
			if killed_unit:IsRealHero() then
				CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", {
					type = "generic",
					text = "#custom_toast_TeamKilled",
					victimUnitName = killed_unit:GetUnitName(),
					teamColor = killer:GetTeam(),
					team = killer:GetTeam(),
					tower = true,
				})
			end
		end

		if killed_unit:IsRealHero() then
			if killer:GetTeamNumber() == 4 then
				CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", {
					type = "kill",
					victimUnitName = killed_unit:GetUnitName(),
					neutral = true,
				})
			end
			-- reset killstreak if not comitted suicide
			killed_unit.killstreak = 0
		end
	end
end

-- This function is called 1 to 2 times as the player connects initially but before they have completely connected
function GameMode:PlayerConnect(keys)

end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
	GameMode:_OnConnectFull(keys)

	local entIndex = keys.index+1
	local ply = EntIndexToHScript(entIndex)
	local player_id = ply:GetPlayerID()

	ApiEvent(ApiEventCodes.PlayerConnected, { tostring(PlayerResource:GetSteamID(player_id)) })
	-------------------------------------------------------------------------------------------------
	-- IMBA: Player data initialization
	-------------------------------------------------------------------------------------------------
	print("Player has fully connected:", player_id)

	--	if player.is_dev then
	--		CustomGameEventManager:Send_ServerToPlayer(player:GetPlayerOwner(), "show_netgraph", {})
	--	end

	CustomGameEventManager:Send_ServerToAllClients("send_news", {})

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player reconnect logic
	-------------------------------------------------------------------------------------------------
	ReconnectPlayer(player_id)

	PlayerResource:InitPlayerData(player_id)
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function GameMode:OnIllusionsCreated(keys)
	local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever an item is combined to create a new item
function GameMode:OnItemCombined(keys)
	-- The playerID of the hero who is buying something
	local plyID = keys.PlayerID
	if not plyID then return end
	local player = PlayerResource:GetPlayer(plyID)

	-- The name of the item purchased
	local itemName = keys.itemname

	-- The cost of the item purchased
	local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function GameMode:OnAbilityCastBegins(keys)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local abilityName = keys.abilityname
end

-- This function is called whenever a tower is killed
function GameMode:OnTowerKill(keys)
	local gold = keys.gold
	local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
	local tower_team = keys.teamnumber

	-------------------------------------------------------------------------------------------------
	-- IMBA: Attack of the Ancients tower upgrade logic
	-------------------------------------------------------------------------------------------------

	-- Always enabled!
	--	if TOWER_UPGRADE_MODE then

	-- Find all friendly towers on the map
	local towers = FindUnitsInRadius(tower_team, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

	-- Upgrade each tower
	for _, tower in pairs(towers) do
		UpgradeTower(tower)
	end

	-- Display upgrade message and play ominous sound
	if tower_team == DOTA_TEAM_GOODGUYS then
		Notifications:BottomToAll({text = "#tower_abilities_radiant_upgrade", duration = 7, style = {color = "DodgerBlue"}})
		EmitGlobalSound("powerup_01")
	else
		Notifications:BottomToAll({text = "#tower_abilities_dire_upgrade", duration = 7, style = {color = "DodgerBlue"}})
		EmitGlobalSound("powerup_02")
	end
	--	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Update comeback gold logic
	-------------------------------------------------------------------------------------------------

	--	local team = PlayerResource:GetTeam(keys.killer_userid)
	--	UpdateComebackBonus(2, team)
end

-- This function is called whenever a player changes there custom team selection during Game Setup
function GameMode:OnPlayerSelectedCustomTeam(keys)
	local player = PlayerResource:GetPlayer(keys.player_id)
	local success = (keys.success == 1)
	local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function GameMode:OnNPCGoalReached(keys)
	local goalEntity = EntIndexToHScript(keys.goal_entindex)
	local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
	local npc = EntIndexToHScript(keys.npc_entindex)
end
