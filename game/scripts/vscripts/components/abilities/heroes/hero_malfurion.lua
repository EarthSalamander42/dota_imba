-- Editors:
--     EarthSalamander #42, 02.04.2017

--------------------------
--	Entrangling Roots	--
--------------------------

LinkLuaModifier("modifier_imba_entrangling_roots", "components/abilities/heroes/hero_malfurion", LUA_MODIFIER_MOTION_NONE)

imba_malfurion_entrangling_roots = imba_malfurion_entrangling_roots or class({})

function imba_malfurion_entrangling_roots:OnSpellStart()
	local target = self:GetCursorTarget()

	if not target:TriggerSpellAbsorb(self) then
		target:EmitSound("Hero_Treant.LeechSeed.Target")
		target:AddNewModifier(self:GetCursorTarget(), self, "modifier_imba_entrangling_roots", {duration=self:GetSpecialValueFor("duration") - 0.01}) -- minus 0.01 second/instance to keep the right root duration but have 1 less damage instance, because first damage instance happen when modifier is granted and not after the first think time.
	end
end

modifier_imba_entrangling_roots = modifier_imba_entrangling_roots or class({})

function modifier_imba_entrangling_roots:IgnoreTenacity()	return true end
function modifier_imba_entrangling_roots:IsDebuff()			return true end
function modifier_imba_entrangling_roots:IsPurgable()		return true end

-------------------------------------------

function modifier_imba_entrangling_roots:GetEffectName()
	return "particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf"
end

function modifier_imba_entrangling_roots:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_entrangling_roots:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}
end

function modifier_imba_entrangling_roots:OnCreated()
	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_entrangling_roots:OnIntervalThink()
	ApplyDamage({
		victim = self:GetParent(),
		attacker = self:GetAbility():GetCaster(),
		damage = self:GetAbility():GetSpecialValueFor("dmg_per_sec"),
		damage_type = self:GetAbility():GetAbilityDamageType()
	})
end

------------------------------
--		Rejuvenation		--
------------------------------

LinkLuaModifier("modifier_imba_rejuvenation", "components/abilities/heroes/hero_malfurion", LUA_MODIFIER_MOTION_NONE)

imba_malfurion_rejuvenation = imba_malfurion_rejuvenation or class({})

function imba_malfurion_rejuvenation:OnAbilityPhaseStart()
	if not IsServer() then return end

	self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)

	return true
end

function imba_malfurion_rejuvenation:OnAbilityPhaseInterrupted()
	if not IsServer() then return end

	self:GetCaster():FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
end

function imba_malfurion_rejuvenation:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_malfurion_rejuvenation:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Warlock.ShadowWordCastGood")
	
	local particle = nil
	
	for _, ally in pairs (FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("radius"), self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)) do
		particle = ParticleManager:CreateParticle("particles/econ/items/leshrac/leshrac_tormented_staff_retro/leshrac_split_retro_sparks_tormented.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
		ParticleManager:ReleaseParticleIndex(particle)
	
		ally:AddNewModifier(self:GetCaster(), self, "modifier_imba_rejuvenation", {duration=self:GetSpecialValueFor("duration")})
	end
end

modifier_imba_rejuvenation = modifier_imba_rejuvenation or class({})

function modifier_imba_rejuvenation:OnCreated()
	if IsServer() then
		self.heal_per_sec = self:GetAbility():GetSpecialValueFor("heal_per_sec") + self:GetCaster():FindTalentValue("special_bonus_imba_malfurion_5")
		
		if self:GetParent():IsBuilding() or string.find(self:GetParent():GetUnitName(), "living_tower") then
			self.heal_per_sec = self.heal_per_sec / 100 * self:GetAbility():GetSpecialValueFor("heal_per_sec_building_pct")
		elseif not self:GetParent():IsHero() then
			self.heal_per_sec = self.heal_per_sec / 100 * self:GetAbility():GetSpecialValueFor("heal_per_sec_creep_pct")
		end
		
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_rejuvenation:OnIntervalThink()
	self:GetParent():Heal(self.heal_per_sec, self:GetCaster())
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self.heal_per_sec, nil)
end

