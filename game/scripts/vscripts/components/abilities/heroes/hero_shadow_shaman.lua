-- Author:
--		X-TheDark

-- Editors:
--     Fudge
--     naowin, 10.07.2018
--     AltiV - July 3rd, 2019 (actual IMBAfication)

LinkLuaModifier("modifier_imba_shadow_shaman_ether_shock_handler", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_shaman_ether_shock_joy_buzzer", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_shaman_ether_shock_mute", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_shadow_shaman_voodoo", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_shaman_voodoo_handler", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_shaman_voodoo_deprecation", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_shadow_shaman_shackles_handler", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_shaman_shackles_target_handler", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_shaman_shackles", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_shaman_shackles_chariot", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_shadow_shaman_parlor_tricks_handler", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)

imba_shadow_shaman_ether_shock                      = class({})
modifier_imba_shadow_shaman_ether_shock_handler     = class({})
modifier_imba_shadow_shaman_ether_shock_joy_buzzer  = class({})
modifier_imba_shadow_shaman_ether_shock_mute        = class({})

imba_shadow_shaman_voodoo                           = class({})
modifier_imba_shadow_shaman_voodoo_handler          = class({})
modifier_imba_shadow_shaman_voodoo                  = class({})
modifier_imba_shadow_shaman_voodoo_deprecation      = class({})

imba_shadow_shaman_shackles                         = class({})
modifier_imba_shadow_shaman_shackles_handler        = class({})
modifier_imba_shadow_shaman_shackles_target_handler = class({})
modifier_imba_shadow_shaman_shackles                = class({})
modifier_imba_shadow_shaman_shackles_chariot        = class({})

imba_shadow_shaman_parlor_tricks                    = class({})
modifier_imba_shadow_shaman_parlor_tricks_handler   = class({})

-----------------
-- ETHER SHOCK --
-----------------

function imba_shadow_shaman_ether_shock:GetIntrinsicModifierName()
	return "modifier_imba_shadow_shaman_ether_shock_handler"
end

