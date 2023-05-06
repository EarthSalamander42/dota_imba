-- Creator:
--	   AltiV, May 11th, 2019

LinkLuaModifier("modifier_imba_life_stealer_rage", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_rage_insanity", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_rage_insanity_active", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_rage_insanity_target", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_life_stealer_feast", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_feast_engorge", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_feast_engorge_counter", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_feast_banquet", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_life_stealer_open_wounds", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_open_wounds_cross_contamination", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_life_stealer_infest", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_infest_effect", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_life_stealer_control", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_life_stealer_assimilate_handler", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_assimilate", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_assimilate_effect", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_assimilate_counter", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_generic_motion_controller", "components/modifiers/generic/modifier_generic_motion_controller", LUA_MODIFIER_MOTION_BOTH)

imba_life_stealer_rage										= class({})
modifier_imba_life_stealer_rage								= class({})
modifier_imba_life_stealer_rage_insanity					= class({})
modifier_imba_life_stealer_rage_insanity_active				= class({})
modifier_imba_life_stealer_rage_insanity_target				= class({})

imba_life_stealer_rage_723									= imba_life_stealer_rage

imba_life_stealer_feast										= class({})
modifier_imba_life_stealer_feast							= class({})
modifier_imba_life_stealer_feast_engorge					= class({})
modifier_imba_life_stealer_feast_engorge_counter			= class({})
modifier_imba_life_stealer_feast_banquet					= class({})

imba_life_stealer_feast_723									= imba_life_stealer_feast

imba_life_stealer_open_wounds								= class({})
modifier_imba_life_stealer_open_wounds						= class({})
modifier_imba_life_stealer_open_wounds_cross_contamination	= class({})

imba_life_stealer_open_wounds_723							= imba_life_stealer_open_wounds

imba_life_stealer_infest 									= class({})
modifier_imba_life_stealer_infest 							= class({})
modifier_imba_life_stealer_infest_effect					= class({})

imba_life_stealer_infest_723								= imba_life_stealer_infest

imba_life_stealer_control 									= class({})
modifier_imba_life_stealer_control	 						= class({})

imba_life_stealer_consume 									= class({})

imba_life_stealer_assimilate 								= class({})
modifier_imba_life_stealer_assimilate_handler				= class({})
modifier_imba_life_stealer_assimilate 						= class({})
modifier_imba_life_stealer_assimilate_effect				= class({})
modifier_imba_life_stealer_assimilate_counter				= class({})

imba_life_stealer_assimilate_eject 							= class({})

----------
-- RAGE --
----------

function imba_life_stealer_rage:OnSpellStart()
	self:GetCaster():EmitSound("Hero_LifeStealer.Rage")
	
	self:GetCaster():StartGesture(ACT_DOTA_LIFESTEALER_RAGE)
	
	-- "Applies spell immunity for the duration and a basic dispel upon cast."
	self:GetCaster():Purge(false, true, false, false, false)
	
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_rage", {duration = self:GetTalentSpecialValueFor("duration")})
end

-------------------
-- RAGE MODIFIER --
-------------------

function modifier_imba_life_stealer_rage:GetStatusEffectName()
	return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end

function modifier_imba_life_stealer_rage:OnCreated()
	self.attack_speed_bonus		= self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	self.movement_speed_bonus	= self:GetAbility():GetSpecialValueFor("movement_speed_bonus")
	
	self.insanity_attack_stacks		= self:GetAbility():GetSpecialValueFor("insanity_attack_stacks")
	self.insanity_other_stacks		= self:GetAbility():GetSpecialValueFor("insanity_other_stacks")
	self.insanity_stack_duration	= self:GetAbility():GetSpecialValueFor("insanity_stack_duration")
	self.insanity_stack_activation	= self:GetAbility():GetSpecialValueFor("insanity_stack_activation")
	self.insanity_active_range		= self:GetAbility():GetSpecialValueFor("insanity_active_range")
	self.insanity_active_duration	= self:GetAbility():GetSpecialValueFor("insanity_active_duration")
	
	if not IsServer() then return end
	
	local rage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(rage_particle, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	self:AddParticle(rage_particle, false, false, -1, true, false)
end

function modifier_imba_life_stealer_rage:OnRefresh()
	self:OnCreated()
end

function modifier_imba_life_stealer_rage:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end

function modifier_imba_life_stealer_rage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		
		-- IMBAfication: Insanity
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_imba_life_stealer_rage:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_bonus
end

function modifier_imba_life_stealer_rage:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_speed_bonus
end

function modifier_imba_life_stealer_rage:OnTakeDamage(keys)
	if keys.attacker == self:GetParent() then
		if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
			keys.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_life_stealer_rage_insanity", 
			{
				duration			= self.insanity_stack_duration,
				stacks				= self.insanity_attack_stacks,
				other_stacks		= self.insanity_other_stacks,
				stack_activation	= self.insanity_stack_activation,
				active_range		= self.insanity_active_range,
				active_duration		= self.insanity_active_duration
			})
		-- elseif keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
			-- keys.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_life_stealer_rage_insanity", {duration = self.insanity_stack_duration, stacks = 1})
		end
	end
end

----------------------------
-- RAGE INSANITY MODIFIER --
----------------------------

function modifier_imba_life_stealer_rage_insanity:IsPurgable()	return false end

function modifier_imba_life_stealer_rage_insanity:OnCreated(params)
	if self:GetAbility() then
		self.stack_activation	= self:GetAbility():GetSpecialValueFor("insanity_stack_activation")
	end
	
	if not IsServer() then return end
	
	self.other_stacks		= params.other_stacks
	self.stack_activation	= params.stack_activation
	self.active_range		= params.active_range
	self.active_duration	= params.active_duration
	
	if params.stacks then
		self:SetStackCount(self:GetStackCount() + params.stacks)
	end
end

function modifier_imba_life_stealer_rage_insanity:OnRefresh(params)
	if not IsServer() then return end
	
	self:OnCreated(params)
end

function modifier_imba_life_stealer_rage_insanity:OnStackCountChanged(stackCount)
	if not IsServer() then return end

	if self:GetStackCount() >= self.stack_activation then	
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.active_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		
		-- If there is a caster enemy in range, make the insanity target go to attack them
		  -- The reason I say "caster enemy" and not "target ally" is cause you can go Insanity on neutrals, just not caster allies
		if #enemies >= 2 then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_life_stealer_rage_insanity_active",
			{
				duration		= self.active_duration * (1 - self:GetParent():GetStatusResistance()),
				active_range	= self.active_range,
				target_entindex	= enemies[2]:entindex()
			})
			
			enemies[2]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_life_stealer_rage_insanity_target", {duration = self.active_duration * (1 - self:GetParent():GetStatusResistance())})
		-- Otherwise, just give them the modifier and periodically search for allies
		else
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_life_stealer_rage_insanity_active",
				{
					duration		= self.active_duration * (1 - self:GetParent():GetStatusResistance()),
					active_range	= self.active_range
				})
		end
		
		self:Destroy()
	end
end

function modifier_imba_life_stealer_rage_insanity:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		
		MODIFIER_PROPERTY_TOOLTIP
	}
	
	return decFuncs
end

function modifier_imba_life_stealer_rage_insanity:OnTakeDamage(keys)
	if keys.unit == self:GetParent() and not keys.attacker:FindModifierByNameAndCaster("modifier_imba_life_stealer_rage", self:GetCaster()) then
		self:SetStackCount(self:GetStackCount() + 1)
	end
end

function modifier_imba_life_stealer_rage_insanity:OnTooltip()
	return self.stack_activation
end

-----------------------------------
-- RAGE INSANITY ACTIVE MODIFIER --
-----------------------------------

function modifier_imba_life_stealer_rage_insanity_active:IsPurgable()	return false end

function modifier_imba_life_stealer_rage_insanity_active:OnCreated(params)
	if not IsServer() then return end

	self.active_range	= params.active_range

	if params.target_entindex then
		self.target = EntIndexToHScript(params.target_entindex)
		self:GetParent():MoveToTargetToAttack(self.target)
		self:GetParent():SetForceAttackTargetAlly(self.target)
	end
		
	self:StartIntervalThink(0.5)
