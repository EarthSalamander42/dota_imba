--[[
    Author: Hewdraw
]]

CreateEmptyTalents("alchemist")

local modifiers = {
    "modifier_imba_acid_spray_thinker",
    "modifier_imba_acid_spray_aura",
    "modifier_imba_acid_spray",
    "modifier_imba_unstable_concoction",
    "modifier_imba_goblins_greed_vision",
    "modifier_imba_goblins_greed_passive",
    "modifier_imba_goblins_greed",
    "modifier_imba_greevils_greed_passive",
    "modifier_imba_chemical_rage_transform",
    "modifier_imba_chemical_rage",
    "modifier_imba_chemical_rage_aura",
    "modifier_alchemist_greed_scepter_passive"
}

for _,modifier in pairs(modifiers) do
    LinkLuaModifier(modifier, "hero/hero_alchemist.lua", LUA_MODIFIER_MOTION_NONE)
end

imba_alchemist_acid_spray = class ({})

function imba_alchemist_acid_spray:GetCastRange(location, target)
    return self.BaseClass.GetCastRange(self, location, target)
end

function imba_alchemist_acid_spray:IsHiddenWhenStolen()
    local caster = self:GetCaster()
    if caster:HasAbility("imba_alchemist_chemical_rage") then
        return true
    end
    return false
end

function imba_alchemist_acid_spray:GetAOERadius()
    local caster = self:GetCaster()
    local radius = self:GetSpecialValueFor("radius")    

    -- #1 Talent: Acid Spray radius increase
    radius = radius + caster:FindTalentValue("special_bonus_imba_alchemist_1")
    
    return radius
end

