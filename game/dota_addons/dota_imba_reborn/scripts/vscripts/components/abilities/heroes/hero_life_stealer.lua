-- Creator:
--	   AltiV, May 11th, 2019



-- This file currently only contains "Lua-fication" for Open Wounds (for cosmetic related interactions), and has no IMBAfications.

LinkLuaModifier("modifier_imba_life_stealer_rage", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_rage_insanity", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_life_stealer_feast", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_feast_engorge", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_feast_engorge_counter", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_life_stealer_open_wounds", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_life_stealer_infest", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_infest_effect", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_infest_chestburster", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_life_stealer_control", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_life_stealer_consume", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_life_stealer_assimilate", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_assimilate_effect", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_life_stealer_eject", "components/abilities/heroes/hero_life_stealer", LUA_MODIFIER_MOTION_NONE)

imba_life_stealer_rage								= class({})
modifier_imba_life_stealer_rage						= class({})
modifier_imba_life_stealer_rage_insanity			= class({})

imba_life_stealer_feast								= class({})
modifier_imba_life_stealer_feast					= class({})
modifier_imba_life_stealer_feast_engorge			= class({})
modifier_imba_life_stealer_feast_engorge_counter	= class({})

imba_life_stealer_open_wounds						= class({})
modifier_imba_life_stealer_open_wounds				= class({})

imba_life_stealer_infest 							= class({})
modifier_imba_life_stealer_infest 					= class({})
modifier_imba_life_stealer_infest_effect			= class({})
modifier_imba_life_stealer_infest_chestburster		= class({})

imba_life_stealer_control 							= class({})
modifier_imba_life_stealer_control	 				= class({})

imba_life_stealer_consume 							= class({})
modifier_imba_life_stealer_consume 					= class({})

imba_life_stealer_assimilate 						= class({})
modifier_imba_life_stealer_assimilate 				= modifier_imba_life_stealer_infest
modifier_imba_life_stealer_assimilate_effect		= class({})

imba_life_stealer_assimilate_eject 					= class({})
modifier_imba_life_stealer_assimilate_eject 		= class({})

----------
-- RAGE --
----------

function imba_life_stealer_rage:OnSpellStart()
	self:GetCaster():EmitSound("Hero_LifeStealer.Rage")
	
	self:GetCaster():StartGesture(ACT_DOTA_LIFESTEALER_RAGE)
	
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_rage", {duration = self:GetTalentSpecialValueFor("duration")})
end

-------------------
-- RAGE MODIFIER --
-------------------

function modifier_imba_life_stealer_rage:GetStatusEffectName()
	return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end

function modifier_imba_life_stealer_rage:OnCreated()
	self.attack_speed_bonus	= self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	
	if not IsServer() then return end
	
	local rage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(rage_particle, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	self:AddParticle(rage_particle, false, false, -1, true, false)
end

function modifier_imba_life_stealer_rage:OnRefresh()
	self:OnCreated()
end

function imba_life_stealer_rage:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
	
	return state
end

function imba_life_stealer_rage:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	
	return decFuncs
end

function imba_life_stealer_rage:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_bonus
end

----------------------------
-- RAGE INSANITY MODIFIER --
----------------------------

-----------
-- FEAST --
-----------

function imba_life_stealer_feast:GetIntrinsicModifierName()
	return "modifier_imba_life_stealer_feast"
end

--------------------
-- FEAST MODIFIER --
--------------------

function modifier_imba_life_stealer_feast:OnCreated()
	--print("OnCreated")
end

function modifier_imba_life_stealer_feast:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}
	
	return decFuncs
end

function modifier_imba_life_stealer_feast:GetModifierProcAttack_BonusDamage_Physical(keys)
	-- "Cannot damage and lifesteal off of wards, buildings, Roshan and allied units."
	if keys.target and not keys.target:IsOther() and not keys.target:IsBuilding() and not keys.target:IsRoshan() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		local heal_amount = keys.target:GetMaxHealth() * self:GetAbility():GetTalentSpecialValueFor("hp_leech_percent") * 0.01
		
		local lifesteal_particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(lifesteal_particle)
		
		self:GetParent():Heal(heal_amount, self:GetCaster())
		
		return heal_amount
	end
end

-----------------
-- OPEN WOUNDS --
-----------------

function imba_life_stealer_open_wounds:GetAbilityTextureName()
	if not IsClient() then return end
	if not self:GetCaster().arcana_style then return "life_stealer_open_wounds" end
	if self:GetCaster().arcana_style == 0 then
		return "life_stealer_open_wounds_ti9"
	elseif self:GetCaster().arcana_style == 1 then
		return "life_stealer_open_wounds_ti9_gold"
	end
end

function imba_life_stealer_open_wounds:OnSpellStart()
	if not IsServer() then return end
	
	if self:GetCursorTarget():TriggerSpellAbsorb(self) then return nil end

	self:GetCaster():EmitSound("Hero_LifeStealer.OpenWounds.Cast")
	
	self:GetCursorTarget():EmitSound("Hero_LifeStealer.OpenWounds")
	
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

	local impact_particle = ParticleManager:CreateParticle(CustomNetTables:GetTableValue("battlepass", "life_stealer").open_wounds_impact, PATTACH_ABSORIGIN_FOLLOW, self:GetCursorTarget())
	ParticleManager:ReleaseParticleIndex(impact_particle)
	
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_open_wounds", {duration = self:GetSpecialValueFor("duration")}):SetDuration(self:GetSpecialValueFor("duration") * (1 - self:GetCursorTarget():GetStatusResistance()), true)
end

--------------------------
-- OPEN WOUNDS MODIFIER --
--------------------------

function modifier_imba_life_stealer_open_wounds:GetEffectName()
	return CustomNetTables:GetTableValue("battlepass", "life_stealer").open_wounds
end

function modifier_imba_life_stealer_open_wounds:GetStatusEffectName()
	return CustomNetTables:GetTableValue("battlepass", "life_stealer").open_wounds_status_effect
end

function modifier_imba_life_stealer_open_wounds:OnCreated()
	self.heal_percent	= self:GetAbility():GetTalentSpecialValueFor("heal_percent")
	
	if not IsServer() then return end
	
	self.slow_steps = {}

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
		MODIFIER_EVENT_ON_TAKEDAMAGE
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
	end
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

-- function imba_life_stealer_infest:CastFilterResultTarget(target)
	-- if not IsServer() then return end
	
	-- if target:IsBuilding() then
		-- return UF_FAIL_BUILDING
	-- elseif target:IsRoshan() then
		-- return UF_FAIL_OTHER
	-- elseif target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		-- return UF_SUCCESS
	-- else
		-- return UF_SUCCESS
	-- end
	
	
	-- -- and not target:IsRoshan() and (target:GetTeamNumber() == 
		-- -- -- Self-cast if we have the talent and are currently Berserker's Calling
		-- -- if caster == target and caster:HasTalent("special_bonus_imba_axe_3") and caster:HasModifier("modifier_imba_berserkers_call_buff_armor") then
			-- -- return UF_SUCCESS
		-- -- end
		-- -- return UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
	-- -- end
-- end

function imba_life_stealer_infest:OnSpellStart()
	-- for i = 1, 50 do
		-- print(self:GetCaster():GetTogglableWearable( i ))
	-- end

	local target = self:GetCursorTarget()

	self:GetCaster():EmitSound("Hero_LifeStealer.Infest")
	
	-- TODO: hero response
	
	local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(infest_particle, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(infest_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(infest_particle)
	
	-- "Applies a basic dispel on Lifestealer and disjoints projectiles upon cast."
	--   "This basic dispel removes buffs as well, and not only debuffs."
	self:GetCaster():Purge(true, true, false, false, false)
	ProjectileManager:ProjectileDodge(self:GetCaster())
	
	local infest_effect_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_infest_effect", {})
	
	local infest_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_infest", 
	{
		target_ent		= target:entindex(),
	})
	
	if infest_modifier then
		infest_modifier.effect_modifier = infest_effect_modifier
	end

	-- TODO: Need to make this select the host unit, but cannot be done in lua it seems
	
	-- Hide Rage and Feast abilities
	local rage_ability	= self:GetCaster():FindAbilityByName("imba_life_stealer_rage")
		
	local feast_ability	= self:GetCaster():FindAbilityByName("imba_life_stealer_feast")

	if rage_ability then
		rage_ability:SetHidden(true)
	end
	
	if feast_ability then
		feast_ability:SetHidden(true)
	end
	
	local control_ability	= self:GetCaster():FindAbilityByName("imba_life_stealer_control")
	-- This is usually Open Wounds, but perhaps there will be cases where the ult is given to some other unit, and/or they won't have Open Wounds?...
	local ability_to_swap	= self:GetCaster():GetAbilityByIndex(2)
	
	if control_ability and ability_to_swap then
		if not control_ability:IsTrained() then
			control_ability:SetLevel(1)
		end
		
		if target:IsCreep() then
			control_ability:SetActivated(true)
		else
			control_ability:SetActivated(false)
		end
		
		self:GetCaster():SwapAbilities(ability_to_swap:GetName(), control_ability:GetName(), false, true)
		
		if infest_modifier then
			infest_modifier.ability_to_swap = ability_to_swap
		end
	end	
	
	local consume_ability = self:GetCaster():FindAbilityByName("imba_life_stealer_consume")
	
	if consume_ability then
		if not consume_ability:IsTrained() then
			consume_ability:SetLevel(1)
		end
		
		self:GetCaster():SwapAbilities(self:GetName(), consume_ability:GetName(), false, true)
	end
end

---------------------
-- INFEST MODIFIER --
---------------------

function modifier_imba_life_stealer_infest:OnCreated(params)
			-- "01"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "radius"				"700 700 700"
			-- }
			-- "02"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "damage"				"150 275 400"
			-- }
			-- "03"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "infest_scepter_duration"		"8"
			-- }
			-- "04"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "damage_increase_pct"				"50"
			-- }
			-- "05"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "cast_range_scepter"	"500"
			-- }
			-- "06"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "cooldown_scepter"	"25"
			-- }

	self.radius	= self:GetAbility():GetSpecialValueFor("radius")
	self.damage	= self:GetAbility():GetSpecialValueFor("damage")
	
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
	
	self:GetParent():EmitSound("Hero_LifeStealer.Consume")
	
	local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
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
	
	self:GetParent():RemoveNoDraw()
	-- Wearable:ShowWearables(self:GetParent())
	
	if self.effect_modifier then
		self.effect_modifier:Destroy()
	end

	-- Unhide Rage and Feast abilities
	local rage_ability	= self:GetCaster():FindAbilityByName("imba_life_stealer_rage")
		
	local feast_ability	= self:GetCaster():FindAbilityByName("imba_life_stealer_feast")

	if rage_ability then
		rage_ability:SetHidden(false)
	end
	
	if feast_ability then
		feast_ability:SetHidden(false)
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
end

