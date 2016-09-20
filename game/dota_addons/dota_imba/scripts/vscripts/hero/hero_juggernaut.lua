--[[	Author: Firetoad
		Date: 18.08.2016	]]

function Bladefury( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_caster = keys.modifier_caster

	-- Purge debuffs
	caster:Purge(false, true, false, false, false)	
	
	-- Apply bladefury modifier to the caster
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})

	-- Play cast lines
	local rand = RandomInt(2, 9)
	if (rand >= 2 and rand <= 3) or (rand >= 5 and rand <= 9) then
		caster:EmitSound("juggernaut_jug_ability_bladefury_0"..rand)
	elseif rand >= 10 and rand <= 18 then
		caster:EmitSound("Imba.JuggernautBladeFury"..rand)
	end
end

function BladefuryTick( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_hit = keys.particle_hit
	local sound_hit = keys.sound_hit
	local modifier_debuff = keys.modifier_debuff
	
	-- Parameters
	local effect_radius = ability:GetLevelSpecialValueFor("effect_radius", ability_level)
	local damage_per_sec = ability:GetLevelSpecialValueFor("damage_per_sec", ability_level)
	local damage_tick = ability:GetLevelSpecialValueFor("damage_tick", ability_level)
	local damage = damage_per_sec * damage_tick
	local caster_loc = caster:GetAbsOrigin()

	-- Iterate through nearby enemies
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, effect_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(nearby_enemies) do
		
		-- Play hit sound
		enemy:EmitSound(sound_hit)

		-- Play hit particle
		local slash_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(slash_pfx, 0, enemy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(slash_pfx)

		-- Apply slow modifier
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff, {})

		-- Deal damage
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end

function BladefuryParticleStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_spin = keys.particle_spin
	local sound_spin = keys.sound_spin
	
	-- Parameters
	local effect_radius = ability:GetLevelSpecialValueFor("effect_radius", ability_level)
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local caster_loc = caster:GetAbsOrigin()

	-- Start spinning animation
	StartAnimation(caster, {activity = ACT_DOTA_OVERRIDE_ABILITY_1, rate = 1.0})

	-- Start looping sound
	caster:EmitSound(sound_spin)

	-- Create particle
	caster.blade_fury_spin_pfx = ParticleManager:CreateParticle(particle_spin, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(caster.blade_fury_spin_pfx, 0, caster_loc)
	ParticleManager:SetParticleControl(caster.blade_fury_spin_pfx, 5, Vector(effect_radius * 1.33, 0, 0))
end

function BladefuryParticleEnd( keys )
	local caster = keys.caster
	local sound_spin = keys.sound_spin
	local sound_stop = keys.sound_stop

	-- Stop spinning animation
	if caster:HasModifier("modifier_imba_omni_slash_caster") then
		StartAnimation(caster, {activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.0})
	else
		EndAnimation(caster)
	end

	-- Stop looping sound
	caster:StopSound(sound_spin)

	-- Play end sound
	caster:EmitSound(sound_stop)

	-- Destroy particle
	ParticleManager:DestroyParticle(caster.blade_fury_spin_pfx, false)
	ParticleManager:ReleaseParticleIndex(caster.blade_fury_spin_pfx)
	caster.blade_fury_spin_pfx = nil
end

function HealingWard( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_loop = keys.sound_loop
	local particle_ward = keys.particle_ward
	local particle_eruption = keys.particle_eruption
	
	-- Parameters
	local health = ability:GetLevelSpecialValueFor("health", ability_level)
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local heal_radius = ability:GetLevelSpecialValueFor("heal_radius", ability_level)
	local player_id = caster:GetPlayerID()

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Spawn the Healing Ward
	local healing_ward = CreateUnitByName("npc_imba_juggernaut_healing_ward", target, false, caster, caster, caster:GetTeam())
	FindClearSpaceForUnit(healing_ward, target, true)

	-- Make the ward immediately follow its caster
	healing_ward:SetControllableByPlayer(player_id, true)
	Timers:CreateTimer(0.1, function()
		healing_ward:MoveToNPC(caster)
	end)

	-- Increase the ward's health, if appropriate
	SetCreatureHealth(healing_ward, health, true)

	-- Prevent nearby units from getting stuck
	Timers:CreateTimer(0.01, function()
		local units = FindUnitsInRadius(caster:GetTeamNumber(), healing_ward:GetAbsOrigin(), nil, 128, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _,unit in pairs(units) do
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
		end
	end)

	-- Start looping sound
	healing_ward:EmitSound(sound_loop)

	-- Play spawn particle
	local eruption_pfx = ParticleManager:CreateParticle(particle_eruption, PATTACH_CUSTOMORIGIN, healing_ward)
	ParticleManager:SetParticleControl(eruption_pfx, 0, target)
	ParticleManager:ReleaseParticleIndex(eruption_pfx)

	-- Attach ambient particle
	healing_ward.healing_ward_ambient_pfx = ParticleManager:CreateParticle(particle_ward, PATTACH_ABSORIGIN_FOLLOW, healing_ward)
	ParticleManager:SetParticleControl(healing_ward.healing_ward_ambient_pfx, 0, healing_ward:GetAbsOrigin() + Vector(0, 0, 100))
	ParticleManager:SetParticleControl(healing_ward.healing_ward_ambient_pfx, 1, Vector(heal_radius, 1, 1))
	ParticleManager:SetParticleControlEnt(healing_ward.healing_ward_ambient_pfx, 2, healing_ward, PATTACH_POINT_FOLLOW, "attach_hitloc", healing_ward:GetAbsOrigin(), true)

	-- Apply the Healing Ward duration modifier
	healing_ward:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})

	-- Grant the Healing Ward its abilities
	local ward_ability = healing_ward:FindAbilityByName("imba_juggernaut_healing_ward_passive")
	ward_ability:SetLevel(ability_level + 1)
	ward_ability = healing_ward:FindAbilityByName("imba_juggernaut_healing_ward_upgrade")
	ward_ability:SetLevel(ability_level + 1)
end

function HealingWardDamage( keys )
	local ward = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability

	-- If the ability was unlearned, do nothing
	if not ability then
		ward:Kill(ability, attacker)
		return nil
	end
	
	-- Parameters
	local damage = 1
	
	-- If the attacker is a hero, deal more damage
	if (attacker:IsHero() or attacker:IsTower() or IsRoshan(attacker)) and not attacker:IsIllusion() then
		damage = 3
	end

	-- If the damage is enough to kill the ward, destroy it
	if ward:GetHealth() <= damage then
		ward:Kill(ability, attacker)

	-- Else, reduce its HP
	else
		ward:SetHealth(ward:GetHealth() - damage)
	end
end

function HealingWardEnd( keys )
	local ward = keys.unit
	local sound_loop = keys.sound_loop
	local sound_end = keys.sound_end

	-- Stop looping sound
	ward:StopSound(sound_loop)

	-- Play destruction sound
	ward:EmitSound(sound_end)

	-- Destroy the ambient particle
	ParticleManager:DestroyParticle(ward.healing_ward_ambient_pfx, true)
	ParticleManager:ReleaseParticleIndex(ward.healing_ward_ambient_pfx)
	ward.healing_ward_ambient_pfx = nil
end

function HealingWardUpgrade( keys )
	local healing_ward = keys.caster
	local caster = healing_ward:GetOwnerEntity()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_loop = keys.sound_loop
	local particle_ward = keys.particle_ward
	local particle_eruption = keys.particle_eruption
	
	-- Parameters
	local health = ability:GetLevelSpecialValueFor("health", ability_level)
	local health_bonus_totem = ability:GetLevelSpecialValueFor("health_bonus_totem", ability_level)
	local heal_radius = ability:GetLevelSpecialValueFor("heal_radius", ability_level)
	local target_loc = healing_ward:GetAbsOrigin()
	local player_id = caster:GetPlayerID()

	-- Play cast sound
	healing_ward:EmitSound(sound_cast)

	-- Spawn the Healing Totem
	local healing_totem = CreateUnitByName("npc_imba_juggernaut_healing_totem", target_loc, false, caster, caster, caster:GetTeam())
	FindClearSpaceForUnit(healing_totem, target_loc, true)

	-- Make the totem controllable by its caster
	healing_totem:SetControllableByPlayer(player_id, true)

	-- Increase the totem's health, if appropriate
	SetCreatureHealth(healing_totem, health, false)
	healing_totem:SetHealth(healing_ward:GetHealth() + health_bonus_totem)

	-- Prevent nearby units from getting stuck
	Timers:CreateTimer(0.01, function()
		local units = FindUnitsInRadius(caster:GetTeamNumber(), healing_totem:GetAbsOrigin(), nil, 128, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _,unit in pairs(units) do
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
		end
	end)

	-- Start looping sound
	healing_totem:EmitSound(sound_loop)

	-- Play spawn particle
	local eruption_pfx = ParticleManager:CreateParticle(particle_eruption, PATTACH_CUSTOMORIGIN, healing_totem)
	ParticleManager:SetParticleControl(eruption_pfx, 0, target_loc)
	ParticleManager:ReleaseParticleIndex(eruption_pfx)

	-- Attach ambient particle
	healing_totem.healing_ward_ambient_pfx = ParticleManager:CreateParticle(particle_ward, PATTACH_ABSORIGIN_FOLLOW, healing_totem)
	ParticleManager:SetParticleControl(healing_totem.healing_ward_ambient_pfx, 0, healing_totem:GetAbsOrigin() + Vector(0, 0, 100))
	ParticleManager:SetParticleControl(healing_totem.healing_ward_ambient_pfx, 1, Vector(heal_radius, 1, 1))

	-- Fetch parent ward's remaining duration
	local modifier_kill = healing_ward:FindModifierByName("modifier_kill")
	local remaining_duration = modifier_kill:GetRemainingTime()

	-- Apply the Healing Totem duration modifier
	healing_totem:AddNewModifier(healing_ward, ability, "modifier_kill", {duration = remaining_duration})

	-- Grant the Healing Totem its ability
	local ward_ability = healing_totem:FindAbilityByName("imba_juggernaut_healing_totem_passive")
	ward_ability:SetLevel(ability_level + 1)

	-- Destroy parent ward
	healing_ward:Kill(ability, healing_totem)
end

function BladedanceHit( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_crit = keys.modifier_crit
	local modifier_stacks = keys.modifier_stacks
	
	-- Parameters
	local crit_chance = ability:GetLevelSpecialValueFor("crit_chance", ability_level)

	-- Roll for a crit
	if RandomInt(1, 100) <= crit_chance then

		-- Increase stacks
		AddStacks(ability, caster, caster, modifier_stacks, 1, true)

		-- Grant a crit on the next hit
		Timers:CreateTimer(0.02, function()
			ability:ApplyDataDrivenModifier(caster, caster, modifier_crit, {})
		end)

	-- Else, if the caster already has the stack modifier, refresh it
	elseif caster:HasModifier(modifier_stacks) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_stacks, {})
	end
end

function BladedanceCrit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local particle_crit = keys.particle_crit
	local sound_hit = keys.sound_hit
	local modifier_crit = keys.modifier_crit

	-- Play crit particle
	local crit_pfx = ParticleManager:CreateParticle(particle_crit, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(crit_pfx, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(crit_pfx)

	-- Play crit sound
	target:EmitSound(sound_hit)

	-- Remove crit modifier and particles
	Timers:CreateTimer(0.01, function()
		caster:RemoveModifierByName(modifier_crit)
	end)
end

function Omnislash( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_caster = keys.modifier_caster
	local modifier_scepter = keys.modifier_scepter
	local sound_cast = keys.sound_cast
	local sound_hit = keys.sound_hit
	local particle_trail = keys.particle_trail
	local particle_hit = keys.particle_hit
	local scepter = HasScepter(caster)
	
	-- Parameters
	local jump_amount = ability:GetLevelSpecialValueFor("jump_amount", ability_level)
	local bounce_range = ability:GetLevelSpecialValueFor("bounce_range", ability_level)
	local bounce_delay = ability:GetLevelSpecialValueFor("bounce_delay", ability_level)
	local agi_per_jump = ability:GetLevelSpecialValueFor("agi_per_jump", ability_level)
	local cooldown_scepter = ability:GetLevelSpecialValueFor("cooldown_scepter", ability_level)
	agi_per_jump = 1 / agi_per_jump

	-- Scepter stuff
	if scepter then

		-- Parameter updates
		bounce_range = ability:GetLevelSpecialValueFor("bounce_range_scepter", ability_level)

		-- Trigger reduced cooldown
		ability:EndCooldown()
		ability:StartCooldown(cooldown_scepter * GetCooldownReduction(caster))
	end

	-- Apply caster modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})

	-- Follow caster with the camera
	PlayerResource:SetCameraTarget(caster:GetPlayerID(), caster)

	-- Move the caster to the initial target's position
	FindClearSpaceForUnit(caster, target:GetAbsOrigin(), true)

	-- Play initial sound
	caster:EmitSound(sound_cast)

	-- Play cast lines
	local rand = math.random
	local rand_number = rand(100)
	if rand_number <= 15 then
		caster:EmitSound("juggernaut_jug_rare_17")
	else
		caster:EmitSound("juggernaut_jug_ability_omnislash_0"..rand(3))
	end

	-- Start slashing animation
	StartAnimation(caster, {activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.0})

	-- Initialize jump variables
	local previous_position = caster:GetAbsOrigin()
	local current_position = previous_position
	local current_target = target
	local nearby_enemies
	local previous_agi = caster:GetAgility()
	if caster:IsRealHero() then
		jump_amount = jump_amount + previous_agi * agi_per_jump
	end
	local jumps_remaining = jump_amount

	-- Start jumping loop
	Timers:CreateTimer(0, function()

		-- Update previous position
		previous_position = current_position
		
		-- Find eligible targets
		nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		
		-- If there is an eligible target, slash it
		if nearby_enemies[1] then

			-- Set the current target
			current_target = nearby_enemies[1]
			current_position = current_target:GetAbsOrigin()

			-- Move the caster to the current target
			FindClearSpaceForUnit(caster, current_position, true)

			-- Set the caster's attack target as the current target
			caster:SetAttacking(current_target)
			caster:SetForceAttackTarget(current_target)
			Timers:CreateTimer(0.01, function()
				caster:SetForceAttackTarget(nil)
			end)

			-- Provide vision of the target for a short duration
			ability:CreateVisibilityNode(current_position, 300, 1.0)

			-- Perform the slash
			caster:PerformAttack(current_target, true, true, true, true, true)

			-- If the target is not Roshan or a hero, instantly kill it
			if not ( current_target:IsHero() or IsRoshan(current_target) ) then
				ApplyDamage({attacker = caster, victim = current_target, ability = ability, damage = current_target:GetHealth(), damage_type = DAMAGE_TYPE_PURE})
			end

			-- Count down amount of slashes
			jumps_remaining = jumps_remaining - 1

			-- Play hit sound
			current_target:EmitSound(sound_hit)

			-- Play hit particle on the current target
			local hit_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, current_target)
			ParticleManager:SetParticleControl(hit_pfx, 0, current_position)
			ParticleManager:ReleaseParticleIndex(hit_pfx)

			-- Play particle trail when moving
			local trail_pfx = ParticleManager:CreateParticle(particle_trail, PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(trail_pfx, 0, previous_position)
			ParticleManager:SetParticleControl(trail_pfx, 1, current_position)
			ParticleManager:ReleaseParticleIndex(trail_pfx)

			-- Update jump count
			local current_agi = caster:GetAgility()
			if current_agi > previous_agi then
				jumps_remaining = jumps_remaining + (current_agi - previous_agi) * agi_per_jump
				previous_agi = current_agi
			end

			-- If there are enough jumps left, keep slashing
			if jumps_remaining >= 1 then
				return bounce_delay

			-- Else, end the omnislash
			else
				caster:RemoveModifierByName(modifier_caster)
				if caster:HasModifier("modifier_imba_blade_fury_caster") then
					StartAnimation(caster, {activity = ACT_DOTA_OVERRIDE_ABILITY_1, rate = 1.0})
				else
					EndAnimation(caster)
				end
				PlayerResource:SetCameraTarget(caster:GetPlayerID(), nil)
			end

		-- Else, end the omnislash
		else
			caster:RemoveModifierByName(modifier_caster)
			if caster:HasModifier("modifier_imba_blade_fury_caster") then
				StartAnimation(caster, {activity = ACT_DOTA_OVERRIDE_ABILITY_1, rate = 1.0})
			else
				EndAnimation(caster)
			end
			PlayerResource:SetCameraTarget(caster:GetPlayerID(), nil)
		end
	end)
end