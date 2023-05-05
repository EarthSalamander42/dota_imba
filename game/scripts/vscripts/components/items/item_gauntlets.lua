item_imba_gauntlets = item_imba_gauntlets or class({})

LinkLuaModifier("modifier_imba_gauntlets", "components/items/item_gauntlets", LUA_MODIFIER_MOTION_NONE)

---------------------------
-- GAUNTLETS OF STRENGTH --
---------------------------

function item_imba_gauntlets:GetIntrinsicModifierName()
	return "modifier_imba_gauntlets"
end

modifier_imba_gauntlets = modifier_imba_gauntlets or class({})

--------------------------------------------
-- GAUNTLETS OF STRENGTH PASSIVE MODIFIER --
--------------------------------------------

function modifier_imba_gauntlets:IsHidden() return true end
function modifier_imba_gauntlets:IsDebuff() return false end
function modifier_imba_gauntlets:IsPurgable() return false end
function modifier_imba_gauntlets:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_gauntlets:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	-- Ability properties
	self.caster = self:GetCaster() 
	self.ability = self:GetAbility()

	-- Ability specials
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.damage_block = self.ability:GetSpecialValueFor("damage_block")
end

function modifier_imba_gauntlets:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

function modifier_imba_gauntlets:GetModifierBonusStats_Strength()
	return self.bonus_str
end

function modifier_imba_gauntlets:GetModifierPhysical_ConstantBlock()
	-- Only block physical damage when not in cooldown
	if self.ability:IsCooldownReady() then

		-- Start cooldown and block
		self.ability:UseResources(false, false, false, true)
		return self.damage_block
	end

	return
end