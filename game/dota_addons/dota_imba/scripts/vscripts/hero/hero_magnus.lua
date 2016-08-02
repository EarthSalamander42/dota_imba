--[[	Author: Firetoad
		Date: 21.11.2015	]]

function Shockwave( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_projectile = keys.particle_projectile
	
	-- Parameters
	local shock_speed = ability:GetLevelSpecialValueFor("shock_speed", ability_level)
	local shock_width = ability:GetLevelSpecialValueFor("shock_width", ability_level)
	local shock_distance = ability:GetLevelSpecialValueFor("shock_distance", ability_level) + GetCastRangeIncrease(caster)

	-- Clear targets hit table
	caster.shockwave_targets_hit = nil
	caster.shockwave_targets_hit = {}

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Launch projectile
	local shockwave_projectile = {
		Ability				= ability,
		EffectName			= particle_projectile,
		vSpawnOrigin		= caster:GetAbsOrigin(),
		fDistance			= shock_distance,
		fStartRadius		= shock_width,
		fEndRadius			= shock_width,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
	--	iUnitTargetFlags	= ,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
	--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= (target - caster:GetAbsOrigin()):Normalized() * shock_speed,
		bProvidesVision		= false,
	--	iVisionRadius		= ,
	--	iVisionTeamNumber	= caster:GetTeamNumber(),
	}

	ProjectileManager:CreateLinearProjectile(shockwave_projectile)
end

function ShockwaveHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit
	local particle_projectile = keys.particle_projectile
	local particle_hit = keys.particle_hit
	local scepter = HasScepter(caster)
	
	-- Parameters
	local shock_speed = ability:GetLevelSpecialValueFor("shock_speed", ability_level)
	local shock_width = ability:GetLevelSpecialValueFor("shock_width", ability_level)
	local shock_distance = ability:GetLevelSpecialValueFor("shock_distance", ability_level)
	local shock_damage = ability:GetLevelSpecialValueFor("shock_damage", ability_level)
	local secondary_damage = ability:GetLevelSpecialValueFor("secondary_damage", ability_level)
	local secondary_angle = ability:GetLevelSpecialValueFor("secondary_angle", ability_level)
	local max_secondary = ability:GetLevelSpecialValueFor("max_secondary", ability_level)
	local has_been_hit = false

	-- Play impact particle
	local hit_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(hit_pfx, 0, target:GetAbsOrigin())

	-- Check if this unit has already been hit during this cast of shockwave
	for _,enemy_hit in pairs(caster.shockwave_targets_hit) do
		if enemy_hit == target then
			has_been_hit = true
		end
	end

	-- If the unit has already been hit, or maximum split count has been reached, deal only secondary damage
	if has_been_hit or #caster.shockwave_targets_hit >= max_secondary then
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = secondary_damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Else, deal primary damage, mark the target as hit, and create extra shockwaves if appropriate
	else

		-- Play impact sound
		target:EmitSound(sound_hit)
		
		-- Mark target as hit
		caster.shockwave_targets_hit[#caster.shockwave_targets_hit + 1] = target

		-- Deal damage
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = shock_damage, damage_type = DAMAGE_TYPE_MAGICAL})

		-- If the target is magnetized, launch bonus shockwaves
		if target:IsRealHero() then

			-- Geometry
			local target_pos = target:GetAbsOrigin()
			local direction = (target_pos - caster:GetAbsOrigin()):Normalized()
			local bonus_target_1 = RotatePosition(target_pos, QAngle(0, secondary_angle, 0), target_pos + direction * 100)
			local bonus_target_2 = RotatePosition(target_pos, QAngle(0, (-1) * secondary_angle, 0), target_pos + direction * 100)

			-- First shockwave
			local shockwave_projectile = {
				Ability				= ability,
				EffectName			= particle_projectile,
				vSpawnOrigin		= target:GetAbsOrigin(),
				fDistance			= shock_distance,
				fStartRadius		= shock_width,
				fEndRadius			= shock_width,
				Source				= caster,
				bHasFrontalCone		= false,
				bReplaceExisting	= false,
				iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			--	iUnitTargetFlags	= ,
				iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			--	fExpireTime			= ,
				bDeleteOnHit		= false,
				vVelocity			= (bonus_target_1 - target_pos):Normalized() * shock_speed,
				bProvidesVision		= false,
			--	iVisionRadius		= ,
			--	iVisionTeamNumber	= caster:GetTeamNumber(),
			}

			ProjectileManager:CreateLinearProjectile(shockwave_projectile)

			-- Second shockwave
			shockwave_projectile = {
				Ability				= ability,
				EffectName			= particle_projectile,
				vSpawnOrigin		= target:GetAbsOrigin(),
				fDistance			= shock_distance,
				fStartRadius		= shock_width,
				fEndRadius			= shock_width,
				Source				= caster,
				bHasFrontalCone		= false,
				bReplaceExisting	= false,
				iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			--	iUnitTargetFlags	= ,
				iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			--	fExpireTime			= ,
				bDeleteOnHit		= false,
				vVelocity			= (bonus_target_2 - target_pos):Normalized() * shock_speed,
				bProvidesVision		= false,
			--	iVisionRadius		= ,
			--	iVisionTeamNumber	= caster:GetTeamNumber(),
			}

			ProjectileManager:CreateLinearProjectile(shockwave_projectile)

			-- If the caster has a scepter, create two additional shockwaves
			if scepter then
				local bonus_target_3 = RotatePosition(target_pos, QAngle(0, 2 * secondary_angle, 0), target_pos + direction * 100)
				local bonus_target_4 = RotatePosition(target_pos, QAngle(0, (-2) * secondary_angle, 0), target_pos + direction * 100)

				-- Third shockwave
				shockwave_projectile = {
					Ability				= ability,
					EffectName			= particle_projectile,
					vSpawnOrigin		= target:GetAbsOrigin(),
					fDistance			= shock_distance,
					fStartRadius		= shock_width,
					fEndRadius			= shock_width,
					Source				= caster,
					bHasFrontalCone		= false,
					bReplaceExisting	= false,
					iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
				--	iUnitTargetFlags	= ,
					iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				--	fExpireTime			= ,
					bDeleteOnHit		= false,
					vVelocity			= (bonus_target_3 - target_pos):Normalized() * shock_speed,
					bProvidesVision		= false,
				--	iVisionRadius		= ,
				--	iVisionTeamNumber	= caster:GetTeamNumber(),
				}

				ProjectileManager:CreateLinearProjectile(shockwave_projectile)

				-- Fourth shockwave
				shockwave_projectile = {
					Ability				= ability,
					EffectName			= particle_projectile,
					vSpawnOrigin		= target:GetAbsOrigin(),
					fDistance			= shock_distance,
					fStartRadius		= shock_width,
					fEndRadius			= shock_width,
					Source				= caster,
					bHasFrontalCone		= false,
					bReplaceExisting	= false,
					iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
				--	iUnitTargetFlags	= ,
					iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				--	fExpireTime			= ,
					bDeleteOnHit		= false,
					vVelocity			= (bonus_target_4 - target_pos):Normalized() * shock_speed,
					bProvidesVision		= false,
				--	iVisionRadius		= ,
				--	iVisionTeamNumber	= caster:GetTeamNumber(),
				}

				ProjectileManager:CreateLinearProjectile(shockwave_projectile)
			end
		end
	end
