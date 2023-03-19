-- Editors:
--    Fudge: 23.08.2017 (Ravage)
--    AltiV, May 29th, 2019 (true IMBAfication)

LinkLuaModifier("modifier_imba_tidehunter_gush", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_gush_handler", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_gush_surf", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE) -- Was originally gonna make this a horizontal motion controller, but seeing how those tend to cancel other controllers out, I don't think this warrants that same power so it'll just be standard intervalthink updates

LinkLuaModifier("modifier_imba_tidehunter_kraken_shell", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_kraken_shell_backstroke", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_kraken_shell_greater_hardening", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_tidehunter_anchor_smash", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_anchor_smash_suppression", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_anchor_smash_handler", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_anchor_smash_throw", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_tidehunter_ravage_handler", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_ravage_creeping_wave", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_ravage_suggestive_compromise", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_generic_motion_controller", "components/modifiers/generic/modifier_generic_motion_controller", LUA_MODIFIER_MOTION_BOTH)

imba_tidehunter_gush                                    = class({})
modifier_imba_tidehunter_gush                           = class({})
modifier_imba_tidehunter_gush_handler                   = class({})
modifier_imba_tidehunter_gush_surf                      = class({})

imba_tidehunter_kraken_shell                            = class({})
modifier_imba_tidehunter_kraken_shell                   = class({})
modifier_imba_tidehunter_kraken_shell_backstroke        = class({})
modifier_imba_tidehunter_kraken_shell_greater_hardening = class({})

imba_tidehunter_anchor_smash                            = class({})
modifier_imba_tidehunter_anchor_smash                   = class({})
modifier_imba_tidehunter_anchor_smash_suppression       = class({})
modifier_imba_tidehunter_anchor_smash_handler           = class({})
modifier_imba_tidehunter_anchor_smash_throw             = class({})

modifier_imba_tidehunter_ravage_handler                 = class({})
modifier_imba_tidehunter_ravage_creeping_wave           = class({})
modifier_imba_tidehunter_ravage_suggestive_compromise   = class({})

----------
-- GUSH --
----------

function imba_tidehunter_gush:GetIntrinsicModifierName()
	return "modifier_imba_tidehunter_gush_handler"
end

function imba_tidehunter_gush:GetAbilityTextureName()
	if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_gush_handler", self:GetCaster()) < 3 then
		return "tidehunter_gush"
	else
		return "tidehunter_gush_filtration"
	end
end

function imba_tidehunter_gush:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else
		return tonumber(tostring(self.BaseClass.GetBehavior(self))) + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end

function imba_tidehunter_gush:GetCastRange(location, target)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCastRange(self, location, target)
	else
		return self:GetSpecialValueFor("cast_range_scepter")
	end
end

