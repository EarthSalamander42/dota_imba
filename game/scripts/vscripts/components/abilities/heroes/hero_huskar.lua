-- Creator:
--	   AltiV, April 3rd, 2019

LinkLuaModifier("modifier_imba_huskar_inner_fire_knockback", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_huskar_inner_fire_disarm", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_inner_fire_raze_land", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_inner_fire_raze_land_aura", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_generic_orb_effect_lua", "components/modifiers/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_burning_spear_counter", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_burning_spear_debuff", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_huskar_berserkers_blood", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_berserkers_blood_crimson_priest", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_huskar_inner_vitality", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_huskar_life_break", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_huskar_life_break_charge", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_life_break_slow", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_life_break_sac_dagger", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_life_break_sac_dagger_tracker", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_life_break_taunt", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_NONE)

imba_huskar_inner_fire									= class({})
modifier_imba_huskar_inner_fire_knockback				= class({})
modifier_imba_huskar_inner_fire_disarm					= class({})
modifier_imba_huskar_inner_fire_raze_land				= class({})
modifier_imba_huskar_inner_fire_raze_land_aura			= class({})

imba_huskar_burning_spear								= class({})
modifier_imba_huskar_burning_spear_counter				= class({})
modifier_imba_huskar_burning_spear_debuff				= class({})		

imba_huskar_berserkers_blood							= class({})
modifier_imba_huskar_berserkers_blood					= class({})
modifier_imba_huskar_berserkers_blood_crimson_priest	= class({})

imba_huskar_inner_vitality								= class({})
modifier_imba_huskar_inner_vitality						= class({})

imba_huskar_life_break									= class({})
modifier_imba_huskar_life_break							= class({})
modifier_imba_huskar_life_break_charge					= class({})
modifier_imba_huskar_life_break_slow					= class({})
modifier_imba_huskar_life_break_sac_dagger				= class({})
modifier_imba_huskar_life_break_sac_dagger_tracker		= class({})
modifier_imba_huskar_life_break_taunt					= class({})

----------------
-- INNER FIRE --
----------------

