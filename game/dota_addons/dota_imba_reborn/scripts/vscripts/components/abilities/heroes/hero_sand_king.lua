-- Author: Shush
-- Date: 13/04/2017

-------------------------------
--       BURROWSTRIKE        --
-------------------------------
imba_sandking_burrowstrike = class({})
LinkLuaModifier("modifier_imba_burrowstrike_stun", "components/abilities/heroes/hero_sand_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_burrowstrike_burrow", "components/abilities/heroes/hero_sand_king.lua", LUA_MODIFIER_MOTION_NONE)

function imba_sandking_burrowstrike:GetAbilityTextureName()
   return "sandking_burrowstrike"
end

function imba_sandking_burrowstrike:IsHiddenWhenStolen()
    return false
end

function imba_sandking_burrowstrike:IsNetherWardStealable()
    return false
end

function imba_sandking_burrowstrike:GetCastRange(location, target)
    local caster = self:GetCaster()
    local cast_range = self:GetSpecialValueFor("cast_range")

    -- #3 Talent: Burrowstrike cast range increase
    cast_range = cast_range + caster:FindTalentValue("special_bonus_imba_sand_king_3")
    return cast_range
end

function imba_sandking_burrowstrike:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()    
    local ability = self
    local target_point = self:GetCursorPosition()
    local cast_responses = "sandking_skg_ability_burrowstrike_0"..math.random(1, 9)
    local sound_cast = "Ability.SandKing_BurrowStrike"
    local particle_burrow = "particles/units/heroes/hero_sandking/sandking_burrowstrike.vpcf"        
    local modifier_burrow = "modifier_imba_burrowstrike_burrow"    

    -- Ability specials
    local burrow_speed = ability:GetSpecialValueFor("burrow_speed")
    local burrow_radius = ability:GetSpecialValueFor("burrow_radius")    
    local burrowstrike_time = ability:GetSpecialValueFor("burrowstrike_time")

    -- #1 Talent: Burrowstrike path radius increase
    burrow_radius = burrow_radius + caster:FindTalentValue("special_bonus_imba_sand_king_1")

    -- Play cast response
    EmitSoundOn(cast_responses, caster)

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)

    -- Disjoint projectiles
    ProjectileManager:ProjectileDodge(caster)

    -- Calculate distance for the projectile to move
    local distance = (caster:GetAbsOrigin() - target_point):Length2D()

    -- Adjust direction
    local direction = (target_point - caster:GetAbsOrigin()):Normalized()

    -- Add particle effect
    local particle_burrow_fx = ParticleManager:CreateParticle(particle_burrow, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(particle_burrow_fx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_burrow_fx, 1, target_point)    
 
    -- Projectile information
    local burrow_projectile = {Ability = ability,                               
                               vSpawnOrigin = caster:GetAbsOrigin(),
                               fDistance = distance,
                               fStartRadius = burrow_radius,
                               fEndRadius = burrow_radius,
                               Source = caster,
                               bHasFrontalCone = false,
                               bReplaceExisting = false,
                               iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,                          
                               iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,                           
                               bDeleteOnHit = false,
                               vVelocity = direction * burrow_speed * Vector(1, 1, 0),
                               bProvidesVision = false,                                
                             }
     
    -- Launch projectile                        
    ProjectileManager:CreateLinearProjectile(burrow_projectile)        

    -- Cache target_point in the ability
    self.target_point = target_point

    -- Set the caster's location at the end
    caster:SetAbsOrigin(target_point)    

    -- Wait a frame, then resolve positions
    Timers:CreateTimer(FrameTime(), function()
        ResolveNPCPositions(target_point, 128)
    end)

    -- Add burrowed status modifier
    caster:AddNewModifier(caster, ability, modifier_burrow, {duration = burrowstrike_time})    
end

function imba_sandking_burrowstrike:OnProjectileHit(target, location)
    -- If there was no target, do nothing
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
    local target_point = self.target_point    
    local modifier_stun = "modifier_imba_burrowstrike_stun"    
    local modifier_poison = "modifier_imba_caustic_finale_poison"

    -- Ability specials
    local knockback_duration = ability:GetSpecialValueFor("knockback_duration")
    local stun_duration = ability:GetSpecialValueFor("stun_duration")
    local damage = ability:GetSpecialValueFor("damage")
    local max_push_distance = ability:GetSpecialValueFor("max_push_distance")
    local knockup_height = ability:GetSpecialValueFor("knockup_height")
    local knockup_duration = ability:GetSpecialValueFor("knockup_duration")

    -- Caustic Finale
    local caustic_ability_name = "imba_sandking_caustic_finale"
    local caustic_ability
    local poison_duration
    if caster:HasAbility(caustic_ability_name) then
        caustic_ability = caster:FindAbilityByName(caustic_ability_name)
        poison_duration = caustic_ability:GetSpecialValueFor("poison_duration")
    end    

    -- If an enemy target has Linken's sphere ready, do nothing
    if caster:GetTeamNumber() ~= target:GetTeamNumber() then
        if target:TriggerSpellAbsorb(ability) then
            return nil
        end
    end

    -- Calculate target's distance from target point
    local push_distance = (target:GetAbsOrigin() - target_point):Length2D()

    -- If the distance is more than the maximum possible, use the maximum instead
    if push_distance > max_push_distance then
        push_distance = max_push_distance
    end

    -- Find a spot that would bring the enemy towards the caster
    local distance = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
    local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
    local bump_point = caster:GetAbsOrigin() + direction * (distance + 150)

    -- Knockback enemies up and towards the target point
    local knockbackProperties =
    {
         center_x = bump_point.x,
         center_y = bump_point.y,
         center_z = bump_point.z,
         duration = knockup_duration,
         knockback_duration = knockup_duration,
         knockback_distance = push_distance,
         knockback_height = knockup_height
    }
 
    target:RemoveModifierByName("modifier_knockback")
    target:AddNewModifier(target, nil, "modifier_knockback", knockbackProperties)

    -- Stun the target
    target:AddNewModifier(caster, ability, modifier_stun, {duration = stun_duration})

    -- Apply Caustic Finale to heroes, unless they already have it
    if target:IsHero() and poison_duration and poison_duration > 0 and not target:HasModifier(modifier_poison) then
        target:AddNewModifier(caster, caustic_ability, modifier_poison, {duration = poison_duration})
    end

    -- Deal damage
    local damageTable = {victim = target,
                         attacker = caster, 
                         damage = damage,
                         damage_type = DAMAGE_TYPE_MAGICAL,
                         ability = ability
                         }
        
    ApplyDamage(damageTable)  

    -- Wait until the target lands, then resolve positions
    Timers:CreateTimer(knockup_duration + FrameTime(), function()
        ResolveNPCPositions(target_point, 128)
    end)    
end



-- Burrowstrike stun modifier
modifier_imba_burrowstrike_stun = class({})

function modifier_imba_burrowstrike_stun:CheckState()
    local state = {[MODIFIER_STATE_STUNNED] = true}
    return state
end

function modifier_imba_burrowstrike_stun:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_burrowstrike_stun:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_burrowstrike_stun:IsHidden() return false end
function modifier_imba_burrowstrike_stun:IsPurgeException() return true end
function modifier_imba_burrowstrike_stun:IsStunDebuff() return true end


-- Burrowstrike burrow modifier
modifier_imba_burrowstrike_burrow = class({})

function modifier_imba_burrowstrike_burrow:OnCreated()
    if IsServer() then
        self.caster = self:GetCaster()

        -- Remove caster's model
        self.caster:AddNoDraw()
    end
end

function modifier_imba_burrowstrike_burrow:CheckState()
    local state = {[MODIFIER_STATE_STUNNED] = true,
                   [MODIFIER_STATE_OUT_OF_GAME] = true,
                   [MODIFIER_STATE_INVULNERABLE] = true,
                   [MODIFIER_STATE_NO_HEALTH_BAR] = true}
    return state
end

function modifier_imba_burrowstrike_burrow:OnDestroy()
    if IsServer() then
        -- Redraw caster's model
        self.caster:RemoveNoDraw()
    end
end

function modifier_imba_burrowstrike_burrow:IsHidden() return true end
function modifier_imba_burrowstrike_burrow:IsPurgable() return false end
function modifier_imba_burrowstrike_burrow:IsDebuff() return false end


-------------------------------
--        SAND STORM         --
-------------------------------
imba_sandking_sand_storm = class({})
LinkLuaModifier("modifier_imba_sandstorm", "components/abilities/heroes/hero_sand_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sandstorm_invis", "components/abilities/heroes/hero_sand_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sandstorm_aura", "components/abilities/heroes/hero_sand_king.lua", LUA_MODIFIER_MOTION_NONE)

function imba_sandking_sand_storm:GetAbilityTextureName()
   return "sandking_sand_storm"
end

function imba_sandking_sand_storm:IsHiddenWhenStolen()
    return false
end

function imba_sandking_sand_storm:GetIntrinsicModifierName()
    return "modifier_imba_sandstorm_aura"
end

function imba_sandking_sand_storm:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local sound_cast = "Ability.SandKing_SandStorm.start"
    local sound_loop = "Ability.SandKing_SandStorm.loop"
    local sound_darude = "Imba.SandKingSandStorm"
    local particle_sandstorm = "particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf"
    local modifier_sandstorm = "modifier_imba_sandstorm"    
    local modifier_invis = "modifier_imba_sandstorm_invis"

    -- Ability specials
    local radius = ability:GetSpecialValueFor("radius")

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)   

    -- Roll for Darude Sandstorm meme, if applicable, or use the usual loop sound
    if USE_MEME_SOUNDS and RollPercentage(MEME_SOUNDS_CHANCE) then
        EmitSoundOn(sound_darude, caster)
    else
        EmitSoundOn(sound_loop, caster)
    end

    -- Assign this cast a new cast
    self.new_cast = true

    -- If there are sandstorm particles from previous casts, remove them
    if self.particle_sandstorm_fx then
        ParticleManager:DestroyParticle(self.particle_sandstorm_fx, false)
        ParticleManager:ReleaseParticleIndex(self.particle_sandstorm_fx)    
    end

    -- Add sandstorm particles
    self.particle_sandstorm_fx = ParticleManager:CreateParticle(particle_sandstorm, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(self.particle_sandstorm_fx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(self.particle_sandstorm_fx, 1, Vector(radius, radius, 0))

    -- Get channel time
    local channel_time = self.BaseClass.GetChannelTime(self)    

    -- Add sandstorm modifiers
    caster:AddNewModifier(caster, ability, modifier_sandstorm, {})
    caster:AddNewModifier(caster, ability, modifier_invis, {})

    -- Nether Ward behavior
    if string.find(caster:GetUnitName(), "npc_imba_pugna_nether_ward") then        
        -- Start a timer to check if it has died
        Timers:CreateTimer(0.5, function()
            if not caster:IsAlive() then                
                ability:OnChannelFinish()
                return nil
            end

            -- Nether Ward still alive: check again
            return 0.5
        end)
    end
end

function imba_sandking_sand_storm:OnChannelFinish()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local sound_loop = "Ability.SandKing_SandStorm.loop"
    local sound_darude = "Imba.SandKingSandStorm"
    local modifier_sandstorm = "modifier_imba_sandstorm"    
    local modifier_invis = "modifier_imba_sandstorm_invis"

    -- Ability specials
    local invis_extend_time = ability:GetSpecialValueFor("invis_extend_time")

    -- Remove assignment of a new cast
    self.new_cast = false

    -- Stop sound effects
    StopSoundOn(sound_loop, caster)
    StopSoundOn(sound_darude, caster)    

    -- Remove modifiers
    caster:RemoveModifierByName(modifier_sandstorm)

    -- Extend the invisibility by a bit 
    Timers:CreateTimer(invis_extend_time, function()

        -- Only apply if it was not a new cast that interrupted the earlier one
        if not self.new_cast and self.particle_sandstorm_fx then
            -- Remove sandstorm particle
            ParticleManager:DestroyParticle(self.particle_sandstorm_fx, false)
            ParticleManager:ReleaseParticleIndex(self.particle_sandstorm_fx)    
            self.particle_sandstorm_fx = nil

            -- Remove invisibility
            caster:RemoveModifierByName(modifier_invis)
        end
    end)    
end



-- Sandstorm thinker modifier
modifier_imba_sandstorm = class({})

function modifier_imba_sandstorm:OnCreated()
    if IsServer() then
        -- Ability properties    
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()

        -- Ability specials
        self.damage = self.ability:GetSpecialValueFor("damage")
        self.radius = self.ability:GetSpecialValueFor("radius")
        self.pull_speed = self.ability:GetSpecialValueFor("pull_speed")
        self.pull_prevent_radius = self.ability:GetSpecialValueFor("pull_prevent_radius")    
        self.damage_interval = self.ability:GetSpecialValueFor("damage_interval")

        -- #2 Talent: Sandstorm damage per second increase
        self.damage = self.damage + self.caster:FindTalentValue("special_bonus_imba_sand_king_2")

        -- Calculate damage per think    
        self.damage_per_instance = self.damage * self.damage_interval

        -- Calculate pull per think
        self.pull_per_think = self.pull_speed * FrameTime()

        -- Set the first damage instance time and the time that elapsed
        self.time_elapsed = 0
        self.damage_instance_time = self.damage_interval

        -- Start thinking!
        self:StartIntervalThink(FrameTime())
    end
end

function modifier_imba_sandstorm:OnIntervalThink()
    if IsServer() then        

        -- Variable to decide if enemies should be damaged this instance
        local damage_enemies = false

        -- Move time forward!
        self.time_elapsed = self.time_elapsed + FrameTime()

        -- Check if it's time to damage an enemy
        if self.time_elapsed >= self.damage_instance_time then                
            damage_enemies = true

            -- Move to the next damage instance time
            self.damage_instance_time = self.damage_instance_time + self.damage_interval
        end

        -- Find all enemies in the radius
        local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
                                          self.caster:GetAbsOrigin(),
                                          nil,
                                          self.radius,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                          DOTA_UNIT_TARGET_FLAG_NONE,
                                          FIND_ANY_ORDER,
                                          false)

        for _,enemy in pairs(enemies) do
            if damage_enemies then

                -- Deal damage
                local damageTable = {victim = enemy,
                                     attacker = self.caster, 
                                     damage = self.damage_per_instance,
                                     damage_type = DAMAGE_TYPE_MAGICAL,
                                     ability = self.ability
                                     }
            
                ApplyDamage(damageTable)  
            end

            -- If farther than the minimum pull range, pull it
            local distance = (enemy:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D()
            if distance > self.pull_prevent_radius then
                -- Calculate the new location to pull that enemy to
                local direction = (enemy:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()
                local pull_location = self.caster:GetAbsOrigin() + direction * (distance - self.pull_per_think)

                -- Set the enemy at that location
                enemy:SetAbsOrigin(pull_location)

                -- Resolve NPC positions
                ResolveNPCPositions(enemy:GetAbsOrigin(), enemy:GetHullRadius())
            end
        end
    end
end

function modifier_imba_sandstorm:IsHidden() return true end
function modifier_imba_sandstorm:IsPurgable() return false end
function modifier_imba_sandstorm:IsDebuff() return false end

function modifier_imba_sandstorm:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}

    return decFuncs    
end

function modifier_imba_sandstorm:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_2
end



-- Sandstorm invisibility modifier
modifier_imba_sandstorm_invis = class({})

function modifier_imba_sandstorm_invis:IsHidden() return false end
function modifier_imba_sandstorm_invis:IsPurgable() return false end
function modifier_imba_sandstorm_invis:IsDebuff() return false end

function modifier_imba_sandstorm_invis:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_INVISIBILITY_LEVEL}

    return decFuncs
end

function modifier_imba_sandstorm_invis:GetModifierInvisibilityLevel()
    return 1
end

function modifier_imba_sandstorm_invis:CheckState()
    local state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                   [MODIFIER_STATE_INVISIBLE] = true}
    return state
