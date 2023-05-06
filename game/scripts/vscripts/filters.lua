-- TODO: FORMAT FILTERS CODE IT LOOKS LIKE SHIT

-- Testing a gold reduction on hero kills to reduce "snowballing"; 1 is default
local HERO_KILL_MULTIPLIER = 0.6

-- Gold gain filter function
function GameMode:GoldFilter(keys)
	-- reason_const		12
	-- reliable			1
	-- player_id_const	0
	-- gold				141

	-- Ignore negative gold values
	if keys.gold <= 0 then
		return false
	end

	-- Gold from abandoning players does not get multiplied
	if keys.reason_const == DOTA_ModifyGold_AbandonedRedistribute or keys.reason_const == DOTA_ModifyGold_GameTick then
		return true
	end

	-- if keys.reason_const == DOTA_ModifyGold_HeroKill then
	-- return not IMBA_GOLD_SYSTEM
	-- end

	if PlayerResource:GetPlayer(keys.player_id_const) == nil then return end
	local player = PlayerResource:GetPlayer(keys.player_id_const)

	-- player can be nil for some reason
	if player then
		local hero = player:GetAssignedHero()
		if hero == nil then return end

		-- Hand of Midas gold bonus (let's make it not affect hero kills)
		if hero:HasItemInInventory("item_imba_hand_of_midas") and hero:HasModifier("modifier_item_imba_hand_of_midas") and keys.reason_const ~= DOTA_ModifyGold_HeroKill then
			keys.gold = keys.gold * (1 + (GetAbilitySpecial("item_imba_hand_of_midas", "passive_gold_bonus") / 100))
		end

		-- Lobby options adjustment
		local custom_gold_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "bounty_multiplier")["1"]) or 100

		-- Test gold reduction for hero kills
		if keys.reason_const == DOTA_ModifyGold_HeroKill then
			custom_gold_bonus = custom_gold_bonus * HERO_KILL_MULTIPLIER
		end

		keys.gold = keys.gold * custom_gold_bonus / 100

		-- local reliable = false
		-- if keys.reason_const == DOTA_ModifyGold_RoshanKill or keys.reason_const == DOTA_ModifyGold_CourierKill or keys.reason_const == DOTA_ModifyGold_Building then
		-- reliable = true
		-- end

		if keys.reason_const == DOTA_ModifyGold_Unspecified then return true end

		-- Testing gold multiplier based on networth differentials
		local ally_networth = 0
		local enemy_networth = 0

		for num = 1, PlayerResource:GetPlayerCountForTeam(player:GetTeam()) do
			ally_networth = ally_networth + PlayerResource:GetNetWorth(PlayerResource:GetNthPlayerIDOnTeam(player:GetTeam(), num))
		end

		for num = 1, PlayerResource:GetPlayerCountForTeam(hero:GetOpposingTeamNumber()) do
			enemy_networth = enemy_networth + PlayerResource:GetNetWorth(PlayerResource:GetNthPlayerIDOnTeam(hero:GetOpposingTeamNumber(), num))
		end

		local networth_difference = enemy_networth - ally_networth

		-- Let's try linear scaling with max of 2x gold granted at a 125k networth differential (IDK good numbers without more input)
		if networth_difference > 0 then
			keys.gold = keys.gold * math.min(1 + (networth_difference / 125000), 2)
		end
	end

	return true
end

-- Experience gain filter function
function GameMode:ExperienceFilter(keys)
	-- reason_const		1 (DOTA_ModifyXP_CreepKill)
	-- experience		130
	-- player_id_const	0

	-- Ignore negative experience values
	if keys.experience < 0 then
		return false
	end

	local custom_xp_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "exp_multiplier")["1"])

	-- Test exp reduction for hero kills
	if keys.reason_const == DOTA_ModifyXP_HeroKill then
		custom_xp_bonus = custom_xp_bonus * HERO_KILL_MULTIPLIER
	end

	if custom_xp_bonus ~= nil then
		keys.experience = keys.experience * (custom_xp_bonus / 100)
	end

	-- Testing exp multiplier based on networth differentials
	local player = PlayerResource:GetPlayer(keys.player_id_const)

	if player == nil then return end

	local hero = player:GetAssignedHero()

	if hero == nil then return end

	local ally_level = 0
	local enemy_level = 0

	for num = 1, PlayerResource:GetPlayerCountForTeam(player:GetTeam()) do
		ally_level = ally_level + PlayerResource:GetLevel(PlayerResource:GetNthPlayerIDOnTeam(player:GetTeam(), num))
	end

	for num = 1, PlayerResource:GetPlayerCountForTeam(hero:GetOpposingTeamNumber()) do
		enemy_level = enemy_level + PlayerResource:GetLevel(PlayerResource:GetNthPlayerIDOnTeam(hero:GetOpposingTeamNumber(), num))
	end

	local level_difference = enemy_level - ally_level

	-- Let's try linear scaling with max of 2x experience granted at a 60 level differential (IDK good numbers without more input)
	if level_difference > 0 then
		keys.experience = keys.experience * math.min(1 + (level_difference / 60), 2)
	end

	--	if PlayerResource:GetPlayer(keys.player_id_const) == nil then return true end
	--	local player = PlayerResource:GetPlayer(keys.player_id_const)
	--	local hero = player:GetAssignedHero()

	-- if MAX_LEVEL and MAX_LEVEL[GetMapName()] and hero:GetLevel() >= MAX_LEVEL[GetMapName()] then

	-- end

	return true
