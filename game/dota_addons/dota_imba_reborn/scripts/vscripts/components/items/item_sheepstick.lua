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

--	Author: Firetoad
--	Date: 			09.05.2015
--	Last Update:	18.03.2017

-----------------------------------------------------------------------------------------------------------
--	Sheepstick definition
-----------------------------------------------------------------------------------------------------------

item_imba_sheepstick = item_imba_sheepstick or class({})
LinkLuaModifier( "modifier_item_imba_sheepstick", "components/items/item_sheepstick.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_sheepstick_debuff", "components/items/item_sheepstick.lua", LUA_MODIFIER_MOTION_NONE )	-- Enemy debuff
LinkLuaModifier( "modifier_item_imba_sheepstick_buff", "components/items/item_sheepstick.lua", LUA_MODIFIER_MOTION_NONE )		-- Self-use buff

function item_imba_sheepstick:GetIntrinsicModifierName()
	return "modifier_item_imba_sheepstick"
end

function item_imba_sheepstick:CastFilterResultTarget(target)
	-- Can't cast on allies, except for yourself
	if self:GetCaster():GetTeamNumber() == target:GetTeamNumber() and self:GetCaster() ~= target then
		return UF_FAIL_CUSTOM
--	elseif target:HasModifier("modifier_item_imba_sheepstick_debuff") or target:HasModifier("modifier_imba_lion_hex") or target:HasModifier("modifier_shadow_shaman_voodoo") then
--		return UF_FAIL_CUSTOM
	end
	
	return UnitFilter( target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber() )
end

function item_imba_sheepstick:GetCustomCastErrorTarget(target)
	local caster = self:GetCaster()
	if caster:GetTeamNumber() == target:GetTeamNumber() and caster ~= target then
		return "#dota_hud_error_only_cast_on_self"
--	elseif target:HasModifier("modifier_item_imba_sheepstick_debuff") or target:HasModifier("modifier_imba_lion_hex") or target:HasModifier("modifier_shadow_shaman_voodoo") then
--		return "#dota_hud_error_cant_use_already_hexed"
	end
end

function item_imba_sheepstick:OnSpellStart()
	if IsServer() then
		-- Parameters
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local hex_duration = self:GetSpecialValueFor("hex_duration")
		local modified_duration = hex_duration

		if target:IsMagicImmune() then
			return nil
		end

		-- If the target possesses a ready Linken's Sphere, do nothing
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
		end

		-- Play the cast sound
		target:EmitSound("DOTA_Item.Sheepstick.Activate")

		-- Kill the target instantly if it is an illusion
		if target:IsIllusion() and not Custom_bIsStrongIllusion(target) then
			target:ForceKill(true)
			return
		end

		-- If the target is yourself, apply the buff and purge, else, the debuff
		if caster == target then
			target:AddNewModifier(caster, self, "modifier_item_imba_sheepstick_buff", {duration = hex_duration})
			target:Purge(false, true, false, false, false)
			
			-- Find targets in range
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("self_debuff_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

			for _,enemy in pairs(nearby_enemies) do
				-- Kill the target instantly if it is an illusion
				if enemy:IsIllusion() and (not enemy.Custom_IsStrongIllusion or (enemy.Custom_IsStrongIllusion and not enemy:Custom_IsStrongIllusion())) then
					enemy:ForceKill(true)
				else
					enemy:AddNewModifier(caster, self, "modifier_item_imba_sheepstick_debuff", {duration = modified_duration * (1 - enemy:GetStatusResistance())})
				end
			end
		else
			target:AddNewModifier(caster, self, "modifier_item_imba_sheepstick_debuff", {duration = modified_duration * (1 - target:GetStatusResistance())})
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Sheepstick owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sheepstick == nil then modifier_item_imba_sheepstick = class({}) end

function modifier_item_imba_sheepstick:IsHidden() return true end
function modifier_item_imba_sheepstick:IsPurgable() return false end
function modifier_item_imba_sheepstick:RemoveOnDeath() return false end
function modifier_item_imba_sheepstick:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Attribute bonuses
function modifier_item_imba_sheepstick:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_item_imba_sheepstick:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self:OnIntervalThink()
	self:StartIntervalThink(1.0)
end

function modifier_item_imba_sheepstick:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_strength") end

function modifier_item_imba_sheepstick:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agility") end

function modifier_item_imba_sheepstick:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_intellect") end

function modifier_item_imba_sheepstick:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end

-----------------------------------------------------------------------------------------------------------
--	Sheepstick enemy debuff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sheepstick_debuff == nil then modifier_item_imba_sheepstick_debuff = class({}) end
function modifier_item_imba_sheepstick_debuff:IsHidden() return false end
function modifier_item_imba_sheepstick_debuff:IsDebuff() return true end
function modifier_item_imba_sheepstick_debuff:IsPurgable() return true end

-- Declare modifier events/properties
function modifier_item_imba_sheepstick_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}
	return funcs
