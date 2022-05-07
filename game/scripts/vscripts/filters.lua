--------------------------------------------------------------------------------
-- Event: Filter for inventory full
--------------------------------------------------------------------------------
function GameMode:OrderFilter( filterTable )
--[[
	for k, v in pairs( filterTable ) do
		print("EO: " .. k .. " " .. tostring(v) )
	end
--]]

	local units = filterTable["units"]
	local unit

	if units["0"] then
		unit = EntIndexToHScript(units["0"])
	else
		return nil
	end

	if unit == nil then return end

	local orderType = filterTable["order_type"]
	local target = filterTable["entindex_target"] ~= 0 and EntIndexToHScript(filterTable["entindex_target"]) or nil
	local ability = filterTable["entindex_ability"] ~= 0 and EntIndexToHScript(filterTable["entindex_ability"]) or nil
	local disableHelpResult = DisableHelp.ExecuteOrderFilter(orderType, ability, target, unit)

	if disableHelpResult == false then
		return false
	end

--[[
	if (orderType ~= DOTA_UNIT_ORDER_PICKUP_ITEM or filterTable["issuer_player_id_const"] == -1) then
		return true
	else
		local item = EntIndexToHScript(target)

		if item == nil then
			return true
		end

		local pickedItem = item:GetContainedItem()

		--print(pickedItem:GetAbilityName())

		if pickedItem == nil then
			return true
		end

		if pickedItem:GetAbilityName() == "item_treasure_chest" then
			local player = PlayerResource:GetPlayer(filterTable["issuer_player_id_const"])
			local hero = player:GetAssignedHero()

			if hero:GetNumItemsInInventory() < 6 then
				--print("inventory has space")
				return true
			else
				--print("Moving to target instead")
				local position = item:GetAbsOrigin()

				filterTable["position_x"] = position.x
				filterTable["position_y"] = position.y
				filterTable["position_z"] = position.z
				filterTable["order_type"] = DOTA_UNIT_ORDER_MOVE_TO_POSITION

				return true
			end
		end
	end
--]]

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
						keys.damage = keys.damage * (1 + (on_prow_crit_damage_pct - 100) * 0.01)

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

-- Item added to inventory filter
function GameMode:ItemAddedFilter( keys )
	-- Typical keys:
	-- inventory_parent_entindex_const: 852
	-- item_entindex_const: 1519
	-- item_parent_entindex_const: -1
	-- suggested_slot: -1

	local unit = EntIndexToHScript(keys.inventory_parent_entindex_const)
	local item = EntIndexToHScript(keys.item_entindex_const)
	local item_name = 0

	if item:GetName() then
		item_name = item:GetName()
	end

	if item_name == "item_aegis" then
		-- If this is a player, do Aegis stuff
		if unit:IsRealHero() and not unit:HasModifier("modifier_item_imba_aegis") then
			unit:AddNewModifier(unit, item, "modifier_item_imba_aegis",{})
		elseif unit:IsRoshan() then
			return true
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
			if 	((item_name == "item_imba_rapier") and (rapier_amount == 2)) or
			((item_name == "item_imba_rapier_magic") and (rapier_magic_amount == 2)) or
			((item_name == "item_imba_rapier_2") and (rapier_magic_2_amount >= 1)) or
			((item_name == "item_imba_rapier_magic_2") and (rapier_2_amount >= 1)) then
				return true
			else
				DisplayError(unit:GetPlayerID(),"#dota_hud_error_cant_item_enough_slots")
			end
		end
		
		if unit:IsIllusion() or unit:IsTempestDouble() or unit:IsHero() then
			return true
		else
			unit:DropItem(nil, item_name, true)
		end
		
		return false
	end

	return true
end

-- Testing a gold reduction on hero kills to reduce "snowballing"; 1 is default
-- local HERO_KILL_MULTIPLIER = 5.0

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

--	print(keys)

	-- Gold from abandoning players does not get multiplied
	if keys.reason_const == DOTA_ModifyGold_AbandonedRedistribute or keys.reason_const == DOTA_ModifyGold_GameTick then
		return true
	end

	if PlayerResource:GetPlayer(keys.player_id_const) == nil then return end

	local player = PlayerResource:GetPlayer(keys.player_id_const)

	-- player can be nil for some reason
	if player then
		-- Test gold reduction for hero kills
--		if keys.reason_const == DOTA_ModifyGold_HeroKill then
--			keys.gold = keys.gold * HERO_KILL_MULTIPLIER
--			return true
--		end

		-- Lobby options adjustment
		local custom_gold_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "bounty_multiplier")["1"]) or 100

		if custom_gold_bonus ~= nil then
			keys.gold = keys.gold * custom_gold_bonus / 100
		end
	end

	return true
end

-- Experience gain filter function
function GameMode:ExperienceFilter( keys )
	-- reason_const		1 (DOTA_ModifyXP_CreepKill)
	-- experience		130
	-- player_id_const	0

	-- Ignore negative experience values
	if keys.experience < 0 then
		return false
	end

	local custom_xp_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "exp_multiplier")["1"])

	-- Test exp reduction for hero kills
--	if keys.reason_const == DOTA_ModifyXP_HeroKill then
--		custom_xp_bonus = custom_xp_bonus * HERO_KILL_MULTIPLIER
--	end

	if custom_xp_bonus ~= nil then
		keys.experience = keys.experience * (custom_xp_bonus / 100)
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
		keys.gold_bounty = keys.gold_bounty * (1 + (GetAbilitySpecial("item_imba_hand_of_midas", "passive_gold_bonus") * 0.01))
	end

	-- Okay now we should have the list of allies, so for each instance of BountyRuneFilter that is run, go through and check gold/exp; if Greevil's Greed owner, give an extra amount accordingly	
	local custom_gold_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "bounty_multiplier")["1"])
