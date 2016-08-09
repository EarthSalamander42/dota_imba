--[[	Author: Firetoad & Hewdraw
		Date: 22.06.2015			]]

function ShadowStrikeCast( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_caster = keys.particle_caster
	local particle_projectile = keys.particle_projectile

	-- Parameters
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Play caster particle
	local caster_pfx = ParticleManager:CreateParticle(particle_caster, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(caster_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(caster_pfx, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(caster_pfx, 3, Vector(projectile_speed, 0, 0))
	ParticleManager:ReleaseParticleIndex(caster_pfx)

	-- Launch homing projectile
	local shadow_projectile = {
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = particle_projectile,
		bDodgeable = true,
		bProvidesVision = false,
		iMoveSpeed = projectile_speed,
	--	iVisionRadius = vision_radius,
	--	iVisionTeamNumber = caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}
	ProjectileManager:CreateTrackingProjectile(shadow_projectile)
end

function ShadowStrikeAttack( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit
	local particle_caster = keys.particle_caster
	local particle_projectile = keys.particle_projectile
	local modifier_debuff = keys.modifier_debuff

	-- If the target is a building, Roshan, an ally, already affected by the debuff, or magic immune, do nothing
	if target:IsMagicImmune() or target:IsBuilding() or IsRoshan(target) or (caster:GetTeam() == target:GetTeam()) or target:HasModifier(modifier_debuff) then
		return nil
	end

	-- Parameters
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level) * 2
	local attack_count = ability:GetLevelSpecialValueFor("attack_count", ability_level)
	local should_cast = false

	-- Play hit sound
	caster:EmitSound(sound_hit)

	-- Play caster particle
	local caster_pfx = ParticleManager:CreateParticle(particle_caster, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(caster_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(caster_pfx, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(caster_pfx, 3, Vector(projectile_speed, 0, 0))
	ParticleManager:ReleaseParticleIndex(caster_pfx)

	-- Throw the projectile
	local shadow_projectile = {
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = particle_projectile,
		bDodgeable = true,
		bProvidesVision = false,
		iMoveSpeed = projectile_speed,
	--	iVisionRadius = vision_radius,
	--	iVisionTeamNumber = caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}
	ProjectileManager:CreateTrackingProjectile(shadow_projectile)
end	

function ShadowStrikeHit( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local ability_level = ability:GetLevel() - 1

	local stack_modifier = keys.stack_modifier

	target:RemoveModifierByName(stack_modifier)
	AddStacks(ability, caster, target, stack_modifier, 8, true)

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, ability:GetLevelSpecialValueFor("strike_damage", ability_level), nil)
end

function ShadowStrikeDecay( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local stack_modifier = keys.stack_modifier

	-- If the ability was unlearned, remove all stacks
	if not ability then
		target:RemoveModifierByName(stack_modifier)
	end

	-- Else, reduce stacks by 1
	local current_charges = target:GetModifierStackCount(stack_modifier, caster)
	if current_charges <= 1 then
		target:RemoveModifierByName(stack_modifier)
	else
		target:SetModifierStackCount(stack_modifier, caster, current_charges - 1 )
	end

	-- Play damage message
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, ability:GetLevelSpecialValueFor("duration_damage", ability_level), nil)
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
	local range = ability:GetLevelSpecialValueFor("blink_range", (ability:GetLevel() - 1)) + GetCastRangeIncrease(caster)

	if ability_scream_level ~= 0 then
		caster:EmitSound("Hero_QueenOfPain.ScreamOfPain")
		projectile_speed = ability_scream:GetLevelSpecialValueFor("projectile_speed", ability_scream_level - 1)
		radius = ability_scream:GetLevelSpecialValueFor("area_of_effect", ability_scream_level - 1)
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

	FindClearSpaceForUnit(caster, point, false)
	ProjectileManager:ProjectileDodge(caster)

	Timers:CreateTimer(0.05, function()
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
	local nausea_duration = ability:GetLevelSpecialValueFor("nausea_duration", ability_scream_level)

	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = scream_damage, damage_type = DAMAGE_TYPE_MAGICAL})
	ability_scream:ApplyDataDrivenModifier(caster, target, modifier_confusion, {duration = nausea_duration})
end

function NauseaCast( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local nausea_base_dmg = ability:GetLevelSpecialValueFor("nausea_base_dmg", ability_level)
	local nausea_bonus_dmg = ability:GetLevelSpecialValueFor("nausea_bonus_dmg", ability_level) * 0.01

	-- Calculate damage
	local damage = nausea_base_dmg + target:GetMaxHealth() * nausea_bonus_dmg

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end

function NauseaAttack( keys )
	local caster = keys.caster
	local target = keys.attacker
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local nausea_base_dmg = ability:GetLevelSpecialValueFor("nausea_base_dmg", ability_level)
	local nausea_bonus_dmg = ability:GetLevelSpecialValueFor("nausea_bonus_dmg", ability_level) * 0.01

	-- Calculate damage
	local damage = nausea_base_dmg + target:GetMaxHealth() * nausea_bonus_dmg

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end

function Torment( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local cooldown_reduction = ability:GetLevelSpecialValueFor("cooldown_reduction", ability_level)

	-- If a hero was damaged, reduce all ability cooldowns
	if target:IsRealHero() then
		for i = 0, 15 do
			local current_ability = caster:GetAbilityByIndex(i)
			if current_ability then
				local cooldown_remaining = current_ability:GetCooldownTimeRemaining()
				current_ability:EndCooldown()
				if cooldown_remaining > cooldown_reduction then
					current_ability:StartCooldown( cooldown_remaining - cooldown_reduction )
				end
			end
		end
	end
end	

function Daze( keys )
	local target = keys.target
	
	local fv = target:GetForwardVector()
	local radius = QAngle(0, RandomInt(1, 360), 0)
	local unit_position = target:GetAbsOrigin()
	local front_position = unit_position + fv * 500
	local vector = RotatePosition(unit_position, radius, front_position)

	target:MoveToPosition(vector)
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

	-- Apply daze modifier on non-magic-immune targets
	if not unit:IsMagicImmune() then
		ability:ApplyDataDrivenModifier(caster, unit, modifier_daze, {duration = debuff_duration})
	end

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