end

-- Modifier gained filter function
function GameMode:ModifierFilter(keys)
	-- entindex_parent_const	215
	-- entindex_ability_const	610
	-- duration					-1
	-- entindex_caster_const	215
	-- name_const				modifier_imba_roshan_rage_stack

	if IsServer() then
		local disableHelpResult = DisableHelp.ModifierGainedFilter(keys)
		if disableHelpResult == false then
			return false
		end

		local modifier_owner = EntIndexToHScript(keys.entindex_parent_const)
		local modifier_name = keys.name_const
		local modifier_caster
		local modifier_class
		local modifier_ability

		if keys.entindex_caster_const then
			modifier_caster = EntIndexToHScript(keys.entindex_caster_const)
		else
			return true
		end

		if keys.entindex_ability_const then
			modifier_ability = EntIndexToHScript(keys.entindex_ability_const)
		end

		-- volvo bugfix
		if modifier_name == "modifier_datadriven" then
			return false
		end

		-- don't add buyback penalty
		if modifier_name == "modifier_buyback_gold_penalty" then
			return false
		end

		-- setting bonus strength to 0 ain't working, let's go the hard way then
		if modifier_name == "modifier_item_minotaur_horn" then
			return false
		end

		-------------------------------------------------------------------------------------------------
		-- Roshan special modifier rules
		-------------------------------------------------------------------------------------------------

		-- if modifier_owner:IsRoshan() then
		-- -- Ignore stuns
		-- print("Roshan modifier name:", modifier_name)
		-- if modifier_name == "modifier_stunned" then
		-- return false
		-- end

		-- -- Halve the duration of everything else
		-- if modifier_caster ~= modifier_owner and keys.duration > 0 then
		-- keys.duration = keys.duration / (100 / 50)
		-- end

		-- -- Fury swipes capping
		-- if modifier_owner:GetModifierStackCount("modifier_ursa_fury_swipes_damage_increase", nil) > 5 then
		-- modifier_owner:SetModifierStackCount("modifier_ursa_fury_swipes_damage_increase", nil, 5)
		-- end

		-- if modifier_name == "modifier_doom_bringer_infernal_blade_burn" or modifier_name == "modifier_viper_nethertoxin" or modifier_name == "modifier_pangolier_gyroshell_stunned" or modifier_name == "modifier_pangolier_gyroshell_bounce" then
		-- return false
		-- end
		-- end

		-- -- add particle or sound playing to notify
		-- if modifier_owner:HasModifier("modifier_item_imba_jarnbjorn_static") or modifier_owner:HasModifier("modifier_item_imba_heavens_halberd_ally_buff") then
		-- for _, modifier in pairs(IMBA_DISARM_IMMUNITY) do
		-- if modifier_name == modifier then
		-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_EVADE, modifier_owner, 0, nil)
		-- return false
		-- end
		-- end
		-- end

		-- Bringing Helm of the Undying back but giving it Wraith King's Reincarnation Wraith mechanics for balance
		if modifier_name == "modifier_item_helm_of_the_undying_active" then
			-- "An ally enters Death Delay when their health reaches 1, unless they are affected by Shallow Grave, Battle Trance, Wraith Delay, or have Reincarnation."
			if modifier_owner:HasModifier("modifier_imba_dazzle_shallow_grave") or
				modifier_owner:HasModifier("modifier_imba_dazzle_nothl_protection") or
				modifier_owner:HasModifier("modifier_imba_battle_trance_720") or
				modifier_owner:HasModifier("modifier_imba_reincarnation_wraith_form") or
				modifier_owner:HasModifier("modifier_item_imba_bloodstone_active_720") then
				return false
			else
				modifier_owner:AddNewModifier(modifier_owner, modifier_ability, "modifier_item_imba_helm_of_the_undying_addendum", { duration = keys.duration + FrameTime() })
			end
		end

		-- Deactivate Tusk's Snowball so you don't allow multiple casting while Snowball is active (resulting in permanently lingering particles)
		if modifier_name == "modifier_tusk_snowball_movement" then
			if modifier_owner:FindAbilityByName("tusk_snowball") then
				modifier_owner:FindAbilityByName("tusk_snowball"):SetActivated(false)
				Timers:CreateTimer(9.0, function()
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

		if IMBA_RUNE_SYSTEM == false then
			if string.find(modifier_name, "modifier_rune_") then
				local rune_name = string.gsub(modifier_name, "modifier_rune_", "")
				ImbaRunes:PickupRune(rune_name, modifier_owner, false)

				return false
			end
		end

		if modifier_name == "modifier_bottle_regeneration" then
			local duration = modifier_ability:GetSpecialValueFor("restore_time")

			modifier_owner:AddNewModifier(modifier_owner, modifier_ability, "modifier_item_imba_bottle_heal", { duration = duration })

			return false
		end

		if modifier_owner:HasModifier("modifier_no_pvp") and modifier_owner:GetOpposingTeamNumber() == modifier_caster:GetTeamNumber() and not modifier_name == "modifier_truesight" then
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_EVADE, modifier_owner, 0, nil)
			return false
		end

		return true
	end
