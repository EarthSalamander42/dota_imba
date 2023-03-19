-- Creator:
--	   AltiV, January 20th, 2020

LinkLuaModifier("modifier_imba_brewmaster_thunder_clap", "components/abilities/heroes/hero_brewmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_thunder_clap_conductive_thinker", "components/abilities/heroes/hero_brewmaster", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_brewmaster_cinder_brew", "components/abilities/heroes/hero_brewmaster", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_brewmaster_drunken_brawler_passive", "components/abilities/heroes/hero_brewmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_drunken_brawler_crit_cooldown", "components/abilities/heroes/hero_brewmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_drunken_brawler_miss_cooldown", "components/abilities/heroes/hero_brewmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_drunken_brawler", "components/abilities/heroes/hero_brewmaster", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_brewmaster_primal_split", "components/abilities/heroes/hero_brewmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_primal_split_split_delay", "components/abilities/heroes/hero_brewmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_primal_split_duration", "components/abilities/heroes/hero_brewmaster", LUA_MODIFIER_MOTION_NONE)

imba_brewmaster_thunder_clap                             = imba_brewmaster_thunder_clap or class({})
modifier_imba_brewmaster_thunder_clap                    = modifier_imba_brewmaster_thunder_clap or class({})
modifier_imba_brewmaster_thunder_clap_conductive_thinker = modifier_imba_brewmaster_thunder_clap_conductive_thinker or class({})

imba_brewmaster_cinder_brew                              = imba_brewmaster_cinder_brew or class({})
modifier_imba_brewmaster_cinder_brew                     = modifier_imba_brewmaster_cinder_brew or class({})
modifier_imba_brewmaster_cinder_brew_thinker             = modifier_imba_brewmaster_cinder_brew_thinker or class({})
modifier_imba_brewmaster_cinder_brew_thinker_aura        = modifier_imba_brewmaster_cinder_brew_thinker_aura or class({})

imba_brewmaster_drunken_brawler                          = imba_brewmaster_drunken_brawler or class({})
modifier_imba_brewmaster_drunken_brawler_passive         = modifier_imba_brewmaster_drunken_brawler_passive or class({})
modifier_imba_brewmaster_drunken_brawler_crit_cooldown   = modifier_imba_brewmaster_drunken_brawler_crit_cooldown or class({})
modifier_imba_brewmaster_drunken_brawler_miss_cooldown   = modifier_imba_brewmaster_drunken_brawler_miss_cooldown or class({})
modifier_imba_brewmaster_drunken_brawler                 = modifier_imba_brewmaster_drunken_brawler or class({})

imba_brewmaster_primal_split                             = imba_brewmaster_primal_split or class({})
modifier_imba_brewmaster_primal_split                    = modifier_imba_brewmaster_primal_split or class({})
modifier_imba_brewmaster_primal_split_split_delay        = modifier_imba_brewmaster_primal_split_split_delay or class({})
modifier_imba_brewmaster_primal_split_duration           = modifier_imba_brewmaster_primal_split_duration or class({})

imba_brewmaster_primal_unison                            = imba_brewmaster_primal_unison or class({})

----------------------------------
-- IMBA_BREWMASTER_THUNDER_CLAP --
----------------------------------

function imba_brewmaster_thunder_clap:GetCastRange(location, target)
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

function imba_brewmaster_thunder_clap:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Brewmaster.ThunderClap")

	local clap_particle = ParticleManager:CreateParticle("particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_elixir.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(clap_particle, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius")))
	ParticleManager:ReleaseParticleIndex(clap_particle)

	-- Initialize variable to deal with whether or not to apply hero or creep duration
	local slow_duration = nil

	local debris_targets = 0

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius") + self:GetSpecialValueFor("debris_buffer_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		-- Multiplying the unit distance by Vector(1, 1, 0) to account for some verticality exceptions (this might also need to be done in some of the older files...)
		if ((enemy:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()) * Vector(1, 1, 0)):Length2D() <= self:GetSpecialValueFor("radius") then
			enemy:EmitSound("Hero_Brewmaster.ThunderClap.Target")

			if self:GetCaster():GetName() == "npc_dota_hero_brewmaster" and RollPercentage(75) then
				if not self.responses then
					self.responses = {
						"brewmaster_brew_ability_thunderclap_01",
						"brewmaster_brew_ability_thunderclap_02",
						"brewmaster_brew_ability_thunderclap_03",
						"brewmaster_brew_ability_primalsplit_02",
						"brewmaster_brew_ability_primalsplit_03",
					}
				end

				self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
			end

			if enemy:IsHero() then
				slow_duration = self:GetTalentSpecialValueFor("duration")
			else
				slow_duration = self:GetTalentSpecialValueFor("duration_creeps")
			end

			-- "The clap first applies the debuff, then the damage."
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_brewmaster_thunder_clap", { duration = slow_duration * (1 - enemy:GetStatusResistance()) })

			ApplyDamage({
				victim       = enemy,
				damage       = self:GetSpecialValueFor("damage"),
				damage_type  = self:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = self:GetCaster(),
				ability      = self
			})
			-- IMBAfication: Mind the Debris
		elseif debris_targets <= self:GetSpecialValueFor("debris_max_targets") then
			debris_targets = debris_targets + 1

			-- Going to be comprehensive on the available options here since most other sources don't include them (referring to https://dota-data.netlify.com/vscripts/ProjectileManager/#CreateTrackingProjectile)
			ProjectileManager:CreateTrackingProjectile({
				EffectName        = "particles/units/heroes/hero_brewmaster/brewmaster_hurl_boulder.vpcf",
				Ability           = self,
				-- Source				= self:GetCaster(),
				Source            = GetGroundPosition(self:GetCaster():GetAbsOrigin() + (enemy:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("radius"), nil),
				vSourceLoc        = GetGroundPosition(self:GetCaster():GetAbsOrigin() + (enemy:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("radius"), nil), -- Does this have to be the same as Source? IDK
				Target            = enemy,
				iMoveSpeed        = self:GetSpecialValueFor("debris_projectile_speed"),
				flExpireTime      = GameRules:GetGameTime() + self:GetSpecialValueFor("debris_expiry_time"),
				bDodgeable        = true,
				bIsAttack         = false,
				bReplaceExisting  = false,
				iSourceAttachment = nil,
				bDrawsOnMinimap   = nil,
				bVisibleToEnemies = true,
				bProvidesVision   = false,
				iVisionRadius     = nil,
				iVisionTeamNumber = nil,
				ExtraData         = {}
			})
		end
	end
end

function imba_brewmaster_thunder_clap:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target and not target:IsMagicImmune() then
		target:EmitSound("Brewmaster_Earth.Boulder.Target")

		target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("debris_stun_duration") * (1 - target:GetStatusResistance()) })

		ApplyDamage({
			victim       = target,
			damage       = self:GetSpecialValueFor("debris_damage"),
			damage_type  = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self:GetCaster(),
			ability      = self
		})
	end
