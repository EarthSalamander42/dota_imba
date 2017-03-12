imba_bane_enfeeble       = imba_bane_enfeeble       or class({})  
imba_bane_brain_sap      = imba_bane_brain_sap      or class({})  
imba_bane_nightmare      = imba_bane_nightmare      or class({})  
imba_bane_nightmare_end  = imba_bane_nightmare_end  or class({}) 
imba_bane_fiends_grip    = imba_bane_fiends_grip    or class({})

-- Enfeeble Debuff
modifier_imba_bane_enfeeble = class({
    IsDebuff                         = function(self) return true                                                                                                           end,    
    IsPurgable                       = function(self) return false                                                                                                          end,    
    IsPurgableException              = function(self) return false                                                                                                          end,        
    GetModifierBonusStats_Strength   = function(self) return self.strengthmodifier                                                                                          end,
    GetModifierBonusStats_Agility    = function(self) return self.agilitymodifier                                                                                           end,
    GetModifierBonusStats_Intellect  = function(self) return self.intellectmodifier                                                                                         end,
    GetModifierPreAttack_BonusDamage = function(self) return self.damagereduction                                                                                           end,
    GetEffectName                    = function(self) return "particles/units/heroes/hero_bane/bane_enfeeble.vpcf"                                                          end,
    GetEffectAttachType              = function(self) return PATTACH_OVERHEAD_FOLLOW                                                                                        end,
  })
-- brain_sap Debuff
modifier_imba_bane_brain_sap = class({
    IsDebuff                         = function(self) return true                                                                                                           end,
    GetModifierManaBonus             = function(self) return (((self:GetParent():GetIntellect() * 12) + 50) * (self:GetAbility():GetSpecialValueFor("manapool_reduction"))) end,    
  })
-- Nightmare Debuff
modifier_imba_bane_nightmare = class({
    IsDebuff                         = function(self) return true                                                                                                           end,
    IsNightmared                     = function(self) return true                                                                                                           end,
    IsPurgable                       = function(self) return true                                                                                                           end,    
    GetBonusVisionPercentage         = function(self) return -100                                                                                                           end,         
    GetEffectName                    = function(self) return "particles/units/heroes/hero_bane/bane_nightmare.vpcf"                                                         end,
    GetEffectAttachType              = function(self) return PATTACH_OVERHEAD_FOLLOW                                                                                        end,
    GetOverrideAnimation             = function(self) return ACT_DOTA_FLAIL                                                                                                 end,
    GetOverrideAnimationRate         = function(self) return 0.2                                                                                                            end,    
  })
modifier_imba_bane_nightmare_invuln_period = class({
    IsDebuff                         = function(self) return true                                                                                                           end,    
    IsHidden                         = function(self) return true                                                                                                           end,
  })
modifier_imba_bane_nightmare_baleful_visions = class({
    GetBonusVisionPercentage         = function(self) return self.visionreduction                                                                                           end,    
  })
-- Fiends Grip Debuff
modifier_imba_bane_fiends_grip = class({
    IsDebuff                         = function(self) return true                                                                                                           end,
    IsStunDebuff                     = function(self) return true                                                                                                           end,    
    IsPurgableException              = function(self) return true                                                                                                           end,      
    GetEffectName                    = function(self) return "particles/units/heroes/hero_bane/bane_fiends_grip.vpcf"                                                       end,
    GetEffectAttachType              = function(self) return PATTACH_OVERHEAD_FOLLOW                                                                                        end,
    GetOverrideAnimation             = function(self) return ACT_DOTA_FLAIL                                                                                                 end,
  })
-- Attach defined modifiers
LinkLuaModifier("modifier_imba_bane_enfeeble",                  "hero/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_bane_brain_sap",                 "hero/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_bane_nightmare",                 "hero/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_bane_nightmare_invuln_period",   "hero/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_bane_nightmare_baleful_visions", "hero/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_bane_fiends_grip",               "hero/hero_bane", LUA_MODIFIER_MOTION_NONE)



