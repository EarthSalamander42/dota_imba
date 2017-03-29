--[[	Author: Shush
		Date: 03.12.2016	]]

function ArcaneBoltCast ( keys )
	-- Ability properties	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() -1
	local sound_cast = keys.sound_cast
	local particle_projectile = keys.particle_projectile	
	local scepter = caster:HasScepter()

	-- Parameters
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)

	-- Play the cast sound
	caster:EmitSound(sound_cast)

	-- Launch the projectile
	local arcane_bolt_projectile
	arcane_bolt_projectile = {
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = particle_projectile,
		iMoveSpeed = projectile_speed,
		bDodgeable = false, 
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = true,
		iVisionRadius = vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	ProjectileManager:CreateTrackingProjectile(arcane_bolt_projectile)	

	-- Secondary cast with scepter
	if scepter then
		local range_scepter = ability:GetLevelSpecialValueFor("range_scepter", ability_level)
		local nearby_targets = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, range_scepter, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		if nearby_targets[1] then
			Timers:CreateTimer(0.3, function()
				-- Launch the projectile
				local arcane_bolt_projectile
				arcane_bolt_projectile = {
					Target = nearby_targets[1],
					Source = caster,
					Ability = ability,
					EffectName = particle_projectile,
					iMoveSpeed = projectile_speed,
					bDodgeable = false, 
					bVisibleToEnemies = true,
					bReplaceExisting = false,
					bProvidesVision = true,
					iVisionRadius = vision_radius,
					iVisionTeamNumber = caster:GetTeamNumber()
				}
				ProjectileManager:CreateTrackingProjectile(arcane_bolt_projectile)
			end)
		end
	end
end

function ArcaneBoltHit ( keys )	
	-- Ability properties
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_impact = keys.sound_impact
	local modifier_stacks = keys.modifier_stacks	
	local seal_modifier = keys.seal_modifier	

	-- Parameters
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local int_multiplier = ability:GetLevelSpecialValueFor("int_multiplier", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)	
	local stack_count = caster:GetModifierStackCount(modifier_stacks, ability)
	local stack_int_multi_bonus = ability:GetLevelSpecialValueFor("stack_int_multi_bonus", ability_level)

	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- Calculate caster's intelligence
	local caster_int = 0
	if caster:IsRealHero() then
		caster_int = caster:GetIntellect()
	end

	-- Play impact sound
	caster:EmitSound(sound_impact)

	-- Apply vision around the impact area
	ability:CreateVisibilityNode(target:GetAbsOrigin(), vision_radius, vision_duration)
	
	-- Calculate damage 		
	local int_multiplier = int_multiplier + (stack_count * stack_int_multi_bonus)
	local final_damage = base_damage + (int_multiplier * caster_int)
	
	-- Deal damage to target if it's not magic immune
	ApplyDamage({victim = target, attacker = caster, damage = final_damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Add a stack of Arcane Wrath if the target is a hero
	if target:IsHero() then
		AddStacks(ability, caster, caster, modifier_stacks, 1, true)
	end
	
	-- Calculate and increase duration of Ancient Seal, if present
	if target:HasModifier(seal_modifier) and caster:FindAbilityByName(keys.seal_ability) then
		local seal_ability = caster:FindAbilityByName(keys.seal_ability)
		local seal_duration_increase = seal_ability:GetLevelSpecialValueFor("bolt_duration", seal_ability:GetLevel() - 1)
		local modifier = target:FindModifierByName(seal_modifier)
		modifier:SetDuration(modifier:GetRemainingTime() + seal_duration_increase, true)
	end
end

function ConcussiveShotCast ( keys )
	-- Ability properties	
	local caster = keys.caster	
	local ability = keys.ability
	local ability_level = ability:GetLevel() -1
	local sound_cast = keys.sound_cast
	local particle_projectile = keys.particle_projectile
	local scepter = caster:HasScepter()
	
	-- Parameters
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local search_range = ability:GetLevelSpecialValueFor("search_range", ability_level)
	local target_teams = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)		
	
	-- Play the cast sound
	caster:EmitSound(sound_cast)

	-- Scepter target amount adjustment
	local target_amount = 1
	if scepter then
		target_amount = 2
	end
	
	-- Find nearest heroes as the skill's target
	local targets = FindUnitsInRadius(caster:GetTeam(),
									 caster:GetAbsOrigin(),
									 nil,
									 search_range,
									 target_teams,
									 target_types,
									 target_flags,
									 FIND_CLOSEST,
									 false)

	for _,target in pairs(targets) do
		
		-- Launch projectile on closest enemy
		local concussive_projectile = {
			Target = target,
			Source = caster,
			Ability = ability,
			EffectName = particle_projectile,		
			iMoveSpeed = projectile_speed,
			bDodgeable = true, 
			bVisibleToEnemies = true,
			bReplaceExisting = false,        
			bProvidesVision = true,
			iVisionRadius = vision_radius,
			iVisionTeamNumber = caster:GetTeamNumber()		
		}
		ProjectileManager:CreateTrackingProjectile(concussive_projectile)

		-- Break iteration if enough shots were fired.
		target_amount = target_amount - 1
		if target_amount <= 0 then
			break
		end
	end
end

function ConcussiveShotImpact ( keys )
	-- Ability properties
	local caster = keys.caster
	local target = keys.target
	local target_loc = target:GetAbsOrigin() -- not local for Ghastly Pulse functions		  
	local ability = keys.ability
	local ability_level = ability:GetLevel()-1
	local sound_impact = keys.sound_impact
	local modifier_slow = keys.modifier_slow
	local modifier_ghast_pulse = keys.modifier_ghast_pulse
	local aoe_particle = keys.aoe_particle
	local ghastly_ability = caster:FindAbilityByName(keys.ghastly_ability_name)
	local sound_cast = keys.sound_cast
	local particle_projectile = keys.particle_projectile		
	local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY -- forces casters of Ghastly Pulse to attack their allies
	local target_types = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()
	local seal_modifier = keys.seal_modifier

	-- Ability specials
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)	
	local slow_duration = ability:GetLevelSpecialValueFor("slow_duration", ability_level)
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)	  
	local search_range = ability:GetLevelSpecialValueFor("search_range", ability_level)	  

	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)		  	
	local interval = ability:GetLevelSpecialValueFor("ghastly_pulse_intervals", ability_level)
	local mana_force_spend = ability:GetLevelSpecialValueFor("mana_force_spend", ability_level)
	local ghastly_strikes = 0

	-- Check for Linken's Sphere
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end	 

	-- Applies Ghastly Pulse modifier on caster to make it activate. Deactivate after the duration ends
	ability:ApplyDataDrivenModifier(caster, caster, modifier_ghast_pulse, {})
	Timers:CreateTimer(slow_duration, function()
		caster:RemoveModifierByName(modifier_ghast_pulse)
	end)
	
	-- Create AoE Particle
	local aoe_particle_pfx = ParticleManager:CreateParticle(aoe_particle, PATTACH_CUSTOMORIGIN, caster)	
	ParticleManager:SetParticleControl(aoe_particle_pfx, 0, target:GetAbsOrigin())	
	
	Timers:CreateTimer(slow_duration, function()
		ParticleManager:DestroyParticle(aoe_particle_pfx, false)
	end)

	-- Play impact sound
	caster:EmitSound(sound_impact)	
	
	-- Calculate and increase duration of Ancient Seal, if present
	if target:HasModifier(seal_modifier) and caster:FindAbilityByName(keys.seal_ability) then
		local seal_ability = caster:FindAbilityByName(keys.seal_ability)
		local seal_duration_increase = seal_ability:GetLevelSpecialValueFor("concussive_duration", seal_ability:GetLevel() - 1)
		local modifier = target:FindModifierByName(seal_modifier)
		modifier:SetDuration(modifier:GetRemainingTime() + seal_duration_increase, true)
	end

	-- Apply vision on impact for the duration
	ability:CreateVisibilityNode(target:GetAbsOrigin(), vision_radius, vision_duration)

	-- Find all units in AoE range
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									target_loc,
									nil,
									radius,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
									FIND_ANY_ORDER,
									false)

	-- Deal damage to targets that are not magic immune
	for _,enemy in pairs(enemies) do	
			local damageTable = {victim = enemy,
								 attacker = caster,	
								 damage = damage,
								 damage_type = DAMAGE_TYPE_MAGICAL
								}
		ApplyDamage(damageTable)	

		-- Add a stack of Concussive's slow	to every enemy unit or hero in the AoE
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
	end
	
	Timers:CreateTimer(function()
		-- Find heroes inside the Ghastly Pulse AoE
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
										  target_loc,
										  nil,
										  radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO,
										  DOTA_UNIT_TARGET_FLAG_NONE,
										  FIND_ANY_ORDER,
										  false)
								  
		-- Each enemy found will cast Concussive Shot								  
	    for _,enemy in pairs(enemies) do		
			
			-- Play the cast sound
			enemy:EmitSound(sound_cast)	
			
			-- Find nearest hero as the projectile's target
			local targets = FindUnitsInRadius(enemy:GetTeam(),
											 enemy:GetAbsOrigin(),
											 nil,
											 search_range,
											 target_teams, --forces heroes to attack their allies
											 target_types,
											 target_flags,
											 FIND_CLOSEST,
											 false)										 
			
			for _,target in pairs(targets) do
				-- Prevent illusions shoting projectiles, and hero on himself
				if enemy ~= target and enemy:IsRealHero() then 
				
					-- Launch projectile on closest enemy
					local concussive_projectile
					concussive_projectile = {Target = target,
											Source = enemy,
											Ability = ghastly_ability,
											EffectName = particle_projectile,		
											iMoveSpeed = projectile_speed,
											bDodgeable = true, 
											bVisibleToEnemies = true,
											bReplaceExisting = false,        
											bProvidesVision = true,
											iVisionRadius = vision_radius,
											iVisionTeamNumber = caster:GetTeamNumber()		
											}
			
					ProjectileManager:CreateTrackingProjectile(concussive_projectile)				
					
					-- Reduce enemy mana for using the spell
					enemy:SpendMana(mana_force_spend, ghastly_ability)	
					break -- Break iteration so it will only shot at the closest enemy.						
				end					
			end	
		end
		
		if ghastly_strikes >= slow_duration-1 then
			return nil
		else
			ghastly_strikes = ghastly_strikes + 1
		end
		return interval
	end)
