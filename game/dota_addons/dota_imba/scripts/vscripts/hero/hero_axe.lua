--[[
Author: sercankd
Date: 25.03.2017
Updated: 17.05.2017
]]

CreateEmptyTalents("axe")
local LinkedModifiers = {}
-------------------------------------------
--			     Berserker's Call            --
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_berserkers_call_buff_armor"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_berserkers_call_debuff_cmd"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_berserkers_call_talent"] = LUA_MODIFIER_MOTION_NONE,
})
imba_axe_berserkers_call = imba_axe_berserkers_call or class({})
function imba_axe_berserkers_call:OnSpellStart()
  local caster                    =       self:GetCaster()
  local ability                   =       self

  -- Ability specials
  local radius                    =      ability:GetSpecialValueFor("radius") + caster:FindTalentValue("special_bonus_imba_axe_1")
  self:GetCaster():EmitSound("Hero_Axe.Berserkers_Call")

  -- On cast, hit 1 or more units
  local responses_1_or_more_enemies = "axe_axe_ability_berserk_0"..math.random(1,9)
  -- On cast, hit no unit
  local responses_zero_enemy = "axe_axe_anger_0"..math.random(1,3)

  local particle = ParticleManager:CreateParticle("particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
  ParticleManager:SetParticleControl(particle, 2, Vector(radius, radius, radius))
  ParticleManager:ReleaseParticleIndex(particle)

  -- find targets
  local enemies_in_radius = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
  for _,target in pairs(enemies_in_radius) do
    target:SetForceAttackTarget(caster)
    target:MoveToTargetToAttack(caster)
    target:AddNewModifier(caster, self, "modifier_imba_berserkers_call_debuff_cmd", {duration = ability:GetSpecialValueFor("duration")})
  end

  -- if enemies table is empty play random responses_zero_enemy
  if next (enemies_in_radius) == nil then
    self:GetCaster():EmitSound(responses_zero_enemy)
  else
    self:GetCaster():EmitSound(responses_1_or_more_enemies)
  end

  caster:AddNewModifier(caster, self, "modifier_imba_berserkers_call_buff_armor", {duration = ability:GetSpecialValueFor("duration")})

  if caster:HasTalent("special_bonus_imba_axe_2") then
	local talent_duration = caster:FindTalentValue("special_bonus_imba_axe_2")
    caster:AddNewModifier(caster, self, "modifier_imba_berserkers_call_talent", {duration = ability:GetSpecialValueFor("duration") + talent_duration})
  end

end

function imba_axe_berserkers_call:GetCastAnimation()
  return ACT_DOTA_OVERRIDE_ABILITY_1
end

function imba_axe_berserkers_call:IsHidden()
  return false
end

function imba_axe_berserkers_call:IsHiddenWhenStolen()
  return false
end


-------------------------------------------
-- Berserker's Call caster modifier
-------------------------------------------

modifier_imba_berserkers_call_buff_armor = modifier_imba_berserkers_call_buff_armor or class({})
function modifier_imba_berserkers_call_buff_armor:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
  }
  return funcs
end

function modifier_imba_berserkers_call_buff_armor:GetModifierPhysicalArmorBonus()
  return self:GetAbility():GetSpecialValueFor( "bonus_armor")
end

function modifier_imba_berserkers_call_buff_armor:OnCreated()
  local caster_particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControl(caster_particle, 2, Vector(0, 0, 0))
  ParticleManager:ReleaseParticleIndex(caster_particle)
  return true
end

function modifier_imba_berserkers_call_buff_armor:GetStatusEffectName()
  return "particles/status_fx/status_effect_gods_strength.vpcf"
end

function modifier_imba_berserkers_call_buff_armor:IsPurgable()
  return false
end

function modifier_imba_berserkers_call_buff_armor:IsBuff()
  return true
end

function modifier_imba_berserkers_call_buff_armor:RemoveOnDeath()
  return true
end

