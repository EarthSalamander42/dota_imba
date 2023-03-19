-- Creator:
--	   AltiV, August 13th, 2019

LinkLuaModifier("modifier_imba_ancient_apparition_cold_feet", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ancient_apparition_cold_feet_freeze", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_ancient_apparition_ice_vortex_thinker", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ancient_apparition_ice_vortex", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_generic_orb_effect_lua", "components/modifiers/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ancient_apparition_chilling_touch_slow", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_ancient_apparition_imbued_ice", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ancient_apparition_imbued_ice_slow", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_ancient_apparition_anti_abrasion_thinker", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_ancient_apparition_ice_blast_thinker", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ancient_apparition_ice_blast", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ancient_apparition_ice_blast_global_cooling", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ancient_apparition_ice_blast_cold_hearted", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)

imba_ancient_apparition_cold_feet                         = class(VANILLA_ABILITIES_BASECLASS)
modifier_imba_ancient_apparition_cold_feet                = class({})
modifier_imba_ancient_apparition_cold_feet_freeze         = class({})

imba_ancient_apparition_ice_vortex                        = class(VANILLA_ABILITIES_BASECLASS)
modifier_imba_ancient_apparition_ice_vortex_thinker       = class({})
modifier_imba_ancient_apparition_ice_vortex               = class({})

imba_ancient_apparition_chilling_touch                    = class(VANILLA_ABILITIES_BASECLASS)
modifier_imba_ancient_apparition_chilling_touch_slow      = class({})

imba_ancient_apparition_imbued_ice                        = class({})
modifier_imba_ancient_apparition_imbued_ice               = class({})
modifier_imba_ancient_apparition_imbued_ice_slow          = class({})

imba_ancient_apparition_anti_abrasion                     = class({})
modifier_imba_ancient_apparition_anti_abrasion_thinker    = class({})

imba_ancient_apparition_ice_blast                         = class(VANILLA_ABILITIES_BASECLASS)
modifier_imba_ancient_apparition_ice_blast_thinker        = class({})
modifier_imba_ancient_apparition_ice_blast                = class({})
modifier_imba_ancient_apparition_ice_blast_global_cooling = class({})
modifier_imba_ancient_apparition_ice_blast_cold_hearted   = class({})

imba_ancient_apparition_ice_blast_release                 = class(VANILLA_ABILITIES_BASECLASS)

---------------
-- COLD FEET --
---------------

function imba_ancient_apparition_cold_feet:GetAOERadius()
	return self:GetCaster():FindTalentValue("special_bonus_imba_ancient_apparition_cold_feet_aoe")
end

function imba_ancient_apparition_cold_feet:GetBehavior()
	if not self:GetCaster():HasTalent("special_bonus_imba_ancient_apparition_cold_feet_aoe") then
		return self.BaseClass.GetBehavior(self)
	else
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	end
end

function imba_ancient_apparition_cold_feet:OnSpellStart()
	if not self:GetCaster():HasTalent("special_bonus_imba_ancient_apparition_cold_feet_aoe") then
		local target = self:GetCursorTarget()

		if target:TriggerSpellAbsorb(self) then return end

		if not target:HasModifier("imba_ancient_apparition_cold_feet") then
			target:AddNewModifier(self:GetCaster(), self, "modifier_imba_ancient_apparition_cold_feet", {})
		end
	else
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetCaster():FindTalentValue("special_bonus_imba_ancient_apparition_cold_feet_aoe"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		for _, enemy in pairs(enemies) do
			if not enemy:HasModifier("imba_ancient_apparition_cold_feet") then
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_ancient_apparition_cold_feet", {})
			end
		end
	end
end

------------------------
-- COLD FEET MODIFIER --
------------------------

function modifier_imba_ancient_apparition_cold_feet:IgnoreTenacity() return true end

function modifier_imba_ancient_apparition_cold_feet:OnCreated()
	if not IsServer() then return end

	local vanilla_ability_name = string.gsub(self:GetAbility():GetAbilityName(), "imba_", "")
	self.duration              = GetAbilityKV(vanilla_ability_name, "AbilityDuration", self:GetAbility():GetLevel())
	self.damage                = self:GetAbility():GetVanillaAbilitySpecial("damage")
	self.break_distance        = self:GetAbility():GetVanillaAbilitySpecial("break_distance")
	self.stun_duration         = self:GetAbility():GetVanillaAbilitySpecial("stun_duration")

	self.damageTable           = {
		victim       = self:GetParent(),
		damage       = self.damage,
		damage_type  = self:GetAbility():GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		attacker     = self:GetCaster(),
		ability      = self:GetAbility()
	}

	self.original_position     = self:GetParent():GetAbsOrigin()
	self.counter               = 1
	self.ticks                 = 0

	self.interval              = 0.1

	self:GetParent():EmitSound("Hero_Ancient_Apparition.ColdFeetCast")

	-- This marks the original location on the ground
	local cold_feet_marker_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_marker.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	self:AddParticle(cold_feet_marker_particle, false, false, -1, false, false)

	-- This marks the debuff over the target's head
	local cold_feet_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(cold_feet_particle, false, false, -1, false, false)

	self:OnIntervalThink()
	self:StartIntervalThink(self.interval)
end

function modifier_imba_ancient_apparition_cold_feet:OnIntervalThink()
	if (self:GetParent():GetAbsOrigin() - self.original_position):Length2D() < self.break_distance then
		self.counter = self.counter + self.interval

		if self.counter >= 1 then
			if self.ticks < self.duration then
				EmitSoundOnClient("Hero_Ancient_Apparition.ColdFeetTick", self:GetParent():GetPlayerOwner())

				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage, nil)

				ApplyDamage(self.damageTable)
				self.ticks = self.ticks + 1
				self.counter = 0
			else
				self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_ancient_apparition_cold_feet_freeze", { duration = self.stun_duration * (1 - self:GetParent():GetStatusResistance()) })

				self:Destroy()
			end
		end
	else
		self:Destroy()
	end
end

function modifier_imba_ancient_apparition_cold_feet:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER
	}