end

function ConcussiveShotGhastlyPulseImpact ( keys )
	-- Ability properties
	local caster = keys.caster
	local target = keys.target		  
	local ability = caster:FindAbilityByName("imba_skywrath_mage_concussive_shot")
	local ability_level = ability:GetLevel()-1
	local sound_impact = keys.sound_impact
	local modifier_slow = keys.modifier_slow	
	local seal_modifier = keys.seal_modifier	
	
	-- Ability specials
	local damage = ability:GetLevelSpecialValueFor("damage_ghastly", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)	
	local slow_duration = ability:GetLevelSpecialValueFor("slow_duration", ability_level)

	-- Check for Linken's Sphere
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end	 

	-- Play impact sound
	caster:EmitSound(sound_impact)	
	
	-- Apply vision on impact for the duration
	ability:CreateVisibilityNode(target:GetAbsOrigin(), vision_radius, vision_duration)
	
	-- Calculate and increase duration of Ancient Seal, if present
	if target:HasModifier(seal_modifier) and caster:FindAbilityByName(keys.seal_ability) then
		local seal_ability = caster:FindAbilityByName(keys.seal_ability)
		local seal_duration_increase = seal_ability:GetLevelSpecialValueFor("concussive_duration", seal_ability:GetLevel() - 1)
		local modifier = target:FindModifierByName(seal_modifier)
		modifier:SetDuration(modifier:GetRemainingTime() + seal_duration_increase, true)
	end
		
	-- Find all units in AoE range
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									target:GetAbsOrigin(),
									nil,
									radius,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
									FIND_ANY_ORDER,
									false)
	
	
	-- Deal damage to targets that are not magic immune
	for _,enemy in pairs(enemies) do	
		
		if not enemy:IsMagicImmune() then
			local damageTable = {victim = enemy,
								 attacker = caster,	
								 damage = damage,
								 damage_type = DAMAGE_TYPE_MAGICAL}
	
		ApplyDamage(damageTable)	
		end
	
		-- Add a stack of Concussive's slow	to every enemy unit or hero in the AoE
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
	end
