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

-- Author: Ported from Angel Arena Black Star's Github
-- https://github.com/ark120202/aabs/blob/1faaadbc3cbf9f9d9bf2cbb8c1e2463141c17d2e/game/scripts/vscripts/items/item_bottle.lua

LinkLuaModifier("modifier_item_imba_bottle_heal", "items/item_bottle.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_bottle_texture_controller", "items/item_bottle.lua", LUA_MODIFIER_MOTION_NONE)

item_imba_bottle = class({})


function item_imba_bottle:OnCreated()
	self:SetCurrentCharges(3)
	self.RuneStorage = nil
end

function item_imba_bottle:GetIntrinsicModifierName() return "modifier_item_imba_bottle_texture_controller" end

function item_imba_bottle:SetCurrentCharges(charges)
	return self.BaseClass.SetCurrentCharges(self, charges)
end

function item_imba_bottle:OnSpellStart()
	if self.RuneStorage then
		PickupRune(self.RuneStorage, self:GetCaster(), true)
		if self.RuneStorage == "bounty" and self:GetCurrentCharges() < 3 then
			self:SetCurrentCharges(2)
		else
			self:SetCurrentCharges(3)
		end
		self.RuneStorage = nil
	else
		local charges = self:GetCurrentCharges()
		if charges > 0 then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_bottle_heal", {duration = self:GetSpecialValueFor("restore_time")})
			self:SetCurrentCharges(charges - 1)
			self:GetCaster():EmitSound("Bottle.Drink")
		end
	end
end

function item_imba_bottle:SetStorageRune(type)
	--if self.RuneStorage then return end
	if self:GetCaster().GetPlayerID then
		CustomGameEventManager:Send_ServerToTeam(self:GetCaster():GetTeam(), "create_custom_toast", {
			type = "generic",
			text = "#custom_toast_BottledRune",
			player = self:GetCaster():GetPlayerID(),
			runeType = type
		})
	end
	self.RuneStorage = type
	if self.RuneStorage == "bounty" then
		if self:GetCurrentCharges() < 3 then
			self:SetCurrentCharges(2)
		else
			PickupRune(self.RuneStorage, self:GetCaster(), true)
			self.RuneStorage = nil
			return
		end
	else
		self:SetCurrentCharges(3)
	end

	self:GetCaster():EmitSound("Bottle.Cork")
end

function item_imba_bottle:GetAbilityTextureName()
	local texture = "custom/bottle_3"
	texture = self.texture_name or texture
	return texture
end

modifier_item_imba_bottle_texture_controller = modifier_item_imba_bottle_texture_controller or class({})

function modifier_item_imba_bottle_texture_controller:IsHidden() return true end
function modifier_item_imba_bottle_texture_controller:IsPurgable() return false end
function modifier_item_imba_bottle_texture_controller:IsDebuff() return false end
function modifier_item_imba_bottle_texture_controller:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end


function modifier_item_imba_bottle_texture_controller:OnCreated()
	self:OnIntervalThink()
	self:StartIntervalThink(FrameTime())
end

function modifier_item_imba_bottle_texture_controller:OnIntervalThink()
	local bottle = self:GetAbility()
	local rune_table = {
		"0",--1
		"1",--2
		"2",--3
		"3",--4
		"arcane", --5
		"double_damage", --6
		"haste", --7
		"regeneration", --8
		"illusion", --9
		"invisibility",  --10
		"frost", --11
		"bounty", --12
	}
	if IsServer() then
		if bottle:IsCooldownReady() and self:GetParent():HasModifier("modifier_fountain_aura_buff") or self:GetParent():HasModifier("modifier_fountain_aura_effect_lua") then
			bottle:SetCurrentCharges(3)
		end
		local stack = bottle:GetCurrentCharges() + 1
		for i=5,12 do
			if bottle.RuneStorage == rune_table[i] then
				stack = i
				break
			end
		end
		self:SetStackCount(stack)
	end
	local client_stack = self:GetStackCount()
	if client_stack >= 1 and client_stack <= 4 then
		bottle.texture_name = "custom/bottle_"..rune_table[client_stack]
	else
		bottle.texture_name = "custom/bottle_rune_"..rune_table[client_stack]
	end
end

modifier_item_imba_bottle_heal = class({
	GetTexture =			function() return "custom/bottle_3" end,
	IsPurgable =			function() return false end,
	GetEffectAttachType =	function() return PATTACH_ABSORIGIN_FOLLOW end,
})

function modifier_item_imba_bottle_heal:OnCreated()
	self.health_restore = self:GetAbility():GetSpecialValueFor("health_restore") / self:GetAbility():GetSpecialValueFor("restore_time")
	self.mana_restore = self:GetAbility():GetSpecialValueFor("mana_restore") / self:GetAbility():GetSpecialValueFor("restore_time")
end

function modifier_item_imba_bottle_heal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
end

function modifier_item_imba_bottle_heal:GetModifierConstantHealthRegen()
	return self.health_restore
end

function modifier_item_imba_bottle_heal:GetModifierConstantManaRegen()
	return self.mana_restore
end

function modifier_item_imba_bottle_heal:OnCreated()
	if not IsServer() then return end
	self.pfx = ParticleManager:CreateParticle(self:GetCaster().bottle_effect, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
end

function modifier_item_imba_bottle_heal:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
end
