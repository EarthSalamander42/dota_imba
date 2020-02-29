--[[	Author: Firetoad
		Date: 12.05.2017	]]

if modifier_imba_donator_statue == nil then
	modifier_imba_donator_statue = class({})
end

function modifier_imba_donator_statue:CheckState()
	local state = {
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	}

	return state
end

function modifier_imba_donator_statue:GetStatusEffectName()
	return "particles/ambient/contributor_effigy_fx.vpcf"
end

function modifier_imba_donator_statue:IsHidden()
	return true
end
