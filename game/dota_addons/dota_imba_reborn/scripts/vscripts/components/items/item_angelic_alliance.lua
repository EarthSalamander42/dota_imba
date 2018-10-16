-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Editors:
--

--	Angelic Alliance
--	Author: zimberzimber
--	Date:	27.1.2017

if item_imba_angelic_alliance == nil then item_imba_angelic_alliance = class({}) end
LinkLuaModifier( "modifier_imba_angelic_alliance_debuff", "components/items/item_angelic_alliance.lua", LUA_MODIFIER_MOTION_NONE )					--	Disarm, armor reduction, vision
LinkLuaModifier( "modifier_imba_angelic_alliance_passive_effect", "components/items/item_angelic_alliance.lua", LUA_MODIFIER_MOTION_NONE )			--	Item Modifier + attack/hit effect
LinkLuaModifier( "modifier_imba_angelic_alliance_slow_decaying", "components/items/item_angelic_alliance.lua", LUA_MODIFIER_MOTION_NONE )			--	Decaying slow
LinkLuaModifier( "modifier_imba_angelic_alliance_buff", "components/items/item_angelic_alliance.lua", LUA_MODIFIER_MOTION_NONE )					--	Evasion, armor, vision
LinkLuaModifier( "modifier_imba_angelic_alliance_haste_decaying", "components/items/item_angelic_alliance.lua", LUA_MODIFIER_MOTION_NONE )			--	Decaying haste
LinkLuaModifier( "modifier_imba_angelic_alliance_debuff_caster", "components/items/item_angelic_alliance.lua", LUA_MODIFIER_MOTION_NONE )			--	Armor reduction for the caster
LinkLuaModifier( "modifier_imba_angelic_alliance_passive_disarm", "components/items/item_angelic_alliance.lua", LUA_MODIFIER_MOTION_NONE )			--	Passive disarm from attacking or getting attacked
LinkLuaModifier( "modifier_imba_angelic_alliance_passive_disarm_cooldown", "components/items/item_angelic_alliance.lua", LUA_MODIFIER_MOTION_NONE )--	Cooldown for the passive disarm effect per target

-----------------------------------------------------------------------------------------------------------
--	Item Definition
-----------------------------------------------------------------------------------------------------------

function item_imba_angelic_alliance:GetAbilityTextureName()
	return "custom/imba_angelic_alliance"
end

function item_imba_angelic_alliance:GetManaCost()		return self:GetSpecialValueFor("mana_cost")	end
function item_imba_angelic_alliance:GetCooldown()		return self:GetSpecialValueFor("cooldown")	end
function item_imba_angelic_alliance:GetCastRange()		return self:GetSpecialValueFor("cast_range")end
function item_imba_angelic_alliance:GetBehavior()		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET 	end
function item_imba_angelic_alliance:IsRefreshable()		return true		end
function item_imba_angelic_alliance:ProcsMagicStick()	return false	end

function item_imba_angelic_alliance:GetIntrinsicModifierName()
	return "modifier_imba_angelic_alliance_passive_effect"
end

function item_imba_angelic_alliance:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(self) then
			return
		end
	end

	-- If the target is magic immune (Lotus Orb/Anti Mage), do nothing
	if target:IsMagicImmune() then
		return nil
	end

	if target:GetTeamNumber() == caster:GetTeamNumber() then
		target:EmitSound("Imba.AngelicAllianceCast")
		target:AddNewModifier(caster, self, "modifier_imba_angelic_alliance_buff", {duration = duration})
		target:RemoveModifierByName("modifier_imba_angelic_alliance_haste_decaying")

		local hasteBuff = target:AddNewModifier(caster, self, "modifier_imba_angelic_alliance_haste_decaying", {})
		hasteBuff:SetStackCount(duration*2)
	else
		if target:TriggerSpellAbsorb(self) then return nil end
		target:EmitSound("Imba.AngelicAllianceCast")
		target:AddNewModifier(caster, self, "modifier_imba_angelic_alliance_debuff", {duration = duration})
		target:RemoveModifierByName("modifier_imba_angelic_alliance_slow_decaying")

		local slowDebuff = target:AddNewModifier(caster, self, "modifier_imba_angelic_alliance_slow_decaying", {})
		slowDebuff:SetStackCount(duration*2)
	end

	caster:AddNewModifier(caster, self, "modifier_imba_angelic_alliance_debuff_caster", {duration = duration})
