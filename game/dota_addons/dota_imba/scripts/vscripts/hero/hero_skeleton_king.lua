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
	local secondary_stun = ability:GetLevelSpecialValueFor("secondary_stun", ability_level)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local bounce_range = ability:GetLevelSpecialValueFor("bounce_range", ability_level)

	-- Play the impact sound
	caster:EmitSound(sound_hit)

	-- Stun and debuff the target if it is not magic immune
	if not target:IsMagicImmune() then
		target:AddNewModifier(caster, ability, "modifier_stunned", {duration = secondary_stun})
		ability:ApplyDataDrivenModifier(caster, target, modifier_slow, {})
	end

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Only bounce and spawn a summon if this is the main target
	if caster.wraithfire_blast_main_target and caster.wraithfire_blast_main_target == target then

		-- Stun the main target for longer
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

function ReincarnationUpdate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_reincarnation = keys.modifier_reincarnation
	local modifier_scepter = keys.modifier_scepter
	local modifier_wraith = keys.modifier_wraith
	local scepter = HasScepter(caster)

	-- If the ability was unlearned, do nothing
	if not ability then
		return nil
	end

	-- Parameters
	local ability_level = ability:GetLevel() - 1
	local aura_radius_scepter = ability:GetLevelSpecialValueFor("aura_radius_scepter", ability_level)

	-- Add reincarnation modifier if it's missing
	if ability:IsCooldownReady() and not caster:HasModifier(modifier_reincarnation) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_reincarnation, {})
	end

	-- Remove reincarnation modifier if it shouldn't be there
	if not ability:IsCooldownReady() and caster:HasModifier(modifier_reincarnation) then
		caster:RemoveModifierByName(modifier_reincarnation)
	end

	-- If the caster has a scepter, apply its aura to all nearby teammates
	if scepter then
		local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, aura_radius_scepter, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		for _,ally in pairs(allies) do
			if not ally:HasModifier(modifier_wraith) then
				ability:ApplyDataDrivenModifier(caster, ally, modifier_scepter, {})
			end
		end
	end
end

function ReincarnationWraithDamage( keys )
	local target = keys.unit

	-- If health is not 2, do nothing
	if target:GetHealth() > 2 or target:HasModifier("modifier_imba_reincarnation") or target:HasModifier("modifier_imba_shallow_grave") or target:HasModifier("modifier_imba_shallow_grave_passive") then
		return nil
	end

	-- Keyvalues
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local modifier_scepter = keys.modifier_scepter
	local modifier_wraith = keys.modifier_wraith
	local sound_wraith = keys.sound_wraith

	-- Store the attacker which killed this unit's ID
	local killer_id
	local killer_type = "hero"
	if attacker:GetOwnerEntity() then
		killer_id = attacker:GetOwnerEntity():GetPlayerID()
	elseif attacker:IsHero() then
		killer_id = attacker:GetPlayerID()
	else
		killer_id = attacker
		killer_type = "creature"
	end

	-- If there is a player-owned killer, store it
	if killer_type == "hero" then
		target.reincarnation_scepter_killer = PlayerResource:GetPlayer(killer_id):GetAssignedHero()

	-- Else, assign the kill to the unit which dealt the finishing blow
	else
		target.reincarnation_scepter_killer = attacker
	end

	-- Play transformation sound
	target:EmitSound(sound_wraith)

	-- Apply wraith form modifier
	ability:ApplyDataDrivenModifier(caster, target, modifier_wraith, {})

	-- Remove the scepter aura modifier
	target:RemoveModifierByName(modifier_scepter)

	-- Purge all debuffs
	target:Purge(false, true, false, true, false)
end

function ReincarnationWraithEnd( keys )
	local target = keys.target
	local ability = keys.ability
	
	-- Kill the target, granting credit to the original killer
	if target.reincarnation_scepter_killer then
		TrueKill(target.reincarnation_scepter_killer, target, ability)
	else
		TrueKill(target, target, ability)
	end

	-- Clear the killer variable
	target.reincarnation_scepter_killer_id = nil
end

function ReincarnationDamage( keys )
	local caster = keys.caster

	-- If health is not 1, do nothing
	if caster:GetHealth() > 1 or caster:HasModifier("modifier_imba_shallow_grave") or caster:HasModifier("modifier_imba_shallow_grave_passive") then
		return nil
	end

	-- Keyvalues
	local attacker = keys.attacker
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_reincarnation = keys.modifier_reincarnation
	local modifier_death = keys.modifier_death
	local modifier_slow = keys.modifier_slow
	local particle_wait = keys.particle_wait
	local sound_death = keys.sound_death
	local sound_reincarnation = keys.sound_reincarnation

	-- Parameters
	local slow_radius = ability:GetLevelSpecialValueFor("slow_radius", ability_level)
	local reincarnate_delay = ability:GetLevelSpecialValueFor("reincarnate_delay", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
	local caster_loc = caster:GetAbsOrigin()

	-- If health is minimal, but the ability is on cooldown, die to the original attacker
	if not ability:IsCooldownReady() then
		caster:RemoveModifierByName(modifier_reincarnation)
		ApplyDamage({attacker = attacker, victim = caster, ability = ability, damage = 3, damage_type = DAMAGE_TYPE_PURE})
		return nil
	end

	-- Else, put the ability on cooldown and play out the reincarnation
	local cooldown_reduction = GetCooldownReduction(caster)
	ability:StartCooldown(ability:GetCooldown(ability_level) * cooldown_reduction)

	-- Play initial sound
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, slow_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
	if USE_MEME_SOUNDS and #heroes >= IMBA_PLAYERS_ON_GAME * 0.35 then
		caster:EmitSound("Hero_WraithKing.IllBeBack")
	else
		caster:EmitSound(sound_death)
	end

	-- Create visibility node
	ability:CreateVisibilityNode(caster_loc, vision_radius, reincarnate_delay)

	-- Apply simulated death modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_death, {})

	-- Remove caster's model from the game
	caster:AddNoDraw()

	-- Play initial particle
	local wait_pfx = ParticleManager:CreateParticle(particle_wait, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleAlwaysSimulate(wait_pfx)
	ParticleManager:SetParticleControl(wait_pfx, 0, caster_loc)
	ParticleManager:SetParticleControl(wait_pfx, 1, Vector(reincarnate_delay, 0, 0))
	ParticleManager:SetParticleControl(wait_pfx, 11, Vector(200, 0, 0))

	-- Slow all enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, slow_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
	end

	-- Heal, even through healing prevention debuffs
	caster:SetHealth(caster:GetMaxHealth())
	caster:SetMana(caster:GetMaxMana())

	-- After the respawn delay
	Timers:CreateTimer(reincarnate_delay, function()

		-- Purge most debuffs
		caster:Purge(false, true, false, true, false)

		-- Heal, even through healing prevention debuffs
		caster:SetHealth(caster:GetMaxHealth())
		caster:SetMana(caster:GetMaxMana())

		-- Remove reincarnation modifier
		caster:RemoveModifierByName(modifier_reincarnation)

		-- Redraw caster's model
		caster:RemoveNoDraw()

		-- Play reincarnation stinger
		caster:EmitSound(sound_reincarnation)
	end)
end