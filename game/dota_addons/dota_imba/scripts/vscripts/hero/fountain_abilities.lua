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
----------------------------------------------------
----------------------------------------------------
--Fountain's Relief Aura (increases tenacity)
----------------------------------------------------
----------------------------------------------------

imba_fountain_relief = imba_fountain_relief or class({})
LinkLuaModifier("modifier_imba_fountain_relief_aura", "hero/fountain_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fountain_relief_aura_buff", "hero/fountain_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_fountain_relief:GetIntrinsicModifierName()
  return "modifier_imba_fountain_relief_aura"
end

--fountain aura 
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

function modifier_imba_fountain_relief_aura:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_fountain_relief_aura:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_fountain_relief_aura:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
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
  if not self.ability then
    self:Destroy()
    return nil
  end
  self.parent = self:GetParent()

  -- Ability specials
  self.tenacity = self.ability:GetSpecialValueFor("tenacity")
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