end

function modifier_imba_life_stealer_rage_insanity_active:OnRefresh(params)
	if not IsServer() then return end

	sekf:OnCreated(params)
end

function modifier_imba_life_stealer_rage_insanity_active:OnIntervalThink()
	if not IsServer() then return end
	
	if not self.target or not self.target:IsAlive() then
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.active_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		
		if #enemies >= 2 then
			local insanity_target_modifier = enemies[2]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_life_stealer_rage_insanity_target", {duration = self:GetRemainingTime()})
			
			self.target = enemies[2]
			self:GetParent():MoveToTargetToAttack(self.target)
			self:GetParent():SetForceAttackTargetAlly(self.target)
		else
			self:GetParent():SetForceAttackTargetAlly(nil)
			self.target = nil
		end
	end
end

function modifier_imba_life_stealer_rage_insanity_active:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():SetForceAttackTargetAlly(nil)
end

-----------------------------------
-- RAGE INSANITY TARGET MODIFIER --
-----------------------------------

-- Duration of this modifier synchs up with the insanity active modifier so it the status resistance will be handled in other functions
function modifier_imba_life_stealer_rage_insanity_target:IgnoreTenacity()	return true end
function modifier_imba_life_stealer_rage_insanity_target:IsPurgable()		return false end

function modifier_imba_life_stealer_rage_insanity_target:CheckState()
	local state = {[MODIFIER_STATE_SPECIALLY_DENIABLE] = true}
	
	return state
end

function modifier_imba_life_stealer_rage_insanity_target:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT
    }

    return decFuncs
end

function modifier_imba_life_stealer_rage_insanity_target:OnTakeDamageKillCredit(keys)
	if keys.target == self:GetParent() and self:GetParent():GetHealth() <= keys.damage then
		-- Credit kill to Lifestealer if the target is killed by an ally (PRESUMABLY due to Insanity but there can be exceptions)
		if keys.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then
			self:GetParent():Kill(self:GetAbility(), self:GetCaster())
		else
			self:GetParent():Kill(self:GetAbility(), keys.attacker)
		end
	end
end

-----------
-- FEAST --
-----------

function imba_life_stealer_feast:GetIntrinsicModifierName()
	return "modifier_imba_life_stealer_feast"
end

function imba_life_stealer_feast:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_POINT
end

function imba_life_stealer_feast:GetCastRange(location, target)
	return self:GetSpecialValueFor("banquet_cast_range")
end

function imba_life_stealer_feast:GetCooldown(level)
	return self:GetSpecialValueFor("banquet_cooldown")
end

-- IMBAfication: Banquet
function imba_life_stealer_feast:OnSpellStart()
	self:GetCaster():StartGesture(ACT_DOTA_LIFESTEALER_RAGE)

	local banquet = CreateUnitByName("npc_dota_life_stealer_banquet", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())

	if banquet then
		local banquet_modifier = banquet:AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_feast_banquet", {})
		banquet:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = self:GetSpecialValueFor("engorge_duration")})
		FindClearSpaceForUnit(banquet, banquet:GetAbsOrigin(), false)
	end
end

--------------------
-- FEAST MODIFIER --
--------------------

function modifier_imba_life_stealer_feast:IsHidden()	return true end

function modifier_imba_life_stealer_feast:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, -- 7.23 version
		
		--IMBAfication: Engorge
		MODIFIER_PROPERTY_HEALTH_BONUS
	}
end

function modifier_imba_life_stealer_feast:GetModifierProcAttack_BonusDamage_Physical(keys)
	-- "Cannot damage and lifesteal off of wards, buildings, Roshan and allied units."
	if keys.target and not keys.target:IsOther() and not keys.target:IsBuilding() and not keys.target:IsRoshan() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		local heal_amount = keys.target:GetMaxHealth() * self:GetAbility():GetTalentSpecialValueFor("hp_leech_percent") * 0.01
		
		local lifesteal_particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(lifesteal_particle)
		
		-- IMBAfication: Engorge
		if heal_amount > self:GetParent():GetMaxHealth() - self:GetParent():GetHealth() then
			local health_differential = heal_amount - (self:GetParent():GetMaxHealth() - self:GetParent():GetHealth())

			local engorge_modifier = self:GetParent():FindModifierByNameAndCaster("modifier_imba_life_stealer_feast_engorge", keys.target)
			
			if not engorge_modifier then
				-- Making the target the caster here so we can easily allow only one engorge modifier per unit as seen with the "FindModifierByNameAndCaster" above
				self:GetParent():AddNewModifier(keys.target, self:GetAbility(), "modifier_imba_life_stealer_feast_engorge", 
				{
					duration	= self:GetAbility():GetSpecialValueFor("engorge_duration"),
					stacks		= health_differential * self:GetAbility():GetSpecialValueFor("engorge_pct") * 0.01
				})
				
				self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_life_stealer_feast_engorge_counter", 
				{
					duration	= self:GetAbility():GetSpecialValueFor("engorge_duration"),
					stacks		= health_differential * self:GetAbility():GetSpecialValueFor("engorge_pct") * 0.01
				})
				
				self:GetParent():CalculateStatBonus(true)
			end
		end
		
		self:GetParent():Heal(heal_amount, self:GetCaster())
		
		if self:GetAbility() and self:GetAbility():GetName() == "imba_life_stealer_feast" then
			return heal_amount
		end
	end
end

function modifier_imba_life_stealer_feast:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
end

function modifier_imba_life_stealer_feast:GetModifierHealthBonus()
	return self:GetParent():GetModifierStackCount("modifier_imba_life_stealer_feast_engorge_counter", self:GetCaster())
end

----------------------------
-- FEAST ENGORGE MODIFIER --
----------------------------

-- self:GetParent(): Lifestealer
-- self:GetCaster(): The unit that Lifestealer attacked

-- ...or Morphling instead of Lifestealer if he morphed, or any unit if they got the Feast ability, but you get what I mean

function modifier_imba_life_stealer_feast_engorge:IsDebuff()			return false end
function modifier_imba_life_stealer_feast_engorge:IsHidden()			return true end
function modifier_imba_life_stealer_feast_engorge:GetAttributes()		return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_life_stealer_feast_engorge:OnCreated(params)
	if not IsServer() then return end

	self:SetStackCount(params.stacks)
end

function modifier_imba_life_stealer_feast_engorge:OnDestroy()
	if not IsServer() then return end
	
	local engorge_counter_modifier = self:GetParent():FindModifierByNameAndCaster("modifier_imba_life_stealer_feast_engorge_counter", self:GetCaster())
	
	if engorge_counter_modifier then
		engorge_counter_modifier:SetStackCount(engorge_counter_modifier:GetStackCount() - self:GetStackCount())
	end
end

------------------------------------
-- FEAST ENGORGE COUNTER MODIFIER --
------------------------------------

function modifier_imba_life_stealer_feast_engorge_counter:OnCreated(params)
	if not IsServer() then return end
	
	self:SetStackCount(self:GetStackCount() + params.stacks)
end

function modifier_imba_life_stealer_feast_engorge_counter:OnRefresh(params)
	if not IsServer() then return end
	
	self:OnCreated(params)
end

----------------------------
-- FEAST BANQUET MODIFIER --
----------------------------

function modifier_imba_life_stealer_feast_banquet:IsPurgable()	return false end

function modifier_imba_life_stealer_feast_banquet:OnCreated()
	self.destroy_attacks		= self:GetAbility():GetSpecialValueFor("destroy_attacks")
	self.hero_attack_multiplier	= self:GetAbility():GetSpecialValueFor("hero_attack_multiplier")
	
	if not IsServer() then return end

	-- Feed Engorge stacks into the meal's health
	local engorge_counter_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_life_stealer_feast_engorge_counter", self:GetCaster())
	
	if engorge_counter_modifier then
		self:SetStackCount(engorge_counter_modifier:GetStackCount())
		
		for _, engorge_modifier in pairs(self:GetCaster():FindAllModifiersByName("modifier_imba_life_stealer_feast_engorge")) do
			engorge_modifier:Destroy()
		end
		
		engorge_counter_modifier:Destroy()
	end
	
	self:GetParent():SetBaseMaxHealth(self:GetParent():GetMaxHealth() + self:GetStackCount())
	self:GetParent():SetMaxHealth(self:GetParent():GetMaxHealth() + self:GetStackCount())
	self:GetParent():SetHealth(self:GetParent():GetHealth() + self:GetStackCount())

	-- Calculate health chunks that the unit will lose on getting attacked
	self.health_increments		= self:GetParent():GetMaxHealth() / self.destroy_attacks
