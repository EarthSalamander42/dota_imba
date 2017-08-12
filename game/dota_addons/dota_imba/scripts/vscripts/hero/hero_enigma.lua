CreateEmptyTalents("enigma")

-- Force calculations
-- Returns the handle of the strongest force, so use this:GetAbsOrigin() to get the location
-- Use if FindStrongestForce(caster)!
function FindStrongestForce(caster)
  if caster.hBlackHoleDummyUnit and not caster.hBlackHoleDummyUnit:IsNull() then
    return caster.hBlackHoleDummyUnit
  elseif caster.hMidnightPulseDummyUnit and not caster.hMidnightPulseDummyUnit:IsNull()  then
    return caster.hMidnightPulseDummyUnit
  elseif caster:IsAlive() then
    return caster
  end
  -- Should pull towards dead caster?
  return --caster
end

-- Malefice
imba_enigma_malefice = class({})

function imba_enigma_malefice:IsHiddenWhenStolen() return false end
function imba_enigma_malefice:IsRefreshable() return true end
function imba_enigma_malefice:IsStealable() return true end
function imba_enigma_malefice:IsNetherWardStealable() return true end

function imba_enigma_malefice:GetAbilityTextureName()
   return "enigma_malefice"
end

function imba_enigma_malefice:GetCastPoint()
  return self:GetSpecialValueFor("cast_point")
end

function imba_enigma_malefice:GetCastRange(a,b)
  return self:GetSpecialValueFor("cast_range")
end

function imba_enigma_malefice:GetAOERadius()
  local caster = self:GetCaster()
  -- #2 Talent: Malefice Effect Radius
  if caster:HasTalent("special_bonus_imba_enigma_2") then
    return caster:FindTalentValue("special_bonus_imba_enigma_2")
  else
    return nil
  end
end

-- Apply modifier(s)
function imba_enigma_malefice:OnSpellStart()
  local caster = self:GetCaster()
  local target = self:GetCursorTarget()

  if target:TriggerSpellAbsorb(self) then return end
  local malefice_duration = self:GetSpecialValueFor("total_duration")

  if caster:IsAlive() and caster:HasTalent("special_bonus_imba_enigma_7") then
    local modifier = caster:FindModifierByName("modifier_enigma_magic_immunity")
    if modifier then
      local time = modifier:GetRemainingTime() + caster:FindTalentValue("special_bonus_imba_enigma_7")
      modifier:SetDuration(time,true)
      
    else
      caster:AddNewModifier(caster,nil,"modifier_enigma_magic_immunity",{duration = caster:FindTalentValue("special_bonus_imba_enigma_7")})
    end
  end

  EmitSoundOn("Hero_Enigma.Malefice",parent)
  
  -- #2 Talent: Malefice Effect Radius
  if caster:HasTalent("special_bonus_imba_enigma_2") then
    local radius = caster:FindTalentValue("special_bonus_imba_enigma_2")
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    for _,enemy in pairs(enemies) do
      enemy:AddNewModifier(caster, self, "modifier_imba_enigma_malefice", {duration = malefice_duration})             
    end
  else
    target:AddNewModifier(caster, self, "modifier_imba_enigma_malefice", {duration = malefice_duration})  
  end
end