function imba_tidehunter_gush:OnSpellStart()
	self:GetCaster():EmitSound("Ability.GushCast")

	-- IMBAfication: Filtration System
	local gush_handler_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_tidehunter_gush_handler", self:GetCaster())
	local filtration_wave       = gush_handler_modifier:GetStackCount() >= self:GetSpecialValueFor("casts_before_filtration")

	-- Standard ability logic
	if self:GetCursorTarget() then
		local direction = (self:GetCursorTarget():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()

		local projectile =
		{
			Target            = self:GetCursorTarget(),
			Source            = self:GetCaster(),
			Ability           = self,
			EffectName        = "particles/units/heroes/hero_tidehunter/tidehunter_gush.vpcf",
			iMoveSpeed        = self:GetSpecialValueFor("projectile_speed"),
			vSourceLoc        = self:GetCaster():GetAbsOrigin(),
			bDrawsOnMinimap   = false,
			bDodgeable        = true,
			bIsAttack         = false,
			bVisibleToEnemies = true,
			bReplaceExisting  = false,
			flExpireTime      = GameRules:GetGameTime() + 10.0,
			bProvidesVision   = false,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2, -- Need to put the mouth?
			ExtraData         = {
				bScepter  = self:GetCaster():HasScepter(),
				bTargeted = true,
				speed     = self:GetSpecialValueFor("projectile_speed"),
				x         = direction.x,
				y         = direction.y,
				z         = direction.z,
				bFiltrate = filtration_wave
			}
		}

		ProjectileManager:CreateTrackingProjectile(projectile)
	end

	-- Scepter ability logic
	if self:GetCaster():HasScepter() then
		-- This "dummy" literally only exists to attach the gush travel sound to
		local gush_dummy = CreateModifierThinker(self:GetCaster(), self, nil, {}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
		gush_dummy:EmitSound("Hero_Tidehunter.Gush.AghsProjectile")

		-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
		if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
			self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
		end

		local direction = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized()

		local linear_projectile = {
			Ability          = self,
			EffectName       = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf", -- Might not do anything
			vSpawnOrigin     = self:GetCaster():GetAbsOrigin(),
			fDistance        = self:GetSpecialValueFor("cast_range_scepter") + GetCastRangeIncrease(self:GetCaster()),
			fStartRadius     = self:GetSpecialValueFor("aoe_scepter"),
			fEndRadius       = self:GetSpecialValueFor("aoe_scepter"),
			Source           = self:GetCaster(),
			bHasFrontalCone  = false,
			bReplaceExisting = false,
			iUnitTargetTeam  = DOTA_UNIT_TARGET_TEAM_BOTH, -- IMBAfication: Surf's Up!
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType  = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime      = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit     = true,
			vVelocity        = direction * self:GetSpecialValueFor("speed_scepter"),
			bProvidesVision  = false,
			ExtraData        =
			{
				bScepter   = true,
				bTargeted  = false,
				speed      = self:GetSpecialValueFor("speed_scepter"),
				x          = direction.x,
				y          = direction.y,
				z          = direction.z,
				bFiltrate  = filtration_wave,
				gush_dummy = gush_dummy:entindex(),
			}
		}

		self.projectile = ProjectileManager:CreateLinearProjectile(linear_projectile)
	end

	if not filtration_wave then
		gush_handler_modifier:IncrementStackCount()
	else
		gush_handler_modifier:SetStackCount(0)
	end
end

-- Make the travel sound follow the Gush
function imba_tidehunter_gush:OnProjectileThink_ExtraData(location, data)
	if not IsServer() then return end

	if data.gush_dummy then
		EntIndexToHScript(data.gush_dummy):SetAbsOrigin(location)
	end
end

function imba_tidehunter_gush:OnProjectileHit_ExtraData(target, location, data)
	if not IsServer() then return end

	-- Gush hit some unit
	if target then
		if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
			-- Trigger spell absorb if applicable
			if data.bTargeted == 1 and target:TriggerSpellAbsorb(self) then
				target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("shieldbreaker_stun") * (1 - target:GetStatusResistance()) })
				return nil
			end

			target:EmitSound("Ability.GushImpact")

			-- IMBAfication: Filtration System
			if data.bFiltrate == 1 then
				target:Purge(true, false, false, false, false)
			end

			-- Make the targeted gush not have any effects except for shield break if scepter (no double damage nuttiness)
			if not (data.bScepter == 1 and data.bTargeted == 1) then
				-- "Gush first applies the debuff, then the damage."
				target:AddNewModifier(self:GetCaster(), self, "modifier_imba_tidehunter_gush", { duration = self:GetDuration() * (1 - target:GetStatusResistance()) })

				-- "Provides 200 radius ground vision around each hit enemy for 2 seconds."
				if data.bScepter == 1 then
					self:CreateVisibilityNode(target:GetAbsOrigin(), 200, 2)
				end

				local damageTable = {
					victim       = target,
					damage       = self:GetTalentSpecialValueFor("gush_damage"),
					damage_type  = self:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					attacker     = self:GetCaster(),
					ability      = self
				}

				ApplyDamage(damageTable)

				if self:GetCaster():GetName() == "npc_dota_hero_tidehunter" and target:IsRealHero() and not target:IsAlive() and RollPercentage(25) then
					self:GetCaster():EmitSound("tidehunter_tide_ability_gush_0" .. RandomInt(1, 2))
				end
			end
		end

		-- IMBAfication: Surf's Up!
		if self:GetAutoCastState() and target ~= self:GetCaster() and (target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() or (target:GetTeamNumber() == self:GetCaster():GetTeamNumber())) then
			local surf_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_tidehunter_gush_surf",
				{
					duration = self:GetSpecialValueFor("surf_duration"),
					speed    = data.speed,
					x        = data.x,
					y        = data.y,
					z        = data.z,
				})

			if surf_modifier and target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				surf_modifier:SetDuration(self:GetSpecialValueFor("surf_duration") * (1 - target:GetStatusResistance()), true)
			end
		end
		-- Scepter Gush has reached its end location
	elseif data.gush_dummy then
		EntIndexToHScript(data.gush_dummy):StopSound("Hero_Tidehunter.Gush.AghsProjectile")
		EntIndexToHScript(data.gush_dummy):RemoveSelf()
	end
end

-------------------
-- GUSH MODIFIER --
-------------------

function modifier_imba_tidehunter_gush:GetEffectName()
	return "particles/units/heroes/hero_tidehunter/tidehunter_gush_slow.vpcf"
end

function modifier_imba_tidehunter_gush:GetStatusEffectName()
	return "particles/status_fx/status_effect_gush.vpcf"
end

function modifier_imba_tidehunter_gush:OnCreated()
	if self:GetAbility() then
		self.movement_speed = self:GetAbility():GetSpecialValueFor("movement_speed")
		self.negative_armor = self:GetAbility():GetTalentSpecialValueFor("negative_armor")
	else
		self:Destroy()
	end
end

function modifier_imba_tidehunter_gush:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tidehunter_gush:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return decFuncs
end

function modifier_imba_tidehunter_gush:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_speed
end