end

-------------------------------------------
-- MODIFIER_IMBA_BREWMASTER_THUNDER_CLAP --
-------------------------------------------

function modifier_imba_brewmaster_thunder_clap:GetStatusEffectName()
	return "particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf"
end

function modifier_imba_brewmaster_thunder_clap:OnCreated()
	self.movement_slow          = self:GetAbility():GetSpecialValueFor("movement_slow") * (-1)
	self.attack_speed_slow      = self:GetAbility():GetSpecialValueFor("attack_speed_slow") * (-1)

	self.conduction_chance      = self:GetAbility():GetSpecialValueFor("conduction_chance")
	self.conduction_max_targets = self:GetAbility():GetSpecialValueFor("conduction_max_targets")
	self.conduction_damage      = self:GetAbility():GetSpecialValueFor("conduction_damage")
	self.conduction_distance    = self:GetAbility():GetSpecialValueFor("conduction_distance")
	self.conduction_interval    = self:GetAbility():GetSpecialValueFor("conduction_interval")
end

function modifier_imba_brewmaster_thunder_clap:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,

		-- IMBAfication: Celebratory Conduction
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_imba_brewmaster_thunder_clap:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow
end

function modifier_imba_brewmaster_thunder_clap:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_slow
end

function modifier_imba_brewmaster_thunder_clap:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and not keys.target:IsMagicImmune() and RollPseudoRandom(self.conduction_chance, self) then
		CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_imba_brewmaster_thunder_clap_conductive_thinker", {
			starting_unit_entindex = self:GetParent():entindex(),
			conduction_max_targets = self.conduction_max_targets,
			conduction_damage      = self.conduction_damage,
			conduction_distance    = self.conduction_distance,
			conduction_interval    = self.conduction_interval
		}, keys.attacker:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	end
end

--------------------------------------------------------------
-- MODIFIER_IMBA_BREWMASTER_THUNDER_CLAP_CONDUCTIVE_THINKER --
--------------------------------------------------------------

function modifier_imba_brewmaster_thunder_clap_conductive_thinker:OnCreated(keys)
	if not IsServer() then return end

	self.starting_unit_entindex = keys.starting_unit_entindex
	self.conduction_max_targets = keys.conduction_max_targets
	self.conduction_damage      = keys.conduction_damage
	self.conduction_distance    = keys.conduction_distance
	self.conduction_interval    = keys.conduction_interval

	self.units_affected         = {}
	self.unit_counter           = 0

	-- Include the unit that initiated the Celebratory Conudction, although they will not actually take damage from it
	if EntIndexToHScript(self.starting_unit_entindex) then
		self.current_unit                      = EntIndexToHScript(self.starting_unit_entindex)
		self.units_affected[self.current_unit] = true
	else
		self:Destroy()
		return
	end

	self:OnIntervalThink()
	self:StartIntervalThink(self.conduction_interval)
end