end

-- IMBAfication: Pole Transferral
function modifier_imba_ancient_apparition_cold_feet:OnOrder(keys)
	if keys.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() and keys.target == self:GetParent() and keys.unit ~= self:GetParent() and not keys.unit:IsMagicImmune() then
		if not keys.unit:HasModifier("imba_ancient_apparition_cold_feet") then
			keys.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_ancient_apparition_cold_feet", {})
		end
	end
end

-------------------------------
-- COLD FEET FREEZE MODIFIER --
-------------------------------

function modifier_imba_ancient_apparition_cold_feet_freeze:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_frozen.vpcf"
end

function modifier_imba_ancient_apparition_cold_feet_freeze:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_ancient_apparition_cold_feet_freeze:OnCreated()
	if not IsServer() then return end

	self:GetParent():EmitSound("Hero_Ancient_Apparition.ColdFeetFreeze")

	if self:GetCaster():GetName() == "npc_dota_hero_ancient_apparition" then
		self:GetCaster():EmitSound("ancient_apparition_appa_ability_coldfeet_0" .. RandomInt(2, 4))
	end
end

function modifier_imba_ancient_apparition_cold_feet_freeze:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN]  = true
	}

	return state
end

function modifier_imba_ancient_apparition_cold_feet_freeze:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_EVENT_ON_ORDER
	}

	return decFuncs
end

-- IMBAfication: Thoroughly Chilled
function modifier_imba_ancient_apparition_cold_feet_freeze:GetDisableHealing()
	return 1
end

-- IMBAfication: Pole Transferral
function modifier_imba_ancient_apparition_cold_feet_freeze:OnOrder(keys)
	if keys.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() and keys.target == self:GetParent() and keys.unit ~= self:GetParent() and not keys.unit:IsMagicImmune() then
		if not keys.unit:HasModifier("imba_ancient_apparition_cold_feet") then
			keys.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_ancient_apparition_cold_feet_freeze", { duration = self:GetRemainingTime() })
		end
	end
end

----------------
-- ICE VORTEX --
----------------

function imba_ancient_apparition_ice_vortex:GetAOERadius()
	return self:GetVanillaAbilitySpecial("radius")
end

--[[
function imba_ancient_apparition_ice_vortex:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_ancient_apparition_ice_vortex_cooldown")
end
--]]
function imba_ancient_apparition_ice_vortex:OnUpgrade()
	if not self.anti_abrasion_ability then
		self.anti_abrasion_ability = self:GetCaster():FindAbilityByName("imba_ancient_apparition_anti_abrasion")
	end

	if self.anti_abrasion_ability then
		self.anti_abrasion_ability:SetLevel(self:GetLevel())
	end
end

function imba_ancient_apparition_ice_vortex:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Ancient_Apparition.IceVortexCast")

	if self:GetCaster():GetName() == "npc_dota_hero_ancient_apparition" then
		if not self.responses then
			self.responses =
			{
				["ancient_apparition_appa_ability_vortex_01"] = 0,
				["ancient_apparition_appa_ability_vortex_02"] = 0,
				["ancient_apparition_appa_ability_vortex_03"] = 0,
				["ancient_apparition_appa_ability_vortex_04"] = 0,
				["ancient_apparition_appa_ability_vortex_05"] = 0,
				["ancient_apparition_appa_ability_vortex_06"] = 0
			}
		end

		for response, timer in pairs(self.responses) do
			if GameRules:GetDOTATime(true, true) - timer >= 60 then
				self:GetCaster():EmitSound(response)
				self.responses[response] = GameRules:GetDOTATime(true, true)
				break
			end
		end
	end

	local vortex_thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_ancient_apparition_ice_vortex_thinker", { duration = self:GetVanillaAbilitySpecial("vortex_duration") }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
end

---------------------------------
-- ICE VORTEX THINKER MODIFIER --
---------------------------------

function modifier_imba_ancient_apparition_ice_vortex_thinker:OnCreated()
	self.radius          = self:GetAbility():GetVanillaAbilitySpecial("radius")
	self.vision_aoe      = self:GetAbility():GetVanillaAbilitySpecial("vision_aoe")
	self.vortex_duration = self:GetAbility():GetVanillaAbilitySpecial("vortex_duration")

	if not IsServer() then return end

	self:GetParent():EmitSound("Hero_Ancient_Apparition.IceVortex")
	self:GetParent():EmitSound("Hero_Ancient_Apparition.IceVortex.lp")

	local vortex_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_ice_vortex.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(vortex_particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(vortex_particle, 5, Vector(self.radius, 0, 0))
	self:AddParticle(vortex_particle, false, false, -1, false, false)

	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.vision_aoe, self.vortex_duration, false)
end

function modifier_imba_ancient_apparition_ice_vortex_thinker:OnDestroy()
	if not IsServer() then return end

	self:GetParent():StopSound("Hero_Ancient_Apparition.IceVortex.lp")
	self:GetParent():RemoveSelf()
end

function modifier_imba_ancient_apparition_ice_vortex_thinker:IsHidden() return true end

function modifier_imba_ancient_apparition_ice_vortex_thinker:IsAura() return true end

function modifier_imba_ancient_apparition_ice_vortex_thinker:IsAuraActiveOnDeath() return false end

function modifier_imba_ancient_apparition_ice_vortex_thinker:GetAuraRadius() return self.radius end

