imprisoned_soldier = class({})
LinkLuaModifier( "modifier_imprisoned_soldier", "components/siltbreaker/modifiers/modifier_imprisoned_soldier", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imprisoned_soldier_animation", "components/siltbreaker/modifiers/modifier_imprisoned_soldier_animation", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function imprisoned_soldier:GetIntrinsicModifierName()
	return "modifier_imprisoned_soldier"
end

--------------------------------------------------------------------------------

