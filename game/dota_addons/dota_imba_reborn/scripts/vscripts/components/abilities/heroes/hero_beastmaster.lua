-- Editors:
--     Fudge, 10.07.2017

-- HELPER FUNCTION

local function UpgradeBeastsSummons(caster, ability)
	local hawk_ability = "imba_beastmaster_summon_hawk"
	local boar_ability = "imba_beastmaster_summon_boar"

	-- Get handles
	local hawk_ability_handler
	local boar_ability_handler
	local raze_far_handler

	if caster:HasAbility(hawk_ability) then
		hawk_ability_handler = caster:FindAbilityByName(hawk_ability)
	end

	if caster:HasAbility(boar_ability) then
		boar_ability_handler = caster:FindAbilityByName(boar_ability)
	end

	-- Get the level to compare
	local leveled_ability_level = ability:GetLevel()

	if hawk_ability_handler and hawk_ability_handler:GetLevel() < leveled_ability_level then
		hawk_ability_handler:SetLevel(leveled_ability_level)
	end

	if boar_ability_handler and boar_ability_handler:GetLevel() < leveled_ability_level then
		boar_ability_handler:SetLevel(leveled_ability_level)
	end
end

---------------------------------------
-------- CALL OF THE WILD: HAWK -------
---------------------------------------
imba_beastmaster_summon_hawk    =   imba_beastmaster_summon_hawk or class({})
LinkLuaModifier("modifier_imba_beastmaster_hawk",  "components/abilities/heroes/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)

function imba_beastmaster_summon_hawk:OnUpgrade()
	UpgradeBeastsSummons(self:GetCaster(), self)
end

function imba_beastmaster_summon_hawk:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster            =   self:GetCaster()
		local hawk_name         =   "npc_imba_dota_beastmaster_hawk_"
		local hawk_level        =   self:GetLevel()
		local spawn_point       =   caster:GetAbsOrigin()
		local spawn_particle    =   "particles/units/heroes/hero_beastmaster/beastmaster_call_bird.vpcf"
		local response          =   "beastmaster_beas_ability_summonsbird_0"
		-- Ability paramaters
		local hawk_duration =   self:GetSpecialValueFor("hawk_duration")


		-- Say response
		caster:EmitSound(response..RandomInt(1,5))
		-- Emit cast sound
		caster:EmitSound("Hero_Beastmaster.Call.Hawk")
		-- Do the summon particle
		local spawn_particle_fx = ParticleManager:CreateParticle(spawn_particle, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl( spawn_particle_fx, 0, spawn_point )

		-- Create hawk
		self.hawk = CreateUnitByName(hawk_name..hawk_level, spawn_point, false, caster, caster, caster:GetTeamNumber())
		self.hawk:AddNewModifier(caster, self, "modifier_imba_beastmaster_hawk", {})
		self.hawk:AddNewModifier(caster, self, "modifier_kill", {duration = hawk_duration})
		self.hawk:SetControllableByPlayer(caster:GetPlayerID(), true)

	end
	local hawk_speed	=	self:GetSpecialValueFor("hawk_speed_tooltip")
	-- Show movespeed beyond max
	self.hawk:SetBaseMoveSpeed(hawk_speed)
end

-----------------
--- Hawk modifier
-----------------

modifier_imba_beastmaster_hawk = modifier_imba_beastmaster_hawk or class({})

-- Modifier properties
function modifier_imba_beastmaster_hawk:IsDebuff() return false end
function modifier_imba_beastmaster_hawk:IsHidden() return true end
function modifier_imba_beastmaster_hawk:IsPurgable() return false end

function modifier_imba_beastmaster_hawk:OnCreated()
	if IsServer() then
		local parent		=	self:GetParent()
		local ability		=	self:GetAbility()
		local invis_ability	=	parent:FindAbilityByName("imba_beastmaster_hawk_invis")

		-- Level the invis ability
		invis_ability:SetLevel(ability:GetLevel() )
	end
end
function modifier_imba_beastmaster_hawk:DeclareFunctions()
	local decFuncs  =   {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
	}
	return decFuncs
end

-- SUPA FAST BIRDS CAW CAW
function modifier_imba_beastmaster_hawk:GetModifierMoveSpeed_Max()
	return 1200
end
--[[
-- Kill hawk when it's duration is over
function modifier_imba_beastmaster_hawk:OnDestroy()
    if IsServer() then
        self:GetParent():EmitSound("Hero_Beastmaster_Bird.Death")
        self:GetParent():ForceKill(false)
    end
end
]]
-----------------------------------------------------
-------- CALL OF THE WILD: HAWK: Invisibility -------
-----------------------------------------------------
imba_beastmaster_hawk_invis = imba_beastmaster_hawk_invis or class({})

LinkLuaModifier("modifier_imba_hawk_invis_handler",  "components/abilities/heroes/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hawk_invis",  "components/abilities/heroes/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)

function imba_beastmaster_hawk_invis:GetIntrinsicModifierName()
	return "modifier_imba_hawk_invis_handler"
end

----------------------
--- Hawk invis checker
----------------------
modifier_imba_hawk_invis_handler = modifier_imba_hawk_invis_handler or class({})

function modifier_imba_hawk_invis_handler:IsPurgable() return false end
function modifier_imba_hawk_invis_handler:IsDebuff() return false end
function modifier_imba_hawk_invis_handler:IsHidden() return true end

function modifier_imba_hawk_invis_handler:OnCreated()
	if IsServer() then
		local ability	=	self:GetAbility()
		ability:StartCooldown(ability:GetSpecialValueFor("fade_time") )

		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_hawk_invis_handler:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local fade_time = ability:GetSpecialValueFor("fade_time")

		-- If the passive cooldown is ready
		if ability:IsCooldownReady() then
			if not parent:HasModifier("modifier_imba_hawk_invis") then
				parent:AddNewModifier(parent, ability, "modifier_imba_hawk_invis", {})
			end

			-- If the passive is on cooldown, remove the invis modifier
		elseif parent:HasModifier("modifier_imba_hawk_invis") then
			parent:RemoveModifierByName("modifier_imba_hawk_invis")
		end
	end
end

function modifier_imba_hawk_invis_handler:DeclareFunctions()
	local funcs = { MODIFIER_EVENT_ON_UNIT_MOVED}
	return funcs
end

function modifier_imba_hawk_invis_handler:OnUnitMoved(keys)
	if IsServer() then
		if keys.unit	==	self:GetParent() then
			local ability = self:GetAbility()
			local fade_time = ability:GetSpecialValueFor("fade_time")

			-- Refresh the timer on the invis
			if ability:GetCooldownTimeRemaining() < fade_time * 0.9 then
				ability:StartCooldown(fade_time)
			end
		end
	end
end

---------------
--- Hawk invis
---------------
modifier_imba_hawk_invis	=	modifier_imba_hawk_invis or class({})

function modifier_imba_hawk_invis:IsPurgable() return false end
function modifier_imba_hawk_invis:IsDebuff() return false end
function modifier_imba_hawk_invis:IsHidden() return false end

function modifier_imba_hawk_invis:OnCreated()
	local particle = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:ReleaseParticleIndex(particle)
end

function modifier_imba_hawk_invis:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_INVISIBILITY_LEVEL, }
	return funcs
end

function modifier_imba_hawk_invis:GetModifierInvisibilityLevel()
	if IsClient() then
		return 1
	end
end

function modifier_imba_hawk_invis:CheckState()
	if IsServer() then
		local state = { [MODIFIER_STATE_INVISIBLE] = true}
		return state
	end
end

function modifier_imba_hawk_invis:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end

---------------------------------------
-------- CALL OF THE WILD: BOAR -------
---------------------------------------

imba_beastmaster_summon_boar = imba_beastmaster_summon_boar or class({})

LinkLuaModifier("modifier_imba_beastmaster_boar",  "components/abilities/heroes/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)

function imba_beastmaster_summon_boar:OnUpgrade()
	UpgradeBeastsSummons(self:GetCaster(), self)
end

function imba_beastmaster_summon_boar:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster            =   self:GetCaster()
		local boar_name         =   "npc_imba_dota_beastmaster_boar_"
		local boar_level        =   self:GetLevel()
		local spawn_point       =   caster:GetAbsOrigin()
		local spawn_particle    =   "particles/units/heroes/hero_beastmaster/beastmaster_call_boar.vpcf"
		local response          =   "beastmaster_beas_ability_summonsboar_0"
		-- Ability paramaters
		local boar_duration =   self:GetSpecialValueFor("boar_duration")

		-- Say response
		caster:EmitSound(response..RandomInt(1,5))
		-- Emit cast sound
		caster:EmitSound("Hero_Beastmaster.Call.Boar")
		-- Do the summon particle
		local spawn_particle_fx = ParticleManager:CreateParticle(spawn_particle, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl( spawn_particle_fx, 0, spawn_point )

		-- Moar Boar talent
		local boar_count = 1
		if caster:HasAbility("special_bonus_unique_beastmaster_2") then
			local talent_handler = caster:FindAbilityByName("special_bonus_unique_beastmaster_2")
			if talent_handler and talent_handler:GetLevel() > 0 then
				local additional_boars = talent_handler:GetSpecialValueFor("value")
				if additional_boars then
					boar_count = boar_count + additional_boars
				end
			end
		end

		for i = 1, boar_count do
			-- Create boar
			boar = CreateUnitByName(boar_name..boar_level, spawn_point, true, caster, caster, caster:GetTeamNumber())
			boar:AddNewModifier(caster, self, "modifier_imba_beastmaster_boar", {})
			boar:AddNewModifier(caster, self, "modifier_kill", {duration = boar_duration})

			boar:SetControllableByPlayer(caster:GetPlayerID(), true)
		end
	end
end

-----------------
--- Boar modifier
-----------------

modifier_imba_beastmaster_boar = modifier_imba_beastmaster_boar or class({})



-- Modifier properties
function modifier_imba_beastmaster_boar:IsDebuff() return false end
function modifier_imba_beastmaster_boar:IsHidden() return true end
function modifier_imba_beastmaster_boar:IsPurgable() return false end

function modifier_imba_beastmaster_boar:OnCreated()
	if IsServer() then
		local parent			=	self:GetParent()
		local ability			=	self:GetAbility()
		local poison_ability	=	parent:FindAbilityByName("imba_beastmaster_boar_poison")

		-- Level the poison ability
		poison_ability:SetLevel(ability:GetLevel() )
	end
end

function modifier_imba_beastmaster_boar:DeclareFunctions()
	local decFuncs  =   {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
	}
	return decFuncs
end

-- Kill boar when it's duration is over
function modifier_imba_beastmaster_boar:OnDestroy()
	if IsServer() then
		self:GetParent():EmitSound("Hero_Beastmaster_Boar.Death")
		self:GetParent():ForceKill(false)
	end
end

-----------------------------------------------
-------- CALL OF THE WILD: BOAR: POISON -------
-----------------------------------------------

imba_beastmaster_boar_poison = imba_beastmaster_boar_poison or class({})

LinkLuaModifier("modifier_imba_boar_poison" , "components/abilities/heroes/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_boar_poison_debuff" , "components/abilities/heroes/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)

function imba_beastmaster_boar_poison:GetIntrinsicModifierName()
	return "modifier_imba_boar_poison"
end

modifier_imba_boar_poison = modifier_imba_boar_poison or class({})

-- Modifier properties
function modifier_imba_boar_poison:IsDebuff() return false end
function modifier_imba_boar_poison:IsHidden() return true end
function modifier_imba_boar_poison:IsPurgable() return false end

function modifier_imba_boar_poison:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return decFuncs
end

function modifier_imba_boar_poison:OnAttackLanded(params)
	if IsServer() then
		-- Ability properties
		local target 	=	 params.target
		local parent	=	self:GetParent()
		local ability	=	self:GetAbility()
		-- Ability paramaters
		local duration	=	ability:GetSpecialValueFor("duration")
		-- When the boar attacks a target, apply poison on the target.
		if (parent == params.attacker) then
			if (target:IsCreep() or target:IsHero()) and not target:IsBuilding() then
				target:AddNewModifier(parent, ability, "modifier_imba_boar_poison_debuff", {duration = duration})
			end
		end
	end
end

modifier_imba_boar_poison_debuff = modifier_imba_boar_poison_debuff or class({})

-- Modifier properties
function modifier_imba_boar_poison_debuff:IsDebuff() return true end
function modifier_imba_boar_poison_debuff:IsHidden() return false end
function modifier_imba_boar_poison_debuff:IsPurgable() return true end

function modifier_imba_boar_poison_debuff:OnCreated()
	-- Necessary client-side handling
	-- Ability properties
	local ability		=	self:GetAbility()
	-- Ability paramaters
	self.movespeed_slow		=	ability:GetSpecialValueFor("movespeed_slow")
	self.attackspeed_slow	=	ability:GetSpecialValueFor("attackspeed_slow")
end

function modifier_imba_boar_poison_debuff:DeclareFunctions()
	local decFuncs ={
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return decFuncs
end

function modifier_imba_boar_poison_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_slow * (-1)
end

function modifier_imba_boar_poison_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed_slow * (-1)
end

