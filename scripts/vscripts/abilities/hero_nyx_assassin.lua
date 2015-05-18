--[[ 	Author: D2imba & kritth
		Date: 16.05.2015	]]

function Impale ( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local land_sound = keys.land_sound

	-- Parameters
	local damage_delay = ability:GetLevelSpecialValueFor("air_time", ability_level)
	local damage_pct = ability:GetLevelSpecialValueFor("damage_repeat", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)

	-- Initializes the global variable if it doesn't exist
	if not target.impale_damage_taken then
		target.impale_damage_taken = 0
	end

	-- Wait for the target to land, in [damage_delay] time
	Timers:CreateTimer(damage_delay, function()
		-- Calculates damage to repeat and total damage
		local damage_to_repeat = target.impale_damage_taken * damage_pct / 100

		-- Applies damage and plays landing sound
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage_to_repeat, damage_type = DAMAGE_TYPE_PURE})
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		target:EmitSound(land_sound)
	end)
end

function ImpaleDamageCounter( keys )
	local target = keys.unit
	local damage = keys.damage
	local ability = keys.ability
	local damage_duration = ability:GetLevelSpecialValueFor("damage_duration", ability:GetLevel() - 1 )

	-- Initializes the global variable if it doesn't exist
	if not target.impale_damage_taken then
		target.impale_damage_taken = 0
	end

	-- Adds damage to the rolling sum
	target.impale_damage_taken = target.impale_damage_taken + damage

	-- After [damage duration], removes the damage from the rolling sum
	Timers:CreateTimer(damage_duration, function()
		target.impale_damage_taken = target.impale_damage_taken - damage
	end)
end

function SpikedCarapaceReflect( keys )
	local caster = keys.caster
	local ability = keys.ability
	local attacker = keys.attacker
	local damage_taken = keys.damage_taken
	local stun_modifier = keys.stun_modifier
	local caster_health = caster:GetHealth()

	-- Prevents damage
	caster:SetHealth( caster_health + damage_taken )
	
	-- Checks if the target is not spell immune
	if not attacker:IsMagicImmune() then

		-- Deals damage only to heroes
		if attacker:IsHero() then
			-- Uses HP removal to avoid infinite damage return loops. If the target's health is <= 0, kills it
			if attacker:GetHealth() <= damage_taken then
				attacker:Kill(ability, caster)
			else
				attacker:SetHealth( attacker:GetHealth() - damage_taken )
			end
		end

		-- Applies the stun
		if not attacker:HasModifier(stun_modifier) then
			ability:ApplyDataDrivenModifier(caster, attacker, stun_modifier, {})
		end
	end
end

function Vendetta( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier
	local stack_modifier = keys.stack_modifier
	local particle_name = keys.particle_name
	local attack_sound = keys.attack_sound
	local base_damage = ability:GetLevelSpecialValueFor("bonus_damage", ability:GetLevel() - 1 )
	local scepter = HasScepter(caster)

	-- If the user has Aghanim's Scepter, shorten the cooldown
	if scepter then
		local scepter_cooldown = ability:GetLevelSpecialValueFor("cooldown_scepter", ability:GetLevel() - 1 )
		ability:StartCooldown(scepter_cooldown)
	end

	-- Initialize the variable if it doesn't exist
	if not caster.vendetta_stored_damage then
		caster.vendetta_stored_damage = 0
	end

	-- Retrieve and reset the stored Vendetta damage
	local stored_damage = caster.vendetta_stored_damage
	caster.vendetta_stored_damage = nil
	caster:RemoveModifierByName(stack_modifier)

	-- Fire particle effects and sound
	local vendetta_fx = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(vendetta_fx, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl(vendetta_fx, 1, target:GetAbsOrigin() )
	
	target:EmitSound(attack_sound)

	-- Apply damage	
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = base_damage + stored_damage, damage_type = ability:GetAbilityDamageType()})
	
	caster:RemoveModifierByName(modifier)
end

function VendettaDamageCount( keys )
	local caster = keys.caster
	local ability = keys.ability
	local attacker = keys.attacker
	local damage_taken = keys.damage_taken
	local stack_modifier = keys.stack_modifier
	local max_damage = ability:GetLevelSpecialValueFor("damage_storage", ability:GetLevel() - 1 )
	local scepter = HasScepter(caster)

	-- Initialize the variable if it doesn't exist
	if not caster.vendetta_stored_damage then
		caster.vendetta_stored_damage = 0
	end

	-- Only stores hero-based damage
	if attacker:IsHero() then
		caster.vendetta_stored_damage = caster.vendetta_stored_damage + damage_taken

		-- Caps the stored damage at [max_damage] if the user does not have Aghanim's scepter
		if caster.vendetta_stored_damage > max_damage and not scepter then
			caster.vendetta_stored_damage = max_damage
		end

		-- Updates the damage counter
		if not caster:HasModifier(stack_modifier) then
			ability:ApplyDataDrivenModifier(caster, caster, stack_modifier, {})
		end
		caster:SetModifierStackCount(stack_modifier, ability, caster.vendetta_stored_damage)
	end
end