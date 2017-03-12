-- Author: Shush
-- Date: 12.03.2017

-----------------------
--  MASK OF MADNESS  --
-----------------------

item_imba_mask_of_madness = class({})
LinkLuaModifier("modifier_imba_mask_of_madness", "items/item_mask_of_madness.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mask_of_madness_berserk", "items/item_mask_of_madness.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mask_of_madness_rage", "items/item_mask_of_madness.lua", LUA_MODIFIER_MOTION_NONE)


function item_imba_mask_of_madness:GetIntrinsicModifierName()
    return "modifier_imba_mask_of_madness"
end

function item_imba_mask_of_madness:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local modifier_berserk = "modifier_imba_mask_of_madness_berserk"

    -- Ability specials
    local berserk_duration = ability:GetSpecialValueFor("berserk_duration")

    -- Berserk!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    caster:AddNewModifier(caster, ability, modifier_berserk, {duration = berserk_duration})
end

-- Passive MoM modifier
modifier_imba_mask_of_madness = class({})

function modifier_imba_mask_of_madness:OnCreated()        
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()    
        self.particle_lifesteal = "particles/generic_gameplay/generic_lifesteal.vpcf"
        self.modifier_rage = "modifier_imba_mask_of_madness_rage"   

        -- Ability specials
        self.damage_bonus = self.ability:GetSpecialValueFor("damage_bonus")
        self.lifesteal_pct = self.ability:GetSpecialValueFor("lifesteal_pct")
        self.rage_damage_bonus = self.ability:GetSpecialValueFor("rage_damage_bonus")
        self.rage_lifesteal_bonus_pct = self.ability:GetSpecialValueFor("rage_lifesteal_bonus_pct")

    if IsServer() then
        -- Change to lifesteal projectile, if there's nothing "stronger"    
        ChangeAttackProjectileImba(self.caster)
    end
end

function modifier_imba_mask_of_madness:DeclareFunctions()
    local decFunc = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                     MODIFIER_EVENT_ON_ATTACK_LANDED}

    return decFunc
end

function modifier_imba_mask_of_madness:GetModifierPreAttack_BonusDamage()    
    local damage_bonus = self.damage_bonus

    -- Check for rage!!
    if self.caster:HasModifier(self.modifier_rage) then
        damage_bonus = damage_bonus + self.rage_damage_bonus
    end

    return damage_bonus
end

function modifier_imba_mask_of_madness:OnAttackLanded(keys)
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

            -- Calculate lifesteal percentage, in case of a rage
            local lifesteal_pct = self.lifesteal_pct

            if self.caster:HasModifier(self.modifier_rage) then
                lifesteal_pct = lifesteal_pct + self.rage_lifesteal_bonus_pct
            end

            -- Calculate heal amount
            local lifesteal = damage * (lifesteal_pct/100)

            -- Heal as a percent of the damage dealt
            self.caster:Heal(lifesteal, self.caster)
        end
    end
end

function modifier_imba_mask_of_madness:OnDestroy()
    if IsServer() then
        -- Remove lifesteal projectile
        ChangeAttackProjectileImba(self.caster) 
    end
end

function modifier_imba_mask_of_madness:IsHidden()
    return true
end

function modifier_imba_mask_of_madness:IsPurgable()
    return false
end

function modifier_imba_mask_of_madness:IsDebuff()
    return false
end


-- Berserk modifier
modifier_imba_mask_of_madness_berserk = class({})

function modifier_imba_mask_of_madness_berserk:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility() 
    self.modifier_rage = "modifier_imba_mask_of_madness_rage"   
    self.sound_rage = "Hero_Clinkz.Strafe"

    -- Ability specials
    self.berserk_attack_speed = self.ability:GetSpecialValueFor("berserk_attack_speed")
    self.berserk_ms_bonus_pct = self.ability:GetSpecialValueFor("berserk_ms_bonus_pct")    
    self.berserk_armor_reduction = self.ability:GetSpecialValueFor("berserk_armor_reduction")
    self.rage_ms_bonus_pct = self.ability:GetSpecialValueFor("rage_ms_bonus_pct")        
    self.rage_max_distance = self.ability:GetSpecialValueFor("rage_max_distance")

    if IsServer() then
        self:StartIntervalThink(0.2)
    end
end

