-- Editors:
--    AltiV, October 4th, 2019


LinkLuaModifier("modifier_imba_oracle_fortunes_end_purge", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_oracle_fates_edict", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_oracle_purifying_flames", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_oracle_false_promise_timer", "components/abilities/heroes/hero_oracle", LUA_MODIFIER_MOTION_NONE)

imba_oracle_fortunes_end					= class({})
modifier_imba_oracle_fortunes_end_purge		= class({})

imba_oracle_fates_edict						= class({})
modifier_imba_oracle_fates_edict			= class({})

imba_oracle_purifying_flames				= class({})
modifier_imba_oracle_purifying_flames		= class({})

imba_oracle_false_promise					= class({})
modifier_imba_oracle_false_promise_timer	= class({})

------------------------------
-- IMBA_ORACLE_FORTUNES_END --
------------------------------

function imba_oracle_fortunes_end:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_oracle_fortunes_end:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Oracle.FortunesEnd.Channel")
	
	if self.fortunes_particle then
		ParticleManager:DestroyParticle(self.fortunes_particle, false)
		ParticleManager:ReleaseParticleIndex(self.fortunes_particle)
	end
	
	self.fortunes_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.fortunes_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	
	self.target_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_cast_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCursorTarget())
	ParticleManager:ReleaseParticleIndex(self.target_particle)
			-- "01"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "damage"					"120 150 180 210"
			-- }
			-- "02"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "bolt_speed"				"1000"
			-- }
			-- "03"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "minimum_purge_duration"	"0.5"
			-- }
			-- "04"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "maximum_purge_duration"	"2.5"
				-- "LinkedSpecialBonus"	"special_bonus_unique_oracle_2"
			-- }
			-- "05"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "radius"					"300"
			-- }
end

function imba_oracle_fortunes_end:OnChannelThink(flInterval)

end

function imba_oracle_fortunes_end:OnChannelFinish(bInterrupted)
	self:GetCaster():StopSound("Hero_Oracle.FortunesEnd.Channel")
	self:GetCaster():EmitSound("Hero_Oracle.FortunesEnd.Attack")
	
	if self.fortunes_particle then
		ParticleManager:DestroyParticle(self.fortunes_particle, false)
		ParticleManager:ReleaseParticleIndex(self.fortunes_particle)
	end
	
	ProjectileManager:CreateTrackingProjectile(	{
		Target 				= self:GetCursorTarget(),
		Source 				= self:GetCaster(),
		Ability 			= self,
		EffectName 			= "particles/units/heroes/hero_oracle/oracle_fortune_prj.vpcf",
		iMoveSpeed			= self:GetSpecialValueFor("bolt_speed"),
		vSourceLoc 			= self:GetCaster():GetAbsOrigin(),
		bDrawsOnMinimap 	= false,
		bDodgeable 			= true,
		bIsAttack 			= false,
		bVisibleToEnemies 	= true,
		bReplaceExisting 	= false,
		flExpireTime 		= GameRules:GetGameTime() + 10.0,
		bProvidesVision 	= false,
		
		iSourceAttachment	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		
		ExtraData = {
			charge_pct		= ((GameRules:GetGameTime() - self:GetChannelStartTime()) / self:GetChannelTime())
		}
	})
end

function imba_oracle_fortunes_end:OnProjectileHit_ExtraData(target, location, data)
	EmitSoundOnLocationWithCaster(location, "Hero_Oracle.FortunesEnd.Target", self:GetCaster())

	self.aoe_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_aoe.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(self.aoe_particle, 0, location)
	ParticleManager:SetParticleControl(self.aoe_particle, 2, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius")))
	ParticleManager:ReleaseParticleIndex(self.aoe_particle)

	if target and data.charge_pct and not target:TriggerSpellAbsorb(self) then
		-- "Fortune's End first applies the dispel, then the debuff, then the damage."
		if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			target:Purge(false, true, false, false, false)
		end
		
		-- "Always removes Fate's Edict on affected targets."
		if target:HasModifier("modifier_imba_oracle_fates_edict") then
			target:RemoveModifierByName("modifier_imba_oracle_fates_edict")
		end
		
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			self.damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(self.damage_particle, 1, location)
			ParticleManager:SetParticleControl(self.damage_particle, 3, enemy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.damage_particle)
		
			enemy:Purge(true, false, false, false, false)
		
			self.purge_modifier = enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_oracle_fortunes_end_purge", {duration = math.max(self:GetTalentSpecialValueFor("maximum_purge_duration") * data.charge_pct, self:GetSpecialValueFor("minimum_purge_duration"))})
			
			if self.purge_modifier then
				self.purge_modifier:SetDuration(math.max(self:GetTalentSpecialValueFor("maximum_purge_duration") * data.charge_pct, self:GetSpecialValueFor("minimum_purge_duration")) * (1 - enemy:GetStatusResistance()), true)
			end

			ApplyDamage({
				victim 			= enemy,
				damage 			= self:GetSpecialValueFor("damage"),
				damage_type		= self:GetAbilityDamageType(),
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self
			})
		end
		
		self.purge_modifier = nil
	end
end

---------------------------------------------
-- MODIFIER_IMBA_ORACLE_FORTUNES_END_PURGE --
---------------------------------------------

function modifier_imba_oracle_fortunes_end_purge:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_fortune_purge.vpcf"
end

function modifier_imba_oracle_fortunes_end_purge:OnCreated()

end

function modifier_imba_oracle_fortunes_end_purge:CheckState()
	return {[MODIFIER_STATE_ROOTED] = true}
end

-----------------------------
-- IMBA_ORACLE_FATES_EDICT --
-----------------------------

function imba_oracle_fates_edict:OnSpellStart()
			-- "01"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "duration"				"3.0 3.5 4.0 4.5"
			-- }
			-- "02"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "magic_damage_resistance_pct_tooltip"				"100"
			-- }

	local target = self:GetCursorTarget()

	if target:TriggerSpellAbsorb(self) then return end

	self:GetCaster():EmitSound("Hero_Oracle.FatesEdict.Cast")
	target:EmitSound("Hero_Oracle.FatesEdict")

	self.edict_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_oracle_fates_edict", {duration = self:GetSpecialValueFor("duration")})
	
	if self.edict_modifier and target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		self.edict_modifier:SetDuration(self:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance()), true)
	end
end

--------------------------------------
-- MODIFIER_IMBA_ORACLE_FATES_EDICT --
--------------------------------------

-- Even though this is a debuff for both allies and enemies presumably, it is not affected by status resistance for allies
function modifier_imba_oracle_fates_edict:IgnoreTenacity()	return self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() end
function modifier_imba_oracle_fates_edict:IsDebuff()		return true end

