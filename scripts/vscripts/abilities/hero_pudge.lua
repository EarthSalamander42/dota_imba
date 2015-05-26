--[[ 	Authors: Pizzalol and D2imba
		Date: 26.05.2015				]]

hook_table = hook_table or {}

function LaunchMeatHook( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local caster_loc = caster:GetAbsOrigin()
	local dummy_loc = caster_loc
	local dummy = CreateUnitByName("npc_dummy_blank", dummy_loc, false, caster, caster, caster:GetTeam())

	-- Parameters
	local target_loc = keys.target_points[1]
	local dummy_modifier = keys.dummy_modifier	
	local hook_particle = keys.hook_particle
	local sound_extend = keys.sound_extend
	local hook_speed = ability:GetLevelSpecialValueFor("hook_speed", ability_level) * 0.03
	local travel_distance = ability:GetLevelSpecialValueFor("hook_distance", ability_level)
	local distance_traveled = 0

	-- Hook particle
	local hook_fx = ParticleManager:CreateParticle(hook_particle, PATTACH_RENDERORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(hook_fx, 0, caster, 5, "attach_attack1", caster_loc, false)
	ParticleManager:SetParticleControlEnt(hook_fx, 6, dummy, 5, "attach_hitloc", dummy_loc, false)

	-- Setting up the hook dummy
	dummy:AddNewModifier(caster, nil, "modifier_phased", {})
	ability:ApplyDataDrivenModifier(caster, dummy, dummy_modifier, {})
	dummy_loc = dummy_loc + Vector(0,0,125) 

	local direction = (target_loc - caster_loc):Normalized()
	dummy:SetForwardVector(direction)	

	-- Setting up the extend/retract decision
	hook_table[caster] = hook_table[caster] or {}
	hook_table[caster].bHitUnit = false

	-- Extending the hook dummy
	Timers:CreateTimer(0.03, function()
		dummy_loc = dummy_loc + direction * hook_speed
		dummy:SetAbsOrigin(dummy_loc)
		distance_traveled = distance_traveled + hook_speed

		if distance_traveled < travel_distance and not hook_table[caster].bHitUnit then
			return 0.03
		else
			-- Retract the hook dummy
			Timers:CreateTimer(0,function()
				distance_traveled = distance_traveled - hook_speed
				dummy_loc = caster_loc + Vector(0,0,125) + direction * distance_traveled
				dummy:SetAbsOrigin(dummy_loc)

				if distance_traveled > 100 then
					return 0.03
				else
					StopSoundEvent(sound_extend, caster)
					ParticleManager:DestroyParticle(hook_fx, true)
					dummy:Destroy()
				end
			end)
		end
	end)
end

function RetractMeatHook( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = ability:GetAbilityDamage() 

	-- Parameters
	local hook_speed = ability:GetLevelSpecialValueFor("hook_speed", ability_level) * 0.03
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
	local dmg_per_100_units = ability:GetLevelSpecialValueFor("dmg_per_100_units", ability_level)
	local dmg_per_tick = hook_speed * dmg_per_100_units / 100
	local rupture_particle = keys.rupture_particle
	local meat_hook_modifier = keys.meat_hook_modifier
	local sound_extend = keys.sound_extend
	local sound_retract = keys.sound_retract
	local sound_retract_stop = keys.sound_retract_stop

	-- Calculate directions
	local caster_loc = caster:GetAbsOrigin()
	local target_loc = target:GetAbsOrigin() 
	local distance = (target_loc - caster_loc):Length2D()
	local direction = (caster_loc - target_loc):Normalized()

	-- Stop extending hook sound
	StopSoundEvent(sound_extend, caster)

	-- Vision
	ability:CreateVisibilityNode(target_loc, vision_radius, vision_duration)

	-- Impact
	local blood_particle
	if target:GetTeam() ~= caster:GetTeam() then
		-- Damage and stun
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = ability:GetAbilityDamageType()})
		ability:ApplyDataDrivenModifier(caster, target, meat_hook_modifier, {})

		-- Blood particle
		blood_particle = ParticleManager:CreateParticle(rupture_particle, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(blood_particle, 0, target_loc)
	end

	-- Make the target face the caster
	target:SetForwardVector(direction)

	-- For retracting the hook
	hook_table[caster].bHitUnit = true
	
	-- Move the target
	Timers:CreateTimer(0, function()
		-- Movement
		target_loc = caster_loc + (target_loc - caster_loc):Normalized() * (distance - hook_speed)
		target:SetAbsOrigin(target_loc)
		distance = (target_loc - caster_loc):Length2D()

		-- Damage
		if target:GetTeam() ~= caster:GetTeam() then
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = dmg_per_tick, damage_type = ability:GetAbilityDamageType()})
		end
		
		if distance > 100 then
			return 0.03
		else
			-- Finished dragging the target
			FindClearSpaceForUnit(target, target_loc, false)
			StopSoundEvent(sound_retract, caster)
			EmitSoundOn(sound_retract_stop, caster)
			if target:GetTeam() ~= caster:GetTeam() then
				ParticleManager:DestroyParticle(blood_particle, true)
				target:RemoveModifierByName(meat_hook_modifier)
			end

			-- This is to fix a visual bug when the target is very close to the caster
			Timers:CreateTimer(0.03, function() print("test?") hook_table[caster].bHitUnit = false end)
		end
	end)
end

--[[Author: Pizzalol
	Date: 1.1.2015.
	Stops the rot sound]]
function RotStopSound( keys )
	local caster = keys.caster
	local sound = "Hero_Pudge.Rot"

	StopSoundEvent(sound, caster)
end

function FleshHeapStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local stack_modifier = keys.stack_modifier
	local assists = caster:GetAssists()
	local kills = caster:GetKills()

	AddStacks(ability, caster, caster, stack_modifier, assists + kills, true)
	caster:SetModelScale(1.1 + 0.02 * caster:GetModifierStackCount(stack_modifier, ability))
end

function FleshHeapStack( keys )
	local caster = keys.caster
	local ability = keys.ability
	local stack_modifier = keys.stack_modifier

	AddStacks(ability, caster, caster, stack_modifier, 1, true)
	caster:SetModelScale(1.1 + 0.02 * caster:GetModifierStackCount(stack_modifier, ability))
end

function FleshHeapAdjust( keys )
	local caster = keys.caster
	local ability = keys.ability
	local stack_modifier = keys.stack_modifier

	AddStacks(ability, caster, caster, stack_modifier, 0, true)
end

function Dismember( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	-- Parameters
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability:GetLevel() - 1 )
	local str_mult = ability:GetLevelSpecialValueFor("str_multiplier", ability:GetLevel() - 1 )
	local caster_str = caster:GetStrength()

	-- Apply damage
	local damage = base_damage + caster_str * str_mult / 100
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = ability:GetAbilityDamageType()})
end