end

-- Item added to inventory filter
function GameMode:ItemAddedFilter(keys)
	-- Typical keys:
	-- inventory_parent_entindex_const: 852
	-- item_entindex_const: 1519
	-- item_parent_entindex_const: -1
	-- suggested_slot: -1
	local unit = EntIndexToHScript(keys.inventory_parent_entindex_const)
	if unit == nil then return end
	local item = EntIndexToHScript(keys.item_entindex_const)
	if item == nil then return end

	-- This is currently done by default and does not use the ENABLE_TPSCROLL_ON_FIRST_SPAWN variable
	-- if item:GetAbilityName() == "item_tpscroll" and item:GetPurchaser() == nil then
	-- item:EndCooldown()

	-- return ENABLE_TPSCROLL_ON_FIRST_SPAWN

	-- -- return false to remove it
	-- --		return false
	-- end

	local item_name = nil

	-- this event is broken in dota, so calling it from here instead (Credits: Pohka)
	if item.OnItemEquipped ~= nil then
		item:OnItemEquipped(item)
	end

	if item:GetName() then
		item_name = item:GetName()
	end

	-- Custom Rune System
	if string.find(item_name, "item_imba_rune_") and unit:IsRealHero() then
		ImbaRunes:PickupRune(item_name, unit)
		return false
	end

	-------------------------------------------------------------------------------------------------
	-- Aegis of the Immortal pickup logic
	-------------------------------------------------------------------------------------------------
	if item_name == "item_aegis" then
		-- If this is a player, do Aegis stuff
		if unit:IsRealHero() and not unit:HasModifier("modifier_item_imba_aegis") then
			local line_duration = 7

			if unit:GetTeamNumber() ~= _G.GAME_ROSHAN_KILLER_TEAM and _G.GAME_ROSHAN_KILLER_TEAM ~= 0 then
				local color = "white"

				if unit.GetPlayerID and PLAYER_COLORS[unit:GetPlayerID()] then
					color = rgbToHex(PLAYER_COLORS[unit:GetPlayerID()])
				end

				Notifications:BottomToAll({ hero = unit:GetName(), duration = line_duration })
				Notifications:BottomToAll({ text = PlayerResource:GetPlayerName(unit:GetPlayerID()) .. " ", duration = line_duration, style = { color = color }, continue = true })
				Notifications:BottomToAll({ text = "#imba_player_aegis_message_snatch", duration = line_duration, continue = true })

				_G.GAME_ROSHAN_KILLER_TEAM = 0
			else
				Notifications:BottomToAll({ hero = unit:GetName(), duration = line_duration })
				Notifications:BottomToAll({ text = PlayerResource:GetPlayerName(unit:GetPlayerID()) .. " ", duration = line_duration, style = { color = color }, continue = true })
				Notifications:BottomToAll({ text = "#imba_player_aegis_message", duration = line_duration, continue = true })
			end

			-- I get what you were trying to do but none of this works properly
			-- -- With no timer, combat events notification is not triggered
			-- if unit:GetNumItemsInInventory() >= 6 then
			-- unit:AddNewModifier(unit, item, "modifier_item_imba_aegis",{})
			-- else
			-- Timers:CreateTimer(1.0, function()
			-- if item then
			-- if item.GetContainer then
			-- UTIL_Remove(item:GetContainer())
			-- end

			-- UTIL_Remove(item)
			-- end

			-- -- in the rare case where the player would die within 1 second after picked the aegis
			-- if unit:IsAlive() then
			-- unit:AddNewModifier(unit, item, "modifier_item_imba_aegis",{})
			-- end
			-- end)
			-- end

			-- return true

			unit:AddNewModifier(unit, item, "modifier_item_imba_aegis", {})
			return false
		else
			local drop = CreateItem("item_imba_aegis", nil, nil)
			CreateItemOnPositionSync(unit:GetAbsOrigin(), drop)
			drop:LaunchLoot(false, 250, 0.5, unit:GetAbsOrigin() + RandomVector(100))

			UTIL_Remove(item:GetContainer())
			UTIL_Remove(item)
			return false
		end
		-- return true

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
		if unit:IsRealHero() or (unit:GetClassname() == "npc_dota_lone_druid_bear") then
			-- If the rapier has a purchaser (WARNING: if the courier buys it, item:GetPurchaser() is nil), and someone from the opposite team picks it up, then it becomes a free rapier
			-- Gonna make a pretty bold assumption here; there is the edge case where someone's inventory is full, they buy rapiers from courier which then drop the rapiers, and then someone from the enemy team picks it up; this code would then make THEM the original purchaser
			-- ...well I'm just trying to make rapiers not disappear first
			if not item:GetPurchaser() then
				item:SetPurchaser(unit)
			end

			-- Cursed Rapiers should not be droppable at all after first drop (due to abuse like Spectre ult)
			if item:GetName() == "item_imba_rapier_cursed" then
				item:SetDroppable(false)
			end

			if item:GetPurchaser() and item:GetPurchaser():GetTeamNumber() ~= unit:GetTeamNumber() then
				item.free = true
			end

			-- If the rapier is picked up by an enemy after it was dropped, then it is no longer droppable
			if item.free then
				item:SetPurchaser(nil)
				item:SetPurchaseTime(0)
				item:SetDroppable(false)
			end

			local rapier_amount = 0
			local rapier_2_amount = 0
			local rapier_magic_amount = 0
			local rapier_magic_2_amount = 0

			for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
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

			-- This handles combining rapiers or soemthing
			if ((item_name == "item_imba_rapier") and (rapier_amount == 2)) or
				((item_name == "item_imba_rapier_magic") and (rapier_magic_amount == 2)) or
				((item_name == "item_imba_rapier_2") and (rapier_magic_2_amount >= 1)) or
				((item_name == "item_imba_rapier_magic_2") and (rapier_2_amount >= 1)) then
				return true
			else
				DisplayError(unit:GetPlayerID(), "#dota_hud_error_cant_item_enough_slots")
			end
		end

		if unit:IsIllusion() or unit:IsTempestDouble() or unit:IsHero() then
			return true
		else
			unit:DropItem(nil, item_name, true)
		end

		return false
	end

	----------------------------------------------------------------
	-- Gem of True Sight Logic (mostly for Soul of Truth merging) --
	----------------------------------------------------------------

	if item:GetName() == "item_imba_gem" and not unit:IsCourier() then
		item:SetPurchaser(unit)
	end

	return true
