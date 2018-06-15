
beastmaster_statue_boar_poison = class({})
LinkLuaModifier( "modifier_beastmaster_statue_boar_poison", "components/cavern/modifiers/modifier_beastmaster_statue_boar_poison", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_beastmaster_statue_boar_poison_effect", "components/cavern/modifiers/modifier_beastmaster_statue_boar_poison_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function beastmaster_statue_boar_poison:GetIntrinsicModifierName()
	return "modifier_beastmaster_statue_boar_poison"
end

--------------------------------------------------------------------------------
