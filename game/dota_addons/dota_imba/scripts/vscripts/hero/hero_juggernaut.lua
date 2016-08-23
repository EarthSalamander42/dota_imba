--[[	Author: Firetoad
		Date: 18.08.2016	]]

function Bladefury( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_caster = keys.modifier_caster
	
	-- Apply bladefury modifier to the caster
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})
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
	StartAnimation(caster, {duration = duration, activity = ACT_DOTA_OVERRIDE_ABILITY_1, rate = 1.0})

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
	EndAnimation(caster)

	-- Stop looping sound
	caster:StopSound(sound_spin)

	-- Play end sound
	caster:EmitSound(sound_stop)

	-- Destroy particle
	ParticleManager:DestroyParticle(caster.blade_fury_spin_pfx, false)
	ParticleManager:ReleaseParticleIndex(caster.blade_fury_spin_pfx)
	caster.blade_fury_spin_pfx = nil
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
	local particle_self = keys.particle_self
	local particle_hit = keys.particle_hit
	local scepter = HasScepter(caster)
	
	-- Parameters
	local jump_amount = ability:GetLevelSpecialValueFor("jump_amount", ability_level)
	local bounce_range = ability:GetLevelSpecialValueFor("bounce_range", ability_level)
	local bounce_delay = ability:GetLevelSpecialValueFor("bounce_delay", ability_level)
	local agi_per_jump = ability:GetLevelSpecialValueFor("agi_per_jump", ability_level)
	local cooldown_scepter = ability:GetLevelSpecialValueFor("cooldown_scepter", ability_level)
	local cast_delay_scepter = 0

	-- Scepter stuff
	if scepter then

		-- Parameter updates
		bounce_range = ability:GetLevelSpecialValueFor("bounce_range_scepter", ability_level)
		cast_delay_scepter = ability:GetLevelSpecialValueFor("cast_delay_scepter", ability_level)

		-- Trigger reduced cooldown
		ability:StartCooldown(cooldown_scepter * GetCooldownReduction(caster))
		
		-- Wind-up animation
		StartAnimation(caster, {activity = ACT_DOTA_VICTORY, rate = 1.0})

		-- Global cast sound
		caster:EmitSound("Imba.JuggOmnislashWindUp01")
		--local all_heroes = HeroList:GetAllHeroes()
		--for _,hero in pairs(all_heroes) do
		--	EmitSoundOnClient("Imba.JuggOmnislashWindUp01", PlayerResource:GetPlayer(hero:GetPlayerID()))
		--end

		-- Self-root
		ability:ApplyDataDrivenModifier(caster, caster, modifier_scepter, {})
	end

	-- Apply caster modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})

	-- Initialize jump variables
	local previous_position = caster:GetAbsOrigin()
	local current_position = previous_position
	local current_target = target
	local nearby_targets
	if caster:IsRealHero() then
		jump_amount = jump_amount + math.floor(caster:GetAgility() / agi_per_jump)
	end
	local jumps_remaining = jump_amount

	-- Follow caster with the camera
	PlayerResource:SetCameraTarget(caster:GetPlayerID(), caster)

	-- Play initial sound and start animation
	Timers:CreateTimer(cast_delay_scepter, function()
		caster:EmitSound(sound_cast)
		StartAnimation(caster, {activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.0})
	end)

	-- Start jumping loop
	Timers:CreateTimer(cast_delay_scepter, function()

		previous_position = current_position
		
		-- Find eligible targets
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		
		-- If there is an eligible target, slash it
		if nearby_enemies[1] then
			current_target = nearby_enemies[1]
			current_position = current_target:GetAbsOrigin()
			FindClearSpaceForUnit(caster, current_position, true)
			caster:SetAttacking(current_target)
			caster:SetForceAttackTarget(current_target)
			Timers:CreateTimer(0.01, function()
				caster:SetForceAttackTarget(nil)
			end)
			ability:CreateVisibilityNode(current_position, 300, 1.0)
			caster:PerformAttack(current_target, true, true, true, true, true)

			if current_target:IsHero() or IsRoshan(current_target) then
				jumps_remaining = jumps_remaining - 1
			else
				ApplyDamage({attacker = caster, victim = current_target, ability = ability, damage = current_target:GetHealth(), damage_type = DAMAGE_TYPE_PURE})
			end

			current_target:EmitSound(sound_hit)

			local trail_pfx = ParticleManager:CreateParticle(particle_trail, PATTACH_ABSORIGIN_FOLLOW, current_target)
			ParticleManager:SetParticleControl(trail_pfx, 0, previous_position)
			ParticleManager:SetParticleControl(trail_pfx, 1, current_position)
			ParticleManager:ReleaseParticleIndex(trail_pfx)

			local self_pfx = ParticleManager:CreateParticle(particle_self, PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(self_pfx, 0, previous_position)
			ParticleManager:SetParticleControl(self_pfx, 1, current_position)
			ParticleManager:ReleaseParticleIndex(self_pfx)

			local hit_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, current_target)
			ParticleManager:SetParticleControl(hit_pfx, 0, current_position)
			ParticleManager:ReleaseParticleIndex(hit_pfx)

			-- If there are enough jumps left, keep slashing
			if jumps_remaining >= 1 then
				return bounce_delay
			-- Else, end the omnislash
			else
				caster:RemoveModifierByName(modifier_caster)
				EndAnimation(caster)
				PlayerResource:SetCameraTarget(caster:GetPlayerID(), nil)
			end

		-- Else, end the omnislash
		else
			caster:RemoveModifierByName(modifier_caster)
			EndAnimation(caster)
			PlayerResource:SetCameraTarget(caster:GetPlayerID(), nil)
		end
	end)
end