function imba_huskar_inner_fire:OnSpellStart()
	if not IsServer() then return end

	local damage				= self:GetSpecialValueFor("damage")
	local radius				= self:GetSpecialValueFor("radius")
	local disarm_duration		= self:GetSpecialValueFor("disarm_duration")
	local knockback_distance	= self:GetSpecialValueFor("knockback_distance")
	local knockback_duration	= self:GetSpecialValueFor("knockback_duration")

	local raze_land_duration	= self:GetSpecialValueFor("raze_land_duration")
	
	-- Emit sound
	self:GetCaster():EmitSound("Hero_Huskar.Inner_Fire.Cast")
	
	-- Particle effects
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf", PATTACH_POINT, self:GetCaster())
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, 0, 0))
	ParticleManager:SetParticleControl(particle, 3, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	
	-- Find enemies in the radius
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	-- "Inner Fire first applies the damage, then the debuffs."
	for _, enemy in pairs(enemies) do
		local damageTable = {
			victim 			= enemy,
			damage 			= damage,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}
		
		ApplyDamage(damageTable)
		
		-- Apply the knockback (and pass the caster's location coordinates to know which way to knockback)
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_huskar_inner_fire_knockback", {duration = knockback_duration * (1 - enemy:GetStatusResistance()), x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})
		
		-- Apply the disarm
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_huskar_inner_fire_disarm", {duration = disarm_duration * (1 - enemy:GetStatusResistance())})
	end
	
	-- IMBAfication: Raze Land
	CreateModifierThinker(self:GetCaster(), self, "modifier_imba_huskar_inner_fire_raze_land_aura", {
		duration		= raze_land_duration
	}, 
	self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
end

-----------------------------------
-- INNER FIRE KNOCKBACK MODIFIER --
-----------------------------------

function modifier_imba_huskar_inner_fire_knockback:IsHidden() return true end

function modifier_imba_huskar_inner_fire_knockback:OnCreated(params)
	if not IsServer() then return end
	
	self.ability				= self:GetAbility()
	self.caster					= self:GetCaster()
	self.parent					= self:GetParent()
	
	-- AbilitySpecials
	self.knockback_duration		= self.ability:GetSpecialValueFor("knockback_duration")
	-- Knockbacks a set distance, so change this value based on distance from caster and parent
	self.knockback_distance		= math.max(self.ability:GetSpecialValueFor("knockback_distance") - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
	
	-- Calculate speed at which modifier owner will be knocked back
	self.knockback_speed		= self.knockback_distance / self.knockback_duration
	
	-- Get the center of the Blinding Light sphere to know which direction to get knocked back
	self.position	= GetGroundPosition(Vector(params.x, params.y, 0), nil)
	
	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
		return
	end
end

function modifier_imba_huskar_inner_fire_knockback:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end

	local distance = (me:GetOrigin() - self.position):Normalized()
	
	me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )
	
	-- Destroy any trees passed through
	GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_imba_huskar_inner_fire_knockback:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_imba_huskar_inner_fire_knockback:GetOverrideAnimation()
	 return ACT_DOTA_FLAIL
end

function modifier_imba_huskar_inner_fire_knockback:OnDestroy()
	if not IsServer() then return end
	
	self.parent:RemoveHorizontalMotionController( self )
end

--------------------------------
-- INNER FIRE DISARM MODIFIER --
--------------------------------

function modifier_imba_huskar_inner_fire_disarm:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf"
end

function modifier_imba_huskar_inner_fire_disarm:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_huskar_inner_fire_disarm:CheckState()
	return {[MODIFIER_STATE_DISARMED] = true}
end

-----------------------------------
-- INNER FIRE RAZE LAND MODIFIER --
-----------------------------------

function modifier_imba_huskar_inner_fire_raze_land:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_imba_huskar_inner_fire_raze_land:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.raze_land_strength_pct	= self:GetAbility():GetSpecialValueFor("raze_land_strength_pct")
	
	if not IsServer() then return end
	
	self.damage		= self:GetCaster():GetStrength() * self.raze_land_strength_pct * 0.01
	
	self:OnIntervalThink()
	self:StartIntervalThink(0.5)
end

function modifier_imba_huskar_inner_fire_raze_land:OnIntervalThink()
	if not IsServer() then return end
	
	-- Update strength damage periodically if the caster still exists
	if self:GetCaster() then
		self.damage		= self:GetCaster():GetStrength() * self.raze_land_strength_pct * 0.01
	end
	
	local damageTable = {
		victim 			= self:GetParent(),
		attacker 		= self:GetCaster(),
		damage 			= self.damage,
		damage_type 	= DAMAGE_TYPE_MAGICAL,
		ability 		= self:GetAbility(),
		damage_flags	= DOTA_DAMAGE_FLAG_NONE
	}
	ApplyDamage(damageTable)

	-- Apply burning spear stacks if applicable
	-- local burning_spears_ability = self:GetCaster():FindAbilityByName("imba_huskar_burning_spear")
	
	-- if burning_spears_ability and burning_spears_ability:IsTrained() then
		-- self:GetParent():AddNewModifier(self:GetCaster(), burning_spears_ability, "modifier_imba_huskar_burning_spear_debuff", { duration = burning_spears_ability:GetDuration() })
		-- self:GetParent():AddNewModifier(self:GetCaster(), burning_spears_ability, "modifier_imba_huskar_burning_spear_counter", { duration = burning_spears_ability:GetDuration() })
	-- end
end

----------------------------------------
-- INNER FIRE RAZE LAND AURA MODIFIER --
----------------------------------------

function modifier_imba_huskar_inner_fire_raze_land_aura:IsAura() 				return true end

function modifier_imba_huskar_inner_fire_raze_land_aura:GetAuraRadius()
	if not self.radius then self.radius = self:GetAbility():GetSpecialValueFor("radius") end
	return self.radius
end
function modifier_imba_huskar_inner_fire_raze_land_aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_imba_huskar_inner_fire_raze_land_aura:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_huskar_inner_fire_raze_land_aura:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_huskar_inner_fire_raze_land_aura:GetModifierAura()		return "modifier_imba_huskar_inner_fire_raze_land" end

function modifier_imba_huskar_inner_fire_raze_land_aura:OnCreated()
	self.radius						= self:GetAbility():GetSpecialValueFor("radius")
	self.raze_land_damage_interval	= self:GetAbility():GetSpecialValueFor("raze_land_damage_interval")
	
	if not IsServer() then return end
	-- Man I am so garbage with particles
	self.particle = ParticleManager:CreateParticle("particles/hero/huskar/huskar_inner_fire_raze_land.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(self.particle, 1, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.particle, false, false, -1, false, false)
	
	self:StartIntervalThink(self.raze_land_damage_interval)
end

function modifier_imba_huskar_inner_fire_raze_land_aura:OnIntervalThink()
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.radius, true )
	
	local wards = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_OTHER, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	
	for _, ward in pairs(wards) do
		if ward:GetUnitName() == "npc_dota_observer_wards" or ward:GetUnitName() == "npc_dota_sentry_wards" then
			ward:Kill(self:GetAbility(), self:GetCaster())
		end
	end
end

-------------------
-- BURNING SPEAR --
-------------------

function imba_huskar_burning_spear:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end

function imba_huskar_burning_spear:GetProjectileName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf"
end

function imba_huskar_burning_spear:GetAbilityTargetFlags()
	if self:GetCaster():HasTalent("special_bonus_imba_huskar_pure_burning_spears") then
		return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	else
		return DOTA_UNIT_TARGET_FLAG_NONE
	end
end

function imba_huskar_burning_spear:CastFilterResultTarget(target)
	if self:GetCaster():HasTalent("special_bonus_imba_huskar_pure_burning_spears") then
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber())
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	end
end

function imba_huskar_burning_spear:OnOrbFire()
	self:GetCaster():EmitSound("Hero_Huskar.Burning_Spear.Cast")
	
	-- Vanilla version doesn't actually show Huskar taking damage so I assume it's a SetHealth thing
	self:GetCaster():SetHealth(math.max(self:GetCaster():GetHealth() - (self:GetCaster():GetHealth() * self:GetSpecialValueFor("health_cost") * 0.01), 1))
end

function imba_huskar_burning_spear:OnOrbImpact( keys )
	if not keys.target:IsMagicImmune() or self:GetCaster():HasTalent("special_bonus_imba_huskar_pure_burning_spears") then	
		keys.target:EmitSound("Hero_Huskar.Burning_Spear")
		
		keys.target:AddNewModifier(self:GetCaster(), self, "modifier_imba_huskar_burning_spear_debuff", { duration = self:GetDuration() })
		keys.target:AddNewModifier(self:GetCaster(), self, "modifier_imba_huskar_burning_spear_counter", { duration = self:GetDuration() })
	end
end

------------------------------------
-- BURNING SPEAR COUNTER MODIFIER --
------------------------------------

-- This will be the visible, non-multiple, stacking modifier
function modifier_imba_huskar_burning_spear_counter:IgnoreTenacity()	return true end
function modifier_imba_huskar_burning_spear_counter:IsPurgable()		return false end

function modifier_imba_huskar_burning_spear_counter:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_imba_huskar_burning_spear_counter:OnCreated()
	if not IsServer() then return end
	
	self:IncrementStackCount()

	self.burn_damage 				= self:GetAbility():GetSpecialValueFor("burn_damage") + self:GetCaster():FindTalentValue("special_bonus_unique_huskar_2")
	self.pain_reflection_per_stack	= self:GetAbility():GetSpecialValueFor("pain_reflection_per_stack")

	self.damage_type = DAMAGE_TYPE_MAGICAL
	
	if self:GetCaster() and self:GetCaster():HasTalent("special_bonus_imba_huskar_pure_burning_spears") then
		self.damage_type = DAMAGE_TYPE_PURE
	end

	-- Precache damage table
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		-- damage = to be handled in the intervalthink due to stacks
		-- damage_type = to be handled in the intervalthink due to potential talent switch
		ability = self:GetAbility()
	}
	
	self:StartIntervalThink(1)
end

function modifier_imba_huskar_burning_spear_counter:OnRefresh()
	if not IsServer() then return end
	
	self:IncrementStackCount()
end

function modifier_imba_huskar_burning_spear_counter:OnIntervalThink()
	if not IsServer() then return end

	-- Dumb nil checks that should never happen in an actual game
	if self:GetAbility() and self:GetCaster() then
		self.burn_damage 				= self:GetAbility():GetSpecialValueFor("burn_damage") + self:GetCaster():FindTalentValue("special_bonus_unique_huskar_2")
		
		self.damage_type = DAMAGE_TYPE_MAGICAL
		
		if self:GetCaster() and self:GetCaster():HasTalent("special_bonus_imba_huskar_pure_burning_spears") then
			self.damage_type = DAMAGE_TYPE_PURE
		end
	end
	
	self.damageTable.damage 		= self:GetStackCount() * self.burn_damage
	self.damageTable.damage_type	= self.damage_type

	ApplyDamage( self.damageTable )
end

function modifier_imba_huskar_burning_spear_counter:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_Huskar.Burning_Spear")
end

function modifier_imba_huskar_burning_spear_counter:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE, -- IMBAfication: Know My Pain!
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
    }

    return decFuncs
