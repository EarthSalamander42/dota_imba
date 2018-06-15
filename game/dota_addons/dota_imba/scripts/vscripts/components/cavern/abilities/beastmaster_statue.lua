
beastmaster_statue = class({})
LinkLuaModifier( "modifier_beastmaster_statue", "components/cavern/modifiers/modifier_beastmaster_statue", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_beastmaster_statue_activatable", "components/cavern/modifiers/modifier_beastmaster_statue_activatable", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_beastmaster_statue_aura_effect", "components/cavern/modifiers/modifier_beastmaster_statue_aura_effect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_beastmaster_statue_casting", "components/cavern/modifiers/modifier_beastmaster_statue_casting", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_statue_inactive", "components/cavern/modifiers/modifier_statue_inactive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function beastmaster_statue:GetIntrinsicModifierName()
	return "modifier_beastmaster_statue"
end

--------------------------------------------------------------------------------