function modifier_imba_rejuvenation:GetEffectName()
	return "particles/econ/events/ti6/bottle_ti6.vpcf"
end

function modifier_imba_rejuvenation:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-----------------------------
--     Mark of the Claw    --
-----------------------------

LinkLuaModifier("modifier_imba_mark_of_the_claw", "components/abilities/heroes/hero_malfurion", LUA_MODIFIER_MOTION_NONE)

imba_malfurion_mark_of_the_claw = imba_malfurion_mark_of_the_claw or class({})

function imba_malfurion_mark_of_the_claw:GetIntrinsicModifierName()
	return "modifier_imba_mark_of_the_claw"
end

modifier_imba_mark_of_the_claw = modifier_imba_mark_of_the_claw or class({})

function modifier_imba_mark_of_the_claw:IsHidden() return true end

function modifier_imba_mark_of_the_claw:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_imba_mark_of_the_claw:OnAttackLanded(kv)
	if IsServer() then
		if self:GetParent() == kv.attacker and kv.attacker:GetTeamNumber() ~= kv.target:GetTeamNumber() then
			if kv.target:IsBuilding() then return end

			if RollPseudoRandom(self:GetAbility():GetSpecialValueFor("chance"), self) then
				local base_damage = kv.damage * (self:GetAbility():GetSpecialValueFor("bonus_damage_pct") / 100)
				local splash_damage = base_damage * (self:GetAbility():GetSpecialValueFor("splash_damage_pct") / 100)

				ApplyDamage({
					victim = kv.target,
					attacker = kv.attacker,
					damage = base_damage,
					damage_type = DAMAGE_TYPE_PHYSICAL
				})

				kv.attacker:EmitSound("Imba.UrsaDeepStrike")

				local coup_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, kv.attacker)
				ParticleManager:SetParticleControlEnt(coup_pfx, 0, kv.target, PATTACH_POINT_FOLLOW, "attach_hitloc", kv.target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(coup_pfx, 1, kv.target, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", kv.target:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(coup_pfx)

				DoCleaveAttack(
					kv.attacker,
					kv.target,
					self:GetAbility(),
					splash_damage,
					self:GetAbility():GetSpecialValueFor("cleave_start"),
					self:GetAbility():GetSpecialValueFor("cleave_end"),
					self:GetAbility():GetSpecialValueFor("radius"),
					"particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf"
				)
			end
		end
	end
end

-----------------------------
--  Strength of the Wild   --
-----------------------------

LinkLuaModifier("modifier_imba_malfurion_strength_of_the_wild", "components/abilities/heroes/hero_malfurion", LUA_MODIFIER_MOTION_NONE)

imba_malfurion_strength_of_the_wild = imba_malfurion_strength_of_the_wild or class({})

function imba_malfurion_strength_of_the_wild:IsInnateAbility() return true end

function imba_malfurion_strength_of_the_wild:GetIntrinsicModifierName()
	return "modifier_imba_malfurion_strength_of_the_wild"
end

modifier_imba_malfurion_strength_of_the_wild = modifier_imba_malfurion_strength_of_the_wild or class({})

function modifier_imba_malfurion_strength_of_the_wild:IsHidden() return true end

function modifier_imba_malfurion_strength_of_the_wild:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE  
	}
	return funcs
end

function modifier_imba_malfurion_strength_of_the_wild:GetModifierDamageOutgoing_Percentage(keys)
	if keys.target and keys.target.IsRealHero and not keys.target:IsRealHero() and not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage_percentage")
	end
end

---------------------
--  Living Tower   --
---------------------

LinkLuaModifier("modifier_imba_malfurion_living_tower", "components/abilities/heroes/hero_malfurion", LUA_MODIFIER_MOTION_NONE)

imba_malfurion_living_tower = imba_malfurion_living_tower or class({})

function imba_malfurion_living_tower:OnAbilityPhaseStart()
	if not IsServer() then return end

	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)

	return true