function modifier_imba_brewmaster_thunder_clap_conductive_thinker:OnIntervalThink()
	self.zapped = false

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.current_unit:GetAbsOrigin(), nil, self.conduction_distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)) do
		if not self.units_affected[enemy] then
			enemy:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")

			self.zap_particle = ParticleManager:CreateParticle("particles/econ/events/ti6/maelstorm_ti6.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
			ParticleManager:SetParticleControlEnt(self.zap_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.zap_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.zap_particle, 2, Vector(10, 10, 10))
			ParticleManager:ReleaseParticleIndex(self.zap_particle)

			self.unit_counter                      = self.unit_counter + 1
			self.current_unit                      = enemy
			self.units_affected[self.current_unit] = true
			self.zapped                            = true

			ApplyDamage({
				victim       = enemy,
				damage       = self.conduction_damage,
				damage_type  = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = self:GetCaster(),
				ability      = self:GetAbility()
			})

			break
		end
	end

	if self.unit_counter >= self.conduction_max_targets or not self.zapped then
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end

---------------------------------
-- IMBA_BREWMASTER_CINDER_BREW --
---------------------------------

function imba_brewmaster_cinder_brew:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_brewmaster_cinder_brew:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Brewmaster.CinderBrew.Cast")

	local brew_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(brew_particle, 1, self:GetCursorPosition())
	ParticleManager:ReleaseParticleIndex(brew_particle)

	if self:GetCaster():GetName() == "npc_dota_hero_brewmaster" then
		if not self.responses then
			self.responses = {
				"brewmaster_brew_ability_drukenhaze_01",
				"brewmaster_brew_ability_drukenhaze_02",
				"brewmaster_brew_ability_drukenhaze_03",
				"brewmaster_brew_ability_drukenhaze_04",
				"brewmaster_brew_ability_drukenhaze_05",
				"brewmaster_brew_ability_drukenhaze_08"
			}
		end

		self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
	end

	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	-- Set up projectile table to track both the final projectile location as well as any hit enemies along the wave
	if not self.projectiles then
		self.projectiles = {}
	end

	--"Cinder Brew's projectile travels at a speed of 1600."
	local brew_projectile = ProjectileManager:CreateLinearProjectile({
		EffectName        = "",
		Ability           = self,
		Source            = self:GetCaster(),
		vSpawnOrigin      = self:GetCaster():GetAbsOrigin(),
		vVelocity         = ((self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()) * Vector(1, 1, 0)):Normalized() * 1600,
		vAcceleration     = nil, --hmm...
		fMaxSpeed         = nil, -- What's the default on this thing?
		fDistance         = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Length2D(),
		fStartRadius      = self:GetSpecialValueFor("radius"),
		fEndRadius        = self:GetSpecialValueFor("radius"),
		fExpireTime       = nil,
		iUnitTargetTeam   = DOTA_UNIT_TARGET_TEAM_BOTH,
		iUnitTargetFlags  = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType   = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bIgnoreSource     = true,
		bHasFrontalCone   = false,
		bDrawsOnMinimap   = false,
		bVisibleToEnemies = true,
		bProvidesVision   = false,
		iVisionRadius     = nil,
		iVisionTeamNumber = nil,
		ExtraData         = {}
	})

	self.projectiles[brew_projectile] = {}
	self.projectiles[brew_projectile]["destination"] = self:GetCursorPosition()
end

-- Due to some weird logic detailed in the wiki where this doesn't work as a simple "apply immediately to all enemies upon projectile land" but rather like a wave that gradually affects units but only if they're within a radius, going to use a thinker
function imba_brewmaster_cinder_brew:OnProjectileThinkHandle(projectileHandle)
	for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), ProjectileManager:GetLinearProjectileLocation(projectileHandle), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		-- Check if the projectile, the unit, and the final destination radius are all overlapping or not
		if self.projectiles[projectileHandle]["destination"] and ((self.projectiles[projectileHandle]["destination"] - ProjectileManager:GetLinearProjectileLocation(projectileHandle)) * Vector(1, 1, 0)):Length2D() <= self:GetSpecialValueFor("radius") and ((unit:GetAbsOrigin() - ProjectileManager:GetLinearProjectileLocation(projectileHandle)) * Vector(1, 1, 0)):Length2D() <= self:GetSpecialValueFor("radius") and not self.projectiles[projectileHandle][unit:entindex()] then
			self.projectiles[projectileHandle][unit:entindex()] = true

			if unit:IsHero() then
				unit:EmitSound("Hero_Brewmaster.CinderBrew.Target")
			else
				unit:EmitSound("Hero_Brewmaster.CinderBrew.Target.Creep")
			end

			if unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				-- IMBAfication: Alcohol Wash
				unit:Purge(true, false, false, false, false)

				unit:AddNewModifier(self:GetCaster(), self, "modifier_imba_brewmaster_cinder_brew", { duration = self:GetSpecialValueFor("duration") * (1 - unit:GetStatusResistance()) })
			elseif self:GetCaster():HasScepter() then
				local splash_particle = ParticleManager:CreateParticle("particles/econ/events/ti9/blink_dagger_ti9_start_lvl2_splash.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
				ParticleManager:ReleaseParticleIndex(splash_particle)

				unit:Purge(false, true, false, true, true)
			end
		end
	end
end

function imba_brewmaster_cinder_brew:OnProjectileHitHandle(target, location, projectileHandle)
	if not target and location then
		EmitSoundOnLocationWithCaster(location, "Hero_Brewmaster.CinderBrew", self:GetCaster())

		for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			if not self.projectiles[projectileHandle][unit:entindex()] then
				self.projectiles[projectileHandle][unit:entindex()] = true

				if unit:IsHero() then
					unit:EmitSound("Hero_Brewmaster.CinderBrew.Target")
				else
					unit:EmitSound("Hero_Brewmaster.CinderBrew.Target.Creep")
				end

				if unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
					-- IMBAfication: Alcohol Wash
					unit:Purge(true, false, false, false, false)

					unit:AddNewModifier(self:GetCaster(), self, "modifier_imba_brewmaster_cinder_brew", { duration = self:GetSpecialValueFor("duration") * (1 - unit:GetStatusResistance()) })
				elseif self:GetCaster():HasScepter() then
					local splash_particle = ParticleManager:CreateParticle("particles/econ/events/ti9/blink_dagger_ti9_start_lvl2_splash.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
					ParticleManager:ReleaseParticleIndex(splash_particle)

					unit:Purge(false, true, false, true, true)
				end
			end
		end

		self.projectiles[projectileHandle] = nil
		self.brew_modifier = nil
	end
end

------------------------------------------
-- MODIFIER_IMBA_BREWMASTER_CINDER_BREW --
------------------------------------------

function modifier_imba_brewmaster_cinder_brew:GetEffectName()
	return "particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_debuff.vpcf"
end

function modifier_imba_brewmaster_cinder_brew:GetStatusEffectName()
	return "particles/status_fx/status_effect_brewmaster_cinder_brew.vpcf"
end

-- When did this line become mandatory?...
function modifier_imba_brewmaster_cinder_brew:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_imba_brewmaster_cinder_brew:OnCreated()
	self.total_damage = self:GetAbility():GetSpecialValueFor("total_damage")
	self.movement_slow = self:GetAbility():GetSpecialValueFor("movement_slow") * (-1)
	self.extra_duration = self:GetAbility():GetSpecialValueFor("extra_duration")
	self.remnants_self_damage_chance = self:GetAbility():GetSpecialValueFor("remnants_self_damage_chance")

	if not IsServer() then return end

	self.damage_type = self:GetAbility():GetAbilityDamageType()
end

-- This only runs if the target is ignited
function modifier_imba_brewmaster_cinder_brew:OnIntervalThink()
	ApplyDamage({
		victim       = self:GetParent(),
		damage       = self.damage_per_instance,
		damage_type  = self.damage_type,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		attacker     = self:GetCaster(),
		ability      = self:GetAbility()
	})

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage_per_instance, nil)
end

function modifier_imba_brewmaster_cinder_brew:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,

		-- IMBAfication: Remnants of Cinder Brew
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_imba_brewmaster_cinder_brew:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow
end

function modifier_imba_brewmaster_cinder_brew:OnTakeDamage(keys)
	if keys.unit == self:GetParent() and not self.bIgnited and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
		self.bIgnited = true

		self:GetParent():EmitSound("Hero_BrewMaster.CinderBrew.Ignite")

		local burn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_drunkenbrawler_crit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(burn_particle, false, false, -1, false, false)
		self:SetDuration(self:GetRemainingTime() + self.extra_duration, true)

		-- "The damage interval is based on the debuff's duration, so that it always deals 8 instances of damage."
		self.damage_per_instance = self.total_damage / 8
		self.tick_interval       = self:GetDuration() / 8

		self:StartIntervalThink(self.tick_interval)
	end
end

function modifier_imba_brewmaster_cinder_brew:GetModifierTotalDamageOutgoing_Percentage(keys)
	if self.bIgnited and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and RollPseudoRandom(self.remnants_self_damage_chance, self) then
		self:GetParent():EmitSound("Hero_BrewMaster.CinderBrew.SelfAttack")

		self.self_attack_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_self_attack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.self_attack_particle)

		self.self_damage = ApplyDamage({
			victim       = self:GetParent(),
			damage       = keys.original_damage,
			damage_type  = keys.damage_type,
			damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_REFLECTION,
			attacker     = self:GetParent(),
			ability      = self:GetAbility()
		})

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_OUTGOING_DAMAGE, self:GetParent(), self.self_damage, nil)

		return -100
	end
