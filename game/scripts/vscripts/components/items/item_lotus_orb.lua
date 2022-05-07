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

-- Author: EarthSalamander
-- Date: 19/08/2020


----------------------------------
--          LOTUS ORB           --
----------------------------------

item_imba_lotus_orb = item_imba_lotus_orb or class({})

LinkLuaModifier("modifier_item_imba_lotus_orb_passive", "components/items/item_lotus_orb.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_lotus_orb_active", "components/items/item_lotus_orb.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_lotus_orb:GetIntrinsicModifierName()
	return "modifier_item_imba_lotus_orb_passive"
end

function item_imba_lotus_orb:OnSpellStart()
	if not IsServer() then return end

	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_lotus_orb_active", {duration = self:GetSpecialValueFor("active_duration"), dispel = true})
end

modifier_item_imba_lotus_orb_passive = modifier_item_imba_lotus_orb_passive or class({})

function modifier_item_imba_lotus_orb_passive:IsHidden()		return true end
function modifier_item_imba_lotus_orb_passive:IsPurgable()		return false end
function modifier_item_imba_lotus_orb_passive:RemoveOnDeath()	return false end
function modifier_item_imba_lotus_orb_passive:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_lotus_orb_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_imba_lotus_orb_passive:OnCreated()
	if not IsServer() then return end

	self:GetParent().tOldSpells = {}

	self:StartIntervalThink(FrameTime())
end

-- Deleting old abilities
-- This is bound to the passive modifier, so this is constantly on!
function modifier_item_imba_lotus_orb_passive:OnIntervalThink()
	for i = #self:GetParent().tOldSpells, 1, -1 do
		local hSpell = self:GetParent().tOldSpells[i]

		if hSpell:NumModifiersUsingAbility() == 0 and not hSpell:IsChanneling() then
			hSpell:RemoveSelf()
			table.remove(self:GetParent().tOldSpells,i)
		end
	end
end

function modifier_item_imba_lotus_orb_passive:GetModifierConstantHealthRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	end
end

function modifier_item_imba_lotus_orb_passive:GetModifierManaBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_mana")
	end
end

function modifier_item_imba_lotus_orb_passive:GetModifierConstantManaRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	end
end

function modifier_item_imba_lotus_orb_passive:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_armor")
	end
end

-- Reflect modifier
-- Biggest thanks to Yunten !
modifier_item_imba_lotus_orb_active = modifier_item_imba_lotus_orb_active or class({})

function modifier_item_imba_lotus_orb_active:IsPurgable() return false end
function modifier_item_imba_lotus_orb_active:IsPurgeException() return false end

function modifier_item_imba_lotus_orb_active:DeclareFunctions() return {
	MODIFIER_PROPERTY_ABSORB_SPELL,
	MODIFIER_PROPERTY_REFLECT_SPELL,
} end

function modifier_item_imba_lotus_orb_active:OnCreated(params)
	if not IsServer() then return end

	local shield_pfx = "particles/items3_fx/lotus_orb_shield.vpcf"
	self.reflect_pfx = "particles/items3_fx/lotus_orb_reflect.vpcf"
	local cast_sound = "Item.LotusOrb.Target"
	self.reflect_sound = ""

	if params.shield_pfx then shield_pfx = params.shield_pfx end
	if params.cast_sound then cast_sound = params.cast_sound end
	if params.reflect_pfx then self.reflect_pfx = params.reflect_pfx end
	if params.absorb then self.absorb = params.absorb end
	if params.dispel then self.dispel = params.dispel end

	if params.dispel then
		self:GetParent():Purge(false, true, false, false, false)
	end

	self.pfx = ParticleManager:CreateParticle(shield_pfx, PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

	-- Random numbers
--	ParticleManager:SetParticleControl(self.particle, 1, Vector(150, 150, 150))

	self:GetCaster():EmitSound(cast_sound)
end

function modifier_item_imba_lotus_orb_active:GetAbsorbSpell(params)
	if self:GetAbility():GetAbilityName() == "item_imba_lotus_orb" then
		return nil
	end

	if params.ability then
		print("Ability absorbed:", params.ability:GetAbilityName())
	end

	if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return nil
	end

	if not self.absorb then return 0 end

	self:GetCaster():EmitSound("Item.LotusOrb.Activate")

	if self:GetParent():HasAbility("imba_antimage_spell_shield") then
		-- IMBAfication: Trading Places
		if self:GetAbility() and self:GetAbility():GetAutoCastState() and params.ability:GetCaster() and params.ability:GetCaster():IsAlive() then
			local modifier_holder_position	= self:GetParent():GetAbsOrigin()
			local caster_position			= params.ability:GetCaster():GetAbsOrigin()
		
			FindClearSpaceForUnit(self:GetParent(), caster_position, true)
			FindClearSpaceForUnit(params.ability:GetCaster(), modifier_holder_position, true)
		
			local blink_1 = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", PATTACH_ABSORIGIN, self:GetParent())
			ParticleManager:ReleaseParticleIndex(blink_1)
			self:GetParent():EmitSound("Hero_Antimage.Blink_out")

			local blink_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", PATTACH_ABSORIGIN, params.ability:GetCaster())
			ParticleManager:ReleaseParticleIndex(blink_2)
			params.ability:GetCaster():EmitSound("Hero_Antimage.Blink_out")

			params.ability:GetCaster():EmitSound("Hero_Antimage.Counterspell.Target")
		end
	end
	
	return 1
end

function modifier_item_imba_lotus_orb_active:GetReflectSpell(params)
	-- If some spells shouldn't be reflected, enter it into this spell-list
	local exception_spell = {
		["rubick_spell_steal"] = true,
		["imba_alchemist_greevils_greed"] = true,
		["imba_alchemist_unstable_concoction"] = true,
		["imba_disruptor_glimpse"] = true,
		["legion_commander_duel"] = true,
		["imba_phantom_assassin_phantom_strike"] = true,
		["phantom_assassin_phantom_strike"] = true,
		["imba_riki_blink_strike"] = true,
		["riki_blink_strike"] = true,
		["imba_rubick_spellsteal"] = true,
		["morphling_replicate"]	= true
	}

	local reflected_spell_name = params.ability:GetAbilityName()
	local target = params.ability:GetCaster()

	-- Does not reflect allies' projectiles for any reason
	if target:GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return nil
	end

	if ( not exception_spell[reflected_spell_name] ) and (not target:HasModifier("modifier_imba_spell_shield_buff_reflect")) then
		-- If this is a reflected ability, do nothing
		if params.ability.spell_shield_reflect then
			return nil
		end

		local pfx = ParticleManager:CreateParticle(self.reflect_pfx, PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)

--		local reflect_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, parent)
--		ParticleManager:SetParticleControlEnt(reflect_pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetOrigin(), true)
--		ParticleManager:ReleaseParticleIndex(reflect_pfx)

		local old_spell = false

		for _,hSpell in pairs(self:GetParent().tOldSpells) do
			if hSpell ~= nil and hSpell:GetAbilityName() == reflected_spell_name then
				old_spell = true
				break
			end
		end

		if old_spell then
			ability = self:GetParent():FindAbilityByName(reflected_spell_name)
		else
			ability = self:GetParent():AddAbility(reflected_spell_name)
			ability:SetStolen(true)
			ability:SetHidden(true)

			-- Tag ability as a reflection ability
			ability.spell_shield_reflect = true

			-- Modifier counter, and add it into the old-spell list
			ability:SetRefCountsModifiers(true)
			table.insert(self:GetParent().tOldSpells, ability)
		end

		ability:SetLevel(params.ability:GetLevel())
		-- Set target & fire spell
		self:GetParent():SetCursorCastTarget(target)

		if ability:GetToggleState() then
			ability:ToggleAbility()
		end

		ability:OnSpellStart()
		
		-- This isn't considered vanilla behavior, but at minimum it should resolve any lingering channeled abilities...
		if ability.OnChannelFinish then
			ability:OnChannelFinish(false)
		end	
	end

	return false
end

function modifier_item_imba_lotus_orb_active:OnRemoved()
	if not IsServer() then return end

	self:GetCaster():EmitSound("Item.LotusOrb.Destroy")

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end
