-- TODO: FORMAT FILTERS CODE IT LOOKS LIKE SHIT

-- Gold gain filter function
function GameMode:GoldFilter(keys)
	-- reason_const		12
	-- reliable			1
	-- player_id_const	0
	-- gold				141

	-- Gold from abandoning players does not get multiplied
	if keys.reason_const == DOTA_ModifyGold_AbandonedRedistribute or keys.reason_const == DOTA_ModifyGold_GameTick then
		return true
	end

	-- Ignore negative experience values
	if keys.gold < 0 then
		return false
	end

	if PlayerResource:GetPlayer(keys.player_id_const) == nil then return end
	local player = PlayerResource:GetPlayer(keys.player_id_const)

	-- player can be nil for some reason
	if player then
		local hero = player:GetAssignedHero()

		-- Hand of Midas gold bonus
		if hero:HasModifier("modifier_item_imba_hand_of_midas") and keys.gold > 0 then
			keys.gold = keys.gold * 1.1
		end

		-- Lobby options adjustment
		local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, 30) -- minutes
		local custom_gold_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "bounty_multiplier")["1"]) or 100

		if keys.reason_const == DOTA_ModifyGold_HeroKill then
			keys.gold = keys.gold * (custom_gold_bonus / 100)
			if not hero.kill_hero_bounty then hero.kill_hero_bounty = 0 end
			if hero.kill_hero_bounty == 0 then hero.kill_hero_bounty = keys.gold end
			if hero.kill_hero_bounty ~= 0 and hero.kill_hero_bounty ~= keys.gold then
				CustomNetTables:SetTableValue("player_table", tostring(keys.player_id_const), {hero_kill_bounty = keys.gold + hero.kill_hero_bounty})
			end
		else
			keys.gold = keys.gold * custom_gold_bonus / 100
		end

		local reliable = false
		if keys.reason_const == DOTA_ModifyGold_HeroKill or keys.reason_const == DOTA_ModifyGold_RoshanKill or keys.reason_const == DOTA_ModifyGold_CourierKill or keys.reason_const == DOTA_ModifyGold_Building then
			reliable = true
		end

		if keys.reason_const == DOTA_ModifyGold_Unspecified then return true end

		-- TODO: Find a way to call this message on the killed unit
--		SendOverheadEventMessage(PlayerResource:GetPlayer(keys.player_id_const), OVERHEAD_ALERT_GOLD, hero, keys.gold, nil)
	end

	return false
end

-- Experience gain filter function
function GameMode:ExperienceFilter( keys )
	-- reason_const		1 (DOTA_ModifyXP_CreepKill)
	-- experience		130
	-- player_id_const	0

	if PlayerResource:GetPlayer(keys.player_id_const) == nil then return end
	local player = PlayerResource:GetPlayer(keys.player_id_const)
	local hero = player:GetAssignedHero()

	-- Ignore negative experience values
	if keys.experience < 0 then
		return false
	end

	local game_time = math.max(GameRules:GetDOTATime(false, false), 0)
	local custom_xp_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "exp_multiplier")["1"])

	if keys.reason_const == DOTA_ModifyXP_HeroKill then
		keys.experience = keys.experience * (custom_xp_bonus / 100)
	else
		if GetMapName() ~= Map1v1() then
			keys.experience = keys.experience * (custom_xp_bonus / 100) * (1 + game_time / 200)
		end
	end

	return true
end