-- Generic Subroutines to make code easier (for me at least) to read

local function findtarget(source) -- simple list return function for finding a players current target entity
  local t = source:GetCursorTarget()
  local c = source:GetCaster()
  if t and c then return t,c end
end

local talentnamescheme = "special_bonus_unique_bane_"
-- talentmanager usage: talentmanager(entity,nameScheme,isParityNeeded,{(talentnumber)},{(talentnumber,"extra data requested")}
-- real example: nightmareduration = talentmanager(self:GetCaster,nameScheme,false,{1})
-- complex example: rupturebonus,thirstmove,thirstdmg = talentmanager(self:GetCaster,nameScheme,true,{5},{7,"value1","value2"})
function talentmanager(tEntity, nameScheme, isParityNeeded, ...) -- todo: add support for keys with multiple values (key_tEntity_1){value=1,value=2}
  --if IsStolenSpell(tEntity:GetCaster()) then end -- we probably need to do some special shit to avoid giving stolen spells talents, not sure  
  local values = {...}                                                                        -- Our user input
  local returnvalues = {}                                                                     -- table that will be unpacked for result                                                    
  local playerstalenttable = "player_"..tEntity:GetPlayerOwnerID().."_"..nameScheme
  if isParityNeeded == true then
    for k,v in ipairs(values) do  
      local talentnumber = v[1]                                                               -- should be 1-8, but probably can be extrapolated later on to be any number
      local talentname = nameScheme..talentnumber                                             -- special_bonus_unique_bane_1 (for keyvalue txt)
      local keyname = playerstalenttable..talentnumber                                        -- player_(#)_special_bonus_unique_bane(1-8)
      if IsServer() then
        local netTableKey = netTableCmd(false,"talents",keyname)                              -- Command to grab our key value pair
        if tEntity:HasTalent(talentname) then                                                 -- Do we have the talent?
          local kvpair = createNetTableKey(tEntity,true,nameScheme,v)                         -- call function to write my net table key with flag has talent (which can be any number of arguments)
          
          if not netTableKey then                                                             -- We have talent and value isn't populated (rare)        
            netTableCmd(true,"talents",keyname,kvpair)                                        -- We didn't find a current kv pair, so create one 
          else
            for i=1,#netTableKey do                                                           -- iterate through all potential values 
              print(netTableKey[i],kvpair[i])
              if netTableKey[i] ~= kvpair[i] then                                             -- We have talent and value is populated but incorrect (common)
                print('our key was wrong!')
                netTableCmd(true,"talents",keyname,kvpair)                                    -- Rewrite entire key with new data
                break                                                                         -- We only need to rewrite once, since it'll populate the entire key
              end
            end
          end
        else                                                                                  -- this should be the 'we don't have talent' else, but serverside
          local kvpair = createNetTableKey(tEntity,false,nameScheme,v)
          if not netTableKey then                                                             -- We don't have talent, and the kv pair doesn't exist so...
            if type(netTableKey) == 'boolean' then                                            -- The table exists but we only got a true/false statement that it does, it is not populated if this is true.
              netTableCmd(true,"talents",keyname,kvpair)                                      -- Write a value for clients to be able to read (which will be 0 instead of nil)
            end
          end
        end
        returnvalues = netTableCmd(false,"talents",keyname)                                   -- Get the whoooole table in one go, we make the somewhat dangerous assumption the table actually exists i suppose
      else
        local finaltableresult = netTableCmd(false,"talents",keyname)                              -- We're a client
        for i=1,#v do
          if finaltableresult then                                                                 -- Talent value is set
            if type(finaltableresult) ~= 'boolean' then
              for i=1,#finaltableresult do
                table.insert(returnvalues,finaltableresult[i])                                        -- Grab and insert result into our return table
              end
            end
          else                                                                                -- else if its not set, 0
            table.insert(returnvalues,0)                                                      -- populate table with 0 when we fail to receive value (should not happen, we should get this data from net tables basically 100% of the time)
          end
        end      
      end
    end
  else                                                                                          -- Just check values if we don't care about nettables
    if IsServer() then
      for k,v in ipairs(values) do
        local talentnumber = v[1]                                                               -- should be 1-8, but probably can be extrapolated later on to be any number
        local talentname = nameScheme..talentnumber                                             -- special_bonus_unique_bane_1 (for keyvalue txt)
        local keyname = playerstalenttable..talentnumber                                        -- player_(#)_special_bonus_unique_bane(1-8)        
       -- local kvpair = {}
        if tEntity:HasTalent(talentname) then 
          kvpair = createNetTableKey(tEntity,true,nameScheme,v)
          for i=1,#kvpair do
            table.insert(returnvalues,kvpair[i])
          end
        else
          kvpair = createNetTableKey(tEntity,false,nameScheme,v)
          for i=1,#kvpair do
            table.insert(returnvalues,kvpair[i])
          end          
        end
      end
    else
      returnvalues = {0,0,0,0,0,0,0,0} -- This should never ever execute on the client side, if you are receiving an 8 value 0 response here you did not wrap this code in isserver while calling talentmanager & parity off
    end
  end
return unpack(returnvalues)
end

function netTableCmd(send,readtable,key,tabletosend) -- Beg valve to make this more user friendly
  if send == false then
    local finalresulttable = {}
    local nettabletemp = CustomNetTables:GetTableValue(readtable,key)
    if not nettabletemp then return false end
    for key,value in pairs(nettabletemp) do
      table.insert(finalresulttable,value)
    end          
    if #finalresulttable > 0 then 
      return finalresulttable
    else
      return true
    end
  else
    CustomNetTables:SetTableValue(readtable, key, tabletosend)
  end
end

function createNetTableKey(tEntity, talentrequest,nameScheme,v)
  local valuePair = {}
  if #v > 1 then                                                           -- is our user requesting multiple values?
    for i=2,#v do                                                          -- If our talent check succeeded, place talent value in a value pair {value1=value},{value2=value}
      if talentrequest == true then
        if string.match(v[i],"=") then
          print(tonumber(string.match(v[i],"%d+")))
          table.insert(valuePair, tonumber(string.match(v[i],"%d+")))
          else
          table.insert(valuePair, tEntity:GetCaster():FindSpecificTalentValue(""..nameScheme..v[1],v[i])) 
        end
      else
        table.insert(valuePair,0)                                            -- talent check failed, so set our value pair to 0 
      end
    end
  else
    if talentrequest == true then                                           -- Single values only, only difference is it just returns the first talentvalue
      local append = tostring(nameScheme..v[1])
      table.insert(valuePair, tEntity:FindTalentValue(append))              -- example: {value1 = 16}
    else
      table.insert(valuePair,0)                                                -- talent check failed, so set our value pair to 0 
    end
  end
  return valuePair  
end

function getkvValues(tEntity, ...) -- KV Values look hideous in finished code, so this function will parse through all sent KV's for tEntity (typically self)
  local values = {...}
  local data = {}
  for i,v in ipairs(values) do
    table.insert(data,tEntity:GetSpecialValueFor(v))
  end
  return unpack(data)
end

-- End Generic Subs

-- ####Main Ability Functions Start####
-- define one line functions here because they look make working code look confusing
function imba_bane_fiends_grip:GetChannelAnimation() return ACT_DOTA_CHANNEL_ABILITY_4 or ACT_DOTA_CHANNEL_ABILITY_5 end
function imba_bane_enfeeble:IsHiddenWhenStolen() return false                                                        end
function imba_bane_brain_sap:IsHiddenWhenStolen() return false                                                       end
function imba_bane_nightmare:IsHiddenWhenStolen() return false                                                       end
function imba_bane_nightmare_end:IsHiddenWhenStolen() return false                                                   end
function imba_bane_fiends_grip:IsHiddenWhenStolen() return false                                                     end

-- sound responses
function imba_bane_enfeeble:GetConceptRecipientType() return                                                               end
function imba_bane_brain_sap:GetConceptRecipientType() return                                                         end
function imba_bane_nightmare:GetConceptRecipientType() return                                                        end
function imba_bane_fiends_grip:GetConceptRecipientType() return                                                        end

function imba_bane_enfeeble:Trigger() if RollPercentage(75) then return DOTA_ABILITY_SPEAK_CAST  end            end
function imba_bane_brain_sap:Trigger() if RollPercentage(75) then return DOTA_ABILITY_SPEAK_CAST  end           end
function imba_bane_nightmare:Trigger() print('we expect response!') return DOTA_ABILITY_SPEAK_CAST                                           end
function imba_bane_fiends_grip:Trigger() return DOTA_ABILITY_SPEAK_CAST                                         end


-- Enfeeble Spell Cast
function imba_bane_enfeeble:OnSpellStart() 
  if not IsServer() then return end
  local target,caster = findtarget(self)
  if target:TriggerSpellAbsorb(self) then return end
  local enfeeble_duration = getkvValues(self,"enfeeble_duration")  
  target:AddNewModifier(caster, self, "modifier_imba_bane_enfeeble", {duration = enfeeble_duration})
  EmitSoundOn("Hero_Bane.Enfeeble.Cast", caster)
  EmitSoundOn("hero_bane.enfeeble", target)
  if RollPercentage(75) then
    EmitSoundOn ("bane_bane_ability_enfeeble_"..string.format("%02d",RandomInt(1,14)), self:GetCaster())
    print('playing sound!')
  end       
end

-- Brain Sap Spell Cast

function imba_bane_brain_sap:OnSpellStart()
  if not IsServer() then return end
  local target,caster = findtarget(self)
  local sapdamage,sapduration = getkvValues(self,"brain_sap_damage","brain_sap_duration")  
  local talentdamagebonus,talentdurationbonus = talentmanager(self:GetCaster(),talentnamescheme,false,{5},{1})
  if target:TriggerSpellAbsorb(self) then return end -- Does player have linkins or another spell absorb?
  damage = {
    victim      = target,
    attacker    = caster,
    damage      = sapdamage+talentdamagebonus,
    damage_type = DAMAGE_TYPE_PURE,
    ability     = self
  }
  ApplyDamage(damage)
  caster:Heal(sapdamage+talentdamagebonus, caster) -- todo caster healamp from spell damage amp?
  target:AddNewModifier(caster, self, "modifier_imba_bane_brain_sap", {duration = (sapduration+talentdurationbonus)}) -- debuff enemy
  local sapFX = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_sap.vpcf", PATTACH_ABSORIGIN, caster)     -- o boy here we go sappin again
  ParticleManager:SetParticleControlEnt(sapFX, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)   -- just gfx commands
  ParticleManager:SetParticleControlEnt(sapFX, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)   -- attach from a->b
  ParticleManager:ReleaseParticleIndex(sapFX)   -- release index
  EmitSoundOn("Hero_Bane.BrainSap", caster)
  EmitSoundOn("Hero_Bane.BrainSap.Target", target) -- slslslllslslsllrprpp
  if RollPercentage(75) then
    EmitSoundOn ("bane_bane_ability_brainsap_"..string.format("%02d",RandomInt(1,6)), self:GetCaster())
  end    
end

function imba_bane_brain_sap:GetCastRange(l,t)
  local talentrangebonus = talentmanager(self:GetCaster(),talentnamescheme,true,{4}) 
  if IsServer() then return self.BaseClass.GetCastRange(self,l,t)+talentrangebonus end
  if IsClient() then return self.BaseClass.GetCastRange(self,l,t)
  end
end

-- Nightmare Spell Cast
function imba_bane_nightmare:OnUpgrade()
  if self:GetCaster():HasAbility("imba_bane_nightmare_end") and self:GetCaster():FindAbilityByName("imba_bane_nightmare_end"):GetLevel() ~= 1 then --do we have nightmareend? is nightmare end skilled?
    self:GetCaster():FindAbilityByName("imba_bane_nightmare_end"):SetLevel(1) -- skill it if both true
  end
end

function imba_bane_nightmare:GetAssociatedSecondaryAbilities()
  return "imba_bane_nightmare_end" 
end 

function imba_bane_nightmare:OnSpellStart()
  if not IsServer() then return end
  local target,caster = findtarget(self) -- who did we target? who are we?
  if target:TriggerSpellAbsorb(self) then return end    -- 'ting!' linkins
  local invulnduration,nightmareduration = getkvValues(self,"nightmare_invuln_duration","nightmare_duration")    -- get kv valuse
  local talentinvulnbonus = talentmanager(self:GetCaster(),talentnamescheme,false,{7})        -- get talent bonus

  if caster:GetTeamNumber() == target:GetTeamNumber() then -- are we on the same team? if so buff the invuln duration by the talent 
    invulnduration=invulnduration+talentinvulnbonus
  end    
  target:AddNewModifier(caster, self, "modifier_imba_bane_nightmare",               {duration = nightmareduration}) -- im schleep
  target:AddNewModifier(caster, self, "modifier_imba_bane_nightmare_invuln_period", {duration = invulnduration})
  EmitSoundOn("hero_bane.nightmare", target)
  if caster ~= target then
    EmitSoundOn ("bane_bane_ability_nightmare_"..string.format("%02d",RandomInt(1,3)), self:GetCaster())   
    end
end

function imba_bane_nightmare_end:OnSpellStart()
  if not IsServer() then return end
  local target,caster = findtarget(self)
  EmitSoundOn("Hero_Bane.Nightmare.End", caster)
  if target:HasModifier("modifier_imba_bane_nightmare_invuln_period") then -- We can't debuff an immune target! so remove this first
    target:RemoveModifierByName("modifier_imba_bane_nightmare_invuln_period")
  end    
  if target:HasModifier("modifier_imba_bane_nightmare") then  --do we have it? remove it
    target:RemoveModifierByName("modifier_imba_bane_nightmare")
  end
end

function imba_bane_nightmare_end:GetAssociatedPrimaryAbilities()
  return "imba_bane_nightmare" end

-- Fiends Grip Spell Cast

function imba_bane_fiends_grip:GetChannelTime()
  local talentchannelbonus = talentmanager(self:GetCaster(),talentnamescheme,true,{6})  -- net tables
  return (self:GetSpecialValueFor("fiends_grip_duration")+talentchannelbonus)
end

function imba_bane_fiends_grip:GetCooldown(nLevel)
  local talentcooldownbonus = talentmanager(self:GetCaster(),talentnamescheme,true,{8}) -- net tables
  return self.BaseClass.GetCooldown( self, nLevel )-talentcooldownbonus 
end

-- Create table to store all fiendgrip victims, with no scepter it's always 1
function imba_bane_fiends_grip:OnSpellStart()  
  if not IsServer() then return end
  self.fiendtarget,self.fiendcaster = findtarget(self) -- we append fiendcaster and fiendtarget into class values for use later in cases of channel interruption or spell reflection to avoid conflicts
  if self.fiendtarget:TriggerSpellAbsorb(self) then self.fiendcaster:Interrupt() return end    
  local fiends_grip_duration = getkvValues(self,"fiends_grip_duration")  
  local talentchannelbonus = talentmanager(self:GetCaster(),talentnamescheme,true,{6}) 
  self.fiendgriptable = {} -- set table to blank when skill is invoked to avoid weird shit
  table.insert(self.fiendgriptable,self.fiendtarget)  -- o ur about to get spooked really good now fiendtarget!
  self.fiendtarget:Interrupt()  -- !
  self.fiendtarget:AddNewModifier(self.fiendcaster, self, "modifier_imba_bane_fiends_grip", {duration = fiends_grip_duration+talentchannelbonus,propogated = 0, original_target = 1}) -- we are the original target, it has not spread
  EmitSoundOn("Hero_Bane.FiendsGrip.Cast", self.fiendcaster)  
  EmitSoundOn("hero_bane.fiends_grip", self.fiendtarget)
  EmitSoundOn("hero_bane.fiends_grip", self.fiendcaster)
  EmitSoundOn ("bane_bane_ability_fiendsgrip_"..string.format("%02d",RandomInt(1,7)), self:GetCaster())  
end

-- When channel is finished or interrupted iterate through table and destroy original modifier. Destroy will trigger OnDestroy() for the modifier, and determine eligibility for propogation
function imba_bane_fiends_grip:OnChannelFinish(bInterrupted) 
  if not IsServer() then return end  
  for k,v in pairs(self.fiendgriptable) do
    -- Doing it this way prevents a runtime error in case some not accounted for situations occur.
    if ((self.fiendgriptable[k]:HasModifier("modifier_imba_bane_fiends_grip")) and self.fiendgriptable[k]:FindModifierByName("modifier_imba_bane_fiends_grip").propogated == 0) then
      self.fiendgriptable[k]:FindModifierByName("modifier_imba_bane_fiends_grip"):Destroy() -- if our target has been gripped, and it has not been spread by itself, destroy it (which will reinvoke and set propogated to 1)
    end
  end
end

-- We only care about channel operations when he has scepter
function imba_bane_fiends_grip:OnChannelThink()
  if not IsServer() then return end
  if self:GetCaster():HasScepter() then
    local vision_radius,vision_cone,fiends_grip_duration = getkvValues(self,"fiends_grip_duration","fiends_grip_scepter_radius","fiends_grip_scepter_vision_cone") 
    local talentchannelbonus = talentmanager(self:GetCaster(),talentnamescheme,true,{6}) 
    local caster_location = self.fiendcaster:GetAbsOrigin()
    local enemies_to_check = FindUnitsInRadius(self.fiendcaster:GetTeamNumber(), caster_location, nil, vision_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, self:GetAbilityTargetType(), 0, FIND_CLOSEST, false)
    for _,v in pairs(enemies_to_check) do
      caster_location = self.fiendcaster:GetAbsOrigin()
      local isgripped = v:HasModifier("modifier_imba_bane_fiends_grip")
      local target_location = v:GetAbsOrigin()
      local direction = (caster_location - target_location):Normalized()
      local forward_vector = v:GetForwardVector() -- im probably too stupid for vector shit, firetoad wrote this i just slapped some true false in there. didn't touch original code
      local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y)
      if angle <= ( vision_cone / 2 ) and v:CanEntityBeSeenByMyTeam(self.fiendcaster) and v~=self.fiendtarget and not isgripped and not v:IsMagicImmune() then
        v:AddNewModifier(self.fiendcaster, self, "modifier_imba_bane_fiends_grip", {duration = ((fiends_grip_duration+talentchannelbonus)-(GameRules:GetGameTime()-self:GetChannelStartTime())),propogated = 0})
        table.insert(self.fiendgriptable,v)
      end
    end    
  end
end

--### Modifier Definitions Start ### --

-- Enfeeble Debuff Start
function modifier_imba_bane_enfeeble:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
  }
  return funcs
end

function modifier_imba_bane_enfeeble:OnCreated()
  local statreduction,damagereduction = getkvValues(self:GetAbility(),"stat_reduction","damage_reduction") 
  local talentdamagereduction = talentmanager(self:GetCaster(),talentnamescheme,true,{3})
  self.damagereduction   = damagereduction+talentdamagereduction   
  if not IsServer() then return end
  self.strengthmodifier  = self:GetParent():GetStrength()  * (statreduction/100) -- Note these are only evaluated once, on spell cast.  On refresh they will                      
  self.agilitymodifier   = self:GetParent():GetAgility()   * (statreduction/100) -- NOT be recalculated, this can be rewritten to calculate stat reduction on
  self.intellectmodifier = self:GetParent():GetIntellect() * (statreduction/100) -- recast or w/e is required
end

-- Enfeeble Debuff End

-- Brain Sap Debuff Start

function modifier_imba_bane_brain_sap:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MANA_BONUS,
  }
  return funcs  
