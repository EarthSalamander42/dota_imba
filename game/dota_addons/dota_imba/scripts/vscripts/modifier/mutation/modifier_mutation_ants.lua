modifier_mutation_ants = class({})

function modifier_mutation_ants:IsHidden() return true end
function modifier_mutation_ants:RemoveOnDeath() return false end

function modifier_mutation_ants:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}

	return funcs
end

function modifier_mutation_ants:OnCreated()
	self.minimum_cap = -75
	self:SetStackCount(0)
end

function modifier_mutation_ants:OnDeath(keys)
	if keys.unit == self:GetParent() then
		self:SetStackCount(self:GetStackCount() + 1)
	end
end

function modifier_mutation_ants:GetModifierModelScale()
	return math.max(-(5 * self:GetStackCount()), self.minimum_cap)
end