function modifier_imba_tidehunter_gush:GetModifierPhysicalArmorBonus()
	return self.negative_armor * (-1)
end

---------------------------
-- GUSH HANDLER MODIFIER --
---------------------------

function modifier_imba_tidehunter_gush_handler:IsHidden() return true end

function modifier_imba_tidehunter_gush_handler:IsPurgable() return false end

-- Grimstroke Soulbind exception (without this line the modifier disappears -_-)
function modifier_imba_tidehunter_gush_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

------------------------
-- GUSH SURF MODIFIER --
------------------------

function modifier_imba_tidehunter_gush_surf:OnCreated(params)
	if not IsServer() then return end

	if self:GetAbility() then
		self.speed          = params.speed
		self.direction      = Vector(params.x, params.y, params.z)
		self.surf_speed_pct = self:GetAbility():GetSpecialValueFor("surf_speed_pct")

		self:StartIntervalThink(FrameTime())
	else
		self:Destroy()
	end
end

function modifier_imba_tidehunter_gush_surf:OnRefresh(params)
	if not IsServer() then return end

	self:OnCreated(params)
end

function modifier_imba_tidehunter_gush_surf:OnIntervalThink()
	if not IsServer() then return end

	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin() + (self.direction * self.speed * self.surf_speed_pct / 100 * FrameTime()), false)
end

------------------
-- KRAKEN SHELL --
------------------

function imba_tidehunter_kraken_shell:GetIntrinsicModifierName()
	return "modifier_imba_tidehunter_kraken_shell"
end

function imba_tidehunter_kraken_shell:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
end

function imba_tidehunter_kraken_shell:OnSpellStart()
	self:GetCaster():Purge(false, true, false, true, true)

	local kraken_shell_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(kraken_shell_particle)

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_tidehunter_kraken_shell_backstroke", { duration = 3.6 })

	if self:GetCaster():HasTalent("special_bonus_imba_tidehunter_greater_hardening") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_tidehunter_kraken_shell_greater_hardening", { duration = self:GetCaster():FindTalentValue("special_bonus_imba_tidehunter_greater_hardening", "duration") })
	end
end

---------------------------
-- KRAKEN SHELL MODIFIER --
---------------------------

function modifier_imba_tidehunter_kraken_shell:IsHidden() return not (self:GetAbility() and self:GetAbility():GetLevel() >= 1) end

function modifier_imba_tidehunter_kraken_shell:OnCreated()
	if not IsServer() then return end

	self.reset_timer = GameRules:GetDOTATime(true, true)
	self:SetStackCount(0)

	self:StartIntervalThink(0.1)
end

-- This is to keep tracking of the damage reset interval
function modifier_imba_tidehunter_kraken_shell:OnIntervalThink()
	if not IsServer() then return end

	if GameRules:GetDOTATime(true, true) - self.reset_timer >= self:GetAbility():GetSpecialValueFor("damage_reset_interval") then
		self:SetStackCount(0)
		self.reset_timer = GameRules:GetDOTATime(true, true)
	end

	-- Calculate stat bonuses
	if not self.bInRiver and self:GetParent():GetAbsOrigin().z < 160 then
		self:GetParent():CalculateStatBonus(true)

		self.bInRiver = true
	elseif self.bInRiver and self:GetParent():GetAbsOrigin().z >= 160 then
		self:GetParent():CalculateStatBonus(true)

		self.bInRiver = false
	end
end

function modifier_imba_tidehunter_kraken_shell:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,

		MODIFIER_EVENT_ON_TAKEDAMAGE,

		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end

function modifier_imba_tidehunter_kraken_shell:GetModifierPhysical_ConstantBlock()
	return self:GetAbility():GetTalentSpecialValueFor("damage_reduction")
end

function modifier_imba_tidehunter_kraken_shell:OnTakeDamage(keys)
	if keys.unit == self:GetParent() and not keys.attacker:IsOther() and (keys.attacker:GetOwnerEntity() or keys.attacker.GetPlayerID) and not self:GetParent():PassivesDisabled() and not self:GetParent():IsIllusion() and self:GetAbility():IsTrained() then
		self:SetStackCount(self:GetStackCount() + keys.damage)
		self.reset_timer = GameRules:GetDOTATime(true, true)

		if self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("damage_cleanse") then
			self:GetParent():EmitSound("Hero_Tidehunter.KrakenShell")

			local kraken_shell_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN, self:GetParent())
			ParticleManager:ReleaseParticleIndex(kraken_shell_particle)

			self:GetParent():Purge(false, true, false, true, true)

			self:SetStackCount(0)

			if self:GetCaster():HasTalent("special_bonus_imba_tidehunter_greater_hardening") then
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_tidehunter_kraken_shell_greater_hardening", { duration = self:GetCaster():FindTalentValue("special_bonus_imba_tidehunter_greater_hardening", "duration") })
			end
		end
	end
end

function modifier_imba_tidehunter_kraken_shell:GetModifierBonusStats_Strength()
	if self:GetAbility() and self:GetParent():GetAbsOrigin().z < 160 and not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("aqueous_strength")
	end
