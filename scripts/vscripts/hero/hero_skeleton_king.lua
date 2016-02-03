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

	-- Stun the target if it is not magic immune
	if not target:IsMagicImmune() then
		target:AddNewModifier(caster, ability, "modifier_stunned", {duration = secondary_stun})
	end

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Only bounce and spawn a summon if this is the main target
	if caster.wraithfire_blast_main_target and caster.wraithfire_blast_main_target == target then

		-- Stun the main target for longer
		target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})

		-- Spawn the summon
		if caster:IsHero() then
			local skeleton_loc = target:GetAbsOrigin() + RandomVector(100)
			local hellfire_skeleton = CreateUnitByName(summon_name, skeleton_loc, false, caster, caster, caster:GetTeam())
			FindClearSpaceForUnit(hellfire_skeleton, skeleton_loc, true)

			-- Make the summon limited duration and uncontrollable
			hellfire_skeleton:SetControllableByPlayer(caster:GetPlayerID(), true)
			hellfire_skeleton:SetForceAttackTarget(target)
			hellfire_skeleton:AddNewModifier(caster, ability, "modifier_kill", {duration = summon_duration})
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

		-- Delay the lifesteal for one game tick to prevent blademail interaction
		Timers:CreateTimer(0.01, function()
			if target:IsRealHero() then
				attacker:Heal(damage * lifesteal_hero / 100, caster)
			else
				attacker:Heal(damage * lifesteal_creep / 100, caster)
			end
		end)
		
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
	local modifier_dmg = keys.modifier_dmg
	local modifier_ms = keys.modifier_ms

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local creep_damage = ability:GetLevelSpecialValueFor("creep_damage", ability_level)
	local creep_ms = ability:GetLevelSpecialValueFor("creep_ms", ability_level)
	local hero_damage = ability:GetLevelSpecialValueFor("hero_damage", ability_level)
	local hero_ms = ability:GetLevelSpecialValueFor("hero_ms", ability_level)
	local caster_loc = caster:GetAbsOrigin()

	-- Destroy tell particle
	ParticleManager:DestroyParticle(caster.kingdom_come_tell_pfx, false)
	caster.kingdom_come_tell_pfx = nil

	-- Find enemies inside the area of effect and iterate through them
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,target in pairs(enemies) do
		
		-- Apply the debuff modifier to this enemy
		ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})

		-- Stun this enemy
		target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})

		-- Kill non-ancient creeps and illusions
		if not target:IsRealHero() and not target:IsAncient() then
			target:Kill(ability, caster)

			-- Add buff stacks to the caster
			AddStacks(ability, caster, caster, modifier_dmg, creep_damage, true)
			AddStacks(ability, caster, caster, modifier_ms, creep_ms, true)

		-- Damage and create wraiths for heroes
		elseif target:IsRealHero() then

			-- Damage
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

			-- Summon a wraith for this enemy
			local target_loc = target:GetAbsOrigin()
			local wraith_loc = target_loc + (caster_loc - target_loc):Normalized() * 120
			local kingdom_wraith = CreateUnitByName(summon_name, wraith_loc, false, caster, caster, caster:GetTeam())
			FindClearSpaceForUnit(kingdom_wraith, wraith_loc, true)

			-- Make the summon limited duration and uncontrollable
			kingdom_wraith:SetControllableByPlayer(caster:GetPlayerID(), true)
			kingdom_wraith:SetForceAttackTarget(target)
			kingdom_wraith:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})

			-- Apply the summon's modifier
			ability:ApplyDataDrivenModifier(caster, kingdom_wraith, modifier_summon, {})

			-- Add buff stacks to the caster
			AddStacks(ability, caster, caster, modifier_dmg, hero_damage, true)
			AddStacks(ability, caster, caster, modifier_ms, hero_ms, true)
		end
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
			if ally ~= caster and not ally:HasModifier(modifier_wraith) then
				ability:ApplyDataDrivenModifier(caster, ally, modifier_scepter, {})
			end
		end
	end
end

function ReincarnationWraithDamage( keys )
	local target = keys.unit

	-- If health is not 1, do nothing
	if target:GetHealth() > 1 or target.has_aegis or target:HasModifier("modifier_imba_shallow_grave") or target:HasModifier("modifier_imba_shallow_grave_passive") then
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

	-- If health is minimal, but the ability is on cooldown, die to the original attacker
	if not ability:IsCooldownReady() then
		caster:RemoveModifierByName(modifier_reincarnation)
		ApplyDamage({attacker = attacker, victim = caster, ability = ability, damage = 3, damage_type = DAMAGE_TYPE_PURE})
		return nil
	end

	-- Else, put the ability on cooldown and play out the reincarnation
	local cooldown_reduction = GetCooldownReduction(caster)
	ability:StartCooldown( ability:GetCooldown(ability_level) * cooldown_reduction )

	-- Play initial sound
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, slow_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
	if #heroes >= IMBA_PLAYERS_ON_GAME * 0.35 then
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

		-- Count nearby allies
		local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, slow_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

		-- Grant temporary bonus strength
		if nearby_allies and #nearby_allies > 1 then
			local bonus_str = math.floor( caster:GetStrength() * str_bonus * math.min(#nearby_allies - 1, 4) / 100 )
			AddStacks(ability, caster, caster, modifier_str, bonus_str, true)
		end

		-- Purge all debuffs
		caster:Purge( false, true, false, true, false)

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