-- Editors:
--    AltiV, October 4th, 2019

LinkLuaModifier("modifier_imba_oracle_fortunes_end_delay", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_oracle_fortunes_end_purge", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_oracle_fortunes_end_purge_alter", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_oracle_fates_edict_delay", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_oracle_fates_edict", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_oracle_fates_edict_alter", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_oracle_purifying_flames", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_oracle_purifying_flames_alter", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_oracle_alter_self", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_oracle_false_promise_delay", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_oracle_false_promise_timer", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_oracle_false_promise_timer_alter", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_oracle_false_promise_timer_alter_targets", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)

imba_oracle_fortunes_end                               = class({})
modifier_imba_oracle_fortunes_end_delay                = class({})
modifier_imba_oracle_fortunes_end_purge                = class({})
modifier_imba_oracle_fortunes_end_purge_alter          = class({})

imba_oracle_fates_edict                                = class({})
modifier_imba_oracle_fates_edict_delay                 = class({})
modifier_imba_oracle_fates_edict                       = class({})
modifier_imba_oracle_fates_edict_alter                 = class({})

imba_oracle_purifying_flames                           = class({})
modifier_imba_oracle_purifying_flames                  = class({})
modifier_imba_oracle_purifying_flames_alter            = class({})

imba_oracle_alter_self                                 = class({})
modifier_imba_oracle_alter_self                        = class({})

imba_oracle_false_promise_alter                        = imba_oracle_false_promise_alter or class({})

imba_oracle_false_promise                              = class({})
modifier_imba_oracle_false_promise_delay               = class({})
modifier_imba_oracle_false_promise_timer               = class({})
modifier_imba_oracle_false_promise_timer_alter         = class({})
modifier_imba_oracle_false_promise_timer_alter_targets = class({})

------------------------------
-- IMBA_ORACLE_FORTUNES_END --
------------------------------

function imba_oracle_fortunes_end:GetAbilityTextureName()
	if not self:GetCaster():HasModifier("modifier_imba_oracle_alter_self") then
		return "oracle_fortunes_end"
	else
		return "oracle/fortunes_end_alter"
	end
end

function imba_oracle_fortunes_end:GetAOERadius()
	if not self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("radius")
	else
		return self:GetSpecialValueFor("radius") + self:GetSpecialValueFor("scepter_bonus_radius")
	end
end

function imba_oracle_fortunes_end:GetCastRange(location, target)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCastRange(self, location, target)
	else
		return self.BaseClass.GetCastRange(self, location, target) + self:GetSpecialValueFor("scepter_bonus_range")
	end
end

function imba_oracle_fortunes_end:OnSpellStart()
	self.target            = self:GetCursorTarget()

	self.channel_sound     = "Hero_Oracle.FortunesEnd.Channel"
	self.attack_sound      = "Hero_Oracle.FortunesEnd.Attack"
	self.target_sound      = "Hero_Oracle.FortunesEnd.Target"
	self.channel_particle  = "particles/units/heroes/hero_oracle/oracle_fortune_channel.vpcf"
	self.tgt_particle      = "particles/units/heroes/hero_oracle/oracle_fortune_cast_tgt.vpcf"
	self.effect_name       = "particles/units/heroes/hero_oracle/oracle_fortune_prj.vpcf"
	self.aoe_particle_name = "particles/units/heroes/hero_oracle/oracle_fortune_aoe.vpcf"
	self.modifier_name     = "modifier_imba_oracle_fortunes_end_purge"

	if self:GetCaster():HasModifier("modifier_imba_oracle_alter_self") then
		self.channel_sound     = "Hero_Oracle.FortunesEnd.Channel_Alter"
		self.attack_sound      = "Hero_Oracle.FortunesEnd.Attack_Alter"
		self.target_sound      = "Hero_Oracle.FortunesEnd.Target_Alter"
		self.channel_particle  = "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_channel.vpcf"
		self.tgt_particle      = "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_cast_tgt.vpcf"
		self.effect_name       = "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_proj.vpcf"
		self.aoe_particle_name = "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_aoe.vpcf"
		self.modifier_name     = "modifier_imba_oracle_fortunes_end_purge_alter"
	end

	self.autocast_state = self:GetAutoCastState()

	self:GetCaster():EmitSound(self.channel_sound)

	if self:GetCaster():GetName() == "npc_dota_hero_oracle" and RollPercentage(50) then
		self:GetCaster():EmitSound("oracle_orac_fortunesend_0" .. RandomInt(1, 6))
	end

	if self.fortunes_particle then
		ParticleManager:DestroyParticle(self.fortunes_particle, false)
		ParticleManager:ReleaseParticleIndex(self.fortunes_particle)
	end

	self.fortunes_particle = ParticleManager:CreateParticle(self.channel_particle, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.fortunes_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)

	self.target_particle = ParticleManager:CreateParticle(self.tgt_particle, PATTACH_ABSORIGIN_FOLLOW, self:GetCursorTarget())
	ParticleManager:ReleaseParticleIndex(self.target_particle)
end

-- function imba_oracle_fortunes_end:OnChannelThink(flInterval)

-- end

function imba_oracle_fortunes_end:OnChannelFinish(bInterrupted)
	self:GetCaster():StopSound(self.channel_sound)
	self:GetCaster():EmitSound(self.attack_sound)

	if self.fortunes_particle then
		ParticleManager:DestroyParticle(self.fortunes_particle, false)
		ParticleManager:ReleaseParticleIndex(self.fortunes_particle)
	end

	ProjectileManager:CreateTrackingProjectile({
		Target            = self.target,
		Source            = self:GetCaster(),
		Ability           = self,
		EffectName        = self.effect_name,
		iMoveSpeed        = self:GetSpecialValueFor("bolt_speed"),
		vSourceLoc        = self:GetCaster():GetAbsOrigin(),
		bDrawsOnMinimap   = false,
		bDodgeable        = false,
		bIsAttack         = false,
		bVisibleToEnemies = true,
		bReplaceExisting  = false,
		flExpireTime      = GameRules:GetGameTime() + 10.0,
		bProvidesVision   = false,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		ExtraData         = {
			charge_pct        = ((GameRules:GetGameTime() - self:GetChannelStartTime()) / self:GetChannelTime()),
			target_sound      = self.target_sound,
			aoe_particle_name = self.aoe_particle_name,
			modifier_name     = self.modifier_name,
			autocast_state    = self.autocast_state
		}
	})
end

-- -- There's some issue with the projectile not doing anything on reflected targets (ex. Lotus Orb), but I can't figure out what the cause is
-- -- The projectile still flies towards said reflected target, but it never calls the thinker or hit functions
-- function imba_oracle_fortunes_end:OnProjectileThink_ExtraData(target, location, data)

-- end

