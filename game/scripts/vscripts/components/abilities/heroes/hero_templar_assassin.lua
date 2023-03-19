-- Editors:
--    AltiV, November 3rd, 2019

LinkLuaModifier("modifier_imba_templar_assassin_refraction_handler", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_templar_assassin_refraction_damage", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_templar_assassin_refraction_absorb", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_templar_assassin_refraction_reality", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_templar_assassin_meld", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_templar_assassin_meld_animation", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_templar_assassin_meld_armor", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_templar_assassin_meld_linger", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_templar_assassin_psi_blades", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_templar_assassin_trap_slow", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_templar_assassin_trap_limbs", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_templar_assassin_trap_eyes", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_templar_assassin_trap_nerves", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_templar_assassin_trap_springboard", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_templar_assassin_psionic_trap_handler", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_templar_assassin_psionic_trap", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_templar_assassin_psionic_trap_counter", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)

imba_templar_assassin_refraction                    = class({})
modifier_imba_templar_assassin_refraction_handler   = class({})
modifier_imba_templar_assassin_refraction_damage    = class({})
modifier_imba_templar_assassin_refraction_absorb    = class({})
modifier_imba_templar_assassin_refraction_reality   = class({})

imba_templar_assassin_meld                          = class({})
modifier_imba_templar_assassin_meld                 = class({})
modifier_imba_templar_assassin_meld_animation       = class({})
modifier_imba_templar_assassin_meld_armor           = class({})
modifier_imba_templar_assassin_meld_linger          = class({})

imba_templar_assassin_psi_blades                    = class({})
modifier_imba_templar_assassin_psi_blades           = class({})

imba_templar_assassin_trap                          = class({})
modifier_imba_templar_assassin_trap_slow            = class({})
modifier_imba_templar_assassin_trap_limbs           = class({})
modifier_imba_templar_assassin_trap_eyes            = class({})
modifier_imba_templar_assassin_trap_nerves          = class({})
modifier_imba_templar_assassin_trap_springboard     = class({})

imba_templar_assassin_trap_teleport                 = class({})

imba_templar_assassin_psionic_trap                  = class({})
modifier_imba_templar_assassin_psionic_trap_handler = class({})
modifier_imba_templar_assassin_psionic_trap         = class({})
modifier_imba_templar_assassin_psionic_trap_counter = class({})

imba_templar_assassin_self_trap                     = class({})

--------------------------------------
-- IMBA_TEMPLAR_ASSASSIN_REFRACTION --
--------------------------------------

function imba_templar_assassin_refraction:GetIntrinsicModifierName()
	return "modifier_imba_templar_assassin_refraction_handler"
end

function imba_templar_assassin_refraction:GetAbilityTextureName()
	if self:GetCaster():GetModifierStackCount("modifier_imba_templar_assassin_refraction_handler", self:GetCaster()) <= 0 then
		return "templar_assassin_refraction"
	elseif self:GetCaster():GetModifierStackCount("modifier_imba_templar_assassin_refraction_handler", self:GetCaster()) == 1 then
		return "templar_assassin_refraction_damage"
	elseif self:GetCaster():GetModifierStackCount("modifier_imba_templar_assassin_refraction_handler", self:GetCaster()) == 2 then
		return "templar_assassin/refraction_defense"
	else
		return "templar_assassin_refraction"
	end
end

-- IMBAfication: Disperse Influence
function imba_templar_assassin_refraction:GetCastRange(location, target)
	return self:GetSpecialValueFor("disperse_radius") - self:GetCaster():GetCastRangeBonus()
end

function imba_templar_assassin_refraction:OnSpellStart()
	self:GetCaster():EmitSound("Hero_TemplarAssassin.Refraction")

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_templar_assassin_refraction_damage", { duration = self:GetSpecialValueFor("duration") })
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_templar_assassin_refraction_absorb", { duration = self:GetSpecialValueFor("duration") })

	-- IMBAfication: Refract Reality
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_templar_assassin_refraction_reality", { duration = self:GetSpecialValueFor("reality_duration") })

	-- IMBAfication: Disperse Influence
	for _, ally in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("disperse_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		if ally ~= self:GetCaster() then
			ally:AddNewModifier(self:GetCaster(), self, "modifier_imba_templar_assassin_refraction_absorb", { duration = self:GetSpecialValueFor("disperse_duration") })
		end
	end
end

-------------------------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_REFRACTION_HANDLER --
-------------------------------------------------------

function modifier_imba_templar_assassin_refraction_handler:IsHidden() return true end

function modifier_imba_templar_assassin_refraction_handler:IsPurgable() return false end

function modifier_imba_templar_assassin_refraction_handler:RemoveOnDeath() return false end

function modifier_imba_templar_assassin_refraction_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_templar_assassin_refraction_handler:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ORDER }
end

function modifier_imba_templar_assassin_refraction_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end

	if not self:GetAbility():GetAutoCastState() then
		if self:GetStackCount() >= 2 then
			self:SetStackCount(0)
		else
			self:IncrementStackCount()
		end

		self:GetAbility():ToggleAutoCast()
	end
end

------------------------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_REFRACTION_DAMAGE --
------------------------------------------------------

function modifier_imba_templar_assassin_refraction_damage:IsPurgable() return false end

function modifier_imba_templar_assassin_refraction_damage:GetTexture()
	return "templar_assassin_refraction_damage"
end

function modifier_imba_templar_assassin_refraction_damage:OnCreated()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")

	if not IsServer() then return end

	if self.damage_particle then
		ParticleManager:DestroyParticle(self.damage_particle, false)
		ParticleManager:ReleaseParticleIndex(self.damage_particle)
	end

	self.damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refraction_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.damage_particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.damage_particle, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.damage_particle, false, false, -1, true, false)

	self.instances = self:GetAbility():GetTalentSpecialValueFor("instances")

	if self:GetCaster():GetModifierStackCount("modifier_imba_templar_assassin_refraction_handler", self:GetCaster()) <= 0 then
		self:SetStackCount(math.max(self.instances, self:GetStackCount()))
	elseif self:GetCaster():GetModifierStackCount("modifier_imba_templar_assassin_refraction_handler", self:GetCaster()) == 1 then
		self:SetStackCount(math.max(self.instances + math.ceil(self.instances / 2), self:GetStackCount()))
	else
		self:SetStackCount(math.max(self.instances - math.ceil(self.instances / 2), self:GetStackCount()))
	end
end

function modifier_imba_templar_assassin_refraction_damage:OnRefresh()
	self:OnCreated()
end

function modifier_imba_templar_assassin_refraction_damage:OnStackCountChanged(iStackCount)
	if self:GetStackCount() <= 0 then
		self:Destroy()
	end
end

function modifier_imba_templar_assassin_refraction_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_imba_templar_assassin_refraction_damage:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

-- "Neither loses instances upon attacking allies, nor applies the bonus damage to them."
function modifier_imba_templar_assassin_refraction_damage:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		--particles/units/heroes/hero_templar_assassin/templar_assassin_refraction_dmg.vpcf

		keys.target:EmitSound("Hero_TemplarAssassin.Refraction.Damage")

		self:DecrementStackCount()
	end
end

------------------------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_REFRACTION_ABSORB --
------------------------------------------------------

function modifier_imba_templar_assassin_refraction_absorb:IsPurgable() return false end

-- "Has a higher priority than Aphotic Shield and Living Armor, but lower than False Promise. However, it still loses a charge when combined with the latter."
-- IDK
function modifier_imba_templar_assassin_refraction_absorb:GetPriority() return MODIFIER_PRIORITY_ULTRA end

function modifier_imba_templar_assassin_refraction_absorb:GetTexture()
	return "templar_assassin_refraction"