function modifier_imba_oracle_fates_edict:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf"
end

function modifier_imba_oracle_fates_edict:OnCreated()
	self.magic_damage_resistance_pct_tooltip	= self:GetAbility():GetSpecialValueFor("magic_damage_resistance_pct_tooltip")
	
	if not IsServer() then return end
	
	self.disarm_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fatesedict_disarm.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.disarm_particle, false, false, -1, true, true)
end

function modifier_imba_oracle_fates_edict:CheckState()
	return {[MODIFIER_STATE_DISARMED] = true}
end

function modifier_imba_oracle_fates_edict:DeclareFunctions()
	return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end

function modifier_imba_oracle_fates_edict:GetModifierMagicalResistanceBonus()
	return self.magic_damage_resistance_pct_tooltip
end

----------------------------------
-- IMBA_ORACLE_PURIFYING_FLAMES --
----------------------------------

function imba_oracle_purifying_flames:GetCastPoint()
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCastPoint(self)
	else
		return self:GetSpecialValueFor("castpoint_scepter")
	end
end

function imba_oracle_purifying_flames:GetCooldown(level)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCooldown(self, level)
	else
		return self:GetSpecialValueFor("cooldown_scepter")
	end
end

function imba_oracle_purifying_flames:OnSpellStart()
			-- "01"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "damage"				"90 180 270 360"
			-- }			
			-- "02"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "heal_per_second"		"11.0 22.0 33.0 44.0"
			-- }
			-- "03"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "total_heal_tooltip"	"99 198 297 396"
			-- }
			-- "04"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "duration"				"9.0"
			-- }
			-- "05"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "tick_rate"				"1.0"
			-- }
			-- "06"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "cooldown_scepter"		"1.0"
				-- "RequiresScepter"	"1"
			-- }
			-- "07"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "castpoint_scepter"		"0.1"
				-- "RequiresScepter"	"1"
			-- }

	self.target = self:GetCursorTarget()
	
	if self.target:TriggerSpellAbsorb(self) then return end

	self:GetCaster():EmitSound("Hero_Oracle.PurifyingFlames")
	self.target:EmitSound("Hero_Oracle.PurifyingFlames.Damage")
	
	self.purifying_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
	ParticleManager:ReleaseParticleIndex(self.purifying_particle)
	
	self.purifying_cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.purifying_cast_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(self.purifying_particle)
	
	-- "The damage is applied instantly upon cast, followed by the heal over time. The damage is lethal to enemies, but not to allies."
	if self.target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		self.damage_flag = DOTA_DAMAGE_FLAG_NONE
	else
		self.damage_flag = DOTA_DAMAGE_FLAG_NON_LETHAL
	end
	
	ApplyDamage({
		victim 			= self.target,
		damage 			= self:GetSpecialValueFor("damage"),
		damage_type		= self:GetAbilityDamageType(),
		damage_flags 	= self.damage_flag,
		attacker 		= self:GetCaster(),
		ability 		= self
	})
	
	self.target:AddNewModifier(self:GetCaster(), self, "modifier_imba_oracle_purifying_flames", {duration = self:GetSpecialValueFor("duration")})
end

-------------------------------------------
-- MODIFIER_IMBA_ORACLE_PURIFYING_FLAMES --
-------------------------------------------

function modifier_imba_oracle_purifying_flames:IgnoreTenacity()	return true end
function modifier_imba_oracle_purifying_flames:IsDebuff()		return false end
function modifier_imba_oracle_purifying_flames:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_oracle_purifying_flames:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf"
end

function modifier_imba_oracle_purifying_flames:OnCreated()
	self.heal_per_second	= self:GetAbility():GetSpecialValueFor("heal_per_second")
	self.tick_rate			= self:GetAbility():GetSpecialValueFor("tick_rate")
	
	if not IsServer() then return end
	
	self:StartIntervalThink(self.tick_rate)
end

function modifier_imba_oracle_purifying_flames:OnIntervalThink()
	self:GetParent():Heal(self.heal_per_second, self:GetCaster())
	
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self.heal_per_second, nil)
end

-------------------------------
-- IMBA_ORACLE_FALSE_PROMISE --
-------------------------------

function imba_oracle_false_promise:OnSpellStart()
			-- "01"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "duration"				"8 9 10"
				-- "LinkedSpecialBonus"	"special_bonus_unique_oracle"
			-- }
			-- "02"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "radius"				"400"
			-- }

	local target = self:GetCursorTarget()
	
	self:GetCaster():EmitSound("Hero_Oracle.FalsePromise.Cast")
	target:EmitSound("Hero_Oracle.FalsePromise.Target")
	
	self.false_promise_cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(self.false_promise_cast_particle, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.false_promise_cast_particle)
	
	self.false_promise_target_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(self.false_promise_target_particle)
	
	target:Purge(false, true, false, true, true)
	
	target:AddNewModifier(self:GetCaster(), self, "modifier_imba_oracle_false_promise_timer", {duration = self:GetTalentSpecialValueFor("duration")})
end

----------------------------------------------
-- MODIFIER_IMBA_ORACLE_FALSE_PROMISE_TIMER --
----------------------------------------------

function modifier_imba_oracle_false_promise_timer:IsPurgable()	return false end

function modifier_imba_oracle_false_promise_timer:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_false_promise.vpcf"
end

function modifier_imba_oracle_false_promise_timer:OnCreated()
	if not IsServer() then return end
	
	self:GetParent():EmitSound("Hero_Oracle.FalsePromise.FP")
	
	self.overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_indicator.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.overhead_particle, false, false, -1, true, true)
	
	-- I think it's okay to just have a tracked number for heals, but damage needs to also track the attacker so you can properly attribute a kill
	self.heal_counter		= 0
	self.damage_instances	= {}
	self.damage_counter		= 0
end

function modifier_imba_oracle_false_promise_timer:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_Oracle.FalsePromise.FP")
end

function modifier_imba_oracle_false_promise_timer:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_EVENT_ON_HEAL_RECEIVED, MODIFIER_PROPERTY_DISABLE_HEALING} -- double check that this accounts for regen and heals; there's also MODIFIER_EVENT_ON_HEALTH_GAINED 
end

