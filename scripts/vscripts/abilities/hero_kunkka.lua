--[[ Author: Hewdraw ]]

function torrent_bubble_allies( keys )
	local caster = keys.caster
	
	local allHeroes = HeroList:GetAllHeroes()
	local delay = keys.ability:GetLevelSpecialValueFor( "delay", keys.ability:GetLevel() - 1 )
	local particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_bubbles.vpcf"
	local target = keys.target_points[1]
	
	for k, v in pairs( allHeroes ) do
		if v:GetPlayerID() and v:GetTeam() == caster:GetTeam() then
			local fxIndex = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_ABSORIGIN, v, PlayerResource:GetPlayer( v:GetPlayerID() ) )
			ParticleManager:SetParticleControl( fxIndex, 0, target )
			
			EmitSoundOnClient( "Ability.pre.Torrent", PlayerResource:GetPlayer( v:GetPlayerID() ) )
			
			-- Destroy particle after delay
			Timers:CreateTimer( delay, function()
					ParticleManager:DestroyParticle( fxIndex, false )
					return nil
				end
			)
		end
	end
end

function torrent_emit_sound( keys )
	local dummy = CreateUnitByName( "npc_dummy_blank", keys.target_points[1], false, keys.caster, keys.caster, keys.caster:GetTeamNumber() )
	EmitSoundOn( "Ability.Torrent", dummy )
	dummy:ForceKill( true )
end

function torrent_post_vision( keys )
	local ability = keys.ability
	local target = keys.target_points[1]
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "vision_duration", ability:GetLevel() - 1 )
	
	ability:CreateVisibilityNode( target, radius, duration )
end

function torrent( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target_points[1]
	local ability_level = ability:GetLevel() -1
	local radius = ability:GetLevelSpecialValueFor( "radius", ability_level )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability_level )
	local duration = ability:GetLevelSpecialValueFor( "stun_duration", ability_level )
	local tick_count = ability:GetLevelSpecialValueFor( "tick_count", ability_level )
	local tick_interval = duration / tick_count
	local particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"

	if caster:HasModifier("modifier_tidebringer_high_tide") then
		radius = radius + 100
		damage = damage + 100
	end

	local damage_tick = damage / (2 * tick_count)
	local tick_amount = 0



	if not caster:HasModifier("modifier_tidebringer_wave_break") then
		Timers:CreateTimer( 1.6, function()
			local enemies = FindUnitsInRadius(caster.GetTeam(caster), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			local torrent_particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(torrent_particle, 0, target)
			for _,enemy in pairs(enemies) do
				ApplyDamage({victim = enemy, attacker = caster, damage = damage / 2, damage_type = DAMAGE_TYPE_MAGICAL})
				if caster:HasModifier("modifier_tidebringer_tsunami") then
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_torrent_knockup_tsunami", {})
				else
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_torrent_knockup", {})
				end
				Timers:CreateTimer( 0, function()
					if tick_amount < tick_count then
						ApplyDamage({victim = enemy, attacker = caster, damage = damage_tick, damage_type = DAMAGE_TYPE_MAGICAL})
						tick_amount = tick_amount + 1
						return tick_interval
					else
						return nil
					end
				end)
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_torrent_slow_debuff", {})
			end
			return nil
		end)
	else
		local enemies = FindUnitsInRadius(caster.GetTeam(caster), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local torrent_particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(torrent_particle, 0, target)
		for _,enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = damage / 2, damage_type = DAMAGE_TYPE_MAGICAL})
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_torrent_knockup", {})
			Timers:CreateTimer( 0, function()
				if tick_amount < tick_count then
					ApplyDamage({victim = enemy, attacker = caster, damage = damage_tick, damage_type = DAMAGE_TYPE_MAGICAL})	
					tick_amount = tick_amount + 1
					return tick_interval
				else
					return nil
				end
			end)
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_torrent_slow_debuff", {})
		end
		return nil
	end
end