end

function modifier_imba_huskar_burning_spear_counter:OnTakeDamage(keys)
	if not IsServer() then return end
	
	-- No infinite loops plz
	if keys.unit == self:GetCaster() and bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION then
	
		-- Might be too obnoxious if played a billion times
		-- self:GetParent():EmitSound("DOTA_Item.BladeMail.Damage")
		
		local damageTable = {
			victim 			= self:GetParent(),
			damage 			= keys.original_damage * (self:GetStackCount() * self.pain_reflection_per_stack * 0.01),
			damage_type		= keys.damage_type,
			damage_flags 	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		}
								
		ApplyDamage(damageTable)
	end
end

function modifier_imba_huskar_burning_spear_counter:OnTooltip()
	return self:GetStackCount() * self.pain_reflection_per_stack
end

-----------------------------------
-- BURNING SPEAR DEBUFF MODIFIER --
-----------------------------------

-- This will be the hidden, multiple, non-stacking modifier

function modifier_imba_huskar_burning_spear_debuff:IgnoreTenacity()	return true end
function modifier_imba_huskar_burning_spear_debuff:IsHidden() 		return true end
function modifier_imba_huskar_burning_spear_debuff:IsPurgable()		return false end
function modifier_imba_huskar_burning_spear_debuff:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_huskar_burning_spear_debuff:OnDestroy()
	if not IsServer() then return end
	
	local burning_spear_counter = self:GetParent():FindModifierByNameAndCaster("modifier_imba_huskar_burning_spear_counter", self:GetCaster())
	
	if burning_spear_counter then
		burning_spear_counter:DecrementStackCount()
	end
end

-----------------------
-- BERSERKER'S BLOOD --
-----------------------

-- IMBAfication: Crimson Priest
-- function imba_huskar_berserkers_blood:GetBehavior()
	-- return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
-- end

-- Crimson Priest IMBAfication will be an "opt-out" add-on
-- function imba_huskar_berserkers_blood:OnUpgrade()
	-- if self:GetLevel() == 1 then
		-- self:ToggleAutoCast()
	-- end
-- end

-- Not castable
-- function imba_huskar_berserkers_blood:OnAbilityPhaseStart() return false end

function imba_huskar_berserkers_blood:GetIntrinsicModifierName()
	return "modifier_imba_huskar_berserkers_blood"
end

--------------------------------
-- BERSERKER'S BLOOD MODIFIER --
--------------------------------

function modifier_imba_huskar_berserkers_blood:IsHidden()	return true end
	
