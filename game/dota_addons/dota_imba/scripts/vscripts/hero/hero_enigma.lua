--[[	Author: Firetoad
		Date: 12.01.2016	]]

CreateEmptyTalents("enigma")
imba_enigma_malefice           = imba_enigma_malefice           or class({})  
imba_enigma_demonic_conversion = imba_enigma_demonic_conversion or class({})  
imba_enigma_midnight_pulse     = imba_enigma_midnight_pulse     or class({})  
imba_enigma_black_hole         = imba_enigma_black_hole         or class({}) 
imba_enigma_gravity_well       = imba_enigma_gravity_well       or class({}) 

LinkLuaModifier("modifier_imba_enigma_malefice",           "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_malefice_stun",      "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_demonic_conversion", "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_eidolon_buffs",                  "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_midnight_pulse",     "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_black_hole",         "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_singularity",        "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)

-- Enfeeble Debuff
modifier_imba_enigma_malefice = class({  -- ticking debuff for malefice duration
    IsDebuff                         = function(self) return true                                                                                                           end,    
    IsPurgable                       = function(self) return true                                                                                                           end,         
  })
-- Enfeeble Debuff
modifier_imba_enigma_malefice_stun = class({ -- actual 'stun' of malefice, make sure to apply this to a radius around primary target
    IsDebuff                         = function(self) return true                                                                                                           end,    
    IsPurgable                       = function(self) return false                                                                                                          end,       
    GetEffectName                    = function(self) return "particles/generic_gameplay/generic_stunned.vpcf"                                                              end,
    GetEffectAttachType              = function(self) return PATTACH_OVERHEAD_FOLLOW                                                                                        end,
  })
-- brain_sap Debuff
modifier_imba_enigma_demonic_conversion = class({
    IsDebuff                         = function(self) return true                                                                                                           end,
  })
modifier_eidolon_buffs = class({ 
    IsBuff                           = function(self) return true                                                                                                           end,
    IsPurgable                       = function(self) return false                                                                                                          end,           
    IsHidden                         = function(self) return false                                                                                                           end,    
  })

-- Nightmare Debuff
modifier_imba_enigma_midnight_pulse = class({ -- damage over tick time and extra pull from grav well
    IsDebuff                         = function(self) return true                                                                                                           end,
    IsNightmared                     = function(self) return true                                                                                                           end,
    IsPurgable                       = function(self) return true                                                                                                           end,       
    --GetEffectName                    = function(self) return "particles/units/heroes/hero_bane/bane_nightmare.vpcf"                                                         end,
    --GetEffectAttachType              = function(self) return PATTACH_OVERHEAD_FOLLOW                                                                                        end,
    --GetOverrideAnimation             = function(self) return ACT_DOTA_FLAIL                                                                                                 end,
    --GetOverrideAnimationRate         = function(self) return 0.2                                                                                                            end,    
  })
modifier_imba_enigma_black_hole = class({ -- ultra hard disable, forces pull on gravity well, enigma gets perma buff per hero caught
    IsDebuff                         = function(self) return true                                                                                                           end,    
    IsHidden                         = function(self) return true                                                                                                           end,
  })
modifier_imba_enigma_gravity_well = class({
    --GetBonusVisionPercentage         = function(self) return self.visionreduction                                                                                           end,    
  })

modifier_imba_enigma_singularity = class({
   -- GetBonusVisionPercentage         = function(self) return self.visionreduction                                                                                           end,    
  })
-- Fiends Grip Debuff



function imba_enigma_malefice:OnSpellStart()
  local target,caster = findtarget(self)
  if target:TriggerSpellAbsorb(self) then return end
  local malefice_duration = getkvValues(self,"total_duration")  
  target:AddNewModifier(caster, self, "modifier_imba_enigma_malefice", {duration = malefice_duration})  
  --todo: cast sounds here
end

function imba_enigma_demonic_conversion:OnSpellStart()
  local target,caster = findtarget(self)
  target:EmitSound("Hero_Enigma.Demonic_Conversion")
  local duration,count = getkvValues(self,"duration","eidolon_count")
  target:Kill(ability,caster)  
  imba_enigma_create_eidolons(target,caster,self,count,duration)
end

function imba_enigma_create_eidolons(target,caster,abilitysource,number_of_eidolons,duration)
  local base_health,health_per_level,shard_percentage = getkvValues(abilitysource,"base_health","health_per_level","shard_percentage")
	local eidolon_name = "npc_imba_enigma_eidolon_"..math.min(abilitysource:GetLevel(),4)
	local caster_level = caster:GetLevel()
	local target_loc = target:GetAbsOrigin()  
  shard_percentage = shard_percentage / 100
  local shard_damage_min          = caster:GetBaseDamageMin() * shard_percentage
  local shard_damage_max          = caster:GetBaseDamageMax() * shard_percentage
  local shard_green_damage        = caster:GetBonusDamage(caster)

  local shard_attack_speed        = caster:GetAttackSpeed()  * shard_percentage
  local shard_movespeed           = caster:GetBaseMoveSpeed() * shard_percentage
  local shard_armor               = caster:GetPhysicalArmorValue() * shard_percentage
  local shard_health              = caster:GetMaxHealth() * shard_percentage
  local shard_health_regeneration = caster:GetHealthRegen() * shard_percentage
	for i=1, number_of_eidolons do
		local eidolon_loc = RotatePosition(target_loc, QAngle(0, (i - 1) * 360 / number_of_eidolons, 0), target_loc + caster:GetForwardVector() * 80) 		-- Spawn position
		local eidolon = CreateUnitByName(eidolon_name, eidolon_loc, true, caster, caster, caster:GetTeam())
		Timers:CreateTimer(0.01, function()		-- Prevent nearby units from getting stuck
			local units = FindUnitsInRadius(
        caster:GetTeamNumber(),
        eidolon_loc,
        nil,
        128,
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER,
        false)
			for _,unit in pairs(units) do
				FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
			end
		end) -- end timer
		eidolon:SetOwner(caster)
    eidolon:SetControllableByPlayer(caster:GetPlayerID(), true)
		eidolon:AddNewModifier(caster, abilitysource, "modifier_kill", {duration = duration}) 
		eidolon:AddNewModifier(caster, abilitysource, "modifier_eidolon_buffs", {attacks=0,shard_damage=shard_damage,shard_attack_speed = shard_attack_speed,shard_movespeed = shard_movespeed,shard_armor = shard_armor,shard_health = shard_health,shard_health_regeneration = shard_health_regeneration})
		SetCreatureHealth(eidolon, base_health + shard_health + caster_level * health_per_level, true)
    eidolon:SetBaseDamageMin(shard_damage_min + eidolon:GetBaseDamageMin())
    eidolon:SetBaseDamageMax(shard_damage_max + eidolon:GetBaseDamageMax())
    eidolon:SetBaseHealthRegen(shard_health_regeneration + eidolon:GetHealthRegen())
	end  
end

function imba_enigma_midnight_pulse:OnSpellStart() --todo: graphics, sounds.  damage and pull stuff should work without much work
  local gtarget,caster = findgroundtarget(self)
  local radius,duration,damage,pull,singularity_radius = getkvValues(self,"radius","duration","damage_per_tick","pull_distance","singularity_radius")  -- populate our vars
  radius = radius + singularity_radius * caster:GetModifierStackCount(modifier_imba_enigma_singularity, caster)
  caster.midnight_pulse_center = gtarget
  local midnight_pulse = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/bloodseeker_bloodritual_ring.vpcf", PATTACH_CUSTOMORIGIN, nil)
  -- probably use some form of emitsound here, maybe StartSoundEventFromPosition (?)
  Timers:CreateTimer(1, function()
		local elapsed_duration = elapsed_duration + 1
		if elapsed_duration >= duration then
			pulse_dummy:StopSound(sound_cast)                 -- he uses dummy to play sound, i'll try to find alternative for that
			ParticleManager:DestroyParticle(pulse_pfx, false)
			pulse_dummy:Destroy()
		else 		-- Else, keep going
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), gtarget, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for _,enemy in pairs(nearby_enemies) do
				if not enemy:IsMagicImmune() and not IsUninterruptableForcedMovement(enemy) then -- not magic immune, not affected by special moveskills
					local enemy_loc = enemy:GetAbsOrigin() -- enemy location...
					if (gtarget - enemy_loc):Length2D() <= pull_distance then -- if our target is too far, we need to pull them tighter
						FindClearSpaceForUnit(enemy, target, true) 
					else
						FindClearSpaceForUnit(enemy, enemy_loc + (target - enemy_loc):Normalized() * pull_distance, true)
					end
				end
				ApplyDamage({ 
            attacker = caster,
            victim = enemy,
            ability = ability,
            damage = (enemy:GetMaxHealth() * damage_per_tick / 100), -- get damage from maxhealth
            damage_type = DAMAGE_TYPE_PURE
                   })
			end
			return 1 -- return timer, 1s
		end
	end)
