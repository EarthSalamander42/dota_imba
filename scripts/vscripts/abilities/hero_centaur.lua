--[[Author: d2imba
	Date: 20.03.2015.]]

function HoofStomp( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local caster_pos = caster:GetAbsOrigin()
	local pit_radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local pit_width = ability:GetLevelSpecialValueFor("pit_width", ability:GetLevel() - 1)
	local pit_duration = ability:GetLevelSpecialValueFor("pit_duration", ability:GetLevel() - 1)

	-- Creates a dummy to spawn the collider on
	local dummy_out = CreateUnitByName("npc_dummy_unit", caster_pos, false, nil, nil, caster:GetTeamNumber())
	local dummy_in = CreateUnitByName("npc_dummy_unit", caster_pos, false, nil, nil, caster:GetTeamNumber())
	Physics:Unit(dummy_out)
	Physics:Unit(dummy_in)

	-- Creates the pit's wall
	local wall_angle = QAngle(0, 10, 0)
	local base_wall_angle = wall_angle
	local start_vector = caster_pos + caster:GetForwardVector() * (pit_radius + pit_width / 2)

	local wallpiece_01 = CreateUnitByName("npc_dummy_centaur_pit_wall", start_vector, false, nil, nil, caster:GetTeamNumber())
	local wallpiece_02 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_03 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_04 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_05 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_06 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_07 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_08 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_09 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_10 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_11 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_12 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_13 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_14 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_15 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_16 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_17 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_18 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_19 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_20 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_21 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_22 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_23 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_24 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_25 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_26 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_27 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_28 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_29 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_30 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_31 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_32 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_33 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_34 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_35 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())
	wall_angle = RotateOrientation(wall_angle, base_wall_angle)
	local wallpiece_36 = CreateUnitByName("npc_dummy_centaur_pit_wall", RotatePosition(caster_pos, wall_angle, start_vector), false, nil, nil, caster:GetTeamNumber())

	-- Spawns colliders to prevent units from getting in/out
	local collider_pit_out = dummy_out:AddColliderFromProfile("hoof_stomp_pit_out")
	collider_pit_out.radius = pit_radius + pit_width

	local collider_pit_in = dummy_in:AddColliderFromProfile("hoof_stomp_pit_in")
	collider_pit_in.radius = pit_radius + pit_width
	collider_pit_in.buffer = pit_width

	-- Marks the units inside the pit so they are not pushed out of the collider
	local units_inside_pit = FindUnitsInRadius(1, caster_pos, nil, pit_radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)

	for _,v in pairs(units_inside_pit) do
		v.is_inside_hoof_stomp_pit = true
	end

	-- destroys dummy units and wall pieces
	Timers:CreateTimer(pit_duration, function()
		Physics:RemoveCollider(collider_pit_out)
		Physics:RemoveCollider(collider_pit_in)
		dummy_out:StopPhysicsSimulation()
		dummy_out:ForceKill(true)
		dummy_in:StopPhysicsSimulation()
		dummy_in:ForceKill(true)
		wallpiece_01:Destroy()
		wallpiece_02:Destroy()
		wallpiece_03:Destroy()
		wallpiece_04:Destroy()
		wallpiece_05:Destroy()
		wallpiece_06:Destroy()
		wallpiece_07:Destroy()
		wallpiece_08:Destroy()
		wallpiece_09:Destroy()
		wallpiece_10:Destroy()
		wallpiece_11:Destroy()
		wallpiece_12:Destroy()
		wallpiece_13:Destroy()
		wallpiece_14:Destroy()
		wallpiece_15:Destroy()
		wallpiece_16:Destroy()
		wallpiece_17:Destroy()
		wallpiece_18:Destroy()
		wallpiece_19:Destroy()
		wallpiece_20:Destroy()
		wallpiece_21:Destroy()
		wallpiece_22:Destroy()
		wallpiece_23:Destroy()
		wallpiece_24:Destroy()
		wallpiece_25:Destroy()
		wallpiece_26:Destroy()
		wallpiece_27:Destroy()
		wallpiece_28:Destroy()
		wallpiece_29:Destroy()
		wallpiece_30:Destroy()
		wallpiece_31:Destroy()
		wallpiece_32:Destroy()
		wallpiece_33:Destroy()
		wallpiece_34:Destroy()
		wallpiece_35:Destroy()
		wallpiece_36:Destroy()
		for _,v in pairs(units_inside_pit) do
			v.is_inside_hoof_stomp_pit = nil
		end
		end)
