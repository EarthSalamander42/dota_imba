-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- first time a real hero spawn
function GameMode:OnUnitFirstSpawn(unit)
	-- Track the time the unit spawned (for IMBAfications or other custom checks)
	unit.time_spawned = GameRules:GetGameTime()

	local unit_name = unit:GetUnitName()

	-- TERRIBLE FIX, LOOK AWAY
	if string.find(unit_name, "npc_imba_enigma_eidolon_") then
		unit_name = "npc_dota_eidolon"
	end

	if string.find(unit:GetUnitName(), "npc_dota_lone_druid_bear") then
		-- Give the custom mechanics like damage block and lifesteal
		unit:AddNewModifier(unit, nil, "modifier_custom_mechanics", {})
	end

	-- Let's give jungle creeps some love too...I guess
	if string.find(unit:GetUnitName(), "_neutral_") then
		unit:AddAbility("custom_creep_scaling")
	end

	-- Gotta do it manually here because the ability/modifier doesn't work on server-side for some godforsaken reason
	if unit:GetClassname() == "npc_dota_creep_lane" or unit:GetClassname() == "npc_dota_creep_siege" or string.find(unit:GetUnitName(), "_neutral_") then
		if unit:HasAbility("custom_creep_scaling") then
			local creep_scaling_ability = unit:FindAbilityByName("custom_creep_scaling")
			creep_scaling_ability:SetLevel(1)

			local multiplier = creep_scaling_ability:GetSpecialValueFor("base_mult")

			if string.find(unit:GetUnitName(), "upgraded") then
				multiplier = creep_scaling_ability:GetSpecialValueFor("super_mult")
			elseif string.find(unit:GetUnitName(), "upgraded_mega") then
				multiplier = creep_scaling_ability:GetSpecialValueFor("mega_mult")
			end

			local game_time = math.floor(GameRules:GetDOTATime(false, false) / 60)

			unit:SetBaseDamageMin(unit:GetBaseDamageMin() + creep_scaling_ability:GetSpecialValueFor("melee_attack") * game_time * multiplier) -- Works
			unit:SetBaseDamageMax(unit:GetBaseDamageMax() + creep_scaling_ability:GetSpecialValueFor("melee_attack") * game_time * multiplier) -- Works
			-- unit:SetBaseAttackTime(unit:GetBaseAttackTime() - creep_scaling_ability:GetSpecialValueFor("melee_aspd") * game_time * multiplier)
			unit:SetBaseMoveSpeed(unit:GetBaseMoveSpeed() + creep_scaling_ability:GetSpecialValueFor("melee_ms") * game_time * multiplier) -- Works but doesn't show on client side (wtf...)
			unit:SetMaxHealth(unit:GetMaxHealth() + creep_scaling_ability:GetSpecialValueFor("melee_hp") * game_time * multiplier)       -- Works
			unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() + creep_scaling_ability:GetSpecialValueFor("melee_hp") * game_time * multiplier) -- Works
			unit:SetHealth(unit:GetMaxHealth() + creep_scaling_ability:GetSpecialValueFor("melee_hp") * game_time * multiplier)          -- Works
			unit:SetBaseHealthRegen(unit:GetBaseHealthRegen() + creep_scaling_ability:GetSpecialValueFor("melee_regen") * game_time * multiplier) -- Works
		end

		if IMBA_GREEVILING == true then
			Greeviling(unit)
			return
		end
	end

	-- Burning Army override (skeletons invulnerable + fix not dying when duration ends)
	if unit:GetClassname() == "npc_dota_clinkz_skeleton_archer" then
		-- IMBA effect
		--		unit:AddNewModifier(unit, nil, "modifier_invulnerable_hidden", {})

		-- These skeletons have no set owner or team like wtf...
		-- Need to do hacky inconsistent way to check for owner (breaks apart when you have multiple heroes all with Burning Army)
		for _, hero in pairs(FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_DEAD, FIND_CLOSEST, false)) do
			if hero:HasAbility("clinkz_burning_army") then
				unit:SetOwner(hero)
				unit:AddNewModifier(hero, nil, "modifier_imba_burning_army", {})
				unit:AddNewModifier(hero, nil, "modifier_kill", { duration = GetAbilitySpecial("clinkz_burning_army", "duration") })
				break
			end
		end

		if unit and unit.HasAbility and unit:HasAbility("imba_clinkz_searing_arrows") and unit.GetOwner and unit:GetOwner() and unit:GetOwner():HasAbility("imba_clinkz_searing_arrows") then
			unit:FindAbilityByName("imba_clinkz_searing_arrows"):SetLevel(unit:GetOwner():FindAbilityByName("imba_clinkz_searing_arrows"):GetLevel())
		end
	end

	-- Replacing Cloak Aura with a version that stacks with itself
	if unit:HasAbility("mudgolem_cloak_aura") then
		local old_cloak_aura_ability = unit:FindAbilityByName("mudgolem_cloak_aura")
		local new_cloak_aura_ability = unit:AddAbility("imba_mudgolem_cloak_aura")
		new_cloak_aura_ability:SetLevel(old_cloak_aura_ability:GetLevel())
		unit:SwapAbilities("mudgolem_cloak_aura", "imba_mudgolem_cloak_aura", false, true)
		unit:RemoveAbilityByHandle(old_cloak_aura_ability)
	end

	-- Cursed Fountain addendum
	if unit.GetOwner and unit:GetOwner() and unit:GetOwner().HasModifier and unit:GetOwner():HasModifier("modifier_imba_cursed_fountain") then
		local cursed_fountain_modifier = unit:AddNewModifier(unit:GetOwner():FindModifierByName("modifier_imba_cursed_fountain"):GetCaster(), unit:GetOwner():FindModifierByName("modifier_imba_cursed_fountain"):GetAbility(), "modifier_imba_cursed_fountain", {})

		if cursed_fountain_modifier then
			cursed_fountain_modifier:SetStackCount(unit:GetOwner():FindModifierByName("modifier_imba_cursed_fountain"):GetStackCount())
		end
	end
	--[[
	-- Find hidden modifiers
	if unit:GetUnitName() == "npc_dota_techies_remote_mine" then
		unit:SetContextThink(DoUniqueString("ModifierChecker"), function()
			for i = 0, unit:GetModifierCount() -1 do
				print(unit:GetUnitName(), unit:GetModifierNameByIndex(i))
			end

			return 1.0
		end, 0)
	end
--]]
end

