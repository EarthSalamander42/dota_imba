-- Creator:
-- 	AltiV - March 20th, 2019

LinkLuaModifier("modifier_item_imba_armlet_of_dementor", "components/items/item_armlet_of_dementor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_armlet_of_dementor_active", "components/items/item_armlet_of_dementor.lua", LUA_MODIFIER_MOTION_NONE)

item_imba_armlet_of_dementor					= class({})
modifier_item_imba_armlet_of_dementor			= class({})
modifier_item_imba_armlet_of_dementor_active	= class({})

-----------------------------
-- ARMLET OF DEMENTOR BASE --
-----------------------------

function item_imba_armlet_of_dementor:GetIntrinsicModifierName()
	-- Client/server way of checking for multiple items and only apply the effects of one without relying on extra modifiers
	
	Timers:CreateTimer(FrameTime(), function()
		if not self:IsNull() then
			for _, modifier in pairs(self:GetParent():FindAllModifiersByName("modifier_item_imba_armlet_of_dementor")) do
				modifier:SetStackCount(_)
			end
		end
	end)

	return "modifier_item_imba_armlet_of_dementor"
end

function item_imba_armlet_of_dementor:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_item_imba_armlet_of_dementor_active") then
		return "custom/armlet_of_dementor_active"
	else
		return "custom/armlet_of_dementor_inactive"
	end
end

function item_imba_armlet_of_dementor:OnSpellStart()
	local caster	= self:GetCaster()

	if not IsServer() then return end

	if not caster:HasModifier("modifier_item_imba_armlet_of_dementor_active") then
		caster:EmitSound("DOTA_Item.Armlet.Activate")
		caster:AddNewModifier(caster, self, "modifier_item_imba_armlet_of_dementor_active", {})
	elseif caster:HasModifier("modifier_item_imba_armlet_of_dementor_active") then
		caster:EmitSound("DOTA_Item.Armlet.DeActivate")
		caster:RemoveModifierByName("modifier_item_imba_armlet_of_dementor_active")
	end
end

----------------------------------------
-- ARMLET OF DEMENTOR ACTIVE MODIFIER --
----------------------------------------

function modifier_item_imba_armlet_of_dementor_active:IsPurgable() 	return false end

function modifier_item_imba_armlet_of_dementor_active:GetEffectName()
	return "particles/item/armlet_of_dementor/armlet_of_dementor.vpcf"
end

function modifier_item_imba_armlet_of_dementor_active:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()	

	-- AbilitySpecials
	self.mind_bonus_int			=	self.ability:GetSpecialValueFor("mind_bonus_int")
	self.mind_bonus_magic_res	=	self.ability:GetSpecialValueFor("mind_bonus_magic_res")
	self.mind_bonus_spell_amp	=	self.ability:GetSpecialValueFor("mind_bonus_spell_amp")
	self.mind_mana_drain_mult	=	self.ability:GetSpecialValueFor("mind_mana_drain_mult")
end

function modifier_item_imba_armlet_of_dementor_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,	-- GetModifierBonusStats_Intellect
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, --GetModifierMagicalResistanceBonus
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, --GetModifierSpellAmplify_Percentage
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,	-- GetModifierConstantManaRegen
		
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_MANA_GAINED
	}
end

function modifier_item_imba_armlet_of_dementor_active:GetModifierBonusStats_Intellect()
	return self.mind_bonus_int
end

function modifier_item_imba_armlet_of_dementor_active:GetModifierMagicalResistanceBonus()
	if IsClient() or not self.parent:IsIllusion() then
		return self.mind_bonus_magic_res
	end
end

function modifier_item_imba_armlet_of_dementor_active:GetModifierSpellAmplify_Percentage()
	if IsClient() or not self.parent:IsIllusion() then
		return self.mind_bonus_spell_amp
	end
end

function modifier_item_imba_armlet_of_dementor_active:OnManaGained(keys)
	if keys.unit == self:GetParent() then
		self:GetParent():SpendMana(keys.gain * self.mind_mana_drain_mult, self.ability)
		
		-- There's some weird glitch that prevents mana from going below some non-zero threshold when using SpendMana, but IDK how to fix that for now
		if keys.gain >= self:GetParent():GetMana() then

		end
	end
end

---------------------------------
-- ARMLET OF DEMENTOR MODIFIER --
---------------------------------

function modifier_item_imba_armlet_of_dementor:IsHidden()		return true end
function modifier_item_imba_armlet_of_dementor:IsPurgable()		return false end
function modifier_item_imba_armlet_of_dementor:RemoveOnDeath()	return false end
function modifier_item_imba_armlet_of_dementor:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_armlet_of_dementor:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.bonus_spell_amp	=	self.ability:GetSpecialValueFor("bonus_spell_amp")
	self.bonus_spell_cd		=	self.ability:GetSpecialValueFor("bonus_spell_cd")
	self.bonus_magic_res	=	self.ability:GetSpecialValueFor("bonus_magic_res")
	self.bonus_mana_regen	=	self.ability:GetSpecialValueFor("bonus_mana_regen")
	
	if not IsServer() then return end
	
	-- Check for illusions to add Mind's Despair to if active (there's probably a less convoluted way to do this...)
	if self.parent:IsIllusion() and self.parent:GetPlayerOwner():GetAssignedHero():HasModifier("modifier_item_imba_armlet_of_dementor_active") then
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_imba_armlet_of_dementor_active", {})
	end
	
    -- Use Secondary Charges system to make mana loss reduction and CDR not stack with multiples
    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end
end

-- This is just to make sure the CD modifier doesn't stack with itself or frantic modifier, without having to make an additional modifier to check
function modifier_item_imba_armlet_of_dementor:OnDestroy()
	if not IsServer() then return end
	
	for _, modifier in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
		modifier:SetStackCount(_)
		modifier:GetAbility():SetSecondaryCharges(_)
	end
end

function modifier_item_imba_armlet_of_dementor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, --GetModifierSpellAmplify_Percentage
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING, --GetModifierPercentageCooldownStacking
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, --GetModifierMagicalResistanceBonus
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT	-- GetModifierConstantManaRegen
	}
end

-- As of 7.23, the items that Nether Wand's tree contains are as follows:
--   - Nether Wand
--   - Aether Lens
--   - Aether Specs
--   - Eul's Scepter of Divinity EX
--   - Armlet of Dementor
--   - Arcane Nexus
function modifier_item_imba_armlet_of_dementor:GetModifierSpellAmplify_Percentage()
	if self:GetAbility():GetSecondaryCharges() == 1 and 
	not self:GetParent():HasModifier("modifier_item_imba_arcane_nexus_passive") then
        return self.bonus_spell_amp
    end
end

function modifier_item_imba_armlet_of_dementor:GetModifierPercentageCooldownStacking()
	if self:GetAbility():GetSecondaryCharges() == 1 then
		return self.bonus_spell_cd
	end
end

function modifier_item_imba_armlet_of_dementor:GetModifierMagicalResistanceBonus()
	return self.bonus_magic_res
end

function modifier_item_imba_armlet_of_dementor:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end
