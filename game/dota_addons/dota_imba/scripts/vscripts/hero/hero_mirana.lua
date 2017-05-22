-- Author: Shush
-- Date: 26/03/2017


CreateEmptyTalents("mirana")

-------------------------------
--        STARSTORM          --
-------------------------------

imba_mirana_starfall = class({})
LinkLuaModifier("modifier_imba_starfall_scepter_thinker", "hero/hero_mirana", LUA_MODIFIER_MOTION_NONE)

function imba_mirana_starfall:OnUpgrade()
    local caster = self:GetCaster()
    local modifier_agh_starfall = "modifier_imba_starfall_scepter_thinker"

    -- Add it only once, when Starfall is first gained (no need to make it reapply)
    if not caster:HasModifier(modifier_agh_starfall) then
        caster:AddNewModifier(caster, self, modifier_agh_starfall, {})
    end
end

function imba_mirana_starfall:IsHiddenWhenStolen()
    return false
end

function imba_mirana_starfall:OnUnStolen()
    local caster = self:GetCaster()
    local modifier_agh_starfall = "modifier_imba_starfall_scepter_thinker"

    -- Remove modifier from Rubick when he loses the spell
    if caster:HasModifier(modifier_agh_starfall) then
        caster:RemoveModifierByName(modifier_agh_starfall)
    end
end

