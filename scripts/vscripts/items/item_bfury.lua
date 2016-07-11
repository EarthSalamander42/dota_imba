--[[	Author: Firetoad
		Date:	08.07.2016	]]

function BattleFury( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local chop_radius = ability:GetLevelSpecialValueFor("chop_radius", ability_level)

	-- Destroy trees in the area
	GridNav:DestroyTreesAroundPoint(target, chop_radius, false)

	-- Destroy wards in the area
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, chop_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		if IsWardOrBomb(enemy) then
			enemy:Kill(ability, caster)
		end
	end
end

function BattleFuryHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_cleave = keys.modifier_cleave
	local particle_cleave = keys.particle_cleave

	-- If the target is a building, do nothing
	if target:IsBuilding() then
		return nil
	end

	-- Parameters
	local cleave_damage = ability:GetLevelSpecialValueFor("ranged_cleave_damage", ability_level)
	local quelling_bonus = ability:GetLevelSpecialValueFor("quelling_bonus", ability_level)
	local cleave_radius = ability:GetLevelSpecialValueFor("cleave_radius", ability_level)
	local target_loc = target:GetAbsOrigin()

	-- If the wielder is melee, increase cleave damage
	if not caster:IsRangedAttacker() or caster:HasModifier("modifier_imba_berserkers_rage") then
		cleave_damage = ability:GetLevelSpecialValueFor("melee_cleave_damage", ability_level)
	end

	-- Calculate actual cleave and quell bonuses
	local cleave_stacks = caster:GetModifierStackCount(modifier_cleave, caster)
	cleave_damage = cleave_damage * cleave_stacks
	quelling_bonus = quelling_bonus * cleave_stacks

	-- Calculate damage to deal
	local damage = caster:GetAverageTrueAttackDamage()
	cleave_damage = damage * cleave_damage / 100

	-- If the target is a creep, deal bonus damage
	if not ( target:IsHero() or target:IsBuilding() or IsRoshan(target) ) then
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage * quelling_bonus / 100, damage_type = DAMAGE_TYPE_PHYSICAL})
	end

	-- Draw particle
	local cleave_pfx = ParticleManager:CreateParticle(particle_cleave, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(cleave_pfx, 0, target_loc)

	-- Find enemies to damage
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, cleave_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	
	-- Deal damage
	for _,enemy in pairs(enemies) do
		if enemy ~= target and not enemy:IsAttackImmune() then
			ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = cleave_damage, damage_type = DAMAGE_TYPE_PURE})
		end
	end
end

function BattleFuryStackUp( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_cleave = keys.modifier_cleave

	-- Apply a stack of the cleave modifier
	AddStacks(ability, caster, caster, modifier_cleave, 1, true)
end

function BattleFuryStackDown( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_cleave = keys.modifier_cleave

	-- If this is the last stack, remove cleave modifier
	local current_stacks = caster:GetModifierStackCount(modifier_cleave, caster)
	if current_stacks <= 1 then
		caster:RemoveModifierByName(modifier_cleave)

	-- Else, reduce stack count by 1
	else
		caster:SetModifierStackCount(modifier_cleave, caster, current_stacks - 1)
	end
end