end

function imba_malfurion_living_tower:OnAbilityPhaseInterrupted()
	if not IsServer() then return end

	self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_4)
end

function imba_malfurion_living_tower:OnSpellStart()
	if IsServer() then
		local tower_name = {}
		tower_name[2] = "radiant"
		tower_name[3] = "dire"
		self.living_tower = CreateUnitByName("npc_imba_malfurion_living_tower_"..tower_name[self:GetCaster():GetTeamNumber()], self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeam())
		
		if not self:GetCaster():HasScepter() then
			self.living_tower:AddNewModifier(self.living_tower, self, "modifier_kill", {duration=self:GetSpecialValueFor("duration")})
		else
			self.living_tower:AddNewModifier(self.living_tower, self, "modifier_kill", {duration=self:GetSpecialValueFor("scepter_duration")})
		end
		
		self.living_tower:AddNewModifier(self.living_tower, self, "modifier_imba_malfurion_living_tower", {})
		
		if self:GetCaster().GetPlayerID then
			self.living_tower:SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)
		elseif self:GetCaster().GetOwner and self:GetCaster():GetOwner().GetPlayerID then
			self.living_tower:SetControllableByPlayer(self:GetCaster():GetOwner():GetPlayerID(), false)
		end
		
		if not self:GetCaster():HasScepter() then
			self.living_tower:SetMaxHealth(self:GetSpecialValueFor("health"))
			self.living_tower:SetHealth(self:GetSpecialValueFor("health"))
			self.living_tower:SetBaseMaxHealth(self:GetSpecialValueFor("health"))
		else
			self.living_tower:SetMaxHealth(self:GetSpecialValueFor("scepter_health"))
			self.living_tower:SetHealth(self:GetSpecialValueFor("scepter_health"))
			self.living_tower:SetBaseMaxHealth(self:GetSpecialValueFor("scepter_health"))		
		end
		
		self.living_tower:SetBaseDamageMin(self:GetSpecialValueFor("damage") * 0.9)
		self.living_tower:SetBaseDamageMax(self:GetSpecialValueFor("damage") * 1.1)
		self.living_tower:SetAcquisitionRange(self:GetSpecialValueFor("attack_range"))
		self.living_tower:SetDeathXP(self:GetSpecialValueFor("xp_bounty"))
		self.living_tower:SetMinimumGoldBounty(self:GetSpecialValueFor("gold_bounty"))
		self.living_tower:SetMaximumGoldBounty(self:GetSpecialValueFor("gold_bounty"))
		self.living_tower:EmitSound("Hero_Treant.Overgrowth.Cast")
		if self:GetCaster():HasTalent("special_bonus_imba_malfurion_1") then
			self.living_tower:AddAbility("imba_tower_aegis"):SetLevel(self:GetLevel())
		end
		if self:GetCaster():HasTalent("special_bonus_imba_malfurion_2") then
			self.living_tower:AddAbility("imba_tower_atrophy"):SetLevel(self:GetLevel())
		end
		if self:GetCaster():HasTalent("special_bonus_imba_malfurion_3") then
			self.living_tower:AddAbility("imba_tower_soul_leech"):SetLevel(self:GetLevel())
		end
		if self:GetCaster():HasTalent("special_bonus_imba_malfurion_4") then
			self.living_tower:AddAbility("imba_tower_barrier"):SetLevel(self:GetLevel())
		end
	end
end

modifier_imba_malfurion_living_tower = modifier_imba_malfurion_living_tower or class({})

function modifier_imba_malfurion_living_tower:IsHidden() return true end
function modifier_imba_malfurion_living_tower:IsPurgable()	return false end
function modifier_imba_malfurion_living_tower:RemoveOnDeath() return false end