end

function modifier_imba_life_stealer_feast_banquet:CheckState()
	local state = {[MODIFIER_STATE_SPECIALLY_DENIABLE] = true}
	
	return state
end

function modifier_imba_life_stealer_feast_banquet:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		
		MODIFIER_EVENT_ON_ATTACKED
    }

    return decFuncs
end

function modifier_imba_life_stealer_feast_banquet:GetAbsoluteNoDamageMagical()
    return 1
end

function modifier_imba_life_stealer_feast_banquet:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_imba_life_stealer_feast_banquet:GetAbsoluteNoDamagePure()
    return 1
end

function modifier_imba_life_stealer_feast_banquet:OnAttacked(keys)
    if not IsServer() then return end
	
	if keys.target == self:GetParent() then
		
		local damage_amount = math.min(self.health_increments, self:GetParent():GetHealth())
		
		if keys.attacker:IsHero() then
			damage_amount = math.min(self.health_increments * self.hero_attack_multiplier, self:GetParent():GetHealth())
		end
		
		self:GetParent():SetHealth(self:GetParent():GetHealth() - damage_amount)

		if keys.attacker:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			keys.attacker:Heal(damage_amount, self:GetAbility())
			
			local lifesteal_particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:ReleaseParticleIndex(lifesteal_particle)
			
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.attacker, damage_amount, nil)
		end
		
		if self:GetParent():GetHealthPercent() > 75 then
			self:GetParent():SetModel("models/props_gameplay/cheese_04.vmdl")
		elseif self:GetParent():GetHealthPercent() > 50 then
			self:GetParent():SetModel("models/props_gameplay/cheese_03.vmdl")
		elseif self:GetParent():GetHealthPercent() > 25 then
			self:GetParent():SetModel("models/props_gameplay/cheese_02.vmdl")
		else
			self:GetParent():SetModel("models/props_gameplay/cheese_01.vmdl")
		end	
		
		if self:GetParent():GetHealth() <= 0 then
			local infest_effect_modifier = self:GetParent():FindModifierByNameAndCaster("modifier_imba_life_stealer_infest_effect", self:GetCaster())
			
			if infest_effect_modifier then
				infest_effect_modifier:Destroy()
			end
		
			self:GetParent():Kill(nil, keys.attacker)
			self:GetParent():RemoveSelf()
			self:Destroy()
		end
	end
end

-----------------
-- OPEN WOUNDS --
-----------------

function imba_life_stealer_open_wounds:OnSpellStart()
	if not IsServer() then return end

	local target = self:GetCursorTarget()

	if target:TriggerSpellAbsorb(self) then return nil end

	self:GetCaster():EmitSound("Hero_LifeStealer.OpenWounds.Cast", self:GetCaster())

	target:EmitSound("Hero_LifeStealer.OpenWounds", self:GetCaster())

	if self:GetCaster():GetName() == "npc_dota_hero_life_stealer" and RollPercentage(75) then
		if not self.responses then
			self.responses = 
			{
				["life_stealer_lifest_ability_openwound_01"] = 0,
				["life_stealer_lifest_ability_openwound_02"] = 0,
				["life_stealer_lifest_ability_openwound_03"] = 0,
				["life_stealer_lifest_ability_openwound_04"] = 0,
				["life_stealer_lifest_ability_openwound_05"] = 0,
				["life_stealer_lifest_ability_openwound_06"] = 0
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

	local impact_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_open_wounds_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(impact_particle)

	target:AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_open_wounds", {duration = self:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance())})

	-- IMBAfication: Cross-Contamination
	target:AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_open_wounds_cross_contamination", {duration = self:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance())})
end

--------------------------
-- OPEN WOUNDS MODIFIER --
--------------------------

function modifier_imba_life_stealer_open_wounds:GetStatusEffectName()
	return "particles/status_fx/status_effect_life_stealer_open_wounds.vpcf"
end

function modifier_imba_life_stealer_open_wounds:OnCreated()
	self.heal_percent	= self:GetAbility():GetTalentSpecialValueFor("heal_percent")

	if not IsServer() then return end

	local impact_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_open_wounds.vpcf", PATTACH_ABSORIGIN_FOLLOW, target, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(impact_particle)

	self.slow_steps = {}

	-- GetLevelSpecialValueFor is a server only function so I'm using stack counts to show on client (which means I'm using another modifier for the Cross-Contamination IMBAfication)
	for step = 0, self:GetAbility():GetSpecialValueFor("duration") - 1 do
		table.insert(self.slow_steps, self:GetAbility():GetLevelSpecialValueFor("slow_steps", step))
	end

	self:SetStackCount(self.slow_steps[math.floor(self:GetElapsedTime()) + 1])

	self:StartIntervalThink(0.1)
end

function modifier_imba_life_stealer_open_wounds:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount(self.slow_steps[math.floor(self:GetElapsedTime()) + 1] or 0)
end

function modifier_imba_life_stealer_open_wounds:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_LifeStealer.OpenWounds")
end

function modifier_imba_life_stealer_open_wounds:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
	
	return decFuncs
end

function modifier_imba_life_stealer_open_wounds:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

function modifier_imba_life_stealer_open_wounds:OnTakeDamage(keys)
	if not IsServer() then return end

	if self:GetParent() == keys.unit and keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.attacker:IsBuilding() and not keys.attacker:IsOther() then
		local heal_amount = keys.damage * self.heal_percent * 0.01
	
		keys.attacker:Heal(heal_amount, self:GetAbility())
		
		local lifesteal_particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
		ParticleManager:ReleaseParticleIndex(lifesteal_particle)
		
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.attacker, heal_amount, nil)
		
		-- IMBAfication: Cross-Contamination
		local cross_contamination_modifier = keys.unit:FindModifierByNameAndCaster("modifier_imba_life_stealer_open_wounds_cross_contamination", self:GetCaster())
		
		if cross_contamination_modifier and cross_contamination_modifier.attacking_units and not cross_contamination_modifier.attacking_units[keys.attacker] then
			cross_contamination_modifier.attacking_units[keys.attacker]	= true
			cross_contamination_modifier:IncrementStackCount()
		end
	end
end

----------------------------------------------
-- OPEN WOUNDS CROSS-CONTAMINATION MODIFIER --
----------------------------------------------

function modifier_imba_life_stealer_open_wounds_cross_contamination:OnCreated()
	self.cross_contamination_pct	= self:GetAbility():GetSpecialValueFor("cross_contamination_pct")
	self.attacking_units	= {}
end

function modifier_imba_life_stealer_open_wounds_cross_contamination:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_imba_life_stealer_open_wounds_cross_contamination:GetModifierIncomingDamage_Percentage()
	return self:GetStackCount() * self.cross_contamination_pct
end

------------
-- INFEST --
------------

function imba_life_stealer_infest:GetAssociatedSecondaryAbilities()
	return "imba_life_stealer_consume"
end

function imba_life_stealer_infest:GetAbilityTargetTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function imba_life_stealer_infest:CastFilterResultTarget(target)
	if not IsServer() then return end

	if target == self:GetCaster() or target:GetClassname() == "npc_dota_rattletrap_cog" then
		return UF_FAIL_OTHER
	else
		return UF_SUCCESS
	end
	
	-- This line shouldn't be reached based on the if-else success statement above but will just leave this here
	return UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
end

function imba_life_stealer_infest:OnUpgrade()
	local consume_ability = self:GetCaster():FindAbilityByName("imba_life_stealer_consume")
	
	if consume_ability and consume_ability:GetLevel() ~= self:GetLevel() then
		consume_ability:SetLevel(self:GetLevel())
	end
