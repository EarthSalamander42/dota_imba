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

item_imba_black_queen_cape = item_imba_black_queen_cape or class({})
LinkLuaModifier( "modifier_imba_black_queen_cape_passive", "components/items/item_black_queen_cape.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_black_queen_cape_active_heal", "components/items/item_black_queen_cape.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_black_queen_cape_active_bkb", "components/items/item_black_queen_cape.lua", LUA_MODIFIER_MOTION_NONE )

------------------------------------------------------------
-- Black Queen Cape item
------------------------------------------------------------
function item_imba_black_queen_cape:GetIntrinsicModifierName()
	return "modifier_imba_black_queen_cape_passive"
end

function item_imba_black_queen_cape:GetAbilityTextureName()
	return "custom/imba_black_queen_cape"
end

function item_imba_black_queen_cape:OnSpellStart()
	if not IsServer() then
		return nil
	end
	-- Particles + modifiers--
	local urn_particle = "particles/items2_fx/urn_of_shadows.vpcf"
	local bkb_modifier = "modifier_imba_black_queen_cape_active_bkb"
	local heal_modifier = "modifier_imba_black_queen_cape_active_heal"
	---------------
	local heal = self:GetSpecialValueFor("heal")
	local heal_duration = self:GetSpecialValueFor("heal_duration")
	local bkb_duration = self:GetSpecialValueFor("bkb_duration")

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	EmitSoundOn("DOTA_Item.BlackKingBar.Activate", target)

	local particle_fx = ParticleManager:CreateParticle(urn_particle, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_fx, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_fx)

	target:AddNewModifier(caster, self, bkb_modifier, {duration = bkb_duration})
	target:Purge(false, true, false, false, false)

	if self:GetCurrentCharges() > 0 then
		EmitSoundOn("DOTA_Item.UrnOfShadows.Activate", target)
		target:AddNewModifier(caster, self, heal_modifier, {duration = heal_duration, heal = heal, bkb_modifier = bkb_modifier})
		self:SetCurrentCharges(self:GetCurrentCharges() - 1)
	end
end

------------------------------------------------------------
-- Black Queen Cape stats + soul steal modifier
------------------------------------------------------------
modifier_imba_black_queen_cape_passive = modifier_imba_black_queen_cape_passive or class({})
function modifier_imba_black_queen_cape_passive:IsDebuff() return false end
function modifier_imba_black_queen_cape_passive:IsHidden() return true end
function modifier_imba_black_queen_cape_passive:IsPermanent() return true end
function modifier_imba_black_queen_cape_passive:IsPurgable() return false end
function modifier_imba_black_queen_cape_passive:IsPurgeException() return false end
function modifier_imba_black_queen_cape_passive:IsStunDebuff() return false end
function modifier_imba_black_queen_cape_passive:RemoveOnDeath() return false end
function modifier_imba_black_queen_cape_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_black_queen_cape_passive:OnCreated()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	self.soultrap_range = self.item:GetSpecialValueFor("soultrap_range")
	self.bonus_armor = self.item:GetSpecialValueFor("bonus_armor")
	self.bonus_damage = self.item:GetSpecialValueFor("bonus_damage")
	self.bonus_mana_regen = self.item:GetSpecialValueFor("bonus_mana_regen")
	self.bonus_health_regen = self.item:GetSpecialValueFor("bonus_health_regen")
	self.bonus_agility = self.item:GetSpecialValueFor("bonus_agility")
	self.bonus_strength = self.item:GetSpecialValueFor("bonus_strength")
	self.bonus_intelligence = self.item:GetSpecialValueFor("bonus_intelligence")
end

function modifier_imba_black_queen_cape_passive:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_EVENT_ON_HERO_KILLED
		}
	return decFuns
end