function imba_mirana_starfall:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self            
    local particle_circle = "particles/units/heroes/hero_mirana/mirana_starfall_circle.vpcf"
    local particle_moon = "particles/units/heroes/hero_mirana/mirana_moonlight_owner.vpcf"
    local cast_response = "mirana_mir_ability_star_0"
    local sound_cast = "Ability.Starfall"        

    -- Ability specials
    local radius = ability:GetSpecialValueFor("radius")    
    local damage = ability:GetSpecialValueFor("damage")
    local secondary_damage_pct = ability:GetSpecialValueFor("secondary_damage_pct")
    local additional_waves_count = ability:GetSpecialValueFor("additional_waves_count")
    local additional_waves_dmg_pct = ability:GetSpecialValueFor("additional_waves_dmg_pct")
    local additional_waves_interval = ability:GetSpecialValueFor("additional_waves_interval")

    -- Roll cast response for "longer" line
    if RollPercentage(10) then
        cast_response = cast_response..3
        EmitSoundOn(cast_response, caster)

    elseif RollPercentage(75) then -- If it failed, roll for normal cast response
        cast_response = cast_response..math.random(1,2)
        EmitSoundOn(cast_response, caster)
    end

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)

    -- #7 Talent: Starfall wave interval decrease (value is negative)
    additional_waves_interval = additional_waves_interval + caster:FindTalentValue("special_bonus_imba_mirana_7")

    -- Assign caster's location on cast, since the waves do not move with Mirana
    local caster_position = caster:GetAbsOrigin()

    -- Add circle particle, repeat it every second until all waves came down
    local repeats = additional_waves_count * additional_waves_interval
    local current_instance = 0    

    -- Start repeating
    Timers:CreateTimer(function()
        local particle_circle_fx = ParticleManager:CreateParticle(particle_circle, PATTACH_ABSORIGIN, caster)
        ParticleManager:SetParticleControl(particle_circle_fx, 0, caster_position)
        ParticleManager:ReleaseParticleIndex(particle_circle_fx)

        current_instance = current_instance + 1

        -- If there are still waves incoming, repeat the particle creation
        if current_instance <= repeats then            
            return 1
        else
            return nil
        end
    end)        

    -- Add moon particle
    local particle_moon_fx = ParticleManager:CreateParticle(particle_moon, PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(particle_moon_fx, 0, Vector(caster_position.x, caster_position.y, caster_position.z + 400))

    -- Remove moon particle after the duration elapsed
    Timers:CreateTimer(repeats, function()
        ParticleManager:DestroyParticle(particle_moon_fx, false)
        ParticleManager:ReleaseParticleIndex(particle_moon_fx)
    end)

    -- First Starfall wave
    StarfallWave(caster, ability, caster_position, radius, damage)

    -- Secondary Starfall
    local secondary_wave_damage = damage * (secondary_damage_pct * 0.01)
    SecondaryStarfall(caster, ability, caster_position, radius, secondary_wave_damage)

    -- Additional waves    
    local current_wave = 1     
    local additional_wave_damage = damage * (additional_waves_dmg_pct * 0.01)
    local additional_secondary_damage = additional_wave_damage * (secondary_damage_pct * 0.01)

    Timers:CreateTimer(additional_waves_interval, function()
        -- Commence Starfalls
        StarfallWave(caster, ability, caster_position, radius, additional_wave_damage)
        SecondaryStarfall(caster, ability, caster_position, radius, additional_secondary_damage)

        current_wave = current_wave + 1

        if current_wave <= additional_waves_count then
            return additional_waves_interval
        else
            return nil
        end 
    end)    
end

function StarfallWave(caster, ability, caster_position, radius, damage)
    local particle_starfall = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
    local hit_delay = ability:GetSpecialValueFor("hit_delay")    
    local sound_impact = "Ability.StarfallImpact"

    -- #1 Talent: Increase Starfall search radius
    radius = radius + caster:FindTalentValue("special_bonus_imba_mirana_1")

    -- Find enemies in radius
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                      caster_position,
                                      nil,
                                      radius,
                                      DOTA_UNIT_TARGET_TEAM_ENEMY,
                                      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                      DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
                                      FIND_ANY_ORDER,
                                      false)

    for _,enemy in pairs(enemies) do

        -- Does not hit magic immune enemies
        if not enemy:IsMagicImmune() then

            -- Add starfall effect
            local particle_starfall_fx = ParticleManager:CreateParticle(particle_starfall, PATTACH_ABSORIGIN_FOLLOW, enemy)
            ParticleManager:SetParticleControl(particle_starfall_fx, 0, enemy:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_starfall_fx, 1, enemy:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_starfall_fx, 3, enemy:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(particle_starfall_fx)

            -- Wait for the star to get to the target
            Timers:CreateTimer(hit_delay, function()

                -- Deal damage if the target did not become magic immune
                if not enemy:IsMagicImmune() then

                    -- Play impact sound
                    EmitSoundOn(sound_impact, enemy)

                    local damageTable = {victim = enemy,
                                        damage = damage,
                                        damage_type = DAMAGE_TYPE_MAGICAL,
                                        attacker = caster,
                                        ability = ability
                                        }
                        
                    ApplyDamage(damageTable)    
                end
            end)                
        end    
    end    
end

function SecondaryStarfall(caster, ability, caster_position, radius, damage)
    local particle_starfall = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
    local hit_delay = ability:GetSpecialValueFor("hit_delay")    
    local secondary_delay = ability:GetSpecialValueFor("secondary_delay")    
    local sound_impact = "Ability.StarfallImpact"

    -- #1 Talent: Increase Starfall search radius
    radius = radius + caster:FindTalentValue("special_bonus_imba_mirana_1")

    -- Find the closest enemy in the secondary radius
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                      caster_position,
                                      nil,
                                      radius,
                                      DOTA_UNIT_TARGET_TEAM_ENEMY,
                                      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                      DOTA_UNIT_TARGET_FLAG_NO_INVIS,
                                      FIND_CLOSEST,
                                      false)

    -- Check if there is an enemy to rain on, commence after a small delay
    if enemies[1] then
        local enemy = enemies[1]

        Timers:CreateTimer(secondary_delay, function()
              -- Add starfall effect
            local particle_starfall_fx = ParticleManager:CreateParticle(particle_starfall, PATTACH_ABSORIGIN_FOLLOW, enemy)
            ParticleManager:SetParticleControl(particle_starfall_fx, 0, enemy:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_starfall_fx, 1, enemy:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_starfall_fx, 3, enemy:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(particle_starfall_fx)

            -- Wait for the star to get to the target
            Timers:CreateTimer(hit_delay, function()

                -- Deal damage if the target did not become magic immune
                if not enemy:IsMagicImmune() then

                    -- Play impact sound
                    EmitSoundOn(sound_impact, enemy)

                    local damageTable = {victim = enemy,
                                         damage = damage,
                                         damage_type = DAMAGE_TYPE_MAGICAL,
                                         attacker = caster,
                                         ability = ability
                                        }
                        
                    ApplyDamage(damageTable)    
                end
            end)          
        end)        
    end
end

-- Aghnaim's Scepter thinker modifier
modifier_imba_starfall_scepter_thinker = class({})

function modifier_imba_starfall_scepter_thinker:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()        

        -- Start thinking!
        self:StartIntervalThink(1)
    end
end

function modifier_imba_starfall_scepter_thinker:IsHidden()
    if self:GetCaster():HasScepter() then
        return false
    end        

    return true 
end

function modifier_imba_starfall_scepter_thinker:IsPurgable() return false end
function modifier_imba_starfall_scepter_thinker:IsDebuff() return false end
function modifier_imba_starfall_scepter_thinker:DestroyOnExpire() return false end
function modifier_imba_starfall_scepter_thinker:RemoveOnDeath() return false end
function modifier_imba_starfall_scepter_thinker:IsPermanent() return true end

function modifier_imba_starfall_scepter_thinker:OnIntervalThink()
    if IsServer() then
        -- Ability specials
        self.radius = self.ability:GetSpecialValueFor("radius")
        self.damage = self.ability:GetSpecialValueFor("damage")
        self.scepter_starfall_cd = self.ability:GetSpecialValueFor("scepter_starfall_cd")        

        -- If the buff is not ready yet, do nothing
        if self:GetRemainingTime() > 0.5 then
            return nil
        else
            -- Set the buff's duration to -1
            self:SetDuration(-1, true)
        end
        
        -- If caster is dead, do nothing
        if not self.caster:IsAlive() then
            return nil
        end
        
        -- If caster does not have scepter, do nothing
        if not self.caster:HasScepter() then
            return nil
        end        

        -- If caster is invisible, do nothing
        if self.caster:IsInvisible() then
            return nil
        end

        -- Look for nearby enemy units to use Starfall on
        local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
                                          self.caster:GetAbsOrigin(),
                                          nil,
                                          self.radius-50,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                          DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
                                          FIND_ANY_ORDER,
                                          false)

        -- If there are no enemies, do nothing
        if #enemies == 0 then
            return nil
        end

        -- Otherwise, Commence Starfall
        StarfallWave(self.caster, self.ability, self.caster:GetAbsOrigin(), self.radius, self.damage)        

        -- Restart the buff duration
        self:SetDuration(self.scepter_starfall_cd, true)
    end
