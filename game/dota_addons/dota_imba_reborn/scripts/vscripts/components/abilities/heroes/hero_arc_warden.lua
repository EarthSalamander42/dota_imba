-- Creator:
--	   AltiV, April 7th, 2020

-- I will NOT be making Tempest Double custom; there are far too many exceptions, and argubaly no way to replicate all the mechanics with only Lua (at least without some serious compromises in game performance such as lag)

LinkLuaModifier("modifier_imba_arc_warden_flux", "components/abilities/heroes/hero_arc_warden", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_arc_warden_magnetic_field_thinker_attack_speed", "components/abilities/heroes/hero_arc_warden", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_arc_warden_magnetic_field_thinker_evasion", "components/abilities/heroes/hero_arc_warden", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_arc_warden_magnetic_field_attack_speed", "components/abilities/heroes/hero_arc_warden", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_arc_warden_magnetic_field_evasion", "components/abilities/heroes/hero_arc_warden", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_arc_warden_spark_wraith_thinker", "components/abilities/heroes/hero_arc_warden", LUA_MODIFIER_MOTION_NONE)

imba_arc_warden_flux			= imba_arc_warden_flux or class({})
modifier_imba_arc_warden_flux	= modifier_imba_arc_warden_flux or class({})

imba_arc_warden_magnetic_field									= imba_arc_warden_magnetic_field or class({})
modifier_imba_arc_warden_magnetic_field_thinker_attack_speed	= modifier_imba_arc_warden_magnetic_field_thinker_attack_speed or class({})
modifier_imba_arc_warden_magnetic_field_thinker_evasion			= modifier_imba_arc_warden_magnetic_field_thinker_evasion or class({})
modifier_imba_arc_warden_magnetic_field_attack_speed			= modifier_imba_arc_warden_magnetic_field_attack_speed or class({})
modifier_imba_arc_warden_magnetic_field_evasion					= modifier_imba_arc_warden_magnetic_field_evasion or class({})

imba_arc_warden_spark_wraith									= imba_arc_warden_spark_wraith or class({})
modifier_imba_arc_warden_spark_wraith_thinker					= modifier_imba_arc_warden_spark_wraith_thinker or class({})

    -- "modifier_arc_warden_scepter",
    -- "modifier_arc_warden_spark_wraith_purge",
    -- "modifier_arc_warden_spark_wraith_thinker",
    -- "modifier_arc_warden_tempest_double",

--------------------------
-- IMBA_ARC_WARDEN_FLUX --
--------------------------

function imba_arc_warden_flux:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():FindTalentValue("special_bonus_imba_arc_warden_flux_cast_range")
end

function imba_arc_warden_flux:OnSpellStart()
	local target = self:GetCursorTarget()
	
	if not target:TriggerSpellAbsorb(self) then
		self:GetCaster():EmitSound("Hero_ArcWarden.Flux.Cast")
		target:EmitSound("Hero_ArcWarden.Flux.Target")
		
		local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(cast_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(cast_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(cast_particle, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
	
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_arc_warden_flux", {duration = self:GetTalentSpecialValueFor("duration")})
	end
end

-----------------------------------
-- MODIFIER_IMBA_ARC_WARDEN_FLUX --
-----------------------------------

-- This debuff's slow durations are reduced by status resistance, but not its duration

function modifier_imba_arc_warden_flux:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_arc_warden_flux:IgnoreTenacity()	return true end

function modifier_imba_arc_warden_flux:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.damage_per_second		= self:GetAbility():GetSpecialValueFor("damage_per_second")
	self.search_radius			= self:GetAbility():GetSpecialValueFor("search_radius")
	self.think_interval			= self:GetAbility():GetSpecialValueFor("think_interval")
	self.move_speed_slow_pct	= self:GetAbility():GetSpecialValueFor("move_speed_slow_pct")
	
	if not IsServer() then return end
	
	self.damage_per_interval	= self.damage_per_second * self.think_interval
	self.damage_type			= self:GetAbility():GetAbilityDamageType()
	
	self.flux_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.flux_particle, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.flux_particle, false, false, -1, false, false)
	
	self:OnIntervalThink()
	self:StartIntervalThink(self.think_interval)
end

function modifier_imba_arc_warden_flux:OnIntervalThink()
	-- IMBAfication: Enemy of All Friends (neutrals will not save you)
	if #FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.search_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false) <= 1 then
		ParticleManager:SetParticleControl(self.flux_particle, 4, Vector(1, 0, 0))
		
		self:SetStackCount(self.move_speed_slow_pct * (1 - self:GetParent():GetStatusResistance()) * (-1))
		
		ApplyDamage({
			victim 			= self:GetParent(),
			damage 			= self.damage_per_interval,
			damage_type		= self.damage_type,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		})
	else
		ParticleManager:SetParticleControl(self.flux_particle, 4, Vector(0, 0, 0))
		
		self:SetStackCount(0)
	end
end

function modifier_imba_arc_warden_flux:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_imba_arc_warden_flux:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

------------------------------------
-- IMBA_ARC_WARDEN_MAGNETIC_FIELD --
------------------------------------

function imba_arc_warden_magnetic_field:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_arc_warden_magnetic_field:OnSpellStart()
	self:GetCaster():EmitSound("Hero_ArcWarden.MagneticField.Cast")
	
	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_magnetic_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(cast_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)
	
	CreateModifierThinker(self:GetCaster(), self, "modifier_imba_arc_warden_magnetic_field_thinker_attack_speed", {
		duration = self:GetSpecialValueFor("duration")
	}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	CreateModifierThinker(self:GetCaster(), self, "modifier_imba_arc_warden_magnetic_field_thinker_evasion", {
		duration = self:GetSpecialValueFor("duration")
	}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
end

------------------------------------------------------------------
-- MODIFIER_IMBA_ARC_WARDEN_MAGNETIC_FIELD_THINKER_ATTACK_SPEED --
------------------------------------------------------------------

function modifier_imba_arc_warden_magnetic_field_thinker_attack_speed:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.attack_speed_bonus	= self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	
	if not IsServer() then return end
	
	self:GetParent():EmitSound("Hero_ArcWarden.MagneticField")
	
	self.magnetic_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_magnetic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.magnetic_particle, 1, Vector(self.radius, 1, 1))
	self:AddParticle(self.magnetic_particle, false, false, 1, false, false)
end

function modifier_imba_arc_warden_magnetic_field_thinker_attack_speed:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_ArcWarden.MagneticField")
end

function modifier_imba_arc_warden_magnetic_field_thinker_attack_speed:IsAura()						return true end
function modifier_imba_arc_warden_magnetic_field_thinker_attack_speed:IsAuraActiveOnDeath() 		return false end

function modifier_imba_arc_warden_magnetic_field_thinker_attack_speed:GetAuraDuration()				return 0.1 end
function modifier_imba_arc_warden_magnetic_field_thinker_attack_speed:GetAuraRadius()				return self.radius end
function modifier_imba_arc_warden_magnetic_field_thinker_attack_speed:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_arc_warden_magnetic_field_thinker_attack_speed:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_arc_warden_magnetic_field_thinker_attack_speed:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING end
function modifier_imba_arc_warden_magnetic_field_thinker_attack_speed:GetModifierAura()				return "modifier_imba_arc_warden_magnetic_field_attack_speed" end

-------------------------------------------------------------
-- MODIFIER_IMBA_ARC_WARDEN_MAGNETIC_FIELD_THINKER_EVASION --
-------------------------------------------------------------

function modifier_imba_arc_warden_magnetic_field_thinker_evasion:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.evasion_chance		= self:GetAbility():GetSpecialValueFor("evasion_chance")
end

function modifier_imba_arc_warden_magnetic_field_thinker_evasion:IsAura()						return true end
function modifier_imba_arc_warden_magnetic_field_thinker_evasion:IsAuraActiveOnDeath() 			return false end

function modifier_imba_arc_warden_magnetic_field_thinker_evasion:GetAuraDuration()				return 0.1 end
function modifier_imba_arc_warden_magnetic_field_thinker_evasion:GetAuraRadius()				return self.radius end
function modifier_imba_arc_warden_magnetic_field_thinker_evasion:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_arc_warden_magnetic_field_thinker_evasion:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_arc_warden_magnetic_field_thinker_evasion:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING end
function modifier_imba_arc_warden_magnetic_field_thinker_evasion:GetModifierAura()				return "modifier_imba_arc_warden_magnetic_field_evasion" end

----------------------------------------------------------
-- MODIFIER_IMBA_ARC_WARDEN_MAGNETIC_FIELD_ATTACK_SPEED --
----------------------------------------------------------

function modifier_imba_arc_warden_magnetic_field_attack_speed:OnCreated()
	if self:GetAbility() then
		self.attack_speed_bonus	= self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	elseif self:GetAuraOwner() and self:GetAuraOwner():HasModifier("modifier_imba_arc_warden_magnetic_field_thinker_attack_speed") then
		self.attack_speed_bonus	= self:GetAuraOwner():FindModifierByName("modifier_imba_arc_warden_magnetic_field_thinker_attack_speed").attack_speed_bonus
	else
		self:Destroy()
	end
end

function modifier_imba_arc_warden_magnetic_field_attack_speed:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_imba_arc_warden_magnetic_field_attack_speed:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_bonus
end

-----------------------------------------------------
-- MODIFIER_IMBA_ARC_WARDEN_MAGNETIC_FIELD_EVASION --
-----------------------------------------------------

function modifier_imba_arc_warden_magnetic_field_evasion:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_arc_warden_magnetic_field_evasion:OnCreated()
	if self:GetAbility() then
		self.evasion_chance	= self:GetAbility():GetSpecialValueFor("evasion_chance")
	elseif self:GetAuraOwner() and self:GetAuraOwner():HasModifier("modifier_imba_arc_warden_magnetic_field_thinker_evasion") then
		self.evasion_chance	= self:GetAuraOwner():FindModifierByName("modifier_imba_arc_warden_magnetic_field_thinker_evasion").evasion_chance
	else
		self:Destroy()
	end
end

function modifier_imba_arc_warden_magnetic_field_evasion:DeclareFunctions()
	return {MODIFIER_PROPERTY_EVASION_CONSTANT}
end

function modifier_imba_arc_warden_magnetic_field_evasion:GetModifierEvasion_Constant(keys)
	if keys.attacker and self:GetAuraOwner() and self:GetAuraOwner():HasModifier("modifier_imba_arc_warden_magnetic_field_thinker_evasion") and self:GetAuraOwner():FindModifierByName("modifier_imba_arc_warden_magnetic_field_thinker_evasion").radius and (keys.attacker:GetAbsOrigin() - self:GetAuraOwner():GetAbsOrigin()):Length2D() > self:GetAuraOwner():FindModifierByName("modifier_imba_arc_warden_magnetic_field_thinker_evasion").radius then
		return self.evasion_chance
	end
end

----------------------------------
-- IMBA_ARC_WARDEN_SPARK_WRAITH --
----------------------------------

function imba_arc_warden_spark_wraith:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_arc_warden_spark_wraith_cooldown")
end

function imba_arc_warden_spark_wraith:OnSpellStart()
	CreateModifierThinker(self:GetCaster(), self, "modifier_imba_arc_warden_spark_wraith_thinker", {
		duration = self:GetSpecialValueFor("duration")
	}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
end

---------------------------------------------------
-- MODIFIER_IMBA_ARC_WARDEN_SPARK_WRAITH_THINKER --
---------------------------------------------------

function modifier_imba_arc_warden_spark_wraith_thinker:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.activation_delay	= self:GetAbility():GetSpecialValueFor("activation_delay")
	self.wraith_speed		= self:GetAbility():GetSpecialValueFor("wraith_speed")
	self.spark_damage		= self:GetAbility():GetTalentSpecialValueFor("spark_damage")
	self.think_interval			= self:GetAbility():GetSpecialValueFor("think_interval")
	self.wraith_vision_radius	= self:GetAbility():GetSpecialValueFor("wraith_vision_radius")
	self.wraith_vision_duration	= self:GetAbility():GetSpecialValueFor("wraith_vision_duration")
	self.ministun_duration		= self:GetAbility():GetSpecialValueFor("ministun_duration")
	self.move_speed_slow_pct	= self:GetAbility():GetSpecialValueFor("move_speed_slow_pct")
	
	if not IsServer() then return end
	
	self.wraith_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_wraith.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.wraith_particle, 1, Vector(self.radius, 1, 1))
	self:AddParticle(self.wraith_particle, false, false, -1, false, false)
	
	self:GetCaster():SetContextThink(DoUniqueString(self:GetName()), function()
		self:StartIntervalThink(self.think_interval)
		return nil
	end, self.activation_delay - self.think_interval)
end

function modifier_imba_arc_warden_spark_wraith_thinker:OnIntervalThink()
	
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_arc_warden_flux_cast_range", "components/abilities/heroes/hero_arc_warden", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_arc_warden_spark_wraith_cooldown", "components/abilities/heroes/hero_arc_warden", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_arc_warden_spark_wraith_damage", "components/abilities/heroes/hero_arc_warden", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_arc_warden_flux_cast_range			= modifier_special_bonus_imba_arc_warden_flux_cast_range or class({})
modifier_special_bonus_imba_arc_warden_spark_wraith_cooldown	= modifier_special_bonus_imba_arc_warden_spark_wraith_cooldown or class({})
modifier_special_bonus_imba_arc_warden_spark_wraith_damage		= modifier_special_bonus_imba_arc_warden_spark_wraith_damage or class({})

function modifier_special_bonus_imba_arc_warden_flux_cast_range:IsHidden() 		return true end
function modifier_special_bonus_imba_arc_warden_flux_cast_range:IsPurgable()		return false end
function modifier_special_bonus_imba_arc_warden_flux_cast_range:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_arc_warden_spark_wraith_cooldown:IsHidden() 			return true end
function modifier_special_bonus_imba_arc_warden_spark_wraith_cooldown:IsPurgable() 		return false end
function modifier_special_bonus_imba_arc_warden_spark_wraith_cooldown:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_arc_warden_spark_wraith_damage:IsHidden() 		return true end
function modifier_special_bonus_imba_arc_warden_spark_wraith_damage:IsPurgable() 		return false end
function modifier_special_bonus_imba_arc_warden_spark_wraith_damage:RemoveOnDeath() 	return false end

function imba_arc_warden_spark_wraith:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_arc_warden_spark_wraith_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_arc_warden_spark_wraith_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_arc_warden_spark_wraith_cooldown"), "modifier_special_bonus_imba_arc_warden_spark_wraith_cooldown", {})
	end
	
	if self:GetCaster():HasTalent("special_bonus_imba_arc_warden_spark_wraith_damage") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_arc_warden_spark_wraith_damage") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_arc_warden_spark_wraith_damage"), "modifier_special_bonus_imba_arc_warden_spark_wraith_damage", {})
	end
end
