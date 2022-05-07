modifier_movement_speed_activity = class({})

require('libraries/modifiers/animation_code')

function modifier_movement_speed_activity:OnCreated(keys)
    if not IsServer() then
        self.translate = _CODE_TO_ANIMATION_TRANSLATE[keys.stack_count]
    else
        self.translate = keys.translate
    end
end

function modifier_movement_speed_activity:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE --+ MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_movement_speed_activity:IsHidden()
    return true
end

function modifier_movement_speed_activity:IsDebuff()
    return false
end

function modifier_movement_speed_activity:IsPurgable()
    return false
end

function modifier_movement_speed_activity:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }

    return funcs
end

function modifier_movement_speed_activity:GetActivityTranslationModifiers(...)
    --print('TRANSLATE MODIFIER', IsServer())
    --print(self.translate)
    return self.translate or 0
end

--[[function modifier_movement_speed_activity:CheckState() 
  local state = {
    [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  }

  return state
end]]