end




-------------------------------
--        SACRED ARROW       --
-------------------------------

imba_mirana_arrow = class({})
LinkLuaModifier("modifier_imba_sacred_arrow_stun", "hero/hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sacred_arrow_haste", "hero/hero_mirana", LUA_MODIFIER_MOTION_NONE)

function imba_mirana_arrow:IsHiddenWhenStolen()
    return false
end

function imba_mirana_arrow:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self        
    local target_point = self:GetCursorPosition()
    local sound_cast = "Hero_Mirana.ArrowCast"        

    -- Ability specials
    local spawn_distance = ability:GetSpecialValueFor("spawn_distance")

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)

    -- Set direction for main arrow
    local direction = (target_point - caster:GetAbsOrigin()):Normalized()

    -- Get spawn point    
    local spawn_point = caster:GetAbsOrigin() + direction * spawn_distance    

    -- Fire main arrow
    FireSacredArrow(caster, ability, spawn_point, direction)    

    -- #4 Talent: Two additional Sacred Arrows to the sides
    if caster:HasTalent("special_bonus_imba_mirana_4") then

        -- Set QAngles
        local left_QAngle = QAngle(0, 30, 0)
        local right_QAngle = QAngle(0, -30, 0)

        -- Left arrow variables
        local left_spawn_point = RotatePosition(caster:GetAbsOrigin(), left_QAngle, spawn_point)
        local left_direction = (left_spawn_point - caster:GetAbsOrigin()):Normalized()                

        -- Right arrow variables
        local right_spawn_point = RotatePosition(caster:GetAbsOrigin(), right_QAngle, spawn_point)
        local right_direction = (right_spawn_point - caster:GetAbsOrigin()):Normalized()        

        -- Fire left and right arrows
        FireSacredArrow(caster, ability, left_spawn_point, left_direction)
        FireSacredArrow(caster, ability, right_spawn_point, right_direction)
    end    
end

function FireSacredArrow(caster, ability, spawn_point, direction)
    local particle_arrow = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf"
    -- Ability specials

    local arrow_radius
    local arrow_speed
    local vision_radius
    local arrow_distance

    -- If ability is not levelled, assign level 1 values
    if ability:GetLevel() == 0 then        
        arrow_radius = ability:GetLevelSpecialValueFor("arrow_radius", 1)
        arrow_speed = ability:GetLevelSpecialValueFor("arrow_speed", 1)
        vision_radius = ability:GetLevelSpecialValueFor("vision_radius", 1)
        arrow_distance = ability:GetLevelSpecialValueFor("arrow_distance", 1)        
    else
        arrow_radius = ability:GetSpecialValueFor("arrow_radius")
        arrow_speed = ability:GetSpecialValueFor("arrow_speed")
        vision_radius = ability:GetSpecialValueFor("vision_radius")
        arrow_distance = ability:GetSpecialValueFor("arrow_distance")    
    end

    -- Fire arrow in the set direction
    local arrow_projectile = {  Ability = ability,
                                EffectName = particle_arrow,
                                vSpawnOrigin = spawn_point,
                                fDistance = arrow_distance,
                                fStartRadius = arrow_radius,
                                fEndRadius = arrow_radius,
                                Source = caster,
                                bHasFrontalCone = false,
                                bReplaceExisting = false,
                                iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,                                                          
                                iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,                           
                                bDeleteOnHit = true,
                                vVelocity = direction * arrow_speed,
                                bProvidesVision = true, 
                                iVisionRadius = vision_radius,
                                iVisionTeamNumber = caster:GetTeamNumber(),
                                ExtraData = {cast_loc_x = tostring(caster:GetAbsOrigin().x),
                                            cast_loc_y = tostring(caster:GetAbsOrigin().y),
                                            cast_loc_z = tostring(caster:GetAbsOrigin().z)}                         
                            }
                 
    ProjectileManager:CreateLinearProjectile(arrow_projectile)
end

