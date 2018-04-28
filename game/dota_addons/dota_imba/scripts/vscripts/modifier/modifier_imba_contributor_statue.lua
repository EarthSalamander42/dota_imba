--[[	Author: Firetoad
		Date: 12.05.2017	]]

if modifier_imba_contributor_statue == nil then
	modifier_imba_contributor_statue = class({})
end

function modifier_imba_contributor_statue:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

function modifier_imba_contributor_statue:GetStatusEffectName()
--	return "particles/ambient/contributor_effigy_fx.vpcf"
end

function modifier_imba_contributor_statue:IsHidden()
	return true
end