end

function modifier_imba_templar_assassin_refraction_absorb:OnCreated()
	if not IsServer() then return end

	if self.refraction_particle then
		ParticleManager:DestroyParticle(self.refraction_particle, false)
		ParticleManager:ReleaseParticleIndex(self.refraction_particle)
	end

	self.refraction_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.refraction_particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.refraction_particle, false, false, -1, true, false)

	self.instances          = self:GetAbility():GetTalentSpecialValueFor("instances")
	self.damage_threshold   = self:GetAbility():GetSpecialValueFor("damage_threshold")
	self.disperse_instances = self:GetAbility():GetSpecialValueFor("disperse_instances")

	-- IMBAfication: Disperse Influence
	if self:GetParent() ~= self:GetCaster() then
		self:SetStackCount(self.disperse_instances)
	elseif self:GetCaster():GetModifierStackCount("modifier_imba_templar_assassin_refraction_handler", self:GetCaster()) <= 0 then
		self:SetStackCount(math.max(self.instances, self:GetStackCount()))
	elseif self:GetCaster():GetModifierStackCount("modifier_imba_templar_assassin_refraction_handler", self:GetCaster()) == 1 then
		self:SetStackCount(math.max(self.instances - math.ceil(self.instances / 2), self:GetStackCount()))
	else
		self:SetStackCount(math.max(self.instances + math.ceil(self.instances / 2), self:GetStackCount()))
	end
end

function modifier_imba_templar_assassin_refraction_absorb:OnRefresh()
	self:OnCreated()
end

function modifier_imba_templar_assassin_refraction_absorb:OnStackCountChanged(iStackCount)
	if self:GetStackCount() <= 0 then
		self:Destroy()
	end
end

function modifier_imba_templar_assassin_refraction_absorb:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,

		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
	}
end

-- function modifier_imba_templar_assassin_refraction_absorb:GetModifierIncomingDamage_Percentage(keys)
-- -- "Damage below 5 (after reductions) is completely ignored. It is neither blocked, nor wastes any block instances."
-- -- "Refraction negates all 3 damage types. It does not negate damage flagged as HP Removal."
-- if keys.attacker and keys.damage and keys.damage >= self.damage_threshold and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
-- self:GetParent():EmitSound("Hero_TemplarAssassin.Refraction.Absorb")

-- local warp_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refract_plasma_contact_warp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
-- ParticleManager:ReleaseParticleIndex(warp_particle)

-- local hit_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
-- ParticleManager:SetParticleControlEnt(hit_particle, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
-- ParticleManager:ReleaseParticleIndex(hit_particle)

-- self:DecrementStackCount()
-- return -100
-- end
-- end

function modifier_imba_templar_assassin_refraction_absorb:GetAbsoluteNoDamagePhysical(keys)
	if keys.attacker and ((keys.damage and keys.damage >= self.damage_threshold) or keys.damage_type == DAMAGE_TYPE_PHYSICAL or keys.damage_type == DAMAGE_TYPE_PURE) and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
		return 1
	end
end

function modifier_imba_templar_assassin_refraction_absorb:GetAbsoluteNoDamageMagical(keys)
	if keys.attacker and ((keys.damage and keys.damage >= self.damage_threshold) or keys.damage_type == DAMAGE_TYPE_PHYSICAL or keys.damage_type == DAMAGE_TYPE_PURE) and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
		return 1
	end
end

-- Since the pure function seems to run last when compared to the physical and magical ones above (but before the GetModifierIncomingDamage_Percentage), I guess it makes sense to put the actual logic here? Seems kinda hacky...
function modifier_imba_templar_assassin_refraction_absorb:GetAbsoluteNoDamagePure(keys)
	-- "Damage below 5 (after reductions) is completely ignored. It is neither blocked, nor wastes any block instances."
	-- "Refraction negates all 3 damage types. It does not negate damage flagged as HP Removal."
	if keys.attacker and ((keys.damage and keys.damage >= self.damage_threshold) or keys.damage_type == DAMAGE_TYPE_PHYSICAL or keys.damage_type == DAMAGE_TYPE_PURE) and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
		self:GetParent():EmitSound("Hero_TemplarAssassin.Refraction.Absorb")

		local warp_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refract_plasma_contact_warp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(warp_particle)

		local hit_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(hit_particle, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(hit_particle)

		self:DecrementStackCount()
		return 1
	end
end

-------------------------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_REFRACTION_REALITY --
-------------------------------------------------------

function modifier_imba_templar_assassin_refraction_reality:IsHidden() return true end

function modifier_imba_templar_assassin_refraction_reality:IsPurgable() return false end

function modifier_imba_templar_assassin_refraction_reality:OnCreated()
	if not IsServer() then return end

	self:GetParent():AddNoDraw()
end

function modifier_imba_templar_assassin_refraction_reality:OnDestroy()
	if not IsServer() then return end

	self:GetParent():RemoveNoDraw()
end

function modifier_imba_templar_assassin_refraction_reality:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end

--------------------------------
-- IMBA_TEMPLAR_ASSASSIN_MELD --
--------------------------------

function imba_templar_assassin_meld:OnSpellStart()
	self:GetCaster():EmitSound("Hero_TemplarAssassin.Meld")

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_templar_assassin_meld", {})

	if self:GetCaster():HasTalent("special_bonus_imba_templar_assassin_meld_dispels") then
		self:GetCaster():Purge(false, true, false, false, false)
	end
end

-- Splitting this into its own function so it can be applied elsewhere as an IMBAfication
function imba_templar_assassin_meld:ApplyMeld(target, attacker)
	-- "Meld first applies its armor debuff, then Templar Assassin's attack damage, and then the Meld damage (Talent and then the bash)."
	target:AddNewModifier(attacker, self, "modifier_imba_templar_assassin_meld_armor", { duration = self:GetDuration() * (1 - target:GetStatusResistance()) })

	ApplyDamage({
		victim       = target,
		damage       = self:GetSpecialValueFor("bonus_damage"),
		damage_type  = self:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		attacker     = attacker,
		ability      = self
	})

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, target, self:GetSpecialValueFor("bonus_damage"), nil)

	if self:GetCaster():HasTalent("special_bonus_imba_templar_assassin_meld_bash") then
		target:AddNewModifier(attacker, self, "modifier_stunned", { duration = self:GetCaster():FindTalentValue("special_bonus_imba_templar_assassin_meld_bash") * (1 - target:GetStatusResistance()) })
	end
end

-----------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_MELD --
-----------------------------------------

function modifier_imba_templar_assassin_meld:GetEffectName()
	return "particles/units/heroes/hero_templar_assassin/templar_assassin_meld.vpcf"
end

function modifier_imba_templar_assassin_meld:OnCreated()
	if not IsServer() then return end

	self.armor_reduction_duration          = self:GetAbility():GetDuration()
	self.bonus_damage                      = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.damage_type                       = self:GetAbility():GetAbilityDamageType()

	self.inner_eye_seconds_to_flying_sight = self:GetAbility():GetSpecialValueFor("inner_eye_seconds_to_flying_sight")
	self.inner_eye_seconds_to_expand       = self:GetAbility():GetSpecialValueFor("inner_eye_seconds_to_expand")
	self.inner_eye_vision_bonus            = self:GetAbility():GetSpecialValueFor("inner_eye_vision_bonus")
	self.inner_eye_after_duration          = self:GetAbility():GetSpecialValueFor("inner_eye_after_duration")

	-- "Turns Templar Assassin instantly invisible and orders her to stop."
	if not IsServer() then return end

	-- This variable is used to save Templar Assassin's initial meld location, to determine to remove the modifier if she is moved horizontally
	self.cast_position      = self:GetParent():GetAbsOrigin()

	-- This variable is used to check if Templar Assassin issues an auto-attack command, which will then enable it again (because otherwise she would keep interrupting her Meld)
	self.bDisableAuto       = 1

	self.flying_vision_time = math.max(self.inner_eye_seconds_to_flying_sight, FrameTime())

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_templar_assassin_meld:OnIntervalThink()
	if self:GetParent():GetAbsOrigin().x ~= self.cast_position.x or self:GetParent():GetAbsOrigin().y ~= self.cast_position.y then
		self:StartIntervalThink(-1)
		self:Destroy()
	end

	-- IMBAfication: Inner Eye
	if not self.bInnerEye and self:GetElapsedTime() >= self.flying_vision_time then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_templar_assassin_meld_linger",
			{
				inner_eye_seconds_to_flying_sight = self.inner_eye_seconds_to_flying_sight,
				inner_eye_seconds_to_expand       = self.inner_eye_seconds_to_expand,
				inner_eye_vision_bonus            = self.inner_eye_vision_bonus,
				inner_eye_after_duration          = self.inner_eye_after_duration
			})
		self.bInnerEye = true
	end
