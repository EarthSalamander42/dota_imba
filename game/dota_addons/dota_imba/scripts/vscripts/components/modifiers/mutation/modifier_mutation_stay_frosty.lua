modifier_mutation_stay_frosty = class({})

function modifier_mutation_stay_frosty:IsHidden() return true end
function modifier_mutation_stay_frosty:RemoveOnDeath() return false end
function modifier_mutation_stay_frosty:DeclareFunctions()
	local funcs = 	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_mutation_stay_frosty:GetDisableHealing()
	return 1
end

function modifier_mutation_stay_frosty:OnCreated()
	if IsServer() then
		self.health_regen = 0
		self:StartIntervalThink(0.1)
	end
end

function modifier_mutation_stay_frosty:OnIntervalThink()
	if IsServer() then
		-- get base hero regen
		local base_regen = self:GetParent():GetBaseHealthRegen()
		-- get regen from items and passives
		local additional_regen = self:GetParent():GetHealthRegen()
		-- current regen
		local current_regen = self.health_regen
		-- my brain cant handle negative numbers... sorry
		if current_regen < 0 then 
			current_regen = current_regen * -1.0
		end

		if item_regen == 0 then 
			self.health_regen  = base_regen * -1.0
		else
			if additional_regen > 0 then
				self.health_regen = (base_regen - additional_regen)
			else
				self.health_regen = self.health_regen - (additional_regen/2)
			end
		end
		
		--print("health_regen: ", self.health_regen, base_regen, additional_regen)
	end
end

function modifier_mutation_stay_frosty:GetModifierConstantHealthRegen()
	if IsServer() then 
		return self.health_regen
	end
end
