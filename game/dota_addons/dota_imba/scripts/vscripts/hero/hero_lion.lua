--[[	Author: Shush
		Date: 05.12.2016	]]

function EarthSpikes ( keys )
	-- Ability properties
	local caster = keys.caster
	local target = keys.target
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel()-1
	local sound_cast = keys.sound_cast
	local particle_projectile = keys.particle_projectile		
	
	
	-- Ability specials
	local spike_speed = ability:GetLevelSpecialValueFor("spike_speed", ability_level)
	local travel_distance = ability:GetLevelSpecialValueFor("travel_distance", ability_level)
	local spikes_radius = ability:GetLevelSpecialValueFor("spikes_radius", ability_level)	
		
	
	-- Clean all targets from the earth spike hit variation
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									caster:GetAbsOrigin(),
									nil,
									50000,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
									FIND_ANY_ORDER,
									false)
	
	for _,enemy in pairs(enemies) do
		if enemy.hit_by_earth_spikes then
			enemy.hit_by_earth_spikes = nil
		end
		
		if enemy.earth_spikes_incoming then
			enemy.earth_spikes_incoming = nil
		end
	end	
	
	
	-- Decide if spell was cast on ground or on a target unit
	if not target then
		target = target_point
	else
		target = target:GetAbsOrigin()
	end
	
	-- Adjust length if caster has cast increase
	travel_distance = travel_distance + GetCastRangeIncrease(caster)
	
		
	-- Play sound
	caster:EmitSound(sound_cast)		
	
	-- Launch line projectile
	local spikes_projectile = {	Ability = ability,
								EffectName = particle_projectile,
								vSpawnOrigin = caster:GetAbsOrigin(),
								fDistance = travel_distance,
								fStartRadius = spikes_radius,
								fEndRadius = spikes_radius,
								Source = caster,
								bHasFrontalCone = false,
								bReplaceExisting = false,
								iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,							
								iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,							
								bDeleteOnHit = false,
								vVelocity = (target - caster:GetAbsOrigin()):Normalized() * spike_speed,
								bProvidesVision = false,							
							}
							
	ProjectileManager:CreateLinearProjectile(spikes_projectile)
	
end

