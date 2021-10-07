item_imba_faerie_fire = item_imba_faerie_fire or class({})

LinkLuaModifier("modifier_imba_faerie_fire", "components/items/item_faerie_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_faerie_fire_fire_within", "components/items/item_faerie_fire", LUA_MODIFIER_MOTION_NONE)

-----------------
-- FAERIE FIRE -- 
-----------------

function item_imba_faerie_fire:GetIntrinsicModifierName()
    return "modifier_imba_faerie_fire"
end

function item_imba_faerie_fire:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self    
    local cast_sound = "DOTA_Item.FaerieSpark.Activate"
    local particle_faerie = "" -- TO GET FROM COOKIES
    local modifier_fire_within = "modifier_imba_faerie_fire_fire_within"

    -- Ability specials
    local hp_restore = ability:GetSpecialValueFor("hp_restore")
    local fire_within_duration = ability:GetSpecialValueFor("fire_within_duration")

    -- Emit cast sound on self
    EmitSoundOn(cast_sound, caster)

    -- Show particle on self
    -- TO DO: GET PARTICLE

    -- Heal self
    caster:Heal(hp_restore, caster)

    -- Give self fire within modifier
    caster:AddNewModifier(caster, ability, modifier_fire_within, {duration = fire_within_duration})

    -- Spend charge
    ability:SpendCharge()
end


-------------------------------------
-- FAERIE FIRE INTRINSIC MODIFIER  --
-------------------------------------

modifier_imba_faerie_fire = modifier_imba_faerie_fire or class({})

function modifier_imba_faerie_fire:IsHidden() return true end
function modifier_imba_faerie_fire:IsDebuff() return false end
function modifier_imba_faerie_fire:IsPurgable() return false end
function modifier_imba_faerie_fire:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_faerie_fire:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()    

    -- Ability specials
    self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
end

function modifier_imba_faerie_fire:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}

    return decFuncs
end

function modifier_imba_faerie_fire:GetModifierPreAttack_BonusDamage()
    return self.bonus_damage * self.ability:GetCurrentCharges()
end


--------------------------
-- FIRE WITHIN MODIFIER --
--------------------------

modifier_imba_faerie_fire_fire_within = modifier_imba_faerie_fire_fire_within or class({})

function modifier_imba_faerie_fire_fire_within:IsHidden() return false end
function modifier_imba_faerie_fire_fire_within:IsDebuff() return false end
function modifier_imba_faerie_fire_fire_within:IsPurgable() return true end

function modifier_imba_faerie_fire_fire_within:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()

    -- Ability specials
    self.fire_within_dmg = self.ability:GetSpecialValueFor("fire_within_dmg")
    self.fire_within_dmg_rdctn_pct = self.ability:GetSpecialValueFor("fire_within_dmg_rdctn_pct")
end

function modifier_imba_faerie_fire_fire_within:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                      MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}

    return decFuncs
end

function modifier_imba_faerie_fire_fire_within:GetModifierPreAttack_BonusDamage()
    return self.fire_within_dmg
end

function modifier_imba_faerie_fire_fire_within:GetModifierIncomingDamage_Percentage()
    return self.fire_within_dmg_rdctn_pct * (-1)
end

function modifier_imba_faerie_fire_fire_within:GetTexture()
    return "item_faerie_fire"
end