end
-- Brain Sap Debuff End


-- Nightmare Debuff Start

function modifier_imba_bane_nightmare:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_EVENT_ON_ATTACK_START,  
    MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
  }
  return funcs
end

function modifier_imba_bane_nightmare:OnCreated()
  self:GetBonusVisionPercentage()
  if not IsServer() then return end  
  self:OnIntervalThink()  
  self:StartIntervalThink(1)
end

function modifier_imba_bane_nightmare:CheckState()
  return{
    [MODIFIER_STATE_NIGHTMARED]           = true,
    [MODIFIER_STATE_STUNNED]              = true,
    [MODIFIER_STATE_SPECIALLY_DENIABLE]   = true,
    [MODIFIER_STATE_LOW_ATTACK_PRIORITY]  = true,
  }
end

function modifier_imba_bane_nightmare:OnTakeDamage(t)
  if not IsServer() then return end
  if t.unit == self:GetParent() then
    self:Destroy()
  end
end

function modifier_imba_bane_nightmare:OnAttackStart(t)
  if not IsServer() then return end
  if t.target == self:GetParent() then -- am i the target of an attack?
    local nightmare_duration,nightmare_invuln_duration = getkvValues(self:GetAbility(),"nightmare_duration","nightmare_invuln_duration")
    t.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_bane_nightmare", {duration = nightmare_duration}) -- Spread Nightmare
    t.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_bane_nightmare_invuln_period", {duration = nightmare_invuln_duration}) -- Apply invuln, idk if firetoad wanted allies to gain the talent so i'm leaving original functionality
    --self:Destroy() -- This is the original design of nightmare, it wasn't specified in the board if we only wanted '1' active nightmare.  So it's here if someone wants to uncomment it
  end
