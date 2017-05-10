-- Author: Shush
-- Date: 19/03/2017

CreateEmptyTalents("clinkz")

-----------------------------
--         STRAFE          --
-----------------------------

imba_clinkz_strafe = class({})
LinkLuaModifier("modifier_imba_strafe_aspd", "hero/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_strafe_mount", "hero/hero_clinkz", LUA_MODIFIER_MOTION_NONE)

function imba_clinkz_strafe:IsHiddenWhenStolen() return false end

function imba_clinkz_strafe:GetCooldown(level)
    if IsServer() then
        local caster = self:GetCaster()
        local duration = self:GetSpecialValueFor("duration")        
        local modifier_mount = "modifier_imba_strafe_mount"
        
        -- Assign correct cooldown. No need to update the UI
        if self.time_remaining ~= nil then  
            local time_remaining = self.time_remaining
            self.time_remaining = nil
            return self.BaseClass.GetCooldown(self, level) - (duration - math.max(time_remaining,0))            
        end
    end

    return self.BaseClass.GetCooldown(self, level)
end

function imba_clinkz_strafe:GetBehavior()
    local caster = self:GetCaster()
    local modifier_mount = "modifier_imba_strafe_mount"

    if caster:HasModifier(modifier_mount) then
        return DOTA_ABILITY_BEHAVIOR_NO_TARGET
    else
        return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
    end
end



function imba_clinkz_strafe:OnSpellStart()
    if IsServer() then        
            -- Ability properties
            local caster = self:GetCaster()
            local ability = self
            local target = self:GetCursorTarget()
            local sound_cast = "Hero_Clinkz.Strafe"    
            local modifier_aspd = "modifier_imba_strafe_aspd"
            local modifier_mount = "modifier_imba_strafe_mount"

            -- Ability specials
            local duration = ability:GetSpecialValueFor("duration")

            -----------------------
            --    NORMAL CAST    --
            -----------------------

        if not caster:HasModifier(modifier_mount) then

            -- Play cast sound
            EmitSoundOn(sound_cast, caster)

            -- Apply attack speed modifier    
            caster:AddNewModifier(caster, ability, modifier_aspd, {duration = duration})

            -- If used on ally, apply mount modifier
            if caster ~= target then            
                ability:EndCooldown()
                local modifier = caster:AddNewModifier(caster, ability, modifier_mount, {duration = duration})
                if modifier then
                    modifier.target = target
                end
            end

            -----------------------
            --     DISMOUNT      --
            -----------------------
        else            
            -- Assign the time remaining to the ability and remove modifier
            local modifier_mount_handler = caster:FindModifierByName(modifier_mount)            
            ability.time_remaining = modifier_mount_handler:GetRemainingTime()
            caster:RemoveModifierByName(modifier_mount)   

            -- Renew cooldown so it would use the new time remaining variable
            ability:EndCooldown()
            ability:UseResources(false, false, true)         
        end
    end
end


-- Attack speed modifier
modifier_imba_strafe_aspd = class({})

function modifier_imba_strafe_aspd:OnCreated()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.modifier_mount = "modifier_imba_strafe_mount"

    self.as_bonus = self.ability:GetSpecialValueFor("as_bonus")
    self.bonus_attack_range = self.ability:GetSpecialValueFor("bonus_attack_range")

    -- #1 Talent: Strafe Bonus attack range when mounted
    self.bonus_attack_range = self.bonus_attack_range + self.caster:FindTalentValue("special_bonus_imba_clinkz_1")

    -- #5 Talent: Strafe bonus attack speed
    self.as_bonus = self.as_bonus + self.caster:FindTalentValue("special_bonus_imba_clinkz_5")
end

function modifier_imba_strafe_aspd:IsHidden() return false end
function modifier_imba_strafe_aspd:IsPurgable() return true end
function modifier_imba_strafe_aspd:IsDebuff() return false end

function modifier_imba_strafe_aspd:GetEffectName()
    return "particles/units/heroes/hero_clinkz/clinkz_strafe_fire.vpcf"
end

function modifier_imba_strafe_aspd:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_strafe_aspd:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                      MODIFIER_PROPERTY_ATTACK_RANGE_BONUS}

    return decFuncs
end

function modifier_imba_strafe_aspd:GetModifierAttackSpeedBonus_Constant()
    return self.as_bonus 
end

function modifier_imba_strafe_aspd:GetModifierAttackRangeBonus()
    if self.caster:HasModifier(self.modifier_mount) then
        return self.bonus_attack_range
    end

    return nil
end


-- Mount modifier
modifier_imba_strafe_mount = class({})

function modifier_imba_strafe_mount:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()        

        -- Ability specials
        self.duration = self.ability:GetSpecialValueFor("duration")

        -- Wait a game tick so we can have the target assigned to this modifier
        Timers:CreateTimer(FrameTime(), function()           
            -- Get mount location
            local direction = self.target:GetForwardVector()
            local collision_radius = self.caster:GetPaddedCollisionRadius() + self.target:GetPaddedCollisionRadius() + 80
            local mount_point = self.target:GetAbsOrigin() + direction * (-1) * collision_radius

            -- Set Clinkz' location to it        
            self.caster:SetAbsOrigin(mount_point)            

            -- Start thinking
            self:StartIntervalThink(FrameTime())
        end)        
    end