function modifier_imba_oracle_false_promise_timer:GetModifierIncomingDamage_Percentage(keys)
	if keys.attacker and keys.record then
		-- table.insert(self.damage_instances, [GameRules:GetGameTime()] = {attacker = keys.attacker, damage = keys.damage}
		self.damage_instances[keys.record] = {attacker = keys.attacker, damage = keys.damage}
		self.damage_counter = self.damage_counter + keys.damage
	end
	
	return -100
end

function modifier_imba_oracle_false_promise_timer:OnHealReceived(keys)
	-- print(keys)
end

function modifier_imba_oracle_false_promise_timer:GetDisableHealing(keys)
	return 1
end

-- LinkLuaModifier("modifier_imba_nian_frenzy_swipes", "components/abilities/heroes/hero_nian", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_nian_frenzy_swipes_suppression", "components/abilities/heroes/hero_nian", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_nian_frenzy_swipes_slow", "components/abilities/heroes/hero_nian", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_nian_frenzy_swipes_armor_reduction", "components/abilities/heroes/hero_nian", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_imba_nian_crushing_leap_movement", "components/abilities/heroes/hero_nian", LUA_MODIFIER_MOTION_BOTH)
-- LinkLuaModifier("modifier_imba_nian_crushing_leap_strength", "components/abilities/heroes/hero_nian", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_nian_crushing_leap_agility", "components/abilities/heroes/hero_nian", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_nian_crushing_leap_intellect", "components/abilities/heroes/hero_nian", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_imba_nian_volcanic_burster", "components/abilities/heroes/hero_nian", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_nian_volcanic_burster_cooldown", "components/abilities/heroes/hero_nian", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_nian_volcanic_burster_tracker", "components/abilities/heroes/hero_nian", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_generic_motion_controller", "components/modifiers/generic/modifier_generic_motion_controller", LUA_MODIFIER_MOTION_BOTH)

-- imba_nian_frenzy_swipes								= class({})
-- modifier_imba_nian_frenzy_swipes					= class({})
-- modifier_imba_nian_frenzy_swipes_suppression		= class({})
-- modifier_imba_nian_frenzy_swipes_slow				= class({})
-- modifier_imba_nian_frenzy_swipes_armor_reduction	= class({})

-- imba_nian_crushing_leap								= class({})
-- -- modifier_imba_nian_crushing_leap_movement		= modifier_generic_motion_controller -- Why doesn't this work
-- modifier_imba_nian_crushing_leap_movement			= class({})
-- modifier_imba_nian_crushing_leap_strength			= class({})
-- modifier_imba_nian_crushing_leap_agility			= class({})
-- modifier_imba_nian_crushing_leap_intellect			= class({})

-- imba_nian_tail_spin									= class({})
-- modifier_imba_nian_tail_spin						= class({})

-- imba_nian_tail_stomp								= class({})
-- modifier_imba_nian_tail_stomp						= class({})

-- imba_nian_volcanic_burster							= class({})
-- modifier_imba_nian_volcanic_burster					= class({})
-- modifier_imba_nian_volcanic_burster_cooldown		= class({})
-- modifier_imba_nian_volcanic_burster_tracker			= class({})

-- -------------------
-- -- FRENZY SWIPES --
-- -------------------

-- function imba_nian_frenzy_swipes:OnToggle()
	-- local frenzy_swipes_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_nian_frenzy_swipes", self:GetCaster())

	-- if self:GetToggleState() and not frenzy_swipes_modifier then
		-- self:GetCaster():EmitSound("Hero_Nian.Frenzy_Swipes_Cast")
	
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_nian_frenzy_swipes", {})
	-- elseif not self:GetToggleState() then
		-- if frenzy_swipes_modifier and frenzy_swipes_modifier:GetElapsedTime() >= 0.25 then
			-- self:GetCaster():RemoveModifierByNameAndCaster("modifier_imba_nian_frenzy_swipes", self:GetCaster())
		-- else
			-- self:ToggleAbility()
		-- end
	-- end
-- end

-- ----------------------------
-- -- FRENZY SWIPES MODIFIER --
-- ----------------------------

-- function modifier_imba_nian_frenzy_swipes:IsPurgable()	return false end

-- function modifier_imba_nian_frenzy_swipes:OnCreated()
	-- self.attack_damage_multiplier	= self:GetAbility():GetSpecialValueFor("attack_damage_multiplier")
	-- self.attack_speed_multiplier	= self:GetAbility():GetSpecialValueFor("attack_speed_multiplier")
	-- self.mana_per_attack			= self:GetAbility():GetSpecialValueFor("mana_per_attack")
	-- self.attack_angle				= self:GetAbility():GetSpecialValueFor("attack_angle")
	-- self.bonus_attack_range			= self:GetAbility():GetSpecialValueFor("bonus_attack_range")
	-- self.move_speed_slow_duration	= self:GetAbility():GetSpecialValueFor("move_speed_slow_duration")
	
	-- if not IsServer() then return end
	
	-- self.attack_point	= self:GetParent():GetAttackAnimationPoint() / (1 + self:GetParent():GetIncreasedAttackSpeed())
	-- self.slash_rate = 1 / ( self:GetParent():GetAttackSpeed() * (math.max(self:GetAbility():GetSpecialValueFor("attack_speed_multiplier"), 1)))
	
	-- self.wind_up = true
	
	-- local glow_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_nian/frenzy_swipes_glow.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	-- ParticleManager:SetParticleControlEnt(glow_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
	-- self:AddParticle(glow_particle, true, false, -1, true, false)
	
	-- local glow_particle_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_nian/frenzy_swipes_glow.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	-- ParticleManager:SetParticleControlEnt(glow_particle_2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true)
	-- self:AddParticle(glow_particle_2, true, false, -1, true, false)
	
	-- self:OnIntervalThink()
-- end

-- function modifier_imba_nian_frenzy_swipes:OnIntervalThink()
	-- if not IsServer() then return end

	-- if self.wind_up then
		-- -- Does not properly account for mana loss reduction abilities right now
		-- if self:GetParent():GetMana() >= self.mana_per_attack and self:GetAbility() then
		
			-- if not self:GetParent():IsStunned() and not self:GetParent():IsOutOfGame() then
				-- -- self:GetCaster():ReduceMana(self.mana_per_attack)
			
				-- self:GetParent():FadeGesture(ACT_DOTA_ATTACK)
				-- self:GetParent():StartGesture(ACT_DOTA_ATTACK)
			-- end
			
			-- self.wind_up = false
			
			-- self:StartIntervalThink(self.slash_rate - self.attack_point)
		-- else
			-- self:StartIntervalThink(-1)
			-- if self:GetAbility() and self:GetAbility():GetToggleState() then
				-- self:GetAbility():ToggleAbility()
			-- end
			
			-- self:Destroy()
		-- end
	-- else
		-- if not self:GetParent():IsStunned() and not self:GetParent():IsOutOfGame() then
			-- local frenzy_swipe_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_nian/frenzy_swipes.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			-- ParticleManager:ReleaseParticleIndex(frenzy_swipe_particle)
			
			-- local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange() + self.bonus_attack_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)

			-- for _, enemy in pairs(enemies) do
				-- if math.abs(AngleDiff(VectorToAngles(self:GetParent():GetForwardVector()).y, VectorToAngles(enemy:GetAbsOrigin() - self:GetParent():GetAbsOrigin()).y)) <= self.attack_angle then
					-- self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_nian_frenzy_swipes_suppression", {})
					-- self:GetParent():PerformAttack(enemy, false, true, true, false, true, false, false)
					-- self:GetParent():RemoveModifierByNameAndCaster("modifier_imba_nian_frenzy_swipes_suppression", self:GetCaster())
					
					-- local slow_modifier = enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_nian_frenzy_swipes_slow", {duration = self.move_speed_slow_duration})
					
					-- if slow_modifier then
						-- slow_modifier:SetDuration(self.move_speed_slow_duration * (1 - enemy:GetStatusResistance()), true)
					-- end
					
					-- if self:GetCaster():HasTalent("special_bonus_imba_nian_frenzy_swipes_upgrade") then
						-- local armor_reduction_modifier = enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_nian_frenzy_swipes_armor_reduction", {duration = self:GetCaster():FindTalentValue("special_bonus_imba_nian_frenzy_swipes_upgrade", "duration")})
						
						-- if armor_reduction_modifier then
							-- armor_reduction_modifier:SetDuration(self:GetCaster():FindTalentValue("special_bonus_imba_nian_frenzy_swipes_upgrade", "duration") * (1 - enemy:GetStatusResistance()), true)
						-- end
					-- end
				-- end
			-- end
		-- end
		
		-- self.wind_up = true
		
		-- self.slash_rate = 1 / ( self:GetParent():GetAttackSpeed() * (math.max(self:GetAbility():GetSpecialValueFor("attack_speed_multiplier"), 1)))
		-- self:StartIntervalThink(self.attack_point)
	-- end
-- end

-- function modifier_imba_nian_frenzy_swipes:OnDestroy()
	-- if not IsServer() then return end
	
	-- self:GetParent():FadeGesture(ACT_DOTA_ATTACK)
-- end

-- function modifier_imba_nian_frenzy_swipes:CheckState()
	-- local state = {
		-- [MODIFIER_STATE_DISARMED]	= true,
		-- [MODIFIER_STATE_ROOTED]		= true
	-- }
	
	-- return state
-- end

-- ----------------------------------------
-- -- FRENZY SWIPES SUPPRESSION MODIFIER --
-- ----------------------------------------

-- -- I guess this will also be used for the bonus attack damage
-- function modifier_imba_nian_frenzy_swipes_suppression:OnCreated()
	-- if self:GetAbility() then
		-- self.attack_damage_multiplier	= self:GetAbility():GetSpecialValueFor("attack_damage_multiplier")
	-- else
		-- self:Destroy()
	-- end
-- end

 -- -- MODIFIER_PROPERTY_SUPPRESS_CLEAVE does not work
-- function modifier_imba_nian_frenzy_swipes_suppression:DeclareFunctions()
	-- local decFuncs = 
	-- {
		-- MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		-- MODIFIER_PROPERTY_SUPPRESS_CLEAVE,
		
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	-- }
	
	-- return decFuncs
-- end

-- function modifier_imba_nian_frenzy_swipes_suppression:GetModifierDamageOutgoing_Percentage()
	-- return (self.attack_damage_multiplier - 1) * 100
-- end

-- function modifier_imba_nian_frenzy_swipes_suppression:GetSuppressCleave()
	-- return 1
-- end

-- -- Hopefully this is enough random information to only suppress cleaves?...
-- function modifier_imba_nian_frenzy_swipes_suppression:GetModifierTotalDamageOutgoing_Percentage(keys)
	-- if not keys.no_attack_cooldown and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.damage_flags == DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION then
		-- return -100
	-- end
-- end

-- ---------------------------------
-- -- FRENZY SWIPES SLOW MODIFIER --
-- ---------------------------------

-- function modifier_imba_nian_frenzy_swipes_slow:OnCreated()
	-- self.move_speed_slow_pct	= self:GetAbility():GetSpecialValueFor("move_speed_slow_pct")
-- end

-- function modifier_imba_nian_frenzy_swipes_slow:DeclareFunctions()
	-- local decFuncs = 
	-- {
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	-- }
	
	-- return decFuncs
-- end

-- function modifier_imba_nian_frenzy_swipes_slow:GetModifierMoveSpeedBonus_Percentage()
	-- return self.move_speed_slow_pct * (-1)
-- end

-- --------------------------------------------
-- -- FRENZY SWIPES ARMOR REDUCTION MODIFIER --
-- --------------------------------------------

-- function modifier_imba_nian_frenzy_swipes_armor_reduction:OnCreated()
	-- if not IsServer() or not self:GetCaster():FindTalentValue("special_bonus_imba_nian_frenzy_swipes_upgrade") then return end
	
	-- self:SetStackCount(self:GetStackCount() + self:GetCaster():FindTalentValue("special_bonus_imba_nian_frenzy_swipes_upgrade"))
-- end

-- function modifier_imba_nian_frenzy_swipes_armor_reduction:OnRefresh()
	-- self:OnCreated()
-- end

-- function modifier_imba_nian_frenzy_swipes_armor_reduction:DeclareFunctions()
	-- local decFuncs = 
	-- {
		-- MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		-- MODIFIER_PROPERTY_TOOLTIP
	-- }
	
	-- return decFuncs
-- end

-- function modifier_imba_nian_frenzy_swipes_armor_reduction:GetModifierPhysicalArmorBonus()
	-- return self:GetStackCount() * (-1)
-- end

-- function modifier_imba_nian_frenzy_swipes_armor_reduction:OnTooltip()
	-- return self:GetStackCount()
-- end

-- -------------------
-- -- CRUSHING LEAP --
-- -------------------

-- function imba_nian_crushing_leap:GetAOERadius()
	-- return self:GetSpecialValueFor("radius")
-- end

-- function imba_nian_crushing_leap:GetCastRange(location, target)
	-- if IsServer() then
		-- return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():FindTalentValue("special_bonus_imba_nian_crushing_leap_cast_range")
	-- else
		-- return self.BaseClass.GetCastRange(self, location, target)
	-- end
-- end

-- function imba_nian_crushing_leap:GetCooldown(level)
	-- return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_nian_crushing_leap_cooldown")
-- end

-- function imba_nian_crushing_leap:GetCastAnimation()
	-- return ACT_DOTA_LEAP_STUN
-- end

-- function imba_nian_crushing_leap:GetPlaybackRateOverride()
	-- return 0.8
-- end

-- function imba_nian_crushing_leap:OnSpellStart()
	-- local direction_vector = self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()
	
	-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_nian_crushing_leap_movement", 
	-- {
		-- distance		= direction_vector:Length2D(),
		-- direction_x 	= direction_vector.x,
		-- direction_y 	= direction_vector.y,
		-- direction_z 	= direction_vector.z,
		-- duration 		= self:GetSpecialValueFor("duration"),
		-- height 			= self:GetSpecialValueFor("min_height") + ((self:GetSpecialValueFor("max_height") - self:GetSpecialValueFor("min_height")) * (1 - direction_vector:Length2D() / (self:GetCastRange(self:GetCursorPosition(), self:GetCaster()) + GetCastRangeIncrease(self:GetCaster())))),
		-- bGroundStop 	= true,
		-- bDecelerate 	= false,
		-- bInterruptible 	= false,
		-- treeRadius		= self:GetSpecialValueFor("radius")
	-- })
