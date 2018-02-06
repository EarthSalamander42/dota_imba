-- Author: Shush
-- Date: 12.03.2017

-----------------------
--    MORBID MASK    --
-----------------------

item_imba_morbid_mask = class({})
LinkLuaModifier("modifier_imba_morbid_mask", "items/item_lifesteal.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_morbid_mask_unique", "items/item_lifesteal.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_morbid_mask:GetIntrinsicModifierName()
    return "modifier_imba_morbid_mask"
end

function item_imba_morbid_mask:GetAbilityTextureName()
   return "item_lifesteal"
end

-- morbid mask modifier
modifier_imba_morbid_mask = class({})

function modifier_imba_morbid_mask:OnCreated()        
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()    
    self.particle_lifesteal = "particles/generic_gameplay/generic_lifesteal.vpcf"

    -- Ability specials
    self.damage_bonus = self.ability:GetSpecialValueFor("damage_bonus")    

    if IsServer() then
        -- Change to lifesteal projectile, if there's nothing "stronger"    
        ChangeAttackProjectileImba(self.caster)

        if not self.caster:HasModifier("modifier_imba_morbid_mask_unique") then
            self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_morbid_mask_unique", {})
        end
    end
end

function modifier_imba_morbid_mask:DeclareFunctions()
    local decFunc = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                     MODIFIER_EVENT_ON_ATTACK_LANDED}

    return decFunc
end

function modifier_imba_morbid_mask:GetModifierPreAttack_BonusDamage()
    return self.damage_bonus
end

function modifier_imba_morbid_mask:OnDestroy()
    if IsServer() then
        if not self.caster:HasModifier("modifier_imba_morbid_mask") then
            self.caster:RemoveModifierByName("modifier_imba_morbid_mask_unique")
        end

        -- Remove lifesteal projectile
        ChangeAttackProjectileImba(self.caster) 
    end
end

function modifier_imba_morbid_mask:IsHidden()
    return true
end

function modifier_imba_morbid_mask:IsPurgable()
    return false
end

function modifier_imba_morbid_mask:IsDebuff()
    return false
end

function modifier_imba_morbid_mask:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

modifier_imba_morbid_mask_unique = class({})
function modifier_imba_morbid_mask_unique:IsHidden() return true end
function modifier_imba_morbid_mask_unique:IsPurgable() return false end
function modifier_imba_morbid_mask_unique:IsDebuff() return false end

function modifier_imba_morbid_mask_unique:OnCreated()
    -- Ability properties
    self.ability = self:GetAbility()

    -- Ability specials
    self.lifesteal_pct = self.ability:GetSpecialValueFor("lifesteal_pct")
end

function modifier_imba_morbid_mask_unique:OnRefresh()
    self:OnCreated()
end

function modifier_imba_morbid_mask_unique:GetModifierLifesteal()
    return self.lifesteal_pct 
end