function imba_mirana_arrow:OnProjectileHit_ExtraData(target, location, extra_data)    
    -- If no target was hit, do nothing
    if not target then
        return nil
    end

    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local cast_response_hero = {"mirana_mir_ability_arrow_01", "mirana_mir_ability_arrow_07", "mirana_mir_lasthit_03"}
    local cast_response_hero_perfect = "mirana_mir_ability_arrow_02"
    local cast_response_creep = {"mirana_mir_ability_arrow_03", "mirana_mir_ability_arrow_04", "mirana_mir_ability_arrow_05", "mirana_mir_ability_arrow_06", "mirana_mir_ability_arrow_08"}
    local cast_response_roshan = {"mirana_mir_ability_arrow_09", "mirana_mir_ability_arrow_10", "mirana_mir_ability_arrow_11", "mirana_mir_ability_arrow_12"}
    local sound_impact = "Hero_Mirana.ArrowImpact"
    local modifier_stun = "modifier_imba_sacred_arrow_stun"

    -- Ability specials
    local base_damage = ability:GetSpecialValueFor("base_damage")
    local distance_tick = ability:GetSpecialValueFor("distance_tick")
    local stun_increase_per_tick = ability:GetSpecialValueFor("stun_increase_per_tick")
    local damage_increase_per_tick = ability:GetSpecialValueFor("damage_increase_per_tick")
    local max_damage = ability:GetSpecialValueFor("max_damage")
    local max_stun_duration = ability:GetSpecialValueFor("max_stun_duration")
    local base_stun = ability:GetSpecialValueFor("base_stun")
    local vision_radius = ability:GetSpecialValueFor("vision_radius")
    local vision_linger_duration = ability:GetSpecialValueFor("vision_linger_duration")

    -- Cast response for creeps
    if target:IsCreep() and not IsRoshan(target) then
        local chosen_response = cast_response_creep[math.random(1, 5)]
        EmitSoundOn(chosen_response, caster)
    end

    -- Cast response for Roshan
    if IsRoshan(target) then
        local chosen_response = cast_response_roshan[math.random(1,4)]
        EmitSoundOn(chosen_response, caster)
    end

    -- Play impact sound
    EmitSoundOn(sound_impact, target)

    -- Add FOW viewer for the linger duration
    AddFOWViewer(caster:GetTeamNumber(), location, vision_radius, vision_linger_duration, false)   

    -- If target was a creep, kill it immediately and exit
    if target:IsCreep() and not IsRoshan(target) and not target:IsAncient() then
        target:Kill(ability, caster)
        return true
    end

    -- If target was an illusion, kill it immediately and exit
    if target:IsIllusion() then
        target:Kill(ability, caster)
        return true
    end

    -- Recombine cast location vector
    local cast_location = Vector(tonumber(extra_data.cast_loc_x), tonumber(extra_data.cast_loc_y), tonumber(extra_data.cast_loc_z))

    -- Calculate distance traveled
    local distance = (target:GetAbsOrigin() - cast_location):Length2D()

    -- Calculate damage
    local damage = base_damage + (distance / distance_tick * damage_increase_per_tick)

    -- Cannot exceed max damage
    if damage > max_damage then
        damage = max_damage
    end

    -- Apply damage
    local damageTable = {victim = target,
                        damage = damage,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        attacker = caster,
                        ability = ability
                        }
                        
    ApplyDamage(damageTable)    

    -- Calculate stun duration 
    local stun_duration = base_stun + (distance / distance_tick * stun_increase_per_tick)

    -- Cannot exceed max stun
    if stun_duration > max_stun_duration then
        stun_duration = max_stun_duration
    end   

    -- #3 Talent: Sacred Arrow's stun duration increase
    stun_duration = stun_duration + caster:FindTalentValue("special_bonus_imba_mirana_3")    

    -- Cast response for heroes
    if target:IsRealHero() then

        -- Bullseye
        if stun_duration >= max_stun_duration then
            EmitSoundOn(cast_response_hero_perfect, caster)
        else
            local chosen_response = cast_response_hero[math.random(1, 3)]
            EmitSoundOn(chosen_response, caster)
        end
    end

    -- Apply stun
    target:AddNewModifier(caster, ability, modifier_stun, {duration = stun_duration})

    return true
end





-- Arrow stun modifier
modifier_imba_sacred_arrow_stun = class({})

function modifier_imba_sacred_arrow_stun:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()
        self.modifier_arrow_stun = "modifier_imba_sacred_arrow_stun"
        self.modifier_haste = "modifier_imba_sacred_arrow_haste"
        self.attackers_table = {}

        -- Ability specials
        self.on_prow_crit_damage = self.ability:GetSpecialValueFor("on_prow_crit_damage")        
    end
 end 

function modifier_imba_sacred_arrow_stun:IsHidden() return false end
function modifier_imba_sacred_arrow_stun:IsStunDebuff() return true end
function modifier_imba_sacred_arrow_stun:IsPurgeException() return true end

function modifier_imba_sacred_arrow_stun:CheckState()
    local state = {[MODIFIER_STATE_STUNNED] = true}
    return state
end

function modifier_imba_sacred_arrow_stun:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_sacred_arrow_stun:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_sacred_arrow_stun:DeclareFunctions()
    local decFuncs = {MODIFIER_EVENT_ON_ORDER,
                      MODIFIER_EVENT_ON_TAKEDAMAGE}

    return decFuncs
end