end

function DoubleEdge( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = ability:GetLevelSpecialValueFor("edge_damage", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local str_percentage = ability:GetLevelSpecialValueFor("str_percentage", ability_level)
	local target_pos = target:GetAbsOrigin()
	local HP = caster:GetHealth()
	local str = caster:GetStrength()
	local magic_resist = caster:GetMagicalArmorValue()
	local damage_type = ability:GetAbilityDamageType()

	-- Draw the particle
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) -- Destination
	ParticleManager:SetParticleControl(particle, 5, target:GetAbsOrigin()) -- Hit Glow

	-- Deal damage to enemies
	local self_damage = damage - str * str_percentage / 100
	damage = damage + str * str_percentage / 100

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _,v in pairs(enemies) do
		ApplyDamage({victim = v, attacker = caster, ability = ability, damage = damage, damage_type = damage_type})
	end

	-- Calculate the self magic damage
	if self_damage < 0 then
		self_damage = 0
	end
	local true_damage = self_damage * (1 - magic_resist)
	
	-- If its lethal damage, set hp to 1, else do the full self damage
	if HP <= true_damage then
		caster:SetHealth(1)
	else
	-- Self Damage
		ApplyDamage({victim = caster, attacker = caster, ability = ability, damage = self_damage, damage_type = damage_type})
	end
end

function Return( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_prevent_return = keys.modifier_prevent_return
	local caster_str = caster:GetStrength()
	local str_percentage = ability:GetLevelSpecialValueFor("strength_pct", ability_level)
	local min_damage = ability:GetLevelSpecialValueFor("minimum_damage", ability_level)
	local damage_type = ability:GetAbilityDamageType()
	local damage = caster_str * str_percentage / 100

	-- Checks for damage below minimum
	if damage < min_damage then
		damage = min_damage
	end

	-- Damages attacker if it hasn't taken return damage in the last second
	if not attacker:HasModifier(modifier_prevent_return) then
		ApplyDamage({victim = attacker, attacker = caster, damage = damage, damage_type = damage_type })
		
		-- Applies "damaged by return" modifier to the attacker
		ability:ApplyDataDrivenModifier(caster, attacker, modifier_prevent_return, {duration = "0.95"})
	end
end

function Stampede( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_debuff = keys.modifier_debuff
	local ability_level = ability:GetLevel() - 1
	local duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local caster_str = caster:GetStrength()
	local strength_damage = ability:GetLevelSpecialValueFor("strength_damage", ability_level) / 100
	local damage_type = ability:GetAbilityDamageType()
	local total_damage = damage + ( caster_str * strength_damage )

	local scepter = HasScepter(caster)
	local hit = false

	-- Ignore the target if its already on the table
	local targets_hit = ability.targets_hit
	for k,v in pairs(targets_hit) do
		if v == target then
			hit = true
		end
	end

	if not hit then
		-- Damage
		ApplyDamage({victim = target, attacker = caster, damage = total_damage, damage_type = damage_type})

		-- Modifier
		ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {duration = duration})

		-- Add to the targets hit by this cast
		table.insert(ability.targets_hit, target)
		target.stampede_hit_count = 1
	end

	if hit and scepter then
		-- Increase hit counter
		target.stampede_hit_count = target.stampede_hit_count + 1

		-- Reduced damage
		ApplyDamage({victim = target, attacker = caster, damage = total_damage / target.stampede_hit_count, damage_type = damage_type})

		-- Reduced duration stun
		ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {duration = duration / target.stampede_hit_count})
	end


end

-- Emits the global sound and initializes a table to keep track of the units hit
function StampedeStart( keys )
	EmitGlobalSound("Hero_Centaur.Stampede.Cast")

	if not targets_hit == nil then
		for k,v in pairs(targets_hit) do
			v.stampede_hit_count = 0
		end
	end

	keys.ability.targets_hit = {}
end