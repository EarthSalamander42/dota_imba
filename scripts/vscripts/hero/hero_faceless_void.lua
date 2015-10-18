--[[	Author: Firetoad
		Date: 17.09.2015	]]

function TimeWalk( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_cast = keys.particle_cast
	local particle_chrono = keys.particle_chrono
	local modifier_caster = keys.modifier_caster
	local modifier_slow = keys.modifier_slow
	local modifier_buff = keys.modifier_buff

	-- Parameters
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local slow_radius = ability:GetLevelSpecialValueFor("slow_radius", ability_level)
	local chrono_radius = ability:GetLevelSpecialValueFor("chrono_radius", ability_level)
	local chrono_linger = ability:GetLevelSpecialValueFor("chrono_linger", ability_level)

	-- Movement geometry variables
	local target_loc = keys.target_points[1]
	local caster_loc = caster:GetAbsOrigin()
	local last_chrono_loc = caster_loc
	local tick_interval = 0.03
	local duration = (target_loc - caster_loc):Length2D() / speed
	local elapsed_duration = 0
	local tick_speed = speed * tick_interval

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Play afterimage particle
	local afterimage_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(afterimage_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(afterimage_pfx, 1, caster:GetAbsOrigin())

	-- Create chrono particle
	local chrono_pfx = {}
	local latest_chrono_pfx = 1
	chrono_pfx[latest_chrono_pfx] = ParticleManager:CreateParticle(particle_chrono, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(chrono_pfx[latest_chrono_pfx], 0, caster_loc)
	ParticleManager:SetParticleControl(chrono_pfx[latest_chrono_pfx], 1, Vector(chrono_radius, chrono_radius, 0))

	-- Mini-freeze enemies (initial)
	local chrono_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, chrono_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(chrono_enemies) do
		enemy:AddNewModifier(caster, ability, "modifier_faceless_void_chronosphere_freeze", {duration = (duration - elapsed_duration + chrono_linger)})
	end

	-- Slow enemies (initial)
	local slow_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, slow_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(slow_enemies) do
		if not enemy:HasModifier(modifier_slow) and enemy:IsRealHero() then
			AddStacks(ability, caster, caster, modifier_buff, 1, true)
		elseif enemy:IsRealHero() then
			AddStacks(ability, caster, caster, modifier_buff, 0, true)
		end
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
	end

	-- Apply caster modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})

	Timers:CreateTimer(tick_interval, function()

		-- Update the caster's position
		caster:SetAbsOrigin(caster_loc + (target_loc - caster_loc):Normalized() * tick_speed)

		-- Update caster location and jump duration variables
		caster_loc = caster:GetAbsOrigin()
		elapsed_duration = elapsed_duration + tick_interval

		-- Add another chrono particle, if appropriate
		if (caster_loc - last_chrono_loc):Length2D() > (chrono_radius / 2) then

			-- Update latest chrono position
			last_chrono_loc = caster_loc
			latest_chrono_pfx = latest_chrono_pfx + 1

			-- Create the particle
			chrono_pfx[latest_chrono_pfx] = ParticleManager:CreateParticle(particle_chrono, PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(chrono_pfx[latest_chrono_pfx], 0, last_chrono_loc)
			ParticleManager:SetParticleControl(chrono_pfx[latest_chrono_pfx], 1, Vector(chrono_radius, chrono_radius, 0))

			-- Mini-freeze enemies
			chrono_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, chrono_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(chrono_enemies) do
				enemy:AddNewModifier(caster, ability, "modifier_faceless_void_chronosphere_freeze", {duration = (duration - elapsed_duration + chrono_linger)})
			end

			-- Slow enemies
			slow_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, slow_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(slow_enemies) do
				if not enemy:HasModifier(modifier_slow) and enemy:IsRealHero() then
					AddStacks(ability, caster, caster, modifier_buff, 1, true)
				elseif enemy:IsRealHero() then
					AddStacks(ability, caster, caster, modifier_buff, 0, true)
				end
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
			end
		end

		-- If the distance to the target is smaller than [speed], or the duration is over, end the ability
		if (target_loc - caster_loc):Length2D() <= tick_speed or elapsed_duration >= duration then
			
			-- Destroy chrono particles after [chrono_linger] delay
			Timers:CreateTimer(chrono_linger, function()
				for _,current_chrono_pfx in pairs(chrono_pfx) do
					ParticleManager:DestroyParticle(current_chrono_pfx, false)
				end
			end)

			-- Remove caster modifier
			caster:RemoveModifierByName(modifier_caster)

			-- Move caster to the target position
			FindClearSpaceForUnit(caster, target_loc, true)

		-- If not, keep looping
		else
			return tick_interval
		end
	end)
end

function TimeLock( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_chrono = caster:FindAbilityByName(keys.ability_chrono)
	local sound_bash = keys.sound_bash
	local particle_chrono = keys.particle_chrono
	local modifier_caster = keys.modifier_caster
	local modifier_ally = keys.modifier_ally
	local scepter = HasScepter(caster)

	-- If the target is invalid, do nothing
	if target:IsTower() or target:IsBuilding() or target:GetTeam() == caster:GetTeam() then
		return nil
	end
	
	-- Parameters
	local bash_chance = ability:GetLevelSpecialValueFor("bash_chance", ability_level)
	local bash_damage = ability:GetLevelSpecialValueFor("bash_damage", ability_level)
	local bash_duration = ability:GetLevelSpecialValueFor("bash_duration", ability_level)
	local bash_radius = ability:GetLevelSpecialValueFor("bash_radius", ability_level)

	-- Roll for bash chance
	if RandomInt(1, 100) <= bash_chance then

		-- Fire sound effect
		target:EmitSound(sound_bash)

		-- Fire particle
		local chrono_pfx = ParticleManager:CreateParticle(particle_chrono, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(chrono_pfx, 0, bash_radius)
		ParticleManager:SetParticleControl(chrono_pfx, 1, Vector(bash_radius, bash_radius, 0))

		-- Find units inside the chrono
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, caster.small_chrono_radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		
		-- Apply appropriate modifiers
		for _,unit in pairs(units) do
			if unit == caster or unit:GetOwnerEntity() == caster or unit:FindAbilityByName("imba_faceless_void_chronosphere") then
				unit:AddNewModifier(caster, ability, "modifier_imba_speed_limit_break", {duration = bash_duration})
			elseif unit:GetTeam() == caster:GetTeam() then
				ability_chrono:ApplyDataDrivenModifier(caster, unit, modifier_ally, {duration = bash_duration})
			else

				-- Double damage if the target is inside a chrono
				if unit:HasModifier("modifier_faceless_void_chronosphere_freeze") then
					bash_damage = bash_damage * 2
				end

				-- Apply bash damage
				ApplyDamage({attacker = caster, victim = unit, ability = ability, damage = bash_damage, damage_type = DAMAGE_TYPE_MAGICAL})
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_faceless_void_chronosphere_freeze", {duration = bash_duration})
			end
		end

		
	end
end

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

	-- Fetch caster mana
	local mana_cost = ability:GetManaCost(-1)
	local caster_mana = caster:GetMana()

	-- Apply diminishing returns to caster's mana pool
	if caster_mana > 3000 then
		caster_mana = 1000 + 1000 * 0.8 + 1000 * 0.6 + (caster_mana - 3000) * 0.4
	elseif caster_mana > 2000 then
		caster_mana = 1000 + 1000 * 0.8 + (caster_mana - 2000) * 0.6
	elseif caster_mana > 1000 then
		caster_mana = 1000 + (caster_mana - 1000) * 0.8
	end

	-- Calculate final chronosphere parameters
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