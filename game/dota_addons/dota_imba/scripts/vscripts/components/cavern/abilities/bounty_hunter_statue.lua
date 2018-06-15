
bounty_hunter_statue = class({})
LinkLuaModifier( "modifier_bounty_hunter_statue", "components/cavern/modifiers/modifier_bounty_hunter_statue", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bounty_hunter_statue_activatable", "components/cavern/modifiers/modifier_bounty_hunter_statue_activatable", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bounty_hunter_statue_aura_effect", "components/cavern/modifiers/modifier_bounty_hunter_statue_aura_effect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bounty_hunter_statue_casting", "components/cavern/modifiers/modifier_bounty_hunter_statue_casting", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_statue_inactive", "components/cavern/modifiers/modifier_statue_inactive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function bounty_hunter_statue:GetIntrinsicModifierName()
	return "modifier_bounty_hunter_statue"
end

--------------------------------------------------------------------------------
