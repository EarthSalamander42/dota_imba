--[[ 	Author: D2imba
		Date: 27.04.2015	]]

function DeathPulse( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_ally = keys.particle_ally
	local particle_enemy = keys.particle_enemy
	local modifier_caster = keys.modifier_caster
	local mana_cost = keys.mana_cost

	-- Parameters
	local area_of_effect = ability:GetLevelSpecialValueFor("area_of_effect", ability_level)
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)

	-- If the caster doesn't have enough mana, toggle the skill off
	if caster:GetMana() < mana_cost then
		ability:ToggleAbility()
		return nil

	-- Else, spend mana and move on
	else
		caster:SpendMana(mana_cost, ability)
	end

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Apply caster modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})

	-- Create projectile for nearby units
	local nearby_units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, area_of_effect, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	for _,unit in pairs(nearby_units) do
		if unit:GetTeam() == caster:GetTeam() then

			-- Allied projectile parameters
			local projectile = {
				Target = unit,
				Source = caster,
				Ability = ability,
				EffectName = particle_ally,
				bDodgeable = false,
				bProvidesVision = false,
				iMoveSpeed = projectile_speed,
			--	iVisionRadius = vision_radius,
			--	iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}

			-- Create the projectile
			ProjectileManager:CreateTrackingProjectile(projectile)
		else

			-- Enemy projectile parameters
			local projectile = {
				Target = unit,
				Source = caster,
				Ability = ability,
				EffectName = particle_enemy,
				bDodgeable = false,
				bProvidesVision = false,
				iMoveSpeed = projectile_speed,
			--	iVisionRadius = vision_radius,
			--	iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}

			-- Create the projectile
			ProjectileManager:CreateTrackingProjectile(projectile)
		end
	end
end

function DeathPulseEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_caster = keys.modifier_caster

	-- Parameters
	local cast_cooldown = ability:GetLevelSpecialValueFor("cast_cooldown", ability_level) / FRANTIC_MULTIPLIER

	-- Remove caster modifier
	caster:RemoveModifierByName(modifier_caster)

	-- Put the skill on cooldown
	ability:StartCooldown(cast_cooldown)
end

		
function DeathPulseHit( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local stack_buff = keys.stack_buff
	local stack_debuff = keys.stack_debuff

	-- If the ability is gone (Random OMG), do nothing
	if not ability then
		return nil
	end

	-- Ability parameters
	local ability_level = ability:GetLevel() - 1
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local heal = ability:GetLevelSpecialValueFor("heal", ability_level)
	local stack_power = ability:GetLevelSpecialValueFor("stack_power", ability_level)
	local stack_cap = ability:GetLevelSpecialValueFor("stack_cap", ability_level)

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
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, heal, nil)
		if stack_count < stack_cap then
			AddStacks(ability, caster, target, stack_buff, 1, true)
		else
			AddStacks(ability, caster, target, stack_buff, 0, true)
		end
	elseif not target:IsMagicImmune() then
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		if target:HasModifier(stack_debuff) then
			stack_count = target:GetModifierStackCount(stack_debuff, ability)
		else
			stack_count = 0
		end
		if stack_count < stack_cap then
			AddStacks(ability, caster, target, stack_debuff, 1, true)
		else
			AddStacks(ability, caster, target, stack_debuff, 0, true)
		end
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
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)
	local aura_damage = ability:GetLevelSpecialValueFor("aura_damage", ability_level)
	local stack_power = ability:GetLevelSpecialValueFor("stack_power", ability_level)

	-- Adds a stack of the debuff
	local debuff_stacks = target:GetModifierStackCount(stack_modifier, ability)
	if debuff_stacks < max_stacks then
		AddStacks(ability, caster, target, stack_modifier, 1, true)
	end

	-- Calculates damage
	local damage = target:GetMaxHealth() * (1 + debuff_stacks * stack_power / 100) * aura_damage / 100
	
	-- If the target is at low enough HP, kill it
	if target:GetHealth() <= (damage + 5) then
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage + 10, damage_type = DAMAGE_TYPE_PURE})

	-- Else, remove some HP from it
	else
		target:SetHealth(target:GetHealth() - damage)
	end

	-- Modifier is only visible if the enemy team has vision of Necrophos
	if target:CanEntityBeSeenByMyTeam(caster) then
		if not target:HasModifier(visibility_modifier) then
			ability:ApplyDataDrivenModifier(caster, target, visibility_modifier, {})
		end
	else
		target:RemoveModifierByName(visibility_modifier)
	end
end

function HeartstopperUpdate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_aura = keys.modifier_aura

	-- Remove the old modifier
	caster:RemoveModifierByName(modifier_aura)

	-- Re-apply an updated version of it
	ability:ApplyDataDrivenModifier(caster, caster, modifier_aura, {})
end

function HeartstopperEnd( keys )
	local target = keys.target
	local stack_modifier = keys.stack_modifier
	local visible_modifier = keys.visible_modifier

	target:RemoveModifierByName(stack_modifier)
	target:RemoveModifierByName(visible_modifier)
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
	local damage_delay = ability:GetLevelSpecialValueFor("stun_duration", ability_level) - 0.05
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

	-- Checks if the target is not wraith king, and does not have aegis
	local should_increase_respawn_time = true
	if target:GetUnitName() == "npc_dota_hero_skeleton_king" or HasAegis(target) then
		should_increase_respawn_time = false
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

		-- Removes relevant debuffs and deals damage
		if target:HasModifier("modifier_aphotic_shield") then
			target:RemoveModifierByName("modifier_aphotic_shield")
		end
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, damage, nil)

		-- If the target is at 1 HP (i.e. only alive due to the Reaper's Scythe debuff), kill it
		if target:GetHealth() <= 3 then

			-- Initialize or increase scythe respawn timer stacking penalty
			if target.scythe_stacking_respawn_timer then
				target.scythe_stacking_respawn_timer = target.scythe_stacking_respawn_timer + respawn_stack
			else
				target.scythe_stacking_respawn_timer = respawn_stack
			end

			-- Flag this as a scythe death, increasing respawn timer by respawn_base
			target.scythe_added_respawn = respawn_base
			target:RemoveModifierByName("modifier_imba_reapers_scythe")
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = 30, damage_type = DAMAGE_TYPE_PURE})

			-- Prevent buyback if caster has scepter
			if scepter then
				target:SetBuyBackDisabledByReapersScythe(true)
			end
		end
	end)
end