end

function modifier_imba_sandstorm_invis:GetPriority()
    return MODIFIER_PRIORITY_NORMAL
end


-- Sandstorm aura modifier
modifier_imba_sandstorm_aura = class({})

function modifier_imba_sandstorm_aura:OnCreated() 
    if IsServer() then
        Timers:CreateTimer(function()
            self.caster = self:GetCaster()
            self.aura_talent = self.caster:HasTalent("special_bonus_imba_sand_king_7")

            -- #7 Talent: Sandstorm Aura
            -- Check if the caster has the talent: stop this timer start interval thinking
            if self.aura_talent then
                -- Ability properties    
                self.ability = self:GetAbility()
                self.particle_sandstorm = "particles/hero/sand_king/sandking_sandstorm_aura.vpcf"

                -- Ability specials
                self.damage = self.ability:GetSpecialValueFor("damage")
                self.radius = self.ability:GetSpecialValueFor("radius")
                self.pull_speed = self.ability:GetSpecialValueFor("pull_speed")
                self.pull_prevent_radius = self.ability:GetSpecialValueFor("pull_prevent_radius")
                self.damage_interval = self.ability:GetSpecialValueFor("damage_interval")

                -- Aura values    
                self.damage = self.damage * (1 - self.caster:FindTalentValue("special_bonus_imba_sand_king_7") * 0.01)
                self.radius = self.radius * (1 - self.caster:FindTalentValue("special_bonus_imba_sand_king_7") * 0.01)
                self.pull_speed = self.pull_speed * (1 - self.caster:FindTalentValue("special_bonus_imba_sand_king_7") * 0.01)

                -- Calculate damage per think    
                self.damage_per_instance = self.damage * self.damage_interval

                -- Calculate pull per think
                self.pull_per_think = self.pull_speed * FrameTime()

                -- Set the first damage instance time and the time that elapsed
                self.time_elapsed = 0
                self.damage_instance_time = self.damage_interval

                -- In case of refreshes, destroy the previous sandstorm effect
                if self.particle_sandstorm_fx then
                    ParticleManager:DestroyParticle(self.particle_sandstorm_fx, false)
                    ParticleManager:ReleaseParticleIndex(self.particle_sandstorm_fx)
                end

                -- Apply the sandstorm effect
                self.particle_sandstorm_fx = ParticleManager:CreateParticle(self.particle_sandstorm, PATTACH_ABSORIGIN_FOLLOW, self.caster)
                ParticleManager:SetParticleControl(self.particle_sandstorm_fx, 0, self.caster:GetAbsOrigin())
                ParticleManager:SetParticleControl(self.particle_sandstorm_fx, 1, Vector(self.radius, self.radius, 1))                

                -- Start thinking
                self:StartIntervalThink(FrameTime())
                return nil
            else
                -- Repeat and try again
                return 2
            end    
        end)
        
    end
