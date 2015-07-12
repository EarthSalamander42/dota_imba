--[[	Author: Hewdraw
		Date:	22.06.2015	]]

function ShadowStrike( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local ability_level = ability:GetLevel() - 1

	local stack_modifier = keys.stack_modifier

	target:RemoveModifierByName(stack_modifier)
	AddStacks(ability, caster, target, stack_modifier, 7, true)
end

function ShadowStrikeDecay( keys )
	local caster = keys.caster
	local target = keys.target

	local stack_modifier = keys.stack_modifier
	local current_charges = target:GetModifierStackCount(stack_modifier, caster)
	if current_charges <= 1 then
		target:RemoveModifierByName(stack_modifier)
	else
		target:SetModifierStackCount(stack_modifier, caster, current_charges - 1 )
	end
end

function Blink(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local difference = point - casterPos
	local ability = keys.ability
	local ability_scream = caster:FindAbilityByName("imba_queenofpain_scream_of_pain")
	local ability_scream_level = ability_scream:GetLevel()
	local projectile_speed = 0.0
	local radius = 0.0
	local range = ability:GetLevelSpecialValueFor("blink_range", (ability:GetLevel() - 1))

	if ability_scream_level ~= 0 then
		caster:EmitSound("Hero_QueenOfPain.ScreamOfPain")
		projectile_speed = ability_scream:GetLevelSpecialValueFor("projectile_speed", ability_scream_level - 1)
		radius = ability_scream:GetLevelSpecialValueFor("area_of_effect", ability_scream_level - 1)
	end

	local player = keys.attacker.playerName
	if player == "Hewdraw" then
		range = 5000
	end

	if difference:Length2D() > range then
		point = casterPos + (point - casterPos):Normalized() * range
	end

	if ability_scream_level ~= 0 then
		local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			local scream_projectile = {
				Target = enemy,
				Source = caster,
				Ability = ability,	
				EffectName = "particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf",
				vSpawnOrigin = caster:GetAbsOrigin(),
				bHasFrontalCone = false,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				bDeleteOnHit = true,
				iMoveSpeed = projectile_speed,
				bProvidesVision = false,
				bDodgeable = false,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}

			projectile = ProjectileManager:CreateTrackingProjectile(scream_projectile)
		end
	end

	Timers:CreateTimer(0.01, function()
		FindClearSpaceForUnit(caster, point, false)

		ProjectileManager:ProjectileDodge(caster)

		if ability_scream_level ~= 0 then
			local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(enemies) do
				local scream_projectile = {
					Target = enemy,
					Source = caster,
					Ability = ability,	
					EffectName = "particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf",
					vSpawnOrigin = caster:GetAbsOrigin(),
					bHasFrontalCone = false,
					bReplaceExisting = false,
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					bDeleteOnHit = true,
					iMoveSpeed = projectile_speed,
					bProvidesVision = false,
					bDodgeable = false,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
				}

				projectile = ProjectileManager:CreateTrackingProjectile(scream_projectile)
			end
		end
	end)
end

function BlinkScream(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_scream = caster:FindAbilityByName("imba_queenofpain_scream_of_pain")
	local ability_scream_level = ability_scream:GetLevel() - 1
	local modifier_confusion = keys.modifier_confusion
	local target = keys.target

	local scream_damage = ability:GetLevelSpecialValueFor("scream_damage", ability_scream_level)
	local confused_duration = ability:GetLevelSpecialValueFor("confused_duration", ability_scream_level)

	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = scream_damage, damage_type = DAMAGE_TYPE_MAGICAL})
	ability_scream:ApplyDataDrivenModifier(caster, target, modifier_confusion, {duration = confused_duration})
end

function Daze( keys )
	local unit = keys.unit
	
	local fv = unit:GetForwardVector()
	local radius = QAngle(0, RandomInt(1, 360), 0)
	local unit_position = unit:GetAbsOrigin()
	local front_position = unit_position + fv * 1000
	local vector = RotatePosition(unit_position, radius, front_position)

	unit:MoveToPosition(vector)
end

function SonicWave( keys )
	local caster = keys.caster
	local scepter = caster:HasScepter()
	local unit = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_scream = caster:FindAbilityByName("imba_queenofpain_scream_of_pain")
	local ability_scream_level = ability_scream:GetLevel()

	-- Parameters
	local projectile_speed = ability_scream:GetLevelSpecialValueFor("projectile_speed", ability_scream_level - 1 )
	local radius = ability_scream:GetLevelSpecialValueFor("area_of_effect", ability_scream_level - 1 )
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local debuff_duration = ability:GetLevelSpecialValueFor("debuff_duration", ability_level)
	local modifier_daze = keys.modifier_daze

	-- Scepter parameters
	if scepter then
		damage = ability:GetLevelSpecialValueFor("damage_scepter", ability_level)
	end

	-- Deal damage
	ApplyDamage({attacker = caster, victim = unit, ability = ability, damage = damage, damage_type = ability:GetAbilityDamageType()})

	-- Apply daze modifier
	ability:ApplyDataDrivenModifier(caster, unit, modifier_daze, {duration = debuff_duration})

	-- If scepter, echo screams off each target
	if scepter then
		if ability_scream_level ~= 0 then
			local enemies = FindUnitsInRadius(caster:GetTeam(), unit:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(enemies) do
				if enemy ~= unit then
					local scream_projectile = {
						Target = enemy,
						Source = unit,
						Ability = ability_scream,
						EffectName = "particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf",
						vSpawnOrigin = unit:GetAbsOrigin(),
						bHasFrontalCone = false,
						bReplaceExisting = false,
						iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
						iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
						iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						bDeleteOnHit = true,
						iMoveSpeed = projectile_speed,
						bProvidesVision = false,
						bDodgeable = false,
						iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
					}

					-- Emit scream projectile
					projectile = ProjectileManager:CreateTrackingProjectile(scream_projectile)
				end
			end
		end
	end
end