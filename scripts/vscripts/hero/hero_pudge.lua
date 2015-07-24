--[[ 	Authors: Pizzalol and D2imba
		Date: 10.07.2015				]]

function HookCast( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_cast_check = keys.modifier_cast_check
	local modifier_light = keys.modifier_light

	-- Parameters
	local base_range = ability:GetLevelSpecialValueFor("base_range", ability_level)
	local stack_range = ability:GetLevelSpecialValueFor("stack_range", ability_level)
	local cast_distance = ( target - caster:GetAbsOrigin() ):Length2D()
	caster.stop_hook_cast = nil

	-- Calculate actual cast range
	local light_stacks = caster:GetModifierStackCount(modifier_light, caster)
	local hook_range = base_range + stack_range * light_stacks

	-- Check if the target point is inside range, if not, stop casting and move closer
	if cast_distance > hook_range then

		-- Start moving
		caster:MoveToPosition(target)
		Timers:CreateTimer(0.1, function()

			-- Update distance and range
			cast_distance = ( target - caster:GetAbsOrigin() ):Length2D()
			light_stacks = caster:GetModifierStackCount(modifier_light, caster)
			hook_range = base_range + stack_range * light_stacks

			-- If it's not a legal cast situation and no other order was given, keep moving
			if cast_distance > hook_range and not caster.stop_hook_cast then
				return 0.1

			-- If another order was given, stop tracking the cast distance
			elseif caster.stop_hook_cast then
				caster:RemoveModifierByName(modifier_cast_check)
				caster.stop_hook_cast = nil

			-- If all conditions are met, cast Hook again
			else
				caster:CastAbilityOnPosition(target, ability, caster:GetPlayerID())
			end
		end)
		return nil
	end
end

function HookCastCheck( keys )
	local caster = keys.caster
	caster.stop_hook_cast = true
end

function MeatHook( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- If another hook is already out, refund mana cost and do nothing
	if caster.hook_launched then
		caster:GiveMana(ability:GetManaCost(ability_level))
		ability:EndCooldown()
		return nil
	end

	-- Set the global hook_launched variable
	caster.hook_launched = true

	-- Sound, particle and modifier keys
	local sound_extend = keys.sound_extend
	local sound_hit = keys.sound_hit
	local sound_scepter_hit = keys.sound_scepter_hit
	local sound_retract = keys.sound_retract
	local sound_retract_stop = keys.sound_retract_stop
	local particle_hook = keys.particle_hook
	local particle_hit = keys.particle_hit
	local particle_hit_scepter = keys.particle_hit_scepter
	local modifier_caster = keys.modifier_caster
	local modifier_target_enemy = keys.modifier_target_enemy
	local modifier_target_ally = keys.modifier_target_ally
	local modifier_dummy = keys.modifier_dummy
	local modifier_light = keys.modifier_light
	local modifier_sharp = keys.modifier_sharp
	
	-- Parameters
	local scepter = HasScepter(caster)
	local base_speed = ability:GetLevelSpecialValueFor("base_speed", ability_level)
	local hook_width = ability:GetLevelSpecialValueFor("hook_width", ability_level)
	local base_range = ability:GetLevelSpecialValueFor("base_range", ability_level)
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local stack_range = ability:GetLevelSpecialValueFor("stack_range", ability_level)
	local stack_speed = ability:GetLevelSpecialValueFor("stack_speed", ability_level)
	local stack_damage = ability:GetLevelSpecialValueFor("stack_damage", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)
	local damage_scepter = ability:GetLevelSpecialValueFor("damage_scepter", ability_level)
	local caster_loc = caster:GetAbsOrigin()
	local start_loc = caster_loc + caster:GetForwardVector() * hook_width

	-- Calculate range, speed, and damage
	local light_stacks = caster:GetModifierStackCount(modifier_light, caster)
	local sharp_stacks = caster:GetModifierStackCount(modifier_sharp, caster)
	local hook_speed = base_speed + stack_speed * light_stacks
	local hook_range = base_range + stack_range * light_stacks
	local hook_damage = base_damage + stack_damage * sharp_stacks

	-- Stun the caster for the hook duration
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})

	-- Play Hook launch sound
	caster:EmitSound(sound_extend)

	-- Create and set up the Hook dummy unit
	local hook_dummy = CreateUnitByName("npc_dummy_blank", start_loc, false, caster, caster, caster:GetTeam())
	hook_dummy:AddNewModifier(caster, nil, "modifier_phased", {})
	ability:ApplyDataDrivenModifier(caster, hook_dummy, modifier_dummy, {})
	hook_dummy:SetForwardVector(caster:GetForwardVector())

	-- Make the hook always visible to both teams
	caster:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, hook_range / hook_speed)
	caster:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, hook_range / hook_speed)
	
	-- Attach the Hook particle
	local hook_pfx = ParticleManager:CreateParticle(particle_hook, PATTACH_RENDERORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleAlwaysSimulate(hook_pfx)
	ParticleManager:SetParticleControlEnt(hook_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", caster_loc, true)
	ParticleManager:SetParticleControl(hook_pfx, 1, start_loc)
	ParticleManager:SetParticleControl(hook_pfx, 2, Vector(hook_speed, hook_range, hook_width) )
	ParticleManager:SetParticleControlEnt(hook_pfx, 6, hook_dummy, 5, "attach_hitloc", start_loc, false)
	ParticleManager:SetParticleControlEnt(hook_pfx, 7, caster, PATTACH_CUSTOMORIGIN, nil, caster_loc, true)

	-- Remove the caster's hook
	local weapon_hook = caster:GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
	if weapon_hook ~= nil then
		weapon_hook:AddEffects( EF_NODRAW )
	end

	-- Initialize Hook variables
	local hook_loc = start_loc
	local tick_rate = 0.03
	hook_speed = hook_speed * tick_rate

	local travel_distance = (hook_loc - caster_loc):Length2D()
	local hook_step = caster:GetForwardVector() * hook_speed

	local target_hit = false
	local target

	-- Main Hook loop
	Timers:CreateTimer(tick_rate, function()

		-- Check for valid units in the area
		local units = FindUnitsInRadius(caster:GetTeamNumber(), hook_loc, nil, hook_width, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,unit in pairs(units) do
			if unit ~= caster and unit ~= hook_dummy and not unit:IsAncient() then
				target_hit = true
				target = unit
				break
			end
		end

		-- If a valid target was hit, start dragging them
		if target_hit then

			-- Apply stun/root modifier, and damage if the target is an enemy
			if caster:GetTeam() == target:GetTeam() then
				ability:ApplyDataDrivenModifier(caster, target, modifier_target_ally, {})
			else
				ability:ApplyDataDrivenModifier(caster, target, modifier_target_enemy, {})
				ApplyDamage({attacker = caster, victim = target, ability = ability, damage = hook_damage, damage_type = DAMAGE_TYPE_PURE})
			end

			-- Play the hit sound and particle
			target:EmitSound(sound_hit)
			local hook_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, target)

			-- If Pudge has scepter, play the Rupture sound effect
			if scepter and target:GetTeam() ~= caster:GetTeam() then
				target:EmitSound(sound_scepter_hit)
			end

			-- Grant vision on the hook hit area
			ability:CreateVisibilityNode(hook_loc, vision_radius, vision_duration)
		end

		-- If no target was hit and the maximum range is not reached, move the hook and keep going
		if not target_hit and travel_distance < hook_range then

			-- Move the hook
			hook_dummy:SetAbsOrigin(hook_loc + hook_step)

			-- Recalculate position and distance
			hook_loc = hook_dummy:GetAbsOrigin()
			travel_distance = (hook_loc - caster_loc):Length2D()
			return tick_rate
		end

		-- If we are here, this means the hook has to start reeling back; prepare return variables
		local direction = ( caster_loc - hook_loc )

		-- Stop the extending sound and start playing the return sound
		StopSoundEvent(sound_extend, caster)
		caster:EmitSound(sound_retract)

		-- Remove the caster's self-stun
		caster:RemoveModifierByName(modifier_caster)

		-- Play sound reaction according to which target was hit
		if target_hit and target:IsRealHero() and target:GetTeam() ~= caster:GetTeam() then
			caster:EmitSound("pudge_pud_ability_hook_0"..RandomInt(1,9))
		elseif target_hit and target:IsRealHero() and target:GetTeam() == caster:GetTeam() then
			caster:EmitSound("pudge_pud_ability_hook_miss_01")
		elseif target_hit then
			caster:EmitSound("pudge_pud_ability_hook_miss_0"..RandomInt(2,6))
		else
			caster:EmitSound("pudge_pud_ability_hook_miss_0"..RandomInt(8,9))
		end

		-- Hook reeling loop
		Timers:CreateTimer(tick_rate, function()

			-- Recalculate position variables
			caster_loc = caster:GetAbsOrigin()
			hook_loc = hook_dummy:GetAbsOrigin()
			direction = ( caster_loc - hook_loc )
			hook_step = direction:Normalized() * hook_speed
			
			-- If the target is close enough, finalize the hook return
			if direction:Length2D() < hook_speed then

				-- Stop moving the target
				if target_hit then
					local final_loc = caster_loc + caster:GetForwardVector() * 100
					FindClearSpaceForUnit(target, final_loc, false)

					-- Remove the target's modifiers
					target:RemoveModifierByName(modifier_target_ally)
					target:RemoveModifierByName(modifier_target_enemy)
				end

				-- Destroy the hook dummy and particles
				hook_dummy:Destroy()
				ParticleManager:DestroyParticle(hook_pfx, false)

				-- Stop playing the reeling sound
				StopSoundEvent(sound_retract, caster)
				caster:EmitSound(sound_retract_stop)

				-- Give back the caster's hook
				if weapon_hook ~= nil then
					weapon_hook:RemoveEffects( EF_NODRAW )
				end

				-- Clear global variables
				caster.hook_launched = nil

			-- If this is not the final step, keep reeling the hook in
			else

				-- Move the hook and an eventual target
				hook_dummy:SetAbsOrigin(hook_loc + hook_step)

				if target_hit then
					target:SetAbsOrigin(hook_loc + hook_step)
					target:SetForwardVector(direction:Normalized())
					ability:CreateVisibilityNode(hook_loc, vision_radius, 0.5)

					-- If Pudge has scepter, deal damage on every step
					if scepter and target:GetTeam() ~= caster:GetTeam() then
						local step_damage = damage_scepter * hook_speed / 1000
						ApplyDamage({attacker = caster, victim = target, ability = ability, damage = step_damage, damage_type = DAMAGE_TYPE_PURE})
						local rupture_pfx = ParticleManager:CreateParticle(particle_hit_scepter, PATTACH_ABSORIGIN, target)
					end
				end
				
				return tick_rate
			end
		end)
	end)
end

function HookUpgrade( keys )
	local caster = keys.caster
	local ability_level = keys.ability:GetLevel()
	local ability_sharp = caster:FindAbilityByName(keys.ability_sharp)
	local ability_light = caster:FindAbilityByName(keys.ability_light)

	-- Level up sharp and light hook abilities
	ability_sharp:SetLevel(ability_level)
	ability_light:SetLevel(ability_level)
end

function HookStacksUpdater( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_sharp = keys.modifier_sharp
	local modifier_light = keys.modifier_light

	-- Parameters
	local sharp_stacks = caster:GetModifierStackCount(modifier_sharp, caster)
	local light_stacks = caster:GetModifierStackCount(modifier_light, caster)
	local caster_level = caster:GetLevel()

	-- Check if caster level is greater than twice the amount of stacks
	if (caster_level * 2) > ( sharp_stacks + light_stacks ) then
		AddStacks(ability, caster, caster, modifier_sharp, 1, true)
		AddStacks(ability, caster, caster, modifier_light, 1, true)
	end
end

function SharpHookToggle( keys )
	local caster = keys.caster
	local ability_light = caster:FindAbilityByName(keys.ability_light)

	if ability_light:GetToggleState() then
		ability_light:ToggleAbility()
	end
end

function LightHookToggle( keys )
	local caster = keys.caster
	local ability_sharp = caster:FindAbilityByName(keys.ability_sharp)

	if ability_sharp:GetToggleState() then
		ability_sharp:ToggleAbility()
	end
end

function SharpHook( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_hook = caster:FindAbilityByName(keys.ability_hook)
	local modifier_sharp = keys.modifier_sharp
	local modifier_light = keys.modifier_light

	-- If there are no stacks of Light Hook, do nothing and toggle the skill off
	if not caster:HasModifier(modifier_light) then
		ability:ToggleAbility()
		return nil
	end

	-- Fetch the amount of Light Hook stacks
	local light_stacks = caster:GetModifierStackCount(modifier_light, caster)

	-- If the amount of Light Hook stacks is 1, remove the buff
	if light_stacks <= 1 then
		caster:RemoveModifierByName(modifier_light)

	-- If not, just remove 1 stack from it
	else
		AddStacks(ability_hook, caster, caster, modifier_light, -1, true)
	end

	-- Add a stack of Sharp Hook
	AddStacks(ability_hook, caster, caster, modifier_sharp, 1, true)
end

function LightHook( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_hook = caster:FindAbilityByName(keys.ability_hook)
	local modifier_sharp = keys.modifier_sharp
	local modifier_light = keys.modifier_light

	-- If there are no stacks of Sharp Hook, do nothing and toggle the skill off
	if not caster:HasModifier(modifier_sharp) then
		ability:ToggleAbility()
		return nil
	end

	-- Fetch the amount of Sharp Hook stacks
	local sharp_stacks = caster:GetModifierStackCount(modifier_sharp, caster)

	-- If the amount of Sharp Hook stacks is 1, remove the buff
	if sharp_stacks <= 1 then
		caster:RemoveModifierByName(modifier_sharp)

	-- If not, just remove 1 stack from it
	else
		AddStacks(ability_hook, caster, caster, modifier_sharp, -1, true)
	end

	-- Add a stack of Light Hook
	AddStacks(ability_hook, caster, caster, modifier_light, 1, true)
end

function Rot( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_slow= keys.modifier_slow
	local modifier_heap = keys.modifier_heap

	-- Parameters
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local stack_damage = ability:GetLevelSpecialValueFor("stack_damage", ability_level)
	local base_radius = ability:GetLevelSpecialValueFor("base_radius", ability_level)
	local stack_radius = ability:GetLevelSpecialValueFor("stack_radius", ability_level)
	local max_radius = ability:GetLevelSpecialValueFor("max_radius", ability_level)
	local rot_tick = ability:GetLevelSpecialValueFor("rot_tick", ability_level)

	-- Retrieve flesh heap stacks
	local heap_stacks = 0
	if caster:HasModifier(modifier_heap) then
		heap_stacks = caster:GetModifierStackCount(modifier_heap, caster)
	end

	-- Calculate damage and radius
	local damage = base_damage * ( ( 100 + heap_stacks * stack_damage ) * rot_tick ) / 100
	local radius = math.min( base_radius + stack_radius * heap_stacks , max_radius)

	-- Damage the caster
	ApplyDamage({attacker = caster, victim = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Deal damage and apply slow
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,unit in pairs(units) do
		ApplyDamage({attacker = caster, victim = unit, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		ability:ApplyDataDrivenModifier(caster, unit, modifier_slow, {})
	end
end

function RotParticle( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_heap = keys.modifier_heap
	local rot_particle= keys.rot_particle

	-- Parameters
	local base_radius = ability:GetLevelSpecialValueFor("base_radius", ability_level)
	local stack_radius = ability:GetLevelSpecialValueFor("stack_radius", ability_level)
	local max_radius = ability:GetLevelSpecialValueFor("max_radius", ability_level)

	-- Retrieve flesh heap stacks
	local heap_stacks = 0
	if caster:HasModifier(modifier_heap) then
		heap_stacks = caster:GetModifierStackCount(modifier_heap, caster)
	end

	-- Calculate radius
	local radius = math.min( base_radius + stack_radius * heap_stacks , max_radius)

	-- Draw the particle
	caster.rot_fx = ParticleManager:CreateParticle(rot_particle, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(caster.rot_fx, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl(caster.rot_fx, 1, Vector(radius,0,0) )
end

function RotResponse( keys )
	local caster = keys.caster

	-- Play pudge's voice reaction
	local random_int = RandomInt(7,13)
	if random_int < 10 then
		caster:EmitSound("pudge_pud_ability_rot_0"..random_int)
	else
		caster:EmitSound("pudge_pud_ability_rot_"..random_int)
	end
end

function RotEnd( keys )
	local caster = keys.caster
	local rot_sound = keys.rot_sound

	StopSoundEvent(rot_sound, caster)
	ParticleManager:DestroyParticle(caster.rot_fx, false)
end

function FleshHeapUpgrade( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_bonus = keys.modifier_bonus
	local modifier_stacks = keys.modifier_stacks

	-- Parameters
	local stack_scale_up = ability:GetLevelSpecialValueFor("stack_scale_up", ability_level)
	local stack_amount

	-- If Heap is already learned, fetch the current amount of stacks
	if caster.heap_stacks then
		stack_amount = caster.heap_stacks

	-- Else, fetch kills/assists up to this point of the game (lazy way to make Heap retroactive)
	else
		local assists = caster:GetAssists()
		local kills = caster:GetKills()	
		stack_amount = kills + assists

		-- Define the global variable which keeps track of heap stacks
		caster.heap_stacks = stack_amount
	end
	
	-- Remove both modifiers in order to update their bonuses
	caster:RemoveModifierByName(modifier_stacks)
	for i = 1, stack_amount do
		caster:RemoveModifierByName(modifier_bonus)
	end

	-- Add stacks of the real (hidden) bonus modifier
	for i = 1, stack_amount do
		ability:ApplyDataDrivenModifier(caster, caster, modifier_bonus, {})
	end

	-- Add stacks of the fake modifier
	AddStacks(ability, caster, caster, modifier_stacks, stack_amount, true)

	-- Make pudge GROW
	caster:SetModelScale( math.min( 1 + stack_scale_up * stack_amount / 100, 1.8) )
end

function FleshHeap( keys )
	local caster = keys.caster

	-- Update the global heap stacks variable
	caster.heap_stacks = caster.heap_stacks + 1

	-- Play pudge's voice reaction
	caster:EmitSound("pudge_pud_ability_heap_0"..RandomInt(1,2))
end

function HeapUpdater( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_bonus = keys.modifier_bonus
	local modifier_stacks = keys.modifier_stacks

	-- Parameters
	local stack_scale_up = ability:GetLevelSpecialValueFor("stack_scale_up", ability_level)
	local stack_amount = caster:GetModifierStackCount(modifier_stacks, caster)

	-- If the amount of stacks has increased, update it
	if caster.heap_stacks > stack_amount then

		-- Add a stack of the real (hidden) bonus modifier
		ability:ApplyDataDrivenModifier(caster, caster, modifier_bonus, {})

		-- Add a stack of the fake modifier
		AddStacks(ability, caster, caster, modifier_stacks, 1, true)

		-- Make pudge GROW
		caster:SetModelScale( math.min( 1 + stack_scale_up * stack_amount / 100, 1.8) )
	end
end

function Dismember( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_target = keys.particle_target

	-- Parameters
	local dismember_damage = ability:GetLevelSpecialValueFor("dismember_damage", ability_level)
	local strength_damage = ability:GetLevelSpecialValueFor("strength_damage", ability_level)
	local caster_str = caster:GetStrength()

	-- Calculate damage/heal
	local damage = dismember_damage + caster_str * strength_damage / 100

	-- Apply damage/heal
	caster:Heal(damage, caster)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, damage, nil)
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Play the particle
	local blood_pfx = ParticleManager:CreateParticle(particle_target, PATTACH_ABSORIGIN, target)
end