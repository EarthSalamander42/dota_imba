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
		By: AtroCty
		Date: 27.05.2017
		Updated:27.05.2017
	]]
-------------------------------------------
--			RUSTY OLD SHOTGUN
-------------------------------------------
LinkLuaModifier("modifier_imba_shotgun_passive", "components/items/item_starfury.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------
item_imba_shotgun = item_imba_shotgun or class({})
-------------------------------------------
function item_imba_shotgun:GetIntrinsicModifierName()
	return "modifier_imba_shotgun_passive"
end

function item_imba_shotgun:GetAbilityTextureName()
	return "custom/imba_shotgun"
end

-------------------------------------------
modifier_imba_shotgun_passive = modifier_imba_shotgun_passive or class({})
function modifier_imba_shotgun_passive:IsDebuff() return false end
function modifier_imba_shotgun_passive:IsHidden() return true end
function modifier_imba_shotgun_passive:IsPermanent() return true end
function modifier_imba_shotgun_passive:IsPurgable() return false end
function modifier_imba_shotgun_passive:IsPurgeException() return false end
function modifier_imba_shotgun_passive:IsStunDebuff() return false end
function modifier_imba_shotgun_passive:RemoveOnDeath() return false end
function modifier_imba_shotgun_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_shotgun_passive:OnDestroy()
	self:CheckUnique(false)
end

function modifier_imba_shotgun_passive:OnCreated()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and self.item then
		self.bonus_damage = self.item:GetSpecialValueFor("bonus_damage")
		self.bonus_as = self.item:GetSpecialValueFor("bonus_as")
		self.bonus_agi = self.item:GetSpecialValueFor("bonus_agi")
		self:CheckUnique(true)
		if not self.parent:IsIllusion() then
			self.projectile_speed = self.item:GetSpecialValueFor("projectile_speed")
			self.agility_pct_ranged = self.item:GetSpecialValueFor("agility_pct_ranged") * 0.01
			self.agility_pct_melee = self.item:GetSpecialValueFor("agility_pct_melee") * 0.01
			self.ranged_proj_range = self.item:GetSpecialValueFor("ranged_proj_range")
			self.ranged_proj_radius = self.item:GetSpecialValueFor("ranged_proj_radius")
			self.ranged_proj_angle = self.item:GetSpecialValueFor("ranged_proj_angle")
			self.ranged_proj_stun = self.item:GetSpecialValueFor("ranged_proj_stun")
		end
	end
end

function modifier_imba_shotgun_passive:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_EVENT_ON_ATTACK
		}
	return decFuns
end

function modifier_imba_shotgun_passive:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_imba_shotgun_passive:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_shotgun_passive:GetModifierBonusStats_Agility()
	return self.bonus_agi
end