end

function modifier_imba_templar_assassin_meld:OnDestroy()
	if not IsServer() then return end

	for _, modifier in pairs(self:GetParent():FindAllModifiersByName("modifier_imba_templar_assassin_meld_linger")) do
		if modifier:GetDuration() == -1 then
			modifier:SetDuration(self.inner_eye_after_duration, true)
		end
	end
end

function modifier_imba_templar_assassin_meld:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE]         = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end

function modifier_imba_templar_assassin_meld:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,

		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,

		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_FAIL,

		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
end

function modifier_imba_templar_assassin_meld:GetDisableAutoAttack()
	return self.bDisableAuto
end

function modifier_imba_templar_assassin_meld:GetModifierInvisibilityLevel()
	return 1
end

function modifier_imba_templar_assassin_meld:OnOrder(keys)
	if keys.unit == self:GetParent() and keys.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE then
		self.bDisableAuto = 0
	end
end

function modifier_imba_templar_assassin_meld:OnAbilityFullyCast(keys)
	if keys.unit == self:GetParent() and keys.ability ~= self:GetAbility() and keys.ability:GetName() ~= "imba_templar_assassin_trap_teleport" then
		self:Destroy()
	end
end

-- Because only one Meld projectile is released, but the modifier can linger through multiple attack launches, I'll use a stack count check on the first attack launched and check projectile name below
function modifier_imba_templar_assassin_meld:OnAttack(keys)
	if keys.attacker == self:GetParent() then
		self:GetAbility().meld_record = keys.record
		self:SetStackCount(-1)
	end
end

function modifier_imba_templar_assassin_meld:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() then
		-- "Neither the bonus damage nor the armor reduction from Meld affect buildings."
		if not keys.target:IsBuilding() and self:GetAbility() and self:GetAbility().meld_record then
			keys.target:EmitSound("Hero_TemplarAssassin.Meld.Attack")

			self:GetAbility():ApplyMeld(keys.target, self:GetParent())

			self:Destroy()
		end
	end
end

-- "However, when the projectile misses (evasion, blind or disjoint), the invisibility is lost at the moment it misses."
function modifier_imba_templar_assassin_meld:OnAttackFail(keys)
	if keys.attacker == self:GetParent() then
		self:Destroy()
	end
end

function modifier_imba_templar_assassin_meld:GetModifierProjectileName()
	if self:GetStackCount() ~= -1 and (self:GetParent():GetAttackTarget() and not self:GetParent():GetAttackTarget():IsBuilding()) then
		return "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf"
	end
end

function modifier_imba_templar_assassin_meld:GetActivityTranslationModifiers()
	return "meld"
end

---------------------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_MELD_ANIMATION --
---------------------------------------------------

-- Currently unused
function modifier_imba_templar_assassin_meld_animation:DeclareFunctions()
	return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION }
end

function modifier_imba_templar_assassin_meld_animation:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end

-----------------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_MELD_ARMOR --
-----------------------------------------------

function modifier_imba_templar_assassin_meld_armor:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_templar_assassin_meld_armor:GetEffectName()
	return "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_armor.vpcf"
end

function modifier_imba_templar_assassin_meld_armor:OnCreated()
	if self:GetAbility() then
		self.bonus_armor = self:GetAbility():GetTalentSpecialValueFor("bonus_armor")
	else
		self.bonus_armor = 0
	end

	if not IsServer() then return end

	self.overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_meld_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.overhead_particle, false, false, -1, false, true)
end

function modifier_imba_templar_assassin_meld_armor:DeclareFunctions()
	return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end

function modifier_imba_templar_assassin_meld_armor:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

------------------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_MELD_LINGER --
------------------------------------------------

function modifier_imba_templar_assassin_meld_linger:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_templar_assassin_meld_linger:OnCreated(params)
	if not IsServer() then return end

	if self:GetAbility() then
		self.inner_eye_seconds_to_flying_sight = self:GetAbility():GetSpecialValueFor("inner_eye_seconds_to_flying_sight")
		self.inner_eye_seconds_to_expand       = self:GetAbility():GetSpecialValueFor("inner_eye_seconds_to_expand")
		self.inner_eye_vision_bonus            = self:GetAbility():GetSpecialValueFor("inner_eye_vision_bonus")
		self.inner_eye_after_duration          = self:GetAbility():GetSpecialValueFor("inner_eye_after_duration")
	elseif params then
		self.inner_eye_seconds_to_flying_sight = params.inner_eye_seconds_to_flying_sight
		self.inner_eye_seconds_to_expand       = params.inner_eye_seconds_to_expand
		self.inner_eye_vision_bonus            = params.inner_eye_vision_bonus
		self.inner_eye_after_duration          = params.inner_eye_after_duration
	else -- Stupid hard-coded stuff for Morphling/Rubick...
		self.inner_eye_seconds_to_flying_sight = 5
		self.inner_eye_seconds_to_expand       = 10
		self.inner_eye_vision_bonus            = 1000
		self.inner_eye_after_duration          = 5
	end

	self.expansion_time = math.max(self.inner_eye_seconds_to_expand - self.inner_eye_seconds_to_flying_sight, FrameTime())
	self.interval       = 0.1
	self.bonus_vision   = 0

	self:StartIntervalThink(self.interval)
end

function modifier_imba_templar_assassin_meld_linger:OnIntervalThink()
	if not self.bExpanded and self:GetElapsedTime() >= self.expansion_time then
		self.bonus_vision = self.inner_eye_vision_bonus
		self.bExpanded    = true
	end

	AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetParent():GetCurrentVisionRange() + self.bonus_vision, self.interval, false)
end

--------------------------------------
-- IMBA_TEMPLAR_ASSASSIN_PSI_BLADES --
--------------------------------------

function imba_templar_assassin_psi_blades:GetIntrinsicModifierName()
	return "modifier_imba_templar_assassin_psi_blades"
end

-- function imba_templar_assassin_psi_blades:OnSpellStart()

-- end

-----------------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_PSI_BLADES --
-----------------------------------------------

function modifier_imba_templar_assassin_psi_blades:IsHidden() return self:GetStackCount() <= 0 end

function modifier_imba_templar_assassin_psi_blades:OnCreated()

end

function modifier_imba_templar_assassin_psi_blades:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,

		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS
	}
end

function modifier_imba_templar_assassin_psi_blades:GetModifierAttackRangeBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_range")
end