end

function AncientSeal ( keys )
	-- Ability properties
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel()-1	
	local sound_cast = keys.sound_cast
	local seal_modifier = keys.seal_modifier
	local seal_particle = keys.seal_particle
	local scepter = caster:HasScepter()
	
	-- Check for Linken's Sphere
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end	 
	
	-- Apply or refresh debuff
	ability:ApplyDataDrivenModifier(caster, target, seal_modifier, {})	

	-- Play sound
	target:EmitSound(sound_cast)

	-- Set particles if not already applied on target
	if not target.ancient_seal_particle then
		target.ancient_seal_particle = ParticleManager:CreateParticle(seal_particle, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(target.ancient_seal_particle, 1, target:GetAbsOrigin())
	end

	-- Secondary cast with scepter
	if scepter then
		local radius_scepter = ability:GetLevelSpecialValueFor("radius_scepter", ability_level)
		local nearby_targets = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius_scepter, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		for _,secondary_target in pairs(nearby_targets) do
			if target ~= secondary_target then
				-- Check for Linken's Sphere
				if secondary_target:GetTeam() ~= caster:GetTeam() then
					if secondary_target:TriggerSpellAbsorb(ability) then
						return nil
					end
				end

				-- Apply or refresh debuff
				ability:ApplyDataDrivenModifier(caster, secondary_target, seal_modifier, {})

				-- Set particles if not already applied on secondary target
				if not secondary_target.ancient_seal_particle then
					secondary_target.ancient_seal_particle = ParticleManager:CreateParticle(seal_particle, PATTACH_OVERHEAD_FOLLOW, secondary_target)
					ParticleManager:SetParticleControl(secondary_target.ancient_seal_particle, 1, secondary_target:GetAbsOrigin())
				end
				break
			end
		end
	end
end

function AncientSealParticleUpdate( keys )
	local target = keys.target
	
	if target.ancient_seal_particle then
		ParticleManager:SetParticleControl(target.ancient_seal_particle, 1, target:GetAbsOrigin())
	end
end

function AncientSealRemoveDebuff ( keys )
	local target = keys.target
	
	if target.ancient_seal_particle then
		ParticleManager:DestroyParticle(target.ancient_seal_particle, false)
		ParticleManager:ReleaseParticleIndex(target.ancient_seal_particle)
		target.ancient_seal_particle = nil
	end
end

function MysticFlare ( keys )
	-- Ability properties
	local caster = keys.caster
	local primary_target = keys.target_points[1]	
	local ability = keys.ability
	local ability_level = ability:GetLevel()
	local sound_cast = keys.sound_cast	
	local sound_target = keys.sound_target
	local core_particle = keys.core_particle
	local modifier_mystic_flare = keys.modifier_mystic_flare
	local explosion_particle = keys.explosion_particle
	local explosion_shockwave_particle = keys.explosion_shockwave_particle	
	local seal_modifier = keys.seal_modifier
	local scepter = HasScepter(caster)
	
	-- Ability specials
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)		
	local total_damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local interval = ability:GetLevelSpecialValueFor("interval", ability_level)
	local explosion_delay = ability:GetLevelSpecialValueFor("explosion_delay", ability_level)
	local explosion_damage = ability:GetLevelSpecialValueFor("explosion_damage", ability_level)
	local explosion_radius = ability:GetLevelSpecialValueFor("explosion_radius", ability_level)
	local explosion_radius_increase = ability:GetLevelSpecialValueFor("explosion_radius_increase", ability_level)
	local explosion_damage_increase = ability:GetLevelSpecialValueFor("explosion_damage_increase", ability_level)

	-- Setting hit intervals and max hits variables
	local hit_intervals = 0
	local max_hits = math.floor(duration/interval)

	-- Scepter target adjustment
	local target_points = {}
	target_points[1] = primary_target
	if scepter then
		local radius_scepter = ability:GetLevelSpecialValueFor("range_scepter", ability_level)
		local nearby_targets = FindUnitsInRadius(caster:GetTeamNumber(), primary_target, nil, radius_scepter, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		for _,secondary_target in pairs(nearby_targets) do
			if (secondary_target:GetAbsOrigin() - primary_target):Length2D() > radius then
				-- Add this location as a secondary target
				target_points[2] = secondary_target:GetAbsOrigin()
				max_hits = max_hits * 2
				break
			end
		end
	end
	
	-- Calculate final explosion radius based on Arcane Magic stacks
	if caster:HasModifier("modifier_imba_arcane_int_stack") then
		local modifier_arcane_magic_stacks = caster:FindModifierByName("modifier_imba_arcane_int_stack"):GetStackCount()
		explosion_radius = explosion_radius + explosion_radius_increase * modifier_arcane_magic_stacks 
		explosion_damage = explosion_damage + explosion_damage_increase * modifier_arcane_magic_stacks
	end
	
	for _,target in pairs(target_points) do
		
		-- Create dummy unit in point target and add it to the dummies table
		local dummy = CreateUnitByName("npc_dummy_unit", target, false, caster, caster, caster:GetTeamNumber())

		-- Play cast sound
		dummy:EmitSound(sound_cast)	
		
		-- Assign mystic flare modifier to dummy
		ability:ApplyDataDrivenModifier(caster, dummy, modifier_mystic_flare, {})						
		
		-- Add particles for the duration of the spell
		local mystic_flare_particle = ParticleManager:CreateParticle(core_particle, PATTACH_ABSORIGIN, dummy)		 
		ParticleManager:SetParticleControl(mystic_flare_particle, 1, Vector(radius, radius , 0))	 		
		 
		 -- Destroy particles when spell ends
		Timers:CreateTimer(duration, function()
			ParticleManager:DestroyParticle(mystic_flare_particle, false)	  
		  
			-- Create explosion particle
			local explosion_particle = ParticleManager:CreateParticle(explosion_particle, PATTACH_ABSORIGIN, dummy)
			ParticleManager:SetParticleControl(explosion_particle, 1, Vector(explosion_radius, 0, 0)) 
		  
			-- Destroy explosion particle, calculate damage
			Timers:CreateTimer(explosion_delay, function()
				ParticleManager:DestroyParticle(explosion_particle, false)

					-- Find all units found on explosion radius
					local explosion_enemies = FindUnitsInRadius(caster:GetTeamNumber(),
																dummy:GetAbsOrigin(),
																nil,
																explosion_radius,
																DOTA_UNIT_TARGET_TEAM_ENEMY,
																DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
																DOTA_UNIT_TARGET_FLAG_NONE,
																FIND_ANY_ORDER,
																false)
						
				for _, enemy in pairs (explosion_enemies) do
					-- Deal damage to target if it's not magic immune
					if not enemy:IsMagicImmune() then	
						local damageTable = 
						{
							victim = enemy,
							attacker = caster,
							damage = explosion_damage,
							damage_type = DAMAGE_TYPE_MAGICAL		
						}
						ApplyDamage(damageTable)
					end
					
					-- Calculate and increase duration of Ancient Seal, if present
					if enemy:HasModifier(seal_modifier) and caster:FindAbilityByName(keys.seal_ability) then
						local seal_ability = caster:FindAbilityByName(keys.seal_ability)
						local seal_duration_increase = seal_ability:GetLevelSpecialValueFor("mystic_duration", seal_ability:GetLevel() - 1)
						local modifier = enemy:FindModifierByName(seal_modifier)
						modifier:SetDuration(modifier:GetRemainingTime() + seal_duration_increase, true)
					end
				end
				
				-- Wait a second before killing the dummy for particle effects
				Timers:CreateTimer(1, function()			
				dummy:Destroy()
				end)
			end)		
		end)

		-- Calculate damage per tick
		local damage_per_tick = total_damage / max_hits		
			
		Timers:CreateTimer(function()

			-- Play hit sound		
			dummy:EmitSound(sound_target)			
			
			-- Find enemies in the AoE area
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
												  dummy:GetAbsOrigin(),
												  nil,
												  radius,
												  DOTA_UNIT_TARGET_TEAM_ENEMY,
												  DOTA_UNIT_TARGET_HERO,
												  DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
												  FIND_ANY_ORDER,
												  false)
				
			-- Set amount of units found and appropriate damage
			local damage_per_hero = 0
			if #enemies > 0 then
				damage_per_hero = math.floor(damage_per_tick / #enemies)
			end
			
			for _,enemy in pairs (enemies) do
				
				-- Play hit sound
				enemy:EmitSound(sound_target)
				
				-- Calculate and increase duration of Ancient Seal, if present
				if enemy:HasModifier(seal_modifier) and caster:FindAbilityByName(keys.seal_ability) then
					local seal_ability = caster:FindAbilityByName(keys.seal_ability)
					local seal_duration_increase = seal_ability:GetLevelSpecialValueFor("mystic_duration", seal_ability:GetLevel() - 1)
					local modifier = enemy:FindModifierByName(seal_modifier)
					modifier:SetDuration(modifier:GetRemainingTime() + seal_duration_increase, true)
				end
				
				
				-- Deal damage to target if it's not magic immune
				if not enemy:IsMagicImmune() then	
					local damageTable = 
					{
						victim = enemy,
						attacker = caster,
						damage = damage_per_hero,
						damage_type = DAMAGE_TYPE_MAGICAL		
					}
					
					ApplyDamage(damageTable)	
				end
			end

			if hit_intervals >= max_hits then							
				return nil
			else
				hit_intervals = hit_intervals + 1
				return interval
			end
		end)
	end
end