modifier_attack_range_activity = class({})

require('libraries/modifiers/animation_code')

function modifier_attack_range_activity:OnCreated(keys)
    if not IsServer() then
        self.translate = _CODE_TO_ANIMATION_TRANSLATE[keys.stack_count]
    else
        self.translate = keys.translate
    end
end

function modifier_attack_range_activity:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE --+ MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_attack_range_activity:IsHidden()
    return true
end

function modifier_attack_range_activity:IsDebuff()
    return false
end

function modifier_attack_range_activity:IsPurgable()
    return false
end

function modifier_attack_range_activity:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }

    return funcs
end

function modifier_attack_range_activity:GetActivityTranslationModifiers(...)
    -- print("TRANSLATE MODIFIER", IsServer())
    --print(self.translate)
    if IsServer() then
        local hParent = self:GetParent()
        local target = hParent:GetAttackTarget()
        if not target then
            return 0
        end
        local distance = (hParent:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()
        local AttackRangeAM = ActivityModifier.units[hParent:GetUnitName()].AttackRangeActivityModifiers
        local translate = nil
        local maxModifierDistance = -1
        for modifier_distance, activity_modifier in pairs(AttackRangeAM) do
            if distance > modifier_distance and modifier_distance > maxModifierDistance then
                maxModifierDistance = modifier_distance
                translate = activity_modifier
            end
        end
        if not translate then
            return 0
        end
        if self.translate == translate then
            return translate
        else
            hParent:RemoveModifierByName("modifier_attack_range_activity")
            hParent:AddNewModifier(hParent, nil, "modifier_attack_range_activity", {translate = translate})
            hParent:SetModifierStackCount(
                "modifier_attack_range_activity",
                hParent,
                _ANIMATION_TRANSLATE_TO_CODE[translate]
            )
        end
    end
end

--[[function modifier_attack_range_activity:CheckState() 
  local state = {
    [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  }

  return state
end]]
