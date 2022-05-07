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

item_imba_hood_of_defiance = item_imba_hood_of_defiance or class({})
LinkLuaModifier("modifier_imba_hood_of_defiance_passive", "components/items/item_hood_of_defiance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_hood_of_defiance_barrier", "components/items/item_hood_of_defiance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hood_of_defiance_active_bonus", "components/items/item_hood_of_defiance.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_hood_of_defiance:GetIntrinsicModifierName()
	return "modifier_imba_hood_of_defiance_passive"
end

function item_imba_hood_of_defiance:OnSpellStart()
	self:GetCaster():EmitSound("DOTA_Item.Pipe.Activate")
	
	self:GetCaster():RemoveModifierByName("modifier_item_imba_hood_of_defiance_barrier")
	
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_hood_of_defiance_barrier", {duration = self:GetSpecialValueFor("duration"), shield_health = self:GetSpecialValueFor("shield_health")})
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_hood_of_defiance_active_bonus", {duration = self:GetSpecialValueFor("duration"), unreducable_magic_resist = self:GetSpecialValueFor("unreducable_magic_resist")})
end

-----------------------------------------------------------------------------------------------------------
--	Hood of Defiance stats modifier
-----------------------------------------------------------------------------------------------------------
modifier_imba_hood_of_defiance_passive = modifier_imba_hood_of_defiance_passive or class({})

function modifier_imba_hood_of_defiance_passive:IsHidden() return true end
function modifier_imba_hood_of_defiance_passive:IsPurgable() return false end
function modifier_imba_hood_of_defiance_passive:RemoveOnDeath() return false end
function modifier_imba_hood_of_defiance_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_hood_of_defiance_passive:OnCreated( params )
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.active_tenacity_pct = self:GetAbility():GetSpecialValueFor("active_tenacity_pct")
end

function modifier_imba_hood_of_defiance_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_imba_hood_of_defiance_passive:GetModifierConstantHealthRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	end
end

function modifier_imba_hood_of_defiance_passive:GetModifierMagicalResistanceBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_magic_resist")
	end
end

function modifier_imba_hood_of_defiance_passive:GetModifierStatusResistanceStacking()
	if self:GetParent():HasModifier("modifier_imba_hood_of_defiance_active_bonus") then
		return self.active_tenacity_pct
	elseif self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("passive_tenacity_pct")
	end
end

-----------------------------------------------------------------------------------------------------------
--	Hood of Defiance active shield that protects from spell damage
-----------------------------------------------------------------------------------------------------------
modifier_item_imba_hood_of_defiance_barrier = modifier_item_imba_hood_of_defiance_barrier or class({})

function modifier_item_imba_hood_of_defiance_barrier:IsDebuff() return false end
function modifier_item_imba_hood_of_defiance_barrier:IsHidden() return false end
function modifier_item_imba_hood_of_defiance_barrier:IsPurgable() return false end
function modifier_item_imba_hood_of_defiance_barrier:IsPurgeException() return false end

function modifier_item_imba_hood_of_defiance_barrier:OnCreated( params )
	if not self:GetAbility() then self:Destroy() return end

	self.barrier_block			= self:GetAbility():GetSpecialValueFor("barrier_block")
	self.barrier_health			= self.barrier_block
	
	self.particle = ParticleManager:CreateParticle("particles/items2_fx/pipe_of_insight.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle, 2, Vector(self:GetParent():GetModelRadius() * 1.2, 0, 0))
	self:AddParticle(self.particle, false, false, -1, false, false)
end

-- -- Don't override pipe's higher potency shield, unless it'c current health is lower than the new one
-- function modifier_item_imba_hood_of_defiance_barrier:OnRefresh( params )
	-- if IsServer() and self.shield_health < params.shield_health then
		-- self.shield_health = params.shield_health
	-- end
-- end

-- -- Shield absorption, returns damage to deal to the victim (in DamageFilter)
-- function modifier_item_imba_hood_of_defiance_barrier:AbsorbDamage(damage)
	-- if IsServer() then
		-- local new_health = self.shield_health - damage
		-- if new_health > 0 then
			-- self.shield_health = new_health
			-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, self.parent, damage, nil)
			-- return 0
		-- else
			-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, self.parent, self.shield_health, nil)
			-- self:Destroy()
			-- return -(new_health)
		-- end
	-- end