end

function modifier_imba_strafe_mount:IsHidden() return false end
function modifier_imba_strafe_mount:IsPurgable() return true end
function modifier_imba_strafe_mount:IsDebuff() return false end

function modifier_imba_strafe_mount:CheckState()
    local state = {[MODIFIER_STATE_ROOTED] = true,
                   [MODIFIER_STATE_NO_UNIT_COLLISION] = true}

    return state
end

function modifier_imba_strafe_mount:OnIntervalThink()
    if IsServer() then
        -- Get new point        
        local current_loc = self.caster:GetAbsOrigin()

        local direction = self.target:GetForwardVector()
        local collision_radius = self.caster:GetPaddedCollisionRadius() + self.target:GetPaddedCollisionRadius() + 80
        local mount_point = self.target:GetAbsOrigin() + direction * (-1) * collision_radius

        local distance = (mount_point - current_loc):Length2D()

        -- If target died, kill modifier
        if not self.target:IsAlive() then
            self:Destroy()
        end

        if distance > 300 then
            -- Set Clinkz' location to it        
            self.caster:SetAbsOrigin(mount_point) 
        else
            -- Move Clinkz toward it
            direction = (mount_point - current_loc):Normalized()            
            local target_movespeed = self.target:GetMoveSpeedModifier(self.target:GetBaseMoveSpeed())

            local new_point = current_loc + direction * ((target_movespeed * 1.25) * FrameTime())

            if distance > 25 then                
                self.caster:SetAbsOrigin(new_point)
            end
        end
    end
end

function modifier_imba_strafe_mount:OnRemoved()
    if IsServer() then
        -- Start cooldown, reduce it by the duration of the skill
        if self.ability:IsCooldownReady() then
            self.ability.time_remaining = self:GetRemainingTime()
            self.ability:UseResources(false, false, true)
        end
    end
end




-----------------------------
--     SEARING ARROWS      --
-----------------------------

imba_clinkz_searing_arrows = class({})
LinkLuaModifier("modifier_imba_searing_arrows_passive", "hero/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_searing_arrows_active", "hero/hero_clinkz", LUA_MODIFIER_MOTION_NONE)

function imba_clinkz_searing_arrows:GetIntrinsicModifierName()    
    return "modifier_imba_searing_arrows_passive"
end

function imba_clinkz_searing_arrows:GetCastRange(location, target)
     local caster = self:GetCaster()
     return caster:GetAttackRange()
end 

function imba_clinkz_searing_arrows:IsHiddenWhenStolen()
    return false
end

function imba_clinkz_searing_arrows:OnUnStolen()
    -- Rubick interaction
    local caster = self:GetCaster()
    if caster:HasModifier("modifier_imba_searing_arrows_passive") then
        caster:RemoveModifierByName("modifier_imba_searing_arrows_passive")
    end
end

function imba_clinkz_searing_arrows:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorTarget()
    local particle_projectile = "particles/hero/clinkz/searing_flames_active/clinkz_searing_arrow.vpcf"
    local sound_cast = "Hero_Clinkz.SearingArrows"

    -- Ability specials
    local projectile_speed = ability:GetSpecialValueFor("projectile_speed")
    local vision_radius = ability:GetSpecialValueFor("vision_radius")

    -- Play attack sound
    EmitSoundOn(sound_cast, caster)    

    -- Launch projectile on target
    local searing_arrow_active
    searing_arrow_active = {
        Target = target,
        Source = caster,
        Ability = ability,
        EffectName = particle_projectile,
        iMoveSpeed = projectile_speed,
        bDodgeable = true, 
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        bProvidesVision = true,        
        iVisionRadius = vision_radius,
        iVisionTeamNumber = caster:GetTeamNumber()      
        }

    ProjectileManager:CreateTrackingProjectile(searing_arrow_active)

    -- #4 Talent: Searing Arrow active hits in an AoE
    if caster:HasTalent("special_bonus_imba_clinkz_4") then
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                          target:GetAbsOrigin(),
                                          nil,
                                          caster:FindTalentValue("special_bonus_imba_clinkz_4"),
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                          DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
                                          FIND_ANY_ORDER,
                                          false)

        -- Fire arrows at anyone that is not the main target
        for _,enemy in pairs(enemies) do 
            if enemy ~= target then
                -- Launch projectile on enemy
                local searing_arrow_active_seconday
                searing_arrow_active_seconday = {
                    Target = enemy,
                    Source = caster,
                    Ability = ability,
                    EffectName = particle_projectile,
                    iMoveSpeed = projectile_speed,
                    bDodgeable = true, 
                    bVisibleToEnemies = true,
                    bReplaceExisting = false,
                    bProvidesVision = true,        
                    iVisionRadius = vision_radius,
                    iVisionTeamNumber = caster:GetTeamNumber()      
                    }

                ProjectileManager:CreateTrackingProjectile(searing_arrow_active_seconday)
            end
        end
    end
end