end

-- Why does this block even need to be a thing
-- Infest can go into dead enemies without this and then the whole thing explodes
function imba_life_stealer_infest:OnAbilityPhaseStart()
	local target = self:GetCursorTarget()
	
	if not target:IsAlive() or target:IsInvulnerable() or target:IsOutOfGame() then
		return false
	else
		return true
	end
end

function imba_life_stealer_infest:GetCastRange(location, target)
	if not self:GetCaster():HasScepter() or self:GetName() ~= "imba_life_stealer_infest_723" then
		return self.BaseClass.GetCastRange(self, location, target)
	else
		return self:GetSpecialValueFor("cast_range_scepter")
	end
end

function imba_life_stealer_infest:GetCooldown(level)
	if not self:GetCaster():HasScepter() or self:GetName() ~= "imba_life_stealer_infest_723" then
		return self.BaseClass.GetCooldown(self, level)
	else
		return self:GetSpecialValueFor("cooldown_scepter")
	end
end

function imba_life_stealer_infest:OnSpellStart()
	local target = self:GetCursorTarget()

	-- Some really messy stuff happening if this line isn't in...
	if not target:IsAlive() or target:IsInvulnerable() or target:IsOutOfGame() then 
		self:RefundManaCost()
		self:EndCooldown()
		return
	end

	self:GetCaster():EmitSound("Hero_LifeStealer.Infest")

	if self:GetCaster():GetName() == "npc_dota_hero_life_stealer" and RollPercentage(75) then
		if not self.responses then
			self.responses = {
				["life_stealer_lifest_ability_infest_cast_01"] = 0,
				["life_stealer_lifest_ability_infest_cast_02"] = 0,
				["life_stealer_lifest_ability_infest_cast_03"] = 0,
				["life_stealer_lifest_ability_infest_cast_04"] = 0,
				["life_stealer_lifest_ability_infest_cast_05"] = 0,
				["life_stealer_lifest_ability_infest_cast_06"] = 0,
				["life_stealer_lifest_ability_infest_cast_07"] = 0,
				["life_stealer_lifest_ability_infest_cast_08"] = 0,
				["life_stealer_lifest_ability_infest_burst_02"] = 0,
				["life_stealer_lifest_ability_infest_burst_03"] = 0,
				["life_stealer_lifest_ability_infest_hero_02"] = 0,
				["life_stealer_lifest_ability_infest_hero_03"] = 0,
				["life_stealer_lifest_ability_infest_hero_04"] = 0,	
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
	
	local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_POINT, target)
	ParticleManager:SetParticleControl(infest_particle, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(infest_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(infest_particle)
	
	-- "Applies a basic dispel on Lifestealer and disjoints projectiles upon cast."
	--   "This basic dispel removes buffs as well, and not only debuffs."
	self:GetCaster():Purge(true, true, false, false, false)
	ProjectileManager:ProjectileDodge(self:GetCaster())

	local infest_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_infest", 
	{
		target_ent		= target:entindex(),
	})
	
	local infest_effect_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_infest_effect", {})
	
	if infest_modifier and infest_effect_modifier then
		infest_modifier.infest_effect_modifier	= infest_effect_modifier
		infest_effect_modifier.infest_modifier	= infest_modifier
	end
	
	if self:GetName() == "imba_life_stealer_infest_723" and (not target:IsHero() or (target:IsHero() and target:GetTeamNumber() == self:GetCaster():GetTeamNumber())) and not target:IsBuilding() and not target:IsOther() and not target:IsRoshan() then
		target:Heal(self:GetSpecialValueFor("bonus_health"), self:GetCaster())
		
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetCaster(), self:GetSpecialValueFor("bonus_health"), nil)
	end
	
	-- Don't throw selection to the target if it's an enemy hero
	if self:GetCaster():GetTeamNumber() == target:GetTeamNumber() and target:IsConsideredHero() then
		PlayerResource:NewSelection(self:GetCaster():GetPlayerID(), target)
	end
	
	-- Hide Rage and Feast abilities
	local rage_ability	= self:GetCaster():FindAbilityByName("imba_life_stealer_rage") or self:GetCaster():FindAbilityByName("imba_life_stealer_rage_723")
		
	local feast_ability	= self:GetCaster():FindAbilityByName("imba_life_stealer_feast") or self:GetCaster():FindAbilityByName("imba_life_stealer_feast_723")

	if rage_ability then
		rage_ability:SetHidden(true)
	end
	
	if feast_ability then
		feast_ability:SetHidden(true)
	end
	
	-- Also need to hide Assimilate and Eject now
	local assimilate_ability	= self:GetCaster():FindAbilityByName("imba_life_stealer_assimilate")
		
	local eject_ability			= self:GetCaster():FindAbilityByName("imba_life_stealer_assimilate_eject")

	if assimilate_ability then
		assimilate_ability:SetHidden(true)
	end
	
	if eject_ability then
		eject_ability:SetHidden(true)
	end	
	
	local control_ability	= self:GetCaster():FindAbilityByName("imba_life_stealer_control")
	-- This is usually Open Wounds, but perhaps there will be cases where the ult is given to some other unit, and/or they won't have Open Wounds?...
	local ability_to_swap	= self:GetCaster():GetAbilityByIndex(2)
	
	if control_ability and ability_to_swap then
		if not control_ability:IsTrained() then
			control_ability:SetLevel(1)
		end
		
		-- "Cannot take control over heroes, creep-heroes and units already owned by Lifestealer. All other infestable units can be controlled."
		if target:IsCreep() and not target:IsConsideredHero() and (not target:GetOwner() or target:GetOwner() ~= self:GetCaster()) and not target:IsRoshan() then
			control_ability:SetActivated(true)
		else
			control_ability:SetActivated(false)
		end
		
		self:GetCaster():SwapAbilities(ability_to_swap:GetName(), control_ability:GetName(), false, true)
		
		if infest_modifier then
			infest_modifier.ability_to_swap = ability_to_swap
		end
		
		if control_ability:IsActivated() and self:GetName() == "imba_life_stealer_infest_723" then
			control_ability:OnSpellStart()
		end
	end	
	
	local consume_ability = self:GetCaster():FindAbilityByName("imba_life_stealer_consume")
	
	if consume_ability then		
		self:GetCaster():SwapAbilities(self:GetName(), consume_ability:GetName(), false, true)
	end

	if self:GetCaster():HasAbility("imba_life_stealer_rage_723") and self:GetCaster():HasScepter() and self:GetName() == "imba_life_stealer_infest_723" and (not target:IsHero() or (target:IsHero() and target:GetTeamNumber() == self:GetCaster():GetTeamNumber())) and not target:IsBuilding() and not target:IsOther() and not target:IsRoshan() then
		local rage_ability = self:GetCaster():FindAbilityByName("imba_life_stealer_rage_723")
		
		target:EmitSound("Hero_LifeStealer.Rage")
		
		-- "Applies spell immunity for the duration and a basic dispel upon cast."
		target:Purge(false, true, false, false, false)
		
		target:AddNewModifier(self:GetCaster(), rage_ability, "modifier_imba_life_stealer_rage", {duration = rage_ability:GetTalentSpecialValueFor("duration")})
	end
end

---------------------
-- INFEST MODIFIER --
---------------------

function modifier_imba_life_stealer_infest:IsPurgable()	return false end

function modifier_imba_life_stealer_infest:OnCreated(params)
	self.radius	= self:GetAbility():GetSpecialValueFor("radius")
	self.damage	= self:GetAbility():GetSpecialValueFor("damage")
	self.self_regen	= self:GetAbility():GetSpecialValueFor("self_regen")
	
	if not IsServer() then return end
	
	self.ability_damage_type	= self:GetAbility():GetAbilityDamageType()
	
	self.target_ent	= EntIndexToHScript(params.target_ent)
	self:GetParent():AddNoDraw()

	-- -- These don't even work
	--Wearable:HideWearables(self:GetParent())
	--Wearable:RemoveWearables(self:GetParent())
	
	self:StartIntervalThink(0.1)
end