end

function modifier_imba_tidehunter_kraken_shell:GetModifierHealthRegenPercentage()
	if self:GetAbility() and self:GetParent():GetAbsOrigin().z < 160 and not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("aqueous_heal")
	end
end

--------------------------------------
-- KRAKEN SHELL BACKSTROKE MODIFIER --
--------------------------------------

function modifier_imba_tidehunter_kraken_shell_backstroke:OnCreated()
	if self:GetAbility() then
		self.backstroke_movespeed    = self:GetAbility():GetSpecialValueFor("backstroke_movespeed")
		self.backstroke_statusresist = self:GetAbility():GetSpecialValueFor("backstroke_statusresist")
	else
		self:Destroy()
	end
end

function modifier_imba_tidehunter_kraken_shell_backstroke:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,

		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_imba_tidehunter_kraken_shell_backstroke:GetOverrideAnimation()
	--if self:GetParent():GetAbsOrigin().z < 160 then return ACT_DOTA_TAUNT end
	return ACT_DOTA_TAUNT
end

function modifier_imba_tidehunter_kraken_shell_backstroke:GetActivityTranslationModifiers()
	--if self:GetParent():GetAbsOrigin().z < 160 then return "backstroke_gesture" end
	return "backstroke_gesture"
end

function modifier_imba_tidehunter_kraken_shell_backstroke:GetModifierMoveSpeedBonus_Percentage()
	if self:GetParent():GetAbsOrigin().z >= 160 then
		return self.backstroke_movespeed
	else
		return self.backstroke_movespeed * 2
	end
end

function modifier_imba_tidehunter_kraken_shell_backstroke:GetModifierStatusResistanceStacking()
	if self:GetParent():GetAbsOrigin().z >= 160 then
		return self.backstroke_statusresist
	else
		return self.backstroke_statusresist * 2
	end
end

---------------------------------------------
-- KRAKEN SHELL GREATER HARDENING MODIFIER --
---------------------------------------------

function modifier_imba_tidehunter_kraken_shell_greater_hardening:OnCreated()
	self.value = self:GetCaster():FindTalentValue("special_bonus_imba_tidehunter_greater_hardening")

	if not IsServer() then return end

	self:IncrementStackCount()
end

function modifier_imba_tidehunter_kraken_shell_greater_hardening:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tidehunter_kraken_shell_greater_hardening:DeclareFunctions()
	return { MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS }
end

function modifier_imba_tidehunter_kraken_shell_greater_hardening:GetModifierMagicalResistanceBonus()
	return self:GetStackCount() * self.value
end

------------------
-- ANCHOR SMASH --
------------------

function imba_tidehunter_anchor_smash:GetCastRange(location, target)
	if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_anchor_smash_handler", self:GetCaster()) == 0 then
		return self.BaseClass.GetCastRange(self, location, target) - self:GetCaster():GetCastRangeBonus()
	else
		return self:GetSpecialValueFor("throw_range")
	end
end

function imba_tidehunter_anchor_smash:GetBehavior()
	if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_anchor_smash_handler", self:GetCaster()) == 0 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end

function imba_tidehunter_anchor_smash:GetAOERadius()
	if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_anchor_smash_handler", self:GetCaster()) == 0 then
		return 0
	else
		return self:GetSpecialValueFor("throw_radius")
	end
end

function imba_tidehunter_anchor_smash:GetIntrinsicModifierName()
	return "modifier_imba_tidehunter_anchor_smash_handler"
end

function imba_tidehunter_anchor_smash:OnSpellStart()
	if self:GetAutoCastState() then
		-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
		if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
			self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
		end

		self:GetCaster():EmitSound("Hero_ChaosKnight.idle_throw")

		local anchor_dummy = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_tidehunter_anchor_smash_throw",
			{
				x = self:GetCursorPosition().x,
				y = self:GetCursorPosition().y,
				z = self:GetCursorPosition().z
			}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)

		local linear_projectile = {
			Ability          = self,
			-- EffectName			= "nil"
			vSpawnOrigin     = self:GetCaster():GetAbsOrigin(),
			fDistance        = self:GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster()) + GetCastRangeIncrease(self:GetCaster()),
			fStartRadius     = self:GetSpecialValueFor("throw_radius"),
			fEndRadius       = self:GetSpecialValueFor("throw_radius"),
			Source           = self:GetCaster(),
			bHasFrontalCone  = false,
			bReplaceExisting = false,
			iUnitTargetTeam  = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType  = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime      = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit     = true,
			vVelocity        = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("throw_speed"),
			bProvidesVision  = false,
			ExtraData        = { anchor_dummy = anchor_dummy:entindex() }
		}

		ProjectileManager:CreateLinearProjectile(linear_projectile)
	else
		self:GetCaster():EmitSound("Hero_Tidehunter.AnchorSmash")

		local anchor_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_anchor_hero.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:ReleaseParticleIndex(anchor_particle)

		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false) -- IMBAfication: Sheer Force

		for _, enemy in pairs(enemies) do
			self:Smash(enemy)
		end
	end
