if modifier_wearable_arcana_spellicons == nil then modifier_wearable_arcana_spellicons = class({}) end

function modifier_wearable_arcana_spellicons:IsHidden() return true end
function modifier_wearable_arcana_spellicons:RemoveOnDeath() return false end

function modifier_wearable_arcana_spellicons:OnCreated(keys)
	if self:GetParent():IsIllusion() then self:Destroy() return end

	self.arcana_style = 0

	if keys.style then
		self.arcana_style = keys.style
	end

	self:StartIntervalThink(1.0)
end

function modifier_wearable_arcana_spellicons:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(self.arcana_style + 1)
	end

	if IsClient() then
		if self:GetStackCount() == 0 then self:Destroy() return end
		self:GetCaster().arcana_style = self:GetStackCount() - 1
		self:StartIntervalThink(-1)
	end
end