function imba_clinkz_searing_arrows:OnProjectileHit(target, location)
    if IsServer() then
        -- Ability properties
        local caster = self:GetCaster()
        local ability = self
        local sound_hit = "Hero_Clinkz.SearingArrows.Impact"
        local modifier_active = "modifier_imba_searing_arrows_active"

        -- Ability specials
        local active_duration = ability:GetSpecialValueFor("active_duration")

        -- If target has Linken Sphere, block effect entirely
        if target:GetTeam() ~= caster:GetTeam() then
            if target:TriggerSpellAbsorb(ability) then
                return nil
            end
        end

        -- Play hit sound
        EmitSoundOn(sound_hit, target)

        -- Perform an attack on the target
        caster:PerformAttack(target, false, true, true, false, false, false, true)

        -- Apply the active debuff
        target:AddNewModifier(caster, ability, modifier_active, {duration = active_duration})
    end
end

function imba_clinkz_searing_arrows:OnUpgrade()
    if IsServer() then
        local caster = self:GetCaster()    
        caster:RemoveModifierByName("modifier_imba_searing_arrows_passive")    
        caster:AddNewModifier(caster, self, "modifier_imba_searing_arrows_passive", {})
    end
end

-- Passive Clinkz Searing Arrows modifier
modifier_imba_searing_arrows_passive = class({})

function modifier_imba_searing_arrows_passive:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()

    -- Ability specials
    self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
end

function modifier_imba_searing_arrows_passive:IsHidden() return true end
function modifier_imba_searing_arrows_passive:IsPurgable() return false end
function modifier_imba_searing_arrows_passive:IsDebuff() return false end

function modifier_imba_searing_arrows_passive:DeclareFunctions()
    local decFuncs = {MODIFIER_EVENT_ON_ATTACK_START,
                      MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE}

    return decFuncs
end

function modifier_imba_searing_arrows_passive:OnAttackStart(keys)
    if IsServer() then
        local attacker = keys.attacker
        local target = keys.target

        -- If the ability is stolen, do nothing
        if self.ability:IsStolen() then
            return nil
        end

        -- If the target is not a valid Searing Arrow target, do nothing
        if not target:IsHero() or target:IsBuilding() or target:IsCreep() then
            SetArrowAttackProjectile(self.caster, false)
            return nil
        end          

        -- Only apply to the caster's attacks on enemy team
        if self.caster == attacker and self.caster:GetTeamNumber() ~= target:GetTeamNumber() then
            -- Change to correct projectile
            if self.caster:PassivesDisabled() then
                SetArrowAttackProjectile(self.caster, false)
            else
                SetArrowAttackProjectile(self.caster, true)
            end        
        end        
    end
end

function modifier_imba_searing_arrows_passive:GetModifierBaseAttack_BonusDamage()
    -- Ignore if it is a stolen ability
    if self.ability:IsStolen() then
        return nil
    end

    if not self.caster:PassivesDisabled() then
        return self.bonus_damage + self.caster:FindTalentValue("special_bonus_imba_clinkz_3")
    end

    return nil
end


function SetArrowAttackProjectile(caster, searing_arrows)    
    -- modifiers
    local skadi_modifier = "modifier_item_imba_skadi_unique"
    local deso_modifier = "modifier_item_imba_desolator_unique" 
    local morbid_modifier = "modifier_imba_morbid_mask"
    local mom_modifier = "modifier_item_mask_of_madness"
    local satanic_modifier = "modifier_item_satanic"
    local vladimir_modifier = "modifier_item_imba_vladmir"
    local vladimir_2_modifier = "modifier_item_imba_vladmir_2"

    -- normal projectiles
    local skadi_projectile = "particles/items2_fx/skadi_projectile.vpcf"
    local deso_projectile = "particles/items_fx/desolator_projectile.vpcf"  
    local deso_skadi_projectile = "particles/item/desolator/desolator_skadi_projectile_2.vpcf"  
    local lifesteal_projectile = "particles/item/lifesteal_mask/lifesteal_particle.vpcf"

    -- searing arrow projectiles
    local basic_arrow = "particles/units/heroes/hero_clinkz/clinkz_base_attack.vpcf"
    local searing_arrow = "particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf"
    
    local searing_lifesteal_projectile = "particles/hero/clinkz/searing_lifesteal/searing_lifesteal_arrow.vpcf"
    local searing_skadi_projectile = "particles/hero/clinkz/searing_skadi/searing_skadi_arrow.vpcf"
    local searing_deso_projectile = "particles/hero/clinkz/searing_desolator/searing_desolator_arrow.vpcf"  
    local searing_deso_skadi_projectile = "particles/hero/clinkz/searing_skadi_desolator/searing_skadi_desolator_arrow.vpcf"
    local searing_lifesteal_skadi_projectile = "particles/hero/clinkz/searing_skadi_lifesteal/searing_skadi_steal_arrow.vpcf"
    local searing_lifesteal_deso_projectile = "particles/hero/clinkz/searing_deso_lifesteal/searing_deso_lifesteal.vpcf"
    local searing_lifesteal_deso_skadi_projectile = "particles/hero/clinkz/searing_skadi_deso_steal/searing_skadi_deso_steal_arrow.vpcf"

    -- Set variables
    local has_lifesteal
    local has_skadi
    local has_desolator

    -- Assign variables
    -- Lifesteal
    if caster:HasModifier(morbid_modifier) or caster:HasModifier(mom_modifier) or caster:HasModifier(satanic_modifier) or caster:HasModifier(vladimir_modifier) or caster:HasModifier(vladimir_2_modifier) then
        has_lifesteal = true
    end

    -- Skadi
    if caster:HasModifier(skadi_modifier) then
        has_skadi = true
    end

    -- Desolator
    if caster:HasModifier(deso_modifier) then
        has_desolator = true
    end

    -- ASSIGN PARTICLES
    -- searing attack
    if searing_arrows then
        -- Desolator + lifesteal + searing + skadi
        if has_desolator and has_skadi and has_lifesteal then
            caster:SetRangedProjectileName(searing_lifesteal_deso_skadi_projectile)
            return

        -- Desolator + lifesteal + searing
        elseif has_desolator and has_lifesteal then
            caster:SetRangedProjectileName(searing_lifesteal_deso_projectile)
            return 

        -- Desolator + skadi + searing 
        elseif has_skadi and has_desolator then
            caster:SetRangedProjectileName(searing_deso_skadi_projectile)
            return

        -- Lifesteal + skadi + searing 
        elseif has_lifesteal and has_skadi then
            caster:SetRangedProjectileName(searing_lifesteal_skadi_projectile)
            return

        -- skadi + searing
        elseif has_skadi then
            caster:SetRangedProjectileName(searing_skadi_projectile)
            return

        -- lifesteal + searing
        elseif has_lifesteal then
            caster:SetRangedProjectileName(searing_lifesteal_projectile)
            return

        -- Desolator + searing            
        elseif has_desolator then
            caster:SetRangedProjectileName(searing_deso_projectile)
            return

        -- searing
        else
            caster:SetRangedProjectileName(searing_arrow)
            return
        end
    
    else -- Non searing attack
        -- Skadi + desolator
        if has_skadi and has_desolator then
            caster:SetRangedProjectileName(deso_skadi_projectile)
            return

        -- Skadi
        elseif has_skadi then
            caster:SetRangedProjectileName(skadi_projectile)
            return

        -- Desolator
        elseif has_desolator then
            caster:SetRangedProjectileName(deso_projectile)
            return 

        -- Lifesteal
        elseif has_lifesteal then
            caster:SetRangedProjectileName(lifesteal_projectile)
            return 

        -- Basic arrow
        else
            caster:SetRangedProjectileName(basic_arrow)
            return 
        end
    end