end

function imba_tidehunter_anchor_smash:Smash(enemy, bThrown)
	if not enemy:IsRoshan() then
		if bThrown and enemy:IsConsideredHero() then
			self:GetCaster():EmitSound("Hero_Tidehunter.AnchorSmash")
		end

		-- The smash first applies the debuff, then the instant attack.
		if not enemy:IsMagicImmune() then
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_tidehunter_anchor_smash", { duration = self:GetSpecialValueFor("reduction_duration") * (1 - enemy:GetStatusResistance()) })
		end

		-- "These instant attacks are allowed to trigger attack modifiers, except cleave, normally. Has True Strike."
		-- So funny thing about this actually...the VANILLA ability ignores CUSTOM cleave suppression (ex. Jarnbjorn), which means Anchor Smash still applies custom cleaves anyways...so I guess in ways this is actually nerfing the ability but bleh
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_tidehunter_anchor_smash_suppression", {})
		-- PerformAttack(target: CDOTA_BaseNPC, useCastAttackOrb: bool, processProcs: bool, skipCooldown: bool, ignoreInvis: bool, useProjectile: bool, fakeAttack: bool, neverMiss: bool): nil
		self:GetCaster():PerformAttack(enemy, false, true, true, false, false, false, true)
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_imba_tidehunter_anchor_smash_suppression", self:GetCaster())

		-- IMBAfication: Angled
		if not bThrown then
			enemy:SetForwardVector(enemy:GetForwardVector() * (-1))
			enemy:FaceTowards(enemy:GetAbsOrigin() + enemy:GetForwardVector())
		end
	end
end

function imba_tidehunter_anchor_smash:OnProjectileThink_ExtraData(location, data)
	if not IsServer() then return end

	EntIndexToHScript(data.anchor_dummy):SetAbsOrigin(GetGroundPosition(location, nil))
end

function imba_tidehunter_anchor_smash:OnProjectileHit_ExtraData(target, location, data)
	if not IsServer() then return end

	-- Gush hit some unit
	if target then
		self:Smash(target, true)
	else
		EntIndexToHScript(data.anchor_dummy):RemoveSelf()
	end
end

---------------------------
-- ANCHOR SMASH MODIFIER --
---------------------------

function modifier_imba_tidehunter_anchor_smash:OnCreated()
	if self:GetAbility() then
		self.damage_reduction = self:GetAbility():GetTalentSpecialValueFor("damage_reduction")
	else
		self:Destroy()
	end
end

function modifier_imba_tidehunter_anchor_smash:OnRefresh()
	self:OnCreated()
end

function modifier_imba_tidehunter_anchor_smash:DeclareFunctions()
	return { MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE }
end

function modifier_imba_tidehunter_anchor_smash:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_reduction
end

---------------------------------------
-- ANCHOR SMASH SUPPRESSION MODIFIER --
---------------------------------------

-- I guess this will also be used for the bonus attack damage

function modifier_imba_tidehunter_anchor_smash_suppression:OnCreated()
	if self:GetAbility() then
		self.attack_damage = self:GetAbility():GetSpecialValueFor("attack_damage")
	else
		self:Destroy()
	end
end

-- MODIFIER_PROPERTY_SUPPRESS_CLEAVE does not work
function modifier_imba_tidehunter_anchor_smash_suppression:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SUPPRESS_CLEAVE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_imba_tidehunter_anchor_smash_suppression:GetModifierPreAttack_BonusDamage()
	return self.attack_damage
end

function modifier_imba_tidehunter_anchor_smash_suppression:GetSuppressCleave()
	return 1
end

-- Hopefully this is enough random information to only suppress cleaves?...
function modifier_imba_tidehunter_anchor_smash_suppression:GetModifierTotalDamageOutgoing_Percentage(keys)
	if not keys.no_attack_cooldown and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.damage_flags == DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION then
		return -100
	end
end

--------------------------
-- ANCHOR SMASH HANDLER --
--------------------------

function modifier_imba_tidehunter_anchor_smash_handler:IsHidden() return true end

function modifier_imba_tidehunter_anchor_smash_handler:IsPurgable() return false end

function modifier_imba_tidehunter_anchor_smash_handler:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ORDER }
end

function modifier_imba_tidehunter_anchor_smash_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end

	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

---------------------------------
-- ANCHOR SMASH THROW MODIFIER --
---------------------------------