function modifier_imba_ancient_apparition_ice_vortex_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_imba_ancient_apparition_ice_vortex_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end

function modifier_imba_ancient_apparition_ice_vortex_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_imba_ancient_apparition_ice_vortex_thinker:GetModifierAura() return "modifier_imba_ancient_apparition_ice_vortex" end

-------------------------
-- ICE VORTEX MODIFIER --
-------------------------

function modifier_imba_ancient_apparition_ice_vortex:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_imba_ancient_apparition_ice_vortex:OnCreated()
	if self:GetAbility() then
		self.radius             = self:GetAbility():GetVanillaAbilitySpecial("radius")
		self.movement_speed_pct = self:GetAbility():GetVanillaAbilitySpecial("movement_speed_pct") + self:GetCaster():FindTalentValue("special_bonus_imba_ancient_apparition_ice_vortex_boost")
		self.spell_resist_pct   = self:GetAbility():GetVanillaAbilitySpecial("spell_resist_pct") + self:GetCaster():FindTalentValue("special_bonus_imba_ancient_apparition_ice_vortex_boost")
	else
		self.radius             = 0
		self.movement_speed_pct = 0
		self.spell_resist_pct   = 0
	end
end

function modifier_imba_ancient_apparition_ice_vortex:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_imba_ancient_apparition_ice_vortex:GetModifierMoveSpeedBonus_Percentage()
	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		return self.movement_speed_pct
	else
		return self.movement_speed_pct * (-1)
	end
end

function modifier_imba_ancient_apparition_ice_vortex:GetModifierMagicalResistanceBonus()
	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		return self.spell_resist_pct
	else
		return 0
	end
end

--------------------
-- CHILLING TOUCH --
--------------------

function imba_ancient_apparition_chilling_touch:OnUpgrade()
	if not self.imbued_ice_ability then
		self.imbued_ice_ability = self:GetCaster():FindAbilityByName("imba_ancient_apparition_imbued_ice")
	end

	if self.imbued_ice_ability then
		self.imbued_ice_ability:SetLevel(self:GetLevel())
	end
end

function imba_ancient_apparition_chilling_touch:ProcsMagicStick() return false end

function imba_ancient_apparition_chilling_touch:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end

function imba_ancient_apparition_chilling_touch:GetProjectileName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf"
end

function imba_ancient_apparition_chilling_touch:GetCastRange()
	return self:GetCaster():Script_GetAttackRange() + self:GetVanillaAbilitySpecial("attack_range_bonus") + self:GetCaster():FindTalentValue("special_bonus_imba_ancient_apparition_chilling_touch_range")
end

--[[
function imba_ancient_apparition_chilling_touch:GetCooldown(level)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCooldown(self, level)
	else
		return 0
	end
end
--]]
function imba_ancient_apparition_chilling_touch:OnOrbFire()
	self:GetCaster():EmitSound("Hero_Ancient_Apparition.ChillingTouch.Cast")
end

-- "The attacks first apply the debuff, then their own damage."
function imba_ancient_apparition_chilling_touch:OnOrbImpact(keys)
	if keys.target:IsMagicImmune() then return end

	keys.target:EmitSound("Hero_Ancient_Apparition.ChillingTouch.Target")

	keys.target:AddNewModifier(self:GetCaster(), self, "modifier_imba_ancient_apparition_chilling_touch_slow", { duration = self:GetVanillaAbilitySpecial("duration") * (1 - keys.target:GetStatusResistance()) })

	-- IMBAfication: Packed Ice
	keys.target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("packed_ice_duration") * (1 - keys.target:GetStatusResistance()) })

	local damage = self:GetVanillaAbilitySpecial("damage") + self:GetCaster():FindTalentValue("special_bonus_imba_ancient_apparition_chilling_touch_damage")

	ApplyDamage({
		victim       = keys.target,
		damage       = damage,
		damage_type  = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		attacker     = self:GetCaster(),
		ability      = self
	})

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, damage, nil)
end

----------------------------------
-- CHILLING TOUCH SLOW MODIFIER --
----------------------------------

function modifier_imba_ancient_apparition_chilling_touch_slow:OnCreated()
	if self:GetAbility() then
		self.slow                = self:GetAbility():GetVanillaAbilitySpecial("slow")
		self.packed_ice_duration = self:GetAbility():GetSpecialValueFor("packed_ice_duration")
	else
		self.slow                = 0
		self.packed_ice_duration = 0
	end
end

function modifier_imba_ancient_apparition_chilling_touch_slow:CheckState()
	if not IsServer() then return end

	return { [MODIFIER_STATE_FROZEN] = self:GetElapsedTime() <= self.packed_ice_duration * (1 - self:GetParent():GetStatusResistance()) }
end

function modifier_imba_ancient_apparition_chilling_touch_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_imba_ancient_apparition_chilling_touch_slow:GetModifierMoveSpeedBonus_Percentage()
	if self.slow then
		return self.slow * (-1)
	end
end

----------------
-- IMBUED ICE --
----------------

function imba_ancient_apparition_imbued_ice:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_ancient_apparition_imbued_ice:OnSpellStart()
	local position = self:GetCursorPosition()

	self:GetCaster():EmitSound("Hero_Ancient_Apparition.Imbued_Ice_Cast")

	local imbued_ice_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(imbued_ice_particle, 0, position)
	ParticleManager:SetParticleControl(imbued_ice_particle, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), 0))
	ParticleManager:ReleaseParticleIndex(imbued_ice_particle)

	-- "The buff is always placed on Ancient Apparition, even when he is outside the targeted area."
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_ancient_apparition_imbued_ice", { duration = self:GetSpecialValueFor("buff_duration") })

	local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), position, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)

	for _, ally in pairs(allies) do
		if ally ~= self:GetCaster() then
			ally:AddNewModifier(self:GetCaster(), self, "modifier_imba_ancient_apparition_imbued_ice", { duration = self:GetSpecialValueFor("buff_duration") })
		end
	end