function imba_oracle_fortunes_end:OnProjectileHit_ExtraData(target, location, data)
	if target and data.charge_pct and not target:TriggerSpellAbsorb(self) then
		if not data.autocast_state or data.autocast_state == 0 then
			self:ApplyFortunesEnd(target, data.target_sound, data.aoe_particle_name, data.modifier_name, data.charge_pct)
		else
			target:AddNewModifier(self:GetCaster(), self, "modifier_imba_oracle_fortunes_end_delay", {
				duration          = self:GetSpecialValueFor("mergence_delay"),
				target_sound      = data.target_sound,
				aoe_particle_name = data.aoe_particle_name,
				modifier_name     = data.modifier_name,
				charge_pct        = data.charge_pct
			})
		end
	end
end

function imba_oracle_fortunes_end:ApplyFortunesEnd(target, target_sound, aoe_particle_name, modifier_name, charge_pct)
	local radius = self:GetSpecialValueFor("radius")

	if self:GetCaster():HasScepter() then
		radius = self:GetSpecialValueFor("radius") + self:GetSpecialValueFor("scepter_bonus_radius")
	end

	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), target_sound, self:GetCaster())

	if aoe_particle_name then
		self.aoe_particle = ParticleManager:CreateParticle(aoe_particle_name, PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(self.aoe_particle, 0, target:GetAbsOrigin())

		ParticleManager:SetParticleControl(self.aoe_particle, 2, Vector(radius, radius, radius))
		ParticleManager:ReleaseParticleIndex(self.aoe_particle)
	end

	-- "Fortune's End first applies the dispel, then the debuff, then the damage."
	if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		target:Purge(false, true, false, false, false)
	end

	-- "Always removes Fate's Edict on affected targets."
	if target:HasModifier("modifier_imba_oracle_fates_edict") then
		target:RemoveModifierByName("modifier_imba_oracle_fates_edict")
	end

	if target:HasModifier("modifier_imba_oracle_fates_edict_alter") then
		target:RemoveModifierByName("modifier_imba_oracle_fates_edict_alter")
	end

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		self.damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(self.damage_particle, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.damage_particle, 3, enemy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.damage_particle)

		enemy:Purge(true, false, false, false, false)

		enemy:AddNewModifier(self:GetCaster(), self, modifier_name, { duration = (math.max(self:GetTalentSpecialValueFor("maximum_purge_duration") * math.min(charge_pct, 1), self:GetSpecialValueFor("minimum_purge_duration")) * (1 - enemy:GetStatusResistance())) })

		ApplyDamage({
			victim       = enemy,
			damage       = self:GetSpecialValueFor("damage"),
			damage_type  = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self:GetCaster(),
			ability      = self
		})
	end
end

---------------------------------------------
-- MODIFIER_IMBA_ORACLE_FORTUNES_END_DELAY --
---------------------------------------------

function modifier_imba_oracle_fortunes_end_delay:IsPurgable() return false end

function modifier_imba_oracle_fortunes_end_delay:RemoveOnDeath() return false end

function modifier_imba_oracle_fortunes_end_delay:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_oracle_fortunes_end_delay:IgnoreTenacity() return true end

function modifier_imba_oracle_fortunes_end_delay:GetTexture()
	if self.texture_name then
		return self.texture_name
	else
		return "oracle_fortunes_end"
	end
end

function modifier_imba_oracle_fortunes_end_delay:OnCreated(params)
	self.texture_name = "oracle_fortunes_end"

	if self:GetCaster():HasModifier("modifier_imba_oracle_alter_self") then
		self.texture_name = "oracle/fortunes_end_alter"
	end

	if not IsServer() then return end

	self.target_sound      = params.target_sound
	self.aoe_particle_name = params.aoe_particle_name
	self.modifier_name     = params.modifier_name
	self.charge_pct        = params.charge_pct
end

function modifier_imba_oracle_fortunes_end_delay:OnDestroy()
	if not IsServer() or not self:GetAbility() or not self:GetParent():IsAlive() or self:GetRemainingTime() > 0 then return end

	self:GetAbility():ApplyFortunesEnd(self:GetParent(), self.target_sound, self.aoe_particle_name, self.modifier_name, self.charge_pct)
end

---------------------------------------------
-- MODIFIER_IMBA_ORACLE_FORTUNES_END_PURGE --
---------------------------------------------

function modifier_imba_oracle_fortunes_end_purge:GetTexture()
	return "oracle_fortunes_end"
end

function modifier_imba_oracle_fortunes_end_purge:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_fortune_purge.vpcf"
end

function modifier_imba_oracle_fortunes_end_purge:CheckState()
	if self:GetAbility() and self:GetCaster():HasScepter() and (self:GetElapsedTime() / (self:GetElapsedTime() + self:GetRemainingTime())) <= self:GetAbility():GetSpecialValueFor("scepter_stun_percentage") / 100 then
		return {
			[MODIFIER_STATE_STUNNED]   = true,
			[MODIFIER_STATE_ROOTED]    = true,
			[MODIFIER_STATE_INVISIBLE] = false -- This might not be technically correct
		}
	else
		return {
			[MODIFIER_STATE_ROOTED]    = true,
			[MODIFIER_STATE_INVISIBLE] = false -- This might not be technically correct
		}
	end
end

---------------------------------------------------
-- MODIFIER_IMBA_ORACLE_FORTUNES_END_PURGE_ALTER --
---------------------------------------------------

function modifier_imba_oracle_fortunes_end_purge_alter:GetTexture()
	return "oracle/fortunes_end_alter"
end

function modifier_imba_oracle_fortunes_end_purge_alter:GetEffectName()
	return "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_purge.vpcf"
end

-- Doesn't work properly with the effect name above
-- function modifier_imba_oracle_fortunes_end_purge_alter:GetStatusEffectName()
-- return "particles/status_fx/status_effect_obsidian_matter.vpcf"
-- end

function modifier_imba_oracle_fortunes_end_purge_alter:OnCreated()
	if not IsServer() then return end

	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_fear_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle, 60, Vector(255, 0, 0))
	ParticleManager:SetParticleControl(self.particle, 61, Vector(1, 0, 0))
	self:AddParticle(self.particle, false, false, -1, true, true)
end