-- end

-- -------------------------------------
-- -- CRUSHING LEAP MOVEMENT MODIFIER --
-- -------------------------------------

-- -- Gonna copy-paste my generic motion controller code here cause there's too many changes that need to be made (and I can't copy the class itself for some reason)

-- function modifier_imba_nian_crushing_leap_movement:IgnoreTenacity()	return self.bIgnoreTenacity == 1 end
-- function modifier_imba_nian_crushing_leap_movement:IsPurgable()		return false end
-- function modifier_imba_nian_crushing_leap_movement:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- function modifier_imba_nian_crushing_leap_movement:OnCreated(params)
	-- self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	-- self.damage				= self:GetAbility():GetSpecialValueFor("damage")
	-- self.stun_duration		= self:GetAbility():GetSpecialValueFor("stun_duration")
	
	-- self.scepter_duration	= self:GetAbility():GetSpecialValueFor("scepter_duration")
	
	-- if not IsServer() then return end
	
	-- self.damage_type		= self:GetAbility():GetAbilityDamageType()
	
	-- self.distance			= params.distance
	-- self.direction			= Vector(params.direction_x, params.direction_y, params.direction_z):Normalized()
	-- self.duration			= params.duration
	-- self.height				= params.height
	-- self.bInterruptible		= params.bInterruptible
	-- self.bGroundStop		= params.bGroundStop
	-- self.bDecelerate		= params.bDecelerate
	-- self.bIgnoreTenacity	= params.bIgnoreTenacity
	-- self.treeRadius			= params.treeRadius

	-- self.velocity		= self.direction * self.distance / self.duration

	-- if self.bDecelerate and self.bDecelerate == 1 then
		-- self.horizontal_velocity		= (2 * self.distance / self.duration) * self.direction
		-- self.horizontal_acceleration 	= -(2 * self.distance) / (self.duration * self.duration)
	-- end
	
	-- if self.height then
		-- self.vertical_velocity		= 4 * self.height / self.duration
		-- self.vertical_acceleration	= -(8 * self.height) / (self.duration * self.duration)
	-- end
	
	-- if self:ApplyVerticalMotionController() == false then 
		-- self:Destroy()
	-- end
	
	-- if self:ApplyHorizontalMotionController() == false then 
		-- self:Destroy()
	-- end