end

function modifier_imba_brewmaster_cinder_brew:OnTooltip()
	return self.remnants_self_damage_chance
end

-------------------------------------
-- IMBA_BREWMASTER_DRUNKEN_BRAWLER --
-------------------------------------

function imba_brewmaster_drunken_brawler:GetIntrinsicModifierName()
	return "modifier_imba_brewmaster_drunken_brawler_passive"
end

function imba_brewmaster_drunken_brawler:GetAbilityTextureName()
	if not self:GetCaster():HasModifier("modifier_imba_brewmaster_drunken_brawler_crit_cooldown") and not self:GetCaster():HasModifier("modifier_imba_brewmaster_drunken_brawler_miss_cooldown") then
		return "brewmaster/drunken_brawler_both"
	elseif not self:GetCaster():HasModifier("modifier_imba_brewmaster_drunken_brawler_crit_cooldown") and self:GetCaster():HasModifier("modifier_imba_brewmaster_drunken_brawler_miss_cooldown") then
		return "brewmaster/drunken_brawler_crit"
	elseif self:GetCaster():HasModifier("modifier_imba_brewmaster_drunken_brawler_crit_cooldown") and not self:GetCaster():HasModifier("modifier_imba_brewmaster_drunken_brawler_miss_cooldown") then
		return "brewmaster/drunken_brawler_miss"
	else
		return "brewmaster_drunken_brawler"
	end
end

function imba_brewmaster_drunken_brawler:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Brewmaster.Brawler.Cast")

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_brewmaster_drunken_brawler", { duration = self:GetSpecialValueFor("duration") })
end

------------------------------------------------------
-- MODIFIER_IMBA_BREWMASTER_DRUNKEN_BRAWLER_PASSIVE --
------------------------------------------------------

function modifier_imba_brewmaster_drunken_brawler_passive:IsHidden() return true end

function modifier_imba_brewmaster_drunken_brawler_passive:IsPurgable() return false end

function modifier_imba_brewmaster_drunken_brawler_passive:RemoveOnDeath() return false end

function modifier_imba_brewmaster_drunken_brawler_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,

		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_FAIL
	}
end

function modifier_imba_brewmaster_drunken_brawler_passive:GetModifierPreAttack_CriticalStrike()
	if self:GetAbility() then
		if not self:GetParent():HasModifier("modifier_imba_brewmaster_drunken_brawler_crit_cooldown") and not self:GetParent():HasModifier("modifier_imba_brewmaster_drunken_brawler") then
			self.bCrit = true
			return self:GetAbility():GetSpecialValueFor("crit_multiplier")
		else
			self.bCrit = false
		end
	end
end

function modifier_imba_brewmaster_drunken_brawler_passive:GetModifierEvasion_Constant()
	if self:GetAbility() and not self:GetParent():HasModifier("modifier_imba_brewmaster_drunken_brawler_miss_cooldown") and not self:GetParent():HasModifier("modifier_imba_brewmaster_drunken_brawler") then
		return 100
	end
end

function modifier_imba_brewmaster_drunken_brawler_passive:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and self.bCrit then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_brewmaster_drunken_brawler_crit_cooldown", { duration = self:GetAbility():GetSpecialValueFor("certain_trigger_timer") })
	end
end

function modifier_imba_brewmaster_drunken_brawler_passive:OnAttackFail(keys)
	if keys.target == self:GetParent() and not self:GetParent():HasModifier("modifier_imba_brewmaster_drunken_brawler_miss_cooldown") then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_brewmaster_drunken_brawler_miss_cooldown", { duration = self:GetAbility():GetSpecialValueFor("certain_trigger_timer") })
	end
end

------------------------------------------------------------
-- MODIFIER_IMBA_BREWMASTER_DRUNKEN_BRAWLER_CRIT_COOLDOWN --
------------------------------------------------------------

function modifier_imba_brewmaster_drunken_brawler_crit_cooldown:IsHidden() return true end

function modifier_imba_brewmaster_drunken_brawler_crit_cooldown:IsPurgable() return false end

function modifier_imba_brewmaster_drunken_brawler_crit_cooldown:RemoveOnDeath() return false end

------------------------------------------------------------
-- MODIFIER_IMBA_BREWMASTER_DRUNKEN_BRAWLER_MISS_COOLDOWN --
------------------------------------------------------------

function modifier_imba_brewmaster_drunken_brawler_miss_cooldown:IsHidden() return true end

function modifier_imba_brewmaster_drunken_brawler_miss_cooldown:IsPurgable() return false end

function modifier_imba_brewmaster_drunken_brawler_miss_cooldown:RemoveOnDeath() return false end

----------------------------------------------
-- MODIFIER_IMBA_BREWMASTER_DRUNKEN_BRAWLER --
----------------------------------------------

function modifier_imba_brewmaster_drunken_brawler:GetEffectName()
	return "particles/units/heroes/hero_brewmaster/brewmaster_drunkenbrawler_crit.vpcf"
end

-- Why doesn't this status effect have brewmaster in the name
function modifier_imba_brewmaster_drunken_brawler:GetStatusEffectName()
	return "particles/status_fx/status_effect_drunken_brawler.vpcf"