function tidebringer_cooldown( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "modifier_tidebringer"

	if ability:GetCooldownTimeRemaining() == 0 then
		if not caster:HasModifier("modifier_tidebringer_low_tide") then
			if not caster:HasModifier("modifier_tidebringer_high_tide") then
				if not caster:HasModifier("modifier_tidebringer_wave_break") then
					if not caster:HasModifier("modifier_tidebringer_tsunami") then
						ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
					end
				end
			end
		end
	end
end

function tidebringer_set_cooldown( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local cooldown = ability:GetCooldown( ability:GetLevel() - 1)

	-- Remove cooldown
	caster:RemoveModifierByName( "modifier_tidebringer_low_tide" )
	caster:RemoveModifierByName( "modifier_tidebringer_high_tide" )
	caster:RemoveModifierByName( "modifier_tidebringer_tsunami" )
	ability:StartCooldown( cooldown )
end

function tidebringer_tsunami( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )

	local enemies = FindUnitsInRadius(caster.GetTeam(caster), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _,enemy in pairs(enemies) do
		local torrent_particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(torrent_particle, 0, enemy:GetAbsOrigin())
		ability:ApplyDataDrivenModifier(caster, enemy, "modifier_tidebringer_knockup", {})
	end
end

function x_marks_the_spot_init( keys )
  -- Variables
	local caster = keys.caster
	local target = keys.target
	local targetLoc = keys.target:GetAbsOrigin()
	local x_marks_return_name = "imba_kunkka_return"
	
	-- Set variables
	caster.x_marks_target = target
	caster.x_marks_origin = targetLoc
	
	-- Swap ability
	caster:SwapAbilities( keys.ability:GetAbilityName(), x_marks_return_name, false, true )
end

function x_marks_the_spot_force_return( keys )
	local caster = keys.caster
	local modifierName = "modifier_x_marks_the_spot_debuff"
	caster.x_marks_target:RemoveModifierByName( modifierName )
	Timers:CreateTimer(0.1, function()
		caster.x_marks_target:RemoveModifierByName( "modifier_x_marks_the_spot_debuff_forced" )
		return nil
	end )
end

function x_marks_the_spot_return( keys )
  -- Variables
	local caster = keys.caster
	local x_marks = "imba_kunkka_x_marks_the_spot"
	local x_marks_return = "imba_kunkka_return"
	local modifierName = "modifier_x_marks_the_spot_debuff"
	
	-- Check if there is target unit
	if caster.x_marks_target ~= nil and caster.x_marks_origin ~= nil then
		Timers:CreateTimer(0.2, function()
			FindClearSpaceForUnit( caster.x_marks_target, caster.x_marks_origin, true )
			caster.x_marks_target = nil
			caster.x_marks_origin = nil
			return nil
		end )
		
	end
	
	-- Swap ability
	caster:SwapAbilities( x_marks, x_marks_return, true, false )
	x_marks_start_cooldown( keys )
end

function x_marks_start_cooldown( keys )
  -- Name of both abilities
	local x_marks = "imba_kunkka_x_marks_the_spot"
	local x_marks_return = "imba_kunkka_return"

  -- Loop to reset cooldown
	for i = 0, keys.caster:GetAbilityCount() - 1 do
		local currentAbility = keys.caster:GetAbilityByIndex( i )
		if currentAbility ~= nil and ( currentAbility:GetAbilityName() == x_marks or currentAbility:GetAbilityName() == x_marks_return ) then
			currentAbility:EndCooldown()
			currentAbility:StartCooldown( currentAbility:GetCooldown( currentAbility:GetLevel() - 1 ) )
		end
	end
end

function x_marks_the_spot_level_up( keys )
  -- Variable for sub ability
	local x_marks_return_name = "imba_kunkka_return"

  -- loop to find the ability
	for i = 0, keys.caster:GetAbilityCount() do
		local currentAbility = keys.caster:GetAbilityByIndex( i )
		if currentAbility ~= nil and currentAbility:GetAbilityName() == x_marks_return_name then
			if currentAbility:GetLevel() ~= keys.ability:GetLevel() then
				currentAbility:SetLevel( keys.ability:GetLevel() )
			end
			break
		end
	end
end

function LevelUpAbility( keys )
	local caster = keys.caster
	local this_ability = keys.ability		
	local this_abilityName = this_ability:GetAbilityName()
	local this_abilityLevel = this_ability:GetLevel()

	-- The ability to level up
	local ability_name = keys.ability_name
	local ability_handle = caster:FindAbilityByName(ability_name)	
	local ability_level = ability_handle:GetLevel()

	-- Check to not enter a level up loop
	if ability_level ~= this_abilityLevel then
		ability_handle:SetLevel(this_abilityLevel)
	end
end

function ForcedReturn( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local radius = ability:GetLevelSpecialValueFor( "return_range" , ability:GetLevel() - 1 )

	if not caster:HasModifier("modifier_x_marks_the_spot_debuff") then
		if caster.x_marks_origin ~= nil then
			local enemies = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
			for _,enemy in pairs( enemies ) do
				FindClearSpaceForUnit(enemy, caster.x_marks_origin, true)
			end
		end
	end
end

function ghostship_mark_allies( caster, ability, target )
	local allHeroes = HeroList:GetAllHeroes()
	local delay = ability:GetLevelSpecialValueFor( "tooltip_delay", ability:GetLevel() - 1 )
	local particleName = "particles/units/heroes/hero_kunkka/kunkka_ghostship_marker.vpcf"
	
	for k, v in pairs( allHeroes ) do
		if v:GetPlayerID() and v:GetTeam() == caster:GetTeam() then
			local fxIndex = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_ABSORIGIN, v, PlayerResource:GetPlayer( v:GetPlayerID() ) )
			ParticleManager:SetParticleControl( fxIndex, 0, target )
			
			EmitSoundOnClient( "Ability.pre.Torrent", PlayerResource:GetPlayer( v:GetPlayerID() ) )
			
			-- Destroy particle after delay
			Timers:CreateTimer( delay, function()
					ParticleManager:DestroyParticle( fxIndex, false )
					return nil
				end
			)
		end
	end
end

function ghostship_start_traverse( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local casterPoint = caster:GetAbsOrigin()
	local targetPoint = keys.target_points[1]
	local spawnDistance = ability:GetLevelSpecialValueFor( "ghostship_distance", ability:GetLevel() - 1 )
	local spawnDistanceScepter = ability:GetLevelSpecialValueFor( "ghostship_distance_scepter", ability:GetLevel() - 1 )
	local projectileSpeed = ability:GetLevelSpecialValueFor( "ghostship_speed", ability:GetLevel() - 1 )
	local projectileSpeedScepter = ability:GetLevelSpecialValueFor( "ghostship_speed_scepter", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "ghostship_width", ability:GetLevel() - 1 )
	local stunDelay = ability:GetLevelSpecialValueFor( "tooltip_delay", ability:GetLevel() - 1 )
	local stunDuration = ability:GetLevelSpecialValueFor( "stun_duration", ability:GetLevel() - 1 )
	local damage = ability:GetAbilityDamage()
	local damageType = ability:GetAbilityDamageType()
	local targetBuffTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local targetImpactTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL
	local targetFlag = DOTA_UNIT_TARGET_FLAG_NONE
	local scepter = caster:HasScepter()
	caster.target_point = targetPoint
	
	-- Get necessary vectors
	local forwardVec = targetPoint - casterPoint
		forwardVec = forwardVec:Normalized()
	local backwardVec = casterPoint - targetPoint
		backwardVec = backwardVec:Normalized()
	if scepter == true then
		spawnDistance = spawnDistanceScepter
		projectileSpeed = projectileSpeedScepter
	end
	local spawnPoint = casterPoint + ( spawnDistance * backwardVec )
	local impactPoint = casterPoint + ( spawnDistance * forwardVec )
	local velocityVec = Vector( forwardVec.x, forwardVec.y, 0 )
	
	-- Show visual effect
	ghostship_mark_allies( caster, ability, impactPoint )
	
	-- Spawn projectiles
	local projectileTable = {
		Ability = ability,
		EffectName = "particles/units/heroes/hero_kunkka/kunkka_ghost_ship.vpcf",
		vSpawnOrigin = spawnPoint,
		fDistance = spawnDistance * 2,
		fStartRadius = radius,
		fEndRadius = radius,
		fExpireTime = GameRules:GetGameTime() + 5,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		bProvidesVision = false,
		iUnitTargetTeam = targetBuffTeam + targetImpactTeam,
		iUnitTargetType = targetType,
		vVelocity = velocityVec * projectileSpeed
	}
	ProjectileManager:CreateLinearProjectile( projectileTable )
	
	-- Create timer for crashing
	Timers:CreateTimer( stunDelay, function()
			local units = FindUnitsInRadius(
				caster:GetTeamNumber(), impactPoint, caster, radius, targetImpactTeam,
				targetType, targetFlag, FIND_ANY_ORDER, false
			)
			
			-- Fire sound event
			local dummy = CreateUnitByName( "npc_dummy_blank", impactPoint, false, caster, caster, caster:GetTeamNumber() )
			StartSoundEvent( "Ability.Ghostship.crash", dummy )
			dummy:ForceKill( true )
			
			-- Stun and damage enemies
			for k, v in pairs( units ) do
				if not v:IsMagicImmune() then
					local damageTable = {
						victim = v,
						attacker = caster,
						damage = damage,
						damage_type = damageType
					}
					ApplyDamage( damageTable )
				end
				
				v:AddNewModifier( caster, nil, "modifier_stunned", { duration = stunDuration } )
			end
			
			return nil	-- Delete timer
		end
	)
end

function ghostship_register_damage( keys )
	local target = keys.unit
	local damageTaken = keys.DamageTaken
	if not target.ghostship_damage then
		target.ghostship_damage = 0
	end
	
	target.ghostship_damage = target.ghostship_damage + damageTaken
end

function ghostship_spread_damage( keys )
	-- Init in case never take any damage
	if not keys.target.ghostship_damage then
		keys.target.ghostship_damage = 0
	end

	-- Variables
	local target = keys.target
	local ability = keys.ability
	local damageDuration = ability:GetLevelSpecialValueFor( "damage_duration", ability:GetLevel() - 1 )
	local damageInterval = ability:GetLevelSpecialValueFor( "damage_interval", ability:GetLevel() - 1 )
	local damageCurrentTime = 0.0
	local damagePerInterval = target.ghostship_damage * ( damageInterval / damageDuration )
	local minimumHealth = 1

	-- Overtime debuff
	Timers:CreateTimer( damageInterval, function()
			-- HP Removal
			local targetHealth = target:GetHealth()
			if targetHealth - damagePerInterval <= minimumHealth then
				target:SetHealth( minimumHealth )
			else
				target:SetHealth( targetHealth - damagePerInterval )
			end
			
			-- Update timer
			damageCurrentTime = damageCurrentTime + damageInterval
			
			-- Check closing condition
			if damageCurrentTime >= damageDuration then
				return nil
			else
				return damageInterval
			end
		end
	)
end

function scepterCheck( keys )
	local caster = keys.caster
	local ability = keys.ability
	local scepter = caster:HasScepter()
	local unit = keys.target

	if scepter == true then
		unit:RemoveModifierByName("modifier_ghostship_rum")
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_ghostship_rum_scepter",{})
	end
end

function OnABoat( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local targetPoint = caster.target_point
	local casterPoint = caster:GetAbsOrigin()
	local spawnDistance = ability:GetLevelSpecialValueFor( "ghostship_distance", ability:GetLevel() - 1 )
	local spawnDistanceScepter = ability:GetLevelSpecialValueFor( "ghostship_distance_scepter", ability:GetLevel() - 1 )
	local projectileSpeed = ability:GetLevelSpecialValueFor( "ghostship_speed", ability:GetLevel() - 1 )
	local projectileSpeedScepter = ability:GetLevelSpecialValueFor( "ghostship_speed_scepter", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "ghostship_width", ability:GetLevel() - 1 )
	local stunDelay = ability:GetLevelSpecialValueFor( "tooltip_delay", ability:GetLevel() - 1 )
	local stunDuration = ability:GetLevelSpecialValueFor( "stun_duration", ability:GetLevel() - 1 )
	local scepter = caster:HasScepter()
	
	-- Get necessary vectors
	local forwardVec = targetPoint - casterPoint
		forwardVec = forwardVec:Normalized()
	local backwardVec = casterPoint - targetPoint
		backwardVec = backwardVec:Normalized()
	if scepter == true then
		spawnDistance = spawnDistanceScepter
		projectileSpeed = projectileSpeedScepter
	end
	local spawnPoint = casterPoint + ( spawnDistance * backwardVec )
	local impactPoint = casterPoint + ( spawnDistance * forwardVec )
	local velocityVec = Vector( forwardVec.x, forwardVec.y, 0 )

	local vCaster = spawnPoint
	local vTarget = target:GetAbsOrigin()
	local distance = spawnDistance * 2

	-- calculates knockback distance
	local len = distance - ( vTarget - vCaster ):Length2D()
	local duration = len / projectileSpeed

	-- knockbacks using modifier_knockback
	local knockbackModifierTable =
	{
		should_stun = 1,
		knockback_duration = duration,
		duration = duration,
		knockback_distance = len,
		knockback_height = 0,
		center_x = spawnPoint.x,
		center_y = spawnPoint.y,
		center_z = spawnPoint.z
	}
	if target:GetTeam() ~= caster:GetTeam() then
		target:AddNewModifier( caster, nil, "modifier_knockback", knockbackModifierTable )
		ApplyDamage({victim = target, attacker = caster, damage = 50, damage_type = DAMAGE_TYPE_PURE})
	end
end