function EarthSpikesHit ( keys )
	-- Ability properties
	local caster = keys.caster
	local target = keys.target	
	local ability = keys.ability
	local ability_level = ability:GetLevel()-1
	local sound_impact = keys.sound_impact
	local particle_hit = keys.particle_hit	
	local sound_cast = keys.sound_cast
	local particle_projectile = keys.particle_projectile
	
	-- Ability specials	
	local knock_up_height = ability:GetLevelSpecialValueFor("knock_up_height", ability_level)
	local knock_up_time = ability:GetLevelSpecialValueFor("knock_up_time", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local spike_speed = ability:GetLevelSpecialValueFor("spike_speed", ability_level)
	local travel_distance = ability:GetLevelSpecialValueFor("travel_distance", ability_level)
	local spikes_radius = ability:GetLevelSpecialValueFor("spikes_radius", ability_level)	
	local extra_spike_AOE = ability:GetLevelSpecialValueFor("extra_spike_AOE", ability_level)
	local wait_interval = ability:GetLevelSpecialValueFor("wait_interval", ability_level)
			
	-- Spikes ignore target if it was already hit this cast
	if target.hit_by_earth_spikes then
		return nil
	end
	
	-- Mark target as hit by Earth Spikes
	target.hit_by_earth_spikes = true
		
	
	-- Add high spikes particles
	local particle_hit = ParticleManager:CreateParticle(particle_hit, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle_hit, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_hit, 2, target:GetAbsOrigin())	
	
	-- Play hit sound
	caster:EmitSound(sound_impact)	
	
	Timers:CreateTimer(0.35, function()	
		-- Find closest enemy around target that is not on the hit table and has no lines coming to them.
								
					local enemies = FindUnitsInRadius(caster:GetTeam(),
												 target:GetAbsOrigin(),
												 nil,
												 extra_spike_AOE,
												 DOTA_UNIT_TARGET_TEAM_ENEMY, 
												 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
												 DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
												 FIND_CLOSEST,
												 false)										 
				
		for _,enemy in pairs(enemies) do
			-- Prevent heroes shoting himself and those who are already marked
			if enemy ~= target and not enemy.hit_by_earth_spikes and not enemy.earth_spikes_incoming then 					
					
				-- Register as valid enemy for an earth spike
				enemy.earth_spikes_incoming = true
						
				-- Play sound
				caster:EmitSound(sound_cast)		
							
				-- Launch line projectile
				local spikes_projectile = {	Ability = ability,
											EffectName = particle_projectile,
											vSpawnOrigin = target:GetAbsOrigin(),
											fDistance = travel_distance,
											fStartRadius = spikes_radius,
											fEndRadius = spikes_radius,
											Source = caster,
											bHasFrontalCone = false,
											bReplaceExisting = false,
											iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,							
											iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,							
											bDeleteOnHit = false,
											vVelocity = (enemy:GetAbsOrigin() - target:GetAbsOrigin()):Normalized() * spike_speed,
											bProvidesVision = false,							
										}
												
				ProjectileManager:CreateLinearProjectile(spikes_projectile)
			-- Stop at the first valid enemy										
			break
			end
		end			
	end)
	
	-- If target has Linken's Sphere off cooldown, do nothing else
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end	
	
	-- If target has magic immunity, do nothing else
	if target:IsMagicImmune() then
		return nil
	end
	
	-- Immediately apply stun
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		
	-- Knockback unit to the air	
	local knockbackProperties =
    {
        center_x = target.x,
        center_y = target.y,
        center_z = target.z,
        duration = knock_up_time,
        knockback_duration = knock_up_time,
        knockback_distance = 0,
        knockback_height = knock_up_height
    }
      target:AddNewModifier( target, nil, "modifier_knockback", knockbackProperties )
		
	
	-- Wait for the target to land and apply damage
	Timers:CreateTimer(knock_up_time, function()
		-- Add target to table of enemies hit
			
		
		local damageTable = {	victim = target,
								 attacker = caster,	
								 damage = damage,
								 damage_type = DAMAGE_TYPE_MAGICAL
							}
	
		ApplyDamage(damageTable)		
	end)
	
	-- Adjust length if caster has cast increase
	travel_distance = travel_distance + GetCastRangeIncrease(caster)
end

function Hex ( keys )
	-- Ability properties
	local caster = keys.caster
	local target = keys.target	
	local ability = keys.ability
	local ability_level = ability:GetLevel()-1
	local sound_cast = keys.sound_cast	
	local modifier_hex = keys.modifier_hex
	local modifier_bounce = keys.modifier_bounce
	local hex_particle = keys.hex_particle
	local scepter = HasScepter(caster)
	
	-- Ability specials
	local bounce_delay = ability:GetLevelSpecialValueFor("bounce_duration", ability_level)

	if scepter then
		bounce_delay = ability:GetLevelSpecialValueFor("b_duration_scepter", ability_level)
	end
	
	-- If target has Linken's Sphere off cooldown, do nothing else
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end
	
	-- Play sound
	caster:EmitSound(sound_cast)

	-- Add particles
	local hex_particle = ParticleManager:CreateParticle(hex_particle, PATTACH_CUSTOMORIGIN, target)		
	ParticleManager:SetParticleControl(hex_particle, 0, target:GetAbsOrigin())		
	ability:ApplyDataDrivenModifier(caster, target, modifier_hex, {})
	ability:ApplyDataDrivenModifier(caster, target, modifier_bounce, {duration = bounce_delay})
end

function HexModelChange( keys )
	local target = keys.target
	local model_frog = keys.model_frog

	ChangeUnitModel(target, model_frog)
end

function HexModelRevert( keys )
	local target = keys.target

	RevertUnitModel(target)
end

function HexBounce ( keys )

	-- Ability properties
	local caster = keys.caster
	local target = keys.target	
	local ability = keys.ability
	local ability_level = ability:GetLevel()-1
	local sound_cast = keys.sound_cast
	local modifier_hex = keys.modifier_hex
	local modifier_bounce = keys.modifier_bounce
	local hex_particle = keys.hex_particle
	local scepter = HasScepter(caster)
	
	-- Ability specials
	local hex_bounce_radius = ability:GetLevelSpecialValueFor("hex_bounce_radius", ability_level)
	local bounce_delay = ability:GetLevelSpecialValueFor("bounce_duration", ability_level)

	if scepter then
		bounce_delay = ability:GetLevelSpecialValueFor("b_duration_scepter", ability_level)
	end
	
	-- If the target was an is illusion, kill it
	if target:IsIllusion() then
		target:ForceKill(false)
	end
	
	-- Find enemies
	Timers:CreateTimer(0.03, function()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
										target:GetAbsOrigin(),
										nil,
										hex_bounce_radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY,
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
										FIND_ANY_ORDER,
										false)
										
		-- Pick enemy which is not the one the modifier was just destroyed on	
		for _,enemy in pairs(enemies) do
		
			if target ~= enemy and not enemy:HasModifier(modifier_hex) then

				-- If target has Linken's Sphere off cooldown, do nothing else
				if enemy:GetTeam() ~= caster:GetTeam() and enemy:TriggerSpellAbsorb(ability) then
					return nil
				else

					-- Play sound
					enemy:EmitSound(sound_cast)	

					-- Add particles
					local hex_particle = ParticleManager:CreateParticle(hex_particle, PATTACH_CUSTOMORIGIN, enemy)		
					ParticleManager:SetParticleControl(hex_particle, 0, enemy:GetAbsOrigin())				
					ability:ApplyDataDrivenModifier(caster, enemy, modifier_hex, {})
					ability:ApplyDataDrivenModifier(caster, enemy, modifier_bounce, {duration = bounce_delay})
				end

				-- Stop at the first valid target
				break
			end
		end
	end)
