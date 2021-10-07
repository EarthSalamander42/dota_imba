item_imba_enchanted_mango = item_imba_enchanted_mango or class({})

LinkLuaModifier("modifier_imba_mango", "components/items/item_enchanted_mango", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ripe_mango_timer", "components/items/item_enchanted_mango", LUA_MODIFIER_MOTION_NONE)


---------------------
-- ENCHANTED MANGO --
---------------------

function item_imba_enchanted_mango:GetIntrinsicModifierName()
    return "modifier_imba_mango"
end

function item_imba_enchanted_mango:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local target = ability:GetCursorTarget() or caster
    local cast_sound = "DOTA_Item.Mango.Activate"
    local mango_particle = "" -- need to be added!
    local ripe_mango_particle = "" -- need to be added
    local modifier_ripe_mango = "modifier_imba_ripe_mango_timer"

    -- Ability specials
    local mana_replenish = ability:GetSpecialValueFor("mana_replenish")
    local ripe_mango_mana = ability:GetSpecialValueFor("ripe_mango_mana")
    local ripe_mango_duration = ability:GetSpecialValueFor("ripe_mango_duration")   

    -- Play cast sound
    EmitSoundOn(cast_sound, target)    

    -- Restore mana. If target doesn't have the ripe mango modifier, grant more and give him the modifier    
    if not target:HasModifier(modifier_ripe_mango) then

        -- TODO Show ripe mango particle on target
        

        target:GiveMana(ripe_mango_mana)
        target:AddNewModifier(caster, ability, modifier_ripe_mango, {duration = ripe_mango_duration})
    else
        -- TODO Show regular mango particle on target
        target:GiveMana(mana_replenish)
    end

    -- Spend a charge
    ability:SpendCharge()
end


------------------------------
-- ENCHANTED MANGO MODIFIER --
------------------------------

modifier_imba_mango = modifier_imba_mango or class({})

function modifier_imba_mango:IsHidden() return true end
function modifier_imba_mango:IsPurgable() return false end
function modifier_imba_mango:IsDebuff() return false end
function modifier_imba_mango:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_mango:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
    
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    -- Ability specials
    self.hp_regen = self.ability:GetSpecialValueFor("hp_regen")
end

function modifier_imba_mango:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT}

    return decFuncs
end

function modifier_imba_mango:GetModifierConstantHealthRegen()
    return self.hp_regen * self.ability:GetCurrentCharges()
end

-------------------------------
-- RIPE MANGO TIMER MODIFIER --
-------------------------------

modifier_imba_ripe_mango_timer = modifier_imba_ripe_mango_timer or class({})

function modifier_imba_ripe_mango_timer:IsHidden() return false end
function modifier_imba_ripe_mango_timer:IsPurgable() return false end
function modifier_imba_ripe_mango_timer:IsDebuff() return false end

function modifier_imba_ripe_mango_timer:GetTexture()
    return "item_enchanted_mango"
end