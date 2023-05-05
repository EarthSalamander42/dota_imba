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
--  Editor:
--      AltiV, 02.03.2020 and a few times before that

-----------------------------------------------------------------------------------------------------------
--	Item Definition
-----------------------------------------------------------------------------------------------------------
LinkLuaModifier( "modifier_imba_aeon_disk_basic", "components/items/item_aeon_disk", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_aeon_disk", "components/items/item_aeon_disk", LUA_MODIFIER_MOTION_NONE )

if item_imba_aeon_disk == nil then item_imba_aeon_disk = class({}) end

function item_imba_aeon_disk:GetAbilityTextureName()
	return "imba_aeon_disk_icon"
end

function item_imba_aeon_disk:GetIntrinsicModifierName()
	return "modifier_imba_aeon_disk_basic"
end

function item_imba_aeon_disk:OnSpellStart()
	-- Play sound only to the caster
	self:GetCaster():EmitSound("Item.DropGemWorld")
		
	for _, mod in pairs(self:GetCaster():FindAllModifiersByName("modifier_imba_aeon_disk_basic")) do
		if mod:GetStackCount() == 2 then
			mod:SetStackCount(1)
		else
			mod:SetStackCount(2)
		end
	end

	-- Ignore the item's cooldown
	self:EndCooldown()
end

function item_imba_aeon_disk:GetAbilityTextureName()
	if self:GetCaster():GetModifierStackCount("modifier_imba_aeon_disk_basic", self:GetCaster()) == 1 then
		return "imba_aeon_disk_icon_off"
	else
		return "imba_aeon_disk_icon"
	end
end

-----------------------------------------------------------------------------------------------------------
--	Basic modifier definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_aeon_disk_basic == nil then modifier_imba_aeon_disk_basic = class({}) end
function modifier_imba_aeon_disk_basic:IsHidden()			return true end
function modifier_imba_aeon_disk_basic:IsPurgable()		return false end
function modifier_imba_aeon_disk_basic:RemoveOnDeath()	return false end
function modifier_imba_aeon_disk_basic:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_aeon_disk_basic:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if self:GetAbility() then
		self.bonus_health	= self:GetAbility():GetSpecialValueFor("bonus_health")
		self.bonus_mana		= self:GetAbility():GetSpecialValueFor("bonus_mana")
	else
		self.bonus_health	= 0
		self.bonus_mana		= 0
	end

	if IsServer() then
		self:SetStackCount(2)
	end
end

function modifier_imba_aeon_disk_basic:DeclareFunctions()
	return {	
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_imba_aeon_disk_basic:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_imba_aeon_disk_basic:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_imba_aeon_disk_basic:GetModifierIncomingDamage_Percentage(kv)
	-- [ 1 = disabled | 2 = enabled ]
	if self:GetParent():FindAllModifiersByName("modifier_imba_aeon_disk_basic")[1] == self and self:GetStackCount() == 2 and self:GetAbility() and self:GetAbility():IsCooldownReady() and kv.attacker ~= self:GetParent() and not self:GetParent():HasModifier("modifier_imba_aeon_disk") and not self:GetParent():IsIllusion() then
		local buff_duration			= self:GetAbility():GetSpecialValueFor("buff_duration")
		local health_threshold_pct	= self:GetAbility():GetSpecialValueFor("health_threshold_pct") / 100.0
		local health_threshold		= self:GetParent():GetHealth() / self:GetParent():GetMaxHealth()
		
		if (health_threshold < health_threshold_pct or ((self:GetParent():GetHealth() - kv.damage) / self:GetParent():GetMaxHealth()) <= health_threshold_pct) and bit.band(kv.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
			self:GetParent():EmitSound("DOTA_Item.ComboBreaker")
		
			self:GetParent():Purge( false, true, false, true, true )
			local aeon_disc = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_aeon_disk", {duration = buff_duration})
			
			self:GetParent():SetHealth(math.min(self:GetParent():GetHealth(), self:GetParent():GetMaxHealth() * health_threshold_pct))
			
			self:GetAbility():UseResources(false, false, false, true)
			
			return -100
		end
	end
end

-----------------------------
-- MODIFIER_IMBA_AEON_DISK --
-----------------------------

if modifier_imba_aeon_disk == nil then modifier_imba_aeon_disk = class({}) end

function modifier_imba_aeon_disk:GetTexture()
	return "item_aeon_disk"
end

function modifier_imba_aeon_disk:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
end

function modifier_imba_aeon_disk:OnCreated(kv)
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
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