end

function EmpowerAura( keys )
	local caster = keys.caster
	local scepter = HasScepter(caster)

	-- If the caster has no scepter, do nothing
	if not scepter then
		return nil
	end

	-- Parameters
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_empower = keys.modifier_empower
	local sound_target = keys.sound_target
	local radius = ability:GetLevelSpecialValueFor("radius_scepter", ability_level)
	local empower_duration = ability:GetLevelSpecialValueFor("supercharge_duration", ability_level)

	-- Iterate through nearby allies
	local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,target in pairs(nearby_allies) do
		
		-- Play sound if the target is gaining the buff now
		if not target:HasModifier(modifier_empower) then
			target:EmitSound(sound_target)
		end

		-- Refresh the Empower buff on anything but the caster
		if target ~= caster then
			ability:ApplyDataDrivenModifier(caster, target, modifier_empower, {duration = empower_duration})
		end
	end
end

function Empower( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_target = keys.sound_target
	local modifier_empower = keys.modifier_empower
	local modifier_supercharged = keys.modifier_supercharged

	-- Parameters
	local empower_duration = ability:GetLevelSpecialValueFor("empower_duration", ability_level)
	local supercharge_duration = ability:GetLevelSpecialValueFor("supercharge_duration", ability_level)

	-- If cast on a target with Empower, supercharge them
	if target:HasModifier(modifier_empower) then
		ability:ApplyDataDrivenModifier(caster, target, modifier_supercharged, {duration = supercharge_duration})
	end
	
	-- Play target sound
	target:EmitSound(sound_target)

	-- Apply limited-duration empower modifier if the target doesn't have the empower ability
	if not target:FindAbilityByName("imba_magnus_empower") then
		ability:ApplyDataDrivenModifier(caster, target, modifier_empower, {duration = empower_duration})
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier_empower, {})
	end
