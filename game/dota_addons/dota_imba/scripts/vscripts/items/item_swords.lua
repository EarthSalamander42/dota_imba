--	Author: Firetoad
--	Date: 			24.06.2015
--	Last Update:	23.03.2017
--	Definitions for the three swords and its combinations

-----------------------------------------------------------------------------------------------------------
--	Sange definition
-----------------------------------------------------------------------------------------------------------

if item_imba_sange == nil then item_imba_sange = class({}) end
LinkLuaModifier( "modifier_item_imba_sange", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_sange_maim", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Maim debuff
LinkLuaModifier( "modifier_item_imba_sange_disarm", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Disarm debuff

function item_imba_sange:GetIntrinsicModifierName()
	return "modifier_item_imba_sange" end

-----------------------------------------------------------------------------------------------------------
--	Sange passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sange == nil then modifier_item_imba_sange = class({}) end
function modifier_item_imba_sange:IsHidden() return true end
function modifier_item_imba_sange:IsDebuff() return false end
function modifier_item_imba_sange:IsPurgable() return false end
function modifier_item_imba_sange:IsPermanent() return true end
function modifier_item_imba_sange:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Declare modifier events/properties
function modifier_item_imba_sange:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_sange:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

function modifier_item_imba_sange:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_strength") end

-- On attack landed, roll for proc and apply stacks
function modifier_item_imba_sange:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()

		-- If this attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return end

		-- If a higher-priority sword is present, do nothing either
		local priority_sword_modifiers = {
			"modifier_item_imba_sange_yasha",
			"modifier_item_imba_sange_azura",
			"modifier_item_imba_triumvirate"
		}
		for _, sword_modifier in pairs(priority_sword_modifiers) do
			if owner:HasModifier(sword_modifier) then
				return nil
			end
		end

		-- All conditions met, perform a Sange attack
		SangeAttack(owner, keys.target, self:GetAbility(), "modifier_item_imba_sange_maim", "modifier_item_imba_sange_disarm")
	end
end

-----------------------------------------------------------------------------------------------------------
--	Sange maim debuff (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sange_maim == nil then modifier_item_imba_sange_maim = class({}) end
function modifier_item_imba_sange_maim:IsHidden() return false end
function modifier_item_imba_sange_maim:IsDebuff() return true end
function modifier_item_imba_sange_maim:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_sange_maim:GetEffectName()
	return "particles/items2_fx/sange_maim.vpcf"
end

function modifier_item_imba_sange_maim:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Modifier property storage
function modifier_item_imba_sange_maim:OnCreated()
	self.maim_stack = self:GetAbility():GetSpecialValueFor("maim_stack")
end

-- Declare modifier events/properties
function modifier_item_imba_sange_maim:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_item_imba_sange_maim:GetModifierAttackSpeedBonus_Constant()
	return self.maim_stack * self:GetStackCount() end

function modifier_item_imba_sange_maim:GetModifierMoveSpeedBonus_Percentage()
	return self.maim_stack * self:GetStackCount() end

-----------------------------------------------------------------------------------------------------------
--	Sange disarm debuff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sange_disarm == nil then modifier_item_imba_sange_disarm = class({}) end
function modifier_item_imba_sange_disarm:IsHidden() return false end
function modifier_item_imba_sange_disarm:IsDebuff() return true end
function modifier_item_imba_sange_disarm:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_sange_disarm:GetEffectName()
	return "particles/items2_fx/heavens_halberd.vpcf"
end

function modifier_item_imba_sange_disarm:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Declare modifier states
function modifier_item_imba_sange_disarm:CheckState()
	local states = {
		[MODIFIER_STATE_DISARMED] = true,
	}
	return states
end

function SangeAttack(attacker, target, ability, modifier_stacks, modifier_proc)

	-- If the target is not valid, do nothing
	if target:IsMagicImmune() or (not IsHeroOrCreep(target)) then
		return end

	-- Stack the maim up
	local modifier_maim = target:AddNewModifier(attacker, ability, modifier_stacks, {duration = ability:GetSpecialValueFor("stack_duration")})
	if modifier_maim:GetStackCount() < ability:GetSpecialValueFor("max_stacks") then
		modifier_maim:SetStackCount(modifier_maim:GetStackCount() + 1)
		target:EmitSound("Imba.SangeStack")
	end

	-- If the ability is not on cooldown, roll for a proc
	if ability:IsCooldownReady() and RollPercentage(ability:GetSpecialValueFor("proc_chance")) then

		-- Proc! Apply the disarm modifier and put the ability on cooldown
		target:AddNewModifier(attacker, ability, modifier_proc, {duration = ability:GetSpecialValueFor("proc_duration")})
		target:EmitSound("Imba.SangeProc")
		ability:StartCooldown(ability:GetCooldown(1) * GetCooldownReduction(attacker))
	end
end