end


function modifier_imba_bane_nightmare:OnIntervalThink()
  if not IsServer() then return end
  local CurHP = self:GetParent():GetHealth()
  local nightmare_damage = getkvValues(self:GetAbility(),"nightmare_damage")
  local talentinvulnbonus = talentmanager(self:GetCaster(),talentnamescheme,true,{7,"value="..999})        -- get talent bonus
  print(talentinvulnbonus)
  if (CurHP <= nightmare_damage) then
    local damage = {
      victim      = self:GetParent(),
      attacker    = self:GetCaster(),
      damage      = nightmare_damage+talentinvulnbonus,
      damage_type = DAMAGE_TYPE_PURE,
      ability     = self:GetAbility()
    }
    -- Frag target with pure damage, give kill credit to Bane.
    ApplyDamage(damage)
  else
    -- While I could apply damage in a more traditional way, IIRC Banes' Nightmare does 'damage' by just subtracting from the targets current health.
    self:GetParent():SetHealth(CurHP - nightmare_damage-talentinvulnbonus)
  end
  EmitSoundOn("Hero_Bane.Nightmare.Loop", target)
end

function modifier_imba_bane_nightmare:OnDestroy()
  if not IsServer() then return end
  if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then -- when nightmare is destroyed, are we an enemy?
    if not self:GetParent():IsMagicImmune() then  -- are we magic immune if we're an enemy?
      local nightmare_baleful_visions_duration = getkvValues(self:GetAbility(),"nightmare_baleful_visions_duration") 
      local talentdurationbonus = talentmanager(self:GetCaster(),talentnamescheme,false,{2}) 
      self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_bane_nightmare_baleful_visions", {duration = nightmare_baleful_visions_duration+talentdurationbonus}) -- blind them
    end
  end
  if self:GetParent():HasModifier("modifier_imba_bane_nightmare_invuln_period") then -- If we don't do this, clever players will only skill one point in nightmare and take the 6sec invuln talent
    self:GetParent():RemoveModifierByName("modifier_imba_bane_nightmare_invuln_period")
  end      
  EmitSoundOn("Hero_Bane.Nightmare.End", self:GetParent())