end

function EmpowerHit( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local damage = keys.damage
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_supercharged = keys.modifier_supercharged
	local particle_cleave = keys.particle_cleave
	local particle_red_cleave = keys.particle_red_cleave

	-- If the target is a building, do nothing
	if target:IsBuilding() then
		return nil
	end

	-- Parameters
	local cleave_damage_pct = ability:GetLevelSpecialValueFor("cleave_damage_pct", ability_level)
	local cleave_radius = ability:GetLevelSpecialValueFor("cleave_radius", ability_level)

	-- Draw particle
	local cleave_pfx
	if attacker:HasModifier(modifier_supercharged) then
		cleave_pfx = ParticleManager:CreateParticle(particle_red_cleave, PATTACH_ABSORIGIN, target)
	else
		cleave_pfx = ParticleManager:CreateParticle(particle_cleave, PATTACH_ABSORIGIN, target)
	end
	ParticleManager:SetParticleControl(cleave_pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(cleave_pfx, 1, Vector(cleave_radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(cleave_pfx)

	-- If this is an illusion, only play the particle
	if not attacker:IsRealHero() then
		return nil
	end

	-- Calculate damage to deal
	damage = damage * cleave_damage_pct * 0.01

	-- Find enemies to damage
	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, cleave_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	
	-- Deal damage
	for _,enemy in pairs(enemies) do
		if enemy ~= target and not enemy:IsAttackImmune() then
			ApplyDamage({attacker = attacker, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})
		end
	end
end

function Magnetize( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local modifier_debuff = keys.modifier_debuff

	-- If the ability was unlearned or broken, do nothing
	if ability:GetLevel() == 0 or caster.break_duration_left then
		return nil
	end
	
	-- If the target is an enemy hero, apply the Magnetize debuff
	if target:IsRealHero() and target:GetTeam() ~= caster:GetTeam() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})
	end
end

function MagnetizeThink( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_magnetize = keys.modifier_magnetize
	local modifier_slow = keys.modifier_slow
	
	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local target_pos = target:GetAbsOrigin()

	-- Check for nearby magnetized heroes
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	-- Count nearby magnetized heroes
	local magnetized_count = 0
	for _,hero in pairs(heroes) do

		-- If this hero has the magnetize debuff and is not the target, increase the magnetized hero count
		if hero ~= target and ( hero:HasModifier(modifier_magnetize) or hero == caster ) then
			magnetized_count = magnetized_count + 1
		end
	end

	-- Apply stacks of slow according to the number of nearby magnetized heroes
	if magnetized_count > 0 then
		ability:ApplyDataDrivenModifier(caster, target, modifier_slow, {})
		target:SetModifierStackCount(modifier_slow, nil, magnetized_count)
	end
end

function ReversePolarityAnim( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_anim = keys.sound_anim
	local particle_anim = keys.particle_anim
	
	-- Parameters
	local normal_pull = ability:GetLevelSpecialValueFor("normal_pull", ability_level)

	-- Play animation sound
	caster:EmitSound(sound_anim)

	-- Play animation particle
	local animation_pfx = ParticleManager:CreateParticle(particle_anim, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(animation_pfx, 1, Vector(normal_pull, 0, 0))
	ParticleManager:SetParticleControl(animation_pfx, 2, Vector(0.3, 0, 0))
	ParticleManager:SetParticleControl(animation_pfx, 3, caster:GetAbsOrigin())
end


function ReversePolarity( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_stun = keys.sound_stun
	local particle_pull = keys.particle_pull
	local modifier_magnet = keys.modifier_magnet
	local modifier_slow = keys.modifier_slow

	-- Parameters
	local normal_pull = ability:GetLevelSpecialValueFor("normal_pull", ability_level)
	local magnetize_pull = ability:GetLevelSpecialValueFor("magnetize_pull", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local tree_radius = ability:GetLevelSpecialValueFor("tree_radius", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local caster_loc = caster:GetAbsOrigin()

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Find enemy heroes
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		
		-- Calculate pull and distance to the caster
		local enemy_loc = enemy:GetAbsOrigin()
		local distance = (caster_loc - enemy_loc):Length2D()
		local direction = (caster_loc - enemy_loc):Normalized()
		local enemy_pull = normal_pull

		-- Increase pull radius if enemy is magnetized
		if enemy:HasModifier(modifier_magnet) then
			enemy_pull = magnetize_pull
		end

		-- Play hit sound
		enemy:EmitSound(sound_stun)

		-- Play pull particle
		local pull_pfx = ParticleManager:CreateParticle(particle_pull, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pull_pfx, 0, enemy_loc)
		ParticleManager:SetParticleControl(pull_pfx, 1, caster:GetAbsOrigin())

		-- Apply slow modifier
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})

		-- If the enemy is too far away, pull it and apply the slow + a normalized stun
		if distance > enemy_pull then
			
			-- Damage and pull the enemy
			FindClearSpaceForUnit(enemy, enemy_loc + direction * enemy_pull, true)

			-- Destroy trees in the enemy's pull path if it is a real hero
			if enemy:IsRealHero() then
				for i = 0, math.ceil(enemy_pull / tree_radius) do
					GridNav:DestroyTreesAroundPoint(enemy_loc + direction * (enemy_pull - i * tree_radius), tree_radius, false)
				end
			end

			-- Stun enemies who were pulled near enough
			if distance < (enemy_pull + normal_pull) then
				
				-- Calculate stun duration
				local this_enemy_stun = math.max(( normal_pull - (distance - enemy_pull) ), 0) / normal_pull * stun_duration

				-- Apply stun
				enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = this_enemy_stun})
			end

		-- If the enemy is near enough, move it to the caster's front and stun it
		else

			-- Damage and pull the enemy
			FindClearSpaceForUnit(enemy, caster_loc + caster:GetForwardVector() * 100, true)
			ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

			-- Apply stun
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		end

		-- If an enemy was moved to the fountain area, remove it from there
		if enemy:IsRealHero() and IsNearEnemyClass(enemy, 1700, "ent_dota_fountain") then
			local fountain_loc
			if enemy:GetTeam() == DOTA_TEAM_GOODGUYS then
				fountain_loc = Vector(7472, 6912, 512)
			else
				fountain_loc = Vector(-7456, -6938, 528)
			end
			FindClearSpaceForUnit(enemy, fountain_loc + (enemy:GetAbsOrigin() - fountain_loc):Normalized() * 1700, true)
		end
	end
end