function modifier_imba_life_stealer_infest:OnIntervalThink()
	if not IsServer() then return end
	
	self:GetParent():SetAbsOrigin(self.target_ent:GetAbsOrigin())
end

function modifier_imba_life_stealer_infest:OnDestroy()
	if not IsServer() then return end
	
	if not self.null_destroy then
		PlayerResource:NewSelection(self:GetCaster():GetPlayerID(), self:GetCaster())

		self:GetParent():EmitSound("Hero_LifeStealer.Consume")
		
		local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster(), self:GetCaster())
		ParticleManager:ReleaseParticleIndex(infest_particle)
		
		self:GetParent():StartGesture(ACT_DOTA_LIFESTEALER_INFEST_END)
		
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.target_ent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
		for _, enemy in pairs(enemies) do
			local damageTable = {
				victim 			= enemy,
				damage 			= self.damage,
				damage_type		= self.ability_damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			}

			ApplyDamage(damageTable)
		end
		
		FindClearSpaceForUnit(self:GetParent(), self.target_ent:GetAbsOrigin(), false)
	end
	
	self:GetParent():RemoveNoDraw()
	-- Wearable:ShowWearables(self:GetParent())
	
	if self.infest_effect_modifier then
		self.infest_effect_modifier:Destroy()
	end

	-- Unhide Rage and Feast abilities
	local rage_ability	= self:GetCaster():FindAbilityByName("imba_life_stealer_rage") or self:GetCaster():FindAbilityByName("imba_life_stealer_rage_723")
		
	local feast_ability	= self:GetCaster():FindAbilityByName("imba_life_stealer_feast") or self:GetCaster():FindAbilityByName("imba_life_stealer_feast_723")

	if rage_ability then
		rage_ability:SetHidden(false)
	end
	
	if feast_ability then
		feast_ability:SetHidden(false)
	end

	if self:GetCaster():HasScepter() and self:GetCaster():HasAbility("imba_life_stealer_infest") then
		-- Also need to unhide Assimilate and Eject now
		local assimilate_ability	= self:GetCaster():FindAbilityByName("imba_life_stealer_assimilate")
			
		local eject_ability			= self:GetCaster():FindAbilityByName("imba_life_stealer_assimilate_eject")

		if assimilate_ability then
			assimilate_ability:SetHidden(false)
		end
		
		if eject_ability then
			eject_ability:SetHidden(false)
		end
	end

	-- Swap out Control ability back for Open Wounds/whatever the 3rd ability slot was
	local control_ability	= self:GetCaster():FindAbilityByName("imba_life_stealer_control")
	
	if control_ability and self.ability_to_swap then
		self:GetCaster():SwapAbilities(self.ability_to_swap:GetName(), control_ability:GetName(), true, false)
		control_ability:SetActivated(false)
	end
	
	-- Swap out Consume ability back for Infest
	local consume_ability = self:GetCaster():FindAbilityByName("imba_life_stealer_consume")
		
	if consume_ability and self:GetAbility() then
		self:GetCaster():SwapAbilities(self:GetAbility():GetName(), consume_ability:GetName(), true, false)
	end
	
	if self:GetAbility():GetName() == "imba_life_stealer_infest_723" then
		self:GetAbility():UseResources(false, false, false, true) 
	end
end

function modifier_imba_life_stealer_infest:CheckState(keys)
	if not IsServer() then return end

	-- Defaults
	local state = {
		[MODIFIER_STATE_INVULNERABLE] 						= true,
		[MODIFIER_STATE_OUT_OF_GAME]						= true,
		[MODIFIER_STATE_DISARMED]							= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]					= true,
		[MODIFIER_STATE_UNSELECTABLE]						= true
	}
	
	-- Need some slight exceptions due to the Chestburster IMBAfication
	if not self.infest_effect_modifier or self.infest_effect_modifier:GetParent():GetTeamNumber() == self:GetParent():GetTeamNumber() or not self.infest_effect_modifier:GetParent():IsHero() then
		state[MODIFIER_STATE_COMMAND_RESTRICTED]			= true
	else
		state[MODIFIER_STATE_MUTED]							= true
		state[MODIFIER_STATE_ROOTED]						= true
	end
	
	return state
end

function modifier_imba_life_stealer_infest:DeclareFunctions()
	return {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE}
end

function modifier_imba_life_stealer_infest:GetModifierHealthRegenPercentage()
	return self.self_regen
end

----------------------------
-- INFEST EFFECT MODIFIER --
----------------------------

-- This handles the overhead particle that shows above the host's head

-- IMBAfication: Chestburster
  -- Gonna use this modifier to handle the IMBAfication as well, just kind of with separate blocks
function modifier_imba_life_stealer_infest_effect:IsHidden()		return self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() or not self:GetParent():IsHero() end
function modifier_imba_life_stealer_infest_effect:IsPurgable()		return false end

-- If you have multiple people infesting a target somehow, let the particles stack horizontally on top
function modifier_imba_life_stealer_infest_effect:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_life_stealer_infest_effect:ShouldUseOverheadOffset() return true end

function modifier_imba_life_stealer_infest_effect:OnCreated()
	self.bonus_movement_speed	= self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
	self.bonus_health			= self:GetAbility():GetSpecialValueFor("bonus_health")
	
	-- IMBAfication: Chestburster
	self.chestburster_tick_up_rate				= self:GetAbility():GetSpecialValueFor("chestburster_tick_up_rate")
	self.chestburster_orders_to_tick_up			= self:GetAbility():GetSpecialValueFor("chestburster_orders_to_tick_up")
	self.chestburster_orders_to_tick_down		= self:GetAbility():GetSpecialValueFor("chestburster_orders_to_tick_down")
	self.chestburster_ticks_per_damage			= self:GetAbility():GetSpecialValueFor("chestburster_ticks_per_damage")
	self.chestburster_fail_knockback_distance	= self:GetAbility():GetSpecialValueFor("chestburster_fail_knockback_distance")
	self.chestburster_fail_knockback_height		= self:GetAbility():GetSpecialValueFor("chestburster_fail_knockback_height")
	self.chestburster_fail_knockback_duration	= self:GetAbility():GetSpecialValueFor("chestburster_fail_knockback_duration")
	self.chestburster_fail_stun_duration		= self:GetAbility():GetSpecialValueFor("chestburster_fail_stun_duration")

	self.chestburster_starting_stacks			= self:GetAbility():GetSpecialValueFor("chestburster_starting_stacks")
	self.chestburster_success_stacks			= self:GetAbility():GetSpecialValueFor("chestburster_success_stacks") -- Reaching this = Target dies
	self.chestburster_failure_stacks			= self:GetAbility():GetSpecialValueFor("chestburster_failure_stacks") -- Reaching this = Lifestealer gets forcibly ejected / stunned
	self.chestburster_min_eject_time			= self:GetAbility():GetSpecialValueFor("chestburster_min_eject_time")
	
	self.parent_tick_count						= 0 -- Hit threshold to reduce stacks (towards failure)
	self.caster_tick_count						= 0 -- Hit threshold to increase stacks (towards success)
	--
	
	if not IsServer() then return end
	
	local infest_overhead_particle
	
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and not self:GetParent():IsBuilding() and not self:GetParent():IsOther() then
		infest_overhead_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetParent():GetTeamNumber(), self:GetCaster())
	else
		infest_overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster())
	end
	
	self:AddParticle(infest_overhead_particle, false, false, -1, true, false)
	
	-- IMBAfication: Chestburster
	if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetParent():IsHero() then
		-- Let the death games begin...
		self.consume_ability = self:GetCaster():FindAbilityByName("imba_life_stealer_consume")

		if self.consume_ability then
			self.consume_ability:SetActivated(false)
		end
		
		self:SetStackCount(self.chestburster_starting_stacks)
		
		if self:GetCaster():FindModifierByNameAndCaster("modifier_imba_life_stealer_infest", self:GetCaster()) then
			self:GetCaster():FindModifierByNameAndCaster("modifier_imba_life_stealer_infest", self:GetCaster()):SetStackCount(self:GetStackCount())
		end
		
		self:StartIntervalThink(self.chestburster_tick_up_rate)
	end