end

-------------------------
-- IMBUED ICE MODIFIER --
-------------------------

function modifier_imba_ancient_apparition_imbued_ice:OnCreated()
	if not IsServer() then return end

	self.number_of_attacks    = self:GetAbility():GetSpecialValueFor("number_of_attacks")
	self.damage_per_attack    = self:GetAbility():GetSpecialValueFor("damage_per_attack")
	self.move_speed_slow      = self:GetAbility():GetSpecialValueFor("move_speed_slow")
	self.move_speed_duration  = self:GetAbility():GetSpecialValueFor("move_speed_duration")

	-- "The damage source is set to be the attacking hero, not Ancient Apparition."
	self.damage_table         = {
		victim       = nil,
		damage       = self.damage_per_attack,
		damage_type  = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		attacker     = self:GetParent(),
		ability      = self:GetAbility()
	}

	local imbued_ice_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(imbued_ice_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(imbued_ice_particle, false, false, -1, false, false)

	self:SetStackCount(self.number_of_attacks)
end

function modifier_imba_ancient_apparition_imbued_ice:OnRefresh()
	self:OnCreated()
end

function modifier_imba_ancient_apparition_imbued_ice:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

-- "Does not work against buildings, but fully works against wards."
function modifier_imba_ancient_apparition_imbued_ice:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and not keys.target:IsMagicImmune() and not keys.target:IsBuilding() then
		self:DecrementStackCount()

		keys.target:EmitSound("Hero_Ancient_Apparition.ChillingTouch.Target")

		self.damage_table.victim = keys.target
		ApplyDamage(self.damage_table)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self.damage_per_attack, nil)

		keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_ancient_apparition_imbued_ice_slow", { duration = self.move_speed_duration * (1 - keys.target:GetStatusResistance()) })

		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
	end
end

------------------------------
-- IMBUED ICE SLOW MODIFIER --
------------------------------

function modifier_imba_ancient_apparition_imbued_ice_slow:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_ancient_apparition_imbued_ice_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_imba_ancient_apparition_imbued_ice_slow:OnCreated()
	if self:GetAbility() then
		self.move_speed_slow = self:GetAbility():GetSpecialValueFor("move_speed_slow")
	else
		self.move_speed_slow = 0
	end
end

function modifier_imba_ancient_apparition_imbued_ice_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_DISABLE_HEALING
	}
end

function modifier_imba_ancient_apparition_imbued_ice_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed_slow
end

function modifier_imba_ancient_apparition_imbued_ice_slow:GetDisableHealing()
	return 1
end

-------------------
-- ANTI-ABRASION --
-------------------

function imba_ancient_apparition_anti_abrasion:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_ancient_apparition_anti_abrasion:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Ancient_Apparition.IceVortexCast")

	local vortex_thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_ancient_apparition_anti_abrasion_thinker", { duration = self:GetSpecialValueFor("vortex_duration") }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
end

----------------------------
-- ANTI-ABRASION MODIFIER --
----------------------------

function modifier_imba_ancient_apparition_anti_abrasion_thinker:OnCreated()
	self.radius          = self:GetAbility():GetSpecialValueFor("radius")
	self.vision_aoe      = self:GetAbility():GetSpecialValueFor("vision_aoe")
	self.vortex_duration = self:GetAbility():GetSpecialValueFor("vortex_duration")

	if not IsServer() then return end

	self:GetParent():EmitSound("Hero_Ancient_Apparition.IceVortex")
	self:GetParent():EmitSound("Hero_Ancient_Apparition.IceVortex.lp")

	local vortex_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_anti_abrasion.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(vortex_particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(vortex_particle, 5, Vector(self.radius, 0, 0))
	self:AddParticle(vortex_particle, false, false, -1, false, false)

	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.vision_aoe, self.vortex_duration, false)
end

function modifier_imba_ancient_apparition_anti_abrasion_thinker:OnDestroy()
	if not IsServer() then return end

	self:GetParent():StopSound("Hero_Ancient_Apparition.IceVortex.lp")
	self:GetParent():RemoveSelf()
end

function modifier_imba_ancient_apparition_anti_abrasion_thinker:IsHidden() return true end

function modifier_imba_ancient_apparition_anti_abrasion_thinker:IsAura() return true end

function modifier_imba_ancient_apparition_anti_abrasion_thinker:IsAuraActiveOnDeath() return false end

function modifier_imba_ancient_apparition_anti_abrasion_thinker:GetAuraRadius() return self.radius end

function modifier_imba_ancient_apparition_anti_abrasion_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_imba_ancient_apparition_anti_abrasion_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_imba_ancient_apparition_anti_abrasion_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_imba_ancient_apparition_anti_abrasion_thinker:GetModifierAura() return "modifier_ice_slide" end

function modifier_imba_ancient_apparition_anti_abrasion_thinker:GetAuraDuration() return 0.25 end

---------------
-- ICE BLAST --
---------------

function imba_ancient_apparition_ice_blast:GetAssociatedSecondaryAbilities() return "imba_ancient_apparition_ice_blast_release" end

function imba_ancient_apparition_ice_blast:OnUpgrade()
	if not self.release_ability then
		self.release_ability = self:GetCaster():FindAbilityByName("imba_ancient_apparition_ice_blast_release")
	end

	if self.release_ability and not self.release_ability:IsTrained() then
		self.release_ability:SetLevel(1)
	end
end

