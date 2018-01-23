--[[
		By: AtroCty
		Date: 17.05.2017
		Updated:  18.05.2017
	]]
-------------------------------------------
--			NETHER WAND
-------------------------------------------
LinkLuaModifier("modifier_imba_item_nether_wand_passive", "items/item_nether_wand.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_item_elder_staff_passive", "items/item_nether_wand.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------

item_imba_nether_wand = item_imba_nether_wand or class({})

-------------------------------------------
function item_imba_nether_wand:GetIntrinsicModifierName()
    return "modifier_imba_item_nether_wand_passive"
end

function item_imba_nether_wand:GetAbilityTextureName()
   return "custom/imba_nether_wand"
end

-------------------------------------------
modifier_imba_item_nether_wand_passive = modifier_imba_item_nether_wand_passive or class({})
function modifier_imba_item_nether_wand_passive:IsDebuff() return false end
function modifier_imba_item_nether_wand_passive:IsHidden() return true end
function modifier_imba_item_nether_wand_passive:IsPermanent() return true end
function modifier_imba_item_nether_wand_passive:IsPurgable() return false end
function modifier_imba_item_nether_wand_passive:IsPurgeException() return false end
function modifier_imba_item_nether_wand_passive:IsStunDebuff() return false end
function modifier_imba_item_nether_wand_passive:RemoveOnDeath() return false end
function modifier_imba_item_nether_wand_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_item_nether_wand_passive:OnDestroy()
	self:CheckUnique(false)
end

function modifier_imba_item_nether_wand_passive:OnCreated()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and self.item then
		self.spell_amp = self.item:GetSpecialValueFor("spell_amp")
		self:CheckUnique(true)
	end
end

function modifier_imba_item_nether_wand_passive:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }
    return decFuns
end

function modifier_imba_item_nether_wand_passive:GetModifierSpellAmplify_Percentage()
	return self:CheckUniqueValue(self.spell_amp,{"modifier_imba_item_elder_staff_passive"})
end

-------------------------------------------
--			ELDER STAFF
-------------------------------------------
item_imba_elder_staff = item_imba_elder_staff or class({})
-------------------------------------------
function item_imba_elder_staff:GetIntrinsicModifierName()
    return "modifier_imba_item_elder_staff_passive"
end

function item_imba_elder_staff:GetAbilityTextureName()
   return "custom/imba_arcane_nexus"
end
-------------------------------------------
modifier_imba_item_elder_staff_passive = modifier_imba_item_elder_staff_passive or class({})
function modifier_imba_item_elder_staff_passive:IsDebuff() return false end
function modifier_imba_item_elder_staff_passive:IsHidden() return true end
function modifier_imba_item_elder_staff_passive:IsPermanent() return true end
function modifier_imba_item_elder_staff_passive:IsPurgable() return false end
function modifier_imba_item_elder_staff_passive:IsPurgeException() return false end
function modifier_imba_item_elder_staff_passive:IsStunDebuff() return false end
function modifier_imba_item_elder_staff_passive:RemoveOnDeath() return false end
function modifier_imba_item_elder_staff_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_item_elder_staff_passive:OnDestroy()
	self:CheckUnique(false)
end

function modifier_imba_item_elder_staff_passive:OnCreated()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and self.item then
		self.bonus_damage = self.item:GetSpecialValueFor("bonus_damage")
		self.bonus_as = self.item:GetSpecialValueFor("bonus_as")
		self.bonus_intellect = self.item:GetSpecialValueFor("bonus_intellect")
		self.cast_range_bonus = self.item:GetSpecialValueFor("cast_range_bonus")
		self.spell_power = self.item:GetSpecialValueFor("spell_power")
		self.burn_duration = self.item:GetSpecialValueFor("burn_duration")
		self.bonus_cdr = self.item:GetSpecialValueFor("bonus_cdr")
		self:CheckUnique(true)
	end
end

function modifier_imba_item_elder_staff_passive:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
    }
    return decFuns
end

function modifier_imba_item_elder_staff_passive:GetModifierSpellAmplify_Percentage()
	return self:CheckUniqueValue(self.spell_power,nil)
end

function modifier_imba_item_elder_staff_passive:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_item_elder_staff_passive:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_imba_item_elder_staff_passive:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_imba_item_elder_staff_passive:GetModifierPercentageCooldown()
	return self.bonus_cdr
end

function modifier_imba_item_elder_staff_passive:GetModifierPercentageManacost()
	return self.bonus_cdr
end