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
--
--
--	Author:
--		naowin, 21.08.2019


-----------------------------------------------------------------------------------------------------------
--	Item Definition
-----------------------------------------------------------------------------------------------------------
LinkLuaModifier( "modifier_imba_aeon_disk_basic", "components/items/item_aeon_disk.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_aeon_disk_unique", "components/items/item_aeon_disk.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_aeon_disk", "components/items/item_aeon_disk.lua", LUA_MODIFIER_MOTION_NONE )
if item_imba_aeon_disk == nil then item_imba_aeon_disk = class({}) end
function item_imba_aeon_disk:GetAbilityTextureName()
	return "custom/imba_aeon_disk_icon"
end

function item_imba_aeon_disk:GetIntrinsicModifierName()
	return "modifier_imba_aeon_disk_basic" end

function item_imba_aeon_disk:OnSpellStart()
	if IsServer() then
		local uniqueModifier = self:GetCaster():FindModifierByName("modifier_imba_aeon_disk_unique")
		if not uniqueModifier then return end -- If this happens, something is terribly wrong

		-- Get, and toggle state [ 1 = disabled | 2 = enabled ]
		local state = uniqueModifier:GetStackCount()
		if state == 2 then
			uniqueModifier:SetStackCount(1)
		else
			uniqueModifier:SetStackCount(2)
		end

		-- Play sound only to the caster
		self:GetCaster():EmitSound("Item.DropGemWorld")

		-- Ignore the item's cooldown
		self:EndCooldown()
	end
end

function item_imba_aeon_disk:GetAbilityTextureName()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_aeon_disk_unique") then
		local state = caster:GetModifierStackCount("modifier_imba_aeon_disk_unique", caster)
		if state == 1 then return "custom/imba_aeon_disk_icon_off" end
	end

	return "custom/imba_aeon_disk_icon"
end



-----------------------------------------------------------------------------------------------------------
--	Basic modifier definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_aeon_disk_basic == nil then modifier_imba_aeon_disk_basic = class({}) end
function modifier_imba_aeon_disk_basic:IsHidden() return true end
function modifier_imba_aeon_disk_basic:IsDebuff() return false end
function modifier_imba_aeon_disk_basic:IsPurgable() return false end
function modifier_imba_aeon_disk_basic:IsPermanent() return true end
function modifier_imba_aeon_disk_basic:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_aeon_disk_basic:DeclareFunctions()
	local funcs = {	
			MODIFIER_PROPERTY_MANA_BONUS,
			MODIFIER_PROPERTY_HEALTH_BONUS,
		}
	return funcs
end

function modifier_imba_aeon_disk_basic:OnCreated()
	if IsServer() then 
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.modifier_self = "modifier_imba_aeon_disk_basic"
		self.uniqueModifier = "modifier_imba_aeon_disk_unique"

		if not self.caster:HasModifier(self.uniqueModifier) then
			local modifier_handler = self.caster:AddNewModifier(self.caster, self.ability, self.uniqueModifier, {})
			if modifier_handler then
				modifier_handler:SetStackCount(2)
			end
		end
	end
end

function modifier_imba_aeon_disk_basic:OnDestroy()
	if IsServer() then
		-- Remove the unique modifier if no other cores were found
		if not self:IsNull() and not self.caster:IsNull() and not self.caster:HasModifier(self.modifier_self) then
			self.caster:RemoveModifierByName(self.uniqueModifier)
		end
	end
end

function modifier_imba_aeon_disk_basic:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_mana") 
end

function modifier_imba_aeon_disk_basic:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health") 
end


-----------------------------------------------------------------------------------------------------------
--	Unique modifier definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_aeon_disk_unique == nil then modifier_imba_aeon_disk_unique = class({}) end
function modifier_imba_aeon_disk_unique:IsHidden() return true end
function modifier_imba_aeon_disk_unique:IsDebuff() return false end
function modifier_imba_aeon_disk_unique:IsPurgable() return false end
function modifier_imba_aeon_disk_unique:RemoveOnDeath() return false end

function modifier_imba_aeon_disk_unique:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

function modifier_imba_aeon_disk_unique:GetModifierIncomingDamage_Percentage(kv)
	if IsServer() then
		local state = self:GetStackCount()
		if state == 2 then	-- [ 1 = disabled | 2 = enabled ]

			local ability 	= self:GetAbility()
			local parent 	= self:GetParent()

			if ability:IsCooldownReady() and kv.attacker:GetOwner() and kv.attacker ~= parent and not parent:HasModifier("modifier_imba_aeon_disk") and not parent:IsIllusion() then
				local buff_duration 			= ability:GetSpecialValueFor("buff_duration")
				local health_threshold_pct 	= ability:GetSpecialValueFor("health_threshold_pct") / 100.0
				local health_treshold 	= parent:GetHealth() / parent:GetMaxHealth()
				
				if (health_treshold < health_threshold_pct or ((parent:GetHealth() - kv.damage) / parent:GetMaxHealth()) <= health_threshold_pct) and bit.band(kv.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
					parent:EmitSound("DOTA_Item.ComboBreaker")
				
					parent:Purge( false, true, false, true, true )
					local aeon_disc = parent:AddNewModifier(parent, ability, "modifier_imba_aeon_disk", {duration = buff_duration})
					ability:UseResources(false, false, true)
					
					return -100
				end
			end
		end
	end
end

if modifier_imba_aeon_disk == nil then modifier_imba_aeon_disk = class({}) end

function modifier_imba_aeon_disk:GetTexture()
	return "item_aeon_disk"
end

function modifier_imba_aeon_disk:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
	return funcs
end

function modifier_imba_aeon_disk:OnCreated(kv)
	self.damage_reduction	= self:GetAbility():GetSpecialValueFor("damage_reduction")
	self.status_resistance	= self:GetAbility():GetSpecialValueFor("status_resistance")

	if IsServer() then
		local parent 			= self:GetParent()
		self.ability 			= self:GetAbility()
	 	-- self.aeon_disk_pfx 		= ParticleManager:CreateParticle("particles/item/aeon_disk/imba_combo_breaker_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	 	-- local pfx_point 		= Vector(parent:GetAbsOrigin().x, parent:GetAbsOrigin().y , parent:GetAbsOrigin().z + parent:GetBoundingMaxs().z )   
		-- ParticleManager:SetParticleControl(self.aeon_disk_pfx, 0, pfx_point)
		-- ParticleManager:SetParticleControl(self.aeon_disk_pfx, 1, pfx_point)
		
		local combo_breaker_particle = ParticleManager:CreateParticle("particles/items4_fx/combo_breaker_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(combo_breaker_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(combo_breaker_particle, false, false, -1, true, false)
		
--	 else
--	 	self.damage_reduction 	= -100
	 end
end

-- function modifier_imba_aeon_disk:OnRemoved()
	-- if IsServer() then
		-- if self.aeon_disk_pfx ~= nil then
			-- ParticleManager:DestroyParticle(self.aeon_disk_pfx, false)
		-- end
	-- end
-- end

function modifier_imba_aeon_disk:GetModifierIncomingDamage_Percentage() 
	return -100
end

function modifier_imba_aeon_disk:GetModifierTotalDamageOutgoing_Percentage()
	return self.damage_reduction * (-1)
end

function modifier_imba_aeon_disk:GetModifierStatusResistanceStacking()
	return self.status_resistance
end
