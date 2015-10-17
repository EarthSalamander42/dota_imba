--[[	Author: Firetoad
		Date:	11.10.2015	]]

function VanguardBlock( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = keys.damage
	local block_sound = keys.block_sound

	-- If the owner has a higher tier of Vanguard, do nothing
	if caster:HasModifier("modifier_item_crimson_guard_unique") or caster:HasModifier("modifier_item_crimson_guard_active") or caster:HasModifier("modifier_item_greatwyrm_plate_unique") or caster:HasModifier("modifier_item_greatwyrm_plate_active") then
		return nil
	end

	-- Parameters
	local proc_chance = ability:GetLevelSpecialValueFor("proc_chance", ability_level)
	local damage_block = ability:GetLevelSpecialValueFor("damage_block", ability_level)
	local damage_to_block = 0

	-- If damage is less or the same as the damage block, just block all of it
	if damage <= damage_block then
		damage_to_block = damage

	-- Else, roll for a proc
	elseif RandomInt(1, 100) <= proc_chance then

		-- Play the block sound
		caster:EmitSound(block_sound)

		-- Block all damage
		damage_to_block = damage

	-- Else, block the normal amount
	else
		damage_to_block = damage_block
	end
	
	-- Prevent damage
	caster:SetHealth(caster:GetHealth() + damage_to_block)

	-- Play block message
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, caster, damage_to_block, nil)
end

function CrimsonGuard( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_active = keys.modifier_active
	local sound_cast = keys.sound_cast
	local particle_cast = keys.particle_cast

	-- Parameters
	local active_radius = ability:GetLevelSpecialValueFor("active_radius", ability_level)

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Play particle
	local cast_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(cast_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(cast_pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(cast_pfx, 2, Vector(active_radius, 0, 0))

	-- Find nearby allies
	local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, active_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)

	-- Apply the active buff to nearby allies
	for _,ally in pairs(nearby_allies) do
		if not ally:HasModifier("modifier_item_crimson_guard_unique") and not ally:HasModifier("modifier_item_greatwyrm_plate_active") and not ally:HasModifier("modifier_item_greatwyrm_plate_unique") then
			ability:ApplyDataDrivenModifier(caster, ally, modifier_active, {})			
		end
	end
end

function CrimsonGuardParticle( keys )
	local target = keys.target
	local particle_guard = keys.particle_guard
	
	-- Create the Crimson Guard particle
	target.crimson_guard_pfx = ParticleManager:CreateParticle(particle_guard, PATTACH_OVERHEAD_FOLLOW, target)
	ParticleManager:SetParticleControl(target.crimson_guard_pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(target.crimson_guard_pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
end

function CrimsonGuardParticleEnd( keys )
	local target = keys.target
	
	-- Destroy the Crimson Guard particle
	ParticleManager:DestroyParticle(target.crimson_guard_pfx, false)
end

function CrimsonGuardBlock( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = keys.damage
	local block_sound = keys.block_sound

	-- If the owner has a higher tier of Vanguard, do nothing
	if caster:HasModifier("modifier_item_greatwyrm_plate_unique") or caster:HasModifier("modifier_item_greatwyrm_plate_active") then
		return nil
	end

	-- Parameters
	local proc_chance = ability:GetLevelSpecialValueFor("proc_chance", ability_level)
	local damage_block = ability:GetLevelSpecialValueFor("damage_block", ability_level)
	local damage_to_block = 0

	-- If damage is less or the same as the damage block, just block all of it
	if damage <= damage_block then
		damage_to_block = damage

	-- Else, roll for a proc
	elseif RandomInt(1, 100) <= proc_chance then

		-- Play the block sound
		target:EmitSound(block_sound)

		-- Block all damage
		damage_to_block = damage

	-- Else, block the normal amount
	else
		damage_to_block = damage_block
	end
	
	-- Prevent damage
	target:SetHealth(target:GetHealth() + damage_to_block)

	-- Play block message
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, damage_to_block, nil)
end

function GreatwyrmPlate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_active = keys.modifier_active
	local sound_cast = keys.sound_cast
	local particle_cast = keys.particle_cast

	-- Parameters
	local active_radius = ability:GetLevelSpecialValueFor("active_radius", ability_level)
	local cooldown = ability:GetCooldownTimeRemaining()

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Play particle
	local cast_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(cast_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(cast_pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(cast_pfx, 2, Vector(active_radius, 0, 0))

	-- Find nearby allies
	local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, active_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)

	-- Apply the active buff to nearby allies
	for _,ally in pairs(nearby_allies) do
		if not ally:HasModifier("modifier_item_crimson_guard_unique") and not ally:HasModifier("modifier_item_greatwyrm_plate_unique") then
			ally:RemoveModifierByName("modifier_item_crimson_guard_active")
			ability:ApplyDataDrivenModifier(caster, ally, modifier_active, {})
		end
	end
end

function GreatwyrmParticle( keys )
	local target = keys.target
	local particle_guard = keys.particle_guard
	
	-- Create the Crimson Guard particle
	target.greatwyrm_plate_pfx = ParticleManager:CreateParticle(particle_guard, PATTACH_OVERHEAD_FOLLOW, target)
	ParticleManager:SetParticleControl(target.greatwyrm_plate_pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(target.greatwyrm_plate_pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
end

function GreatwyrmParticleEnd( keys )
	local target = keys.target
	
	-- Destroy the Crimson Guard particle
	ParticleManager:DestroyParticle(target.greatwyrm_plate_pfx, false)
end

function GreatwyrmBlockAttack( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = keys.damage
	local block_sound = keys.block_sound
	local modifier_prevent = keys.modifier_prevent

	-- Parameters
	local proc_chance = ability:GetLevelSpecialValueFor("proc_chance", ability_level)
	local damage_block = ability:GetLevelSpecialValueFor("damage_block", ability_level)
	local damage_to_block = 0

	-- Apply block prevention modifier (prevents double block/heal)
	ability:ApplyDataDrivenModifier(caster, target, modifier_prevent, {})

	-- If damage is less or the same as the damage block, just block all of it
	if damage <= damage_block then
		damage_to_block = damage

	-- Else, roll for a proc
	elseif RandomInt(1, 100) <= proc_chance then

		-- Play the block sound
		target:EmitSound(block_sound)

		-- Block all damage
		damage_to_block = damage

	-- Else, block the normal amount
	else
		damage_to_block = damage_block
	end
	
	-- Prevent damage
	target:SetHealth(target:GetHealth() + damage_to_block)

	-- Play block message
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, damage_to_block, nil)
end

function GreatwyrmBlockDamage( keys )
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = keys.damage
	local block_sound = keys.block_sound
	local modifier_prevent = keys.modifier_prevent

	-- If target has block prevention modifier, do nothing
	if target:HasModifier(modifier_prevent) then
		return nil
	end

	-- Parameters
	local proc_chance = ability:GetLevelSpecialValueFor("proc_chance", ability_level)

	-- Roll for a proc
	if RandomInt(1, 100) <= proc_chance then

		-- Play the block sound
		target:EmitSound(block_sound)

		-- Prevent damage
		target:SetHealth(target:GetHealth() + damage)

		-- Play block message
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, damage, nil)
	end
end