function imba_shadow_shaman_ether_shock:OnSpellStart()
	local target = self:GetCursorTarget()

	if target:TriggerSpellAbsorb(self) then return end

	self:GetCaster():EmitSound("Hero_ShadowShaman.EtherShock")

	if self:GetCaster():GetName() == "npc_dota_hero_shadow_shaman" and RollPercentage(75) then
		self:GetCaster():EmitSound("shadowshaman_shad_ability_ether_0" .. RandomInt(1, 4))
	end

	-- Helper function in vscripts\internal\util.lua
	local enemies = FindUnitsInBicycleChain(
		self:GetCaster():GetTeamNumber(),
		target:GetAbsOrigin(),
		self:GetCaster():GetAbsOrigin(),
		self:GetCaster():GetAbsOrigin() + ((target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized() * (self:GetSpecialValueFor("end_distance") + GetCastRangeIncrease(self:GetCaster()))),
		self:GetSpecialValueFor("start_radius"),
		self:GetSpecialValueFor("end_radius"),
		nil,
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		FIND_CLOSEST,
		false
	)

	local enemies_hit = 0
	local attachment

	-- IMBAfication: Dramatic Entrance
	local dramatic_passive_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_shadow_shaman_ether_shock_handler", self:GetCaster())

	for _, enemy in pairs(enemies) do
		if enemies_hit < self:GetSpecialValueFor("targets") then
			enemy:EmitSound("Hero_ShadowShaman.EtherShock.Target")

			local ether_shock_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())

			-- When hitting multiple targets, the shocks from Shaman's weapons are spread amongst the two wands
			if enemies_hit % 2 == 1 then
				attachment = "attach_attack1"
			else
				attachment = "attach_attack2"
			end

			ParticleManager:SetParticleControlEnt(ether_shock_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, attachment, self:GetCaster():GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(ether_shock_particle, 1, enemy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(ether_shock_particle)

			local damageTable = {
				victim       = enemy,
				damage       = self:GetTalentSpecialValueFor("damage"),
				damage_type  = self:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = self:GetCaster(),
				ability      = self
			}

			ApplyDamage(damageTable)

			-- IMBAfication: Joy Buzzer
			local joy_buzzer_modifier = enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_shadow_shaman_ether_shock_joy_buzzer", { duration = ((self:GetSpecialValueFor("joy_buzzer_stun_duration") + self:GetSpecialValueFor("joy_buzzer_off_duration")) * self:GetSpecialValueFor("joy_buzzer_instances") - self:GetSpecialValueFor("joy_buzzer_stun_duration")) * (1 - enemy:GetStatusResistance()) })

			-- IMBAfication: Dramatic Entrance
			if self == self:GetCaster():FindAbilityByName(self:GetName()) and dramatic_passive_modifier and dramatic_passive_modifier.dramatic and dramatic_passive_modifier.dramatic == true then
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_shadow_shaman_ether_shock_mute", { duration = self:GetSpecialValueFor("dramatic_mute_duration") * (1 - enemy:GetStatusResistance()) })
			end

			enemies_hit = enemies_hit + 1
		end
	end
end

----------------------------------
-- ETHER SHOCK HANDLER MODIFIER --
----------------------------------

-- This is to manage fog vision tracking for the Dramatic Entrance IMBAfication
function modifier_imba_shadow_shaman_ether_shock_handler:IsHidden() return true end

function modifier_imba_shadow_shaman_ether_shock_handler:IsPurgable() return false end

-- Grimstroke Soulbind exception (without this line the modifier disappears -_-)
function modifier_imba_shadow_shaman_ether_shock_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_shadow_shaman_ether_shock_handler:OnCreated()
	self.interval = 0.1

	if self:GetParent():GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		self.enemy_team = DOTA_TEAM_BADGUYS
	else
		self.enemy_team = DOTA_TEAM_GOODGUYS
	end

	if not IsServer() then return end

	self.counter  = 0
	self.dramatic = false

	self:StartIntervalThink(self.interval)
end

function modifier_imba_shadow_shaman_ether_shock_handler:OnIntervalThink()
	if not IsServer() then return end

	if not IsLocationVisible(self.enemy_team, self:GetParent():GetAbsOrigin()) then
		self.counter = math.min(self.counter + self.interval, self:GetAbility():GetSpecialValueFor("dramatic_fog_duration"))
	else
		self.counter = math.max(self.counter - self.interval, 0)
	end

	-- Just testing stuff
	self:SetStackCount(self.counter * 10)

	if self.counter >= self:GetAbility():GetSpecialValueFor("dramatic_fog_duration") then
		self.dramatic = true
	elseif self.counter <= 0 then
		self.dramatic = false
	end
end

-------------------------------------
-- ETHER SHOCK JOY BUZZER MODIFIER --
-------------------------------------

function modifier_imba_shadow_shaman_ether_shock_joy_buzzer:IgnoreTenacity() return true end

function modifier_imba_shadow_shaman_ether_shock_joy_buzzer:OnCreated()
	self.joy_buzzer_stun_duration     = self:GetAbility():GetSpecialValueFor("joy_buzzer_stun_duration")
	self.joy_buzzer_off_duration      = self:GetAbility():GetSpecialValueFor("joy_buzzer_off_duration")
	self.joy_buzzer_instances         = self:GetAbility():GetSpecialValueFor("joy_buzzer_instances")

	self.joy_buzzer_instance_duration = self.joy_buzzer_stun_duration + self.joy_buzzer_off_duration

	if not IsServer() then return end
end

function modifier_imba_shadow_shaman_ether_shock_joy_buzzer:CheckState()
	local state = {}

	if self:GetElapsedTime() % self.joy_buzzer_instance_duration >= 0 and self:GetElapsedTime() % self.joy_buzzer_instance_duration <= self.joy_buzzer_stun_duration then
		state[MODIFIER_STATE_STUNNED] = true
	end

	return state
end

-------------------------------
-- ETHER SHOCK MUTE MODIFIER --
-------------------------------

function modifier_imba_shadow_shaman_ether_shock_mute:GetEffectName()
	return "particles/items4_fx/nullifier_mute_2.vpcf"
end

function modifier_imba_shadow_shaman_ether_shock_mute:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_shadow_shaman_ether_shock_mute:OnCreated()

end

function modifier_imba_shadow_shaman_ether_shock_mute:CheckState()
	local state = {
		[MODIFIER_STATE_MUTED] = true
	}

	return state
end

------------------
-- VOODOO (HEX) --
------------------

function imba_shadow_shaman_voodoo:GetIntrinsicModifierName()
	return "modifier_imba_shadow_shaman_voodoo_handler"
end

function imba_shadow_shaman_voodoo:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

function imba_shadow_shaman_voodoo:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_shadow_shaman_hex_cooldown")
end

function imba_shadow_shaman_voodoo:CastFilterResultTarget(target)
	if self:GetCaster():GetModifierStackCount("modifier_imba_shadow_shaman_voodoo_handler", self:GetCaster()) == 0 or target ~= self:GetCaster() then
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	else
		-- IMBAfication: Cucco
		return UF_SUCCESS
	end
end

function imba_shadow_shaman_voodoo:OnSpellStart()
	local target = self:GetCursorTarget()

	if target:IsMagicImmune() then
		return nil
	end

	if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		if not target:TriggerSpellAbsorb(self) then
			-- "Hex instantly destroys illusions."
			if target:IsIllusion() and not Custom_bIsStrongIllusion(self.parent) then
				target:Kill(target, self:GetCaster())
			else
				if self:GetCaster():GetName() == "npc_dota_hero_shadow_shaman" and RollPercentage(75) then
					self:GetCaster():EmitSound("shadowshaman_shad_ability_voodoo_0" .. RandomInt(1, 4))
				end

				target:AddNewModifier(self:GetCaster(), self, "modifier_imba_shadow_shaman_voodoo", { duration = self:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance()) })
			end
		end
	else
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_shadow_shaman_voodoo", { duration = self:GetSpecialValueFor("duration") })
	end

	target:EmitSound("Hero_ShadowShaman.Hex.Target")
	target:EmitSound("General.Illusion.Create")

	local chicken_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_voodoo.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(chicken_particle)
end

-----------------------------
-- VOODOO HANDLER MODIFIER --
-----------------------------

function modifier_imba_shadow_shaman_voodoo_handler:IsHidden() return true end

function modifier_imba_shadow_shaman_voodoo_handler:IsPurgable() return false end

function modifier_imba_shadow_shaman_voodoo_handler:RemoveOnDeath() return false end

function modifier_imba_shadow_shaman_voodoo_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_shadow_shaman_voodoo_handler:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_imba_shadow_shaman_voodoo_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end

	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

function modifier_imba_shadow_shaman_voodoo_handler:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker == self:GetParent() and self:GetCaster():HasTalent("special_bonus_imba_shadow_shaman_hex_parlor_tricks") and not self:GetParent():IsIllusion() and self:GetAbility() and self:GetAbility():IsTrained() and self == self:GetParent():FindAllModifiersByName("modifier_imba_shadow_shaman_voodoo_handler")[1] and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then --and not keys.attacker:PassivesDisabled() then
		if RollPseudoRandom(self:GetCaster():FindTalentValue("special_bonus_imba_shadow_shaman_hex_parlor_tricks"), self) then
			keys.target:EmitSound("Hero_ShadowShaman.Hex.Target")
			keys.target:EmitSound("General.Illusion.Create")

			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_shadow_shaman_voodoo", { duration = self:GetCaster():FindTalentValue("special_bonus_imba_shadow_shaman_hex_parlor_tricks", "value2") * (1 - keys.target:GetStatusResistance()) })
		end
	end
end

---------------------
-- VOODOO MODIFIER --
---------------------

function modifier_imba_shadow_shaman_voodoo:IsDebuff() return self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() end

function modifier_imba_shadow_shaman_voodoo:OnCreated()
	self.movespeed      = self:GetAbility():GetSpecialValueFor("movespeed")

	self.base_movespeed = 285

	if self:GetParent().GetBaseMoveSpeed then
		self.base_movespeed = self:GetParent():GetBaseMoveSpeed()
	end

	self.base_attackrange = 400

	if self:GetParent().Script_GetAttackRange then
		self.base_attackrange = self:GetParent():Script_GetAttackRange()
	end

	self.base_attacktime = 1.7

	if self:GetParent().GetBaseAttackTime then
		self.base_attacktime = self:GetParent():GetBaseAttackTime()
	end

	self.deprecation_radius     = self:GetAbility():GetSpecialValueFor("deprecation_radius")
	self.deprecation_angle      = self:GetAbility():GetSpecialValueFor("deprecation_angle")
	self.cucco_move_speed       = self:GetAbility():GetSpecialValueFor("cucco_move_speed")
	self.cucco_attack_range     = self:GetAbility():GetSpecialValueFor("cucco_attack_range")
	self.cucco_attack_speed     = self:GetAbility():GetSpecialValueFor("cucco_attack_speed")
	self.cucco_base_attack_time = self:GetAbility():GetSpecialValueFor("cucco_base_attack_time")

	if not IsServer() then return end

	-- IMBAfication: Deprecation
	-- Create a table to hold units that have been broken out of the deprecation hypnosis (aka if they take damage they won't be stunned by the aura modifier again)
	self.targets = {}

	-- IMBAfication: Cucco
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		self.attack_capability = self:GetParent():GetAttackCapability()

		self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
	end
end

function modifier_imba_shadow_shaman_voodoo:OnDestroy()
	if not IsServer() then return end

	self:GetParent():EmitSound("General.Illusion.Destroy")

	if self.attack_capability then
		self:GetParent():SetAttackCapability(self.attack_capability)
	end
end

-- "Applies a hex on the target, setting its base movement speed to 100, silencing, muting, and disarming it. "
function modifier_imba_shadow_shaman_voodoo:CheckState()
	local state =
	{
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED]    = true
	}

	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		state[MODIFIER_STATE_DISARMED]       = true
		state[MODIFIER_STATE_BLOCK_DISABLED] = true
	end

	-- Calling this last so it shows as the forefront state on the UI
	state[MODIFIER_STATE_HEXED] = true

	return state
end

function modifier_imba_shadow_shaman_voodoo:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MODEL_CHANGE,

		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}

	return decFuncs
