-- Author: Shush
-- Date: 08/07/2017


item_imba_ironleaf_boots = item_imba_ironleaf_boots or class({})
LinkLuaModifier("modifier_imba_ironleaf_boots", "items/item_ironleaf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ironleaf_boots_unique", "items/item_ironleaf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ironleaf_boots_meditate", "items/item_ironleaf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ironleaf_boots_leafwalk", "items/item_ironleaf", LUA_MODIFIER_MOTION_NONE)

function item_imba_ironleaf_boots:GetIntrinsicModifierName()
    return "modifier_imba_ironleaf_boots"
end

function item_imba_ironleaf_boots:GetCooldown(level)
    return self:GetSpecialValueFor("meditate_stack_break_duration")
end

-- STACKABLE IRONLEAF BOOTS STATS MODIFIER
modifier_imba_ironleaf_boots = modifier_imba_ironleaf_boots or class({})

function modifier_imba_ironleaf_boots:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_ironleaf_boots:IsHidden() return true end
function modifier_imba_ironleaf_boots:IsDebuff() return false end
function modifier_imba_ironleaf_boots:IsPurgable() return false end
function modifier_imba_ironleaf_boots:RemoveOnDeath() return false end

function modifier_imba_ironleaf_boots:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()    
    self.modifier_self = "modifier_imba_ironleaf_boots"
    self.modifier_unique = "modifier_imba_ironleaf_boots_unique"

    -- Ability specials
    self.base_move_speed = self.ability:GetSpecialValueFor("base_move_speed")
    self.base_health_regen = self.ability:GetSpecialValueFor("base_health_regen")
    self.mana_regen = self.ability:GetSpecialValueFor("mana_regen")
    self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
    self.base_magic_resistance = self.ability:GetSpecialValueFor("base_magic_resistance")

    if IsServer() then
        -- Unique modifier, if not present
        if not self.caster:HasModifier(self.modifier_unique) then
            self.caster:AddNewModifier(self.caster, self.ability, self.modifier_unique, {})
        end
    end
end

function modifier_imba_ironleaf_boots:OnDestroy()
    if IsServer() then
        -- If this is the last Ironleaf boots in inventory, remove the unique modifier
        if not self.caster:HasModifier(self.modifier_self) then
            self.caster:RemoveModifierByName(self.modifier_unique)
        end
    end
end

function modifier_imba_ironleaf_boots:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
                      MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
                      MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
                      MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                      MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}

    return decFuncs
end

function modifier_imba_ironleaf_boots:GetModifierMoveSpeedBonus_Special_Boots()
    return self.base_move_speed
end

function modifier_imba_ironleaf_boots:GetModifierConstantHealthRegen()
    return self.base_health_regen
end

function modifier_imba_ironleaf_boots:GetModifierConstantManaRegen()
    return self.mana_regen
end

function modifier_imba_ironleaf_boots:GetModifierAttackSpeedBonus_Constant()
    return self.attack_speed
end

function modifier_imba_ironleaf_boots:GetModifierMagicalResistanceBonus()
    return self.base_magic_resistance
end


-- Unique modifier, responsible for Meditate, Iron Body and Leafwalk
modifier_imba_ironleaf_boots_unique = modifier_imba_ironleaf_boots_unique or class({})

function modifier_imba_ironleaf_boots_unique:IsHidden() return true end
function modifier_imba_ironleaf_boots_unique:IsDebuff() return false end
function modifier_imba_ironleaf_boots_unique:IsPurgable() return false end
function modifier_imba_ironleaf_boots_unique:RemoveOnDeath() return false end

function modifier_imba_ironleaf_boots_unique:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.modifier_meditate = "modifier_imba_ironleaf_boots_meditate"
        self.modifier_leafwalk = "modifier_imba_ironleaf_boots_leafwalk"

        -- Ability specials
        self.iron_body_thrshold = self.ability:GetSpecialValueFor("iron_body_thrshold")
        self.iron_body_high_reduction = self.ability:GetSpecialValueFor("iron_body_high_reduction")
        self.iron_body_normal_reduction = self.ability:GetSpecialValueFor("iron_body_normal_reduction")
        self.iron_body_min_stacks_req = self.ability:GetSpecialValueFor("iron_body_min_stacks_req")
        self.leafwalk_hold_time = self.ability:GetSpecialValueFor("leafwalk_hold_time")

        -- Add meditate's modifier
        self.caster:AddNewModifier(self.caster, self.ability, self.modifier_meditate, {})

        -- Set variable
        self.last_movement = GameRules:GetGameTime()                

        -- Start timer for triggering Leafwalk
        self:StartIntervalThink(0.2)
    end
