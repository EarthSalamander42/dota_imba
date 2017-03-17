-- Author: Shush
-- Date: 12.03.2017

-----------------------
--    MORBID MASK    --
-----------------------

item_imba_morbid_mask = class({})
LinkLuaModifier("modifier_imba_morbid_mask", "items/item_lifesteal.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_morbid_mask:GetIntrinsicModifierName()
    return "modifier_imba_morbid_mask"
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
        self.lifesteal_pct = self.ability:GetSpecialValueFor("lifesteal_pct")
    if IsServer() then
        -- Change to lifesteal projectile, if there's nothing "stronger"    
        ChangeAttackProjectileImba(self.caster)
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

function modifier_imba_morbid_mask:OnAttackLanded(keys)
    if IsServer() then
        local attacker = keys.attacker
        local target = keys.target
        local damage = keys.damage

        -- Only apply on caster attacking an enemy
        if self.caster == attacker and self.caster:GetTeamNumber() ~= target:GetTeamNumber() then
            -- If it is not a hero or a unit, do nothing            
            if not target:IsHero() and not target:IsCreep() then
                return nil
            end

            -- Apply particle
            self.particle_lifesteal_fx = ParticleManager:CreateParticle(self.particle_lifesteal, PATTACH_ABSORIGIN, self.caster)
            ParticleManager:SetParticleControl(self.particle_lifesteal_fx, 0, self.caster:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(self.particle_lifesteal_fx)

            -- Only actually lifesteal if it's not an illusion
            if self.caster:IsIllusion() then
                return nil
            end

            -- Calculate heal amount
            local lifesteal = damage * (self.lifesteal_pct/100)

            -- Heal as a percent of the damage dealt
            self.caster:Heal(lifesteal, self.caster)
        end
    end
end

function modifier_imba_morbid_mask:OnDestroy()
    if IsServer() then
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