function modifier_imba_templar_assassin_psi_blades:OnTakeDamage(keys)
	if keys.attacker == self:GetParent() and self:GetAbility():IsTrained() and not self:GetParent():PassivesDisabled() and keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK and not keys.unit:IsBuilding() and (not keys.unit:IsOther() or (keys.unit:IsOther() and keys.damage > 0)) then
		if not self.meld_ability or self.meld_ability:IsNull() then
			self.meld_ability = self:GetCaster():FindAbilityByName("imba_templar_assassin_meld")
		end

		if self.meld_ability and self.meld_ability.meld_record and self.meld_ability.meld_record == keys.record then
			self.meld_extension           = true
			self.meld_ability.meld_record = nil
		end

		local damage_to_use = keys.damage

		if self.accelerate_record == keys.record then
			if not keys.unit:IsIllusion() then
				damage_to_use = math.max(keys.original_damage, keys.damage)
			else
				damage_to_use = keys.original_damage
			end

			self.accelerate_record = nil
			-- This is so jank...the spill damage isn't increased through hitting illusions with higher incoming damage multipliers, so I'm going to calculate the purported damage as if it hit a non-illusion and carry that forward
		elseif keys.unit:IsIllusion() and keys.unit.GetPhysicalArmorValue and GetReductionFromArmor then
			damage_to_use = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetPhysicalArmorValue(false)))
		end

		for _, enemy in pairs(FindUnitsInLine(self:GetCaster():GetTeamNumber(), keys.unit:GetAbsOrigin(), keys.unit:GetAbsOrigin() + ((keys.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized() * self:GetAbility():GetSpecialValueFor("attack_spill_range")), nil, self:GetAbility():GetSpecialValueFor("attack_spill_width"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)) do
			if enemy ~= keys.unit then
				enemy:EmitSound("Hero_TemplarAssassin.PsiBlade")

				self.psi_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_psi_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit, self:GetParent())
				ParticleManager:SetParticleControlEnt(self.psi_particle, 0, keys.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.psi_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(self.psi_particle)

				ApplyDamage({
					victim       = enemy,
					damage       = damage_to_use * self:GetAbility():GetSpecialValueFor("attack_spill_pct") / 100,
					damage_type  = self:GetAbility():GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
					attacker     = self:GetParent(),
					ability      = self:GetAbility()
				})

				-- IMBAfication: Meld Extension
				if self.meld_extension then
					self.meld_ability:ApplyMeld(enemy, self:GetParent())
				end
			end
		end

		self.meld_extension = false
	end
end

function modifier_imba_templar_assassin_psi_blades:OnAttack(keys)
	if keys.attacker == self:GetParent() and self:GetAbility():IsTrained() and not self:GetParent():PassivesDisabled() and not keys.no_attack_cooldown then
		if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("attacks_to_accelerate") then
			self:IncrementStackCount()
		else
			self.accelerate_record = keys.record
			self:SetStackCount(0)
		end
	end
end

function modifier_imba_templar_assassin_psi_blades:GetModifierProjectileSpeedBonus()
	if self:GetStackCount() == self:GetAbility():GetSpecialValueFor("attacks_to_accelerate") then
		return self:GetAbility():GetSpecialValueFor("accelerant_speed_bonus")
	end
end

--------------------------------
-- IMBA_TEMPLAR_ASSASSIN_TRAP --
--------------------------------

function imba_templar_assassin_trap:GetAssociatedSecondaryAbilities() return "imba_templar_assassin_psionic_trap" end

function imba_templar_assassin_trap:ProcsMagicStick() return false end

function imba_templar_assassin_trap:OnSpellStart()
	if not self.trap_ability then
		self.trap_ability = self:GetCaster():FindAbilityByName("imba_templar_assassin_psionic_trap")
	end

	if not self.counter_modifier or self.counter_modifier:IsNull() then
		self.counter_modifier = self:GetCaster():FindModifierByName("modifier_imba_templar_assassin_psionic_trap_counter")
	end

	if self.trap_ability and self.counter_modifier and self.counter_modifier.trap_table and #self.counter_modifier.trap_table > 0 then
		-- Find closest trap to cursor position
		local distance = nil
		local index    = nil

		for trap_number = 1, #self.counter_modifier.trap_table do
			if self.counter_modifier.trap_table[trap_number] and not self.counter_modifier.trap_table[trap_number]:IsNull() then
				if not distance then
					index    = trap_number
					distance = (self:GetCaster():GetAbsOrigin() - self.counter_modifier.trap_table[trap_number]:GetParent():GetAbsOrigin()):Length2D()
				elseif ((self:GetCaster():GetAbsOrigin() - self.counter_modifier.trap_table[trap_number]:GetParent():GetAbsOrigin()):Length2D() < distance) then
					index    = trap_number
					distance = (self:GetCaster():GetAbsOrigin() - self.counter_modifier.trap_table[trap_number]:GetParent():GetAbsOrigin()):Length2D()
				end
			end
		end

		if index then
			self:GetCaster():EmitSound("Hero_TemplarAssassin.Trap.Trigger")

			if self:GetCaster():GetName() == "npc_dota_hero_templar_assassin" and RollPercentage(50) then
				if RollPercentage(50) then
					self:GetCaster():EmitSound("templar_assassin_temp_psionictrap_05")
				else
					self:GetCaster():EmitSound("templar_assassin_temp_psionictrap_10")
				end
			end

			self.counter_modifier.trap_table[index]:Explode(self.trap_ability, self:GetSpecialValueFor("trap_radius"), self:GetSpecialValueFor("trap_duration"))
		end
	else
		DisplayError(self:GetCaster():GetPlayerOwnerID(), "No traps")
	end
end

----------------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_TRAP_SLOW --
----------------------------------------------

-- "When activated via the sub-spell on the caster, only reduces the slow value. When activated via the sub-spell on the trap itself, reduces slow value and duration, and increases damage per tick."
function modifier_imba_templar_assassin_trap_slow:IgnoreTenacity() return true end

function modifier_imba_templar_assassin_trap_slow:GetTexture() return "templar_assassin_psionic_trap" end

function modifier_imba_templar_assassin_trap_slow:GetEffectName()
	return "particles/units/heroes/hero_templar_assassin/templar_assassin_trap_slow.vpcf"
end

function modifier_imba_templar_assassin_trap_slow:OnCreated(params)
	-- This is used for tooltip
	self.movement_speed_max = self:GetAbility():GetSpecialValueFor("movement_speed_max")

	if not IsServer() then return end

	self.slow                     = params.slow * (-1)
	self.elapsedTime              = params.elapsedTime

	self.trap_duration_tooltip    = math.max(self:GetAbility():GetSpecialValueFor("trap_duration_tooltip"), self:GetAbility():GetSpecialValueFor("trap_duration"))
	self.trap_bonus_damage        = self:GetAbility():GetSpecialValueFor("trap_bonus_damage") + self:GetCaster():FindTalentValue("special_bonus_imba_templar_assassin_psionic_trap_damage")
	self.trap_max_charge_duration = self:GetAbility():GetSpecialValueFor("trap_max_charge_duration")

	self.interval                 = 1

	if params.bSelfTrigger then
		self.interval = self.interval * (1 - self:GetParent():GetStatusResistance())
	end

	self.damage_per_tick = self.trap_bonus_damage / (self.trap_duration_tooltip / self.interval)

	if self.elapsedTime >= self.trap_max_charge_duration then
		self:StartIntervalThink(self.interval)
	end
end

function modifier_imba_templar_assassin_trap_slow:OnIntervalThink()
	ApplyDamage({
		victim       = self:GetParent(),
		damage       = self.damage_per_tick,
		damage_type  = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		attacker     = self:GetCaster(),
		ability      = self:GetAbility()
	})
end

function modifier_imba_templar_assassin_trap_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_imba_templar_assassin_trap_slow:GetModifierMoveSpeedBonus_Percentage()
	-- if self.slow then
	-- return self.slow
	-- end

	return self:GetStackCount() / 100
end

function modifier_imba_templar_assassin_trap_slow:OnTooltip()
	return self.movement_speed_max
end

-----------------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_TRAP_LIMBS --
-----------------------------------------------

function modifier_imba_templar_assassin_trap_limbs:GetTexture() return "templar_assassin_psionic_trap" end

function modifier_imba_templar_assassin_trap_limbs:OnCreated(params)
	if self:GetAbility() then
		self.inhibit_limbs_attack_slow     = self:GetAbility():GetSpecialValueFor("inhibit_limbs_attack_slow")
		self.inhibit_limbs_attack_slow_pct = self:GetAbility():GetSpecialValueFor("inhibit_limbs_attack_slow_pct")
		self.inhibit_limbs_turn_rate_slow  = self:GetAbility():GetSpecialValueFor("inhibit_limbs_turn_rate_slow")
	elseif params then
		self.inhibit_limbs_attack_slow     = params.inhibit_limbs_attack_slow
		self.inhibit_limbs_attack_slow_pct = params.inhibit_limbs_attack_slow_pct
		self.inhibit_limbs_turn_rate_slow  = params.inhibit_limbs_turn_rate_slow
	else -- Stupid hard-coded stuff for Rubick...
		self.inhibit_limbs_attack_slow     = 50
		self.inhibit_limbs_attack_slow_pct = 10
		self.inhibit_limbs_turn_rate_slow  = -50
	end

	self.attack_speed_slow = math.max(self:GetParent():GetAttackSpeed() * self.inhibit_limbs_attack_slow_pct, self.inhibit_limbs_attack_slow) * (-1)
	self.interval          = 0.1

	self:StartIntervalThink(self.interval)
end

function modifier_imba_templar_assassin_trap_limbs:OnIntervalThink()
	self.attack_speed_slow = 0
	self.attack_speed_slow = math.max(self:GetParent():GetAttackSpeed() * self.inhibit_limbs_attack_slow_pct, self.inhibit_limbs_attack_slow) * (-1)
end

function modifier_imba_templar_assassin_trap_limbs:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
	}
end

function modifier_imba_templar_assassin_trap_limbs:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_slow
end

function modifier_imba_templar_assassin_trap_limbs:GetModifierTurnRate_Percentage()
	return self.inhibit_limbs_turn_rate_slow
end

----------------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_TRAP_EYES --
----------------------------------------------

function modifier_imba_templar_assassin_trap_eyes:GetTexture() return "templar_assassin/psionic_trap_eyes" end

function modifier_imba_templar_assassin_trap_eyes:OnCreated(params)
	if self:GetAbility() then
		self.inhibit_eyes_vision_reduction = self:GetAbility():GetSpecialValueFor("inhibit_eyes_vision_reduction")
	elseif params then
		self.inhibit_eyes_vision_reduction = params.inhibit_eyes_vision_reduction
	else -- Stupid hard-coded stuff for Rubick...
		self.inhibit_eyes_vision_reduction = -75
	end
end

function modifier_imba_templar_assassin_trap_eyes:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
		MODIFIER_PROPERTY_DONT_GIVE_VISION_OF_ATTACKER
	}