end

function modifier_imba_ironleaf_boots_unique:OnIntervalThink()
    if IsServer() then       
        -- If the caster already has Leafwalk, do nothing.
        if self.caster:HasModifier(self.modifier_leafwalk) then
            return nil
        end

        -- If the last movement was above the threshold, apply Leafwalk
        if GameRules:GetGameTime() - self.last_movement >= self.leafwalk_hold_time then
            self.caster:AddNewModifier(self.caster, self.ability, self.modifier_leafwalk, {})
        end
    end
end

function modifier_imba_ironleaf_boots_unique:OnDestroy()
    if IsServer() then
        -- Remove Meditate, and, if present, Leafwalk's modifier
        if self.caster:HasModifier(self.modifier_meditate) then
            self.caster:RemoveModifierByName(self.modifier_meditate)
        end

        if self.caster:HasModifier(self.modifier_leafwalk) then
            self.caster:RemoveModifierByName(self.modifier_leafwalk)
        end
    end
end

function modifier_imba_ironleaf_boots_unique:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
                     MODIFIER_EVENT_ON_UNIT_MOVED,
                     MODIFIER_EVENT_ON_ATTACK_START,
                     MODIFIER_EVENT_ON_ABILITY_START,
                     MODIFIER_EVENT_ON_RESPAWN}

    return decFuncs
end

function modifier_imba_ironleaf_boots_unique:OnRespawn(keys)
    if IsServer() then
        local unit = keys.unit

        -- Only apply if the caster is the one who respawned
        if self.caster == unit then

            -- Reset the movement timer
            self.last_movement = GameRules:GetGameTime()
        end
    end
end

function modifier_imba_ironleaf_boots_unique:OnAttackStart(keys)
    if IsServer() then
        local attacker = keys.attacker

        -- Only apply if the caster is the attacker
        if self.caster == attacker then

            -- Attacking resets the movement timer
            self.last_movement = GameRules:GetGameTime()
        end
    end
end

function modifier_imba_ironleaf_boots_unique:OnAbilityStart(keys)
    if IsServer() then
        local unit = keys.unit

        -- Only apply if the unit is the caster
        if self.caster == unit then

            -- Using an ability resets the movement timer
            self.last_movement = GameRules:GetGameTime()
        end
    end
end

function modifier_imba_ironleaf_boots_unique:OnUnitMoved(keys)    
    if IsServer() then
        local unit = keys.unit

        -- Only apply if the unit is the caster
        if self.caster == unit then            

            -- Mark the last time the caster has moved
            self.last_movement = GameRules:GetGameTime()
        end
    end
end

function modifier_imba_ironleaf_boots_unique:GetModifierTotal_ConstantBlock(keys)
    if IsServer() then
        local target = keys.target    
        local damage = keys.damage

        -- Only apply when the target is the caster
        if self.caster == target then

            -- Only apply if the caster has the minimum amount of Meditate stacks
            local modifier_meditate_handler = self.caster:FindModifierByName(self.modifier_meditate)
            if modifier_meditate_handler then
                local stacks = modifier_meditate_handler:GetStackCount()
                if stacks >= self.iron_body_min_stacks_req then

                    -- Check if the damage is above threshold
                    if damage >= self.iron_body_thrshold then
                        -- If so, reduce damage by the higher amount
                        return self.iron_body_high_reduction
                    else
                        -- Otherwise, reduce damage by the normal amount
                        return self.iron_body_normal_reduction
                    end
                end
            end
        end
    end
end

-- MEDITATE STACKS MODIFIER
modifier_imba_ironleaf_boots_meditate = modifier_imba_ironleaf_boots_meditate or class({})

function modifier_imba_ironleaf_boots_meditate:IsHidden() 
	if self:GetStackCount() == 0 then return true end
	return false
end
function modifier_imba_ironleaf_boots_meditate:IsPurgable() return false end
function modifier_imba_ironleaf_boots_meditate:IsDebuff() return false end
function modifier_imba_ironleaf_boots_meditate:RemoveOnDeath() return false end