function modifier_imba_malfurion_living_tower:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
--		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_imba_malfurion_living_tower:GetEffectName()
	if self:GetStackCount() == 2 then
		return "particles/econ/world/towers/rock_golem/radiant_rock_golem_ambient.vpcf"
	elseif self:GetStackCount() == 3 then
		return "particles/econ/world/towers/rock_golem/dire_rock_golem_ambient.vpcf"
	end
end

function modifier_imba_malfurion_living_tower:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_malfurion_living_tower:GetOverrideAnimation()
	return ACT_DOTA_CUSTOM_TOWER_IDLE
end

function modifier_imba_malfurion_living_tower:OnCreated()
	self.attack_speed	= self:GetAbility():GetSpecialValueFor("attack_speed")
	self.attack_range	= self:GetAbility():GetSpecialValueFor("attack_range")

	if not IsServer() then return end

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:ReleaseParticleIndex(pfx)

	self:SetStackCount(self:GetCaster():GetTeamNumber())
end

function modifier_imba_malfurion_living_tower:OnAttackStart(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() then
		self:GetParent():EmitSound("Tree.GrowBack")
		self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CUSTOM_TOWER_ATTACK, self:GetParent():GetAttacksPerSecond())
	end
end

--[[ -- Works around the caster only
function modifier_imba_malfurion_living_tower:OnAttackLanded(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() then
		if keys.attacker:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			DoCleaveAttack(
				self:GetParent(),
				keys.target,
				self:GetAbility(),
				self:GetAbility():GetSpecialValueFor("cleave_pct"),
				self:GetAbility():GetSpecialValueFor("cleave_radius"),
				self:GetAbility():GetSpecialValueFor("cleave_radius"),
				self:GetAbility():GetSpecialValueFor("cleave_radius"),
				"particles/items_fx/battlefury_cleave.vpcf"
			)
		end
	end
end
--]]
function modifier_imba_malfurion_living_tower:OnDeath(keys)
	if not IsServer() then return end

	if keys.unit == self:GetParent() then
		self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CUSTOM_TOWER_DIE, 0.75)
	end
end

function modifier_imba_malfurion_living_tower:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function modifier_imba_malfurion_living_tower:GetModifierAttackRangeBonus()
	return self.attack_range
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_malfurion_1", "components/abilities/heroes/hero_malfurion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_malfurion_2", "components/abilities/heroes/hero_malfurion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_malfurion_5", "components/abilities/heroes/hero_malfurion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_malfurion_4", "components/abilities/heroes/hero_malfurion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_malfurion_3", "components/abilities/heroes/hero_malfurion", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_malfurion_1		= modifier_special_bonus_imba_malfurion_1 or class({})
modifier_special_bonus_imba_malfurion_2		= modifier_special_bonus_imba_malfurion_2 or class({})
modifier_special_bonus_imba_malfurion_5		= modifier_special_bonus_imba_malfurion_5 or class({})
modifier_special_bonus_imba_malfurion_4		= modifier_special_bonus_imba_malfurion_4 or class({})
modifier_special_bonus_imba_malfurion_3		= modifier_special_bonus_imba_malfurion_3 or class({})

function modifier_special_bonus_imba_malfurion_1:IsHidden() 		return true end
function modifier_special_bonus_imba_malfurion_1:IsPurgable()		return false end
function modifier_special_bonus_imba_malfurion_1:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_malfurion_2:IsHidden() 		return true end
function modifier_special_bonus_imba_malfurion_2:IsPurgable()		return false end
function modifier_special_bonus_imba_malfurion_2:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_malfurion_5:IsHidden() 		return true end
function modifier_special_bonus_imba_malfurion_5:IsPurgable()		return false end
function modifier_special_bonus_imba_malfurion_5:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_malfurion_4:IsHidden() 		return true end
function modifier_special_bonus_imba_malfurion_4:IsPurgable()		return false end
function modifier_special_bonus_imba_malfurion_4:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_malfurion_3:IsHidden() 		return true end
function modifier_special_bonus_imba_malfurion_3:IsPurgable()		return false end
function modifier_special_bonus_imba_malfurion_3:RemoveOnDeath() 	return false end
