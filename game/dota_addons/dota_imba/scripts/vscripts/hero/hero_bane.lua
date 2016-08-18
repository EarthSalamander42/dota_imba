--[[	Author: D2imba
		Date: 10.03.2015	]]

function Enfeeble( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_str = keys.modifier_str
	local modifier_agi = keys.modifier_agi
	local modifier_int = keys.modifier_int

	-- Parameters
	local reduce_factor = ability:GetLevelSpecialValueFor("stat_reduction", ability_level) / 100

	-- Remove current stacks and enfeeble debuff
	target:RemoveModifierByName(modifier_str)
	target:RemoveModifierByName(modifier_agi)
	target:RemoveModifierByName(modifier_int)

	-- Calculate attribute reduction
	local target_str = target:GetStrength()
	local target_agi = target:GetAgility()
	local target_int = target:GetIntellect()
	local total_stacks = math.floor( ( target_str + target_agi + target_int ) * reduce_factor )
	
	-- Reduce Intelligence to a minimum of 1 (prevents making the target manaless for the rest of the match)
	if math.floor(total_stacks / 3) < target_int then
		AddStacks(ability, caster, target, modifier_int, math.floor(total_stacks / 3), true)
		total_stacks = total_stacks - math.floor(total_stacks / 3)
	else
		AddStacks(ability, caster, target, modifier_int, target_int - 1, true)
		total_stacks = total_stacks - (target_int - 1)
	end
	
	-- Reduce Strength to a minimum of 1 (prevents making the target a "zombie" for the rest of the match)
	if math.floor(total_stacks / 2) < target_str then
		AddStacks(ability, caster, target, modifier_str, math.floor(total_stacks / 2), true)
		total_stacks = total_stacks - math.floor(total_stacks / 2)
	else
		AddStacks(ability, caster, target, modifier_str, target_str - 1, true)
		total_stacks = total_stacks - (target_str - 1)
	end

	-- Reduce Agility (no minimum value)
	AddStacks(ability, caster, target, modifier_agi, total_stacks, true)
	
	-- Update the target's stats
	target:CalculateStatBonus()
end

function EnfeebleEnd( keys )
	local caster = keys.caster
	local target = keys.target
	local modifier_str = keys.modifier_str
	local modifier_agi = keys.modifier_agi
	local modifier_int = keys.modifier_int

	-- Remove current stacks of attribute reduction
	target:RemoveModifierByName(modifier_str)
	target:RemoveModifierByName(modifier_agi)
	target:RemoveModifierByName(modifier_int)
end

function BrainSap( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_target = keys.sound_target
	local modifier_sap = keys.modifier_sap
	local particle_sap = keys.particle_sap

	-- Parameters
	local heal_amt = ability:GetLevelSpecialValueFor("heal_amt", ability_level)

	-- Play sounds
	caster:EmitSound(sound_cast)
	target:EmitSound(sound_target)

	-- Play particle
	local sap_pfx = ParticleManager:CreateParticle(particle_sap, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(sap_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(sap_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

	-- Apply the debuff
	ability:ApplyDataDrivenModifier(caster, target, modifier_sap, {})

	-- Heal/Damage
	caster:Heal(heal_amt, caster)
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = heal_amt, damage_type = DAMAGE_TYPE_PURE})

end

function BrainSapSpellCast( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local cast_ability = keys.event_ability
	local sound_manaburn = keys.sound_manaburn
	local modifier_sap = keys.modifier_sap
	local particle_manaburn = keys.particle_manaburn
	local particle_sap = keys.particle_sap

	-- If there isn't a casted ability, do nothing
	if not cast_ability then
		return nil
	end

	-- Parameters
	local mana_percent = ability:GetLevelSpecialValueFor("mana_percent", ability_level)
	local mana_to_drain = target:GetMaxMana() * mana_percent / 100

	-- If the spell uses mana, reduce target's mana by the specified %
	if cast_ability and cast_ability:GetManaCost( cast_ability:GetLevel() - 1 ) > 0 then
		target:ReduceMana(mana_to_drain)

		-- Show how much mana was drained
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, target, mana_to_drain, nil)

		-- Play mana burn particle
		local manaburn_pfx = ParticleManager:CreateParticle(particle_manaburn, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(manaburn_pfx, 0, target:GetAbsOrigin() )

		-- Play sap particle
		local sap_pfx = ParticleManager:CreateParticle(particle_sap, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControlEnt(sap_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(sap_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

		-- Play mana burn sound
		target:EmitSound(sound_manaburn)

		-- Grant the caster health and mana
		caster:Heal(mana_to_drain / 2, caster)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, mana_to_drain / 2, nil)
		caster:GiveMana(mana_to_drain / 2)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, mana_to_drain / 2, nil)

		-- Destroy the debuff
		target:RemoveModifierByName(modifier_sap)
	end
end

function FiendsGripManaDrain( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local scepter = HasScepter(caster)
	local mana_drain = ability:GetLevelSpecialValueFor("fiends_grip_mana_drain", ability:GetLevel() -1) / 100
	
	if scepter == true then
		mana_drain = ability:GetLevelSpecialValueFor("fiends_grip_mana_drain_scepter", ability:GetLevel() -1) / 100
	end

	local target_max_mana = target:GetMaxMana()
	local actual_mana_drained = mana_drain * target_max_mana
	
	target:ReduceMana(actual_mana_drained)
	caster:GiveMana(actual_mana_drained)
end

function FiendsGripStopChannel( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier
	local scepter = HasScepter(caster)
	local extra_duration = ability:GetLevelSpecialValueFor("fiends_grip_extra_duration", (ability:GetLevel() -1))

	if scepter == true then
		extra_duration = ability:GetLevelSpecialValueFor("fiends_grip_extra_duration_scepter", (ability:GetLevel() -1))
	end

	local enemies_affected = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType() , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
	for _,v in pairs(enemies_affected) do
		if v:HasModifier(modifier) then
			ability:ApplyDataDrivenModifier(caster, v, modifier, {duration = extra_duration})
		end
	end
end

function FiendsGripEndSound( keys )
	local target = keys.target
	local sound_1 = keys.sound_1
	local sound_2 = keys.sound_2

	StopSoundEvent(sound_1, target)
	StopSoundEvent(sound_2, target)
	target.fiends_grip_dummy:Destroy()
end

function FiendsGripScepter( keys )
	local caster = keys.caster
	local scepter = HasScepter(caster)

	if scepter == true then
		local target = keys.target
		local ability = keys.ability
		local modifier = keys.modifier_fiends_grip
		local ability_level = ability:GetLevel() - 1

		local vision_radius = ability:GetLevelSpecialValueFor("fiends_grip_scepter_radius", ability_level)
		local vision_cone = ability:GetLevelSpecialValueFor("fiends_grip_scepter_vision_cone", ability_level)
		local caster_location = caster:GetAbsOrigin()
		local enemies_to_check = FindUnitsInRadius(target:GetTeam(), caster_location, nil, vision_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType() , 0, FIND_CLOSEST, false)
		
		for _,v in pairs(enemies_to_check) do
			caster_location = caster:GetAbsOrigin()
			local target_location = v:GetAbsOrigin()
			local direction = (caster_location - target_location):Normalized()
			local forward_vector = v:GetForwardVector()
			local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y)
			if angle <= ( vision_cone / 2 ) and v:CanEntityBeSeenByMyTeam(caster) then
				ability:ApplyDataDrivenModifier(caster, v, modifier, {})
			end
		end
	end
end

function FiendsGripTruesight( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability

	local target_location = target:GetAbsOrigin()
	target.fiends_grip_dummy = CreateUnitByName("npc_dummy_unit", target_location, false, nil, nil, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, target.fiends_grip_dummy, "modifier_item_gem_of_true_sight", {radius = 50})
end

function NightmareDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	local target_health = target:GetHealth()
	local damage = ability:GetLevelSpecialValueFor("damage_per_second", ability:GetLevel() - 1)

	-- Check if the damage would be lethal.
	if target_health <= damage then
		
		-- If that's the case, deal pure damage.
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})
	else
		-- Otherwise, just set the health to be lower
		target:SetHealth(target_health - damage)
	end
end

function NightmareSpread( keys )
	local caster = keys.caster
	local target = keys.target
	local attacker = keys.attacker
	local ability = keys.ability
	local nightmare_modifier = keys.nightmare_modifier

	-- Check if it has the Nightmare debuff
	if target:HasModifier(nightmare_modifier) then

		-- If it does then apply it to the attacker
		ability:ApplyDataDrivenModifier(caster, attacker, nightmare_modifier, {})
	end
end

function NightmareInvulEnd( keys )
	local caster = keys.caster
	local target = keys.target
	local nightmare_modifier = keys.nightmare_modifier

	-- If this is the caster, remove the nightmare modifier
	if caster == target then
		target:RemoveModifierByName(nightmare_modifier)
	end
end

function NightmareEnd( keys )
	local target = keys.target
	local loop_sound = keys.loop_sound

	-- Stops playing sound
	StopSoundEvent(loop_sound, target)
end

function NightmareEndCast( keys )
	local ability = keys.ability
	local target = keys.target
	local modifier_nightmare = keys.modifier_nightmare
	local modifier_invul = keys.modifier_invul

	-- Remove Nightmare modifiers
	target:RemoveModifierByName(modifier_nightmare)
	target:RemoveModifierByName(modifier_invul)
end