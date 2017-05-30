
-- Copy shallow copy given input
local function ShallowCopy(orig)
    local copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    return copy
end

local function RetrieveValueFromTalentTable(talent_name, level)
    local e
    if IsServer() then
        e = "server"
    else
        e = "client"
    end

    if talent_name and level then
        local talent_kv = IMBA_GENERIC_TALENT_LIST[talent_name]
        if talent_kv then
            local values = talent_kv.value
            if values then
                -- Split the values by empty space
                local value_array = {}

                --Convert single line into table
                for v in values:gmatch("%S+") do
                    table.insert(value_array, v)
                end

                -- Can still return null here if level does not exist
                return value_array[level]
            else
                print("missing values "..e)
            end
        else
            print("missing talent_kv "..e)
        end
    else
        print("missing talent name or level "..e)
        print("talent_name "..talent_name)
        print("level"..level)
    end

    return nil
end

-- Base class with generic functions
local modifier_imba_generic_talent_base = class({
    IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
    IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
    AllowIllusionDuplicate	= function(self) return true end,
    IsPermanent             = function(self) return true end
})

function modifier_imba_generic_talent_base:_updateValue()
    local stack_count = self:GetStackCount()

    -- Can be 0 for server when first created
    if stack_count > 0 then
        local talent_name = self:GetName():gsub("modifier_", "")
        local table_value = RetrieveValueFromTalentTable(talent_name, stack_count)

        if table_value == nil then
            print("generic talent value not found "..e)
            --Remove if value not valid
            self:Destroy()
        else
            self.value = tonumber(table_value)
        end
    end
end

function modifier_imba_generic_talent_base:OnCreated()
    self:_updateValue()
end

function modifier_imba_generic_talent_base:OnRefresh()
    self:_updateValue()
end

-----------------------------
--		    Damage         --
-----------------------------
modifier_imba_generic_talent_damage = ShallowCopy(modifier_imba_generic_talent_base)

function modifier_imba_generic_talent_damage:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE }
	return funcs
end

function modifier_imba_generic_talent_damage:GetModifierBaseAttack_BonusDamage()
    return self.value
end

-----------------------------
--		  All Stats        --
-----------------------------
modifier_imba_generic_talent_all_stats = ShallowCopy(modifier_imba_generic_talent_base)

function modifier_imba_generic_talent_all_stats:DeclareFunctions()
    local funcs = { 
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }
	return funcs
end

function modifier_imba_generic_talent_all_stats:OnCreated()
    if IsServer() then
        Timers:CreateTimer(0.01, function()
            self:GetParent():CalculateStatBonus()
        end)
    end
end

function modifier_imba_generic_talent_all_stats:GetModifierBonusStats_Agility()
    return self.value
end
function modifier_imba_generic_talent_all_stats:GetModifierBonusStats_Intellect()
    return self.value
end
function modifier_imba_generic_talent_all_stats:GetModifierBonusStats_Strength()
    return self.value
end

-----------------------------
--		  Strength         --
-----------------------------
modifier_imba_generic_talent_strength = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_strength:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_STATS_STRENGTH_BONUS }
	return funcs
end

function modifier_imba_generic_talent_strength:OnCreated()
    if IsServer() then
        Timers:CreateTimer(0.01, function()
            self:GetParent():CalculateStatBonus()
        end)
    end
end

function modifier_imba_generic_talent_strength:GetModifierBonusStats_Strength()
    return self.value
end

-----------------------------
--		  Agility         --
-----------------------------
modifier_imba_generic_talent_agility = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_agility:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_STATS_AGILITY_BONUS }
	return funcs
end

function modifier_imba_generic_talent_agility:OnCreated()
    if IsServer() then
        Timers:CreateTimer(0.01, function()
            self:GetParent():CalculateStatBonus()
        end)
    end
end

function modifier_imba_generic_talent_agility:GetModifierBonusStats_Agility()
    return self.value
end

-----------------------------
--		Intelligence       --
-----------------------------
modifier_imba_generic_talent_intelligence = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_intelligence:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_STATS_INTELLECT_BONUS }
	return funcs
end

function modifier_imba_generic_talent_intelligence:OnCreated()
    if IsServer() then
        Timers:CreateTimer(0.01, function()
            self:GetParent():CalculateStatBonus()
        end)
    end
end

function modifier_imba_generic_talent_intelligence:GetModifierBonusStats_Intellect()
    return self.value
end

-----------------------------
--		    Armor          --
-----------------------------
modifier_imba_generic_talent_armor = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_armor:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
	return funcs
end

function modifier_imba_generic_talent_armor:GetModifierPhysicalArmorBonus()
    return self.value
end

-----------------------------
--	   Magic Resistance    --
-----------------------------
modifier_imba_generic_talent_magic_resistance = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_magic_resistance:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS }
	return funcs
end