-------------------------------------------
-- Berserker's Call caster talent modifier
-------------------------------------------

modifier_imba_berserkers_call_talent = modifier_imba_berserkers_call_talent or class({})

function modifier_imba_berserkers_call_talent:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_EVENT_ON_ATTACKED
  }
  return funcs
end

function modifier_imba_berserkers_call_talent:GetModifierPhysicalArmorBonus()
	local stack_count = self:GetCaster():GetModifierStackCount("modifier_imba_berserkers_call_talent", self)  
	return stack_count
end

function modifier_imba_berserkers_call_talent:OnAttacked(keys)
  if IsServer() then
    if keys.target == self:GetParent() then
      if self:GetCaster():HasModifier("modifier_imba_berserkers_call_buff_armor") then
        local stack_count = self:GetCaster():GetModifierStackCount("modifier_imba_berserkers_call_talent", self)
        self:GetParent():SetModifierStackCount("modifier_imba_berserkers_call_talent", self, stack_count + 1)
      end
    end
  end
end

function modifier_imba_berserkers_call_talent:IsBuff()
  return true
end

function modifier_imba_berserkers_call_talent:IsHidden()
  return false
end

function modifier_imba_berserkers_call_talent:IsPurgable()
  return false
end

-------------------------------------------
-- Berserker's Call enemy modifier
-------------------------------------------

modifier_imba_berserkers_call_debuff_cmd = modifier_imba_berserkers_call_debuff_cmd or class({})

function modifier_imba_berserkers_call_debuff_cmd:CheckState()
  local state = {[MODIFIER_STATE_COMMAND_RESTRICTED] = true}
  return state
end

function modifier_imba_berserkers_call_debuff_cmd:OnCreated()
  return true
end

function modifier_imba_berserkers_call_debuff_cmd:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
  }
  return funcs
end

function modifier_imba_berserkers_call_debuff_cmd:OnDestroy()
  if IsServer() then
    self:GetParent():SetForceAttackTarget(nil)
    return true
  end
end

function modifier_imba_berserkers_call_debuff_cmd:GetModifierAttackSpeedBonus_Constant()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    self.speed_bonus = ability:GetSpecialValueFor("bonus_as") + caster:FindTalentValue("special_bonus_imba_axe_5")
    return self.speed_bonus
end

function modifier_imba_berserkers_call_debuff_cmd:GetStatusEffectName()
  return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

function modifier_imba_berserkers_call_debuff_cmd:StatusEffectPriority()
  return 10
end

function modifier_imba_berserkers_call_debuff_cmd:IsHidden()
  return false
end

function modifier_imba_berserkers_call_debuff_cmd:IsDebuff()
  return true
end

function modifier_imba_berserkers_call_debuff_cmd:IsPurgable()
  return false
end

----------------------------------------------------------------------------------------------------


-------------------------------------------
-- Battle Hunger
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_battle_hunger_buff_haste"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_battle_hunger_debuff"] = LUA_MODIFIER_MOTION_NONE,
})

imba_axe_battle_hunger = imba_axe_battle_hunger or class({})
function imba_axe_battle_hunger:OnSpellStart(target)

  local caster                    =       self:GetCaster()
  if target == nil then
    target                        =       self:GetCursorTarget()
  end
  local ability                   =       self
  local caster_modifier           =       "modifier_imba_battle_hunger_buff_haste"
  local random_response           =       "axe_axe_ability_battlehunger_0"..math.random(1,3)

  self:GetCaster():EmitSound("Hero_Axe.Battle_Hunger")
  self:GetCaster():EmitSound(random_response)

  -- If the target possesses a ready Linken's Sphere, do nothing
  if target:GetTeamNumber() ~= caster:GetTeamNumber() then
    if target:TriggerSpellAbsorb(ability) then
      return nil
    end
  end

  -- If the caster doesnt have the stack modifier then we create it, otherwise
  -- we just update the value
  if not caster:HasModifier(caster_modifier) then
    caster:AddNewModifier(caster, self, caster_modifier, {})
    caster:SetModifierStackCount(caster_modifier, ability, 1)
  else
    if not target:HasModifier("modifier_imba_battle_hunger_debuff_dot") then
      local stack_count = caster:GetModifierStackCount(caster_modifier, ability)
      caster:SetModifierStackCount(caster_modifier, ability, stack_count + 1)
    end
  end

  --caster:AddNewModifier(caster, self, "modifier_imba_battle_hunger_buff_haste", {})
  target:AddNewModifier(caster, self, "modifier_imba_battle_hunger_debuff_dot", {})

