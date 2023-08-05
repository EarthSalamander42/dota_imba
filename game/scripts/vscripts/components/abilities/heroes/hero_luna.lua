-- Creator:
--	   AltiV, May 5th, 2019

LinkLuaModifier("modifier_imba_luna_moon_glaive", "components/abilities/heroes/hero_luna", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_luna_lunar_blessing_aura", "components/abilities/heroes/hero_luna", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_luna_lunar_blessing_aura_723", "components/abilities/heroes/hero_luna", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_luna_lunar_blessing_723", "components/abilities/heroes/hero_luna", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_luna_eclipse", "components/abilities/heroes/hero_luna", LUA_MODIFIER_MOTION_NONE)

imba_luna_lucent_beam                      = class({})

imba_luna_moon_glaive                      = class({})
modifier_imba_luna_moon_glaive             = class({})

imba_luna_lunar_blessing                   = class({})
modifier_imba_luna_lunar_blessing_aura     = class({})

imba_luna_lunar_blessing_723               = class({})
modifier_imba_luna_lunar_blessing_aura_723 = class({})
modifier_imba_luna_lunar_blessing_723      = modifier_imba_luna_lunar_blessing_723 or class({})

imba_luna_eclipse                          = class({})
modifier_imba_luna_eclipse                 = class({})

-----------------
-- LUCENT BEAM --
-----------------

function imba_luna_lucent_beam:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

function imba_luna_lucent_beam:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_luna_lucent_beam_cooldown")
end

