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
		local enemies = FindUnitsInRadius(caster.GetTeam(caster), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			local scream_projectile = {
				Target = enemy,
				Source = caster,
				Ability = ability_scream,	
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

		if ability_scream_level ~= 0 then
			local enemies = FindUnitsInRadius(caster.GetTeam(caster), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(enemies) do
				local scream_projectile = {
					Target = enemy,
					Source = caster,
					Ability = ability_scream,	
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

function Confusion( keys )
	local caster = keys.caster
	local unit = keys.unit
	
	local fv = unit:GetForwardVector()
	local radius = QAngle(0, RandomInt(1, 360), 0)
	local caster_position = caster:GetAbsOrigin()
	local front_position = caster_position + fv * 1000
	local vector = RotatePosition(caster_position, radius, front_position)

	unit:MoveToPosition(vector)
end

function ScepterCheck( keys )
	local caster = keys.caster
	local scepter = caster:HasScepter()
	local unit = keys.target
	local ability_scream = caster:FindAbilityByName("imba_queenofpain_scream_of_pain")
	local ability_scream_level = ability_scream:GetLevel()
	local projectile_speed = ability_scream:GetLevelSpecialValueFor("projectile_speed", ability_scream_level - 1)
	local radius = ability_scream:GetLevelSpecialValueFor("area_of_effect", ability_scream_level - 1)

	if scepter == true then
		if ability_scream_level ~= 0 then
			local enemies = FindUnitsInRadius(caster.GetTeam(caster), unit:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
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

					projectile = ProjectileManager:CreateTrackingProjectile(scream_projectile)
				end
			end
		end
	end
end

function ScepterCooldown