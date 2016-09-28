--[[	Author: AtroCty
		Date: 
		13.09.2016
		Last Update:	
		13.09.2016	]]

function Sunder( keys )
	local caster = keys.caster
	local playerID = caster:GetPlayerID()
	local target = keys.target
	local ability = keys.ability
	local caster_pos = caster:GetAbsOrigin()
	local hit_point_minimum_pct = ability:GetLevelSpecialValueFor( "hit_point_minimum_pct", ability:GetLevel() - 1 ) * 0.01
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local radius_scepter = ability:GetLevelSpecialValueFor( "radius_scepter", ability:GetLevel() - 1 )
	local scepter = HasScepter(caster)
	local sound_target = keys.sound_target
	local sound_caster = keys.sound_caster
	
	-- Set Scepter-Radius
	if scepter then radius = radius_scepter end
	
	-- Find nearby allies
	local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos , nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
		
	-- Remove the caster from the table--
	for k, v in pairs( nearby_allies ) do
		if v==caster then 
			table.remove( nearby_allies, k ) 
			break
		end
	end
	
	-- Count Illusions for Scepter
	local illusions = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos , nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local nearby_illusions = {}
	
	for _,v in pairs( illusions ) do
		if v:GetPlayerID() == playerID and v:IsIllusion() then
			table.insert( nearby_illusions, v )
		end
	end

	-- Find nearby enemies
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	-- Steal the highest HP from everyone
	local caster_maxHealth = caster:GetMaxHealth()
	local highest_HP_percent = caster:GetHealth() / caster_maxHealth
	local highest_target = caster
	
	local units
	local compare_table_ally = {}
	local compare_table_enemies = {}
	local target_HP_percent
	for i = 1, 3 do
		if 	   i==1 then units = nearby_allies
		elseif i==2 then units = nearby_enemies
		elseif i==3 then units = nearby_illusions
		end
		for _, units in pairs( units ) do
			target_HP_percent = units:GetHealth() / units:GetMaxHealth()
			
			-- Add allies to list for comparison
			if (i==1) or ((i == 3) and scepter)  then
				table.insert(compare_table_ally, target_HP_percent)
			end
			
			if (i==2) then
				table.insert(compare_table_enemies, target_HP_percent)
			end
		end
	end
	
	-- Table in descending order by HP
	for k,v in spairs(compare_table_enemies, function(t,a,b) return t[b] < t[a] end) do
		-- Comparison for TB best result (enemies first if they have the same ratio)
		target_HP_percent = nearby_enemies[k]:GetHealth() / nearby_enemies[k]:GetMaxHealth()
		if highest_HP_percent < target_HP_percent then
			highest_HP_percent = target_HP_percent
			highest_target = nearby_enemies[k]
		end
		break
	end
	
	local j = 0
	for k,v in spairs(compare_table_ally, function(t,a,b) return t[b] < t[a] end) do
		-- Comparison for TB best result (ally & (Aghs)Illusions afterwards)
		if (k <= #nearby_allies) then
			target_HP_percent = nearby_allies[k]:GetHealth() / nearby_allies[k]:GetMaxHealth()
		else
			j = k - #nearby_allies
			target_HP_percent = ( ( nearby_illusions[j]:GetHealth() ) / ( nearby_illusions[j]:GetMaxHealth() ) )
		end
		if highest_HP_percent < target_HP_percent then
			highest_HP_percent = target_HP_percent
			if j == 0 then
				highest_target = nearby_allies[k]
			else
				highest_target = nearby_illusions[j]
			end
		end
		break
	end
	
	if not (highest_target["__self"] == caster["__self"]) then
		SunderTarget( caster, highest_target, hit_point_minimum_pct, sound_caster, sound_target)
	end

	-- Counts the number of possible casts
	local count = math.abs(#compare_table_enemies - #compare_table_ally)
	if count == nil then count = 0 end
	if (#compare_table_ally >= #compare_table_enemies) then
		count = #compare_table_ally - count
	else
		count = #compare_table_enemies - count
	end
	
	local sunder_caster
	local sunder_target
	local caster_HP_percent
	-- Give Allies the best lives
	for i = 1, count do
		for ka,va in spairs(compare_table_ally, function(t1,a1,b1) return t1[b1] > t1[a1] end) do
			for ke,ve in spairs(compare_table_enemies, function(t2,a2,b2) return t2[b2] < t2[a2] end) do
				if (ka <= #nearby_allies) then
					sunder_caster = nearby_allies[ka]
					sunder_target = nearby_enemies[ke]
					
					caster_HP_percent = sunder_caster:GetHealth() / sunder_caster:GetMaxHealth()
					target_HP_percent = sunder_target:GetHealth() / sunder_target:GetMaxHealth()
						
					if caster_HP_percent < target_HP_percent then
						SunderTarget( sunder_caster, sunder_target, hit_point_minimum_pct, sound_caster, sound_target)
						break
					end
				else
					sunder_caster = nearby_illusions[ka-#nearby_allies]
					sunder_target = nearby_enemies[ke]

					caster_HP_percent = sunder_caster:GetHealth() / sunder_caster:GetMaxHealth()
					target_HP_percent = sunder_target:GetHealth() / sunder_target:GetMaxHealth()
						
					if caster_HP_percent < target_HP_percent then
						SunderTarget( sunder_caster, sunder_target, hit_point_minimum_pct, sound_caster, sound_target)
						break
					end
				end
			end
		end
	end
end

-- Do Sunder on targets
function SunderTarget( caster, target, hit_point_minimum_pct , sound_caster, sound_target)
	local caster_maxHealth = caster:GetMaxHealth()
	local target_maxHealth = target:GetMaxHealth()
	local casterHP_percent = caster:GetHealth() / caster_maxHealth
	local targetHP_percent = target:GetHealth() / target_maxHealth

	-- Swap the HP of the caster
	if targetHP_percent <= hit_point_minimum_pct then
		caster:SetHealth(caster_maxHealth * hit_point_minimum_pct)
	else
		caster:SetHealth(caster_maxHealth * targetHP_percent)
	end

	-- Swap the HP of the target
	if casterHP_percent <= hit_point_minimum_pct then
		target:SetHealth(target_maxHealth * hit_point_minimum_pct)
	else
		target:SetHealth(target_maxHealth * casterHP_percent)
	end
	-- Show the particle caster-> target
	local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"	
	local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, target )

	ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

	-- Show the particle target-> caster
	local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"	
	local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )

	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	
	-- Emit sound
	caster:EmitSound(sound_caster)
	target:EmitSound(sound_target)
end