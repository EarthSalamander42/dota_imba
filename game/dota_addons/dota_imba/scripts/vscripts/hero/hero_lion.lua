-- Author: Shush
-- Date: 05/12/2016

-- ******************




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
	local hex_particle = keys.hex_particle
	
	
	-- Ability specials
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	
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
	
end


function HexBounce ( keys )
	-- Ability properties
	local caster = keys.caster
	local target = keys.target	
	local ability = keys.ability
	local ability_level = ability:GetLevel()-1
	local sound_cast = keys.sound_cast
	local modifier_hex = keys.modifier_hex
	local hex_particle = keys.hex_particle
	
	-- Ability specials
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local hex_bounce_radius = ability:GetLevelSpecialValueFor("hex_bounce_radius", ability_level)
	
	
	-- If the target was an is illusion, kill it
	if target:IsIllusion() then
		target:ForceKill(false)
	end
	
	-- Find enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									target:GetAbsOrigin(),
									nil,
									hex_bounce_radius,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
									FIND_ANY_ORDER,
									false)
									
	-- Pick enemy which is not the one the modifier was just destroyed on	
	for _,enemy in pairs(enemies) do
	
		if target ~= enemy then		
			-- Play sound
			caster:EmitSound(sound_cast)					
				-- Add particles
				local hex_particle = ParticleManager:CreateParticle(hex_particle, PATTACH_CUSTOMORIGIN, enemy)		
				ParticleManager:SetParticleControl(hex_particle, 0, enemy:GetAbsOrigin())				
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_hex, {})												
			break -- stop at the first valid target
		end	
		
	end
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
	local mana_pct_as_damage = ability:GetLevelSpecialValueFor("mana_pct_as_damage", ability_level)
	
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
		if distance > break_distance or target:IsMagicImmune() or target:IsInvulnerable() or target:GetMana() == 0 then		
			caster:InterruptChannel()
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
	local aura_max_mana_drain = ability:GetLevelSpecialValueFor("aura_max_mana_drain", ability_level)
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
			local mana_drain_per_interval = mana_to_drain / 10
			
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
	local scepter = caster:HasScepter()	
	local modifier_kill = keys.modifier_kill
	
	-- Ability specials
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)	
	local scepter_cooldown = ability:GetLevelSpecialValueFor("scepter_cooldown", ability_level)
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
		ability:StartCooldown(scepter_cooldown * GetCooldownReduction(caster))
	end
	
	-- Play the cast sound
	caster:EmitSound(sound_cast)

	-- Launch the projectile(s)
	if not scepter then -- single target
		local finger_projectile =	{Target = target,
									Source = caster,
									Ability = ability,
									EffectName = particle_finger,		
									iMoveSpeed = projectile_speed,
									bDodgeable = false, 
									bVisibleToEnemies = true,
									bReplaceExisting = false,        									
									}
									
		ProjectileManager:CreateTrackingProjectile(finger_projectile)	
	else
		-- Find enemies in the AoE area
		local enemies = FindUnitsInRadius(	caster:GetTeamNumber(),
											  target:GetAbsOrigin(),
											  nil,
											  scepter_radius,
											  DOTA_UNIT_TARGET_TEAM_ENEMY,
											  DOTA_UNIT_TARGET_HERO,
											  DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
											  FIND_ANY_ORDER,
											  false)
											  
		for _,enemy in pairs(enemies) do			
			local finger_projectile =	{Target = enemy,
										Source = caster,
										Ability = ability,
										EffectName = particle_finger,		
										iMoveSpeed = projectile_speed,
										bDodgeable = false, 
										bVisibleToEnemies = true,
										bReplaceExisting = false,        									
										}										
										
			ProjectileManager:CreateTrackingProjectile(finger_projectile)
			
		end
	end									  
end

function FingerOfDeathImpact ( keys )
	-- Ability properties
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel()-1
	local sound_impact = keys.sound_impact
	local particle_impact = keys.particle_impact
	local scepter = caster:HasScepter()
	local modifier_kill = keys.modifier_kill
	local modifier_check = keys.modifier_check
	
	-- Ability specials
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local damage_delay = ability:GetLevelSpecialValueFor("damage_delay", ability_level)	
	local scepter_damage = ability:GetLevelSpecialValueFor("scepter_damage", ability_level)
		
	-- Declare caster kill state
	if not caster.newCast then
		caster.newCast = true
	end
		
	-- Check for scepter, assign damage
	if scepter then
		damage = scepter_damage		
	end	
	
	-- Play hit sound
	caster:EmitSound(sound_impact)
	
	--Add particles
	local particle_impact = ParticleManager:CreateParticle(particle_impact, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_impact, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_impact, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_impact, 2, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_impact, 3, Vector(100, 0, 0))
	
	-- Check for Linken's Sphere on primary target	
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end	 	
	
	-- Wait for 0.25 seconds, then deal damage
	Timers:CreateTimer(damage_delay, function()		
		if not target:IsMagicImmune() then
			local damageTable = {victim = target,
							 attacker = caster,	
							 damage = damage,
							 damage_type = DAMAGE_TYPE_MAGICAL
							}	
			ApplyDamage(damageTable)					
			
		end						
	end)	
	
end



function FingerOfDeathCheckKill ( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel()-1
	local modifier_kill = keys.modifier_kill
	
	print("check kill")	
	
	-- Reset cooldown when target hero has died from Finger. Give a stack of modifier that increases mana cost by 50% per stack.	
	if caster.newCast then
	print("we're into check kill!")
			ability:EndCooldown()	
			ability:ApplyDataDrivenModifier(caster, caster, modifier_kill, {})
	
			-- Prevent multiple triggers in one cast
			caster.newCast = false			
	end

	
	
	
end






































