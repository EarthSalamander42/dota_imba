--[[
    Remove souls on death
]]
function NecromasteryDeath(keys)
    local caster = keys.caster

    -- Check if requiem is learned
    local ability_requiem = caster:FindAbilityByName(keys.requiem_ability)
    if ability_requiem then
        if ability_requiem:GetLevel() > 0 then
            -- Requiem is responsible for soul release once it is learned
            return nil
        end
    end

    -- Otherwise reduce soul counter
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local modifier = keys.modifier
    local soul_release = ability:GetLevelSpecialValueFor("soul_release", ability_level)
    local current_stack = caster:GetModifierStackCount(modifier, caster)
    if current_stack then
        caster:SetModifierStackCount(modifier, caster, math.ceil(current_stack * soul_release))
    end
end

--[[
    Add permanent souls on kill
]]
function NecromasteryStack(keys)
    local caster = keys.caster
    local target = keys.unit
    local modifier = keys.modifier
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local scepter = HasScepter(caster)
    
    -- Parameters
    local souls_non_hero_count = ability:GetLevelSpecialValueFor("souls_non_hero_count", ability_level)
    local souls_hero_count = ability:GetLevelSpecialValueFor("souls_hero_count", ability_level)
    local max_souls = ability:GetLevelSpecialValueFor("max_souls", ability_level)
    if scepter then
        max_souls = ability:GetLevelSpecialValueFor("max_souls_scepter", ability_level)
    end

    -- Check how many stacks should be granted, 0 for illusions
    local souls_gained = 0
    if target:IsRealHero() then
        souls_gained = souls_hero_count
    elseif not target:IsIllusion() then
        souls_gained = souls_non_hero_count
    end

    -- Check if the hero already has the modifier
    local current_stack = caster:GetModifierStackCount(modifier, caster)
    if current_stack == 0 then
        ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
    end

    -- Set the stack count up to max_souls
    if (current_stack + souls_gained) <= max_souls then
        caster:SetModifierStackCount(modifier, caster, current_stack + souls_gained)
    else
        caster:SetModifierStackCount(modifier, caster, max_souls)
    end
end

--[[
    Give temporary souls upon dealing damage
]]
function NecromasteryOnDamage(keys)
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.unit
    local modifier_ignore_damage = keys.modifier_ignore_damage

    if target:IsRealHero() and target:IsOpposingTeam(caster:GetTeam()) and not target:HasModifier(modifier_ignore_damage) then
        -- Additional variables
        local ability = keys.ability
        local ability_level = ability:GetLevel() - 1
        local modifier = keys.modifier
        local modifier_souls_counter = keys.modifier_souls_counter
        local engorge_damage_soul_count = ability:GetLevelSpecialValueFor("engorge_damage_soul_count", ability_level)

        AddTemporarySouls(caster, modifier, modifier_souls_counter, engorge_damage_soul_count)
    end
end

--[[
    Reduce the temporary soul counter whenever a dummy buff runs out
]]
function NecromasteryReduceTemporarySouls(keys)
    local caster = keys.caster
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local engorge_damage_soul_count = ability:GetLevelSpecialValueFor("engorge_damage_soul_count", ability_level)
    local modifier = keys.modifier
    local modifier_souls_counter = keys.modifier_souls_counter

    -- Reduce counter
    RemoveStacks(ability, caster, modifier_souls_counter, engorge_damage_soul_count)
end