function modifier_imba_generic_talent_magic_resistance:GetModifierMagicalResistanceBonus()
    return self.value
end

-----------------------------
--		   Evasion         --
-----------------------------
modifier_imba_generic_talent_evasion = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_evasion:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_EVASION_CONSTANT }
	return funcs
end

function modifier_imba_generic_talent_evasion:GetModifierEvasion_Constant()
    return self.value
end

-----------------------------
--		  Move Speed       --
-----------------------------
modifier_imba_generic_talent_move_speed = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_move_speed:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_MOVESPEED_MAX }
	return funcs
end

function modifier_imba_generic_talent_move_speed:GetModifierMoveSpeedBonus_Constant()
    return self.value
end

function modifier_imba_generic_talent_move_speed:GetModifierMoveSpeed_Max()
    return 550 + self.value
end

-----------------------------
--	     Attack Speed      --
-----------------------------
modifier_imba_generic_talent_attack_speed = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_attack_speed:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT }
	return funcs
end

function modifier_imba_generic_talent_attack_speed:GetModifierAttackSpeedBonus_Constant()
    return self.value
end

-----------------------------
--	       Health          --
-----------------------------
modifier_imba_generic_talent_hp = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_hp:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_HEALTH_BONUS }
	return funcs
end

function modifier_imba_generic_talent_hp:OnCreated()
    if IsServer() then
        Timers:CreateTimer(0.01, function()
            self:GetParent():CalculateStatBonus()
        end)
    end
end

function modifier_imba_generic_talent_hp:GetModifierHealthBonus()
    return self.value
end

-----------------------------
--	    Health Regen       --
-----------------------------
modifier_imba_generic_talent_hp_regen = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_hp_regen:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT }
	return funcs
end

function modifier_imba_generic_talent_hp_regen:GetModifierConstantHealthRegen()
    return self.value
end

-----------------------------
--	        Mana           --
-----------------------------
modifier_imba_generic_talent_mp = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_mp:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_MANA_BONUS }
	return funcs
end

function modifier_imba_generic_talent_mp:OnCreated()
    if IsServer() then
        Timers:CreateTimer(0.01, function()
            self:GetParent():CalculateStatBonus()
        end)
    end
end

function modifier_imba_generic_talent_mp:GetModifierManaBonus()
    return self.value
end

-----------------------------
--	     Mana Regen        --
-----------------------------
modifier_imba_generic_talent_mp_regen = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_mp_regen:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_MANA_REGEN_CONSTANT }
	return funcs
end

function modifier_imba_generic_talent_mp_regen:GetModifierConstantManaRegen()
    return self.value
end

-----------------------------
--	     Attack Range      --
-----------------------------
modifier_imba_generic_talent_attack_range = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_attack_range:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_ATTACK_RANGE_BONUS }
	return funcs
end

function modifier_imba_generic_talent_attack_range:GetModifierAttackRangeBonus()
    return self.value
end

-----------------------------
--	      Cast Range       --
-----------------------------
modifier_imba_generic_talent_cast_range = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_cast_range:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_CAST_RANGE_BONUS }
	return funcs
end

function modifier_imba_generic_talent_cast_range:GetModifierCastRangeBonus()
    return self.value
end

-----------------------------
--	  Attack Life Steal    --
-----------------------------
modifier_imba_generic_talent_attack_life_steal = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_attack_life_steal:GetModifierLifesteal()
    -- Handled by modifier_imba_generic_talents_handler
    return self.value
end

-----------------------------
--	   Spell Life Steal    --
-----------------------------
modifier_imba_generic_talent_spell_life_steal = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_spell_life_steal:GetModifierSpellLifesteal()
    -- Handled by modifier_imba_generic_talents_handler
    return self.value
end

-----------------------------
--	      Spell Power      --
-----------------------------
modifier_imba_generic_talent_spell_power = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_spell_power:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE }
	return funcs
end

function modifier_imba_generic_talent_spell_power:GetModifierSpellAmplify_Percentage()
    return self.value
end

-----------------------------
--	  Cooldown Reduction   --
-----------------------------
modifier_imba_generic_talent_cd_reduction = ShallowCopy(modifier_imba_generic_talent_base)

function modifier_imba_generic_talent_cd_reduction:GetCustomCooldownReductionStacking()
    return self.value
end

-----------------------------
--	     Bonus EXP         --
-----------------------------
modifier_imba_generic_talent_bonus_xp = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_bonus_xp:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_EXP_RATE_BOOST }
	return funcs
end

function modifier_imba_generic_talent_bonus_xp:GetModifierPercentageExpRateBoost()
    return self.value
end

-----------------------------
--	  Respawn Reduction    --
-----------------------------
modifier_imba_generic_talent_respawn_reduction = ShallowCopy(modifier_imba_generic_talent_base)
function modifier_imba_generic_talent_respawn_reduction:RespawnTimeStacking()
    -- Return negative value
    return -(self.value)
end