function imba_ancient_apparition_ice_blast:OnSpellStart()
	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	EmitSoundOnClient("Hero_Ancient_Apparition.IceBlast.Tracker", self:GetCaster():GetPlayerOwner())

	local velocity = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetVanillaAbilitySpecial("speed")

	-- Use a dummy to attach logic to
	self.ice_blast_dummy = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_ancient_apparition_ice_blast_thinker", { x = velocity.x, y = velocity.y }, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)

	local linear_projectile = {
		Ability           = self,
		--EffectName			= "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_initial.vpcf", -- Since this should only show to allies I think I have to make this a separate particle on a modifier thinker?
		vSpawnOrigin      = self:GetCaster():GetAbsOrigin(),
		fDistance         = math.huge, -- Will this cause issues?
		fStartRadius      = 0,
		fEndRadius        = 0,
		Source            = self:GetCaster(),
		bDrawsOnMinimap   = true,
		bVisibleToEnemies = false,
		bHasFrontalCone   = false,
		bReplaceExisting  = false,
		iUnitTargetTeam   = DOTA_UNIT_TARGET_TEAM_NONE,
		iUnitTargetFlags  = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType   = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime       = GameRules:GetGameTime() + 30.0,
		bDeleteOnHit      = false,
		vVelocity         = Vector(velocity.x, velocity.y, 0),
		bProvidesVision   = true,
		iVisionRadius     = self:GetVanillaAbilitySpecial("target_sight_radius"),
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		ExtraData         =
		{
			direction_x     = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()).x,
			direction_y     = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()).y,
			direction_z     = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()).z,
			ice_blast_dummy = self.ice_blast_dummy:entindex(),
		}
	}

	self.initial_projectile = ProjectileManager:CreateLinearProjectile(linear_projectile)

	if not self.release_ability then
		self.release_ability = self:GetCaster():FindAbilityByName("imba_ancient_apparition_ice_blast_release")
	end

	if self.release_ability then
		self:GetCaster():SwapAbilities(self:GetName(), self.release_ability:GetName(), false, true)
	end
end

function imba_ancient_apparition_ice_blast:OnProjectileThink_ExtraData(location, data)
	if data.ice_blast_dummy then
		EntIndexToHScript(data.ice_blast_dummy):SetAbsOrigin(location)
	end

	if not self:GetCaster():IsAlive() and self.release_ability then
		self.release_ability:OnSpellStart()
	end
end

function imba_ancient_apparition_ice_blast:OnProjectileHit_ExtraData(target, location, data)
	if not target and data.ice_blast_dummy then
		local ice_blast_thinker_modifier = EntIndexToHScript(data.ice_blast_dummy):FindModifierByNameAndCaster("modifier_imba_ancient_apparition_ice_blast_thinker", self:GetCaster())

		if ice_blast_thinker_modifier then
			ice_blast_thinker_modifier:Destroy()
		end
	end
end

--------------------------------
-- ICE BLAST THINKER MODIFIER --
--------------------------------

function modifier_imba_ancient_apparition_ice_blast_thinker:IsPurgable() return false end

function modifier_imba_ancient_apparition_ice_blast_thinker:OnCreated(params)
	if not IsServer() then return end

	local ice_blast_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_initial.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber())
	ParticleManager:SetParticleControl(ice_blast_particle, 1, Vector(params.x, params.y, 0))
	self:AddParticle(ice_blast_particle, false, false, -1, false, false)
end

function modifier_imba_ancient_apparition_ice_blast_thinker:OnDestroy()
	if not IsServer() then return end

	self.release_ability = self:GetCaster():FindAbilityByName("imba_ancient_apparition_ice_blast_release")

	if self:GetAbility() and self:GetAbility():IsHidden() and self.release_ability then
		self:GetCaster():SwapAbilities(self:GetAbility():GetName(), self.release_ability:GetName(), true, false)
	end

	self:GetParent():RemoveSelf()
end

------------------------
-- ICE BLAST MODIFIER --
------------------------

function modifier_imba_ancient_apparition_ice_blast:IsDebuff() return true end

function modifier_imba_ancient_apparition_ice_blast:IsPurgable() return false end

function modifier_imba_ancient_apparition_ice_blast:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_debuff.vpcf"
end

function modifier_imba_ancient_apparition_ice_blast:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_imba_ancient_apparition_ice_blast:OnCreated(params)
	if not IsServer() then return end

	self.dot_damage = params.dot_damage
	self.kill_pct   = params.kill_pct

	if params.caster_entindex then
		self.caster = EntIndexToHScript(params.caster_entindex)
	else
		self.caster = self:GetCaster()
	end

	self.damage_table = {
		victim       = self:GetParent(),
		damage       = self.dot_damage,
		damage_type  = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		attacker     = self.caster,
		ability      = self:GetAbility()
	}

	self:StartIntervalThink(1 - self:GetParent():GetStatusResistance())
end

function modifier_imba_ancient_apparition_ice_blast:OnRefresh(params)
	self:OnCreated(params)
end

function modifier_imba_ancient_apparition_ice_blast:OnIntervalThink()
	self:GetParent():EmitSound("Hero_Ancient_Apparition.IceBlastRelease.Tick")

	ApplyDamage(self.damage_table)

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.dot_damage, nil)
end

function modifier_imba_ancient_apparition_ice_blast:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT
	}
end

function modifier_imba_ancient_apparition_ice_blast:GetDisableHealing()
	return 1
end

function modifier_imba_ancient_apparition_ice_blast:OnTakeDamageKillCredit(keys)
	if keys.target == self:GetParent() and (self:GetParent():GetHealth() / self:GetParent():GetMaxHealth()) * 100 <= self.kill_pct then
		if keys.attacker == self:GetParent() and not self:GetParent():IsInvulnerable() then
			self:GetParent():Kill(self:GetAbility(), self.caster)
		else
			self:GetParent():Kill(self:GetAbility(), keys.attacker)
		end

		if not self:GetParent():IsAlive() then
			local ice_blast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:ReleaseParticleIndex(ice_blast_particle)
		end
	end
