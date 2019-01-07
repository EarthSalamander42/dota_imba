-- Author: Shush
-- Date: 04/04/2017

-----------------------------------
--          PURIFICATION         --
-----------------------------------

imba_omniknight_purification = class({})
LinkLuaModifier("modifier_imba_purification_buff", "components/abilities/heroes/hero_omniknight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_purification_omniguard_ready", "components/abilities/heroes/hero_omniknight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_purification_omniguard_recharging", "components/abilities/heroes/hero_omniknight.lua", LUA_MODIFIER_MOTION_NONE)

function imba_omniknight_purification:GetAbilityTextureName()
   return "omniknight_purification"
end

function imba_omniknight_purification:IsHiddenWhenStolen()
    return false
end

function imba_omniknight_purification:GetIntrinsicModifierName()
    return "modifier_imba_purification_omniguard_ready"
end

function imba_omniknight_purification:GetAOERadius()
    local ability = self
    local radius = ability:GetSpecialValueFor("radius")

    return radius
end

function imba_omniknight_purification:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorTarget()
    local rare_cast_response = "omniknight_omni_ability_purif_03"
    local target_cast_response = {"omniknight_omni_ability_purif_01", "omniknight_omni_ability_purif_02", "omniknight_omni_ability_purif_04", "omniknight_omni_ability_purif_05", "omniknight_omni_ability_purif_06", "omniknight_omni_ability_purif_07", "omniknight_omni_ability_purif_08"}
    local self_cast_response = {"omniknight_omni_ability_purif_01", "omniknight_omni_ability_purif_05", "omniknight_omni_ability_purif_06", "omniknight_omni_ability_purif_07", "omniknight_omni_ability_purif_08"}
    local sound_cast = "Hero_Omniknight.Purification"    

    -- Play cast responses    
    if caster == target then
        if RollPercentage(50) then
            EmitSoundOn(self_cast_response[math.random(1, #self_cast_response)], caster)
        end
    else
        -- Roll for rare response
        if RollPercentage(5) then
            EmitSoundOn(rare_cast_response, caster)

        -- Roll for normal reponse
        elseif RollPercentage(50) then
            EmitSoundOn(target_cast_response[math.random(1,#target_cast_response)], caster)
        end
    end

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)
    
    -- Purification!
    Purification(caster, ability, target)

    -- #4 Talent: Purification is also applied on a second random target
    if caster:HasTalent("special_bonus_imba_omniknight_4") then
        local bounce_radius = caster:FindTalentValue("special_bonus_imba_omniknight_4")

        -- Find a target to jump to
        local allies = FindUnitsInRadius(caster:GetTeamNumber(),
                                                 target:GetAbsOrigin(),
                                                 nil,
                                                 bounce_radius,
                                                 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                                 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                                 DOTA_UNIT_TARGET_FLAG_NONE,
                                                 FIND_ANY_ORDER,
                                                 false)

        -- Find a bounce target
        for _,ally in pairs(allies) do

            if ally ~= target then
                -- Purify it
                Purification(caster, ability, ally)

                -- Stop at the first valid bounce target
                break
            end
        end
    end
end

function Purification(caster, ability, target)
    -- Ability properties
    local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
    local particle_aoe = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
    local particle_hit = "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf"
    local modifier_purifiception = "modifier_imba_purification_buff"    

    -- Ability specials
    local heal_amount = ability:GetSpecialValueFor("heal_amount")
    local radius = ability:GetSpecialValueFor("radius")
    local purifiception_duration = ability:GetSpecialValueFor("purifiception_duration")    

    -- #8 Talent: Purification heal/damage increase
    heal_amount = heal_amount + caster:FindTalentValue("special_bonus_imba_omniknight_8")

    -- Add cast particle
    local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(particle_cast_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(particle_cast_fx, 1, target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle_cast_fx)

    -- Add AoE particle
    local particle_aoe_fx = ParticleManager:CreateParticle(particle_aoe, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(particle_aoe_fx, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_aoe_fx, 1, Vector(radius, 1, 1))
    ParticleManager:ReleaseParticleIndex(particle_aoe_fx)    

    -- Get spell power
    local spell_power = caster:GetSpellAmplification(false)

    -- Calculate final heal/damage values
    local heal = heal_amount * (1+ (spell_power * 0.01))
    local damage = heal

    -- Heal target
    target:Heal(heal, caster)    
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, heal, nil)

    -- Find enemies around it
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                      target:GetAbsOrigin(),
                                      nil,
                                      radius,
                                      DOTA_UNIT_TARGET_TEAM_ENEMY,
                                      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                      DOTA_UNIT_TARGET_FLAG_NONE,
                                      FIND_ANY_ORDER,
                                      false)

    
    for _,enemy in pairs(enemies) do
        -- If they're not magic immune, damage them
        if not enemy:IsMagicImmune() then
            local damageTable = {victim = enemy,
                                 attacker = caster, 
                                 damage = damage,
                                 damage_type = DAMAGE_TYPE_PURE,
                                 damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
                                 ability = ability
                                }
        
            ApplyDamage(damageTable)  

            -- Add hit particle
            local particle_hit_fx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, enemy)
            ParticleManager:SetParticleControlEnt(particle_hit_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(particle_hit_fx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
            ParticleManager:SetParticleControl(particle_hit_fx, 3, Vector(radius, 0, 0))
            ParticleManager:ReleaseParticleIndex(particle_hit_fx)
        end
    end        

    -- Add Purifiception buff to target if it doesn't have it yet
    if not target:HasModifier(modifier_purifiception) then
        target:AddNewModifier(caster, ability, modifier_purifiception, {duration = purifiception_duration})
    end    

    -- Just refresh it (stack will be given through OnHealRecieved)
    local modifier_purifiception_handler = target:FindModifierByName(modifier_purifiception)

    if modifier_purifiception_handler then
       modifier_purifiception_handler:ForceRefresh() 
    end    
end


-- Purifiception modifier
modifier_imba_purification_buff = class({})

function modifier_imba_purification_buff:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()    

    -- Ability specials 
    self.purifiception_heal_amp_pct = self.ability:GetSpecialValueFor("purifiception_heal_amp_pct")
    self.purifiception_max_stacks = self.ability:GetSpecialValueFor("purifiception_max_stacks")
    self.purifiception_stack_threshold = self.ability:GetSpecialValueFor("purifiception_stack_threshold")

    -- Set stacks
    self:SetStackCount(1)
end

function modifier_imba_purification_buff:IsHidden() return false end
function modifier_imba_purification_buff:IsPurgable() return true end
function modifier_imba_purification_buff:IsDebuff() return false end

function modifier_imba_purification_buff:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE,
                      MODIFIER_EVENT_ON_HEALTH_GAINED}
                
    return decFuncs
end

function modifier_imba_purification_buff:GetEffectName()
    return "particles/hero/omniknight/purification_buff.vpcf"    
end

function modifier_imba_purification_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_purification_buff:GetModifierHealAmplify_Percentage(keys)            
    local stacks = self:GetStackCount()

    return self.purifiception_heal_amp_pct * stacks
end


function modifier_imba_purification_buff:OnHealthGained(keys)    
    if IsServer() then               
        -- Only apply on the parent getting heals
        if keys.unit == self.parent then            
            -- Only apply if was healed over the threshold            
            if keys.gain and keys.gain >= self.purifiception_stack_threshold then                
                self:IncrementStackCount()
            end
        end
    end
end

function modifier_imba_purification_buff:OnStackCountChanged()
    if IsServer() then
        local stacks = self:GetStackCount()

        if stacks > self.purifiception_max_stacks then
            self:SetStackCount(self.purifiception_max_stacks)
        end
    end
end



-- Purification Omniguard - ready mode
modifier_imba_purification_omniguard_ready = class({})

function modifier_imba_purification_omniguard_ready:OnCreated()            
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.modifier_recharge = "modifier_imba_purification_omniguard_recharging"                

        -- If the caster has modifier recharge, commit soduku
        if self.caster:HasModifier(self.modifier_recharge) then
            self:Destroy()
        end
end

function modifier_imba_purification_omniguard_ready:IsHidden()
    if self.caster:HasTalent("special_bonus_imba_omniknight_2") then
        return false
    end

    return true
end

function modifier_imba_purification_omniguard_ready:IsPurgable() return false end
function modifier_imba_purification_omniguard_ready:IsDebuff() return false end



function modifier_imba_purification_omniguard_ready:DeclareFunctions()
    local decFuncs = {MODIFIER_EVENT_ON_TAKEDAMAGE}

    return decFuncs
end

function modifier_imba_purification_omniguard_ready:OnTakeDamage(keys)
    if IsServer() then
        local unit = keys.unit        

        -- Only apply on the caster getting damaged
        if self.caster == unit then

            -- If the caster doesn't have the talent, do nothing
            if not self.caster:HasTalent("special_bonus_imba_omniknight_2") then
                return nil
            end

            -- If the caster is broken, do nothing
            if self.caster:PassivesDisabled() then
                return nil
            end

            -- #2 Talent: Purification auto cast on critical health
            self.cooldown = self.caster:FindTalentValue("special_bonus_imba_omniknight_2", "cooldown")
            self.trigger_hp_pct = self.caster:FindTalentValue("special_bonus_imba_omniknight_2", "trigger_hp_pct")

            -- Get caster's HP
            local current_health_pct = self.caster:GetHealthPercent()

            -- If the caster's health is below the threshold, activate!
            if current_health_pct <= self.trigger_hp_pct and not self.caster:HasModifier(self.modifier_recharge) then

                -- Apply recharge modifier
                self.caster:AddNewModifier(self.caster, self.ability, self.modifier_recharge, {duration = self.cooldown})

                -- Boom!
                Purification(self.caster, self.ability, self.caster)

                -- Remove self
                self:Destroy()
            end
        end
    end
end

-- Purification Omniguard - recharging
modifier_imba_purification_omniguard_recharging = class({})

function modifier_imba_purification_omniguard_recharging:OnCreated()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.modifier_omniguard = "modifier_imba_purification_omniguard_ready"
end

function modifier_imba_purification_omniguard_recharging:IsHidden() return false end
function modifier_imba_purification_omniguard_recharging:IsPurgable() return false end
function modifier_imba_purification_omniguard_recharging:IsDebuff() return false end

function modifier_imba_purification_omniguard_recharging:GetTexture()
    return "custom/omnikinight_purification_cooldown"
end

function modifier_imba_purification_omniguard_recharging:OnDestroy()
    if IsServer() then
        self.caster:AddNewModifier(self.caster, self.ability, self.modifier_omniguard, {})
    end
end


-----------------------------------
--            REPEL              --
-----------------------------------

imba_omniknight_repel = class({})
LinkLuaModifier("modifier_imba_repel", "components/abilities/heroes/hero_omniknight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_degen_aura", "components/abilities/heroes/hero_omniknight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_degen_debuff", "components/abilities/heroes/hero_omniknight.lua", LUA_MODIFIER_MOTION_NONE)

function imba_omniknight_repel:GetAbilityTextureName()
   return "omniknight_repel"
end

function imba_omniknight_repel:IsHiddenWhenStolen()
    return false
end

function imba_omniknight_repel:GetIntrinsicModifierName()
    return "modifier_imba_degen_aura"
end

function imba_omniknight_repel:OnUnStolen()
    local caster = self:GetCaster()
    local modifier_degen = "modifier_imba_degen_aura"

    -- Remvoe Degen Aura from Rubick
    if caster:HasModifier(modifier_degen) then
        caster:RemoveModifierByName(modifier_degen)
    end
end

function imba_omniknight_repel:GetAOERadius()
	if self:GetCaster():HasTalent("special_bonus_imba_omniknight_6") then
		return self:GetCaster():FindTalentValue("special_bonus_imba_omniknight_6", "radius")
	else
		return 0
	end
end

function imba_omniknight_repel:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorTarget() 
    local target_cast_response = "omniknight_omni_ability_repel_0"..math.random(1,6)
    local self_cast_response = {"omniknight_omni_ability_repel_01", "omniknight_omni_ability_repel_05", "omniknight_omni_ability_repel_06"}
    local sound_cast = "Hero_Omniknight.Repel"    

    -- Ability specials
    local duration = ability:GetSpecialValueFor("duration")    

    -- Target cast responses
    if target ~= caster then
        EmitSoundOn(target_cast_response, caster)
    else
        -- Self cast responses
        EmitSoundOn(self_cast_response[math.random(1, #self_cast_response)], caster)
    end

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)    

    -- Repel the target
    Repel(caster, ability, target, duration)

    -- #6 Talent: Repel affects nearby allies briefly
    if caster:HasTalent("special_bonus_imba_omniknight_6") then
        -- Talent values
        local radius = caster:FindTalentValue("special_bonus_imba_omniknight_6", "radius")
        local talent_duration = caster:FindTalentValue("special_bonus_imba_omniknight_6", "duration")

        -- Find all nearby allies
        local allies = FindUnitsInRadius(caster:GetTeamNumber(),
                                         target:GetAbsOrigin(),
                                         nil,
                                         radius,
                                         DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                         DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                         DOTA_UNIT_TARGET_FLAG_NONE,
                                         FIND_ANY_ORDER,
                                         false)

        -- Repel all allies except the target
        for _, ally in pairs(allies) do
            if ally ~= target then
                --Repel(caster, ability, ally, talent_duration)
				-- Lets make it just last for whole duration cause no one gets this thing otherwise
				Repel(caster, ability, ally, duration)
            end
        end
    end
end

function Repel(caster, ability, target, duration)
    -- Ability properties
    local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_repel_cast.vpcf"
    local modifier_repel = "modifier_imba_repel"
    local modifier_degen_aura = "modifier_imba_degen_aura"    

    -- Add particle effect
    local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())

    -- Apply a strong dispel on target
    target:Purge(false, true, false, true, true)

    -- Give target Repel buff and Degen Aura buffs
    target:AddNewModifier(caster, ability, modifier_repel, {duration = duration})

    -- Give auras to targets other than the caster
    if target ~= caster then
        target:AddNewModifier(caster, ability, modifier_degen_aura, {duration = duration})
    end
end


-- Repel modifier
modifier_imba_repel = class({})

function modifier_imba_repel:IsHidden() return false end
function modifier_imba_repel:IsPurgable() return false end
function modifier_imba_repel:IsDebuff() return false end

function modifier_imba_repel:CheckState()
    local state = {[MODIFIER_STATE_MAGIC_IMMUNE] = true}
    return state
end

function modifier_imba_repel:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}

    return decFuncs
end

function modifier_imba_repel:GetModifierMagicalResistanceBonus()
    return 100
end

function modifier_imba_repel:GetEffectName()
    return "particles/units/heroes/hero_omniknight/omniknight_repel_buff.vpcf"
end

function modifier_imba_repel:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


-- Degen Aura
modifier_imba_degen_aura = class({})

function modifier_imba_degen_aura:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    -- Ability specials
    self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
    self.linger_duration = self.ability:GetSpecialValueFor("linger_duration")
end

function modifier_imba_degen_aura:GetEffectName()
    return "particles/auras/aura_degen.vpcf"
end

function modifier_imba_degen_aura:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_degen_aura:GetAuraDuration()
    return self.linger_duration
end

function modifier_imba_degen_aura:GetAuraRadius()
    return self.aura_radius
end

function modifier_imba_degen_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_degen_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_degen_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_degen_aura:GetModifierAura()
    return "modifier_imba_degen_debuff"
end

function modifier_imba_degen_aura:IsAura()
    if self.caster:PassivesDisabled() then
        return false
    end

    return true
end

function modifier_imba_degen_aura:IsHidden() return true end
function modifier_imba_degen_aura:IsPurgable() return false end
function modifier_imba_degen_aura:IsDebuff() return false end

function modifier_imba_degen_aura:OnRefresh()
    self:OnCreated()
end

-- Degen slow debuff 
modifier_imba_degen_debuff = class({})

function modifier_imba_degen_debuff:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    -- Ability specials
    self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
    self.as_slow = self.ability:GetSpecialValueFor("as_slow")

    -- #3 Talent: Increases Degen Aura's move and attack speed slows 
    self.ms_slow_pct = self.ms_slow_pct + self.caster:FindTalentValue("special_bonus_imba_omniknight_3")
    self.as_slow = self.as_slow + self.caster:FindTalentValue("special_bonus_imba_omniknight_3")
end

function modifier_imba_degen_debuff:GetEffectName()
    return "particles/units/heroes/hero_omniknight/omniknight_degen_aura_debuff.vpcf"    
end

function modifier_imba_degen_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_imba_degen_debuff:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
                      MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

    return decFuncs
end

function modifier_imba_degen_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.ms_slow_pct * (-1)
end

function modifier_imba_degen_debuff:GetModifierAttackSpeedBonus_Constant()
    return self.as_slow * (-1)
end

function modifier_imba_degen_debuff:GetTexture()
    return "omniknight_degen_aura"
end





-----------------------------------
--       HAMMER OF VIRTUE        --
-----------------------------------

imba_omniknight_hammer_of_virtue = class({})
LinkLuaModifier("modifier_imba_hammer_of_virtue", "components/abilities/heroes/hero_omniknight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hammer_of_virtue_nodamage", "components/abilities/heroes/hero_omniknight.lua", LUA_MODIFIER_MOTION_NONE)

function imba_omniknight_hammer_of_virtue:OnToggle() return end

function imba_omniknight_hammer_of_virtue:OnSpellStart() 
	if IsServer() then
		-- Force attack the target
		local caster = self:GetCaster()
		caster:MoveToTargetToAttack(self:GetCursorTarget())
		-- If manually casted, reset CD, CD getting applied on hit
		self:EndCooldown()
		self.isAutoAttack = false 
	end   
end

-- THIS IF VERY FRAGILE CODE, EVEN PRINTING IT WILL FUCK THINGS UP
function imba_omniknight_hammer_of_virtue:IsAutoAttack()
	if self.isAutoAttack ~= nil then
		-- Reset auto attack checker
		local original_value = self.isAutoAttack
		self.isAutoAttack = true 
		
		return original_value
	end
	return true 
end

function imba_omniknight_hammer_of_virtue:IsStealable()
	return false
end

-- function imba_omniknight_hammer_of_virtue:GetCastRange(location, target)
    -- return self:GetCaster():Script_Script_GetAttackRange() 
-- end

function imba_omniknight_hammer_of_virtue:GetAbilityTextureName()
   return "custom/omniknight_hammer_of_virtue"
end

function imba_omniknight_hammer_of_virtue:GetIntrinsicModifierName()
    return "modifier_imba_hammer_of_virtue"
end

-- Hammer of virtue passive modifier
modifier_imba_hammer_of_virtue = class({})

function modifier_imba_hammer_of_virtue:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()    
        self.particle_heal = "particles/hero/omniknight/hammer_of_virtue_heal.vpcf"
        self.particle_hit = "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf"
        self.modifier_nodmg = "modifier_imba_hammer_of_virtue_nodamage"
		self.IsAutoAttack = self.ability:IsAutoAttack() 

		--  When first learned, activate auto-cast.
		if not self.toggled_on_default then
            self.toggled_on_default = true
            self.ability:ToggleAutoCast()
        end
	
        -- Ability specials
        self.radius = self.ability:GetSpecialValueFor("radius")
        self.damage_as_heal_pct = self.ability:GetSpecialValueFor("damage_as_heal_pct")
    end 
end


function modifier_imba_hammer_of_virtue:DeclareFunctions()
    local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED,
						
	}

    return decFuncs
end

function modifier_imba_hammer_of_virtue:OnAttackLanded(keys)
    if IsServer() then
        local attacker = keys.attacker
        local target = keys.target
        local damage = keys.original_damage

        -- #1 Talent: Hammer of Virtue heal increase
        if self.caster:HasTalent("special_bonus_imba_omniknight_1") and not self.talent_1_leveled then
            self.damage_as_heal_pct = self.damage_as_heal_pct + self.caster:FindTalentValue("special_bonus_imba_omniknight_1")        
            self.talent_1_leveled = true            
        end
        
        -- Only apply on caster attacking
        if self.caster == attacker then

            -- If the ability is on cooldown, do nothing
            if not self.ability:IsCooldownReady() then
                return nil
            end
			
			-- If auto cast is disabled then don't apply automaticly
			if self.ability:IsAutoAttack() and not self.ability:GetAutoCastState() then
				return nil
			end
			
            -- If the attack was on a teammate, do nothing
            if self.caster:GetTeamNumber() == target:GetTeamNumber() then
                return nil
            end

            -- If the attacker is broken, do nothing
            if self.caster:PassivesDisabled() then
                return nil
            end

            -- if the target is a ward or a building, do nothing
            if not target:IsHero() and not target:IsCreep() then
                return nil
            end

            -- Add hit particle effect
            self.particle_hit_fx = ParticleManager:CreateParticle(self.particle_hit, PATTACH_ABSORIGIN_FOLLOW, target)
            ParticleManager:SetParticleControlEnt(self.particle_hit_fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(self.particle_hit_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
            --ParticleManager:SetParticleControl(self.particle_hit_fx, 3, Vector(0, 0, 0))
            ParticleManager:ReleaseParticleIndex(self.particle_hit_fx)

            -- Apply no damage buff
            self.caster:AddNewModifier(self.caster, self.ability, self.modifier_nodmg, {duration = 0.1})
            target:AddNewModifier(self.caster, self.ability, self.modifier_nodmg, {duration = 0.1})

            -- Damage the target with pure light powa
            local damageTable = {victim = target,
                                 attacker = self.caster, 
                                 damage = damage,
                                 damage_type = DAMAGE_TYPE_PURE,
                                 ability = ability
                                }
            
            ApplyDamage(damageTable)  
            
            -- Find all nearby allies
            local allies = FindUnitsInRadius(self.caster:GetTeamNumber(),
                                             self.caster:GetAbsOrigin(),
                                             nil,
                                             self.radius,
                                             DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                             DOTA_UNIT_TARGET_HERO,
                                             DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
                                             FIND_ANY_ORDER,
                                             false)

            -- Heal them (and the caster)
            local heal = damage * self.damage_as_heal_pct * 0.01
            for _,ally in pairs(allies) do
                ally:Heal(heal, self.caster)

                -- Apply heal effect
                self.particle_heal_fx = ParticleManager:CreateParticle(self.particle_heal, PATTACH_ABSORIGIN_FOLLOW, ally)
                ParticleManager:SetParticleControl(self.particle_heal_fx, 0, ally:GetAbsOrigin())
            end

            -- Start the cooldown of the ability
            self.ability:UseResources(false, false, true)
			
			
        end
    end
end

function modifier_imba_hammer_of_virtue:IsHidden() return true end
function modifier_imba_hammer_of_virtue:IsPurgable() return false end
function modifier_imba_hammer_of_virtue:IsDebuff() return false end
function modifier_imba_hammer_of_virtue:RemoveOnDeath() return false end

function modifier_imba_hammer_of_virtue:OnRefresh()
    self:OnCreated()
end

-- Hammer of Virtue no damage buff

modifier_imba_hammer_of_virtue_nodamage =class({})

function modifier_imba_hammer_of_virtue_nodamage:IsHidden() return true end
function modifier_imba_hammer_of_virtue_nodamage:IsDebuff() return false end
function modifier_imba_hammer_of_virtue_nodamage:IsPurgable() return false end

-- Declare modifier events/properties
function modifier_imba_hammer_of_virtue_nodamage:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL}

    return decFuncs
end

function modifier_imba_hammer_of_virtue_nodamage:GetAbsoluteNoDamagePhysical()
    return 1 
end


-----------------------------------
--        GUARDIAN ANGEL         --
-----------------------------------

imba_omniknight_guardian_angel = class({})
LinkLuaModifier("modifier_imba_guardian_angel", "components/abilities/heroes/hero_omniknight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_guardian_angel_shield", "components/abilities/heroes/hero_omniknight.lua", LUA_MODIFIER_MOTION_NONE)

function imba_omniknight_guardian_angel:GetAbilityTextureName()
   return "omniknight_guardian_angel"
end

function imba_omniknight_guardian_angel:IsHiddenWhenStolen()
    return false
end

function imba_omniknight_guardian_angel:GetCooldown(level)
local caster = self:GetCaster()
local cooldown = self.BaseClass.GetCooldown(self, level)

	-- #7 Talent: Guardian Angel cooldown decrease
	cooldown = cooldown - caster:FindTalentValue("special_bonus_imba_omniknight_7")

    return cooldown    
end

function imba_omniknight_guardian_angel:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end

function imba_omniknight_guardian_angel:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local cast_response = {"omniknight_omni_ability_guard_04", "omniknight_omni_ability_guard_05", "omniknight_omni_ability_guard_06", "omniknight_omni_ability_guard_10"}
    local sound_cast = "Hero_Omniknight.GuardianAngel.Cast"
    local modifier_angel = "modifier_imba_guardian_angel"
    local scepter = caster:HasScepter()

    -- Ability specials
    local duration = ability:GetSpecialValueFor("duration")
    local scepter_duration = ability:GetSpecialValueFor("scepter_duration")
    local radius = ability:GetSpecialValueFor("radius")    

    -- Roll a cast response
    EmitSoundOn(cast_response[math.random(1, #cast_response)], caster)

    -- Play cast sound
    EmitSoundOn(sound_cast, caster)

    -- If caster has scepter, assign values
    if scepter then
        duration = scepter_duration
        radius = 25000 -- global
    end

    -- Find all nearby allied unit
    local allies = FindUnitsInRadius(caster:GetTeamNumber(),
                                     caster:GetAbsOrigin(),
                                     nil,
                                     radius,
                                     DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                     DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
                                     DOTA_UNIT_TARGET_FLAG_NONE,
                                     FIND_ANY_ORDER,
                                     false)

    -- Grant them the guardian angel buff
    for _,ally in pairs(allies) do
        ally:AddNewModifier(caster, ability, modifier_angel, {duration = duration})
    end
end


-- Physical immunity modifier
modifier_imba_guardian_angel = class({})

function modifier_imba_guardian_angel:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.particle_wings = "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf"
    self.particle_ally = "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf"    
    self.particle_halo = "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf"
    self.modifier_shield = "modifier_imba_guardian_angel_shield"

    -- Ability specials
    self.shield_duration = self.ability:GetSpecialValueFor("shield_duration")    

    -- If this is the caster, give him an halo and wings! He deserve them!
    if self.parent == self.caster then
        self.particle_wings_fx = ParticleManager:CreateParticle(self.particle_wings, PATTACH_ABSORIGIN_FOLLOW, self.parent)
        ParticleManager:SetParticleControl(self.particle_wings_fx, 0, self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControlEnt(self.particle_wings_fx, 5, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        self:AddParticle(self.particle_wings_fx, false, false, -1, false, false)    

        -- Halo particle
        self.particle_halo_fx = ParticleManager:CreateParticle(self.particle_halo, PATTACH_OVERHEAD_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt(self.particle_halo_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)    
        self:AddParticle(self.particle_halo_fx, false, false, -1, false, false)    

    -- Else, play regular particle
    else
        self.particle_ally_fx = ParticleManager:CreateParticle(self.particle_ally, PATTACH_ABSORIGIN_FOLLOW, self.parent)
        ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self.parent:GetAbsOrigin())
        self:AddParticle(self.particle_ally_fx, false, false, -1, false, false)    
    end    
end

function modifier_imba_guardian_angel:OnRefresh()
	self:OnCreated()
end

function modifier_imba_guardian_angel:GetStatusEffectName()
    return "particles/status_fx/status_effect_guardian_angel.vpcf"
end

function modifier_imba_guardian_angel:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL}

    return decFuncs
end

function modifier_imba_guardian_angel:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_imba_guardian_angel:IsHidden() return false end
function modifier_imba_guardian_angel:IsPurgable() return true end
function modifier_imba_guardian_angel:IsDebuff() return false end

function modifier_imba_guardian_angel:OnDestroy()
    if IsServer() and (self:GetElapsedTime() >= self.shield_duration) then
        self.parent:AddNewModifier(self.caster, self.ability, self.modifier_shield, {duration = self.shield_duration})
    end
end

-- Guardian Shield modifier
modifier_imba_guardian_angel_shield = class({})

function modifier_imba_guardian_angel_shield:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()

        -- Ability specials
        self.max_hp_shield_health_pct = self.ability:GetSpecialValueFor("max_hp_shield_health_pct")

        -- #5 Talent: Guardian Angel Shield health increase
        self.max_hp_shield_health_pct = self.max_hp_shield_health_pct + self.caster:FindTalentValue("special_bonus_imba_omniknight_5")        

        -- Assign the maximum capability of the shield depending on parent's max HP
        self.shield_health = self.parent:GetMaxHealth() * self.max_hp_shield_health_pct * 0.01        
    end
end

function modifier_imba_guardian_angel_shield:GetEffectName()
    return "particles/hero/omniknight/guardian_angel_shield.vpcf"
end

function modifier_imba_guardian_angel_shield:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_guardian_angel_shield:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_AVOID_DAMAGE,
                      MODIFIER_EVENT_ON_TAKEDAMAGE}

    return decFuncs
end

function modifier_imba_guardian_angel_shield:GetModifierAvoidDamage()
    return 1
end

function modifier_imba_guardian_angel_shield:OnTakeDamage(keys)
    if IsServer() then
        local original_damage = keys.original_damage        
        local damage_type = keys.damage_type
        local unit = keys.unit
        local attacker = keys.attacker
        local damage

        -- Only apply on the parent being attacked
        if self.parent == unit then                        
            -- If the damage was pure, deal original damage with no changes
            if damage_type == DAMAGE_TYPE_PURE then
                damage = original_damage

            -- If the damage was magical, reduce damage according to magical resistance
            elseif damage_type == DAMAGE_TYPE_MAGICAL then
                local magic_res = self.parent:GetMagicalArmorValue()
                damage = original_damage * (1 - magic_res)

            -- Physical damage
            else
                local armornpc = self.parent:GetPhysicalArmorValue()
                local physical_reduction = 1 - (0.06 * armornpc) / (1 + (0.06 * math.abs(armornpc)))
                physical_reduction = 100 - (physical_reduction * 100)                
                damage = original_damage * (1 - physical_reduction * 0.01)
            end            

            -- Check if the shield is broken from excess damage
            if self.shield_health <= damage then                          

                -- Remove the shield
                self:Destroy()

                -- Deal excess damage to the target
                local excess_damage = damage - self.shield_health

                local damageTable = {victim = self.parent,
                                     attacker = attacker, 
                                     damage = damage,
                                     damage_type = DAMAGE_TYPE_PURE,
                                     ability = ability
                                    }
        
                ApplyDamage(damageTable)                  

            else
                -- Shield is not broken. Reduce the shield health
                self.shield_health = self.shield_health - damage                
            end
        end
    end
end

function modifier_imba_guardian_angel_shield:IsHidden() return false end
function modifier_imba_guardian_angel_shield:IsPurgable() return true end
function modifier_imba_guardian_angel_shield:IsDebuff() return false end

-- Client-side helper functions --

LinkLuaModifier("modifier_special_bonus_imba_omniknight_6", "components/abilities/heroes/hero_omniknight", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_omniknight_7", "components/abilities/heroes/hero_omniknight", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_omniknight_6 = class({})
function modifier_special_bonus_imba_omniknight_6:IsHidden() 		return true end
function modifier_special_bonus_imba_omniknight_6:IsPurgable() 		return false end
function modifier_special_bonus_imba_omniknight_6:RemoveOnDeath() 	return false end

modifier_special_bonus_imba_omniknight_7 = class({})
function modifier_special_bonus_imba_omniknight_7:IsHidden() 		return true end
function modifier_special_bonus_imba_omniknight_7:IsPurgable() 		return false end
function modifier_special_bonus_imba_omniknight_7:RemoveOnDeath() 	return false end

function imba_omniknight_repel:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_omniknight_6") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_omniknight_6") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_omniknight_6", {})
	end
end

function imba_omniknight_guardian_angel:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_omniknight_7") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_omniknight_7") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_omniknight_7", {})
	end
end