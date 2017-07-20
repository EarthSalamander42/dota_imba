-- Author: Shush
-- Date: 01/04/2017

CreateEmptyTalents("nyx_assassin")

-------------------------------------------------
--                  IMPALE                     --
-------------------------------------------------

imba_nyx_assassin_impale = class({})
LinkLuaModifier("modifier_imba_impale_suffering_aura", "hero/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_impale_suffering", "hero/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_impale_stun", "hero/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_nyx_assassin_impale:GetAbilityTextureName()
   return "nyx_assassin_impale"
end

function imba_nyx_assassin_impale:IsHiddenWhenStolen()
    return false
end

function imba_nyx_assassin_impale:OnUnStolen()
    local caster = self:GetCaster()
    local modifier_aura = "modifier_imba_impale_suffering_aura"

    if caster:HasModifier(modifier_aura) then
        caster:RemoveModifierByName(modifier_aura)
    end
end

function imba_nyx_assassin_impale:GetIntrinsicModifierName()
    return "modifier_imba_impale_suffering_aura"
end

function imba_nyx_assassin_impale:GetCastRange(location, target)    
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local modifier_burrowed = "modifier_nyx_assassin_burrow"
    local base_cast_range = self.BaseClass.GetCastRange(self, location, target)    

    -- Ability specials
    local burrow_length_increase = ability:GetSpecialValueFor("burrow_length_increase")        

    if caster:HasModifier(modifier_burrowed) then        
        return base_cast_range + burrow_length_increase
    end

    return base_cast_range
end

function imba_nyx_assassin_impale:GetCooldown(level)
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local modifier_burrowed = "modifier_nyx_assassin_burrow"
    local base_cooldown = self.BaseClass.GetCooldown(self, level)

    -- Ability specials
    local burrow_cd_reduction = ability:GetSpecialValueFor("burrow_cd_reduction")        

    if caster:HasModifier(modifier_burrowed) then
        return base_cooldown - burrow_cd_reduction
    else
        return base_cooldown
    end
end

function imba_nyx_assassin_impale:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local target_point = self:GetCursorPosition()
    local sound_cast = "Hero_NyxAssassin.Impale"
    local particle_projectile = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_impale.vpcf"
    local modifier_burrowed = "modifier_nyx_assassin_burrow"

    -- Ability specials
    local width = ability:GetSpecialValueFor("width")
    local duration = ability:GetSpecialValueFor("duration")
    local length = ability:GetSpecialValueFor("length") + GetCastRangeIncrease(caster)
    local speed = ability:GetSpecialValueFor("speed")
    local burrow_length_increase = ability:GetSpecialValueFor("burrow_length_increase")    

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)

    -- Increase travel distance if caster is burrowed
    if caster:HasModifier(modifier_burrowed) then
        length = length + burrow_length_increase
    end

    -- Adjust direction
    local direction = (target_point - caster:GetAbsOrigin()):Normalized()

    -- Projectile information
    local spikes_projectile = { Ability = ability,
                                EffectName = particle_projectile,
                                vSpawnOrigin = caster:GetAbsOrigin(),
                                fDistance = length,
                                fStartRadius = width,
                                fEndRadius = width,
                                Source = caster,
                                bHasFrontalCone = false,
                                bReplaceExisting = false,
                                iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,                          
                                iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,                           
                                bDeleteOnHit = false,
                                vVelocity = direction * speed * Vector(1, 1, 0),
                                bProvidesVision = false,                                
                            }
    
    -- Launch projectile                        
    ProjectileManager:CreateLinearProjectile(spikes_projectile)    
end