function modifier_imba_oracle_fortunes_end_purge_alter:CheckState()
	if self:GetAbility() and self:GetCaster():HasScepter() and (self:GetElapsedTime() / (self:GetElapsedTime() + self:GetRemainingTime())) <= self:GetAbility():GetSpecialValueFor("scepter_stun_percentage") / 100 then
		return {
			[MODIFIER_STATE_STUNNED]            = true,
			[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
			[MODIFIER_STATE_INVISIBLE]          = false -- This might not be technically correct
		}
	else
		return {
			[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
			[MODIFIER_STATE_INVISIBLE]          = false -- This might not be technically correct
		}
	end
end

-----------------------------
-- IMBA_ORACLE_FATES_EDICT --
-----------------------------

function imba_oracle_fates_edict:GetAbilityTextureName()
	if not self:GetCaster():HasModifier("modifier_imba_oracle_alter_self") then
		return "oracle_fates_edict"
	else
		return "oracle/fates_edict_alter"
	end
end

function imba_oracle_fates_edict:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_oracle_fates_edict_cooldown")
end

function imba_oracle_fates_edict:OnSpellStart()
	local target = self:GetCursorTarget()

	if target:TriggerSpellAbsorb(self) then return end

	self.cast_sound    = "Hero_Oracle.FatesEdict.Cast"
	-- self.channel_particle	= "particles/units/heroes/hero_oracle/oracle_fortune_channel.vpcf"
	-- self.tgt_particle		= "particles/units/heroes/hero_oracle/oracle_fortune_cast_tgt.vpcf"
	-- self.effect_name		= "particles/units/heroes/hero_oracle/oracle_fortune_prj.vpcf"
	-- self.aoe_particle_name	= "particles/units/heroes/hero_oracle/oracle_fortune_aoe.vpcf"
	self.modifier_name = "modifier_imba_oracle_fates_edict"

	if self:GetCaster():HasModifier("modifier_imba_oracle_alter_self") then
		self.cast_sound    = "Hero_Oracle.FatesEdict.Cast_Alter"
		-- self.channel_particle	= "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_channel.vpcf"
		-- self.tgt_particle		= "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_cast_tgt.vpcf"
		-- self.effect_name		= "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_proj.vpcf"
		-- self.aoe_particle_name	= "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_aoe.vpcf"
		self.modifier_name = "modifier_imba_oracle_fates_edict_alter"
	end

	if not self:GetAutoCastState() then
		self:ApplyFatesEdict(target, self.cast_sound, self.modifier_name)
	else
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_oracle_fates_edict_delay", {
			duration      = self:GetSpecialValueFor("decree_delay"),
			cast_sound    = self.cast_sound,
			modifier_name = self.modifier_name
		})
	end
end

function imba_oracle_fates_edict:ApplyFatesEdict(target, cast_sound, modifier_name)
	self:GetCaster():EmitSound(cast_sound)
	target:EmitSound("Hero_Oracle.FatesEdict")

	if self:GetCaster():GetName() == "npc_dota_hero_oracle" and RollPercentage(50) then
		if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			if target ~= self:GetCaster() then
				self:GetCaster():EmitSound("oracle_orac_fatesedict_0" .. RandomInt(1, 6))
			else
				self:GetCaster():EmitSound("oracle_orac_fatesedict_1" .. RandomInt(0, 7))
			end
		else
			self:GetCaster():EmitSound("oracle_orac_fatesedict_0" .. RandomInt(7, 9))
		end
	end

	self.edict_modifier = target:AddNewModifier(self:GetCaster(), self, self.modifier_name, { duration = self:GetSpecialValueFor("duration") })

	if self.edict_modifier and target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		self.edict_modifier:SetDuration(self:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance()), true)
	end
end

--------------------------------------------
-- MODIFIER_IMBA_ORACLE_FATES_EDICT_DELAY --
--------------------------------------------

function modifier_imba_oracle_fates_edict_delay:IsPurgable() return false end

function modifier_imba_oracle_fates_edict_delay:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_oracle_fates_edict_delay:IgnoreTenacity() return true end

function modifier_imba_oracle_fates_edict_delay:GetTexture()
	if self.texture_name then
		return self.texture_name
	else
		return "oracle_fates_edict"
	end
end

function modifier_imba_oracle_fates_edict_delay:OnCreated(params)
	self.texture_name = "oracle_fates_edict"

	if self:GetCaster():HasModifier("modifier_imba_oracle_alter_self") then
		self.texture_name = "oracle/fates_edict_alter"
	end

	if not IsServer() then return end

	self.cast_sound    = params.cast_sound
	self.modifier_name = params.modifier_name
end

function modifier_imba_oracle_fates_edict_delay:OnDestroy()
	if not IsServer() or not self:GetAbility() or not self:GetParent():IsAlive() or self:GetRemainingTime() > 0 then return end

	self:GetAbility():ApplyFatesEdict(self:GetParent(), self.cast_sound, self.modifier_name)
end

--------------------------------------
-- MODIFIER_IMBA_ORACLE_FATES_EDICT --
--------------------------------------

-- Even though this is a debuff for both allies and enemies presumably, it is not affected by status resistance for allies
function modifier_imba_oracle_fates_edict:IgnoreTenacity() return self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() end

function modifier_imba_oracle_fates_edict:IsDebuff() return true end

function modifier_imba_oracle_fates_edict:GetTexture()
	return "oracle_fates_edict"
end

function modifier_imba_oracle_fates_edict:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf"
end

function modifier_imba_oracle_fates_edict:OnCreated()
	self.magic_damage_resistance_pct_tooltip = self:GetAbility():GetSpecialValueFor("magic_damage_resistance_pct_tooltip")

	if not IsServer() then return end

	self.disarm_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fatesedict_disarm.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.disarm_particle, false, false, -1, true, true)
end

function modifier_imba_oracle_fates_edict:OnDestroy()
	if not IsServer() then return end

	self:GetParent():StopSound("Hero_Oracle.FatesEdict")
end

function modifier_imba_oracle_fates_edict:CheckState()
	return { [MODIFIER_STATE_DISARMED] = true }
end

function modifier_imba_oracle_fates_edict:DeclareFunctions()
	return { MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS }
end

function modifier_imba_oracle_fates_edict:GetModifierMagicalResistanceBonus()
	return self.magic_damage_resistance_pct_tooltip
end

--------------------------------------------
-- MODIFIER_IMBA_ORACLE_FATES_EDICT_ALTER --
--------------------------------------------

function modifier_imba_oracle_fates_edict_alter:IgnoreTenacity() return self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() end

function modifier_imba_oracle_fates_edict_alter:IsDebuff() return true end

function modifier_imba_oracle_fates_edict_alter:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_fatesedict_alter.vpcf"
end

function modifier_imba_oracle_fates_edict_alter:GetTexture()
	return "oracle/fates_edict_alter"
end

function modifier_imba_oracle_fates_edict_alter:OnCreated()
	-- self.alter_status_resistance_reduction_pct	= self:GetAbility():GetSpecialValueFor("alter_status_resistance_reduction_pct") * (-1)

	if not IsServer() then return end

	self.flash_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fatesedict_disarm_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(self.flash_particle)

	self.mute_particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_muted.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.mute_particle, false, false, -1, true, true)

	-- for _, mod in pairs(self:GetParent():FindAllModifiersByName("modifier_imba_oracle_purifying_flames_alter")) do
	-- mod:Destroy()
	-- end
