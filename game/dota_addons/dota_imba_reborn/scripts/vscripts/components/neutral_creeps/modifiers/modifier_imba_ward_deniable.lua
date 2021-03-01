modifier_imba_ward_deniable = modifier_imba_ward_deniable or class({})

function modifier_imba_ward_deniable:IsHidden() return true end
function modifier_imba_ward_deniable:IsPurgable() return false end
function modifier_imba_ward_deniable:GetEffectName() return "particles/msg_fx/msg_deniable.vpcf" end
function modifier_imba_ward_deniable:CheckState() return {
	[MODIFIER_STATE_SPECIALLY_DENIABLE] = true,
} end