function modifier_imba_life_stealer_infest:CheckState(keys)
	local state = {
		[MODIFIER_STATE_INVULNERABLE] 						= true,
		[MODIFIER_STATE_OUT_OF_GAME]						= true,
		
		[MODIFIER_STATE_DISARMED]							= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED]					= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]					= true
	}
	
	return state
end

----------------------------
-- INFEST EFFECT MODIFIER --
----------------------------

-- This handles the overhead particle that shows above the host's head

function modifier_imba_life_stealer_infest_effect:IsHidden()		return true end
function modifier_imba_life_stealer_infest_effect:IsPurgable()		return false end

-- If you have multiple people infesting a target somehow, let the particles stack horizontally on top
function modifier_imba_life_stealer_infest_effect:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_life_stealer_infest_effect:ShouldUseOverheadOffset() return true end

function modifier_imba_life_stealer_infest_effect:OnCreated()
	if not IsServer() then return end
	
	local infest_overhead_particle
	
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		infest_overhead_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetParent():GetTeamNumber())
	else
		infest_overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	end
	
	self:AddParticle(infest_overhead_particle, false, false, -1, true, false)
end

----------------------------------
-- INFEST CHESTBURSTER MODIFIER --
----------------------------------

function modifier_imba_life_stealer_infest_chestburster:OnCreated()