function imba_luna_lucent_beam:OnAbilityPhaseStart()
	if not IsServer() then return end

	local precast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_lucent_beam_precast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(precast_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(precast_particle)

	return true
end

-- Atmospheric Refraction IMBAfication will be an "opt-out" add-on
function imba_luna_lucent_beam:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end

function imba_luna_lucent_beam:OnSpellStart()
	if not IsServer() then return end

	-- Do not continue logic if blocked by Linken's Sphere
	if self:GetCursorTarget():TriggerSpellAbsorb(self) then return nil end

	self:GetCaster():EmitSound("Hero_Luna.LucentBeam.Cast")
	self:GetCursorTarget():EmitSound("Hero_Luna.LucentBeam.Target")

	if self:GetCaster():GetName() == "npc_dota_hero_luna" and RollPercentage(50) then
		local responses =
		{
			"luna_luna_ability_lucentbeam_01",
			"luna_luna_ability_lucentbeam_02",
			"luna_luna_ability_lucentbeam_04",
			"luna_luna_ability_lucentbeam_05",
		}

		self:GetCaster():EmitSound(responses[RandomInt(1, #responses)])
	end

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_lucent_beam.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle, 1, self:GetCursorTarget():GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(particle, 5, self:GetCursorTarget(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCursorTarget():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 6, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)

	-- "Lucent Beam first applies the damage, then the debuff."
	local damageTable = {
		victim       = self:GetCursorTarget(),
		damage       = self:GetTalentSpecialValueFor("beam_damage"),
		damage_type  = self:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		attacker     = self:GetCaster(),
		ability      = self
	}

	ApplyDamage(damageTable)

	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("stun_duration") * (1 - self:GetCursorTarget():GetStatusResistance()) })

	if self:GetAutoCastState() then
		-- IMBAfication: Atmospheric Refraction	
		local refraction_damage_radius = self:GetSpecialValueFor("refraction_damage_radius")
		local refraction_waves         = self:GetSpecialValueFor("refraction_waves")
		local refraction_beams         = self:GetSpecialValueFor("refraction_beams")
		local refraction_distance      = self:GetSpecialValueFor("refraction_distance")
		local refraction_delay         = self:GetSpecialValueFor("refraction_delay")

		local target_pos               = self:GetCursorTarget():GetAbsOrigin()
		local random_vector            = Vector(1, 1, 0):Normalized() * refraction_distance
		local wave_count               = 0

		Timers:CreateTimer(refraction_delay, function()
			wave_count    = wave_count + 1
			random_vector = random_vector:Normalized() + (refraction_distance * wave_count)

			for inner_beam = 1, refraction_beams do
				local beam_pos = GetGroundPosition(RotatePosition(target_pos, QAngle(0, 360 * inner_beam / 4, 0), target_pos + random_vector), nil)
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_lucent_beam.vpcf", PATTACH_POINT, self:GetCaster())
				ParticleManager:SetParticleControl(particle, 1, beam_pos)
				ParticleManager:SetParticleControl(particle, 5, beam_pos)
				ParticleManager:SetParticleControlEnt(particle, 6, self:GetCaster(), PATTACH_POINT, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(particle, 60, Vector(RandomInt(0, 255), RandomInt(0, 255), RandomInt(0, 255)))
				ParticleManager:SetParticleControl(particle, 61, Vector(1, 0, 0))
				ParticleManager:ReleaseParticleIndex(particle)

				local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), beam_pos, nil, refraction_damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

				for _, enemy in pairs(enemies) do
					local damageTable = {
						victim       = enemy,
						damage       = self:GetTalentSpecialValueFor("beam_damage"),
						damage_type  = self:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE,
						attacker     = self:GetCaster(),
						ability      = self
					}

					ApplyDamage(damageTable)
				end
			end

			if wave_count < refraction_waves then
				return refraction_delay
			end
		end)
	end
end

-----------------
-- MOON GLAIVE --
-----------------

function imba_luna_moon_glaive:GetIntrinsicModifierName()
	return "modifier_imba_luna_moon_glaive"
end

function imba_luna_moon_glaive:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if not IsServer() then return end

	if hTarget then
		-- -- IMBAfication: Weighted Dual-Edge
		self.damage_type = DAMAGE_TYPE_PHYSICAL

		-- if not hTarget:IsBuilding() and hTarget:GetMagicalArmorValue() < GetReductionFromArmor(hTarget:GetPhysicalArmorValue(false)) then
		-- self.damage_type = DAMAGE_TYPE_MAGICAL
		-- end

		local damageTable = {
			victim       = hTarget,
			damage       = ExtraData.damage * ((100 - self:GetSpecialValueFor("damage_reduction_percent")) / 100) ^ (ExtraData.bounces + 1),
			damage_type  = self.damage_type,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --+ DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, -- IMBAfication: Waning Gibbous
			attacker     = self:GetCaster(),
			ability      = self
		}

		damage_dealt = ApplyDamage(damageTable)

		if not self.target_tracker then
			self.target_tracker = {}
		end

		if not self.target_tracker[ExtraData.record] then
			self.target_tracker[ExtraData.record] = {}
		end

		self.target_tracker[ExtraData.record][hTarget:GetEntityIndex()] = true
	end

	-- "A disjointed bounce still counts as a bounce, so it reduces the amount of bounces left and the damage of the next bounce."
	ExtraData.bounces = ExtraData.bounces + 1

	local glaive_launched = false

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vLocation, nil, self:GetSpecialValueFor("range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

	if ExtraData.bounces < self:GetSpecialValueFor("bounces") and #enemies > 1 then
		-- First, check if all enemies haven't been bounced on yet
		local all_enemies_bounced = true

		for _, enemy in pairs(enemies) do
			if enemy ~= hTarget and not self.target_tracker[ExtraData.record][enemy:GetEntityIndex()] then -- Yes, hTarget can be nil here. That is intended
				all_enemies_bounced = false
				break
			end
		end

		for _, enemy in pairs(enemies) do
			if enemy ~= hTarget and (not self.target_tracker[ExtraData.record][enemy:GetEntityIndex()] or all_enemies_bounced) then -- Yes, hTarget can be nil here. Same as above
				local glaive =
				{
					Target            = enemy,
					Ability           = self,
					EffectName        = "particles/units/heroes/hero_luna/luna_moon_glaive_bounce.vpcf",
					iMoveSpeed        = 900,
					vSourceLoc        = vLocation,
					bDrawsOnMinimap   = false,
					bDodgeable        = false,
					bIsAttack         = false,
					bVisibleToEnemies = true,
					bReplaceExisting  = false,
					flExpireTime      = GameRules:GetGameTime() + 10,
					bProvidesVision   = false,
					ExtraData         = {
						bounces = ExtraData.bounces,
						record  = ExtraData.record,
						damage  = ExtraData.damage
					}
				}

				ProjectileManager:CreateTrackingProjectile(glaive)

				glaive_launched = true

				break
			end
		end

		if not glaive_launched then
			self.target_tracker[ExtraData.record] = nil
		end
	else
		self.target_tracker[ExtraData.record] = nil
	end
end

--------------------------
-- MOON GLAIVE MODIFIER --
--------------------------

function modifier_imba_luna_moon_glaive:IsHidden() return true end

function modifier_imba_luna_moon_glaive:OnCreated()
	if not IsServer() then return end
end

function modifier_imba_luna_moon_glaive:OnRefresh()
	if not IsServer() then return end

	if not self.glaive_particle and self:GetAbility():IsTrained() then
		self.glaive_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_ambient_moon_glaive.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.glaive_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
		self:AddParticle(self.glaive_particle, false, false, -1, false, false)
	end
end

function modifier_imba_luna_moon_glaive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_imba_luna_moon_glaive:GetModifierProcAttack_Feedback(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() then
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

		local crescents = 0

		for _, enemy in pairs(enemies) do
			if enemy ~= keys.target then
				local glaive =
				{
					Target            = enemy,
					Source            = keys.target,
					Ability           = self:GetAbility(),
					EffectName        = "particles/units/heroes/hero_luna/luna_moon_glaive_bounce.vpcf",
					iMoveSpeed        = 900,
					bDrawsOnMinimap   = false,
					bDodgeable        = false,
					bIsAttack         = false,
					bVisibleToEnemies = true,
					bReplaceExisting  = false,
					flExpireTime      = GameRules:GetGameTime() + 10,
					bProvidesVision   = false,
					ExtraData         = {
						bounces = 0,
						record  = keys.record, -- Will use this to attempt proper bounce logic
						damage  = keys.original_damage
					}
				}

				ProjectileManager:CreateTrackingProjectile(glaive)

				-- IMBAfication: Crescent
				crescents = crescents + 1

				if crescents > self:GetAbility():GetSpecialValueFor("bounces") or not self:GetAbility():IsCooldownReady() then
					break
				end
			end
		end

		if self:GetAbility():IsCooldownReady() and #enemies > 1 then
			self:GetAbility():UseResources(false, false, false, true)
		end
	end
end

--------------------
-- LUNAR BLESSING --
--------------------

function imba_luna_lunar_blessing:IsStealable() return false end

function imba_luna_lunar_blessing:GetIntrinsicModifierName()
	return "modifier_imba_luna_lunar_blessing_aura"
end

-- This is so bootleg
-- IMBAfication: Full Moon
function imba_luna_lunar_blessing:CastFilterResult()
	self.full_moon = GameRules:GetDOTATime(true, true)

	return UF_SUCCESS
end

function imba_luna_lunar_blessing:GetAbilityTextureName()
	if self.full_moon and GameRules:GetDOTATime(true, true) - self.full_moon <= self:GetSpecialValueFor("full_moon_duration") then
		return "luna_lunar_blessing_full_moon"
	else
		return "luna_lunar_blessing"
	end
end

----------------------------------
-- LUNAR BLESSING MODIFIER AURA --
----------------------------------

function modifier_imba_luna_lunar_blessing_aura:IsHidden() return not (self:GetAbility() and self:GetAbility():GetLevel() >= 1) end

function modifier_imba_luna_lunar_blessing_aura:IsAura() return self:GetParent() == self:GetCaster() end

function modifier_imba_luna_lunar_blessing_aura:IsAuraActiveOnDeath() return false end

function modifier_imba_luna_lunar_blessing_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end

function modifier_imba_luna_lunar_blessing_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end

function modifier_imba_luna_lunar_blessing_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_imba_luna_lunar_blessing_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end

function modifier_imba_luna_lunar_blessing_aura:GetModifierAura() return "modifier_imba_luna_lunar_blessing_aura" end

-- function modifier_imba_luna_lunar_blessing_aura:GetAuraEntityReject(hEntity)	return hEntity == self:GetCaster() end -- Already an intrinsic modifier

function modifier_imba_luna_lunar_blessing_aura:GetEffectName()
	if self:GetAbility() and self:GetAbility():GetLevel() >= 1 and (self:GetParent() == self:GetCaster() or (self:GetAbility().full_moon and GameRules:GetDOTATime(true, true) - self:GetAbility().full_moon <= self:GetAbility():GetSpecialValueFor("full_moon_duration"))) then return "particles/units/heroes/hero_luna/luna_ambient_lunar_blessing.vpcf" end
end

-- Using bootleg way to deal with client/server interaction for strength/agility/intellect
-- On serverside, set the stack count to the attribute number (strength = 0, agility = 1, intellect = 2)
-- By the time a frame passes, hypothetically speaking the client side should be able to read the proper stack count, which will then store the value in a variable before setting the stack count back to nothing since vanilla doesn't have a stack number
function modifier_imba_luna_lunar_blessing_aura:OnCreated()
	self.initialized = false

	self:StartIntervalThink(FrameTime())

	if not IsServer() then return end

	self:SetStackCount(self:GetParent():GetPrimaryAttribute() or 0)
end

function modifier_imba_luna_lunar_blessing_aura:OnIntervalThink()
	if not self.initialized then
		self.hero_primary_attribute = self:GetStackCount()
		self:SetStackCount(0)
		self.initialized = true
		if IsServer() then
			self:StartIntervalThink(0.5)
		else
			self:StartIntervalThink(-1)
		end
	end

	if IsServer() then
		self:GetParent():CalculateStatBonus(true)
	end
end

function modifier_imba_luna_lunar_blessing_aura:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

		MODIFIER_PROPERTY_BONUS_NIGHT_VISION
	}

	return decFuncs
end

function modifier_imba_luna_lunar_blessing_aura:GetModifierBonusStats_Strength()
	if self:GetAbility() and (self.hero_primary_attribute == DOTA_ATTRIBUTE_STRENGTH or (self:GetAbility().full_moon and GameRules:GetDOTATime(true, true) - self:GetAbility().full_moon <= self:GetAbility():GetSpecialValueFor("full_moon_duration"))) and not self:GetCaster():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("primary_attribute")
	end
end

function modifier_imba_luna_lunar_blessing_aura:GetModifierBonusStats_Agility()
	if self:GetAbility() and (self.hero_primary_attribute == DOTA_ATTRIBUTE_AGILITY or (self:GetAbility().full_moon and GameRules:GetDOTATime(true, true) - self:GetAbility().full_moon <= self:GetAbility():GetSpecialValueFor("full_moon_duration"))) and not self:GetCaster():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("primary_attribute")
	end
end

function modifier_imba_luna_lunar_blessing_aura:GetModifierBonusStats_Intellect()
	if self:GetAbility() and (self.hero_primary_attribute == DOTA_ATTRIBUTE_INTELLECT or (self:GetAbility().full_moon and GameRules:GetDOTATime(true, true) - self:GetAbility().full_moon <= self:GetAbility():GetSpecialValueFor("full_moon_duration"))) and not self:GetCaster():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("primary_attribute")
	end
end

function modifier_imba_luna_lunar_blessing_aura:GetBonusNightVision()
	if self:GetAbility() and (self:GetParent() == self:GetCaster() or (self:GetAbility().full_moon and GameRules:GetDOTATime(true, true) - self:GetAbility().full_moon <= self:GetAbility():GetSpecialValueFor("full_moon_duration"))) and not self:GetCaster():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("bonus_night_vision")
	end
end

----------------------------------
-- IMBA_LUNA_LUNAR_BLESSING_723 --
----------------------------------

function imba_luna_lunar_blessing_723:IsStealable() return false end

function imba_luna_lunar_blessing_723:GetIntrinsicModifierName()
	return "modifier_imba_luna_lunar_blessing_aura_723"
end

-- This is so bootleg
-- IMBAfication: Full Moon
function imba_luna_lunar_blessing_723:CastFilterResult()
	self.full_moon = GameRules:GetDOTATime(true, true)

	return UF_SUCCESS
end

function imba_luna_lunar_blessing_723:GetAbilityTextureName()
	if self.full_moon and GameRules:GetDOTATime(true, true) - self.full_moon <= self:GetSpecialValueFor("full_moon_duration") then
		return "luna_lunar_blessing_full_moon"
	else
		return "luna_lunar_blessing"
	end
end

------------------------------------------------
-- MODIFIER_IMBA_LUNA_LUNAR_BLESSING_AURA_723 --
------------------------------------------------

function modifier_imba_luna_lunar_blessing_aura_723:IsHidden() return true end

function modifier_imba_luna_lunar_blessing_aura_723:IsAura() return true end

function modifier_imba_luna_lunar_blessing_aura_723:IsAuraActiveOnDeath() return false end

function modifier_imba_luna_lunar_blessing_aura_723:GetAuraRadius()
	if not self:GetCaster():PassivesDisabled() then
		if (self:GetAbility().full_moon and GameRules:GetDOTATime(true, true) - self:GetAbility().full_moon <= self:GetAbility():GetSpecialValueFor("full_moon_duration")) then
			return 25000
		else
			return self:GetAbility():GetSpecialValueFor("radius")
		end
	end
end

function modifier_imba_luna_lunar_blessing_aura_723:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end

function modifier_imba_luna_lunar_blessing_aura_723:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_imba_luna_lunar_blessing_aura_723:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_imba_luna_lunar_blessing_aura_723:GetModifierAura() return "modifier_imba_luna_lunar_blessing_723" end

function modifier_imba_luna_lunar_blessing_aura_723:GetAuraEntityReject(hEntity) return (not hEntity.GetPlayerID and not hEntity:GetOwnerEntity()) or (not hEntity:IsRangedAttacker() and not ((self:GetAbility().full_moon and GameRules:GetDOTATime(true, true) - self:GetAbility().full_moon <= self:GetAbility():GetSpecialValueFor("full_moon_duration")))) end

-- function modifier_imba_luna_lunar_blessing_aura_723:GetEffectName()
-- if self:GetAbility() and self:GetAbility():GetLevel() >= 1 and (self:GetParent() == self:GetCaster() or (self:GetAbility().full_moon and GameRules:GetDOTATime(true, true) - self:GetAbility().full_moon <= self:GetAbility():GetSpecialValueFor("full_moon_duration"))) then return "particles/units/heroes/hero_luna/luna_ambient_lunar_blessing.vpcf" end
-- end

-------------------------------------------
-- MODIFIER_IMBA_LUNA_LUNAR_BLESSING_723 --
-------------------------------------------

function modifier_imba_luna_lunar_blessing_723:OnCreated()
	self.armor = self:GetParent():GetPhysicalArmorValue(false)

	self:StartIntervalThink(0.1)
end

function modifier_imba_luna_lunar_blessing_723:OnIntervalThink()
	self.armor = 0
	self.armor = self:GetParent():GetPhysicalArmorValue(false)
end

function modifier_imba_luna_lunar_blessing_723:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_PHYSICAL_ARMOR_TOTAL_PERCENTAGE, -- Doesn't seem to be working right now...
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,

		MODIFIER_PROPERTY_BONUS_NIGHT_VISION
	}
end

-- function modifier_imba_luna_lunar_blessing_723:GetModifierPhysicalArmorTotal_Percentage()
-- if self:GetAbility() and not self:GetCaster():PassivesDisabled() then
-- return self:GetAbility():GetSpecialValueFor("armor_pct")
-- end
-- end

function modifier_imba_luna_lunar_blessing_723:GetModifierPhysicalArmorBonus()
	if self:GetAbility() and not self:GetCaster():PassivesDisabled() and self.armor then
		return self.armor * self:GetAbility():GetSpecialValueFor("armor_pct") / 100
	end
end

function modifier_imba_luna_lunar_blessing_723:OnTooltip()
	if self:GetAbility() and not self:GetCaster():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("armor_pct")
	else
		return 0
	end
end

function modifier_imba_luna_lunar_blessing_723:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetAbility() and not self:GetCaster():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("damage_pct")
	end
end

function modifier_imba_luna_lunar_blessing_723:GetBonusNightVision()
	if self:GetAbility() and (self:GetParent() == self:GetCaster() or (self:GetAbility().full_moon and GameRules:GetDOTATime(true, true) - self:GetAbility().full_moon <= self:GetAbility():GetSpecialValueFor("full_moon_duration"))) and not self:GetCaster():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("bonus_night_vision")
	end
end

-------------
-- ECLIPSE --
-------------

function imba_luna_eclipse:OnAbilityPhaseStart()
	if not IsServer() then return end

	local precast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_eclipse_precast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(precast_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(precast_particle)

	return true
end

function imba_luna_eclipse:GetAssociatedPrimaryAbilities()
	return "imba_luna_lucent_beam"
end

function imba_luna_eclipse:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
end

function imba_luna_eclipse:GetCastRange()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("cast_range_tooltip_scepter")
	else
		return self:GetSpecialValueFor("radius")
	end
end

function imba_luna_eclipse:GetAOERadius()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("radius")
	else
		return 0
	end
end

function imba_luna_eclipse:OnSpellStart()
	if not IsServer() then return end

	if self:GetCaster():HasScepter() then
		if self:GetCursorTarget() then
			self:GetCursorTarget():EmitSound("Hero_Luna.Eclipse.Cast")
		elseif self:GetCursorPosition() then
			EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "Hero_Luna.Eclipse.Cast", self:GetCaster())
		end
	else
		self:GetCaster():EmitSound("Hero_Luna.Eclipse.Cast")
	end

	if self:GetCaster():GetName() == "npc_dota_hero_luna" then
		local responses =
		{
			"luna_luna_ability_eclipse_01",
			"luna_luna_ability_eclipse_02",
			"luna_luna_ability_eclipse_03",
			"luna_luna_ability_eclipse_07",
		}

		self:GetCaster():EmitSound(responses[RandomInt(1, #responses)])
	end

	if self:GetCaster():HasScepter() and self:GetCursorTarget() then
		self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_luna_eclipse", {})
	else
		local modifier_params = {}

		if self:GetCaster():HasScepter() and self:GetCursorPosition() then
			modifier_params.x = self:GetCursorPosition().x
			modifier_params.y = self:GetCursorPosition().y
			modifier_params.z = self:GetCursorPosition().z
		end

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_luna_eclipse", modifier_params)
	end

	GameRules:BeginTemporaryNight(self:GetSpecialValueFor("night_duration"))
end

----------------------
-- ECLIPSE MODIFIER --
----------------------

function modifier_imba_luna_eclipse:IsPurgable() return false end

function modifier_imba_luna_eclipse:RemoveOnDeath() return false end -- IMBAfication: Selemene's Wrath

function modifier_imba_luna_eclipse:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_luna_eclipse:OnCreated(params)
	self.beams                      = self:GetAbility():GetSpecialValueFor("beams")
	self.hit_count                  = self:GetAbility():GetSpecialValueFor("hit_count")
	self.beam_interval              = self:GetAbility():GetSpecialValueFor("beam_interval")
	self.beam_interval_scepter      = self:GetAbility():GetSpecialValueFor("beam_interval_scepter")
	self.duration_tooltip           = self:GetAbility():GetSpecialValueFor("duration_tooltip")
	self.radius                     = self:GetAbility():GetSpecialValueFor("radius")
	self.beams_scepter              = self:GetAbility():GetSpecialValueFor("beams_scepter")
	self.hit_count_scepter          = self:GetAbility():GetSpecialValueFor("hit_count_scepter")
	self.duration_tooltip_scepter   = self:GetAbility():GetSpecialValueFor("duration_tooltip_scepter")
	self.cast_range_tooltip_scepter = self:GetAbility():GetSpecialValueFor("cast_range_tooltip_scepter")

	self.night_duration             = self:GetAbility():GetSpecialValueFor("night_duration")
	self.dark_moon_additional_beams = self:GetAbility():GetSpecialValueFor("dark_moon_additional_beams")
	self.moonscraper_beams          = self:GetAbility():GetSpecialValueFor("moonscraper_beams")
	self.moonscraper_spread         = self:GetAbility():GetSpecialValueFor("moonscraper_spread")
	self.moonscraper_radius         = self:GetAbility():GetSpecialValueFor("moonscraper_radius")

	if not IsServer() then return end

	self.beams_elapsed     = 0
	self.targets           = {}

	local eclipse_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_eclipse.vpcf", PATTACH_POINT, self:GetParent())
	ParticleManager:SetParticleControl(eclipse_particle, 1, Vector(self.radius, 0, 0))

	-- If Eclipse was cast on the ground, set the target position to be there instead of situated at a unit
	if params.x then
		self.target_position = Vector(params.x, params.y, params.z)
		ParticleManager:SetParticleControl(eclipse_particle, 0, self.target_position)
	end

	self:AddParticle(eclipse_particle, false, false, -1, false, false)

	self.cast_pos       = self.target_position or self:GetParent():GetAbsOrigin()
	self.refraction_pos = self.cast_pos + RandomVector(self.radius)

	-- IMBAfication: Ultimate Blessing (description attached to Lunar Blessing)
	if not self.target_position and self:GetCaster():HasAbility("imba_luna_lunar_blessing") and self:GetCaster():FindAbilityByName("imba_luna_lunar_blessing"):IsTrained() then
		local ultimate_blessing_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_ultimate_blessing.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(ultimate_blessing_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(ultimate_blessing_particle, false, false, -1, true, false)
	end

	self:OnIntervalThink()

	if self:GetCaster():HasScepter() then
		self:StartIntervalThink(self.beam_interval_scepter)
	else
		self:StartIntervalThink(self.beam_interval)
	end
end

function modifier_imba_luna_eclipse:OnIntervalThink()
	if not IsServer() then return end

	-- The Eclipse modifier itself doesn't have an actual buff duration; it removes itself after a number of beams have fired (or if 10 seconds pass from too many Eclipse kills)
	if ((self:GetCaster():HasScepter() and self.beams_elapsed >= self.beams_scepter) or (not self:GetCaster():HasScepter() and self.beams_elapsed >= self.beams)) or self:GetElapsedTime() >= self.night_duration then
		self:Destroy()
		return
	end

	-- "Provides 675 radius ground vision for its duration when not targeting a unit."
	if self.target_position then
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self.target_position, self.radius, self.beam_interval_scepter, true)
	end

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.target_position or self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- First check if there are any valid enemies first; if not, draw the Lucent Beam particle to a random area
	local valid_targets = false

	local lucent_beam_ability = self:GetCaster():FindAbilityByName("imba_luna_lucent_beam")

	for _, enemy in pairs(enemies) do
		if not self.targets[enemy:GetEntityIndex()] then
			self.targets[enemy:GetEntityIndex()] = 0
		end

		if (self:GetCaster():HasScepter() and self.targets[enemy:GetEntityIndex()] < self.hit_count_scepter) or (not self:GetCaster():HasScepter() and self.targets[enemy:GetEntityIndex()] < self.hit_count) then
			self.targets[enemy:GetEntityIndex()] = self.targets[enemy:GetEntityIndex()] + 1

			enemy:EmitSound("Hero_Luna.Eclipse.Target")

			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_eclipse_impact.vpcf", PATTACH_POINT, enemy)
			ParticleManager:SetParticleControl(particle, 1, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControlEnt(particle, 5, enemy, PATTACH_POINT, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle)

			if lucent_beam_ability then
				-- "Lucent Beam first applies the damage, then the debuff."
				local damageTable = {
					victim       = enemy,
					damage       = lucent_beam_ability:GetTalentSpecialValueFor("beam_damage"),
					damage_type  = lucent_beam_ability:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					attacker     = self:GetCaster(),
					ability      = lucent_beam_ability
				}

				ApplyDamage(damageTable)

				if self:GetCaster():HasTalent("special_bonus_unique_luna_5") then
					enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = self:GetCaster():FindTalentValue("special_bonus_unique_luna_5") * (1 - enemy:GetStatusResistance()) })
				end

				-- -- IMBAfication: Dark Moon
				-- if not enemy:IsAlive() and (not enemy.IsReincarnating or (enemy.IsReincarnating and not enemy:IsReincarnating())) then
				-- self.beams			= self.beams + self.dark_moon_additional_beams
				-- self.beams_scepter	= self.beams_scepter + self.dark_moon_additional_beams
				-- end
			end

			valid_targets = true

			break
		end
	end

	-- If there are no available targets around, just draw the Lucent Beam particle in some random location
	if not valid_targets then
		local random_location = RandomVector(RandomInt(0, self.radius))

		EmitSoundOnLocationWithCaster((self.target_position or self:GetParent():GetAbsOrigin()) + random_location, "Hero_Luna.Eclipse.NoTarget", self:GetCaster())

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_eclipse_impact_notarget.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(particle, 1, (self.target_position or self:GetParent():GetAbsOrigin()) + random_location)
		ParticleManager:SetParticleControl(particle, 5, (self.target_position or self:GetParent():GetAbsOrigin()) + random_location)
		ParticleManager:ReleaseParticleIndex(particle)
	end

	-- IMBAfication: Moonscraper

	-- I should have set these variables earlier but w/e
	if self:GetCaster():HasScepter() then
		self.think_interval = self.beam_interval_scepter
	else
		self.think_interval = self.beam_interval
	end

	for outer_beam = 0, self.moonscraper_beams - 1 do
		Timers:CreateTimer((outer_beam / self.moonscraper_beams) * self.think_interval, function()
			if self and self.IsNull and not self:IsNull() and self.GetParent and self:GetParent() and self:GetParent().IsNull and not self:GetParent():IsNull() and self.GetCaster and self:GetCaster().IsNull and not self:GetCaster():IsNull() then
				local beam_pos = GetGroundPosition(RotatePosition(self.cast_pos, QAngle(0, self.moonscraper_spread * outer_beam, 0), self.refraction_pos), nil)
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_eclipse_impact.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
				ParticleManager:SetParticleControl(particle, 1, beam_pos)
				ParticleManager:SetParticleControl(particle, 5, beam_pos)
				ParticleManager:SetParticleControl(particle, 60, Vector(RandomInt(0, 255), RandomInt(0, 255), RandomInt(0, 255)))
				ParticleManager:SetParticleControl(particle, 61, Vector(1, 0, 0))
				ParticleManager:ReleaseParticleIndex(particle)

				local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), beam_pos, nil, self.moonscraper_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

				for _, enemy in pairs(enemies) do
					if lucent_beam_ability then
						local damageTable = {
							victim       = enemy,
							damage       = lucent_beam_ability:GetTalentSpecialValueFor("beam_damage"),
							damage_type  = lucent_beam_ability:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE,
							attacker     = self:GetCaster(),
							ability      = lucent_beam_ability
						}

						ApplyDamage(damageTable)
					end
				end
			end
		end)
	end

	self.cast_pos = self.target_position or self:GetParent():GetAbsOrigin()
	self.refraction_pos = RotatePosition(self.cast_pos, QAngle(0, 10 * 8, 0), self.refraction_pos)

	-- Increase the total amount of beams fired by one
	self.beams_elapsed = self.beams_elapsed + 1

	-- Update stack count to let player know how many beams are left to that Eclipse
	if self:GetCaster():HasScepter() then
		self:SetStackCount(math.max(self.beams_scepter - self.beams_elapsed, 0))
	else
		self:SetStackCount(math.max(self.beams - self.beams_elapsed, 0))
	end
end

function modifier_imba_luna_eclipse:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE
	}
end

function modifier_imba_luna_eclipse:GetModifierProcAttack_BonusDamage_Pure()
	if IsServer() and not self.target_position and (self:GetCaster():HasAbility("imba_luna_lunar_blessing") or self:GetCaster():HasAbility("imba_luna_lunar_blessing_723")) then
		return self:GetCaster():FindAbilityByName("imba_luna_lunar_blessing"):GetSpecialValueFor("eclipse_pure_damage")
	end
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_luna_lucent_beam_cooldown", "components/abilities/heroes/hero_luna", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_luna_lucent_beam_cooldown = class({})

function modifier_special_bonus_imba_luna_lucent_beam_cooldown:IsHidden() return true end

function modifier_special_bonus_imba_luna_lucent_beam_cooldown:IsPurgable() return false end

function modifier_special_bonus_imba_luna_lucent_beam_cooldown:RemoveOnDeath() return false end

function imba_luna_lucent_beam:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_luna_lucent_beam_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_luna_lucent_beam_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_luna_lucent_beam_cooldown"), "modifier_special_bonus_imba_luna_lucent_beam_cooldown", {})
	end
end