end

function modifier_imba_oracle_fates_edict_alter:OnDestroy()
	if not IsServer() then return end

	self:GetParent():StopSound("Hero_Oracle.FatesEdict")
end

function modifier_imba_oracle_fates_edict_alter:CheckState()
	return { [MODIFIER_STATE_MUTED] = true }
end

function modifier_imba_oracle_fates_edict_alter:DeclareFunctions()
	return { MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING }
end

function modifier_imba_oracle_fates_edict_alter:GetAbsoluteNoDamagePhysical()
	return 1
end

-- function modifier_imba_oracle_fates_edict_alter:GetModifierStatusResistanceStacking()
-- return self.alter_status_resistance_reduction_pct
-- end

----------------------------------
-- IMBA_ORACLE_PURIFYING_FLAMES --
----------------------------------

function imba_oracle_purifying_flames:GetAbilityTextureName()
	if not self:GetCaster():HasModifier("modifier_imba_oracle_alter_self") then
		return "oracle_purifying_flames"
	else
		return "oracle/purifying_flames_alter"
	end
end

function imba_oracle_purifying_flames:GetCastPoint()
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCastPoint(self)
	else
		return self:GetSpecialValueFor("castpoint_scepter")
	end
end

function imba_oracle_purifying_flames:GetCooldown(level)
	-- if not self:GetCaster():HasScepter() then
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_oracle_purifying_flames_cooldown")
	-- else
	-- return self:GetSpecialValueFor("cooldown_scepter") - self:GetCaster():FindTalentValue("special_bonus_imba_oracle_purifying_flames_cooldown")
	-- end
end