end

function imba_enigma_black_hole:OnSpellStart()
  local gtarget,caster = findgroundtarget(self)
  local radius,
  base_pull_distance,
  stack_pull_distance,
  base_pull_speed,
  stack_pull_speed,
  inner_pull_speed,
  pull_speed_scepter = getkvValues("radius","base_pull_distance","stack_pull_distance","base_pull_speed","stack_pull_speed","inner_pull_speed","pull_speed_scepter")
  
	local sound_cast = keys.sound_cast
	local sound_ti5 = keys.sound_ti5
	local particle_hole_ti5 = keys.particle_hole_ti5
	local particle_hole = keys.particle_hole
	local modifier_debuff = keys.modifier_debuff
	local modifier_debuff_ti5 = keys.modifier_debuff_ti5
	local modifier_singularity = keys.modifier_singularity
	local scepter = HasScepter(caster)

	-- Parameters

	-- Set up dummy and global center point variable
	caster.black_hole_dummy = CreateUnitByName("npc_dummy_unit", target, false, nil, nil, caster:GetTeamNumber())
	caster.black_hole_center = target

	-- Verify how many enemies were caught initially
	local enemies_caught = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)

	-- Grant singularity stacks to the caster due to heroes caught
	AddStacks(ability, caster, caster, modifier_singularity, #enemies_caught, true)

	-- Decide particles and sounds to use
	local blackhole_particle = particle_hole
	local blackhole_sound = sound_cast
	local blackhole_modifier = modifier_debuff
  
end

function imba_enigma_gravity_well:OnSpellStart()
  local gtarget,caster = findgroundtarget(self)
end


function modifier_imba_enigma_malefice:DeclareFunctions()
  return{}
end

function modifier_imba_enigma_malefice:OnCreated()
  if not IsServer() then return end
  self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_imba_enigma_malefice_stun",{duration=getkvValues(self:GetAbility(),"stun_duration")})
  self:StartIntervalThink(2)
end

function modifier_imba_enigma_malefice:OnIntervalThink()
  if not IsServer() then return end
  self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_imba_enigma_malefice_stun",{duration=getkvValues(self:GetAbility(),"stun_duration")})
end

function modifier_imba_enigma_malefice_stun:CheckState()
  return
      {
      [MODIFIER_STATE_STUNNED]              = true,
      }
end

function modifier_imba_enigma_malefice_stun:OnCreated()
  if not IsServer() then return end
  self:GetParent():StartGesture(ACT_DOTA_DISABLED)
  local damage = {
    victim      = self:GetParent(),
    attacker    = self:GetCaster(),
    damage      = getkvValues(self:GetAbility(),"tick_damage"),
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability     = self:GetAbility()
  }
  ApplyDamage(damage)
end

function modifier_imba_enigma_malefice_stun:OnDestroy()
  if not IsServer() then return end
  self:GetParent():FadeGesture(ACT_DOTA_DISABLED)
end

function modifier_imba_enigma_malefice_stun:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
end

function modifier_eidolon_buffs:DeclareFunctions()
  return
    {
    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_EVENT_ON_ATTACK,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_eidolon_buffs:OnCreated(var)
  local shard_percentage = getkvValues(self:GetAbility(),"shard_percentage") 
  shard_percentage = shard_percentage / 100
  self.attacks = var.attacks
  --self.shard_damage              = self:GetCaster():GetAttackDamage() * shard_percentage 
  self.shard_attack_speed        = self:GetCaster():GetAttackSpeed()  * shard_percentage
  self.shard_movespeed           = self:GetCaster():GetBaseMoveSpeed() * shard_percentage
  self.shard_armor               = self:GetCaster():GetPhysicalArmorValue() * shard_percentage
  --self.shard_health              = self:GetCaster():GetMaxHealth() * shard_percentage
  --self.shard_health_regeneration = self:GetCaster():GetHealthRegen() * shard_percentage
  --print(self:GetCaster():GetAttackDamage(),self:GetCaster():GetAttackSpeed(),self:GetCaster():GetBaseMoveSpeed(),self:GetCaster():GetPhysicalArmorValue(),self:GetCaster():GetMaxHealth())
end

function modifier_eidolon_buffs:GetModifierMoveSpeedBonus_Percentage()
  return self.shard_movespeed
end

function modifier_eidolon_buffs:GetModifierBaseAttack_BonusDamage()
  return 1
end

function modifier_eidolon_buffs:GetModifierAttackSpeedBonus_Constant()
  return self.shard_attack_speed
end

function modifier_eidolon_buffs:GetModifierPhysicalArmorBonus()
  return self.shard_armor
end

function modifier_eidolon_buffs:GetModifierConstantHealthRegen()
  return 1
end

function modifier_eidolon_buffs:GetModifierMoveSpeedBonus_Constant()
  return self.shard_movespeed  
end

function modifier_eidolon_buffs:OnAttack(vars)
  if not IsServer() then return end
  if vars.attacker == self:GetParent() then
  self.attacks = self.attacks + 1
  if self.attacks >= 7 then 
    self.attacks = 0
    self:GetParent():Heal(9999,self:GetParent():GetOwner())
    local duration = getkvValues(self:GetAbility(),"child_duration") + self:GetParent():FindModifierByName("modifier_kill"):GetDuration()
    imba_enigma_create_eidolons(self:GetParent(),self:GetParent():GetOwner(),self:GetAbility(),1,duration)
  end
  end
end
