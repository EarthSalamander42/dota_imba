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

item_imba_urn_of_shadows = item_imba_urn_of_shadows or class({})
LinkLuaModifier( "modifier_imba_urn_of_shadows_passive", "components/items/item_urn_of_shadows.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_urn_of_shadows_active_ally", "components/items/item_urn_of_shadows.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_urn_of_shadows_active_enemy", "components/items/item_urn_of_shadows.lua", LUA_MODIFIER_MOTION_NONE )

------------------------------------------------------------
-- Urn of Shadows item
------------------------------------------------------------
function item_imba_urn_of_shadows:GetIntrinsicModifierName()
	return "modifier_imba_urn_of_shadows_passive"
end

function item_imba_urn_of_shadows:GetAbilityTextureName()
	return "item_urn_of_shadows"
end

function item_imba_urn_of_shadows:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		if caster:GetTeam() ~= target:GetTeam() and target:IsMagicImmune() then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end
		return UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
	end
end

function item_imba_urn_of_shadows:OnSpellStart()
	if not IsServer() then
		return nil
	end
	-- Particles + Modifier names--
	local urn_particle = "particles/items2_fx/urn_of_shadows.vpcf"
	local heal_modifier = "modifier_imba_urn_of_shadows_active_ally"
	local damage_modifier = "modifier_imba_urn_of_shadows_active_enemy"
	--------------
	local damage = self:GetSpecialValueFor("damage")
	local heal = self:GetSpecialValueFor("heal")
	local duration = self:GetSpecialValueFor("duration")

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(self) then
			return
		end
	end

	EmitSoundOn("DOTA_Item.UrnOfShadows.Activate", target)

	-- Create and release particle
	local particle_fx = ParticleManager:CreateParticle(urn_particle, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_fx, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_fx)

	if target:GetTeam() == caster:GetTeam() then
		target:AddNewModifier(caster, self, heal_modifier, {duration = duration, heal = heal})
	else
		target:AddNewModifier(caster, self, damage_modifier, {duration = duration, damage = damage})
	end

	self:SetCurrentCharges(self:GetCurrentCharges() - 1)
end

------------------------------------------------------------
-- Urn of Shadows stats + soul steal modifier
------------------------------------------------------------
modifier_imba_urn_of_shadows_passive = modifier_imba_urn_of_shadows_passive or class({})
function modifier_imba_urn_of_shadows_passive:IsDebuff() return false end
function modifier_imba_urn_of_shadows_passive:IsHidden() return true end
function modifier_imba_urn_of_shadows_passive:IsPermanent() return true end
function modifier_imba_urn_of_shadows_passive:IsPurgable() return false end
function modifier_imba_urn_of_shadows_passive:IsPurgeException() return false end
function modifier_imba_urn_of_shadows_passive:IsStunDebuff() return false end
function modifier_imba_urn_of_shadows_passive:RemoveOnDeath() return false end
function modifier_imba_urn_of_shadows_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_urn_of_shadows_passive:OnCreated()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	self.soultrap_range = self.item:GetSpecialValueFor("soultrap_range")
	self.bonus_armor = self.item:GetSpecialValueFor("bonus_armor")
	self.bonus_mana_regen = self.item:GetSpecialValueFor("bonus_mana_regen")
	self.bonus_agility = self.item:GetSpecialValueFor("bonus_agility")
	self.bonus_strength = self.item:GetSpecialValueFor("bonus_strength")
	self.bonus_intelligence = self.item:GetSpecialValueFor("bonus_intelligence")
end

function modifier_imba_urn_of_shadows_passive:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_EVENT_ON_HERO_KILLED
		}
	return decFuns
end