function imba_oracle_purifying_flames:OnSpellStart()
	self.damage_sound  = "Hero_Oracle.PurifyingFlames.Damage"
	self.hit_particle  = "particles/units/heroes/hero_oracle/oracle_purifyingflames_hit.vpcf"
	self.modifier_name = "modifier_imba_oracle_purifying_flames"

	if self:GetCaster():HasModifier("modifier_imba_oracle_alter_self") then
		self.damage_sound  = "Hero_Oracle.PurifyingFlames.Damage_Alter"
		self.hit_particle  = "particles/units/heroes/hero_oracle/oracle_purifyingflames_hit_alter.vpcf"
		self.modifier_name = "modifier_imba_oracle_purifying_flames_alter"
	end

	self.target = self:GetCursorTarget()

	if self.target:TriggerSpellAbsorb(self) then return end

	self.target:EmitSound(self.damage_sound)
	self.target:EmitSound("Hero_Oracle.PurifyingFlames")

	if self:GetCaster():GetName() == "npc_dota_hero_oracle" then
		if self.target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			if RollPercentage(30) then
				if not self.responses_allied then
					self.responses_allied =
					{
						"oracle_orac_purifyingflames_01",
						"oracle_orac_purifyingflames_02",
						"oracle_orac_purifyingflames_03",
						"oracle_orac_purifyingflames_04",
						"oracle_orac_purifyingflames_05",
						"oracle_orac_purifyingflames_08",
						"oracle_orac_purifyingflames_09",
						"oracle_orac_purifyingflames_11"
					}
				end

				self:GetCaster():EmitSound(self.responses_allied[RandomInt(1, #self.responses_allied)])
			end
		else
			if RollPercentage(25) then
				if not self.responses_enemy then
					self.responses_enemy =
					{
						"oracle_orac_purifyingflames_06",
						"oracle_orac_purifyingflames_07",
						"oracle_orac_purifyingflames_10",
						"oracle_orac_purifyingflames_12"
					}
				end

				self:GetCaster():EmitSound(self.responses_enemy[RandomInt(1, #self.responses_enemy)])
			end
		end
	end

	self.purifying_particle = ParticleManager:CreateParticle(self.hit_particle, PATTACH_ABSORIGIN_FOLLOW, self.target)
	ParticleManager:SetParticleControlEnt(self.purifying_particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(self.purifying_particle)

	self.purifying_cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.purifying_cast_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(self.purifying_cast_particle)

	-- "The damage is applied instantly upon cast, followed by the heal over time. The damage is lethal to enemies, but not to allies."
	if self.target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		self.damage_flag = DOTA_DAMAGE_FLAG_NONE
	else
		self.damage_flag = DOTA_DAMAGE_FLAG_NON_LETHAL
	end

	if not self:GetCaster():HasModifier("modifier_imba_oracle_alter_self") then
		ApplyDamage({
			victim       = self.target,
			damage       = self:GetSpecialValueFor("damage"),
			damage_type  = self:GetAbilityDamageType(),
			damage_flags = self.damage_flag,
			attacker     = self:GetCaster(),
			ability      = self
		})
	else
		self.target:Heal(self:GetSpecialValueFor("damage"), self:GetCaster())

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.target, self:GetSpecialValueFor("damage"), nil)
	end

	self.target:AddNewModifier(self:GetCaster(), self, self.modifier_name, { duration = self:GetSpecialValueFor("duration") })
end

-------------------------------------------
-- MODIFIER_IMBA_ORACLE_PURIFYING_FLAMES --
-------------------------------------------

function modifier_imba_oracle_purifying_flames:IgnoreTenacity() return true end

function modifier_imba_oracle_purifying_flames:IsDebuff() return false end

function modifier_imba_oracle_purifying_flames:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_oracle_purifying_flames:GetTexture()
	return "oracle_purifying_flames"
end

function modifier_imba_oracle_purifying_flames:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf"
end

function modifier_imba_oracle_purifying_flames:OnCreated()
	self.heal_per_second = self:GetAbility():GetSpecialValueFor("heal_per_second")
	self.tick_rate       = self:GetAbility():GetSpecialValueFor("tick_rate")

	if not IsServer() then return end

	self:StartIntervalThink(self.tick_rate)
end

function modifier_imba_oracle_purifying_flames:OnIntervalThink()
	self:GetParent():Heal(self.heal_per_second, self:GetCaster())

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self.heal_per_second, nil)
end

-------------------------------------------------
-- MODIFIER_IMBA_ORACLE_PURIFYING_FLAMES_ALTER --
-------------------------------------------------

function modifier_imba_oracle_purifying_flames_alter:IgnoreTenacity() return true end

function modifier_imba_oracle_purifying_flames_alter:IsDebuff() return true end

function modifier_imba_oracle_purifying_flames_alter:IsPurgable() return false end

function modifier_imba_oracle_purifying_flames_alter:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_oracle_purifying_flames_alter:GetTexture()
	return "oracle/purifying_flames_alter"
end

function modifier_imba_oracle_purifying_flames_alter:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_purifyingflames_alter.vpcf"
end

function modifier_imba_oracle_purifying_flames_alter:OnCreated()
	self.heal_per_second = self:GetAbility():GetSpecialValueFor("heal_per_second")
	self.tick_rate       = self:GetAbility():GetSpecialValueFor("tick_rate")

	if not IsServer() then return end

	self.damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR

	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		self.damage_flags = self.damage_flags + DOTA_DAMAGE_FLAG_NON_LETHAL
	end

	self:StartIntervalThink(self.tick_rate)
end

function modifier_imba_oracle_purifying_flames_alter:OnIntervalThink()
	if not self:GetParent():HasModifier("modifier_imba_oracle_fates_edict_alter") then
		ApplyDamage({
			victim       = self:GetParent(),
			damage       = self.heal_per_second,
			damage_type  = DAMAGE_TYPE_PHYSICAL,
			damage_flags = self.damage_flags,
			attacker     = self:GetCaster(),
			ability      = self
		})

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.heal_per_second, nil)
	end
end

----------------------------
-- IMBA_ORACLE_ALTER_SELF --
----------------------------

function imba_oracle_alter_self:IsInnateAbility() return true end

function imba_oracle_alter_self:IsStealable() return false end

function imba_oracle_alter_self:GetAbilityTextureName()
	if not self:GetCaster():HasModifier("modifier_imba_oracle_alter_self") then
		return "oracle/alter_self"
	else
		return "oracle/alter_self_return"
	end
end

function imba_oracle_alter_self:OnSpellStart()
	if not self:GetCaster():HasModifier("modifier_imba_oracle_alter_self") then
		self:GetCaster():EmitSound("Hero_Oracle.Alter_Self")

		self.particle = ParticleManager:CreateParticle("particles/econ/events/league_teleport_2014/teleport_end_ground_flash_league.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:ReleaseParticleIndex(self.particle)

		self.particle_2 = ParticleManager:CreateParticle("particles/econ/events/ti9/hero_levelup_ti9_flash_hit_magic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:ReleaseParticleIndex(self.particle_2)

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_oracle_alter_self", {})
	else
		self:GetCaster():EmitSound("Hero_Oracle.Alter_Self_Base")

		self.particle = ParticleManager:CreateParticle("particles/econ/events/league_teleport_2014/teleport_start_l_flash_league.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:ReleaseParticleIndex(self.particle)

		self:GetCaster():RemoveModifierByName("modifier_imba_oracle_alter_self")
	end

	if self:GetCaster():HasAbility("imba_oracle_fortunes_end") then
		self:GetCaster():FindAbilityByName("imba_oracle_fortunes_end"):EndCooldown()
	end

	if self:GetCaster():HasAbility("imba_oracle_fates_edict") then
		self:GetCaster():FindAbilityByName("imba_oracle_fates_edict"):EndCooldown()
	end

	if self:GetCaster():HasAbility("imba_oracle_purifying_flames") then
		self:GetCaster():FindAbilityByName("imba_oracle_purifying_flames"):EndCooldown()
	end

	self.particle = nil
	self.particle_2 = nil
end

-------------------------------------
-- MODIFIER_IMBA_ORACLE_ALTER_SELF --
-------------------------------------

function modifier_imba_oracle_alter_self:IsPurgable() return false end

function modifier_imba_oracle_alter_self:RemoveOnDeath() return false end

function modifier_imba_oracle_alter_self:GetTexture()
	return "oracle/alter_self"
end

function modifier_imba_oracle_alter_self:GetStatusEffectName()
	return "particles/status_fx/status_effect_teleport_image.vpcf"
end

-------------------------------
-- IMBA_ORACLE_FALSE_PROMISE --
-------------------------------

function imba_oracle_false_promise:OnUpgrade()
	if self:GetCaster():HasAbility("imba_oracle_false_promise_alter") then
		self:GetCaster():FindAbilityByName("imba_oracle_false_promise_alter"):SetLevel(self:GetLevel())
	end
end

function imba_oracle_false_promise:OnSpellStart()
	local target = self:GetCursorTarget()

	if not self:GetAutoCastState() then
		self:ApplyFalsePromise(target)
	else
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_oracle_false_promise_delay", { duration = self:GetSpecialValueFor("future_delay") })
	end
end

function imba_oracle_false_promise:ApplyFalsePromise(target)
	target:EmitSound("Hero_Oracle.FalsePromise.Target")
	EmitSoundOnClient("Hero_Oracle.FalsePromise.FP", target:GetPlayerOwner())

	if self:GetCaster():GetName() == "npc_dota_hero_oracle" and target:GetTeamNumber() == self:GetCaster():GetTeamNumber() and RollPercentage(50) then
		if not self.responses then
			self.responses =
			{
				"oracle_orac_falsepromise_01",
				"oracle_orac_falsepromise_02",
				"oracle_orac_falsepromise_03",
				"oracle_orac_falsepromise_04",
				"oracle_orac_falsepromise_06",
				"oracle_orac_falsepromise_11"
			}
		end

		self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
	end

	self.false_promise_cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(self.false_promise_cast_particle, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.false_promise_cast_particle)

	self.false_promise_target_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(self.false_promise_target_particle)

	self:GetCaster():EmitSound("Hero_Oracle.FalsePromise.Cast")

	target:Purge(false, true, false, true, true)

	target:AddNewModifier(self:GetCaster(), self, "modifier_imba_oracle_false_promise_timer", { duration = self:GetTalentSpecialValueFor("duration") })

	if self:GetCaster():HasAbility("imba_oracle_false_promise_alter") then
		self:GetCaster():FindAbilityByName("imba_oracle_false_promise_alter"):StartCooldown(self:GetSpecialValueFor("alter_cooldown") * self:GetCaster():GetCooldownReduction())
	end
end

-------------------------------------
-- IMBA_ORACLE_FALSE_PROMISE_ALTER --
-------------------------------------

function imba_oracle_false_promise_alter:OnSpellStart()
	local target = self:GetCursorTarget()

	if not self:GetAutoCastState() then
		if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and not target:TriggerSpellAbsorb(self) then
			self:ApplyFalsePromise(target)
		end
	else
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_oracle_false_promise_delay", { duration = self:GetSpecialValueFor("future_delay") })
	end
end

function imba_oracle_false_promise_alter:ApplyFalsePromise(target)
	target:EmitSound("Hero_Oracle.FalsePromise.Target")
	EmitSoundOnClient("Hero_Oracle.FalsePromise.FP", target:GetPlayerOwner())

	if self:GetCaster():GetName() == "npc_dota_hero_oracle" and target:GetTeamNumber() == self:GetCaster():GetTeamNumber() and RollPercentage(50) then
		if not self.responses then
			self.responses =
			{
				"oracle_orac_falsepromise_01",
				"oracle_orac_falsepromise_02",
				"oracle_orac_falsepromise_03",
				"oracle_orac_falsepromise_04",
				"oracle_orac_falsepromise_06",
				"oracle_orac_falsepromise_11"
			}
		end

		self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
	end

	self.false_promise_cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(self.false_promise_cast_particle, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.false_promise_cast_particle)

	self.false_promise_target_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(self.false_promise_target_particle)

	self:GetCaster():EmitSound("Hero_Oracle.False_Promise_Alter")

	target:Purge(true, false, false, false, false)

	target:AddNewModifier(self:GetCaster(), self, "modifier_imba_oracle_false_promise_timer_alter", { duration = self:GetTalentSpecialValueFor("duration") })

	if self:GetCaster():HasAbility("imba_oracle_false_promise") then
		self:GetCaster():FindAbilityByName("imba_oracle_false_promise"):StartCooldown(self:GetSpecialValueFor("alter_cooldown") * self:GetCaster():GetCooldownReduction())
	end
end

----------------------------------------------
-- MODIFIER_IMBA_ORACLE_FALSE_PROMISE_DELAY --
----------------------------------------------

function modifier_imba_oracle_false_promise_delay:IsPurgable() return false end

function modifier_imba_oracle_false_promise_delay:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_oracle_false_promise_delay:IgnoreTenacity() return true end

function modifier_imba_oracle_false_promise_delay:GetTexture()
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return "oracle_false_promise"
	else
		return "oracle/false_promise_alter"
	end
end

function modifier_imba_oracle_false_promise_delay:OnDestroy()
	if not IsServer() or not self:GetAbility() or not self:GetParent():IsAlive() or self:GetRemainingTime() > 0 then return end

	self:GetAbility():ApplyFalsePromise(self:GetParent())
end

----------------------------------------------
-- MODIFIER_IMBA_ORACLE_FALSE_PROMISE_TIMER --
----------------------------------------------

-- "If the target is invulnerable as False Promise expires, the delayed heal and damage wait for it to become vulnerable again."
-- Since Ball Lightning is coded...differently, this exception needs to be included as well
function modifier_imba_oracle_false_promise_timer:DestroyOnExpire() return not self:GetParent():IsInvulnerable() and not self:GetParent():HasModifier("modifier_imba_ball_lightning") end

-- I have no idea how this priority function works
function modifier_imba_oracle_false_promise_timer:GetPriority() return MODIFIER_PRIORITY_ULTRA end

function modifier_imba_oracle_false_promise_timer:IsPurgable() return false end

function modifier_imba_oracle_false_promise_timer:GetTexture()
	return "oracle_false_promise"
end

function modifier_imba_oracle_false_promise_timer:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_false_promise.vpcf"
end

function modifier_imba_oracle_false_promise_timer:OnCreated()
	if not IsServer() then return end

	self.overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_indicator.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.overhead_particle, false, false, -1, true, true)

	-- I think it's okay to just have a tracked number for heals, but damage needs to also track the attacker so you can properly attribute a kill
	self.heal_counter     = 0

	self.damage_instances = {}
	self.instance_counter = 1
	self.damage_counter   = 0

	if self:GetCaster():HasTalent("special_bonus_imba_oracle_false_promise_invisibility") then
		self.invis_fade_delay = 0.6

		self:StartIntervalThink(self.invis_fade_delay)
	end
end

function modifier_imba_oracle_false_promise_timer:OnRefresh()
	if not IsServer() then return end

	self.heal_counter     = self.heal_counter or 0

	self.damage_instances = self.damage_instances or {}
	self.instance_counter = self.instance_counter or 1
	self.damage_counter   = self.damage_counter or 0

	if self:GetCaster():HasTalent("special_bonus_imba_oracle_false_promise_invisibility") then
		self.invis_fade_delay = 0.6

		self:StartIntervalThink(self.invis_fade_delay)
	end
end

function modifier_imba_oracle_false_promise_timer:OnIntervalThink()
	self.invis_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invisible", {})

	-- Dumb generic invis modifier stopping attacks (and I no longer have reference to its keys) but at least have this block so units don't keep getting their attacks interrupted when this activates
	if self:GetParent():GetAggroTarget() then
		self:GetParent():MoveToTargetToAttack(self:GetParent():GetAggroTarget())
	end

	self:StartIntervalThink(-1)
end

function modifier_imba_oracle_false_promise_timer:OnDestroy()
	if not IsServer() then return end

	-- print("Heal counter: ", self.heal_counter)
	-- print("Damage counter: ", self.damage_counter)

	if self.damage_counter < self.heal_counter then
		self:GetParent():EmitSound("Hero_Oracle.FalsePromise.Healed")

		if self:GetCaster():GetName() == "npc_dota_hero_oracle" and RollPercentage(25) then
			self.responses =
			{
				"oracle_orac_falsepromise_14",
				"oracle_orac_falsepromise_15",
				"oracle_orac_falsepromise_17",
				"oracle_orac_falsepromise_18",
				"oracle_orac_falsepromise_19"
			}

			self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
		end

		self.end_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.end_particle)

		self:GetParent():Heal(self.heal_counter - self.damage_counter, self:GetCaster())

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self.heal_counter - self.damage_counter, nil)
	else
		self:GetParent():EmitSound("Hero_Oracle.FalsePromise.Damaged")

		self.end_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.end_particle)

		-- Since Chen's Divine Favor has an IMBAfication that blocks pure damage, we need this exception here if we don't want it to also block False Promise end-damage...
		local divine_favor_modifier = self:GetParent():FindModifierByName("modifier_imba_chen_divine_favor")
		local divine_favor_ability = nil
		local divine_favor_caster = nil
		local divine_favor_duration = nil

		if divine_favor_modifier then
			divine_favor_ability  = divine_favor_modifier:GetAbility()
			divine_favor_caster   = divine_favor_modifier:GetCaster()
			divine_favor_duration = divine_favor_modifier:GetRemainingTime()
			divine_favor_modifier:Destroy()
		end

		for _, instance in pairs(self.damage_instances) do
			if self.heal_counter > 0 then
				if self.heal_counter < instance.damage then
					instance.damage = instance.damage - self.heal_counter

					ApplyDamage(instance)
				end

				local subtraction_value = math.min(instance.damage, self.heal_counter)

				self.heal_counter = self.heal_counter - subtraction_value
				self.damage_counter = self.damage_counter - subtraction_value
			else
				ApplyDamage(instance)
			end
		end

		if divine_favor_ability and divine_favor_caster then
			self:GetParent():AddNewModifier(divine_favor_caster, divine_favor_ability, "modifier_imba_chen_divine_favor", { duration = divine_favor_duration })
		end

		if self:GetCaster():GetName() == "npc_dota_hero_oracle" then
			if not self:GetParent():IsAlive() and RollPercentage(15) then
				self.responses =
				{
					"oracle_orac_falsepromise_05",
					"oracle_orac_falsepromise_07",
					"oracle_orac_falsepromise_08",
					"oracle_orac_falsepromise_09",
					"oracle_orac_falsepromise_10",
					"oracle_orac_falsepromise_12",
					"oracle_orac_falsepromise_13",
					"oracle_failure_01",
				}
			elseif self:GetParent():GetHealth() >= 100 then
				self.responses =
				{
					"oracle_orac_falsepromise_14",
					"oracle_orac_falsepromise_15",
					"oracle_orac_falsepromise_17",
					"oracle_orac_falsepromise_18",
					"oracle_orac_falsepromise_19",
				}
			end

			if self.responses then
				self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
			end
		end

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage_counter, nil)
	end

	if self.invis_modifier and not self.invis_modifier:IsNull() then
		self.invis_modifier:Destroy()
	end
end

function modifier_imba_oracle_false_promise_timer:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_PROPERTY_DISABLE_HEALING,

		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
end

function modifier_imba_oracle_false_promise_timer:GetModifierIncomingDamage_Percentage(keys)
	if keys.attacker and self:GetRemainingTime() >= 0 then
		self.attacked_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_attacked.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.attacked_particle)

		local damage_flags = keys.damage_flags

		-- "If the heal sum depletes, then the remaining damage instances get applied in order. The damage is flagged as HP Removal."
		if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
			damage_flags = damage_flags + DOTA_DAMAGE_FLAG_HPLOSS
		end

		if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION) ~= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION then
			damage_flags = damage_flags + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		end

		self.damage_instances[self.instance_counter] = {
			victim       = self:GetParent(),
			damage       = keys.damage,
			damage_type  = DAMAGE_TYPE_PURE,
			damage_flags = damage_flags,
			attacker     = keys.attacker,
			ability      = keys.ability
		}

		self.instance_counter = self.instance_counter + 1
		self.damage_counter = self.damage_counter + keys.damage

		-- "If the accumulated damage exceeds the accumulated heal, the orb above the target glows red and emits fire, indicating it will receive damage."
		-- IDK the proper numbers so let's just use large ones based on what I see in the Particle Editor
		-- Also this wiki description seems wrong too cause I think it only glows when the damage would be considered fatal so...
		ParticleManager:SetParticleControl(self.overhead_particle, 1, Vector(self.damage_counter - self.heal_counter, 0, 0))
		ParticleManager:SetParticleControl(self.overhead_particle, 2, Vector(self.heal_counter - self.damage_counter, 0, 0))

		self:SetStackCount(math.abs(self.damage_counter - self.heal_counter))
	end

	-- Overkill? Meh
	return -99999999