end


-- Active burning Searing Arrow modifier
modifier_imba_searing_arrows_active = class({})

function modifier_imba_searing_arrows_active:IsHidden() return false end
function modifier_imba_searing_arrows_active:IsPurgable() return true end
function modifier_imba_searing_arrows_active:IsDebuff() return true end

function modifier_imba_searing_arrows_active:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()
        self.particle_flame = "particles/hero/clinkz/searing_flames_active/burn_effect.vpcf"

        -- Ability specials
        self.vision_radius = self.ability:GetSpecialValueFor("vision_radius")

        -- Add and attach flaming particle
        self.particle_flame_fx = ParticleManager:CreateParticle(self.particle_flame, PATTACH_POINT_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt(self.particle_flame_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)

        self:AddParticle(self.particle_flame_fx, false, false, -1, false, false)        

        -- Start revealing
        self:StartIntervalThink(FrameTime())
    end
end

function modifier_imba_searing_arrows_active:OnIntervalThink()
    AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), self.vision_radius, FrameTime(), false)
end


-----------------------------
--     SKELETON WALK       --
-----------------------------

imba_clinkz_skeleton_walk = class({})
LinkLuaModifier("modifier_imba_skeleton_walk_invis", "hero/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_skeleton_walk_spook", "hero/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_skeleton_walk_talent_ms", "hero/hero_clinkz", LUA_MODIFIER_MOTION_NONE)

function imba_clinkz_skeleton_walk:IsHiddenWhenStolen()
    return false
end

function imba_clinkz_skeleton_walk:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local particle_invis = "particles/units/heroes/hero_clinkz/clinkz_windwalk.vpcf"
    local sound_cast = "Hero_Clinkz.WindWalk"
    local modifier_invis = "modifier_imba_skeleton_walk_invis"
    local scepter = caster:HasScepter()
    local modifier_mount = "modifier_imba_strafe_mount"

    -- Ability specials
    local duration = ability:GetSpecialValueFor("duration")

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)

    -- Add particle effect
    local particle_invis_fx = ParticleManager:CreateParticle(particle_invis, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle_invis_fx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_invis_fx, 1, caster:GetAbsOrigin())

    -- Apply invisibilty modifier on self
    caster:AddNewModifier(caster, ability, modifier_invis, {duration = duration})

    -- Scepter skeleton walk on mounted 
    if scepter then        
        if caster:HasModifier(modifier_mount) then
            local modifier_mount_handler = caster:FindModifierByName(modifier_mount)
            if modifier_mount_handler then
                local mounted_ally = modifier_mount_handler.target
                mounted_ally:AddNewModifier(caster, ability, modifier_invis, {duration = modifier_mount_handler:GetRemainingTime()})
            end
        end

    end
end

-- Invisibility modifier
modifier_imba_skeleton_walk_invis = class({})

function modifier_imba_skeleton_walk_invis:IsHidden() return false end
function modifier_imba_skeleton_walk_invis:IsPurgable() return false end
function modifier_imba_skeleton_walk_invis:IsDebuff() return false end