-- end

function modifier_item_imba_hood_of_defiance_barrier:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT}
end

function modifier_item_imba_hood_of_defiance_barrier:GetModifierIncomingSpellDamageConstant(keys)
	if IsClient() then
		return self.barrier_block
	else
		if keys.damage_type == DAMAGE_TYPE_MAGICAL then
			if keys.original_damage >= self.barrier_health then
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, self:GetParent(), self.barrier_health, nil)
			
				self:Destroy()
				return self.barrier_health * (-1)
			else
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, self:GetParent(), keys.original_damage, nil)
			
				self.barrier_health = self.barrier_health - keys.original_damage
				return keys.original_damage * (-1)
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Hood of Defiance active bonus that increases tenacity and makes the magic resistance unreducable
--  (by calculating a compensation)
-----------------------------------------------------------------------------------------------------------
modifier_imba_hood_of_defiance_active_bonus = modifier_imba_hood_of_defiance_active_bonus or class({})

function modifier_imba_hood_of_defiance_active_bonus:IsDebuff() return false end
function modifier_imba_hood_of_defiance_active_bonus:IsHidden() return false end
function modifier_imba_hood_of_defiance_active_bonus:IsPurgable() return false end
function modifier_imba_hood_of_defiance_active_bonus:IsPurgeException() return false end

function modifier_imba_hood_of_defiance_active_bonus:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.magic_resist_compensation = 0
	self.precision = 0.5 / 100 -- margin of 0.5% magic resistance. This is to prevent rounding-related errors/recalculations
	self.parent = self:GetParent()

	self.unreducable_magic_resist = self:GetAbility():GetSpecialValueFor("unreducable_magic_resist")
	self.unreducable_magic_resist = self.unreducable_magic_resist / 100
	self:StartIntervalThink(0.1)
end

function modifier_imba_hood_of_defiance_active_bonus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_imba_hood_of_defiance_active_bonus:OnIntervalThink()
	-- No Sell. If you want item-dropping shenanigans, get Pipe
	if not self.parent:HasModifier("modifier_imba_hood_of_defiance_passive") then
		self:StartIntervalThink(-1)
		self:Destroy()
		return
	end

	-- If we are under the effect of the stronger bonus of pipe, reset ourseleves and do nothing
	if self.parent:HasModifier("modifier_imba_pipe_active_bonus") then
		self.magic_resist_compensation = 0
		return
	end

	local current_res = self.parent:GetMagicalArmorValue()
	-- If we are below the margin, we need to add magic resistance
	if current_res < ( self.unreducable_magic_resist - self.precision ) then
		-- Serious math
		if self.magic_resist_compensation > 0 then
			local current_compensation = self.magic_resist_compensation / 100
			local compensation = ( self.unreducable_magic_resist - 1 ) * ( 1 - current_compensation) / (1 - current_res) + 1
			self.magic_resist_compensation = compensation * 100
		else
			local compensation = 1 + (self.unreducable_magic_resist - 1) / (1 - current_res)
			self.magic_resist_compensation = compensation * 100
		end
		-- If we already have compensation and are above the margin, decrease it
	elseif self.magic_resist_compensation > 0 and current_res > ( self.unreducable_magic_resist + self.precision ) then
		-- Serious copy-paste
		local current_compensation = self.magic_resist_compensation / 100
		local compensation = (self.unreducable_magic_resist - 1) * ( 1 - current_compensation) / (1 - current_res) + 1

		self.magic_resist_compensation = math.max(compensation * 100, 0)
	end
end

function modifier_imba_hood_of_defiance_active_bonus:GetModifierMagicalResistanceBonus()
	if IsClient() then
		return self.unreducable_magic_resist * 100
	else
		return self.magic_resist_compensation
	end
end
