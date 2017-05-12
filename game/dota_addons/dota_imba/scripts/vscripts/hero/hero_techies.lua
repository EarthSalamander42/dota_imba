-- Author: Shush
-- Date: 2/5/2017

CreateEmptyTalents("techies")


------------------------------
--     PROXIMITY MINE       --
------------------------------
imba_techies_proximity_mine = class({})

function imba_techies_proximity_mine:IsHiddenWhenStolen()
    return false
end

function imba_techies_proximity_mine:IsNetherWardStealable()
    return false
end



function imba_techies_proximity_mine:CastFilterResultLocation(location)
    if IsServer() then        
        -- Ability properties
        local caster = self:GetCaster()
        local ability = self

        -- Ability specials
        local mine_distance = ability:GetSpecialValueFor("mine_distance")
        local trigger_range = ability:GetSpecialValueFor("trigger_range")

        -- #1 Talent: Trigger range increase
        trigger_range = trigger_range + caster:FindTalentValue("special_bonus_imba_techies_1")

        -- Radius
        local radius = mine_distance + trigger_range

        -- Look for nearby mines
        local friendly_units = FindUnitsInRadius(caster:GetTeamNumber(),
                                                location,
                                                nil,
                                                radius,
                                                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                                DOTA_UNIT_TARGET_OTHER,
                                                DOTA_UNIT_TARGET_FLAG_NONE,
                                                FIND_ANY_ORDER,
                                                false)

        local mine_found = false

        -- Search and see if mines were found        
        for _,unit in pairs(friendly_units) do            
            if unit:GetUnitName() == "npc_imba_techies_proximity_mine" then
                mine_found = true
                break
            end
        end

        if mine_found then
            return UF_FAIL_CUSTOM
        else
            return UF_SUCCESS
        end
    end
end

function imba_techies_proximity_mine:GetCustomCastErrorLocation(location)    
    return "Cannot place mine in range of other mines"    
end

function imba_techies_proximity_mine:GetAOERadius()
    local caster = self:GetCaster()
    local ability = self

    local trigger_range = ability:GetSpecialValueFor("trigger_range")
    local mine_distance = ability:GetSpecialValueFor("mine_distance")

    -- #1 Talent: Trigger range increase
    trigger_range = trigger_range + caster:FindTalentValue("special_bonus_imba_techies_1")

    return trigger_range + mine_distance
end

