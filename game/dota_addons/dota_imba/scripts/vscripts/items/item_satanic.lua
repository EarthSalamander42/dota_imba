-- Author: Shush
-- Date: 12.03.2017

-----------------------
--    SATANIC        --
-----------------------

item_imba_satanic = class({})
LinkLuaModifier("modifier_imba_satanic", "items/item_satanic.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_satanic_active", "items/item_satanic.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_satanic_soul_slaughter", "items/item_satanic.lua", LUA_MODIFIER_MOTION_NONE)


function item_imba_satanic:GetIntrinsicModifierName()
    return "modifier_imba_satanic"
end

function item_imba_satanic:OnSpellStart()
    -- Ability properties    
    local caster = self:GetCaster()
    local ability = self
    local modifier_unholy = "modifier_imba_satanic_active"

    -- Ability specials
    local unholy_rage_duration = ability:GetSpecialValueFor("unholy_rage_duration")

    -- Unholy rage!
    caster:AddNewModifier(caster, ability, modifier_unholy, {duration = unholy_rage_duration})
end

-- morbid mask modifier
modifier_imba_satanic = class({})

function modifier_imba_satanic:OnCreated()        
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()    
        self.particle_lifesteal = "particles/generic_gameplay/generic_lifesteal.vpcf"
        self.modifier_unholy = "modifier_imba_satanic_active"
        self.modifier_soul = "modifier_imba_satanic_soul_slaughter"

        -- Ability specials
        self.damage_bonus = self.ability:GetSpecialValueFor("damage_bonus")
        self.lifesteal_pct = self.ability:GetSpecialValueFor("lifesteal_pct")
        self.strength_bonus = self.ability:GetSpecialValueFor("strength_bonus")        
        self.unholy_rage_lifesteal_bonus = self.ability:GetSpecialValueFor("unholy_rage_lifesteal_bonus")
        self.soul_slaughter_hp_increase_pct = self.ability:GetSpecialValueFor("soul_slaughter_hp_increase_pct")
        self.soul_slaughter_creep_duration = self.ability:GetSpecialValueFor("soul_slaughter_creep_duration")
        self.soul_slaughter_hero_duration = self.ability:GetSpecialValueFor("soul_slaughter_hero_duration")

    if IsServer() then
        -- Change to lifesteal projectile, if there's nothing "stronger"    
        ChangeAttackProjectileImba(self.caster)       
    end
end

function modifier_imba_satanic:DeclareFunctions()
    local decFunc = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                     MODIFIER_EVENT_ON_ATTACK_LANDED,
                     MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}

    return decFunc
end

function modifier_imba_satanic:GetModifierPreAttack_BonusDamage()
    return self.damage_bonus
end

function modifier_imba_satanic:GetModifierBonusStats_Strength()
    return self.strength_bonus
end

function modifier_imba_satanic:OnAttackLanded(keys)
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

            -- Calculate lifesteal amount
            local lifesteal_pct = self.lifesteal_pct

            if self.caster:HasModifier(self.modifier_unholy) then
                lifesteal_pct = lifesteal_pct + self.unholy_rage_lifesteal_bonus
            end

            -- Calculate heal amount
            local lifesteal = damage * (lifesteal_pct/100)

            -- Heal as a percent of the damage dealt
            self.caster:Heal(lifesteal, self.caster)

            -- Wait a gametick to let things die
            Timers:CreateTimer(FrameTime(), function()
                -- If the target is an illusion, do nothing
                if target:IsIllusion() then
                    return nil
                end

                -- Check if the target died as a result of that attack
                if not target:IsAlive() then
                    -- Calculate soul worth in health and stacks
                    local soul_health = target:GetMaxHealth() * (self.soul_slaughter_hp_increase_pct/100) 
                    local soul_stacks = (soul_health/10)

                    -- Assign correct duration
                    local duration
                    if target:IsHero() then
                        duration = self.soul_slaughter_hero_duration
                    else
                        duration = self.soul_slaughter_creep_duration
                    end

                    -- Set variable
                    local modifier_soul_feast

                    -- Feast on its soul!
                    -- Check if the buff already exists, otherwise, add it
                    if self.caster:HasModifier(self.modifier_soul) then
                        modifier_soul_feast = self.caster:FindModifierByName(self.modifier_soul)
                        modifier_soul_feast:SetStackCount(modifier_soul_feast:GetStackCount() + soul_stacks)

                        -- Refresh the buff if the new duration is higher than the current remaining duration
                        if modifier_soul_feast:GetRemainingTime() < duration then
                            modifier_soul_feast:SetDuration(duration, true)
                        end

                    else
                        modifier_soul_feast = self.caster:AddNewModifier(self.caster, self.ability, self.modifier_soul, {duration = duration})
                    end

                    -- Give stacks
                    if modifier_soul_feast then
                        modifier_soul_feast:SetStackCount(modifier_soul_feast:GetStackCount() + soul_stacks)
                    end
                end
            end)
            
        end
    end
end

function modifier_imba_satanic:OnDestroy()
    if IsServer() then
        -- Remove lifesteal projectile
        ChangeAttackProjectileImba(self.caster) 
    end
end

function modifier_imba_satanic:IsHidden()
    return true
end

function modifier_imba_satanic:IsPurgable()
    return false
end

function modifier_imba_satanic:IsDebuff()
    return false
end

-- Active Satanic modifier
modifier_imba_satanic_active = class({})

function modifier_imba_satanic_active:IsHidden()
    return false
end

function modifier_imba_satanic_active:IsPurgable()
    return true
end

function modifier_imba_satanic_active:IsDebuff()
    return false
end

function modifier_imba_satanic_active:GetEffectName()
    return "particles/items2_fx/satanic_buff.vpcf"
end

function modifier_imba_satanic_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


-- Soul Slaughter modifier
modifier_imba_satanic_soul_slaughter = class({})

function modifier_imba_satanic_soul_slaughter:OnCreated()
    self.ability = self:GetAbility()
    self.soul_slaughter_damage_per_stack = self.ability:GetSpecialValueFor("soul_slaughter_damage_per_stack")
    self.soul_slaughter_hp_per_stack = self.ability:GetSpecialValueFor("soul_slaughter_hp_per_stack")
end

function modifier_imba_satanic_soul_slaughter:IsHidden()
    return false
end

function modifier_imba_satanic_soul_slaughter:IsPurgable()
    return true
end

function modifier_imba_satanic_soul_slaughter:IsDebuff()
    return false
end

function modifier_imba_satanic_soul_slaughter:DeclareFunctions()
    local decFunc = {MODIFIER_PROPERTY_HEALTH_BONUS,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}

    return decFunc
end

function modifier_imba_satanic_soul_slaughter:GetModifierHealthBonus()
    local stacks = self:GetStackCount()
    return (stacks * self.soul_slaughter_hp_per_stack)
end

function modifier_imba_satanic_soul_slaughter:GetModifierPreAttack_BonusDamage()
    local stacks = self:GetStackCount()
    return (stacks * self.soul_slaughter_damage_per_stack)
end