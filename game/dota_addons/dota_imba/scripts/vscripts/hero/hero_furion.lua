--[[
	Author: Noya
	Editor: AtroCty
	Date: 25.01.2015
	Edited: 21.12.2016
	Latches the tree_cut keys to spawn treants up to the amount of trees destroyed, limited by the ability rank.
]]
function ForceOfNature( keys )
	local caster = keys.caster
	local pID = keys.caster:GetPlayerID()
	local ability = keys.ability
	local point = keys.target_points[1]
	local area_of_effect = ability:GetLevelSpecialValueFor("area_of_effect", ability:GetLevel() - 1 )
	local max_treants = ability:GetLevelSpecialValueFor("max_treants", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local unit_name = keys.UnitName
	local treant_health = ability:GetLevelSpecialValueFor("treant_health", ability:GetLevel() - 1 )
	local treant_health_extra = ability:GetLevelSpecialValueFor("treant_health_extra", ability:GetLevel() - 1 )
	local treant_min_dmg = ability:GetLevelSpecialValueFor("treant_min_dmg", ability:GetLevel() - 1 )
	local treant_min_dmg_extra = ability:GetLevelSpecialValueFor("treant_min_dmg_extra", ability:GetLevel() - 1 )
	local treant_max_dmg = ability:GetLevelSpecialValueFor("treant_max_dmg", ability:GetLevel() - 1 )
	local treant_max_dmg_extra = ability:GetLevelSpecialValueFor("treant_max_dmg_extra", ability:GetLevel() - 1 )
	
	local unique_talent = caster:FindAbilityByName("special_bonus_unique_furion"):GetLevel()
	
	-- Reinitialize the trees cut count
	ability.trees_cut = 0

	-- Check if listener is already running
	if not ability.listenerRunning then
		ability.listenerRunning = true
		ListenToGamekeys( "tree_cut", 
			function( keys )
				ability.trees_cut = ability.trees_cut + 1
				--print(ability,"One tree cut")	
			end, 
		nil	)
	end

	-- Play the particle
	local particleName = "particles/units/heroes/hero_furion/furion_force_of_nature_cast.vpcf"
	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( particle1, 0, point )
	ParticleManager:SetParticleControl( particle1, 1, point )
	ParticleManager:SetParticleControl( particle1, 2, Vector(area_of_effect,0,0) )
	
	if unique_talent > 0 then
		treant_health = treant_health + treant_health_extra
		treant_min_dmg = treant_min_dmg + treant_min_dmg_extra
		treant_max_dmg = treant_max_dmg + treant_max_dmg_extra
	end
		
	-- Create the units on the next frame
	Timers:CreateTimer(0.03,
		function() 
			--print(ability.trees_cut)
			local treants_spawned = max_treants
			if ability.trees_cut < max_treants then
				treants_spawned = ability.trees_cut
			end

			-- Spawn as many treants as possible
			for i=1,treants_spawned do
				local treant = CreateUnitByName(unit_name, point, true, caster, caster, caster:GetTeamNumber())
				treant:SetControllableByPlayer(pID, true)
				treant:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
				FindClearSpaceForUnit(treant, point, true)
				
				-- Set damage + health
				SetCreatureHealth(treant, treant_health, true)
				treant:SetBaseDamageMin(treant_min_dmg)
				treant:SetBaseDamageMax(treant_max_dmg)
			end
		end
	)
end

--[[
	Author: Noya
	Editor: AtroCty
	Date: 25.01.2015
	Edited: 21.12.2016
	Bounces from the main point/target to other targets visible on the map
	Every bounce does increased damage and has a delay between the next jump
	TODO: Find out the visibility issues.
]]
function WrathOfNature( keys )
	local DEBUG = true
	local caster = keys.caster -- the hero
	local thinker = keys.target -- the thinker, point where the abilty was clicked
	local ability = keys.ability
	local abilityTargetType = ability:GetAbilityTargetType()
	local abilityDamageType = ability:GetAbilityDamageType()

	local max_targets = ability:GetLevelSpecialValueFor("max_targets", ability:GetLevel()-1)
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel()-1)
	local damage_percent_add = ability:GetSpecialValueFor("damage_percent_add") * 0.01
	local jump_delay = ability:GetSpecialValueFor("jump_delay")
	local particleName = "particles/units/heroes/hero_furion/furion_wrath_of_nature.vpcf"
	-- Control points
	-- CP0 Origin
	-- CP1 Jump1
	-- CP2 Origin2
	-- CP3 Jump2
	-- CP4 Hit

	print(point,thinker:GetUnitName(),caster:GetUnitName())

	-- Get the first target
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, 
									   abilityTargetType, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		if not enemies then
			print("No enemies on the map")
			return
		end
	else
		enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, 
									   abilityTargetType, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	end

	-- Filter for visible enemies (necessary? desirable?)
	local visible_enemies = {}
	for _,enemy in pairs(enemies) do
		if enemy:CanEntityBeSeenByMyTeam(caster) == true then
			table.insert(visible_enemies, enemy)
		end
	end

	-- Main target first. 
	-- Deal damage and play particle
	local target_number = 1
	local main_target = visible_enemies[target_number]
	local damage_table = {}
	damage_table.victim = main_target
	damage_table.attacker = caster					
	damage_table.damage_type = abilityDamageType
	damage_table.damage = damage

	ApplyDamage(damage_table)
	local targets_hit = 1
	if DEBUG then print("Wrath hit Number "..targets_hit..": "..damage_table.victim:GetUnitName().." for "..damage_table.damage) end

	-- Keep track of the previous target to set the particle origin on next jump
	local previous_target = main_target

	-- Do bounces from the main target to closest targets
	Timers:CreateTimer(DoUniqueString("WrathOfNature"), {
		callback = function()
	
			-- Increment target iterator
			target_number = target_number + 1

			-- Jump to this target if its possible
			local next_target = visible_enemies[target_number]
			if next_target and IsValidEntity(next_target) and next_target:CanEntityBeSeenByMyTeam(caster) then

				-- Valid target chosen
				targets_hit = targets_hit + 1

				-- Deal increased damaged
				damage_table.damage = damage_table.damage + (damage * damage_percent_add)
				damage_table.victim = next_target
				ApplyDamage(damage_table)
				if DEBUG then print("Wrath hit Number "..targets_hit..": "..damage_table.victim:GetUnitName().." for "..damage_table.damage) end

				-- Particle and sound
				local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControlEnt(particle, 0, previous_target, PATTACH_POINT_FOLLOW, "attach_hitloc", previous_target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(particle, 1, next_target, PATTACH_POINT_FOLLOW, "attach_hitloc", next_target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(particle, 2, next_target, PATTACH_POINT_FOLLOW, "attach_hitloc", next_target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(particle, 3, next_target, PATTACH_POINT_FOLLOW, "attach_hitloc", next_target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(particle, 4, next_target, PATTACH_POINT_FOLLOW, "attach_hitloc", next_target:GetAbsOrigin(), true)

				if next_target:IsRealHero() then
					next_target:EmitSound("Hero_Furion.WrathOfNature_Damage")
				else
					next_target:EmitSound("Hero_Furion.WrathOfNature_Damage.Creep")
				end

				-- Fire the timer again if there are jumps left
				if targets_hit < max_targets then
					-- Update the previous target for the next jump
					previous_target = next_target

					return jump_delay
				end
			else
				-- The target is invalid (was killed while the ability was bouncing)
				-- Fire the timer again if there are jumps left, ignoring this bounce
				if targets_hit < max_targets then
					return jump_delay
				else
					if DEBUG then print("Wrath of Nature ends after "..targets_hit.." hits") end
					return
				end
			end
		end
	})
end