end

function modifier_imba_life_stealer_infest_effect:OnIntervalThink()
	if not IsServer() then return end
	
	self:IncrementStackCount()
	
	if self:GetElapsedTime() >= self.chestburster_min_eject_time and self.consume_ability and not self.consume_ability:IsActivated() then
		self.consume_ability:SetActivated(true)
	end
end

function modifier_imba_life_stealer_infest_effect:OnDestroy()
	if not IsServer() then return end
	
	if self.infest_modifier then
		self.infest_modifier:Destroy()
	end
	
	if self.consume_ability and not self.consume_ability:IsActivated() then
		self.consume_ability:SetActivated(true)
	end
end


function modifier_imba_life_stealer_infest_effect:OnStackCountChanged(stackCount)
	if not IsServer() then return end

	if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetParent():IsHero() then
		if self.infest_modifier then
			self.infest_modifier:SetStackCount(self:GetStackCount())
		end

		-- Lifestealer wins.
		if self:GetStackCount() >= self.chestburster_success_stacks then
			self:GetCaster():Heal(self:GetParent():GetHealth(), self:GetCaster())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetCaster(), self:GetParent():GetHealth(), nil)
			
			self:GetParent():Kill(self, self:GetCaster())
			self:Destroy()
		-- The target wins.
		-- Arbitrary 2 second buffer so target doesn't immediately win when the modifier is created due to it starting at 0 stacks
		elseif self:GetStackCount() <= self.chestburster_failure_stacks and self:GetElapsedTime() > 2 then
			local random_vector			= RandomVector(self.chestburster_fail_knockback_distance)
		
			local knockback_modifier	= self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_generic_motion_controller", 
			{
				distance		= self.chestburster_fail_knockback_distance,
				direction_x 	= random_vector.x,
				direction_y 	= random_vector.y,
				direction_z 	= random_vector.z,
				duration 		= self.chestburster_fail_knockback_duration,
				height 			= self.chestburster_fail_knockback_height,
				bGroundStop 	= true,
				bDecelerate 	= false,
				bInterruptible 	= false,
				bIgnoreTenacity	= true
			})
			
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.chestburster_fail_stun_duration * (1 - self:GetCaster():GetStatusResistance())})
			
			self:Destroy()
		end
	end
end

function modifier_imba_life_stealer_infest_effect:CheckState()
	if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and (self:GetParent():IsHero() or self:GetParent():IsBuilding() or self:GetParent():IsOther()) then
		return {[MODIFIER_STATE_SPECIALLY_DENIABLE] = true}
	end
end

function modifier_imba_life_stealer_infest_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ORDER,
		
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP_2,
		
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_imba_life_stealer_infest_effect:GetModifierMoveSpeedBonus_Percentage()
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return self.bonus_movement_speed
	end
end

function modifier_imba_life_stealer_infest_effect:GetModifierExtraHealthBonus(keys)
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and not self:GetParent():IsBuilding() and not self:GetParent():IsOther() then
		return self.bonus_health
	end
end

function modifier_imba_life_stealer_infest_effect:OnAttackLanded(keys)
	if not IsServer() then return end
	
	if keys.target == self:GetParent() and keys.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then
		self:SetStackCount(self:GetStackCount() - self.chestburster_ticks_per_damage)
	end
end

function modifier_imba_life_stealer_infest_effect:OnOrder(keys)
	if not IsServer() then return end
	
	if keys.unit == self:GetParent() then
		self.parent_tick_count	= self.parent_tick_count + 1
		
		if self.parent_tick_count >= self.chestburster_orders_to_tick_down then
			self:DecrementStackCount()
			
			self.parent_tick_count = 0
		end
	elseif keys.unit == self:GetCaster() then
		self.caster_tick_count	= self.caster_tick_count + 1
		
		if self.caster_tick_count >= self.chestburster_orders_to_tick_up then
			self:IncrementStackCount()
			
			self.caster_tick_count = 0
		end
	end
end

function modifier_imba_life_stealer_infest_effect:OnTooltip()
	return self.chestburster_success_stacks
end

-- Seems like they removed this or something...
function modifier_imba_life_stealer_infest_effect:OnTooltip2()
	return self.chestburster_failure_stacks
end

function modifier_imba_life_stealer_infest_effect:GetModifierIncomingDamage_Percentage(keys)
	if self:GetParent():IsBuilding() and keys.attacker:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and keys.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then
		self:Destroy()
		return -100
	end
end

-------------
-- CONTROL --
-------------

function imba_life_stealer_control:IsStealable()	return false end

function imba_life_stealer_control:OnSpellStart()
	local infest_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_life_stealer_infest", self:GetCaster())
	
	if infest_modifier and infest_modifier.infest_effect_modifier and infest_modifier.infest_effect_modifier:GetParent() and not infest_modifier.infest_effect_modifier:GetParent():FindModifierByNameAndCaster("modifier_imba_life_stealer_control", self:GetCaster()) then
		local target = infest_modifier.infest_effect_modifier:GetParent()
		
		-- -- SUPER JANK LANE CREEP SWITCHAROO TO BYPASS LANE AI
		if string.find(target:GetUnitName(), "guys_") then
			-- Super spaghet line to make the explosion on infest modifier destroy not happen
			infest_modifier.null_destroy = true
		
			local lane_creep_name = target:GetUnitName()
			
			local new_lane_creep = CreateUnitByName(target:GetUnitName(), target:GetAbsOrigin(), false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
			-- Copy the relevant stats over to the creep
			new_lane_creep:SetBaseMaxHealth(target:GetMaxHealth())
			new_lane_creep:SetHealth(target:GetHealth())
			new_lane_creep:SetBaseDamageMin(target:GetBaseDamageMin())
			new_lane_creep:SetBaseDamageMax(target:GetBaseDamageMax())
			new_lane_creep:SetMinimumGoldBounty(target:GetGoldBounty())
			new_lane_creep:SetMaximumGoldBounty(target:GetGoldBounty())			
			target:ForceKill(false)
			target:AddNoDraw()
			target = new_lane_creep
			
			self:GetCaster():SetCursorCastTarget(target)
			
			if infest_modifier:GetAbility() then
				infest_modifier:GetAbility():OnSpellStart()
			end
		end
		
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_control", {})
		
		PlayerResource:NewSelection(self:GetCaster():GetPlayerID(), target)
		
		-- Looks like the Consume ability gets pushed to slot 4 by default, so add empty ability slots if necessary
		for slot = 0, 2 do
			if not target:GetAbilityByIndex(slot) then
				local empty_ability = target:AddAbility("life_stealer_empty_"..(slot + 1))
				empty_ability:SetHidden(false)
			end
		end
		
		local consume_ability = target:AddAbility("imba_life_stealer_consume")
		
		if consume_ability then
			if infest_modifier:GetAbility() then
				consume_ability:SetLevel(infest_modifier:GetAbility():GetLevel())
			else
				consume_ability:SetLevel(1)
			end
			consume_ability:SetHidden(false)
			consume_ability:SetActivated(true)
		end
	end
end

----------------------
-- CONTROL MODIFIER --
----------------------

function modifier_imba_life_stealer_control:IsHidden()		return true end
function modifier_imba_life_stealer_control:IsPurgable()	return false end

function modifier_imba_life_stealer_control:OnCreated()
	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		self.fake_ally = true
	end
	
	if not IsServer() then return end
			
	-- "Fully restores the unit's mana upon cast. Its health stays unaffected."
	if self:GetParent().SetMana and self:GetParent().GetMaxMana then
		self:GetParent():SetMana(self:GetParent():GetMaxMana())
	end
	
	-- Transfer ownership over to Lifestealer
	self:GetParent():SetOwner(self:GetCaster())
	self:GetParent():SetTeam(self:GetCaster():GetTeam())
	self:GetParent():SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)
	
	-- ALRIGHT let's hack up acquisition range so things don't keep auto-ing
	self.acquisition_range = self:GetParent():GetAcquisitionRange()
	
	self.acquisition_null_orders	=
	{
		[DOTA_UNIT_ORDER_MOVE_TO_POSITION]	= true,
		[DOTA_UNIT_ORDER_MOVE_TO_TARGET]	= true,
		[DOTA_UNIT_ORDER_HOLD_POSITION]		= true,
		[DOTA_UNIT_ORDER_STOP]				= true,
		[DOTA_UNIT_ORDER_CONTINUE]			= true
	}
	
	self:StartIntervalThink(1)
