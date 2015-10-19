--[[	Author: Firetoad
		Date: 26.08.2015	]]

function LandMinePlant( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_state = keys.modifier_state
	local modifier_charges = keys.modifier_charges
	local scepter = HasScepter(caster)
	
	-- Parameters
	local activation_time = ability:GetLevelSpecialValueFor("activation_time", ability_level)
	local player_id = caster:GetPlayerID()

	-- Calculate amount of mines to place
	local mine_amount = 1
	if caster:HasModifier(modifier_charges) then
		mine_amount = 1 + math.max(caster:GetModifierStackCount(modifier_charges, caster), 1)
		caster:RemoveModifierByName(modifier_charges)
	end

	-- Create the mines at the specified place
	for i = 1, mine_amount do
		local land_mine = CreateUnitByName("npc_imba_techies_land_mine", target, false, caster, caster, caster:GetTeam())
		FindClearSpaceForUnit(land_mine, target + RandomVector(10), true)
		land_mine:SetControllableByPlayer(player_id, true)

		-- Root the mine in place
		land_mine:AddNewModifier(land_mine, ability, "modifier_rooted", {})

		-- Make the mine have no unit collision or health bar
		ability:ApplyDataDrivenModifier(caster, land_mine, modifier_state, {})

		-- Wait for the activation delay
		Timers:CreateTimer(activation_time, function()
			
			-- Grant the mine the appropriately leveled abilities
			local mine_passive = land_mine:FindAbilityByName("imba_techies_land_mine_passive")
			mine_passive:SetLevel(ability_level + 1)
			if scepter then
				local mine_teleport = land_mine:FindAbilityByName("imba_techies_minefield_teleport")
				mine_teleport:SetLevel(1)
			end
		end)
	end
end

function LandMineCharges( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_charges = keys.modifier_charges
	
	-- Parameters
	local levels_per_charge = ability:GetLevelSpecialValueFor("levels_per_charge", ability_level)
	local charge_cooldown = ability:GetLevelSpecialValueFor("charge_cooldown", ability_level)
	local max_charges = math.floor( caster:GetLevel() / levels_per_charge + 1 )
	local current_charges = caster:GetModifierStackCount(modifier_charges, caster)
	local actual_cooldown = math.ceil( charge_cooldown / max_charges)

	-- If charges are already at their maximum, do nothing
	if current_charges >= max_charges then
		return nil
	end
	
	-- Initialize charge counter if necessary
	if not caster.land_mine_charge_counter then
		caster.land_mine_charge_counter = 0

	-- Increment the timer and add charges if appropriate
	else
		caster.land_mine_charge_counter = caster.land_mine_charge_counter + 1
		if caster.land_mine_charge_counter >= actual_cooldown then
			
			-- Reset timer
			caster.land_mine_charge_counter = 0

			-- If possible, add a charge
			AddStacks(ability, caster, caster, modifier_charges, 1, true)
		end
	end
end

function LandMineThrow( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local throw_sound = keys.throw_sound
	local modifier_state = keys.modifier_state
	local scepter = HasScepter(caster)
	
	-- Parameters
	local activation_time = ability:GetLevelSpecialValueFor("activation_time", ability_level)
	local throw_chance = ability:GetLevelSpecialValueFor("throw_chance", ability_level)
	local throw_speed = ability:GetLevelSpecialValueFor("throw_speed", ability_level)
	local player_id = caster:GetPlayerID()
	local step_duration = 0.03

	-- Verify proc condition
	if RandomInt(1, 100) > throw_chance or not target:IsAlive() or target:GetTeam() == caster:GetTeam() then
		return nil
	end

	-- Create the mine at the specified place
	local land_mine = CreateUnitByName("npc_imba_techies_land_mine", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeam())
	land_mine:SetControllableByPlayer(player_id, true)

	-- Root the mine in place
	land_mine:AddNewModifier(land_mine, ability, "modifier_rooted", {})

	-- Make the mine have no unit collision or health bar
	ability:ApplyDataDrivenModifier(caster, land_mine, modifier_state, {})

	-- Play sound
	caster:EmitSound(throw_sound)

	-- Move the mine towards the target
	Timers:CreateTimer(0, function()

		-- Update geometry
		local mine_pos = land_mine:GetAbsOrigin()
		local target_pos = target:GetAbsOrigin()
		local new_pos = mine_pos + ( target_pos - mine_pos ):Normalized() * throw_speed * step_duration

		-- If close enough to the target, stop
		if ( target_pos - new_pos ):Length2D() < ( throw_speed * step_duration ) then
			
			-- Update position
			land_mine:SetAbsOrigin(target_pos)

			-- Activate the mine
			Timers:CreateTimer(activation_time, function()
				
				-- Grant the mine the appropriately leveled abilities
				local mine_passive = land_mine:FindAbilityByName("imba_techies_land_mine_passive")
				mine_passive:SetLevel(ability_level + 1)
				if scepter then
					local mine_teleport = land_mine:FindAbilityByName("imba_techies_minefield_teleport")
					mine_teleport:SetLevel(1)
				end
			end)

		-- If not, update position and keep going
		else
			land_mine:SetAbsOrigin(new_pos)
			return step_duration
		end
	end)
end

function LandMineThink( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_slow = keys.modifier_slow
	local scepter = HasScepter(caster:GetOwnerEntity())

	-- Parameters
	local small_radius = ability:GetLevelSpecialValueFor("small_radius", ability_level)
	local big_radius = ability:GetLevelSpecialValueFor("big_radius", ability_level)
	local think_interval = ability:GetLevelSpecialValueFor("think_interval", ability_level)

	-- Apply 100% slow modifier
	AddStacks(ability, caster, caster, modifier_slow, 80, true)

	-- Constantly check for nearby enemies
	Timers:CreateTimer(0, function()
		
		-- Find nearby enemies
		local near_units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, small_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		local far_units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, big_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

		-- If any enemy hero is inside the far blast range, move towards it
		if #far_units > 0 then
			caster:RemoveModifierByName("modifier_rooted")
			caster:MoveToPosition(far_units[1]:GetAbsOrigin())
			if scepter then
				AddStacks(ability, caster, caster, modifier_slow, -2, true)
			else
				AddStacks(ability, caster, caster, modifier_slow, -1, true)
			end
		end

		-- If any enemy is inside the small blast range, explode
		local should_explode = false
		for _,unit in pairs(near_units) do
			if unit:GetName() ~= "npc_dota_courier" then
				should_explode = true
			end
		end
		if should_explode then
			caster:ForceKill(false)
		else
			return think_interval
		end
	end)
end

function LandMineExplode( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_explode = keys.sound_explode
	local particle_explode = keys.particle_explode
	local modifier_invis = keys.modifier_invis
	local scepter = HasScepter(caster:GetOwnerEntity())

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local bonus_damage_scepter = ability:GetLevelSpecialValueFor("bonus_damage_scepter", ability_level)
	local small_radius = ability:GetLevelSpecialValueFor("small_radius", ability_level)
	local big_radius = ability:GetLevelSpecialValueFor("big_radius", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)
	local caster_loc = caster:GetAbsOrigin()

	-- Make the mine visible
	caster:RemoveModifierByName(modifier_invis)

	-- Create flying vision node
	ability:CreateVisibilityNode(caster_loc, vision_radius, vision_duration)

	-- Play sound
	caster:EmitSound(sound_explode)

	-- Fire particle
	local explosion_pfx = ParticleManager:CreateParticle(particle_explode, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(explosion_pfx, 0, caster:GetAbsOrigin())
		
	-- Find nearby enemies
	local near_units = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, small_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	local far_units = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, big_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

	-- Damage small radius enemies
	for _,enemy in pairs(near_units) do
		if scepter then
			ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = (damage + enemy:GetMaxHealth() * bonus_damage_scepter / 100), damage_type = DAMAGE_TYPE_PHYSICAL})
		else
			ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
		end
	end

	-- Damage large radius enemies
	for _,enemy in pairs(far_units) do

		-- Check if this enemy was already damaged
		local already_damaged = false
		for _,damaged_enemy in pairs(near_units) do
			if enemy == damaged_enemy then
				already_damaged = true
			end
		end

		-- If not, apply half damage
		if not already_damaged then
			if scepter then
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = (damage / 2 + enemy:GetMaxHealth() * bonus_damage_scepter / 200), damage_type = DAMAGE_TYPE_PHYSICAL})
			else
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage / 2, damage_type = DAMAGE_TYPE_PHYSICAL})
			end
		end
	end

	-- Destroy mine after the animation plays out
	Timers:CreateTimer(0.6, function()
		caster:Destroy()
	end)