function modifier_imba_black_queen_cape_passive:OnHeroKilled( params )
	if not IsServer() then
		return nil
	end

	local target = params.target
	local cape_item_name = "item_imba_black_queen_cape"

	-- Don't gain charges off of illusions
	if not target:IsRealHero() then
		return nil
	end
	-- If we ourselves are an illusion, don't gain charges
	if self.parent:IsIllusion() then
		return nil
	end
	-- Stolen BQC
	if ( self.parent ~= self.item:GetPurchaser() ) then
		return nil
	end
	-- Same team
	if self.parent:GetTeamNumber() == target:GetTeamNumber() then
		return nil
	end
	-- Out of range
	if (self.parent:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > self.soultrap_range then
		return nil
	end
	-- Only other friendly heroes
	local team_filter = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local type_filter = DOTA_UNIT_TARGET_HERO
	local flag_filter = DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS

	local allies_in_vicinity = FindUnitsInRadius(self.parent:GetTeamNumber(), target:GetAbsOrigin(), nil, self.soultrap_range, team_filter, type_filter, flag_filter, FIND_CLOSEST, false)
	local our_distance = (self.parent:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()

	-- if we're the only ones around, don't even need to check the inventories of others
	if #allies_in_vicinity > 1 then
		for _, ally in pairs(allies_in_vicinity) do
			if ally ~= self.parent then
				for i = 0, 5 do
					local item = ally:GetItemInSlot(i)
					if item then
						-- if we find a BQC that's closer than us (that actually belongs to the cheeky bastard), stop searching
						if ( item:GetName() == cape_item_name ) and ( item:GetPurchaser() == ally ) then
							if (ally:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() < our_distance then
								return nil
							end
						end
					end
				end
			end
		end
	end
	-- if we made it this far, the charge is ours
	for i = 0, 5 do
		local item = self.parent:GetItemInSlot(i)
		-- Find the first black queen cape and give it charges, allows to "abuse" multiple empty ones by switching their position
		-- in inventory around. This is consistent with Urn of Shadows mechanics.
		if item then
			if item:GetName() == cape_item_name then
				-- We have multiple BQC, don't do anything (or else we'll add as many charges as we have BQCs)
				-- This is much less useful for BQC due to the high cooldown, but still, let's not let them abuse this
				if item ~= self.item then
					return nil
				end
				local gained_charges = 1
				local current_charges = item:GetCurrentCharges()
				if current_charges == 0 then
					gained_charges = 2
				end
				item:SetCurrentCharges(current_charges + gained_charges)
				break
			end
		end
	end
end

function modifier_imba_black_queen_cape_passive:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_black_queen_cape_passive:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_imba_black_queen_cape_passive:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_imba_black_queen_cape_passive:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_imba_black_queen_cape_passive:GetModifierBonusStats_Intellect()
	return self.bonus_intelligence
end

function modifier_imba_black_queen_cape_passive:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_imba_black_queen_cape_passive:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

------------------------------------------------------------
-- Black Queen Cape active heal modifier
------------------------------------------------------------
modifier_imba_black_queen_cape_active_heal = modifier_imba_black_queen_cape_active_heal or class({})

function modifier_imba_black_queen_cape_active_heal:IsDebuff() return false end
function modifier_imba_black_queen_cape_active_heal:IsHidden() return false end
function modifier_imba_black_queen_cape_active_heal:IsPurgable() return true end
function modifier_imba_black_queen_cape_active_heal:IsStunDebuff() return false end
function modifier_imba_black_queen_cape_active_heal:RemoveOnDeath() return true end

function modifier_imba_black_queen_cape_active_heal:OnCreated( params )
	if IsServer() then
		self.health_regen = params.heal / params.duration
		self.bkb_modifier = params.bkb_modifier
	end
end

function modifier_imba_black_queen_cape_active_heal:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_EVENT_ON_TAKEDAMAGE
		}
	return decFuns
end

function modifier_imba_black_queen_cape_active_heal:GetEffectName()
	return "particles/items2_fx/urn_of_shadows_heal.vpcf"
end

function modifier_imba_black_queen_cape_active_heal:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_black_queen_cape_active_heal:GetModifierConstantHealthRegen()
	return self.health_regen
end

function modifier_imba_black_queen_cape_active_heal:OnTakeDamage( params )
	if not IsServer() then
		return nil
	end
	if ( params.unit ~= self:GetParent() ) or ( not params.attacker:IsHero() ) then
		return nil
	end
	-- don't dispell on damage if we have black queen cape's BKB modifier
	if self:GetParent():HasModifier(self.bkb_modifier) then
		return nil
	end
	if params.damage > 0 then
		self:Destroy()
	end
end

------------------------------------------------------------
-- Black Queen Cape active bkb modifier
------------------------------------------------------------
modifier_imba_black_queen_cape_active_bkb = modifier_imba_black_queen_cape_active_bkb or class({})

function modifier_imba_black_queen_cape_active_bkb:IsDebuff() return false end
function modifier_imba_black_queen_cape_active_bkb:IsHidden() return false end
function modifier_imba_black_queen_cape_active_bkb:IsPurgable() return false end
function modifier_imba_black_queen_cape_active_bkb:IsStunDebuff() return false end
function modifier_imba_black_queen_cape_active_bkb:IsPurgeException() return false end
function modifier_imba_black_queen_cape_active_bkb:RemoveOnDeath() return true end

-- Declare modifier states
function modifier_imba_black_queen_cape_active_bkb:CheckState()
	local states = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
	return states
end

function modifier_imba_black_queen_cape_active_bkb:GetEffectName()
	return "particles/item/black_queen_cape/black_king_bar_avatar.vpcf"
end

function modifier_imba_black_queen_cape_active_bkb:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