function modifier_imba_sacred_arrow_stun:OnOrder(keys)    
    if IsServer() then
        local unit = keys.unit
        local order_type = keys.order_type
        local target = keys.target

        -- Only apply on units from the caster's team
        if unit:GetTeamNumber() == self.caster:GetTeamNumber() then

            -- Only apply if the order is an attack order against the stunned unit. Anything else removes it
            if (order_type == DOTA_UNIT_ORDER_ATTACK_TARGET or order_type == DOTA_UNIT_ORDER_CAST_TARGET) and target:HasModifier(self.modifier_arrow_stun) then
                unit:AddNewModifier(self.caster, self.ability, self.modifier_haste, {})
            else
                if unit:HasModifier(self.modifier_haste) then
                    unit:RemoveModifierByName(self.modifier_haste)
                end
            end
        end
    end
end

function modifier_imba_sacred_arrow_stun:OnTakeDamage(keys)
    if IsServer() then        
        local attacker = keys.attacker
        local target = keys.unit

        -- Only apply if the target is the stunned parent, and the attacker is from another team
        if target == self.parent and target:GetTeamNumber() ~= attacker:GetTeamNumber() then

            -- If the attacker is on the list of attackers, do nothing
            if #self.attackers_table > 0 then
                for i = 1 , #self.attackers_table do
                    if attacker == self.attackers_table[i] then                                                
                        return nil
                    end
                end
            end

            -- Add the attacker to the list            
            table.insert(self.attackers_table, attacker)            
        end
    end
end

function modifier_imba_sacred_arrow_stun:OnDestroy()
    if IsServer() then
        -- Find all enemies
        local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),
                                          self.parent:GetAbsOrigin(),
                                          nil,
                                          25000, -- global
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                          DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
                                          FIND_ANY_ORDER,
                                          false)

        -- Check if they have the haste modifier, if they do, remove it
        for _, enemy in pairs(enemies) do
            if enemy:HasModifier(self.modifier_haste) then
                enemy:RemoveModifierByName(self.modifier_haste)
            end
        end
    end
end

-- Allies haste modifier
modifier_imba_sacred_arrow_haste = class({})

function modifier_imba_sacred_arrow_haste:IsHidden() return false end
function modifier_imba_sacred_arrow_haste:IsPurgable() return true end
function modifier_imba_sacred_arrow_haste:IsDebuff() return false end

function modifier_imba_sacred_arrow_haste:OnCreated()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.on_prowl_movespeed = self.ability:GetSpecialValueFor("on_prowl_movespeed")
end

function modifier_imba_sacred_arrow_haste:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
                      MODIFIER_PROPERTY_MOVESPEED_MAX}

    return decFuncs
end

function modifier_imba_sacred_arrow_haste:GetModifierMoveSpeedOverride()
    return self.on_prowl_movespeed
end

function modifier_imba_sacred_arrow_haste:GetModifierMoveSpeed_Max()
    return self.on_prowl_movespeed
end

function modifier_imba_sacred_arrow_haste:GetEffectName()
    return "particles/hero/mirana/mirana_sacred_boost.vpcf"
end

function modifier_imba_sacred_arrow_haste:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


-------------------------------
--           LEAP            --
-------------------------------

imba_mirana_leap = class({})
LinkLuaModifier("modifier_imba_leap_movement", "hero/hero_mirana", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_imba_leap_aura", "hero/hero_mirana", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_imba_leap_speed_boost", "hero/hero_mirana", LUA_MODIFIER_MOTION_BOTH)

function imba_mirana_leap:GetCastRange(location, target)        
    local ability = self
    local leap_range = ability:GetSpecialValueFor("leap_range")
    local night_leap_range_bonus = ability:GetSpecialValueFor("night_leap_range_bonus")
    
    if IsDaytime() then                    
        return leap_range        
    else            
        return leap_range + night_leap_range_bonus        
    end            
end

function imba_mirana_leap:IsHiddenWhenStolen()
    return false
end

function imba_mirana_leap:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local target_point = self:GetCursorPosition()    
    local modifier_movement = "modifier_imba_leap_movement"
    local sound_cast = "Ability.Leap"

    -- Ability specials
    local jump_speed = ability:GetSpecialValueFor("jump_speed")

    -- Start gesture
    caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)

    -- Disjoint projectiles
    ProjectileManager:ProjectileDodge(caster)

    -- Start moving
    local modifier_movement_handler = caster:AddNewModifier(caster, ability, modifier_movement, {})

    -- Assign the target location in the modifier
    if modifier_movement_handler then
        modifier_movement_handler.target_point = target_point
    end

    -- #6 Talent: Free Sacred Arrow after Leap ends
    if caster:HasTalent("special_bonus_imba_mirana_6") then

        -- Calculate the landing time
        local distance = (caster:GetAbsOrigin() - target_point):Length2D()
        local jump_time = distance / jump_speed

        -- Calculate direction and spawn point of the arrow
        local direction = (target_point - caster:GetAbsOrigin()):Normalized()

        -- Set caster's location BEFORE the jump
        local caster_location = caster:GetAbsOrigin()        

        -- Create Timer
        Timers:CreateTimer(jump_time, function()

            -- Get the Sacred Arrow ability definition and distance
            local sacred_arrow_ability = caster:FindAbilityByName("imba_mirana_arrow")            

            -- Get values for at least level 1 arrow            
            local spawn_distance

            if sacred_arrow_ability:GetLevel() > 0 then
                spawn_distance = sacred_arrow_ability:GetSpecialValueFor("spawn_distance")       
            else
                spawn_distance = sacred_arrow_ability:GetLevelSpecialValueFor("spawn_distance", sacred_arrow_ability:GetLevel()+1)       
            end

            -- Get spawn point    
            local spawn_point = caster_location + direction * (spawn_distance + distance)

            -- Fire Sacred Arrow
            FireSacredArrow(caster, sacred_arrow_ability, spawn_point, direction)
        end)
    end
