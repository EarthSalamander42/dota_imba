modifier_mutation_death_explosion = class({})

function modifier_mutation_death_explosion:IsHidden() return true end
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
	if IsClient() then return end
	self.damage = _G.IMBA_MUTATION_DEATH_EXPLOSION_DAMAGE
	self.game_in_progress = false

	self:StartIntervalThink(1.0)
end

function modifier_mutation_death_explosion:OnIntervalThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if self.game_in_progress == false then
			self:StartIntervalThink(60.0)
			self.game_in_progress = true
		end

		local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, _G.IMBA_MUTATION_DEATH_EXPLOSION_MAX_MINUTES)
		game_time = math.floor(game_time) * _G.IMBA_MUTATION_DEATH_EXPLOSION_DAMAGE_INCREASE_PER_MIN
		self.damage = _G.IMBA_MUTATION_DEATH_EXPLOSION_DAMAGE + game_time
--		print(self.damage)
	end
end

function modifier_mutation_death_explosion:OnDeath(keys)
	if keys.unit == self:GetParent() then
		if self:GetParent():IsIllusion() or self:GetParent():IsTempestDouble() or self:GetParent():IsImbaReincarnating() then return end
		EmitSoundOn("Hero_Pugna.NetherBlastPreCast", self:GetParent())

		local particle_pre_blast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_netherblast_pre.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(particle_pre_blast_fx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_pre_blast_fx, 1, Vector(_G.IMBA_MUTATION_DEATH_EXPLOSION_RADIUS, _G.IMBA_MUTATION_DEATH_EXPLOSION_DELAY, 1))
		ParticleManager:ReleaseParticleIndex(particle_pre_blast_fx)

		Timers:CreateTimer(_G.IMBA_MUTATION_DEATH_EXPLOSION_DELAY, function()
			EmitSoundOn("Hero_Pugna.NetherBlastPreCast", self:GetParent())

			local particle_blast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_netherblast.vpcf", PATTACH_ABSORIGIN, self:GetParent())
			ParticleManager:SetParticleControl(particle_blast_fx, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(_G.IMBA_MUTATION_DEATH_EXPLOSION_RADIUS, 0, 0))
			ParticleManager:ReleaseParticleIndex(particle_blast_fx)

			-- Find all enemies, including buildings
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, _G.IMBA_MUTATION_DEATH_EXPLOSION_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

			for _, enemy in pairs(enemies) do
				-- If the enemy is a building, adjust damage.
				local damage = self.damage
				if enemy:IsBuilding() then
					damage = self.damage * _G.IMBA_MUTATION_DEATH_EXPLOSION_BUILDING_DAMAGE / 100
				end

				-- Deal damage
				local damageTable = {
					victim = enemy,
					damage = damage,
					damage_type = DAMAGE_TYPE_PURE,
					attacker = self:GetParent(),
					damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
				}

				ApplyDamage(damageTable)
			end
		end)
	end
end
