--[[ 	Author: D2imba & kritth
		Date: 16.05.2015	]]

function Impale ( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_projectile = keys.particle_projectile

	-- Parameters
	local width = ability:GetLevelSpecialValueFor("width", ability_level)
	local length = ability:GetLevelSpecialValueFor("length", ability_level)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)

	-- Adjust parameters if burrow buff is present
	if caster:HasModifier("modifier_nyx_assassin_burrow") then
		length = length * 1.75
		speed = speed * 1.75
	end

	-- Adjust based on cast range buffs
	length = length + GetCastRangeIncrease(caster)

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Launch projectile
	local impale_projectile = {
		Ability				= ability,
		EffectName			= particle_projectile,
		vSpawnOrigin		= caster:GetAbsOrigin(),
		fDistance			= length,
		fStartRadius		= width,
		fEndRadius			= width,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
	--	iUnitTargetFlags	= ,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
	--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= (target - caster:GetAbsOrigin()):Normalized() * speed,
		bProvidesVision		= false,
	--	iVisionRadius		= ,
	--	iVisionTeamNumber	= caster:GetTeamNumber(),
	}

	ProjectileManager:CreateLinearProjectile(impale_projectile)

end

function ImpaleDamage ( keys )
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
		local damage_to_repeat = target.impale_damage_taken * damage_pct *0.01

		-- Applies damage and plays landing sound
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage_to_repeat, damage_type = DAMAGE_TYPE_PURE})
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		if damage_to_repeat > 0 then
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, damage_to_repeat, nil)
		end
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

function SpikedCarapace( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stun = keys.modifier_stun

	-- Parameters
	local stun_radius = ability:GetLevelSpecialValueFor("burrow_stun_range", ability_level)

	-- If burrow buff is present, stun nearby enemies
	if caster:HasModifier("modifier_nyx_assassin_burrow") then
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), 0, FIND_ANY_ORDER, false)
		for _,enemy in pairs(nearby_enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_stun, {})
		end
	end
end

function SpikedCarapaceReflect( keys )
	local caster = keys.caster
	local ability = keys.ability
	local attacker = keys.attacker
	local damage_taken = keys.damage_taken
	local stun_modifier = keys.stun_modifier

	local attacker_health = attacker:GetHealth()
	
	-- Checks if the target is not spell immune
	if not attacker:IsMagicImmune() then

		-- Deals damage only to heroes
		if attacker:IsHero() then
			
			-- Uses HP removal to avoid infinite damage return loops. If the target's health would become <= 0, kills it
			if attacker_health <= damage_taken then
				ApplyDamage({attacker = caster, victim = attacker, ability = ability, damage = damage_taken, damage_type = DAMAGE_TYPE_PURE})
			else
				attacker:SetHealth(math.max(attacker_health - damage_taken, 5))
			end
		end

		-- Applies the stun
		if not attacker:HasModifier(stun_modifier) then
			ability:ApplyDataDrivenModifier(caster, attacker, stun_modifier, {})
		end
	end
end

function VendettaCast( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_vendetta = keys.modifier_vendetta
	local ability_carapace = keys.ability_carapace
	local current_ability = caster:GetCurrentActiveAbility()

	-- If the current ability being cast is Spiked Carapace, re-apply invisibility
	if current_ability and current_ability:GetName() == ability_carapace then
		local vendetta_modifier = caster:FindModifierByName(modifier_vendetta)
		local remaining_duration = vendetta_modifier:GetRemainingTime()

		Timers:CreateTimer(0.01, function()
			caster:AddNewModifier(caster, ability, "modifier_invisible", {duration = remaining_duration})
		end)
	else
		caster:RemoveModifierByName(modifier_vendetta)
	end
end

function Vendetta( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local modifier_vendetta = keys.modifier_vendetta

	-- Duration
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)

	-- If burrowed, unburrow first
	if caster:HasModifier("modifier_nyx_assassin_burrow") then
		local unburrow_ability = caster:FindAbilityByName("nyx_assassin_unburrow")
		caster:CastAbilityImmediately(unburrow_ability, caster:GetPlayerID())
	end

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Apply Vendetta and invisibility modifiers
	ability:ApplyDataDrivenModifier(caster, caster, modifier_vendetta, {})
	caster:AddNewModifier(caster, ability, "modifier_invisible", {duration = duration})
end

function VendettaStrike( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier
	local stack_modifier = keys.stack_modifier
	local particle_name = keys.particle_name
	local attack_sound = keys.attack_sound
	local base_damage = ability:GetLevelSpecialValueFor("bonus_damage", ability:GetLevel() - 1 )

	-- If the target is a structure, do nothing
	if target:IsBuilding() or target:IsTower() then
		caster:RemoveModifierByName(modifier)
		return nil
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
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, target, base_damage + stored_damage, nil)
	
	-- Remove the Vendetta buff
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

	-- If this is Rubick and Tidebringer is no longer present, do nothing and kill the modifiers
	if IsStolenSpell(caster) then
		if not caster:FindAbilityByName("imba_nyx_assassin_vendetta") then
			caster:RemoveModifierByName("modifier_imba_vendetta")
			caster:RemoveModifierByName("modifier_imba_vendetta_damage_counter")
			caster:RemoveModifierByName("modifier_imba_vendetta_damage_stacks")
			return nil
		end
	end

	-- Initialize the variable if it doesn't exist
	if not caster.vendetta_stored_damage then
		caster.vendetta_stored_damage = 0
	end

	-- Only stores hero-based damage
	if attacker:IsHero() and attacker:GetTeam() ~= caster:GetTeam() then
		caster.vendetta_stored_damage = caster.vendetta_stored_damage + damage_taken

		-- Caps the stored damage at [max_damage] if the user does not have Aghanim's scepter
		if caster.vendetta_stored_damage > max_damage and not scepter then
			caster.vendetta_stored_damage = max_damage
		end

		-- Updates the damage counter
		if not caster:HasModifier(stack_modifier) then
			ability:ApplyDataDrivenModifier(caster, caster, stack_modifier, {})
		end
		caster:SetModifierStackCount(stack_modifier, ability, math.floor( caster.vendetta_stored_damage / 10 ) )
	end
end