end


-- Leap movement modifier
modifier_imba_leap_movement = class({})

function modifier_imba_leap_movement:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()                
        self.modifier_aura = "modifier_imba_leap_aura"

        -- Ability specials
        self.jump_speed = self.ability:GetSpecialValueFor("jump_speed")
        self.max_height = self.ability:GetSpecialValueFor("max_height")
        self.aura_duration = self.ability:GetSpecialValueFor("aura_duration")

        -- Variables
        self.time_elapsed = 0
        self.leap_z = 0

        -- Wait one frame to get the target point from the ability's OnSpellStart, then calculate distance
        Timers:CreateTimer(FrameTime(), function()
            self.distance = (self.caster:GetAbsOrigin() - self.target_point):Length2D()
            self.jump_time = self.distance / self.jump_speed

            self.direction = (self.target_point - self.caster:GetAbsOrigin()):Normalized()

            -- Start forced movement
            if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
                self:Destroy()
            end        
        end)        
    end
end

function modifier_imba_leap_movement:IsHidden() return true end
function modifier_imba_leap_movement:IsPurgable() return false end
function modifier_imba_leap_movement:IsDebuff() return false end

function modifier_imba_leap_movement:UpdateVerticalMotion(me, dt)
    if IsServer() then
        -- Check if we're still jumping
        if self.time_elapsed < self.jump_time then

            -- Check if we should be going up or down
            if self.time_elapsed <= self.jump_time / 2 then
                -- Going up                
                self.leap_z = self.leap_z + 30                
                

                self.caster:SetAbsOrigin(GetGroundPosition(self.caster:GetAbsOrigin(), self.caster) + Vector(0,0,self.leap_z))                
            else
                -- Going down
                self.leap_z = self.leap_z - 30
                if self.leap_z > 0 then
                    self.caster:SetAbsOrigin(GetGroundPosition(self.caster:GetAbsOrigin(), self.caster) + Vector(0,0,self.leap_z))
                end
                
            end 
        end
    end
end

function modifier_imba_leap_movement:UpdateHorizontalMotion(me, dt)
   if IsServer() then
        -- Check if we're still jumping
        self.time_elapsed = self.time_elapsed + dt
        if self.time_elapsed < self.jump_time then

            -- Go forward
            local new_location = self.caster:GetAbsOrigin() + self.direction * self.jump_speed * dt
            self.caster:SetAbsOrigin(new_location)            
        else
            self.caster:InterruptMotionControllers(true)
            self:Destroy()
        end
   end 
end

function modifier_imba_leap_movement:OnRemoved()    
    if IsServer() then
        self.caster:AddNewModifier(self.caster, self.ability, self.modifier_aura, {duration = self.aura_duration})
    end
end

-- Leap aura modifier
modifier_imba_leap_aura = class({})

function modifier_imba_leap_aura:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()        

    -- Ability specials
    self.aura_aoe = self.ability:GetSpecialValueFor("aura_aoe")
    self.aura_linger_duration = self.ability:GetSpecialValueFor("aura_linger_duration")

    -- #2 Talent: Leap Aura linger duration increase
    self.aura_linger_duration = self.aura_linger_duration + self.caster:FindTalentValue("special_bonus_imba_mirana_2")
end

function modifier_imba_leap_aura:IsHidden() return false end
function modifier_imba_leap_aura:IsPurgable() return false end
function modifier_imba_leap_aura:IsDebuff() return false end

function modifier_imba_leap_aura:GetAuraDuration()
    return self.aura_linger_duration
end

function modifier_imba_leap_aura:GetAuraRadius()
    return self.aura_aoe
end

function modifier_imba_leap_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_leap_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_leap_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_leap_aura:GetModifierAura()
    return "modifier_imba_leap_speed_boost"
end

function modifier_imba_leap_aura:IsAura()
    return true
end

-- Leap speed boost modifier
modifier_imba_leap_speed_boost = class({})

function modifier_imba_leap_speed_boost:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()    
    self.parent = self:GetParent()

    -- Ability specials
    self.move_speed_pct = self.ability:GetSpecialValueFor("move_speed_pct")
    self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")

    -- #5 Talent: Leap Aura attack speed increase
    self.attack_speed = self.attack_speed + self.caster:FindTalentValue("special_bonus_imba_mirana_5")
end

function modifier_imba_leap_speed_boost:IsHidden() 
    if self.parent == self.caster and self.caster:HasModifier("modifier_imba_leap_aura") then
        return true
    end

    return false 
end

function modifier_imba_leap_speed_boost:IsPurgable() return false end
function modifier_imba_leap_speed_boost:IsDebuff() return false end

function modifier_imba_leap_speed_boost:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
                      MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

    return decFuncs