function modifier_imba_huskar_berserkers_blood:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.maximum_attack_speed		= self.ability:GetSpecialValueFor("maximum_attack_speed")
	self.maximum_health_regen		= self.ability:GetSpecialValueFor("maximum_health_regen")
	self.hp_threshold_max 			= self.ability:GetSpecialValueFor("hp_threshold_max")
	self.maximum_resistance 		= self.ability:GetSpecialValueFor("maximum_resistance")
	self.crimson_priest_duration	= self.ability:GetSpecialValueFor("crimson_priest_duration")
	
	self.range 					= 100 - self.hp_threshold_max
	
	-- Max size in pct that Huskar increases to
	self.max_size = 35
	
	if not IsServer() then return end
	
	-- Create the Berserker's Blood particle (glow + heal)
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_berserkers_blood.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	
	-- Create the "blood" particle (big thanks to DarkDice from ModDota for making this for me; as he said, it's not perfect, but it looks much better than the stupid color render solution I was using before)
	-- ...Now only if he could show me how to get it to actually work in-game
	-- self.particle2 = ParticleManager:CreateParticle("particles/hero/huskar/status_effect_berserker_blood_mod.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	
	self:StartIntervalThink(0.1)
end

-- When the ability gets leveled up
function modifier_imba_huskar_berserkers_blood:OnRefresh()
	-- AbilitySpecials
	self.maximum_attack_speed		= self.ability:GetSpecialValueFor("maximum_attack_speed")
	self.maximum_health_regen		= self.ability:GetSpecialValueFor("maximum_health_regen")
	self.hp_threshold_max 			= self.ability:GetSpecialValueFor("hp_threshold_max")
	self.maximum_resistance 		= self.ability:GetSpecialValueFor("maximum_resistance")
	-- self.crimson_priest_duration	= self.ability:GetSpecialValueFor("crimson_priest_duration")
	
	self.range 						= 100 - self.hp_threshold_max
end

function modifier_imba_huskar_berserkers_blood:OnIntervalThink()
	if not IsServer() then return end
	
	-- Use the stack count to store strength value for proper client/server interaction
	self:SetStackCount(self.parent:GetStrength())
end

-- Realistically speaking, this function will never be called...but just in case...
function modifier_imba_huskar_berserkers_blood:OnDestroy()
	if not IsServer() then return end

	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
	
	-- ParticleManager:DestroyParticle(self.particle2, false)
	-- ParticleManager:ReleaseParticleIndex(self.particle2)
end

function modifier_imba_huskar_berserkers_blood:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, -- IMBAfication: Remnants of Berserker's Blood
		-- MODIFIER_PROPERTY_MIN_HEALTH,				-- IMBAfication: Crimson Priest
		-- MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function modifier_imba_huskar_berserkers_blood:GetModifierAttackSpeedBonus_Constant()
	if self.parent:PassivesDisabled() then return end

	-- This percentage gets lower as health drops, which in turn increases the returned value
	local pct = math.max((self.parent:GetHealthPercent() - self.hp_threshold_max) / self.range, 0)
	
	return self.maximum_attack_speed * (1 - pct)
end

function modifier_imba_huskar_berserkers_blood:GetModifierConstantHealthRegen()
	if self.parent:PassivesDisabled() then return end

	local pct = math.max((self.parent:GetHealthPercent() - self.hp_threshold_max) / self.range, 0)
	
	-- Strength * max health regen value pct converted to decimal * the reverse range
	return self:GetStackCount() * self.maximum_health_regen  * 0.01 * (1 - pct)
end

-- This doesn't change if the modifier owner is broken
function modifier_imba_huskar_berserkers_blood:GetModifierModelScale()
	if not IsServer() then return end
	
	local pct = math.max((self.parent:GetHealthPercent() - self.hp_threshold_max) / self.range, 0)

	-- Glow / regen particles are controlled by CP1 of the particle
	ParticleManager:SetParticleControl(self.particle, 1, Vector( (1 - pct) * 100, 0, 0))
	
	-- I haven't seen any examples of how to replicate the blood particles (and can't figure it myself) so time for massive bootleg instead	
	self.parent:SetRenderColor(255, 255 * pct, 255 * pct)
	
	-- Let's use DarkDice's particles (seems to work through a scaling CP0 second value from 0 to 1.4)
	-- ParticleManager:SetParticleControlEnt(self.particle2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector( 0, 1.4 * (1 - pct), 0), true)
	-- return self.max_size * (1 - pct)
end

function modifier_imba_huskar_berserkers_blood:GetActivityTranslationModifiers()
	return "berserkers_blood"
end

function modifier_imba_huskar_berserkers_blood:GetModifierMagicalResistanceBonus()
	local pct = math.max((self.parent:GetHealthPercent() - self.hp_threshold_max) / self.range, 0)
	
	return self.maximum_resistance * (1 - pct)
end

-- function modifier_imba_huskar_berserkers_blood:GetMinHealth()
	-- if (self:GetAbility():GetAutoCastState() and self:GetAbility():IsCooldownReady() and not self:GetCaster():PassivesDisabled() and not self:GetCaster():IsIllusion()) or self:GetParent():HasModifier("modifier_imba_huskar_berserkers_blood_crimson_priest") then
		-- return 1
	-- else
		-- return 0
	-- end
-- end

-- function modifier_imba_huskar_berserkers_blood:OnTakeDamage(keys)
	-- if not IsServer() then return end
	
	-- -- Don't waste it if caster has Shallow Grave or Cheese Death Prevention
	-- if keys.unit == self.caster and self.caster:GetHealth() <= 1 and not self.caster:IsIllusion() and (self.ability:GetAutoCastState() and self.ability:IsCooldownReady()) and not self.caster:PassivesDisabled() and not self.caster:HasModifier("modifier_imba_dazzle_shallow_grave") and not self.caster:HasModifier("modifier_imba_dazzle_nothl_protection_aura_talent") and not self.caster:HasModifier("modifier_imba_cheese_death_prevention") and not self.caster:HasModifier("modifier_imba_huskar_berserkers_blood_crimson_priest") then
		-- self.ability:UseResources(false, false, false, true)
	
		-- self.caster:EmitSound("Hero_Dazzle.Shallow_Grave")
		-- self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_huskar_berserkers_blood_crimson_priest", {duration = self.crimson_priest_duration})
	-- end
-- end

-----------------------------------------------
-- BERSERKER'S BLOOD CRIMSON PRIEST MODIFIER --
-----------------------------------------------

function modifier_imba_huskar_berserkers_blood_crimson_priest:IsPurgable()	return false end

function modifier_imba_huskar_berserkers_blood_crimson_priest:GetEffectName()
	return "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf"
end

function modifier_imba_huskar_berserkers_blood_crimson_priest:OnDestroy()
	if not IsServer() then return end

	self:GetCaster():StopSound("Hero_Dazzle.Shallow_Grave")
end

--------------------
-- INNER VITALITY --
--------------------

-- Self leveling function (since this is technically a completely separate ability)
function imba_huskar_inner_vitality:OnHeroLevelUp()
	self:SetLevel(min(math.floor(self:GetCaster():GetLevel() / 3), 4))
end

function imba_huskar_inner_vitality:OnSpellStart()
	if not IsServer() then return end
	
	self:GetCursorTarget():EmitSound("Hero_Huskar.Inner_Vitality")

	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_huskar_inner_vitality", {duration = self:GetDuration()})
end

-----------------------------
-- INNER VITALITY MODIFIER --
-----------------------------

function modifier_imba_huskar_inner_vitality:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf"
end

function modifier_imba_huskar_inner_vitality:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.heal				= self.ability:GetSpecialValueFor("heal")
	self.attrib_bonus		= self.ability:GetSpecialValueFor("attrib_bonus")
	self.hurt_attrib_bonus	= self.ability:GetSpecialValueFor("hurt_attrib_bonus")
	self.hurt_percent		= self.ability:GetSpecialValueFor("hurt_percent")
	
	self.final_stand_hp_threshold	= self.ability:GetSpecialValueFor("final_stand_hp_threshold")
	self.final_stand_status_resist	= self.ability:GetSpecialValueFor("final_stand_status_resist")
	
	if not IsServer() then return end
	
	self.primary_stat_regen	= 0
	
	-- Check if the target has a primary attribute (creep-heroes typically do not, so they only benefit from the base heal value)
	if self.parent.GetPrimaryStatValue then
		-- If they are healthy, use the standard attribute bonus
		if self.parent:GetHealthPercent() > self.hurt_percent * 100 then
			self.primary_stat_regen = self.parent:GetPrimaryStatValue() * self.attrib_bonus
		-- If they are under the threshold, use the hurt attribute bonus
		else
			self.primary_stat_regen = self.parent:GetPrimaryStatValue() * self.hurt_attrib_bonus
		end
	end
	
	-- Set the final heal regen value as a stack so we don't have client/server issues as per usual
	-- Multiplying by 10 to divide by 10 later for decimal place regen
	self:SetStackCount((self.heal + self.primary_stat_regen) * 10)
	
	self:StartIntervalThink(1)
end

-- Repeats the stat regen calculation part every second
function modifier_imba_huskar_inner_vitality:OnIntervalThink()
	if not IsServer() then return end
	
	if self.parent.GetPrimaryStatValue then
		if self.parent:GetHealthPercent() > self.hurt_percent * 100 then
			self.primary_stat_regen = self.parent:GetPrimaryStatValue() * self.attrib_bonus
		else
			self.primary_stat_regen = self.parent:GetPrimaryStatValue() * self.hurt_attrib_bonus
		end
	end
	
	self:SetStackCount((self.heal + self.primary_stat_regen) * 10)
end

function modifier_imba_huskar_inner_vitality:OnDestroy()
	if not IsServer() then return end
	
	self.parent:StopSound("Hero_Huskar.Inner_Vitality")
end

function modifier_imba_huskar_inner_vitality:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING	-- IMBAfication: Final Stand
	}

	return funcs
