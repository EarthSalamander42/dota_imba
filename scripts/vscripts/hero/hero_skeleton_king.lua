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

	-- Launch the first projectile
	local hellfire_blast_projectile
	if caster.is_skeleton_king then
		hellfire_blast_projectile = {
			Target = target,
			Source = caster,
			Ability = ability,
			EffectName = particle_projectile,
			bDodgeable = false,
			bProvidesVision = false,
			iMoveSpeed = speed,
		--	iVisionRadius = 300,
		--	iVisionTeamNumber = caster:GetTeamNumber(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}
	else
		hellfire_blast_projectile = {
			Target = target,
			Source = caster,
			Ability = ability,
			EffectName = particle_projectile,
			bDodgeable = false,
			bProvidesVision = false,
			iMoveSpeed = speed,
		--	iVisionRadius = 300,
		--	iVisionTeamNumber = caster:GetTeamNumber(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
		}
	end
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
	local summon_duration = ability:GetLevelSpecialValueFor("summon_duration", ability_level)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local bounce_range = ability:GetLevelSpecialValueFor("bounce_range", ability_level)

	-- Play the impact sound
	caster:EmitSound(sound_hit)

	-- Stun the target
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Don't spawn summons if the caster is not a hero
	if caster:IsHero() then

		-- Spawn the skeleton
		local skeleton_loc = target:GetAbsOrigin() + RandomVector(100)
		local hellfire_skeleton = CreateUnitByName(summon_name..( ability_level + 1 ), skeleton_loc, false, caster, caster, caster:GetTeam())
		FindClearSpaceForUnit(hellfire_skeleton, skeleton_loc, true)

		-- Make the skeleton limited duration and uncontrollable
		hellfire_skeleton:SetControllableByPlayer(caster:GetPlayerID(), true)
		hellfire_skeleton:SetForceAttackTarget(target)
		hellfire_skeleton:AddNewModifier(caster, ability, "modifier_kill", {duration = summon_duration})

	end

	-- Limit bounces to 2 per target
	local current_bounces = 0

	-- Find nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
	for _,enemy in pairs(enemies) do

		-- Check if this enemy was already hit
		local already_hit = false
		for _,enemy_test in pairs(caster.hellfire_blast_targets) do
			if enemy_test == enemy then
				already_hit = true
			end
		end
		
		-- If the target wasn't hit, launch another projectile
		if not already_hit then
			local hellfire_blast_projectile = {
				Target = enemy,
				Source = target,
				Ability = ability,
				EffectName = particle_projectile,
				bDodgeable = false,
				bProvidesVision = false,
				iMoveSpeed = speed,
			--	iVisionRadius = 300,
			--	iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}

			ProjectileManager:CreateTrackingProjectile(hellfire_blast_projectile)

			-- Add this target to the targets already hit list
			caster.hellfire_blast_targets[#caster.hellfire_blast_targets + 1] = enemy

			-- Increase number of bounces
			current_bounces = current_bounces + 1
		end

		-- After reaching two bounces, stop
		if current_bounces >= 2 then
			return nil
		end
	end
end

function WraithfireEruptionCast( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_tell = keys.particle_tell

	-- Parameters
	local area_of_effect = ability:GetLevelSpecialValueFor("area_of_effect", ability_level)
	local caster_loc = caster:GetAbsOrigin()

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Remove any existing particles
	if caster.eruption_tell_pfx then
		ParticleManager:DestroyParticle(caster.eruption_tell_pfx, false)
	end

	-- Play particle
	caster.eruption_tell_pfx = ParticleManager:CreateParticle(particle_tell, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleAlwaysSimulate(caster.eruption_tell_pfx)
	ParticleManager:SetParticleControl(caster.eruption_tell_pfx, 0, caster_loc)
end

function HellfireEruptionCast( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_tell = keys.particle_tell

	-- Parameters
	local area_of_effect = ability:GetLevelSpecialValueFor("area_of_effect", ability_level)
	local caster_loc = caster:GetAbsOrigin()

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Remove any existing particles
	if caster.eruption_tell_pfx then
		ParticleManager:DestroyParticle(caster.eruption_tell_pfx, false)
	end

	-- Play particle
	caster.eruption_tell_pfx = ParticleManager:CreateParticle(particle_tell, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleAlwaysSimulate(caster.eruption_tell_pfx)
	ParticleManager:SetParticleControl(caster.eruption_tell_pfx, 0, caster_loc)

	-- Animate caster
	StartAnimation(caster, {duration = 2.0, activity = ACT_DOTA_ATTACK_EVENT, rate = 0.275})
end

function HellfireEruptionSuccess( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit
	local particle_blast = keys.particle_blast
	local particle_hit = keys.particle_hit

	-- Parameters
	local area_of_effect = ability:GetLevelSpecialValueFor("area_of_effect", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local caster_loc = caster:GetAbsOrigin()

	-- Stop caster animation
	EndAnimation(caster)

	-- Continuously stun and damage enemies
	local elapsed_duration = -1
	Timers:CreateTimer(0, function()
		
		-- Find nearby enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, area_of_effect, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			
			-- Stun enemy
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})

			-- Apply damage
			ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

			-- Play sound
			enemy:EmitSound(sound_hit)

			-- Play particle
			local hit_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(hit_pfx, 0, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControl(hit_pfx, 1, Vector(100, 1, 200))
		end

		-- Play the explosion
		local explosion_pfx = ParticleManager:CreateParticle(particle_blast, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleAlwaysSimulate(explosion_pfx)
		ParticleManager:SetParticleControl(explosion_pfx, 0, caster_loc)
		ParticleManager:SetParticleControl(explosion_pfx, 3, caster_loc)

		-- End the loop
		elapsed_duration = elapsed_duration + 1
		if elapsed_duration < duration then
			return 1
		else
			-- Destroy particles
			ParticleManager:DestroyParticle(caster.eruption_tell_pfx, false)
			caster.eruption_tell_pfx = nil
		end
	end)
end

function WraithfireEruptionInterrupt( keys )
	local caster = keys.caster
	local sound_cast = keys.sound_cast

	-- Stop/destroy sound/particle
	caster:StopSound(sound_cast)
	ParticleManager:DestroyParticle(caster.eruption_tell_pfx, true)
	caster.eruption_tell_pfx = nil
end

function HellfireEruptionInterrupt( keys )
	local caster = keys.caster
	local sound_cast = keys.sound_cast

	-- Stop/destroy sound/particle
	caster:StopSound(sound_cast)
	ParticleManager:DestroyParticle(caster.eruption_tell_pfx, true)
	caster.eruption_tell_pfx = nil

	-- Stop caster animation
	EndAnimation(caster)
end

function SummonRoyalGuard( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local summon_name = keys.summon_name
	local modifier_guard = keys.modifier_guard
	local particle_tether = keys.particle_tether

	-- Parameters
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local caster_pos = caster:GetAbsOrigin()
	local guard_distance = 350

	-- Add guard modifier stacks
	AddStacks(ability, caster, caster, modifier_guard, 4, true)

	-- Calculate spawn positions
	local spawn_pos_1 = caster_pos + Vector(guard_distance, guard_distance, 0)
	local spawn_pos_2 = caster_pos + Vector(guard_distance, -guard_distance, 0)
	local spawn_pos_3 = caster_pos + Vector(-guard_distance, guard_distance, 0)
	local spawn_pos_4 = caster_pos + Vector(-guard_distance, -guard_distance, 0)

	-- Spawn summons
	local royal_summon_1 = CreateUnitByName(summon_name, spawn_pos_1, false, caster, caster, caster:GetTeam())
	FindClearSpaceForUnit(royal_summon_1, spawn_pos_1, true)
	local royal_summon_2 = CreateUnitByName(summon_name, spawn_pos_2, false, caster, caster, caster:GetTeam())
	FindClearSpaceForUnit(royal_summon_2, spawn_pos_2, true)
	local royal_summon_3 = CreateUnitByName(summon_name, spawn_pos_3, false, caster, caster, caster:GetTeam())
	FindClearSpaceForUnit(royal_summon_3, spawn_pos_3, true)
	local royal_summon_4 = CreateUnitByName(summon_name, spawn_pos_4, false, caster, caster, caster:GetTeam())
	FindClearSpaceForUnit(royal_summon_4, spawn_pos_4, true)

	-- Make the summons' duration limited
	royal_summon_1:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
	royal_summon_2:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
	royal_summon_3:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
	royal_summon_4:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})

	-- Draw particles
	royal_summon_1.royal_guard_tether_pfx = ParticleManager:CreateParticle(particle_tether, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(royal_summon_1.royal_guard_tether_pfx, 0, royal_summon_1, PATTACH_POINT_FOLLOW, "attach_origin", royal_summon_1:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(royal_summon_1.royal_guard_tether_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	royal_summon_2.royal_guard_tether_pfx = ParticleManager:CreateParticle(particle_tether, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(royal_summon_2.royal_guard_tether_pfx, 0, royal_summon_2, PATTACH_POINT_FOLLOW, "attach_origin", royal_summon_2:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(royal_summon_2.royal_guard_tether_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	royal_summon_3.royal_guard_tether_pfx = ParticleManager:CreateParticle(particle_tether, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(royal_summon_3.royal_guard_tether_pfx, 0, royal_summon_3, PATTACH_POINT_FOLLOW, "attach_origin", royal_summon_3:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(royal_summon_3.royal_guard_tether_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	royal_summon_4.royal_guard_tether_pfx = ParticleManager:CreateParticle(particle_tether, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(royal_summon_4.royal_guard_tether_pfx, 0, royal_summon_4, PATTACH_POINT_FOLLOW, "attach_origin", royal_summon_4:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(royal_summon_4.royal_guard_tether_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)

	-- Memorize relative positions to the caster
	royal_summon_1.royal_guard_position = Vector(guard_distance, guard_distance, 0)
	royal_summon_2.royal_guard_position = Vector(guard_distance, -guard_distance, 0)
	royal_summon_3.royal_guard_position = Vector(-guard_distance, guard_distance, 0)
	royal_summon_4.royal_guard_position = Vector(-guard_distance, -guard_distance, 0)
end

function RoyalGuardThink( keys )
	local caster = keys.caster
	local owner = caster:GetOwnerEntity()

	-- Update position
	caster:SetAbsOrigin(owner:GetAbsOrigin() + caster.royal_guard_position)
	caster:SetForwardVector(owner:GetForwardVector())
end

function RoyalGuardDamage( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	
	-- If the attacker is a creep, take no damage
	if not (attacker:IsHero() or attacker:IsTower() or IsRoshan(attacker) or IsFountain(attacker)) then
		return nil
	end

	-- If the damage is enough to kill the guard, destroy it
	if caster:GetHealth() <= 1 then
		caster:Kill(ability, attacker)

	-- Else, reduce its HP
	else
		caster:SetHealth(caster:GetHealth() - 1)
	end
end

function RoyalGuardEnd( keys )
	local caster = keys.unit
	local owner = caster:GetOwnerEntity()
	local modifier_guard = keys.modifier_guard

	-- Remove one stack of the royal guard buff
	owner:SetModifierStackCount(modifier_guard, owner, owner:GetModifierStackCount(modifier_guard, owner) - 1 )

	-- Delete tether particle
	ParticleManager:DestroyParticle(caster.royal_guard_tether_pfx, false)

	-- If at zero stacks, remove the buff
	if owner:GetModifierStackCount(modifier_guard, owner) <= 0 then
		owner:RemoveModifierByName(modifier_guard)
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

	-- If the target is a hero, grant the crit modifier to the caster
	if caster:IsRealHero() and target:IsHero() then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_crit, {})
	end
end

function VampiricAuraCritHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_buff = keys.modifier_buff
	local modifier_debuff = keys.modifier_debuff

	-- Add a stack of the buff to the caster
	AddStacks(ability, caster, caster, modifier_buff, 1, true)

	-- Add a stack of the debuff to the target
	AddStacks(ability, caster, target, modifier_debuff, 1, true)

	-- Force update the caster and target's attributes
	caster:CalculateStatBonus()
	target:CalculateStatBonus()
end

function HellfireAuraDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stacks = keys.modifier_stacks
	
	-- Parameters
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local bonus_damage = ability:GetLevelSpecialValueFor("bonus_damage", ability_level)

	-- Fetch caster stack amount
	local bonus_stacks = caster:GetModifierStackCount(modifier_stacks, caster)

	-- Calculate damage
	local total_damage = base_damage + bonus_damage * bonus_stacks

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = total_damage, damage_type = DAMAGE_TYPE_MAGICAL})
end

function HellfireAuraPowerup( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stacks = keys.modifier_stacks
	
	-- Add a stack of aura power
	AddStacks(ability, caster, caster, modifier_stacks, 1, true)
end

function HellfireAuraParticle( keys )
	local caster = keys.caster
	local target = keys.target
	local particle_burn = keys.particle_burn
	
	-- Create burn particle
	target.hellfire_aura_burn_pfx = ParticleManager:CreateParticle(particle_burn, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControlEnt(target.hellfire_aura_burn_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_origin", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(target.hellfire_aura_burn_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
end

function HellfireAuraParticleEnd( keys )
	local target = keys.target
	local particle_burn = keys.particle_burn
	
	-- Destroy burn particle
	ParticleManager:DestroyParticle(target.hellfire_aura_burn_pfx, false)
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

function ReincarnationDamageSkeleton( keys )
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
	local particle_reincarnation = keys.particle_reincarnation
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

		-- Play reincarnation particle
		local reincarnate_pfx = ParticleManager:CreateParticle(particle_reincarnation, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleAlwaysSimulate(reincarnate_pfx)
		ParticleManager:SetParticleControl(reincarnate_pfx, 0, caster_loc)
		ParticleManager:SetParticleControl(reincarnate_pfx, 2, caster_loc)

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

		-- Remove wearables
		RemoveWearables(caster)
	end)
end