end

function modifier_imba_shadow_shaman_voodoo:GetModifierMoveSpeedOverride()
	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		return self.movespeed
	else
		if self.cucco_move_speed and self.base_movespeed and self.cucco_move_speed > self.base_movespeed then
			return self.cucco_move_speed
		end
	end
end

function modifier_imba_shadow_shaman_voodoo:GetModifierModelChange()
	return "models/props_gameplay/chicken.vmdl"
end

function modifier_imba_shadow_shaman_voodoo:GetModifierAttackRangeBonus()
	if self.base_attackrange and self.cucco_attack_range and self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return -self.base_attackrange + self.cucco_attack_range
	end
end

function modifier_imba_shadow_shaman_voodoo:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return self.cucco_attack_speed
	end
end

function modifier_imba_shadow_shaman_voodoo:GetModifierBaseAttackTimeConstant()
	if self.cucco_base_attack_time and self.base_attacktime and self.cucco_base_attack_time < self.base_attacktime then
		return self.cucco_base_attack_time
	end
end

function modifier_imba_shadow_shaman_voodoo:GetAttackSound()
	return "tutorial_smallfence_smash"
end

function modifier_imba_shadow_shaman_voodoo:IsAura() return true end

function modifier_imba_shadow_shaman_voodoo:IsAuraActiveOnDeath() return false end

function modifier_imba_shadow_shaman_voodoo:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("deprecation_radius") or 500 end

function modifier_imba_shadow_shaman_voodoo:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_imba_shadow_shaman_voodoo:GetAuraSearchTeam()
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return DOTA_UNIT_TARGET_TEAM_ENEMY
	else
		return DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
end

function modifier_imba_shadow_shaman_voodoo:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_imba_shadow_shaman_voodoo:GetModifierAura() return "modifier_imba_shadow_shaman_voodoo_deprecation" end

function modifier_imba_shadow_shaman_voodoo:GetAuraEntityReject(hTarget)
	if not IsServer() then return end

	return hTarget:IsRoshan() or hTarget == self:GetParent() or (math.abs(AngleDiff(VectorToAngles(hTarget:GetForwardVector()).y, VectorToAngles(self:GetParent():GetAbsOrigin() - hTarget:GetAbsOrigin()).y)) > (self:GetAbility():GetSpecialValueFor("deprecation_angle") or 45)) or self.targets[hTarget:GetEntityIndex()] or not hTarget:CanEntityBeSeenByMyTeam(self:GetParent())
end

---------------------------------
-- VOODOO DEPRECATION MODIFIER --
---------------------------------