end

function modifier_imba_huskar_inner_vitality:GetModifierConstantHealthRegen()
	return self:GetStackCount() * 0.1
end

function modifier_imba_huskar_inner_vitality:GetModifierStatusResistanceStacking()
	if self.parent:GetHealthPercent() < self.final_stand_hp_threshold then
		return self.final_stand_status_resist
	end
end

----------------
-- LIFE BREAK --
----------------

function imba_huskar_life_break:CastFilterResultTarget(target)
	if IsServer() then
		if target == self:GetCaster() and self:GetAutoCastState() then
			return UF_SUCCESS
		end
		
		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_huskar_life_break:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

function imba_huskar_life_break:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():FindTalentValue("special_bonus_imba_huskar_life_break_cast_range")
end

-- Harakiri IMBAfication will be an "opt-out" add-on
function imba_huskar_life_break:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end

-- function imba_huskar_life_break:GetCooldown(level)
	-- if self:GetCaster():HasScepter() then
		-- return self:GetSpecialValueFor("cooldown_scepter")
	-- else
		-- return self.BaseClass.GetCooldown(self, level)
	-- end
-- end

function imba_huskar_life_break:OnSpellStart()
	if not IsServer() then return end

	self:GetCaster():EmitSound("Hero_Huskar.Life_Break")

	-- Applies a basic purge on caster
	self:GetCaster():Purge(false, true, false, false, false)

	-- Yeah this is a thing
	local life_break_charge_max_duration = 5
	
	-- Create Life Break standard (motion controller) and charge modifier and feed the entity index as a parameter, which will be converted back into an entity to handle targeting
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_huskar_life_break", {ent_index = self:GetCursorTarget():GetEntityIndex()})
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_huskar_life_break_charge", {duration = life_break_charge_max_duration})
end