-- end

-- function modifier_imba_nian_crushing_leap_movement:OnDestroy()
	-- if not IsServer() then return end
	
	-- self:GetParent():InterruptMotionControllers(true)
	
	-- if self:GetParent():IsAlive() then
		-- if self:GetRemainingTime() <= 0 and self.treeRadius then
			-- GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.treeRadius, true )
		-- end

		-- self:GetParent():EmitSound("Roshan.Slam")

		-- local slam_particle = ParticleManager:CreateParticle("particles/neutral_fx/roshan_slam.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		-- ParticleManager:SetParticleControl(slam_particle, 0, self:GetParent():GetAbsOrigin())
		-- ParticleManager:SetParticleControl(slam_particle, 1, Vector(self.radius, self.radius, self.radius))
		-- ParticleManager:ReleaseParticleIndex(slam_particle)
		
		-- local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

		-- for _, enemy in pairs(enemies) do
			-- local damageTable = {
				-- victim 			= enemy,
				-- damage 			= self.damage,
				-- damage_type		= self.damage_type,
				-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				-- attacker 		= self:GetParent(),
				-- ability 		= self:GetAbility()
			-- }

			-- ApplyDamage(damageTable)
		
			-- if not enemy:IsMagicImmune() then
				-- local stun_modifier = enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.stun_duration})
				
				-- if stun_modifier then
					-- stun_modifier:SetDuration(self.stun_duration * (1 - enemy:GetStatusResistance()), true)
				-- end
				
				-- if self:GetCaster():HasScepter() then
					-- local strength_modifier		= enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_nian_crushing_leap_strength", {duration = self.scepter_duration})
					-- local agility_modifier		= enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_nian_crushing_leap_agility", {duration = self.scepter_duration})
					-- local intellect_modifier	= enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_nian_crushing_leap_intellect", {duration = self.scepter_duration})
					
					-- if strength_modifier and agility_modifier and intellect_modifier then
						-- strength_modifier:SetDuration(self.scepter_duration * (1 - enemy:GetStatusResistance()), true)
						-- agility_modifier:SetDuration(self.scepter_duration * (1 - enemy:GetStatusResistance()), true)
						-- intellect_modifier:SetDuration(self.scepter_duration * (1 - enemy:GetStatusResistance()), true)
					-- end
				-- end
			-- end
		-- end
	-- end
-- end

-- function modifier_imba_nian_crushing_leap_movement:UpdateHorizontalMotion(me, dt)
	-- if not IsServer() then return end
	
	-- if not self.bDecelerate or self.bDecelerate == 0 then
		-- me:SetOrigin( me:GetOrigin() + self.velocity * dt )
	-- else
		-- me:SetOrigin( me:GetOrigin() + (self.horizontal_velocity * dt) )
		-- self.horizontal_velocity = self.horizontal_velocity + (self.direction * self.horizontal_acceleration * dt)
	-- end
	
	-- if self.bInterruptible == 1 and self:GetParent():IsStunned() then
		-- self:Destroy()
	-- end
-- end

