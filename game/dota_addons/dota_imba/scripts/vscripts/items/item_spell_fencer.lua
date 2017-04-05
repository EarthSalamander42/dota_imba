--	Author: Firetoad
--	Date: 			25.03.2017
--	Last Update:	25.03.2017
--	Spellfencer definitions

-----------------------------------------------------------------------------------------------------------
--	Spellfencer definition
-----------------------------------------------------------------------------------------------------------

if item_imba_spell_fencer == nil then item_imba_spell_fencer = class({}) end
LinkLuaModifier( "modifier_item_imba_spell_fencer", "items/item_spell_fencer.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_spell_fencer_unique", "items/item_spell_fencer.lua", LUA_MODIFIER_MOTION_NONE )	-- Unique passive modifier
LinkLuaModifier( "modifier_item_imba_spell_fencer_buff", "items/item_spell_fencer.lua", LUA_MODIFIER_MOTION_NONE )		-- Physical damage prevention modifier

function item_imba_spell_fencer:GetIntrinsicModifierName()
	return "modifier_item_imba_spell_fencer" end

-----------------------------------------------------------------------------------------------------------
--	Spellfencer passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_spell_fencer == nil then modifier_item_imba_spell_fencer = class({}) end
function modifier_item_imba_spell_fencer:IsHidden() return true end
function modifier_item_imba_spell_fencer:IsDebuff() return false end
function modifier_item_imba_spell_fencer:IsPurgable() return false end
function modifier_item_imba_spell_fencer:IsPermanent() return true end
function modifier_item_imba_spell_fencer:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the unique modifier to the bearer when created
function modifier_item_imba_spell_fencer:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_spell_fencer_unique") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_imba_spell_fencer_unique", {})
		end
	end
end

-- Removes the unique modifier from the bearer if this is the last spellfencer in its inventory
function modifier_item_imba_spell_fencer:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_spell_fencer") then
			parent:RemoveModifierByName("modifier_item_imba_spell_fencer_unique")
		end
	end
end

-- Declare modifier events/properties
function modifier_item_imba_spell_fencer:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
	}
	return funcs
end

function modifier_item_imba_spell_fencer:GetModifierPercentageCooldown()
	return self:GetAbility():GetSpecialValueFor("bonus_cdr") end

function modifier_item_imba_spell_fencer:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

function modifier_item_imba_spell_fencer:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end

function modifier_item_imba_spell_fencer:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int") end

function modifier_item_imba_spell_fencer:GetModifierPercentageManaRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end

-----------------------------------------------------------------------------------------------------------
--	Spellfencer unique modifier
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_spell_fencer_unique == nil then modifier_item_imba_spell_fencer_unique = class({}) end
function modifier_item_imba_spell_fencer_unique:IsHidden() return true end
function modifier_item_imba_spell_fencer_unique:IsDebuff() return false end
function modifier_item_imba_spell_fencer_unique:IsPurgable() return false end
function modifier_item_imba_spell_fencer_unique:IsPermanent() return true end

-- Declare modifier events/properties
function modifier_item_imba_spell_fencer_unique:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

-- On attack landed, roll for proc and apply stacks
function modifier_item_imba_spell_fencer_unique:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()

		-- If this attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return end

		-- If this is an illusion, do nada
		if owner:IsIllusion() then
			return end

		-- If the target is not valid, do nothing either
		local target = keys.target
		if (not IsHeroOrCreep(target)) then
			return end

		-- Apply the damage conversion modifier and deal magical damage
		local ability = self:GetAbility()
		owner:AddNewModifier(owner, ability, "modifier_item_imba_spell_fencer_buff", {duration = 0.01})
		target:AddNewModifier(owner, ability, "modifier_item_imba_spell_fencer_buff", {duration = 0.01})
		ApplyDamage({attacker = owner, victim = target, ability = ability, damage = keys.original_damage, damage_type = DAMAGE_TYPE_MAGICAL})

		-- If a higher-priority sword is present, do zilch
		local priority_sword_modifiers = {
			"modifier_item_imba_sange_azura",
			"modifier_item_imba_azura_yasha",
			"modifier_item_imba_triumvirate"
		}
		for _, sword_modifier in pairs(priority_sword_modifiers) do
			if owner:HasModifier(sword_modifier) then
				return nil
			end
		end

		-- If the target is not valid, do nothing either
		if target:IsMagicImmune() or owner:GetTeam() == target:GetTeam() then
			return end

		-- Stack the magic amp up
		local modifier_amp = target:AddNewModifier(owner, ability, "modifier_item_imba_azura_amp", {duration = ability:GetSpecialValueFor("stack_duration")})
		if modifier_amp and modifier_amp:GetStackCount() < ability:GetSpecialValueFor("max_stacks") then
			modifier_amp:SetStackCount(modifier_amp:GetStackCount() + 1)
			target:EmitSound("Imba.AzuraStack")
		end

		-- If the ability is not on cooldown, roll for a proc
		if ability:IsCooldownReady() and RollPercentage(ability:GetSpecialValueFor("proc_chance")) then

			-- Proc! Apply the silence modifier and put the ability on cooldown
			target:AddNewModifier(owner, ability, "modifier_item_imba_azura_silence", {duration = ability:GetSpecialValueFor("proc_duration")})
			target:EmitSound("Imba.AzuraProc")
			ability:UseResources(false, false, true)
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Spellfencer damage conversion modifier
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_spell_fencer_buff == nil then modifier_item_imba_spell_fencer_buff = class({}) end
function modifier_item_imba_spell_fencer_buff:IsHidden() return true end
function modifier_item_imba_spell_fencer_buff:IsDebuff() return false end
function modifier_item_imba_spell_fencer_buff:IsPurgable() return false end
function modifier_item_imba_spell_fencer_buff:IsPermanent() return true end

-- Declare modifier events/properties
function modifier_item_imba_spell_fencer_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	}
	return funcs
end

function modifier_item_imba_spell_fencer_buff:GetAbsoluteNoDamagePhysical()
	return 1 end