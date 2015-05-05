function DeathPulse( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local stack_buff = keys.stack_buff
	local stack_debuff = keys.stack_debuff

	-- Ability parameters
	local ability_level = ability:GetLevel() - 1
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local heal = ability:GetLevelSpecialValueFor("heal", ability_level)
	local stack_power = ability:GetLevelSpecialValueFor("stack_power", ability_level)

	local stack_count

	-- The buff and debuff are separate modifiers, for cases such as spell-stolen death pulse, or same-hero modes.
	if target:GetTeam() == caster:GetTeam() then
		if target:HasModifier(stack_buff) then
			stack_count = target:GetModifierStackCount(stack_buff, ability)
		else
			stack_count = 0
		end
		heal = heal * (1 + stack_power * stack_count / 100)
		target:Heal(heal, caster)
		AddStacks(ability, caster, target, stack_buff, 1, true)
	else
		if target:HasModifier(stack_debuff) then
			stack_count = target:GetModifierStackCount(stack_debuff, ability)
		else
			stack_count = 0
		end
		damage = damage * (1 + stack_power * stack_count / 100)
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		AddStacks(ability, caster, target, stack_debuff, 1, true)
	end
end

function Heartstopper( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local stack_modifier = keys.stack_modifier
	local visibility_modifier = keys.visible_modifier

	-- Ability parameters
	local ability_level = ability:GetLevel() - 1
	local damage = ability:GetLevelSpecialValueFor("aura_damage", ability_level)
	local damage_interval = ability:GetLevelSpecialValueFor("aura_damage_interval", ability_level)
	local stack_power = ability:GetLevelSpecialValueFor("stack_power", ability_level)

	-- Calculate damage
	AddStacks(ability, caster, target, stack_modifier, 1, true)
	local max_hp = target:GetMaxHealth()
	local stack_count = target:GetModifierStackCount(stack_modifier, ability)
	damage = damage * max_hp * ( 1 + stack_power * stack_count / 100 ) / 100
	
	-- Damage is dealt by modifying the target's HP directly (HP removal). Deals 1 pure damage to kill targets when appropriate
	if target:GetHealth() <= damage then
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})
	else
		target:SetHealth(target:GetHealth() - damage)
	end

	-- Modifier is only visible if the enemy team has vision of Necrophos
	if target:CanEntityBeSeenByMyTeam(caster) then
		if not target:HasModifier(visibility_modifier) then
			ability:ApplyDataDrivenModifier(caster, target, visibility_modifier, {})
		end
		target:SetModifierStackCount(visibility_modifier, ability, target:GetModifierStackCount(stack_modifier, ability) )
	else
		target:RemoveModifierByName(visibility_modifier)
	end
end

function HeartstopperEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local stack_modifier = keys.stack_modifier
	local visibility_modifier = keys.visible_modifier

	local stack_count = target:GetModifierStackCount(stack_modifier, ability)
	RemoveStacks(ability, target, stack_modifier, stack_count)
	stack_count = target:GetModifierStackCount(visibility_modifier, ability)
	RemoveStacks(ability, target, visibility_modifier, stack_count)
end

function Sadist( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.unit
	local regen_modifier = keys.regen_modifier

	local hero_multiplier = ability:GetLevelSpecialValueFor("hero_multiplier", ability:GetLevel() - 1 )

	if target:IsRealHero() then
		for i = 1, hero_multiplier do
			ability:ApplyDataDrivenModifier(caster, caster, regen_modifier, {})
		end
	else
		ability:ApplyDataDrivenModifier(caster, caster, regen_modifier, {})
	end
end

function ApplySadist( keys )
	local caster = keys.caster
	local ability = keys.ability
	local stack_modifier = keys.stack_modifier

	AddStacks(ability, caster, caster, stack_modifier, 1, true)
end

function RemoveSadist( keys )
	local caster = keys.caster
	local ability = keys.ability
	local stack_modifier = keys.stack_modifier

	RemoveStacks(ability, caster, stack_modifier, 1)
end

function ReapersScythe( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local respawn_base = ability:GetLevelSpecialValueFor("respawn_base", ability_level)
	local respawn_stack = ability:GetLevelSpecialValueFor("respawn_stack", ability_level)
	local damage_delay = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local particle_delay = ability:GetLevelSpecialValueFor("animation_delay", ability_level)
	local reap_particle = keys.reap_particle
	local scythe_particle = keys.scythe_particle
	local scepter = HasScepter(caster)

	if scepter then
		damage = ability:GetLevelSpecialValueFor("damage_scepter", ability_level)
	end

	-- Initializes the respawn time variable if necessary
	if not target.scythe_added_respawn then
		target.scythe_added_respawn = 0
	end

	-- Scythe model particle
	Timers:CreateTimer(particle_delay, function()
		local scythe_fx = ParticleManager:CreateParticle(scythe_particle, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(scythe_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(scythe_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		end)

	-- Waits for damage_delay to apply damage
	Timers:CreateTimer(damage_delay, function()

		-- Reaping particle
		local reap_fx = ParticleManager:CreateParticle(reap_particle, PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(reap_fx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(reap_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

		-- Calculates and deals damage
		local damage_bonus = 1 - target:GetHealth() / target:GetMaxHealth() 
		damage = damage * target:GetMaxHealth() * (1 + damage_bonus) / 100
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})

		-- Checking if target is alive to decide if it needs to increase respawn time
		if not target:IsAlive() then
			target:SetTimeUntilRespawn(target:GetRespawnTime() + respawn_base + target.scythe_added_respawn)
			target.scythe_added_respawn = target.scythe_added_respawn + respawn_stack
			if scepter then
				target:SetBuyBackDisabledByReapersScythe(true)
			end
		end
	end)
end