function imba_nyx_assassin_impale:OnProjectileHit(target, location)    
    -- If there were no targets, do nothing
    if not target then
        return nil
    end

    -- If the target is spell immune, do nothing
    if target:IsMagicImmune() then
        return nil
    end

    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local sound_impact = "Hero_NyxAssassin.Impale.Target"
    local sound_land = "Hero_NyxAssassin.Impale.TargetLand"
    local particle_impact = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_impale_hit.vpcf"
    local modifier_stun = "modifier_imba_impale_stun"
    local modifier_suffering = "modifier_imba_impale_suffering"

    -- Ability specials
    local duration = ability:GetSpecialValueFor("duration")
    local air_time = ability:GetSpecialValueFor("air_time")
    local air_height = ability:GetSpecialValueFor("air_height")
    local damage_repeat_pct = ability:GetSpecialValueFor("damage_repeat_pct")
    local damage = ability:GetSpecialValueFor("damage")    

    -- Play impact sound    
    EmitSoundOn(sound_impact, target)

    -- Add particle effect
    local particle_impact_fx = ParticleManager:CreateParticle(particle_impact, PATTACH_ABSORIGIN, target)
    ParticleManager:SetParticleControl(particle_impact_fx, 0, target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle_impact_fx)

    -- #1 Talent: Impale damage increase
    damage = damage + caster:FindTalentValue("special_bonus_imba_nyx_assassin_1")

    -- Stun target
    target:AddNewModifier(caster, ability, modifier_stun, {duration = duration})

    -- Hurl target in the air
    local knockbackProperties =
    {
        center_x = target.x,
        center_y = target.y,
        center_z = target.z,
        duration = air_time,
        knockback_duration = air_time,
        knockback_distance = 0,
        knockback_height = air_height
    }

    target:RemoveModifierByName("modifier_knockback")
    target:AddNewModifier(target, nil, "modifier_knockback", knockbackProperties)

    -- Wait for it to land
    Timers:CreateTimer(air_time, function()

        -- Play land sound
        EmitSoundOn(sound_land, target)

        -- Get the target's Suffering modifier
        local modifier_suffering_handler = target:FindModifierByName(modifier_suffering)
        
        if modifier_suffering_handler then
            -- Get the damage table
            local damage_table = modifier_suffering_handler.damage_table

            -- Calculate Suffering damage
            local suffering_damage = 0
            if damage_table then
                for _,damage in pairs(damage_table) do
                    suffering_damage = suffering_damage + damage
                end
            end

            -- Deal Suffering damage
            local damageTable = {victim = target,
                                 attacker = caster, 
                                 damage = suffering_damage,
                                 damage_type = DAMAGE_TYPE_MAGICAL,
                                 ability = ability
                                }
        
            ApplyDamage(damageTable)  

            -- Create alert
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, target, suffering_damage, nil)
        end

        -- Deal base damage        
        damageTable = {victim = target,
                      attacker = caster, 
                      damage = damage,
                      damage_type = DAMAGE_TYPE_MAGICAL,
                      ability = ability
                      }
    
        ApplyDamage(damageTable) 
    end)
end

 
-- Relive Suffering aura modifier
modifier_imba_impale_suffering_aura = class({})

function modifier_imba_impale_suffering_aura:GetAuraRadius()
    return 25000 --global
end

function modifier_imba_impale_suffering_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_imba_impale_suffering_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_impale_suffering_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_impale_suffering_aura:GetModifierAura()
    return "modifier_imba_impale_suffering"
end

function modifier_imba_impale_suffering_aura:IsAura()
    return true
end

function modifier_imba_impale_suffering_aura:IsAuraActiveOnDeath()
    return true
end

function modifier_imba_impale_suffering_aura:IsDebuff() return true end
function modifier_imba_impale_suffering_aura:IsHidden() return true end
function modifier_imba_impale_suffering_aura:IsPermanent() return true end
function modifier_imba_impale_suffering_aura:IsPurgable() return false end

-- Relive Suffering damage counter
modifier_imba_impale_suffering = class({})

function modifier_imba_impale_suffering:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()        

        -- Ability specials
        self.damage_duration = self.ability:GetSpecialValueFor("damage_duration")

        -- Tables
        self.damage_table = {}
        self.time_table = {}

        -- Talent 4 variable
        self.talent_4_applied = false

        -- Start interval think
        self:StartIntervalThink(0.2)
    end
end

function modifier_imba_impale_suffering:OnIntervalThink()
    if IsServer() then
        -- #4 Talent: Impale Relive Suffering duration increase
        if self.caster:HasTalent("special_bonus_imba_nyx_assassin_4") and not self.talent_4_applied then
            self.damage_duration = self.damage_duration + self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_4")
            self.talent_4_applied = true            
        end

        -- Index to remove from the table
        local relevant_index = 0

        -- If there are records that are too old, remove them
        if self.damage_table and self.time_table then
            local current_time = GameRules:GetDOTATime(true, true)
            

            for _,instance in pairs(self.time_table) do

                -- Check its time in comparison to the current game time
                if (instance + self.damage_duration) < current_time then
                    relevant_index = relevant_index + 1
                end
            end
        end

        -- Remove the firstmost damage and time instance from the table
        for i = 1, relevant_index do            
            table.remove(self.damage_table, 1)
            table.remove(self.time_table, 1)
        end        
    end
