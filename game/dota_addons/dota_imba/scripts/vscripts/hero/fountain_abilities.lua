function GrievousWounds( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local modifier_debuff = keys.modifier_debuff
    local particle_hit = keys.particle_hit

    -- Don't apply if the target is dead
    if not target:IsAlive() then
      return nil
    end

    -- Parameters
    local damage_increase = ability:GetLevelSpecialValueFor("damage_increase", ability_level)

    -- Play hit particle
    local hit_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, target)
    ParticleManager:SetParticleControl(hit_pfx, 0, target:GetAbsOrigin())

    -- Calculate bonus damage
    local base_damage = caster:GetAttackDamage()
    local current_stacks = target:GetModifierStackCount(modifier_debuff, caster)
    local total_damage = base_damage * ( 1 + current_stacks * damage_increase / 100 )

    -- Apply damage
    ApplyDamage({attacker = caster, victim = target, ability = ability, damage = total_damage, damage_type = DAMAGE_TYPE_PHYSICAL})

    -- Apply bonus damage modifier
    AddStacks(ability, caster, target, modifier_debuff, 1, true)
end
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
-- Fountain's Relief Aura (increases tenacity and damage reduction)
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

imba_fountain_relief = imba_fountain_relief or class({})
LinkLuaModifier("modifier_imba_fountain_relief_aura", "hero/fountain_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fountain_relief_aura_buff", "hero/fountain_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fountain_relief_aura_reject", "hero/fountain_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_fountain_relief:GetAbilityTextureName()
   return "custom/fountain_relief"
end

function imba_fountain_relief:GetIntrinsicModifierName()
  return "modifier_imba_fountain_relief_aura"
end

-- Fountain aura 
modifier_imba_fountain_relief_aura = modifier_imba_fountain_relief_aura or class({})

function modifier_imba_fountain_relief_aura:OnCreated()
  self.caster = self:GetCaster()
  self.ability = self:GetAbility()
  if not self.ability then
    self:Destroy()
    return nil
  end

  -- Ability specials
  self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
  self.aura_stickyness = self.ability:GetSpecialValueFor("aura_stickyness")
end

--ability properties
function modifier_imba_fountain_relief_aura:OnRefresh()
  self:OnCreated()
end

function modifier_imba_fountain_relief_aura:GetAuraDuration()
  return self.aura_stickyness
end

function modifier_imba_fountain_relief_aura:GetAuraRadius()
  return self.aura_radius
end

function modifier_imba_fountain_relief_aura:GetAuraEntityReject(target)
    -- Reject the.. well, rejected
    if target:HasModifier("modifier_imba_fountain_relief_aura_reject") then
        return true
    end

    -- Accept everyone else
    return false
end

function modifier_imba_fountain_relief_aura:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_fountain_relief_aura:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_fountain_relief_aura:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_fountain_relief_aura:GetModifierAura()
  return "modifier_imba_fountain_relief_aura_buff"
end

function modifier_imba_fountain_relief_aura:IsAura()
  return true
end

function modifier_imba_fountain_relief_aura:IsDebuff()
  return false
end

function modifier_imba_fountain_relief_aura:IsHidden()
  return true
end

------------------------
-- Tenacity Modifier
------------------------
modifier_imba_fountain_relief_aura_buff = modifier_imba_fountain_relief_aura_buff or class({})

function modifier_imba_fountain_relief_aura_buff:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    if not self.ability then
      self:Destroy()
      return nil
    end
    self.parent = self:GetParent()

    -- Ability specials
    self.tenacity = self.ability:GetSpecialValueFor("tenacity")
    self.damage_reduction = self.ability:GetSpecialValueFor("damage_reduction")
    self.disconnected_dmg_reduction = self.ability:GetSpecialValueFor("disconnected_dmg_reduction")
    self.aura_reject_time = self.ability:GetSpecialValueFor("aura_reject_time")
end

function modifier_imba_fountain_relief_aura_buff:OnRefresh()
    self:OnCreated()
end

function modifier_imba_fountain_relief_aura_buff:IsHidden()
    return false
end

function modifier_imba_fountain_relief_aura_buff:GetCustomTenacity()
    return self.tenacity
end

function modifier_imba_fountain_relief_aura_buff:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
                      MODIFIER_EVENT_ON_ATTACK,
                      MODIFIER_EVENT_ON_ABILITY_FULLY_CAST}

    return decFuncs
end

function modifier_imba_fountain_relief_aura_buff:GetModifierIncomingDamage_Percentage()
    if IsServer() then
        -- Disconnected players take no damage at all
        if PlayerResource:GetConnectionState(self.parent:GetPlayerOwnerID()) == 3 then            
            return self.disconnected_dmg_reduction * (-1)            
        end

        return self.damage_reduction * (-1)
    end
end

function modifier_imba_fountain_relief_aura_buff:OnAttack(keys)
    if IsServer() then
        local target = keys.target
        local attacker = keys.attacker

        -- Only apply if the attacker is the parent
        if self.parent == attacker then

            -- If the attacker attacked one from his team or himself, do nothing
            if attacker:GetTeamNumber() == target:GetTeamNumber() then
                return nil
            end

            -- Reject him from the aura
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_imba_fountain_relief_aura_reject", {duration = self.aura_reject_time})
        end
    end
end

function modifier_imba_fountain_relief_aura_buff:OnAbilityFullyCast(keys)
    if IsServer() then
        local unit = keys.unit

        -- Only apply if the user of the ability is the parent
        if self.parent == unit then
            -- Reject him from the aura
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_imba_fountain_relief_aura_reject", {duration = self.aura_reject_time})            
        end
    end
end



-- Rejection aura. Does nothing, but the aura does not include those rejected by it.
modifier_imba_fountain_relief_aura_reject = modifier_imba_fountain_relief_aura_reject or class({})

function modifier_imba_fountain_relief_aura_reject:IsHidden() return false end
function modifier_imba_fountain_relief_aura_reject:IsPurgable() return false end
function modifier_imba_fountain_relief_aura_reject:IsDebuff() return false end

function modifier_imba_fountain_relief_aura_reject:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    if not self.ability then
      self:Destroy()
      return nil
    end
    self.parent = self:GetParent()    
end

function modifier_imba_fountain_relief_aura_reject:DeclareFunctions()
    local decFuncs = {MODIFIER_EVENT_ON_ATTACK,
                      MODIFIER_EVENT_ON_ABILITY_FULLY_CAST}

    return decFuncs
end

function modifier_imba_fountain_relief_aura_reject:OnAttack(keys)
    if IsServer() then
        local target = keys.target
        local attacker = keys.attacker

        -- Only apply if the attacker is the parent
        if self.parent == attacker then

            -- If the attacker attacked one from his team or himself, do nothing
            if attacker:GetTeamNumber() == target:GetTeamNumber() then
                return nil
            end

            -- Refresh aura
            self:ForceRefresh()
        end
    end
end

function modifier_imba_fountain_relief_aura_reject:OnAbilityFullyCast(keys)
    if IsServer() then
        local unit = keys.unit

        -- Only apply if the user of the ability is the parent
        if self.parent == unit then            
            self:ForceRefresh()
        end
    end
end