function modifier_imba_ironleaf_boots_meditate:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()

    -- Ability specials
    self.meditate_interval = self.ability:GetSpecialValueFor("meditate_interval")
    self.meditate_movespeed_bonus_pct = self.ability:GetSpecialValueFor("meditate_movespeed_bonus_pct")
    self.meditate_health_regen = self.ability:GetSpecialValueFor("meditate_health_regen")
    self.meditate_magic_resistance_pct = self.ability:GetSpecialValueFor("meditate_magic_resistance_pct")
    self.max_stacks = self.ability:GetSpecialValueFor("max_stacks")
    self.meditate_stacks_loss = self.ability:GetSpecialValueFor("meditate_stacks_loss")    

    if IsServer() then
        -- Start thinking
        self:StartIntervalThink(self.meditate_interval)
    end
end

function modifier_imba_ironleaf_boots_meditate:OnIntervalThink()
    -- If boots are broken due to a recent attack, do nothing
    if not self.ability:IsCooldownReady() then
        return nil
    end

    -- If we're not in the threshold yet, increase a stack!
    local stacks = self:GetStackCount()
    if stacks < self.max_stacks then
        self:IncrementStackCount()
    end
end

function modifier_imba_ironleaf_boots_meditate:DeclareFunctions()
    local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED,
                      MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
                      MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
                      MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}

    return decFuncs
end

function modifier_imba_ironleaf_boots_meditate:GetModifierMoveSpeedBonus_Percentage()
    return self.meditate_movespeed_bonus_pct * self:GetStackCount()
end

function modifier_imba_ironleaf_boots_meditate:GetModifierConstantHealthRegen()
    return self.meditate_health_regen * self:GetStackCount()
end

function modifier_imba_ironleaf_boots_meditate:GetModifierMagicalResistanceBonus()
    return self.meditate_magic_resistance_pct * self:GetStackCount()
end


function modifier_imba_ironleaf_boots_meditate:OnAttackLanded(keys)
    if IsServer() then
        local attacker = keys.attacker
        local target = keys.target

        -- Only apply if the target is the caster
        if self.caster == target then
            
            -- Ignore attacks from teammates (WW's ult for instance)
            if attacker:GetTeamNumber() == self.caster:GetTeamNumber() then
                return nil
            end

            -- Reduce stacks by the loss amount 
            local stacks = self:GetStackCount()
            if stacks >= self.meditate_stacks_loss then
                self:SetStackCount(self:GetStackCount() - self.meditate_stacks_loss)
            else
                self:SetStackCount(0)
            end

            -- Boots go into cooldown
            self.ability:UseResources(false, false, true)

            -- Restart the interval thinker
            self:StartIntervalThink(self.meditate_interval)
        end
    end
end







-- LEAFWALK INVISIBILITY MODIFIER
modifier_imba_ironleaf_boots_leafwalk = modifier_imba_ironleaf_boots_leafwalk or class({})

function modifier_imba_ironleaf_boots_leafwalk:IsHidden() return false end
function modifier_imba_ironleaf_boots_leafwalk:IsPurgable() return false end
function modifier_imba_ironleaf_boots_leafwalk:IsDebuff() return false end

function modifier_imba_ironleaf_boots_leafwalk:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
    end
end

function modifier_imba_ironleaf_boots_leafwalk:DeclareFunctions()
    local decFuncs = {MODIFIER_EVENT_ON_ABILITY_EXECUTED,
                      MODIFIER_EVENT_ON_ATTACK,
                      MODIFIER_PROPERTY_INVISIBILITY_LEVEL}

    return decFuncs
end

function modifier_imba_ironleaf_boots_leafwalk:OnAbilityExecuted(keys)
    if IsServer() then
        local unit = keys.unit

        -- Only apply if the caster is the unit
        if self.caster == unit then

            -- Remove the modifier
            self:Destroy()
        end
    end
end

function modifier_imba_ironleaf_boots_leafwalk:OnAttack(keys)
    if IsServer() then
        local attacker = keys.attacker

        -- Only apply if the caster is the unit
        if self.caster == attacker then

            -- Remove the modifier
            self:Destroy()
        end
    end
end

function modifier_imba_ironleaf_boots_leafwalk:GetModifierInvisibilityLevel()
    return 1
end

function modifier_imba_ironleaf_boots_leafwalk:CheckState()
    local state = {[MODIFIER_STATE_INVISIBLE] = true}

    return state
end