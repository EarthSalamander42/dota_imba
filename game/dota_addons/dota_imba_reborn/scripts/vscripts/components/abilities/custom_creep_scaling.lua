-- Creator:
--	AltiV - February 15th, 2019

LinkLuaModifier("modifier_custom_creep_scaling", "components/abilities/custom_creep_scaling.lua", LUA_MODIFIER_MOTION_NONE)

custom_creep_scaling 			= class({})
modifier_custom_creep_scaling	= class({})

----------------------------------
-- CUSTOM CREEP SCALING ABILITY --
----------------------------------

function custom_creep_scaling:IsInnateAbility() return true end
function custom_creep_scaling:IsStealable() 	return false end

function custom_creep_scaling:GetIntrinsicModifierName()
	return "modifier_custom_creep_scaling"
end

-----------------------------------
-- CUSTOM CREEP SCALING MODIFIER --
-----------------------------------

function modifier_custom_creep_scaling:IsHidden()
	if self:GetStackCount() == 0 then
		return true
	end
end

-- Problem: Creeps "spawn" before the actual :00 / :30 mark and their stats don't seem to change at all again after OnCreated runs
function modifier_custom_creep_scaling:OnCreated()
	self.ability		= self:GetAbility()
	self.parent			= self:GetParent()
	
	-- Yeah let's not give Doom the bonuses
	if not self.ability or not self.parent:IsCreep() then return end
	
	self.initialized	= false
	
	self:SetStackCount(math.floor(GameRules:GetDOTATime(false, false) / 60))
	
	-- Let's try some higher scaling values for upgraded and mega creeps (and not have the stupid high base stats)
	self.multiplier		= self.ability:GetSpecialValueFor("base_mult")
	
	if string.find(self.parent:GetUnitName(), "upgraded") then 
		self.multiplier	= self.ability:GetSpecialValueFor("super_mult")
	elseif string.find(self.parent:GetUnitName(), "upgraded_mega") then
		self.multiplier	= self.ability:GetSpecialValueFor("mega_mult")
	end
	
	-- AbilitySpecials (Gonna use one set to deal with all creep types at first test)
	self.melee_attack	= self.ability:GetSpecialValueFor("melee_attack")	* self:GetStackCount()	* self.multiplier
	self.melee_aspd		= self.ability:GetSpecialValueFor("melee_aspd")		* self:GetStackCount()	* self.multiplier
	self.melee_armor	= self.ability:GetSpecialValueFor("melee_armor")	* self:GetStackCount()	* self.multiplier
	self.melee_mres		= self.ability:GetSpecialValueFor("melee_mres")		* self:GetStackCount()	* self.multiplier
	self.melee_ms		= self.ability:GetSpecialValueFor("melee_ms")		* self:GetStackCount()	* self.multiplier
	self.melee_hp		= self.ability:GetSpecialValueFor("melee_hp")		* self:GetStackCount()	* self.multiplier
	self.melee_regen 	= self.ability:GetSpecialValueFor("melee_regen")	* self:GetStackCount()	* self.multiplier
	
	if not IsServer() then return end
	-- Have to call this separately cause the health bonus modifier doesn't work on lane creeps?
	self.parent:SetBaseMaxHealth(self.parent:GetMaxHealth() + self.melee_hp)
	
	-- For Jungle Creeps
	if string.find(self.parent:GetUnitName(), "_neutral_") then
		self.parent:SetMinimumGoldBounty(self.parent:GetMinimumGoldBounty() + (self:GetStackCount() * self.ability:GetSpecialValueFor("jungle_bounty")))
		self.parent:SetMaximumGoldBounty(self.parent:GetMaximumGoldBounty() + (self:GetStackCount() * self.ability:GetSpecialValueFor("jungle_bounty")))
	end
end

function modifier_custom_creep_scaling:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS, -- Doesn't actually work but gonna use this for tooltips
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		-- MODIFIER_EVENT_ON_UNIT_MOVED -- Supposedly causes major lag even with it only doing rest of logic in one frame
    }

    return decFuncs
end

function modifier_custom_creep_scaling:GetModifierPreAttack_BonusDamage()
    return self.melee_attack 
end

function modifier_custom_creep_scaling:GetModifierAttackSpeedBonus_Constant()
    return self.melee_aspd
end

function modifier_custom_creep_scaling:GetModifierPhysicalArmorBonus()
    return self.melee_armor
end

function modifier_custom_creep_scaling:GetModifierMagicalResistanceBonus()
    return self.melee_mres
end

function modifier_custom_creep_scaling:GetModifierMoveSpeedBonus_Constant()
    return self.melee_ms
end

function modifier_custom_creep_scaling:GetModifierHealthBonus()
    return self.melee_hp
end

function modifier_custom_creep_scaling:GetModifierConstantHealthRegen()
    return self.melee_regen
end

-- function modifier_custom_creep_scaling:OnUnitMoved(keys)
	-- if keys.unit == self.parent and not self.initialized then
	
		-- self.initialized = true
		-- self:SetStackCount(math.floor(GameRules:GetDOTATime(false, false) / 60))
	
		-- -- AbilitySpecials (Gonna use one set to deal with all creep types at first test)
		-- self.melee_attack	= self.ability:GetSpecialValueFor("melee_attack")	* self:GetStackCount()	* self.multiplier
		-- self.melee_aspd		= self.ability:GetSpecialValueFor("melee_aspd")		* self:GetStackCount()	* self.multiplier
		-- self.melee_armor	= self.ability:GetSpecialValueFor("melee_armor")	* self:GetStackCount()	* self.multiplier
		-- self.melee_mres		= self.ability:GetSpecialValueFor("melee_mres")		* self:GetStackCount()	* self.multiplier
		-- self.melee_ms		= self.ability:GetSpecialValueFor("melee_ms")		* self:GetStackCount()	* self.multiplier
		-- self.melee_hp		= self.ability:GetSpecialValueFor("melee_hp")		* self:GetStackCount()	* self.multiplier
		-- self.melee_regen 	= self.ability:GetSpecialValueFor("melee_regen")	* self:GetStackCount()	* self.multiplier
		
		-- if not IsServer() then return end
		-- -- Have to call this separately cause the health bonus modifier doesn't work on lane creeps?
		-- self.parent:SetBaseMaxHealth(self.parent:GetMaxHealth() + self.melee_hp)
	-- end
-- end

