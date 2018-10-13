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

--[[
		
		This is old datadriven script.

		Author: Hewdraw
		Date: 17.05.2015	

function MoonShardActive( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sound_consume = keys.sound_consume
	local modifier_consume_1 = keys.modifier_consume_1
	local modifier_consume_2 = keys.modifier_consume_2
	local modifier_consume_3 = keys.modifier_consume_3
	local modifier_stacks = keys.modifier_stacks

	-- If this unit is not a real hero, do nothing
	if string.find(target:GetUnitName(), "lone_druid") then
		print("BEAR!")
	end
--	if ( not target:IsRealHero() or not string.find(target:GetUnitName(), "lone_druid") ) or target:HasModifier("modifier_arc_warden_tempest_double") then
	if ( not target:IsRealHero() ) or target:HasModifier("modifier_arc_warden_tempest_double") then
		print(target:GetUnitName())
		print("NIL unit")
		return nil
	end

	-- Decide the proper modifier to apply based on the target's stack amount
	local current_stacks = target:GetModifierStackCount(modifier_stacks, nil)
	if current_stacks <= 0 then
		ability:ApplyDataDrivenModifier(caster, target, modifier_consume_1, {})
	elseif current_stacks == 1 then
		ability:ApplyDataDrivenModifier(caster, target, modifier_consume_2, {})
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier_consume_3, {})
	end

	-- Add a stack of the dummy modifier
	AddStacks(ability, caster, target, modifier_stacks, 1, true)
	
	-- Play cast sound locally for the caster and the target
	if caster:IsRealHero() then
		local caster_id = caster:GetPlayerID()
		if caster_id then
			EmitSoundOnClient(sound_consume, PlayerResource:GetPlayer(caster_id))
		end
--	elseif caster:IsConsideredHero() then
--		if string.find(target:GetUnitName(), "lone_druid") then
--			print("Play sound based on bear")
--			local caster_id = caster:GetPlayerOwnerID()
--			if caster_id then
--				EmitSoundOnClient(sound_consume, PlayerResource:GetPlayer(caster_id))
--			end
--		end
	end
	local target_id = target:GetPlayerID()
	if target_id then
		EmitSoundOnClient(sound_consume, PlayerResource:GetPlayer(target_id))
	end

	-- Destroy the moon shard
	caster:RemoveItem(ability)
end

]]

--[[

		Author: MouJiaoZi
		Date: 2017.11.29
				Y   M  D

]]

item_imba_moon_shard = item_imba_moon_shard or class({})

LinkLuaModifier("modifier_item_imba_moon_shard", "components/items/item_moon_shard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_moon_shard_active", "components/items/item_moon_shard", LUA_MODIFIER_MOTION_NONE)

CDOTAIMBA_ITEM_MOON_SHARD_AS_1 = 70
CDOTAIMBA_ITEM_MOON_SHARD_AS_2 = 50
CDOTAIMBA_ITEM_MOON_SHARD_AS_3 = 30
CDOTAIMBA_ITEM_MOON_SHARD_NV_1 = 250
CDOTAIMBA_ITEM_MOON_SHARD_NV_2 = 150

function item_imba_moon_shard:GetIntrinsicModifierName() return "modifier_item_imba_moon_shard" end

