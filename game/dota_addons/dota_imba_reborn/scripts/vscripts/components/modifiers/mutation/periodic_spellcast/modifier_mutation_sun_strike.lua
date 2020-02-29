modifier_mutation_sun_strike = class({})

function modifier_mutation_sun_strike:IsHidden() return true end
function modifier_mutation_sun_strike:IsDebuff() return true end
function modifier_mutation_sun_strike:IsPurgable() return false end
function modifier_mutation_sun_strike:RemoveOnDeath() return false end

function modifier_mutation_sun_strike:OnCreated()
	if IsClient() then return end
	self.delay = 1.7
	self.radius = 175
	local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, 30)
	self.damage = 1000 + (250 * game_time)
	self.pos = self:GetParent():GetAbsOrigin()

	EmitSoundOn("Hero_Invoker.SunStrike.Charge", self:GetParent())

	local particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_WORLDORIGIN, nil, self:GetParent():GetTeamNumber())
	ParticleManager:SetParticleControl(particle, 0, self.pos)
	ParticleManager:SetParticleControl(particle, 1, Vector(50, 1, 1))
	ParticleManager:ReleaseParticleIndex(particle)

	Timers:CreateTimer(self.delay, function()
		EmitSoundOnLocationWithCaster(self.pos, "Hero_Invoker.SunStrike.Ignite", self:GetParent())

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(particle, 0, self.pos)
		ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle)

		-- Find all enemies
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		for _, enemy in pairs(enemies) do
			-- Deal damage
			local damageTable = {
				victim = enemy,
				damage = self.damage / #enemies,
				damage_type = DAMAGE_TYPE_MAGICAL,
				attacker = self:GetCaster(),
			}

			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, self.damage / #enemies, nil)
			ApplyDamage(damageTable)
		end

		self:GetParent():RemoveModifierByName("modifier_mutation_sun_strike")
	end)
end
