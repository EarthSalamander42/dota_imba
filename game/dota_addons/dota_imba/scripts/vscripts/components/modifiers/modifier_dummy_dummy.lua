modifier_dummy_dummy = class({})

function modifier_dummy_dummy:IsHidden() return true end
function modifier_dummy_dummy:IsPurgable() return false end

function modifier_dummy_dummy:CheckState()
    local state = {
        [MODIFIER_STATE_NO_UNIT_COLLISION]  = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_INVULNERABLE]       = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP]     = true,
        [MODIFIER_STATE_UNSELECTABLE]       = true,
        [MODIFIER_STATE_OUT_OF_GAME]        = true,
        [MODIFIER_STATE_NO_HEALTH_BAR]      = true,
        [MODIFIER_STATE_ROOTED]             = true,
    }
    return state
end