function item_imba_moon_shard:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	if caster:IsTempestDouble() then return end
	local pos = caster:GetAbsOrigin()
	local target = self:GetCursorTarget()
	local current_stacks = self:GetCurrentCharges()
	if target then
		if target:IsTempestDouble() then
			target = nil
		end
		if target == caster then
			EmitSoundOnClient("Item.MoonShard.Consume", caster:GetPlayerOwner())
			local moon_buff = caster:FindModifierByName("modifier_item_imba_moon_shard_active")
			if moon_buff then
				moon_buff:SetStackCount(moon_buff:GetStackCount() + current_stacks)
			else
				moon_buff = caster:AddNewModifier(caster, self, "modifier_item_imba_moon_shard_active", {})
				moon_buff:SetStackCount(current_stacks)
			end
			caster:RemoveItem(self)
		else
			EmitSoundOnClient("Item.MoonShard.Consume", caster:GetPlayerOwner())
			EmitSoundOnClient("Item.MoonShard.Consume", target:GetPlayerOwner())
			local moon_buff = target:FindModifierByName("modifier_item_imba_moon_shard_active")
			if moon_buff then
				moon_buff:SetStackCount(moon_buff:GetStackCount() + 1)
			else
				moon_buff = target:AddNewModifier(caster, self, "modifier_item_imba_moon_shard_active", {})
				moon_buff:SetStackCount(1)
			end
			if current_stacks > 1 then
				self:SetCurrentCharges(current_stacks-1)
			else
				caster:RemoveItem(self)
			end
		end
	else
		EmitSoundOn("Item.DropWorld", caster)
		local moon = CreateItem("item_imba_moon_shard", caster, caster)
		CreateItemOnPositionSync(pos, moon)
		moon:SetPurchaser(caster)
		moon:SetPurchaseTime(self:GetPurchaseTime())
		if current_stacks > 1 then
			self:SetCurrentCharges(current_stacks-1)
		else
			caster:RemoveItem(self)
		end
	end

end


---------------------------------------
--     STATS MODIFIER (STACKABLE)    --
---------------------------------------
modifier_item_imba_moon_shard = modifier_item_imba_moon_shard or class({})

function modifier_item_imba_moon_shard:IsHidden() return true end
function modifier_item_imba_moon_shard:IsDebuff() return false end
function modifier_item_imba_moon_shard:IsPurgable() return false end
function modifier_item_imba_moon_shard:RemoveOnDeath() return false end

function modifier_item_imba_moon_shard:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(0.2)
end

function modifier_item_imba_moon_shard:OnIntervalThink()
	if not IsServer() then return end
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local stack = ability:GetCurrentCharges()
	local empty_slot = 0
	for i=0,5 do
		local item = caster:GetItemInSlot(i)
		if not item or item:GetAbilityName() == ability:GetAbilityName() then
			empty_slot = empty_slot + 1
		end
	end
	if empty_slot < stack then
		stack = empty_slot
	end
	
	self:SetStackCount(stack)
end

function modifier_item_imba_moon_shard:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION}
	return decFuncs
end

function modifier_item_imba_moon_shard:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_imba_moon_shard:GetBonusNightVision()
	return self:GetAbility():GetSpecialValueFor("bonus_night_vision")
end


---------------------------------------
--     ACTIVE MODIFIER               --
---------------------------------------

modifier_item_imba_moon_shard_active = modifier_item_imba_moon_shard_active or class({})

function modifier_item_imba_moon_shard_active:IsHidden() return false end
function modifier_item_imba_moon_shard_active:IsDebuff() return false end
function modifier_item_imba_moon_shard_active:IsPurgable() return false end
function modifier_item_imba_moon_shard_active:RemoveOnDeath() return false end
function modifier_item_imba_moon_shard_active:GetTexture() return "item_moon_shard" end


function modifier_item_imba_moon_shard_active:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION}
	return decFuncs
end

function modifier_item_imba_moon_shard_active:GetModifierAttackSpeedBonus_Constant()
	local first_as = CDOTAIMBA_ITEM_MOON_SHARD_AS_1
	local second_as = CDOTAIMBA_ITEM_MOON_SHARD_AS_2
	local third_as = CDOTAIMBA_ITEM_MOON_SHARD_AS_3
	local stack = self:GetStackCount()
	if stack == 1 then
		return first_as
	elseif stack == 2 then
		return (first_as + second_as)
	else
		return (first_as + second_as + (stack - 2) * third_as)
	end
end

function modifier_item_imba_moon_shard_active:GetBonusNightVision()
	local first_nv = CDOTAIMBA_ITEM_MOON_SHARD_NV_1
	local second_nv = CDOTAIMBA_ITEM_MOON_SHARD_NV_2
	local stack = self:GetStackCount()
	if stack == 1 then
		return first_nv
	else
		return (first_nv + second_nv)
	end
end
