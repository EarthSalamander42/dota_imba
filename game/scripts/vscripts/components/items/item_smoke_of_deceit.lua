item_imba_smoke_of_deceit = item_imba_smoke_of_deceit or class({})

LinkLuaModifier("modifier_imba_smoke_of_deceit", "components/items/item_smoke_of_deceit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_smoke_of_deceit_surprise", "components/items/item_smoke_of_deceit", LUA_MODIFIER_MOTION_NONE)

---------------------
-- SMOKE OF DECEIT --
---------------------

function item_imba_smoke_of_deceit:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local sound_cast = "DOTA_Item.SmokeOfDeceit.Activate"    
    local modifier_smoke = "modifier_imba_smoke_of_deceit"    

    -- Ability specials
    local application_radius = ability:GetSpecialValueFor("application_radius")
    local smoke_duration = ability:GetSpecialValueFor("smoke_duration")    

    -- Emit cast sound
    EmitSoundOn(sound_cast, caster)

    -- Find all allies and all allied player-controlled units
    local allies = FindUnitsInRadius(caster:GetTeamNumber(),
                                     caster:GetAbsOrigin(),
                                     nil,
                                     application_radius,
                                     DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                     DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                     DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
                                     FIND_ANY_ORDER,
                                     false)       

    -- Give modifier to allies
    for _,ally in pairs(allies) do
        -- For each ally, give it the smoke modifier
        ally:AddNewModifier(caster, ability, modifier_smoke, {duration = smoke_duration})        
    end

    -- Decrease charges (in case more than one is bought), or destroy if it was the only charge left
    ability:SpendCharge()
end

------------------------------
-- SMOKE OF DECEIT MODIFIER --
------------------------------

modifier_imba_smoke_of_deceit = modifier_imba_smoke_of_deceit or class({})

function modifier_imba_smoke_of_deceit:IsHidden() return false end
function modifier_imba_smoke_of_deceit:IsDebuff() return false end
function modifier_imba_smoke_of_deceit:IsPurgable() return false end

function modifier_imba_smoke_of_deceit:GetTexture()
    return "item_smoke_of_deceit"
end

function modifier_imba_smoke_of_deceit:GetTexture()
    return "item_smoke_of_deceit"
end

function modifier_imba_smoke_of_deceit:GetEffectName()
    return "particles/generic_gameplay/dropped_smoke.vpcf"
end

function modifier_imba_smoke_of_deceit:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_smoke_of_deceit:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.modifier_smoke = "modifier_imba_smoke_of_deceit"
    self.modifier_surprise = "modifier_imba_smoke_of_deceit_surprise"

    -- Ability specials
    self.visibility_radius = self.ability:GetSpecialValueFor("visibility_radius")
    self.movespeed_bonus_pct = self.ability:GetSpecialValueFor("movespeed_bonus_pct")
    self.surprise_atk_delay = self.ability:GetSpecialValueFor("surprise_atk_delay")
    self.surprise_atk_duration = self.ability:GetSpecialValueFor("surprise_atk_duration")
    self.surprise_atk_damage_pct = self.ability:GetSpecialValueFor("surprise_atk_damage_pct")
    self.surprise_atk_spell_amp = self.ability:GetSpecialValueFor("surprise_atk_spell_amp")
    self.surprise_atk_hit_count = self.ability:GetSpecialValueFor("surprise_atk_hit_count")
    self.gank_unit_radius = self.ability:GetSpecialValueFor("gank_unit_radius")    
    self.gank_hero_ms_bonus_pct = self.ability:GetSpecialValueFor("gank_hero_ms_bonus_pct")
    self.gank_unit_ms_bonus_pct = self.ability:GetSpecialValueFor("gank_unit_ms_bonus_pct")

    -- Attache surprise attack properties to parent so it can get the properties if last Smoke was consumed
    self.parent.smoke_of_deceit_surprise_atk_damage_pct = self.surprise_atk_damage_pct
    self.parent.smoke_of_deceit_surprise_atk_spell_amp = self.surprise_atk_spell_amp
    self.parent.smoke_of_deceit_surprise_atk_hit_count = self.surprise_atk_hit_count

    if IsServer() then
        -- Start interval think
        self:StartIntervalThink(0.2)
    end
end

function modifier_imba_smoke_of_deceit:OnIntervalThink()
    if not IsServer() then return end

    -- Get enemies and towers inside the visibility radius
    local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),
                                      self.parent:GetAbsOrigin(),
                                      nil,
                                      self.visibility_radius,
                                      DOTA_UNIT_TARGET_TEAM_ENEMY,
                                      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING,
                                      DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
                                      FIND_ANY_ORDER,
                                      false)    

    for _,enemy in pairs(enemies) do
        if enemy:IsRealHero() or enemy:IsClone() or enemy:IsTower() then
            -- Found valid enemy in range - surprise attack! 
            self:SurpriseAttack()

            -- Destroy modifier
            self:Destroy()
            return nil
        end
    end

    -- Gank Formation: find how many allied units are near you    
    local allies = FindUnitsInRadius(self.parent:GetTeamNumber(),
                                     self.parent:GetAbsOrigin(),
                                     nil,
                                     self.gank_unit_radius,
                                     DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                     DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                     DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
                                     FIND_ANY_ORDER,
                                     false)  

    -- Gank Formation: All affected units give bonus speed. Heroes give more than units.
    local stacks = 0

    for _,ally in pairs(allies) do

        -- Check if this is a hero or a player controlled creep (creep heroes are considered creeps).
        -- Only count units with the smoke modifier
        if ally:HasModifier(self.modifier_smoke) then

            -- Illusions do not count towards 
            if ally:IsIllusion() then            
                stacks = stacks + 0        
                -- Heroes stack count
            elseif ally:IsRealHero() then
                stacks = stacks + self.gank_hero_ms_bonus_pct
            else
                -- Anything else should be all player controlled units
                stacks = stacks + self.gank_unit_ms_bonus_pct
            end
        end
    end

    -- Give yourself stacks depending on how many stacks were accumulated by units around you
    self:SetStackCount(stacks)                                   
