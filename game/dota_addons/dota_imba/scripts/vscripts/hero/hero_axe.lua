--[[	Author: Pizzalol
		Date: 09.02.2015	]]


function CastBattleHunger( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifier_debuff = keys.modifier_debuff	
	
	-- Check for Linkens	
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		if target:TriggerSpellAbsorb(ability) then
			return
		end
	end
	
	--Apply Battle Hunger
	ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})
end
	
-- Updates the value of the stack modifier and applies the movement speed modifier]]
function BattleHungerStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	
	local caster_modifier = keys.caster_modifier
	local speed_modifier = keys.speed_modifier

	-- If the caster doesnt have the stack modifier then we create it, otherwise
	-- we just update the value
	if not caster:HasModifier(caster_modifier) then
		ability:ApplyDataDrivenModifier(caster, caster, caster_modifier, {})
		caster:SetModifierStackCount(caster_modifier, ability, 1)		
	else
		local stack_count = caster:GetModifierStackCount(caster_modifier, ability)
		caster:SetModifierStackCount(caster_modifier, ability, stack_count + 1)
	end

	-- Apply the movement speed modifier
	ability:ApplyDataDrivenModifier(caster, caster, speed_modifier, {})
end

--[[Author: Pizzalol
	Date: 09.02.2015.
	Updates the value of the stack modifier and removes the movement speed modifier]]
function BattleHungerEnd( keys )
	local caster = keys.caster
	local ability = keys.ability

	local caster_modifier = keys.caster_modifier
	local speed_modifier = keys.speed_modifier

	local stack_count = caster:GetModifierStackCount(caster_modifier, ability)

	-- If the stack is equal or less than one then just remove the stack modifier entirely
	-- otherwise just update the value
	if stack_count <= 1 then
		caster:RemoveModifierByName(caster_modifier)
	else
		caster:SetModifierStackCount(caster_modifier, ability, stack_count - 1)
	end

	-- Remove one movement modifier
	caster:RemoveModifierByName(speed_modifier)
end

--[[Author: Pizzalol
	Date: 09.02.2015.
	Triggers when the unit kills something, if its not an illusion then remove the Battle Hunger debuff]]
