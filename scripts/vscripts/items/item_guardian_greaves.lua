--[[ 	Author: Firetoad
		Date: 07.08.2015	]]

function GuardianGreaves( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_hot = keys.modifier_hot
	local sound_cast = keys.sound_cast
	local sound_target = keys.sound_target
	local particle_cast = keys.particle_cast
	local particle_hero = keys.particle_hero
	local particle_creep = keys.particle_creep

	-- Parameters
	local hp_heal = ability:GetLevelSpecialValueFor("replenish_health", ability_level)
	local mana_heal = ability:GetLevelSpecialValueFor("replenish_mana", ability_level) * FRANTIC_MULTIPLIER
	local radius = ability:GetLevelSpecialValueFor("replenish_radius", ability_level)
	local caster_pos = caster:GetAbsOrigin()

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Play cast particle
	local guardian_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(guardian_pfx, 0, caster_pos)

	-- Purge debuffs from the caster
	caster:Purge(false, true, false, true, false)

	-- Find affected allies
	local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), 0, FIND_ANY_ORDER, false)
	for _,ally in pairs(nearby_allies) do

		-- Heal & replenish mana
		ally:Heal(hp_heal, caster)
		ally:GiveMana(mana_heal)

		-- Show hp & mana overhead messages
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, hp_heal, nil)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, ally, mana_heal, nil)

		-- Apply heal over time buff
		ability:ApplyDataDrivenModifier(caster, ally, modifier_hot, {})
		
		-- Play target sound
		ally:EmitSound(sound_target)

		-- Choose target particle
		local particle_target = particle_creep
		if ally:IsHero() then
			particle_target = particle_hero
		end

		-- Play target particle
		local target_pfx = ParticleManager:CreateParticle(particle_target, PATTACH_ABSORIGIN_FOLLOW, ally)
		ParticleManager:SetParticleControl(target_pfx, 0, ally:GetAbsOrigin())
	end
end

function GuardianGreavesAuto( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local heal_threshold = ability:GetLevelSpecialValueFor("heal_threshold", ability_level)

	-- If owner's HP is below the threshold, auto-cast Mend
	if not caster:IsIllusion() and caster:GetHealth() <= heal_threshold and ability:IsCooldownReady() then
	 	ability:StartCooldown(ability:GetCooldown(ability_level))
	 	GuardianGreaves(keys)
	end
end

function GuardianGreavesAura( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stacks = keys.modifier_stacks

	local max_health = target:GetMaxHealth()
	local current_health = target:GetHealth()
	local stack_amount = math.floor( ( max_health - current_health ) * 100 / max_health )

	if stack_amount > 0 then
		target:RemoveModifierByName(modifier_stacks)
		AddStacks(ability, caster, target, modifier_stacks, stack_amount, false)
	end
end