end

function modifier_imba_templar_assassin_trap_eyes:GetBonusVisionPercentage()
	return self.inhibit_eyes_vision_reduction
end

function modifier_imba_templar_assassin_trap_eyes:GetModifierNoVisionOfAttacker()
	return 1
end

------------------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_TRAP_NERVES --
------------------------------------------------

function modifier_imba_templar_assassin_trap_nerves:GetTexture() return "templar_assassin/psionic_trap_nerves" end

function modifier_imba_templar_assassin_trap_nerves:OnCreated(params)
	if self:GetAbility() then
		self.inhibit_nerves_ministun_duration = self:GetAbility():GetSpecialValueFor("inhibit_nerves_ministun_duration")
	elseif params then
		self.inhibit_nerves_ministun_duration = params.inhibit_nerves_ministun_duration
	else -- Stupid hard-coded stuff for Rubick...
		self.inhibit_nerves_ministun_duration = 0.05
	end

	if not IsServer() then return end

	self.stun_orders = {
		[DOTA_UNIT_ORDER_MOVE_TO_POSITION] = true,
		[DOTA_UNIT_ORDER_MOVE_TO_TARGET]   = true,
		[DOTA_UNIT_ORDER_ATTACK_MOVE]      = true,
		[DOTA_UNIT_ORDER_ATTACK_TARGET]    = true,
		[DOTA_UNIT_ORDER_CAST_POSITION]    = true,
		[DOTA_UNIT_ORDER_CAST_TARGET]      = true,
		[DOTA_UNIT_ORDER_CAST_TARGET_TREE] = true,
		[DOTA_UNIT_ORDER_CAST_NO_TARGET]   = true,
		[DOTA_UNIT_ORDER_CAST_TOGGLE]      = true,
		[DOTA_UNIT_ORDER_DROP_ITEM]        = true
	}
end

function modifier_imba_templar_assassin_trap_nerves:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ORDER }
end

function modifier_imba_templar_assassin_trap_nerves:OnOrder(keys)
	if keys.unit == self:GetParent() and self.stun_orders[keys.order_type] then
		self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = self.inhibit_nerves_ministun_duration * (1 - self:GetParent():GetStatusResistance()) })
	end
end

-----------------------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_TRAP_SPRINGBOARD --
-----------------------------------------------------

function modifier_imba_templar_assassin_trap_springboard:IsPurgable() return false end

function modifier_imba_templar_assassin_trap_springboard:OnCreated(params)
	self.trap_radius                   = self:GetAbility():GetSpecialValueFor("trap_radius")
	self.springboard_min_height        = self:GetAbility():GetSpecialValueFor("springboard_min_height")
	self.springboard_max_height        = self:GetAbility():GetSpecialValueFor("springboard_max_height")
	self.springboard_duration          = self:GetAbility():GetSpecialValueFor("springboard_duration")
	self.springboard_vector_amp        = self:GetAbility():GetSpecialValueFor("springboard_vector_amp")
	self.springboard_movement_slow_pct = self:GetAbility():GetSpecialValueFor("springboard_movement_slow_pct") * (-1)

	if not IsServer() then return end

	-- Initialize some variables
	self.initial_height        = self:GetParent():GetAbsOrigin().z
	self.visual_z_delta        = 0
	self.interval              = FrameTime()

	self.trap_pos              = Vector(params.trap_pos_x, params.trap_pos_y, params.trap_pos_z)
	self.launch_vector         = (self:GetParent():GetAbsOrigin() - self.trap_pos) * Vector(1, 1, 0) * self.springboard_vector_amp

	self.height                = self.springboard_min_height + ((self.springboard_max_height - self.springboard_min_height) * (1 - (self.launch_vector:Length2D() / self.trap_radius)))
	self.duration              = self.springboard_duration

	self.vertical_velocity     = 4 * self.height / self.duration
	self.vertical_acceleration = -(8 * self.height) / (self.duration * self.duration)

	self:StartIntervalThink(self.interval)
end

function modifier_imba_templar_assassin_trap_springboard:OnRefresh(params)
	if not IsServer() then return end

	if self.initial_height then
		self.initial_height = self.initial_height + self.visual_z_delta
	end

	self.trap_pos              = Vector(params.trap_pos_x, params.trap_pos_y, params.trap_pos_z)
	self.launch_vector         = (self:GetParent():GetAbsOrigin() - self.trap_pos) * Vector(1, 1, 0) * self.springboard_vector_amp

	self.vertical_velocity     = 4 * self.height / self.duration
	self.vertical_acceleration = -(8 * self.height) / (self.duration * self.duration)