end

function modifier_imba_leap_speed_boost:GetModifierMoveSpeedBonus_Percentage()
    return self.move_speed_pct
end

function modifier_imba_leap_speed_boost:GetModifierAttackSpeedBonus_Constant()
    return self.attack_speed
end

-------------------------------
--     MOONLIGHT SHADOW      --
-------------------------------

imba_mirana_moonlight_shadow = class({})
LinkLuaModifier("modifier_imba_moonlight_shadow", "hero/hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_moonlight_shadow_invis", "hero/hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_moonlight_shadow_invis_dummy", "hero/hero_mirana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_moonlight_shadow_invis_fade_time", "hero/hero_mirana", LUA_MODIFIER_MOTION_NONE)

function imba_mirana_moonlight_shadow:GetCooldown(level)
    local caster = self:GetCaster()
    local base_cd = self.BaseClass.GetCooldown(self, level)

    -- #8 Talent: 
    return (base_cd - caster:FindTalentValue("special_bonus_imba_mirana_8"))
end

function imba_mirana_moonlight_shadow:IsHiddenWhenStolen()
    return false
end

function imba_mirana_moonlight_shadow:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local modifier_main = "modifier_imba_moonlight_shadow"
    local cast_response = {"mirana_mir_ability_moon_02", "mirana_mir_ability_moon_03", "mirana_mir_ability_moon_04", "mirana_mir_ability_moon_07", "mirana_mir_ability_moon_08"}
    local sound_cast = "Ability.MoonlightShadow"
    local particle_moon = "particles/units/heroes/hero_mirana/mirana_moonlight_cast.vpcf"

    -- Ability specials
    local duration = ability:GetSpecialValueFor("duration")

    -- Play cast response
    EmitSoundOn(cast_response[math.random(1, 5)], caster)

    -- Play sound cast
    EmitSoundOn(sound_cast, caster)

    -- Add particle effect
    local particle_moon_fx = ParticleManager:CreateParticle(particle_moon, PATTACH_POINT_FOLLOW, caster)    
    ParticleManager:SetParticleControlEnt(particle_moon_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle_moon_fx)    

    -- Apply main modifier
    caster:AddNewModifier(caster, ability, modifier_main, {duration = duration})
end

-- Main modifier (Mirana)
modifier_imba_moonlight_shadow = class({})

function modifier_imba_moonlight_shadow:OnCreated()
    if IsServer() then
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.modifier_invis = "modifier_imba_moonlight_shadow_invis"
        self.modifier_dummy = "modifier_imba_moonlight_shadow_invis_dummy"
        self.fade_delay = self.ability:GetSpecialValueFor("fade_delay")
        -- Start interval think
        self:StartIntervalThink(0.1)
    end
end

function modifier_imba_moonlight_shadow:IsHidden() return false end
function modifier_imba_moonlight_shadow:IsPurgable() return false end
function modifier_imba_moonlight_shadow:IsDebuff() return false end

function modifier_imba_moonlight_shadow:OnIntervalThink()
    if IsServer() then
        local duration = self:GetRemainingTime()
        
        -- Find all allied heroes
        local allies = FindUnitsInRadius(self.caster:GetTeamNumber(),
                                         self.caster:GetAbsOrigin(),
                                         nil,
                                         25000,
                                         DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                         DOTA_UNIT_TARGET_HERO,
                                         DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
                                         FIND_ANY_ORDER,
                                         false)

        -- If they don't have invisibility modifiers, give it to them
        for _,ally in pairs(allies) do
            if not ally:HasModifier(self.modifier_invis) then
                ally:AddNewModifier(self.caster, self.ability, self.modifier_dummy, {duration = duration})
                ally:AddNewModifier(self.caster, self.ability, self.modifier_invis, {duration = duration})
                if self:GetDuration() < (duration + self.fade_delay) then
                    ally:AddNewModifier(self.caster, self.ability, "modifier_imba_moonlight_shadow_invis_fade_time", {duration = self.fade_delay})
                end
            end
        end
    end
end

function modifier_imba_moonlight_shadow:OnDestroy()
    if IsServer() then
        -- Find all allied heroes
        local allies = FindUnitsInRadius(self.caster:GetTeamNumber(),
                                         self.caster:GetAbsOrigin(),
                                         nil,
                                         25000,
                                         DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                         DOTA_UNIT_TARGET_HERO,
                                         DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
                                         FIND_ANY_ORDER,
                                         false)

        -- If they have the invisibility modifiers, remove it
        for _,ally in pairs(allies) do
            if ally:HasModifier(self.modifier_invis) then
                ally:RemoveModifierByName(self.modifier_invis)
                ally:RemoveModifierByName(self.modifier_dummy)
            end
        end
    end
end



-- Invisibility modifier (hidden)
modifier_imba_moonlight_shadow_invis = class({})
 