end

function modifier_imba_oracle_false_promise_timer:OnHealReceived(keys)
	if keys.unit == self:GetParent() and self:GetRemainingTime() >= 0 then
		self.heal_counter = self.heal_counter + (keys.gain * 2)

		ParticleManager:SetParticleControl(self.overhead_particle, 1, Vector(self.damage_counter - self.heal_counter, 0, 0))
		ParticleManager:SetParticleControl(self.overhead_particle, 2, Vector(self.heal_counter - self.damage_counter, 0, 0))

		self:SetStackCount(math.abs(self.damage_counter - self.heal_counter))
	end
end

function modifier_imba_oracle_false_promise_timer:GetDisableHealing(keys)
	return 1
end

function modifier_imba_oracle_false_promise_timer:OnAttack(keys)
	if self:GetCaster():HasTalent("special_bonus_imba_oracle_false_promise_invisibility") and keys.attacker == self:GetParent() and not keys.no_attack_cooldown and self.invis_modifier and not self.invis_modifier:IsNull() then
		-- Don't need to manually destroy since the built-in modifier self-destructs on attack
		-- self.invis_modifier:Destroy()

		self:StartIntervalThink(self.invis_fade_delay)
	end
end

function modifier_imba_oracle_false_promise_timer:OnAbilityFullyCast(keys)
	if self:GetCaster():HasTalent("special_bonus_imba_oracle_false_promise_invisibility") and keys.unit == self:GetParent() and self.invis_modifier and not self.invis_modifier:IsNull() then
		-- Don't need to manually destroy since the built-in modifier self-destructs on ability cast
		-- self.invis_modifier:Destroy()

		self:StartIntervalThink(self.invis_fade_delay)
	end