end

function modifier_imba_life_stealer_control:OnIntervalThink()
	if not IsServer() then return end
end

function modifier_imba_life_stealer_control:CheckState()
	if self.fake_ally then
		return {
			[MODIFIER_STATE_FAKE_ALLY]	= true,
			[MODIFIER_STATE_DOMINATED]	= true -- This doesn't really do anything
		}
	end
end

function modifier_imba_life_stealer_control:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_imba_life_stealer_control:GetModifierMoveSpeed_Absolute()
	if self:GetCaster().HasAbility and self:GetCaster():HasAbility("imba_life_stealer_infest") then
		return self:GetCaster():GetMoveSpeedModifier(self:GetCaster():GetBaseMoveSpeed(), false)
	end
end

function modifier_imba_life_stealer_control:OnOrder(keys)
	if not IsServer() then return end
	
	if keys.unit == self:GetParent() then
		if self.acquisition_null_orders[keys.order_type] then
			self:GetParent():SetAcquisitionRange(0)
		else
			self:GetParent():SetAcquisitionRange(self.acquisition_range)
		end
	end
end

-------------
-- CONSUME --
-------------

function imba_life_stealer_consume:GetAssociatedPrimaryAbilities()
	return "imba_life_stealer_infest"
end

function imba_life_stealer_consume:ProcsMagicStick() return false end

function imba_life_stealer_consume:OnUpgrade()
	local infest_ability = self:GetCaster():FindAbilityByName("imba_life_stealer_infest")
	
	if infest_ability and infest_ability:GetLevel() ~= self:GetLevel() then
		infest_ability:SetLevel(self:GetLevel())
	end
end

function imba_life_stealer_consume:OnSpellStart()
	if self:GetCaster():GetName() == "npc_dota_hero_life_stealer" then
		self:GetCaster():EmitSound("life_stealer_lifest_ability_infest_burst_01")
	end

	local infest_modifier	= self:GetCaster():FindModifierByNameAndCaster("modifier_imba_life_stealer_infest", self:GetCaster())
	local caster			= self:GetCaster()
	
	if not infest_modifier and self:GetCaster():GetOwner() then
		infest_modifier		= self:GetCaster():GetOwner():FindModifierByNameAndCaster("modifier_imba_life_stealer_infest", self:GetCaster():GetOwner())
		caster				= self:GetCaster():GetOwner()
	end
	
	if infest_modifier then
		if infest_modifier.infest_effect_modifier then
			local infest_effect_modifier_parent = infest_modifier.infest_effect_modifier:GetParent()
			
			if infest_effect_modifier_parent and infest_effect_modifier_parent:IsCreep() and not infest_effect_modifier_parent:IsRoshan() and (infest_effect_modifier_parent:GetTeamNumber() ~= caster:GetTeamNumber() or infest_effect_modifier_parent:FindModifierByNameAndCaster("modifier_imba_life_stealer_control", caster) or infest_effect_modifier_parent:FindModifierByNameAndCaster("modifier_imba_life_stealer_control", caster:GetOwner())) then
				
				if infest_modifier:GetAbility():GetName() == "imba_life_stealer_infest" then
					caster:Heal(infest_effect_modifier_parent:GetHealth(), caster)
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, infest_effect_modifier_parent:GetHealth(), nil)
				end
				
				infest_effect_modifier_parent:Kill(self, caster)
	
				if caster:GetName() == "npc_dota_hero_life_stealer" then
					if RollPercentage(5) then
						local rare_responses = {"life_stealer_lifest_ability_infest_burst_06", "life_stealer_lifest_ability_infest_burst_08"}
					
						caster:EmitSound(rare_responses[RandomInt(1, #rare_responses)])
					elseif RollPercentage(15) then
						caster:EmitSound("life_stealer_lifest_ability_rage_01")
					end
				end
			end
		end
		
		infest_modifier:Destroy()
	end
end

----------------
-- ASSIMILATE --
----------------

function imba_life_stealer_assimilate:IsStealable()	return false end

function imba_life_stealer_assimilate:OnInventoryContentsChanged()
	if self:GetCaster():HasAbility("imba_life_stealer_infest") and self:GetCaster():HasScepter() and not self:GetCaster():FindModifierByNameAndCaster("modifier_imba_life_stealer_infest", self:GetCaster()) then
		self:SetHidden(false)
		
		if not self:IsTrained() then
			self:SetLevel(1)
		end
	-- Lifestealer technically can't drop scepter once he gets one but I guess this is still appropriate for Io talent tethers
	else
		self:SetHidden(true)
	end
end

function imba_life_stealer_assimilate:GetIntrinsicModifierName()
	return "modifier_imba_life_stealer_assimilate_handler"
end

function imba_life_stealer_assimilate:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

function imba_life_stealer_assimilate:CastFilterResultTarget(target)
	if target == self:GetCaster() then
		return UF_FAIL_OTHER
	else
		return UnitFilter( target, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, self:GetCaster():GetTeamNumber() )
	end
end

function imba_life_stealer_assimilate:GetAOERadius()
	if self:GetCaster():GetModifierStackCount("modifier_imba_life_stealer_assimilate_handler", self:GetCaster()) == 0 then
		return 0
	else
		return self:GetSpecialValueFor("consume_radius")
	end
end

function imba_life_stealer_assimilate:OnSpellStart()
	self:GetCaster():EmitSound("Hero_LifeStealer.Infest")
	
	if not self:GetAutoCastState() then
		self.consume_radius = 0
	else
		self.consume_radius = self:GetSpecialValueFor("consume_radius")
	end
	
	for _, target in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorTarget():GetAbsOrigin(), nil, self.consume_radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)) do
		if target ~= self:GetCaster() and not PlayerResource:IsDisableHelpSetForPlayerID(target:GetPlayerOwnerID(), self:GetCaster():GetPlayerOwnerID()) then
			local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_POINT, self:GetCaster())
			ParticleManager:SetParticleControl(infest_particle, 0, target:GetAbsOrigin())
			ParticleManager:SetParticleControlEnt(infest_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(infest_particle)

			-- "Unlike Infest, Assimilate applies a strong dispel on the target and disjoints projectiles upon cast."
			target:Purge(false, true, false, true, true)
			ProjectileManager:ProjectileDodge(target)

			local assimilate_effect_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_assimilate_effect", {})
			
			local assimilate_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_assimilate", {})
			
			-- Couple assimilate and the assimilate effect modifiers together so one can destroy the other
			if assimilate_effect_modifier then
				assimilate_effect_modifier.assimilate_modifier	= assimilate_modifier
				assimilate_modifier.assimilate_effect_modifier	= assimilate_effect_modifier
			end
			
			target:Interrupt()
			
			local eject_ability	= self:GetCaster():FindAbilityByName("imba_life_stealer_assimilate_eject")
			
			if eject_ability then
				if not eject_ability:IsTrained() then
					eject_ability:SetLevel(1)
				end
				
				--self:GetCaster():SwapAbilities(self:GetName(), eject_ability:GetName(), false, true)
			end
			
			-- IMBAfication: I'm So Hungry...
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_assimilate_counter", {})
		end
	end
end

---------------------------------
-- ASSIMILATE HANDLER MODIFIER --
---------------------------------

function modifier_imba_life_stealer_assimilate_handler:IsHidden()		return true end
function modifier_imba_life_stealer_assimilate_handler:IsPurgable()		return false end

function modifier_imba_life_stealer_assimilate_handler:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ORDER}
	
	return decFuncs
end

function modifier_imba_life_stealer_assimilate_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
	
	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end


-------------------------
-- ASSIMILATE MODIFIER --
-------------------------

function modifier_imba_life_stealer_assimilate:IsPurgable()	return false end