end

-- Order filter function
function GameMode:OrderFilter(keys)
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

	-- Don't let couriers be controlled when multi-selected
	if keys.units then
		for k, v in pairs(keys.units) do
			if k ~= "0" and EntIndexToHScript(v) and EntIndexToHScript(v):IsCourier() then
				return false
			end
		end
	end

	-- Do special handlings if shift-casted only here! The event gets fired another time if the caster
	-- is actually doing this order
	if keys.queue == 1 then
		return true
	end

	local target = keys.entindex_target ~= 0 and EntIndexToHScript(keys.entindex_target) or nil
	local ability = keys.entindex_ability ~= 0 and EntIndexToHScript(keys.entindex_ability) or nil

	local disableHelpResult = DisableHelp.ExecuteOrderFilter(keys.order_type, ability, target, unit)
	if disableHelpResult == false then
		return false
	end

	--	if keys.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
	--		local ability = EntIndexToHScript(keys["entindex_ability"])
	--		if unit:IsRealHero() then
	--			local companions = FindUnitsInRadius(unit:GetTeamNumber(), Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	--			for _, companion in pairs(companions) do
	--				if companion:GetUnitName() == "npc_donator_companion" and companion:GetOwner() == unit then
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

	-- The "(IMBA_PUNISHED and unit.GetPlayerID and IMBA_PUNISHED[PlayerResource:GetSteamAccountID(unit:GetPlayerID())])" line is for "banning" units without going into the database (or I guess if it goes down?)
	if api:GetDonatorStatus(keys.issuer_player_id_const) == 10 or (IMBA_PUNISHED and unit.GetPlayerID and IMBA_PUNISHED[PlayerResource:GetSteamAccountID(unit:GetPlayerID())]) then
		return false
	end

	if keys.order_type == DOTA_UNIT_ORDER_GLYPH then
		CombatEvents("generic", "glyph", unit)
	end

	-- credits Overthrow 2.0 (Dota2Unofficial)
	if keys.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM then
		if not target then return true end
		local pickedItem = target:GetContainedItem()
		if not pickedItem then return true end

		local itemName = pickedItem:GetAbilityName()

		if itemName == "item_aegis" then
			if not unit:IsRealHero() then
				DisplayError(keys.issuer_player_id_const, "#dota_hud_error_non_hero_cant_pickup_aegis")
				return false
			elseif unit:HasModifier("modifier_item_imba_aegis") then
				DisplayError(keys.issuer_player_id_const, "#dota_hud_error_already_have_aegis")
				return false
			end
		end
	end

	-- Turbo Courier filters
	if unit:IsCourier() then
		-- Timers:CreateTimer(FrameTime(), function()
		-- if unit and not unit:IsNull() and keys.issuer_player_id_const then
		-- unit.last_idle_change_time 			= unit:GetLastIdleChangeTime()
		-- unit.issuer_player_id_const			= keys.issuer_player_id_const
		-- end
		-- end)

		local ability = EntIndexToHScript(keys["entindex_ability"])

		-- Don't let frozen players mess with courier either
		if api:GetDonatorStatus(keys.issuer_player_id_const) == 10 or (IMBA_PUNISHED and IMBA_PUNISHED[PlayerResource:GetSteamAccountID(keys.issuer_player_id_const)]) then
			return false
		end

		-- Rough code to drop neutral items on the ground
		if IsNearFountain(unit:GetAbsOrigin(), 1200) and ability and ability.GetName and ability:GetName() == "courier_return_stash_items" then
			for i = 0, 8 do
				if unit:GetItemInSlot(i) and unit:GetItemInSlot(i).GetPurchaser and not unit:GetItemInSlot(i):GetPurchaser() then
					unit:DropItemAtPositionImmediate(unit:GetItemInSlot(i), unit:GetAbsOrigin() + RandomVector(RandomInt(0, 100)))
				end
			end
		end

		if keys.issuer_player_id_const then
			-- Attempts at locking courier to one player at a time
			--  How it works: When the player issues a transfer item command, the courier will have its issuer_player_id_const variable set to keys.issuer_player_id_const, which will only turn nil once that player issues a different courier command OR the courier inventory contents change
			-- Yes, even with this there may be potential abuse...
			if unit.issuer_player_id_const then
				if keys.issuer_player_id_const == unit.issuer_player_id_const then
					unit.issuer_player_id_const = nil
				elseif keys.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM or keys.order_type == DOTA_UNIT_ORDER_SELL_ITEM then
					return true
				else
					DisplayError(keys.issuer_player_id_const, "Courier is currently delivering items to " .. PlayerResource:GetPlayerName(unit.issuer_player_id_const))
					return false
				end
			end

			-- allow buy order!
			if keys.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM or keys.order_type == DOTA_UNIT_ORDER_SELL_ITEM or keys.order_type == DOTA_UNIT_ORDER_DISASSEMBLE_ITEM or keys.order_type == DOTA_UNIT_ORDER_MOVE_ITEM or keys.order_type == DOTA_UNIT_ORDER_SET_ITEM_COMBINE_LOCK then
				return true
			end

			if (ability and ability.GetName and ability:GetName() ~= "" and not ability:IsItem()) then
				--				print("Valid Ability")
				if unit:HasAbility(ability:GetName()) then
					if (ability:GetName() == "courier_transfer_items" or "courier_take_stash_and_transfer_items") then
						if not unit.issuer_player_id_const then
							unit.issuer_player_id_const = keys.issuer_player_id_const
							return true
						end
					else
						return true
					end
				end
			else
				-- Prevent the courier from moving on right-click
				DisplayError(keys.issuer_player_id_const, "#dota_hud_error_control_courier_with_abilities_only")

				return false
			end

			-- Prevent the courier from moving if already moving (therefore being used by another player)
			--			if unit:IsMoving() then
			--				DisplayError(keys.issuer_player_id_const, "#dota_hud_error_courier_in_use")

			--				return false
			--			end
		end

		--		print("Return false 3")
		return false
	end

	------------------------------------------------------------------------------------
	-- Prevent Buyback during reincarnation
	------------------------------------------------------------------------------------
	if keys.order_type == DOTA_UNIT_ORDER_BUYBACK then
		if unit:IsReincarnating() then
			return false
		else
			-- Trying to add a custom buyback respawn timer penalty modifier
			-- Doing a rough safeguard using gold so people don't get the modifier when spamming the buyback button a frame before they respawn like an idiot
			local gold_before_buyback = unit:GetGold() or -1

			Timers:CreateTimer(FrameTime(), function()
				-- If these checks pass, this assumes that the person actually bought back
				if unit:IsAlive() and gold_before_buyback >= (unit:GetGold() or 0) then
					unit:AddNewModifier(unit, nil, "modifier_buyback_penalty", {})
				end
			end)
		end
	end

	------------------------------------------------------------------------------------
	-- Witch Doctor Death Ward handler
	------------------------------------------------------------------------------------
	if unit:HasModifier("modifier_imba_death_ward") then
		if keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
			local death_ward_mod = unit:FindModifierByName("modifier_imba_death_ward")
			death_ward_mod.attack_target = EntIndexToHScript(keys.entindex_target)
			return true
		else
			return nil
		end
	end

	if unit:HasModifier("modifier_imba_death_ward_caster") then
		if keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
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
		local target = EntIndexToHScript(keys["entindex_target"])

		if ability:GetAbilityName() == "doom_bringer_devour" then
			if target:IsRoshan() then
				DisplayError(unit:GetPlayerID(), "#dota_hud_error_cant_devour_roshan")
				return false
			end
		elseif ability:GetAbilityName() == "life_stealer_infest" or ability:GetAbilityName() == "imba_life_stealer_infest" then
			if target:GetUnitName() == "npc_dota_mutation_golem" then
				DisplayError(unit:GetPlayerID(), "#dota_hud_error_cant_infest_bob")
				return false
			end
		elseif ability:GetAbilityName() == "imba_riki_blink_strike" then
			ability.thinker = unit:AddNewModifier(unit, ability, "modifier_imba_blink_strike_thinker", { target = keys.entindex_target })
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

			local nearby_units = FindUnitsInRadius(unit:GetTeamNumber(), caster_loc, nil, math.max(target_distance, (ability:GetCastRange(caster_loc, unit)) + GetCastRangeIncrease(unit)), ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
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
			local range = ability.BaseClass.GetCastRange(ability, ability:GetCursorPosition(), unit) + GetCastRangeIncrease(unit)
			if unit:HasModifier("modifier_imba_ebb_and_flow_tide_low") or unit:HasModifier("modifier_imba_ebb_and_flow_tsunami") then
				range = range + ability:GetSpecialValueFor("tide_low_range")
			end
			local distance = (unit:GetAbsOrigin() - Vector(keys.position_x, keys.position_y, keys.position_z)):Length2D()

			if (range >= distance) then
				unit:AddNewModifier(unit, ability, "modifier_imba_torrent_cast", { duration = 0.41 })
			end
		end

		-- Kunkka Tidebringer cast-handling
		if ability ~= nil and ability:GetAbilityName() == "imba_kunkka_tidebringer" then
			ability.manual_cast = true
		end

		-- Give Lone Druid's Spirit Bear the Cursed Fountain debuff if applicable (doesn't get picked up by any of the spawn filters)
		if ability ~= nil and ability:GetAbilityName() == "lone_druid_spirit_bear" and unit:HasModifier("modifier_imba_cursed_fountain") then
			for _, search_unit in pairs(FindUnitsInRadius(unit:GetTeamNumber(), Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)) do
				if string.find(search_unit:GetUnitName(), "npc_dota_lone_druid_bear") and search_unit.GetOwner and search_unit:GetOwner() == unit then
					local cursed_fountain_modifier = search_unit:AddNewModifier(unit:FindModifierByName("modifier_imba_cursed_fountain"):GetCaster(), unit:FindModifierByName("modifier_imba_cursed_fountain"):GetAbility(), "modifier_imba_cursed_fountain", {})

					if cursed_fountain_modifier then
						cursed_fountain_modifier:SetStackCount(unit:FindModifierByName("modifier_imba_cursed_fountain"):GetStackCount())
					end
				end
			end
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
			unit:AddNewModifier(unit, ability, "modifier_imba_focused_detonate", { duration = 0.2 })
		end

		-- Mirana's Leap talent cast-handling
		if ability ~= nil and ability:GetAbilityName() == "imba_mirana_leap" and unit:HasTalent("special_bonus_imba_mirana_7") then
			unit:AddNewModifier(unit, ability, "modifier_imba_leap_talent_cast_angle_handler", { duration = FrameTime() })
		end
	end

	-- -- Meepo item handle
	-- if unit:GetUnitName() == "npc_dota_hero_meepo" then
	-- local meepo_table = Entities:FindAllByName("npc_dota_hero_meepo")
	-- local ability = EntIndexToHScript(keys.entindex_ability)
	-- if ability then
	-- for m = 1, #meepo_table do
	-- if meepo_table[m]:GetTeamNumber() == unit:GetTeamNumber() then
	-- if keys.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
	-- if ability:GetName() == "item_imba_black_king_bar" then
	-- local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() -1)
	-- meepo_table[m]:AddNewModifier(meepo_table[m], ability, "modifier_black_king_bar_immune", {duration = duration})
	-- elseif ability:GetName() == "item_imba_white_queen_cape" then
	-- local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() -1)
	-- meepo_table[m]:AddNewModifier(meepo_table[m], ability, "modifier_black_king_bar_immune", {duration = duration})
	-- end
	-- elseif keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET then
	-- if ability:GetName() == "item_imba_black_queen_cape" then
	-- local duration = ability:GetLevelSpecialValueFor("bkb_duration", ability:GetLevel() -1)
	-- meepo_table[m]:AddNewModifier(meepo_table[m], nil, "modifier_imba_black_queen_cape_active_bkb", {duration = duration})
	-- end
	-- end
	-- end
	-- end
	-- end
	-- end

	if GetMapName() == Map1v1() then
		if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
			local target = EntIndexToHScript(keys["entindex_target"])
			if target:GetUnitName() == "npc_dota_goodguys_healers" or target:GetUnitName() == "npc_dota_badguys_healers" then
				DisplayError(unit:GetPlayerID(), "#dota_hud_error_cant_shrine_1v1")
				return false
			end
		end
	end

	if keys.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM then
		local item = keys.entindex_ability
		if item == nil then return true end

		if BANNED_ITEMS[GetMapName()] then
			for _, banned_item in pairs(BANNED_ITEMS[GetMapName()]) do
				--				print(banned_item)
				--				print(self.itemIDs[item])
				if self.itemIDs[item] == banned_item then
					DisplayError(unit:GetPlayerID(), "#dota_hud_error_cant_purchase_1v1")
					return false
				end
			end
		end

		unit.reset_turbo_deliver = true
	end

	if keys.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM then
		local unit = EntIndexToHScript(keys.units["0"])
		if unit == nil then return false end
		local drop = EntIndexToHScript(keys["entindex_target"])
		local item

		if drop ~= nil then
			if drop.GetContainedItem ~= nil then
				if drop:GetContainedItem() ~= nil then
					item = drop:GetContainedItem()
				end
			end
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

	------------------------------------------------------------------------------------
	-- Troll Warlord Battle Trance (7.20 Version) Order Restrictions
	------------------------------------------------------------------------------------
	-- This only has to be put in here cause of dumb stop/interrupt orders not having a good state to prevent bricking up

	-- Based on very quick tests of vanilla, Troll Warlord can still buy/sell items while under targetted Battle Trance
	if unit:GetModifierStackCount("modifier_imba_battle_trance_720", unit) == 1 then
		-- First check if the ability is something Troll Warlord is allowed to cast
		if keys.order_type >= DOTA_UNIT_ORDER_CAST_POSITION and keys.order_type <= DOTA_UNIT_ORDER_CAST_TOGGLE then
			local valid_abilities =
			{
				"imba_troll_warlord_berserkers_rage",
				"imba_troll_warlord_whirling_axes_melee",
				"imba_troll_warlord_whirling_axes_ranged"
			}

			if keys.entindex_ability and EntIndexToHScript(keys.entindex_ability) then
				for ability = 1, #valid_abilities do
					if EntIndexToHScript(keys.entindex_ability):GetName() == valid_abilities[ability] then
						return true
					end
				end
			end

			-- Next check if it's some other randomly allowed command (might be more but can't be assed to dig THAT deep)
		else
			local other_valid_orders =
			{
				DOTA_UNIT_ORDER_TRAIN_ABILITY,
				DOTA_UNIT_ORDER_PURCHASE_ITEM,
				DOTA_UNIT_ORDER_SELL_ITEM,
				DOTA_UNIT_ORDER_DISASSEMBLE_ITEM,
				DOTA_UNIT_ORDER_MOVE_ITEM,
				DOTA_UNIT_ORDER_GLYPH,
				DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH
			}

			for order = 1, #other_valid_orders do
				if keys.order_type == other_valid_orders[order] then
					return true
				end
			end
		end

		-- If the above checks failed, then it shouldn't be a valid order
		DisplayError(unit:GetPlayerID(), "Cannot Act")
		return false
	end

	-----------------------------------------------------------
	-- Gyrocopter Vanilla Flak Cannon Stack Refresh Override --
	-----------------------------------------------------------
	if EntIndexToHScript(keys.entindex_ability) and EntIndexToHScript(keys.entindex_ability).GetName and EntIndexToHScript(keys.entindex_ability):GetName() == "gyrocopter_flak_cannon" and unit:FindModifierByNameAndCaster("modifier_gyrocopter_flak_cannon", unit) then
		-- Cannot directly manipulate modifier stack count as there's some hard-coded value that makes the modifier destroy itself after the original max attacks are reached
		unit:FindModifierByNameAndCaster("modifier_gyrocopter_flak_cannon", unit):Destroy()
		EntIndexToHScript(keys.entindex_ability):OnSpellStart()
	end

	return true