-------------------------
-- LIFE BREAK MODIFIER --
-------------------------

function modifier_imba_huskar_life_break:IsHidden()		return true end
function modifier_imba_huskar_life_break:IsPurgable()	return false end

function modifier_imba_huskar_life_break:OnCreated(params)
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()

	-- AbilitySpecials
	self.health_cost_percent	= self.ability:GetSpecialValueFor("health_cost_percent")
	self.health_damage			= self.ability:GetSpecialValueFor("health_damage")
	self.health_damage_scepter	= self.ability:GetSpecialValueFor("health_damage_scepter")
	self.charge_speed			= self.ability:GetSpecialValueFor("charge_speed")

	self.sac_dagger_duration		= self.ability:GetSpecialValueFor("sac_dagger_duration")
	self.sac_dagger_distance		= self.ability:GetSpecialValueFor("sac_dagger_distance")
	self.sac_dagger_rotation_speed	= self.ability:GetSpecialValueFor("sac_dagger_rotation_speed")
	self.sac_dagger_contact_radius	= self.ability:GetSpecialValueFor("sac_dagger_contact_radius")
	self.sac_dagger_dmg_pct			= self.ability:GetSpecialValueFor("sac_dagger_dmg_pct")
	
	self.taunt_duration				= self.ability:GetSpecialValueFor("taunt_duration")

	if not IsServer() then return end

	self.target			= EntIndexToHScript(params.ent_index)
	-- As per the wiki; Life Break stops if the target exceeds this distance away from the caster
	self.break_range	= 1450

	-- Begin the motion controller
	if self:ApplyHorizontalMotionController() == false then
		self:Destroy()
	end
end

function modifier_imba_huskar_life_break:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end
	
	me:FaceTowards(self.target:GetOrigin())

	local distance = (self.target:GetOrigin() - me:GetOrigin()):Normalized()
	me:SetOrigin( me:GetOrigin() + distance * self.charge_speed * dt )
	
	-- IDK aribtrary numbers again
	if (self.target:GetOrigin() - me:GetOrigin()):Length2D() <= 128 or (self.target:GetOrigin() - me:GetOrigin()):Length2D() > self.break_range or self.parent:IsHexed() or self.parent:IsNightmared() or self.parent:IsStunned() then
		self:Destroy()
	end
end

