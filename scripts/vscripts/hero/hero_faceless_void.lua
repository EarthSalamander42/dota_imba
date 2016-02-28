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

	-- Heal recent damage
	if caster.time_walk_damage_taken then
		caster:Heal(caster.time_walk_damage_taken, caster)
	end

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

function TimeWalkDamage( keys )
	local ability = keys.ability

	-- If the ability was unlearned, do nothing
	if not ability then
		return nil
	end

	-- Parameters
	local caster = keys.caster
	local ability_level = ability:GetLevel() - 1
	local damage_taken = keys.damage_taken
	local damage_time = ability:GetLevelSpecialValueFor("damage_time", ability_level)

	-- Initializes damage taken counter if necessary
	if not caster.time_walk_damage_taken then
		caster.time_walk_damage_taken = 0
	end
	
	-- Stores this instance of damage
	caster.time_walk_damage_taken = caster.time_walk_damage_taken + damage_taken

	-- Decrease damage counter after the duration is up
	Timers:CreateTimer(damage_time, function()
		caster.time_walk_damage_taken = caster.time_walk_damage_taken - damage_taken
	end)
end

function TimeDilation( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_hit = keys.sound_hit
	local particle_cast = keys.particle_cast
	local particle_hit = keys.particle_hit
	local modifier_slow = keys.modifier_slow
	local modifier_buff = keys.modifier_buff

	-- Parameters
	local cooldown_increase = ability:GetLevelSpecialValueFor("cooldown_increase", ability_level)
	local cooldown_start = ability:GetLevelSpecialValueFor("cooldown_start", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local caster_pos = caster:GetAbsOrigin()

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Play cast particles
	local cast_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(cast_pfx, 0, caster_pos)
	ParticleManager:SetParticleControl(cast_pfx, 1, Vector(radius, 0, 0))
	local cast_pfx_2 = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(cast_pfx, 0, caster_pos)

	-- Iterate through affected enemies
	local abilities_affected = 0
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
	for _,target in pairs(nearby_enemies) do
		
		-- Play hit sound
		target:EmitSound(sound_hit)

		-- Play hit particle
		local hit_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControl(hit_pfx, 0, target:GetAbsOrigin())

		-- Iterate through the target's abilities
		local abilities_on_cooldown = 0
		for i = 0, 15 do
			local current_ability = target:GetAbilityByIndex(i)
			if current_ability then
				if current_ability:IsCooldownReady() then
					current_ability:StartCooldown(cooldown_start)
				else
					current_ability:StartCooldown( current_ability:GetCooldownTimeRemaining() + cooldown_increase )
					abilities_on_cooldown = abilities_on_cooldown + 1
				end
			end
		end

		-- Apply slow according to how many abilities were affected
		if abilities_on_cooldown > 0 then
			AddStacks(ability, caster, target, modifier_slow, abilities_on_cooldown, true)
		end

		-- Add abilities affected to the total count
		abilities_affected = abilities_affected + abilities_on_cooldown
	end

	-- Grant bonuses, if applicable
	if abilities_affected > 0 then
		AddStacks(ability, caster, caster, modifier_buff, abilities_affected, true)
	end
end

function TimeLock( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_bash = keys.sound_bash
	local particle_chrono = keys.particle_chrono
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
	local target_loc = target:GetAbsOrigin()

	-- Roll for bash chance
	if RandomInt(1, 100) <= bash_chance then

		-- Fire sound effect
		target:EmitSound(sound_bash)

		-- Find units inside the chrono
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, bash_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		
		-- Perform bash
		for _,enemy in pairs(enemies) do

			-- Fire particle
			local chrono_pfx = ParticleManager:CreateParticle(particle_chrono, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(chrono_pfx, 0, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControl(chrono_pfx, 1, Vector(40, 40, 0))

			-- Destroy particle after [bash_duration]
			Timers:CreateTimer(bash_duration, function()
				ParticleManager:DestroyParticle(chrono_pfx, false)
			end)

			-- Double damage if the target is inside a chrono
			if enemy:HasModifier("modifier_faceless_void_chronosphere_freeze") then
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = bash_damage * 2, damage_type = DAMAGE_TYPE_MAGICAL})
			else
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = bash_damage, damage_type = DAMAGE_TYPE_MAGICAL})
			end

			-- Apply bash modifier
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_faceless_void_chronosphere_freeze", {duration = bash_duration})
		end
	end
end

function Timelord( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	
	-- Parameters
	local maximum_as = ability:GetLevelSpecialValueFor("maximum_as", ability_level)

	-- Increase attack speed cap
	IncreaseAttackSpeedCap(caster, maximum_as)
end

function TimelordStrike( keys )
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local cooldown_increase = ability:GetLevelSpecialValueFor("cooldown_increase", ability_level)

	-- If a hero was damaged, increase all its ability cooldowns
	if target:IsRealHero() then
		for i = 0, 15 do
			local current_ability = target:GetAbilityByIndex(i)
			if current_ability and not current_ability:IsCooldownReady() then
				current_ability:StartCooldown( current_ability:GetCooldownTimeRemaining() + cooldown_increase )
			end
		end
	end
end

function TimelordEnd( keys )
	local caster = keys.caster

	-- Revert attack speed cap
	RevertAttackSpeedCap(caster)
end

function TimelordUpgrade( keys )
	local caster = keys.caster
	local ability_timelord = caster:FindAbilityByName(keys.ability_timelord)

	-- Upgrade the Timelord ability
	if ability_timelord then
		ability_timelord:SetLevel(ability_timelord:GetLevel() + 1)
	end
end

function Chronosphere( keys )
	local caster = keys.caster
	local chrono_center = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_za_warudo = keys.sound_za_warudo
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
	local linger_duration = ability:GetLevelSpecialValueFor("linger_duration", ability_level)

	-- Fetch caster mana
	local mana_cost = ability:GetManaCost(-1)
	local caster_mana = caster:GetMana()

	-- Apply diminishing returns to caster's mana pool
	if caster_mana > 1000 then
		caster_mana = 1000 + (caster_mana - 1000) * 0.5
	end

	-- Calculate final chronosphere parameters
	local total_radius = base_radius + extra_radius * caster_mana / mana_cost / FRANTIC_MULTIPLIER
	local total_duration = base_duration + extra_duration * caster_mana / mana_cost / FRANTIC_MULTIPLIER

	-- Spend mana
	caster:SpendMana(caster:GetMana(), ability)

	-- Create flying vision node
	ability:CreateVisibilityNode(chrono_center, total_radius, total_duration)

	-- Create particle
	local chrono_pfx = ParticleManager:CreateParticle(particle_chrono, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(chrono_pfx, 0, chrono_center)
	ParticleManager:SetParticleControl(chrono_pfx, 1, Vector(total_radius, total_radius, 0))

	-- Decide which cast sound to play
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), chrono_center, nil, total_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
	if #heroes >= IMBA_PLAYERS_ON_GAME * 0.35 then
		EmitGlobalSound(sound_za_warudo)
	else
		caster:EmitSound(sound_cast)
	end

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
				unit:AddNewModifier(caster, ability, "modifier_imba_chronosphere_ally_slow", {duration = linger_duration})
			else
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_faceless_void_chronosphere_freeze", {duration = linger_duration})
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