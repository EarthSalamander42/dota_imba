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
	pit_width = 180

	-- creates a dummy to spawn the collider on
	local dummy_out = CreateUnitByName("npc_dummy_unit", caster_pos, false, nil, nil, caster:GetTeamNumber())
	local dummy_in = CreateUnitByName("npc_dummy_unit", caster_pos, false, nil, nil, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier( caster, dummy_in, "modifier_dummy_particle", {} )
	Physics:Unit(dummy_out)
	Physics:Unit(dummy_in)

	-- spawns a collider to prevent units from getting out
	local collider_pit_out = dummy_out:AddColliderFromProfile("hoof_stomp_pit_out")
	collider_pit_out.radius = pit_radius + pit_width
	collider_pit_out.draw = {color = Vector(200,0,0), alpha = 0}

	local collider_pit_in = dummy_in:AddColliderFromProfile("hoof_stomp_pit_in")
	collider_pit_in.radius = pit_radius + pit_width
	collider_pit_in.buffer = pit_width
	collider_pit_in.draw = {color = Vector(0,200,0), alpha = 0}

	-- marks the units inside the pit so they are not pushed out of the collider
	local units_inside_pit = FindUnitsInRadius(1, caster_pos, nil, pit_radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)

	for _,v in pairs(units_inside_pit) do
		v.is_inside_hoof_stomp_pit = true
	end

	Timers:CreateTimer(pit_duration, function()
		Physics:RemoveCollider(collider_pit_out)
		Physics:RemoveCollider(collider_pit_in)
		dummy_out:StopPhysicsSimulation()
		dummy_out:ForceKill(true)
		dummy_in:StopPhysicsSimulation()
		dummy_in:ForceKill(true)
		for _,v in pairs(units_inside_pit) do
			v.is_inside_hoof_stomp_pit = nil
		end
		end)
end