end

----------------------------------------------------
-- MODIFIER_IMBA_ORACLE_FALSE_PROMISE_TIMER_ALTER --
----------------------------------------------------

function modifier_imba_oracle_false_promise_timer_alter:IsPurgable() return false end

function modifier_imba_oracle_false_promise_timer_alter:IgnoreTenacity() return true end

function modifier_imba_oracle_false_promise_timer_alter:GetTexture()
	return "oracle/false_promise_alter"
end

function modifier_imba_oracle_false_promise_timer_alter:GetStatusEffectName()
	return "particles/status_fx/status_effect_electrical.vpcf"
end

function modifier_imba_oracle_false_promise_timer_alter:OnCreated()
	self.alter_heal_pct = self:GetAbility():GetSpecialValueFor("alter_heal_pct")

	if not IsServer() then return end

	self.false_promise_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.false_promise_particle, 60, Vector(255, 0, 0))
	ParticleManager:SetParticleControl(self.false_promise_particle, 61, Vector(1, 0, 0))
	self:AddParticle(self.false_promise_particle, false, false, -1, true, true)
end

function modifier_imba_oracle_false_promise_timer_alter:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, MODIFIER_EVENT_ON_TAKEDAMAGE }
end

-- Properly handled in filters.lua for now
-- function modifier_imba_oracle_false_promise_timer_alter:GetModifierTotalDamageOutgoing_Percentage(keys)
-- return -100
-- end

function modifier_imba_oracle_false_promise_timer_alter:OnTakeDamage(keys)
	if keys.attacker == self:GetParent() then
		local alter_targets_modifier = keys.unit:FindModifierByNameAndCaster("modifier_imba_oracle_false_promise_timer_alter_targets", self:GetParent())

		if not alter_targets_modifier then
			-- Allow an extra frame so the main modifier should be removed by then (and thus not have damage blocked by the damage filter)
			alter_targets_modifier = keys.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_oracle_false_promise_timer_alter_targets", {
				duration       = self:GetRemainingTime() + FrameTime(),
				alter_heal_pct = self.alter_heal_pct
			})
		end

		if alter_targets_modifier.damage_instances then
			self.attacked_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_attacked.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit)
			ParticleManager:SetParticleControl(self.attacked_particle, 60, Vector(255, 0, 0))
			ParticleManager:SetParticleControl(self.attacked_particle, 61, Vector(1, 0, 0))
			ParticleManager:ReleaseParticleIndex(self.attacked_particle)

			local damage_flags = keys.damage_flags

			if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
				damage_flags = damage_flags + DOTA_DAMAGE_FLAG_HPLOSS
			end

			if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION) ~= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION then
				damage_flags = damage_flags + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
			end

			table.insert(alter_targets_modifier.damage_instances, {
				victim       = keys.unit,
				damage       = keys.damage,
				damage_type  = DAMAGE_TYPE_PURE,
				damage_flags = damage_flags,
				attacker     = keys.attacker,
				ability      = keys.ability
			})

			if alter_targets_modifier.damage_counter then
				alter_targets_modifier.damage_counter = alter_targets_modifier.damage_counter + keys.damage
				alter_targets_modifier:SetStackCount(alter_targets_modifier.damage_counter)
			end
		end
	end