function modifier_imba_skeleton_walk_invis:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.sound_cast = "Hero_Clinkz.WindWalk"
    self.modifier_spook = "modifier_imba_skeleton_walk_spook"        
    self.modifier_talent_ms = "modifier_imba_skeleton_walk_talent_ms"
    self.modifier_mount = "modifier_imba_strafe_mount"   

    -- Ability specials
    self.ms_bonus_pct = self.ability:GetSpecialValueFor("ms_bonus_pct")
    self.spook_radius = self.ability:GetSpecialValueFor("spook_radius")
    self.base_spook_duration = self.ability:GetSpecialValueFor("base_spook_duration")
    self.spook_distance_inc = self.ability:GetSpecialValueFor("spook_distance_inc")
    self.spook_added_duration = self.ability:GetSpecialValueFor("spook_added_duration")

    -- #2 Talent: Spook search radius increase
    self.spook_radius = self.spook_radius + self.caster:FindTalentValue("special_bonus_imba_clinkz_2")

    if IsServer() then
        self:StartIntervalThink(0.1)
    end
end

function modifier_imba_skeleton_walk_invis:OnIntervalThink()
    if IsServer() then
        -- If it is someone else from the caster (agh effect) then
        -- Check if the caster still has the Mounted buff. Remove it if he doesn't.    
        if self.parent ~= self.caster then
            if not self.caster:HasModifier(self.modifier_mount) then
                self:Destroy()
            end
        end
    end    
end

function modifier_imba_skeleton_walk_invis:CheckState()
    local state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                   [MODIFIER_STATE_INVISIBLE] = true}
    return state
end

function modifier_imba_skeleton_walk_invis:GetPriority()
    return MODIFIER_PRIORITY_NORMAL
end

function modifier_imba_skeleton_walk_invis:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
                      MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
                      MODIFIER_EVENT_ON_ABILITY_EXECUTED,
                      MODIFIER_EVENT_ON_ATTACK}

    return decFuncs
end

function modifier_imba_skeleton_walk_invis:GetModifierInvisibilityLevel()
    return 1
end

function modifier_imba_skeleton_walk_invis:GetModifierMoveSpeedBonus_Percentage()
    return self.ms_bonus_pct
end

function modifier_imba_skeleton_walk_invis:OnAbilityExecuted(keys)
    if IsServer() then       
        local caster = keys.unit        

        -- Only apply when Clinkz was the one who activated an ability        
        if self.parent == caster then            
            local enemy = FindUnitsInRadius(self.parent:GetTeamNumber(),
                                            self.parent:GetAbsOrigin(),
                                            nil,
                                            25000,
                                            DOTA_UNIT_TARGET_TEAM_ENEMY,
                                            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                            DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
                                            FIND_CLOSEST,
                                            false)

            -- Check if Clinkz is visible to the enemy when appearing            
            if enemy[1] and enemy[1]:CanEntityBeSeenByMyTeam(self.parent) then
                self.detected = true
            end

            -- Remove the invisibilty
            self:Destroy()        
        end        
    end
end

function modifier_imba_skeleton_walk_invis:OnAttack(keys)
    if IsServer() then
        local attacker = keys.attacker

        -- Only apply when Clinkz was the one attacking anything
        if self.parent == attacker then
            -- Find nearby closest enemy
            local enemy = FindUnitsInRadius(self.parent:GetTeamNumber(),
                                            self.parent:GetAbsOrigin(),
                                            nil,
                                            25000,
                                            DOTA_UNIT_TARGET_TEAM_ENEMY,
                                            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                            DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
                                            FIND_CLOSEST,
                                            false)
            
            -- Check if Clinkz is visible to the enemy when appearing            
            if enemy[1] and enemy[1]:CanEntityBeSeenByMyTeam(self.parent) then
                self.detected = true
            end            
 
            -- Remove invisibility
            self:Destroy()
        end
    end
end