function modifier_imba_urn_of_shadows_passive:OnHeroKilled( params )
	if not IsServer() then
		return nil
	end

	local target = params.target
	local black_queen_cape_modifier = "modifier_imba_black_queen_cape_passive"
	local urn_item_name = "item_imba_urn_of_shadows"
	local cape_item_name = "item_imba_black_queen_cape"

	-- Don't gain charges off of illusions
	if not target:IsRealHero() then
		return nil
	end
	-- If we ourselves are an illusion, don't gain charges
	if self.parent:IsIllusion() then
		return nil
	end
	-- Stolen Urn
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
	-- If we have BQC, it has priority on charge gaining
	if self.parent:HasModifier(black_queen_cape_modifier) then
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
					-- if we find a BQC, end immediately, it gets the charges, regardless of ally's distance
					-- if Urn found, check if the ally in question is closer than we are and that the Urn actually belongs to the cheeky bastard
					if item then
						if ( item:GetName() == urn_item_name ) and ( item:GetPurchaser() == ally ) then
							if (ally:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() < our_distance then
								return nil
							end
						elseif ( item:GetName() == cape_item_name ) and ( item:GetPurchaser() == ally ) then
							return nil
						end
					end
				end
			end
		end
	end

	-- if we made it this far, the charge is ours
	for i = 0, 5 do
		local item = self.parent:GetItemInSlot(i)
		-- Find the first urn and give it charges, allows to "abuse" multiple empty urns by switching their position
		-- in inventory around. This is consistent with Vanilla Dota 2 mechanics.
		if item then
			if item:GetName() == urn_item_name then
				-- We have multiple urns and the urn found isn't us, don't do anything (or else the urn would add additional charges)
				-- Hilarious and IMBA as it might be, probably don't want to do that
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

function modifier_imba_urn_of_shadows_passive:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_imba_urn_of_shadows_passive:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_imba_urn_of_shadows_passive:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_imba_urn_of_shadows_passive:GetModifierBonusStats_Intellect()
	return self.bonus_intelligence
end

function modifier_imba_urn_of_shadows_passive:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

------------------------------------------------------------
-- Urn of Shadows active heal modifier
------------------------------------------------------------
modifier_imba_urn_of_shadows_active_ally = modifier_imba_urn_of_shadows_active_ally or class({})

function modifier_imba_urn_of_shadows_active_ally:IsDebuff() return false end
function modifier_imba_urn_of_shadows_active_ally:IsHidden() return false end
function modifier_imba_urn_of_shadows_active_ally:IsPurgable() return true end
function modifier_imba_urn_of_shadows_active_ally:IsStunDebuff() return false end
function modifier_imba_urn_of_shadows_active_ally:RemoveOnDeath() return true end

function modifier_imba_urn_of_shadows_active_ally:OnCreated( params )
	if IsServer() then
		self.health_regen = params.heal / params.duration
	end
end

function modifier_imba_urn_of_shadows_active_ally:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_EVENT_ON_TAKEDAMAGE
		}
	return decFuns
end

function modifier_imba_urn_of_shadows_active_ally:GetEffectName()
	return "particles/items2_fx/urn_of_shadows_heal.vpcf"
end

function modifier_imba_urn_of_shadows_active_ally:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_urn_of_shadows_active_ally:GetTexture()
	return "item_urn_of_shadows"
end

function modifier_imba_urn_of_shadows_active_ally:GetModifierConstantHealthRegen()
	return self.health_regen
end

function modifier_imba_urn_of_shadows_active_ally:OnTakeDamage( params )
	if not IsServer() then
		return nil
	end
	if ( params.unit ~= self:GetParent() ) or ( not params.attacker:IsHero() ) then
		return nil
	end
	if params.damage > 0 then
		self:Destroy()
	end
end

------------------------------------------------------------
-- Urn of Shadows active damage  modifier
------------------------------------------------------------
modifier_imba_urn_of_shadows_active_enemy = modifier_imba_urn_of_shadows_active_enemy or class({})

function modifier_imba_urn_of_shadows_active_enemy:IsDebuff() return true end
function modifier_imba_urn_of_shadows_active_enemy:IsHidden() return false end
function modifier_imba_urn_of_shadows_active_enemy:IsPurgable() return true end
function modifier_imba_urn_of_shadows_active_enemy:IsStunDebuff() return false end
function modifier_imba_urn_of_shadows_active_enemy:RemoveOnDeath() return true end

function modifier_imba_urn_of_shadows_active_enemy:GetEffectName()
	return "particles/items2_fx/urn_of_shadows_damage.vpcf"
end

function modifier_imba_urn_of_shadows_active_enemy:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_urn_of_shadows_active_enemy:GetTexture()
	return "item_urn_of_shadows"
end

if IsServer() then
	function modifier_imba_urn_of_shadows_active_enemy:OnCreated( params )
		self.damage_per_second = params.damage / params.duration
		self:StartIntervalThink(1)
	end

	function modifier_imba_urn_of_shadows_active_enemy:OnIntervalThink()
		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage_per_second,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS,
			ability = self:GetAbility()
		}

		ApplyDamage(damageTable)
	end
end