--	local custom_xp_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "exp_multiplier")["1"])

	-- Base gold and EXP; if the hero does not have Greevil's Greed this is basically the end
	keys.gold_bounty = keys.gold_bounty * (custom_gold_bonus / 100)
--	keys.xp_bounty = keys.xp_bounty * (custom_xp_bonus / 100)

	-- Testing first bounty runes giving bonus gold
	if GameRules:GetDOTATime(false, false) < 120 then -- less than 2 min = first bounty rune
		keys.gold_bounty = keys.gold_bounty * (FIRST_BOUNTY_RUNE_BONUS_PCT / 100)
	end

	-- Greevil's Greed logic
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

		-- TODO: Add code that replaces gold value in vanilla Combat Events UI
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("set_bounty_rune_gold_text"), function()
			CustomGameEventManager:Send_ServerToAllClients("set_bounty_rune_gold", {gold = keys.gold_bounty})
		end, 0.1)
	else
		self.player_counter = self.player_counter + 1
	end

	-- I don't even think this return statement does anything
	return true
end

-- Modifier gained filter function
function GameMode:ModifierFilter( keys )
	-- entindex_parent_const	215
	-- entindex_ability_const	610
	-- duration					-1
	-- entindex_caster_const	215
	-- name_const				modifier_imba_roshan_rage_stack

	if not IsServer() then return end

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

	-- This is causing too much grief with having to use SetDuration to just override times due to this filter not respecting refreshes, so I'm just going to nuke this once and for all and work from there...
	-- if modifier_owner ~= nil then
		-- modifier_class = modifier_owner:FindModifierByName(modifier_name)
		-- if modifier_class == nil then return end

		-- -- Check for skills (typically vanilla) that are explicitly flagged to not account for frantic's status resistance
		-- local ignore_frantic = false

		-- for _, modifier in pairs(IMBA_MODIFIER_IGNORE_FRANTIC) do
			-- if modifier == modifier_name then
				-- ignore_frantic = true
			-- end
		-- end

		-- if keys.entindex_ability_const and modifier_ability.GetAbilityName then
			-- if ignore_frantic == false and string.find(modifier_ability:GetAbilityName(), "imba") and keys.duration > 0 and modifier_owner:GetTeam() ~= modifier_caster:GetTeam() then
				-- local original_duration = keys.duration
				-- local actual_duration = original_duration
				-- local status_resistance = modifier_owner:GetStatusResistance()
-- --				print("Old duration:", actual_duration)

				-- if not (modifier_class.IgnoreTenacity and modifier_class:IgnoreTenacity()) then
					-- actual_duration = actual_duration * (1 - status_resistance)
				-- end

-- --				print("New duration:", actual_duration)

				-- keys.duration = actual_duration
			-- else
				-- -- works fine for legion commander's duel, imba modifiers are using IgnoreTenacity
				-- if ignore_frantic == true then
					-- local original_duration = keys.duration
					-- local actual_duration = original_duration
					-- local status_resistance = modifier_owner:GetStatusResistance()

					-- actual_duration = actual_duration / ((100 - (status_resistance * 100)) / 100)
					-- keys.duration = actual_duration
				-- end
			-- end
		-- end
	-- end

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
	
	-- Tried some fancy stuff in the frantic file but you cannot properly override vanilla durations so I will do it here for Legion Commander's Duel
	-- Because Duel ends if either of the modifiers (on caster and target) ends, we need a way to equalize the durations even if the two units have differing status resistance
	-- Because Duel first applies a modifier on the target, I will use it to store the proper duration to set it to, and use that for the caster duration
	if modifier_name == "modifier_legion_commander_duel" and keys.duration > 0 then
		if modifier_owner:HasModifier("modifier_frantic") and not modifier_ability.frantic_adjusted_duration then
			modifier_ability.frantic_adjusted_duration = keys.duration / ((100 - modifier_owner:FindModifierByName("modifier_frantic"):GetStackCount()) * 0.01)
			keys.duration = modifier_ability.frantic_adjusted_duration
		elseif modifier_ability.frantic_adjusted_duration then
			keys.duration = modifier_ability.frantic_adjusted_duration
			modifier_ability.frantic_adjusted_duration = nil
		end
	end
	
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
			modifier_owner:AddNewModifier(modifier_owner, modifier_ability, "modifier_item_imba_helm_of_the_undying_addendum", {duration = keys.duration + FrameTime()})
		end
	end

--[[
	-- Deactivate Tusk's Snowball so you don't allow multiple casting while Snowball is active (resulting in permanently lingering particles)
	-- let's deactivate this weird fix to see if that issue is still a thing
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
--]]

	if modifier_owner:GetUnitName() == "npc_imba_warlock_demonic_ascension" then
		if modifier_name == "modifier_fountain_aura_effect_lua" then
			return false
		end
	end

	-- Replaces rune vanilla modifier with imba rune modifier
	if string.find(modifier_name, "modifier_rune_") then
		local rune_name = string.gsub(modifier_name, "modifier_rune_", "")
		ImbaRunes:PickupRune(rune_name, modifier_owner, false)

		return false
	end

	return true
end