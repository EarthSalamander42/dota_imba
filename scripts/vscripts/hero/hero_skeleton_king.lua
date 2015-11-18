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
	local summon_name = keys.summon_name
	
	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local secondary_stun = ability:GetLevelSpecialValueFor("secondary_stun", ability_level)
	local summon_duration = ability:GetLevelSpecialValueFor("summon_duration", ability_level)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local bounce_range = ability:GetLevelSpecialValueFor("bounce_range", ability_level)

	-- Play the impact sound
	caster:EmitSound(sound_hit)

	-- Stun the target
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = secondary_stun})

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Only bounce and spawn a summon if this is the main target
	if caster.wraithfire_blast_main_target and caster.wraithfire_blast_main_target == target then

		-- Stun the main target for longer
		target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})

		-- Spawn the summon
		local skeleton_loc = target:GetAbsOrigin() + RandomVector(100)
		local hellfire_skeleton = CreateUnitByName(summon_name, skeleton_loc, false, caster, caster, caster:GetTeam())
		FindClearSpaceForUnit(hellfire_skeleton, skeleton_loc, true)

		-- Make the summon limited duration and uncontrollable
		hellfire_skeleton:SetControllableByPlayer(caster:GetPlayerID(), true)
		hellfire_skeleton:SetForceAttackTarget(target)
		hellfire_skeleton:AddNewModifier(caster, ability, "modifier_kill", {duration = summon_duration})

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

function VampiricAura( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local target = keys.unit
	local ability = keys.ability
	local damage = keys.damage
	local particle_heal = keys.particle_heal

	-- If the ability was unlearned, do nothing
	if not ability then
		return nil
	end

	-- Parameters
	local ability_level = ability:GetLevel() - 1
	local lifesteal_hero = ability:GetLevelSpecialValueFor("lifesteal_hero", ability_level)
	local lifesteal_creep = ability:GetLevelSpecialValueFor("lifesteal_creep", ability_level)

	-- If there's no valid target, do nothing
	if target:IsBuilding() or target:IsTower() or target == attacker then
		return nil
	end

	-- If the attacker is a real hero, heal and draw the particle
	if attacker:IsRealHero() then

		if target:IsRealHero() then
			attacker:Heal(damage * lifesteal_hero / 100, caster)
		else
			attacker:Heal(damage * lifesteal_creep / 100, caster)
		end

		local lifesteal_pfx = ParticleManager:CreateParticle(particle_heal, PATTACH_ABSORIGIN_FOLLOW, attacker)
		ParticleManager:SetParticleControl(lifesteal_pfx, 0, attacker:GetAbsOrigin())
		ParticleManager:SetParticleControl(lifesteal_pfx, 1, attacker:GetAbsOrigin())

	-- If the attacker is an illusion, only draw the particle
	elseif attacker:IsHero() then
		local lifesteal_pfx = ParticleManager:CreateParticle(particle_heal, PATTACH_ABSORIGIN_FOLLOW, attacker)
		ParticleManager:SetParticleControl(lifesteal_pfx, 0, attacker:GetAbsOrigin())
		ParticleManager:SetParticleControl(lifesteal_pfx, 1, attacker:GetAbsOrigin())
	end
end

function VampiricAuraCrit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_crit = keys.modifier_crit

	-- If the target is not a building, grant the crit modifier to the caster
	if caster:IsRealHero() and not target:IsBuilding() then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_crit, {})
	end
end

function VampiricAuraCritHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_buff = keys.modifier_buff
	local modifier_debuff = keys.modifier_debuff

	-- If the target is a hero, steal strength from it
	if caster:IsRealHero() and target:IsHero() then

		-- Add a stack of the buff to the caster
		AddStacks(ability, caster, caster, modifier_buff, 1, true)

		-- Add a stack of the debuff to the target
		AddStacks(ability, caster, target, modifier_debuff, 1, true)

		-- Force update the caster and target's attributes
		caster:CalculateStatBonus()
		target:CalculateStatBonus()
	end
end