-- Malefice stun applying modifier
LinkLuaModifier("modifier_imba_enigma_malefice","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
modifier_imba_enigma_malefice = class({})
function modifier_imba_enigma_malefice:IsDebuff() return true end
function modifier_imba_enigma_malefice:IsHidden() return false end
function modifier_imba_enigma_malefice:IsPurgable() return true end
function modifier_imba_enigma_malefice:IsStunDebuff() return false end

function modifier_imba_enigma_malefice:GetEffectName()
  return "particles/units/heroes/hero_enigma/enigma_malefice.vpcf" 
end
function modifier_imba_enigma_malefice:GetEffectName()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_enigma_malefice:OnCreated()
  if IsServer() then
    local ability = self:GetAbility()
    local tick_interval = ability:GetSpecialValueFor("tick_interval")
    self.tick_damage = ability:GetSpecialValueFor("tick_damage")
    self.stun_duration = ability:GetSpecialValueFor("stun_duration")
    self.eidolon_bonus_duration = ability:GetSpecialValueFor("eidolon_bonus_duration")
    self.mini_black_hole_radius = self:GetCaster():FindTalentValue("special_bonus_imba_enigma_5")
    self.eidolon_bonus_duration_percent = ability:GetSpecialValueFor("eidolon_bonus_duration_percent")
    self.health_bonus_duration_percent = ability:GetSpecialValueFor("health_bonus_duration_percent")
    if self.health_bonus_duration_percent == 0 then self.health_bonus_duration_percent = 25 end
    self.health_bonus_duration = ability:GetSpecialValueFor("health_bonus_duration")

    local health_pct = self:GetParent():GetHealthPercent()
    while (100-health_pct) >= self.health_bonus_duration_percent do
      health_pct = health_pct +    self.health_bonus_duration_percent
      self:SetDuration(self:GetRemainingTime() + self.health_bonus_duration,true)
    end

    self:StartIntervalThink(tick_interval)
    self:OnIntervalThink()
  end
end

function modifier_imba_enigma_malefice:OnIntervalThink()
  local parent = self:GetParent()

  -- Get the duration boost caused by eidolons
  local eidolon_bonus_duration = 0
  local modifier = parent:FindModifierByName("modifier_imba_enigma_eidolon_attack_counter")
  if modifier and self.eidolon_bonus_duration_percent then
    eidolon_bonus_duration =  1+(modifier:GetStackCount() *self.eidolon_bonus_duration_percent)
  end
  local duration = self.stun_duration + eidolon_bonus_duration

  parent:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_stunned",{duration = duration})
  -- #5 Talent Mini black hole on intervals. Store the right values to use in the black hole
  if self:GetCaster():HasTalent("special_bonus_imba_enigma_5") and self:GetCaster():FindAbilityByName("imba_enigma_black_hole"):GetLevel() > 0 then
    local modifier = parent:AddNewModifier(self:GetCaster(),self,"modifier_imba_enigma_black_hole_aura",{duration = duration,radius = self.mini_black_hole_radius,damage = 0})
  else
    local modifier = parent:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_imba_enigma_malefice_force",{duration = duration})
    modifier.pull_strength = FrameTime() * self:GetAbility():GetSpecialValueFor("pull_strength")
  end

  EmitSoundOn("Hero_Enigma.MaleficeTick",parent)
  local damage = 
  {
    victim = parent,
    attacker = self:GetCaster(),
    damage = self.tick_damage,
    damage_type = DAMAGE_TYPE_MAGICAL,    
    ability = self:GetAbility(),
  }
  ApplyDamage( damage )
end

-- Modifier applying force
LinkLuaModifier("modifier_imba_enigma_malefice_force","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
modifier_imba_enigma_malefice_force = class({})
function modifier_imba_enigma_malefice_force:IsDebuff() return true end
function modifier_imba_enigma_malefice_force:IsHidden() return true end
function modifier_imba_enigma_malefice_force:IsPurgable() return false end
function modifier_imba_enigma_malefice_force:IsPurgeException()return true end
function modifier_imba_enigma_malefice_force:IsStunDebuff() return false end
function modifier_imba_enigma_malefice_force:IsMotionController()  return true end
function modifier_imba_enigma_malefice_force:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_enigma_malefice_force:OnCreated()
  if IsServer() then
    self:GetParent():StartGesture(ACT_DOTA_FLAIL)
    
    self:StartIntervalThink(FrameTime())
  end
end

function modifier_imba_enigma_malefice_force:OnDestroy()
  if IsServer() then
    self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
    ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
  end
end
function modifier_imba_enigma_malefice_force:OnIntervalThink()
  -- Remove force if conflicting
  if not self:CheckMotionControllers() then
    self:Destroy()
    return nil
  end
  self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_imba_enigma_malefice_force:HorizontalMotion()
  if IsServer() then
    if FindStrongestForce(self:GetCaster()) then
      local eidolon_bonus_duration = 0
      local ab = self:GetCaster():FindAbilityByName("imba_enigma_demonic_conversion")
      local pull_strength = self.pull_strength 
      local modifier = self:GetParent():FindModifierByName("modifier_imba_enigma_eidolon_attack_counter")
      if modifier then
        pull_strength = pull_strength + (modifier:GetStackCount() * (1+ab:GetSpecialValueFor("increased_mass_pull_pct")))
      end
      
      local direction = (FindStrongestForce(self:GetCaster()):GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
      local set_point = self:GetParent():GetAbsOrigin() + direction * self.pull_strength
      self:GetParent():SetAbsOrigin(Vector(set_point.x, set_point.y, GetGroundPosition(set_point, self:GetParent()).z))
    end
  end
end

-- Enigma midnight Pulse
imba_enigma_midnight_pulse = class({})
function imba_enigma_midnight_pulse:IsHiddenWhenStolen() return false end
function imba_enigma_midnight_pulse:IsRefreshable() return true end
function imba_enigma_midnight_pulse:IsStealable() return true end
function imba_enigma_midnight_pulse:IsNetherWardStealable() return true end

function imba_enigma_midnight_pulse:GetAbilityTextureName()
   return "enigma_midnight_pulse"
end

function imba_enigma_midnight_pulse:GetCastPoint()
  return self:GetSpecialValueFor("cast_point")
end

function imba_enigma_midnight_pulse:GetCastRange(a,b)
  return self:GetSpecialValueFor("cast_range")
end

function imba_enigma_midnight_pulse:GetAOERadius()
  return self:GetSpecialValueFor("radius")
end

function imba_enigma_midnight_pulse:OnSpellStart()
  local caster = self:GetCaster()
  local point = self:GetCursorPosition()

  if caster:IsAlive() and caster:HasTalent("special_bonus_imba_enigma_7") then
    local modifier = caster:FindModifierByName("modifier_enigma_magic_immunity")
    if modifier then
      local time = modifier:GetRemainingTime() + caster:FindTalentValue("special_bonus_imba_enigma_7")
      modifier:SetDuration(time,true)
      
    else
      caster:AddNewModifier(caster,nil,"modifier_enigma_magic_immunity",{duration = caster:FindTalentValue("special_bonus_imba_enigma_7")})
    end
  end

  -- Store variables
  local duration = self:GetSpecialValueFor("duration")
  local damage_per_tick = self:GetSpecialValueFor("damage_per_tick")
  local radius = self:GetSpecialValueFor("radius")
  local pull_strength = self:GetSpecialValueFor("pull_strength")
  

  caster.hMidnightPulseDummyUnit = CreateModifierThinker(caster,self,"modifier_imba_enigma_midnight_pulse_aura",{duration = duration},point,caster:GetTeamNumber(),false)
  
  -- Sound
  EmitSoundOnLocationWithCaster(point,"Hero_Enigma.Midnight_Pulse",caster)

  GridNav:DestroyTreesAroundPoint(point, radius, false)
end

---------------------------------------------------------------

LinkLuaModifier("modifier_imba_enigma_midnight_pulse_aura","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
modifier_imba_enigma_midnight_pulse_aura = class({})
function modifier_imba_enigma_midnight_pulse_aura:IsDebuff() return false end
function modifier_imba_enigma_midnight_pulse_aura:IsHidden() return true end
function modifier_imba_enigma_midnight_pulse_aura:IsPurgable() return false end
function modifier_imba_enigma_midnight_pulse_aura:RemoveOnDeath() return false end
function modifier_imba_enigma_midnight_pulse_aura:IsAura() return true end

-- Allow this to stack for black hole
function modifier_imba_enigma_midnight_pulse_aura:GetAttributes()
  return {MODIFIER_ATTRIBUTE_MULTIPLE}
end

function modifier_imba_enigma_midnight_pulse_aura:OnCreated()
  self.radius = self:GetAbility():GetSpecialValueFor("radius")
  self.auraRadius = self.radius 
  self.duration = self:GetAbility():GetSpecialValueFor("duration")
  self.damage_per_tick = self:GetAbility():GetSpecialValueFor("damage_per_tick")
  self.pull_duration = self:GetAbility():GetSpecialValueFor("pull_duration")
  if IsServer() then    
    self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
    ParticleManager:SetParticleControl(self.particle,0,self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(self.particle,1,Vector(self.auraRadius,0,0))

    self:StartIntervalThink(1)
  end
end

function modifier_imba_enigma_midnight_pulse_aura:OnDestroy()
  if IsServer() then
    ParticleManager:DestroyParticle(self.particle,false)
    ParticleManager:ReleaseParticleIndex(self.particle)
    UTIL_Remove(self:GetParent())
  end
end

function modifier_imba_enigma_midnight_pulse_aura:OnIntervalThink()
  -- Damage everyone inside and apply force
  local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.auraRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
  for _,enemy in pairs(enemies) do
    local damage = 
    {
      victim = enemy,
      attacker = self:GetCaster(),
      damage = self.damage_per_tick * enemy:GetMaxHealth() * 0.01,
      damage_type = DAMAGE_TYPE_PURE,
      ability = self:GetAbility()
    }
    ApplyDamage(damage)

    local modifier = enemy:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_imba_enigma_midnight_pulse_force",{duration = self.pull_duration})
    if modifier then
      modifier.pull_strength = FrameTime() * self:GetAbility():GetSpecialValueFor("pull_strength")
    end
  end
  -- Apply modifier for eidolons
  local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.auraRadius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
  for _,ally in pairs(allies) do
    if ally:HasModifier("modifier_imba_enigma_eidolon") then
      duration = self:GetAbility():GetSpecialValueFor("eidolon_heal_duration")
      ally:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_imba_enigma_midnight_pulse_eidolon_regen",{duration = duration})
    end
  end

  if self:GetCaster():HasTalent("special_bonus_imba_enigma_3") then
    -- Update the particle for expanding midnight talent, if neccesary.
    ParticleManager:SetParticleControl(self.particle,1,Vector(self.auraRadius,0,0))
  end
end

-- Control the aura radius, could be based on the duration. 
function modifier_imba_enigma_midnight_pulse_aura:GetAuraRadius()
  -- #3 Talent: Increasing the radius based on the duration
  if self:GetCaster():HasTalent("special_bonus_imba_enigma_3")  then
    local pct_duration = 1- (self:GetRemainingTime() / self.duration)
    self.auraRadius = self.radius + (self.radius * pct_duration)
  else
    self.auraRadius = self.radius
  end
  
  return self.auraRadius
end

LinkLuaModifier("modifier_imba_enigma_midnight_pulse_eidolon_regen","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
modifier_imba_enigma_midnight_pulse_eidolon_regen = class({})

function modifier_imba_enigma_midnight_pulse_eidolon_regen:IsDebuff() return self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() end
function modifier_imba_enigma_midnight_pulse_eidolon_regen:IsHidden() return false end
function modifier_imba_enigma_midnight_pulse_eidolon_regen:IsPurgable() return false end

function modifier_imba_enigma_midnight_pulse_eidolon_regen:DeclareFunctions()
  return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT}
end

function modifier_imba_enigma_midnight_pulse_eidolon_regen:GetModifierConstantHealthRegen()
  return self:GetAbility():GetSpecialValueFor("eidolon_hp_regen")  
end


-- Modifier applying force
LinkLuaModifier("modifier_imba_enigma_midnight_pulse_force","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
modifier_imba_enigma_midnight_pulse_force = class({})
function modifier_imba_enigma_midnight_pulse_force:IsDebuff() return true end
function modifier_imba_enigma_midnight_pulse_force:IsHidden() return true end
function modifier_imba_enigma_midnight_pulse_force:IsPurgable() return false end
function modifier_imba_enigma_midnight_pulse_force:IsPurgeException()return true end
function modifier_imba_enigma_midnight_pulse_force:IsStunDebuff() return false end
function modifier_imba_enigma_midnight_pulse_force:IsMotionController()  return true end
function modifier_imba_enigma_midnight_pulse_force:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_enigma_midnight_pulse_force:OnCreated()
  if IsServer() then    
    self:StartIntervalThink(FrameTime())
  end
end

function modifier_imba_enigma_midnight_pulse_force:OnDestroy()
  if IsServer() then    
    ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
  end
end
function modifier_imba_enigma_midnight_pulse_force:OnIntervalThink()
  --Remove force if conflicting
  if not self:CheckMotionControllers() then
    self:Destroy()
    return nil
  end
  self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_imba_enigma_midnight_pulse_force:HorizontalMotion()
  if IsServer() then
    if FindStrongestForce(self:GetCaster()) then
      local eidolon_bonus_duration = 0
      local ab = self:GetCaster():FindAbilityByName("imba_enigma_demonic_conversion")
      local pull_strength = self.pull_strength 
      local modifier = self:GetParent():FindModifierByName("modifier_imba_enigma_eidolon_attack_counter")
      if modifier then
        pull_strength = pull_strength + (modifier:GetStackCount() * (1+ab:GetSpecialValueFor("increased_mass_pull_pct")))
      end
      
      if (FindStrongestForce(self:GetCaster()):GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() < 10 then self.pull_strength = 0 end
      local direction = (FindStrongestForce(self:GetCaster()):GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
      local set_point = self:GetParent():GetAbsOrigin() + direction * self.pull_strength
      self:GetParent():SetAbsOrigin(Vector(set_point.x, set_point.y, GetGroundPosition(set_point, self:GetParent()).z))            
      ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
    end
  end
end

-- Black Hole
imba_enigma_black_hole = class({})

function imba_enigma_black_hole:IsHiddenWhenStolen() return false end
function imba_enigma_black_hole:IsRefreshable() return true end
function imba_enigma_black_hole:IsStealable() return true end
function imba_enigma_black_hole:IsNetherWardStealable() return true end

function imba_enigma_black_hole:GetAbilityTextureName()
  return "enigma_black_hole"
end

function imba_enigma_black_hole:GetIntrinsicModifierName()
  return "modifier_imba_singularity"
end

function imba_enigma_black_hole:GetCooldown(nLevel)  
  local charges = self:GetCaster():GetModifierStackCount("modifier_imba_singularity", self:GetCaster())
  return self.BaseClass.GetCooldown( self, nLevel ) - charges * self:GetCaster():FindTalentValue("special_bonus_imba_enigma_1")    
end

function imba_enigma_black_hole:GetCastPoint()
  return self:GetSpecialValueFor("cast_point")
end

function imba_enigma_black_hole:GetCastRange(a,b)
  return self:GetSpecialValueFor("cast_range")
end

function imba_enigma_black_hole:GetAOERadius()
  local caster = self:GetCaster()
  if IsServer() then
    return self:GetSpecialValueFor("radius") + (caster:FindModifierByName("modifier_imba_singularity"):GetStackCount() * self:GetSpecialValueFor("singularity_stun_radius_increment_per_stack"))
  end
  return self:GetSpecialValueFor("radius")
end

function imba_enigma_black_hole:GetChannelTime()
  return self:GetSpecialValueFor("duration")
end

-- Like midnight pulse, create dummy that transmits aura
function imba_enigma_black_hole:OnSpellStart()
  self:BeginBlackHole(false)
end

function imba_enigma_black_hole:BeginBlackHole(black_death)
  local caster = self:GetCaster()
  local point = self:GetCursorPosition()

  if not black_death and caster:IsAlive() and caster:HasTalent("special_bonus_imba_enigma_7") then
    local modifier = caster:FindModifierByName("modifier_enigma_magic_immunity")
    if modifier then
      local time = modifier:GetRemainingTime() + caster:FindTalentValue("special_bonus_imba_enigma_7")
      modifier:SetDuration(time,true)      
    else
      caster:AddNewModifier(caster,nil,"modifier_enigma_magic_immunity",{duration = caster:FindTalentValue("special_bonus_imba_enigma_7")})
    end
  end
  -- Store variables
  local duration = self.duration or self:GetSpecialValueFor("duration")
  local stun_radius = self:GetAOERadius()
  -- self.duration should only have a value when used with the cast on death talent
  self.duration = nil
  local damage_per_tick = self:GetSpecialValueFor("damage_per_tick")
  local pull_strength = self:GetSpecialValueFor("pull_strength")
  self.heroesHit = {}

  local enemies = FindUnitsInRadius(
                self:GetCaster():GetTeamNumber(),
                point,
                nil,
                stun_radius,
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO,
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                FIND_ANY_ORDER,
                false)

  for _, unit in pairs(enemies) do
    if unit:IsRealHero() and self.heroesHit then
      table.insert(self.heroesHit, unit)
    end
  end
  
  caster.hBlackHoleDummyUnit = CreateModifierThinker(caster,self,"modifier_imba_enigma_black_hole_aura",{duration = duration,radius = radius},point,caster:GetTeamNumber(),false)
  
  if not black_death and caster:HasScepter() then
    CreateModifierThinker(caster,caster:FindAbilityByName("imba_enigma_midnight_pulse"),"modifier_imba_enigma_midnight_pulse_aura",{duration = duration},point,caster:GetTeamNumber(),false)
  end

  if not black_death then
    -- Increase stacks based on heroes hit
    local stacks = #self.heroesHit or 0    
    local modifier_singularity_handler = self:GetCaster():FindModifierByName("modifier_imba_singularity")
    if modifier_singularity_handler then      
      modifier_singularity_handler:SetStackCount(modifier_singularity_handler:GetStackCount() + stacks)
    end
  end

  -- Decreases cooldown of the current black hole based on singularity stacks
  if not black_death and caster:HasTalent("special_bonus_imba_enigma_1") then
    self:EndCooldown()
    self:UseResources(false, false, true)
  end
  -- Sound
  EmitSoundOnLocationWithCaster(point,"Hero_Enigma.BlackHole.Cast",caster)  
end

-- Reset the singularity stacks
function imba_enigma_black_hole:OnChannelFinish(interrupted) 

  -- If Enigma was interrupted, remove Singularity stacks accumulated so far  
  if interrupted then
      self:GetCaster():FindModifierByName("modifier_imba_singularity"):SetStackCount(0)
  end

  if IsValidEntity(self:GetCaster().hBlackHoleDummyUnit) then
    self:GetCaster().hBlackHoleDummyUnit:RemoveModifierByName("modifier_imba_enigma_black_hole_aura")
  end  
  
end

LinkLuaModifier("modifier_imba_singularity","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
modifier_imba_singularity = class({})
function modifier_imba_singularity:IsHidden() return false end
function modifier_imba_singularity:IsPermanent() return true end

function modifier_imba_singularity:DeclareFunctions()
  return {MODIFIER_EVENT_ON_DEATH}
end

function modifier_imba_singularity:OnDeath(keys)
  if not IsServer() then return end
  if keys.unit ~= self:GetParent() then return end

  if not self:GetParent():HasTalent("special_bonus_imba_enigma_4") then return end

  if self:GetParent():IsIllusion() then return end

  local ability = self:GetAbility()
  ability.duration = ability:GetSpecialValueFor("duration") / self:GetParent():FindTalentValue("special_bonus_imba_enigma_4")
  self:GetParent():SetCursorPosition(self:GetParent():GetAbsOrigin())
  ability:BeginBlackHole(true)
end

LinkLuaModifier("modifier_imba_enigma_black_hole_aura","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
modifier_imba_enigma_black_hole_aura = class({})
function modifier_imba_enigma_black_hole_aura:IsDebuff() return false end
function modifier_imba_enigma_black_hole_aura:IsHidden() return true end
function modifier_imba_enigma_black_hole_aura:IsPurgable() return false end
function modifier_imba_enigma_black_hole_aura:RemoveOnDeath() return false end
function modifier_imba_enigma_black_hole_aura:IsAura() return true end


function modifier_imba_enigma_black_hole_aura:OnCreated(keys)
  if IsServer() then
    local caster = self:GetCaster()
    local ability = caster:FindAbilityByName("imba_enigma_black_hole")
    -- Storing values
    self.damage_per_tick  = keys.damage or ability:GetSpecialValueFor("damage_per_tick")
    self.singularity_stun_radius_increment_per_stack = ability:GetSpecialValueFor("singularity_stun_radius_increment_per_stack")
    self.singularity_pull_radius_increment_per_stack = ability:GetSpecialValueFor("singularity_pull_radius_increment_per_stack")
    self.stun_radius = ability:GetSpecialValueFor("radius") + (caster:FindModifierByName("modifier_imba_singularity"):GetStackCount() * self.singularity_stun_radius_increment_per_stack)
    self.radius = ability:GetSpecialValueFor("pull_radius") + (caster:FindModifierByName("modifier_imba_singularity"):GetStackCount() * self.singularity_pull_radius_increment_per_stack)
    
    self.stun_radius = keys.radius or self.stun_radius
    self.radius = keys.radius or self.radius    

    if ability == self:GetAbility() then
      ability:CreateVisibilityNode(self:GetParent():GetAbsOrigin(),self.stun_radius,1.5)
      Timers:CreateTimer(1,function()
        if not self:IsNull() then
          self:DealDamage()
          return 1
        end
      end)
      -- Sound
      if not caster:IsSilenced() then
        EmitSoundOn("Hero_Enigma.Black_Hole", caster)
      end
    else 
      if not caster:IsSilenced() then
        caster:EmitSoundParams("Hero_Enigma.Black_Hole",1,0.01,0)
      end
    end
    self:StartIntervalThink(FrameTime())
    -- Particle stuff
    if ability == self:GetAbility() then
      self.particle = ParticleManager:CreateParticle('particles/units/heroes/hero_enigma/enigma_blackhole.vpcf', PATTACH_CUSTOMORIGIN, nil)
    else
      self.particle = ParticleManager:CreateParticle('particles/hero/enigma/enigma_blackhole_malefice.vpcf', PATTACH_CUSTOMORIGIN, nil)
    end
    ParticleManager:SetParticleControl( self.particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl( self.particle, 1, Vector(self.stun_radius, self.stun_radius, self.stun_radius))
    
  end
end
-- Damage everyone via this to deal damage at the right time
function modifier_imba_enigma_black_hole_aura:DealDamage()

  local caster = self:GetCaster()
  local ability = caster:FindAbilityByName("imba_enigma_black_hole")

  ability:CreateVisibilityNode(self:GetParent():GetAbsOrigin(),self.stun_radius,1.5)
  local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
  for _,enemy in pairs(enemies) do
    if IsValidEntity(enemy) then
      local damage = 
      {
        victim = enemy,
        attacker = self:GetCaster(),
        damage = self.damage_per_tick,
        damage_type = DAMAGE_TYPE_PURE,
        ability = self:GetAbility()
      }
      ApplyDamage(damage)
    end
  end
end

-- Damage everyone via this to deal damage at the right time
function modifier_imba_enigma_black_hole_aura:OnIntervalThink()
  local caster = self:GetCaster()
  local ability = caster:FindAbilityByName("imba_enigma_black_hole")

  local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
  for _,enemy in pairs(enemies) do
    local modifier = enemy:AddNewModifier(caster,ability,"modifier_imba_enigma_black_hole_aura_modifier",{duration = 0.5,parent = self:GetParent():entindex()})
  end
end

function modifier_imba_enigma_black_hole_aura:OnDestroy()
  if IsServer() then
    -- Stop the sound
    StopSoundOn("Hero_Enigma.Black_Hole",self:GetCaster())
    EmitSoundOn("Hero_Enigma.Black_Hole.Stop",self:GetCaster())
    -- Kill particles
    if self.particle then
      ParticleManager:DestroyParticle(self.particle,false)
      ParticleManager:ReleaseParticleIndex(self.particle)
    end
    if self:GetAbility() == self:GetCaster():FindAbilityByName("imba_enigma_black_hole") then
      UTIL_Remove(self:GetParent())
    end
  end
end

function modifier_imba_enigma_black_hole_aura:GetModifierAura()
  return "modifier_imba_enigma_black_hole_aura_modifier"
end
  
function modifier_imba_enigma_black_hole_aura:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_enigma_black_hole_aura:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER 
end

function modifier_imba_enigma_black_hole_aura:GetAuraRadius()
  return self.radius
end

function modifier_imba_enigma_black_hole_aura:GetAuraDuration()
  return 0.5
end

LinkLuaModifier("modifier_imba_enigma_black_hole_aura_modifier","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
modifier_imba_enigma_black_hole_aura_modifier = class({})
function modifier_imba_enigma_black_hole_aura_modifier:IsDebuff() return true end
function modifier_imba_enigma_black_hole_aura_modifier:IsStunDebuff() return true end
function modifier_imba_enigma_black_hole_aura_modifier:IsHidden() return true end
function modifier_imba_enigma_black_hole_aura_modifier:IsPurgable() return false end

function modifier_imba_enigma_black_hole_aura_modifier:GetEffectName()
  return "particles/units/heroes/hero_enigma/enigma_blackhole_target.vpcf"
end

function modifier_imba_enigma_black_hole_aura_modifier:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_enigma_black_hole_aura_modifier:OnCreated(keys)
  if IsServer() then
    local caster = self:GetCaster()
    local ability = caster:FindAbilityByName("imba_enigma_black_hole")

    if keys.parent then
      self.parent = EntIndexToHScript(keys.parent)
    else
      self.parent = caster.hBlackHoleDummyUnit
    end

    self.pull_strength = ability:GetSpecialValueFor("pull_strength")
    self.min_pull_power = ability:GetSpecialValueFor("min_pull_power")
    self.singularity_stun_radius_increment_per_stack = ability:GetSpecialValueFor("stun_radius")
    self.stun_radius = ability:GetSpecialValueFor("radius") + (caster:FindModifierByName("modifier_imba_singularity"):GetStackCount() * self.singularity_stun_radius_increment_per_stack)
    
    self.modifier = self:GetParent():AddNewModifier(caster,ability,"modifier_imba_enigma_black_hole_force",{})
    self.modifier.pull_strength = self.min_pull_power
    self.modifier.parent = self.parent

    self.radius = ability.radius or self.stun_radius
    
    -- Means malefice
    if not self:GetAbility() then
      self.stun_radius = caster:FindTalentValue("special_bonus_imba_enigma_5")
    end
    self:StartIntervalThink(FrameTime())
  end
end

function modifier_imba_enigma_black_hole_aura_modifier:OnDestroy()
  if IsServer() then
    self:GetParent():RemoveModifierByName("modifier_imba_enigma_black_hole_force")
  end
end

function modifier_imba_enigma_black_hole_aura_modifier:OnIntervalThink()
  local caster = self:GetCaster()

  local ability = caster:FindAbilityByName("imba_enigma_black_hole") 

    if not self.parent or self.parent:IsNull() then self.parent = caster.hBlackHoleDummyUnit end
    if not self.parent or self.parent:IsNull() then return end

    local distance = (self:GetParent():GetAbsOrigin()-self.parent:GetAbsOrigin()):Length2D()
    local pct_distance = 1- (distance / self.radius)
    self.modifier.pull_strength = FrameTime() * math.max(self.min_pull_power , (self.pull_strength * pct_distance))

    if not self.stun_radius or distance < self.stun_radius or self.stun_radius == 0 then
      self:SetStackCount(1)
    else
      self:SetStackCount(0)
    end
end

-- Only stun in stun radius
function modifier_imba_enigma_black_hole_aura_modifier:CheckState()
    local states = 
    {
      [MODIFIER_STATE_STUNNED] = self:GetStackCount() == 1,
    }
    return states
end

-- Modifier applying force
LinkLuaModifier("modifier_imba_enigma_black_hole_force","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
modifier_imba_enigma_black_hole_force = class({})
function modifier_imba_enigma_black_hole_force:IsDebuff() return true end
function modifier_imba_enigma_black_hole_force:IsHidden() return true end
function modifier_imba_enigma_black_hole_force:IsPurgable() return false end
function modifier_imba_enigma_black_hole_force:IsPurgeException()return true end
function modifier_imba_enigma_black_hole_force:IsStunDebuff() return false end
function modifier_imba_enigma_black_hole_force:IsMotionController()  return true end
function modifier_imba_enigma_black_hole_force:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_imba_enigma_black_hole_force:OnCreated()
  if IsServer() then
    self:GetParent():StartGesture(ACT_DOTA_FLAIL)
    
    self:StartIntervalThink(FrameTime())
  end
end

function modifier_imba_enigma_black_hole_force:OnDestroy()
  if IsServer() then
    self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
    self:GetParent():SetUnitOnClearGround()
  end
end
function modifier_imba_enigma_black_hole_force:OnIntervalThink()
  -- Remove force if conflicting
  if not self:CheckMotionControllers() then
    self:Destroy()
    return nil
  end
  self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_imba_enigma_black_hole_force:HorizontalMotion()
  if IsServer() then
    if not self.parent or self.parent:IsNull() then self.parent = self:GetCaster().hBlackHoleDummyUnit end
    if self.parent:IsNull() then return end
    local eidolon_bonus_duration = 0
    local ab = self:GetCaster():FindAbilityByName("imba_enigma_demonic_conversion")
    local pull_strength = self.pull_strength

    local modifier = self:GetParent():FindModifierByName("modifier_imba_enigma_eidolon_attack_counter")
    if modifier then
      pull_strength = pull_strength + (modifier:GetStackCount() * (1+ab:GetSpecialValueFor("increased_mass_pull_pct")))
    end
    local direction = (self.parent:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
    local set_point = self:GetParent():GetAbsOrigin() + direction * self.pull_strength
    self:GetParent():SetAbsOrigin(Vector(set_point.x, set_point.y, GetGroundPosition(set_point, self:GetParent()).z))
    
  end
end

-- Demonic Conversion
imba_enigma_demonic_conversion = class({})

function imba_enigma_demonic_conversion:IsHiddenWhenStolen() return false end
function imba_enigma_demonic_conversion:IsRefreshable() return true end
function imba_enigma_demonic_conversion:IsStealable() return true end
function imba_enigma_demonic_conversion:IsNetherWardStealable() return true end

function imba_enigma_demonic_conversion:GetAbilityTextureName()
  return "enigma_demonic_conversion"
end

function imba_enigma_demonic_conversion:GetCastPoint()
  return self:GetSpecialValueFor("cast_point")
end

function imba_enigma_demonic_conversion:GetCastRange(a,b)
  return self:GetSpecialValueFor("cast_range")
end

function imba_enigma_demonic_conversion:CastFilterResultTarget(target)
  if IsServer() then
    local caster = self:GetCaster() 
    -- #8 Talent: Cast Eidolons on heroes
    if caster:HasTalent("special_bonus_imba_enigma_8") and target:IsRealHero() then
      return UF_SUCCESS
    end
    local nResult = UnitFilter(target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber())
    return nResult
  end
end

function imba_enigma_demonic_conversion:OnSpellStart()
  local caster = self:GetCaster()
  local target = self:GetCursorTarget()
  local location = target:GetAbsOrigin()

  if caster:IsAlive() and caster:HasTalent("special_bonus_imba_enigma_7") then
    local modifier = caster:FindModifierByName("modifier_enigma_magic_immunity")
    if modifier then
      local time = modifier:GetRemainingTime() + caster:FindTalentValue("special_bonus_imba_enigma_7")
      modifier:SetDuration(time,true)
      
    else
      caster:AddNewModifier(caster,nil,"modifier_enigma_magic_immunity",{duration = caster:FindTalentValue("special_bonus_imba_enigma_7")})
    end
  end

  EmitSoundOn("Hero_Enigma.Demonic_Conversion",caster)

  if not target:IsHero() then
    target:Kill(self,caster)
    target = nil
  end
  -- Create 3 eidolons
  for i=1,3 do
    self:CreateEidolons(location,0,self:GetSpecialValueFor("duration"),target)
  end
end

function imba_enigma_demonic_conversion:CreateEidolons(vLocation,nTimesRecycled,flDuration,hHero)
  nTimesRecycled = nTimesRecycled or 0
  hHero = hHero or self:GetCaster()
  hCaster = self:GetCaster()
  if flDuration then
    flDuration = flDuration + self:GetSpecialValueFor("child_duration")
  end
  local attacks_needed = self:GetSpecialValueFor("attacks_to_split") + (nTimesRecycled * self:GetSpecialValueFor("additional_attacks_split"))
  local duration = flDuration or self:GetSpecialValueFor("duration")
  
  local eidolon = CreateUnitByName("npc_imba_enigma_eidolon_"..math.min(4,self:GetLevel()),vLocation,true,hCaster,hCaster,hCaster:GetTeamNumber())
  eidolon:SetOwner(hCaster)
  eidolon:SetControllableByPlayer(hCaster:GetPlayerID(),true)
  
  eidolon:AddNewModifier(hCaster,self,"modifier_imba_enigma_eidolon",{duration = duration,parent = hHero:entindex()}).count = attacks_needed
  eidolon:AddNewModifier(hCaster,self,"modifier_kill",{duration = duration})
  eidolon.nTimesRecycled = nTimesRecycled + 1
  eidolon:SetUnitOnClearGround()
end

LinkLuaModifier("modifier_imba_enigma_eidolon","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
modifier_imba_enigma_eidolon = class({})

function modifier_imba_enigma_eidolon:IsDebuff() return false end
function modifier_imba_enigma_eidolon:IsHidden() return true end
function modifier_imba_enigma_eidolon:IsPurgable() return false end

function modifier_imba_enigma_eidolon:OnCreated(keys)
  if keys.parent then self.parent = EntIndexToHScript(keys.parent) end
  self.parent = self.parent or self:GetCaster()
  self.shard_percentage = self:GetAbility():GetSpecialValueFor("shard_percentage")
  self.child_duration = self:GetAbility():GetSpecialValueFor("child_duration")
  self.increased_mass_duration  = self:GetAbility():GetSpecialValueFor("increased_mass_duration")
end

function modifier_imba_enigma_eidolon:DeclareFunctions()
  local funcs = 
  {
    MODIFIER_EVENT_ON_ATTACK,

    MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
  }
  return funcs
end

function modifier_imba_enigma_eidolon:OnAttack(keys)
  -- Decide when to do nothing
  if not IsServer() then return end
  if keys.attacker ~= self:GetParent() then return end

  -- "The 7th attack will trigger this, doesnt have to be a valid target"
  if self.count <= 0 then
    -- Make 2 new eidolons
    self:GetAbility():CreateEidolons(self:GetParent():GetAbsOrigin(),self:GetParent().nTimesRecycled,self:GetRemainingTime(),self.parent)
    self:GetAbility():CreateEidolons(self:GetParent():GetAbsOrigin(),self:GetParent().nTimesRecycled,self:GetRemainingTime(),self.parent)
    self:GetParent():ForceKill(false)
    return
  end

  if keys.target:IsBuilding() or keys.target:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end

  -- Lower the stack count
  self.count = self.count -1


  -- Find the eidolon related modifier on the target or create one
  local modifier
  if keys.target:HasModifier("modifier_imba_enigma_eidolon_attack_counter") then
    modifier = keys.target:FindModifierByName("modifier_imba_enigma_eidolon_attack_counter")
    modifier:SetDuration(self.child_duration,true)
  else
    modifier = keys.target:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_imba_enigma_eidolon_attack_counter",{duration = self.increased_mass_duration})
    if modifier then
      modifier.hitByEidolons = {}
    end
  end
  if modifier then
    -- Set the correct amount of stacks
    -- Register this unit, then remove all the dead/removed units so the correct count can be registered.
    modifier.hitByEidolons[self:GetParent()] = true
    local count = 0
    for k,v in pairs(modifier.hitByEidolons) do
      if IsValidEntity(k) and k:IsAlive() then
        count = count + 1
      else
        modifier.hitByEidolons[k] = nil
      end
    end
    modifier:SetStackCount(count)
  end
end

function modifier_imba_enigma_eidolon:GetModifierExtraHealthBonus()
  -- Syncs perfectly
  if IsServer() then
    return self.shard_percentage * self.parent:GetMaxHealth() * 0.01
  end
end

function modifier_imba_enigma_eidolon:GetModifierPhysicalArmorBonus()
  return self.shard_percentage * self.parent:GetPhysicalArmorValue() * 0.01
end

function modifier_imba_enigma_eidolon:GetModifierPreAttack_BonusDamage()
  if IsServer() then
    local attack = self.shard_percentage * self.parent:GetAverageTrueAttackDamage(self.parent)
    self:SetStackCount(attack)
  end
  local number = self:GetStackCount() * 0.01
  return number
end

function modifier_imba_enigma_eidolon:GetModifierAttackSpeedBonus_Constant()
  return self.shard_percentage * self.parent:GetAttackSpeed()
end

function modifier_imba_enigma_eidolon:GetModifierMoveSpeedBonus_Constant()
  return self.shard_percentage * self.parent:GetIdealSpeed()  * 0.01
end

LinkLuaModifier("modifier_imba_enigma_eidolon_attack_counter","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
modifier_imba_enigma_eidolon_attack_counter = class({})

function modifier_imba_enigma_eidolon_attack_counter:IsDebuff() return false end
function modifier_imba_enigma_eidolon_attack_counter:IsHidden() return false end
function modifier_imba_enigma_eidolon_attack_counter:IsPurgable() return false end

LinkLuaModifier("modifier_enigma_magic_immunity","hero/hero_enigma",LUA_MODIFIER_MOTION_NONE)
modifier_enigma_magic_immunity = class({})

function modifier_enigma_magic_immunity:IsDebuff() return false end
function modifier_enigma_magic_immunity:IsHidden() return false end

function modifier_enigma_magic_immunity:CheckState()
  return {[MODIFIER_STATE_MAGIC_IMMUNE] = true}
end

function modifier_enigma_magic_immunity:GetEffectName()
  return "particles/hero/enigma/enigma_magic_immunity.vpcf"
end
function modifier_enigma_magic_immunity:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end
-----------------------------------------------------------
-- Talent modifier stuff overrides
-- Namely, Midnight Pulse aura talent thing
-----------------------------------------------------------
function modifier_special_bonus_imba_enigma_6:IsDebuff() return false end
function modifier_special_bonus_imba_enigma_6:IsHidden() return true end
function modifier_special_bonus_imba_enigma_6:IsPurgable() return false end
function modifier_special_bonus_imba_enigma_6:RemoveOnDeath() return false end
function modifier_special_bonus_imba_enigma_6:IsAura() return true end

function modifier_special_bonus_imba_enigma_6:OnCreated()
  if IsServer() then
    self.ability = self:GetParent():FindAbilityByName("imba_enigma_midnight_pulse")
    if not self.ability then
      return
    end
    self.auraRadius = self.ability:GetSpecialValueFor("radius")
    self.damage_per_tick = self:GetCaster():FindTalentValue("special_bonus_imba_enigma_6")

    self.particle = ParticleManager:CreateParticle("particles/hero/enigma/enigma_midnight_pulse_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(self.particle,0,self:GetParent(),PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
    ParticleManager:SetParticleControl(self.particle,1,Vector(self.auraRadius,0,0))

    self:StartIntervalThink(1)
  end
end

function modifier_special_bonus_imba_enigma_6:OnDestroy()
  if IsServer() then
    ParticleManager:DestroyParticle(self.particle,true)
    ParticleManager:ReleaseParticleIndex(self.particle)
  end
end

function modifier_special_bonus_imba_enigma_6:OnIntervalThink()
  -- Damage everyone inside
  -- We need to refresh this value   
  local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.auraRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
  for _,enemy in pairs(enemies) do
    local damage = 
    {
      victim = enemy,
      attacker = self:GetCaster(),
      damage = self.damage_per_tick * enemy:GetMaxHealth() * 0.01,
      damage_type = DAMAGE_TYPE_PURE,
      ability = self.ability,
      flags = DOTA_DAMAGE_FLAG_DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN,
    }
    ApplyDamage(damage)
  end

  -- Apply modifier for eidolons
  local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.auraRadius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
  for _,ally in pairs(allies) do
    if ally:GetOwner() == self:GetCaster():GetOwner() and ally:HasModifier("modifier_imba_enigma_eidolon") then
      duration = self.ability:GetSpecialValueFor("eidolon_heal_duration")
      ally:AddNewModifier(self:GetCaster(),self.ability,"modifier_imba_enigma_midnight_pulse_eidolon_regen",{duration = duration})
    end
  end

  if self:GetCaster():HasTalent("special_bonus_imba_enigma_3") then
    ParticleManager:SetParticleControl(self.particle,1,Vector(self.auraRadius,0,0))
  end
end

function modifier_special_bonus_imba_enigma_6:GetAuraRadius()
  return self.auraRadius
end