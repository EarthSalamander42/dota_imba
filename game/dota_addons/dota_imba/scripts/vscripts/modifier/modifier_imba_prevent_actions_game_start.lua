--[[	Author: Firetoad
		Date: 15.02.2017	]]

if modifier_imba_prevent_actions_game_start == nil then
	modifier_imba_prevent_actions_game_start = class({})
end

function modifier_imba_prevent_actions_game_start:CheckState()
	local state = {
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

function modifier_imba_prevent_actions_game_start:GetDuration()
	return 60
end

function modifier_imba_prevent_actions_game_start:IsHidden()
	return true
end