function modifier_imba_moonlight_shadow_invis:OnCreated()
    -- this stacks is the actual invisibility, but since it has a on/off triggers, it's counted with stacks
    -- 0 stacks means the hero is not invisible
    -- 1 stack means the hero is invisible, but can be detected
    -- 2 stacks means the hero is both invisible and cannot be detected

    if IsServer() then   
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent() 
        self.modifier_dummy_name = "modifier_imba_moonlight_shadow_invis_dummy"
        self.modifier_dummy = self.parent:FindModifierByName("modifier_imba_moonlight_shadow_invis_dummy")

        -- Ability specials
        self.fade_delay = self.ability:GetSpecialValueFor("fade_delay")
        self.truesight_immunity_radius = self.ability:GetSpecialValueFor("truesight_immunity_radius")

        -- Set stack count to level 2
        self:SetStackCount(2)

        -- Start thinking
        self:StartIntervalThink(0.1)
    end
end 

function modifier_imba_moonlight_shadow_invis:IsHidden() return true end
function modifier_imba_moonlight_shadow_invis:IsPurgable() return false end
function modifier_imba_moonlight_shadow_invis:IsDebuff() return false end

function modifier_imba_moonlight_shadow_invis:OnIntervalThink()
    if IsServer() then
        -- Look around for enemy heroes in the immunity radius
        local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),
                                          self.parent:GetAbsOrigin(),
                                          nil,
                                          self.truesight_immunity_radius,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO,
                                          DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
                                          FIND_ANY_ORDER,
                                          false)

        -- if the hero is not invisible, do nothing
        if self:GetStackCount() == 0 then
            return nil
        end

        -- If an enemy hero was found, remove immunity
        if #enemies > 0 then            
            self:SetStackCount(1)
        else
            -- Else, set it back
            self:SetStackCount(2)
        end    
    end
end

function modifier_imba_moonlight_shadow_invis:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
                      MODIFIER_EVENT_ON_ABILITY_EXECUTED,
                      MODIFIER_EVENT_ON_ATTACK}

    return decFuncs                      
end

function modifier_imba_moonlight_shadow_invis:GetModifierInvisibilityLevel()    
    local stacks = self:GetStackCount()

    if stacks == 2 or stacks == 1 then
        return 1
    else
        return 0
    end    
end

function modifier_imba_moonlight_shadow_invis:OnAbilityExecuted(keys)
    if IsServer() then
        local unit = keys.unit

        -- Only apply if the parent is the one casting
        if self.parent == unit then

            -- Remove invisibility, set duration to fade delay
            self:SetStackCount(0)
            self:SetDuration(self.fade_delay, true)
            self.modifier_dummy:SetDuration(self.fade_delay, true)
            self.parent:AddNewModifier(self.caster, self.ability, self:GetName(), {duration = self.fade_delay})
            self.parent:AddNewModifier(self.caster, self.ability, self.modifier_dummy_name, {duration = self.fade_delay})
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_imba_moonlight_shadow_invis_fade_time", {duration = self.fade_delay})
        end
    end
end

function modifier_imba_moonlight_shadow_invis:OnAttack(keys)
    if IsServer() then
        local attacker = keys.attacker    

        -- Only apply if the parent is the one attacking
        if self.parent == attacker then

            -- Remove invisibility, set duration to fade delay
            self:SetStackCount(0)
            self:SetDuration(self.fade_delay, true)
            self.modifier_dummy:SetDuration(self.fade_delay, true)
            self.parent:AddNewModifier(self.caster, self.ability, self:GetName(), {duration = self.fade_delay})
            self.parent:AddNewModifier(self.caster, self.ability, self.modifier_dummy_name, {duration = self.fade_delay})
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_imba_moonlight_shadow_invis_fade_time", {duration = self.fade_delay})
        end
    end
end

function modifier_imba_moonlight_shadow_invis:CheckState()
    if IsServer() then
        local state
        local stacks = self:GetStackCount()

        -- If parent is not invisible, no states are applied
        if stacks == 0 then
            return nil
        end

        -- If parent is truesight immune and invisible, set correct state
        if stacks == 2 then
            state = {[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
                     [MODIFIER_STATE_INVISIBLE] = true}
        else
            state = {[MODIFIER_STATE_INVISIBLE] = true}
        end
        
        return state
    end
end

-- Dummy invisibility modifier (shown)
modifier_imba_moonlight_shadow_invis_dummy = class({})

function modifier_imba_moonlight_shadow_invis_dummy:IsHidden() return false end
function modifier_imba_moonlight_shadow_invis_dummy:IsPurgable() return false end
function modifier_imba_moonlight_shadow_invis_dummy:IsDebuff() return false end

function modifier_imba_moonlight_shadow_invis_dummy:GetEffectName()
    return "particles/units/heroes/hero_mirana/mirana_moonlight_owner.vpcf"
end

function modifier_imba_moonlight_shadow_invis_dummy:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

-- Dummy fade modifier (shown)
modifier_imba_moonlight_shadow_invis_fade_time = class({})

function modifier_imba_moonlight_shadow_invis_fade_time:IsHidden() return false end
function modifier_imba_moonlight_shadow_invis_fade_time:IsPurgable() return false end
function modifier_imba_moonlight_shadow_invis_fade_time:IsPurgeException() return false end
function modifier_imba_moonlight_shadow_invis_fade_time:IsDebuff() return false end