end

function modifier_imba_smoke_of_deceit:CheckState()
    local state = {[MODIFIER_STATE_INVISIBLE] = true,
                   [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true}
    return state
end

function modifier_imba_smoke_of_deceit:GetPriority()
    return MODIFIER_PRIORITY_NORMAL
end


function modifier_imba_smoke_of_deceit:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
                      MODIFIER_PROPERTY_INVISIBILITY_LEVEL,        
                      MODIFIER_EVENT_ON_ATTACK_FINISHED}

    return decFuncs
end

function modifier_imba_smoke_of_deceit:GetModifierMoveSpeedBonus_Percentage()
    -- Each stack increases movespeed bonus by 1%
    local ms_bonus = self.movespeed_bonus_pct + self:GetStackCount()
    return ms_bonus
end

function modifier_imba_smoke_of_deceit:GetModifierInvisibilityLevel()
    return 1
end

function modifier_imba_smoke_of_deceit:OnAttackFinished(keys)
    if not IsServer() then return end

    local attacker = keys.attacker
    local target = keys.target

    -- Only apply if the the attacker is the parent of this modifier
    if self.parent == attacker then
        self:SurpriseAttack()

        -- Remove invisibility!
        self:Destroy()
    end
end

function modifier_imba_smoke_of_deceit:SurpriseAttack()
    if not IsServer() then return end

    -- If the delay time did not elapse since starting the smoke, do nothing
    if self:GetElapsedTime() < self.surprise_atk_delay then
        return nil
    end

    -- Start the surprise attack! Give self modifier
    self.parent:AddNewModifier(self.caster, self.ability, self.modifier_surprise, {duration = self.surprise_atk_duration})
end

----------------------------------------------
-- SMOKE OF DECEIT SURPRISE ATTACK MODIFIER --
----------------------------------------------

modifier_imba_smoke_of_deceit_surprise = modifier_imba_smoke_of_deceit_surprise or class({})

function modifier_imba_smoke_of_deceit_surprise:IsHidden() return false end
function modifier_imba_smoke_of_deceit_surprise:IsDebuff() return false end
function modifier_imba_smoke_of_deceit_surprise:IsPurgable() return true end

function modifier_imba_smoke_of_deceit_surprise:GetTexture()
    return "item_smoke_of_deceit"
end

function modifier_imba_smoke_of_deceit_surprise:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

    -- Ability properties
    self.caster = self:GetCaster()
    self.parent = self:GetParent()

    -- Ability specials (taken from parent in case ability no longer exists and cannot be referenced)
    self.surprise_atk_damage_pct = self.parent.smoke_of_deceit_surprise_atk_damage_pct 
    self.surprise_atk_spell_amp = self.parent.smoke_of_deceit_surprise_atk_spell_amp 
    self.surprise_atk_hit_count = self.parent.smoke_of_deceit_surprise_atk_hit_count     

    -- Clear values from parent
    self.parent.smoke_of_deceit_surprise_atk_damage_pct = nil
    self.parent.smoke_of_deceit_surprise_atk_spell_amp = nil
    self.parent.smoke_of_deceit_surprise_atk_hit_count = nil    

    -- Set stack count
    self:SetStackCount(self.surprise_atk_hit_count)
end

function modifier_imba_smoke_of_deceit_surprise:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                      MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
                      MODIFIER_EVENT_ON_TAKEDAMAGE}

    return decFuncs
end

function modifier_imba_smoke_of_deceit_surprise:GetModifierSpellAmplify_Percentage()
    return self.surprise_atk_spell_amp
end

function modifier_imba_smoke_of_deceit_surprise:GetModifierBaseDamageOutgoing_Percentage()
    return self.surprise_atk_damage_pct
end

function modifier_imba_smoke_of_deceit_surprise:OnTakeDamage(keys)
    if not IsServer() then return end

    local attacker = keys.attacker
    local target = keys.unit
    local damage = keys.damage

    -- Do nothing if the attacker wasn't the parent
    if attacker == self.parent then
        -- Show instance of damage in bold so people will notice it!
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, damage, nil)

        -- Reduce an instance of this modifier, or destroy it if it's up
        if self:GetStackCount() > 1 then
            self:DecrementStackCount()
        else
            self:Destroy()
        end        
    end

end