function modifier_imba_shotgun_passive:OnAttack(params)
	if IsServer() then
		-- Only for real heroes & clones
		if params.attacker == self.parent and self.parent:IsRealHero() then

			-- Cooldown check and lookup for Starfury
			if self.item:IsCooldownReady() and (self:CheckUniqueValue(1,{"modifier_imba_starfury_passive"}) == 1) then
				-- Parameters
				local hero = self.parent
				local damage
				if hero:IsRangedAttacker() then
					damage = hero:GetAgility() * self.agility_pct_ranged
				else
					damage = hero:GetAgility() * self.agility_pct_melee
				end

				local damage_type = DAMAGE_TYPE_PHYSICAL
				local stun_duration = self.ranged_proj_stun
				if hero:HasItemInInventory("item_imba_spell_fencer") then
					damage_type = DAMAGE_TYPE_MAGICAL
				end
				local vColor = hero:GetFittingColor()
				-- If ranged then launch 3 projectiles
				if hero:IsRangedAttacker() then
					local hero_pos = hero:GetAbsOrigin()
					local target_pos = params.target:GetAbsOrigin()
					local main_direction
					if target_pos == hero_pos then
						main_direction = hero:GetForwardVector()
					else
						main_direction = (target_pos - hero_pos):Normalized()
					end
					-- Hit counter, stun if hit by all projectiles
					local hits = 0
					local last_target

					for i = 1, 3 do
						local direction = main_direction
						if i == 1 then
							direction = RotateVector2D(direction,self.ranged_proj_angle,true)
						elseif i == 2 then
							direction = RotateVector2D(direction,-self.ranged_proj_angle,true)
						end
						local end_loc = hero_pos+direction*self.ranged_proj_range+Vector(0,0,90)
						local projectile =
							{
								EffectName = "particles/item/starfury/starfury_projectile.vpcf",
								vSpawnOrigin = {unit=hero, attach="attach_attack1", offset=Vector(0,0,90)},
								fDistance = self.ranged_proj_range,
								fStartRadius = self.ranged_proj_radius,
								fEndRadius = self.ranged_proj_radius,
								Source = hero,
								fExpireTime = 8.0,
								vVelocity = direction*self.projectile_speed,
								UnitBehavior = PROJECTILES_DESTROY,
								bMultipleHits = false,
								bIgnoreSource = true,
								TreeBehavior = PROJECTILES_NOTHING,
								bCutTrees = false,
								bTreeFullCollision = false,
								WallBehavior = PROJECTILES_NOTHING,
								GroundBehavior = PROJECTILES_NOTHING,
								fGroundOffset = 80,
								nChangeMax = 1,
								bRecreateOnChange = false,
								bZCheck = false,
								bGroundLock = true,
								bProvidesVision = false,
								bFlyingVision = false,
								ControlPoints = {[0]=hero_pos+Vector(0,0,90),[1]=end_loc,[2]=Vector(self.projectile_speed,0,0),[3]=end_loc,[4]=vColor,[5]=hero:GetHeroColorSecondary()},
								UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= hero:GetTeamNumber() end,
								OnUnitHit = function(self, unit)
									if last_target == nil then
										last_target = unit
									elseif last_target ~= unit then
										hits = -1
									end
									hits = hits + 1
									if hits == 3 then
										unit:AddNewModifier(hero, self.item, "modifier_stunned", {duration = stun_duration})
									end
									params.damage = damage
									params.damage_type = damage_type
									params.hCaster = hero
									params.hTarget = unit
									ProjectileHit(params, nil, self)
								end,
							}
						Projectiles:CreateProjectile(projectile)
					end
				else
					params.damage = damage
					params.damage_type = damage_type
					params.hCaster = hero
					params.hTarget = params.target
					ProjectileHit(params, nil, self)
				end
				local bullet_pfx = ParticleManager:CreateParticle("particles/item/starfury/shotgun_eject_charlie.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
				ParticleManager:SetParticleControl(bullet_pfx, 0, hero:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_ATTACK_1))
				ParticleManager:SetParticleControl(bullet_pfx, 4, vColor)
				self.item:UseResources(false, false, true)
				StartSoundEventFromPosition("Imba.Shotgun",hero:GetAbsOrigin())
			end
		end
	end
end

-------------------------------------------
--			STARFURY
-------------------------------------------
LinkLuaModifier("modifier_imba_starfury_passive", "components/items/item_starfury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_starfury_buff_increase", "components/items/item_starfury.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------
item_imba_starfury = item_imba_starfury or class({})
-------------------------------------------
function item_imba_starfury:GetIntrinsicModifierName()
	return "modifier_imba_starfury_passive"
end

function item_imba_starfury:GetAbilityTextureName()
	return "custom/imba_starfury"
end
-------------------------------------------
modifier_imba_starfury_passive = modifier_imba_starfury_passive or class({})
function modifier_imba_starfury_passive:IsDebuff() return false end
function modifier_imba_starfury_passive:IsHidden() return true end
function modifier_imba_starfury_passive:IsPermanent() return true end
function modifier_imba_starfury_passive:IsPurgable() return false end
function modifier_imba_starfury_passive:IsPurgeException() return false end
function modifier_imba_starfury_passive:IsStunDebuff() return false end
function modifier_imba_starfury_passive:RemoveOnDeath() return false end
function modifier_imba_starfury_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_starfury_passive:OnDestroy()
	self:CheckUnique(false)
end

function modifier_imba_starfury_passive:OnCreated()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and self.item then
		self.bonus_damage = self.item:GetSpecialValueFor("bonus_damage")
		self.bonus_as = self.item:GetSpecialValueFor("bonus_as")
		self.bonus_agi = self.item:GetSpecialValueFor("bonus_agi")
		self.range = self.item:GetSpecialValueFor("range")
		self.proc_chance = self.item:GetSpecialValueFor("proc_chance")
		self.proc_duration = self.item:GetSpecialValueFor("proc_duration")
		self.projectile_speed = self.item:GetSpecialValueFor("projectile_speed")
		self.agility_pct = self.item:GetSpecialValueFor("agility_pct") * 0.01
		self:CheckUnique(true)
	end
end

function modifier_imba_starfury_passive:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_EVENT_ON_ATTACK_FAIL,
		}
	return decFuns