end

-------------------------------------------
-- Battle Hunger caster modifier
-------------------------------------------

modifier_imba_battle_hunger_buff_haste = modifier_imba_battle_hunger_buff_haste or class({})

function modifier_imba_battle_hunger_buff_haste:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
  }
  return funcs
end

function modifier_imba_battle_hunger_buff_haste:GetModifierMoveSpeedBonus_Percentage()
  return self:GetAbility():GetSpecialValueFor("speed_bonus") * self:GetStackCount()
end

function modifier_imba_battle_hunger_buff_haste:IsHidden()
  return false
end

function modifier_imba_battle_hunger_buff_haste:IsPurgable()
  return false
end

-------------------------------------------
-- Battle Hunger enemy modifier
-------------------------------------------

modifier_imba_battle_hunger_debuff_dot = modifier_imba_battle_hunger_debuff_dot or class({})

function modifier_imba_battle_hunger_debuff_dot:OnCreated()
  if IsServer() then
    self.battle_hunger_particle = "particles/units/heroes/hero_axe/axe_battle_hunger.vpcf"
    self.kill_count = 0
    self.enemy_particle = ParticleManager:CreateParticle( self.battle_hunger_particle, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(self.enemy_particle, 2, Vector(0, 0, 0))

    self:StartIntervalThink(1)
  end
end

function modifier_imba_battle_hunger_debuff_dot:OnRefresh()
  self.kill_count = 0
end

function modifier_imba_battle_hunger_debuff_dot:OnIntervalThink()
  if IsServer() then
    local target = self:GetParent()
    local caster = self:GetCaster()
    local damage_over_time = self:GetAbility():GetSpecialValueFor( "damage" ) + caster:FindTalentValue("special_bonus_imba_axe_6")
    local damageTable = {
      victim = target,
      attacker = caster,
      damage = damage_over_time,
      damage_type = DAMAGE_TYPE_MAGICAL,
    }
    ApplyDamage(damageTable)
    --check if target is in fountain area
    if IsNearFriendlyClass(target, 1360, "ent_dota_fountain") then
      self:Destroy()
      return nil
    end
  end
end

function modifier_imba_battle_hunger_debuff_dot:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_EVENT_ON_DEATH, MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
  }
  return funcs
end

function modifier_imba_battle_hunger_debuff_dot:GetModifierMoveSpeedBonus_Percentage()
  return self:GetAbility():GetSpecialValueFor("slow") * 0.01
end

function modifier_imba_battle_hunger_debuff_dot:GetModifierTotalDamageOutgoing_Percentage()
    self.scepter 	= self:GetCaster():HasScepter()
    self.scepter_damage_reduction = self:GetAbility():GetSpecialValueFor( "scepter_damage_reduction" )
    if self.scepter then
      return self.scepter_damage_reduction
    else
      return 0
    end
end

function modifier_imba_battle_hunger_debuff_dot:GetStatusEffectName()
  return "particles/status_fx/status_effect_battle_hunger.vpcf"
end

function modifier_imba_berserkers_call_debuff_cmd:StatusEffectPriority()
  return 9
end

function modifier_imba_battle_hunger_debuff_dot:IsDebuff()
  return true
end

function modifier_imba_battle_hunger_debuff_dot:IsPurgable()
  return true
