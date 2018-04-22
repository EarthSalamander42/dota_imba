modifier_imba_donator = class({})

function modifier_imba_donator:IsHidden() return true end
function modifier_imba_donator:IsPurgable() return false end
function modifier_imba_donator:IsPurgeException() return false end

function modifier_imba_donator:GetEffectName()
	return "particles/econ/events/ti7/ti7_hero_effect.vpcf"
end

function modifier_imba_donator:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
