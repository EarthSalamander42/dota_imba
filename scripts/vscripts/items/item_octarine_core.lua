--[[	Author: d2imba
		Date:	15.08.2015	]]

function OctarineLifesteal( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = keys.damage
	local particle_lifesteal = keys.particle_lifesteal
	local modifier_prevent = keys.modifier_prevent

	-- Parameters
	local hero_lifesteal = ability:GetLevelSpecialValueFor("hero_lifesteal", ability_level)
	local creep_lifesteal = ability:GetLevelSpecialValueFor("creep_lifesteal", ability_level)

	-- If there's no valid target, do nothing
	if target:IsBuilding() or target:IsTower() or target == caster or target:HasModifier(modifier_prevent) then
		return nil
	end

	-- Play the particle
	local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(lifesteal_fx, 0, caster:GetAbsOrigin())

	-- If the target is a real hero, heal for the full value
	if target:IsRealHero() then
		caster:Heal(damage * hero_lifesteal / 100, caster)

	-- else, heal for the reduced value
	else
		caster:Heal(damage * creep_lifesteal / 100, caster)
	end
end

function OctarineAttack( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_prevent = keys.modifier_prevent

	-- Applies the lifesteal-prevention modifier
	ability:ApplyDataDrivenModifier(caster, target, modifier_prevent, {})
end

function OctarineBlast( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local cast_ability = keys.event_ability
	local particle_blast = keys.particle_blast
	local particle_hit = keys.particle_hit
	local sound_hit = keys.sound_hit

	-- Parameters
	local blast_radius = ability:GetLevelSpecialValueFor("blast_radius", ability_level)
	local dmg_per_mana = ability:GetLevelSpecialValueFor("dmg_per_mana", ability_level)
	local cast_ability_mana_cost = cast_ability:GetManaCost(cast_ability:GetLevel() - 1) / FRANTIC_MULTIPLIER
	local damage = cast_ability_mana_cost * dmg_per_mana / 100

	-- Blast geometry
	local blast_duration = 0.75 * 0.75
	local blast_speed = blast_radius / blast_duration
	local step_time = 0.15
	local current_time = 0
	local current_radius = 0
	local targets_hit = {}

	-- If the cast ability has a mana cost, emit a damaging blast
	if cast_ability and cast_ability_mana_cost > 0 and StickProcCheck(cast_ability) then
		
		-- Fire particle
		local blast_pfx = ParticleManager:CreateParticle(particle_blast, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(blast_pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(blast_pfx, 1, Vector(100,0,blast_speed))

		-- Start blasting loop
		Timers:CreateTimer(step_time, function()

			-- Update blast geometry
			current_time = current_time + step_time
			current_radius = current_radius + step_time * blast_speed
			
			-- Find units in current blast radius
			local blast_targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, current_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

			-- Damage units inside the blast radius if they haven't been affected already
			for _,target in pairs(blast_targets) do
				
				-- Check if this unit has been hit already
				local target_is_hit = false
				for i = 1, #targets_hit do
					if targets_hit[i] == target then
						target_is_hit = true
					end
				end

				-- If it hasn't, add it to the targets_hit table
				if not target_is_hit then
					targets_hit[ #targets_hit + 1 ] = target

					-- Apply damage
					ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

					-- Fire particle
					local hit_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, target)
					ParticleManager:SetParticleControl(hit_pfx, 0, target:GetAbsOrigin())
					ParticleManager:SetParticleControl(hit_pfx, 1, Vector(100,0,blast_speed))
					ParticleManager:SetParticleControl(hit_pfx, 2, Vector(1,0,0))
					
					-- Print overhead message
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, damage, nil)

					-- Fire sound
					target:EmitSound(sound_hit)
				end
			end
			if current_time <= blast_duration then
				return step_time
			end
		end)
	end
end
