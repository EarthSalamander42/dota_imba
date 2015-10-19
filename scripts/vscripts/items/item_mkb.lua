--[[	Author: d2imba
		Date:	20.09.2015	]]

function MonkeyKingBarPassive( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_ranged = keys.modifier_ranged
	local modifier_melee = keys.modifier_melee

	-- Apply the relevant modifier, according to the caster's attack capability
	if caster:IsRangedAttacker() then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_ranged, {})
	else
		caster:RemoveModifierByName(modifier_ranged)
	end
end

function MonkeyKingBarProc( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit
	local sound_bash = keys.sound_bash
	local particle_hit = keys.particle_hit

	-- Parameters
	local pulverize_chance = ability:GetLevelSpecialValueFor("pulverize_chance", ability_level)
	local pulverize_radius = ability:GetLevelSpecialValueFor("pulverize_radius", ability_level)
	local pulverize_damage = ability:GetLevelSpecialValueFor("pulverize_damage", ability_level)
	local pulverize_stun = ability:GetLevelSpecialValueFor("pulverize_stun", ability_level)

	-- Check for a proc
	if not target:IsBuilding() and ability:IsCooldownReady() and RandomInt(1, 100) <= pulverize_chance then
		
		-- Play bash sound
		target:EmitSound(sound_bash)

		-- Start cooldown
		ability:StartCooldown(ability:GetCooldown(0))

		-- If the caster is melee, pulverize
		if not caster:IsRangedAttacker() then

			-- Play pulverize sound
			target:EmitSound(sound_hit)

			-- Find enemies in the pulverize area
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, pulverize_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

			-- Damage enemies
			for _,enemy in pairs(enemies) do

				-- Deal pulverize damage
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = pulverize_damage, damage_type = DAMAGE_TYPE_MAGICAL})

				-- Apply ministun
				enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = pulverize_stun})

				-- Play particle
				local pulverize_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, enemy)
				ParticleManager:SetParticleControl(pulverize_pfx, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl(pulverize_pfx, 1, Vector(100,0,0))
			end
		end
	end
end