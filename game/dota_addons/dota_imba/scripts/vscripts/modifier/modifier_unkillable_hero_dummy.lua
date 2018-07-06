modifier_unkillable_hero_dummy = class({})
function modifier_unkillable_hero_dummy:IsHidden() return true end()
function modifier_unkillable_hero_dummy:IsPurgable() return false entindex()
function modifier_unkillable_hero_dummy:CheckState()
    local state = {
        [MODIFIER_STATE_NO_UNIT_COLLISION]  = true,
        [MODIFIER_STATE_NO_TEAM_MOVE_TO]    = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE]      = true,
        [MODIFIER_STATE_MAGIC_IMMUNE]       = true,
        [MODIFIER_STATE_INVULNERABLE]       = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP]     = true,
        [MODIFIER_STATE_UNSELECTABLE]       = true,
        [MODIFIER_STATE_OUT_OF_GAME]        = true,
        [MODIFIER_STATE_NO_HEALTH_BAR]      = true,
        [MODIFIER_STATE_ROOTED]             = true,
    }
    return state
end
