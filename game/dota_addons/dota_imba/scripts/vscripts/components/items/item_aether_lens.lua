--[[
		By: AtroCty
		Date: 17.05.2017
		Updated:  17.05.2017
	]]
-------------------------------------------
--			AETHER LENS
-------------------------------------------
LinkLuaModifier("modifier_imba_aether_lens_passive", "components/items/item_aether_lens.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------

item_imba_aether_lens = item_imba_aether_lens or class({})
-------------------------------------------
function item_imba_aether_lens:GetIntrinsicModifierName()
	return "modifier_imba_aether_lens_passive"
end

function item_imba_aether_lens:GetAbilityTextureName()
	return "custom/imba_aether_lens"
end

-------------------------------------------
modifier_imba_aether_lens_passive = modifier_imba_aether_lens_passive or class({})
function modifier_imba_aether_lens_passive:IsDebuff() return false end
function modifier_imba_aether_lens_passive:IsHidden() return true end
function modifier_imba_aether_lens_passive:IsPermanent() return true end
function modifier_imba_aether_lens_passive:IsPurgable() return false end
function modifier_imba_aether_lens_passive:IsPurgeException() return false end
function modifier_imba_aether_lens_passive:IsStunDebuff() return false end
function modifier_imba_aether_lens_passive:RemoveOnDeath() return false end
function modifier_imba_aether_lens_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_aether_lens_passive:OnDestroy()
	self:CheckUnique(false)
end

function modifier_imba_aether_lens_passive:OnCreated()
	local item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and item then
		self.bonus_mana = item:GetSpecialValueFor("bonus_mana")
		self.bonus_mana_regen = item:GetSpecialValueFor("bonus_mana_regen")
		self.cast_range_bonus = item:GetSpecialValueFor("cast_range_bonus")
		self.spell_power = item:GetSpecialValueFor("spell_power")
		self:CheckUnique(true)
	end
end

function modifier_imba_aether_lens_passive:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
			MODIFIER_PROPERTY_MANA_BONUS,
			MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
		}
	return decFuns
end

function modifier_imba_aether_lens_passive:GetModifierSpellAmplify_Percentage()
	return self:CheckUniqueValue(self.spell_power,{"modifier_imba_elder_staff","modifier_imba_nether_wand"})
end

function modifier_imba_aether_lens_passive:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_imba_aether_lens_passive:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_imba_aether_lens_passive:GetModifierCastRangeBonusStacking()
	return self:CheckUniqueValue(self.cast_range_bonus, {"modifier_imba_elder_staff"})
end