end

function modifier_imba_battle_hunger_debuff_dot:OnDestroy()
  if IsServer() then
    local caster = self:GetCaster()
    local stack_count = caster:GetModifierStackCount("modifier_imba_battle_hunger_buff_haste", self)
    if (stack_count == 1) then
      caster:RemoveModifierByName("modifier_imba_battle_hunger_buff_haste")
    else
      caster:SetModifierStackCount("modifier_imba_battle_hunger_buff_haste", self, stack_count - 1)
    end
    ParticleManager:DestroyParticle(self.enemy_particle, false)
    ParticleManager:ReleaseParticleIndex(self.enemy_particle)
  end
end

function modifier_imba_battle_hunger_debuff_dot:OnDeath(keys)
  if IsServer() then
    local units_to_kill = self:GetAbility():GetSpecialValueFor("units")
    if keys.attacker == self:GetParent() then
      self.kill_count = self.kill_count + 1
    end
    if units_to_kill == self.kill_count then
      self:Destroy()
    end
  end
end

----------------------------------------------------------------------------------------------------


-------------------------------------------
-- Counter Helix
-------------------------------------------
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_counter_helix_passive"] = LUA_MODIFIER_MOTION_NONE,
})
imba_axe_counter_helix = imba_axe_counter_helix or class({})

function imba_axe_counter_helix:GetIntrinsicModifierName()
  return "modifier_imba_counter_helix_passive"
end

-------------------------------------------
-- Counter Helix modifier
-------------------------------------------

modifier_imba_counter_helix_passive = modifier_imba_counter_helix_passive or class({})

function modifier_imba_counter_helix_passive:OnCreated()

  self.caster = self:GetCaster()
  self.ability = self:GetAbility()
  self.particle_spin_1 = "particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf"
  self.particle_spin_2 = "particles/units/heroes/hero_axe/axe_counterhelix.vpcf"
  self.modifier_enemy_taunt = "modifier_imba_berserkers_call_debuff_cmd"

  --ability specials
  self.radius = self.ability:GetSpecialValueFor("radius") + self.caster:FindTalentValue("special_bonus_imba_axe_3")
  self.proc_chance = self.ability:GetSpecialValueFor("proc_chance")
  self.base_damage = self.ability:GetSpecialValueFor("base_damage")
  self.taunted_damage_bonus_pct = self.ability:GetSpecialValueFor("taunted_damage_bonus_pct")
end

function modifier_imba_counter_helix_passive:OnRefresh()
    self:OnCreated()
end

function modifier_imba_counter_helix_passive:DeclareFunctions()
  local decFuncs = {MODIFIER_EVENT_ON_ATTACKED}
  return decFuncs
end

function modifier_imba_counter_helix_passive:OnAttacked(keys)
  if IsServer() then

    if keys.target == self:GetParent() then

      if self.caster:PassivesDisabled() then
          return nil
      end

      -- +30% of your strength added to Counter Helix damage.
      if self.caster:HasTalent("special_bonus_imba_axe_4") then
        self.str = self.caster:GetStrength() / 100
        self.talent_4_value = self.caster:FindTalentValue("special_bonus_imba_axe_4")
        self.bonus_damage = self.str * self.talent_4_value
        self.total_damage = self.base_damage + self.bonus_damage
      else
        self.total_damage = self.base_damage
      end

      --calculate chance to counter helix
      if RollPercentage(self.proc_chance) then
        self.helix_pfx_1 = ParticleManager:CreateParticle(self.particle_spin_1, PATTACH_ABSORIGIN_FOLLOW, self.caster)
        ParticleManager:SetParticleControl(self.helix_pfx_1, 0, self.caster:GetAbsOrigin())

        self.helix_pfx_2 = ParticleManager:CreateParticle(self.particle_spin_2, PATTACH_ABSORIGIN_FOLLOW, self.caster)
        ParticleManager:SetParticleControl(self.helix_pfx_2, 0, self.caster:GetAbsOrigin())

        self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
        self.caster:EmitSound("Hero_Axe.CounterHelix")

        -- Find nearby enemies
        self.enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        -- Apply damage to valid enemies
        for _,enemy in pairs(self.enemies) do
          local damage = self.total_damage

          -- If an enemy is tauned, increase damage on it
          if enemy:HasModifier(self.modifier_enemy_taunt) then            
              damage = damage * (1 + self.taunted_damage_bonus_pct * 0.01)            
              SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, enemy, damage, nil)
          end

          ApplyDamage({attacker = self.caster, victim = enemy, ability = self.ability, damage = self.total_damage, damage_type = DAMAGE_TYPE_PURE})
        end
      end
      return true
    end
  end
