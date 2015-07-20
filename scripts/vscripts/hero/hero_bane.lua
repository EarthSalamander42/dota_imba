--[[	Author: D2imba
		Date: 10.03.2015	]]

function Enfeeble( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stacks = keys.modifier_stacks

	-- Parameters
	local reduce_factor = ability:GetLevelSpecialValueFor("stat_reduction", ability_level) / 100

	-- Remove current stacks and enfeeble debuff
	target:RemoveModifierByName(modifier_stacks)

	-- Calculate attribute reduction
	local total_stats = target:GetStrength() + target:GetAgility() + target:GetIntellect()
	local reduction_stacks = math.floor( total_stats * reduce_factor / 3 )

	-- Apply stacks
	AddStacks(ability, caster, target, modifier_stacks, reduction_stacks, true)
end

function EnfeebleEnd( keys )
	local caster = keys.caster
	local target = keys.target
	local modifier_stacks = keys.modifier_stacks

	-- Remove current stacks of attribute reduction
	target:RemoveModifierByName(modifier_stacks)
end

function BrainSapManaDrain( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local mana_to_steal = ability:GetLevelSpecialValueFor("mana_steal_amt", ability_level)

	target:ReduceMana(mana_to_steal)
	caster:GiveMana(mana_to_steal)
end

function BrainSapSpellCast( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local mana_percent = ability:GetLevelSpecialValueFor("mana_percent", ability_level)
	local mana_to_spend = target:GetMaxMana() * mana_percent / 100

	-- Reduce the target's mana
	target:ReduceMana(mana_to_spend)
end

function FiendsGripManaDrain( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local scepter = HasScepter(caster)
	local mana_drain = ability:GetLevelSpecialValueFor("fiends_grip_mana_drain", ability:GetLevel() -1) / 100
	
	if scepter == true then
		mana_drain = ability:GetLevelSpecialValueFor("fiends_grip_mana_drain_scepter", ability:GetLevel() -1) / 100
	end

	local target_max_mana = target:GetMaxMana()
	local actual_mana_drained = mana_drain * target_max_mana
	
	target:ReduceMana(actual_mana_drained)
	caster:GiveMana(actual_mana_drained)
end

function FiendsGripStopChannel( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier
	local scepter = HasScepter(caster)
	local max_duration = ability:GetLevelSpecialValueFor("fiends_grip_duration", (ability:GetLevel() -1))

	if scepter == true then
		max_duration = ability:GetLevelSpecialValueFor("fiends_grip_duration_scepter", (ability:GetLevel() -1))
	end

	local enemies_affected = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType() , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	local channel_time = GameRules:GetGameTime() - ability:GetChannelStartTime()

	if channel_time * 2 > max_duration then
		for _,v in pairs(enemies_affected) do
			if v:HasModifier(modifier) then
				ability:ApplyDataDrivenModifier(caster, v, modifier, {duration = max_duration - channel_time})
			end
		end
	else
		for _,v in pairs(enemies_affected) do
			if v:HasModifier(modifier) then
				ability:ApplyDataDrivenModifier(caster, v, modifier, {duration = channel_time})
			end
		end
	end
end

function FiendsGripEndSound( keys )
	local target = keys.target
	local sound_1 = keys.sound_1
	local sound_2 = keys.sound_2

	StopSoundEvent(sound_1, target)
	StopSoundEvent(sound_2, target)
	target.fiends_grip_dummy:Destroy()
end

function FiendsGripScepter( keys )
	local caster = keys.caster
	local scepter = HasScepter(caster)

	if scepter == true then
		local target = keys.target
		local ability = keys.ability
		local modifier = keys.modifier_fiends_grip
		local ability_level = ability:GetLevel() - 1

		local vision_radius = ability:GetLevelSpecialValueFor("fiends_grip_scepter_radius", ability_level)
		local vision_cone = ability:GetLevelSpecialValueFor("fiends_grip_scepter_vision_cone", ability_level)
		local caster_location = caster:GetAbsOrigin()
		local enemies_to_check = FindUnitsInRadius(target:GetTeam(), caster_location, nil, vision_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType() , 0, FIND_CLOSEST, false)
		
		for _,v in pairs(enemies_to_check) do
			caster_location = caster:GetAbsOrigin()
			local target_location = v:GetAbsOrigin()
			local direction = (caster_location - target_location):Normalized()
			local forward_vector = v:GetForwardVector()
			local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y)
			if angle <= vision_cone/2 then
				ability:ApplyDataDrivenModifier(caster, v, modifier, {})
			end
		end
	end
end

function FiendsGripTruesight( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability

	local target_location = target:GetAbsOrigin()
	target.fiends_grip_dummy = CreateUnitByName("npc_dummy_unit", target_location, false, nil, nil, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, target.fiends_grip_dummy, "modifier_item_gem_of_true_sight", {radius = 50})
end

function NightmareDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	local target_health = target:GetHealth()
	local damage = ability:GetAbilityDamage()

	-- Check if the damage would be lethal.
	if target_health <= damage then
		-- If that's the case, deal pure damage.
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})
	else
		-- Otherwise, just set the health to be lower
		target:SetHealth(target_health - damage)
	end
end

function NightmareSpread( keys )
	local caster = keys.caster
	local target = keys.target
	local attacker = keys.attacker
	local ability = keys.ability
	local nightmare_modifier = keys.nightmare_modifier

	-- Check if it has the Nightmare debuff
	if target:HasModifier(nightmare_modifier) then
		-- If it does then apply it to the attacker
		ability:ApplyDataDrivenModifier(caster, attacker, nightmare_modifier, {})
	end
end

function NightmareEnd( keys )
	local caster = keys.caster
	local target = keys.target
	local loop_sound = keys.loop_sound
	local nightmare_name = keys.nightmare
	local nightmare_end_name = keys.nightmare_end
	local ability_nightmare = keys.ability

	-- Stops playing sound
	StopSoundEvent(loop_sound, target)

	-- If this is the caster, toggles Nightmare End off
	if caster == target then
		local ability_nightmare_end = caster:FindAbilityByName(nightmare_end_name)
		if ability_nightmare_end:GetToggleState() then
			ability_nightmare_end:ToggleAbility()
		end
		caster:SwapAbilities(nightmare_name, nightmare_end_name, true, false)
	end
end

function NightmareStart( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local invul_modifier = keys.invul_modifier
	local nightmare_name = keys.nightmare
	local nightmare_end_name = keys.nightmare_end
	local invul_duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)

	if target == caster then

		-- Apply invulnerability for the whole duration
		ability:ApplyDataDrivenModifier(caster, caster, invul_modifier, {duration = invul_duration})

		-- Swaps abilities
		caster:SwapAbilities(nightmare_name, nightmare_end_name, false, true)

		-- Upgrade Nightmare End to level 1
		local nightmare_end_ability = caster:FindAbilityByName(nightmare_end_name)
		nightmare_end_ability:SetLevel(1)
	end
end
