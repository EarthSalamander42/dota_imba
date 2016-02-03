--[[	Author: D2imba
		Date: 23.05.2015	]]

function Purification( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target
	local scepter = HasScepter(caster)

	-- If the target is a building and there's no scepter, refund mana and reset the cooldown.
	if target:IsBuilding() and not scepter then
		ability:RefundManaCost()
		ability:EndCooldown()
		return nil
	end

	-- Effects
	local cast_sound = keys.cast_sound
	local aoe_particle = keys.aoe_particle
	local target_particle = keys.target_particle

	-- Parameters
	local heal_min = ability:GetLevelSpecialValueFor("heal_min", ability_level)
	local heal_pct = ability:GetLevelSpecialValueFor("heal_pct", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local target_pos = target:GetAbsOrigin()

	-- Increase healing if the target is not a building
	local heal = heal_min
	if not target:IsBuilding() then
		heal = math.max( heal_min, target:GetMaxHealth() * heal_pct / 100 )		
	end

	-- Heal and apply the strong purge on the target
	target:Heal(heal, caster)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, heal, nil)
	--target:Purge(false, true, false, true, false)

	-- Play cast sound and particles
	target:EmitSound(cast_sound)
	local aoe_fx = ParticleManager:CreateParticle(aoe_particle, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(aoe_fx, 0, target_pos)
	ParticleManager:SetParticleControl(aoe_fx, 1, Vector(radius, radius, radius))
	local target_fx = ParticleManager:CreateParticle(target_particle, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(target_fx, 0, target_pos)

	-- Damage nearby enemies
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, 0, 0, false)
	for _,enemy in pairs(targets) do
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = heal_min, damage_type = DAMAGE_TYPE_PURE})
	end
end

function PurificationDeath( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Effects
	local cast_sound = keys.cast_sound
	local aoe_particle = keys.aoe_particle
	local target_particle = keys.target_particle

	-- Parameters
	local heal_min = ability:GetLevelSpecialValueFor("heal_min", ability_level)
	local heal_pct = ability:GetLevelSpecialValueFor("heal_pct", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local passive_modifier = keys.passive_modifier
	local cooldown_modifier = keys.cooldown_modifier
	local caster_pos = caster:GetAbsOrigin()
	local heal = math.max( heal_min, caster:GetMaxHealth() * heal_pct / 100 )

	-- Check if fatal damage was dealt
	if caster:GetHealth() <= 2 then

		-- Heal and apply the strong purge
		caster:Heal(heal, caster)
		--caster:Purge(false, true, false, true, false)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, heal, nil)

		-- Play cast sound and particles
		caster:EmitSound(cast_sound)
		local aoe_fx = ParticleManager:CreateParticle(aoe_particle, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(aoe_fx, 0, caster_pos)
		ParticleManager:SetParticleControl(aoe_fx, 1, Vector(radius, radius, radius))
		local target_fx = ParticleManager:CreateParticle(target_particle, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(target_fx, 0, caster_pos)

		-- Damage nearby enemies
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, 0, 0, false)
		for _,enemy in pairs(targets) do
			ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = heal_min, damage_type = DAMAGE_TYPE_PURE})
		end

		-- Remove the passive modifier and apply the cooldown one
		caster:RemoveModifierByName(passive_modifier)
		ability:ApplyDataDrivenModifier(caster, caster, cooldown_modifier, {})
	end
end

function Repel( keys )
	local target = keys.target
	local caster = keys.caster

	target:Purge(false, true, false, true, false)
	caster:Purge(false, true, false, true, false)
end

function DegenAura( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local stack_reduction_pct = ability:GetLevelSpecialValueFor("stack_reduction_pct", ability_level)
	local modifier = keys.modifier
	local dummy_modifier = keys.dummy_modifier
	local main_stat = 0

	-- Only removes attributes from heroes
	if target:IsHero() then
		
		-- Verifies which is the affected hero's main attribute
		local main_att = target:GetPrimaryAttribute()
		if main_att == 0 then
			modifier = modifier.."str"
			main_stat = target:GetStrength()
		elseif main_att == 1 then
			modifier = modifier.."agi"
			main_stat = target:GetAgility()
		elseif main_att == 2 then
			modifier = modifier.."int"
			main_stat = target:GetIntellect()
		end

		-- Refreshes the debuff and adds stacks
		local stack_amount = math.max(main_stat * stack_reduction_pct / 100, 1)
		AddStacks(ability, caster, target, modifier, stack_amount, true)

		-- Places and removes a dummy modifier to refresh health/mana amounts
		ability:ApplyDataDrivenModifier(caster, target, dummy_modifier, {})
		target:RemoveModifierByName(dummy_modifier)
	end
end

function ScepterCheck( keys )
	local caster = keys.caster
	local scepter = HasScepter(caster)

	if scepter then
		local repel_name = keys.repel_name
		local guardian_angel_name = keys.guardian_angel_name
		local modifier = keys.modifier

		caster:RemoveModifierByName(modifier)
		SwitchAbilities(caster, repel_name.."_scepter", repel_name, true, true)
		SwitchAbilities(caster, guardian_angel_name.."_scepter", guardian_angel_name, true, true)
	else
		return nil
	end
end

function ScepterLostCheck( keys )
	local caster = keys.caster
	local scepter = HasScepter(caster)

	if scepter then
		return nil
	else
		local repel_name = keys.repel_name
		local guardian_angel_name = keys.guardian_angel_name
		local modifier = keys.modifier

		caster:RemoveModifierByName(modifier)
		SwitchAbilities(caster, repel_name, repel_name.."_scepter", true, true)
		SwitchAbilities(caster, guardian_angel_name, guardian_angel_name.."_scepter", true, true)
	end
end