function modifier_imba_shadow_shaman_voodoo_deprecation:OnCreated()
	self.deprecation_threshold = self:GetAbility():GetSpecialValueFor("deprecation_threshold")

	if not IsServer() then return end

	self:StartIntervalThink(0.1)
end

function modifier_imba_shadow_shaman_voodoo_deprecation:OnIntervalThink()
	if not IsServer() then return end

	self:GetParent():SetForwardVector((self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized())
	self:GetParent():FaceTowards(self:GetCaster():GetAbsOrigin())
end

function modifier_imba_shadow_shaman_voodoo_deprecation:CheckState()
	local state = { [MODIFIER_STATE_STUNNED] = true }

	return state
end

function modifier_imba_shadow_shaman_voodoo_deprecation:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return decFuncs
end

function modifier_imba_shadow_shaman_voodoo_deprecation:GetOverrideAnimation()
	return ACT_DOTA_VICTORY
end

function modifier_imba_shadow_shaman_voodoo_deprecation:OnTakeDamage(keys)
	if not IsServer() then return end

	if keys.unit == self:GetParent() and keys.damage >= self:GetParent():GetMaxHealth() * self.deprecation_threshold / 100 then
		local voodoo_modifier = self:GetCaster():FindModifierByName("modifier_imba_shadow_shaman_voodoo")

		if voodoo_modifier and voodoo_modifier.targets then
			voodoo_modifier.targets[self:GetParent():GetEntityIndex()] = true
			self:Destroy()
		end
	end
end

--------------
-- SHACKLES --
--------------

function imba_shadow_shaman_shackles:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

function imba_shadow_shaman_shackles:GetIntrinsicModifierName()
	return "modifier_imba_shadow_shaman_shackles_handler"
end

function imba_shadow_shaman_shackles:CastFilterResultTarget(target)
	if not self:GetCaster():HasModifier("modifier_imba_shadow_shaman_shackles_target_handler") or target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() or target == self:GetCaster() then
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	else
		-- IMBAfication: Chariot
		return UF_SUCCESS
	end
end

function imba_shadow_shaman_shackles:GetChannelTime()
	return self:GetCaster():GetModifierStackCount("modifier_imba_shadow_shaman_shackles_handler", self:GetCaster()) / 100
end

function imba_shadow_shaman_shackles:OnSpellStart()
	local target = self:GetCursorTarget()

	if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		if not target:TriggerSpellAbsorb(self) then
			self:GetCaster():EmitSound("Hero_ShadowShaman.Shackles.Cast")

			if self:GetCaster():GetName() == "npc_dota_hero_shadow_shaman" and RollPercentage(75) then
				local responses = {
					"shadowshaman_shad_ability_shackle_01",
					"shadowshaman_shad_ability_shackle_02",
					"shadowshaman_shad_ability_shackle_03",
					"shadowshaman_shad_ability_shackle_04",
					"shadowshaman_shad_ability_shackle_05",
					"shadowshaman_shad_ability_shackle_06",
					"shadowshaman_shad_ability_shackle_08",
					"shadowshaman_shad_ability_entrap_02",
					"shadowshaman_shad_ability_entrap_03",
				}

				self:GetCaster():EmitSound(responses[RandomInt(1, #responses)])
			end

			-- IMBAfication: Stronghold
			local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("stronghold_width"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS)

			for _, enemy in pairs(enemies) do
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_shadow_shaman_shackles", { duration = self:GetChannelTime() })
			end
		else
			self:GetCaster():Interrupt()
		end
	else
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_shadow_shaman_shackles_chariot", { duration = self:GetChannelTime() })
	end

	target:EmitSound("Hero_ShadowShaman.Shackles.Cast")
end

function imba_shadow_shaman_shackles:OnChannelFinish(bInterrupted)
	if not IsServer() then return end

	local target = self:GetCursorTarget()

	if target then
		target:StopSound("Hero_ShadowShaman.Shackles.Cast")

		if target:FindModifierByNameAndCaster("modifier_imba_shadow_shaman_shackles", self:GetCaster()) then
			target:RemoveModifierByNameAndCaster("modifier_imba_shadow_shaman_shackles", self:GetCaster())
		elseif target:FindModifierByNameAndCaster("modifier_imba_shadow_shaman_shackles_chariot", self:GetCaster()) then
			target:RemoveModifierByNameAndCaster("modifier_imba_shadow_shaman_shackles_chariot", self:GetCaster())
		end
	end
end

-------------------------------
-- SHACKLES HANDLER MODIFIER --
-------------------------------

function modifier_imba_shadow_shaman_shackles_handler:IsHidden() return true end

function modifier_imba_shadow_shaman_shackles_handler:IsPurgable() return false end

function modifier_imba_shadow_shaman_shackles_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_shadow_shaman_shackles_handler:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_ORDER
	}
end

-- Going to use this hacky method to determine channel time on UI
-- During the brief time before the ability actually casts, record the target's status resistance * 100 into its intrinsic modifier, then use that divided by 100 as the channel time
function modifier_imba_shadow_shaman_shackles_handler:OnAbilityExecuted(keys)
	if not IsServer() then return end

	if keys.ability == self:GetAbility() then
		if keys.target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
			self:GetCaster():SetModifierStackCount("modifier_imba_shadow_shaman_shackles_handler", self:GetCaster(), self:GetAbility():GetTalentSpecialValueFor("channel_time") * (1 - keys.target:GetStatusResistance()) * 100)
		else
			self:GetCaster():SetModifierStackCount("modifier_imba_shadow_shaman_shackles_handler", self:GetCaster(), self:GetAbility():GetTalentSpecialValueFor("channel_time") * self:GetAbility():GetSpecialValueFor("chariot_channel_multiplier") * 100)
		end
	end
end

function modifier_imba_shadow_shaman_shackles_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end

	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:GetParent():RemoveModifierByName("modifier_imba_shadow_shaman_shackles_target_handler")
	else
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_shadow_shaman_shackles_target_handler", {})
	end
end

--------------------------------------
-- SHACKLES TARGET HANDLER MODIFIER --
--------------------------------------

function modifier_imba_shadow_shaman_shackles_target_handler:IsHidden() return true end

function modifier_imba_shadow_shaman_shackles_target_handler:IsPurgable() return false end

function modifier_imba_shadow_shaman_shackles_target_handler:RemoveOnDeath() return false end

function modifier_imba_shadow_shaman_shackles_target_handler:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_imba_shadow_shaman_shackles_target_handler:OnOrder()
	if not self:GetAbility() or self:GetAbility():IsNull() then
		self:Destroy()
	end
end

-----------------------
-- SHACKLES MODIFIER --
-----------------------

-- Doesn't actually ignore status resist, but this is handled in the channel time function
function modifier_imba_shadow_shaman_shackles:IgnoreTenacity() return true end

function modifier_imba_shadow_shaman_shackles:IsPurgable() return false end

function modifier_imba_shadow_shaman_shackles:IsPurgeException() return true end

function modifier_imba_shadow_shaman_shackles:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_shadow_shaman_shackles:OnCreated()
	if not IsServer() then return end

	-- Create shackle particle (yeah this is like 100% wrong but I can't be assed to figure out what exactly goes where)
	local shackle_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_shackle.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(shackle_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 5, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	self:AddParticle(shackle_particle, true, false, -1, true, false)

	self.tick_interval         = self:GetAbility():GetSpecialValueFor("tick_interval")
	self.total_damage          = self:GetAbility():GetSpecialValueFor("total_damage")
	self.channel_time          = self:GetAbility():GetSpecialValueFor("channel_time")

	self.swindle_gold_per_tick = self:GetAbility():GetSpecialValueFor("swindle_gold_per_tick")

	-- "The damage per tick is based on the total damage divided by its duration and then divided by 10. The talent bonus is ignored."
	self.damage_per_tick       = self.total_damage / (self.channel_time / self.tick_interval)

	self:StartIntervalThink(self.tick_interval * (1 - self:GetParent():GetStatusResistance()))
end

function modifier_imba_shadow_shaman_shackles:OnIntervalThink()
	if not IsServer() then return end

	if not self:GetAbility():IsChanneling() then
		self:Destroy()
	else
		local damageTable = {
			victim       = self:GetParent(),
			damage       = self.damage_per_tick,
			damage_type  = self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self:GetCaster(),
			ability      = self:GetAbility()
		}

		ApplyDamage(damageTable)

		-- IMBAfication: Swindle
		-- Transfer gold from target to caster
		if self:GetParent():IsRealHero() and self:GetParent():GetPlayerID() and self:GetParent().ModifyGold and self:GetCaster().ModifyGold then
			local actual_gold_to_steal = math.min(self.swindle_gold_per_tick, PlayerResource:GetUnreliableGold(self:GetParent():GetPlayerID()))
			self:GetParent():ModifyGold(-actual_gold_to_steal, false, 0)
			self:GetCaster():ModifyGold(actual_gold_to_steal, false, 0)
			SendOverheadEventMessage(self:GetCaster(), OVERHEAD_ALERT_XP, self:GetCaster(), actual_gold_to_steal, nil)
		end
	end
end

function modifier_imba_shadow_shaman_shackles:CheckState()
	return { [MODIFIER_STATE_STUNNED] = true }
end

function modifier_imba_shadow_shaman_shackles:DeclareFunctions()
	return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION }
end

function modifier_imba_shadow_shaman_shackles:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

-------------------------------
-- SHACKLES CHARIOT MODIFIER --
-------------------------------

function modifier_imba_shadow_shaman_shackles_chariot:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_shadow_shaman_shackles_chariot:OnCreated()
	self.chariot_break_distance   = self:GetAbility():GetSpecialValueFor("chariot_break_distance")
	self.chariot_bonus_move_speed = self:GetAbility():GetSpecialValueFor("chariot_bonus_move_speed")

	if not IsServer() then return end

	-- Create shackle particle (yeah this is like 100% wrong but I can't be assed to figure out what exactly goes where)
	local shackle_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_shackle.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(shackle_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 5, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	self:AddParticle(shackle_particle, true, false, -1, true, false)

	self.chariot_max_length = self:GetAbility():GetCastRange(self:GetParent():GetAbsOrigin(), self:GetParent())
	self.vector             = self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()
	self.current_position   = self:GetParent():GetAbsOrigin()

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_shadow_shaman_shackles_chariot:OnIntervalThink()
	if not IsServer() then return end

	if not self:GetAbility():IsChanneling() or (self:GetParent():GetAbsOrigin() - self.current_position):Length2D() > self.chariot_break_distance then
		self:GetAbility():SetChanneling(false)
		self:Destroy()
	else
		-- This variable gets updated every frame because the cast range can change at any time technically
		self.chariot_max_length = self:GetAbility():GetCastRange(self:GetParent():GetAbsOrigin(), self:GetParent())
		self.vector             = self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()
		self.current_position   = self:GetParent():GetAbsOrigin()

		if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() > self.chariot_max_length then
			FindClearSpaceForUnit(self:GetCaster(), self:GetParent():GetAbsOrigin() + self.vector:Normalized() * self.chariot_max_length, false)
		end
	end
end

function modifier_imba_shadow_shaman_shackles_chariot:OnDestroy()
	if not IsServer() then return end

	if self:GetAbility() and self:GetAbility():IsChanneling() then
		self:GetAbility():SetChanneling(false)
	end
end

function modifier_imba_shadow_shaman_shackles_chariot:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT }
end

function modifier_imba_shadow_shaman_shackles_chariot:GetModifierMoveSpeedBonus_Constant()
	return self.chariot_bonus_move_speed
end

--------------------------------
------ MASS SERPENT WARD -------
--------------------------------
imba_shadow_shaman_mass_serpent_ward = imba_shadow_shaman_mass_serpent_ward or class({})

LinkLuaModifier("modifier_imba_mass_serpent_ward", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)

function imba_shadow_shaman_mass_serpent_ward:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end

function imba_shadow_shaman_mass_serpent_ward:GetAOERadius()
	return 150
end

function imba_shadow_shaman_mass_serpent_ward:OnSpellStart()
	-- Ability properties
	local caster         = self:GetCaster()
	local target_point   = self:GetCursorPosition()
	local ward_level     = self:GetLevel()
	-- local ward_name         =   "npc_imba_dota_shadow_shaman_ward_"
	local ward_name      = "npc_dota_shadow_shaman_ward_"
	local response       = "shadowshaman_shad_ability_ward_"
	local spawn_particle = "particles/units/heroes/hero_shadowshaman/shadowshaman_ward_spawn.vpcf"
	-- Ability parameters
	local ward_count     = self:GetSpecialValueFor("ward_count")
	local ward_duration  = self:GetSpecialValueFor("duration")

	local base_hp        = self:GetSpecialValueFor("ward_hp")
	local bonus_hp       = 0
	local bonus_dmg      = 0

	if caster:HasTalent("special_bonus_imba_shadow_shaman_2") then
		bonus_hp = caster:FindTalentValue("special_bonus_imba_shadow_shaman_2")
	end

	if caster:HasTalent("special_bonus_imba_shadow_shaman_3") then
		bonus_dmg = caster:FindTalentValue("special_bonus_imba_shadow_shaman_3")
	end

	-- Emit cast sound
	caster:EmitSound("Hero_ShadowShaman.SerpentWard")
	-- Emit cast response
	caster:EmitSound(response .. RandomInt(4, 7))

	-- Emit spawn particle
	local spawn_particle_fx = ParticleManager:CreateParticle(spawn_particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(spawn_particle_fx, 0, target_point)

	--[[
	-- #1 TALENT: More Serpent Wards
	if caster:HasTalent("special_bonus_imba_shadow_shaman_1") then
		ward_count = ward_count + caster:FindTalentValue("special_bonus_imba_shadow_shaman_1")
		print("has talent 1", ward_count)
	end
	]]
	-- Create 8 wards in a box formation (note the vectors) + more wards near them
	-- local formation_vectors = {
	-- Vector(-128 , 64 ,0), 	Vector(-64, 64, 0), 	Vector(0, 64 ,0), 		
	-- Vector(64, 64 ,0), 		Vector(128 , 64 ,0),	Vector(-64, 0, 0),   	
	-- Vector(64, 0 ,0),		Vector(-64, -64, 0), 	Vector(0, -64 ,0), 		
	-- Vector(64, -64 ,0), 	Vector(-192, 64 ,0),	Vector(192, 64 ,0),
	-- Vector(-128, -64 ,0),	Vector(128, -64 ,0),
	-- }

	-- It's a circle now...
	local formation_vectors = {}

	for i = 1, ward_count do
		table.insert(formation_vectors, Vector(math.cos(math.rad(((360 / ward_count) * i))), math.sin(math.rad(((360 / ward_count) * i))), 0) * 150)
	end

	local find_clear_space = true
	local npc_owner        = caster
	local unit_owner       = caster

	for i = 1, ward_count do
		-- local ward = CreateUnitByName(ward_name..ward_level, target_point + formation_vectors[i], find_clear_space, npc_owner, unit_owner, caster:GetTeamNumber())
		-- ward:SetForwardVector(caster:GetForwardVector())
		-- ward:AddNewModifier(caster, self, "modifier_imba_mass_serpent_ward", {})
		-- ward:AddNewModifier(caster, self, "modifier_kill", {duration = ward_duration})
		-- ward:SetControllableByPlayer(caster:GetPlayerID(), true)
		-- -- Update Health
		-- local new_hp = base_hp + bonus_hp

		-- -- Just gonna spam all the health functions to see what sticks cause this is super inconsistent
		-- ward:SetBaseMaxHealth(new_hp)
		-- ward:SetMaxHealth(new_hp)
		-- ward:SetHealth(new_hp)

		-- -- Update Damage
		-- if bonus_dmg > 0 then
		-- ward:SetBaseDamageMin(ward:GetBaseDamageMin() + bonus_dmg)
		-- ward:SetBaseDamageMax(ward:GetBaseDamageMax() + bonus_dmg)
		-- end

		-- if not self:GetCaster():HasTalent("special_bonus_imba_shadow_shaman_wards_movement") then
		-- ward:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
		-- end

		self:SummonWard(target_point + formation_vectors[i])
	end
end

function imba_shadow_shaman_mass_serpent_ward:SummonWard(position, bChild, elapsedTime)
	local new_hp
	local duration

	if not bChild then
		new_hp   = self:GetSpecialValueFor("ward_hp") + self:GetCaster():FindTalentValue("special_bonus_imba_shadow_shaman_2")
		duration = self:GetSpecialValueFor("duration")
	else
		new_hp   = self:GetSpecialValueFor("snake_charmer_health")
		--duration	= self:GetSpecialValueFor("snake_charmer_duration")
		duration = math.max(self:GetSpecialValueFor("duration") - elapsedTime + self:GetSpecialValueFor("snake_charmer_bonus_duration"), self:GetSpecialValueFor("snake_charmer_bonus_duration"))
	end

	local ward = CreateUnitByName("npc_dota_shadow_shaman_ward_" .. math.min(self:GetLevel(), 3), position, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	ward:SetForwardVector(self:GetCaster():GetForwardVector())
	ward:AddNewModifier(self:GetCaster(), self, "modifier_imba_mass_serpent_ward", {})
	ward:AddNewModifier(self:GetCaster(), self, "modifier_kill", { duration = duration })

	if self:GetCaster().GetPlayerID then
		ward:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	elseif self:GetCaster():GetOwner() and self:GetCaster():GetOwner().GetPlayerID then
		ward:SetControllableByPlayer(self:GetCaster():GetOwner():GetPlayerID(), true)
	end


	-- Just gonna spam all the health functions to see what sticks cause this is super inconsistent
	ward:SetBaseMaxHealth(new_hp)
	ward:SetMaxHealth(new_hp)
	ward:SetHealth(new_hp)

	-- Update Damage
	ward:SetBaseDamageMin(self:GetSpecialValueFor("damage_tooltip") + self:GetCaster():FindTalentValue("special_bonus_imba_shadow_shaman_3"))
	ward:SetBaseDamageMax(self:GetSpecialValueFor("damage_tooltip") + self:GetCaster():FindTalentValue("special_bonus_imba_shadow_shaman_3"))

	-- Differentiate snake charmer wards
	if bChild then
		ward:SetRenderColor(0, 0, 0)
	end

	-- if not self:GetCaster():HasTalent("special_bonus_imba_shadow_shaman_wards_movement") then
	-- ward:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	-- end
end

--- SERPENT WARD MODIFIER
modifier_imba_mass_serpent_ward = modifier_imba_mass_serpent_ward or class({})

function modifier_imba_mass_serpent_ward:IsDebuff() return false end

function modifier_imba_mass_serpent_ward:IsHidden() return true end

function modifier_imba_mass_serpent_ward:IsPurgable() return false end

function modifier_imba_mass_serpent_ward:OnCreated()
	local caster                               = self:GetCaster()
	local ability                              = self:GetAbility()
	local parent                               = self:GetParent()

	self.scepter_additional_targets            = ability:GetSpecialValueFor("scepter_additional_targets")

	self.snake_charmer_creep_count             = self:GetAbility():GetSpecialValueFor("snake_charmer_creep_count")
	self.snake_charmer_hero_count              = self:GetAbility():GetSpecialValueFor("snake_charmer_hero_count")

	self.snake_charmer_creep_bat_reduction_pct = self:GetAbility():GetSpecialValueFor("snake_charmer_creep_bat_reduction_pct")
	self.snake_charmer_hero_bat_reduction_pct  = self:GetAbility():GetSpecialValueFor("snake_charmer_hero_bat_reduction_pct")

	-- AGHANIM'S SCEPTER: Wards have more attack range
	if caster:HasScepter() then
		self.bonus_range = ability:GetSpecialValueFor("scepter_bonus_range")
	end

	if not IsServer() then return end
	-- These things still get stuck sometimes (important for...reasons) so reassess the space again
	Timers:CreateTimer(FrameTime(), function()
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
	end)
end

function modifier_imba_mass_serpent_ward:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,

		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_imba_mass_serpent_ward:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end

-- Set all damage taken to 1
function modifier_imba_mass_serpent_ward:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_imba_mass_serpent_ward:OnAttackLanded(params) -- health handling
	if IsServer() then
		if params.target == self:GetParent() then
			local damage = 1
			-- if params.attacker:IsRealHero() then -- Everyone should do 1 damage
			-- damage = 2
			-- end

			if self:GetParent():GetHealth() > damage then
				self:GetParent():SetHealth(self:GetParent():GetHealth() - damage)
			else
				self:GetParent():Kill(nil, params.attacker)
			end
		end
	end
end

function modifier_imba_mass_serpent_ward:OnAttack(keys)
	-- AGHANIM'S SCEPTER: Ward's attacks split shot
	if keys.attacker == self:GetParent() and not keys.no_attack_cooldown and self:GetCaster() and not self:GetCaster():IsNull() and self:GetCaster():HasScepter() then
		-- Look for a target in the attack range of the ward
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			nil,
			self:GetParent():Script_GetAttackRange(),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
			FIND_ANY_ORDER,
			false)

		local targets_aimed = 0

		-- Send a attack projectile to the chosen enemies
		for i = 1, #enemies do
			if enemies[i] ~= keys.target then
				-- "Unlike most other instant attacks, the ones from the Serpent Wards do not proc any on-hit effects."
				self:GetParent():PerformAttack(enemies[i], false, false, true, true, true, false, false)

				targets_aimed = targets_aimed + 1

				if targets_aimed >= self.scepter_additional_targets then
					break
				end
			end
		end
	end
end

-- AGHANIM'S SCEPTER: wards have bonus attack range
function modifier_imba_mass_serpent_ward:GetModifierAttackRangeBonus()
	return self.bonus_range
end

-- Hero-based damage handling
function modifier_imba_mass_serpent_ward:OnTakeDamage(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			if params.damage > 0 then
				local damageTable = {
					victim = params.unit,
					damage = 1,
					damage_type = DAMAGE_TYPE_PURE,
					attacker = self:GetCaster(),
					ability = self:GetAbility()
				}

				ApplyDamage(damageTable)
			end
		end
	end
end

function modifier_imba_mass_serpent_ward:GetModifierMoveSpeed_Absolute()
	if self:GetCaster():HasTalent("special_bonus_imba_shadow_shaman_wards_movement") then
		return self:GetCaster():FindTalentValue("special_bonus_imba_shadow_shaman_wards_movement")
	end
end

function modifier_imba_mass_serpent_ward:OnDeath(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() and keys.attacker ~= keys.unit and self:GetAbility() and not keys.unit:IsOther() and keys.unit:GetName() ~= "npc_dota_unit_undying_zombie" then
		-- Screw patterns, let's just clump them together xd
		if not keys.unit:IsRealHero() and not keys.unit:IsBuilding() then
			-- for ward = 1, self.snake_charmer_creep_count do
			-- self:GetAbility():SummonWard(keys.unit:GetAbsOrigin(), true, self:GetElapsedTime())
			-- end

			self:GetParent():SetMaxHealth(self:GetParent():GetMaxHealth() + self.snake_charmer_creep_count)
			self:GetParent():Heal(self.snake_charmer_creep_count, self:GetAbility())
			self:GetParent():SetBaseAttackTime(self:GetParent():GetBaseAttackTime() * (1 - (self.snake_charmer_creep_bat_reduction_pct / 100)))

			SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_HEAL, self:GetParent(), self.snake_charmer_creep_count, nil)
		else
			-- for ward = 1, self.snake_charmer_hero_count do
			-- self:GetAbility():SummonWard(keys.unit:GetAbsOrigin(), true, self:GetElapsedTime())
			-- end

			self:GetParent():SetMaxHealth(self:GetParent():GetMaxHealth() + self.snake_charmer_hero_count)
			self:GetParent():Heal(self.snake_charmer_hero_count, self:GetAbility())
			self:GetParent():SetBaseAttackTime(self:GetParent():GetBaseAttackTime() * (1 - (self.snake_charmer_hero_bat_reduction_pct / 100)))

			SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_HEAL, self:GetParent(), self.snake_charmer_hero_count, nil)
		end

		self:GetParent():SetModel("models/items/shadowshaman/serpent_ward/dotapit_s3_wild_tempest_wards/dotapit_s3_wild_tempest_wards.vmdl")
		self:GetParent():SetModelScale(1.3)
	end
end

function modifier_imba_mass_serpent_ward:OnDestroy()
	if IsServer() then
		local particle          = "particles/units/heroes/hero_shadowshaman/shadowshaman_ward_death.vpcf"

		-- Emit ward death particle
		local spawn_particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(spawn_particle_fx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(spawn_particle_fx)
	end
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_shadow_shaman_shackles_duration", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_shadow_shaman_hex_parlor_tricks", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_shadow_shaman_ether_shock_damage", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_shadow_shaman_3", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_shadow_shaman_shackles_duration = modifier_special_bonus_imba_shadow_shaman_shackles_duration or class({})
modifier_special_bonus_imba_shadow_shaman_hex_parlor_tricks = modifier_special_bonus_imba_shadow_shaman_hex_parlor_tricks or class({})
modifier_special_bonus_imba_shadow_shaman_ether_shock_damage = modifier_special_bonus_imba_shadow_shaman_ether_shock_damage or class({})
modifier_special_bonus_imba_shadow_shaman_3 = modifier_special_bonus_imba_shadow_shaman_3 or class({})

function modifier_special_bonus_imba_shadow_shaman_shackles_duration:IsHidden() return true end

function modifier_special_bonus_imba_shadow_shaman_shackles_duration:IsPurgable() return false end

function modifier_special_bonus_imba_shadow_shaman_shackles_duration:RemoveOnDeath() return false end

function modifier_special_bonus_imba_shadow_shaman_hex_parlor_tricks:IsHidden() return true end

function modifier_special_bonus_imba_shadow_shaman_hex_parlor_tricks:IsPurgable() return false end

function modifier_special_bonus_imba_shadow_shaman_hex_parlor_tricks:RemoveOnDeath() return false end

function modifier_special_bonus_imba_shadow_shaman_ether_shock_damage:IsHidden() return true end

function modifier_special_bonus_imba_shadow_shaman_ether_shock_damage:IsPurgable() return false end

function modifier_special_bonus_imba_shadow_shaman_ether_shock_damage:RemoveOnDeath() return false end

function modifier_special_bonus_imba_shadow_shaman_3:IsHidden() return true end

function modifier_special_bonus_imba_shadow_shaman_3:IsPurgable() return false end

function modifier_special_bonus_imba_shadow_shaman_3:RemoveOnDeath() return false end

LinkLuaModifier("modifier_special_bonus_imba_shadow_shaman_hex_cooldown", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_shadow_shaman_wards_movement", "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_shadow_shaman_hex_cooldown   = class({})
modifier_special_bonus_imba_shadow_shaman_wards_movement = class({})

function modifier_special_bonus_imba_shadow_shaman_hex_cooldown:IsHidden() return true end

function modifier_special_bonus_imba_shadow_shaman_hex_cooldown:IsPurgable() return false end

function modifier_special_bonus_imba_shadow_shaman_hex_cooldown:RemoveOnDeath() return false end

function modifier_special_bonus_imba_shadow_shaman_wards_movement:IsHidden() return true end

function modifier_special_bonus_imba_shadow_shaman_wards_movement:IsPurgable() return false end

function modifier_special_bonus_imba_shadow_shaman_wards_movement:RemoveOnDeath() return false end

function imba_shadow_shaman_voodoo:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_shadow_shaman_hex_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_shadow_shaman_hex_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_shadow_shaman_hex_cooldown"), "modifier_special_bonus_imba_shadow_shaman_hex_cooldown", {})
	end
end

function imba_shadow_shaman_voodoo:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_shadow_shaman_wards_movement") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_shadow_shaman_wards_movement") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_shadow_shaman_wards_movement"), "modifier_special_bonus_imba_shadow_shaman_wards_movement", {})
	end
end