function modifier_imba_tidehunter_anchor_smash_throw:OnCreated(params)
	if not IsServer() then return end

	local models = {
		"models/items/tidehunter/tidehunter_fish_skeleton_lod.vmdl",
		"models/items/tidehunter/tidehunter_mine_lod.vmdl",
		"models/items/tidehunter/ancient_leviathan_weapon/ancient_leviathan_weapon_fx.vmdl",
		"models/items/tidehunter/claddish_cudgel/claddish_cudgel.vmdl",
		"models/items/tidehunter/claddish_cudgel/claddish_cudgel_octopus.vmdl",
		"models/items/tidehunter/krakens_bane/krakens_bane.vmdl",
		"models/items/tidehunter/living_iceberg_collection_weapon/living_iceberg_collection_weapon.vmdl",
		--"models/items/tidehunter/ti_9_cache_tide_chelonia_mydas_off_hand/ti_9_cache_tide_chelonia_mydas_off_hand.vmdl",
		--"models/items/tidehunter/ti_9_cache_tide_chelonia_mydas_weapon/ti_9_cache_tide_chelonia_mydas_weapon.vmdl",
		--"models/items/tidehunter/ti_9_cache_tide_tidal_conqueror_off_hand/ti_9_cache_tide_tidal_conqueror_off_hand.vmdl",
		--"models/items/tidehunter/ti_9_cache_tide_tidal_conqueror_weapon/ti_9_cache_tide_tidal_conqueror_weapon.vmdl",
		"models/items/tidehunter/tidebreaker_weapon/tidebreaker_weapon.vmdl"
	}

	-- Some models are originally oriented in a different way, so they have to be flipped to look proper
	local models_rotate = {
		180,
		180,
		0,
		0,
		180,
		0,
		0,
		--180,
		--0,
		--180,
		--0,
		0
	}

	local randomSelection = RandomInt(1, #models)
	local cursorPosition = Vector(params.x, params.y, params.z)

	self.selected_model = models[randomSelection]
	self:GetParent():SetForwardVector(RotatePosition(Vector(0, 0, 0), QAngle(0, models_rotate[randomSelection], 0), ((cursorPosition - self:GetCaster():GetAbsOrigin()):Normalized())))
end

function modifier_imba_tidehunter_anchor_smash_throw:CheckState()
	return { [MODIFIER_STATE_NO_UNIT_COLLISION] = true }
end

function modifier_imba_tidehunter_anchor_smash_throw:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
end

function modifier_imba_tidehunter_anchor_smash_throw:GetModifierModelChange()
	return self.selected_model or "models/heroes/tidehunter/tidehunter_anchor.vmdl"
end

function modifier_imba_tidehunter_anchor_smash_throw:GetVisualZDelta()
	return 150
end

-----------------------------
------ 	   RAVAGE	  -------
-----------------------------
imba_tidehunter_ravage = imba_tidehunter_ravage or class({})

function imba_tidehunter_ravage:GetIntrinsicModifierName()
	return "modifier_imba_tidehunter_ravage_handler"
end

function imba_tidehunter_ravage:GetAOERadius()
	if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_ravage_handler", self:GetCaster()) == 0 then
		return self:GetSpecialValueFor("radius")
	else
		return self:GetSpecialValueFor("creeping_radius")
	end
end

function imba_tidehunter_ravage:GetCastRange(location, target)
	if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_ravage_handler", self:GetCaster()) == 0 then
		return self.BaseClass.GetCastRange(self, location, target)
	else
		return self:GetSpecialValueFor("creeping_range")
	end
end

function imba_tidehunter_ravage:GetBehavior()
	if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_ravage_handler", self:GetCaster()) == 0 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end

-- TODO: Destroy the knockback modifier after it's done
-- TODO: add a phased modifier for 0.5 secs
-- TODO: fix nyx stun animation too

function imba_tidehunter_ravage:OnSpellStart()
	if not self:GetAutoCastState() then
		-- Ability properties
		local caster              = self:GetCaster()
		local caster_pos          = caster:GetAbsOrigin()
		local cast_sound          = "Ability.Ravage"
		local hit_sound           = "Hero_Tidehunter.RavageDamage"
		local kill_responses      = "tidehunter_tide_ability_ravage_0"
		local particle            = "particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf"
		-- Ability parameters
		local end_radius          = self:GetSpecialValueFor("radius")
		local stun_duration       = self:GetSpecialValueFor("duration")
		local suggestive_duration = self:GetSpecialValueFor("suggestive_duration")

		-- Emit sound
		caster:EmitSound(cast_sound)

		-- Emit particle
		self.particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(self.particle_fx, 0, caster_pos)
		-- Set each ring in it's position
		for i = 1, 5 do
			ParticleManager:SetParticleControl(self.particle_fx, i, Vector(end_radius * 0.2 * i, 0, 0))
		end
		ParticleManager:ReleaseParticleIndex(self.particle_fx)

		local radius     = end_radius * 0.2
		local ring       = 1
		local ring_width = end_radius * 0.2
		local hit_units  = {}

		-- Find units in a ring 5 times and hit them with ravage
		Timers:CreateTimer(function()
			local enemies = FindUnitsInRing(caster:GetTeamNumber(),
				caster_pos,
				nil,
				ring * radius,
				radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				DOTA_DAMAGE_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)

			for _, enemy in pairs(enemies) do
				-- Custom function, checks if the unit was hit already
				if not CheckIfInTable(hit_units, enemy) then
					-- Emit hit sound
					enemy:EmitSound(hit_sound)

					-- Apply stun and air time modifiers
					enemy:AddNewModifier(caster, self, "modifier_stunned", { duration = stun_duration * (1 - enemy:GetStatusResistance()) })

					-- Knock the enemy into the air
					local knockback =
					{
						knockback_duration = 0.5 * (1 - enemy:GetStatusResistance()),
						duration = 0.5 * (1 - enemy:GetStatusResistance()),
						knockback_distance = 0,
						knockback_height = 350,
					}
					enemy:RemoveModifierByName("modifier_knockback")
					enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)

					-- IMBAfication: Suggestive Compromise
					enemy:AddNewModifier(caster, self, "modifier_imba_tidehunter_ravage_suggestive_compromise", { duration = suggestive_duration * (1 - enemy:GetStatusResistance()) })

					Timers:CreateTimer(0.5, function()
						-- Apply damage
						local damageTable = {
							victim = enemy,
							damage = self:GetAbilityDamage(),
							damage_type = self:GetAbilityDamageType(),
							attacker = caster,
							ability = self
						}
						ApplyDamage(damageTable)

						-- Check if the enemy is a dead hero, if he is, emit kill response
						if not enemy:IsAlive() and enemy:IsHero() and RollPercentage(25) and caster:GetName() == "npc_dota_hero_tidehunter" then
							caster:EmitSound(kill_responses .. RandomInt(1, 2))
						end

						-- We need to do this because the gesture takes it's fucking time to stop
						enemy:RemoveGesture(ACT_DOTA_FLAIL)
					end)

					-- Mark the enemy as hit to not get hit again
					table.insert(hit_units, enemy)
				end
			end

			-- Send the next ring
			if ring < 5 then
				ring = ring + 1
				return 0.2
			end
		end)
	else
		local stun_duration   = self:GetSpecialValueFor("duration")

		local creeping_range  = self:GetSpecialValueFor("creeping_range")
		local creeping_radius = self:GetSpecialValueFor("creeping_radius")

		local waves           = (creeping_range / creeping_radius / 2)
		local counter         = 0
		local total_time      = 1.38 -- This is the duration for the vanilla ability so let's use that too

		-- Need to save this variable as it's going to be repeatedly used within the timer
		local caster_pos      = self:GetCaster():GetAbsOrigin()
		local forward_vec     = (self:GetCursorPosition() - caster_pos):Normalized()

		Timers:CreateTimer(function()
			CreateModifierThinker(self:GetCaster(), self, "modifier_imba_tidehunter_ravage_creeping_wave", {
					duration            = 0.3, -- Kinda arbitrary but only want to show one wave of tentacles and not all five
					damage              = self:GetAbilityDamage(),
					stun_duration       = stun_duration,
					creeping_radius     = creeping_radius,
					suggestive_duration = self:GetSpecialValueFor("suggestive_duration")
				},
				caster_pos + (forward_vec * counter * creeping_radius * 2 * ((creeping_range + GetCastRangeIncrease(self:GetCaster())) / creeping_range)), self:GetCaster():GetTeamNumber(), false)

			counter = counter + 1

			if counter <= waves then
				return total_time / waves
			end
		end)
	end
