--[[	Author: D2imba
		Date: 23.05.2015	]]

function Purification( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target

	-- Effects
	local cast_sound = keys.cast_sound
	local aoe_particle = keys.aoe_particle
	local cast_particle = keys.cast_particle
	local hit_particle = keys.hit_particle

	-- Parameters
	local heal_base = ability:GetLevelSpecialValueFor("heal_base", ability_level)
	local heal_pct = ability:GetLevelSpecialValueFor("heal_pct", ability_level) * 0.01
	local damage_factor = ability:GetLevelSpecialValueFor("damage_factor", ability_level) * 0.01
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local target_pos = target:GetAbsOrigin()

	-- Increase healing if the target has enough health
	local heal = heal_base + target:GetMaxHealth() * heal_pct

	-- Heal the target
	target:Heal(heal, caster)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, heal, nil)

	-- Play cast sound and particles
	target:EmitSound(cast_sound)
	local aoe_pfx = ParticleManager:CreateParticle(aoe_particle, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(aoe_pfx, 0, target_pos)
	ParticleManager:SetParticleControl(aoe_pfx, 1, Vector(radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(aoe_pfx)
	local caster_pfx = ParticleManager:CreateParticle(cast_particle, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(caster_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(caster_pfx, 1, target_pos)
	ParticleManager:ReleaseParticleIndex(caster_pfx)

	-- Calculate damage
	local damage = heal * damage_factor

	-- Damage nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _,enemy in pairs(enemies) do
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})

		-- Play particle
		local hit_pfx = ParticleManager:CreateParticle(hit_particle, PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControlEnt(hit_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_pos, true)
		ParticleManager:SetParticleControlEnt(hit_pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(hit_pfx, 3, Vector(radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(hit_pfx)
	end
end

function PurificationDeath( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- If fatal damage was not dealt, do nothing
	if caster:GetHealth() > 2 then
		return nil
	end

	-- Effects
	local cast_sound = keys.cast_sound
	local aoe_particle = keys.aoe_particle
	local cast_particle = keys.cast_particle
	local hit_particle = keys.hit_particle

	-- Parameters
	local heal_base = ability:GetLevelSpecialValueFor("heal_base", ability_level)
	local heal_pct = ability:GetLevelSpecialValueFor("heal_pct", ability_level) * 0.01
	local damage_factor = ability:GetLevelSpecialValueFor("damage_factor", ability_level) * 0.01
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local passive_modifier = keys.passive_modifier
	local cooldown_modifier = keys.cooldown_modifier
	local caster_pos = caster:GetAbsOrigin()

	-- Increase healing based on the caster's health
	local heal = heal_base + caster:GetMaxHealth() * heal_pct

	-- Heal the caster
	caster:Heal(heal, caster)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, heal, nil)

	-- Play cast sound and particles
	caster:EmitSound(cast_sound)
	local aoe_pfx = ParticleManager:CreateParticle(aoe_particle, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(aoe_pfx, 0, caster_pos)
	ParticleManager:SetParticleControl(aoe_pfx, 1, Vector(radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(aoe_pfx)
	local caster_pfx = ParticleManager:CreateParticle(cast_particle, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(caster_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(caster_pfx, 1, caster_pos)
	ParticleManager:ReleaseParticleIndex(caster_pfx)

	-- Calculate damage
	local damage = heal * damage_factor

	-- Damage nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _,enemy in pairs(enemies) do
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})

		-- Play particle
		local hit_pfx = ParticleManager:CreateParticle(hit_particle, PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControlEnt(hit_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster_pos, true)
		ParticleManager:SetParticleControlEnt(hit_pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(hit_pfx, 3, Vector(radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(hit_pfx)
	end

	-- Remove the passive modifier and apply the cooldown one
	caster:RemoveModifierByName(passive_modifier)
	ability:ApplyDataDrivenModifier(caster, caster, cooldown_modifier, {})
end

function Repel( keys )
	local target = keys.target
	local caster = keys.caster

	target:Purge(false, true, false, true, false)
	caster:Purge(false, true, false, true, false)
end

function DegenAura( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_stacks = keys.modifier_stacks

	-- If the ability is disabled by Break, do nothing
	if caster.break_duration_left then
		return nil
	end
	
	-- Refreshes the debuff and adds stacks
	AddStacks(ability, caster, target, modifier_stacks, 1, true)
end

function GuardianAngel( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local modifier_buff = keys.modifier_buff
	local modifier_repel = keys.modifier_repel
	local scepter = HasScepter(caster)

	-- Parameters
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local repel_duration = ability:GetLevelSpecialValueFor("repel_duration", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)

	-- Scepter changes
	if scepter then
		radius = 25000
		duration = ability:GetLevelSpecialValueFor("duration_scepter", ability_level)
	end

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Iterate through allies in range
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,ally in pairs(allies) do
		
		-- Apply guardian angel modifier
		ability:ApplyDataDrivenModifier(caster, ally, modifier_buff, {duration = duration})

		-- Apply repel modifier
		ability:ApplyDataDrivenModifier(caster, ally, modifier_repel, {duration = repel_duration})
	end
end

function GuardianAngelParticle( keys )
	local caster = keys.caster
	local target = keys.target
	local particle_wings = keys.particle_wings
	local particle_halo = keys.particle_halo
	local particle_ally = keys.particle_ally
	local target_loc = target:GetAbsOrigin()

	-- If this unit is the caster, play special particles
	if target == caster then

		-- Special buff particle with wings
		target.guardian_angel_buff_pfx = ParticleManager:CreateParticle(particle_wings, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(target.guardian_angel_buff_pfx, 0, target_loc)
		ParticleManager:SetParticleControlEnt(target.guardian_angel_buff_pfx, 5, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_loc, true)

		-- Halo particle
		target.guardian_angel_halo_pfx = ParticleManager:CreateParticle(particle_halo, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(target.guardian_angel_halo_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_loc, true)

	-- Else, play regular particle
	else
		target.guardian_angel_buff_pfx = ParticleManager:CreateParticle(particle_ally, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(target.guardian_angel_buff_pfx, 0, target_loc)
	end
end

function GuardianAngelParticleDestroy( keys )
	local target = keys.target

	-- Destroy all particles (AND HUMANS!)
	ParticleManager:DestroyParticle(target.guardian_angel_buff_pfx, false)
	ParticleManager:ReleaseParticleIndex(target.guardian_angel_buff_pfx)
	target.guardian_angel_buff_pfx = nil

	-- I said ALL of them!
	if target.guardian_angel_halo_pfx then
		ParticleManager:DestroyParticle(target.guardian_angel_halo_pfx, true)
		ParticleManager:ReleaseParticleIndex(target.guardian_angel_halo_pfx)
		target.guardian_angel_halo_pfx = nil
	end
end