-- -- This typically gets called if the caster uses a position breaking tool (ex. Blink Dagger) while in mid-motion
-- function modifier_imba_nian_crushing_leap_movement:OnHorizontalMotionInterrupted()
	-- self:Destroy()
-- end

-- function modifier_imba_nian_crushing_leap_movement:UpdateVerticalMotion(me, dt)
	-- if not IsServer() then return end
	
	-- if self.height then
		-- me:SetOrigin( me:GetOrigin() + Vector(0, 0, self.vertical_velocity) * dt )
		
		-- if self.bGroundStop == 1 and GetGroundHeight(self:GetParent():GetAbsOrigin(), nil) > self:GetParent():GetAbsOrigin().z then
			-- self:Destroy()
		-- else
			-- self.vertical_velocity = self.vertical_velocity + (self.vertical_acceleration * dt)
		-- end
	-- else
		-- me:SetOrigin( GetGroundPosition(me:GetOrigin(), nil) )
	-- end
-- end

-- -- -- This typically gets called if the caster uses a position breaking tool (ex. Earth Spike) while in mid-motion
-- function modifier_imba_nian_crushing_leap_movement:OnVerticalMotionInterrupted()
	-- self:Destroy()
-- end

-- -------------------------------------
-- -- CRUSHING LEAP STRENGTH MODIFIER --
-- -------------------------------------

-- function modifier_imba_nian_crushing_leap_strength:OnCreated()
	-- if not IsServer() then return end
	
	-- -- In this case this modifier gets refreshed, so it can calculate the percentage properly
	-- self:SetStackCount(0)
	
	-- if self:GetParent().GetStrength then
		-- self:SetStackCount(self:GetParent():GetStrength() * self:GetAbility():GetSpecialValueFor("scepter_stat_reduction") * 0.01)
	-- end
-- end

-- function modifier_imba_nian_crushing_leap_strength:OnRefresh()
	-- self:OnCreated()
-- end

-- function modifier_imba_nian_crushing_leap_strength:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		-- MODIFIER_PROPERTY_TOOLTIP
	-- }
	
	-- return decFuncs
-- end

-- function modifier_imba_nian_crushing_leap_strength:GetModifierBonusStats_Strength()
	-- return self:GetStackCount() * (-1)
-- end

-- function modifier_imba_nian_crushing_leap_strength:OnTooltip()
	-- return self:GetStackCount()
-- end

-- ------------------------------------
-- -- CRUSHING LEAP AGILITY MODIFIER --
-- ------------------------------------

-- function modifier_imba_nian_crushing_leap_agility:OnCreated()
	-- if not IsServer() then return end
	
	-- -- In this case this modifier gets refreshed, so it can calculate the percentage properly
	-- self:SetStackCount(0)
	
	-- if self:GetParent().GetAgility then
		-- self:SetStackCount(self:GetParent():GetAgility() * self:GetAbility():GetSpecialValueFor("scepter_stat_reduction") * 0.01)
	-- end
-- end

-- function modifier_imba_nian_crushing_leap_agility:OnRefresh()
	-- self:OnCreated()
-- end

-- function modifier_imba_nian_crushing_leap_agility:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		-- MODIFIER_PROPERTY_TOOLTIP
	-- }
	
	-- return decFuncs
-- end

-- function modifier_imba_nian_crushing_leap_agility:GetModifierBonusStats_Agility()
	-- return self:GetStackCount() * (-1)
-- end

-- function modifier_imba_nian_crushing_leap_agility:OnTooltip()
	-- return self:GetStackCount()
-- end

-- --------------------------------------
-- -- CRUSHING LEAP INTELLECT MODIFIER --
-- --------------------------------------

-- function modifier_imba_nian_crushing_leap_intellect:OnCreated()
	-- if not IsServer() then return end
	
	-- -- In this case this modifier gets refreshed, so it can calculate the percentage properly
	-- self:SetStackCount(0)
	
	-- if self:GetParent().GetIntellect then
		-- self:SetStackCount(self:GetParent():GetIntellect() * self:GetAbility():GetSpecialValueFor("scepter_stat_reduction") * 0.01)
	-- end
-- end

-- function modifier_imba_nian_crushing_leap_intellect:OnRefresh()
	-- self:OnCreated()
-- end

-- function modifier_imba_nian_crushing_leap_intellect:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		-- MODIFIER_PROPERTY_TOOLTIP
	-- }
	
	-- return decFuncs
-- end

-- function modifier_imba_nian_crushing_leap_intellect:GetModifierBonusStats_Intellect()
	-- return self:GetStackCount() * (-1)
-- end

-- function modifier_imba_nian_crushing_leap_intellect:OnTooltip()
	-- return self:GetStackCount()
-- end

-- ---------------
-- -- TAIL SPIN --
-- ---------------

-- function imba_nian_tail_spin:GetCastAnimation()
	-- return ACT_DOTA_CAST_ABILITY_5
-- end

-- function imba_nian_tail_spin:GetPlaybackRateOverride()
	-- return 2
-- end

-- function imba_nian_tail_spin:GetBehavior()
	-- return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
-- end

-- function imba_nian_tail_spin:OnSpellStart()
	-- local spin_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_nian/tail_spin.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	-- ParticleManager:ReleaseParticleIndex(spin_particle)

	-- GridNav:DestroyTreesAroundPoint( self:GetCaster():GetOrigin(), self:GetSpecialValueFor("radius"), true )

	-- self:GetCaster():EmitSound("Hero_Nian.Tail_Spin_Swoosh")
	
	-- local target_flag = DOTA_UNIT_TARGET_FLAG_NONE
	
	-- if self:GetCaster():HasTalent("special_bonus_imba_nian_tail_spin_pierces_spell_immunity") then
		-- target_flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	-- end
	
	-- local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, target_flag, FIND_ANY_ORDER, false)

	-- if #enemies >= 1 then
		-- self:GetCaster():EmitSound("Hero_Nian.Tail_Spin_Impact")
	-- end

	-- for _, enemy in pairs(enemies) do
		-- local damageTable = {
			-- victim 			= enemy,
			-- damage 			= self:GetSpecialValueFor("damage"),
			-- damage_type		= self:GetAbilityDamageType(),
			-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			-- attacker 		= self:GetCaster(),
			-- ability 		= self
		-- }

		-- ApplyDamage(damageTable)
	
		-- local stun_modifier = enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun_duration")})
		
		-- if stun_modifier then
			-- stun_modifier:SetDuration(self:GetSpecialValueFor("stun_duration") * (1 - enemy:GetStatusResistance()), true)
		-- end
		
		-- local direction_vector = Vector(0, 0, 0)
		
		-- if self:GetAutoCastState() then
			-- direction_vector = enemy:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()
		-- end
		
		-- local knockback_modifier = enemy:AddNewModifier(self:GetCaster(), self, "modifier_generic_motion_controller", 
		-- {
			-- distance		= self:GetSpecialValueFor("knockback_distance"),
			-- direction_x 	= direction_vector.x,
			-- direction_y 	= direction_vector.y,
			-- direction_z 	= direction_vector.z,
			-- duration 		= self:GetSpecialValueFor("duration"),
			-- height 			= self:GetSpecialValueFor("knockback_height"),
			-- bGroundStop 	= true,
			-- bDecelerate 	= false,
			-- bInterruptible 	= false,
			-- bIgnoreTenacity	= true,
			-- treeRadius		= self:GetSpecialValueFor("tree_radius")
		-- })
	-- end