end

function ManaDrain ( keys )
	-- Ability properties
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel()-1
	local sound_cast = keys.sound_cast
	local particle_drain = keys.particle_drain	
	local modifier_drain = keys.modifier_drain
	
	-- Ability specials
	local max_channel_time = ability:GetLevelSpecialValueFor("max_channel_time", ability_level)
	local break_distance = ability:GetLevelSpecialValueFor("break_distance", ability_level)
	local interval = ability:GetLevelSpecialValueFor("interval", ability_level)
	local mana_drain_sec = ability:GetLevelSpecialValueFor("mana_drain_sec", ability_level)
	local mana_pct_as_damage = ability:GetLevelSpecialValueFor("mana_pct_as_damage", ability_level) * 0.01
	
	-- Play cast sound
	caster:EmitSound(sound_cast)
	
	-- Check for Linken's Sphere
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end	
	
	-- Check for illusions	
	if target:IsIllusion() then
		target:ForceKill(false)
		return nil
	end
	
	-- Add debuff
	ability:ApplyDataDrivenModifier(caster, target, modifier_drain, {})
	
	-- Add particles
	local particle_drain = ParticleManager:CreateParticle(particle_drain, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_drain, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_drain, 1, caster:GetAbsOrigin())
	
	-- Initalize variables
	local firstInterval = true
	local canDrain = true
	local mana_drain_per_interval = mana_drain_sec / 10	
	
	-- Start timer every 0.1 interval, 
	Timers:CreateTimer(function()
		-- Check if it's time to break the timer, remove particle if so
		if not caster:IsChanneling() then			
		ParticleManager:DestroyParticle(particle_drain, false)
			return nil
		end		
		
		-- Delay by 0.1 after first cast	
		if firstInterval then
			firstInterval = false		
			return interval
		end
	
		-- Distance and direction
		local distance = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()	
		local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()		
	
		-- Make sure caster is always facing towards the target
		caster:SetForwardVector(direction)	
	
		-- Check for states that break the drain, remove particle if so
		if distance > break_distance or target:IsMagicImmune() or target:IsInvulnerable() then		
			caster:InterruptChannel()
			caster:StopSound(sound_cast)
			ParticleManager:DestroyParticle(particle_drain, false)
			return nil
		end
		
		-- Calculate mana needed for caster to have full mana, set variable to store drained mana
		local caster_mana_needed = caster:GetMaxMana()-caster:GetMana()			
		local mana_drained = nil
		
		-- Check if target has more mana than max possible to drain, else drain what target has		
		if target:GetMana() > mana_drain_per_interval then
			target:ReduceMana(mana_drain_per_interval)			
			caster:GiveMana(mana_drain_per_interval)
			mana_drained = mana_drain_per_interval
		else
			mana_drained = target:GetMana()
			target:ReduceMana(target:GetMana())
			caster:GiveMana(target:GetMana())
		end			
		
		-- Damage target by a percent of mana drained
		local damage = mana_drained * mana_pct_as_damage
			local damageTable = {victim = target,
								 attacker = caster,	
								 damage = damage,
								 damage_type = DAMAGE_TYPE_MAGICAL
								}
	
		ApplyDamage(damageTable)
		
		-- Excess mana converted to healing
			if mana_drained > caster_mana_needed then
				local heal_caster_by = mana_drained - caster_mana_needed
				caster:Heal(heal_caster_by, caster)
			end
		
		return interval	
	end)
