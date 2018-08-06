--[[	Max health regen cap.
		Author: EarthSalamander #42
		Date:	06.08.2018	]]

modifier_ultimate_level = class({})
function modifier_ultimate_level:IsHidden() return true end
function modifier_ultimate_level:IsDebuff() return false end
function modifier_ultimate_level:IsPurgable() return false end
function modifier_ultimate_level:IsPermanent() return true end

function modifier_ultimate_level:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.25)
	end
end

function modifier_ultimate_level:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_ultimate_level:OnIntervalThink()
	if IsServer() then
		self.health_regen = 0

		-- restrict maximum health regen
		if IMBA_MUTATION and IMBA_MUTATION["positive"] == "ultimate_level" then
			if self:GetParent():HasItemInInventory("item_imba_heart") then
				self.health_regen = modifier_ultimate_level:CalculateMaxHealthRegen(self:GetParent():GetHealthRegen(), 600)
			else
				self.health_regen = modifier_ultimate_level:CalculateMaxHealthRegen(self:GetParent():GetHealthRegen(), 300)
			end
			print("Ultimate Level mutator is on:", self:GetParent():GetHealthRegen(), self.health_regen)
		end
	end
end

function modifier_ultimate_level:CalculateMaxHealthRegen(regen, max_regen)
	if regen < max_regen then
		return regen
	else
		return regen - max_regen * (-1)
	end
end

-- Health regeneration max cap handler
function modifier_ultimate_level:GetModifierConstantHealthRegen()
	if IsServer() then
		return self.health_regen
	end
end
