--[[	Author: Firetoad
		Date: 12.05.2017	]]

if modifier_imba_amphibian == nil then
	modifier_imba_amphibian = class({})
end

function modifier_imba_amphibian:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true
	}

	return state
end

function modifier_imba_amphibian:IsHidden()
	return true
end