end

function StasisTrapPlant( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_state = keys.modifier_state
	local modifier_creep = keys.modifier_creep
	local particle_cast = keys.particle_cast
	local particle_creep = keys.particle_creep
	local scepter = HasScepter(caster)
	
	-- Parameters
	local activation_delay = ability:GetLevelSpecialValueFor("activation_delay", ability_level)
	local player_id = caster:GetPlayerID()

	-- If a creep is near the target point, apply the mine modifier to it
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, 150, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_SUMMONED, FIND_CLOSEST, false)
	if creeps[1] then

		-- Activate the trap modifier
		Timers:CreateTimer(activation_delay, function()
			ability:ApplyDataDrivenModifier(caster, creeps[1], modifier_creep, {})
		end)

		-- Fire initial particle for the caster's team
		local trap_start_pfx = ParticleManager:CreateParticleForTeam(particle_creep, PATTACH_ABSORIGIN_FOLLOW, caster, caster:GetTeam())
		ParticleManager:SetParticleControl(trap_start_pfx, 0, creeps[1]:GetAbsOrigin())
		ParticleManager:SetParticleControl(trap_start_pfx, 1, creeps[1]:GetAbsOrigin())
		ParticleManager:SetParticleControl(trap_start_pfx, 2, Vector(1, 0, 0))

		Timers:CreateTimer(1, function()

			-- Continuously fire stasis trap particle for the caster's team
			local trap_pfx = ParticleManager:CreateParticleForTeam(particle_creep, PATTACH_ABSORIGIN_FOLLOW, creeps[1], caster:GetTeam())
			ParticleManager:SetParticleControl(trap_pfx, 0, creeps[1]:GetAbsOrigin())
			ParticleManager:SetParticleControl(trap_pfx, 1, creeps[1]:GetAbsOrigin() + Vector(0, 0, creeps[1]:GetModelRadius()))
			ParticleManager:SetParticleControl(trap_pfx, 2, Vector(1, 0, 0))

			-- If the trap is still active, keep firing the particle
			if creeps[1]:HasModifier(modifier_creep) then
				return 0.5
			end
		end)

		-- Exit the function
		return nil
	end

	-- Play the post-cast spawn animation
	local trap_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(trap_pfx, 0, target)
	ParticleManager:SetParticleControl(trap_pfx, 1, target)

	-- Wait for the activation delay
	Timers:CreateTimer(activation_delay, function()

		-- Create the mine at the specified place
		local stasis_trap = CreateUnitByName("npc_imba_techies_stasis_trap", target, false, caster, caster, caster:GetTeam())
		stasis_trap:SetControllableByPlayer(player_id, true)

		-- Root the mine in place
		stasis_trap:AddNewModifier(stasis_trap, ability, "modifier_rooted", {})

		-- Make the mine have no unit collision or health bar
		ability:ApplyDataDrivenModifier(caster, stasis_trap, modifier_state, {})
			
		-- Grant the mine the appropriately leveled abilities
		local trap_passive = stasis_trap:FindAbilityByName("imba_techies_stasis_trap_passive")
		trap_passive:SetLevel(ability_level + 1)
		if scepter then
			local trap_teleport = stasis_trap:FindAbilityByName("imba_techies_minefield_teleport")
			trap_teleport:SetLevel(1)
		end
	end)