-- This typically gets called if the caster uses a position breaking tool (ex. Blink Dagger) while in mid-motion
function modifier_imba_huskar_life_break:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_imba_huskar_life_break:OnDestroy()
	if not IsServer() then return end

	self.parent:RemoveHorizontalMotionController( self )

	if self.parent:HasModifier("modifier_imba_huskar_life_break_charge") then
		self.parent:RemoveModifierByName("modifier_imba_huskar_life_break_charge")
	end

	-- Assumption is that if the caster's within range when the modifier is destroyed, then the cast landed (probably some extreme edge cases but like come on now)
	if (self.target:GetOrigin() - self.parent:GetOrigin()):Length2D() <= 128 then
		-- Do nothing else if blocked
		if self.target:TriggerSpellAbsorb(self.ability) then
			return nil
		end

		-- Play ending cast animation if applicable
		if self.parent:GetName() == "npc_dota_hero_huskar" then
			self.parent:StartGesture(ACT_DOTA_CAST_LIFE_BREAK_END)
		end

		-- Emit sound
		self.target:EmitSound("Hero_Huskar.Life_Break.Impact")

		-- Emit particle
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_life_break.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target, self.caster)
		ParticleManager:SetParticleControl(particle, 1, self.target:GetOrigin())
		ParticleManager:ReleaseParticleIndex(particle)

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_life_break_spellstart.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target, self.caster)
		ParticleManager:SetParticleControl(particle, 1, self.target:GetOrigin())
		ParticleManager:ReleaseParticleIndex(particle)

		local enemy_damage_to_use = self.health_damage

		-- if self.parent:HasScepter() then
			-- enemy_damage_to_use = self.health_damage_scepter
		-- end

		-- Deal damage to enemy and self
		local damageTable_enemy = {
			victim 			= self.target,
			attacker 		= self.parent,
			damage 			= enemy_damage_to_use * self.target:GetHealth(),
			damage_type 	= DAMAGE_TYPE_MAGICAL,
			ability 		= self.ability,
			damage_flags	= DOTA_DAMAGE_FLAG_NONE
		}
		local enemy_damage = ApplyDamage(damageTable_enemy)

		local damageTable_self = {
			victim 			= self.parent,
			attacker 		= self.parent,
			damage 			= self.health_cost_percent * self.parent:GetHealth(),
			damage_type 	= DAMAGE_TYPE_MAGICAL,
			ability		 	= self.ability,
			damage_flags 	= DOTA_DAMAGE_FLAG_NON_LETHAL
		}
		local self_damage = ApplyDamage(damageTable_self)
		
		local duration = self.ability:GetDuration() * (1 - self.target:GetStatusResistance())
		
		if self.target:GetTeamNumber() == self.parent:GetTeamNumber() then
			duration = self.ability:GetDuration()
		end
		
		-- Apply the slow modifier
		self.target:AddNewModifier(self.parent, self.ability, "modifier_imba_huskar_life_break_slow", {duration = duration})
		
		-- This is optional I guess but it replicates vanilla Life Break being reflected by Lotus Orb a bit closer (cause the target starts attacking you)
		self.parent:MoveToTargetToAttack( self.target )
		
		-- 7.23 Aghanim's Scepter effect
		if self.caster:HasScepter() and self.caster ~= self.target then
			local taunt_modifier = self.target:AddNewModifier(self.caster, self.ability, "modifier_imba_huskar_life_break_taunt", {duration = self.taunt_duration})
			
			if taunt_modifier then
				taunt_modifier:SetDuration(self.taunt_duration * (1 - self.target:GetStatusResistance()), true)
			end
		end

		-- IMBAfication: Sacrificial Dagger
		local random_angle	= RandomInt(0, 359)

		CreateModifierThinker(self.parent, self.ability, "modifier_imba_huskar_life_break_sac_dagger", {
			duration		= self.sac_dagger_duration,
			random_angle	= random_angle,
			distance		= self.sac_dagger_distance,
			rotation_speed	= self.sac_dagger_rotation_speed,
			contact_radius	= self.sac_dagger_contact_radius,
			damage			= enemy_damage * self.sac_dagger_dmg_pct * 0.01
		}, 
		self.parent:GetAbsOrigin() + Vector(math.cos(math.rad(random_angle)), math.sin(math.rad((random_angle)))) * self.sac_dagger_distance, self.parent:GetTeamNumber(), false)
		
		-- Create damage tracker modifier
		local tracker_modifier = self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_huskar_life_break_sac_dagger_tracker", {duration = self.sac_dagger_duration})
		
		if tracker_modifier then
			tracker_modifier:SetStackCount(enemy_damage * self.sac_dagger_dmg_pct * 0.01)
		end
	end
end

--------------------------------
-- LIFE BREAK CHARGE MODIFIER --
--------------------------------

--"This modifier turns him spell immune, disarms him, forces him to face the target and is responsible for the leap animation."
-- I'm gonna put the "forces him to face the target" in the other modifier cause it seems to make sense to just deal with that logic in the motion controller

function modifier_imba_huskar_life_break_charge:IsHidden()		return true end
function modifier_imba_huskar_life_break_charge:IsPurgable()	return false end

function modifier_imba_huskar_life_break_charge:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

function modifier_imba_huskar_life_break_charge:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }

    return decFuncs
end

function modifier_imba_huskar_life_break_charge:GetOverrideAnimation()
	return ACT_DOTA_CAST_LIFE_BREAK_START
end

function modifier_imba_huskar_life_break_charge:GetActivityTranslationModifiers()
	if self:GetStackCount() == 1 then
		return "dominator"
	else
		return ""
	end
end

function modifier_imba_huskar_life_break_charge:OnCreated()
	if IsServer() then
		if BATTLEPASS_HUSKAR and Battlepass:GetRewardUnlocked(self:GetParent():GetPlayerID()) >= BATTLEPASS_HUSKAR["huskar_immortal"] then
			self:SetStackCount(1)
			self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_life_break_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster(), self:GetCaster())
--			ParticleManager:SetParticleControl(self.pfx, 0, self:GetCaster():GetAbsOrigin())
		end
	end
end

function modifier_imba_huskar_life_break_charge:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
	end
end

------------------------------
-- LIFE BREAK SLOW MODIFIER --
------------------------------

function modifier_imba_huskar_life_break_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end

function modifier_imba_huskar_life_break_slow:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.movespeed	= self.ability:GetSpecialValueFor("movespeed")
end

function modifier_imba_huskar_life_break_slow:OnRefresh()
	self:OnCreated()
end

function modifier_imba_huskar_life_break_slow:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return decFuncs
end

function modifier_imba_huskar_life_break_slow:GetModifierMoveSpeedBonus_Percentage()
	-- Casting it on self boosts speed instead of slows
    if self:GetParent() == self:GetCaster() then
		return self.movespeed * (-1)
	else
		return self.movespeed
	end
end

------------------------------------
-- LIFE BREAK SAC DAGGER MODIFIER --
------------------------------------

