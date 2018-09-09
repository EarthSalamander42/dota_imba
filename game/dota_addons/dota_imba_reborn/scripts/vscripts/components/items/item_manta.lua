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
-- Author:
-- EarthSalamander #42

LinkLuaModifier( "modifier_item_manta_passive", "components/items/item_manta.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_imba_manta_stacks", "components/items/item_manta.lua", LUA_MODIFIER_MOTION_NONE )		-- Stacking attack speed
LinkLuaModifier( "modifier_manta_invulnerable", "components/items/item_manta.lua", LUA_MODIFIER_MOTION_NONE )

if item_imba_manta == nil then item_imba_manta = class({}) end

function item_imba_manta:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function item_imba_manta:GetAbilityTextureName()
	return "item_manta"
end

function item_imba_manta:GetIntrinsicModifierName()
	return "modifier_item_manta_passive"
end

function item_imba_manta:GetCooldown()
	if self:GetCaster():IsRangedAttacker() then
		return self:GetSpecialValueFor("cooldown_ranged_tooltip")
	else
		return self:GetSpecialValueFor("cooldown_melee")
	end
end

function item_imba_manta:OnSpellStart()
	local caster_entid = self:GetCaster():entindex()
	local duration = self:GetSpecialValueFor("tooltip_illusion_duration")
	local invulnerability_duration = self:GetSpecialValueFor("invuln_duration")
	local images_count = self:GetSpecialValueFor("images_count")
	local cooldown_melee = self:GetSpecialValueFor("cooldown_melee")
	local outgoingDamage = self:GetSpecialValueFor("images_do_damage_percent_ranged")
	local incomingDamage = self:GetSpecialValueFor("images_take_damage_percent_ranged")

	if not self:GetCaster():IsRangedAttacker() then  --Manta Style's cooldown is less for melee heroes.
		--self:EndCooldown()
		--self:StartCooldown(cooldown_melee)
		outgoingDamage = self:GetSpecialValueFor("images_do_damage_percent_melee")
		incomingDamage = self:GetSpecialValueFor("images_take_damage_percent_melee")
	end

	self:GetCaster():Purge(false, true, false, false, false)
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_manta_invulnerable", {duration=invulnerability_duration})

	if not self:GetCaster().manta then
		self:GetCaster().manta = {}
	end

	for k,v in pairs(self:GetCaster().manta) do
		if v and IsValidEntity(v) then
			v:ForceKill(false)
		end
	end

	self:GetCaster():EmitSound("DOTA_Item.Manta.Activate")
	local manta_particle = ParticleManager:CreateParticle("particles/items2_fx/manta_phase.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	Timers:CreateTimer(invulnerability_duration, function()
		FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin() + RandomVector(100), true)

		for i = 1, images_count do
			if string.find(self:GetCaster():GetUnitName(), "npc_dota_lone_druid_bear") then print("NO BEAR") break end
			local illusion = self:GetCaster():CreateIllusion(duration, incomingDamage, outgoingDamage)
			table.insert(self:GetCaster().manta, illusion)
		end

		ParticleManager:DestroyParticle(manta_particle, false)
		ParticleManager:ReleaseParticleIndex(manta_particle)
	end)
end

if modifier_item_manta_passive == nil then modifier_item_manta_passive = class({}) end
function modifier_item_manta_passive:IsPassive() return true end
function modifier_item_manta_passive:IsHidden() return true end
function modifier_item_manta_passive:IsPurgable() return false end

function modifier_item_manta_passive:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return decFuncs
end

function modifier_item_manta_passive:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end

function modifier_item_manta_passive:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_item_manta_passive:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_item_manta_passive:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

function modifier_item_manta_passive:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

-- On attack landed, roll for proc and apply stacks
function modifier_item_manta_passive:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()
		local target = keys.target

		-- If this attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return end

		-- If a higher-priority sword is present, do nothing either
		local priority_sword_modifiers = {
			"modifier_item_imba_sange_yasha",
			"modifier_item_imba_kaya_yasha",
			"modifier_item_imba_triumvirate"
		}
		for _, sword_modifier in pairs(priority_sword_modifiers) do
			if owner:HasModifier(sword_modifier) then
				return nil
			end
		end

		-- All conditions met, perform a manta attack
		MantaAttack(owner, self:GetAbility(), "modifier_item_imba_manta_stacks")
	end
end

function modifier_item_manta_passive:OnDestroy()

end

modifier_manta_invulnerable = class({})

--------------------------------------------------------------------------------

function modifier_manta_invulnerable:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_manta_invulnerable:CheckState()
	local state =
		{
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
		}

	return state
end

-----------------------------------------------------------------------------------------------------------
--	manta attack speed buff (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_manta_stacks == nil then modifier_item_imba_manta_stacks = class({}) end
function modifier_item_imba_manta_stacks:IsHidden() return false end
function modifier_item_imba_manta_stacks:IsDebuff() return false end
function modifier_item_imba_manta_stacks:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_manta_stacks:GetEffectName()
	return "particles/item/swords/yasha_buff.vpcf"
end

function modifier_item_imba_manta_stacks:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Modifier property storage
function modifier_item_imba_manta_stacks:OnCreated()
	self.as_stack = self:GetAbility():GetSpecialValueFor("as_stack")

	-- Remove this if higher tier modifiers are present
	if IsServer() then
		local owner = self:GetParent()
		local higher_tier_modifiers = {
			"modifier_item_imba_sange_yasha_stacks",
			"modifier_item_imba_kaya_yasha_stacks",
			"modifier_item_imba_triumvirate_stacks_buff"
		}
		for _, modifier in pairs(higher_tier_modifiers) do
			if owner:FindModifierByName(modifier) then
				self:Destroy()
			end
		end
	end
end

-- Declare modifier events/properties
function modifier_item_imba_manta_stacks:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_item_imba_manta_stacks:GetModifierAttackSpeedBonus_Constant()
	return self.as_stack * self:GetStackCount()
end


function MantaAttack(attacker, ability, modifier_stacks)
	-- Stack the attack speed buff up
	local modifier_as = attacker:AddNewModifier(attacker, ability, modifier_stacks, {duration = ability:GetSpecialValueFor("stack_duration")})
	if modifier_as and modifier_as:GetStackCount() < ability:GetSpecialValueFor("max_stacks") then
		modifier_as:SetStackCount(modifier_as:GetStackCount() + 1)
		attacker:EmitSound("Imba.YashaStack")
	end

	-- If this is an illusion, do nothing else
	if attacker:IsIllusion() then
		return
	end
end
