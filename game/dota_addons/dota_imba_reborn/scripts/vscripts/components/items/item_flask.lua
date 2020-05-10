item_imba_flask = item_imba_flask or class({})

LinkLuaModifier("modifier_imba_flask", "components/items/item_flask", LUA_MODIFIER_MOTION_NONE)

----------------------
--  HEALING SALVE   --
----------------------

function item_imba_flask:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster() 
    local ability = self
    local target = self:GetCursorTarget() 
    local cast_sound = "DOTA_Item.HealingSalve.Activate"
    local modifier_regen = "modifier_imba_flask"

    -- Ability specials
    local duration = ability:GetSpecialValueFor("duration")
    local break_stacks = ability:GetSpecialValueFor("break_stacks")

    -- Emit sound
    EmitSoundOn(cast_sound, target) 

    -- Give the target the modifier
    local modifier_regen_modifier = target:AddNewModifier(caster, ability, modifier_regen, {duration = duration})
    modifier_regen_modifier:SetStackCount(break_stacks)

    -- Reduce a charge, or destroy the item if no charges are left
    ability:SpendCharge()
end

--------------------------------------
-- HEALING SALVE HP REGEN MODIFIER  --
--------------------------------------

modifier_imba_flask = modifier_imba_flask or class({})

function modifier_imba_flask:IsHidden() return false end
function modifier_imba_flask:IsDebuff() return false end
function modifier_imba_flask:IsPurgable() return true end

function modifier_imba_flask:GetTexture()
    return "item_flask"
end

function modifier_imba_flask:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

    -- Ability properties
    self.caster = self:GetCaster() 
    self.ability = self:GetAbility()
    self.parent = self:GetParent()        

    -- Ability specials
    self.hp_regen = self.ability:GetSpecialValueFor("hp_regen")   
    self.break_stacks = self.ability:GetSpecialValueFor("break_stacks")
    self.flat_heal_reduction = self.ability:GetSpecialValueFor("flat_heal_reduction")
    self.hp_threshold_pct = self.ability:GetSpecialValueFor("hp_threshold_pct")
    self.heal_multiplier = self.ability:GetSpecialValueFor("heal_multiplier")
end

function modifier_imba_flask:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,                     
                     MODIFIER_EVENT_ON_TAKEDAMAGE} 
    return decFuncs
end

function  modifier_imba_flask:OnTakeDamage(keys)
    if not IsServer() then return nil end
    
    local attacker = keys.attacker
    local target = keys.unit
    local damage = keys.original_damage
    local damage_flags = keys.damage_flags

    -- Do nothing if the target isn't the parent
    if target ~= self.parent then
        return nil
    end

    -- Do nothing if damage is 0
    if damage <= 0 then 
        return nil
    end

    -- Do nothing if the source of the damage is the modifier bearer himself
    if attacker == self.parent then
        return nil
    end

    -- Do nothing if the source of the damage is flagged as HP removal
    if damage_flags == DOTA_DAMAGE_FLAG_HPLOSS then
        return nil
    end

    -- Check if the source of the damage is a player controlled unit/hero, or Roshan    
    if (attacker:GetTeamNumber() == target:GetOpposingTeamNumber() and attacker:IsHero()) or (attacker:GetTeamNumber() == target:GetOpposingTeamNumber() and attacker:GetPlayerOwner() ~= nil) or attacker:GetTeamNumber() == target:GetTeamNumber() or attacker:IsRoshan() then
        -- On valid damage taken, remove a stack. If no stacks are left, destroy this modifier
        if self:GetStackCount() == 1 then
            self:Destroy() 
        else
            self:SetStackCount(self:GetStackCount() - 1)
        end
    end
end

function modifier_imba_flask:GetModifierConstantHealthRegen()    
    local hp_regen = self.hp_regen

    -- Calculate heal value including multiplier if parent is wounded
    if (self.parent:GetHealthPercent()) <= self.hp_threshold_pct then
        hp_regen = hp_regen * self.heal_multiplier
    end

    -- Calculate heal value depending on damage stacks
    local flat_reduction = (self.break_stacks - self:GetStackCount()) * self.flat_heal_reduction
    hp_regen = hp_regen - flat_reduction     

    return hp_regen
end

function modifier_imba_flask:GetEffectName()
    return "particles/items_fx/healing_flask.vpcf"
end

function modifier_imba_flask:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end