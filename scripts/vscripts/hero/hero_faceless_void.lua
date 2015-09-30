--[[	Author: Firetoad
		Date: 17.09.2015	]]

function Chronosphere( keys )
	local caster = keys.caster
	local chrono_center = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_chrono = keys.particle_chrono
	local modifier_caster = keys.modifier_caster
	local modifier_enemy = keys.modifier_enemy
	local modifier_ally = keys.modifier_ally
	local scepter = HasScepter(caster)
	
	-- Parameters
	local base_radius = ability:GetLevelSpecialValueFor("base_radius", ability_level)
	local base_duration = ability:GetLevelSpecialValueFor("base_duration", ability_level)
	local extra_radius = ability:GetLevelSpecialValueFor("extra_radius", ability_level)
	local extra_duration = ability:GetLevelSpecialValueFor("extra_duration", ability_level)
	local tick_interval = ability:GetLevelSpecialValueFor("tick_interval", ability_level)

	-- Calculate Chronosphere parameters
	local mana_cost = ability:GetManaCost(-1)
	local caster_mana = caster:GetMana()
	local total_radius = base_radius + extra_radius * caster_mana / mana_cost / FRANTIC_MULTIPLIER
	local total_duration = base_duration + extra_duration * caster_mana / mana_cost / FRANTIC_MULTIPLIER

	-- Spend mana
	caster:SpendMana(caster:GetMana(), ability)

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Create flying vision node
	ability:CreateVisibilityNode(chrono_center, total_radius, total_duration)

	-- Create particle
	local chrono_pfx = ParticleManager:CreateParticle(particle_chrono, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(chrono_pfx, 0, chrono_center)
	ParticleManager:SetParticleControl(chrono_pfx, 1, Vector(total_radius, total_radius, 0))

	-- Effect loop
	local elapsed_duration = 0
	Timers:CreateTimer(0, function()
		
		-- Find units inside the Chrono's radius
		local units = FindUnitsInRadius(caster:GetTeamNumber(), chrono_center, nil, total_radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		
		-- Apply appropriate modifiers
		for _,unit in pairs(units) do
			if unit == caster or unit:GetOwnerEntity() == caster or unit:FindAbilityByName("imba_faceless_void_chronosphere") then
				ability:ApplyDataDrivenModifier(caster, unit, modifier_caster, {})
				unit:AddNewModifier(caster, ability, "modifier_imba_speed_limit_break", {})	
			elseif scepter and unit:GetTeam() == caster:GetTeam() then
				ability:ApplyDataDrivenModifier(caster, unit, modifier_ally, {})
			elseif not unit:HasModifier(modifier_enemy) then
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_faceless_void_chronosphere_freeze", {duration = (total_duration - elapsed_duration)})
			end
		end

		-- Update duration and check end condition
		elapsed_duration = elapsed_duration + tick_interval
		if elapsed_duration < total_duration then
			return tick_interval
		else
			ParticleManager:DestroyParticle(chrono_pfx, false)
		end
		
	end)
end

function ChronoBuffEnd( keys )
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_imba_speed_limit_break")
end