end

function modifier_imba_counter_helix_passive:IsPassive()
  return true
end
function modifier_imba_counter_helix_passive:IsHidden()
  return true
end
function modifier_imba_counter_helix_passive:IsBuff()
  return true
end
function modifier_imba_counter_helix_passive:IsPurgable()
  return false
end

----------------------------------------------------------------------------------------------------


-------------------------------------------
-- Culling Blade
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_culling_blade_buff_haste"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_culling_blade_motion"] = LUA_MODIFIER_MOTION_BOTH,
})
imba_axe_culling_blade = imba_axe_culling_blade or class({})

function imba_axe_culling_blade:GetCastRange()
  return 150 + self:GetCaster():FindTalentValue("special_bonus_imba_axe_8");
end

function imba_axe_culling_blade:OnSpellStart()

  self.caster = self:GetCaster()
  self.ability = self
  self.target = self:GetCursorTarget()
  self.target_location = self.target:GetAbsOrigin()
  self.scepter = self.caster:HasScepter()

  --particle
  self.particle_kill = "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
  self.kill_enemy_response = "axe_axe_ability_cullingblade_0"..math.random(1,2)

  --ability specials
  self.kill_threshold = self.ability:GetSpecialValueFor("kill_threshold")
  self.damage = self.ability:GetSpecialValueFor("damage")
  self.speed_bonus = self.ability:GetSpecialValueFor("speed_bonus")
  self.as_bonus = self.ability:GetSpecialValueFor("as_bonus")
  self.speed_duration = self.ability:GetSpecialValueFor("speed_duration")
  self.speed_aoe_radius = self.ability:GetSpecialValueFor("speed_aoe")
  self.max_health_kill_heal_pct = self.ability:GetSpecialValueFor("max_health_kill_heal_pct")  
  self.scepter_battle_hunger_radius = self.ability:GetSpecialValueFor("scepter_battle_hunger_radius")
  -- Check for Linkens
  if self.target:GetTeamNumber() ~= self.caster:GetTeamNumber() then
    if self.target:TriggerSpellAbsorb(self.ability) then
      return
    end
  end

  -- #7 Talent: Kill threshold increase
  self.kill_threshold = self.kill_threshold + self.caster:FindTalentValue("special_bonus_imba_axe_7")

  -- Initializing the damage table
  self.damageTable = {
    victim = self.target,
    attacker = self.caster,
    damage = self.damage,
    damage_type = self.ability:GetAbilityDamageType(),
    ability = self.ability
  }

  --leap
  	local vLocation = self:GetCursorPosition()
		local kv =
		{
			vLocX = vLocation.x,
			vLocY = vLocation.y,
			vLocZ = vLocation.z
		}

  -- Check if the target HP is equal or below the threshold
  if self.target:GetHealth() <= self.kill_threshold and not self.target:HasModifier("modifier_imba_reincarnation_scepter_wraith") then

    if self.caster:HasTalent("special_bonus_imba_axe_8") then
      self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_imba_culling_blade_motion", kv )
      self:GetCaster():StartGestureWithPlaybackRate( ACT_DOTA_CAST_ABILITY_4, 1 )
    	Timers:CreateTimer(0.40, function()
			  self:KillUnit(self.target)
        self:GetCaster():EmitSound("Hero_Axe.Culling_Blade_Success")
		  end)
    else
      self:KillUnit(self.target)
      self:GetCaster():EmitSound("Hero_Axe.Culling_Blade_Success")
    end
    

    -- if blink and ulti kill successfully then play blink response
    for i=0,5 do
      self.item = self.caster:GetItemInSlot(i)
      if self.item and self.item:GetAbilityName():find("^item_imba_blink") then
        self.blink_cd_remaining = self.item:GetCooldownTimeRemaining()
        self.blink_cd_total_minus_two = self.item:GetCooldown(0) - 2
        if(self.blink_cd_remaining >= self.blink_cd_total_minus_two) then
          self.kill_enemy_response = "axe_axe_blinkcull_0"..math.random(1,3)
        else
          self.kill_enemy_response = "axe_axe_ability_cullingblade_0"..math.random(1,2)
        end
      end
    end
    self:GetCaster():EmitSoundParams(self.kill_enemy_response,200,1000,1)

    -- find allied targets for speed bonus
    self.allies_in_radius = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.speed_aoe_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

    for _,target in pairs(self.allies_in_radius) do
      target:AddNewModifier(self.caster, self, "modifier_imba_culling_blade_buff_haste", {duration = self.speed_duration})
    end

    -- refresh cooldown if killed unit is player
    if (self.target:IsHero()) then
      self.ability:EndCooldown()
    end


  --scepter apply battle hunger to enemies in radius
  if self.scepter then
  	self.targets = FindUnitsInRadius(self.caster:GetTeamNumber(), self.target:GetAbsOrigin(), nil, self.scepter_battle_hunger_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
    self.battle_hunger_ability = self.caster:FindAbilityByName("imba_axe_battle_hunger")
    for _,enemies in pairs(self.targets) do
      self.battle_hunger_ability:OnSpellStart(enemies)
    end
  end
  
  else
    if self.caster:HasTalent("special_bonus_imba_axe_8") then
      self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_imba_culling_blade_motion", kv )
      self:GetCaster():StartGestureWithPlaybackRate( ACT_DOTA_CAST_ABILITY_4, 1 )
    	Timers:CreateTimer(0.50, function()
			  ApplyDamage( self.damageTable )
		  end)
    else
      ApplyDamage( self.damageTable )
    end
    EmitSoundOn("Hero_Axe.Culling_Blade_Fail", self:GetCaster())
  end
end

function imba_axe_culling_blade:KillUnit(target)

  target:ForceKill(false)
  self.heal_amount = (self.caster:GetMaxHealth() / 100) * self.max_health_kill_heal_pct  
  self.caster:Heal(self.heal_amount, self.caster)
  -- Play the kill particle
  self.culling_kill_particle = ParticleManager:CreateParticle(self.particle_kill, PATTACH_CUSTOMORIGIN, self.caster)
  ParticleManager:SetParticleControlEnt(self.culling_kill_particle, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target_location, true)
  ParticleManager:SetParticleControlEnt(self.culling_kill_particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target_location, true)
  ParticleManager:SetParticleControlEnt(self.culling_kill_particle, 2, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target_location, true)
  ParticleManager:SetParticleControlEnt(self.culling_kill_particle, 4, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target_location, true)
  ParticleManager:SetParticleControlEnt(self.culling_kill_particle, 8, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target_location, true)
  ParticleManager:ReleaseParticleIndex(self.culling_kill_particle)

end

function imba_axe_culling_blade:GetCastAnimation(target)
  if self:GetCaster():HasTalent("special_bonus_imba_axe_8") then
    return ACT_SHOTGUN_PUMP
  else
  return ACT_DOTA_CAST_ABILITY_4
  end
end

-------------------------------------------
-- Culling Blade sprint modifier
-------------------------------------------

modifier_imba_culling_blade_buff_haste = modifier_imba_culling_blade_buff_haste or class({})

function modifier_imba_culling_blade_buff_haste:OnCreated()

  self.axe_culling_blade_boost = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_boost.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
  ParticleManager:ReleaseParticleIndex(self.axe_culling_blade_boost)

end

function modifier_imba_culling_blade_buff_haste:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
  }
  return funcs