end

function modifier_imba_templar_assassin_trap_springboard:OnIntervalThink()
	self.visual_z_delta    = self.visual_z_delta + (self.vertical_velocity * self.interval)
	self.vertical_velocity = self.vertical_velocity + (self.vertical_acceleration * self.interval)

	if (self.initial_height + self.visual_z_delta) < GetGroundHeight(self:GetParent():GetAbsOrigin(), nil) or self.visual_z_delta < 0 then
		self:Destroy()
	else
		self:SetStackCount(self.visual_z_delta)
		self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin() + (self.launch_vector * self.interval))
	end
end

function modifier_imba_templar_assassin_trap_springboard:CheckState()
	return { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true }
end

function modifier_imba_templar_assassin_trap_springboard:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_imba_templar_assassin_trap_springboard:GetVisualZDelta()
	return math.max(self:GetStackCount(), 0)
end

function modifier_imba_templar_assassin_trap_springboard:GetModifierMoveSpeedBonus_Percentage()
	return self.springboard_movement_slow_pct
end

-----------------------------------------
-- IMBA_TEMPLAR_ASSASSIN_TRAP_TELEPORT --
-----------------------------------------

function imba_templar_assassin_trap_teleport:GetAssociatedSecondaryAbilities() return "imba_templar_assassin_psionic_trap" end

function imba_templar_assassin_trap_teleport:ProcsMagicStick() return false end

function imba_templar_assassin_trap_teleport:OnInventoryContentsChanged()
	if self:GetCaster():HasScepter() then
		self:SetHidden(false)
	else
		self:SetHidden(true)
	end
end

function imba_templar_assassin_trap_teleport:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

function imba_templar_assassin_trap_teleport:OnChannelFinish(bInterrupted)
	if not bInterrupted then
		if not self.trap_ability then
			self.trap_ability = self:GetCaster():FindAbilityByName("imba_templar_assassin_psionic_trap")
		end

		if not self.counter_modifier or self.counter_modifier:IsNull() then
			self.counter_modifier = self:GetCaster():FindModifierByName("modifier_imba_templar_assassin_psionic_trap_counter")
		end

		if self.trap_ability and self.counter_modifier and self.counter_modifier.trap_table and #self.counter_modifier.trap_table > 0 then
			-- Find closest trap to cursor position
			local distance = nil
			local index    = nil

			for trap_number = 1, #self.counter_modifier.trap_table do
				if self.counter_modifier.trap_table[trap_number] and not self.counter_modifier.trap_table[trap_number]:IsNull() then
					if not distance then
						index    = trap_number
						distance = (self:GetCursorPosition() - self.counter_modifier.trap_table[trap_number]:GetParent():GetAbsOrigin()):Length2D()
					elseif ((self:GetCursorPosition() - self.counter_modifier.trap_table[trap_number]:GetParent():GetAbsOrigin()):Length2D() < distance) then
						index    = trap_number
						distance = (self:GetCursorPosition() - self.counter_modifier.trap_table[trap_number]:GetParent():GetAbsOrigin()):Length2D()
					end
				end
			end

			if index then
				FindClearSpaceForUnit(self:GetCaster(), self.counter_modifier.trap_table[index]:GetParent():GetAbsOrigin(), false)
				self.counter_modifier.trap_table[index]:Explode(self.trap_ability, self:GetSpecialValueFor("trap_radius"), self:GetSpecialValueFor("trap_duration"))

				if self:GetCaster():HasModifier("modifier_imba_templar_assassin_meld") then
					self:GetCaster():FindModifierByName("modifier_imba_templar_assassin_meld").cast_position = self:GetCaster():GetAbsOrigin()
				end
			end
		end
	end
end

----------------------------------------
-- IMBA_TEMPLAR_ASSASSIN_PSIONIC_TRAP --
----------------------------------------

function imba_templar_assassin_psionic_trap:GetAssociatedPrimaryAbilities() return "imba_templar_assassin_trap" end

function imba_templar_assassin_psionic_trap:GetIntrinsicModifierName()
	return "modifier_imba_templar_assassin_psionic_trap_counter"
end

function imba_templar_assassin_psionic_trap:GetAbilityTextureName()
	if self:GetCaster():GetModifierStackCount("modifier_imba_templar_assassin_psionic_trap_handler", self:GetCaster()) <= 0 then
		return "templar_assassin_psionic_trap"
	elseif self:GetCaster():GetModifierStackCount("modifier_imba_templar_assassin_psionic_trap_handler", self:GetCaster()) == 1 then
		return "templar_assassin/psionic_trap_eyes"
	elseif self:GetCaster():GetModifierStackCount("modifier_imba_templar_assassin_psionic_trap_handler", self:GetCaster()) == 2 then
		return "templar_assassin/psionic_trap_nerves"
	else
		return "templar_assassin_psionic_trap"
	end
end

function imba_templar_assassin_psionic_trap:GetAOERadius()
	return self:GetSpecialValueFor("trap_radius")
end

function imba_templar_assassin_psionic_trap:OnUpgrade()
	if self:GetCaster():HasAbility("imba_templar_assassin_trap") then
		self:GetCaster():FindAbilityByName("imba_templar_assassin_trap"):SetLevel(self:GetLevel())
	end

	if self:GetCaster():HasAbility("imba_templar_assassin_trap_teleport") then
		self:GetCaster():FindAbilityByName("imba_templar_assassin_trap_teleport"):SetLevel(self:GetLevel())
	end
end

function imba_templar_assassin_psionic_trap:OnSpellStart()
	if not self.counter_modifier or self.counter_modifier:IsNull() then
		self.counter_modifier = self:GetCaster():FindModifierByName("modifier_imba_templar_assassin_psionic_trap_counter")
	end

	if self.counter_modifier and self.counter_modifier.trap_table then
		self:GetCaster():EmitSound("Hero_TemplarAssassin.Trap.Cast")
		EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "Hero_TemplarAssassin.Trap", self:GetCaster())

		if self:GetCaster():GetName() == "npc_dota_hero_templar_assassin" then
			if RollPercentage(1) then
				self:GetCaster():EmitSound("templar_assassin_temp_psionictrap_04")
			elseif RollPercentage(50) then
				self:GetCaster():EmitSound("templar_assassin_temp_psionictrap_0" .. RandomInt(1, 3))
			end
		end

		local trap = CreateUnitByName("npc_dota_templar_assassin_psionic_trap", self:GetCursorPosition(), false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		FindClearSpaceForUnit(trap, trap:GetAbsOrigin(), false)

		local trap_modifier = trap:AddNewModifier(self:GetCaster(), self, "modifier_imba_templar_assassin_psionic_trap", {})
		trap:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)

		if trap:HasAbility("imba_templar_assassin_self_trap") then
			trap:FindAbilityByName("imba_templar_assassin_self_trap"):SetHidden(false) -- TODO: Temp line
			trap:FindAbilityByName("imba_templar_assassin_self_trap"):SetLevel(self:GetLevel())
		end

		table.insert(self.counter_modifier.trap_table, trap_modifier)

		if #self.counter_modifier.trap_table > self:GetTalentSpecialValueFor("max_traps") then
			if self.counter_modifier.trap_table[1]:GetParent() then
				self.counter_modifier.trap_table[1]:GetParent():ForceKill(false)
			end
		end

		self.counter_modifier:SetStackCount(#self.counter_modifier.trap_table)

		if self:GetCaster():HasAbility("imba_templar_assassin_trap") and self:GetCaster():FindAbilityByName("imba_templar_assassin_trap"):GetLevel() ~= self:GetLevel() then
			self:GetCaster():FindAbilityByName("imba_templar_assassin_trap"):SetLevel(self:GetLevel())
		end

		if self:GetCaster():HasAbility("imba_templar_assassin_trap_teleport") and self:GetCaster():FindAbilityByName("imba_templar_assassin_trap_teleport"):GetLevel() ~= self:GetLevel() then
			self:GetCaster():FindAbilityByName("imba_templar_assassin_trap_teleport"):SetLevel(self:GetLevel())
		end
	end
end

---------------------------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_PSIONIC_TRAP_HANDLER --
---------------------------------------------------------

function modifier_imba_templar_assassin_psionic_trap_handler:IsHidden() return true end

function modifier_imba_templar_assassin_psionic_trap_handler:IsPurgable() return false end

function modifier_imba_templar_assassin_psionic_trap_handler:RemoveOnDeath() return false end

function modifier_imba_templar_assassin_psionic_trap_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_templar_assassin_psionic_trap_handler:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ORDER }
end