function KingdomCome( keys )
	local caster = keys.caster
	local sound_cast = keys.sound_cast
	local particle_cast = keys.particle_cast

	-- Start cast sound
	caster:EmitSound(sound_cast)

	-- Play particle
	caster.kingdom_come_tell_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleAlwaysSimulate(caster.kingdom_come_tell_pfx)
	ParticleManager:SetParticleControl(caster.kingdom_come_tell_pfx, 0, caster:GetAbsOrigin())
end

function KingdomComeStopChannel( keys )
	local caster = keys.caster
	local sound_cast = keys.sound_cast

	-- Stop cast cound
	caster:StopSound(sound_cast)

	-- Destroy particle
	ParticleManager:DestroyParticle(caster.kingdom_come_tell_pfx, true)
	caster.kingdom_come_tell_pfx = nil
end

function KingdomComeEndChannel( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local summon_name = keys.summon_name
	local modifier_debuff = keys.modifier_debuff
	local modifier_summon = keys.modifier_summon

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local summon_health = ability:GetLevelSpecialValueFor("summon_health", ability_level)

	-- Destroy tell particle
	ParticleManager:DestroyParticle(caster.kingdom_come_tell_pfx, false)
	caster.kingdom_come_tell_pfx = nil

	-- Find enemies inside the area of effect and iterate through them
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,target in pairs(enemies) do
		
		-- Apply the debuff modifier to this enemy
		ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})

		-- Summon a wraith for this enemy
		local wraith_loc = target:GetAbsOrigin() - target:GetForwardVector() * 120
		local kingdom_wraith = CreateUnitByName(summon_name, wraith_loc, false, caster, caster, caster:GetTeam())
		FindClearSpaceForUnit(kingdom_wraith, wraith_loc, true)

		-- Make the summon limited duration and uncontrollable
		kingdom_wraith:SetControllableByPlayer(caster:GetPlayerID(), true)
		kingdom_wraith:SetForceAttackTarget(target)
		kingdom_wraith:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})

		-- Adjust the summon's stats if this unit is an enemy hero
		if target:IsHero() then
			local target_level = target:GetLevel()
			AddStacks(ability, caster, kingdom_wraith, modifier_summon, target_level, true)
			SetCreatureHealth(kingdom_wraith, kingdom_wraith:GetMaxHealth() + (target_level - 1) * summon_health, true)
			kingdom_wraith:SetModelScale(kingdom_wraith:GetModelScale() + math.min(0.025 * target_level, 0.6))
		else
			ability:ApplyDataDrivenModifier(caster, kingdom_wraith, modifier_summon, {})
		end

		-- Set this unit as the summon's target
		kingdom_wraith.kingdom_come_target = target
	end
end