end

function modifier_imba_brewmaster_drunken_brawler:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_imba_brewmaster_drunken_brawler:OnCreated()
	self.dodge_chance = self:GetAbility():GetSpecialValueFor("dodge_chance")
	self.crit_chance = self:GetAbility():GetSpecialValueFor("crit_chance")
	self.crit_multiplier = self:GetAbility():GetTalentSpecialValueFor("crit_multiplier")
	self.min_movement = self:GetAbility():GetSpecialValueFor("min_movement")
	self.max_movement = self:GetAbility():GetSpecialValueFor("max_movement")

	if not IsServer() then return end

	local evade_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_drunkenbrawler_evade.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(evade_particle, false, false, -1, true, false)
end

function modifier_imba_brewmaster_drunken_brawler:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,

		-- IMBAfication: Redirective Flow
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_imba_brewmaster_drunken_brawler:GetModifierEvasion_Constant()
	return self.dodge_chance
end

function modifier_imba_brewmaster_drunken_brawler:GetModifierPreAttack_CriticalStrike()
	if RollPseudoRandom(self.crit_chance, self) then
		self:GetParent():EmitSound("Hero_Brewmaster.Brawler.Crit")

		return self.crit_multiplier
	end
end

function modifier_imba_brewmaster_drunken_brawler:GetModifierMoveSpeedBonus_Percentage()
	if math.floor(self:GetElapsedTime()) % 2 == 0 then
		return self.max_movement
	else
		return self.min_movement
	end
end

-- Not sure if this is how you're supposed to do it?
function modifier_imba_brewmaster_drunken_brawler:OnTooltip(keys)
	if keys.fail_type == 1 then
		return self.crit_chance
	elseif keys.fail_type == 2 then
		return self.crit_multiplier
	end
end

function modifier_imba_brewmaster_drunken_brawler:OnAttackFail(keys)
	if keys.target == self:GetParent() then
		self:SetStackCount(self:GetStackCount() + keys.damage)
	end
end

function modifier_imba_brewmaster_drunken_brawler:GetModifierPreAttack_BonusDamage(keys)
	if keys.target and self:GetStackCount() > 0 then
		self.redirective_damage = self:GetStackCount()
		self:SetStackCount(0)

		return self.redirective_damage
	end
end

----------------------------------
-- IMBA_BREWMASTER_PRIMAL_SPLIT --
----------------------------------

function imba_brewmaster_primal_split:CastFilterResultTarget(target)
	if self:GetCaster():GetModifierStackCount("modifier_imba_brewmaster_primal_split", self:GetCaster()) == 0 then
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_NONE, DOTA_UNIT_TARGET_NONE, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, self:GetCaster():GetTeamNumber())
	end
end

function imba_brewmaster_primal_split:GetIntrinsicModifierName()
	return "modifier_imba_brewmaster_primal_split"
end

function imba_brewmaster_primal_split:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_brewmaster_primal_split_cooldown")
end

function imba_brewmaster_primal_split:GetBehavior()
	if self:GetCaster():GetModifierStackCount("modifier_imba_brewmaster_primal_split", self:GetCaster()) == 0 then
		return tonumber(tostring(self.BaseClass.GetBehavior(self))) + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end

function imba_brewmaster_primal_split:GetCastRange(location, target)
	if self:GetCaster():GetModifierStackCount("modifier_imba_brewmaster_primal_split", self:GetCaster()) == 0 then
		return self.BaseClass.GetCastRange(self, location, target)
	else
		return self:GetSpecialValueFor("co-pilot_cast_range")
	end
end

function imba_brewmaster_primal_split:OnAbilityPhaseStart()
	if self:GetCaster():GetName() == "npc_dota_hero_brewmaster" then
		if not self.responses then
			self.responses = {
				"brewmaster_brew_ability_primalsplit_06",
				"brewmaster_brew_ability_primalsplit_08",
				"brewmaster_brew_ability_primalsplit_09",
				"brewmaster_brew_ability_primalsplit_13"
			}
		end

		self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
	end

	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)

	return true
end

function imba_brewmaster_primal_split:OnAbilityPhaseInterrupted()
	self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
end

function imba_brewmaster_primal_split:OnSpellStart()
	if not self:GetAutoCastState() then
		self:GetCaster():EmitSound("Hero_Brewmaster.PrimalSplit.Cast")

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_brewmaster_primal_split_split_delay", { duration = self:GetSpecialValueFor("split_duration") })
	else
		self:GetCaster():EmitSound("Hero_Brewmaster.Primal_Split_Projectile_Cast")

		ProjectileManager:CreateTrackingProjectile({
			EffectName        = "particles/hero/brewmaster/primal_split_co-pilot.vpcf",
			Ability           = self,
			Source            = self:GetCaster():GetAbsOrigin(),
			vSourceLoc        = self:GetCaster():GetAbsOrigin(),
			Target            = self:GetCursorTarget(),
			iMoveSpeed        = self:GetSpecialValueFor("co-pilot_projectile_speed"),
			-- flExpireTime		= nil,
			bDodgeable        = false,
			bIsAttack         = false,
			bReplaceExisting  = false,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
			bDrawsOnMinimap   = nil,
			bVisibleToEnemies = true,
			bProvidesVision   = false,
			iVisionRadius     = nil,
			iVisionTeamNumber = nil,
			ExtraData         = {}
		})
	end
end

function imba_brewmaster_primal_split:OnProjectileHitHandle(target, location, projectileHandle)
	if target and target:IsAlive() and not target:IsInvulnerable() then
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_brewmaster_primal_split_split_delay", { duration = self:GetSpecialValueFor("split_duration") })
	else
		-- Assuming the projectile failed to land
		self:EndCooldown()
		self:StartCooldown(self:GetCooldown(self:GetLevel()) * self:GetSpecialValueFor("co-pilot_fail_cooldown_pct") / 100 * self:GetCaster():GetCooldownReduction())
	end
end

-------------------------------------------
-- MODIFIER_IMBA_BREWMASTER_PRIMAL_SPLIT --
-------------------------------------------

