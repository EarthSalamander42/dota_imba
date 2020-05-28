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

function modifier_imba_aether_lens_passive:IsHidden()		return true end
function modifier_imba_aether_lens_passive:IsPurgable()		return false end
function modifier_imba_aether_lens_passive:RemoveOnDeath()	return false end
function modifier_imba_aether_lens_passive:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_aether_lens_passive:OnDestroy()
	self:CheckUnique(false)
end

function modifier_imba_aether_lens_passive:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
    
	local item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and item then
		self.bonus_mana = item:GetSpecialValueFor("bonus_mana")
		self.bonus_mana_regen = item:GetSpecialValueFor("bonus_mana_regen")
		self.cast_range_bonus = item:GetSpecialValueFor("cast_range_bonus")
		self.spell_power = item:GetSpecialValueFor("spell_power")
		self:CheckUnique(true)
	end

	if not IsServer() then return end
	
    -- Use Secondary Charges system to make mana loss reduction and CDR not stack with multiples
    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end
end

function modifier_imba_aether_lens_passive:OnDestroy()
	if not IsServer() then return end
	
    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end
end

function modifier_imba_aether_lens_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
end

-- As of 7.23, the items that Nether Wand's tree contains are as follows:
--   - Nether Wand
--   - Aether Lens
--   - Aether Specs
--   - Eul's Scepter of Divinity EX
--   - Armlet of Dementor
--   - Arcane Nexus
function modifier_imba_aether_lens_passive:GetModifierSpellAmplify_Percentage()
    if self:GetAbility():GetSecondaryCharges() == 1 and 
	not self:GetParent():HasModifier("modifier_item_imba_aether_specs") and 
	not self:GetParent():HasModifier("modifier_item_imba_cyclone_2") and 
	not self:GetParent():HasModifier("modifier_item_imba_armlet_of_dementor") and
	not self:GetParent():HasModifier("modifier_item_imba_arcane_nexus_passive") then
        return self.spell_power
    end
end

-- function modifier_imba_aether_lens_passive:GetModifierSpellAmplify_Percentage()
	-- return self:CheckUniqueValue(self.spell_power,{"modifier_imba_elder_staff","modifier_imba_nether_wand","modifier_item_imba_aether_specs"})
-- end

function modifier_imba_aether_lens_passive:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_imba_aether_lens_passive:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_imba_aether_lens_passive:GetModifierCastRangeBonusStacking()
	return self:CheckUniqueValue(self.cast_range_bonus, {"modifier_imba_elder_staff","modifier_item_imba_aether_specs"})
end