-- Modifier gained filter function
function GameMode:ModifierFilter( keys )
	-- entindex_parent_const	215
	-- entindex_ability_const	610
	-- duration					-1
	-- entindex_caster_const	215
	-- name_const				modifier_imba_roshan_rage_stack

	if IsServer() then
		local modifier_owner = EntIndexToHScript(keys.entindex_parent_const)
		local modifier_name = keys.name_const
		local modifier_caster

		if keys.entindex_caster_const then
			modifier_caster = EntIndexToHScript(keys.entindex_caster_const)
		else
			return true
		end

		-- volvo bugfix
		if modifier_name == "modifier_datadriven" then
			return false
		end

		-- don't add buyback penalty
		if modifier_name == "modifier_buyback_gold_penalty" then
			return false
		end

		-------------------------------------------------------------------------------------------------
		-- Roshan special modifier rules
		-------------------------------------------------------------------------------------------------
		if modifier_owner:IsRoshan() then
			-- Ignore stuns
			if modifier_name == "modifier_stunned" then
				return false
			end

			-- Halve the duration of everything else
			if modifier_caster ~= modifier_owner and keys.duration > 0 then
				keys.duration = keys.duration / (100/50)
			end

			-- Fury swipes capping
			if modifier_owner:GetModifierStackCount("modifier_ursa_fury_swipes_damage_increase", nil) > 5 then
				modifier_owner:SetModifierStackCount("modifier_ursa_fury_swipes_damage_increase", nil, 5)
			end
		end

		-------------------------------------------------------------------------------------------------
		-- Silencer Arcane Supremacy silence duration reduction
		-------------------------------------------------------------------------------------------------
		if modifier_owner:HasModifier("modifier_imba_silencer_arcane_supremacy") then
			if not modifier_owner:PassivesDisabled() then

				local arcane_supremacy = modifier_owner:FindModifierByName("modifier_imba_silencer_arcane_supremacy")
				local silence_reduction_pct
				if arcane_supremacy then
					silence_reduction_pct = arcane_supremacy:GetSilenceReductionPct() * 0.01
				end

				if modifier_owner:GetTeam() ~= modifier_caster:GetTeam() and keys.duration > 0 then
					if IsVanillaSilence(modifier_name) or IsImbaSilence(modifier_name) then
						-- if reduction is 1 (or more), the modifier is completely ignored
						if silence_reduction_pct >= 1 then
							SendOverheadEventMessage(nil, OVERHEAD_ALERT_LAST_HIT_MISS, modifier_owner, 0, nil)
							return false
						else
							keys.duration = keys.duration * (1 - silence_reduction_pct)
						end
					elseif IsSilentSilence(modifier_name) then
						if silence_reduction_pct >= 1 then
							return false
						else
							keys.duration = keys.duration * (1 - silence_reduction_pct)
						end
					end
				end
			end
		end

		-------------------------------------------------------------------------------------------------
		-- Silencer Arcane Supremacy silence duration increase for Silencer's applied silences
		-------------------------------------------------------------------------------------------------
		if modifier_caster:HasModifier("modifier_imba_silencer_arcane_supremacy") and not modifier_owner:PassivesDisabled() then
			if modifier_owner:GetTeam() ~= modifier_caster:GetTeam() and keys.duration > 0 then

				durationIncreasePcnt = modifier_caster:FindTalentValue("special_bonus_imba_silencer_3") * 0.01
				if durationIncreasePcnt > 0 then

					-- If the modifier is a vanilla one, increase duration directly
					if IsVanillaSilence(modifier_name) or IsImbaSilence(modifier_name) then
						keys.duration = keys.duration * (1 + durationIncreasePcnt)
					end
				end
			end
		end

		-- disarm immune
		local jarnbjorn_immunity = {
			"modifier_disarmed",
			"modifier_item_imba_triumvirate_proc_debuff",
			"modifier_item_imba_sange_kaya_proc",
			"modifier_item_imba_sange_yasha_disarm",
			"modifier_item_imba_heavens_halberd_active_disarm",
			"modifier_item_imba_sange_disarm",
			"modifier_imba_angelic_alliance_debuff",
			"modifier_imba_overpower_disarm",
			"modifier_imba_silencer_last_word_debuff",
			"modifier_imba_hurl_through_hell_disarm",
			"modifier_imba_frost_armor_freeze",
			"modifier_dismember_disarm",
			"modifier_imba_decrepify",

--			"modifier_imba_faceless_void_time_lock_stun",
--			"modifier_bashed",
		}

		-- add particle or sound playing to notify
		if modifier_owner:HasModifier("modifier_item_imba_jarnbjorn_static") then
			for _, modifier in pairs(jarnbjorn_immunity) do
				if modifier_name == modifier then
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_EVADE, modifier_owner, 0, nil)
					return false
				end
			end
		end

		if modifier_name == "modifier_tusk_snowball_movement" then
			if modifier_owner:FindAbilityByName("tusk_snowball") then
				modifier_owner:FindAbilityByName("tusk_snowball"):SetActivated(false)
				Timers:CreateTimer(15.0, function()
					if not modifier_owner:FindModifierByName("modifier_tusk_snowball_movement") then
						modifier_owner:FindAbilityByName("tusk_snowball"):SetActivated(true)
					end
				end)
			end
		end

		if modifier_owner:GetUnitName() == "npc_imba_warlock_demonic_ascension" then
			if modifier_name == "modifier_fountain_aura_effect_lua" then
				return false
			end
		end

		return true
	end
end

