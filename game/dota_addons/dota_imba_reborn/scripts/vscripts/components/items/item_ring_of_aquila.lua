-- Creator:
-- 	AltiV - June 7th, 2019

LinkLuaModifier("modifier_item_imba_ring_of_aquila", "components/items/item_ring_of_aquila", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_ring_of_aquila_aura_bonus", "components/items/item_ring_of_aquila", LUA_MODIFIER_MOTION_NONE)

item_imba_ring_of_aquila					= class({})
modifier_item_imba_ring_of_aquila			= class({})
modifier_item_imba_ring_of_aquila_aura_bonus		= class({})

-------------------------
-- RING OF AQUILA BASE --
-------------------------

function item_imba_ring_of_aquila:GetAbilityTextureName()
	if self:GetCaster():GetModifierStackCount("modifier_item_imba_ring_of_aquila", self:GetCaster()) == 1 then
		return "item_ring_of_aquila"
	else
		-- IDK the vanilla name of the item so I'll have to shove the image in the custom folder
		return "custom/item_ring_of_aquila_inactive"
	end
end

function item_imba_ring_of_aquila:GetIntrinsicModifierName()
	return "modifier_item_imba_ring_of_aquila"
end

function item_imba_ring_of_aquila:OnToggle()
	local item_modifier = self:GetCaster():FindModifierByName("modifier_item_imba_ring_of_aquila")

	if item_modifier then
		if self:GetToggleState() then
			item_modifier:SetStackCount(0)
			self.stack = 0
		else
			item_modifier:SetStackCount(1)
			self.stack = 1
		end
	end
end

-----------------------------
-- RING OF AQUILA MODIFIER --
-----------------------------

function modifier_item_imba_ring_of_aquila:IsHidden() return true end
function modifier_item_imba_ring_of_aquila:IsPurgable() return false end
function modifier_item_imba_ring_of_aquila:RemoveOnDeath() return false end
function modifier_item_imba_ring_of_aquila:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_ring_of_aquila:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	-- AbilitySpecials
	if self:GetAbility() then
		self.bonus_damage		= self:GetAbility():GetSpecialValueFor("bonus_damage")
		self.bonus_strength		= self:GetAbility():GetSpecialValueFor("bonus_strength")
		self.bonus_agility		= self:GetAbility():GetSpecialValueFor("bonus_agility")
		self.bonus_intellect	= self:GetAbility():GetSpecialValueFor("bonus_intellect")
		self.bonus_aspd			= self:GetAbility():GetSpecialValueFor("bonus_aspd")
	else
		self:Destroy()
	end
	
	if not IsServer() then return end
	
	if self:GetAbility().stack then
		self:SetStackCount(self:GetAbility().stack)
	end
	
	-- Check for illusions to "toggle" if active
	if self:GetParent():IsIllusion() and self:GetParent():GetPlayerOwner():GetAssignedHero():GetModifierStackCount("modifier_item_imba_ring_of_aquila", self:GetParent():GetPlayerOwner():GetAssignedHero()) == 1 then
		self:SetStackCount(1)
	end	
end

function modifier_item_imba_ring_of_aquila:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,	
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_imba_ring_of_aquila:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_imba_ring_of_aquila:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_imba_ring_of_aquila:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_imba_ring_of_aquila:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_imba_ring_of_aquila:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_aspd
end

function modifier_item_imba_ring_of_aquila:IsAura()						return true end
function modifier_item_imba_ring_of_aquila:IsAuraActiveOnDeath() 		return false end

function modifier_item_imba_ring_of_aquila:GetAuraRadius()				return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_imba_ring_of_aquila:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end
function modifier_item_imba_ring_of_aquila:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_imba_ring_of_aquila:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_imba_ring_of_aquila:GetModifierAura()			return "modifier_item_imba_ring_of_aquila_aura_bonus" end

function modifier_item_imba_ring_of_aquila:GetAuraEntityReject(hTarget)
	if self:GetStackCount() == 0 and (hTarget:IsCreep() and not hTarget:IsConsideredHero()) then
		return hTarget
	end
end

----------------------------------
-- RING OF AQUILA AURA MODIFIER --
----------------------------------

function modifier_item_imba_ring_of_aquila_aura_bonus:GetTexture()
	return "item_ring_of_aquila"
end

function modifier_item_imba_ring_of_aquila_aura_bonus:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	if self:GetAbility() then
		-- AbilitySpecials
		self.aura_mana_regen	= self:GetAbility():GetSpecialValueFor("aura_mana_regen")
		self.aura_bonus_armor	= self:GetAbility():GetSpecialValueFor("aura_bonus_armor")
		self.aura_bonus_vision	= self:GetAbility():GetSpecialValueFor("aura_bonus_vision")
	else
		self.aura_mana_regen	= 0
		self.aura_bonus_armor	= 0
		self.aura_bonus_vision	= 0
	end
end

function modifier_item_imba_ring_of_aquila_aura_bonus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT_UNIQUE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
	}
end

function modifier_item_imba_ring_of_aquila_aura_bonus:GetModifierConstantManaRegenUnique()
	return self.aura_mana_regen
end

function modifier_item_imba_ring_of_aquila_aura_bonus:GetModifierPhysicalArmorBonusUnique()
	if not self:GetParent():IsIllusion() then
		return self.aura_bonus_armor
	end
end

function modifier_item_imba_ring_of_aquila_aura_bonus:GetBonusDayVision()
	if not self:GetParent():IsIllusion() and not self:GetParent():HasModifier("modifier_item_imba_aether_specs_aura_bonus") then
		return self.aura_bonus_vision
	end
end

function modifier_item_imba_ring_of_aquila_aura_bonus:GetBonusNightVision()
	if not self:GetParent():IsIllusion() and not self:GetParent():HasModifier("modifier_item_imba_aether_specs_aura_bonus") then
		return self.aura_bonus_vision
	end
end