end

-- Damage filter function
function GameMode:DamageFilter(keys)
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

				for _, modifier in pairs(modifiers) do
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
					keys.damage = keys.damage / (1 + rapier_spellpower / 100)
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
				keys.damage = keys.damage / ((ksp.damage_increase * ksp:GetStackCount() / 100) + 1)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, victim, keys.damage, nil)
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
					ApplyDamage({ attacker = scythe_caster, victim = victim, ability = ability, damage = victim:GetHealth() + 10, damage_type = DAMAGE_TYPE_PURE, damage_flag = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK })
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
						keys.damage = keys.damage * (1 + (on_prow_crit_damage_pct - 100) / 100)

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
					ApplyDamage({ attacker = battle_hunger_caster, victim = victim, ability = battle_hunger_ability, damage = victim:GetHealth() + 10, damage_type = DAMAGE_TYPE_PURE, damage_flag = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK })
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

		-- Another testing trying to remove invinicible 0 hp illusions
		if attacker:IsIllusion() and attacker:GetHealth() <= 0 then
			--			attacker:RemoveSelf()
			keys.damage = 0
		end

		-- Oracle False Promise Alter logic (most of it will be handled in the ability file)
		if attacker:HasModifier("modifier_imba_oracle_false_promise_timer_alter") then
			keys.damage = 0
		end

		if victim:HasModifier("modifier_no_pvp") and attacker:GetTeamNumber() == victim:GetOpposingTeamNumber() then
			keys.damage = 0
		end
	end

	return true