end

function modifier_item_imba_sheepstick_debuff:OnCreated()
	if IsServer() then
		self.sheep_pfx = ParticleManager:CreateParticle("particles/items_fx/item_sheepstick.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster())
		ParticleManager:SetParticleControl(self.sheep_pfx, 0, self:GetParent():GetAbsOrigin())

		print(self:GetCaster().sheepstick_model)

		if self:GetCaster().sheepstick_model then
			if self:GetCaster().sheepstick_model == "models/props_gameplay/pig_blue.vmdl" then
				self:SetStackCount(1)
			elseif self:GetCaster().sheepstick_model == "models/props_gameplay/roquelaire/roquelaire.vmdl" then
				self:SetStackCount(2)
			end
		end
	end
end

function modifier_item_imba_sheepstick_debuff:OnRefresh()
	if not IsServer() then return end

	self:OnCreated()
end

function modifier_item_imba_sheepstick_debuff:GetModifierMoveSpeedOverride()
	return self:GetAbility():GetSpecialValueFor("enemy_move_speed") end

function modifier_item_imba_sheepstick_debuff:GetModifierModelChange()
	-- Yeah, i know...
	if self:GetStackCount() == 1 then
		return "models/props_gameplay/pig_blue.vmdl"
	elseif self:GetStackCount() == 2 then
		return "models/props_gameplay/roquelaire/roquelaire.vmdl"
	end

	return "models/props_gameplay/pig.vmdl"
end

function modifier_item_imba_sheepstick_debuff:GetVisualZDelta()
	-- if self:GetStackCount() == 2 then
		-- return 220
	-- end

	return 0
end

-- Hexed state
function modifier_item_imba_sheepstick_debuff:CheckState()
	local states = {
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
	return states
end

function modifier_item_imba_sheepstick_debuff:OnDestroy()
	if IsServer() then
		if self.sheep_pfx then
			ParticleManager:DestroyParticle(self.sheep_pfx, false)
			ParticleManager:ReleaseParticleIndex(self.sheep_pfx)
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Sheepstick self-buff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sheepstick_buff == nil then modifier_item_imba_sheepstick_buff = class({}) end
function modifier_item_imba_sheepstick_buff:IsHidden() return false end
function modifier_item_imba_sheepstick_buff:IsDebuff() return false end
function modifier_item_imba_sheepstick_buff:IsPurgable() return true end

function modifier_item_imba_sheepstick_buff:OnCreated()
	if IsServer() then
		self.sheep_pfx = ParticleManager:CreateParticle("particles/items_fx/item_sheepstick.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster())
		ParticleManager:SetParticleControl(self.sheep_pfx, 0, self:GetParent():GetAbsOrigin())
	end
end

-- Destroy trees at the end of the self-buff's duration
function modifier_item_imba_sheepstick_buff:OnDestroy()
	if IsServer() then
		local owner = self:GetParent()
		GridNav:DestroyTreesAroundPoint(owner:GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("tree_radius"), false)

		if self.sheep_pfx then
			ParticleManager:DestroyParticle(self.sheep_pfx, false)
			ParticleManager:ReleaseParticleIndex(self.sheep_pfx)
		end
	end
end

-- Base movement speed override
function modifier_item_imba_sheepstick_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
	return funcs
end

function modifier_item_imba_sheepstick_buff:GetModifierMoveSpeed_AbsoluteMin()
	return self:GetAbility():GetSpecialValueFor("self_move_speed") end
	
function modifier_item_imba_sheepstick_buff:GetModifierModelChange()
	return "models/items/courier/mighty_chicken/mighty_chicken_flying.vmdl" end

-- Hexed state
function modifier_item_imba_sheepstick_buff:CheckState()
	local states = {
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
	}
	return states
end