end

function modifier_imba_culling_blade_buff_haste:GetModifierMoveSpeedBonus_Percentage()
  return self:GetAbility():GetSpecialValueFor( "speed_bonus" )
end

function modifier_imba_culling_blade_buff_haste:GetModifierAttackSpeedBonus_Constant()
  return self:GetAbility():GetSpecialValueFor( "as_bonus" )
end

function modifier_imba_culling_blade_buff_haste:IsBuff()
  return true
end

function modifier_imba_culling_blade_buff_haste:IsPurgable()
  return true
end

function modifier_imba_culling_blade_buff_haste:GetStatusEffectName()
  return "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf"
end

-------------------------------------------
-- Culling Blade leap modifier
-------------------------------------------
-- credits goes to o0oradaro0o/Battleships_Reborn

modifier_imba_culling_blade_motion = modifier_imba_culling_blade_motion or class({})

function modifier_imba_culling_blade_motion:OnCreated(kv)
  self.axe_minimum_height_above_lowest = 500
  self.axe_minimum_height_above_highest = 100
  self.axe_acceleration_z = 4000
  self.axe_max_horizontal_acceleration = 3000

	if IsServer() then

		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end

    self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0

		self.vLoc = Vector( kv.vLocX, kv.vLocY, kv.vLocZ )
		self.vLastKnownTargetPos = self.vLoc

		local duration = self:GetAbility():GetSpecialValueFor( "duration" )
		local flDesiredHeight = self.axe_minimum_height_above_lowest * duration * duration
		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = math.max( flLowZ + flDesiredHeight, flHighZ + self.axe_minimum_height_above_highest )

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * self.axe_acceleration_z )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * self.axe_acceleration_z * flDeltaZ ) )
		self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / self.axe_acceleration_z, ( self.flInitialVelocityZ - flSqrtDet) / self.axe_acceleration_z )

		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0
	end
