-- Credits: 
-- Coder: EarthSalamander #42
-- Particle: Toyoka

modifier_mutation_kill_streak_power = class({})

function modifier_mutation_kill_streak_power:IsHidden() return false end
function modifier_mutation_kill_streak_power:IsPurgable() return false end
function modifier_mutation_kill_streak_power:RemoveOnDeath() return false end

function modifier_mutation_kill_streak_power:GetTexture()
	return "custom/tower_toughness"
end

function modifier_mutation_kill_streak_power:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_HERO_KILLED,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}

	return funcs
end

function modifier_mutation_kill_streak_power:OnCreated()
	self.damage_increase = CustomNetTables:GetTableValue("mutation_info", "killstreak_power")["1"]
	self.maximum_size = _G.IMBA_MUTATION_KILLSTREAK_POWER_MAX_SIZE

	self:StartIntervalThink(1.0)

	if not IsServer() then return end
	self.particle = ParticleManager:CreateParticle("particles/hw_fx/candy_carrying_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle, 2, Vector(0, 0, 0))
	ParticleManager:SetParticleControl(self.particle, 3, Vector(0, 0, 0))
end

function modifier_mutation_kill_streak_power:OnHeroKilled(params)
	if not IsServer() then
		return nil
	end

	local attacker = params.attacker
	local target = params.target

	-- if killer is not parent, don't gain charges
	if self:GetParent() ~= attacker then
		return nil
	end

	-- Don't gain charges off of illusions
	if not target:IsRealHero() then
		return nil
	end

	-- Same team
	if self:GetParent():GetTeamNumber() == target:GetTeamNumber() then
		return nil
	end

	self:SetStackCount(self:GetStackCount() + 1)

	local stack = self:GetStackCount() * self.damage_increase
	local stack_100 = math.floor(stack / 100)

	if stack_100 > 0 then
		ParticleManager:SetParticleControl(self.particle, 2, Vector(stack_100, (stack / 10) - (stack_100 * 10), 0))
		ParticleManager:SetParticleControl(self.particle, 3, Vector(1, 1, 1))
	else
		ParticleManager:SetParticleControl(self.particle, 2, Vector(stack / 10, 0, 0))
		ParticleManager:SetParticleControl(self.particle, 3, Vector(0, 0, 0))
	end
end

function modifier_mutation_kill_streak_power:GetModifierIncomingDamage_Percentage()
	return self.damage_increase * self:GetStackCount()
end

function modifier_mutation_kill_streak_power:GetModifierDamageOutgoing_Percentage()
	return self.damage_increase * self:GetStackCount()
end

function modifier_mutation_kill_streak_power:GetModifierSpellAmplify_Percentage()
	return self.damage_increase * self:GetStackCount()
end

function modifier_mutation_kill_streak_power:OnDeath(keys)
	if keys.unit == self:GetParent() and not keys.unit:IsImbaReincarnating() then
		self:SetStackCount(0)
		ParticleManager:SetParticleControl(self.particle, 2, Vector(0, 0, 0))
		ParticleManager:SetParticleControl(self.particle, 3, Vector(0, 0, 0))
	end
end

function modifier_mutation_kill_streak_power:GetModifierModelScale()
	if IsServer() then
		return math.min(self:GetStackCount() * 10, self.maximum_size)
	end
end