-- end

-- ----------------------
-- -- VOLCANIC BURSTER --
-- ----------------------

-- function imba_nian_volcanic_burster:GetCastAnimation()
	-- return ACT_DOTA_NIAN_GAME_END
-- end

-- function imba_nian_volcanic_burster:GetPlaybackRateOverride()
	-- return 0.8
-- end

-- function imba_nian_volcanic_burster:GetAOERadius()
	-- return self:GetSpecialValueFor("radius")
-- end

-- function imba_nian_volcanic_burster:OnSpellStart()
	-- -- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	-- if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		-- self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	-- end

	-- self:GetCaster():EmitSound("Hero_Nian.Volcanic_Burster_Cast")

	-- -- Use a dummy to attach potential sounds to + keep track of projectile time
	-- local volcanic_dummy = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_nian_volcanic_burster_tracker", {}, self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * self:GetSpecialValueFor("projectile_spawn_distance"), self:GetCaster():GetTeamNumber(), false)
	-- volcanic_dummy:EmitSound("Hero_Nian.Volcanic_Burster_Flight")

	-- local velocity	= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("projectile_speed")

	-- local linear_projectile = {
		-- Ability				= self,
		-- EffectName			= "particles/units/heroes/hero_nian/volcanic_burster_main.vpcf",
		-- vSpawnOrigin		= self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * self:GetSpecialValueFor("projectile_spawn_distance"),
		-- fDistance			= self:GetCastRange(self:GetCursorPosition(), self:GetCaster()) + GetCastRangeIncrease(self:GetCaster()),
		-- fStartRadius		= self:GetSpecialValueFor("radius"),
		-- fEndRadius			= self:GetSpecialValueFor("radius"),
		-- Source				= self:GetCaster(),
		-- bHasFrontalCone		= false,
		-- bReplaceExisting	= false,
		-- iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		-- iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		-- iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		-- fExpireTime 		= GameRules:GetGameTime() + 20.0,
		-- bDeleteOnHit		= true,
		-- vVelocity			= Vector(velocity.x, velocity.y, 0),
		-- bProvidesVision		= true,
		-- iVisionRadius 		= self:GetSpecialValueFor("radius"),
		-- iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),
		
		-- ExtraData			=
		-- {
			-- direction_x		= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()).x,
			-- direction_y		= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()).y,
			-- direction_z		= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()).z,
			-- volcanic_dummy	= volcanic_dummy:entindex(),
		-- }
	-- }
	
	-- ProjectileManager:CreateLinearProjectile(linear_projectile)
-- end

-- function imba_nian_volcanic_burster:SecondaryProjectiles(location, direction)
	-- local linear_projectile = {
		-- Ability				= self,
		-- EffectName			= "particles/units/heroes/hero_nian/volcanic_burster_secondary.vpcf",
		-- vSpawnOrigin		= location,
		-- fDistance			= self:GetSpecialValueFor("secondary_distance"),
		-- fStartRadius		= self:GetSpecialValueFor("secondary_radius"),
		-- fEndRadius			= self:GetSpecialValueFor("secondary_radius"),
		-- Source				= self:GetCaster(),
		-- bHasFrontalCone		= false,
		-- bReplaceExisting	= false,
		-- iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		-- iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		-- iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		-- fExpireTime 		= GameRules:GetGameTime() + 10.0,
		-- bDeleteOnHit		= true,
		-- vVelocity			= direction:Normalized() * self:GetSpecialValueFor("secondary_speed"),
		-- bProvidesVision		= true,
		-- iVisionRadius 		= self:GetSpecialValueFor("secondary_radius"),
		-- iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),
		
		-- ExtraData			=
		-- {
			-- bSecondary		= true
		-- }
	-- }
	
	-- ProjectileManager:CreateLinearProjectile(linear_projectile)
-- end

-- function imba_nian_volcanic_burster:OnProjectileThink_ExtraData(location, data)
	-- if not IsServer() or data.bSecondary == 1 then return end
	
	-- if data.volcanic_dummy then
		-- EntIndexToHScript(data.volcanic_dummy):SetAbsOrigin(location)
	-- end	
	
	-- local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	-- for _, enemy in pairs(enemies) do
		-- if not enemy:FindModifierByNameAndCaster("modifier_imba_nian_volcanic_burster_cooldown", self:GetCaster()) then
			-- enemy:EmitSound("BodyImpact_Common.Heavy")
			
			-- local damageTable = {
				-- victim 			= enemy,
				-- damage 			= self:GetSpecialValueFor("damage_per_tick"),
				-- damage_type		= self:GetAbilityDamageType(),
				-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				-- attacker 		= self:GetCaster(),
				-- ability 		= self
			-- }
			
			-- ApplyDamage(damageTable)

			-- -- Get the normal push vector
			-- local push_vector		= self:GetSpecialValueFor("projectile_speed") * Vector(data.direction_x, data.direction_y, data.direction_z):Normalized() * (self:GetSpecialValueFor("stun_on") + self:GetSpecialValueFor("stun_off"))
			
			-- -- Get the "suction" vector, being the vector from enemy location to projectile location, and multiply by a percentage
			-- local suction_vector	= (location - enemy:GetAbsOrigin() + push_vector) * self:GetSpecialValueFor("suction_pct") * 0.01
			
			-- -- Sum the two together to get the final result of where to push
			-- local final_vector		= push_vector + suction_vector

			-- local knockback_modifier = enemy:AddNewModifier(self:GetCaster(), self, "modifier_generic_motion_controller", 
			-- {
				-- distance		= final_vector:Length2D(),
				-- direction_x 	= final_vector.x,
				-- direction_y 	= final_vector.y,
				-- direction_z 	= final_vector.z,
				-- duration 		= self:GetSpecialValueFor("stun_on"),
				-- bGroundStop 	= false,
				-- bDecelerate 	= false,
				-- bInterruptible 	= false,
				-- bIgnoreTenacity	= true,
				-- bStun			= true,
				-- bTreeRadius		= self:GetSpecialValueFor("tree_radius")
			-- })
			
			-- local burn_modifier = enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_nian_volcanic_burster", {duration = self:GetSpecialValueFor("burn_duration")})
			
			-- if burn_modifier then
				-- burn_modifier:SetDuration(self:GetSpecialValueFor("burn_duration") * (1 - enemy:GetStatusResistance()), true)
			-- end
			
			-- enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_nian_volcanic_burster_cooldown", {duration = self:GetSpecialValueFor("stun_on") + self:GetSpecialValueFor("stun_off")})
		-- end
	-- end
