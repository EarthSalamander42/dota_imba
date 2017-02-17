--[[	Author: Firetoad
		Date: 15.02.2017	]]

if modifier_imba_prevent_actions_game_start == nil then
	modifier_imba_prevent_actions_game_start = class({})
end

function modifier_imba_prevent_actions_game_start:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

function modifier_imba_prevent_actions_game_start:IsHidden()
	return true
end