end

function modifier_imba_starfury_passive:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_imba_starfury_passive:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_starfury_passive:GetModifierBonusStats_Agility()
	return self.bonus_agi
end

function modifier_imba_starfury_passive:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self.parent then

			if (RollPseudoRandom(self.proc_chance, self.item) and (self:CheckUniqueValue(1,{}) == 1) and (self.parent:IsClone() or self.parent:IsRealHero())) then
				self.parent:AddNewModifier(self.parent, self.item, "modifier_imba_starfury_buff_increase", {duration = self.proc_duration})
			end
			if self.item:IsCooldownReady() and (self:CheckUniqueValue(1,{}) == 1) then
				target_loc = params.target:GetAbsOrigin()
				StartSoundEventFromPosition("Ability.StarfallImpact", target_loc)
				local damage = self.parent:GetAgility() * self.agility_pct
				local damage_type = DAMAGE_TYPE_PHYSICAL
				if self.parent:HasItemInInventory("item_imba_spell_fencer") then
					damage_type = DAMAGE_TYPE_MAGICAL
				end
				local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), target_loc, nil, self.range, self.item:GetAbilityTargetTeam(), self.item:GetAbilityTargetType(), self.item:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
				-- If enemies found, start cooldown
				local bFound = false
				for _, enemy in pairs(enemies) do
					if enemy ~= params.target then
						local damager = self.parent
						projectile = {
							hTarget = enemy,
							hCaster = damager,
							vColor = self.parent:GetFittingColor(),
							vColor2 = self.parent:GetHeroColorSecondary(),
							hAbility = self.ability,
							iMoveSpeed = self.projectile_speed,
							EffectName = "particles/item/starfury/starfury_projectile.vpcf",
							flRadius = 1,
							bDodgeable = true,
							bDestroyOnDodge = true,
							vSpawnOrigin = target_loc,
							OnProjectileHitUnit = function(params, projectileID)
								params.damage = damage
								params.damage_type = damage_type
								ProjectileHit(params, projectileID, self)
							end,
						}
						TrackingProjectiles:Projectile(projectile)
						if not bFound then
							bFound = true
							self.item:UseResources(false, false, true)
						end
					end
				end
			end
		end
	end
end

function modifier_imba_starfury_passive:OnAttackFail(params)
	self:OnAttackLanded(params)
end

-------------------------------------------
modifier_imba_starfury_buff_increase = modifier_imba_starfury_buff_increase or class({})
function modifier_imba_starfury_buff_increase:IsDebuff() return false end
function modifier_imba_starfury_buff_increase:IsHidden() return false end
function modifier_imba_starfury_buff_increase:IsPurgable() return true end
function modifier_imba_starfury_buff_increase:IsStunDebuff() return false end
function modifier_imba_starfury_buff_increase:RemoveOnDeath() return true end
-------------------------------------------
function modifier_imba_starfury_buff_increase:OnCreated()
	local hItem = self:GetAbility()
	local hParent = self:GetParent()
	if hItem and hParent and IsServer() then
		local agility = hParent:GetAgility()
		self:SetStackCount(hItem:GetSpecialValueFor("proc_bonus") * 0.01 * agility)
	end
end

function modifier_imba_starfury_buff_increase:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS
		}
	return decFuns
end

function modifier_imba_starfury_buff_increase:GetModifierBonusStats_Agility()
	return self:GetStackCount()
end

function ProjectileHit(params, projectileID, modifier)
	-- Perform an instant attack on hit enemy
	ApplyDamage({attacker = params.hCaster, victim = params.hTarget, ability = nil, damage = params.damage, damage_type = params.damage_type, damage_flags = DOTA_DAMAGE_FLAG_USE_COMBAT_PROFICIENCY + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS})
end