end

function ManaDrainRemoveDebuff ( keys )
	local target = keys.target
	local ability = keys.ability
	local modifier_drain = keys.modifier_drain

	if target:HasModifier(modifier_drain) then
		target:RemoveModifierByName(modifier_drain)
	end
end

function ManaDrainAura ( keys )
	-- Ability properties
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel()-1
	local modifier_drain_aura = keys.modifier_drain_aura
	
	-- Ability specials
	local aura_max_mana_drain = ability:GetLevelSpecialValueFor("aura_max_mana_drain", ability_level) * 0.01
	local aura_radius = ability:GetLevelSpecialValueFor("aura_radius", ability_level)

	-- Find enemies in radius that has the aura modifier
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									caster:GetAbsOrigin(),
									nil,
									aura_radius,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
									FIND_ANY_ORDER,
									false)
	
	-- Iterate through each eligible enemy
	for _,enemy in pairs(enemies) do
		if enemy:HasModifier(modifier_drain_aura) and enemy:GetMana() > 0 then
			-- Get Max Mana and produce drain amount from it
			local mana_to_drain = enemy:GetMaxMana() * aura_max_mana_drain
			
			-- Set steal amount divided by 10 (10 intervals per sec)
			local mana_drain_per_interval = mana_to_drain * 0.1
			
			-- Calculate mana needed for caster to have full mana, set variable to store drained mana
			local caster_mana_needed = caster:GetMaxMana()-caster:GetMana()			
			local mana_drained = nil
			
			-- Steal maximum possible or whatever left from target and give it to caster
			if enemy:GetMana() > mana_drain_per_interval then
				enemy:ReduceMana(mana_drain_per_interval)
				caster:GiveMana(mana_drain_per_interval)
				mana_drained = mana_drain_per_interval
			else
				mana_drained = enemy:GetMana()
				enemy:ReduceMana(enemy:GetMana())
				caster:GiveMana(enemy:GetMana())
				
			end
			
			-- Excess mana converted to healing
			if mana_drained > caster_mana_needed then
				local heal_caster_by = mana_drained - caster_mana_needed
				caster:Heal(heal_caster_by, caster)
			end
		end		
	end
end