end

function StasisTrapThink( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local think_type = keys.think_type
	local modifier_creep = keys.modifier_creep
	local particle_creep = keys.particle_creep
	local sound_creep = keys.sound_creep

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local explosion_delay = ability:GetLevelSpecialValueFor("explosion_delay", ability_level)
	local think_interval = ability:GetLevelSpecialValueFor("think_interval", ability_level)

	-- Constantly check for nearby enemies
	Timers:CreateTimer(0, function()
		
		-- Find nearby enemies
		local near_units
		if think_type == "mine" then
			near_units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		elseif think_type == "creep" then
			local creep = keys.target
			near_units = FindUnitsInRadius(caster:GetTeamNumber(), creep:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		end
		
		-- If any enemy is inside the small blast range, explode
		if #near_units > 0 then

			-- Explosion delay
			if think_type == "mine" then
				Timers:CreateTimer(explosion_delay, function()
					caster:ForceKill(false)
				end)
			elseif think_type == "creep" then
				local creep = keys.target

				-- Play particle and sound to warn of explosion
				creep:EmitSound(sound_creep)
				local trap_pfx = ParticleManager:CreateParticle(particle_creep, PATTACH_ABSORIGIN_FOLLOW, near_units[1])
				ParticleManager:SetParticleControl(trap_pfx, 0, creep:GetAbsOrigin())
				ParticleManager:SetParticleControl(trap_pfx, 1, creep:GetAbsOrigin() + Vector(0, 0, creep:GetModelRadius()))
				ParticleManager:SetParticleControl(trap_pfx, 2, Vector(1, 0, 0))

				Timers:CreateTimer(explosion_delay, function()
					creep:RemoveModifierByName(modifier_creep)
				end)
			end
		else
			return think_interval
		end
	end)
end

function StasisTrapExplode( keys )
	local caster = keys.caster
	local caster_owner = caster:GetOwnerEntity()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_explode = keys.sound_explode
	local particle_explode = keys.particle_explode
	local particle_emp = keys.particle_emp
	local modifier_invis = keys.modifier_invis
	local modifier_stun = keys.modifier_stun
	local scepter = HasScepter(caster_owner)

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local secondary_radius = ability:GetLevelSpecialValueFor("secondary_radius", ability_level)
	local secondary_delay = ability:GetLevelSpecialValueFor("secondary_delay", ability_level)
	local mana_burn_scepter = ability:GetLevelSpecialValueFor("mana_burn_scepter", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)
	local caster_loc = caster:GetAbsOrigin()

	-- Make the mine visible
	caster:RemoveModifierByName(modifier_invis)

	-- Create flying vision node
	ability:CreateVisibilityNode(caster_loc, vision_radius, vision_duration)

	-- Play sound
	caster:EmitSound(sound_explode)

	-- Fire particle
	local explosion_pfx = ParticleManager:CreateParticle(particle_explode, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(explosion_pfx, 0, caster_loc)
		
	-- Find nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

	-- Stun all valid enemy targets
	for _,enemy in pairs(enemies) do
		if scepter then
			enemy:ReduceMana(mana_burn_scepter)
		end
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_stun, {})
	end

	-- Initialize chain reaction
	local hit_units = {}
	if enemies[1] then
		hit_units[1] = enemies[1]
	end

	-- Chain reaction loop
	if enemies[2] then
		local current_enemy = enemies[2]
		Timers:CreateTimer(secondary_delay, function()

			-- Update chain reaction targets
			enemies = FindUnitsInRadius(caster_owner:GetTeamNumber(), current_enemy:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			local chain_continue = false

			-- Test if the chain reaction must continue
			for i = 1, #enemies do
				local already_hit = false
				for j = 1, #hit_units do
					if enemies[i] == hit_units[j] then
						already_hit = true
					end
				end
				if not already_hit then
					chain_continue = true
					current_enemy = enemies[i]
				end
			end

			-- Continue the reaction
			if chain_continue then

				-- Add new explosion center to the list of units already hit
				hit_units[#hit_units + 1] = current_enemy

				-- Create flying vision node
				ability:CreateVisibilityNode(current_enemy:GetAbsOrigin(), vision_radius, vision_duration)

				-- Play sound
				current_enemy:EmitSound(sound_explode)

				-- Fire particle
				local chain_reaction_pfx = ParticleManager:CreateParticle(particle_explode, PATTACH_ABSORIGIN, current_enemy)
				ParticleManager:SetParticleControl(chain_reaction_pfx, 0, current_enemy:GetAbsOrigin())

				-- Find nearby enemies
				local chain_enemies = FindUnitsInRadius(caster_owner:GetTeamNumber(), current_enemy:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

				-- Stun all valid enemy targets
				for _,enemy in pairs(chain_enemies) do
					if scepter then
						enemy:ReduceMana(mana_burn_scepter)
					end
					ability:ApplyDataDrivenModifier(caster_owner, enemy, modifier_stun, {})
				end

				-- Keep the chain reaction going
				return secondary_delay
			end
		end)
	end
end

function StasisTrapExplodeCreep( keys )
	local caster = keys.caster
	local creep = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_explode = keys.sound_explode
	local particle_explode = keys.particle_explode
	local particle_emp = keys.particle_emp
	local modifier_stun = keys.modifier_stun
	local scepter = HasScepter(caster)

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local secondary_radius = ability:GetLevelSpecialValueFor("secondary_radius", ability_level)
	local secondary_delay = ability:GetLevelSpecialValueFor("secondary_delay", ability_level)
	local mana_burn_scepter = ability:GetLevelSpecialValueFor("mana_burn_scepter", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)
	local creep_loc = creep:GetAbsOrigin()

	-- Create flying vision node
	ability:CreateVisibilityNode(creep_loc, vision_radius, vision_duration)

	-- Play sound
	creep:EmitSound(sound_explode)

	-- Fire particle
	local explosion_pfx = ParticleManager:CreateParticle(particle_explode, PATTACH_ABSORIGIN, creep)
	ParticleManager:SetParticleControl(explosion_pfx, 0, creep_loc)
		
	-- Find nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), creep_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

	-- Stun all valid enemy targets
	for _,enemy in pairs(enemies) do
		if scepter then
			enemy:ReduceMana(mana_burn_scepter)
		end
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_stun, {})
	end

	-- Initialize chain reaction
	local hit_units = {}
	if enemies[1] then
		hit_units[1] = enemies[1]
	end

	-- Chain reaction loop
	if enemies[2] then
		local current_enemy = enemies[2]
		Timers:CreateTimer(secondary_delay, function()

			-- Update chain reaction targets
			enemies = FindUnitsInRadius(caster:GetTeamNumber(), current_enemy:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			local chain_continue = false

			-- Test if the chain reaction must continue
			for i = 1, #enemies do
				local already_hit = false
				for j = 1, #hit_units do
					if enemies[i] == hit_units[j] then
						already_hit = true
					end
				end
				if not already_hit then
					chain_continue = true
					current_enemy = enemies[i]
				end
			end

			-- Continue the reaction
			if chain_continue then

				-- Add new explosion center to the list of units already hit
				hit_units[#hit_units + 1] = current_enemy

				-- Create flying vision node
				ability:CreateVisibilityNode(current_enemy:GetAbsOrigin(), vision_radius, vision_duration)

				-- Play sound
				current_enemy:EmitSound(sound_explode)

				-- Fire particle
				local chain_reaction_pfx = ParticleManager:CreateParticle(particle_explode, PATTACH_ABSORIGIN, current_enemy)
				ParticleManager:SetParticleControl(chain_reaction_pfx, 0, current_enemy:GetAbsOrigin())

				-- Find nearby enemies
				local chain_enemies = FindUnitsInRadius(caster:GetTeamNumber(), current_enemy:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

				-- Stun all valid enemy targets
				for _,enemy in pairs(chain_enemies) do
					if scepter then
						enemy:ReduceMana(mana_burn_scepter)
					end
					ability:ApplyDataDrivenModifier(caster, enemy, modifier_stun, {})
				end

				-- Keep the chain reaction going
				return secondary_delay
			end
		end)
	end
end

function RemoteMineAutoCreep( keys )
	local mine = keys.caster
	local caster = mine:GetOwnerEntity()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local auto_hero_ability = mine:FindAbilityByName("imba_techies_remote_auto_hero")
	local modifier_unselect = keys.modifier_unselect
	local sound_cast = keys.sound_cast

	local radius = ability:GetLevelSpecialValueFor("radius", ability_level) * 0.6

	-- Play sound
	mine:EmitSound(sound_cast)

	-- Set up auto toggle for any future mines planted
	caster.auto_creep_exploding = true
	caster.auto_hero_exploding = nil

	-- Make this mine unselectable briefly to remove it from the current unit selection
	ability:ApplyDataDrivenModifier(mine, mine, modifier_unselect, {})

	mine.auto_creep_exploding = true
	mine.auto_hero_exploding = nil

	if auto_hero_ability and auto_hero_ability:GetToggleState() then
		auto_hero_ability:ToggleAbility()
	end

	Timers:CreateTimer(0, function()
		local nearby_enemies = FindUnitsInRadius(mine:GetTeamNumber(), mine:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if #nearby_enemies > 0 then
			mine:ForceKill(false)
			mine.auto_creep_exploding = nil
		end
		if mine.auto_creep_exploding then
			return 0.2
		end
	end)
end

function RemoteMineAutoHero( keys )
	local mine = keys.caster
	local caster = mine:GetOwnerEntity()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local auto_creep_ability = mine:FindAbilityByName("imba_techies_remote_auto_creep")
	local modifier_unselect = keys.modifier_unselect
	local sound_cast = keys.sound_cast

	local radius = ability:GetLevelSpecialValueFor("radius", ability_level) * 0.6

	-- Play sound
	mine:EmitSound(sound_cast)

	-- Set up auto toggle for any future mines planted
	caster.auto_hero_exploding = true
	caster.auto_creep_exploding = nil

	-- Make this mine unselectable briefly to remove it from the current unit selection
	ability:ApplyDataDrivenModifier(mine, mine, modifier_unselect, {})

	mine.auto_hero_exploding = true
	mine.auto_creep_exploding = nil

	if auto_creep_ability and auto_creep_ability:GetToggleState() then
		auto_creep_ability:ToggleAbility()
	end

	Timers:CreateTimer(0, function()
		local nearby_enemies = FindUnitsInRadius(mine:GetTeamNumber(), mine:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if #nearby_enemies > 0 then
			local self_detonate = mine:FindAbilityByName("techies_remote_mines_self_detonate")
			mine:CastAbilityImmediately(self_detonate, mine:GetOwnerEntity():GetPlayerID())
			mine.auto_hero_exploding = nil
		end
		if mine.auto_hero_exploding then
			return 0.2
		end
	end)
end

function RemoteMineAutoCreepEnd( keys )
	local mine = keys.caster
	local caster = mine:GetOwnerEntity()

	caster.auto_creep_exploding = nil
	mine.auto_creep_exploding = nil
end

function RemoteMineAutoHeroEnd( keys )
	local mine = keys.caster
	local caster = mine:GetOwnerEntity()

	caster.auto_hero_exploding = nil
	mine.auto_hero_exploding = nil
end

function MinefieldTeleport( keys )
	local mine = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local caster = mine:GetOwnerEntity()
	local modifier_unselect = keys.modifier_unselect

	-- Parameters
	local teleport_radius = ability:GetLevelSpecialValueFor("teleport_radius", ability_level)

	-- Teleport mine to the minefield, if it exists
	if caster.minefield_sign then

		-- Find nearby mines
		local units = FindUnitsInRadius(caster:GetTeamNumber(), mine:GetAbsOrigin(), nil, teleport_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,unit in pairs(units) do

			-- Check if this unit is really a mine from the same player
			if unit:FindAbilityByName("imba_techies_minefield_teleport") and unit:GetOwnerEntity() == caster then
				unit:SetAbsOrigin(caster.minefield_sign:GetAbsOrigin() + RandomVector(RandomInt(1,60)))
			end
		end

		-- Make this mine unselectable briefly to remove it from the current unit selection
		ability:ApplyDataDrivenModifier(mine, mine, modifier_unselect, {})
	end
end

function MinefieldSign( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_passive = keys.modifier_passive
	local modifier_scepter = keys.modifier_scepter
	local scepter = HasScepter(caster)
	
	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)

	-- If too close to a building, do nothing and refresh cooldown
	local nearby_buildings = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	if #nearby_buildings > 0 or IsNearEnemyClass(caster, 2000, "ent_dota_fountain") then
		ability:EndCooldown()
		return nil
	end

	-- Create the sign at the specified place
	if caster.minefield_sign then
		caster.minefield_sign:Destroy()
	end
	caster.minefield_sign = CreateUnitByName("npc_imba_techies_minefield_sign", target, false, caster, caster, caster:GetTeam())

	-- Make the sign invulnerable, etc.
	ability:ApplyDataDrivenModifier(caster, caster.minefield_sign, modifier_passive, {})

	-- Constantly apply anti-invisibility modifier if the caster has a scepter
	Timers:CreateTimer(0, function()
		if scepter then

			-- Find nearby mines
			local nearby_mines = Entities:FindAllByNameWithin("npc_dota_techies_mines", target, radius)

			-- Apply anti-truesight modifier
			for _,mine in pairs(nearby_mines) do
				ability:ApplyDataDrivenModifier(caster, mine, modifier_scepter, {})
			end
		end
		
		-- If the sign's position changes, stop this loop
		if caster.minefield_sign:GetAbsOrigin() == target then
			return 0.5
		end
	end)
end