end

function modifier_imba_impale_suffering:DeclareFunctions()
    local decFuncs = {MODIFIER_EVENT_ON_TAKEDAMAGE}

    return decFuncs
end

function modifier_imba_impale_suffering:OnTakeDamage(keys)
    if IsServer() then
        local unit = keys.unit
        local damage = keys.damage

        -- Only apply if the unit taking damage is the parent of the modifier
        if self.parent == unit then

            -- Record the attack damage in the damage table            
            table.insert(self.damage_table, damage)         
            table.insert(self.time_table, GameRules:GetDOTATime(true, true))
        end
    end
end

function modifier_imba_impale_suffering:IsHidden() return true end
function modifier_imba_impale_suffering:IsPurgable() return false end
function modifier_imba_impale_suffering:IsDebuff() return true end
function modifier_imba_impale_suffering:IsPermanent() return true end


-- Impale stun modifier
modifier_imba_impale_stun = class({})

function modifier_imba_impale_stun:CheckState()
    local state = {[MODIFIER_STATE_STUNNED] = true}
    return state
end

function modifier_imba_impale_stun:IsHidden() return false end
function modifier_imba_impale_stun:IsPurgeException() return true end
function modifier_imba_impale_stun:IsStunDebuff() return true end



-------------------------------------------------
--                MANA BURN                    --
-------------------------------------------------