function FingerOfDeath ( keys )
	-- Ability properties
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel()-1
	local sound_cast = keys.sound_cast
	local particle_finger = keys.particle_finger
	local modifier_kill = keys.modifier_kill
	local modifier_delay = keys.modifier_delay
	local scepter = caster:HasScepter()	
	
	-- Ability specials
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)	
	local cooldown_scepter = ability:GetLevelSpecialValueFor("cooldown_scepter", ability_level)
	local mana_price_increase = ability:GetLevelSpecialValueFor("mana_price_increase", ability_level)
	local scepter_radius = ability:GetLevelSpecialValueFor("scepter_radius", ability_level)	
	
	-- Spend additional mana depending on stacks of Finger Kills
	if caster:HasModifier(modifier_kill) then
		local kill_stacks = caster:FindModifierByName(modifier_kill):GetStackCount()
		local additional_mana = ability:GetManaCost(ability_level) * (1 + mana_price_increase)^kill_stacks		
		
		caster:SpendMana(additional_mana, ability)		
	end
	
	-- Change cooldown if caster has scepter
	if scepter then
		ability:EndCooldown()
		ability:StartCooldown(cooldown_scepter * GetCooldownReduction(caster))
	end
	
	-- Play the cast sound
	caster:EmitSound(sound_cast)

	-- Launch the projectile
	local finger_projectile =	{Target = target,
								Source = caster,
								Ability = ability,
								EffectName = particle_finger,		
								iMoveSpeed = 4000,
								bDodgeable = false, 
								bVisibleToEnemies = true,
								bReplaceExisting = false,        									
	}						
	ProjectileManager:CreateTrackingProjectile(finger_projectile)

	-- Apply the actual damage delay modifier
	ability:ApplyDataDrivenModifier(caster, target, modifier_delay, {})
end

function FingerOfDeathImpact ( keys )
	-- Ability properties
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel()-1
	local sound_impact = keys.sound_impact
	local particle_finger = keys.particle_finger
	local modifier_kill = keys.modifier_kill
	local modifier_hex = keys.modifier_hex
	local scepter = caster:HasScepter()

	-- Ability specials
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local radius_scepter = ability:GetLevelSpecialValueFor("radius_scepter", ability_level)	
		
	-- Declare caster kill state
	if not caster.newCast then
		caster.newCast = true
		Timers:CreateTimer(0.1, function()
			caster.newCast = nil
		end)
	end

	-- Search for valid nearby targets
	local targets = {}
	targets[1] = target
	if scepter then
		damage = ability:GetLevelSpecialValueFor("damage_scepter", ability_level)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius_scepter, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			if enemy ~= target and (enemy:HasModifier("modifier_stunned") or enemy:HasModifier(modifier_hex)) then
				targets[#targets + 1] = enemy
			end
		end
	end

	-- Projectile
	local finger_projectile =	{	Target = target,
									Source = target,
									Ability = ability,
									EffectName = particle_finger,		
									iMoveSpeed = 4000,
									bDodgeable = false, 
									bVisibleToEnemies = true,
									bReplaceExisting = false	}						

	-- Iterate through targets
	for _,hit_target in pairs(targets) do
		if not target:TriggerSpellAbsorb(ability) then
			if hit_target == target or hit_target:IsRealHero() then
				hit_target:EmitSound(sound_impact)
			end
			finger_projectile.Target = hit_target
			ProjectileManager:CreateTrackingProjectile(finger_projectile)
			ApplyDamage({victim = hit_target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end
end

function FingerOfDeathCheckKill ( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel()-1
	local modifier_kill = keys.modifier_kill
	
	-- Reset cooldown when target hero has died from Finger. Give a stack of modifier that increases mana cost by 50% per stack.	
	if caster.newCast then
		ability:EndCooldown()
		ability:ApplyDataDrivenModifier(caster, caster, modifier_kill, {})

		-- Prevent multiple triggers in one cast
		caster.newCast = false
	end
end
