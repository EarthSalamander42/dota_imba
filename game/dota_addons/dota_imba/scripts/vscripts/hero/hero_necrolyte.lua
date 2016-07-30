--[[ 	Author: D2imba
		Date: 27.04.2015	]]

function DeathPulseStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_aux = caster:FindAbilityByName(keys.ability_aux)
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_ally = keys.particle_ally
	local particle_enemy = keys.particle_enemy
	local modifier_caster = keys.modifier_caster
	local modifier_heal_bonus = keys.modifier_heal_bonus

	-- Parameters
	local area_of_effect = ability:GetLevelSpecialValueFor("area_of_effect", ability_level)
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local base_damage_pct = ability:GetLevelSpecialValueFor("base_damage_pct", ability_level) * 0.01
	local base_heal = ability:GetLevelSpecialValueFor("base_heal", ability_level)
	local base_heal_pct = ability:GetLevelSpecialValueFor("base_heal_pct", ability_level) * 0.01
	local stack_power = ability:GetLevelSpecialValueFor("stack_power", ability_level) * 0.01

	-- Initialize projectile parameters
	local projectile = {
		Target = caster,
		Source = target,
		Ability = ability,
		EffectName = "",
		bDodgeable = false,
		bProvidesVision = false,
		iMoveSpeed = projectile_speed,
	--	iVisionRadius = vision_radius,
	--	iVisionTeamNumber = caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	}

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Apply caster modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})

	-- Create projectile for nearby units
	local nearby_units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, area_of_effect, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,target in pairs(nearby_units) do
		if target:GetTeam() == caster:GetTeam() then

			-- Allied projectile
			projectile.EffectName = particle_ally

			-- Calculate and perform healing
			local heal_bonus_stacks = target:GetModifierStackCount(modifier_heal_bonus, caster)
			local total_healing = (base_heal + target:GetMaxHealth() * base_heal_pct) * (1 + stack_power * heal_bonus_stacks)
			target:Heal(total_healing, caster)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, total_healing, nil)
		else

			-- Enemy projectile
			projectile.EffectName = particle_enemy
			
			-- Calculate and apply damage
			local total_damage = base_damage + target:GetMaxHealth() * base_damage_pct
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = total_damage, damage_type = DAMAGE_TYPE_MAGICAL})
		end

		-- Hero and creep projectiles are different
		if target:IsRealHero() then
			projectile.Ability = ability
		elseif ability_aux then
			projectile.Ability = ability_aux
		end

		-- Create the projectile
		projectile.Source = target
		ProjectileManager:CreateTrackingProjectile(projectile)
	end
end

