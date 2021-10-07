item_imba_circlet = item_imba_circlet or class({})

LinkLuaModifier("modifier_imba_circlet", "components/items/item_circlet", LUA_MODIFIER_MOTION_NONE)

-------------
-- CIRCLET --
-------------

function item_imba_circlet:GetIntrinsicModifierName()
	return "modifier_imba_circlet"
end

modifier_imba_circlet = modifier_imba_circlet or class({})

------------------------------
-- CIRCLET PASSIVE MODIFIER --
------------------------------

function modifier_imba_circlet:IsHidden() return true end
function modifier_imba_circlet:IsDebuff() return false end
function modifier_imba_circlet:IsPurgable() return false end
function modifier_imba_circlet:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_circlet:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	-- Ability properties
	self.caster = self:GetCaster() 
	self.ability = self:GetAbility()

	-- Ability specials
	self.bonus_all_stats = self.ability:GetSpecialValueFor("bonus_all_stats")
	self.hidden_pwr_stat_bonus = self.ability:GetSpecialValueFor("hidden_pwr_stat_bonus")
end

function modifier_imba_circlet:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					  MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					  MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}

	return decFuncs
end

function modifier_imba_circlet:GetModifierBonusStats_Strength()
	local strength = self.bonus_all_stats

	if self.caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
		strength = strength + self.hidden_pwr_stat_bonus
	end

	return strength
end

function modifier_imba_circlet:GetModifierBonusStats_Agility()
	local agility = self.bonus_all_stats

	if self.caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
		agility = agility + self.hidden_pwr_stat_bonus
	end

	return agility
end

function modifier_imba_circlet:GetModifierBonusStats_Intellect()
	local int = self.bonus_all_stats

	if self.caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT then
		int = int + self.hidden_pwr_stat_bonus
	end

	return int
end

