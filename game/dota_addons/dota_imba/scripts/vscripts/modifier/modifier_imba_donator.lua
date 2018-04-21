modifier_imba_donator = class({})

function modifier_imba_donator:IsHidden() return false end

function modifier_imba_donator:GetEffectName()
	-- particles/econ/events/ti7/aegis_lvl_1000_ambient_ti7.vpcf
	-- particles/items_fx/aegis_lvl_1000_ambient_ti6.vpcf

	return "particles/items_fx/aegis_lvl_1000_ambient.vpcf"
end

function modifier_imba_donator:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