end

-- This function runs once for each hero that gets affected by a picked up bounty rune, and keys.player_id_const is ONLY the player who actually picked it up, so the previous implementation gave Alcehmist 5 or 10 instances of boosted gold if he picked it up himself which is...bad.
-- Need to try a different (aka. jank) way to implement this.
function GameMode:BountyRuneFilter(keys)
	if not keys.player_id_const then return end
	if not PlayerResource:GetPlayer(keys.player_id_const) then return end
	if not PlayerResource:GetPlayer(keys.player_id_const).GetAssignedHero then return end

	local hero = PlayerResource:GetPlayer(keys.player_id_const):GetAssignedHero()

	if not hero then return end

	self.player_counter = self.player_counter or 1

	-- Initialize the table of people on the bounty rune acquirer's team on the first instance
	if self.player_counter == 1 then
		local heroes = HeroList:GetAllHeroes()
		self.allies = {}

		for _, unit in pairs(heroes) do
			if unit:GetTeam() == hero:GetTeam() and unit:IsRealHero() and not unit:IsClone() and not unit:IsTempestDouble() then
				table.insert(self.allies, unit)
			end
		end
	end

	-- Hand of Midas gold bonus
	if hero:HasItemInInventory("item_imba_hand_of_midas") and hero:HasModifier("modifier_item_imba_hand_of_midas") then
		keys.gold_bounty = keys.gold_bounty * (1 + (GetAbilitySpecial("item_imba_hand_of_midas", "passive_gold_bonus") / 100))
	end

	-- Okay now we should have the list of allies, so for each instance of BountyRuneFilter that is run, go through and check gold/exp; if Greevil's Greed owner, give an extra amount accordingly	
	local custom_gold_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "bounty_multiplier")["1"])
	--	local custom_xp_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "exp_multiplier")["1"])

	-- Base gold and EXP; if the hero does not have Greevil's Greed this is basically the end
	keys.gold_bounty = keys.gold_bounty * (custom_gold_bonus / 100)
	--	keys.xp_bounty = keys.xp_bounty * (custom_xp_bonus / 100)

	-- Testing first bounty runes giving bonus gold
	if GameRules:GetDOTATime(false, false) < 120 then -- less than 2 min = first bounty rune
		keys.gold_bounty = keys.gold_bounty * 1.5
	end

	-- Greevil's Greed  logic
	local target = self.allies[self.player_counter]

	if target:FindAbilityByName("imba_alchemist_goblins_greed") and target:FindAbilityByName("imba_alchemist_goblins_greed"):IsTrained() then
		local alchemy_bounty = 0

		-- #7 Talent: Moar gold from bounty runes (should return 0 for that if the owner doesn't have it)
		alchemy_bounty = keys.gold_bounty * (target:FindAbilityByName("imba_alchemist_goblins_greed"):GetVanillaAbilitySpecial("bounty_multiplier") + target:FindTalentValue("special_bonus_imba_alchemist_7"))

		-- Return the DIFFERENCE between the calculated boost and the standard bounty rune amount since the Greevil's Greed owner is already getting keys.gold_bounty
		local additional_bounty = alchemy_bounty - keys.gold_bounty

		target:ModifyGold(additional_bounty, false, DOTA_ModifyGold_Unspecified)
		SendOverheadEventMessage(PlayerResource:GetPlayer(target:GetPlayerOwnerID()), OVERHEAD_ALERT_GOLD, target, additional_bounty, nil)
	end

	if #self.allies == self.player_counter then
		self.player_counter = nil
		self.allies = nil

		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("set_bounty_rune_gold_text"), function()
			if IMBA_COMBAT_EVENTS == false then
				CustomGameEventManager:Send_ServerToAllClients("set_bounty_rune_gold", { gold = keys.gold_bounty })
			end
		end, 0.1)
	else
		self.player_counter = self.player_counter + 1
	end

	-- I don't even think this return statement does anything
	return true