end

function item_imba_angelic_alliance:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()

		if caster == target then
			return UF_FAIL_CUSTOM
		end

		if target:IsBuilding() then
			return UF_FAIL_BUILDING
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function item_imba_angelic_alliance:GetCustomCastErrorTarget(target)
	return "dota_hud_error_cant_cast_on_self"
end



-----------------------------------------------------------------------------------------------------------
--	Item Modifier (stats + attack/damaged effect)
-----------------------------------------------------------------------------------------------------------

if modifier_imba_angelic_alliance_passive_effect == nil then modifier_imba_angelic_alliance_passive_effect = class({}) end
function modifier_imba_angelic_alliance_passive_effect:IsHidden() return true end
function modifier_imba_angelic_alliance_passive_effect:IsDebuff() return false end
function modifier_imba_angelic_alliance_passive_effect:IsPurgable() return false end

function modifier_imba_angelic_alliance_passive_effect:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,			}
	return funcs
end

function modifier_imba_angelic_alliance_passive_effect:GetModifierBonusStats_Strength()
	local ability = self:GetAbility()
	local strength = ability:GetSpecialValueFor("bonus_strength")
	return strength
end

function modifier_imba_angelic_alliance_passive_effect:GetModifierPhysicalArmorBonus()
	local ability = self:GetAbility()
	local armor = ability:GetSpecialValueFor("armor_change")
	return armor
end

function modifier_imba_angelic_alliance_passive_effect:GetModifierEvasion_Constant()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local evasion = ability:GetSpecialValueFor("bonus_evasion")

	if parent:HasModifier("modifier_imba_angelic_alliance_debuff_caster") then return 0 end
	return evasion
end

function modifier_imba_angelic_alliance_passive_effect:GetModifierPercentageManaRegen()
	local ability = self:GetAbility()
	local mana_regen = ability:GetSpecialValueFor("bonus_mana_regen_pcnt")
	return mana_regen
end

function modifier_imba_angelic_alliance_passive_effect:GetModifierPreAttack_BonusDamage()
	local ability = self:GetAbility()
	local bonus_damage = ability:GetSpecialValueFor("bonus_damage")
	return bonus_damage
end

function modifier_imba_angelic_alliance_passive_effect:OnAttackLanded( keys )
	if IsServer() then
		local target = keys.target			-- Guy getting hit
		local attacker = keys.attacker		-- Guy landing the hit
		local caster = self:GetCaster()		-- Guy holding this modifier
		local ability = self:GetAbility()
		local chance = ability:GetSpecialValueFor("passive_disarm_chance")
		local duration = ability:GetSpecialValueFor("passive_disarm_duration")

		if caster:HasModifier("modifier_imba_angelic_alliance_debuff_caster") then return nil end
		-- Proc once every 6 seconds, regardless of if it's us attacking or being attacked
		if caster:HasModifier("modifier_imba_angelic_alliance_passive_disarm_cooldown") then return nil end
		-- Don't disarm towers
		if attacker:IsBuilding() or target:IsBuilding() then
			return nil
		end

		if caster == target and RollPseudoRandom(chance, self) then				-- Disarm attacker when the wielder is the one getting hit
			if attacker:IsMagicImmune() then return end
			if attacker:HasModifier("modifier_imba_angelic_alliance_passive_disarm") then return end
			attacker:AddNewModifier(caster, ability, "modifier_imba_angelic_alliance_passive_disarm", {duration = duration})
			attacker:EmitSound("DOTA_Item.HeavensHalberd.Activate")
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Enemy Debuff
-----------------------------------------------------------------------------------------------------------

if modifier_imba_angelic_alliance_debuff == nil then modifier_imba_angelic_alliance_debuff = class({}) end
function modifier_imba_angelic_alliance_debuff:IsDebuff() return true end
function modifier_imba_angelic_alliance_debuff:IsHidden() return false end
function modifier_imba_angelic_alliance_debuff:IsPurgable() return false end
function modifier_imba_angelic_alliance_debuff:GetModifierProvidesFOWVision() return 1 end
function modifier_imba_angelic_alliance_debuff:GetTexture() return "custom/imba_angelic_alliance" end