end

-----------------------------
-- RAVAGE HANDLER MODIFIER --
-----------------------------

function modifier_imba_tidehunter_ravage_handler:IsHidden() return true end

function modifier_imba_tidehunter_ravage_handler:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
end

function modifier_imba_tidehunter_ravage_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end

	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

function modifier_imba_tidehunter_ravage_handler:GetActivityTranslationModifiers()
	if RollPercentage and RollPercentage(50) then
		return "belly_flop"
	end
end

-----------------------------------
-- RAVAGE CREEPING WAVE MODIFIER --
-----------------------------------

function modifier_imba_tidehunter_ravage_creeping_wave:OnCreated(params)
	if not IsServer() then return end

	self.stun_duration   = params.stun_duration
	self.creeping_radius = params.creeping_radius

	local ability        = self:GetAbility()
	local caster         = self:GetCaster()
	local damage         = params.damage
	local damage_type    = self:GetAbility():GetAbilityDamageType()

	self:GetParent():EmitSound("Ability.Ravage")

	self.ravage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(self.ravage_particle, 0, self:GetParent():GetAbsOrigin())
	for i = 1, 5 do
		ParticleManager:SetParticleControl(self.ravage_particle, i, Vector(self.creeping_radius, 0, 0))
	end

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.creeping_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, enemy in pairs(enemies) do
		-- Emit hit sound
		enemy:EmitSound("Hero_Tidehunter.RavageDamage")

		local hit_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage_hit.vpcf", PATTACH_ABSORIGIN, enemy)
		ParticleManager:SetParticleControl(hit_particle, 0, GetGroundPosition(enemy:GetAbsOrigin(), nil))
		ParticleManager:ReleaseParticleIndex(hit_particle)

		-- Apply stun and air time modifiers
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = self.stun_duration * (1 - enemy:GetStatusResistance()) })

		-- Knock the enemy into the air
		local knockback =
		{
			knockback_duration = 0.5 * (1 - enemy:GetStatusResistance()),
			duration           = 0.5 * (1 - enemy:GetStatusResistance()),
			knockback_distance = 0,
			knockback_height   = 350,
		}

		enemy:RemoveModifierByName("modifier_knockback")
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_knockback", knockback)

		-- IMBAfication: Suggestive Compromise
		enemy:AddNewModifier(self:GetCaster(), ability, "modifier_imba_tidehunter_ravage_suggestive_compromise", { duration = params.suggestive_duration * (1 - enemy:GetStatusResistance()) })

		Timers:CreateTimer(0.5, function()
			-- Apply damage
			local damageTable =
			{
				victim       = enemy,
				damage       = damage,
				damage_type  = damage_type,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = caster,
				ability      = ability
			}
			ApplyDamage(damageTable)

			if caster:GetName() == "npc_dota_hero_tidehunter" and not enemy:IsAlive() and enemy:IsRealHero() and RollPercentage(25) then
				caster:EmitSound("tidehunter_tide_ability_ravage_0" .. RandomInt(1, 2))
			end
		end)
	end