end

-------------
-- CONTROL --
-------------

function imba_life_stealer_control:IsStealable()	return false end

function imba_life_stealer_control:OnSpellStart()
	-- ClearTeamCustomHealthbarColor(team: DotaTeam): nil
	-- SetTeamCustomHealthbarColor(team: DotaTeam, r: int, g: int, b: int): nil
end

----------------------
-- CONTROL MODIFIER --
----------------------

function modifier_imba_life_stealer_control:OnCreated()

end

-------------
-- CONSUME --
-------------

function imba_life_stealer_consume:GetAssociatedPrimaryAbilities()
	return "imba_life_stealer_infest"
end

function imba_life_stealer_consume:OnSpellStart()
	local infest_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_life_stealer_infest", self:GetCaster())
	
	if infest_modifier then
		infest_modifier:Destroy()
	end
end

----------------------
-- CONSUME MODIFIER --
----------------------

----------------
-- ASSIMILATE --
----------------

function imba_life_stealer_assimilate:OnInventoryContentsChanged()
	if self:GetCaster():HasScepter() then
		self:SetHidden(false)
		
		if not self:IsTrained() then
			self:SetLevel(1)
		end
	-- Lifestealer technically can't drop scepter once he gets one but I guess this is still appropriate for Io talent tethers
	else
		self:SetHidden(true)
	end
