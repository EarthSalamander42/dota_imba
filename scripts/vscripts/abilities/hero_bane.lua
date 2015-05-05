--[[	Author: D2imba
		Date: 10.03.2015	]]

function Enfeeble( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- get target's attributes
	local target_str = target:GetStrength()
	local target_agi = target:GetAgility()
	local target_int = target:GetIntellect()
	
	local reduce_factor = ability:GetLevelSpecialValueFor("stat_reduction", ability_level) / 100
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)

	-- calculate reductions
	local reduction_str = target_str * reduce_factor
	local reduction_agi = target_agi * reduce_factor
	local reduction_int = target_int * reduce_factor

	-- apply reductions
	target:ModifyStrength(reduction_str)
	target:ModifyAgility(reduction_agi)
	target:ModifyIntellect(reduction_int)

	-- restore regular attribute values after the duration elapses
	Timers:CreateTimer(duration, function()
		target:ModifyStrength(-reduction_str)
		target:ModifyAgility(-reduction_agi)
		target:ModifyIntellect(-reduction_int)
		end)
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
	local target = keys.target
	local ability = keys.ability
	local casted_ability = caster:GetCurrentActiveAbility()
	local casted_ability_index = casted_ability:GetAbilityIndex()
	local no_mana_sound = keys.no_mana_sound
	local ability_level = ability:GetLevel() - 1

	-- calculate adjusted spell mana cost
	local spell_cost = casted_ability:GetManaCost(casted_ability_index)
	local caster_mana = caster:GetMana()
	local mana_multiplier = ability:GetLevelSpecialValueFor("mana_multiplier", ability_level) / 100
	local true_mana_cost = (mana_multiplier + 1) * spell_cost

	-- if the caster has not enough mana according to the increased mana cost, prevent casting. If he has, spend the extra mana
	--if caster_mana < true_mana_cost then
	--	EmitSoundOn(no_mana_sound, caster)
	--	caster:Stop()	
	--else
		caster:SpendMana(true_mana_cost - spell_cost, casted_ability)
	--end
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

function NightmareStopSound( keys )
	local target = keys.target
	local loop_sound = keys.loop_sound

	StopSoundEvent(loop_sound, target)
end

function NightmareStart( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local invul_modifier = keys.invul_modifier
	local invul_duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)

	-- If it is the caster then grant Bane invulnerability for Nightmare's duration
	if target == caster then
		ability:ApplyDataDrivenModifier(caster, caster, invul_modifier, {duration = invul_duration})
	end
end

function NightmareSwap( keys )
	local caster = keys.caster
	local ability = keys.ability
	local cooldown = ability:GetCooldown(ability:GetLevel() - 1)

	-- Ability names
	local nightmare = keys.nightmare
	local nightmare_end = keys.nightmare_end

	-- Swaps abilities
	caster:SwapAbilities(nightmare, nightmare_end, false, true)

	-- Upgrade Nightmare End to level 1
	local level_ability = caster:FindAbilityByName(nightmare_end)
	level_ability:SetLevel(1)

	-- Swaps abilities back after the skill cools down
	Timers:CreateTimer(cooldown, function()
		caster:SwapAbilities(nightmare, nightmare_end, true, false)
	end)
end

function NightmareSwapToMain( keys )
	local caster = keys.caster

	-- Ability names
	local sub_ability_name = keys.sub_ability_name
	local main_ability_name = keys.main_ability_name

	caster:SwapAbilities(main_ability_name, sub_ability_name, false, true)

	-- Upgrade Nightmare End to level 1
	local level_ability = caster:FindAbilityByName(sub_ability_name)
	level_ability:SetLevel(1)
end

function NightmareEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local nightmare = keys.nightmare
	local nightmare_end = keys.nightmare_end

	ability:ToggleAbility()
end
