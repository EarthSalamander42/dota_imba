-- Creator:
--	   AltiV, December 10th, 2019

LinkLuaModifier("modifier_imba_form_change", "components/abilities/imba_form_change", LUA_MODIFIER_MOTION_NONE)

imba_form_change 			= imba_form_change or class({})
modifier_imba_form_change	= modifier_imba_form_change or class({})

----------------------
-- IMBA_FORM_CHANGE --
----------------------

function imba_form_change:IsInnateAbility()	return true end
function imba_form_change:IsStealable()		return false end

function imba_form_change:GetIntrinsicModifierName()
	return "modifier_imba_form_change"
end

function imba_form_change:OnSpellStart()

end

-------------------------------
-- MODIFIER_IMBA_FORM_CHANGE --
-------------------------------

function modifier_imba_form_change:DestroyOnExpire()	return false end

function modifier_imba_form_change:OnCreated()
	if not IsServer() then return end
	
	self:SetDuration(self:GetAbility():GetSpecialValueFor("duration"), true)
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("duration"))
end

function modifier_imba_form_change:OnIntervalThink()
	if self:GetAbility() then
		self:GetAbility():SetHidden(true)
	end
	
	self:StartIntervalThink(-1)
end

function modifier_imba_form_change:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ORDER}
end

function modifier_imba_form_change:OnOrder(keys)
	if not IsServer() or not self:GetAbility() or keys.unit ~= self:GetParent() or self:GetStackCount() ~= -1 then return end
	
	self:SetStackCount(-1)
	self:SetDuration(self:GetAbility():GetSpecialValueFor("duration"), true)
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("duration"))
end