-- Let's get weird.
function modifier_imba_huskar_life_break_sac_dagger:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_imba_huskar_life_break_sac_dagger:OnCreated(params)
   if not IsServer() then return end
   
	self.random_angle		= params.random_angle
	self.distance			= params.distance
	self.rotation_speed		= params.rotation_speed
	self.contact_radius		= params.contact_radius
	self.damage				= params.damage
	
	self.damage_interval	= 0.1
	self.counter			= 0
	
	self:OnIntervalThink()
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_huskar_life_break_sac_dagger:OnIntervalThink()
	if not IsServer() then return end

	-- Remove if caster died
	if not self:GetCaster():IsAlive() then
		self:Destroy()
	end

	self:GetParent():SetOrigin(self:GetCaster():GetOrigin() + Vector(math.cos(math.rad(self.random_angle)), math.sin(math.rad((self.random_angle)))) * self.distance)

	self.random_angle = self.random_angle + (self.rotation_speed * FrameTime())
	
	-- Make the dagger face the correct direction (for the PA dagger model specifically it has to be rotated 90 degrees after "facing" towards caster)
	local forward_vector = (self:GetCaster():GetOrigin() - self:GetParent():GetOrigin()):Normalized()
	self:GetParent():SetForwardVector(Vector(forward_vector.y, forward_vector.x * (-1), forward_vector.z))
	
	self.counter = self.counter + FrameTime()
	
	if self.counter >= self.damage_interval then
		self.counter = 0
	
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.contact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		for _, enemy in pairs(enemies) do
			-- Apply half the damage as physical
			local damageTable = {
				victim 			= enemy,
				damage 			= self.damage * self.damage_interval * 0.5,
				damage_type		= DAMAGE_TYPE_PHYSICAL,
				damage_flags 	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			}
			ApplyDamage(damageTable)
			
			-- and the other half as magical
			damageTable.damage_type		= DAMAGE_TYPE_MAGICAL
			ApplyDamage(damageTable)
		end
	end
end

-- IDK if I actually need this but when I was testing, Huskar started moving in weird directions if too many daggers were out
function modifier_imba_huskar_life_break_sac_dagger:CheckState()
	local state = {
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}

	return state
end

function modifier_imba_huskar_life_break_sac_dagger:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE
    }

    return decFuncs
end

function modifier_imba_huskar_life_break_sac_dagger:GetModifierModelChange()
	return "models/particle/phantom_assassin_dagger_model.vmdl"
end

-- Arbitrary
function modifier_imba_huskar_life_break_sac_dagger:GetModifierModelScale()
	return 300
end

--------------------------------------------
-- LIFE BREAK SAC DAGGER TRACKER MODIFIER --
--------------------------------------------

-- This is just a QOL modifier to show how much damage the dagger is doing
function modifier_imba_huskar_life_break_sac_dagger_tracker:IsPurgable()	return false end
function modifier_imba_huskar_life_break_sac_dagger_tracker:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_huskar_life_break_sac_dagger_tracker:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_TOOLTIP
    }

    return decFuncs
end

function modifier_imba_huskar_life_break_sac_dagger_tracker:OnTooltip()
	return self:GetStackCount()
end

-------------------------------------------
-- MODIFIER_IMBA_HUSKAR_LIFE_BREAK_TAUNT --
-------------------------------------------

function modifier_imba_huskar_life_break_taunt:IsPurgable()	return false end

function modifier_imba_huskar_life_break_taunt:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

function modifier_imba_huskar_life_break_taunt:OnCreated()
	if not IsServer() then return end
	
	-- This line works for lane/neutral creeps but not for player-controlled units (vanilla and custom included)
	self:GetParent():SetForceAttackTarget(self:GetCaster())
	
	-- This line works for player-controlled units
	self:GetParent():MoveToTargetToAttack(self:GetCaster())
	
	-- In case there's like multiple taunts going on or something
	self:StartIntervalThink(0.1)
end

function modifier_imba_huskar_life_break_taunt:OnIntervalThink()
	self:GetParent():SetForceAttackTarget(self:GetCaster())
end

function modifier_imba_huskar_life_break_taunt:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():SetForceAttackTarget(nil)
end

function modifier_imba_huskar_life_break_taunt:CheckState()
	return {[MODIFIER_STATE_COMMAND_RESTRICTED] = true}
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_huskar_life_break_cast_range", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_huskar_pure_burning_spears", "components/abilities/heroes/hero_huskar", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_huskar_life_break_cast_range	= modifier_special_bonus_imba_huskar_life_break_cast_range or class({})
modifier_special_bonus_imba_huskar_pure_burning_spears		= modifier_special_bonus_imba_huskar_pure_burning_spears or class({})

function modifier_special_bonus_imba_huskar_life_break_cast_range:IsHidden() 		return true end
function modifier_special_bonus_imba_huskar_life_break_cast_range:IsPurgable() 		return false end
function modifier_special_bonus_imba_huskar_life_break_cast_range:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_huskar_pure_burning_spears:IsHidden() 			return true end
function modifier_special_bonus_imba_huskar_pure_burning_spears:IsPurgable() 		return false end
function modifier_special_bonus_imba_huskar_pure_burning_spears:RemoveOnDeath() 	return false end

function imba_huskar_burning_spear:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_huskar_pure_burning_spears") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_huskar_pure_burning_spears") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_huskar_pure_burning_spears"), "modifier_special_bonus_imba_huskar_pure_burning_spears", {})
	end
end

function imba_huskar_life_break:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_huskar_life_break_cast_range") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_huskar_life_break_cast_range") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_huskar_life_break_cast_range"), "modifier_special_bonus_imba_huskar_life_break_cast_range", {})
	end
end