function modifier_imba_brewmaster_primal_split:IsHidden() return true end

function modifier_imba_brewmaster_primal_split:IsPurgable() return false end

function modifier_imba_brewmaster_primal_split:RemoveOnDeath() return false end

function modifier_imba_brewmaster_primal_split:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ORDER }
end

function modifier_imba_brewmaster_primal_split:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end

	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

-------------------------------------------------------
-- MODIFIER_IMBA_BREWMASTER_PRIMAL_SPLIT_SPLIT_DELAY --
-------------------------------------------------------

function modifier_imba_brewmaster_primal_split_split_delay:IsHidden() return true end

function modifier_imba_brewmaster_primal_split_split_delay:IsPurgable() return false end

function modifier_imba_brewmaster_primal_split_split_delay:OnCreated()
	self.duration              = self:GetAbility():GetSpecialValueFor("duration")
	self.scepter_movementspeed = self:GetAbility():GetSpecialValueFor("scepter_movementspeed")

	if not IsServer() then return end

	local split_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_primal_split.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(split_particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControlForward(split_particle, 0, self:GetParent():GetForwardVector())
	self:AddParticle(split_particle, false, false, -1, false, false)
end

-- "Brewmaster is invulnerable and hidden during the split time and duration. Does not apply any form of dispel upon cast."
function modifier_imba_brewmaster_primal_split_split_delay:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE]      = true,
		[MODIFIER_STATE_OUT_OF_GAME]       = true,
		[MODIFIER_STATE_STUNNED]           = true,
		[MODIFIER_STATE_NO_HEALTH_BAR]     = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end

-- The brewlings spawn always in the same formation, forming an equilateral triangle which fits within a 100 radius circle.
-- The earth brewling is always spawned 100 range in front on Brewmaster's cast location.
-- The storm brewling is always spawned 50 range behind and 86.603 range to the left of Brewmaster's cast location.
-- The fire brewling is always spawned 50 range behind and 86.603 range to the right of Brewmaster's cast location.
-- Their facing angle equals Brewmaster's facing angle on cast.
function modifier_imba_brewmaster_primal_split_split_delay:OnDestroy()
	if not IsServer() then return end

	self.pandas = {}
	-- This table is just for entity indexes for default (i.e. F1 hotkey) selection
	self.pandas_entindexes = {}

	if self:GetParent():IsAlive() and self:GetAbility() then
		self:GetParent():EmitSound("Hero_Brewmaster.PrimalSplit.Spawn")

		local split_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_brewmaster_primal_split_duration", { duration = self.duration })

		local earth_panda = CreateUnitByName("npc_dota_brewmaster_earth_" .. self:GetAbility():GetLevel(), self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 100, true, self:GetParent(), self:GetParent(), self:GetCaster():GetTeamNumber())

		local storm_panda = CreateUnitByName("npc_dota_brewmaster_storm_" .. self:GetAbility():GetLevel(), RotatePosition(self:GetParent():GetAbsOrigin(), QAngle(0, 120, 0), self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 100), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())

		local fire_panda = CreateUnitByName("npc_dota_brewmaster_fire_" .. self:GetAbility():GetLevel(), RotatePosition(self:GetParent():GetAbsOrigin(), QAngle(0, -120, 0), self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 100), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())

		self.standard_abilities = {
			"brewmaster_earth_hurl_boulder",
			"brewmaster_earth_spell_immunity",
			"brewmaster_earth_pulverize",

			"brewmaster_storm_dispel_magic",
			"brewmaster_storm_cyclone",
			"brewmaster_storm_wind_walk",

			"brewmaster_fire_permanent_immolation"
		}

		self.brewmaster_vanilla_abilities = {
			"brewmaster_thunder_clap",
			"brewmaster_cinder_brew",
			"brewmaster_drunken_brawler",
		}

		self.brewmaster_abilities = {
			"imba_brewmaster_thunder_clap",
			"imba_brewmaster_cinder_brew",
			"imba_brewmaster_drunken_brawler"
		}

		table.insert(self.pandas, earth_panda)
		table.insert(self.pandas, storm_panda)
		table.insert(self.pandas, fire_panda)

		table.insert(self.pandas_entindexes, earth_panda:entindex())

		if self:GetCaster() == self:GetParent() then
			table.insert(self.pandas_entindexes, storm_panda:entindex())
			table.insert(self.pandas_entindexes, fire_panda:entindex())
		end

		self:GetParent():FollowEntity(earth_panda, false)

		if split_modifier then
			split_modifier.pandas            = self.pandas
			split_modifier.pandas_entindexes = self.pandas_entindexes
		end

		for _, panda in pairs(self.pandas) do
			panda:SetForwardVector(self:GetParent():GetForwardVector())
			panda:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_brewmaster_primal_split_duration", { duration = self.duration, parent_entindex = self:GetParent():entindex() })
			panda:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kill", { duration = self.duration })

			if self:GetCaster():HasTalent("special_bonus_imba_brewmaster_primal_split_health") then
				panda:SetBaseMaxHealth(panda:GetBaseMaxHealth() + self:GetCaster():FindTalentValue("special_bonus_imba_brewmaster_primal_split_health"))
				panda:SetMaxHealth(panda:GetMaxHealth() + self:GetCaster():FindTalentValue("special_bonus_imba_brewmaster_primal_split_health"))
				panda:SetHealth(panda:GetHealth() + self:GetCaster():FindTalentValue("special_bonus_imba_brewmaster_primal_split_health"))
			end

			if panda:GetName() == "npc_dota_brewmaster_earth" then
				panda:SetControllableByPlayer(self:GetParent():GetPlayerID(), true)
			else
				panda:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			end

			PlayerResource:AddToSelection(self:GetParent():GetPlayerID(), panda)

			for _, ability in pairs(self.standard_abilities) do
				if panda:HasAbility(ability) then
					panda:FindAbilityByName(ability):SetLevel(self:GetAbility():GetLevel())
				end
			end

			-- Replace vanilla ability with IMBA version
			for _, ability in pairs(self.brewmaster_vanilla_abilities) do
				if panda:HasAbility(ability) then
					panda:AddAbility(self.brewmaster_abilities[_])
					panda:SwapAbilities(self.brewmaster_abilities[_], ability, true, false)
					panda:RemoveAbility(ability)
				end
			end

			-- IMBAfication to remove this from the scepter logic?
			-- if self:GetCaster():HasScepter() then
			for _, ability in pairs(self.brewmaster_abilities) do
				if panda:HasAbility(ability) and self:GetCaster():HasAbility(ability) then
					panda:FindAbilityByName(ability):SetLevel(self:GetCaster():FindAbilityByName(ability):GetLevel())
				end
			end
			-- end
		end

		-- IMBAfication: Primal Unison
		local unison_ability = earth_panda:AddAbility("imba_brewmaster_primal_unison")

		if unison_ability then
			unison_ability:SetLevel(1)
			earth_panda:SwapAbilities("imba_brewmaster_primal_unison", "generic_hidden", true, false)
		end

		-- Set the default selection to the pandas
		PlayerResource:RemoveFromSelection(self:GetParent():GetPlayerID(), self:GetParent())
		PlayerResource:SetDefaultSelectionEntities(self:GetParent():GetPlayerID(), self.pandas_entindexes)
		self:GetParent():AddNoDraw()
	end
