--[[	Author: d2imba
		Date:	15.08.2015	]]

function OctarineToggle( keys )
	local caster = keys.caster
	local ability = keys.ability
	local new_item = keys.new_item
	local sound_toggle = keys.sound_toggle

	-- Toggle Octarine Core on or off
	SwapToItem(caster, ability, new_item)

	-- Play sound only to the caster
	caster:EmitSound(sound_toggle)
end

function OctarineLifesteal( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = keys.damage
	local particle_lifesteal = keys.particle_lifesteal
	local modifier_prevent = keys.modifier_prevent

	-- If there's no valid target, do nothing
	if target:IsBuilding() or target:IsTower() or target == caster or target:HasModifier(modifier_prevent) then
		return nil
	end

	-- Parameters
	local hero_lifesteal = ability:GetLevelSpecialValueFor("hero_lifesteal", ability_level)
	local creep_lifesteal = ability:GetLevelSpecialValueFor("creep_lifesteal", ability_level)

	-- Play the particle
	local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(lifesteal_fx, 0, caster:GetAbsOrigin())

	-- Delay the lifesteal for one game tick to prevent blademail/octarine interaction
	Timers:CreateTimer(0.01, function()
		
		-- If the target is a real hero, heal for the full value
		if target:IsRealHero() then
			caster:Heal(damage * hero_lifesteal / 100, caster)

		-- else, heal for the reduced value
		else
			caster:Heal(damage * creep_lifesteal / 100, caster)
		end
	end)
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
	local sound_blast = keys.sound_blast

	-- Parameters
	local blast_radius = ability:GetLevelSpecialValueFor("blast_radius", ability_level)
	local damage = ability:GetLevelSpecialValueFor("blast_dmg", ability_level)
	local minimum_mana = ability:GetLevelSpecialValueFor("minimum_mana", ability_level)
	local cast_ability_mana_cost = cast_ability:GetManaCost(cast_ability:GetLevel() - 1) / FRANTIC_MULTIPLIER

	-- Blast geometry
	local blast_duration = 0.75 * 0.75
	local blast_speed = blast_radius / blast_duration

	-- If the cast ability has a mana cost over the threshold, emit a damaging blast
	if cast_ability and cast_ability_mana_cost >= minimum_mana and StickProcCheck(cast_ability) then
		
		-- Fire particle
		local blast_pfx = ParticleManager:CreateParticle(particle_blast, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(blast_pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(blast_pfx, 1, Vector(100,0,blast_speed))
			
		-- Find units in the blast radius
		local blast_targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, blast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		-- Damage units inside the blast radius if they haven't been affected already
		for _,target in pairs(blast_targets) do

			-- Fire sound
			target:EmitSound(sound_blast)

			-- Apply damage
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

			-- Fire particle
			local hit_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(hit_pfx, 0, target:GetAbsOrigin())
			ParticleManager:SetParticleControl(hit_pfx, 1, Vector(100,0,blast_speed))
			ParticleManager:SetParticleControl(hit_pfx, 2, Vector(1,0,0))
			
			-- Print overhead message
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, damage, nil)
		end
	end
end