function modifier_imba_life_stealer_assimilate:OnCreated(params)
	self.radius					= self:GetAbility():GetSpecialValueFor("radius")
	self.damage					= self:GetAbility():GetSpecialValueFor("damage")
	self.order_lock_duration	= self:GetAbility():GetSpecialValueFor("order_lock_duration")

	if not IsServer() then return end

	self.ability_damage_type	= self:GetAbility():GetAbilityDamageType()

	self:GetParent():AddNoDraw()
	
	-- Orders the ally can make to break out of Assimilate
	self.destroy_orders =
	{
		[DOTA_UNIT_ORDER_MOVE_TO_POSITION]	= true,
		[DOTA_UNIT_ORDER_MOVE_TO_TARGET]	= true,
		[DOTA_UNIT_ORDER_ATTACK_MOVE]		= true,
		[DOTA_UNIT_ORDER_ATTACK_TARGET]		= true,
		[DOTA_UNIT_ORDER_CAST_POSITION]		= true,
		[DOTA_UNIT_ORDER_CAST_TARGET]		= true,
		[DOTA_UNIT_ORDER_CAST_TARGET_TREE]	= true,
		[DOTA_UNIT_ORDER_CAST_NO_TARGET]	= true,
		[DOTA_UNIT_ORDER_CAST_TOGGLE]		= true,
		[DOTA_UNIT_ORDER_DROP_ITEM]			= true,
		[DOTA_UNIT_ORDER_GIVE_ITEM]			= true,
		[DOTA_UNIT_ORDER_PICKUP_ITEM]		= true,
		[DOTA_UNIT_ORDER_TAUNT]				= true,
		[DOTA_UNIT_ORDER_CAST_RUNE]			= true
	}
	
	self:StartIntervalThink(0.1)
end

function modifier_imba_life_stealer_assimilate:OnIntervalThink()
	if not IsServer() then return end
	
	self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin())
end

function modifier_imba_life_stealer_assimilate:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():EmitSound("Hero_LifeStealer.Consume")
	
	local assimilate_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster(), self:GetCaster())
	ParticleManager:ReleaseParticleIndex(assimilate_particle)
	
	self:GetCaster():StartGesture(ACT_DOTA_LIFESTEALER_EJECT)
	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for _, enemy in pairs(enemies) do
		local damageTable = {
			victim 			= enemy,
			damage 			= self.damage,
			damage_type		= self.ability_damage_type,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		}

		ApplyDamage(damageTable)
	end
	
	FindClearSpaceForUnit(self:GetParent(), self:GetCaster():GetAbsOrigin(), false)
	
	self:GetParent():RemoveNoDraw()
	
	if self.assimilate_effect_modifier and not self.assimilate_effect_modifier:IsNull() then
		self.assimilate_effect_modifier:Destroy()
	end
	
	local assimilate_counter_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_life_stealer_assimilate_counter", self:GetCaster())
	
	if assimilate_counter_modifier then
		assimilate_counter_modifier:DecrementStackCount()
		
		if assimilate_counter_modifier:GetStackCount() <= 0 then
			assimilate_counter_modifier:Destroy()
		end
	end
end

function modifier_imba_life_stealer_assimilate:CheckState(keys)
	local state = {
		[MODIFIER_STATE_INVULNERABLE] 						= true,
		[MODIFIER_STATE_OUT_OF_GAME]						= true,
		[MODIFIER_STATE_MAGIC_IMMUNE]						= true,
		
		[MODIFIER_STATE_DISARMED]							= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]					= true,
		[MODIFIER_STATE_UNSELECTABLE]						= true
	}
	
	if self:GetElapsedTime() < self.order_lock_duration then
		state[MODIFIER_STATE_COMMAND_RESTRICTED] 			= true
	end
	
	return state
end


function modifier_imba_life_stealer_assimilate:DeclareFunctions()
    return {		
		MODIFIER_EVENT_ON_ORDER
    }
end

function modifier_imba_life_stealer_assimilate:OnOrder(keys)
	if not IsServer() then return end
	
	if keys.unit == self:GetParent() and self.destroy_orders[keys.order_type] then
		self:Destroy()
	end
end

--------------------------------
-- ASSIMILATE EFFECT MODIFIER --
--------------------------------

-- This handles the overhead particle that shows above the host's head

function modifier_imba_life_stealer_assimilate_effect:IsHidden()		return true end
function modifier_imba_life_stealer_assimilate_effect:IsPurgable()		return false end

-- If you have multiple people being assimilated, let the particles stack horizontally on top
function modifier_imba_life_stealer_assimilate_effect:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_life_stealer_assimilate_effect:ShouldUseOverheadOffset() return true end

function modifier_imba_life_stealer_assimilate_effect:OnCreated()
	if not IsServer() then return end
	
	local assimilate_overhead_particle

	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		assimilate_overhead_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_life_stealer/life_stealer_assimilated_unit.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetParent():GetTeamNumber())
	else
		assimilate_overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_assimilated_unit.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	end
	
	self:AddParticle(assimilate_overhead_particle, false, false, -1, true, false)
end

function modifier_imba_life_stealer_assimilate_effect:OnDestroy()
	if not IsServer() then return end
	
	if self.assimilate_modifier and not self.assimilate_modifier:IsNull() then
		self.assimilate_modifier:Destroy()
	end
	
	local assimilate_effect_modifiers = self:GetCaster():FindAllModifiersByName(self:GetName())
	
	self.eject_ability = self:GetCaster():FindAbilityByName("imba_life_stealer_assimilate_eject")
	
	if self.eject_ability and #assimilate_effect_modifiers <= 0 then
		self.eject_ability:SetActivated(false)
	end
end

function modifier_imba_life_stealer_assimilate_effect:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_HEALTH_GAINED
	}
	
	return decFuncs
end

function modifier_imba_life_stealer_assimilate_effect:OnHealthGained(keys)
	if keys.unit == self:GetCaster() and self.assimilate_modifier and self.assimilate_modifier:GetParent() and self.assimilate_modifier:GetParent():IsAlive() then
		self.assimilate_modifier:GetParent():Heal(keys.gain, self:GetParent())
	end
end

---------------------------------
-- ASSIMILATE COUNTER MODIFIER --
---------------------------------

function modifier_imba_life_stealer_assimilate_counter:IsPurgable()	return false end

function modifier_imba_life_stealer_assimilate_counter:OnCreated()
	if not IsServer() then return end
	
	self.eject_ability = self:GetCaster():FindAbilityByName("imba_life_stealer_assimilate_eject")
	
	self:IncrementStackCount()
end

function modifier_imba_life_stealer_assimilate_counter:OnRefresh()
	if not IsServer() then return end
	
	self:OnCreated()
end

function modifier_imba_life_stealer_assimilate_counter:OnStackCountChanged(stackCount)
	if self.eject_ability then
		if self:GetStackCount() > 0 then
			self.eject_ability:SetActivated(true)
		else
			self.eject_ability:SetActivated(false)
		end
	end
end

----------------------
-- ASSIMILATE EJECT --
----------------------

function imba_life_stealer_assimilate_eject:IsStealable()	return false end

function imba_life_stealer_assimilate_eject:OnInventoryContentsChanged()
	if self:GetCaster():HasAbility("imba_life_stealer_infest") and self:GetCaster():HasScepter() and not self:GetCaster():FindModifierByNameAndCaster("modifier_imba_life_stealer_infest", self:GetCaster()) then
		self:SetHidden(false)
		
		if not self:IsTrained() then
			self:SetLevel(1)
			self:SetActivated(false)
		end
	else
		self:SetHidden(true)
	end
end

function imba_life_stealer_assimilate_eject:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

function imba_life_stealer_assimilate_eject:OnSpellStart()
	local assimilate_effect_modifiers = self:GetCaster():FindAllModifiersByName("modifier_imba_life_stealer_assimilate_effect")
	
	for _, modifier in pairs(assimilate_effect_modifiers) do
		local assimilate_modifier = modifier.assimilate_modifier
		
		if assimilate_modifier and assimilate_modifier.Destroy then
			assimilate_modifier:Destroy()
		end
	end
end