function modifier_imba_mask_of_madness_berserk:OnIntervalThink()
    if IsServer() then
        -- If caster isn't raging, do nothing
        if not self.caster:HasModifier(self.modifier_rage) then
            return nil
        end

        -- Check if rage target is dead - if he is, remove rage modifier and go out
        if not self.rage_target or not self.rage_target:IsAlive() then
            self.caster:RemoveModifierByName(self.modifier_rage)
            return nil
        end

        -- If the target cannot be seen by the caster, remove rage modifier
        if not self.caster:CanEntityBeSeenByMyTeam(self.rage_target) then
            self.caster:RemoveModifierByName(self.modifier_rage)
            return nil
        end

        -- Check distance between the caster and his rage target
        local distance = (self.caster:GetAbsOrigin() - self.rage_target:GetAbsOrigin()):Length2D()

        -- If distance between them is too high, stop raging
        if distance >= self.rage_max_distance then
            self.caster:RemoveModifierByName(self.modifier_rage)        
        end
    end
end

function modifier_imba_mask_of_madness_berserk:GetEffectName()
         return "particles/items2_fx/mask_of_madness.vpcf"          
end

function modifier_imba_mask_of_madness_berserk:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_mask_of_madness_berserk:DeclareFunctions()
    local decFunc = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
                    MODIFIER_EVENT_ON_ATTACK_LANDED}

    return decFunc
end

function modifier_imba_mask_of_madness_berserk:GetModifierMoveSpeedBonus_Percentage()
    local ms_bonus = self.berserk_ms_bonus_pct

    -- In a rage!! Get move speed bonus
    if self.caster:HasModifier(self.modifier_rage) then
        ms_bonus = ms_bonus + self.rage_ms_bonus_pct
    end

    return ms_bonus
end

function modifier_imba_mask_of_madness_berserk:GetModifierAttackSpeedBonus_Constant()
    return self.berserk_attack_speed
end

function modifier_imba_mask_of_madness_berserk:GetModifierPhysicalArmorBonus()
    return self.berserk_armor_reduction * (-1)
end

function modifier_imba_mask_of_madness_berserk:CheckState()
    local state = {[MODIFIER_STATE_SILENCED] = true}
    return state
end

function modifier_imba_mask_of_madness_berserk:OnAttackLanded(keys)
    if IsServer() then
        local target = keys.target
        local attacker = keys.attacker

        -- Only apply on caster being the attacker, on other team, and when he doesn't have Rage
        if self.caster == attacker and self.caster:GetTeamNumber() ~= target:GetTeamNumber() and not self.caster:HasModifier(self.modifier_rage) then
            -- Also, only apply if the target is a hero
            if target:IsHero() then
                -- Mark target for rage distance checks
                self.rage_target = target

                -- Start a rage! (disables commands)
                self.caster:AddNewModifier(self.caster, self.ability, self.modifier_rage, {})

                -- Sound a rage!
                EmitSoundOn(self.sound_rage, self.caster)

                -- Force attacking the target
                self.caster:MoveToTargetToAttack(target)                
            end            
        end
    end
end

function modifier_imba_mask_of_madness_berserk:OnDestroy()
    if IsServer() then
        -- Remove rage
        if self.caster:HasModifier(self.modifier_rage) then
            self.caster:RemoveModifierByName(self.modifier_rage)
        end
    end
end

function modifier_imba_mask_of_madness_berserk:IsHidden()
    return false
end

function modifier_imba_mask_of_madness_berserk:IsPurgable()
    return false
end

function modifier_imba_mask_of_madness_berserk:IsDebuff()
    return false
end


-- Rage modifier
modifier_imba_mask_of_madness_rage = class({})

function modifier_imba_mask_of_madness_rage:CheckState()
    local state = {[MODIFIER_STATE_COMMAND_RESTRICTED] = true}
    return state
end

function modifier_imba_mask_of_madness_rage:IsHidden()
    return false
end

function modifier_imba_mask_of_madness_rage:IsPurgable()
    return false
end

function modifier_imba_mask_of_madness_rage:IsDebuff()
    return false
end

function modifier_imba_mask_of_madness_rage:GetEffectName()
    return "particles/econ/items/drow/drow_head_mania/mask_of_madness_active_mania.vpcf"
end

function modifier_imba_mask_of_madness_rage:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end