--[[
    Called once for each unit affected by presence
]]
function DarkLordPresenceTick(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local modifier = keys.modifier
    local modifier_souls_counter = keys.modifier_souls_counter

    -- Parameters
    local souls_per_tick = ability:GetLevelSpecialValueFor("souls_per_tick", ability_level)

    if target:IsRealHero() then
        AddTemporarySouls(caster, modifier, modifier_souls_counter, souls_per_tick)
    end
end

--[[
    Add 'amount' stacks of 'modifier' to 'caster' and updates 'modifier_counter' to match the current
    number of stacks.
    Only adds souls if the caster has imba_nevermore_necromastery.
]]
function AddTemporarySouls(caster, modifier, modifier_counter, amount)
    local ability = caster:FindAbilityByName("imba_nevermore_necromastery")
    -- Do not add souls if necromastery is not learned
    if not ability then
        return nil
    end
    -- Increase number of temporary souls and update the counter buff
    AddStacks(ability, caster, caster, modifier_counter, amount, true)
    
    --Apply a dummy buff to keep track of individual soul durations.
    ability:ApplyDataDrivenModifier(caster, caster, modifier, nil)
end

--[[
    Create a shadowraze at 'point' with 'radius'.
    Returns the true if a hero was hit by this raze
]]
function ShadowrazeCreateRaze(keys, point, radius)
    local caster = keys.caster
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    -- if the caster does not have this ability, we can't use our modifiers??
    -- not sure how to avoid this in a nice way
    local ability_near_raze = caster:FindAbilityByName(keys.near_raze)
    if not ability_near_raze then
        return nil
    end
    local ability_dark_lord = caster:FindAbilityByName(keys.presence_of_the_dark_lord)
    local dark_lord_level = ability_dark_lord:GetLevel()

    -- Modifiers and effects
    local modifier_combo = keys.modifier_combo
    local modifier_souls_counter = keys.modifier_souls_counter
    local modifier_temp_souls_counter = keys.modifier_temp_souls_counter
    local modifier_raze_no_cooldown = keys.modifier_raze_no_cooldown
    local modifier_raze_refresh_cooldown = keys.modifier_raze_refresh_cooldown
    local particle_raze = keys.particle_raze
    local sound_raze = keys.sound_raze

    -- Parameters
    local base_damage = ability:GetLevelSpecialValueFor("raze_damage", ability_level)
    local soul_damage_bonus = ability:GetLevelSpecialValueFor("soul_damage_bonus", ability_level)
    local souls = caster:GetModifierStackCount(modifier_souls_counter, caster) + caster:GetModifierStackCount(modifier_temp_souls_counter, caster)
    local damage = base_damage + soul_damage_bonus * souls
    local damage_type = ability:GetAbilityDamageType()
    local dark_lord_max_stack_count = ability_dark_lord:GetLevelSpecialValueFor("raze_debuff_max_stacks", dark_lord_level - 1)

    -- Raze particles and sound
    local raze_pfx = ParticleManager:CreateParticle(particle_raze, PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(raze_pfx, 0, point)
    ParticleManager:SetParticleControl(raze_pfx, 1, point)
    ParticleManager:ReleaseParticleIndex(raze_pfx)
    caster:EmitSound(sound_raze)

    
    -- Variable setup for raze
    local can_refresh = not caster:HasModifier(modifier_raze_refresh_cooldown)
    local no_cooldown_buff_active = caster:HasModifier(modifier_raze_no_cooldown)
    local hero_hit = false

    -- Find raze targets hit
    local enemies = FindUnitsInRadius(caster:GetTeam(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _, enemy in pairs(enemies) do

        -- Check for raze combos
        if enemy:IsRealHero() then
            -- Register that a hero was hit
            hero_hit = true

            -- Apply presence of the dark lord debuff if it is learned
            if dark_lord_level > 0 then
                local modifier_dark_lord = keys.modifier_dark_lord_raze
                local dark_lord_stack_count = 0
                -- Check if enemy is already debuffed
                if enemy:HasModifier(modifier_dark_lord) then
                    dark_lord_stack_count = enemy:GetModifierStackCount(modifier_dark_lord, caster)
                end

                -- Increase stack count if below 3
                if dark_lord_stack_count < dark_lord_max_stack_count then
                    dark_lord_stack_count = dark_lord_stack_count + 1
                end

                -- Remove and reapply debuff to refresh stack
                ability_dark_lord:ApplyDataDrivenModifier(caster, enemy, modifier_dark_lord, {})
                enemy:SetModifierStackCount(modifier_dark_lord, caster, dark_lord_stack_count)
            end

            -- Add combo modifier stack to enemy
            local stack_count = 0
            if enemy:HasModifier(modifier_combo) then
                stack_count = enemy:GetModifierStackCount(modifier_combo, caster)
                -- Remove combo modifier to refresh its duration
                enemy:RemoveModifierByNameAndCaster(modifier_combo, caster)
            end
            ability_near_raze:ApplyDataDrivenModifier(caster, enemy, modifier_combo, {})
            stack_count = stack_count + 1
            enemy:SetModifierStackCount(modifier_combo, caster, stack_count)

            -- Check number of combo stacks on this enemy hero
            if stack_count >= 3 then
                -- Sufficient stacks for raze refresh
                if can_refresh and not no_cooldown_buff_active then
                    -- Refresh razes, add cooldown modifier to caster and remove combo modifier
                    RefreshRazes(keys)
                    ability_near_raze:ApplyDataDrivenModifier(caster, caster, modifier_raze_refresh_cooldown, {})
                    enemy:RemoveModifierByNameAndCaster(modifier_combo, caster)
                end
            end
        end

        -- Apply damage AFTER combo check to allow combos on heroes that die from the raze damage
        ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = damage_type})
    end

    return hero_hit
end

--[[
    Refresh all razes. 'keys' needs to contain the necessary ability names
]]
function RefreshRazes(keys)
    local caster = keys.caster
    RefreshAbilityIfPresent(caster, keys.near_raze)
    RefreshAbilityIfPresent(caster, keys.medium_raze)
    RefreshAbilityIfPresent(caster, keys.far_raze)
end

--[[
    Refreshes ability with ability_name for caster if the caster has this ability
]]
function RefreshAbilityIfPresent(caster, ability_name)
    -- Hopefully this avoids errors if a hero only has some razes learned
    local ability = caster:FindAbilityByName(ability_name)
    if ability then
        ability:EndCooldown()
    end
end

--[[
    Update levels of all shadowraze abilities when leveling one of them
]]
function ShadowrazeLeveled(keys)
    local caster = keys.caster
    local ability = keys.ability
    local ability_level = ability:GetLevel()

    -- Update internal level variable
    if not caster.shadowraze_level then
        caster.shadowraze_level = 1
    elseif caster.shadowraze_level == ability_level then
        return nil
    else
        caster.shadowraze_level = ability_level
    end

    -- Set levels of all shadowraze abilities
    SetAbilityLevelIfPresent(caster, keys.near_raze, ability_level)
    SetAbilityLevelIfPresent(caster, keys.medium_raze, ability_level)
    SetAbilityLevelIfPresent(caster, keys.far_raze, ability_level)
end

--[[
    Set level of ability with ability_namy to level for caster if the caster has this ability
]]
function SetAbilityLevelIfPresent(caster, ability_name, level)
    local ability = caster:FindAbilityByName(ability_name)
    if ability then
        ability:SetLevel(level)
    end
end

function Shadowraze1Cast(keys)
    local caster = keys.caster
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local modifier_raze_no_cooldown = keys.modifier_raze_no_cooldown

    -- Parameters
    local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
    local raze_point = caster:GetAbsOrigin()

    -- Create the raze and track if a hero was hit
    local hero_hit = ShadowrazeCreateRaze(keys, raze_point, radius)

   -- If caster has the no cd buff, refresh all razes if an enemy was hit. Remove buff if not.
    local no_cooldown_buff_active = caster:HasModifier(modifier_raze_no_cooldown)
    if no_cooldown_buff_active then
        if hero_hit then
            RefreshRazes(keys)
        else
            caster:RemoveModifierByNameAndCaster(modifier_raze_no_cooldown, caster)
        end
    end 
end

function Shadowraze2Cast(keys)
    local caster = keys.caster
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local modifier_raze_no_cooldown = keys.modifier_raze_no_cooldown

    -- Parameters
    local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
    local distance = ability:GetLevelSpecialValueFor("distance", ability_level)
    local raze_amount = ability:GetLevelSpecialValueFor("raze_amount", ability_level)

    -- Find raze points
    local raze_point
    local caster_loc = caster:GetAbsOrigin()
    local forward_vector = caster:GetForwardVector()
    local hero_hit = false
    for i=0, (raze_amount - 1) do
        raze_point = RotatePosition(caster_loc, QAngle(0, i * 360 / raze_amount, 0), caster_loc + forward_vector * distance)
        -- Create raze and track if a hero has been hit
        hero_hit = ShadowrazeCreateRaze(keys, raze_point, radius) or hero_hit
    end

    -- If caster has the no cd buff, refresh all razes if an enemy was hit. Remove buff if not.
    local no_cooldown_buff_active = caster:HasModifier(modifier_raze_no_cooldown)
    if no_cooldown_buff_active then
        if hero_hit then
            RefreshRazes(keys)
        else
            caster:RemoveModifierByNameAndCaster(modifier_raze_no_cooldown, caster)
        end
    end
end

function Shadowraze3Cast(keys)
    local caster = keys.caster
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local modifier_raze_no_cooldown = keys.modifier_raze_no_cooldown

    -- Parameters
    local radius = ability:GetLevelSpecialValueFor("initial_radius", ability_level)
    local distance = ability:GetLevelSpecialValueFor("initial_distance", ability_level)
    local radius_inc_per_raze = ability:GetLevelSpecialValueFor("radius_inc_per_raze", ability_level)
    local raze_amount = ability:GetLevelSpecialValueFor("raze_amount", ability_level)

    -- Find raze points
    local raze_point
    local caster_loc = caster:GetAbsOrigin()
    local forward_vector = caster:GetForwardVector()
    local hero_hit = false
    for i=0, (raze_amount - 1) do
        raze_point = caster_loc + forward_vector * distance
        -- Create raze and track if a hero has been hit
        hero_hit = ShadowrazeCreateRaze(keys, raze_point, radius) or hero_hit
        -- Update for next raze
        distance = distance + 2 * radius + radius_inc_per_raze
        radius = radius + radius_inc_per_raze
    end

    -- If caster has the no cd buff, refresh all razes if an enemy was hit. Remove buff if not.
    local no_cooldown_buff_active = caster:HasModifier(modifier_raze_no_cooldown)
    if no_cooldown_buff_active then
        if hero_hit then
            RefreshRazes(keys)
        else
            caster:RemoveModifierByNameAndCaster(modifier_raze_no_cooldown, caster)
        end
    end
end

function RequiemCast(keys)
    local caster = keys.caster
    local caster_loc = caster:GetAbsOrigin()
    local ability = keys.ability
    local ability_aux = caster:FindAbilityByName(keys.ability_aux)
    local ability_level = ability:GetLevel() - 1
    local modifier_temp_souls = keys.modifier_temp_souls
    local modifier_souls_counter = keys.modifier_souls_counter
    local modifier_temp_souls_counter = keys.modifier_temp_souls_counter
    local particle_caster = keys.particle_caster_souls
    local particle_ground = keys.particle_caster_ground
    local particle_lines = keys.particle_lines
    local particle_lines_dummy = keys.particle_lines_dummy
    local scepter = HasScepter(caster)
    local death_cast = keys.death_cast

    -- Parameters
    local soul_conversion = ability:GetLevelSpecialValueFor("soul_conversion", ability_level)
    local line_width_start = ability:GetLevelSpecialValueFor("line_width_start", ability_level)
    local line_width_end = ability:GetLevelSpecialValueFor("line_width_end", ability_level)
    local line_speed = ability:GetLevelSpecialValueFor("line_speed", ability_level)
    local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
    local souls
    local soul_death_release = ability:GetLevelSpecialValueFor("soul_death_release", ability_level)
    local scepter_release_time = radius / line_speed

    -- If this was cast on death, we are responsible for removing souls
    if death_cast == 1 then
        -- Reduce soul and temporary soul stacks
        local current_stack = caster:GetModifierStackCount(modifier_souls_counter, caster)
        if current_stack then
            caster:SetModifierStackCount(modifier_souls_counter, caster, math.ceil(current_stack * soul_death_release))
        end
        current_stack = caster:GetModifierStackCount(modifier_temp_souls_counter, caster)
        if current_stack then
            caster:SetModifierStackCount(modifier_temp_souls_counter, caster, math.ceil(current_stack * soul_death_release))
        end
    end

    --Get number of souls
    souls = caster:GetModifierStackCount(modifier_souls_counter, caster) + caster:GetModifierStackCount(modifier_temp_souls_counter, caster)
    local lines = math.ceil(souls / soul_conversion)

    -- Remove all temporary souls. They are consumed regardless of death
    caster:RemoveModifierByName(modifier_temp_souls_counter)
    while caster:HasModifier(modifier_temp_souls) do
        caster:RemoveModifierByName(modifier_temp_souls)
    end

    -- Sound and particle effects
    caster:EmitSound(keys.requiem_cast_sound)
    local pfx_caster = ParticleManager:CreateParticle(particle_caster, PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(pfx_caster, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx_caster, 1, Vector(lines, 0, 0))
    ParticleManager:SetParticleControl(pfx_caster, 2, caster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(pfx_caster)
    local pfx_ground = ParticleManager:CreateParticle(particle_ground, PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(pfx_caster, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx_ground, 1, Vector(lines, 0, 0))
    ParticleManager:ReleaseParticleIndex(pfx_ground)
    local pfx_line

    -- Create projectiles
    local forward_vector = caster:GetForwardVector()
    local line_targets = {}
    local next_line_target
    local next_line_velocity
    local projectile_info
    local pfx_projectile
    for i=0, (lines - 1) do
        -- Find points for projectiles
        next_line_target = RotatePosition(caster_loc, QAngle(0, i * 360 / lines, 0), caster_loc + forward_vector * radius)
        line_targets[i] = next_line_target
        -- Calculate velocity from point vectors and speed
        next_line_velocity = (next_line_target - caster_loc):Normalized() * line_speed
        projectile_info = {
            Ability = ability,
            EffectName = particle_lines_dummy,
            vSpawnOrigin = caster_loc,
            fDistance = radius,
            fStartRadius = line_width_start,
            fEndRadius = line_width_end,
            Source = caster,
            bHasFrontalCone = false,
            bReplaceExisting = false,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            bDeleteOnHit = false,
            vVelocity = next_line_velocity,
            bProvidesVision = false
        }
        -- Create the projectile
        ProjectileManager:CreateLinearProjectile(projectile_info)
        -- Create the particle
        pfx_line = ParticleManager:CreateParticle(particle_lines, PATTACH_ABSORIGIN, caster)
        ParticleManager:SetParticleControl(pfx_line, 0, caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(pfx_line, 1, next_line_velocity)
        ParticleManager:SetParticleControl(pfx_line, 2, Vector(0, scepter_release_time, 0))
        ParticleManager:ReleaseParticleIndex(pfx_line)
    end

    -- Do scepter effect if we have it and it was not a death cast
    if scepter and death_cast == 0 then
        local next_line_direction
        local next_line_length
        local next_line_particle_duration
        Timers:CreateTimer(scepter_release_time, function()
            -- Update caster location in case he has moved
            caster_loc = caster:GetAbsOrigin()
            -- Go through the targets from before and create projectiles that fly back to caster
            for i, line_target in pairs(line_targets) do
                next_line_direction = caster_loc - line_target
                next_line_length = next_line_direction:Length()
                next_line_velocity = next_line_direction:Normalized() * next_line_length / scepter_release_time
                projectile_info = {
                    Ability = ability_aux,
                    EffectName = particle_lines_dummy,
                    vSpawnOrigin = line_target,
                    fDistance = next_line_length,
                    fStartRadius = line_width_start,
                    fEndRadius = line_width_end,
                    Source = caster,
                    bHasFrontalCone = false,
                    bReplaceExisting = false,
                    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
                    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                    bDeleteOnHit = false,
                    vVelocity = next_line_velocity,
                    bProvidesVision = false
                }
                -- Create the projectile
                ProjectileManager:CreateLinearProjectile(projectile_info)
                -- Create the particle
                pfx_line = ParticleManager:CreateParticle(particle_lines, PATTACH_ABSORIGIN, caster)
                ParticleManager:SetParticleControl(pfx_line, 0, line_target)
                ParticleManager:SetParticleControl(pfx_line, 1, next_line_velocity)
                ParticleManager:SetParticleControl(pfx_line, 2, Vector(0, scepter_release_time, 0))
                ParticleManager:ReleaseParticleIndex(pfx_line)
            end
        end)
    end
end

function RequiemProjectileHitOutward(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local modifier_enemy = keys.modifier_enemy
    local modifier_screen = keys.modifier_enemy_screen
    local modifier_ignore_damage = keys.modifier_ignore_damage
    local modifier_raze_no_cooldown = keys.modifier_raze_no_cooldown

    -- Parameters
    local damage = ability:GetLevelSpecialValueFor("line_damage", ability_level)
    local damage_type = ability:GetAbilityDamageType()
    local raze_no_cd_duration = ability:GetLevelSpecialValueFor("raze_no_cd_duration", ability_level)

    -- Apply enemy modifiers
    ability:ApplyDataDrivenModifier(caster, target, modifier_enemy, {})
    ability:ApplyDataDrivenModifier(caster, target, modifier_screen, {})
    ability:ApplyDataDrivenModifier(caster, target, modifier_ignore_damage, {})

    -- Apply no raze cooldown modifier to caster
    if target:IsRealHero() then
        local no_cd_stacks = 0
        if caster:HasModifier(modifier_raze_no_cooldown) then
            no_cd_stacks = caster:GetModifierStackCount(modifier_raze_no_cooldown, caster)
        end
        no_cd_stacks = no_cd_stacks + 1
        --caster:RemoveModifierByNameAndCaster(modifier_raze_no_cooldown, caster)
        ability:ApplyDataDrivenModifier(caster, caster, modifier_raze_no_cooldown, {duration = raze_no_cd_duration * no_cd_stacks})
        caster:SetModifierStackCount(modifier_raze_no_cooldown, caster, no_cd_stacks)
    end

    -- Apply damage
    ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = damage_type})
end

function RequiemProjectileHitInward(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = caster:FindAbilityByName(keys.ability_main)
    -- If the ability is gone (Random OMG), do nothing
    if not ability then
        return nil
    end
    local ability_level = ability:GetLevel() - 1
    local modifier_enemy = keys.modifier_enemy
    local modifier_ignore_damage = keys.modifier_ignore_damage
    local modifier_raze_no_cooldown = keys.modifier_raze_no_cooldown
    local caster_health = caster:GetHealth()    

    -- Parameters
    local damage = ability:GetLevelSpecialValueFor("line_damage", ability_level)
    local damage_type = ability:GetAbilityDamageType()
    local raze_no_cd_duration = ability:GetLevelSpecialValueFor("raze_no_cd_duration", ability_level)
    local heal_factor = ability:GetLevelSpecialValueFor("heal_pct_scepter", ability_level) / 100

    -- Apply enemy modifiers
    ability:ApplyDataDrivenModifier(caster, target, modifier_enemy, {})
    ability:ApplyDataDrivenModifier(caster, target, modifier_ignore_damage, {})

    -- Apply no raze cooldown modifier to caster
    if target:IsRealHero() then
        -- Apply screen black modifier
        ability:ApplyDataDrivenModifier(caster, target, modifier_screen, {})
        -- Add stack of no cooldown raze modifier to caster
        local no_cd_stacks = 0
        if caster:HasModifier(modifier_raze_no_cooldown) then
            no_cd_stacks = caster:GetModifierStackCount(modifier_raze_no_cooldown, caster)
        end
        no_cd_stacks = no_cd_stacks + 1
        --caster:RemoveModifierByNameAndCaster(modifier_raze_no_cooldown, caster)
        ability:ApplyDataDrivenModifier(caster, caster, modifier_raze_no_cooldown, {duration = raze_no_cd_duration * no_cd_stacks})
        caster:SetModifierStackCount(modifier_raze_no_cooldown, caster, no_cd_stacks)
    end

    -- Apply damage
    local damage_done = ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = damage_type})
    caster:SetHealth(caster_health + damage_done * heal_factor)
end

function RequiemDebuffCreated( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local particle_screen = keys.particle_screen

    -- Play particle to hero owners
    if target:IsRealHero() then
        target.requiem_screen_particle = ParticleManager:CreateParticleForPlayer(particle_screen, PATTACH_EYES_FOLLOW, target, PlayerResource:GetPlayer(target:GetPlayerID()))
    end
end

function RequiemDebuffDestroyed( keys )
    local target = keys.target

    -- Destroy particle
    if target.requiem_screen_particle then
        ParticleManager:DestroyParticle(target.requiem_screen_particle, true)
    end
end

function ShadowrazeNoCooldownBuffCreated(keys)
    RefreshRazes(keys)
end