end

---------------------------------------
-- ICE BLAST GLOBAL COOLING MODIFIER --
---------------------------------------

function modifier_imba_ancient_apparition_ice_blast_global_cooling:IsPurgable() return false end

function modifier_imba_ancient_apparition_ice_blast_global_cooling:RemoveOnDeath() return false end

function modifier_imba_ancient_apparition_ice_blast_global_cooling:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_imba_ancient_apparition_ice_blast_global_cooling:OnCreated()
	self.global_cooling_move_speed_reduction = self:GetAbility():GetSpecialValueFor("global_cooling_move_speed_reduction")
end

function modifier_imba_ancient_apparition_ice_blast_global_cooling:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_imba_ancient_apparition_ice_blast_global_cooling:GetModifierMoveSpeedBonus_Percentage()
	return self.global_cooling_move_speed_reduction * (-1)
end

-------------------------------------
-- ICE BLAST COLD HEARTED MODIFIER --
-------------------------------------

function modifier_imba_ancient_apparition_ice_blast_cold_hearted:OnCreated(params)
	if not IsServer() then return end

	if self:GetAbility() then
		self.cold_hearted_pct = self:GetAbility():GetSpecialValueFor("cold_hearted_pct") / 100
	else
		self.cold_hearted_pct = 0.5
	end

	self:SetStackCount(self:GetStackCount() + (params.regen * self.cold_hearted_pct))
end

function modifier_imba_ancient_apparition_ice_blast_cold_hearted:OnRefresh(params)
	self:OnCreated(params)
end

function modifier_imba_ancient_apparition_ice_blast_cold_hearted:DeclareFunctions()
	return { MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT }
end

function modifier_imba_ancient_apparition_ice_blast_cold_hearted:GetModifierConstantHealthRegen()
	return self:GetStackCount()
end

-----------------------
-- ICE BLAST RELEASE --
-----------------------

function imba_ancient_apparition_ice_blast_release:IsStealable() return false end

function imba_ancient_apparition_ice_blast_release:GetAssociatedPrimaryAbilities() return "imba_ancient_apparition_ice_blast" end

function imba_ancient_apparition_ice_blast_release:ProcsMagicStick() return false end

function imba_ancient_apparition_ice_blast_release:OnSpellStart()
	if not self.ice_blast_ability then
		self.ice_blast_ability = self:GetCaster():FindAbilityByName("imba_ancient_apparition_ice_blast")
	end

	if self.ice_blast_ability then
		if self.ice_blast_ability.ice_blast_dummy and self.ice_blast_ability.initial_projectile then
			-- Distance vector between where the ice blast tracer ends and where Ancient Apparition is
			local vector = self.ice_blast_ability.ice_blast_dummy:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()

			-- "The ice blast travels at a speed of 750, or reaches the targeted point in 2 seconds, whichever is faster."
			local velocity = vector:Normalized() * math.max(vector:Length2D() / 2, 750)

			-- "The explosion radius starts at 275 and increases by 50 for every second the tracer has traveled, capped at 1000 radius."
			local final_radius = math.min(self.ice_blast_ability:GetVanillaAbilitySpecial("radius_min") + ((vector:Length2D() / self.ice_blast_ability:GetVanillaAbilitySpecial("speed")) * self.ice_blast_ability:GetVanillaAbilitySpecial("radius_grow")), self.ice_blast_ability:GetVanillaAbilitySpecial("radius_max"))

			--EmitSoundOnClient("Hero_Ancient_Apparition.IceBlastRelease.Cast.Self", self:GetCaster():GetPlayerOwner())
			self:GetCaster():EmitSound("Hero_Ancient_Apparition.IceBlastRelease.Cast")

			local ice_blast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_final.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
			ParticleManager:SetParticleControl(ice_blast_particle, 0, self:GetCaster():GetAbsOrigin())
			-- CP1: Direction Vector
			ParticleManager:SetParticleControl(ice_blast_particle, 1, velocity)
			-- CP5: Duration
			ParticleManager:SetParticleControl(ice_blast_particle, 5, Vector(math.min(vector:Length2D() / velocity:Length2D(), 2), 0, 0))
			ParticleManager:ReleaseParticleIndex(ice_blast_particle)

			local marker_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_marker.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber())
			ParticleManager:SetParticleControl(marker_particle, 0, self.ice_blast_ability.ice_blast_dummy:GetAbsOrigin())
			ParticleManager:SetParticleControl(marker_particle, 1, Vector(final_radius, 1, 1))

			-- "The tracer has 500 flying vision around itself. Upon release, provides 650 flying vision of the impact site for 4 seconds."
			AddFOWViewer(self:GetCaster():GetTeamNumber(), self.ice_blast_ability.ice_blast_dummy:GetAbsOrigin(), 650, 4, false)

			local linear_projectile = {
				Ability           = self,
				--EffectName			= "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_final.vpcf",
				vSpawnOrigin      = self:GetCaster():GetAbsOrigin(),
				fDistance         = vector:Length2D(),
				fStartRadius      = self.ice_blast_ability:GetVanillaAbilitySpecial("path_radius"),
				fEndRadius        = self.ice_blast_ability:GetVanillaAbilitySpecial("path_radius"),
				Source            = self:GetCaster(),
				bHasFrontalCone   = false,
				bReplaceExisting  = false,
				iUnitTargetTeam   = DOTA_UNIT_TARGET_TEAM_NONE,
				iUnitTargetFlags  = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
				iUnitTargetType   = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime       = GameRules:GetGameTime() + 10.0,
				bDeleteOnHit      = true,
				vVelocity         = velocity,
				bProvidesVision   = true,
				iVisionRadius     = self.ice_blast_ability:GetVanillaAbilitySpecial("target_sight_radius"),
				iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
				ExtraData         =
				{
					marker_particle = marker_particle,
					final_radius = final_radius
				}
			}

			self.initial_projectile = ProjectileManager:CreateLinearProjectile(linear_projectile)

			self.ice_blast_ability.ice_blast_dummy:Destroy()
			ProjectileManager:DestroyLinearProjectile(self.ice_blast_ability.initial_projectile)

			self.ice_blast_ability.ice_blast_dummy    = nil
			self.ice_blast_ability.initial_projectile = nil
		end

		self:GetCaster():SwapAbilities(self:GetName(), self.ice_blast_ability:GetName(), false, true)
	end