end

function GameMode:HealingFilter(keys)
	local heal_amplify = 0

	for _, mod in pairs(EntIndexToHScript(keys.entindex_target_const):FindAllModifiers()) do
		if mod.Custom_AllHealAmplify_Percentage and mod:Custom_AllHealAmplify_Percentage() then
			heal_amplify = heal_amplify + mod:Custom_AllHealAmplify_Percentage()
		end
	end

	if heal_amplify ~= 0 then
		keys.heal = keys.heal * (1 + (heal_amplify / 100))
	end

	-- Values:
	--	keys.entindex_target_const (probably want to use EntIndexToHScript(keys.entindex_target_const) to get the unit reference)
	--	keys.heal
	--
	-- Yeah that's it.

	-- MAKE HEALTH REGEN AMP CODE HERE
	-- local nHeal = keys["heal"]
	-- if keys["entindex_healer_const"] == nil then
	-- return true
	-- end

	-- local hHealingHero = EntIndexToHScript( keys["entindex_healer_const"] )
	-- if nHeal > 0 and hHealingHero ~= nil and hHealingHero:IsRealHero() then
	-- for _,Zone in pairs( self.Zones ) do
	-- if Zone:ContainsUnit( hHealingHero ) then
	-- Zone:AddStat( hHealingHero:GetPlayerID(), ZONE_STAT_HEALING, nHeal )
	-- return true
	-- end
	-- end
	-- end

	return true
end

function GameMode:RuneSpawnFilter(keys)
	keys.rune_type = RandomInt(0, 5)

	if keys.rune_type == 5 then
		keys.rune_type = keys.rune_type + 1
	end

	return true
end