-- Item added to inventory filter
function GameMode:ItemAddedFilter( keys )

	-- Typical keys:
	-- inventory_parent_entindex_const: 852
	-- item_entindex_const: 1519
	-- item_parent_entindex_const: -1
	-- suggested_slot: -1
	local unit = EntIndexToHScript(keys.inventory_parent_entindex_const)
	if unit == nil then return end
	local item = EntIndexToHScript(keys.item_entindex_const)
	if item == nil then return end
	if item:GetAbilityName() == "item_tpscroll" and item:GetPurchaser() == nil then return false end
	local item_name = 0
	if item:GetName() then
		item_name = item:GetName()
	end

	if string.find(item_name, "item_imba_rune_") and unit:IsRealHero() then
		ImbaRunes:PickupRune(item_name, unit)
		return false
	end

	if item.airdrop then
		local overthrow_item_drop =
		{
			hero_id = unit:GetClassname(),
			dropped_item = item:GetName()
		}
		CustomGameEventManager:Send_ServerToAllClients("overthrow_item_drop", overthrow_item_drop)
		EmitGlobalSound("powerup_04")
		item.airdrop = nil
	end

	-------------------------------------------------------------------------------------------------
	-- Aegis of the Immortal pickup logic
	-------------------------------------------------------------------------------------------------
	if item_name == "item_imba_aegis" then
		-- If this is a player, do Aegis stuff
		if unit:IsRealHero() and not unit:HasModifier("modifier_item_imba_aegis") then

			-- Display aegis pickup message for all players
			unit:AddNewModifier(unit, item, "modifier_item_imba_aegis",{})
			local line_duration = 7
			Notifications:BottomToAll({hero = unit:GetName(), duration = line_duration})
			Notifications:BottomToAll({text = PlayerResource:GetPlayerName(unit:GetPlayerID()).." ", duration = line_duration, continue = true})
			Notifications:BottomToAll({text = "#imba_player_aegis_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})

			-- Destroy the item
			return false
			-- If this is not a player, do nothing and drop another Aegis
		else
			local drop = CreateItem("item_imba_aegis", nil, nil)
			CreateItemOnPositionSync(unit:GetAbsOrigin(), drop)
			drop:LaunchLoot(false, 250, 0.5, unit:GetAbsOrigin() + RandomVector(100))

			UTIL_Remove(item:GetContainer())
			UTIL_Remove(item)

			-- Destroy the item
			return false
		end
		return false
	end

	-------------------------------------------------------------------------------------------------
	-- Rapier pickup logic
	-------------------------------------------------------------------------------------------------
	if item.IsRapier then
		if item.rapier_pfx then
			ParticleManager:DestroyParticle(item.rapier_pfx, false)
			ParticleManager:ReleaseParticleIndex(item.rapier_pfx)
			item.rapier_pfx = nil
		end
		if item.x_pfx then
			ParticleManager:DestroyParticle(item.x_pfx, false)
			ParticleManager:ReleaseParticleIndex(item.x_pfx)
			item.x_pfx = nil
		end
		if unit:IsRealHero() or ( unit:GetClassname() == "npc_dota_lone_druid_bear" ) then
			item:SetPurchaser(nil)
			item:SetPurchaseTime(0)
			local rapier_amount = 0
			local rapier_2_amount = 0
			local rapier_magic_amount = 0
			local rapier_magic_2_amount = 0
			for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6 do
				local current_item = unit:GetItemInSlot(i)
				if not current_item then
					return true
				elseif current_item and current_item:GetName() == "item_imba_rapier" then
					rapier_amount = rapier_amount + 1
				elseif current_item and current_item:GetName() == "item_imba_rapier_2" then
					rapier_2_amount = rapier_2_amount + 1
				elseif current_item and current_item:GetName() == "item_imba_rapier_magic" then
					rapier_magic_amount = rapier_magic_amount + 1
				elseif current_item and current_item:GetName() == "item_imba_rapier_magic_2" then
					rapier_magic_2_amount = rapier_magic_2_amount + 1
				end
			end
			if 	((item_name == "item_imba_rapier") and (rapier_amount == 2)) or
			((item_name == "item_imba_rapier_magic") and (rapier_magic_amount == 2)) or
			((item_name == "item_imba_rapier_2") and (rapier_magic_2_amount >= 1)) or
			((item_name == "item_imba_rapier_magic_2") and (rapier_2_amount >= 1)) then
				return true
			else
				DisplayError(unit:GetPlayerID(),"#dota_hud_error_cant_item_enough_slots")
			end
		end
		if unit:IsIllusion() or unit:IsTempestDouble() then
			return true
		else
			unit:DropRapier(nil, item_name)
		end
		return false
	end

	-------------------------------------------------------------------------------------------------
	-- Tempest Double forbidden items
	-------------------------------------------------------------------------------------------------

	if unit:IsTempestDouble() then
		-- List of items the clone can't carry
		local clone_forbidden_items = {
			"item_imba_rapier",
			"item_imba_rapier_2",
			"item_imba_rapier_magic",
			"item_imba_rapier_magic_2",
			"item_imba_rapier_cursed",
			"item_imba_moon_shard",
			"item_imba_soul_of_truth",
			"item_imba_mango",
			"item_imba_refresher",
			"item_imba_ultimate_scepter_synth"
		}

		-- If this item is forbidden, delete it
		for _, forbidden_item in pairs(clone_forbidden_items) do
			if item_name == forbidden_item then
				return false
			end
		end
	end

	return true
end

-- Order filter function
function GameMode:OrderFilter( keys )

	--entindex_ability	 ==> 	0
	--sequence_number_const	 ==> 	20
	--queue	 ==> 	0
	--units	 ==> 	table: 0x031d5fd0
	--entindex_target	 ==> 	0
	--position_z	 ==> 	384
	--position_x	 ==> 	-5694.3334960938
	--order_type	 ==> 	1
	--position_y	 ==> 	-6381.1127929688
	--issuer_player_id_const	 ==> 	0

	local units = keys["units"]
	local unit
	if units["0"] then
		unit = EntIndexToHScript(units["0"])
	else
		return nil
	end
	if unit == nil then return end

	-- Do special handlings if shift-casted only here! The event gets fired another time if the caster
	-- is actually doing this order
	if keys.queue == 1 then
		return true
	end

	--	if keys.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
	--		local ability = EntIndexToHScript(keys["entindex_ability"])
	--		if unit:IsRealHero() then
	--			local companions = FindUnitsInRadius(unit:GetTeamNumber(), Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	--			for _, companion in pairs(companions) do
	--				if companion:GetUnitName() == "npc_imba_donator_companion" and companion:GetOwner() == unit then
	--					if ability:GetAbilityName() == "slark_pounce" then
	--						local ab = companion:AddAbility(ability:GetAbilityName())
	--						ab:SetLevel(1)
	--						ab:EndCooldown()
	--						companion:CastAbilityNoTarget(ab, -1)
	--						Timers:CreateTimer(ab:GetCastPoint() + 0.1, function()
	--							companion:RemoveAbility(ab:GetAbilityName())
	--						end)
	--					end
	--				end
	--			end
	--		end
	--	end

	if api.imba.is_donator(tostring(PlayerResource:GetSteamID(keys.issuer_player_id_const))) == 10 then
		return false
	end

	if keys.order_type == DOTA_UNIT_ORDER_GLYPH then
		CombatEvents("generic", "glyph", unit)
	end

	if USE_TEAM_COURIER == false then
		if unit:IsCourier() then
			if unit == TurboCourier.COURIER_PLAYER[unit:GetPlayerOwnerID()] then
				print("this courier is under your exclusive control!")
				if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET or keys.order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
					return false
				else
					return true
				end
			else
				print("This courier is not under your control!")
				return false
			end
		end
	end

	------------------------------------------------------------------------------------
	-- Prevent Buyback during reincarnation
	------------------------------------------------------------------------------------
	if keys.order_type == DOTA_UNIT_ORDER_BUYBACK then
		if unit:IsImbaReincarnating() then
			return false
		end
	end

	------------------------------------------------------------------------------------
	-- Witch Doctor Death Ward handler
	------------------------------------------------------------------------------------
	if unit:HasModifier("modifier_imba_death_ward") then
		if keys.order_type ==  DOTA_UNIT_ORDER_ATTACK_TARGET then
			local death_ward_mod = unit:FindModifierByName("modifier_imba_death_ward")
			death_ward_mod.attack_target = EntIndexToHScript(keys.entindex_target)
			return true
		else
			return nil
		end
	end

	if unit:HasModifier("modifier_imba_death_ward_caster") then
		if keys.order_type ==  DOTA_UNIT_ORDER_ATTACK_TARGET then
			local modifier = unit:FindModifierByName("modifier_imba_death_ward_caster")
			modifier.death_ward_mod.attack_target = EntIndexToHScript(keys.entindex_target)
			return nil
		end
	end

	------------------------------------------------------------------------------------
	-- Riki Blink-Strike handler
	------------------------------------------------------------------------------------
	if keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET then
		if EntIndexToHScript(keys["entindex_ability"]) == nil then return end
		local ability = EntIndexToHScript(keys["entindex_ability"])
		if ability:GetAbilityName() == "imba_riki_blink_strike" then
			ability.thinker = unit:AddNewModifier(unit, ability, "modifier_imba_blink_strike_thinker", {target = keys.entindex_target})
		end
	end

	------------------------------------------------------------------------------------
	-- Queen of Pain's Sonic Wave confusion
	------------------------------------------------------------------------------------

	if unit:HasModifier("modifier_imba_sonic_wave_daze") then
		-- Determine order type
		local modifier = unit:FindModifierByName("modifier_imba_sonic_wave_daze")
		local rand = math.random

		-- Change "move to target" to "move to position"
		if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
			local target = EntIndexToHScript(keys["entindex_target"])
			local target_loc = target:GetAbsOrigin()
			keys.position_x = target_loc.x
			keys.position_y = target_loc.y
			keys.position_z = target_loc.z
			keys.entindex_target = 0
			keys.order_type = DOTA_UNIT_ORDER_MOVE_TO_POSITION
		end

		-- Change "attack target" to "attack move"
		if keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
			local target = EntIndexToHScript(keys["entindex_target"])
			local target_loc = target:GetAbsOrigin()
			keys.position_x = target_loc.x
			keys.position_y = target_loc.y
			keys.position_z = target_loc.z
			keys.entindex_target = 0
			keys.order_type = DOTA_UNIT_ORDER_ATTACK_MOVE
		end

		-- Change "cast on target" target
		if keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET then

			local target = EntIndexToHScript(keys["entindex_target"])
			local ability = EntIndexToHScript(keys["entindex_ability"])
			local caster_loc = unit:GetAbsOrigin()
			local target_loc = target:GetAbsOrigin()
			local target_distance = (target_loc - caster_loc):Length2D()

			local nearby_units = FindUnitsInRadius(unit:GetTeamNumber(), caster_loc, nil, math.max(target_distance,(ability:GetCastRange(caster_loc, unit)) + GetCastRangeIncrease(unit)), ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
			if #nearby_units >= 1 then
				keys.entindex_target = nearby_units[1]:GetEntityIndex()

				-- If no target was found, change to "cast on position" order
			else
				keys.position_x = target_loc.x
				keys.position_y = target_loc.y
				keys.position_z = target_loc.z
				keys.entindex_target = 0
				keys.order_type = DOTA_UNIT_ORDER_CAST_POSITION
			end

			-- Reduce stack-amount
			if not (keys.queue == 1) then
				modifier:DecrementStackCount()
			end
			if modifier:GetStackCount() == 0 then
				modifier:Destroy()
			end
		end

		if keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET_TREE then
			-- Still needs some checkup

		end

		-- Spin positional orders a random angle
		if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or keys.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE or keys.order_type == DOTA_UNIT_ORDER_CAST_POSITION then
			-- Calculate new order position
			local target_loc = Vector(keys.position_x, keys.position_y, keys.position_z)
			local origin_loc = unit:GetAbsOrigin()
			local order_vector = target_loc - origin_loc
			local new_order_vector = RotatePosition(origin_loc, QAngle(0, 180, 0), origin_loc + order_vector)

			-- Override order
			keys.position_x = new_order_vector.x
			keys.position_y = new_order_vector.y
			keys.position_z = new_order_vector.z

			-- Reduce stack-amount
			if not (keys.queue == 1) then
				modifier:DecrementStackCount()
			end
			if modifier:GetStackCount() == 0 then
				modifier:Destroy()
			end
		end
	end

	if keys.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
		local ability = EntIndexToHScript(keys.entindex_ability)

		-- Kunkka Torrent cast-handling
		if ability ~= nil and ability:GetAbilityName() == "imba_kunkka_torrent" then
			local range = ability.BaseClass.GetCastRange(ability,ability:GetCursorPosition(),unit) + GetCastRangeIncrease(unit)
			if unit:HasModifier("modifier_imba_ebb_and_flow_tide_low") or unit:HasModifier("modifier_imba_ebb_and_flow_tsunami") then
				range = range + ability:GetSpecialValueFor("tide_low_range")
			end
			local distance = (unit:GetAbsOrigin() - Vector(keys.position_x,keys.position_y,keys.position_z)):Length2D()

			if ( range >= distance) then
				unit:AddNewModifier(unit, ability, "modifier_imba_torrent_cast", {duration = 0.41} )
			end
		end

		-- Kunkka Tidebringer cast-handling
		if ability ~= nil and ability:GetAbilityName() == "imba_kunkka_tidebringer" then
			ability.manual_cast = true
		end

	elseif unit:HasModifier("modifier_imba_torrent_cast") and keys.order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
		unit:RemoveModifierByName("modifier_imba_torrent_cast")
	end
	-- Tidebringer manual cast
	if unit:HasModifier("modifier_imba_tidebringer_manual") then
		unit:RemoveModifierByName("modifier_imba_tidebringer_manual")
	end

	-- Culling Blade leap
	if unit:HasModifier("modifier_imba_axe_culling_blade_leap") then
		return false
	end

	if keys.order_type == DOTA_UNIT_ORDER_CAST_POSITION then
		local ability = EntIndexToHScript(keys.entindex_ability)

		-- Techies' Focused Detonate cast-handling
		if ability ~= nil and ability:GetAbilityName() == "imba_techies_focused_detonate" then
			unit:AddNewModifier(unit, ability, "modifier_imba_focused_detonate", {duration = 0.2})
		end

		-- Mirana's Leap talent cast-handling
		if ability ~= nil and ability:GetAbilityName() == "imba_mirana_leap" and unit:HasTalent("special_bonus_imba_mirana_7") then
			unit:AddNewModifier(unit, ability, "modifier_imba_leap_talent_cast_angle_handler", {duration = FrameTime()})
		end
	end

	-- Meepo item handle
	local meepo_table = Entities:FindAllByName("npc_dota_hero_meepo")
	local ability = EntIndexToHScript(keys.entindex_ability)
	if unit:GetUnitName() == "npc_dota_hero_meepo" then
		for m = 1, #meepo_table do
			if keys.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
				if ability:GetName() == "item_black_king_bar" then
					local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() -1)
					meepo_table[m]:AddNewModifier(meepo_table[m], ability, "modifier_black_king_bar_immune", {duration = duration})
				elseif ability:GetName() == "item_imba_white_queen_cape" then
					local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() -1)
					meepo_table[m]:AddNewModifier(meepo_table[m], ability, "modifier_black_king_bar_immune", {duration = duration})
				end
			elseif keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET then
				if ability:GetName() == "item_imba_black_queen_cape" then
					local duration = ability:GetLevelSpecialValueFor("bkb_duration", ability:GetLevel() -1)
					meepo_table[m]:AddNewModifier(meepo_table[m], nil, "modifier_imba_black_queen_cape_active_bkb", {duration = duration})
				end
			end
		end
	end

	if GetMapName() == Map1v1() then
		if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
			local target = EntIndexToHScript(keys["entindex_target"])
			if target:GetUnitName() == "npc_dota_goodguys_healers" or target:GetUnitName() == "npc_dota_badguys_healers" then
				DisplayError(unit:GetPlayerID(),"#dota_hud_error_cant_shrine_1v1")
				return false
			end
		end
	end

	if keys.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM then
		local item = keys.entindex_ability
		if item == nil then return true end

		if GetMapName() == Map1v1() then
			for _, banned_item in pairs(BANNED_ITEMS[GetMapName()]) do
				if self.itemIDs[item] == banned_item then
					DisplayError(unit:GetPlayerID(),"#dota_hud_error_cant_purchase_1v1")
					return false
				end
			end
		end

		if USE_TEAM_COURIER == false then
			unit.reset_turbo_deliver = true
		end
	end

	if keys.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM then
		local unit = EntIndexToHScript(keys.units["0"])
		if unit == nil then return false end
		local drop = EntIndexToHScript(keys["entindex_target"])
		local item
		if drop ~= nil then
			item = drop:GetContainedItem()
		end
		if item == nil then return false end

		-- Make sure non-heroes cannot pick up runes and make them do nothing
		if not unit:IsRealHero() then
			if string.find(item:GetAbilityName(), "imba_rune") ~= nil then
				return false
			end

			if unit:IsCourier() then
				if item.airdrop then
					return false
				end
			end

			return true
		end		
	end

	return true
end

-- Damage filter function
function GameMode:DamageFilter( keys )
	if IsServer() then
		--damagetype_const
		--damage
		--entindex_attacker_const
		--entindex_victim_const
		local attacker
		local victim

		if keys.entindex_attacker_const and keys.entindex_victim_const then
			attacker = EntIndexToHScript(keys.entindex_attacker_const)
			victim = EntIndexToHScript(keys.entindex_victim_const)
		else
			return false
		end

		local damage_type = keys.damagetype_const

		-- Lack of entities handling
		if not attacker or not victim then
			return false
		end

		-- If the attacker is holding an Arcane/Archmage/Cursed Rapier and the distance is over the cap, remove the spellpower bonus from it
		if attacker:HasModifier("modifier_imba_arcane_rapier") or attacker:HasModifier("modifier_imba_arcane_rapier_2") or attacker:HasModifier("modifier_imba_rapier_cursed") then
			local distance = (attacker:GetAbsOrigin() - victim:GetAbsOrigin()):Length2D()

			if distance > IMBA_DAMAGE_EFFECTS_DISTANCE_CUTOFF then
				local rapier_spellpower = 0

				-- Get all modifiers, gather how much spellpower the target has from rapiers
				local modifiers = attacker:FindAllModifiers()

				for _,modifier in pairs(modifiers) do
					-- Increment Cursed Rapier's spellpower
					if modifier:GetName() == "modifier_imba_rapier_cursed" then
						rapier_spellpower = rapier_spellpower + modifier:GetAbility():GetSpecialValueFor("spell_power")

						-- Increment Archmage Rapier spellpower
					elseif modifier:GetName() == "modifier_imba_arcane_rapier_2" then
						rapier_spellpower = rapier_spellpower + modifier:GetAbility():GetSpecialValueFor("spell_power")

						-- Increment Arcane Rapier spellpower
					elseif modifier:GetName() == "modifier_imba_arcane_rapier" then
						rapier_spellpower = rapier_spellpower + modifier:GetAbility():GetSpecialValueFor("spell_power")
					end
				end

				-- If spellpower was accumulated, reduce the damage
				if rapier_spellpower > 0 then
					keys.damage = keys.damage / (1 + rapier_spellpower * 0.01)
				end
			end
		end

		-- If the attacker has mutation killstreak stacks and the distance is over the cap, remove the damage bonus from it
		if attacker:HasModifier("modifier_mutation_kill_streak_power") then
			local distance = (attacker:GetAbsOrigin() - victim:GetAbsOrigin()):Length2D()
			if distance > IMBA_DAMAGE_EFFECTS_DISTANCE_CUTOFF then
				local ksp = attacker:FindModifierByName("modifier_mutation_kill_streak_power")
				-- Note that this formula isn't truly accurate in modifying damage as if there were no killstreak stacks
				-- If a more precise formula is known, use that instead
				-- Note that stacking this with arcane rapiers basically turns your global damage into absolute garbage
				keys.damage = keys.damage / ((ksp.damage_increase * ksp:GetStackCount() * 0.01) + 1)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, victim, keys.damage, nil)
			end
		end

		-- Magic shield damage prevention
		if victim:HasModifier("modifier_item_imba_initiate_robe_stacks") and victim:GetTeam() ~= attacker:GetTeam() then

			-- Parameters
			local shield_stacks = victim:GetModifierStackCount("modifier_item_imba_initiate_robe_stacks", nil)

			-- Ignore part of incoming damage
			if keys.damage > shield_stacks then
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, victim, shield_stacks, nil)
				victim:RemoveModifierByName("modifier_item_imba_initiate_robe_stacks")
				keys.damage = keys.damage - shield_stacks
			else
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, victim, keys.damage, nil)
				victim:SetModifierStackCount("modifier_item_imba_initiate_robe_stacks", victim, math.floor(shield_stacks - keys.damage))
				keys.damage = 0
			end
		end

		-- Magic barrier (pipe/hood) damage mitigation
		if victim:HasModifier("modifier_imba_hood_of_defiance_active_shield") and victim:GetTeam() ~= attacker:GetTeam() and damage_type == DAMAGE_TYPE_MAGICAL then
			local shield_modifier = victim:FindModifierByName("modifier_imba_hood_of_defiance_active_shield")

			if shield_modifier and shield_modifier.AbsorbDamage then
				keys.damage = shield_modifier:AbsorbDamage(keys.damage)
			end
		end

		-- Reaper's Scythe kill credit logic
		if victim:HasModifier("modifier_imba_reapers_scythe") then

			-- Check if this is the killing blow
			local victim_health = victim:GetHealth()
			if keys.damage >= victim_health then

				-- Prevent death and trigger Reaper's Scythe's on-kill effects
				local scythe_modifier = victim:FindModifierByName("modifier_imba_reapers_scythe")
				local scythe_caster = false
				if scythe_modifier then
					scythe_caster = scythe_modifier:GetCaster()
				end
				if scythe_caster then
					keys.damage = 0

					-- Find the Reaper's Scythe ability
					local ability = scythe_caster:FindAbilityByName("imba_necrolyte_reapers_scythe")
					if not ability then return nil end
					victim:RemoveModifierByName("modifier_imba_reapers_scythe")
					victim:AddNewModifier(scythe_caster, ability, "modifier_imba_reapers_scythe_respawn", {})

					-- Attempt to kill the target, crediting it to the caster of Reaper's Scythe
					ApplyDamage({attacker = scythe_caster, victim = victim, ability = ability, damage = victim:GetHealth() + 10, damage_type = DAMAGE_TYPE_PURE, damage_flag = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK})
				end
			end
		end

		-- Cheese auto-healing
		if victim:HasModifier("modifier_imba_cheese_death_prevention") then
			-- Only apply if it was a real hero
			if victim:IsRealHero() then

				-- Check if death is imminent
				local victim_health = victim:GetHealth()
				if keys.damage >= victim_health and not ( victim:HasModifier("modifier_imba_dazzle_shallow_grave") or victim:HasModifier("modifier_imba_dazzle_nothl_protection") ) then

					-- Find the cheese item handle
					local cheese_modifier = victim:FindModifierByName("modifier_imba_cheese_death_prevention")
					local item = cheese_modifier:GetAbility()

					-- Spend a charge of Cheese if the cooldown is ready
					if item:IsCooldownReady() then

						-- Reduce damage by your remaining amount of health
						keys.damage = keys.damage - victim_health

						-- Play sound
						victim:EmitSound("DOTA_Item.Cheese.Activate")

						-- Fully heal yourself
						victim:Heal(victim:GetMaxHealth(), victim)
						victim:GiveMana(victim:GetMaxMana())

						-- Spend a charge
						item:SetCurrentCharges( item:GetCurrentCharges() - 1 )

						-- If this was the last charge, remove the item
						if item:GetCurrentCharges() == 0 then
							victim:RemoveItem(item)
						end
					end
				end
			end

		end

		-- Mirana's Sacred Arrow On The Prowl guaranteed critical
		if victim:HasModifier("modifier_imba_sacred_arrow_stun") then
			local modifier_stun_handler = victim:FindModifierByName("modifier_imba_sacred_arrow_stun")
			if modifier_stun_handler then

				-- Get the modifier's ability and caster
				local stun_ability = modifier_stun_handler:GetAbility()
				local caster = modifier_stun_handler:GetCaster()
				if stun_ability and caster then
					local should_crit = false

					-- If the table doesn't exist yet, initialize it
					if not modifier_stun_handler.enemy_attackers then
						modifier_stun_handler.enemy_attackers = {}
					end

					-- Check for the attacker in the attackers table
					local attacker_found = false

					if modifier_stun_handler.enemy_attackers[attacker:entindex()] then
						attacker_found = true
					end

					-- If this attacker haven't attacked the stunned target yet, guarantee a critical
					if not attacker_found then

						should_crit = true

						-- Add the attacker to the attackers table
						modifier_stun_handler.enemy_attackers[attacker:entindex()] = true
					end

					-- #2 Talent: Sacred Arrows allow allies to trigger On The Prowls' critical as long as there is at least enough seconds remaining to the stun
					if caster:HasTalent("special_bonus_imba_mirana_2") and not should_crit then

						-- Talent specials
						local allow_crit_time = caster:FindTalentValue("special_bonus_imba_mirana_2")

						-- Check if the remaining time is above the threshold
						local remaining_stun_time = modifier_stun_handler:GetRemainingTime()

						if remaining_stun_time >= allow_crit_time then
							should_crit = true
						end
					end

					if should_crit then
						-- Get the critical damage count
						local on_prow_crit_damage_pct = stun_ability:GetSpecialValueFor("on_prow_crit_damage_pct")

						-- Increase damage and show the critical attack event
						keys.damage = keys.damage * (1 + on_prow_crit_damage_pct * 0.01)

						-- Overhead critical event
						SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, victim, keys.damage, nil)
					end
				end
			end
		end

		-- Axe Battle Hunger kill credit
		if victim:GetTeam() == attacker:GetTeam() and keys.damage > 0 and attacker:HasModifier("modifier_imba_battle_hunger_debuff_dot") then
			-- Check if this is the killing blow
			local victim_health = victim:GetHealth()
			if keys.damage >= victim_health then
				-- Prevent death and trigger Reaper's Scythe's on-kill effects
				local battle_hunger_modifier = victim:FindModifierByName("modifier_imba_battle_hunger_debuff_dot")
				local battle_hunger_caster = false
				local battle_hunger_ability = false
				if battle_hunger_modifier then
					battle_hunger_caster = battle_hunger_modifier:GetCaster()
					battle_hunger_ability = battle_hunger_modifier:GetAbility()
				end
				if battle_hunger_caster then
					keys.damage = 0

					if not battle_hunger_ability then return nil end

					-- Attempt to kill the target, crediting it to Axe
					ApplyDamage({attacker = battle_hunger_caster, victim = victim, ability = battle_hunger_ability, damage = victim:GetHealth() + 10, damage_type = DAMAGE_TYPE_PURE, damage_flag = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK})
				end
			end
		end

		-- Kunkka Oceanids Blessing talent damage negation, applying true PURE damage towards the target
		if victim:HasModifier("modifier_imba_tidebringer_cleave_hit_target") then
			local tidebringer_ability = attacker:FindAbilityByName("imba_kunkka_tidebringer")
			local tidebringer_modifier = victim:FindModifierByName("modifier_imba_tidebringer_cleave_hit_target")
			if tidebringer_ability then
				keys.damage = 0

				local scythe_modifier = victim:FindModifierByName("modifier_imba_reapers_scythe")
				if scythe_modifier then return nil end
				victim:RemoveModifierByName("modifier_imba_tidebringer_cleave_hit_target")
			end
		end
	end
	return true
end

-- MAKE HEALTH REGEN AMP CODE HERE
--[[
function GameMode:HealingFilter( filterTable )
	local nHeal = filterTable["heal"]
	if filterTable["entindex_healer_const"] == nil then
		return true
	end

	local hHealingHero = EntIndexToHScript( filterTable["entindex_healer_const"] )
	if nHeal > 0 and hHealingHero ~= nil and hHealingHero:IsRealHero() then
		for _,Zone in pairs( self.Zones ) do
			if Zone:ContainsUnit( hHealingHero ) then
				Zone:AddStat( hHealingHero:GetPlayerID(), ZONE_STAT_HEALING, nHeal )
				return true
			end
		end
	end

	return true
end
--]]