function DeathPulseThink( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_aux = caster:FindAbilityByName(keys.ability_aux)
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_ally = keys.particle_ally
	local particle_enemy = keys.particle_enemy
	local modifier_caster = keys.modifier_caster
	local modifier_heal_bonus = keys.modifier_heal_bonus

	-- Parameters
	local area_of_effect = ability:GetLevelSpecialValueFor("area_of_effect", ability_level)
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local base_damage = ability:GetLevelSpecialValueFor("toggle_damage", ability_level)
	local base_damage_pct = ability:GetLevelSpecialValueFor("toggle_damage_pct", ability_level) * 0.01
	local base_heal = ability:GetLevelSpecialValueFor("toggle_heal", ability_level)
	local base_heal_pct = ability:GetLevelSpecialValueFor("toggle_heal_pct", ability_level) * 0.01
	local stack_power = ability:GetLevelSpecialValueFor("stack_power", ability_level) * 0.01
	local toggle_mana_cost = ability:GetLevelSpecialValueFor("toggle_mana_cost", ability_level)
	local cooldown = ability:GetLevelSpecialValueFor("cooldown", ability_level) / FRANTIC_MULTIPLIER

	-- If the caster is out of mana, toggle the ability off
	if caster:GetMana() < toggle_mana_cost then
		ability:ToggleAbility()
		ability:StartCooldown(cooldown * GetCooldownReduction(caster))
		return nil

	-- Else, spend mana and move on
	else
		caster:SpendMana(toggle_mana_cost, ability)
	end

	-- Initialize projectile parameters
	local projectile = {
		Target = caster,
		Source = "",
		Ability = ability,
		EffectName = "",
		bDodgeable = false,
		bProvidesVision = false,
		iMoveSpeed = projectile_speed,
	--	iVisionRadius = vision_radius,
	--	iVisionTeamNumber = caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	}

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Create projectile for nearby units
	local nearby_units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, area_of_effect, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,target in pairs(nearby_units) do
		if target:GetTeam() == caster:GetTeam() then

			-- Allied projectile
			projectile.EffectName = particle_ally

			-- Calculate and perform healing
			local heal_bonus_stacks = target:GetModifierStackCount(modifier_heal_bonus, caster)
			local total_healing = (base_heal + target:GetMaxHealth() * base_heal_pct) * (1 + stack_power * heal_bonus_stacks)
			target:Heal(total_healing, caster)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, total_healing, nil)
		else

			-- Enemy projectile
			projectile.EffectName = particle_enemy
			
			-- Calculate and apply damage
			local total_damage = base_damage + target:GetMaxHealth() * base_damage_pct
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = total_damage, damage_type = DAMAGE_TYPE_MAGICAL})
		end

		-- Hero and creep projectiles are different
		if target:IsRealHero() then
			projectile.Ability = ability
		elseif ability_aux then
			projectile.Ability = ability_aux
		end

		-- Create the projectile
		projectile.Source = target
		ProjectileManager:CreateTrackingProjectile(projectile)
	end
end

function DeathPulseEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_caster = keys.modifier_caster

	-- Parameters
	local cooldown = ability:GetLevelSpecialValueFor("cooldown", ability_level) / FRANTIC_MULTIPLIER

	-- Remove caster modifier
	caster:RemoveModifierByName(modifier_caster)

	-- Put the skill on cooldown
	ability:StartCooldown(cooldown * GetCooldownReduction(caster))
end
	
function DeathPulseHeroHit( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_heal_bonus = keys.modifier_heal_bonus

	-- If the ability is gone (Random OMG), do nothing
	if not ability then
		return nil
	end

	-- Ability parameters
	local ability_level = ability:GetLevel() - 1
	local self_heal_hero_pct = ability:GetLevelSpecialValueFor("self_heal_hero_pct", ability_level) * 0.01
	local stack_power = ability:GetLevelSpecialValueFor("stack_power", ability_level) * 0.01

	-- Calculate and perform healing
	local heal_bonus_stacks = caster:GetModifierStackCount(modifier_heal_bonus, caster)
	local total_healing = (self_heal_hero_pct * caster:GetMaxHealth()) * (1 + stack_power * heal_bonus_stacks)
	caster:Heal(total_healing, caster)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, total_healing, nil)
end

function DeathPulseCreepHit( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_heal_bonus = keys.modifier_heal_bonus

	-- If the ability is gone (Random OMG), do nothing
	if not ability then
		return nil
	end

	-- Ability parameters
	local ability_level = ability:GetLevel() - 1
	local self_heal_creep_pct = ability:GetLevelSpecialValueFor("self_heal_creep_pct", ability_level) * 0.01
	local stack_power = ability:GetLevelSpecialValueFor("stack_power", ability_level) * 0.01

	-- Calculate and perform healing
	local heal_bonus_stacks = caster:GetModifierStackCount(modifier_heal_bonus, caster)
	local total_healing = (self_heal_creep_pct * caster:GetMaxHealth()) * (1 + stack_power * heal_bonus_stacks)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, total_healing, nil)
end

function HeartstopperEnemy( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_debuff = keys.modifier_debuff

	-- Ability parameters
	local aura_damage = ability:GetLevelSpecialValueFor("aura_damage", ability_level) * 0.01
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	-- Adds a stack of the debuff
	local debuff_stacks = target:GetModifierStackCount(modifier_debuff, nil)
	if debuff_stacks < max_stacks then
		AddStacks(ability, caster, target, modifier_debuff, 1, true)
	end

	-- Calculates damage
	local damage = target:GetMaxHealth() * aura_damage
	
	-- If the target is at low enough HP, kill it
	if target:GetHealth() <= (damage + 5) then
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage + 10, damage_type = DAMAGE_TYPE_PURE})

	-- Else, remove some HP from it
	else
		target:SetHealth(target:GetHealth() - damage)
	end