function modifier_imba_angelic_alliance_debuff:DeclareFunctions()
	local decFuncs = {	MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, }
	return decFuncs
end

function modifier_imba_angelic_alliance_debuff:GetEffectName()
	return "particles/item/angelic_alliance/angelic_alliance_debuff.vpcf" end

function modifier_imba_angelic_alliance_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_angelic_alliance_debuff:GetModifierPhysicalArmorBonus()
	local ability = self:GetAbility()
	local armor = ability:GetSpecialValueFor("armor_change")*-1
	return armor
end

function modifier_imba_angelic_alliance_debuff:CheckState()
	local mods = { [MODIFIER_STATE_DISARMED] = true, }
	return mods
end

-----------------------------------------------------------------------------------------------------------
--	Enemy Decaying Slow
-----------------------------------------------------------------------------------------------------------

if modifier_imba_angelic_alliance_slow_decaying == nil then modifier_imba_angelic_alliance_slow_decaying = class({}) end
function modifier_imba_angelic_alliance_slow_decaying:IsDebuff() return true end
function modifier_imba_angelic_alliance_slow_decaying:IsHidden() return true end
function modifier_imba_angelic_alliance_slow_decaying:IsPurgable() return false end

function modifier_imba_angelic_alliance_slow_decaying:OnCreated()
	if IsServer() then self:StartIntervalThink( 0.5 ) end
end

function modifier_imba_angelic_alliance_slow_decaying:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
	return funcs
end

function modifier_imba_angelic_alliance_slow_decaying:GetModifierMoveSpeedBonus_Percentage()
	local target = self:GetParent()
	if target:IsMagicImmune() then return 0 end

	local ability = self:GetAbility()
	local slowRate = ability:GetSpecialValueFor("slow_decay")
	local modifier = "modifier_imba_angelic_alliance_slow_decaying"
	local current_stacks = target:GetModifierStackCount(modifier, caster)
	local totalSlow = slowRate/2 * current_stacks
	return totalSlow
end

function modifier_imba_angelic_alliance_slow_decaying:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local modifier = "modifier_imba_angelic_alliance_slow_decaying"
		local current_stacks = target:GetModifierStackCount(modifier, caster)

		if current_stacks <= 1 then
			target:RemoveModifierByName(modifier)
		else
			self:DecrementStackCount()
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Ally Buff
-----------------------------------------------------------------------------------------------------------

if modifier_imba_angelic_alliance_buff == nil then modifier_imba_angelic_alliance_buff = class({}) end
function modifier_imba_angelic_alliance_buff:IsHidden() return false end
function modifier_imba_angelic_alliance_buff:IsDebuff() return false end
function modifier_imba_angelic_alliance_buff:IsPurgable() return false end
function modifier_imba_angelic_alliance_buff:GetModifierProvidesFOWVision() return 1 end
function modifier_imba_angelic_alliance_buff:GetTexture() return "custom/imba_angelic_alliance" end

function modifier_imba_angelic_alliance_buff:GetEffectName()
	return "particles/item/angelic_alliance/angelic_alliance_buff.vpcf" end

function modifier_imba_angelic_alliance_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_angelic_alliance_buff:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_EVASION_CONSTANT,}
	return funcs
end

function modifier_imba_angelic_alliance_buff:GetModifierPhysicalArmorBonus()
	local ability = self:GetAbility()
	local armor = ability:GetSpecialValueFor("armor_change")
	return armor
end

function modifier_imba_angelic_alliance_buff:GetModifierEvasion_Constant()
	local ability = self:GetAbility()
	local evasion = ability:GetSpecialValueFor("active_evasion")
	return evasion
end

-----------------------------------------------------------------------------------------------------------
--	Ally Decaying Haste
-----------------------------------------------------------------------------------------------------------

if modifier_imba_angelic_alliance_haste_decaying == nil then modifier_imba_angelic_alliance_haste_decaying = class({}) end
function modifier_imba_angelic_alliance_haste_decaying:IsHidden() return true end
function modifier_imba_angelic_alliance_haste_decaying:IsDebuff() return false end
function modifier_imba_angelic_alliance_haste_decaying:IsPurgable() return false end