function imba_techies_proximity_mine:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self    
    local target_point = self:GetCursorPosition()
    local cast_response = {"techies_tech_setmine_01", "techies_tech_setmine_02", "techies_tech_setmine_04", "techies_tech_setmine_08", "techies_tech_setmine_09", "techies_tech_setmine_10", "techies_tech_setmine_11", "techies_tech_setmine_13", "techies_tech_setmine_16", "techies_tech_setmine_17", "techies_tech_setmine_18", "techies_tech_setmine_19", "techies_tech_setmine_20", "techies_tech_setmine_30", "techies_tech_setmine_32", "techies_tech_setmine_33", "techies_tech_setmine_34", "techies_tech_setmine_38", "techies_tech_setmine_45", "techies_tech_setmine_46", "techies_tech_setmine_47", "techies_tech_setmine_48", "techies_tech_setmine_50", "techies_tech_setmine_51", "techies_tech_setmine_54", "techies_tech_cast_02", "techies_tech_cast_03", "techies_tech_setmine_05", "techies_tech_setmine_06", "techies_tech_setmine_07", "techies_tech_setmine_14", "techies_tech_setmine_21", "techies_tech_setmine_22", "techies_tech_setmine_23", "techies_tech_setmine_24", "techies_tech_setmine_25", "techies_tech_setmine_26", "techies_tech_setmine_28", "techies_tech_setmine_29", "techies_tech_setmine_35", "techies_tech_setmine_36", "techies_tech_setmine_37", "techies_tech_setmine_39", "techies_tech_setmine_41", "techies_tech_setmine_42", "techies_tech_setmine_43", "techies_tech_setmine_44", "techies_tech_setmine_52"}
    local sound_cast = "Hero_Techies.LandMine.Plant"    

    -- Ability special
    local mine_placement_count = ability:GetSpecialValueFor("mine_placement_count")
    local mine_distance = ability:GetSpecialValueFor("mine_distance")    

    -- Play cast response
    EmitSoundOn(cast_response[math.random(1, #cast_response)], caster)

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)

    -- Determine mine locations, depending on mine count
    local direction = (target_point - caster:GetAbsOrigin()):Normalized()

    -- #7 Talent: Proximity Mine now scatters additional mines
    mine_placement_count = mine_placement_count + caster:FindTalentValue("special_bonus_imba_techies_7")

    -- 3 mines are placed in a triangle around the cast point
    if mine_placement_count == 3 then
        local degree = 120   

        -- Calculate location of the first mine, ahead of the target point
        local mine_spawn_point = target_point + direction * mine_distance

        for i = 1, mine_placement_count do
            -- Prepare the QAngle
            local qangle = QAngle(0, (i-1) * degree, 0)

            -- Rotate the mine point
            local mine_point = RotatePosition(target_point, qangle, mine_spawn_point)

            -- Plant a mine!
            PlantProximityMine(caster, ability, mine_point)
        end

    -- 4 mines are placed in the form of a X
    elseif mine_placement_count == 4 then
        local degree = 90

        -- Calculate location of the first mine, ahead of the target point
        local mine_spawn_point = target_point + direction * mine_distance        

        for i = 1, mine_placement_count do
            -- Prepare the QAngle
            local qangle = QAngle(0, (i-1) * degree, 0)

            -- Rotate the mine point
            local mine_point = RotatePosition(target_point, qangle, mine_spawn_point)

            -- Plant a mine!
            PlantProximityMine(caster, ability, mine_point)
        end
    

    -- 5 mines are placed in the form of a X, with a mine in the center of it
    elseif mine_placement_count == 5 then
        local degree = 90

        -- Calculate location of the first mine, ahead of the target point
        local mine_spawn_point = target_point + direction * mine_distance        

        for i = 1, mine_placement_count-1 do
            -- Prepare the QAngle
            local qangle = QAngle(0, (i-1) * degree, 0)

            -- Rotate the mine point
            local mine_point = RotatePosition(target_point, qangle, mine_spawn_point)

            -- Plant a mine!
            PlantProximityMine(caster, ability, mine_point)
        end

        -- A final mine is planted at the target point
        PlantProximityMine(caster, ability, target_point)

    -- 6 mines are placed in a circle, with a mine in the center of it. #7 Talent can increase the amount of mines in the outer circle
    else
        local degree = 360 / (mine_placement_count-1)
    
        -- Calculate location of the first mine, ahead of the target point
        local mine_spawn_point = target_point + direction * mine_distance        

        for i = 1, mine_placement_count-1 do
            -- Prepare the QAngle
            local qangle = QAngle(0, (i-1) * degree, 0)

            -- Rotate the mine point
            local mine_point = RotatePosition(target_point, qangle, mine_spawn_point)

            -- Plant a mine!
            PlantProximityMine(caster, ability, mine_point)
        end

        -- A final mine is planted at the target point
        PlantProximityMine(caster, ability, target_point)        
    end
end

function PlantProximityMine(caster, ability, spawn_point)
    local mine_ability = "imba_techies_proximity_mine_trigger"

    -- Create the mine unit
    local mine = CreateUnitByName("npc_imba_techies_proximity_mine", spawn_point, true, caster, caster, caster:GetTeamNumber())

    -- Set the mine's team to be the same as the caster
    local playerID = caster:GetPlayerID()
    mine:SetControllableByPlayer(playerID, true)

    -- Set the mine's ability to be the same level as the planting ability
    if mine:HasAbility(mine_ability) then
        local mine_ability_handler = mine:FindAbilityByName(mine_ability)
        if mine_ability_handler then
            mine_ability_handler:SetLevel(ability:GetLevel())
        end
    end

    -- Set the mine's owner to be the caster
    mine:SetOwner(caster)
end



------------------------------
--     PROXIMITY MINE AI    --
------------------------------
imba_techies_proximity_mine_trigger = class({})
LinkLuaModifier("modifier_imba_proximity_mine", "hero/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_proximity_mine_building_res", "hero/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)


function imba_techies_proximity_mine_trigger:GetIntrinsicModifierName()
    return "modifier_imba_proximity_mine"
end

-- Proximity mine states modifier
modifier_imba_proximity_mine = class({})

function modifier_imba_proximity_mine:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()    
        self.owner = self.caster:GetOwner()
        self.kill_response = {"techies_tech_mineblowsup_01", "techies_tech_mineblowsup_02", "techies_tech_mineblowsup_03", "techies_tech_mineblowsup_04", "techies_tech_mineblowsup_05", "techies_tech_mineblowsup_06", "techies_tech_mineblowsup_08", "techies_tech_mineblowsup_09", "techies_tech_minekill_01", "techies_tech_minekill_02", "techies_tech_minekill_03"}
        self.sound_prime = "Hero_Techies.LandMine.Priming"
        self.sound_explosion = "Hero_Techies.LandMine.Detonate"    
        self.particle_mine = "particles/units/heroes/hero_techies/techies_land_mine.vpcf"       
        self.particle_explosion = "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf"    
        self.modifier_building_res = "modifier_imba_proximity_mine_building_res"
        self.modifier_electrocharge = "modifier_imba_statis_trap_electrocharge"
        self.modifier_inflammable = "modifier_imba_remote_mine_inflammable"
        self.modifier_sign = "modifier_imba_minefield_sign_detection"
        self.detonate_ability = "imba_techies_remote_mine_pinpoint_detonation"

        -- Ability specials
        self.explosion_delay = self.ability:GetSpecialValueFor("explosion_delay")
        self.mine_damage = self.ability:GetSpecialValueFor("mine_damage")
        self.explosion_range = self.ability:GetSpecialValueFor("explosion_range")
        self.trigger_range = self.ability:GetSpecialValueFor("trigger_range")
        self.activation_delay = self.ability:GetSpecialValueFor("activation_delay")
        self.building_damage_pct = self.ability:GetSpecialValueFor("building_damage_pct")    
        self.buidling_damage_duration = self.ability:GetSpecialValueFor("buidling_damage_duration")
        self.tick_interval = self.ability:GetSpecialValueFor("tick_interval")
        self.fow_radius = self.ability:GetSpecialValueFor("fow_radius")
        self.fow_duration = self.ability:GetSpecialValueFor("fow_duration")

        -- #1 Talent: Trigger range increase
        self.trigger_range = self.trigger_range + self.caster:FindTalentValue("special_bonus_imba_techies_1")

        -- Add mine particle effect    
        local particle_mine_fx = ParticleManager:CreateParticle(self.particle_mine, PATTACH_ABSORIGIN_FOLLOW, self.caster)
        ParticleManager:SetParticleControl(particle_mine_fx, 0, self.caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle_mine_fx, 3, self.caster:GetAbsOrigin())
        self:AddParticle(particle_mine_fx, false, false, -1, false, false)

        -- Set the mine as inactive
        self.active = false
        self.triggered = false
        self.trigger_time = 0

        if IsServer() then

            -- Wait for the mine to activate
            Timers:CreateTimer(self.activation_delay, function()
                -- Mark mine as active
                self.active = true

                -- Start looking around for enemies
                self:StartIntervalThink(self.tick_interval)
            end)
        end
    end
end

function modifier_imba_proximity_mine:IsHidden() return true end
function modifier_imba_proximity_mine:IsPurgable() return false end
function modifier_imba_proximity_mine:IsDebuff() return false end

function modifier_imba_proximity_mine:OnIntervalThink()
    if IsServer() then     
        -- If the mine was killed, remove the modifier
        if not self.caster:IsAlive() then
            self:Destroy()            
        end        

        -- If the mine is under the sign effect, reset possible triggers and do nothing
        if self.caster:HasModifier(self.modifier_sign) then
            self.triggered = false
            self.trigger_time = 0
            self.hidden_by_sign = true
            return nil                    
        end

        -- Look for nearby enemies
        local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
                                          self.caster:GetAbsOrigin(),
                                          nil,
                                          self.trigger_range,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
                                          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                          FIND_ANY_ORDER,
                                          false)

        if #enemies > 0 then
            local non_flying_enemies = false

            -- Check if there is at least one enemy that isn't flying
            for _,enemy in pairs(enemies) do
                if not enemy:HasFlyMovementCapability() then
                    non_flying_enemies = true
                    break
                end
            end

            -- At least one non-flying enemy found - mark as found
            if non_flying_enemies then
                self.enemy_found = true
            else
                self.enemy_found = false
            end
        else
            self.enemy_found = false
        end      

        -- If the mine is not triggered, check if it should be triggered
        if not self.triggered then
            if self.enemy_found then
                self.triggered = true
                self.trigger_time = 0                          

                -- Play prime sound
                EmitSoundOn(self.sound_prime, self.caster)
            end

        -- If the mine was already triggered, check if it should stop or count time
        else
            if self.enemy_found then
                self.trigger_time = self.trigger_time + self.tick_interval

                -- Check if the mine should blow up
                if self.trigger_time >= self.explosion_delay then                    

                    local enemy_killed

                    -- BLOW UP TIME! Play explosion sound
                    EmitSoundOn(self.sound_explosion, self.caster)

                    -- Add particle explosion effect
                    local particle_explosion_fx = ParticleManager:CreateParticle(self.particle_explosion, PATTACH_WORLDORIGIN, self.caster)
                    ParticleManager:SetParticleControl(particle_explosion_fx, 0, self.caster:GetAbsOrigin())
                    ParticleManager:SetParticleControl(particle_explosion_fx, 1, self.caster:GetAbsOrigin())
                    ParticleManager:SetParticleControl(particle_explosion_fx, 2, Vector(self.explosion_range, 1, 1))
                    ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

                    -- Deal damage to nearby non-flying enemies
                    for _,enemy in pairs(enemies) do

                        -- If an enemy doesn't have flying movement, ignore it, otherwise continue
                        if not enemy:HasFlyMovementCapability() then

                            -- If the enemy is a building, reduce damage to it
                            local damage = self.mine_damage
                            if enemy:IsBuilding() then
                                damage = damage * self.building_damage_pct * 0.01
                            end

                            -- Deal damage
                            local damageTable = {victim = enemy,
                                                 attacker = self.caster, 
                                                 damage = damage,
                                                 damage_type = DAMAGE_TYPE_MAGICAL,
                                                 ability = self.ability
                                                 }
        
                            ApplyDamage(damageTable)

                            -- If the enemy was a building, give it magical protection
                            if enemy:IsBuilding() and not enemy:HasModifier(self.modifier_building_res) then
                                enemy:AddNewModifier(self.caster, self.ability, self.modifier_building_res, {duration = self.buidling_damage_duration})
                            end

                            -- If the enemy has Electrocharge (from Stasis Trap), refresh it and add a stack
                            if enemy:HasModifier(self.modifier_electrocharge) then
                                local modifier_electrocharge_handler = enemy:FindModifierByName(self.modifier_electrocharge)
                                if modifier_electrocharge_handler then
                                    modifier_electrocharge_handler:IncrementStackCount()
                                    modifier_electrocharge_handler:ForceRefresh()
                                end
                            end

                            -- Find Remote Mines in the explosion radius 
                            local remote_mines = FindUnitsInRadius(self.caster:GetTeamNumber(),
                                                                   self.caster:GetAbsOrigin(),
                                                                   nil,
                                                                   self.trigger_range,
                                                                   DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                                                   DOTA_UNIT_TARGET_OTHER,
                                                                   DOTA_UNIT_TARGET_FLAG_NONE,
                                                                   FIND_ANY_ORDER,
                                                                   false)

                            -- Give them inflammable stacks
                            for _,remote_mine in pairs(remote_mines) do
                                if remote_mine:GetUnitName() == "npc_imba_techies_remote_mine" then
                                    if not remote_mine:HasModifier(self.modifier_inflammable) and remote_mine:HasAbility(self.detonate_ability) then
                                        local detonate_ability_handler = remote_mine:FindAbilityByName(self.detonate_ability)
                                        if detonate_ability_handler then
                                            local inflammable_duration = detonate_ability_handler:GetSpecialValueFor("inflammable_duration")
                                            remote_mine:AddNewModifier(self.caster, detonate_ability_handler, self.modifier_inflammable, {duration = inflammable_duration})
                                        end
                                    end

                                    local modifier_inflammable_handler = remote_mine:FindModifierByName(self.modifier_inflammable)
                                    if modifier_inflammable_handler then
                                        modifier_inflammable_handler:IncrementStackCount()
                                        modifier_inflammable_handler:ForceRefresh()
                                    end
                                end
                            end

                            -- See if the enemy died from the mine
                            Timers:CreateTimer(FrameTime(), function()
                                if not enemy:IsAlive() then                                    
                                    enemy_killed = true                                    
                                end
                            end)
                        end
                    end

                    -- If an enemy was killed from a mine, play kill response
                    Timers:CreateTimer(FrameTime()*2, function()                                                
                        if enemy_killed and RollPercentage(25) then
                            EmitSoundOn(self.kill_response[math.random(1, #self.kill_response)], self.owner)
                        end
                    end)                    

                    -- Apply flying vision at detonation point
                    AddFOWViewer(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), self.fow_radius, self.fow_duration, false)                    

                    -- Kill self and remove modifier
                    self.caster:Kill(self.ability, self.caster)
                    self:Destroy()
                end
            else
                self.triggered = false
                self.trigger_time = 0
            end
        end
    end
end    

function modifier_imba_proximity_mine:CheckState()
    local state

    if self.active and not self.triggered then
        state = {[MODIFIER_STATE_INVISIBLE] = true,
                 [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
    else
        state = {[MODIFIER_STATE_INVISIBLE] = false,
                 [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
    end

    return state
end

function modifier_imba_proximity_mine:GetPriority()
    return MODIFIER_PRIORITY_NORMAL
end


-- Building fortification modifier
modifier_imba_proximity_mine_building_res = class({})

function modifier_imba_proximity_mine_building_res:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()

    -- Ability specials
    self.building_magic_resistance = self.ability:GetSpecialValueFor("building_magic_resistance")
end

function modifier_imba_proximity_mine_building_res:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}

    return decFuncs
end

function modifier_imba_proximity_mine_building_res:GetModifierMagicalResistanceBonus()
    return self.building_magic_resistance
end

function modifier_imba_proximity_mine_building_res:IsHidden() return true end
function modifier_imba_proximity_mine_building_res:IsPurgable() return false end
function modifier_imba_proximity_mine_building_res:IsDebuff() return false end
    



------------------------------
--       STASIS TRAP        --
------------------------------
imba_techies_stasis_trap = class({})

function imba_techies_stasis_trap:IsHiddenWhenStolen()
    return false
end

function imba_techies_stasis_trap:IsNetherWardStealable()
    return false
end

function imba_techies_stasis_trap:GetAOERadius()
    local caster = self:GetCaster()
    local ability = self

    local root_range = ability:GetSpecialValueFor("root_range")
    return root_range
end

function imba_techies_stasis_trap:GetBehavior()
    local caster = self:GetCaster()

    -- #2 Talent: Stasis Traps can be placed within friendly creeps
    if caster:HasTalent("special_bonus_imba_techies_2") then
        return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
    else
        return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
    end
end

function imba_techies_stasis_trap:CastFilterResultTarget(target)    

    local caster = self:GetCaster()
    if target:GetTeamNumber() ~= caster:GetTeamNumber() then
        return UF_FAIL_FRIENDLY
    end

    if target:IsHero() then
        return UF_FAIL_HERO
    end

    if target:IsBuilding() then
        return UF_FAIL_BUILDING
    end

    return UF_SUCCESS
end

function imba_techies_stasis_trap:OnAbilityPhaseStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self  
    local target = self:GetCursorTarget()
    local target_point = self:GetCursorPosition()  
    local particle_cast = "particles/units/heroes/hero_techies/techies_stasis_trap_plant.vpcf"
    local particle_creep = "particles/hero/techies/techies_stasis_trap_plant_creep.vpcf"

    if target then
        -- If it was on a target, place effect in it
        local particle_creep_fx = ParticleManager:CreateParticle(particle_creep, PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControl(particle_creep_fx, 0, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle_creep_fx, 1, target:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle_creep_fx)
    
    -- If it was on a point in the ground, place effect
    else
        -- Add cast particle
        local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)
        ParticleManager:SetParticleControl(particle_cast_fx, 0, target_point)
        ParticleManager:SetParticleControl(particle_cast_fx, 1, target_point)
        ParticleManager:ReleaseParticleIndex(particle_cast_fx)
    end   

    return true
end

function imba_techies_stasis_trap:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self    
    local target = self:GetCursorTarget()
    local target_point = self:GetCursorPosition()  
    local particle_creep = "particles/hero/techies/techies_stasis_trap_plant_creep.vpcf"
    local cast_response = {"techies_tech_settrap_01", "techies_tech_settrap_02", "techies_tech_settrap_03", "techies_tech_settrap_04", "techies_tech_settrap_06", "techies_tech_settrap_07", "techies_tech_settrap_08", "techies_tech_settrap_09", "techies_tech_settrap_10", "techies_tech_settrap_11"}
    local sound_cast = "Hero_Techies.StasisTrap.Plant"

    -- Roll for a cast response
    if RollPercentage(75) then
        EmitSoundOn(cast_response[math.random(1,#cast_response)], caster)
    end

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)    

    -- Plant inside a creep (#2 Talent)
    if target then
        local modifier_stasis = target:AddNewModifier(target, ability, "modifier_imba_statis_trap", {})        
        if modifier_stasis then
            modifier_stasis.owner = caster
        end

        Timers:CreateTimer(1, function()
            if target:IsAlive() then                
                local particle_creep_fx = ParticleManager:CreateParticle(particle_creep, PATTACH_CUSTOMORIGIN_FOLLOW, target)                
                ParticleManager:SetParticleControlEnt(particle_creep_fx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
                ParticleManager:SetParticleControlEnt(particle_creep_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
                ParticleManager:ReleaseParticleIndex(particle_creep_fx)

                return 1
            else
                
                return nil
            end
        end)

    else -- Plant on the ground
        -- Plant trap
        local trap = CreateUnitByName("npc_imba_techies_stasis_trap", target_point, true, caster, caster, caster:GetTeamNumber())
        local trap_ability = "imba_techies_stasis_trap_trigger"

        -- Set the mine's team to be the same as the caster
        local playerID = caster:GetPlayerID()
        trap:SetControllableByPlayer(playerID, true)

        -- Set the mine's ability to be the same level as the planting ability
        if trap:HasAbility(trap_ability) then
            local trap_ability_handler = trap:FindAbilityByName(trap_ability)
            if trap_ability_handler then
                trap_ability_handler:SetLevel(ability:GetLevel())
            end
        end

        -- Set the mine's owner to be the caster
        trap:SetOwner(caster)    
    end    
end



------------------------------
--      STATIS TRAP AI      --
------------------------------
imba_techies_stasis_trap_trigger = class({})
LinkLuaModifier("modifier_imba_statis_trap", "hero/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_statis_trap_root", "hero/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_statis_trap_electrocharge", "hero/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_statis_trap_disarmed", "hero/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)


function imba_techies_stasis_trap_trigger:GetIntrinsicModifierName()
    return "modifier_imba_statis_trap" 
end

-- Statis Trap thinker modifier
modifier_imba_statis_trap = class({})


function modifier_imba_statis_trap:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.owner = self.caster:GetOwner()    
        self.sound_explosion = "Hero_Techies.StasisTrap.Stun"
        self.particle_explode = "particles/units/heroes/hero_techies/techies_stasis_trap_explode.vpcf"        
        self.modifier_root = "modifier_imba_statis_trap_root"
        self.modifier_electrocharge = "modifier_imba_statis_trap_electrocharge"
        self.modifier_disarmed = "modifier_imba_statis_trap_disarmed"
        self.modifier_sign = "modifier_imba_minefield_sign_detection"        
        self.modifier_inflammable = "modifier_imba_remote_mine_inflammable"
        self.detonate_ability = "imba_techies_remote_mine_pinpoint_detonation"

        -- Ability specials
        self.activate_delay = self.ability:GetSpecialValueFor("activate_delay")
        self.trigger_range = self.ability:GetSpecialValueFor("trigger_range")
        self.root_range = self.ability:GetSpecialValueFor("root_range")
        self.root_duration = self.ability:GetSpecialValueFor("root_duration")
        self.tick_rate = self.ability:GetSpecialValueFor("tick_rate")        
        self.flying_vision_duration = self.ability:GetSpecialValueFor("flying_vision_duration")

        -- Set variables
        self.active = false        

        -- Wait for activation
        Timers:CreateTimer(self.activate_delay, function()

            -- Mark trap as activated
            self.active = true

            -- Start thinking
            self:StartIntervalThink(self.tick_rate)            
        end)
    end
end

function modifier_imba_statis_trap:IsHidden() return true end
function modifier_imba_statis_trap:IsPurgable() return false end
function modifier_imba_statis_trap:IsDebuff() return false end

function modifier_imba_statis_trap:OnIntervalThink()
    if IsServer() then
        -- If the caster has the sign modifier, do nothing
        if self.caster:HasModifier(self.modifier_sign) then
            return nil
        end        

        -- Look for nearby enemies
        local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
                                          self.caster:GetAbsOrigin(),
                                          nil,
                                          self.trigger_range,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                          DOTA_UNIT_TARGET_FLAG_NO_INVIS,
                                          FIND_ANY_ORDER,
                                          false)

        if #enemies > 0 then
            -- Springing the trap! Play root sound
            EmitSoundOn(self.sound_explosion, self.caster)

            -- Add explosion particle
            local particle_explode = ParticleManager:CreateParticle(self.particle_explode, PATTACH_WORLDORIGIN, self.caster)
            ParticleManager:SetParticleControl(particle_explode, 0, self.caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_explode, 1, Vector(self.root_range, 1, 1))
            ParticleManager:SetParticleControl(particle_explode, 3, self.caster:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(particle_explode)            

            -- Find all units in radius
            enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
                                        self.caster:GetAbsOrigin(),
                                        nil,
                                        self.root_range,
                                        DOTA_UNIT_TARGET_TEAM_ENEMY,
                                        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                        DOTA_UNIT_TARGET_FLAG_NONE,
                                        FIND_ANY_ORDER,
                                        false)

            -- Root enemies nearby if not disarmed, and apply a electrocharge
            for _,enemy in pairs(enemies) do
                if not self.caster:HasModifier(self.modifier_disarmed) then
                    enemy:AddNewModifier(self.caster, self.ability, self.modifier_root, {duration = self.root_duration})
                end

                -- If the enemy is not yet afflicted with electrocharge, add it. Otherwise, add a stack
                if not enemy:HasModifier(self.modifier_electrocharge) then
                    enemy:AddNewModifier(self.caster, self.ability, self.modifier_electrocharge, {duration = self.root_duration})
                else
                    local modifier_electrocharge_handler = enemy:FindModifierByName(self.modifier_electrocharge)
                    if modifier_electrocharge_handler then
                        modifier_electrocharge_handler:IncrementStackCount()
                        modifier_electrocharge_handler:ForceRefresh()
                    end
                end
            end

            -- Find nearby Statis Traps and mark them as disarmed
            local mines = FindUnitsInRadius(self.caster:GetTeamNumber(),
                                            self.caster:GetAbsOrigin(),
                                            nil,
                                            self.root_range,
                                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                            DOTA_UNIT_TARGET_OTHER,
                                            DOTA_UNIT_TARGET_FLAG_NONE,
                                            FIND_ANY_ORDER,
                                            false)

            for _,mine in pairs(mines) do
                if mine:GetUnitName() == "npc_imba_techies_stasis_trap" and mine ~= self.caster then
                    mine:AddNewModifier(self.caster, self.ability, self.modifier_disarmed, {})
                end
            end

            -- #4 Talent: Stasis Traps grants charges of Inflammable to Remote mines
            if self.owner and self.owner:HasTalent("special_bonus_imba_techies_4") then
                -- Find Remote Mines in the explosion radius and give them inflammable stacks
                for _,mine in pairs(mines) do
                    if mine:GetUnitName() == "npc_imba_techies_remote_mine" then
                        if not mine:HasModifier(self.modifier_inflammable) and mine:HasAbility(self.detonate_ability) then
                            local detonate_ability_handler = mine:FindAbilityByName(self.detonate_ability)
                            if detonate_ability_handler then
                                local inflammable_duration = detonate_ability_handler:GetSpecialValueFor("inflammable_duration")
                                mine:AddNewModifier(self.caster, detonate_ability_handler, self.modifier_inflammable, {duration = inflammable_duration})
                            end
                        end

                        local modifier_inflammable_handler = mine:FindModifierByName(self.modifier_inflammable)
                        if modifier_inflammable_handler then
                            modifier_inflammable_handler:IncrementStackCount()
                            modifier_inflammable_handler:ForceRefresh()
                        end
                    end
                end
            end

            -- Apply flying vision
            AddFOWViewer(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), self.root_range, self.flying_vision_duration, false)

            -- Kill trap and destroy modifier
            self.caster:Kill(self.ability, self.caster)
            self:Destroy()
        end
    end
end

function modifier_imba_statis_trap:CheckState()
    if IsServer() then
        local state
        
        -- Planted inside a creep
        if self.caster:IsCreep() then
            return nil
        end

        -- Trap is invisible since activation
        if self.active then
            state = {[MODIFIER_STATE_INVISIBLE] = true,
                     [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
        else
            state = {[MODIFIER_STATE_INVISIBLE] = false,
                     [MODIFIER_STATE_NO_UNIT_COLLISION] = true}            
        end
        return state
    end
end


-- Root modifier
modifier_imba_statis_trap_root = class({})

function modifier_imba_statis_trap_root:CheckState()
    local state = {[MODIFIER_STATE_ROOTED] = true}
    return state
end

function modifier_imba_statis_trap_root:IsHidden() return false end
function modifier_imba_statis_trap_root:IsPurgable() return true end
function modifier_imba_statis_trap_root:IsDebuff() return true end    

function modifier_imba_statis_trap_root:GetStatusEffectName()
    return "particles/status_fx/status_effect_techies_stasis.vpcf"
end


-- Electrocharge modifier
modifier_imba_statis_trap_electrocharge = class({})

function modifier_imba_statis_trap_electrocharge:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()
        self.owner = self.caster:GetOwner()
        self.teamnumber = self.caster:GetTeamNumber()

        -- Ability specials
        self.base_magnetic_radius = self.ability:GetSpecialValueFor("base_magnetic_radius")
        self.base_magnetic_movespeed = self.ability:GetSpecialValueFor("base_magnetic_movespeed")
        self.magnetic_stack_radius = self.ability:GetSpecialValueFor("magnetic_stack_radius")
        self.magnetic_stack_movespeed = self.ability:GetSpecialValueFor("magnetic_stack_movespeed")

        -- #3 Talent: Electrocharge mines pull radius increase
        if self.owner then
            self.base_magnetic_radius = self.base_magnetic_radius + self.owner:FindTalentValue("special_bonus_imba_techies_3")        
        end

        -- Start thinking
        self:StartIntervalThink(FrameTime())
    end
end

function modifier_imba_statis_trap_electrocharge:IsHidden() return false end
function modifier_imba_statis_trap_electrocharge:IsPurgable() return true end
function modifier_imba_statis_trap_electrocharge:IsDebuff() return true end    

function modifier_imba_statis_trap_electrocharge:OnIntervalThink()
    if IsServer() then
        -- Determine movespeed and radius for this tick
        local stacks = self:GetStackCount()
        local movespeed = self.base_magnetic_movespeed + self.magnetic_stack_movespeed * stacks
        local radius = self.base_magnetic_radius + self.magnetic_stack_radius * stacks        

        -- Find all nearby mines
        local mines = FindUnitsInRadius(self.teamnumber,
                                        self.parent:GetAbsOrigin(),
                                        nil,
                                        radius,
                                        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                        DOTA_UNIT_TARGET_OTHER,
                                        DOTA_UNIT_TARGET_FLAG_NONE,
                                        FIND_ANY_ORDER,
                                        false)

        -- Move each mine towards the parent of the debuff
        for _,mine in pairs(mines) do            
            if mine:GetUnitName() == "npc_imba_techies_proximity_mine" or mine:GetUnitName() == "npc_imba_techies_stasis_trap" or mine:GetUnitName() == "npc_imba_techies_remote_mine" then

                -- Get mine's direction and distance from enemy
                local direction = (self.parent:GetAbsOrigin() - mine:GetAbsOrigin()):Normalized()                
                local distance = (self.parent:GetAbsOrigin() - mine:GetAbsOrigin()):Length2D()  

                -- Minimum distance so game won't keep trying to put it closer in zero range
                if distance > 25 then
                    -- Set the mine's location closer to the enemy
                    local mine_location = mine:GetAbsOrigin() + direction * movespeed * FrameTime()
                    mine:SetAbsOrigin(mine_location)
                end
            end
        end
    end
end

function modifier_imba_statis_trap_electrocharge:GetTexture()
    return "techies_stasis_trap"
end


-- Disarmed Statis Traps modifier
modifier_imba_statis_trap_disarmed = class({})

function modifier_imba_statis_trap_disarmed:IsHidden() return false end
function modifier_imba_statis_trap_disarmed:IsPurgable() return false end
function modifier_imba_statis_trap_disarmed:IsDebuff() return false end









------------------------------
--        BLAST OFF!        --
------------------------------
imba_techies_blast_off = class({})
LinkLuaModifier("modifier_imba_blast_off", "hero/hero_techies.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_imba_blast_off_movement", "hero/hero_techies.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_imba_blast_off_silence", "hero/hero_techies.lua", LUA_MODIFIER_MOTION_BOTH)

function imba_techies_blast_off:IsHiddenWhenStolen()
    return false
end

function imba_techies_blast_off:GetAOERadius()
    local caster = self:GetCaster()
    local ability = self

    local radius  = ability:GetSpecialValueFor("radius")
    return radius
end

function imba_techies_blast_off:IsNetherWardStealable()
    return false
end

function imba_techies_blast_off:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local target_point = self:GetCursorPosition()  
    local piggy_response = "Imba.LittlePiggyWhy"  
    local sound_cast = "Hero_Techies.BlastOff.Cast"
    local modifier_blast = "modifier_imba_blast_off"

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)

    -- #8 Talent: Blast Off throws a little pig instead of you
    local pig
    if caster:HasTalent("special_bonus_imba_techies_8") then
        pig = CreateUnitByName("npc_imba_techies_blast_off_piggy", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())

        -- Set the pig to be on the player's team
        local playerID = caster:GetPlayerID()
        pig:SetControllableByPlayer(playerID, true)

        -- Set the pig to look the same way as the caster
        pig:SetForwardVector(caster:GetForwardVector())

        -- Roll a chance for meme sound, if applicable
        if USE_MEME_SOUNDS and RollPercentage(5) then
            EmitSoundOn(piggy_response, caster)
        end

        -- Add the blast off modifier, and assign it the target point
        local modifier_blast_handler = pig:AddNewModifier(caster, ability, modifier_blast, {})
        if modifier_blast_handler then
            modifier_blast_handler.target_point = target_point
        end    
    else
        -- Add the blast off modifier, and assign it the target point
        local modifier_blast_handler = caster:AddNewModifier(caster, ability, modifier_blast, {})
        if modifier_blast_handler then
            modifier_blast_handler.target_point = target_point
        end    
    end    
end


-- Blast off modifier
modifier_imba_blast_off = class({})

function modifier_imba_blast_off:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()
        self.modifier_movement = "modifier_imba_blast_off_movement"

        -- Ability specials
        self.max_jumps = self.ability:GetSpecialValueFor("max_jumps")
        self.jump_continue_delay = self.ability:GetSpecialValueFor("jump_continue_delay")
        self.jump_duration = self.ability:GetSpecialValueFor("jump_duration")        

        -- Set the caster to jump freely unless otherwise issued        
        self.jumps = 0                

        -- Wait for the target point to be assigned to the modifier
        Timers:CreateTimer(FrameTime(), function()
            if not self.target_point then
                return FrameTime()
            else
                self.direction = (self.target_point - self.parent:GetAbsOrigin()):Normalized()
                self.distance = (self.target_point - self.parent:GetAbsOrigin()):Length2D()

                -- Apply the first jump and assign the target point to it as well
                local modifier_movement_handler = self.parent:AddNewModifier(self.caster, self.ability, self.modifier_movement, {duration = self.jump_duration + self.jump_continue_delay})
                if modifier_movement_handler then
                    modifier_movement_handler.target_point = self.target_point
                end

                -- Start thinking
                self:StartIntervalThink(self.jump_duration + self.jump_continue_delay)
            end
        end)
    end
end

function modifier_imba_blast_off:OnIntervalThink()
    -- Increment jump count
    self.jumps = self.jumps + 1    

    -- If the caster is stunned, hexed, or silenced, destroy self
    if self.parent:IsStunned() or self.parent:IsHexed() or self.parent:IsSilenced() then
        self:Destroy()
        return nil
    end

    -- If the caster reached max jumps, destroy self
    if self.jumps > self.max_jumps then
        self:Destroy()
        return nil
    end

    -- Find new jump position, using the same distance and direction
    self.target_point = self.target_point + self.direction * self.distance

    -- Apply another jump and assign the new target point to it
    local modifier_movement_handler = self.parent:AddNewModifier(self.caster, self.ability, self.modifier_movement, {duration = self.jump_duration + self.jump_continue_delay})
    if modifier_movement_handler then
        modifier_movement_handler.target_point = self.target_point
    end
end

function modifier_imba_blast_off:IsHidden() return true end
function modifier_imba_blast_off:IsPurgable() return false end
function modifier_imba_blast_off:IsDebuff() return false end

function modifier_imba_blast_off:DeclareFunctions()
    local decFuncs = {MODIFIER_EVENT_ON_ORDER}

    return decFuncs
end

function modifier_imba_blast_off:OnOrder(keys)
    if IsServer() then
        local order_type = keys.order_type
        local unit = keys.unit

        -- Only apply if the unit issuing the command is the caster
        if unit == self.parent then            

            -- Apply for stop move, or attack commands            
            local eligible_order_types = {DOTA_UNIT_ORDER_HOLD_POSITION,
                                          DOTA_UNIT_ORDER_STOP,
                                          DOTA_UNIT_ORDER_MOVE_TO_POSITION,
                                          DOTA_UNIT_ORDER_MOVE_TO_TARGET,
                                          DOTA_UNIT_ORDER_ATTACK_MOVE,
                                          DOTA_UNIT_ORDER_ATTACK_TARGET}

            -- Find if the order was eligible for stopping further jumps
            for i = 1 , #eligible_order_types do
                if eligible_order_types[i] == order_type then
                    self:Destroy()
                    break
                end                
            end
        end
    end
end

function modifier_imba_blast_off:CheckState()
    local state = {[MODIFIER_STATE_ROOTED] = true,
                   [MODIFIER_STATE_DISARMED] = true}
    return state
end

function modifier_imba_blast_off:OnDestroy()
    if IsServer() then
        if self.parent:HasModifier(self.modifier_movement) then
            local modifier_movement_handler = self.parent:FindModifierByName(self.modifier_movement)
            if modifier_movement_handler then
                modifier_movement_handler.last_jump = true
            end
        end

        -- If it was a pig, remove it after a small delay
        if self.parent:GetUnitName() == "npc_imba_techies_blast_off_piggy" then
            Timers:CreateTimer(1, function()
                self.parent:Kill(self.ability, self.caster)
            end)      
        end
    end
end


-- Blast off motion controller modifier
modifier_imba_blast_off_movement = class({})

function modifier_imba_blast_off_movement:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()  
        self.miss_response = {"techies_tech_suicidesquad_04", "techies_tech_suicidesquad_09", "techies_tech_suicidesquad_13"}
        self.rare_miss_response = {"techies_tech_suicidesquad_08", "techies_tech_failure_01"}
        self.kill_response = {"techies_tech_suicidesquad_02", "techies_tech_suicidesquad_03", "techies_tech_suicidesquad_06", "techies_tech_suicidesquad_11", "techies_tech_suicidesquad_12"}
        self.rare_kill_response = {"techies_tech_focuseddetonate_14"}  
        self.sound_suicide = "Hero_Techies.Suicide"
        self.particle_trail = "particles/units/heroes/hero_techies/techies_blast_off_trail.vpcf"
        self.particle_explosion = "particles/units/heroes/hero_techies/techies_blast_off.vpcf"
        self.modifier_silence = "modifier_imba_blast_off_silence"
        self.proximity_ability = "imba_techies_proximity_mine"

        -- Ability specials
        self.damage = self.ability:GetSpecialValueFor("damage")
        self.radius = self.ability:GetSpecialValueFor("radius")
        self.self_damage_pct = self.ability:GetSpecialValueFor("self_damage_pct")
        self.silence_duration = self.ability:GetSpecialValueFor("silence_duration")
        self.jump_duration = self.ability:GetSpecialValueFor("jump_duration")        
        self.jump_max_height = self.ability:GetSpecialValueFor("jump_max_height")                

        -- Wait for the target point to be assigned to the modifier
        Timers:CreateTimer(FrameTime(), function()
            if not self.target_point then
                return FrameTime()
            else
                -- Add trail particle
                local particle_trail_fx = ParticleManager:CreateParticle(self.particle_trail, PATTACH_ABSORIGIN_FOLLOW, self.parent)
                ParticleManager:SetParticleControl(particle_trail_fx, 0, self.parent:GetAbsOrigin())
                ParticleManager:SetParticleControl(particle_trail_fx, 1, self.parent:GetAbsOrigin())                
                self:AddParticle(particle_trail_fx, false, false, -1, false, false)

                -- Calculate jump variables
                self.direction = (self.target_point - self.parent:GetAbsOrigin()):Normalized()
                self.distance = (self.target_point - self.parent:GetAbsOrigin()):Length2D()
                self.velocity = self.distance / self.jump_duration
                self.time_elapsed = 0
                self.current_height = 0                               

                -- Execute forced movement
                if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
                    self:Destroy()
                end        
            end            
        end)        
    end
end

function modifier_imba_blast_off_movement:IsHidden() return true end
function modifier_imba_blast_off_movement:IsPurgable() return false end
function modifier_imba_blast_off_movement:IsDebuff() return false end

function modifier_imba_blast_off_movement:UpdateVerticalMotion(me, dt)
    if IsServer() then        
        -- Calculate height as a parabula
        local t = self.time_elapsed / self.jump_duration
        self.current_height = self.current_height + FrameTime() * self.jump_max_height * (4-8*t)

        -- Set the new height
        self.parent:SetAbsOrigin(GetGroundPosition(self.parent:GetAbsOrigin(), self.parent) + Vector(0,0,self.current_height))         

        -- Increase the time elapsed
        self.time_elapsed = self.time_elapsed + dt
    end
end

function modifier_imba_blast_off_movement:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        -- Check if we're still jumping
        if self.time_elapsed < self.jump_duration then
            -- Move parent towards the target point    
            local new_location = self.parent:GetAbsOrigin() + self.direction * self.velocity * dt
            self.parent:SetAbsOrigin(new_location)            
        else
            self.parent:InterruptMotionControllers(true)                    
            self:Destroy()
        end
    end
end

function modifier_imba_blast_off_movement:OnHorizontalMotionInterrupted()
    if IsServer() then
        -- Play explosion sound
        EmitSoundOn(self.sound_suicide, self.parent)

        -- Add explosion particle
        local particle_explosion_fx = ParticleManager:CreateParticle(self.particle_explosion, PATTACH_WORLDORIGIN, self.parent)
        ParticleManager:SetParticleControl(particle_explosion_fx, 0, self.parent:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

        -- Destroy trees around the landing point
        GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), self.radius, true)

        -- Find all nearby enemies    
        local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),
                                          self.parent:GetAbsOrigin(),
                                          nil,
                                          self.radius,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                          DOTA_UNIT_TARGET_FLAG_NONE,
                                          FIND_ANY_ORDER,
                                          false)

        local enemy_killed = false
        for _,enemy in pairs(enemies) do
            -- Deal magical damage to them
            local damageTable = {victim = enemy,
                                 attacker = self.caster, 
                                 damage = self.damage,
                                 damage_type = DAMAGE_TYPE_MAGICAL,
                                 ability = self.ability
                                 }
            
            local actual_damage = ApplyDamage(damageTable)            

            -- Add silence modifier to them
            enemy:AddNewModifier(self.caster, self.ability, self.modifier_silence, {duration = self.silence_duration})

            -- Check (and mark) if an enemy died from the blast
            Timers:CreateTimer(FrameTime(), function()
                if not enemy:IsAlive() then
                    enemy_killed = true
                end
            end)
        end

        -- If no enemies were found, play miss response
        if #enemies == 0 and self.last_jump then
            -- Roll for rare response
            if RollPercentage(15) then
                EmitSoundOn(self.rare_miss_response[math.random(1, #self.rare_miss_response)], self.caster)
            else
                EmitSoundOn(self.miss_response[math.random(1, #self.miss_response)], self.caster)
            end
        end

        Timers:CreateTimer(FrameTime()*2, function()
            -- If an enemy died, play kill response
            if enemy_killed then
                -- Roll for rare response
                if RollPercentage(15) then
                    EmitSoundOn(self.rare_kill_response[math.random(1, #self.rare_kill_response)], self.caster)
                else
                    EmitSoundOn(self.kill_response[math.random(1, #self.kill_response)], self.caster)
                end
            end
        end)
        

        -- Deal damage to the caster based on its max health
        local self_damage = self.parent:GetMaxHealth() * self.self_damage_pct * 0.01       
        
        local damageTable = {victim = self.parent,
                             attacker = self.caster, 
                             damage = self_damage,
                             damage_type = DAMAGE_TYPE_PURE,
                             ability = self.ability,
                             damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
                             }
            
        local actual_damage = ApplyDamage(damageTable)                                
        print(actual_damage)

        --#5 Talent: Blast Off! jumps drop a Proximity Mine
        if self.caster:HasTalent("special_bonus_imba_techies_5") then

            -- Find Proximity Mine ability. Talent can't proc if the caster doesn't have Proximity Mines.
            if self.caster:HasAbility(self.proximity_ability) then
                local proximity_ability_handler = self.caster:FindAbilityByName(self.proximity_ability)
                if proximity_ability_handler and proximity_ability_handler:GetLevel() > 0 then
                    PlantProximityMine(self.caster, proximity_ability_handler, self.parent:GetAbsOrigin())
                end
            end            
        end
    end
end

function modifier_imba_blast_off_movement:CheckState()
    local state = {[MODIFIER_STATE_ROOTED] = true,
                   [MODIFIER_STATE_DISARMED] = true}
    return state
end


-- Blast Off Silence modifier
modifier_imba_blast_off_silence = class({})

function modifier_imba_blast_off_silence:IsHidden() return false end
function modifier_imba_blast_off_silence:IsPurgable() return true end
function modifier_imba_blast_off_silence:IsDebuff() return true end

function modifier_imba_blast_off_silence:CheckState()
    local state = {[MODIFIER_STATE_SILENCED] = true}
    return state
end

function modifier_imba_blast_off_silence:GetEffectName()
    return "particles/generic_gameplay/generic_silence.vpcf"
end

function modifier_imba_blast_off_silence:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end



------------------------------
--      REMOTE MINES        --
------------------------------
imba_techies_remote_mine = class({})

function imba_techies_remote_mine:IsHiddenWhenStolen()
    return false
end

function imba_techies_remote_mine:GetAssociatedSecondaryAbilities()
    return "imba_techies_focused_detonate"
end

function imba_techies_remote_mine:IsNetherWardStealable()
    return false
end

function imba_techies_remote_mine:OnUpgrade()
    local caster = self:GetCaster()
    local focused_ability = "imba_techies_focused_detonate"

    if caster:HasAbility(focused_ability) then
        local focused_ability_handler = caster:FindAbilityByName(focused_ability)
        if focused_ability_handler then
            focused_ability_handler:SetLevel(1)
        end
    end
end

function imba_techies_remote_mine:GetAOERadius()
    local caster = self:GetCaster()
    local ability = self
    local scepter = caster:HasScepter()

    local radius = ability:GetSpecialValueFor("radius")
    local scepter_radius_bonus = ability:GetSpecialValueFor("scepter_radius_bonus")

    if scepter then
        radius = radius + scepter_radius_bonus
    end

    return radius
end

function imba_techies_remote_mine:OnAbilityPhaseStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local target_point = self:GetCursorPosition()
    local sound_toss = "Hero_Techies.RemoteMine.Toss"
    local particle_plant = "particles/hero/techies/techies_remote_mine_plant.vpcf"

    -- Play toss sound
    EmitSoundOn(sound_toss, caster)    

    -- Add particle effect
    local particle_plant_fx = ParticleManager:CreateParticle(particle_plant, PATTACH_CUSTOMORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(particle_plant_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_remote", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(particle_plant_fx, 1, target_point)
    ParticleManager:SetParticleControl(particle_plant_fx, 4, target_point)
    ParticleManager:ReleaseParticleIndex(particle_plant_fx)

    return true
end

function imba_techies_remote_mine:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local target_point = self:GetCursorPosition()
    local cast_response = {"techies_tech_remotemines_03", "techies_tech_remotemines_04", "techies_tech_remotemines_05", "techies_tech_remotemines_07", "techies_tech_remotemines_08", "techies_tech_remotemines_09", "techies_tech_remotemines_13", "techies_tech_remotemines_14", "techies_tech_remotemines_15", "techies_tech_remotemines_17", "techies_tech_remotemines_18", "techies_tech_remotemines_19", "techies_tech_remotemines_20", "techies_tech_remotemines_25", "techies_tech_remotemines_26", "techies_tech_remotemines_27", "techies_tech_remotemines_30", "techies_tech_remotemines_02", "techies_tech_remotemines_10", "techies_tech_remotemines_11", "techies_tech_remotemines_16", "techies_tech_remotemines_21", "techies_tech_remotemines_22", "techies_tech_remotemines_23", "techies_tech_remotemines_28", "techies_tech_remotemines_29"}
    local rare_cast_response = "techies_tech_remotemines_01"
    local sound_cast = "Hero_Techies.RemoteMine.Plant"        
    local mine_ability = "imba_techies_remote_mine_pinpoint_detonation"

    -- Ability specials
    local mine_duration = ability:GetSpecialValueFor("mine_duration")    

    -- Roll for rare cast response
    if RollPercentage(1) then
        EmitSoundOn(rare_cast_response, caster)
    else
        EmitSoundOn(cast_response[math.random(1, #cast_response)], caster)
    end

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)

    -- Plant mine
    local mine = CreateUnitByName("npc_imba_techies_remote_mine", target_point, false, caster, caster, caster:GetTeamNumber())

    -- Set mine to be controllable by the player
    local playerID = caster:GetPlayerID()
    mine:SetControllableByPlayer(playerID, true)

    -- Set the mine's ability to be the same level as the planting ability
    if mine:HasAbility(mine_ability) then
        local mine_ability_handler = mine:FindAbilityByName(mine_ability)
        if mine_ability_handler then
            mine_ability_handler:SetLevel(ability:GetLevel())
        end
    end

    -- Set the mine's owner to be the caster
    mine:SetOwner(caster)

    -- Assign a kill modifier to it
    mine:AddNewModifier(caster, ability, "modifier_kill", {duration = mine_duration})
end


------------------------------
--    PINPOINT DETONATION   --
------------------------------
imba_techies_remote_mine_pinpoint_detonation = class({})
LinkLuaModifier("modifier_imba_remote_mine", "hero/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_remote_mine_inflammable", "hero/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)

function imba_techies_remote_mine_pinpoint_detonation:IsStealable()
    return false
end

function imba_techies_remote_mine_pinpoint_detonation:ProcsMagicStick()
    return false
end

function imba_techies_remote_mine_pinpoint_detonation:IsNetherWardStealable()
    return false
end

function imba_techies_remote_mine_pinpoint_detonation:GetIntrinsicModifierName()
    return "modifier_imba_remote_mine"
end

function imba_techies_remote_mine_pinpoint_detonation:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self  
    local owner = caster:GetOwner()  
    local sound_activate = "Hero_Techies.RemoteMine.Activate"
    local sound_detonate = "Hero_Techies.RemoteMine.Detonate"
    local particle_explosion = "particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf"
    local modifier_inflammable = "modifier_imba_remote_mine_inflammable"
    local modifier_electrocharge = "modifier_imba_statis_trap_electrocharge"
    local scepter = owner:HasScepter()

    -- Ability specials
    local damage = ability:GetSpecialValueFor("damage")
    local radius = ability:GetSpecialValueFor("radius")
    local inflammable_duration = ability:GetSpecialValueFor("inflammable_duration")
    local inflammable_charge_radius = ability:GetSpecialValueFor("inflammable_charge_radius")
    local inflammable_charge_damage = ability:GetSpecialValueFor("inflammable_charge_damage")
    local scepter_damage_bonus = ability:GetSpecialValueFor("scepter_damage_bonus")
    local scepter_radius_bonus = ability:GetSpecialValueFor("scepter_radius_bonus")

    -- Play activation sound
    EmitSoundOn(sound_activate, caster)

    -- Roll a random time to wait
    local random_wait_time = math.random(1, 4)
    Timers:CreateTimer(FrameTime() * random_wait_time, function()

        -- Play detonation sound
        EmitSoundOn(sound_detonate, caster)

        -- Add detonation particles
        local particle_explosion_fx = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(particle_explosion_fx, 0, caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle_explosion_fx, 1, Vector(radius, 1, 1))
        ParticleManager:SetParticleControl(particle_explosion_fx, 3, caster:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

        -- If the caster has scepter, increase the damage and radius
        if scepter then
            damage = damage + scepter_damage_bonus
            radius = radius + scepter_radius_bonus
        end

        -- Fetch stacks of Inflammable
        local stacks = 0
        if caster:HasModifier(modifier_inflammable) then
            local modifier_inflammable_handler = caster:FindModifierByName(modifier_inflammable)
            if modifier_inflammable_handler then
                stacks = modifier_inflammable_handler:GetStackCount()
            end
        end

        -- Increase radius and damage by current Inflammable stacks
        damage = damage + inflammable_charge_radius * stacks
        radius = radius + inflammable_charge_damage * stacks

        -- Find enemies nearby
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                          caster:GetAbsOrigin(),
                                          nil,
                                          radius,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                          DOTA_UNIT_TARGET_FLAG_NONE,
                                          FIND_ANY_ORDER,
                                          false)

        for _,enemy in pairs(enemies) do

            -- Deal damage to enemies
            local damageTable = {victim = enemy,
                                 attacker = caster, 
                                 damage = damage,
                                 damage_type = DAMAGE_TYPE_MAGICAL,
                                 ability = ability
                                 }

            ApplyDamage(damageTable)            

            -- If the enemy has Electrocharge (from Stasis Trap), refresh it and add a stack
            if enemy:HasModifier(modifier_electrocharge) then
                local modifier_electrocharge_handler = enemy:FindModifierByName(modifier_electrocharge)
                if modifier_electrocharge_handler then
                    modifier_electrocharge_handler:IncrementStackCount()
                    modifier_electrocharge_handler:ForceRefresh()
                end
            end
        end

        -- Find remote mines in explosion range
        local mines = FindUnitsInRadius(caster:GetTeamNumber(),
                                        caster:GetAbsOrigin(),
                                        nil,
                                        radius,
                                        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                        DOTA_UNIT_TARGET_OTHER,
                                        DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
                                        FIND_ANY_ORDER,
                                        false)
        
        for _,mine in pairs(mines) do
            -- If a mine doesn't inflammable yet, give it to it
            if mine:GetUnitName() == "npc_imba_techies_remote_mine" then
                if not mine:HasModifier(modifier_inflammable) then
                    mine:AddNewModifier(caster, ability, modifier_inflammable, {duration = inflammable_duration})
                end

                -- Grant them a stack of Inflammable
                local modifier_inflammable_handler = mine:FindModifierByName(modifier_inflammable)
                if modifier_inflammable_handler then
                    modifier_inflammable_handler:IncrementStackCount()
                    modifier_inflammable_handler:ForceRefresh()
                end                
            end
        end        

        -- Kill self
        caster:Kill(ability, caster)
    end)
end


modifier_imba_remote_mine = class({})


function modifier_imba_remote_mine:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.particle_mine = "particles/units/heroes/hero_techies/techies_remote_mine.vpcf"

    -- Play particle effect
    local particle_mine_fx = ParticleManager:CreateParticle(self.particle_mine, PATTACH_ABSORIGIN, self.caster)
    ParticleManager:SetParticleControl(particle_mine_fx, 0, self.caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_mine_fx, 3, self.caster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle_mine_fx)
end

function modifier_imba_remote_mine:IsHidden() return true end
function modifier_imba_remote_mine:IsPurgable() return false end
function modifier_imba_remote_mine:IsDebuff() return false end

function modifier_imba_remote_mine:CheckState()
    local state = {[MODIFIER_STATE_INVISIBLE] = true,
                   [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
    return state
end


-- Remote Mines' Inflammable modifier
modifier_imba_remote_mine_inflammable = class({})

function modifier_imba_remote_mine_inflammable:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()

    -- Ability specials
    self.inflammable_max_charges = self.ability:GetSpecialValueFor("inflammable_max_charges")
end

function modifier_imba_remote_mine_inflammable:GetTexture()
    return "techies_remote_mines_self_detonate" 
end

function modifier_imba_remote_mine_inflammable:IsHidden() return false end
function modifier_imba_remote_mine_inflammable:IsPurgable() return false end
function modifier_imba_remote_mine_inflammable:IsDebuff() return false end

function modifier_imba_remote_mine_inflammable:OnStackCountChanged(old_count)
    local stacks = self:GetStackCount()

    -- Cannot exceed the maximum stacks
    if stacks > self.inflammable_max_charges then
        self:SetStackCount(self.inflammable_max_charges)
    end
end





------------------------------
--     FOCUSED DETONATE     --
------------------------------
imba_techies_focused_detonate = class({})
LinkLuaModifier("modifier_imba_focused_detonate", "hero/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)

function imba_techies_focused_detonate:IsStealable()
    return false
end

function imba_techies_focused_detonate:IsHiddenWhenStolen()
    return false
end

function imba_techies_focused_detonate:IsNetherWardStealable()
    return false
end

function imba_techies_focused_detonate:GetAOERadius()
    local ability = self

    local radius = ability:GetSpecialValueFor("radius")    
    return radius
end

function imba_techies_focused_detonate:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local target_point = self:GetCursorPosition()    
    local detonate_ability = "imba_techies_remote_mine_pinpoint_detonation"

    -- Ability specials
    local radius = ability:GetSpecialValueFor("radius")

    -- Find all mines in radius
    local remote_mines = FindUnitsInRadius(caster:GetTeamNumber(),
                                           target_point:GetAbsOrigin(),
                                           nil,
                                           radius,
                                           DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                           DOTA_UNIT_TARGET_OTHER,
                                           DOTA_UNIT_TARGET_FLAG_NONE,
                                           FIND_ANY_ORDER,
                                           false)

    -- Iterate every mine every game tick
    for i = 1, #remote_mines do        
        Timers:CreateTimer(FrameTime()*(i-1), function()

            -- Find their Pinpoint Detonate spell and force them to cast it
            if remote_mines[i]:HasAbility(detonate_ability) then
                local detonate_ability_handler = remote_mines[i]:FindAbilityByName(detonate_ability)
                if detonate_ability_handler then
                    detonate_ability_handler:OnSpellStart()
                end
            end            
        end)
    end
end

-- Modifier for casting Focused Detonate without facing cast direction
-- Modifier is added in the OrderFilter in imba.lua
modifier_imba_focused_detonate = class({})

function modifier_imba_focused_detonate:DeclareFunctions()
    local decFuncs =
    {
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
        MODIFIER_PROPERTY_DISABLE_TURNING
    }
    return decFuncs
end

function modifier_imba_focused_detonate:IsHidden() return true end
function modifier_imba_focused_detonate:IsPurgable() return false end
function modifier_imba_focused_detonate:IsDebuff() return false end

function modifier_imba_focused_detonate:GetModifierIgnoreCastAngle()
    return 1
end

function modifier_imba_focused_detonate:GetModifierDisableTurning()
    return 1
end

function modifier_imba_focused_detonate:IsHidden()
    return false
end

-- Do a stop order after finish casting to prevent turning to the destination point
function modifier_imba_focused_detonate:OnDestroy()
    if IsServer() then
        local stopOrder =
        {
            UnitIndex = self:GetCaster():entindex(),
            OrderType = DOTA_UNIT_ORDER_STOP
        }
        ExecuteOrderFromTable( stopOrder )
    end
end


------------------------------
--      MINEFIELD SIGN      --
------------------------------
imba_techies_minefield_sign = class({})
LinkLuaModifier("modifier_imba_minefield_sign_aura", "hero/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_minefield_sign_detection", "hero/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)

function imba_techies_minefield_sign:IsHiddenWhenStolen()
    return false
end

function imba_techies_minefield_sign:IsNetherWardStealable()
    return false
end

function imba_techies_minefield_sign:IsInnateAbility()
    return true
end

function imba_techies_minefield_sign:GetAOERadius()
    local caster = self:GetCaster()
    local ability = self
    local radius = ability:GetSpecialValueFor("radius")

    -- #6 Talent: Minefield radius increase
    radius = radius + caster:FindTalentValue("special_bonus_imba_techies_6")

    return radius
end

function imba_techies_minefield_sign:OnUpgrade()
    local ability = self    

    if not ability:GetAutoCastState() then
        ability:ToggleAutoCast()
    end
end

function imba_techies_minefield_sign:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local target_point = self:GetCursorPosition()
    local sound_cast = "Hero_Techies.Sign"
    local modifier_sign = "modifier_imba_minefield_sign_aura"   

    -- Play cast sound
    EmitSoundOn(modifier_sign, caster)

    -- If there is already a sign assigned to this ability, destroy it
    if self.assigned_sign then
        self.assigned_sign:Destroy()
    end

    -- Create a new sign
    local sign = CreateUnitByName("npc_imba_techies_minefield_sign", target_point, false, caster, caster, caster:GetTeamNumber())

    -- Assign it to the ability
    self.assigned_sign = sign

    -- Assign the sign aura modifier to it    
    sign:AddNewModifier(caster, ability, modifier_sign, {})
end


-- Sign aura modifier
modifier_imba_minefield_sign_aura = class({})

function modifier_imba_minefield_sign_aura:OnCreated()
    -- Ability proprties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()

    -- Ability specials
    self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_imba_minefield_sign_aura:IsHidden() return false end
function modifier_imba_minefield_sign_aura:IsPurgable() return false end
function modifier_imba_minefield_sign_aura:IsDebuff() return false end

function modifier_imba_minefield_sign_aura:CheckState()
    local state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                   [MODIFIER_STATE_NO_HEALTH_BAR] = true,
                   [MODIFIER_STATE_INVULNERABLE] = true,
                   [MODIFIER_STATE_UNSELECTABLE] = true}

    return state
end

function modifier_imba_minefield_sign_aura:GetAuraEntityReject(target)
    -- Only apply on mines
    if target:GetUnitName() == "npc_imba_techies_proximity_mine" or target:GetUnitName() == "npc_imba_techies_stasis_trap" or target:GetUnitName() == "npc_imba_techies_remote_mine" then
        return false
    end

    return true
end

function modifier_imba_minefield_sign_aura:GetAuraRadius()
    -- #6 Talent: Minefield radius increase
    local radius = self.radius + self.caster:FindTalentValue("special_bonus_imba_techies_6")

    return radius
end

function modifier_imba_minefield_sign_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_minefield_sign_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_minefield_sign_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_OTHER
end

function modifier_imba_minefield_sign_aura:GetModifierAura()
    return "modifier_imba_minefield_sign_detection"
end

function modifier_imba_minefield_sign_aura:IsAura()
    if IsServer() then
        -- If the spell is toggled on, aura is emitted from the sign
        if self.ability:GetAutoCastState() then
            return true
        else
            return false
        end
    end
end



-- Sign modifier given to nearby mines
modifier_imba_minefield_sign_detection = class({})

function modifier_imba_minefield_sign_detection:CheckState()
    local state = {[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true}
    return state
end

function modifier_imba_minefield_sign_detection:OnDestroy()
    if IsServer() then
        self.parent = self:GetParent()
        self.detonate_ability = "imba_techies_remote_mine_pinpoint_detonation"

        -- If it is a Remote Mine, wait a game tick, check if the mine is still alive, and scan for nearby enemies
        Timers:CreateTimer(FrameTime(), function()
            if self.parent:GetUnitName() == "npc_imba_techies_remote_mine" then
                if self.parent:IsAlive() then
                    if self.parent:HasAbility(self.detonate_ability) then
                        local detonate_ability_handler = self.parent:FindAbilityByName(self.detonate_ability)
                        if detonate_ability_handler then
                            local radius = detonate_ability_handler:GetSpecialValueFor("radius")                            

                            local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),
                                                              self.parent:GetAbsOrigin(),
                                                              nil,
                                                              radius,
                                                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                                                              DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                                              DOTA_UNIT_TARGET_FLAG_NONE,
                                                              FIND_ANY_ORDER,
                                                              false)
                            if #enemies > 0 then
                                detonate_ability_handler:OnSpellStart()
                            end
                        end
                    end
                end
            end
        end)
    end
end