end

function imba_ancient_apparition_ice_blast_release:OnProjectileThink_ExtraData(location, data)
	-- "The ice blast has 500 flying vision, lasting 3 seconds."
	if self.ice_blast_ability then
		AddFOWViewer(self:GetCaster():GetTeamNumber(), location, self.ice_blast_ability:GetVanillaAbilitySpecial("target_sight_radius"), 3, false)

		-- "The debuff can also be placed on spell immune or invulnerable, but not on hidden units."
		local enemies  = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, self.ice_blast_ability:GetVanillaAbilitySpecial("path_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

		local duration = self.ice_blast_ability:GetVanillaAbilitySpecial("frostbite_duration")

		if self:GetCaster():HasScepter() then
			duration = self.ice_blast_ability:GetSpecialValueFor("frostbite_duration_scepter")
		end

		for _, enemy in pairs(enemies) do
			if enemy:IsInvulnerable() then
				enemy:AddNewModifier(enemy, self.ice_blast_ability, "modifier_imba_ancient_apparition_ice_blast",
					{
						duration        = duration * (1 - enemy:GetStatusResistance()),
						dot_damage      = self.ice_blast_ability:GetVanillaAbilitySpecial("dot_damage"),
						kill_pct        = self.ice_blast_ability:GetSpecialValueFor("kill_pct") + self:GetCaster():FindTalentValue("special_bonus_imba_ancient_apparition_ice_blast_kill_threshold"),
						caster_entindex = self:GetCaster():entindex()
					}
				)
			else
				enemy:AddNewModifier(self:GetCaster(), self.ice_blast_ability, "modifier_imba_ancient_apparition_ice_blast",
					{
						duration   = duration * (1 - enemy:GetStatusResistance()),
						dot_damage = self.ice_blast_ability:GetVanillaAbilitySpecial("dot_damage"),
						kill_pct   = self.ice_blast_ability:GetSpecialValueFor("kill_pct") + self:GetCaster():FindTalentValue("special_bonus_imba_ancient_apparition_ice_blast_kill_threshold")
					}
				)
			end
		end
	end
end

function imba_ancient_apparition_ice_blast_release:OnProjectileHit_ExtraData(target, location, data)
	if not target and self.ice_blast_ability then
		EmitSoundOnLocationWithCaster(location, "Hero_Ancient_Apparition.IceBlast.Target", self:GetCaster())

		if data.marker_particle then
			ParticleManager:DestroyParticle(data.marker_particle, false)
			ParticleManager:ReleaseParticleIndex(data.marker_particle)
		end

		-- "The debuff can also be placed on spell immune or invulnerable, but not on hidden units."
		local enemies              = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, data.final_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		local vanilla_ability_name = string.gsub(self.ice_blast_ability:GetAbilityName(), "imba_", "")
		local damage               = GetAbilityKV(vanilla_ability_name, "AbilityDamage", self.ice_blast_ability:GetLevel())

		local damageTable          = {
			victim       = nil,
			damage       = damage,
			damage_type  = self.ice_blast_ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self:GetCaster(),
			ability      = self
		}

		local duration             = self.ice_blast_ability:GetVanillaAbilitySpecial("frostbite_duration")

		if self:GetCaster():HasScepter() then
			duration = self.ice_blast_ability:GetSpecialValueFor("frostbite_duration_scepter")
		end

		for _, enemy in pairs(enemies) do
			-- IMBAfication: Absolute Freeze
			if enemy:IsInvulnerable() then
				enemy:AddNewModifier(enemy, self.ice_blast_ability, "modifier_imba_ancient_apparition_ice_blast",
					{
						duration        = duration * (1 - enemy:GetStatusResistance()),
						dot_damage      = self.ice_blast_ability:GetVanillaAbilitySpecial("dot_damage"),
						kill_pct        = self.ice_blast_ability:GetTalentSpecialValueFor("kill_pct"),
						caster_entindex = self:GetCaster():entindex()
					}
				)
			else
				enemy:AddNewModifier(self:GetCaster(), self.ice_blast_ability, "modifier_imba_ancient_apparition_ice_blast",
					{
						duration   = duration * (1 - enemy:GetStatusResistance()),
						dot_damage = self.ice_blast_ability:GetVanillaAbilitySpecial("dot_damage"),
						kill_pct   = self.ice_blast_ability:GetTalentSpecialValueFor("kill_pct")
					}
				)
			end

			if not enemy:IsMagicImmune() then
				damageTable.victim = enemy

				ApplyDamage(damageTable)
			end

			-- IMBAfication: Cold-Hearted
			self:GetCaster():AddNewModifier(self:GetCaster(), self.ice_blast_ability, "modifier_imba_ancient_apparition_ice_blast_cold_hearted", { duration = duration, regen = enemy:GetHealthRegen() })
		end

		-- -- IMBAfication: Global Cooling
		-- -- Something something lag? IDK
		-- local all_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)

		-- local global_cooling_modifier = nil

		-- for _, enemy in pairs(all_enemies) do
		-- global_cooling_modifier = enemy:AddNewModifier(self:GetCaster(), self.ice_blast_ability, "modifier_imba_ancient_apparition_ice_blast_global_cooling", {duration = duration})

		-- if global_cooling_modifier then
		-- global_cooling_modifier:SetDuration(duration * (1 - enemy:GetStatusResistance()), true)
		-- end
		-- end
	end
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_ancient_apparition_chilling_touch_range", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_ancient_apparition_ice_vortex_cooldown", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_ancient_apparition_ice_blast_kill_threshold", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_ancient_apparition_cold_feet_aoe", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_ancient_apparition_chilling_touch_range     = modifier_special_bonus_imba_ancient_apparition_chilling_touch_range or class({})
modifier_special_bonus_imba_ancient_apparition_ice_vortex_cooldown      = class({})
modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage    = class({})
modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost         = class({})
modifier_special_bonus_imba_ancient_apparition_ice_blast_kill_threshold = modifier_special_bonus_imba_ancient_apparition_ice_blast_kill_threshold or class({})
modifier_special_bonus_imba_ancient_apparition_cold_feet_aoe            = class({})

