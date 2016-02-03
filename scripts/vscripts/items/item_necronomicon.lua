--[[	Author: Firetoad
		Date: 06.01.2016	]]

function Necronomicon( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local necro_level = keys.necro_level

	-- Parameters
	local summon_duration = ability:GetLevelSpecialValueFor("summon_duration", ability_level)
	local caster_loc = caster:GetAbsOrigin()
	local caster_direction = caster:GetForwardVector()
	local melee_summon_name = "npc_imba_necronomicon_warrior_"..necro_level
	local ranged_summon_name = "npc_imba_necronomicon_archer_"..necro_level

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Calculate summon positions
	local melee_loc = RotatePosition(caster_loc, QAngle(0, 30, 0), caster_loc + caster_direction * 180)
	local ranged_loc = RotatePosition(caster_loc, QAngle(0, -30, 0), caster_loc + caster_direction * 180)

	-- Destroy trees
	GridNav:DestroyTreesAroundPoint(caster_loc + caster_direction * 180, 180, false)

	-- Spawn the summons
	local melee_summon = CreateUnitByName(melee_summon_name, melee_loc, true, caster, caster, caster:GetTeam())
	local ranged_summon = CreateUnitByName(ranged_summon_name, ranged_loc, true, caster, caster, caster:GetTeam())

	-- Make the summons limited duration and controllable
	melee_summon:SetControllableByPlayer(caster:GetPlayerID(), true)
	melee_summon:AddNewModifier(caster, ability, "modifier_kill", {duration = summon_duration})
	ability:ApplyDataDrivenModifier(caster, melee_summon, "modifier_item_imba_necronomicon_summon", {})
	ranged_summon:SetControllableByPlayer(caster:GetPlayerID(), true)
	ranged_summon:AddNewModifier(caster, ability, "modifier_kill", {duration = summon_duration})
	ability:ApplyDataDrivenModifier(caster, ranged_summon, "modifier_item_imba_necronomicon_summon", {})
	
	-- Find summon abilities
	local melee_ability_1 = melee_summon:FindAbilityByName("necronomicon_warrior_mana_burn")
	local melee_ability_2 = melee_summon:FindAbilityByName("necronomicon_warrior_last_will")
	local melee_ability_3 = melee_summon:FindAbilityByName("necronomicon_warrior_sight")
	local melee_ability_4 = melee_summon:FindAbilityByName("imba_necronomicon_warrior_trample")
	local melee_ability_5 = melee_summon:FindAbilityByName("imba_necronomicon_warrior_blaze_spikes")

	local ranged_ability_1 = ranged_summon:FindAbilityByName("necronomicon_archer_mana_burn")
	local ranged_ability_2 = ranged_summon:FindAbilityByName("necronomicon_archer_aoe")
	local ranged_ability_3 = ranged_summon:FindAbilityByName("black_dragon_fireball")
	local ranged_ability_4 = ranged_summon:FindAbilityByName("imba_necronomicon_archer_multishot")

	-- Upgrade abilities according to the Necronomicon level
	melee_ability_1:SetLevel(necro_level)
	melee_ability_2:SetLevel(necro_level)
	melee_ability_3:SetLevel(1)
	ranged_ability_1:SetLevel(necro_level)
	ranged_ability_2:SetLevel(necro_level)

	-- Bonus level 4 abilities
	if necro_level >= 4 then
		melee_ability_4:SetLevel(necro_level - 3)
		ranged_ability_3:SetLevel(1)
	end

	-- Bonus level 5 abilities
	if necro_level >= 5 then
		melee_ability_5:SetLevel(1)
		ranged_ability_4:SetLevel(1)
	end
end