end

function imba_life_stealer_assimilate:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

function imba_life_stealer_assimilate:OnSpellStart()
	local target = self:GetCursorTarget()

	local assimilate_effect_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_assimilate_effect", {})
	
	local assimilate_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_life_stealer_assimilate", 
	{
		target_ent		= target:entindex(),
	})
	
	-- Couple assimilate and the assimilate effect modifiers together so one can destroy the other
	if assimilate_effect_modifier then
		assimilate_effect_modifier.assimilate_modifier	= assimilate_modifier
		assimilate_modifier.assimilate_effect_modifier	= assimilate_effect_modifier
	end
	
	local eject_ability	= self:GetCaster():FindAbilityByName("imba_life_stealer_assimilate_eject")
	
	if eject_ability then
		if not eject_ability:IsTrained() then
			eject_ability:SetLevel(1)
		end
		
		self:GetCaster():SwapAbilities(self:GetName(), eject_ability:GetName(), false, true)
	end	
end

-------------------------
-- ASSIMILATE MODIFIER --
-------------------------

function modifier_imba_life_stealer_assimilate:OnCreated(params)
	if not IsServer() then return end

	local assimilate_ability = self:GetCaster():FindAbilityByName("imba_life_stealer_assimilate")
	
	if not assimilate_ability then self:Destroy() return end

	self.radius	= assimilate_ability:GetSpecialValueFor("radius")
	self.damage	= assimilate_ability:GetSpecialValueFor("damage")

	self.ability_damage_type	= assimilate_ability:GetAbilityDamageType()
	
	self.target_ent	= EntIndexToHScript(params.target_ent)
	self:GetParent():AddNoDraw()
	
	self:StartIntervalThink(0.1)
end

function modifier_imba_life_stealer_assimilate:OnIntervalThink()
	if not IsServer() then return end
	
	self:GetParent():SetAbsOrigin(self.target_ent:GetAbsOrigin())
end


function modifier_imba_life_stealer_assimilate:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():EmitSound("Hero_LifeStealer.Consume")
	
	local assimilate_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(assimilate_particle)
	
	self:GetParent():StartGesture(ACT_DOTA_LIFESTEALER_EJECT)
	
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
	
	self:GetParent():RemoveNoDraw()
	
	if self.assimilate_effect_modifier then
		self.assimilate_effect_modifier:Destroy()
	end
end

function modifier_imba_life_stealer_assimilate:CheckState(keys)
	local state = {
		[MODIFIER_STATE_INVULNERABLE] 						= true,
		[MODIFIER_STATE_OUT_OF_GAME]						= true,
		
		[MODIFIER_STATE_DISARMED]							= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED]					= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]					= true
	}
	
	return state
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
	
	-- TODO: Consider making a re-colored particle for this for QOL
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		assimilate_overhead_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetParent():GetTeamNumber())
	else
		assimilate_overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	end
	
	self:AddParticle(assimilate_overhead_particle, false, false, -1, true, false)
end

function modifier_imba_life_stealer_assimilate_effect:OnDestroy()
	if not IsServer() then return end
	
	local assimilate_effect_modifiers = self:GetCaster():FindAllModifiersByName(self:GetName())
	
	if #assimilate_effect_modifiers <= 0 then
		-- Swap out Assimilate Eject ability back for Assimilate
		local eject_ability = self:GetCaster():FindAbilityByName("imba_life_stealer_assimilate_eject")
		
		if eject_ability and self:GetAbility() then
			self:GetCaster():SwapAbilities(self:GetAbility():GetName(), eject_ability:GetName(), true, false)
		end
	end
end

----------------------
-- ASSIMILATE EJECT --
----------------------

function imba_life_stealer_assimilate_eject:OnSpellStart()
	local assimilate_effect_modifiers = self:GetCaster():FindAllModifiersByName("modifier_imba_life_stealer_assimilate_effect")
	
	for _, modifier in pairs(assimilate_effect_modifiers) do
		local assimilate_modifier = modifier.assimilate_modifier
		
		if assimilate_modifier and assimilate_modifier.Destroy then
			assimilate_modifier:Destroy()
		end
	end
end

-------------------------------
-- ASSIMILATE EJECT MODIFIER --
-------------------------------