end

-- Nightmare Invulnerability
function modifier_imba_bane_nightmare_invuln_period:DeclareFunctions()
  local funcs = {
    MODIFIER_STATE_INVULNERABLE,
    MODIFIER_STATE_NO_HEALTH_BAR
  }
  return funcs
end

function modifier_imba_bane_nightmare_invuln_period:CheckState()
  return{[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true}
end

-- Nightmare Baleful Visions

function modifier_imba_bane_nightmare_baleful_visions:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
  }
  return funcs
end

function modifier_imba_bane_nightmare_baleful_visions:OnCreated()
  self:StartIntervalThink(0)
end

function modifier_imba_bane_nightmare_baleful_visions:OnIntervalThink()
  local nightmare_baleful_visions_sight_reduction = getkvValues(self:GetAbility(),"nightmare_baleful_visions_sight_reduction") 
  self.visionreduction = nightmare_baleful_visions_sight_reduction*((self:GetRemainingTime() / self:GetDuration())*-1)
  self:GetBonusVisionPercentage()
end


-- Nightmare Debuff End

-- Fiends Grip Debuff Start

function modifier_imba_bane_fiends_grip:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
  }
  return funcs  
end

function modifier_imba_bane_fiends_grip:OnCreated(var)
  if not IsServer() then return end 
  self:GetParent():Interrupt()  
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)  -- Flail em
  self:OnIntervalThink() -- Invoke a damage instance, once
  self:StartIntervalThink(1) -- Begin damage instances, 1 second interval
  self.propogated = var.propogated -- attribute defining a 'spread' grip
  self.original_target = var.original_target -- Original target for interrupt purposes