end

function HeartstopperAlly( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_buff = keys.modifier_buff

	-- Ability parameters
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	-- Adds a stack of the buff
	local buff_stacks = target:GetModifierStackCount(modifier_buff, nil)
	if buff_stacks < max_stacks then
		AddStacks(ability, caster, target, modifier_buff, 1, true)
	end
end

function HeartstopperEnd( keys )
	local target = keys.target
	local modifier_stacks = keys.modifier_stacks

	target:RemoveModifierByName(modifier_stacks)
end

function SadistKill( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local regen_modifier = keys.regen_modifier

	-- Parameters
	local hero_multiplier = ability:GetLevelSpecialValueFor("hero_multiplier", ability_level)

	-- Apply stacks of the regen buff
	if target:IsRealHero() then
		for i = 1, hero_multiplier do
			ability:ApplyDataDrivenModifier(caster, caster, regen_modifier, {})
		end
	else
		ability:ApplyDataDrivenModifier(caster, caster, regen_modifier, {})
	end
end

function SadistHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local regen_modifier = keys.regen_modifier

	-- Apply a stack of the regen buff
	if target:IsHero() and caster:GetTeam() ~= target:GetTeam() then
		ability:ApplyDataDrivenModifier(caster, caster, regen_modifier, {})
	end
end

function ApplySadist( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stack_modifier = keys.stack_modifier

	AddStacks(ability, caster, target, stack_modifier, 1, true)
end

function RemoveSadist( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stack_modifier = keys.stack_modifier

	-- If this is the last stack, remove modifier
	local current_stacks = target:GetModifierStackCount(stack_modifier, nil)
	if current_stacks <= 1 then
		target:RemoveModifierByName(stack_modifier)

	-- Else, reduce stack count by 1
	else
		target:SetModifierStackCount(stack_modifier, nil, current_stacks - 1)
	end
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
	local ability_sadist = caster:FindAbilityByName(keys.ability_sadist)
	local reap_particle = keys.reap_particle
	local scythe_particle = keys.scythe_particle
	local modifier_regen = keys.modifier_regen
	local scepter = HasScepter(caster)

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
	local caster_loc = caster:GetAbsOrigin()
	local target_loc = target:GetAbsOrigin()
	Timers:CreateTimer(particle_delay, function()
		local scythe_fx = ParticleManager:CreateParticle(scythe_particle, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(scythe_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster_loc, true)
		ParticleManager:SetParticleControlEnt(scythe_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target_loc, true)
		ParticleManager:ReleaseParticleIndex(scythe_fx)
	end)

	-- Waits for damage_delay to apply damage
	Timers:CreateTimer(damage_delay, function()

		-- Reaping particle
		local reap_fx = ParticleManager:CreateParticle(reap_particle, PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(reap_fx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target_loc, true)
		ParticleManager:SetParticleControlEnt(reap_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target_loc, true)
		ParticleManager:ReleaseParticleIndex(reap_fx)

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

			-- Scepter on-kill effects
			if scepter then

				-- Prevent buyback
				target:SetBuyBackDisabledByReapersScythe(true)

				-- Apply sadist stacks to nearby allies
				if ability_sadist and ability_sadist:GetLevel() > 0 then
					local stacks_scepter = ability:GetLevelSpecialValueFor("stacks_scepter", ability_level)
					local sadist_aoe_scepter = ability:GetLevelSpecialValueFor("sadist_aoe_scepter", ability_level)
					local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, sadist_aoe_scepter, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					for _,ally in pairs(nearby_allies) do
						for i = 1, stacks_scepter do
							ability_sadist:ApplyDataDrivenModifier(caster, ally, modifier_regen, {})
						end
					end
				end
			end
		end
	end)
end