end

function modifier_imba_tidehunter_ravage_creeping_wave:OnDestroy()
	if not IsServer() then return end

	ParticleManager:DestroyParticle(self.ravage_particle, false)
	ParticleManager:ReleaseParticleIndex(self.ravage_particle)
	self:GetParent():RemoveSelf()
end

-------------------------------------------
-- RAVAGE SUGGESTIVE COMPROMISE MODIFIER --
-------------------------------------------

function modifier_imba_tidehunter_ravage_suggestive_compromise:IsPurgable() return false end

function modifier_imba_tidehunter_ravage_suggestive_compromise:GetEffectName()
	return "particles/units/heroes/hero_monkey_king/monkey_king_jump_armor_debuff_model.vpcf"
end

function modifier_imba_tidehunter_ravage_suggestive_compromise:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_tidehunter_ravage_suggestive_compromise:OnCreated()
	self.suggestive_armor_reduction = self:GetAbility():GetSpecialValueFor("suggestive_armor_reduction") * (-1)
end

function modifier_imba_tidehunter_ravage_suggestive_compromise:DeclareFunctions()
	return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end

function modifier_imba_tidehunter_ravage_suggestive_compromise:GetModifierPhysicalArmorBonus()
	return self.suggestive_armor_reduction
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_tidehunter_anchor_smash_damage_reduction", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_tidehunter_greater_hardening", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_tidehunter_gush_armor", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_tidehunter_anchor_smash_damage_reduction = modifier_special_bonus_imba_tidehunter_anchor_smash_damage_reduction or class({})
modifier_special_bonus_imba_tidehunter_greater_hardening             = modifier_special_bonus_imba_tidehunter_greater_hardening or class({})
modifier_special_bonus_imba_tidehunter_gush_armor                    = modifier_special_bonus_imba_tidehunter_gush_armor or class({})

function modifier_special_bonus_imba_tidehunter_anchor_smash_damage_reduction:IsHidden() return true end

function modifier_special_bonus_imba_tidehunter_anchor_smash_damage_reduction:IsPurgable() return false end

function modifier_special_bonus_imba_tidehunter_anchor_smash_damage_reduction:RemoveOnDeath() return false end

function modifier_special_bonus_imba_tidehunter_greater_hardening:IsHidden() return true end

function modifier_special_bonus_imba_tidehunter_greater_hardening:IsPurgable() return false end

function modifier_special_bonus_imba_tidehunter_greater_hardening:RemoveOnDeath() return false end

function modifier_special_bonus_imba_tidehunter_gush_armor:IsHidden() return true end

function modifier_special_bonus_imba_tidehunter_gush_armor:IsPurgable() return false end

function modifier_special_bonus_imba_tidehunter_gush_armor:RemoveOnDeath() return false end

function imba_tidehunter_gush:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_tidehunter_gush_armor") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_tidehunter_gush_armor") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_tidehunter_gush_armor"), "modifier_special_bonus_imba_tidehunter_gush_armor", {})
	end
end

function imba_tidehunter_kraken_shell:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_tidehunter_greater_hardening") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_tidehunter_greater_hardening") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_tidehunter_greater_hardening"), "modifier_special_bonus_imba_tidehunter_greater_hardening", {})
	end
end

function imba_tidehunter_anchor_smash:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_tidehunter_anchor_smash_damage_reduction") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_tidehunter_anchor_smash_damage_reduction") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_tidehunter_anchor_smash_damage_reduction"), "modifier_special_bonus_imba_tidehunter_anchor_smash_damage_reduction", {})
	end
end