function modifier_special_bonus_imba_ancient_apparition_chilling_touch_range:IsHidden() return true end

function modifier_special_bonus_imba_ancient_apparition_chilling_touch_range:IsPurgable() return false end

function modifier_special_bonus_imba_ancient_apparition_chilling_touch_range:RemoveOnDeath() return false end

function modifier_special_bonus_imba_ancient_apparition_ice_vortex_cooldown:IsHidden() return true end

function modifier_special_bonus_imba_ancient_apparition_ice_vortex_cooldown:IsPurgable() return false end

function modifier_special_bonus_imba_ancient_apparition_ice_vortex_cooldown:RemoveOnDeath() return false end

function modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage:IsHidden() return true end

function modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage:IsPurgable() return false end

function modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage:RemoveOnDeath() return false end

function modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage:OnCreated()
	if not IsServer() then return end

	self.chilling_touch_ability = self:GetCaster():FindAbilityByName("imba_ancient_apparition_chilling_touch")
	self.imbued_ice_ability     = self:GetCaster():FindAbilityByName("imba_ancient_apparition_imbued_ice")

	if self.chilling_touch_ability and self.imbued_ice_ability then
		self.imbued_ice_ability:SetHidden(false)
		self.imbued_ice_ability:SetLevel(self.chilling_touch_ability:GetLevel())
	end
end

function modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage:OnDestroy()
	if not IsServer() then return end

	if self.imbued_ice_ability then
		self.imbued_ice_ability:SetHidden(true)
	end
end

function modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost:IsHidden() return true end

function modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost:IsPurgable() return false end

function modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost:RemoveOnDeath() return false end

function modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost:OnCreated()
	if not IsServer() then return end

	self.ice_vortex_ability    = self:GetCaster():FindAbilityByName("imba_ancient_apparition_ice_vortex")
	self.anti_abrasion_ability = self:GetCaster():FindAbilityByName("imba_ancient_apparition_anti_abrasion")

	if self.ice_vortex_ability and self.anti_abrasion_ability then
		self.anti_abrasion_ability:SetHidden(false)
		self.anti_abrasion_ability:SetLevel(self.ice_vortex_ability:GetLevel())
	end
end

function modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost:OnDestroy()
	if not IsServer() then return end

	if self.anti_abrasion_ability then
		self.anti_abrasion_ability:SetHidden(true)
	end
end

function modifier_special_bonus_imba_ancient_apparition_ice_blast_kill_threshold:IsHidden() return true end

function modifier_special_bonus_imba_ancient_apparition_ice_blast_kill_threshold:IsPurgable() return false end

function modifier_special_bonus_imba_ancient_apparition_ice_blast_kill_threshold:RemoveOnDeath() return false end

function modifier_special_bonus_imba_ancient_apparition_cold_feet_aoe:IsHidden() return true end

function modifier_special_bonus_imba_ancient_apparition_cold_feet_aoe:IsPurgable() return false end

function modifier_special_bonus_imba_ancient_apparition_cold_feet_aoe:RemoveOnDeath() return false end

function imba_ancient_apparition_cold_feet:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_ancient_apparition_cold_feet_aoe") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_ancient_apparition_cold_feet_aoe") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_ancient_apparition_cold_feet_aoe"), "modifier_special_bonus_imba_ancient_apparition_cold_feet_aoe", {})
	end
end

function imba_ancient_apparition_ice_vortex:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_ancient_apparition_ice_vortex_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_ancient_apparition_ice_vortex_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_ancient_apparition_ice_vortex_cooldown"), "modifier_special_bonus_imba_ancient_apparition_ice_vortex_cooldown", {})
	end

	if self:GetCaster():HasTalent("special_bonus_imba_ancient_apparition_ice_vortex_boost") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_ancient_apparition_ice_vortex_boost"), "modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost", {})
	end
end

function imba_ancient_apparition_chilling_touch:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_ancient_apparition_chilling_touch_range") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_ancient_apparition_chilling_touch_range") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_ancient_apparition_chilling_touch_range"), "modifier_special_bonus_imba_ancient_apparition_chilling_touch_range", {})
	end

	if self:GetCaster():HasTalent("special_bonus_imba_ancient_apparition_chilling_touch_damage") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_ancient_apparition_chilling_touch_damage"), "modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage", {})
	end
end