function imba_alchemist_acid_spray:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local point = self:GetCursorPosition()
    local team_id = caster:GetTeamNumber()
    local cast_responses = {"alchemist_alch_ability_acid_01", "alchemist_alch_ability_acid_02", "alchemist_alch_ability_acid_03", "alchemist_alch_ability_acid_04", "alchemist_alch_ability_acid_05", "alchemist_alch_ability_acid_06", "alchemist_alch_ability_acid_07", "alchemist_alch_ability_acid_08", "alchemist_alch_ability_acid_09", "alchemist_alch_ability_acid_10", "alchemist_alch_ability_acid_11", "alchemist_alch_ability_acid_12"}
    EmitSoundOn(cast_responses[math.random(1, #cast_responses)], caster)

    local duration = ability:GetSpecialValueFor("duration")
    local thinker = CreateModifierThinker(caster, self, "modifier_imba_acid_spray_thinker", {duration = duration}, point, team_id, false)
    return true
end

modifier_imba_acid_spray_thinker = class({})

function modifier_imba_acid_spray_thinker:IsAura()
    return true
end

function modifier_imba_acid_spray_thinker:OnCreated(keys)
    if IsServer() then
        self.caster = self:GetCaster()
        self.thinker = self:GetParent()
        self.ability = self:GetAbility()        
        self.modifier_spray = "modifier_imba_acid_spray_aura"
        self.thinker_loc = self.thinker:GetAbsOrigin()

        self.thinker:EmitSound("Hero_Alchemist.AcidSpray")
        
        self.radius = self.ability:GetSpecialValueFor("radius")
        
        -- #1 Talent: Acid Spray radius increase
        self.radius = self.radius + self.caster:FindTalentValue("special_bonus_imba_alchemist_1")
        
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", PATTACH_POINT_FOLLOW, self.thinker)
        ParticleManager:SetParticleControl(particle, 0, (Vector(0, 0, 0)))
        ParticleManager:SetParticleControl(particle, 1, (Vector(self.radius, 1, 1)))
        ParticleManager:SetParticleControl(particle, 15, (Vector(25, 150, 25)))
        ParticleManager:SetParticleControl(particle, 16, (Vector(0, 0, 0)))
        
        self:StartIntervalThink(0.1)
    end
end

function modifier_imba_acid_spray_thinker:OnIntervalThink()
    local units = FindUnitsInRadius(self.thinker:GetTeamNumber(),
                                    self.thinker_loc,
                                    nil,
                                    self.radius,
                                    self.ability:GetAbilityTargetTeam(),
                                    self.ability:GetAbilityTargetType(),
                                    self.ability:GetAbilityTargetFlags(),
                                    FIND_ANY_ORDER,
                                    false)

    for _,unit in pairs (units) do
        if unit:HasModifier(self.modifier_spray) then
            local modifier_spray_handler = unit:FindModifierByName(self.modifier_spray)
            if modifier_spray_handler and not modifier_spray_handler.center then
                modifier_spray_handler.center = self.thinker_loc
            end
        end
    end
end

function modifier_imba_acid_spray_thinker:GetAuraRadius()
    return self.radius
end

function modifier_imba_acid_spray_thinker:GetAuraSearchTeam()    
    return self.ability:GetAbilityTargetTeam()
end

function modifier_imba_acid_spray_thinker:GetAuraSearchType()    
    return self.ability:GetAbilityTargetType()
end

function modifier_imba_acid_spray_thinker:GetAuraSearchFlags()    
    return self.ability:GetAbilityTargetFlags()
end

function modifier_imba_acid_spray_thinker:GetModifierAura()
    return "modifier_imba_acid_spray_aura"
end


function modifier_imba_acid_spray_thinker:OnDestroy(keys)
    if IsServer() then
        local thinker = self:GetParent()
        thinker:StopSound("Hero_Alchemist.AcidSpray")
    end
end

modifier_imba_acid_spray_aura = class({})

function modifier_imba_acid_spray_aura:IsHidden()
    return true
end

function modifier_imba_acid_spray_aura:OnCreated()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local unit = self:GetParent()
        self.modifier = unit:AddNewModifier(caster, ability, "modifier_imba_acid_spray", {})
        self.modifier.damage = ability:GetSpecialValueFor("damage")
        self.modifier.stack_damage = ability:GetSpecialValueFor("stack_damage")
        local tick_rate = ability:GetSpecialValueFor("tick_rate")
        self:StartIntervalThink(tick_rate)
    end
end

function modifier_imba_acid_spray_aura:OnIntervalThink()
    if IsServer() then
        if self.modifier:IsNull() then
            return --volvo pls
        end
        self.modifier:OnIntervalThink(true, false)
    end
end

modifier_imba_acid_spray = class({})

function modifier_imba_acid_spray:IsDebuff()
    return true
end

function modifier_imba_acid_spray:IsPurgable()
    return false
end

function modifier_imba_acid_spray:OnCreated()
    self.caster = self:GetCaster()
    local ability = self:GetAbility()
    if IsServer() then
        self:SetStackCount(1)
        local tick_rate = ability:GetSpecialValueFor("tick_rate")
        self:StartIntervalThink(tick_rate)
    end    
    self.armor_reduction = ability:GetSpecialValueFor("armor_reduction")
    self.stack_armor_reduction = ability:GetSpecialValueFor("stack_armor_reduction")

    -- #2 Talent: Acid Spray armor reduction
    self.armor_reduction = self.armor_reduction + self.caster:FindTalentValue("special_bonus_imba_alchemist_2")   
end

function modifier_imba_acid_spray:OnIntervalThink(aura_tick, consume_stacks)
    if IsServer() then
        if aura_tick then
            self:IncrementStackCount()
        end
        self.caster = self.caster or self:GetCaster()
        self.ability = self.ability or self:GetAbility()

        if self.caster:IsIllusion() then --prevent ability from becoming nil if the illusion is dead for to long
            if not self.caster:IsAlive() then
                self.caster = self.caster:GetPlayerOwner():GetAssignedHero()
                self.ability = self.caster:FindAbilityByName("imba_alchemist_acid_spray")
            end
        end

        local unit = self:GetParent()
        
        if aura_tick
        or consume_stacks
        or (not unit:HasModifier("modifier_imba_acid_spray_aura")
        and not unit:HasModifier("modifier_imba_chemical_rage_aura")) then
            local damage = self.damage + self.stack_damage * self:GetStackCount()
            local damage_table = {
                victim = unit,
                attacker = self.caster,
                damage = damage,
                damage_type = self.ability:GetAbilityDamageType(),
                ability = self.ability,
            }
            ApplyDamage(damage_table)
            EmitSoundOn("Hero_Alchemist.AcidSpray.Damage", unit)

            if not aura_tick then
                self:DecrementStackCount()
            end
            if self:GetStackCount() == 0 then 
                if consume_stacks then
                    return
                end
                unit:RemoveModifierByName("modifier_imba_acid_spray")
                return
            end
            if consume_stacks then
                self:OnIntervalThink(false, consume_stacks)
            end
        end
    end
end

function modifier_imba_acid_spray:OnStackCountChanged(old_stack_count)
    self.caster = self.caster or self:GetCaster()
    self.ability = self.ability or self:GetAbility()
    if self.caster:IsIllusion() then --prevent ability from becoming nil if the illusion is dead for to long
        if not self.caster:IsAlive() then
            self.caster = self.caster:GetPlayerOwner():GetAssignedHero()
            self.ability = self.caster:FindAbilityByName("imba_alchemist_acid_spray")
        end
    end
    local stack_count = self:GetStackCount()
    local max_stacks = self.ability:GetSpecialValueFor("max_stacks")
    if self.caster:HasModifier("modifier_imba_chemical_rage") then
        max_stacks = max_stacks + max_stacks
    end
    if stack_count > max_stacks then
        self:SetStackCount(max_stacks)
    end
end

function modifier_imba_acid_spray:GetTexture()
    return "alchemist_acid_spray" --prevent texture from dissapearing if the illusion is dead for to long
end

function modifier_imba_acid_spray:DeclareFunctions()
    return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,}
end

function modifier_imba_acid_spray:GetModifierPhysicalArmorBonus()
    local armor_reduction = self.armor_reduction + self.stack_armor_reduction * self:GetStackCount()
    return armor_reduction * (-1)
end

imba_alchemist_unstable_concoction = class({})

function imba_alchemist_unstable_concoction:GetCastRange(location, target)
    local caster = self:GetCaster()
    if caster:HasModifier("modifier_imba_unstable_concoction") then
        return self.BaseClass.GetCastRange(self, location, target)
    end
    return 0
end

function imba_alchemist_unstable_concoction:IsHiddenWhenStolen()
    return false
end

function imba_alchemist_unstable_concoction:OnUnStolen()
    local caster = self:GetCaster()
    caster:RemoveModifierByName("modifier_imba_unstable_concoction")
end

function imba_alchemist_unstable_concoction:OnSpellStart()
    local caster = self:GetCaster()
    local cast_response = {"alchemist_alch_ability_concoc_01", "alchemist_alch_ability_concoc_02", "alchemist_alch_ability_concoc_03", "alchemist_alch_ability_concoc_04", "alchemist_alch_ability_concoc_05", "alchemist_alch_ability_concoc_06", "alchemist_alch_ability_concoc_07", "alchemist_alch_ability_concoc_08", "alchemist_alch_ability_concoc_10"}
    local last_second_throw_response = {"alchemist_alch_ability_concoc_16", "alchemist_alch_ability_concoc_17"}
    if caster:HasModifier("modifier_imba_unstable_concoction") then
        local target = self:GetCursorTarget()
        -- Stops the charging sound
        caster:StopSound("Hero_Alchemist.UnstableConcoction.Fuse")

        -- Last second throw responses
        local modifier_unstable_handler = caster:FindModifierByName("modifier_imba_unstable_concoction")
        if modifier_unstable_handler then
            local remaining_time = modifier_unstable_handler:GetRemainingTime()            
            if remaining_time < 1 then
                EmitSoundOn(last_second_throw_response[math.random(1,#last_second_throw_response)], caster)
            end
        end

        caster:RemoveModifierByName("modifier_imba_unstable_concoction")

        caster:StartGesture(ACT_DOTA_ALCHEMIST_CONCOCTION_THROW)
        caster:FadeGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)

        -- Set how much time the spell charged
        self.time_charged = GameRules:GetGameTime() - self.brew_start

        -- Remove the brewing modifier
        caster:RemoveModifierByName("modifier_imba_unstable_concoction")

        Timers:CreateTimer(0.3, function()
            local projectile_speed = self:GetSpecialValueFor("movement_speed")
            local info = 
            {
                Target = target,
                Source = caster,
                Ability = self, 
                EffectName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf",
                iMoveSpeed = projectile_speed,
            }
            ProjectileManager:CreateTrackingProjectile(info)
            
        end)
        return
    end

    EmitSoundOn(cast_response[math.random(1,#cast_response)], caster)
    caster:StartGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)
    self.brew_start = GameRules:GetGameTime()
    self.brew_time = self:GetSpecialValueFor("brew_time")
    local extra_brew_time = self:GetSpecialValueFor("extra_brew_time")
    local duration = self.brew_time + extra_brew_time
    self.stun = self:GetSpecialValueFor("stun")
    self.damage = self:GetSpecialValueFor("damage")
    self.radius_increase = self:GetSpecialValueFor("radius_increase") / self.brew_time
    local greed_modifier = caster:FindModifierByName("modifier_imba_goblins_greed_passive")
    if greed_modifier then
        local greed_stacks = greed_modifier:GetStackCount()
        local greed_multiplier = self:GetSpecialValueFor("time_per_stack")
        duration = duration + (greed_stacks * greed_multiplier)
    end    

    -- #2 Talent: Unstable Concoction duration increase
    duration = duration + caster:FindTalentValue("special_bonus_imba_alchemist_3")
    
    caster:AddNewModifier(caster, self, "modifier_imba_unstable_concoction", {duration = duration,})
    CustomNetTables:SetTableValue("player_table", tostring(caster:GetPlayerOwnerID()), { brew_start = GameRules:GetGameTime(), radius_increase = self.radius_increase,})
    self.radius = self:GetSpecialValueFor("radius")

    -- Play the sound, which will be stopped when the sub ability fires
    caster:EmitSound("Hero_Alchemist.UnstableConcoction.Fuse")
end

function imba_alchemist_unstable_concoction:OnProjectileHit(target, location)
    local caster = self:GetCaster()
    local damage_type = self:GetAbilityDamageType()
    local stun = self.stun
    local damage = self.damage
    local radius = self:GetAOERadius()
    local kill_response = {"alchemist_alch_ability_concoc_09", "alchemist_alch_ability_concoc_15"}
    local particle_acid_blast = "particles/hero/alchemist/acid_spray_blast.vpcf"

    if target then
        location = target:GetAbsOrigin()
    end
    local units = FindUnitsInRadius(caster:GetTeam(), location, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags() - DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_ANY_ORDER, false)
    local brew_duration = (GameRules:GetGameTime() - self.brew_start)
    local brew_percentage = brew_duration / self.brew_time
    local damage = damage * brew_percentage
    local stun_duration = stun * brew_percentage
    if stun_duration > stun then
        stun_duration = stun
    end

    if target then
        if target == caster then
            if not target:IsMagicImmune() then
                if not target:IsInvulnerable() then
                    if not target:IsOutOfGame() then
                        ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = damage_type,})
                        target:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration,})
                    end
                end
            end
        else
            if target:TriggerSpellAbsorb(self) then
                return
            end
        end
    end

    -- Apply the AoE stun and damage with the variable duration
    local enemy_killed = false
    for _,unit in pairs(units) do
        ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = damage_type,})
        unit:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration,})

        -- See if enemy survive the impact to decide if to roll for a kill response
        Timers:CreateTimer(FrameTime(), function()            
            if not unit:IsAlive() and RollPercentage(50) then
                EmitSoundOn(kill_response[math.random(1, #kill_response)], caster)
            end
        end)

        if unit:HasModifier("modifier_imba_acid_spray_aura") then
            local acid_spray_modifier = unit:FindModifierByName("modifier_imba_acid_spray_aura")
            local acid_spray_ability = acid_spray_modifier:GetAbility()
            local acid_spray_radius = acid_spray_ability:GetAOERadius()            
            if acid_spray_modifier.center then
                location = acid_spray_modifier.center
            end

            particle_acid_blast_fx = ParticleManager:CreateParticle(particle_acid_blast, PATTACH_WORLDORIGIN, caster)
            ParticleManager:SetParticleControl(particle_acid_blast_fx, 0, location)
            ParticleManager:SetParticleControl(particle_acid_blast_fx, 1, location)
            ParticleManager:SetParticleControl(particle_acid_blast_fx, 2, Vector(acid_spray_radius, 0, 0))
            ParticleManager:ReleaseParticleIndex(particle_acid_blast_fx)

            local acid_spray_units = FindUnitsInRadius(caster:GetTeam(), location, nil, acid_spray_radius * 2, self:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_ALL, self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
            local damage_multiplier = self:GetSpecialValueFor("acid_spray_damage") * 0.01

            -- #4 Talent: Unstable Concoction blows stronger on Acid Spray
            damage_multiplier = damage_multiplier + caster:FindTalentValue("special_bonus_imba_alchemist_4")
            
            for _,acid_spray_unit in pairs(acid_spray_units) do
                ApplyDamage({victim = acid_spray_unit, attacker = caster, damage = damage * damage_multiplier, damage_type = damage_type,})
                local modifier = acid_spray_unit:FindModifierByName("modifier_imba_acid_spray")
                if modifier then
                    modifier:OnIntervalThink(false, true)
                end
            end
            local modifier = unit:FindModifierByName("modifier_imba_acid_spray")
            if modifier then
                modifier:OnIntervalThink(false, true)
            end
        end        
    end
end

function imba_alchemist_unstable_concoction:GetAbilityTextureName()
    local caster = self:GetCaster()
    if caster:HasModifier("modifier_imba_unstable_concoction") then
        return "alchemist_unstable_concoction_throw"
    end
    return self.BaseClass.GetAbilityTextureName(self)
end

function imba_alchemist_unstable_concoction:GetCooldown(level)
    local caster = self:GetCaster()
    if caster:HasModifier("modifier_imba_unstable_concoction") then
        if IsServer() then
            return self.BaseClass.GetCooldown(self, level) - (GameRules:GetGameTime() - self.brew_start)
        end
        return 0
    end
    if IsServer() then
        return 0
    end
    return self.BaseClass.GetCooldown(self, level)
end

function imba_alchemist_unstable_concoction:GetManaCost(level)
    local caster = self:GetCaster()
    if caster:HasModifier("modifier_imba_unstable_concoction") then
        return 0
    end
    return self.BaseClass.GetManaCost(self, level)
end


function imba_alchemist_unstable_concoction:GetCastTime()
    local caster = self:GetCaster()
    if caster:HasModifier("modifier_imba_unstable_concoction") then
        return self.BaseClass.GetCastTime(self)
    end
    return 0
end

function imba_alchemist_unstable_concoction:GetBehavior()
    local caster = self:GetCaster()
    if caster:HasModifier("modifier_imba_unstable_concoction") then
        return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
    end
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

function imba_alchemist_unstable_concoction:ProcsMagicStick()
    local caster = self:GetCaster()
    if caster:HasModifier("modifier_imba_unstable_concoction") then
        return false
    end
    return true
end

function imba_alchemist_unstable_concoction:GetAOERadius()
    local caster = self:GetCaster()
    local brew_start = 0
    local radius_increase = 0
    if IsServer() then
        brew_start = self.brew_start
        radius_increase = self.radius_increase
    else
        local net_table = CustomNetTables:GetTableValue("player_table", tostring(caster:GetPlayerOwnerID())) or {}
        brew_start = net_table.brew_start or 0
        radius_increase = net_table.radius_increase or 0
    end
    local radius = self:GetSpecialValueFor("radius") + (GameRules:GetGameTime() - brew_start) * radius_increase
    return radius
end

modifier_imba_unstable_concoction = class({})

function modifier_imba_unstable_concoction:IsPurgable()
    return false
end


function modifier_imba_unstable_concoction:IsHidden()
    return true
end

function modifier_imba_unstable_concoction:OnDestroy()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    if IsServer() then
        if not caster:IsAlive() then
            ability:OnProjectileHit(caster, caster:GetAbsOrigin())
            ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
        end
    end
end

function modifier_imba_unstable_concoction:OnCreated()
    self:StartIntervalThink(FrameTime())
end

function modifier_imba_unstable_concoction:OnIntervalThink()
    if IsServer() then
        local caster = self:GetParent()
        local ability = self:GetAbility()
        local last_second_response = {"alchemist_alch_ability_concoc_11", "alchemist_alch_ability_concoc_12", "alchemist_alch_ability_concoc_13", "alchemist_alch_ability_concoc_14", "alchemist_alch_ability_concoc_18", "alchemist_alch_ability_concoc_19", "alchemist_alch_ability_concoc_20"}        
        local self_blow_response = {"alchemist_alch_ability_concoc_21", "alchemist_alch_ability_concoc_22", "alchemist_alch_ability_concoc_23", "alchemist_alch_ability_concoc_24", "alchemist_alch_ability_concoc_25"}

        -- Show the particle to all allies
        local allHeroes = HeroList:GetAllHeroes()
        local particleName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf"
        local number = math.abs(GameRules:GetGameTime() - ability.brew_start - self:GetDuration())
        -- Get the integer. Add a bit because the think interval isn't a perfect 0.5 timer
        local integer = math.floor(number)        
        if integer <= 0 and not self.last_second_responded then
            self.last_second_responded = true
            EmitSoundOn(last_second_response[math.random(1,#last_second_response)], caster)
        end

        -- Get the amount of digits to show
        local digits = math.floor(math.log10(number)) + 2

        -- Round the decimal number to .0 or .5
        local decimal = number % 1

        if decimal < 0.04 then
            decimal = 1 -- ".0"
        elseif decimal > 0.5
        and decimal < 0.54 then
            decimal = 8 -- ".5"
        else
            return
        end

        -- Don't display the 0.0 message
        if not (integer == 0 and decimal <= 1) then
            for k, v in pairs(allHeroes) do
                if v:GetPlayerID() and v:GetTeam() == caster:GetTeam() then
                    local particle = ParticleManager:CreateParticleForPlayer(particleName, PATTACH_OVERHEAD_FOLLOW, caster, PlayerResource:GetPlayer(v:GetPlayerID()))
                    ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
                    ParticleManager:SetParticleControl(particle, 1, Vector(0, integer, decimal))
                    ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
                    ParticleManager:ReleaseParticleIndex(particle)
                end
            end
        else

            -- Set how much time the spell charged
            ability.time_charged = GameRules:GetGameTime() - ability.brew_start

            -- Self-blow response
            EmitSoundOn(self_blow_response[math.random(1, #self_blow_response)], caster)

            local info = 
            {
                Target = caster,
                Source = caster,
                Ability = ability,  
                EffectName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf",
                iMoveSpeed = ability:GetSpecialValueFor("movement_speed"),
            }
            ProjectileManager:CreateTrackingProjectile(info)
            ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
            caster:RemoveModifierByName("modifier_imba_unstable_concoction")
        end
    end
end

imba_alchemist_goblins_greed = class ({})

function imba_alchemist_goblins_greed:IsStealable()
    return false
end

function imba_alchemist_goblins_greed:OnInventoryContentsChanged()
    -- Checks if Alchemist now has a scepter, or still has it.
    if IsServer() then
        local caster = self:GetCaster()     
        local mammonite_ability = "imba_alchemist_mammonite"        

        if caster:HasAbility(mammonite_ability) then
            local mammonite_ability_handler = caster:FindAbilityByName(mammonite_ability)
            if mammonite_ability_handler then
                if caster:HasScepter() then         
                    mammonite_ability_handler:SetLevel(1)
                    mammonite_ability_handler:SetHidden(false)                   
                else
                    if mammonite_ability_handler:GetLevel() > 0 then
                        mammonite_ability_handler:SetLevel(0)
                        mammonite_ability_handler:SetHidden(true)
                    end                 
                end
            end
        end
    end
end

function imba_alchemist_goblins_greed:GetCastRange(location, target)
    return self.BaseClass.GetCastRange(self, location, target)
end

function imba_alchemist_goblins_greed:GetCooldown(level)
    local caster = self:GetCaster()
    local cooldown = self.BaseClass.GetCooldown(self, level)

    -- #8 Talent: Halves Greevil's Greed's cooldown
    cooldown = cooldown - caster:FindTalentValue("special_bonus_imba_alchemist_8")    
    return cooldown
end

function imba_alchemist_goblins_greed:GetIntrinsicModifierName()
    return "modifier_imba_goblins_greed_passive"
end

function imba_alchemist_goblins_greed:OnUpgrade()
    local caster = self:GetCaster()
    local modifier = caster:FindModifierByName(self:GetIntrinsicModifierName())
    local base_gold = self:GetSpecialValueFor("bonus_gold")
    local base_gold_1 = self:GetLevelSpecialValueFor("bonus_gold", self:GetLevel() - 2)
    local stacks = modifier:GetStackCount()
    if self:GetLevel() == 1 then
        base_gold_1 = 0
    end
    modifier:SetStackCount(stacks + (base_gold - base_gold_1))
end

function imba_alchemist_goblins_greed:OnSpellStart()
    local caster = self:GetCaster()
    if caster:IsIllusion() then --skip greevil movement if hybrid casts it cus only alch gets a pet greevil
        target:AddNewModifier(caster, self, "modifier_imba_goblins_greed", {})
        return
    end
    local target = self:GetCursorTarget()
    self.greevil:CastAbilityOnTarget(target, self.greevil_ability, caster:GetPlayerID())
    self.greevil.target = target
    target:AddNewModifier(caster, self, "modifier_imba_goblins_greed_vision", {})
end

modifier_imba_goblins_greed_passive = class ({})

function modifier_imba_goblins_greed_passive:RemoveOnDeath()
    return false
end

function modifier_imba_goblins_greed_passive:IsPermanent()
    return true
end

function modifier_imba_goblins_greed_passive:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_imba_goblins_greed_passive:OnCreated()
    if IsServer() then
        local caster = self:GetCaster()        
        if not caster:IsIllusion() then
            local ability = self:GetAbility()
            ability.greevil = CreateUnitByName("npc_imba_alchemist_greevil", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeam())
            ability.greevil:SetOwner(caster)
            ability.greevil_ability = ability.greevil:FindAbilityByName("imba_alchemist_greevils_greed")
            ability.greevil_ability:SetLevel(1)            
            Timers:CreateTimer(0.1, function()
                ability.greevil:MoveToNPC(caster)
            end)            
        end
    end
end

function modifier_imba_goblins_greed_passive:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_imba_goblins_greed_passive:OnDeath(keys)
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local attacker = keys.attacker
    local unit = keys.unit

    if caster:PassivesDisabled() then
        return
    end

    if (caster == attacker and (not (caster:GetTeam() == unit:GetTeam())))
    or unit:HasModifier("modifier_imba_goblins_greed") then
        local stacks = self:GetStackCount()
        local hero_multiplier = 1
        if unit:IsHero() then
            hero_multiplier = ability:GetSpecialValueFor("hero_multiplier")
        end
        caster:ModifyGold(stacks * hero_multiplier, false, 0)
        local player = PlayerResource:GetPlayer(caster:GetPlayerID())
        local particleName = "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf"       
        local particle1 = ParticleManager:CreateParticleForPlayer(particleName, PATTACH_ABSORIGIN, unit, player)
        ParticleManager:SetParticleControl(particle1, 0, unit:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle1, 1, unit:GetAbsOrigin())

        local symbol = 0 -- "+" presymbol
        local color = Vector(255, 200, 33) -- Gold
        local lifetime = 2
        local digits = string.len(stacks) + 1
        local particleName = "particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf"
        local particle2 = ParticleManager:CreateParticleForPlayer(particleName, PATTACH_ABSORIGIN, unit, player)
        ParticleManager:SetParticleControl(particle2, 1, Vector(symbol, stacks, symbol))
        ParticleManager:SetParticleControl(particle2, 2, Vector(lifetime, digits, 0))
        ParticleManager:SetParticleControl(particle2, 3, color)

        local stack_bonus = ability:GetSpecialValueFor("bonus_bonus_gold")
        local duration = ability:GetSpecialValueFor("duration")
        self:SetStackCount(stacks + stack_bonus)    
        self:IncrementStackCount()

        Timers:CreateTimer(duration, function()
            stacks = self:GetStackCount()
            self:SetStackCount(stacks - stack_bonus)
        end)
    end
end

modifier_imba_goblins_greed_vision = class({})

function modifier_imba_goblins_greed_vision:IsHidden()
    return true
end

function modifier_imba_goblins_greed_vision:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
    }
end

function modifier_imba_goblins_greed_vision:GetModifierProvidesFOWVision()
    return 1
end

modifier_imba_goblins_greed = class({})

imba_alchemist_greevils_greed = class ({})

function imba_alchemist_greevils_greed:GetCastRange()
    return 1
end

function imba_alchemist_greevils_greed:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local owner = caster:GetOwner()

    local greed_ability = owner:FindAbilityByName("imba_alchemist_goblins_greed")
    local greed_duration = greed_ability:GetSpecialValueFor("greed_duration")

    local particle_greevil = "particles/hero/alchemist/greevil_midas_touch.vpcf"
    if not target:TriggerSpellAbsorb(self) then
        target:RemoveModifierByName("modifier_imba_goblins_greed_vision")        
        target:AddNewModifier(caster, self, "modifier_imba_goblins_greed", {duration = greed_duration})

        local hull_size = target:GetHullRadius()
        local particle_greevil_fx = ParticleManager:CreateParticle(particle_greevil, PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControl(particle_greevil_fx, 0, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle_greevil_fx, 1, Vector(hull_size*3, 1, 1))
        ParticleManager:ReleaseParticleIndex(particle_greevil_fx)        
    end

    caster.target = nil
    caster:MoveToNPC(caster:GetOwner())
end

function imba_alchemist_greevils_greed:GetIntrinsicModifierName()
    return "modifier_imba_greevils_greed_passive"
end

modifier_imba_greevils_greed_passive = class ({})

function modifier_imba_greevils_greed_passive:OnCreated()
    if IsServer() then
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.owner = self.caster:GetOwner()        

        -- Start thinking 
        self:StartIntervalThink(0.5)
    end
end

function modifier_imba_greevils_greed_passive:OnIntervalThink()
    if IsServer() then        
        -- If the owner (Alch) is dead, Golden Greevil's should return to base
        if not self.owner:IsAlive() then            
            local fountain
            -- Find this team's fountain
            if self.caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
                fountain = Entities:FindByName(nil, "ent_dota_fountain_good")

            elseif self.caster:GetTeamNumber() == DOTA_TEAM_BADGUYS then
                fountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
            end

            -- Send the Golden Greevil back to base
            if fountain then
                self.caster:MoveToNPC(fountain)
            end

            -- If the target died, casting fails
            if self.caster.target then
                self.caster.target = nil
            end            
        else
            -- If Alch is alive and the Greevil has a target, Greevil should go to it
            if self.caster.target then
                self.caster:CastAbilityOnTarget(self.caster.target, self.ability, self.owner:GetPlayerID())                
            else
                -- If there is no target,  Golden Greevil's should follow Alch
                self.caster:MoveToNPC(self.owner)                    
            end            
        end
    end
end

function modifier_imba_greevils_greed_passive:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
    }
end




----------------------------------
--          CHEMICAL RAGE       --
----------------------------------
imba_alchemist_chemical_rage = class ({})

function imba_alchemist_chemical_rage:IsHiddenWhenStolen()
    return false
end

function imba_alchemist_chemical_rage:GetAssociatedSecondaryAbilities()
    return "imba_alchemist_acid_spray"
end

function imba_alchemist_chemical_rage:OnSpellStart()
    local caster = self:GetCaster()
    local cast_response = {"alchemist_alch_ability_rage_01", "alchemist_alch_ability_rage_02", "alchemist_alch_ability_rage_03", "alchemist_alch_ability_rage_04", "alchemist_alch_ability_rage_05", "alchemist_alch_ability_rage_06", "alchemist_alch_ability_rage_07", "alchemist_alch_ability_rage_08", "alchemist_alch_ability_rage_09", "alchemist_alch_ability_rage_10", "alchemist_alch_ability_rage_11", "alchemist_alch_ability_rage_12", "alchemist_alch_ability_rage_13", "alchemist_alch_ability_rage_15", "alchemist_alch_ability_rage_16", "alchemist_alch_ability_rage_17", "alchemist_alch_ability_rage_18", "alchemist_alch_ability_rage_19", "alchemist_alch_ability_rage_20", "alchemist_alch_ability_rage_21", "alchemist_alch_ability_rage_22", "alchemist_alch_ability_rage_23", "alchemist_alch_ability_rage_24", "alchemist_alch_ability_rage_25"}

    -- Play cast response
    EmitSoundOn(cast_response[math.random(1,#cast_response)], caster)

    caster:AddNewModifier(caster, self, "modifier_imba_chemical_rage_transform", {})
    caster:EmitSound("Hero_Alchemist.ChemicalRage.Cast")
end

modifier_imba_chemical_rage_transform = class ({})

function modifier_imba_chemical_rage_transform:IsHidden()
    return true
end

function modifier_imba_chemical_rage_transform:OnCreated()
    if IsServer() then
        local caster = self:GetCaster()
        if caster:GetUnitName() == "npc_dota_hero_alchemist" then
            caster:StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_START)
        end
        local ability = self:GetAbility()    
        self:SetDuration(ability:GetSpecialValueFor("transformation_time"), false)
    end
end

function modifier_imba_chemical_rage_transform:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
    }
end

function modifier_imba_chemical_rage_transform:OnDestroy()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        if caster:HasModifier("modifier_imba_chemical_rage") then
            caster:RemoveModifierByName("modifier_imba_chemical_rage")
        end
        caster:AddNewModifier(caster, ability, "modifier_imba_chemical_rage", {})
    end
end

modifier_imba_chemical_rage = class ({})

function modifier_imba_chemical_rage:AllowIllusionDuplicate()
    return true
end

function modifier_imba_chemical_rage:OnCreated()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local particle_acid_aura = "particles/hero/alchemist/chemical_rage_acid_aura.vpcf"

        self.ability = caster:FindAbilityByName("imba_alchemist_acid_spray")
        self.bat_change = self:GetAbility():GetSpecialValueFor("base_attack_time") - 1.7
        ModifyBAT(caster, 0, self.bat_change)
        self.radius = self.ability:GetSpecialValueFor("radius")

        -- #1 Talent: Acid Spray radius increase
        self.radius = self.radius + caster:FindTalentValue("special_bonus_imba_alchemist_1")

        local particle_acid_aura_fx = ParticleManager:CreateParticle(particle_acid_aura, PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControl(particle_acid_aura_fx, 0, caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle_acid_aura_fx, 1, caster:GetAbsOrigin())
        self:AddParticle(particle_acid_aura_fx, false, false, -1, false, false)

        local duration = ability:GetSpecialValueFor("duration")
        
        -- #5 Talent: Chemical Rage duration increase
        duration = duration + caster:FindTalentValue("special_bonus_imba_alchemist_5")
        
        self:SetDuration(duration, false)
    end
end

function modifier_imba_chemical_rage:OnDestroy()
    if IsServer() then
        local caster = self:GetCaster()
        if caster:GetUnitName() == "npc_dota_hero_alchemist" then
            caster:StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_END)
        end

        ModifyBAT(caster, 0, -self.bat_change)
    end
end

function modifier_imba_chemical_rage:IsAura()
    return true
end

function modifier_imba_chemical_rage:GetAuraRadius()
    return self.radius
end

function modifier_imba_chemical_rage:GetAuraSearchTeam()
    return self.ability:GetAbilityTargetTeam()
end

function modifier_imba_chemical_rage:GetAuraSearchType()
    return self.ability:GetAbilityTargetType()
end

function modifier_imba_chemical_rage:GetAuraSearchFlags()
    return self.ability:GetAbilityTargetFlags()
end

function modifier_imba_chemical_rage:GetModifierAura()
    return "modifier_imba_chemical_rage_aura"
end

function modifier_imba_chemical_rage:DeclareFunctions()
    local table = {
        MODIFIER_PROPERTY_BASE_MANA_REGEN,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,        
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
    return table
end

function modifier_imba_chemical_rage:GetActivityTranslationModifiers()
    return "chemical_rage"
end

function modifier_imba_chemical_rage:GetModifierBaseManaRegen()
    local ability = self:GetAbility()
    return ability:GetSpecialValueFor("bonus_mana_regen")
end

function modifier_imba_chemical_rage:GetModifierConstantHealthRegen()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local regen = ability:GetSpecialValueFor("bonus_health_regen")

    -- #6 Talent: Chemical Rage health regeneration increase
    regen = regen + caster:FindTalentValue("special_bonus_imba_alchemist_6")    
    return regen
end

function modifier_imba_chemical_rage:GetModifierMoveSpeedBonus_Constant()
    local ability = self:GetAbility()
    return ability:GetSpecialValueFor("bonus_movespeed")
end

function modifier_imba_chemical_rage:GetEffectName()
    return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf"
end

function modifier_imba_chemical_rage:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_chemical_rage:GetStatusEffectName()
    return "particles/status_fx/status_effect_chemical_rage.vpcf"
end

function modifier_imba_chemical_rage:StatusEffectPriority()
    return 10
end

function modifier_imba_chemical_rage:GetHeroEffectName()
    return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage_hero_effect.vpcf"
end

function modifier_imba_chemical_rage:HeroEffectPriority()
    return 10
end

-- Chemical Rage Acid aura
modifier_imba_chemical_rage_aura = class({})

function modifier_imba_chemical_rage_aura:IsDebuff()
    return true
end

function modifier_imba_chemical_rage_aura:IsHidden()
    return true
end

function modifier_imba_chemical_rage_aura:OnCreated()
    if IsServer() then
        local caster = self:GetCaster()        
        local unit = self:GetParent()
        self.ability = caster:FindAbilityByName("imba_alchemist_acid_spray")
        self.modifier = unit:AddNewModifier(caster, self.ability, "modifier_imba_acid_spray", {})
        self.modifier.damage = self.ability:GetSpecialValueFor("damage")
        self.modifier.stack_damage = self.ability:GetSpecialValueFor("stack_damage")
        local tick_rate = self.ability:GetSpecialValueFor("tick_rate")
        self:StartIntervalThink(tick_rate)


    end
end

function modifier_imba_chemical_rage_aura:OnIntervalThink()
    if IsServer() then
        if self.modifier:IsNull() then
            return --volvo pls
        end
        self.modifier:OnIntervalThink(true, false)
    end
end


----------------------------------
--         MAMMONITE            --
----------------------------------
imba_alchemist_mammonite = class({})

function imba_alchemist_mammonite:OnToggle() return end    

function imba_alchemist_mammonite:GetIntrinsicModifierName()
     return "modifier_alchemist_greed_scepter_passive"
 end 

 -- Scepter gold attacks modifier
modifier_alchemist_greed_scepter_passive = class({})

function modifier_alchemist_greed_scepter_passive:IsHidden() return false end
function modifier_alchemist_greed_scepter_passive:IsPurgable() return false end
function modifier_alchemist_greed_scepter_passive:IsDebuff() return false end
function modifier_alchemist_greed_scepter_passive:RemoveOnDeath() return false end

function modifier_alchemist_greed_scepter_passive:OnCreated()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()

    self.gold_damage = self.ability:GetSpecialValueFor("gold_damage")
end

function modifier_alchemist_greed_scepter_passive:OnRefresh()
    self:OnCreated()
end

function modifier_alchemist_greed_scepter_passive:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                      MODIFIER_EVENT_ON_ATTACK_FINISHED,
                      MODIFIER_PROPERTY_ABILITY_LAYOUT}

    return decFuncs
end

function modifier_alchemist_greed_scepter_passive:GetModifierAbilityLayout()
    return 5
end

function modifier_alchemist_greed_scepter_passive:GetModifierPreAttack_BonusDamage()
    if IsServer() then        
        if self.caster:HasScepter() then
            if self.ability:GetToggleState() then
                local gold = self.caster:GetGold()
                local gold_percent = self.gold_damage * 0.01
                local gold_damage = gold * gold_percent
                return gold_damage
            end
        end
    end
end

function modifier_alchemist_greed_scepter_passive:OnAttackFinished(keys)
    if IsServer() then
        local attacker = keys.attacker        

        -- Only apply if the attacker is the caster
        if self.caster == attacker then                        
            if self.caster:HasScepter() then
                if self.ability:GetToggleState() then
                    local gold = self.caster:GetGold()
                    local gold_percent = self.gold_damage * 0.01
                    local gold_damage = gold * gold_percent                                
                    self.caster:SpendGold(gold_damage, DOTA_ModifyGold_Unspecified)                
                end
            end     
        end
    end
end