function modifier_imba_templar_assassin_psionic_trap_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end

	if not self:GetAbility():GetAutoCastState() then
		if self:GetStackCount() >= 2 then
			self:SetStackCount(0)
		else
			self:IncrementStackCount()
		end

		self:GetAbility():ToggleAutoCast()
	end
end

-------------------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_PSIONIC_TRAP --
-------------------------------------------------

function modifier_imba_templar_assassin_psionic_trap:IsHidden() return self:GetElapsedTime() < self.trap_max_charge_duration end

function modifier_imba_templar_assassin_psionic_trap:IsPurgable() return false end

function modifier_imba_templar_assassin_psionic_trap:GetTexture() return "templar_assassin_psionic_trap" end

-- function modifier_imba_templar_assassin_psionic_trap:GetEffectName()
-- return "particles/units/heroes/hero_templar_assassin/templar_assassin_trap.vpcf"
-- end

function modifier_imba_templar_assassin_psionic_trap:OnCreated()
	self.trap_fade_time                   = self:GetAbility():GetSpecialValueFor("trap_fade_time")
	self.movement_speed_min               = self:GetAbility():GetSpecialValueFor("movement_speed_min")
	self.movement_speed_max               = self:GetAbility():GetSpecialValueFor("movement_speed_max")
	self.trap_duration_tooltip            = self:GetAbility():GetSpecialValueFor("trap_duration_tooltip")
	self.trap_bonus_damage                = self:GetAbility():GetSpecialValueFor("trap_bonus_damage") + self:GetCaster():FindTalentValue("special_bonus_imba_templar_assassin_psionic_trap_damage")
	self.trap_max_charge_duration         = self:GetAbility():GetSpecialValueFor("trap_max_charge_duration")

	self.inhibit_limbs_attack_slow        = self:GetAbility():GetSpecialValueFor("inhibit_limbs_attack_slow")
	self.inhibit_limbs_attack_slow_pct    = self:GetAbility():GetSpecialValueFor("inhibit_limbs_attack_slow_pct")
	self.inhibit_limbs_turn_rate_slow     = self:GetAbility():GetSpecialValueFor("inhibit_limbs_turn_rate_slow")
	self.inhibit_eyes_vision_reduction    = self:GetAbility():GetSpecialValueFor("inhibit_eyes_vision_reduction")
	self.inhibit_nerves_ministun_duration = self:GetAbility():GetSpecialValueFor("inhibit_nerves_ministun_duration")

	if not IsServer() then return end

	if self:GetCaster():GetModifierStackCount("modifier_imba_templar_assassin_psionic_trap_handler", self:GetCaster()) <= 0 then
		self.color     = Vector(0, 0, 0)
		self.bColor    = 0
		self.inhibitor = "modifier_imba_templar_assassin_trap_limbs"
	elseif self:GetCaster():GetModifierStackCount("modifier_imba_templar_assassin_psionic_trap_handler", self:GetCaster()) == 1 then
		self.color     = Vector(94, 94, 94)
		self.bColor    = 1
		self.inhibitor = "modifier_imba_templar_assassin_trap_eyes"
	elseif self:GetCaster():GetModifierStackCount("modifier_imba_templar_assassin_psionic_trap_handler", self:GetCaster()) == 2 then
		self.color     = Vector(141, 0, 0)
		self.bColor    = 1
		self.inhibitor = "modifier_imba_templar_assassin_trap_nerves"
	else
		self.color     = Vector(0, 0, 0)
		self.bColor    = 0
		self.inhibitor = "modifier_imba_templar_assassin_trap_limbs"
	end

	-- This could prove problematic if it's a special set trap particle since those don't have the color CPs for some reason while the main one does...
	self.self_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_trap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.self_particle, 60, self.color)
	ParticleManager:SetParticleControl(self.self_particle, 61, Vector(self.bColor, 0, 0))
	self:AddParticle(self.self_particle, false, false, -1, false, false)

	self.trap_counter_modifier = self:GetCaster():FindModifierByName("modifier_imba_templar_assassin_psionic_trap_counter")
end

function modifier_imba_templar_assassin_psionic_trap:OnDestroy()
	if not IsServer() then return end

	if self.trap_counter_modifier and self.trap_counter_modifier.trap_table then
		for trap_modifier = 1, #self.trap_counter_modifier.trap_table do
			if self.trap_counter_modifier.trap_table[trap_modifier] == self then
				table.remove(self.trap_counter_modifier.trap_table, trap_modifier)

				if self:GetCaster():HasModifier("modifier_imba_templar_assassin_psionic_trap_counter") then
					self:GetCaster():FindModifierByName("modifier_imba_templar_assassin_psionic_trap_counter"):DecrementStackCount()
				end

				break
			end
		end
	end
end

function modifier_imba_templar_assassin_psionic_trap:CheckState()
	if self:GetElapsedTime() >= self.trap_fade_time then
		return {
			[MODIFIER_STATE_INVISIBLE]         = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true
		}
	else
		return {
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true
		}
	end
end

