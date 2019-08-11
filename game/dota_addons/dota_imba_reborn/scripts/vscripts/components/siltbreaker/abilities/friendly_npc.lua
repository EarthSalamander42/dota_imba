
friendly_npc = class({})
LinkLuaModifier( "modifier_friendly_npc", "components/siltbreaker/modifiers/modifier_friendly_npc", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function friendly_npc:GetIntrinsicModifierName()
	return "modifier_friendly_npc"
end

--------------------------------------------------------------------------------