function KingdomComeAddStack( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_dmg = keys.modifier_dmg
	local modifier_ms = keys.modifier_ms

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("creep_damage", ability_level)
	local move_speed = ability:GetLevelSpecialValueFor("creep_ms", ability_level)

	-- If this unit is a hero, increase parameters
	if target:IsHero() then
		damage = ability:GetLevelSpecialValueFor("hero_damage", ability_level)
		move_speed = ability:GetLevelSpecialValueFor("hero_ms", ability_level)
	end

	-- Add the appropriate number of stacks to the caster
	AddStacks(ability, caster, caster, modifier_dmg, damage, true)
	AddStacks(ability, caster, caster, modifier_ms, move_speed, true)
end

function KingdomComeRemoveStack( keys )
	local caster = keys.caster
	local summon = keys.target
	local target = summon.kingdom_come_target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_dmg = keys.modifier_dmg
	local modifier_ms = keys.modifier_ms
	local modifier_debuff = keys.modifier_debuff

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("creep_damage", ability_level)
	local move_speed = ability:GetLevelSpecialValueFor("creep_ms", ability_level)

	-- If this summon's associated unit is a hero, increase parameters
	if target:IsHero() then
		damage = ability:GetLevelSpecialValueFor("hero_damage", ability_level)
		move_speed = ability:GetLevelSpecialValueFor("hero_ms", ability_level)
	end

	-- Remove the debuff from the associated unit
	target:RemoveModifierByName(modifier_debuff)

	-- Remove stacks from the caster accordingly
	local damage_stacks = caster:GetModifierStackCount(modifier_dmg, caster)
	local speed_stacks = caster:GetModifierStackCount(modifier_ms, caster)

	-- If there are few enough stacks of damage remaining, remove them all
	if damage_stacks <= damage then
		caster:RemoveModifierByName(modifier_dmg)
	else
		caster:SetModifierStackCount(modifier_dmg, caster, damage_stacks - damage)
	end

	-- If there are few enough stacks of speed, remove them all
	if speed_stacks <= move_speed then
		caster:RemoveModifierByName(modifier_ms)
	else
		caster:SetModifierStackCount(modifier_ms, caster, speed_stacks - move_speed)
	end
end

function ReincarnationUpdate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_reincarnation = keys.modifier_reincarnation

	-- If the ability was unlearned, do nothing
	if not ability then
		return nil
	end

	-- Add reincarnation modifier if it's missing
	if ability:IsCooldownReady() and not caster:HasModifier(modifier_reincarnation) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_reincarnation, {})
	end

	-- Remove reincarnation modifier if it shouldn't be there
	if not ability:IsCooldownReady() and caster:HasModifier(modifier_reincarnation) then
		caster:RemoveModifierByName(modifier_reincarnation)
	end
end

function ReincarnationDamage( keys )
	local caster = keys.caster

	-- If health is not 1, do nothing
	if caster:GetHealth() > 1 or caster.has_aegis or caster:HasModifier("modifier_imba_shallow_grave") then
		return nil
	end

	-- Keyvalues
	local attacker = keys.attacker
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_reincarnation = keys.modifier_reincarnation
	local modifier_death = keys.modifier_death
	local modifier_str = keys.modifier_str
	local modifier_slow = keys.modifier_slow
	local particle_wait = keys.particle_wait
	local sound_death = keys.sound_death
	local sound_reincarnation = keys.sound_reincarnation

	-- Parameters
	local slow_radius = ability:GetLevelSpecialValueFor("slow_radius", ability_level)
	local reincarnate_delay = ability:GetLevelSpecialValueFor("reincarnate_delay", ability_level)
	local str_bonus = ability:GetLevelSpecialValueFor("str_bonus", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
	local caster_loc = caster:GetAbsOrigin()

	-- If health is 1, but the ability is on cooldown, die to the original attacker
	if not ability:IsCooldownReady() then
		caster:RemoveModifierByName(modifier_reincarnation)
		ApplyDamage({attacker = attacker, victim = caster, ability = ability, damage = 3, damage_type = DAMAGE_TYPE_PURE})
		return nil
	end

	-- Else, put the ability on cooldown and play out the reincarnation
	local cooldown_reduction = GetCooldownReduction(caster)
	ability:StartCooldown( ability:GetCooldown(ability_level) * cooldown_reduction )

	-- Play initial sound
	EmitGlobalSound(sound_death)
	--caster:EmitSound(sound_death)

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

	-- Slow all enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, slow_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
	end

	-- After the respawn delay
	Timers:CreateTimer(reincarnate_delay, function()

		-- Play reincarnation stinger
		EmitGlobalSound(sound_reincarnation)
		--caster:EmitSound(sound_reincarnation)

		-- Grant temporary bonus strength
		local bonus_str = math.floor( caster:GetStrength() * str_bonus / 100 )
		AddStacks(ability, caster, caster, modifier_str, bonus_str, true)

		-- Heal, even through healing prevention debuffs
		caster:SetHealth(caster:GetMaxHealth())
		caster:SetMana(caster:GetMaxMana())

		-- Purge all debuffs
		caster:Purge( false, true, false, true, false)

		-- Remove reincarnation modifier
		caster:RemoveModifierByName(modifier_reincarnation)

		-- Redraw caster's model
		caster:RemoveNoDraw()
	end)
end