imba_nyx_assassin_mana_burn = class({})
LinkLuaModifier("modifier_imba_mana_burn_parasite", "hero/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mana_burn_parasite_charged", "hero/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_nyx_assassin_mana_burn:GetAbilityTextureName()
   return "nyx_assassin_mana_burn"
end

function imba_nyx_assassin_mana_burn:IsHiddenWhenStolen()
    return false
end

function imba_nyx_assassin_mana_burn:GetCastRange(location, target)
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local modifier_burrowed = "modifier_nyx_assassin_burrow"
    local base_cast_range = self.BaseClass.GetCastRange(self, location, target)

    -- Ability specials
    local burrowed_cast_range_increase = ability:GetSpecialValueFor("burrowed_cast_range_increase")        

    if caster:HasModifier(modifier_burrowed) then
        return base_cast_range + burrowed_cast_range_increase
    else
        return base_cast_range
    end
end

function imba_nyx_assassin_mana_burn:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorTarget()
    local sound_cast = "Hero_NyxAssassin.ManaBurn.Target"
    local particle_manaburn = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"
    local modifier_parasite = "modifier_imba_mana_burn_parasite"

    -- Ability specials
    local intelligence_mult = ability:GetSpecialValueFor("intelligence_mult")    
    local mana_burn_damage_pct = ability:GetSpecialValueFor("mana_burn_damage_pct")    
    local parasite_duration = ability:GetSpecialValueFor("parasite_duration")

    -- #5 Talent: Mana Burn Int multiplier increase
    intelligence_mult = intelligence_mult + caster:FindTalentValue("special_bonus_imba_nyx_assassin_5")

    -- Play cast sound
    EmitSoundOn(sound_cast, target)

    -- If target has Linken's Sphere off cooldown, do nothing
    if target:GetTeam() ~= caster:GetTeam() then
        if target:TriggerSpellAbsorb(ability) then
            return nil
        end
    end     

    -- Add particle effect
    local particle_manaburn_fx = ParticleManager:CreateParticle(particle_manaburn, PATTACH_CUSTOMORIGIN, target)
    ParticleManager:SetParticleControlEnt(particle_manaburn_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle_manaburn_fx)

    -- If target doesn't have a parasite yet, plant a new one in it
    if not target:HasModifier(modifier_parasite) then
        target:AddNewModifier(caster, ability, modifier_parasite, {duration = parasite_duration})
    end

    -- Get target's intelligence
    local target_int = target:GetIntellect()

    -- Calculate mana burn
    local manaburn = target_int * intelligence_mult
    local actual_mana_burned = 0

    -- Burn mana
    local target_mana = target:GetMana()

    if target_mana > manaburn then
        target:ReduceMana(manaburn)
        actual_mana_burned = manaburn
    else
        target:ReduceMana(target_mana)
        actual_mana_burned = target_mana
    end

    -- Calculate damage
    local damage = actual_mana_burned * mana_burn_damage_pct * 0.01

    -- Apply damage
    damageTable =     {victim = target,
                      attacker = caster, 
                      damage = damage,
                      damage_type = DAMAGE_TYPE_MAGICAL,
                      ability = ability
                      }
    
    ApplyDamage(damageTable)     
end

-- Mind Bug parasite leech modifier
modifier_imba_mana_burn_parasite = class({})

function modifier_imba_mana_burn_parasite:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()
        self.particle_flames = "particles/hero/nyx_assassin/mana_burn_parasite_flames.vpcf"
        self.modifier_charged = "modifier_imba_mana_burn_parasite_charged"

        -- Ability specials
        self.parasite_mana_leech = self.ability:GetSpecialValueFor("parasite_mana_leech")
        self.parasite_charge_threshold_pct = self.ability:GetSpecialValueFor("parasite_charge_threshold_pct")
        self.explosion_delay = self.ability:GetSpecialValueFor("explosion_delay")    
        self.leech_interval = self.ability:GetSpecialValueFor("leech_interval")

        -- #2 Talent: Scarab Parasite activation delay decrease
        self.explosion_delay = self.explosion_delay - self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_2")

        -- Adjust leech per second
        self.parasite_mana_leech = self.parasite_mana_leech * self.leech_interval

        -- Get target's current mana, set the threshold
        self.starting_target_mana = self.parent:GetMana()
        self.charge_threshold = self.starting_target_mana * self.parasite_charge_threshold_pct * 0.01
        self.last_known_target_mana = self.starting_target_mana        

        -- Start charging/count mana
        self.parasite_charged_mana = 0        

        -- Add mana disruption particle
        self.particle_flames_fx = ParticleManager:CreateParticle(self.particle_flames, PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt(self.particle_flames_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        self:AddParticle(self.particle_flames_fx, false, false, -1, false, false)

        -- Start thinking
        self:StartIntervalThink(self.leech_interval)
    end
end

function modifier_imba_mana_burn_parasite:OnIntervalThink()
    if IsServer() then
        -- Leech mana per interval
        local target_current_mana = self.parent:GetMana()
        local mana_leeched = 0 
        local mana_lost = 0                

        -- Check if there is enough mana to leech
        if target_current_mana >= self.parasite_mana_leech then
            self.parent:ReduceMana(self.parasite_mana_leech)
            mana_leeched = self.parasite_mana_leech

        else -- Get the mana that the target has
            self.parent:ReduceMana(target_current_mana)
            mana_leeched = target_current_mana
        end

        -- Check if the target has lost mana since the last check. If he has, add it to the charge count
        if target_current_mana < self.last_known_target_mana then
            mana_lost = self.last_known_target_mana - target_current_mana - mana_leeched
        end

        -- Update the charge meter
        self.parasite_charged_mana = self.parasite_charged_mana + mana_leeched + math.max(mana_lost, 0)        

        -- Update last known target mana
        self.last_known_target_mana = target_current_mana                

        -- Check if the threshold has been reached
        if self.parasite_charged_mana >= self.charge_threshold then

            -- Give the target the charged parasite modifier and the appropriate variables
            local modifier_charged_handler = self.parent:AddNewModifier(self.caster, self.ability, self.modifier_charged, {duration = self.explosion_delay})            
            if modifier_charged_handler then
                modifier_charged_handler.starting_target_mana = self.starting_target_mana
            end

            -- Remove self
            self:Destroy()
        end
    end
end

function modifier_imba_mana_burn_parasite:IsHidden() return false end
function modifier_imba_mana_burn_parasite:IsPurgable() return true end
function modifier_imba_mana_burn_parasite:IsDebuff() return true end
 

-- Mind Bug parasite charge (active) modifier
modifier_imba_mana_burn_parasite_charged = class({})

function modifier_imba_mana_burn_parasite_charged:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()
        self.sound_charge = "Imba.Nyx_ManaBurnCharge"
        self.sound_explosion = "Imba.Nyx_ManaBurnExplosion"
        self.particle_charged = "particles/hero/nyx_assassin/mana_burn_parasite_charged.vpcf"
        self.particle_explosion = "particles/hero/nyx_assassin/mana_burn_parasite_explosion.vpcf"        

        -- Ability specials
        self.parasite_mana_as_damage_pct = self.ability:GetSpecialValueFor("parasite_mana_as_damage_pct")
        self.leech_interval = self.ability:GetSpecialValueFor("leech_interval")        

        -- Play charge sound
        EmitSoundOn(self.sound_charge, self.parent)

        -- Add charged effect
        self.particle_charged_fx = ParticleManager:CreateParticle(self.particle_charged, PATTACH_CUSTOMORIGIN, self.parent)
        ParticleManager:SetParticleControl(self.particle_charged_fx, 0, self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControlEnt(self.particle_charged_fx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(self.particle_charged_fx, 2, self.parent:GetAbsOrigin())
        self:AddParticle(self.particle_charged_fx, false, false, -1, false, false)
    end    
end

function modifier_imba_mana_burn_parasite_charged:OnDestroy()
    if IsServer() then
        -- Get target's current mana
        local target_current_mana = self.parent:GetMana()        

        -- Play explosion sound
        EmitSoundOn(self.sound_explosion, self.parent)

        -- Add explosion effect
        self.particle_explosion_fx = ParticleManager:CreateParticle(self.particle_explosion, PATTACH_CUSTOMORIGIN, self.parent)
        ParticleManager:SetParticleControlEnt(self.particle_explosion_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(self.particle_explosion_fx, 1, Vector(1,0,0))
        ParticleManager:ReleaseParticleIndex(self.particle_explosion_fx)

        -- If the target now has more mana than what he had when parasite was planted, do nothing
        if target_current_mana >= self.starting_target_mana then
            return nil
        end

        -- Deal damage according to mana lost
        local damage = (self.starting_target_mana - target_current_mana) * self.parasite_mana_as_damage_pct * 0.01

        damageTable = {victim = self.parent,
                      attacker = self.caster, 
                      damage = damage,
                      damage_type = DAMAGE_TYPE_MAGICAL,
                      ability = self.ability
                      }
    
        ApplyDamage(damageTable) 
    end
end

function modifier_imba_mana_burn_parasite_charged:IsHidden() return false end
function modifier_imba_mana_burn_parasite_charged:IsPurgable() return true end
function modifier_imba_mana_burn_parasite_charged:IsDebuff() return true end

-------------------------------------------------
--              SPIKED CARAPACE                --
-------------------------------------------------

imba_nyx_assassin_spiked_carapace = class({})
LinkLuaModifier("modifier_imba_spiked_carapace", "hero/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spiked_carapace_stun", "hero/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_nyx_assassin_spiked_carapace:GetAbilityTextureName()
   return "nyx_assassin_spiked_carapace"
end

function imba_nyx_assassin_spiked_carapace:IsHiddenWhenStolen()
    return false
end

function imba_nyx_assassin_spiked_carapace:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local cast_response = {"nyx_assassin_nyx_spikedcarapace_03", "nyx_assassin_nyx_spikedcarapace_05"}
    local sound_cast = "Hero_NyxAssassin.SpikedCarapace"
    local modifier_spikes = "modifier_imba_spiked_carapace"

    -- Ability specials
    local reflect_duration = ability:GetSpecialValueFor("reflect_duration")
    local burrow_stun_range = ability:GetSpecialValueFor("burrow_stun_range")

    -- #7 Talent: Spiked Carapace duration increase
    reflect_duration = reflect_duration + caster:FindTalentValue("special_bonus_imba_nyx_assassin_7")

    -- Roll for cast response
    if RollPercentage(25) then
        EmitSoundOn(cast_response[math.random(1,2)], caster)
    end

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)

    -- Add spikes modifier
    caster:AddNewModifier(caster, ability, modifier_spikes, {duration = reflect_duration})
end

-- Spiked carapace modifier (owner)
modifier_imba_spiked_carapace = class({})

function modifier_imba_spiked_carapace:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.vendetta_ability = self.caster:FindAbilityByName("imba_nyx_assassin_vendetta")
        self.particle_spikes = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace.vpcf"
        self.modifier_stun = "modifier_imba_spiked_carapace_stun"
        self.modifier_vendetta = "modifier_imba_vendetta_charge"
        self.modifier_burrowed = "modifier_nyx_assassin_burrow"

        -- Ability specials
        self.stun_duration = self.ability:GetSpecialValueFor("stun_duration")
        self.damage_to_vendetta_pct = self.ability:GetSpecialValueFor("damage_to_vendetta_pct")
        self.burrowed_stun_range = self.ability:GetSpecialValueFor("burrow_stun_range")
        self.burrowed_vendetta_stacks = self.ability:GetSpecialValueFor("burrowed_vendetta_stacks")
        self.damage_reflection_pct = self.ability:GetSpecialValueFor("damage_reflection_pct")

        -- Add spikes particles
        self.particle_spikes_fx = ParticleManager:CreateParticle(self.particle_spikes, PATTACH_CUSTOMORIGIN_FOLLOW, self.caster)
        ParticleManager:SetParticleControlEnt(self.particle_spikes_fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
        self:AddParticle(self.particle_spikes_fx, false, false, -1, false, false)

        -- #3 Talent: Spiked Carapace damage reflection increase (percentage)
        self.damage_reflection_pct = self.damage_reflection_pct + self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_3")
        -- If caster is burrowed, stun all nearby enemies and grant stacks per enemy
        if self.caster:HasModifier(self.modifier_burrowed) then
            local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
            self.caster:GetAbsOrigin(),
            nil,
            self.burrowed_stun_range,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
            FIND_ANY_ORDER,
            false)

            for _,enemy in pairs(enemies) do
                -- Stun each enemy
                enemy:AddNewModifier(self.caster, self.ability, self.modifier_stun, {duration = self.stun_duration})

                -- Grant 30 Vendetta stacks
                if self.vendetta_ability and self.vendetta_ability:GetLevel() > 0 then
                    if not self.caster:HasModifier(self.modifier_vendetta) then
                        self.caster:AddNewModifier(self.caster, self.vendetta_ability, self.modifier_vendetta, {})
                    end

                    -- Only stores damage from heroes (including illusions)
                    if enemy:IsHero() then

                        -- Get modifier handler
                        local modifier_vendetta_handler = self.caster:FindModifierByName(self.modifier_vendetta)
                        if modifier_vendetta_handler then

                            -- Set Vendetta stacks
                            modifier_vendetta_handler:SetStackCount(modifier_vendetta_handler:GetStackCount() + self.burrowed_vendetta_stacks)
                        end
                    end
                end
            end
        end
    end
end

function modifier_imba_spiked_carapace:IsHidden() return false end
function modifier_imba_spiked_carapace:IsPurgable() return false end
function modifier_imba_spiked_carapace:IsDebuff() return false end

function modifier_imba_spiked_carapace:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE}

    return decFuncs
end

function modifier_imba_spiked_carapace:GetModifierIncomingDamage_Percentage()
    return -100
end

function modifier_imba_spiked_carapace:OnTakeDamage(keys)
    if IsServer() then
        local attacker = keys.attacker
        local unit = keys.unit
        local original_damage = keys.original_damage
        local damage_flags = keys.damage_flags

        -- Only apply on attacks against the caster
        if unit == self.caster then

            -- If it was a no reflection damage, do nothing
            if bit.band(damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
                return nil
            end

            -- If this has a HP loss flag, do nothing
            if bit.band(damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
                return nil
            end

            -- If the unit is a building, do nothing
            if attacker:IsBuilding() then
                return nil
            end

            -- If the attacking unit has Nyx's Carapace as well, do nothing
            if attacker:HasModifier("modifier_imba_spiked_carapace") then
                return nil
            end

            -- Calculate damage to reflect
            local damage = original_damage * self.damage_reflection_pct * 0.01

            -- Only apply if the caster has Vendetta as ability
            if self.vendetta_ability and self.vendetta_ability:GetLevel() > 0 then

                -- Convert damage to vendetta charges
                if not self.caster:HasModifier(self.modifier_vendetta) then
                    self.caster:AddNewModifier(self.caster, self.vendetta_ability, self.modifier_vendetta, {})
                end

                -- Only stores damage from heroes (including illusions)
                if attacker:IsHero() then
                    -- Get modifier handler
                    local modifier_vendetta_handler = self.caster:FindModifierByName(self.modifier_vendetta)
                    if modifier_vendetta_handler then
                        -- Calculate stacks
                        local stacks = damage * self.damage_to_vendetta_pct * 0.01

                        -- Set Vendetta stacks
                        modifier_vendetta_handler:SetStackCount(modifier_vendetta_handler:GetStackCount() + stacks)
                    end
                end
            end

            -- If the attacker is magic immune or invulnerable, do nothing
            if attacker:IsMagicImmune() or attacker:IsInvulnerable() then
                return nil
            end

            -- Damage the attacker
            local damageTable = {victim = attacker,
                attacker = self.caster,
                damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self.ability
            }

            ApplyDamage(damageTable)

            -- Stun it
            attacker:AddNewModifier(self.caster, self.ability, self.modifier_stun, {duration = self.stun_duration})
        end
    end

end

-- Spiked carapace stun modifier
modifier_imba_spiked_carapace_stun = class({})

function modifier_imba_spiked_carapace_stun:OnCreated()
    if IsServer() then
        self.parent = self:GetParent()
        self.sound_hit = "Hero_NyxAssassin.SpikedCarapace.Stun"
        self.particle_spike_hit = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace_hit.vpcf"

        -- Play hit sound
        EmitSoundOn(self.sound_hit, self.parent)

        -- Add spikes hit particle
        self.particle_spike_hit_fx = ParticleManager:CreateParticle(self.particle_spike_hit, PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
        ParticleManager:SetParticleControl(self.particle_spike_hit_fx, 0, self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControlEnt(self.particle_spike_hit_fx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(self.particle_spike_hit_fx, 2, Vector(1,0,0))
    end
end

function modifier_imba_spiked_carapace_stun:IsHidden() return false end
function modifier_imba_spiked_carapace_stun:IsPurgeException() return true end
function modifier_imba_spiked_carapace_stun:IsStunDebuff() return true end

function modifier_imba_spiked_carapace_stun:CheckState()
    local state = {[MODIFIER_STATE_STUNNED] = true}
    return state
end

function modifier_imba_spiked_carapace_stun:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_spiked_carapace_stun:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end




-------------------------------------------------
--                  VENDETTA                   --
-------------------------------------------------


imba_nyx_assassin_vendetta = class({})
LinkLuaModifier("modifier_imba_vendetta", "hero/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_vendetta_charge", "hero/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_nyx_assassin_vendetta:GetAbilityTextureName()
    return "nyx_assassin_vendetta"
end

function imba_nyx_assassin_vendetta:IsNetherWardStealable() return false end
function imba_nyx_assassin_vendetta:IsHiddenWhenStolen()
    return false
end

function imba_nyx_assassin_vendetta:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local burrow_ability = caster:FindAbilityByName("nyx_assassin_unburrow")
    local cast_response = {"nyx_assassin_nyx_vendetta_01", "nyx_assassin_nyx_vendetta_02", "nyx_assassin_nyx_vendetta_03", "nyx_assassin_nyx_vendetta_09"}
    local sound_cast = "Hero_NyxAssassin.Vendetta"
    local modifier_vendetta = "modifier_imba_vendetta"
    local modifier_burrowed = "modifier_nyx_assassin_burrow"

    -- Ability specials
    local duration = ability:GetSpecialValueFor("duration")

    -- Play cast response
    EmitSoundOn(cast_response[math.random(1,4)], caster)

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)

    -- If Nyx is burrowed, unburrow it
    if burrow_ability and caster:HasModifier(modifier_burrowed) then
        burrow_ability:CastAbility()
    end

    -- Apply Vendetta modifier
    caster:AddNewModifier(caster, ability, modifier_vendetta, {duration = duration})
end


-- Vendetta modifier
modifier_imba_vendetta = class({})

function modifier_imba_vendetta:OnCreated()
    -- Ability properties    
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.sound_attack = "Hero_NyxAssassin.Vendetta.Crit"
    self.particle_vendetta_start = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta_start.vpcf"
    self.particle_vendetta_attack = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta.vpcf"
    self.carapace_ability = "imba_nyx_assassin_spiked_carapace"
    self.modifier_charge = "modifier_imba_vendetta_charge"

    -- Ability specials
    self.movement_speed_pct = self.ability:GetSpecialValueFor("movement_speed_pct")
    self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")

    -- #6 Talent: Vendetta movement speed increase
    self.movement_speed_pct = self.movement_speed_pct + self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_6")

    -- Add Vendetta particle
    self.particle_vendetta_start_fx = ParticleManager:CreateParticle(self.particle_vendetta_start, PATTACH_ABSORIGIN_FOLLOW, self.caster)
    ParticleManager:SetParticleControl(self.particle_vendetta_start_fx, 0, self.caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(self.particle_vendetta_start_fx, 1, self.caster:GetAbsOrigin())
    self:AddParticle(self.particle_vendetta_start_fx, false, false, -1, false, false)
end

function modifier_imba_vendetta:IsHidden() return false end
function modifier_imba_vendetta:IsPurgable() return false end
function modifier_imba_vendetta:IsDebuff() return false end

function modifier_imba_vendetta:CheckState()
    local state = {[MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION]= true}
    return state
end

function modifier_imba_vendetta:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL}

    return decFuncs
end

function modifier_imba_vendetta:GetModifierInvisibilityLevel()
    return 1
end

function modifier_imba_vendetta:OnAbilityExecuted(keys)
    local ability = keys.ability
    local caster = keys.unit

    -- Only apply when the one casting abilities is the caster
    if caster == self.caster then

        -- If ability was Spiked Carapace, do nothing
        if ability:GetName() == self.carapace_ability then
            return nil
        end

        -- Remove invisibility
        self:Destroy()
    end
end

function modifier_imba_vendetta:GetModifierMoveSpeedBonus_Percentage()
    return self.movement_speed_pct
end

function modifier_imba_vendetta:OnAttackLanded(keys)
    if IsServer() then
        local attacker = keys.attacker
        local target = keys.target

        -- Only apply if the attacker is the caster
        if attacker == self.caster then

            -- If the target is not a unit or a hero, just remove invisibility
            if not target:IsHero() and not target:IsCreep() then
                self:Destroy()
                return nil
            end

            -- Play attack sound
            EmitSoundOn(self.sound_attack, self.caster)

            -- Add attack particle effect
            self.particle_vendetta_attack_fx = ParticleManager:CreateParticle(self.particle_vendetta_attack, PATTACH_CUSTOMORIGIN, self.caster)
            ParticleManager:SetParticleControl(self.particle_vendetta_attack_fx, 0, self.caster:GetAbsOrigin() )
            ParticleManager:SetParticleControl(self.particle_vendetta_attack_fx, 1, target:GetAbsOrigin() )

            -- Consume stacks of E for Vendetta, if present
            local stacks = 0
            if self.caster:HasModifier(self.modifier_charge) then
                local modifier_charged_handler = self.caster:FindModifierByName(self.modifier_charge)
                if modifier_charged_handler then
                    stacks = modifier_charged_handler:GetStackCount()
                    modifier_charged_handler:Destroy()
                end
            end

            -- Calculate damage
            local damage = self.bonus_damage + stacks

            -- Deal damage
            local damageTable = {victim = target,
                attacker = self.caster,
                damage = damage,
                damage_type = DAMAGE_TYPE_PHYSICAL,
                ability = self.ability
            }

            ApplyDamage(damageTable)

            -- Create alert
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, target, damage, nil)

            -- Remove modifier
            self:Destroy()
        end
    end
end


-- Vendetta charges modifier_charge
modifier_imba_vendetta_charge = class({})

function modifier_imba_vendetta_charge:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()

        -- Ability specials
        self.maximum_vendetta_stacks = self.ability:GetSpecialValueFor("maximum_vendetta_stacks")

        -- #8 Talent: Maximum Vendetta stored damage increase
        self.maximum_vendetta_stacks = self.maximum_vendetta_stacks + self.caster:FindTalentValue("special_bonus_imba_nyx_assassin_8")
    end
end

function modifier_imba_vendetta_charge:GetTexture()
    return "nyx_assassin_vendetta"
end

function modifier_imba_vendetta_charge:IsHidden() return false end
function modifier_imba_vendetta_charge:IsPurgable() return false end
function modifier_imba_vendetta_charge:IsDebuff() return false end

function modifier_imba_vendetta_charge:OnStackCountChanged()
    if IsServer() then
        -- Limit stack count                
        local stacks = self:GetStackCount()

        if stacks > self.maximum_vendetta_stacks then
            self:SetStackCount(self.maximum_vendetta_stacks)
        end
    end
end