end

function modifier_imba_bane_fiends_grip:OnRefresh(var)
  if not IsServer() then return end   
  self:GetParent():Interrupt()    
  self:OnIntervalThink()  
  self:StartIntervalThink(1)
  self.propogated = var.propogated
  self.original_target = var.original_target
end

function modifier_imba_bane_fiends_grip:OnIntervalThink()
  if not IsServer() then return end 
  local fiends_grip_mana_damage,fiends_grip_damage = getkvValues(self:GetAbility(),"fiends_grip_mana_damage","fiends_grip_damage")
  self:GetParent():ReduceMana(self:GetParent():GetMaxMana() * (fiends_grip_mana_damage/100)) -- Reducing mana first, no particular reasoning why.
  local damage = {
    victim      = self:GetParent(),
    attacker    = self:GetCaster(),
    damage      = fiends_grip_damage,
    damage_type = DAMAGE_TYPE_PURE,
    ability     = self:GetAbility()
  }
  if not self:GetParent():IsMagicImmune() then
    ApplyDamage(damage)
  end
end

function modifier_imba_bane_fiends_grip:CheckState()
  local state = {
    [MODIFIER_STATE_STUNNED] = true,
  }
  return state
end

function modifier_imba_bane_fiends_grip:OnDestroy()  
  if not IsServer() then return end   
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)     -- Fade the gesture, even though it can be immeditaely reinvoked if it's not been spread
  if not self:GetParent():IsMagicImmune() and self.propogated == 0 then -- Are we magic immune somehow(omniknight)? if not, have we already retriggered once?
    if self.original_target == 1 then -- If we are the original target and it's NOT spread, we need to interrupt the primary caster (typically Bane)
      self:GetCaster():InterruptChannel()
    end
    local fiends_grip_linger_duration = getkvValues(self:GetAbility(),"fiends_grip_linger_duration")      
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_bane_fiends_grip", {duration = fiends_grip_linger_duration, propogated = 1})   
  end
end

-- Fiends Grip Debuff End

-- Modifier Definitions End