function modifier_imba_templar_assassin_psionic_trap:Explode(ability, radius, trap_duration, bSelfTrigger)
	self:GetParent():EmitSound("Hero_TemplarAssassin.Trap.Explode")

	self.explode_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.explode_particle, 60, self.color)
	ParticleManager:SetParticleControl(self.explode_particle, 61, Vector(self.bColor, 0, 0))
	ParticleManager:ReleaseParticleIndex(self.explode_particle)

	if self:GetParent():GetOwner() then
		for _, enemy in pairs(FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			local slow_modifier = enemy:AddNewModifier(self:GetParent():GetOwner(), ability, "modifier_imba_templar_assassin_trap_slow", {
				duration     = trap_duration,
				-- "The slow starts at 30% and increases by 0.75% in 0.1 second intervals"
				slow         = math.min(self.movement_speed_min + (((self.movement_speed_max - self.movement_speed_min) / self.trap_max_charge_duration) * math.floor(self:GetElapsedTime() * 10) / 10), self.movement_speed_max),
				elapsedTime  = self:GetElapsedTime(),
				bSelfTrigger = bSelfTrigger
			})

			if slow_modifier then
				-- "When activated via the sub-spell on the caster, only reduces the slow value. When activated via the sub-spell on the trap itself, reduces slow value and duration, and increases damage per tick."
				-- wtf
				slow_modifier:SetStackCount(math.min(self.movement_speed_min + (((self.movement_speed_max - self.movement_speed_min) / self.trap_max_charge_duration) * math.floor(self:GetElapsedTime() * 10) / 10), self.movement_speed_max) * 100 * (1 - enemy:GetStatusResistance()) * (-1))

				if bSelfTrigger then
					slow_modifier:SetDuration(trap_duration * (1 - enemy:GetStatusResistance()), true)
				end
			end

			-- IMBAfication: Psychic Inhibitor
			if self:GetElapsedTime() >= self.trap_max_charge_duration and self.inhibitor then
				local inhibitor_modifier = enemy:AddNewModifier(self:GetParent():GetOwner(), ability, self.inhibitor, {
					duration                         = trap_duration,
					inhibit_limbs_attack_slow        = self.inhibit_limbs_attack_slow,
					inhibit_limbs_attack_slow_pct    = self.inhibit_limbs_attack_slow_pct,
					inhibit_limbs_turn_rate_slow     = self.inhibit_limbs_turn_rate_slow,
					inhibit_eyes_vision_reduction    = self.inhibit_eyes_vision_reduction,
					inhibit_nerves_ministun_duration = self.inhibit_nerves_ministun_duration
				})

				if inhibitor_modifier then
					inhibitor_modifier:SetDuration(trap_duration * (1 - enemy:GetStatusResistance()), true)
				end
			end
		end

		-- IMBAfication: Springboard
		if self:GetParent():GetOwner():HasAbility("imba_templar_assassin_trap") and self:GetParent():GetOwner():FindAbilityByName("imba_templar_assassin_trap"):GetAutoCastState() and (self:GetParent():GetOwner():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= radius and not self:GetParent():GetOwner():IsRooted() then
			local springboard_ability = self:GetParent():GetOwner():FindAbilityByName("imba_templar_assassin_trap")

			self:GetParent():GetOwner():AddNewModifier(self:GetParent():GetOwner(), springboard_ability, "modifier_imba_templar_assassin_trap_springboard", {
				trap_pos_x = self:GetParent():GetAbsOrigin().x,
				trap_pos_y = self:GetParent():GetAbsOrigin().y,
				trap_pos_z = self:GetParent():GetAbsOrigin().z,
			})
		end
	end

	self:GetParent():ForceKill(false)
	self:Destroy()
end

---------------------------------------------------------
-- MODIFIER_IMBA_TEMPLAR_ASSASSIN_PSIONIC_TRAP_COUNTER --
---------------------------------------------------------

function modifier_imba_templar_assassin_psionic_trap_counter:GetTexture() return "templar_assassin_psionic_trap" end

function modifier_imba_templar_assassin_psionic_trap_counter:OnCreated()
	if not IsServer() then return end

	self.trap_table = {}

	-- IMBAfication: Psychic Inhibitor
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_templar_assassin_psionic_trap_handler", {})
end

function modifier_imba_templar_assassin_psionic_trap_counter:OnDestroy()
	if not IsServer() then return end

	self:GetParent():RemoveModifierByName("modifier_imba_templar_assassin_psionic_trap_handler")
end

-------------------------------------
-- IMBA_TEMPLAR_ASSASSIN_SELF_TRAP --
-------------------------------------

function imba_templar_assassin_self_trap:IsStealable() return false end

function imba_templar_assassin_self_trap:ProcsMagicStick() return false end

function imba_templar_assassin_self_trap:OnSpellStart()
	if self:GetCaster():GetOwner() then
		self.trap_counter_modifier = self:GetCaster():GetOwner():FindModifierByName("modifier_imba_templar_assassin_psionic_trap_counter")

		-- I accidentally a FIFO
		-- if self:GetCaster():HasModifier("modifier_imba_templar_assassin_psionic_trap") and self.trap_counter_modifier and self.trap_counter_modifier.trap_table and #self.trap_counter_modifier.trap_table and self.trap_counter_modifier.trap_table[1] and not self.trap_counter_modifier.trap_table[1]:IsNull() and self:GetCaster():GetOwner():HasAbility("imba_templar_assassin_psionic_trap") then
		-- self.trap_counter_modifier.trap_table[1]:Explode(self:GetCaster():GetOwner():FindAbilityByName("imba_templar_assassin_psionic_trap"), self:GetSpecialValueFor("trap_radius"), self:GetSpecialValueFor("trap_duration"), true)

		-- -- I don't think this is vanilla to re-select the hero but it seems like a QOL thing to have it
		-- PlayerResource:NewSelection(self:GetCaster():GetOwner():GetPlayerID(), self:GetCaster():GetOwner())


		if self:GetCaster():HasModifier("modifier_imba_templar_assassin_psionic_trap") then
			self:GetCaster():FindModifierByName("modifier_imba_templar_assassin_psionic_trap"):Explode(self, self:GetSpecialValueFor("trap_radius"), self:GetSpecialValueFor("trap_duration"), true)

			-- I don't think this is vanilla to re-select the hero but it seems like a QOL thing to have it
			PlayerResource:NewSelection(self:GetCaster():GetOwner():GetPlayerID(), self:GetCaster():GetOwner())
		end
	end
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_templar_assassin_meld_dispels", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_templar_assassin_meld_bash", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_templar_assassin_refraction_instances", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_templar_assassin_meld_dispels         = modifier_special_bonus_imba_templar_assassin_meld_dispels or class({})
modifier_special_bonus_imba_templar_assassin_meld_bash            = modifier_special_bonus_imba_templar_assassin_meld_bash or class({})
modifier_special_bonus_imba_templar_assassin_refraction_instances = modifier_special_bonus_imba_templar_assassin_refraction_instances or class({})

function modifier_special_bonus_imba_templar_assassin_meld_dispels:IsHidden() return true end

function modifier_special_bonus_imba_templar_assassin_meld_dispels:IsPurgable() return false end

function modifier_special_bonus_imba_templar_assassin_meld_dispels:RemoveOnDeath() return false end

function modifier_special_bonus_imba_templar_assassin_meld_bash:IsHidden() return true end

function modifier_special_bonus_imba_templar_assassin_meld_bash:IsPurgable() return false end

function modifier_special_bonus_imba_templar_assassin_meld_bash:RemoveOnDeath() return false end

function modifier_special_bonus_imba_templar_assassin_refraction_instances:IsHidden() return true end

function modifier_special_bonus_imba_templar_assassin_refraction_instances:IsPurgable() return false end

function modifier_special_bonus_imba_templar_assassin_refraction_instances:RemoveOnDeath() return false end

LinkLuaModifier("modifier_special_bonus_imba_templar_assassin_meld_armor_reduction", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_templar_assassin_psionic_trap_damage", "components/abilities/heroes/hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_templar_assassin_meld_armor_reduction = modifier_special_bonus_imba_templar_assassin_meld_armor_reduction or class({})
modifier_special_bonus_imba_templar_assassin_psionic_trap_damage  = modifier_special_bonus_imba_templar_assassin_psionic_trap_damage or class({})

function modifier_special_bonus_imba_templar_assassin_meld_armor_reduction:IsHidden() return true end

function modifier_special_bonus_imba_templar_assassin_meld_armor_reduction:IsPurgable() return false end

function modifier_special_bonus_imba_templar_assassin_meld_armor_reduction:RemoveOnDeath() return false end

function modifier_special_bonus_imba_templar_assassin_psionic_trap_damage:IsHidden() return true end

function modifier_special_bonus_imba_templar_assassin_psionic_trap_damage:IsPurgable() return false end

function modifier_special_bonus_imba_templar_assassin_psionic_trap_damage:RemoveOnDeath() return false end

function imba_templar_assassin_meld:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_templar_assassin_meld_armor_reduction") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_templar_assassin_meld_armor_reduction") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_templar_assassin_meld_armor_reduction"), "modifier_special_bonus_imba_templar_assassin_meld_armor_reduction", {})
	end
end

function imba_templar_assassin_psionic_trap:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_templar_assassin_psionic_trap_damage") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_templar_assassin_psionic_trap_damage") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_templar_assassin_psionic_trap_damage"), "modifier_special_bonus_imba_templar_assassin_psionic_trap_damage", {})
	end
end
