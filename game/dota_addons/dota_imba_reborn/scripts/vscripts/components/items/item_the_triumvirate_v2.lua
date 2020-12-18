-- Creator:
-- 	AltiV - March 12th, 2019

LinkLuaModifier("modifier_item_imba_the_triumvirate_v2", "components/items/item_the_triumvirate_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_the_triumvirate_v2_sange", "components/items/item_the_triumvirate_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_the_triumvirate_v2_yasha", "components/items/item_the_triumvirate_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_the_triumvirate_v2_kaya", "components/items/item_the_triumvirate_v2.lua", LUA_MODIFIER_MOTION_NONE)

item_imba_the_triumvirate_v2				= class({})
modifier_item_imba_the_triumvirate_v2		= class({})
modifier_item_imba_the_triumvirate_v2_sange	= class({})
modifier_item_imba_the_triumvirate_v2_yasha	= class({})
modifier_item_imba_the_triumvirate_v2_kaya	= class({})

-----------------------------
-- THE TRIUMVIRATE V2 BASE --
-----------------------------

function item_imba_the_triumvirate_v2:GetIntrinsicModifierName()
	return "modifier_item_imba_the_triumvirate_v2"
end

function item_imba_the_triumvirate_v2:OnSpellStart()
	self.caster	= self:GetCaster()
	
	-- AbilitySpecials
	self.active_duration	= self:GetSpecialValueFor("active_duration")

	if not IsServer() then return end
	
	-- Emit cast sound
	self.caster:EmitSound("DOTA_Item.IronTalon.Activate")
	
	-- Add the KYS modifiers (let's get them in order)
	self.caster:AddNewModifier(self.caster, self, "modifier_item_imba_the_triumvirate_v2_sange", {duration = self.active_duration}) -- bonus_status_resistance_active
	
	Timers:CreateTimer(FrameTime(), function()
		self.caster:AddNewModifier(self.caster, self, "modifier_item_imba_the_triumvirate_v2_yasha", {duration = self.active_duration}) -- bonus_evasion_active
		
		Timers:CreateTimer(FrameTime(), function()
			self.caster:AddNewModifier(self.caster, self, "modifier_item_imba_the_triumvirate_v2_kaya", {duration = self.active_duration}) -- bonus_cdr_active
		end)
	end)

end

-- The rest are copied from swords.lua cause I can't transfer the classes between files
-------------------------------------
-- THE TRIUMVIRATE V2 SANGE ACTIVE --
-------------------------------------

function modifier_item_imba_the_triumvirate_v2_sange:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.ability			= self:GetAbility()
	self.sange_extension	= self.ability:GetSpecialValueFor("sange_extension")
	
	-- AbilitySpecials
	self.bonus_status_resistance_active	= self.ability:GetSpecialValueFor("bonus_status_resistance_active")
end

-- Modifier particle
function modifier_item_imba_the_triumvirate_v2_sange:GetEffectName()
	return "particles/items2_fx/sange_active.vpcf"
end

-- Declare modifier events/properties
function modifier_item_imba_the_triumvirate_v2_sange:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

function modifier_item_imba_the_triumvirate_v2_sange:GetModifierStatusResistanceStacking()
	return self.bonus_status_resistance_active
end

function modifier_item_imba_the_triumvirate_v2_sange:OnAttackLanded(keys)
	if keys.target == self:GetParent() and keys.attacker:IsRealHero() and keys.attacker:GetTeam() ~= keys.target:GetTeam() then
		self:IncrementStackCount()
		-- Seems like I need to call this to update the health properly
		self:GetParent():CalculateStatBonus(true)
		self:SetDuration(self:GetRemainingTime() + self.sange_extension, true)
	end
end

function modifier_item_imba_the_triumvirate_v2_sange:GetModifierBonusStats_Strength(keys)
	return self:GetStackCount()
end

function modifier_item_imba_the_triumvirate_v2_sange:OnTooltip()
	return self:GetStackCount()
end

------------------------------------------
-- THE TRIUMVIRATE V2 BASE YASHA ACTIVE --
------------------------------------------

function modifier_item_imba_the_triumvirate_v2_yasha:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.ability			= self:GetAbility()
	self.yasha_extension	= self.ability:GetSpecialValueFor("yasha_extension")
	
	-- AbilitySpecials
	self.bonus_evasion_active	= self.ability:GetSpecialValueFor("bonus_evasion_active")
end

-- Modifier particle
function modifier_item_imba_the_triumvirate_v2_yasha:GetEffectName()
	return "particles/items2_fx/yasha_active.vpcf"
end

function modifier_item_imba_the_triumvirate_v2_yasha:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function modifier_item_imba_the_triumvirate_v2_yasha:GetModifierEvasion_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_evasion_active")
end

function modifier_item_imba_the_triumvirate_v2_yasha:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and keys.target:IsRealHero() and keys.attacker:GetTeam() ~= keys.target:GetTeam() then
		self:IncrementStackCount()
		-- IDK if I need to call this for Yasha but I'm doing it for the other two so w/e
		self:GetParent():CalculateStatBonus(true)
		self:SetDuration(self:GetRemainingTime() + self.yasha_extension, true)
	end
end

function modifier_item_imba_the_triumvirate_v2_yasha:GetModifierBonusStats_Agility(keys)
	return self:GetStackCount()
end

function modifier_item_imba_the_triumvirate_v2_yasha:OnTooltip()
	return self:GetStackCount()
end

-----------------------------------------
-- THE TRIUMVIRATE V2 BASE KAYA ACTIVE --
-----------------------------------------

function modifier_item_imba_the_triumvirate_v2_kaya:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.ability				= self:GetAbility()
	self.kaya_extension			= self.ability:GetSpecialValueFor("kaya_extension")
	self.kaya_min_health_dmg	= self.ability:GetSpecialValueFor("kaya_min_health_dmg")
	
	-- AbilitySpecials
	self.bonus_cdr_active	= self.ability:GetSpecialValueFor("bonus_cdr_active")
end

function modifier_item_imba_the_triumvirate_v2_kaya:GetEffectName()
	return "particles/items2_fx/kaya_active.vpcf"
end

function modifier_item_imba_the_triumvirate_v2_kaya:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function modifier_item_imba_the_triumvirate_v2_kaya:GetModifierPercentageCooldown()
	return self.bonus_cdr_active
end

function modifier_item_imba_the_triumvirate_v2_kaya:GetModifierPercentageManacost()
	return self.bonus_cdr_active
end

function modifier_item_imba_the_triumvirate_v2_kaya:OnTakeDamage(keys)
	if ((keys.attacker == self:GetParent() and keys.unit:IsRealHero()) or (keys.unit == self:GetParent() and keys.attacker:IsRealHero())) and keys.damage_category == 0 and keys.attacker:GetTeam() ~= keys.unit:GetTeam() then
		
		-- Spell damage taken/received should be above some threshold for...obvious reasons
		if (keys.damage >= self.kaya_min_health_dmg) then
			self:IncrementStackCount()
			-- Seems like I need to call this to update the mana properly
			self:GetParent():CalculateStatBonus(true)
			self:SetDuration(self:GetRemainingTime() + self.kaya_extension, true)
		end
	end
end

function modifier_item_imba_the_triumvirate_v2_kaya:GetModifierBonusStats_Intellect()
	return self:GetStackCount()
end

function modifier_item_imba_the_triumvirate_v2_kaya:OnTooltip()
	return self:GetStackCount()
end

---------------------------------
-- THE TRIUMVIRATE V2 MODIFIER --
---------------------------------

function modifier_item_imba_the_triumvirate_v2:IsHidden()		return true end
function modifier_item_imba_the_triumvirate_v2:IsPurgable()		return false end
function modifier_item_imba_the_triumvirate_v2:RemoveOnDeath()	return false end
function modifier_item_imba_the_triumvirate_v2:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_the_triumvirate_v2:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()

	-- AbilitySpecials
	self.bonus_strength					=	self.ability:GetSpecialValueFor("bonus_strength")
	self.bonus_agility					=	self.ability:GetSpecialValueFor("bonus_agility")
	self.bonus_intellect				=	self.ability:GetSpecialValueFor("bonus_intellect")
	self.bonus_attack_speed				=	self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.spell_amp						=	self.ability:GetSpecialValueFor("spell_amp")
	self.status_resistance				=	self.ability:GetSpecialValueFor("status_resistance")
	self.movement_speed_percent_bonus	=	self.ability:GetSpecialValueFor("movement_speed_percent_bonus")
	self.hp_regen_amp					=	self.ability:GetSpecialValueFor("hp_regen_amp")
	self.mp_regen_amp					=	self.ability:GetSpecialValueFor("mp_regen_amp")
	self.lifesteal_amp					=	self.ability:GetSpecialValueFor("lifesteal_amp")
	self.spell_lifesteal_amp			=	self.ability:GetSpecialValueFor("spell_lifesteal_amp")

	if not IsServer() then return end

    -- Use Secondary Charges system to make CDR not stack with multiples
    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end
end

function modifier_item_imba_the_triumvirate_v2:OnDestroy()
    if not IsServer() then return end

    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end
end

function modifier_item_imba_the_triumvirate_v2:DeclareFunctions() return {
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,

	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,

	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
} end

function modifier_item_imba_the_triumvirate_v2:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_imba_the_triumvirate_v2:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_imba_the_triumvirate_v2:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_imba_the_triumvirate_v2:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_imba_the_triumvirate_v2:GetModifierMoveSpeedBonus_Percentage_Unique()
	return self.movement_speed_percent_bonus
end

function modifier_item_imba_the_triumvirate_v2:GetModifierStatusResistanceStacking()
	return self.status_resistance
end

function modifier_item_imba_the_triumvirate_v2:GetModifierHPRegenAmplify_Percentage()
	return self.hp_regen_amp
end

function modifier_item_imba_the_triumvirate_v2:GetModifierMPRegenAmplify_Percentage()
	return self.mp_regen_amp
end

function modifier_item_imba_the_triumvirate_v2:GetModifierSpellAmplify_PercentageUnique()
	return self.spell_amp
end

function modifier_item_imba_the_triumvirate_v2:GetModifierLifestealAmplify()
	return self.lifesteal_amp
end

function modifier_item_imba_the_triumvirate_v2:GetModifierSpellLifestealAmplify()
	return self.spell_lifesteal_amp
end
