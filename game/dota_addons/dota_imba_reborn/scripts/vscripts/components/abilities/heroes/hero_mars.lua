-- THIS FILE IS CURRENTLY JUST TO ADD A MEME FACTOR; IT DOESN'T HAVE ANY CUSTOM SKILLS/IMBAFICATIONS RIGHT NOW

-- Creator:
--	   AltiV, March 16th, 2019

LinkLuaModifier("modifier_imba_mars_arena_of_blood_enhance", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mars_arena_of_blood_thinker", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mars_arena_of_blood_thinker_debuff", "components/abilities/heroes/hero_mars", LUA_MODIFIER_MOTION_NONE)

imba_mars_arena_of_blood_enhance					= imba_mars_arena_of_blood_enhance or class({})
modifier_imba_mars_arena_of_blood_enhance			= modifier_imba_mars_arena_of_blood_enhance or class({})

modifier_imba_mars_arena_of_blood_thinker			= modifier_imba_mars_arena_of_blood_thinker or class({})
modifier_imba_mars_arena_of_blood_thinker_debuff	= modifier_imba_mars_arena_of_blood_thinker_debuff or class({})

----------------------------
-- Arena of Blood ENHANCE --
----------------------------

function imba_mars_arena_of_blood_enhance:IsInnateAbility() return true end

function imba_mars_arena_of_blood_enhance:GetIntrinsicModifierName()
	return "modifier_imba_mars_arena_of_blood_enhance"
end

-------------------------------------
-- Arena of Blood ENHANCE Modifier --
-------------------------------------

function modifier_imba_mars_arena_of_blood_enhance:IsHidden()	return true end

function modifier_imba_mars_arena_of_blood_enhance:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_SCALE,
		
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
end

function modifier_imba_mars_arena_of_blood_enhance:GetModifierModelScale(keys)
	if self:GetParent():HasModifier("modifier_mars_arena_of_blood_animation") then
		return self:GetAbility():GetSpecialValueFor("expansion_pct")
	end
end

function modifier_imba_mars_arena_of_blood_enhance:OnAbilityFullyCast(keys)
	if keys.unit == self:GetParent() and keys.ability:GetName() == "mars_arena_of_blood" and keys.ability:GetCursorPosition() then
		local aura_thinker = CreateModifierThinker(
			self:GetCaster(),
			self:GetAbility(),
			"modifier_imba_mars_arena_of_blood_thinker",
			{
				duration			= keys.ability:GetSpecialValueFor("formation_time") + keys.ability:GetSpecialValueFor("duration"),
				ability_entindex	= keys.ability:entindex()
			},
			keys.ability:GetCursorPosition(),
			self:GetCaster():GetTeamNumber(),
			false
		)
	end
end

-----------------------------------------------
-- MODIFIER_IMBA_MARS_ARENA_OF_BLOOD_THINKER --
-----------------------------------------------

function modifier_imba_mars_arena_of_blood_thinker:OnCreated(keys)
	if not IsServer() then return end
	
	if keys.ability_entindex and EntIndexToHScript(keys.ability_entindex) then
		self.arena_ability	= EntIndexToHScript(keys.ability_entindex)
		
		self.duration		= self.arena_ability:GetSpecialValueFor("duration")
		self.radius			= self.arena_ability:GetSpecialValueFor("radius")
		self.width			= self.arena_ability:GetSpecialValueFor("width")
		self.formation_time	= self.arena_ability:GetSpecialValueFor("formation_time")
	else
		self:Destroy()
	end
end

function modifier_imba_mars_arena_of_blood_thinker:IsHidden()				return true end

function modifier_imba_mars_arena_of_blood_thinker:IsAura() 				return self.formation_time and self:GetElapsedTime() >= self.formation_time end
function modifier_imba_mars_arena_of_blood_thinker:IsAuraActiveOnDeath()	return false end

function modifier_imba_mars_arena_of_blood_thinker:GetAuraRadius()			return self.radius or 0 end
function modifier_imba_mars_arena_of_blood_thinker:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end

function modifier_imba_mars_arena_of_blood_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_mars_arena_of_blood_thinker:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_mars_arena_of_blood_thinker:GetModifierAura()		return "modifier_imba_mars_arena_of_blood_thinker_debuff" end

function modifier_imba_mars_arena_of_blood_thinker:GetAuraEntityReject(target)	return target:HasFlyMovementCapability() end

------------------------------------------------------
-- MODIFIER_IMBA_MARS_ARENA_OF_BLOOD_THINKER_DEBUFF --
------------------------------------------------------

function modifier_imba_mars_arena_of_blood_thinker_debuff:IsHidden()	return true end

function modifier_imba_mars_arena_of_blood_thinker_debuff:OnCreated()
	if not IsServer() or not self:GetAuraOwner():HasModifier("modifier_imba_mars_arena_of_blood_thinker") then return end

	self.area_center	= self:GetAuraOwner():GetAbsOrigin()
	
	self.aura_modifier	= self:GetAuraOwner():FindModifierByName("modifier_imba_mars_arena_of_blood_thinker")
	
	if self.aura_modifier then
		self.duration		= self.aura_modifier.duration
		self.radius			= self.aura_modifier.radius
		self.width			= self.aura_modifier.width
		self.formation_time	= self.aura_modifier.formation_time
	else
		self:Destroy()
	end
end

-- IMBAfication: Ultra-Gravity
function modifier_imba_mars_arena_of_blood_thinker_debuff:CheckState()
	return {[MODIFIER_STATE_TETHERED] = true}
end

-- IMBAfication: Hardened Walls
function modifier_imba_mars_arena_of_blood_thinker_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_LIMIT}
end

function modifier_imba_mars_arena_of_blood_thinker_debuff:GetModifierMoveSpeed_Limit()
	if not IsServer() or not self:GetParent():IsMagicImmune() then return end
	
	-- A R B I T R A R Y   A N G L E
	if (self:GetParent():GetAbsOrigin() - self.area_center):Length2D() >= self.radius - self.width and math.abs(AngleDiff(VectorToAngles(self:GetParent():GetAbsOrigin() - self.area_center).y, VectorToAngles(self:GetParent():GetForwardVector() ).y)) <= 85 then
		return -0.01
	end
end
