--[[	Author: Firetoad
		Date: 26.10.2015	]]

function HellfireBlast( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_projectile = keys.particle_projectile
	local particle_warmup = keys.particle_warmup
	
	-- Parameters
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)

	-- Initialize the targets hit table
	caster.hellfire_blast_targets = nil
	caster.hellfire_blast_targets = {}
	caster.hellfire_blast_targets[1] = target

	-- Play the cast sound
	caster:EmitSound(sound_cast)

	-- Play warmup particle
	local warmup_pfx = ParticleManager:CreateParticle(particle_warmup, PATTACH_ABSORIGIN, caster)
	if caster.is_skeleton_king then
		ParticleManager:SetParticleControlEnt(warmup_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
	else
		ParticleManager:SetParticleControlEnt(warmup_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	end

	-- Tag the target as the spell's main target
	caster.wraithfire_blast_main_target = target

	-- Launch the first projectile
	local hellfire_blast_projectile
	hellfire_blast_projectile = {
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = particle_projectile,
		bDodgeable = true,
		bProvidesVision = false,
		iMoveSpeed = speed,
	--	iVisionRadius = 300,
	--	iVisionTeamNumber = caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
	}
	ProjectileManager:CreateTrackingProjectile(hellfire_blast_projectile)
end

function HellfireBlastHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit
	local particle_projectile = keys.particle_projectile
	local modifier_slow = keys.modifier_slow
	
	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local bounce_range = ability:GetLevelSpecialValueFor("bounce_range", ability_level)

	-- Play the impact sound
	caster:EmitSound(sound_hit)

	-- Debuff the target if it is not magic immune
	if not target:IsMagicImmune() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_slow, {})
	end

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Only bounce and spawn a summon if this is the main target
	if caster.wraithfire_blast_main_target and caster.wraithfire_blast_main_target == target then

		-- Stun the main target
		if not target:IsMagicImmune() then
			target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		end

		-- Find nearby enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		for _,enemy in pairs(enemies) do
			
			-- Launch extra projectiles to anyone BUT the initial target
			if caster.wraithfire_blast_main_target ~= enemy then
				local hellfire_blast_projectile = {
					Target = enemy,
					Source = target,
					Ability = ability,
					EffectName = particle_projectile,
					bDodgeable = true,
					bProvidesVision = false,
					iMoveSpeed = speed,
				--	iVisionRadius = 300,
				--	iVisionTeamNumber = caster:GetTeamNumber(),
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
				}
				ProjectileManager:CreateTrackingProjectile(hellfire_blast_projectile)
			end
		end
	end
end

function HellfireBlastLifesteal( keys )
	local caster = keys.caster
	local ability = keys.ability
	local attacker = keys.attacker
	local target = keys.unit
	local damage = keys.damage
	local particle_lifesteal = keys.particle_lifesteal

	-- If the ability was unlearned, or if this is an illusion, or attacker and target are in the same team, do nothing
	if not ability or target:IsIllusion() or target:GetTeam() == attacker:GetTeam() then
		return nil
	end

	-- Parameters
	local ability_level = ability:GetLevel() - 1
	local bonus_lifesteal = ability:GetLevelSpecialValueFor("bonus_lifesteal", ability_level)

	-- If the attacker is a hero (illusion or not), draw the particle
	if attacker:IsHero() then
		local lifesteal_pfx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, attacker)
		ParticleManager:SetParticleControl(lifesteal_pfx, 0, attacker:GetAbsOrigin())
		ParticleManager:SetParticleControl(lifesteal_pfx, 1, attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
	end

	-- If the attacker is a real hero, lifesteal
	if attacker:IsRealHero() then

		-- Delay the lifesteal for one game tick to prevent blademail interaction
		Timers:CreateTimer(0.01, function()
			attacker:Heal(damage * bonus_lifesteal * 0.01, caster)
		end)
	end	
end

function VampiricAuraOn( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_aura = keys.modifier_aura

	ability:ApplyDataDrivenModifier(caster, caster, modifier_aura, {})
end

function VampiricAuraOff( keys )
	local caster = keys.caster
	local modifier_aura = keys.modifier_aura

	caster:RemoveModifierByName(modifier_aura)
end

function VampiricAuraHit( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local target = keys.unit
	local ability = keys.ability
	local damage = keys.damage
	local particle_heal = keys.particle_heal

	-- If the ability was unlearned, or disabled by break, do nothing
	if not ability or caster.break_duration_left then
		return nil
	end

	-- If there's no valid target, do nothing
	if target:IsBuilding() or target:IsIllusion() or target:GetTeam() == attacker:GetTeam() then
		return nil
	end

	-- Parameters
	local ability_level = ability:GetLevel() - 1
	local lifesteal_pct = ability:GetLevelSpecialValueFor("lifesteal_ally", ability_level)

	-- If this is the caster, increase lifesteal amount
	if caster == attacker then
		lifesteal_pct = ability:GetLevelSpecialValueFor("lifesteal_self", ability_level)
	end

	-- Draw the particle
	local lifesteal_pfx = ParticleManager:CreateParticle(particle_heal, PATTACH_ABSORIGIN_FOLLOW, attacker)
	ParticleManager:SetParticleControl(lifesteal_pfx, 0, attacker:GetAbsOrigin())
	ParticleManager:SetParticleControl(lifesteal_pfx, 1, attacker:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(lifesteal_pfx)

	-- If the attacker is a real hero, lifesteal
	if attacker:IsRealHero() then

		-- Delay the lifesteal for one game tick to prevent blademail interaction
		Timers:CreateTimer(0.01, function()
			attacker:Heal(damage * lifesteal_pct * 0.01, caster)
		end)
	end	
end

function VampiricAuraCreepHit( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local target = keys.target
	local ability = keys.ability
	local damage = keys.damage
	local particle_heal = keys.particle_heal

	-- If the ability was unlearned, or disabled by break, do nothing
	if not ability or caster.break_duration_left then
		return nil
	end

	-- If there's no valid target, do nothing
	if target:IsBuilding() or target:IsIllusion() or target:GetTeam() == attacker:GetTeam() then
		return nil
	end

	-- Parameters
	local ability_level = ability:GetLevel() - 1
	local lifesteal_pct = ability:GetLevelSpecialValueFor("lifesteal_ally", ability_level)

	-- Draw the particle
	local lifesteal_pfx = ParticleManager:CreateParticle(particle_heal, PATTACH_ABSORIGIN_FOLLOW, attacker)
	ParticleManager:SetParticleControl(lifesteal_pfx, 0, attacker:GetAbsOrigin())
	ParticleManager:SetParticleControl(lifesteal_pfx, 1, attacker:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(lifesteal_pfx)

	-- Delay the lifesteal for one game tick to prevent blademail interaction
	Timers:CreateTimer(0.01, function()
		attacker:Heal(damage * lifesteal_pct * 0.01, caster)
	end)
end

function MortalStrikeCrit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_crit = keys.modifier_crit

	-- Remove preexisting crit modifier
	caster:RemoveModifierByName(modifier_crit)

	-- If the ability was unlearned, or disabled by break, do nothing
	if not ability or caster.break_duration_left then
		return nil
	end

	-- Roll for a crit if the target is appropriate
	local ability_level = ability:GetLevel() - 1
	local crit_chance = ability:GetLevelSpecialValueFor("crit_chance", ability_level)
	if not target:IsBuilding() and RandomInt(1, 100) <= crit_chance then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_crit, {})
	end
end

function MortalStrikeCritHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = keys.damage
	local modifier_drain = keys.modifier_drain
	local modifier_dummy = keys.modifier_dummy

	-- If the target is a building, do nothing
	if target:IsBuilding() then
		return nil
	end

	-- Parameters
	local str_drain_pct = ability:GetLevelSpecialValueFor("str_drain_pct", ability_level) * 0.01

	-- If the target is not an illusion, add strength to the caster
	if not target:IsIllusion() then

		-- Calculate total strength to be gained
		local str_gained = math.floor(damage * str_drain_pct)

		-- Grant it
		for i = 1,str_gained do
			ability:ApplyDataDrivenModifier(caster, caster, modifier_drain, {})
		end
	end

	-- If the target is a creep or an illusion, deal damage equal to its maximum health
	if not target:IsRealHero() and not target:IsAncient() then
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = target:GetMaxHealth(), damage_type = DAMAGE_TYPE_PHYSICAL})
	end
end

function MortalStrikeStackUp( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_dummy = keys.modifier_dummy

	-- Add a stack of the dummy modifier
	AddStacks(ability, caster, caster, modifier_dummy, 1, true)
end

function MortalStrikeStackDown( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_drain = keys.modifier_drain
	local modifier_dummy = keys.modifier_dummy

	-- If this was the last stack, remove the dummy modifier
	if not caster:HasModifier(modifier_drain) then
		caster:RemoveModifierByName(modifier_dummy)

	-- Else, reduce the amount of stacks
	else
		AddStacks(ability, caster, caster, modifier_dummy, -1, false)
	end
end

function ReincarnationScepterAura( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_scepter = keys.modifier_scepter
	local modifier_wraith = keys.modifier_wraith
	local scepter = HasScepter(caster)

	-- If the ability was unlearned, or the caster has no scepter, do nothing
	if not ability or not scepter then
		return nil
	end

	-- Parameters
	local ability_level = ability:GetLevel() - 1
	local aura_radius_scepter = ability:GetLevelSpecialValueFor("aura_radius_scepter", ability_level)

	-- Apply the scepter modifier to all nearby teammates
	if scepter then
		local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, aura_radius_scepter, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		for _,ally in pairs(allies) do
			if ally:IsRealHero() and not ally:HasModifier(modifier_wraith) then
				ability:ApplyDataDrivenModifier(caster, ally, modifier_scepter, {})
			end
		end
	end
end

function ReincarnationWraithEnd( keys )
	local target = keys.target
	local ability = keys.ability

	-- If this is an unit with Reincarnation off-cooldown, do nothing
	local ability_reincarnation = target:FindAbilityByName("imba_wraith_king_reincarnation")
	if ability_reincarnation and ability_reincarnation:IsCooldownReady() then
		TriggerWraithKingReincarnation(target, ability_reincarnation)
		target.reincarnation_scepter_killer_id = nil
		return nil
	end
	
	-- Kill the target, granting credit to the original killer
	target:SetHealth(5)
	if target.reincarnation_scepter_killer then
		TrueKill(target.reincarnation_scepter_killer, target, ability)
	else
		TrueKill(target, target, ability)
	end

	-- Clear the killer variable
	target.reincarnation_scepter_killer_id = nil
end