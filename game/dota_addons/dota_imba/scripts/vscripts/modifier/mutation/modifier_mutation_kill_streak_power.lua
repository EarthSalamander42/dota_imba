modifier_mutation_kill_streak_power = class({})

function modifier_mutation_kill_streak_power:IsHidden() return false end
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
	self.damage_increase = 20 -- %
	self.maximum_size = 75

	if IsServer() then
		self.particle = ParticleManager:CreateParticle("particles/hw_fx/candy_carrying_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 2, Vector(0, 0, 0))
		ParticleManager:SetParticleControl(self.particle, 3, Vector(0, 0, 0))
	end
end

function modifier_mutation_kill_streak_power:OnHeroKilled(params)
	if not IsServer() then
		return nil
	end

	local target = params.target

	-- Don't gain charges off of illusions
	if not target:IsRealHero() then
		return nil
	end
	-- If we ourselves are an illusion, don't gain charges
	if self:GetParent():IsIllusion() then
		return nil
	end
	-- Same team
	if self:GetParent():GetTeamNumber() == target:GetTeamNumber() then
		return nil
	end

	self:SetStackCount(self:GetStackCount() + 1)

	local stack = self:GetStackCount() * 20
	local stack_100 = math.floor(stack / 100)

	if stack_100 > 0 then
		ParticleManager:SetParticleControl(self.particle, 2, Vector(stack_100, (stack / 10) - (stack_100 * 10), 0))
		ParticleManager:SetParticleControl(self.particle, 3, Vector(1, 1, 1))
	else
		ParticleManager:SetParticleControl(self.particle, 2, Vector(0, stack / 10, 0))
		ParticleManager:SetParticleControl(self.particle, 3, Vector(0, 1, 0))
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
	if keys.unit == self:GetParent() then
		self:SetStackCount(0)
		ParticleManager:SetParticleControl(self.particle, 2, Vector(0, 0, 0))
		ParticleManager:SetParticleControl(self.particle, 3, Vector(0, 1, 1))
	end
end

function modifier_mutation_kill_streak_power:GetModifierModelScale()
	if IsServer() then
		return math.min(self:GetStackCount() * 20, self.maximum_size)
	end
end
