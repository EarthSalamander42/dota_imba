
campfire = class({})

LinkLuaModifier( "modifier_campfire", "components/siltbreaker/modifiers/modifier_campfire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_campfire_effect", "components/siltbreaker/modifiers/modifier_campfire_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function campfire:GetIntrinsicModifierName()
	return "modifier_campfire"
end

--------------------------------------------------------------------------------

