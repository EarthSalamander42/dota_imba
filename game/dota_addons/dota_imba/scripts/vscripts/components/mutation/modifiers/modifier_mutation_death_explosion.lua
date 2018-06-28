modifier_mutation_death_explosion = class({})

function modifier_mutation_death_explosion:IsHidden() return false end
function modifier_mutation_death_explosion:IsPurgable() return false end
function modifier_mutation_death_explosion:RemoveOnDeath() return false end

function modifier_mutation_death_explosion:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_mutation_death_explosion:GetTexture()
	return "pugna_nether_blast"
end

function modifier_mutation_death_explosion:OnCreated()
	self.delay = 0.9
	self.radius = 400
	self.damage = 600
	self.damage_per_min = 150
	self.damage_buildings_pct = 0.5
end

function modifier_mutation_death_explosion:OnDeath(keys)
	if keys.unit == self:GetParent() then
	if self:GetParent():IsIllusion() then return end
		EmitSoundOn("Hero_Pugna.NetherBlastPreCast", self:GetParent())

		local particle_pre_blast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_netherblast_pre.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(particle_pre_blast_fx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_pre_blast_fx, 1, Vector(self.radius, self.delay, 1))
		ParticleManager:ReleaseParticleIndex(particle_pre_blast_fx)

		local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, 30)
		game_time = game_time * self.damage_per_min
		self.damage = self.damage + game_time

		Timers:CreateTimer(self.delay, function()
			EmitSoundOn("Hero_Pugna.NetherBlastPreCast", self:GetParent())

			local particle_blast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_netherblast.vpcf", PATTACH_ABSORIGIN, self:GetParent())
			ParticleManager:SetParticleControl(particle_blast_fx, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(self.radius, 0, 0))
			ParticleManager:ReleaseParticleIndex(particle_blast_fx)

			-- Find all enemies, including buildings
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

			for _, enemy in pairs(enemies) do
				-- If the enemy is a building, adjust damage.
				if enemy:IsBuilding() then
					self.damage = self.damage * self.damage_buildings_pct * 0.01
				end

				-- Deal damage
				local damageTable = {
					victim = enemy,
					damage = self.damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					attacker = self:GetParent(),
				}

				ApplyDamage(damageTable)
			end
		end)

		self.damage = 600
	end
end