end

----------------------------------------------------
-- MODIFIER_IMBA_BREWMASTER_PRIMAL_SPLIT_DURATION --
----------------------------------------------------

function modifier_imba_brewmaster_primal_split_duration:IsPurgable() return false end

function modifier_imba_brewmaster_primal_split_duration:OnCreated(keys)
	if self:GetAbility() then
		self.scepter_movementspeed    = self:GetAbility():GetSpecialValueFor("scepter_movementspeed")
		self.scepter_attack_speed     = self:GetAbility():GetSpecialValueFor("scepter_attack_speed")
		self.scepter_magic_resistance = self:GetAbility():GetSpecialValueFor("scepter_magic_resistance")
	else
		self.scepter_movementspeed    = 150
		self.scepter_attack_speed     = 100
		self.scepter_magic_resistance = 20
	end

	if not IsServer() then return end

	-- self.parent here refers to the main modifier holder, not necessarily the caster (due to IMBAfications)
	if keys and keys.parent_entindex then
		self.parent = EntIndexToHScript(keys.parent_entindex)
	end
end

function modifier_imba_brewmaster_primal_split_duration:OnDestroy()
	if not IsServer() then return end

	if self:GetParent():IsHero() then
		self:GetParent():EmitSound("Hero_Brewmaster.PrimalSplit.Return")

		if self:GetRemainingTime() <= 0 and self:GetCaster():GetName() == "npc_dota_hero_brewmaster" then
			if not self.responses then
				self.responses = {
					"brewmaster_brew_ability_primalsplit_10",
					"brewmaster_brew_ability_primalsplit_12",
					"brewmaster_brew_ability_primalsplit_15",
					"brewmaster_brew_ability_primalsplit_16",
					"brewmaster_brew_ability_primalsplit_17"
				}
			end

			self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
		end

		self:GetParent():FollowEntity(nil, false)
		self:GetParent():RemoveNoDraw()

		-- Set default F1 selection back to Brewmaster (or whoever cast the ability)
		PlayerResource:SetDefaultSelectionEntity(self:GetParent():GetPlayerID(), -1)
	end
end

function modifier_imba_brewmaster_primal_split_duration:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE]      = self:GetParent():IsHero(),
		[MODIFIER_STATE_OUT_OF_GAME]       = self:GetParent():IsHero(),
		[MODIFIER_STATE_STUNNED]           = self:GetParent():IsHero(),
		[MODIFIER_STATE_NOT_ON_MINIMAP]    = self:GetParent():IsHero(),
		[MODIFIER_STATE_NO_UNIT_COLLISION] = self:GetParent():IsHero() or self:GetCaster():HasScepter() or self:GetParent():GetName() == "npc_dota_brewmaster_fire",
		[MODIFIER_STATE_UNSELECTABLE]      = self:GetParent():IsHero(),
	}
end

function modifier_imba_brewmaster_primal_split_duration:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,

		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,

		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_imba_brewmaster_primal_split_duration:OnDeath(keys)
	if keys.unit == self:GetParent() and not self:GetParent():IsHero() then
		if self:GetParent():GetName() == "npc_dota_brewmaster_earth" then
			self.death_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_earth_death.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		elseif self:GetParent():GetName() == "npc_dota_brewmaster_storm" then
			self.death_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_storm_death.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		elseif self:GetParent():GetName() == "npc_dota_brewmaster_fire" then
			self.death_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_fire_death.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		end

		if self.death_particle then
			ParticleManager:SetParticleControl(self.death_particle, 0, self:GetParent():GetAbsOrigin())

			if self:GetAbility() then
				ParticleManager:SetParticleControl(self.death_particle, 1, Vector(self:GetAbility():GetLevel(), 0, 0))
			end

			ParticleManager:ReleaseParticleIndex(self.death_particle)
		end

		if self:GetRemainingTime() > 0 then
			if self.parent and not self.parent:IsNull() and self.parent:HasModifier("modifier_imba_brewmaster_primal_split_duration") and self.parent:FindModifierByName("modifier_imba_brewmaster_primal_split_duration").pandas_entindexes then
				Custom_ArrayRemove(self.parent:FindModifierByName("modifier_imba_brewmaster_primal_split_duration").pandas_entindexes, function(i, j)
					return EntIndexToHScript(self.parent:FindModifierByName("modifier_imba_brewmaster_primal_split_duration").pandas_entindexes[i]) and EntIndexToHScript(self.parent:FindModifierByName("modifier_imba_brewmaster_primal_split_duration").pandas_entindexes[i]):IsAlive()
				end)

				-- Yeah technically this should be done with just the one array but I guess I can make the excuse that I'm showing two different ways of doing this
				local bNoneAlive = true

				-- Reminder that these should be the order of Earth, Storm, and Fire in essence of determine which panda to "port" the hero to upon one dying
				for _, panda in pairs(self.parent:FindModifierByName("modifier_imba_brewmaster_primal_split_duration").pandas) do
					if not panda:IsNull() and panda:IsAlive() then
						bNoneAlive = false
						self.parent:FollowEntity(panda, false)

						if self.parent ~= self:GetCaster() then
							table.insert(self.parent:FindModifierByName("modifier_imba_brewmaster_primal_split_duration").pandas_entindexes, panda:entindex())
							panda:SetOwner(self.parent)
							panda:SetControllableByPlayer(self.parent:GetPlayerID(), true)
						end

						break
					end
				end

				-- If one of the brewlings are killed, update the default unit selection to the remainng brewlings
				PlayerResource:SetDefaultSelectionEntities(self.parent:GetPlayerID(), self.parent:FindModifierByName("modifier_imba_brewmaster_primal_split_duration").pandas_entindexes)

				if bNoneAlive then
					self.parent:RemoveModifierByName("modifier_imba_brewmaster_primal_split_duration")

					if keys.attacker ~= self:GetParent() then
						-- self.parent:SetHealth(1)
						self.parent:Kill(self:GetAbility(), keys.attacker)
					end
				end
			end
		end
	end