end

------------------------------------------------------------
-- MODIFIER_IMBA_ORACLE_FALSE_PROMISE_TIMER_ALTER_TARGETS --
------------------------------------------------------------

function modifier_imba_oracle_false_promise_timer_alter_targets:DestroyOnExpire() return not self:GetParent():IsInvulnerable() and not self:GetParent():HasModifier("modifier_imba_ball_lightning") end

function modifier_imba_oracle_false_promise_timer_alter_targets:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_oracle_false_promise_timer_alter_targets:IsHidden() return self:GetStackCount() <= 0 end

function modifier_imba_oracle_false_promise_timer_alter_targets:IsPurgable() return false end

function modifier_imba_oracle_false_promise_timer_alter_targets:IgnoreTenacity() return true end

function modifier_imba_oracle_false_promise_timer_alter_targets:GetTexture()
	return "oracle/false_promise_alter"
end

function modifier_imba_oracle_false_promise_timer_alter_targets:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_false_promise_indicator.vpcf"
end

function modifier_imba_oracle_false_promise_timer_alter_targets:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_oracle_false_promise_timer_alter_targets:OnCreated(params)
	if not IsServer() then return end

	self.alter_heal_pct   = params.alter_heal_pct

	self.damage_counter   = 0
	self.damage_instances = {}
end

function modifier_imba_oracle_false_promise_timer_alter_targets:OnDestroy()
	if not IsServer() then return end

	self:GetParent():EmitSound("Hero_Oracle.FalsePromise.Damaged")

	self.end_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(self.end_particle)

	-- Since Chen's Divine Favor has an IMBAfication that blocks pure damage, we need this exception here if we don't want it to also block False Promise end-damage...
	local divine_favor_modifier = self:GetParent():FindModifierByName("modifier_imba_chen_divine_favor")
	local divine_favor_ability = nil
	local divine_favor_caster = nil
	local divine_favor_duration = nil

	if divine_favor_modifier then
		divine_favor_ability  = divine_favor_modifier:GetAbility()
		divine_favor_caster   = divine_favor_modifier:GetCaster()
		divine_favor_duration = divine_favor_modifier:GetRemainingTime()
		divine_favor_modifier:Destroy()
	end

	for _, instance in pairs(self.damage_instances) do
		ApplyDamage(instance)
	end

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage_counter, nil)

	if divine_favor_ability and divine_favor_caster then
		self:GetParent():AddNewModifier(divine_favor_caster, divine_favor_ability, "modifier_imba_chen_divine_favor", { duration = divine_favor_duration })
	end
end

function modifier_imba_oracle_false_promise_timer_alter_targets:DeclareFunctions()
	return { MODIFIER_EVENT_ON_HEAL_RECEIVED }
end

function modifier_imba_oracle_false_promise_timer_alter_targets:OnHealReceived(keys)
	if keys.unit == self:GetParent() and self:GetRemainingTime() >= 0 then
		local heal_split_amount = (keys.gain * self.alter_heal_pct / 100) / #self.damage_instances

		for instance = 1, #self.damage_instances do
			self.damage_instances[instance].damage = self.damage_instances[instance].damage - heal_split_amount
		end

		self.damage_counter = self.damage_counter - (keys.gain * self.alter_heal_pct / 100)
		self:SetStackCount(self.damage_counter)
	end
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_oracle_fortunes_end_max_duration", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_oracle_false_promise_invisibility", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_oracle_false_promise_duration", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_oracle_fortunes_end_max_duration  = modifier_special_bonus_imba_oracle_fortunes_end_max_duration or class({})
modifier_special_bonus_imba_oracle_false_promise_invisibility = modifier_special_bonus_imba_oracle_false_promise_invisibility or class({})
modifier_special_bonus_imba_oracle_false_promise_duration     = modifier_special_bonus_imba_oracle_false_promise_duration or class({})

function modifier_special_bonus_imba_oracle_fortunes_end_max_duration:IsHidden() return true end

function modifier_special_bonus_imba_oracle_fortunes_end_max_duration:IsPurgable() return false end

function modifier_special_bonus_imba_oracle_fortunes_end_max_duration:RemoveOnDeath() return false end

function modifier_special_bonus_imba_oracle_false_promise_invisibility:IsHidden() return true end

function modifier_special_bonus_imba_oracle_false_promise_invisibility:IsPurgable() return false end

function modifier_special_bonus_imba_oracle_false_promise_invisibility:RemoveOnDeath() return false end

function modifier_special_bonus_imba_oracle_false_promise_duration:IsHidden() return true end

function modifier_special_bonus_imba_oracle_false_promise_duration:IsPurgable() return false end

function modifier_special_bonus_imba_oracle_false_promise_duration:RemoveOnDeath() return false end

LinkLuaModifier("modifier_special_bonus_imba_oracle_purifying_flames_cooldown", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_oracle_fates_edict_cooldown", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_oracle_purifying_flames_cooldown = modifier_special_bonus_imba_oracle_purifying_flames_cooldown or class({})
modifier_special_bonus_imba_oracle_fates_edict_cooldown      = class({})

function modifier_special_bonus_imba_oracle_purifying_flames_cooldown:IsHidden() return true end

function modifier_special_bonus_imba_oracle_purifying_flames_cooldown:IsPurgable() return false end

function modifier_special_bonus_imba_oracle_purifying_flames_cooldown:RemoveOnDeath() return false end

function modifier_special_bonus_imba_oracle_fates_edict_cooldown:IsHidden() return true end

function modifier_special_bonus_imba_oracle_fates_edict_cooldown:IsPurgable() return false end

function modifier_special_bonus_imba_oracle_fates_edict_cooldown:RemoveOnDeath() return false end

function imba_oracle_fates_edict:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_oracle_fates_edict_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_oracle_fates_edict_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_oracle_fates_edict_cooldown"), "modifier_special_bonus_imba_oracle_fates_edict_cooldown", {})
	end
end

function imba_oracle_purifying_flames:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_oracle_purifying_flames_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_oracle_purifying_flames_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_oracle_purifying_flames_cooldown"), "modifier_special_bonus_imba_oracle_purifying_flames_cooldown", {})
	end
end