end

function modifier_imba_sandstorm_aura:IsHidden() 
    if self.aura_talent then
        return false
    end

    return true
end

function modifier_imba_sandstorm_aura:IsPurgable() return false end
function modifier_imba_sandstorm_aura:IsDebuff() return false end

function modifier_imba_sandstorm_aura:OnIntervalThink()
    if IsServer() then

        -- Doesn't work off of your corpse
        if not self.caster:IsAlive() then return end

        -- Resolve NPC positions
        ResolveNPCPositions(self.caster:GetAbsOrigin(), self.radius)

        -- Variable to decide if enemies should be damaged this instance
        local damage_enemies = false

        -- Move time forward!
        self.time_elapsed = self.time_elapsed + FrameTime()

        -- Check if it's time to damage an enemy
            if self.time_elapsed >= self.damage_instance_time then                
                damage_enemies = true

                -- Move to the next damage instance time
                self.damage_instance_time = self.damage_instance_time + self.damage_interval
            end

        -- Find all enemies in the radius
        local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
                                          self.caster:GetAbsOrigin(),
                                          nil,
                                          self.radius,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                          DOTA_UNIT_TARGET_FLAG_NONE,
                                          FIND_ANY_ORDER,
                                          false)

        for _,enemy in pairs(enemies) do
            if damage_enemies then

                -- Deal damage
                local damageTable = {victim = enemy,
                                     attacker = self.caster, 
                                     damage = self.damage_per_instance,
                                     damage_type = DAMAGE_TYPE_MAGICAL,
                                     ability = self.ability
                                     }
            
                ApplyDamage(damageTable)  
            end

            -- If farther than the minimum pull range, pull it
            local distance = (enemy:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D()
            if distance > self.pull_prevent_radius then
                -- Calculate the new location to pull that enemy to
                local direction = (enemy:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()
                local pull_location = self.caster:GetAbsOrigin() + direction * (distance - self.pull_per_think)

                -- Set the enemy at that location
                enemy:SetAbsOrigin(pull_location)
            end
        end
    end
end

function modifier_imba_sandstorm_aura:OnRefresh()
    self:OnCreated()
end

function modifier_imba_sandstorm_aura:DeclareFunctions()
    local funcs ={
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_EVENT_ON_RESPAWN
    }
    return funcs
end

function modifier_imba_sandstorm_aura:OnDeath(params)
    if IsServer() then
        if params.unit == self.caster then
            -- Remove the particle from the corpse
            ParticleManager:DestroyParticle(self.particle_sandstorm_fx, false)
            ParticleManager:ReleaseParticleIndex(self.particle_sandstorm_fx)
        end
    end
end

function modifier_imba_sandstorm_aura:OnRespawn(params)
    if IsServer() then
        if params.unit == self.caster then
            -- Apply the sandstorm effect
            self.particle_sandstorm_fx = ParticleManager:CreateParticle(self.particle_sandstorm, PATTACH_ABSORIGIN_FOLLOW, self.caster)
            ParticleManager:SetParticleControl(self.particle_sandstorm_fx, 0, self.caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(self.particle_sandstorm_fx, 1, Vector(self.radius, self.radius, 1))
        end
    end
end

-------------------------------
--       CAUSTIC FINALE      --
-------------------------------

imba_sandking_caustic_finale = class({})
LinkLuaModifier("modifier_imba_caustic_finale_trigger", "components/abilities/heroes/hero_sand_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_caustic_finale_poison", "components/abilities/heroes/hero_sand_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_caustic_finale_debuff", "components/abilities/heroes/hero_sand_king.lua", LUA_MODIFIER_MOTION_NONE)

function imba_sandking_caustic_finale:GetAbilityTextureName()
    return "sandking_caustic_finale"
end

function imba_sandking_caustic_finale:GetIntrinsicModifierName()
    return "modifier_imba_caustic_finale_trigger"
end

-- Caustic Finale caster's trigger
modifier_imba_caustic_finale_trigger = class({})

function modifier_imba_caustic_finale_trigger:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.modifier_poison = "modifier_imba_caustic_finale_poison"

    -- Ability specials
    self.poison_duration = self.ability:GetSpecialValueFor("poison_duration")
end

function modifier_imba_caustic_finale_trigger:OnRefresh()
    self:OnCreated()
end

function modifier_imba_caustic_finale_trigger:IsHidden() return true end
function modifier_imba_caustic_finale_trigger:IsPurgable() return false end
function modifier_imba_caustic_finale_trigger:IsDebuff() return false end

function modifier_imba_caustic_finale_trigger:DeclareFunctions()
    local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_TAKEDAMAGE}

    return decFuncs
end

function modifier_imba_caustic_finale_trigger:OnAttackLanded(keys)
    if IsServer() then
        local attacker = keys.attacker
        local target = keys.target

        -- Only apply if the attack is the caster
        if attacker == self.caster then
            ApplyCausticFinale(self, attacker, target)
        end
    end
end

function modifier_imba_caustic_finale_trigger:OnTakeDamage(keys)
    if IsServer() then
        -- #8 Talent: Caustic Finale triggers from any damage source
        local attacker = keys.attacker
        local target = keys.unit
        local ability = keys.inflictor

        -- Only apply if the caster has the talent
        if self.caster:HasTalent("special_bonus_imba_sand_king_8") then
            -- Only apply if the caster is the one who dealt damage, but not with Caustic Finale
            if attacker == self.caster and not (ability == self.ability) then
                ApplyCausticFinale(self, attacker, target)
            end
        end
    end
end

function ApplyCausticFinale(modifier, attacker,  target)
    -- If the caster is broken, do nothing
    if modifier.caster:PassivesDisabled() then
        return nil
    end

    -- If the attacker is an illusion, do nothing
    if attacker:IsIllusion() then
        return nil
    end

    -- If the target already has the poison, do nothing
    if target:HasModifier(modifier.modifier_poison) then
        return nil
    end

    -- If the target is a building or a ward, do nothing
    if target:IsBuilding() or target:IsOther() then
        return nil
    end

    -- If the target is an ally, do nothing
    if target:GetTeamNumber() == modifier.caster:GetTeamNumber() then
        return nil
    end

    -- Apply poison on target
    target:AddNewModifier(modifier.caster, modifier.ability, modifier.modifier_poison, {duration = modifier.poison_duration})
end


-- Caustic Finale damage debuff
modifier_imba_caustic_finale_poison = class({})

function modifier_imba_caustic_finale_poison:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.sound_explode = "Ability.SandKing_CausticFinale"
    self.particle_explode = "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf"
    self.particle_debuff = "particles/units/heroes/hero_sandking/sandking_caustic_finale_debuff.vpcf"
    self.modifier_poison = "modifier_imba_caustic_finale_poison"
    self.modifier_slow = "modifier_imba_caustic_finale_debuff"

    -- Ability specials
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")

    if IsServer() then
        -- Add particle effects repeatedly
        Timers:CreateTimer(0.3, function()
            if not self:IsNull() then
                self.particle_debuff_fx = ParticleManager:CreateParticle(self.particle_debuff, PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                ParticleManager:SetParticleControlEnt(self.particle_debuff_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
                self:AddParticle(self.particle_debuff_fx, false, false, -1, false, false)

                return 0.3
            end
        end)
    end
end

function modifier_imba_caustic_finale_poison:IsHidden() return false end
function modifier_imba_caustic_finale_poison:IsPurgable() return true end
function modifier_imba_caustic_finale_poison:IsDebuff() return true end

function modifier_imba_caustic_finale_poison:OnDestroy()
    if IsServer() then
        -- Play explosion sound
        EmitSoundOn(self.sound_explode, self.parent)

        -- Add explosion particle
        self.particle_explode_fx = ParticleManager:CreateParticle(self.particle_explode, PATTACH_ABSORIGIN, self.parent)
        ParticleManager:SetParticleControl(self.particle_explode_fx, 0, self.parent:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(self.particle_explode_fx)

        -- Find all nearby enemies
        local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
        self.parent:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false)
        for _,enemy in pairs(enemies) do
            -- Deal damage
            local damageTable = {victim = enemy,
                attacker = self.caster,
                damage = self.damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self.ability
            }

            ApplyDamage(damageTable)

            -- If an enemy has Caustic Finale debuff, pop it! Kaboom!
            if enemy:HasModifier(self.modifier_poison) then
                local modifier_poison_handler = enemy:FindModifierByName(self.modifier_poison)
                if modifier_poison_handler then
                    modifier_poison_handler:Destroy()
                end
            end

            -- Apply slow
            enemy:AddNewModifier(self.caster, self.ability, self.modifier_slow, {duration = self.slow_duration})
        end
    end
end

-- Caustic Finale debuff
modifier_imba_caustic_finale_debuff = class({})

function modifier_imba_caustic_finale_debuff:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()

    -- Ability specials
    self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")

    -- #5 Talent: Caustic Finale slow increase
    self.ms_slow_pct = self.ms_slow_pct + self.caster:FindTalentValue("special_bonus_imba_sand_king_5")
end

function modifier_imba_caustic_finale_debuff:IsHidden() return false end
function modifier_imba_caustic_finale_debuff:IsPurgable() return true end
function modifier_imba_caustic_finale_debuff:IsDebuff() return true end

function modifier_imba_caustic_finale_debuff:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

    return decFuncs
end

function modifier_imba_caustic_finale_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.ms_slow_pct * (-1)
end





-------------------------------
--         EPICENTER         --
-------------------------------
imba_sandking_epicenter = class({})
LinkLuaModifier("modifier_imba_epicenter_pulse", "components/abilities/heroes/hero_sand_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_epicenter_slow", "components/abilities/heroes/hero_sand_king.lua", LUA_MODIFIER_MOTION_NONE)

function imba_sandking_epicenter:GetAbilityTextureName()
    return "sandking_epicenter"
end

function imba_sandking_epicenter:IsHiddenWhenStolen()
    return false
end

function imba_sandking_epicenter:GetChannelTime()
    local caster = self:GetCaster()
    local ability = self
    local scepter = caster:HasScepter()

    local channel_time = ability:GetSpecialValueFor("channel_time")
    local scepter_channel_time = ability:GetSpecialValueFor("scepter_channel_time")

    if scepter then
        return scepter_channel_time
    else
        return channel_time
    end
end

function imba_sandking_epicenter:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local sound_cast = "Ability.SandKing_Epicenter.spell"
    local particle_sandblast = "particles/units/heroes/hero_sandking/sandking_epicenter_tell.vpcf"
    local modifier_pulse = "modifier_imba_epicenter_pulse"

    -- Ability special
    local channel_time = ability:GetSpecialValueFor("channel_time")

    -- Play cast sound
    EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_cast, caster)

    -- Add sand strikes particle
    self.particle_sandblast_fx = ParticleManager:CreateParticle(particle_sandblast, PATTACH_CUSTOMORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(self.particle_sandblast_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_tail", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(self.particle_sandblast_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_tail", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(self.particle_sandblast_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_tail", caster:GetAbsOrigin(), true)

    -- Make Sand King perform the animation over and over
    Timers:CreateTimer(1.85, function()
        if caster:IsChanneling() then
            caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
            return FrameTime()
        else
            caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)
            return nil
        end
    end)

    -- Nether Ward handling
    if string.find(caster:GetUnitName(), "npc_imba_pugna_nether_ward") then
        -- Wait two seconds, then apply it like it had succeeded
        Timers:CreateTimer(channel_time, function()

            -- Stop the blast particle
            ParticleManager:DestroyParticle(self.particle_sandblast_fx, false)
            ParticleManager:ReleaseParticleIndex(self.particle_sandblast_fx)

            -- Start pulsing
            caster:AddNewModifier(caster, ability, modifier_pulse, {})
        end)
    end
end

function imba_sandking_epicenter:OnChannelFinish(interrupted)
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local modifier_pulse = "modifier_imba_epicenter_pulse"
    local failed_response = "sandking_skg_ability_failure_0"..math.random(1,6)

    -- Stop the blast particle
    ParticleManager:DestroyParticle(self.particle_sandblast_fx, false)
    ParticleManager:ReleaseParticleIndex(self.particle_sandblast_fx)

    -- If the caster was interrupted, complain and do nothing 
    if interrupted then
        EmitSoundOn(failed_response, caster)
        return nil
    end

    -- Channel is complete! Start pulsing!
    caster:AddNewModifier(caster, ability, modifier_pulse, {})
end


-- Epicenter modifier
modifier_imba_epicenter_pulse = class({})

function modifier_imba_epicenter_pulse:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.sound_epicenter = "Ability.SandKing_Epicenter"
        self.particle_epicenter = "particles/units/heroes/hero_sandking/sandking_epicenter.vpcf"
        self.scepter = self.caster:HasScepter()
        self.modifier_slow = "modifier_imba_epicenter_slow"

        -- Ability specials
        self.pulse_count = self.ability:GetSpecialValueFor("pulse_count")
        self.damage = self.ability:GetSpecialValueFor("damage")
        self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")
        self.base_radius = self.ability:GetSpecialValueFor("base_radius")
        self.pulse_radius_increase = self.ability:GetSpecialValueFor("pulse_radius_increase")
        self.max_pulse_radius = self.ability:GetSpecialValueFor("max_pulse_radius")
        self.pull_speed = self.ability:GetSpecialValueFor("pull_speed")
        self.scepter_pulses_count_pct = self.ability:GetSpecialValueFor("scepter_pulses_count_pct")
        self.epicenter_duration = self.ability:GetSpecialValueFor("epicenter_duration")

        -- Play epicenter sound
        EmitSoundOn(self.sound_epicenter, self.caster)

        -- Assign radius and pulse count
        self.radius = self.base_radius
        self.pulses = 0

        -- If the caster has scepter, increase pulse count
        if self.scepter then
            self.pulse_count = self.pulse_count * (1 + self.scepter_pulses_count_pct * 0.01)
        end

        -- #6 Talent: Additional Epicenter pulses
        self.pulse_count = self.pulse_count + self.caster:FindTalentValue("special_bonus_imba_sand_king_6")

        -- Decide the distribution of pulses over the duration of the epicenter
        self.pulse_interval = self.epicenter_duration / self.pulse_count

        -- Start thinking
        self:StartIntervalThink(self.pulse_interval)
    end
end

function modifier_imba_epicenter_pulse:OnIntervalThink()
    if IsServer() then
        -- Assign radiuses
        self.pull_radius = self.radius

        -- #4 Talent: Epicenter increase pull radius
        self.pull_radius = self.pull_radius + self.caster:FindTalentValue("special_bonus_imba_sand_king_4")

        -- Increment pulse count
        self.pulses = self.pulses + 1

        -- Add particle
        self.particle_epicenter_fx = ParticleManager:CreateParticle(self.particle_epicenter, PATTACH_ABSORIGIN_FOLLOW, self.caster)
        ParticleManager:SetParticleControl(self.particle_epicenter_fx, 0, self.caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(self.particle_epicenter_fx, 1, Vector(self.radius, self.radius, 1))
        ParticleManager:ReleaseParticleIndex(self.particle_epicenter_fx)

        -- Find all nearby enemies in the damage radius
        local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
        self.caster:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false)

        for _,enemy in pairs(enemies) do

            -- Deal damage
            local damageTable = {victim = enemy,
                attacker = self.caster,
                damage = self.damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self.ability
            }

            ApplyDamage(damageTable)

            -- Apply Epicenter slow
            enemy:AddNewModifier(self.caster, self.ability, self.modifier_slow, {duration = self.slow_duration})
        end

        -- Find all nearby enemies in the pull radius
        local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
        self.caster:GetAbsOrigin(),
        nil,
        self.pull_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false)

        for _,enemy in pairs(enemies) do

            -- Pull enemy towards Sand King
            -- Calculate distance and direction between SK and the enemy
            local distance = (enemy:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D()
            local direction = (enemy:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()

            -- If the target is not too close, calculate the pull point
            if (distance - self.pull_speed) > 50 then
                local pull_point = self.caster:GetAbsOrigin() + direction * (distance - self.pull_speed)

                -- Set the enemy at the pull point
                enemy:SetAbsOrigin(pull_point)

                -- Wait a frame, then resolve positions
                Timers:CreateTimer(FrameTime(), function()
                    ResolveNPCPositions(pull_point, 64)
                end)
            end
        end

        -- Increase radius
        self.radius = self.radius + self.pulse_radius_increase

        -- If the new radius is above the maximum, set as the maximum instead    
        if self.radius > self.max_pulse_radius then
            self.radius = self.max_pulse_radius
        end

        -- If there are no more pulses left, remove the modifier
        if self.pulses >= self.pulse_count then
            StopSoundOn(self.sound_epicenter, self.caster)
            self:Destroy()
        end
    end
end

function modifier_imba_epicenter_pulse:IsHidden() return true end
function modifier_imba_epicenter_pulse:IsPurgable() return false end
function modifier_imba_epicenter_pulse:IsDebuff() return false end

-- Epicenter Slow modifier
modifier_imba_epicenter_slow = class({})

function modifier_imba_epicenter_slow:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()

    -- Ability specials
    self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
    self.as_slow = self.ability:GetSpecialValueFor("as_slow")
end

function modifier_imba_epicenter_slow:IsHidden() return false end
function modifier_imba_epicenter_slow:IsPurgable() return true end
function modifier_imba_epicenter_slow:IsDebuff() return true end

function modifier_imba_epicenter_slow:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

    return decFuncs
end

function modifier_imba_epicenter_slow:GetModifierMoveSpeedBonus_Percentage()
    return self.ms_slow_pct * (-1)
end

function modifier_imba_epicenter_slow:GetModifierAttackSpeedBonus_Constant()
    return self.as_slow * (-1)
end