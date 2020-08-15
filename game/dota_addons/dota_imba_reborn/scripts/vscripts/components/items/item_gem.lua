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
-- Date: 15/08/2020


---------------------------------
--      GEM OF TRUESIGHT       --
---------------------------------

item_imba_gem = item_imba_gem or class({})

LinkLuaModifier("modifier_item_imba_gem_of_true_sight", "components/items/item_gem.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_gem_of_true_sight_dropped", "components/items/item_gem.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_gem:GetIntrinsicModifierName()
	return "modifier_item_imba_gem_of_true_sight"
end

function item_imba_gem:OnItemEquipped(hItem)
	if hItem == self then
		if self.dummy_unit and self.dummy_unit:HasModifier("modifier_item_imba_gem_of_true_sight_dropped") then
			self.dummy_unit:RemoveModifierByName("modifier_item_imba_gem_of_true_sight_dropped")
		end
	end
end

modifier_item_imba_gem_of_true_sight = modifier_item_imba_gem_of_true_sight or class({})

function modifier_item_imba_gem_of_true_sight:IsHidden() return true end
function modifier_item_imba_gem_of_true_sight:IsPurgable() return false end
function modifier_item_imba_gem_of_true_sight:IsPurgeException() return false end

function modifier_item_imba_gem_of_true_sight:IsAura() return true end
function modifier_item_imba_gem_of_true_sight:GetAuraRadius() return self.radius end
function modifier_item_imba_gem_of_true_sight:GetModifierAura() return "modifier_truesight" end
function modifier_item_imba_gem_of_true_sight:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_imba_gem_of_true_sight:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_item_imba_gem_of_true_sight:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER end
function modifier_item_imba_gem_of_true_sight:GetAuraDuration() return 0.5 end

function modifier_item_imba_gem_of_true_sight:OnCreated(params)
	if not IsServer() then return end

	-- disabled on Couriers and Lone Druid's Bear
	if self:GetParent():IsCourier() or (self:GetParent():IsConsideredHero() and not self:GetParent():IsRealHero()) then
		self:GetParent():RemoveModifierByName("modifier_item_imba_gem_of_true_sight")

		return
	end

	if params.radius then
		self.radius = params.radius
	else
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
	end
end

function modifier_item_imba_gem_of_true_sight:OnRemoved()
	if not IsServer() then return end

	-- Non-heroes should automatically drop rapier and return so they can't crash script at self:GetParent():IsImbaReincarnating() check
	if not self:GetParent():IsRealHero() then
		local item = self:GetParent():DropItem(self:GetAbility(), true)
		self:GetAbility().dummy_unit = CreateUnitByName("npc_dummy_unit_perma", item:GetAbsOrigin(), true, nil, nil, self:GetCaster():GetTeam())
		self:GetAbility().dummy_unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_gem_of_true_sight_dropped", {})

		return
	end

	if not self:GetParent():IsImbaReincarnating() then
		local item = self:GetParent():DropItem(self:GetAbility(), true)
		self:GetAbility().dummy_unit = CreateUnitByName("npc_dummy_unit_perma", item:GetAbsOrigin(), true, nil, nil, self:GetCaster():GetTeam())
		self:GetAbility().dummy_unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_gem_of_true_sight_dropped", {})
	end
end

modifier_item_imba_gem_of_true_sight_dropped = modifier_item_imba_gem_of_true_sight_dropped or class({})

function modifier_item_imba_gem_of_true_sight_dropped:OnCreated()
	if not IsServer() then return end

	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_gem_of_true_sight", {radius = self:GetAbility():GetSpecialValueFor("dropped_radius")})
	self:StartIntervalThink(FrameTime())
end

-- fail-safe to remove ground vision when combining soul of truth
function modifier_item_imba_gem_of_true_sight_dropped:OnIntervalThink()
	if not self:GetParent() or not self:GetAbility() then
		self:StartIntervalThink(-1)

		if self:GetParent() then
			self:GetParent():RemoveModifierByName("modifier_item_imba_gem_of_true_sight_dropped")
		end

		return
	else
		-- delay particle creation so it doesn't create if combining to soul of truth...
		if not self.pfx then
			self.pfx = ParticleManager:CreateParticleForTeam("particles/items_fx/gem_truesight_aura.vpcf", PATTACH_WORLDORIGIN, self:GetParent(), self:GetParent():GetTeam())
			ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.radius, 0, 0))
		end
	end
end


function modifier_item_imba_gem_of_true_sight_dropped:OnRemoved()
	if not IsServer() then return end

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end

	if self:GetParent() then
		UTIL_Remove(self:GetParent())
	end
end
