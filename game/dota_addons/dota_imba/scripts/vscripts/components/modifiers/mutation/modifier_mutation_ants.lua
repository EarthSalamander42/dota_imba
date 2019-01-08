modifier_mutation_ants = class({})

function modifier_mutation_ants:IsHidden() return true end
function modifier_mutation_ants:RemoveOnDeath() return false end

function modifier_mutation_ants:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_HERO_KILLED,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}

	return funcs
end

function modifier_mutation_ants:OnCreated()
	self.minimum_cap = IMBA_MUTATION_DEFENSE_OF_THE_ANTS_MIN_SCALE
	self:SetStackCount(0)
end

function modifier_mutation_ants:OnDeath(keys)
	if not IsServer() then
		return nil
	end

	if keys.unit == self:GetParent() then
		self:SetStackCount(self:GetStackCount() + 1)
	end
end

function modifier_mutation_ants:OnHeroKilled(params)
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

	-- If we ourselves are an illusion, don't gain charges
	if self:GetParent():IsIllusion() then
		return nil
	end

	-- Same team
	if self:GetParent():GetTeamNumber() == target:GetTeamNumber() then
		return nil
	end

	self:SetStackCount(self:GetStackCount() - 1)
end

function modifier_mutation_ants:GetModifierModelScale()
	return math.max(-IMBA_MUTATION_DEFENSE_OF_THE_ANTS_SCALE * self:GetStackCount(), self.minimum_cap)
end