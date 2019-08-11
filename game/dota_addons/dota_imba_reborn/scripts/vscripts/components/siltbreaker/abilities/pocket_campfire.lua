
pocket_campfire = class({})

LinkLuaModifier( "modifier_pocket_campfire", "components/siltbreaker/modifiers/modifier_pocket_campfire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pocket_campfire_effect", "components/siltbreaker/modifiers/modifier_pocket_campfire_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function pocket_campfire:GetIntrinsicModifierName()
	return "modifier_pocket_campfire"
end

--------------------------------------------------------------------------------

