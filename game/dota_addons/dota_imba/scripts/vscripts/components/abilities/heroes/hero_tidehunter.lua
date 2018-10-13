-- Editors:
--    Fudge: 23.08.2017

-----------------------------
------ 	   RAVAGE	  -------
-----------------------------
imba_tidehunter_ravage = imba_tidehunter_ravage or class({})

-- TODO: Destroy the knockback modifier after it's done
-- TODO: add a phased modifier for 0.5 secs
-- TODO: fix nyx stun animation too

function imba_tidehunter_ravage:OnSpellStart()
	-- Ability properties
	local caster			=	self:GetCaster()
	local caster_pos		=	caster:GetAbsOrigin()
	local cast_sound		=	"Ability.Ravage"
	local hit_sound			=	"Hero_Tidehunter.RavageDamage"
	local kill_responses	=	"tidehunter_tide_ability_ravage_0"
	local particle 			=	"particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf"
	-- Ability parameters
	local end_radius	=	self:GetSpecialValueFor("radius")
	local damage		=	self:GetSpecialValueFor("damage")
	local stun_duration	=	self:GetSpecialValueFor("duration")

	-- Emit sound
	caster:EmitSound(cast_sound)

	-- Emit particle
	self.particle_fx	=	ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(self.particle_fx, 0, caster_pos)
	-- Set each ring in it's position
	for i=1, 5 do
		ParticleManager:SetParticleControl(self.particle_fx, i, Vector(end_radius * 0.2 * i, 0 , 0))
	end
	ParticleManager:ReleaseParticleIndex(self.particle_fx)

	local radius =	end_radius * 0.2
	local ring	 =	1
	local ring_width = end_radius * 0.2
	local hit_units	=	{}

	-- Find units in a ring 5 times and hit them with ravage
	Timers:CreateTimer(function()
		local enemies =	FindUnitsInRing(caster:GetTeamNumber(),
			caster_pos,
			nil,
			ring * radius,
			radius,
			self:GetAbilityTargetTeam(),
			self:GetAbilityTargetType(),
			self:GetAbilityTargetFlags(),
			FIND_ANY_ORDER,
			false
		)

		for _,enemy in pairs(enemies) do
			-- Custom function, checks if the unit was hit already
			if not CheckIfInTable(hit_units, enemy) then
				-- Emit hit sound
				enemy:EmitSound(hit_sound)

				-- Apply stun and air time modifiers
				enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration})

				-- Knock the enemy into the air
				local knockback =
				{
						knockback_duration = 0.5,
					duration = 0.5,
					knockback_distance = 0,
					knockback_height = 350,
				}
				enemy:RemoveModifierByName("modifier_knockback")
				enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)

				Timers:CreateTimer(0.5, function()
					-- Apply damage
					local damageTable = {victim = enemy,
						damage = damage,
						damage_type = self:GetAbilityDamageType(),
						attacker = caster,
						ability = self
					}
					ApplyDamage(damageTable)

					-- Check if the enemy is a dead hero, if he is, emit kill response
					if not enemy:IsAlive() and enemy:IsHero() and RollPercentage(25) and caster:GetName() == "npc_dota_hero_tidehunter" then
						caster:EmitSound(kill_responses..RandomInt(1, 2))
					end

					-- We need to do this because the gesture takes it's fucking time to stop
					enemy:RemoveGesture(ACT_DOTA_FLAIL)
				end)

				-- Mark the enemy as hit to not get hit again
				table.insert(hit_units, enemy)
			end
		end

		-- Send the next ring
		if ring < 5 then
			ring = ring + 1
			return 0.2
		end
	end)
end

function imba_tidehunter_ravage:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