function BattleHungerKill( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local unit = keys.unit
	local modifier = keys.modifier

	if not unit:IsIllusion() then
		attacker:RemoveModifierByNameAndCaster(modifier, caster)
	end
end

function BattleHungerAntiRegen( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_stacks = keys.modifier_stacks
	local modifier_enemy = keys.modifier_enemy

	-- If the ability was unlearned, remove the debuff
	if not ability then
		target:RemoveModifierByName(modifier_enemy)
	end

	-- If the target is near its own fountain, end the debuff
	if IsNearFriendlyClass(target, 1360, "ent_dota_fountain") then
		target:RemoveModifierByName(modifier_enemy)
	end

	-- Else, prevent regeneration this tick
	target:RemoveModifierByName(modifier_stacks)
	local hp_regen = target:GetHealthRegen()
	AddStacks(ability, caster, target, modifier_stacks, hp_regen * 10, true)
end

function CounterHelix( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_spin_1 = keys.particle_spin_1
	local particle_spin_2 = keys.particle_spin_2
	local sound_spin = keys.sound_spin

	-- If the ability is disabled by Break, do nothing
	if ability_level < 0 then
		return nil
	end

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local proc_chance = ability:GetLevelSpecialValueFor("proc_chance", ability_level)
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local str_as_damage = ability:GetLevelSpecialValueFor("str_as_damage", ability_level)

	-- Check for a proc
	if RandomInt(1, 100) <= proc_chance then
		
		-- Play sound
		caster:EmitSound(sound_spin)

		-- Play particles
		local helix_pfx_1 = ParticleManager:CreateParticle(particle_spin_1, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(helix_pfx_1, 0, caster:GetAbsOrigin())
		local helix_pfx_2 = ParticleManager:CreateParticle(particle_spin_2, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(helix_pfx_2, 0, caster:GetAbsOrigin())

		-- Spin animation
		StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1.0})

		-- Calculate damage
		local damage = base_damage + caster:GetStrength() * str_as_damage / 100

		-- Find nearby enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		
		-- Apply damage to valid enemies
		for _,enemy in pairs(enemies) do
			ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})
		end
	end
end

function CullingBlade( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin() 
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Sound variables
	local sound_fail = keys.sound_fail
	local sound_success = keys.sound_success

	-- Particle
	local particle_kill = keys.particle_kill

	-- Speed modifier
	local modifier_sprint = keys.modifier_sprint

	-- Ability variables
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local speed_duration = ability:GetLevelSpecialValueFor("speed_duration", ability_level)
	local speed_duration_scepter = ability:GetLevelSpecialValueFor("speed_duration_scepter", ability_level)
	local speed_aoe = ability:GetLevelSpecialValueFor("speed_aoe", ability_level)
	local kill_threshold = ability:GetLevelSpecialValueFor("kill_threshold", ability_level)
	local caster_hp = caster:GetMaxHealth()
	local caster_hp_percent = ability:GetLevelSpecialValueFor("caster_health_percent", ability_level) / 100
	local scepter = HasScepter(caster)

	-- Kill threshold calculation
	if scepter == true then
		kill_threshold = ability:GetLevelSpecialValueFor("kill_threshold_scepter", ability_level)
		caster_hp_percent = ability:GetLevelSpecialValueFor("caster_health_percent_scepter", ability_level) / 100
	end

	kill_threshold = kill_threshold + caster_hp * caster_hp_percent

	-- Exception table
	-- this is where you insert the modifiers that cant be purged but would
	-- prevent a units death
	local exception_table = {}
	table.insert(exception_table, "modifier_dazzle_shallow_grave")
	table.insert(exception_table, "modifier_imba_dazzle_shallow_grave")
	table.insert(exception_table, "modifier_oracle_false_promise")
	table.insert(exception_table, "modifier_imba_oracle_false_promise")

	-- Initializing the damage table
	local damage_table = {}
 	damage_table.victim = target
 	damage_table.attacker = caster
 	damage_table.ability = ability
 	damage_table.damage_type = ability:GetAbilityDamageType()
 	damage_table.damage = damage
	
	-- Check for Linkens
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		if target:TriggerSpellAbsorb(ability) then
			return
		end
	end
	
 	-- Check if the target HP is equal or below the threshold
	if target:GetHealth() <= kill_threshold and not target:HasModifier("modifier_imba_reincarnation_scepter_wraith") then
		
		-- If it is then purge it and manually remove unpurgable modifiers
		target:Purge(true, true, false, false, true)

		local modifier_count = target:GetModifierCount()
		for i = 0, modifier_count do
			local modifier_name = target:GetModifierNameByIndex(i)
			local modifier_check = false

			-- Compare if the modifier is in the exception table
			-- If it is then set the helper variable to true and remove it
			for j = 0, #exception_table do
				if exception_table[j] == modifier_name then
					modifier_check = true
					break
				end
			end

			-- Remove the modifier depending on the helper variable
			if modifier_check then
				target:RemoveModifierByName(modifier_name)
			end
		end

		-- Play the kill particle
		local culling_kill_particle = ParticleManager:CreateParticle(particle_kill, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 8, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:ReleaseParticleIndex(culling_kill_particle)

		-- Play the sound
		caster:EmitSound(sound_success)

		-- Remove exceptional modifiers and kill the target
		TrueKill(caster, target, ability)

		-- Find the valid units in the area that should recieve the speed buff and then apply it to them
		local units_to_buff = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, speed_aoe, DOTA_UNIT_TARGET_TEAM_FRIENDLY, ability:GetAbilityTargetType() , 0, FIND_CLOSEST, false)
		for _,v in pairs(units_to_buff) do
			if scepter == true then
				ability:ApplyDataDrivenModifier(caster, v, modifier_sprint, {duration = speed_duration_scepter})
			else
				ability:ApplyDataDrivenModifier(caster, v, modifier_sprint, {duration = speed_duration})
			end
		end

		-- Reset the ability cooldown if its a hero
		if target:IsRealHero() then
			ability:EndCooldown()
		end				
	else
		-- If its not equal or below the threshold then play the failure sound and deal normal damage
		caster:EmitSound(sound_fail)
		ApplyDamage(damage_table)
	end
end