end

function modifier_imba_culling_blade_motion:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeHoriz = math.min( self.flCurrentTimeHoriz + dt, self.flPredictedTotalTime )
		local t = self.flCurrentTimeHoriz / self.flPredictedTotalTime
		local vStartToTarget = self.vLastKnownTargetPos - self.vStartPosition
		local vDesiredPos = self.vStartPosition + t * vStartToTarget

		local vOldPos = me:GetOrigin()
		local vToDesired = vDesiredPos - vOldPos
		vToDesired.z = 0.0
		local vDesiredVel = vToDesired / dt
		local vVelDif = vDesiredVel - self.vHorizontalVelocity
		local flVelDif = vVelDif:Length2D()
		vVelDif = vVelDif:Normalized()
		local flVelDelta = math.min( flVelDif, self.axe_max_horizontal_acceleration )

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
		me:SetOrigin( vNewPos )
	end
end

function modifier_imba_culling_blade_motion:UpdateVerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -self.axe_acceleration_z * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0
		
		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * self.axe_acceleration_z * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )
		local bLanded = false
		if ( vNewPos.z < flGroundHeight and bGoingDown == true ) then
			vNewPos.z = flGroundHeight
			bLanded = true
		end

		me:SetOrigin( vNewPos )
		if bLanded == true then
			self:GetParent():RemoveHorizontalMotionController( self )
			self:GetParent():RemoveVerticalMotionController( self )
			self:SetDuration(0.15,true)
		end
	end
end
-------------------------------------------
for LinkedModifier, MotionController in pairs(LinkedModifiers) do
	LinkLuaModifier(LinkedModifier, "hero/hero_axe", MotionController)
end