-- everytime an unit respawn
function GameMode:OnUnitSpawned(unit)
	-- Track the time the unit spawned (for IMBAfications or other custom checks)
	unit.time_spawned = GameRules:GetGameTime()

	-- levelup bear ability based on his level
	if string.find(unit:GetUnitName(), "npc_dota_lone_druid_bear") then
		for i = 0, 23 do
			local ability = unit:GetAbilityByIndex(i)
			if IsValidEntity(ability) then
				ability:SetLevel(unit:GetLevel())
			end
		end

		return
	elseif unit:IsIllusion() and not unit:HasModifier("modifier_illusion_manager_out_of_world") and not unit:HasModifier("modifier_illusion_manager") then
		-- Valve Illusion bug to prevent respawning
		UTIL_Remove(unit)
		return
	end

	-- Prevent zombies from spawning inside of units?
	if unit:GetName() == "npc_dota_unit_undying_zombie" then
		ResolveNPCPositions(unit:GetAbsOrigin(), unit:GetHullRadius())
	end

	-- Cursed Fountain addendum
	if unit.GetOwner and unit:GetOwner().HasModifier and unit:GetOwner():HasModifier("modifier_imba_cursed_fountain") then
		local cursed_fountain_modifier = unit:AddNewModifier(unit:GetOwner():FindModifierByName("modifier_imba_cursed_fountain"):GetCaster(), unit:GetOwner():FindModifierByName("modifier_imba_cursed_fountain"):GetAbility(), "modifier_imba_cursed_fountain", {})

		if cursed_fountain_modifier then
			cursed_fountain_modifier:SetStackCount(unit:GetOwner():FindModifierByName("modifier_imba_cursed_fountain"):GetStackCount())
		end
	end
end