end

function modifier_imba_brewmaster_primal_split_duration:GetModifierMoveSpeedBonus_Constant()
	if self:GetCaster() and self:GetCaster():HasScepter() and self:GetCaster() ~= self:GetParent() then
		return self.scepter_movementspeed
	end
end

function modifier_imba_brewmaster_primal_split_duration:GetModifierIgnoreMovespeedLimit()
	if self:GetCaster() and self:GetCaster():HasScepter() and self:GetCaster() ~= self:GetParent() then
		return 1
	end
end

function modifier_imba_brewmaster_primal_split_duration:GetModifierAttackSpeedBonus_Constant()
	if self:GetCaster() and self:GetCaster():HasScepter() and self:GetCaster() ~= self:GetParent() then
		return self.scepter_attack_speed
	end
end

function modifier_imba_brewmaster_primal_split_duration:GetModifierMagicalResistanceBonus()
	if self:GetCaster() and self:GetCaster():HasScepter() and self:GetCaster() ~= self:GetParent() then
		return self.scepter_magic_resistance
	end
end

-----------------------------------
-- IMBA_BREWMASTER_PRIMAL_UNISON --
-----------------------------------

function imba_brewmaster_primal_unison:IsStealable() return false end

function imba_brewmaster_primal_unison:OnSpellStart()
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 0.25)

	self.particle = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_channel_ti6.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
end

-- function imba_brewmaster_primal_unison:OnChannelThink(flInterval)

-- end

function imba_brewmaster_primal_unison:OnChannelFinish(bInterrupted)
	self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_1)

	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)

	if not bInterrupted then
		if self:GetCaster():GetOwner() then
			for _, ent in pairs(Entities:FindAllByName("npc_dota_brewmaster_fire")) do
				if ent:GetOwner() == self:GetCaster():GetOwner() then
					ent:ForceKill(false)
				end
			end

			for _, ent in pairs(Entities:FindAllByName("npc_dota_brewmaster_storm")) do
				if ent:GetOwner() == self:GetCaster():GetOwner() then
					ent:ForceKill(false)
				end
			end

			for _, ent in pairs(Entities:FindAllByName("npc_dota_brewmaster_earth")) do
				if ent:GetOwner() == self:GetCaster():GetOwner() then
					ent:ForceKill(false)
					FindClearSpaceForUnit(self:GetCaster():GetOwner(), ent:GetAbsOrigin(), true)
				end
			end

			self:GetCaster():GetOwner():RemoveModifierByName("modifier_imba_brewmaster_primal_split_duration")
		end
	end
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_brewmaster_thunder_clap_slow_duration", "components/abilities/heroes/hero_brewmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_brewmaster_primal_split_health", "components/abilities/heroes/hero_brewmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_brewmaster_druken_brawler_damage", "components/abilities/heroes/hero_brewmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_brewmaster_primal_split_cooldown", "components/abilities/heroes/hero_brewmaster", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_brewmaster_thunder_clap_slow_duration = modifier_special_bonus_imba_brewmaster_thunder_clap_slow_duration or class({})
modifier_special_bonus_imba_brewmaster_primal_split_health        = modifier_special_bonus_imba_brewmaster_primal_split_health or class({})
modifier_special_bonus_imba_brewmaster_druken_brawler_damage      = class({})
modifier_special_bonus_imba_brewmaster_primal_split_cooldown      = class({})

function modifier_special_bonus_imba_brewmaster_thunder_clap_slow_duration:IsHidden() return true end

function modifier_special_bonus_imba_brewmaster_thunder_clap_slow_duration:IsPurgable() return false end

function modifier_special_bonus_imba_brewmaster_thunder_clap_slow_duration:RemoveOnDeath() return false end

function modifier_special_bonus_imba_brewmaster_primal_split_health:IsHidden() return true end

function modifier_special_bonus_imba_brewmaster_primal_split_health:IsPurgable() return false end

function modifier_special_bonus_imba_brewmaster_primal_split_health:RemoveOnDeath() return false end

function modifier_special_bonus_imba_brewmaster_druken_brawler_damage:IsHidden() return true end

function modifier_special_bonus_imba_brewmaster_druken_brawler_damage:IsPurgable() return false end

function modifier_special_bonus_imba_brewmaster_druken_brawler_damage:RemoveOnDeath() return false end

function modifier_special_bonus_imba_brewmaster_primal_split_cooldown:IsHidden() return true end

function modifier_special_bonus_imba_brewmaster_primal_split_cooldown:IsPurgable() return false end

function modifier_special_bonus_imba_brewmaster_primal_split_cooldown:RemoveOnDeath() return false end

function imba_brewmaster_drunken_brawler:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_brewmaster_druken_brawler_damage") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_brewmaster_druken_brawler_damage") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_brewmaster_druken_brawler_damage"), "modifier_special_bonus_imba_brewmaster_druken_brawler_damage", {})
	end
end

function imba_brewmaster_primal_split:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_brewmaster_primal_split_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_brewmaster_primal_split_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_brewmaster_primal_split_cooldown"), "modifier_special_bonus_imba_brewmaster_primal_split_cooldown", {})
	end
end