function modifier_imba_angelic_alliance_haste_decaying:OnCreated()
	if IsServer() then self:StartIntervalThink( 0.5 ) end
end

function modifier_imba_angelic_alliance_haste_decaying:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
	return funcs
end

function modifier_imba_angelic_alliance_haste_decaying:GetModifierMoveSpeedBonus_Percentage()
	local ability = self:GetAbility()
	local target = self:GetParent()
	local slowRate = ability:GetSpecialValueFor("haste_decay")
	local modifier = "modifier_imba_angelic_alliance_haste_decaying"
	local current_stacks = target:GetModifierStackCount(modifier, caster)
	local totalSlow = slowRate/2 * current_stacks
	return totalSlow
end

function modifier_imba_angelic_alliance_haste_decaying:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local modifier = "modifier_imba_angelic_alliance_haste_decaying"
		local current_stacks = target:GetModifierStackCount(modifier, caster)

		if current_stacks <= 1 then
			target:RemoveModifierByName(modifier)
		else
			self:DecrementStackCount()
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Caster Debuff
-----------------------------------------------------------------------------------------------------------

if modifier_imba_angelic_alliance_debuff_caster == nil then modifier_imba_angelic_alliance_debuff_caster = class({}) end
function modifier_imba_angelic_alliance_debuff_caster:IsHidden() return false end
function modifier_imba_angelic_alliance_debuff_caster:IsDebuff() return true end
function modifier_imba_angelic_alliance_debuff_caster:IsPurgable() return false end

function modifier_imba_angelic_alliance_debuff_caster:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, }
	return funcs
end

function modifier_imba_angelic_alliance_debuff_caster:GetEffectName()
	return "particles/items2_fx/medallion_of_courage.vpcf" end

function modifier_imba_angelic_alliance_debuff_caster:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_angelic_alliance_debuff_caster:GetModifierPhysicalArmorBonus()
	local ability = self:GetAbility()
	local armor = ability:GetSpecialValueFor("armor_change") *-1
	return armor
end

-----------------------------------------------------------------------------------------------------------
--	Passive disarm (from attacks or getting attacked)
-----------------------------------------------------------------------------------------------------------

if modifier_imba_angelic_alliance_passive_disarm == nil then modifier_imba_angelic_alliance_passive_disarm = class({}) end


function modifier_imba_angelic_alliance_passive_disarm:IsHidden() return false end
function modifier_imba_angelic_alliance_passive_disarm:IsDebuff() return true end
function modifier_imba_angelic_alliance_passive_disarm:IsPurgable() return false end

function modifier_imba_angelic_alliance_passive_disarm:GetEffectName()
	return "particles/generic_gameplay/generic_disarm.vpcf" end

function modifier_imba_angelic_alliance_passive_disarm:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_angelic_alliance_passive_disarm:CheckState()
	local mods = { [MODIFIER_STATE_DISARMED] = true, }
	return mods
end

function modifier_imba_angelic_alliance_passive_disarm:OnCreated( keys )
	if IsServer() then
		local target = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local duration = ability:GetSpecialValueFor("passive_disarm_cooldown")

		caster:AddNewModifier(caster, ability, "modifier_imba_angelic_alliance_passive_disarm_cooldown", {duration = duration})
	end
end

-----------------------------------------------------------------------------------------------------------
--	Passive disarm cooldown (prevents the passive disarm from proccing)
-----------------------------------------------------------------------------------------------------------

if modifier_imba_angelic_alliance_passive_disarm_cooldown == nil then modifier_imba_angelic_alliance_passive_disarm_cooldown = class({}) end
function modifier_imba_angelic_alliance_passive_disarm_cooldown:IsHidden() return false end
function modifier_imba_angelic_alliance_passive_disarm_cooldown:IsDebuff() return true end
function modifier_imba_angelic_alliance_passive_disarm_cooldown:IsPurgable() return false end
function modifier_imba_angelic_alliance_passive_disarm_cooldown:GetTexture() return "custom/imba_angelic_alliance" end