-- end

-- function imba_nian_volcanic_burster:OnProjectileHit_ExtraData(target, location, data)
	-- if not IsServer() then return end
		
	-- if target and data.bSecondary == 1 then
		-- local burn_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_nian_volcanic_burster", {duration = self:GetSpecialValueFor("burn_duration")})
		
		-- if burn_modifier then
			-- burn_modifier:SetDuration(self:GetSpecialValueFor("burn_duration") * (1 - target:GetStatusResistance()), true)
		-- end
	-- elseif not target and data.volcanic_dummy then
		-- EntIndexToHScript(data.volcanic_dummy):RemoveSelf()
	-- end
-- end

-- -------------------------------
-- -- VOLCANIC BURSTER MODIFIER --
-- -------------------------------

-- function modifier_imba_nian_volcanic_burster:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- function modifier_imba_nian_volcanic_burster:GetEffectName()
	-- return "particles/units/heroes/hero_invoker/invoker_chaos_meteor_burn_debuff.vpcf"
-- end

-- function modifier_imba_nian_volcanic_burster:OnCreated()
	-- self.burn_tick_rate	= self:GetAbility():GetSpecialValueFor("burn_tick_rate")
	-- self.burn_damage	= self:GetAbility():GetSpecialValueFor("burn_damage")

	-- if not IsServer() then return end
	
	-- self:StartIntervalThink(self.burn_tick_rate * (1 - self:GetParent():GetStatusResistance()))
-- end

-- function modifier_imba_nian_volcanic_burster:OnIntervalThink()
	-- if not IsServer() then return end
	
	-- local damageTable = {
		-- victim 			= self:GetParent(),
		-- damage 			= self:GetAbility():GetSpecialValueFor("burn_damage"),
		-- damage_type		= self:GetAbility():GetAbilityDamageType(),
		-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		-- attacker 		= self:GetCaster(),
		-- ability 		= self:GetAbility()
	-- }
	
	-- ApplyDamage(damageTable)	
-- end

-- ----------------------------------------
-- -- VOLCANIC BURSTER COOLDOWN MODIFIER --
-- ----------------------------------------

-- function modifier_imba_nian_volcanic_burster_cooldown:IgnoreTenacity()	return true end
-- function modifier_imba_nian_volcanic_burster_cooldown:IsHidden()		return true end
-- function modifier_imba_nian_volcanic_burster_cooldown:IsPurgable()		return false end

-- ---------------------------------------
-- -- VOLCANIC BURSTER TRACKER MODIFIER --
-- ---------------------------------------

-- function modifier_imba_nian_volcanic_burster_tracker:IsHidden()		return true end
-- function modifier_imba_nian_volcanic_burster_tracker:IsPurgable()		return false end

-- function modifier_imba_nian_volcanic_burster_tracker:OnCreated()
	-- self.radius							= self:GetAbility():GetSpecialValueFor("radius")
	-- self.projectiles_per_tick			= self:GetAbility():GetSpecialValueFor("projectiles_per_tick")
	-- self.extra_projectile_tick_timer	= self:GetAbility():GetSpecialValueFor("stun_on") + self:GetAbility():GetSpecialValueFor("stun_off")
	
	-- if not IsServer() then return end

	-- self:StartIntervalThink(self.extra_projectile_tick_timer)
-- end

-- function modifier_imba_nian_volcanic_burster_tracker:OnIntervalThink()
	-- if not IsServer() then return end

	-- if self:GetAbility() then
		-- for projectile = 1, self.projectiles_per_tick do
			-- local random_vector = RandomVector(self.radius)
				
			-- local spawn_vector	= GetGroundPosition(self:GetParent():GetAbsOrigin() + random_vector, nil)
			
			-- -- Offset height to make it look a little better?
			-- spawn_vector.z		= spawn_vector.z + 50
		
			-- self:GetAbility():SecondaryProjectiles(spawn_vector, random_vector)
		-- end
	-- end
-- end

-- ---------------------
-- -- TALENT HANDLERS --
-- ---------------------

-- LinkLuaModifier("modifier_special_bonus_imba_nian_crushing_leap_cast_range", "components/abilities/heroes/hero_nian", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_special_bonus_imba_nian_crushing_leap_cooldown", "components/abilities/heroes/hero_nian", LUA_MODIFIER_MOTION_NONE)

-- modifier_special_bonus_imba_nian_crushing_leap_cast_range	= class({})
-- modifier_special_bonus_imba_nian_crushing_leap_cooldown		= class({})

-- function modifier_special_bonus_imba_nian_crushing_leap_cast_range:IsHidden() 		return true end
-- function modifier_special_bonus_imba_nian_crushing_leap_cast_range:IsPurgable() 	return false end
-- function modifier_special_bonus_imba_nian_crushing_leap_cast_range:RemoveOnDeath() 	return false end

-- function modifier_special_bonus_imba_nian_crushing_leap_cooldown:IsHidden() 		return true end
-- function modifier_special_bonus_imba_nian_crushing_leap_cooldown:IsPurgable() 		return false end
-- function modifier_special_bonus_imba_nian_crushing_leap_cooldown:RemoveOnDeath() 	return false end

-- function imba_nian_crushing_leap:OnOwnerSpawned()
	-- if not IsServer() then return end

	-- if self:GetCaster():HasTalent("special_bonus_imba_nian_crushing_leap_cast_range") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_nian_crushing_leap_cast_range") then
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_nian_crushing_leap_cast_range"), "modifier_special_bonus_imba_nian_crushing_leap_cast_range", {})
	-- end
	
	-- if self:GetCaster():HasTalent("special_bonus_imba_nian_crushing_leap_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_nian_crushing_leap_cooldown") then
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_nian_crushing_leap_cooldown"), "modifier_special_bonus_imba_nian_crushing_leap_cooldown", {})
	-- end
-- end