function modifier_imba_skeleton_walk_invis:OnRemoved()
    if IsServer() then
        -- #6 Talent: Skeleton Walk move speed persists for a small period
        if self.caster:HasTalent("special_bonus_imba_clinkz_6") then
            self.parent:AddNewModifier(self.caster, self.ability, self.modifier_talent_ms, {duration = self.caster:FindTalentValue("special_bonus_imba_clinkz_6")})
        end        

        -- Only apply if Clinkz wasn't detected before removing modifier
        if self.detected then
            return nil
        end

        -- Play cast sound, yes, again
        EmitSoundOn(self.sound_cast, self.parent)

        -- Find nearby enemies
        local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),
                                          self.parent:GetAbsOrigin(),
                                          nil,
                                          self.spook_radius,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                          DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
                                          FIND_ANY_ORDER,
                                          false)

        
        for _,enemy in pairs(enemies) do
            -- Only apply on non-magic immune enemies
            if not enemy:IsMagicImmune() then
                -- Calculate distance to each enemy
                local distance = (enemy:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D()

                -- Calculate spook duration
                local spook_duration = self.base_spook_duration + (((self.spook_radius - distance) / self.spook_distance_inc) * self.spook_added_duration)

                -- Apply spook for the duration
                enemy:AddNewModifier(self.parent, self.ability, self.modifier_spook, {duration = spook_duration})
            end
        end
    end
end

-- Spook modifier
modifier_imba_skeleton_walk_spook = class({})

function modifier_imba_skeleton_walk_spook:IsHidden() return false end
function modifier_imba_skeleton_walk_spook:IsPurgable() return true end
function modifier_imba_skeleton_walk_spook:IsDebuff() return true end

function modifier_imba_skeleton_walk_spook:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()
        self.particle_spook = "particles/hero/clinkz/spooked/spooky_skull.vpcf"        

        -- Add particle
        self.particle_spook_fx = ParticleManager:CreateParticle(self.particle_spook, PATTACH_OVERHEAD_FOLLOW, self.parent)
        ParticleManager:SetParticleControl(self.particle_spook_fx, 0, self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControl(self.particle_spook_fx, 3, self.parent:GetAbsOrigin())

        self:AddParticle(self.particle_spook_fx, false, false, -1, false, true)        

        -- RUN FROM CLINKZ!
        self:StartIntervalThink(0.05)        
    end
end

function modifier_imba_skeleton_walk_spook:OnIntervalThink()    
    -- Determine location to force move to
    local direction = (self.parent:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()
    local location = self.parent:GetAbsOrigin() + direction * 500

    self.parent:Stop()
    self.parent:MoveToPosition(location)
end

function modifier_imba_skeleton_walk_spook:CheckState()
    local state = {[MODIFIER_STATE_COMMAND_RESTRICTED] = true}
    return state 
end



-- Move speed modifier for #6 Talent
modifier_imba_skeleton_walk_talent_ms = class({})

function modifier_imba_skeleton_walk_talent_ms:IsHidden() return false end
function modifier_imba_skeleton_walk_talent_ms:IsPurgable() return true end
function modifier_imba_skeleton_walk_talent_ms:IsDebuff() return false end

function modifier_imba_skeleton_walk_talent_ms:OnCreated()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()   

    self.ms_bonus_pct = self.ability:GetSpecialValueFor("ms_bonus_pct")
end

function modifier_imba_skeleton_walk_talent_ms:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

    return decFuncs
end

function modifier_imba_skeleton_walk_talent_ms:GetModifierMoveSpeedBonus_Percentage()
    return self.ms_bonus_pct
end




-----------------------------
--       DEATH PACT        --
-----------------------------

imba_clinkz_death_pact = class({})
LinkLuaModifier("modifier_imba_death_pact_buff", "hero/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_stack_creep", "hero/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_stack_hero", "hero/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_talent_debuff", "hero/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_talent_buff", "hero/hero_clinkz", LUA_MODIFIER_MOTION_NONE)

function imba_clinkz_death_pact:CastFilterResultTarget(target)
    local caster = self:GetCaster()

    -- Can't target self
    if caster == target then
        return UF_FAIL_CUSTOM
    end

    -- Can't target buildings
    if target:IsBuilding() then
        return UF_FAIL_BUILDING
    end

    return UF_SUCCESS
end

function imba_clinkz_death_pact:GetCustomCastErrorTarget(target) 
    return "dota_hud_error_cant_cast_on_self"
end

function imba_clinkz_death_pact:IsHiddenWhenStolen()
    return false
end

function imba_clinkz_death_pact:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorTarget()
    local cast_response = "clinkz_clinkz_ability_pact_0"..math.random(1, 6)
    local sound_cast = "sounds/weapons/hero/clinkz/death_pact_cast.vsnd"
    local particle_pact = "particles/units/heroes/hero_clinkz/clinkz_death_pact.vpcf"
    local modifier_pact = "modifier_imba_death_pact_buff"
    local modifier_stack_creep = "modifier_imba_death_pact_stack_creep"
    local modifier_stack_hero = "modifier_imba_death_pact_stack_hero"
    local modifier_talent_debuff_mark = "modifier_imba_death_pact_talent_debuff"

    -- Ability specials
    local duration = ability:GetSpecialValueFor("duration")        
    local hero_current_hp_damage_pct = ability:GetSpecialValueFor("hero_current_hp_damage_pct")    

    -- If target has Linken's Sphere off cooldown, do nothing
    if target:GetTeam() ~= caster:GetTeam() then
        if target:TriggerSpellAbsorb(ability) then
            return nil
        end
    end

    -- Roll for cast response
    if RollPercentage(50) and caster:IsHero() then
        EmitSoundOn(cast_response, caster)
    end

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)

    -- Add particle effect
    local particle_pact_fx = ParticleManager:CreateParticle(particle_pact, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle_pact_fx, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_pact_fx, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_pact_fx, 5, target:GetAbsOrigin())

    -- Remove existing modifiers so new values would replace the old ones
    if caster:HasModifier(modifier_pact) then
        caster:RemoveModifierByName(modifier_pact)
        caster:RemoveModifierByName(modifier_stack_creep)
        caster:RemoveModifierByName(modifier_stack_hero)
    end

    -- Variables
    local pact_stacks
    local modifier_stacks

    -- Check if it is a hero or a creep
    if target:IsHero() then
        -- Calculate damage based on current HP
        local current_hp = target:GetHealth()
        local damage = current_hp * (hero_current_hp_damage_pct * 0.01)

        -- Deal pure damage
        local damageTable = {victim = target,
                            damage = damage,
                            damage_type = DAMAGE_TYPE_PURE,
                            attacker = caster,
                            ability = ability
                            }
                            
        ApplyDamage(damageTable)    

        -- Assign stacks variables
        pact_stacks = damage
        modifier_stacks = caster:AddNewModifier(caster, ability, modifier_stack_hero, {duration = duration})
    else 
        -- Get creeps' current HP
        local current_hp = target:GetHealth()

        -- Kill creep
        target:Kill(ability, caster)

        -- Assign stacks variables
        pact_stacks = current_hp
        modifier_stacks = caster:AddNewModifier(caster, ability, modifier_stack_creep, {duration = duration})
    end   

    -- If the caster is a nether ward, disable bonus damage and HP
    if not caster:IsHero() then
        return nil        
    end

    -- Add visible modifier to the caster
    caster:AddNewModifier(caster, ability, modifier_pact, {duration = duration})    

    -- Assign stack counts to the stack modifier
    if modifier_stacks then
        modifier_stacks:SetStackCount(pact_stacks)
    end

    -- Force recalculation of stats (to recalculate HP)
    caster:CalculateStatBonus()

    -- #8 Talent: Death Pact bonuses stay permanently if enemy target dies quickly
    -- Apply a marker on the target if caster has the talent
    if caster:HasTalent("special_bonus_imba_clinkz_8") and caster:GetTeamNumber() ~= target:GetTeamNumber() then
        local mark_duration = caster:FindSpecificTalentValue("special_bonus_imba_clinkz_8", "mark_duration")
        target:AddNewModifier(caster, ability, modifier_talent_debuff_mark, {duration = mark_duration})
    end
end

-- Dummy Death Pact buff (shows in the UI, but actually does nothing)
modifier_imba_death_pact_buff = class({})

function modifier_imba_death_pact_buff:IsHidden() return false end
function modifier_imba_death_pact_buff:IsPurgable() return false end
function modifier_imba_death_pact_buff:IsDebuff() return false end


-- Hidden buff for counting stacks (gives bonus damage and HP depending on stacks)
modifier_imba_death_pact_stack_creep = class({})

function modifier_imba_death_pact_stack_creep:IsHidden() return true end
function modifier_imba_death_pact_stack_creep:IsPurgable() return false end
function modifier_imba_death_pact_stack_creep:IsDebuff() return false end

function modifier_imba_death_pact_stack_creep:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.particle_pact_buff = "particles/units/heroes/hero_clinkz/clinkz_death_pact_buff.vpcf"

    -- Ability specials
    self.creep_bonus_hp_pct = self.ability:GetSpecialValueFor("creep_bonus_hp_pct")
    self.creep_bonus_dmg_pct = self.ability:GetSpecialValueFor("creep_bonus_dmg_pct")  

    -- #7 Talent: Death Pact bonuses increase
    self.creep_bonus_hp_pct = self.creep_bonus_hp_pct * (1+ self.caster:FindTalentValue("special_bonus_imba_clinkz_7") * 0.01)
    self.creep_bonus_dmg_pct = self.creep_bonus_dmg_pct * (1+ self.caster:FindTalentValue("special_bonus_imba_clinkz_7") * 0.01)

    -- Add buff effect
    self.particle_pact_buff_fx = ParticleManager:CreateParticle(self.particle_pact_buff, PATTACH_POINT_FOLLOW, self.caster)
    ParticleManager:SetParticleControlEnt(self.particle_pact_buff_fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(self.particle_pact_buff_fx, 2, self.caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(self.particle_pact_buff_fx, 8, Vector(1,0,0))

    self:AddParticle(self.particle_pact_buff_fx, false, false, -1, false, false)

    if IsServer() then        
        Timers:CreateTimer(FrameTime(), function()
            local stacks = self:GetStackCount()
            self.caster:Heal(self.creep_bonus_hp_pct * 0.01 * stacks, self.caster)            
        end)
    end
end


function modifier_imba_death_pact_stack_creep:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
                      MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS}

    return decFuncs
end

function modifier_imba_death_pact_stack_creep:GetModifierBaseAttack_BonusDamage()
    local stacks = self:GetStackCount()
    local bonus_damage = self.creep_bonus_dmg_pct * 0.01 * stacks 

    return bonus_damage
end

function modifier_imba_death_pact_stack_creep:GetModifierExtraHealthBonus()
    local stacks = self:GetStackCount()
    local bonus_hp = self.creep_bonus_hp_pct * 0.01 * stacks

    return bonus_hp
end

-- Hidden buff for counting stacks. Calculates for hero
modifier_imba_death_pact_stack_hero = class({})

function modifier_imba_death_pact_stack_hero:IsHidden() return true end
function modifier_imba_death_pact_stack_hero:IsPurgable() return false end
function modifier_imba_death_pact_stack_hero:IsDebuff() return false end

function modifier_imba_death_pact_stack_hero:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.particle_pact_buff = "particles/units/heroes/hero_clinkz/clinkz_death_pact_buff.vpcf"

    -- Ability specials
    self.hero_bonus_hp_dmg_mult = self.ability:GetSpecialValueFor("hero_bonus_hp_dmg_mult")
    self.hero_bonus_dmg_pct = self.ability:GetSpecialValueFor("hero_bonus_dmg_pct")  

    -- #7 Talent: Death Pact bonuses increase
    self.hero_bonus_hp_dmg_mult = self.hero_bonus_hp_dmg_mult * (1+ self.caster:FindTalentValue("special_bonus_imba_clinkz_7") * 0.01)
    self.hero_bonus_dmg_pct = self.hero_bonus_dmg_pct * (1+ self.caster:FindTalentValue("special_bonus_imba_clinkz_7") * 0.01)

    -- Add buff effect
    self.particle_pact_buff_fx = ParticleManager:CreateParticle(self.particle_pact_buff, PATTACH_POINT_FOLLOW, self.caster)
    ParticleManager:SetParticleControlEnt(self.particle_pact_buff_fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(self.particle_pact_buff_fx, 2, self.caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(self.particle_pact_buff_fx, 8, Vector(1,0,0))

    self:AddParticle(self.particle_pact_buff_fx, false, false, -1, false, false)   

    if IsServer() then        
        Timers:CreateTimer(FrameTime(), function()
            local stacks = self:GetStackCount()
            self.caster:Heal(self.hero_bonus_hp_dmg_mult * stacks, self.caster)            
        end)
    end
end


function modifier_imba_death_pact_stack_hero:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
                      MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS}

    return decFuncs
end

function modifier_imba_death_pact_stack_hero:GetModifierBaseAttack_BonusDamage()
    local stacks = self:GetStackCount()
    local bonus_damage = self.hero_bonus_dmg_pct * 0.01 * stacks 

    return bonus_damage
end

function modifier_imba_death_pact_stack_hero:GetModifierExtraHealthBonus()
    if IsServer() then
        local stacks = self:GetStackCount()
        local bonus_hp = self.hero_bonus_hp_dmg_mult * stacks

        return bonus_hp
    end
end


-- #8 Talent Debuff talent target marker
modifier_imba_death_pact_talent_debuff = class({})

function modifier_imba_death_pact_talent_debuff:IsHidden() return false end
function modifier_imba_death_pact_talent_debuff:IsPurgable() return false end
function modifier_imba_death_pact_talent_debuff:IsDebuff() return true end

function modifier_imba_death_pact_talent_debuff:OnCreated()
    if IsServer() then
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()
        self.modifier_hero_pact = "modifier_imba_death_pact_stack_hero"
        self.modifier_perma_buff = "modifier_imba_death_pact_talent_buff"
    end
end

function modifier_imba_death_pact_talent_debuff:DeclareFunctions()
    local decFuncs ={MODIFIER_EVENT_ON_HERO_KILLED}

    return decFuncs
end

function modifier_imba_death_pact_talent_debuff:OnHeroKilled(keys)    
    if IsServer() then
        local killed_hero = keys.target        

        -- Only apply if the killed hero is the parent of the debuff        
        if killed_hero == self.parent and self.caster:HasModifier(self.modifier_hero_pact) then            
            -- Get stack count from the modifier
            local buff_stacks = self.caster:FindModifierByName(self.modifier_hero_pact):GetStackCount()
            print(buff_stacks)
            -- Calculate stack amount to keep
            local stacks = buff_stacks * (self.caster:FindSpecificTalentValue("special_bonus_imba_clinkz_8", "stacks_pct") * 0.01)
            print(stacks)
            -- Add perma buff if not exists yet
            if not self.caster:HasModifier(self.modifier_perma_buff) then
                self.caster:AddNewModifier(self.caster, self.ability, self.modifier_perma_buff, {})
            end

            -- Increase stack count of the perma buff 
            local modifier_buff_handler = self.caster:FindModifierByName(self.modifier_perma_buff)
            modifier_buff_handler:SetStackCount(modifier_buff_handler:GetStackCount() + stacks)
        end
    end
end

-- #8 Talent Perma bonus buff
modifier_imba_death_pact_talent_buff = class({})

function modifier_imba_death_pact_talent_buff:IsHidden() return false end
function modifier_imba_death_pact_talent_buff:IsPurgable() return false end
function modifier_imba_death_pact_talent_buff:IsDebuff() return false end

function modifier_imba_death_pact_talent_buff:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()        

    -- Ability specials
    self.hero_bonus_hp_dmg_mult = self.ability:GetSpecialValueFor("hero_bonus_hp_dmg_mult")
    self.hero_bonus_dmg_pct = self.ability:GetSpecialValueFor("hero_bonus_dmg_pct")  

    -- #7 Talent: Death Pact bonuses increase
    self.hero_bonus_hp_dmg_mult = self.hero_bonus_hp_dmg_mult * (1+ self.caster:FindTalentValue("special_bonus_imba_clinkz_7") * 0.01)
    self.hero_bonus_dmg_pct = self.hero_bonus_dmg_pct * (1+ self.caster:FindTalentValue("special_bonus_imba_clinkz_7") * 0.01)            
end

function modifier_imba_death_pact_talent_buff:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
                      MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS}

    return decFuncs
end

function modifier_imba_death_pact_talent_buff:GetModifierBaseAttack_BonusDamage()
    local stacks = self:GetStackCount()
    local bonus_damage = self.hero_bonus_dmg_pct * 0.01 * stacks 

    return bonus_damage
end

function modifier_imba_death_pact_talent_buff:GetModifierExtraHealthBonus()
    if IsServer() then
        local stacks = self:GetStackCount()
        local bonus_hp = self.hero_bonus_hp_dmg_mult * stacks

        return bonus_hp
    end
end