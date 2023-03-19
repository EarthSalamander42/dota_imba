-- Creator:
--		EarthSalamander, October 3rd, 2019
--       AltiV, January 18th, 2020

-- Editors:
-- 		Shush, April 14th, 2020


---------------------
-- HELPER FUNCTION --
---------------------

function IsSpiderling(unit)
	if unit:GetUnitName() == "npc_dota_broodmother_spiderking" or unit:GetUnitName() == "npc_dota_broodmother_spiderling" then
		return true
	else
		return false
	end
end

-----------------------
-- SPAWN SPIDERLINGS --
-----------------------

LinkLuaModifier("modifier_imba_broodmother_spawn_spiderlings", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_spawn_spiderlings_avenger", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_spawn_spiderlings_avenger_buff", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)

imba_broodmother_spawn_spiderlings = imba_broodmother_spawn_spiderlings or class({})

function imba_broodmother_spawn_spiderlings:GetAssociatedPrimaryAbilities()
	return "imba_broodmother_spawn_spiderking"
end

function imba_broodmother_spawn_spiderlings:OnUpgrade()
	if not IsServer() then return end

	-- Find and upgrade the Spawn Spiderking ability whenever you level Spawn Spiderling
	local caster = self:GetCaster()
	local ability = self
	local ability_spiderking_name = "imba_broodmother_spawn_spiderking"

	local ability_spiderking = caster:FindAbilityByName(ability_spiderking_name)
	if ability_spiderking then
		ability_spiderking:SetLevel(ability:GetLevel())
	end
end

function imba_broodmother_spawn_spiderlings:GetIntrinsicModifierName()
	return "modifier_imba_broodmother_spawn_spiderlings_avenger"
end

function imba_broodmother_spawn_spiderlings:OnSpellStart()
	-- lycosidae effects
	-- particles/econ/items/broodmother/bm_lycosidaes/bm_lycosidaes_web_cast.vpcf
	-- particles/econ/items/broodmother/bm_lycosidaes/bm_lycosidaes_spiderlings_debuff.vpcf

	local info = {
		Source = self:GetCaster(),
		Target = self:GetCursorTarget(),
		Ability = self,
		bDodgeable = true,
		EffectName = "particles/units/heroes/hero_broodmother/broodmother_web_cast.vpcf",
		iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
	}

	ProjectileManager:CreateTrackingProjectile(info)

	self:GetCaster():EmitSound("Hero_Broodmother.SpawnSpiderlingsCast")
end

function imba_broodmother_spawn_spiderlings:OnProjectileHit(hTarget, vLocation)
	if not hTarget then return nil end

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_spawn = "modifier_imba_broodmother_spawn_spiderlings"

	-- Ability specials
	local buff_duration = ability:GetSpecialValueFor("buff_duration")
	local damage = ability:GetSpecialValueFor("damage")

	hTarget:AddNewModifier(caster, self, modifier_spawn, { duration = self:GetSpecialValueFor("buff_duration") * (1 - hTarget:GetStatusResistance()) })

	ApplyDamage({
		attacker = caster,
		victim = hTarget,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		damage_flags = self:GetAbilityTargetFlags()
	})

	hTarget:EmitSound("Hero_Broodmother.SpawnSpiderlingsImpact")
end

------------------------------
-- SPAWN SPIDERLINGS DEBUFF --
------------------------------

modifier_imba_broodmother_spawn_spiderlings = modifier_imba_broodmother_spawn_spiderlings or class({})

function modifier_imba_broodmother_spawn_spiderlings:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.count = self.ability:GetSpecialValueFor("count")
	self.spiderling_duration = self.ability:GetSpecialValueFor("spiderling_duration")
end

function modifier_imba_broodmother_spawn_spiderlings:IsDebuff() return true end

function modifier_imba_broodmother_spawn_spiderlings:GetEffectName() return "particles/units/heroes/hero_broodmother/broodmother_spiderlings_debuff.vpcf" end

function modifier_imba_broodmother_spawn_spiderlings:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_broodmother_spawn_spiderlings:OnDestroy()
	if not IsServer() then return end
	if not self:GetAbility() then return end

	if not self.parent:IsAlive() then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_broodmother/broodmother_spiderlings_spawn.vpcf", PATTACH_ABSORIGIN, self.parent)
		ParticleManager:SetParticleControl(pfx, 0, self.parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)
		self.parent:EmitSound("Hero_Broodmother.SpawnSpiderlings")

		for i = 1, self.count do
			local spiderling = CreateUnitByName("npc_dota_broodmother_spiderling", self.parent:GetAbsOrigin(), false, self.caster, self.caster, self.caster:GetTeamNumber())
			spiderling:SetOwner(self.caster)
			spiderling:SetControllableByPlayer(self.caster:GetPlayerID(), false)
			spiderling:SetUnitOnClearGround()
			spiderling:AddNewModifier(self.caster, self.ability, "modifier_kill", { duration = self.spiderling_duration })
			self.parent:EmitSound("Hero_Broodmother.SpawnSpiderlings")

			local ability_level = self.ability:GetLevel()

			for i = 0, spiderling:GetAbilityCount() - 1 do
				local ability = spiderling:GetAbilityByIndex(i)

				if ability then
					ability:SetLevel(ability_level)
				end
			end
		end
	end
end

--------------------------------------
-- SPAWN SPIDERLING AVENGER THINKER --
--------------------------------------

modifier_imba_broodmother_spawn_spiderlings_avenger = modifier_imba_broodmother_spawn_spiderlings_avenger or class({})

function modifier_imba_broodmother_spawn_spiderlings_avenger:IsDebuff() return false end

function modifier_imba_broodmother_spawn_spiderlings_avenger:IsPurgable() return false end

function modifier_imba_broodmother_spawn_spiderlings_avenger:IsHidden() return true end

function modifier_imba_broodmother_spawn_spiderlings_avenger:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_avenger = "modifier_imba_broodmother_spawn_spiderlings_avenger_buff"

	-- Ability specials
	self.avenger_radius = self.ability:GetSpecialValueFor("avenger_radius")
	self.avenger_duration = self.ability:GetSpecialValueFor("avenger_duration")
end

function modifier_imba_broodmother_spawn_spiderlings_avenger:DeclareFunctions()
	local funcs = { MODIFIER_EVENT_ON_DEATH }

	return funcs
end

function modifier_imba_broodmother_spawn_spiderlings_avenger:OnDeath(keys)
	if not IsServer() then return end

	local dead_unit = keys.unit

	-- Only apply if the dead unit is either a spiderling or a spiderking
	-- Do not apply on self kills done by modifier kill	
	if IsSpiderling(dead_unit) and keys.attacker ~= dead_unit and dead_unit:GetOwner() == self.caster then
		-- Check if Broodmother is in range
		local distance = (dead_unit:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D()

		if distance <= self.avenger_radius then
			-- If caster has Avenger, increase stack and refresh
			if self.caster:HasModifier(self.modifier_avenger) then
				local modifier = self.caster:FindModifierByName(self.modifier_avenger)
				modifier:IncrementStackCount()
				modifier:ForceRefresh()
			else
				-- Otherwise, give Avenger buff with 1 stack
				local modifier = self.caster:AddNewModifier(self.caster, self.ability, self.modifier_avenger, { duration = self.avenger_duration })
				modifier:IncrementStackCount()
			end
		end
	end
end

-----------------------------------
-- SPAWN SPIDERLING AVENGER BUFF --
-----------------------------------

modifier_imba_broodmother_spawn_spiderlings_avenger_buff = modifier_imba_broodmother_spawn_spiderlings_avenger_buff or class({})

function modifier_imba_broodmother_spawn_spiderlings_avenger_buff:IsDebuff() return false end

function modifier_imba_broodmother_spawn_spiderlings_avenger_buff:IsPurgable() return true end

function modifier_imba_broodmother_spawn_spiderlings_avenger_buff:IsHidden() return false end

function modifier_imba_broodmother_spawn_spiderlings_avenger_buff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.avenger_damage_pct = self.ability:GetSpecialValueFor("avenger_damage_pct")
end

function modifier_imba_broodmother_spawn_spiderlings_avenger_buff:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE }

	return funcs
end

function modifier_imba_broodmother_spawn_spiderlings_avenger_buff:GetModifierBaseDamageOutgoing_Percentage()
	return self.avenger_damage_pct * self:GetStackCount()
end

--------------
-- SPIN WEB --
--------------

LinkLuaModifier("modifier_imba_broodmother_spin_web_aura", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_spin_web", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_spin_web_aura_enemy", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_spin_web_enemy", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_spin_web_sense", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_charges", "components/modifiers/generic/modifier_generic_charges", LUA_MODIFIER_MOTION_NONE)

imba_broodmother_spin_web = imba_broodmother_spin_web or class({})

function imba_broodmother_spin_web:GetCastRange(location, target)
	if IsServer() then
		if IsNearEntity("npc_dota_broodmother_web", location, self:GetSpecialValueFor("radius") * 2, self:GetCaster()) then
			return 25000
		end
	end

	return self.BaseClass.GetCastRange(self, location, target)
end

function imba_broodmother_spin_web:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_broodmother_spin_web:OnUpgrade()
	if not IsServer() then return end

	if self:GetLevel() == 1 then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_charges", {})
	else
		charges_modifier = self:GetCaster():FindModifierByName("modifier_generic_charges")

		if charges_modifier then
			charges_modifier:OnRefresh({ bonus_charges = self:GetLevelSpecialValueFor("max_charges", 1) })
		end
	end
end

function imba_broodmother_spin_web:OnSpellStart()
	if not IsServer() then return end

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = ability:GetCursorPosition()
	local modifier_aura_friendly = "modifier_imba_broodmother_spin_web_aura"
	local modifier_aura_enemy = "modifier_imba_broodmother_spin_web_aura_enemy"

	-- Ability specials
	local count = ability:GetSpecialValueFor("count")

	-- Scepter specials
	local count_scepter = ability:GetSpecialValueFor("count_scepter")

	-- Adjust web count according to scepter bonus
	local web_count = count
	if caster:HasScepter() then
		web_count = count_scepter
	end

	-- Find all webs
	local webs = Entities:FindAllByClassname("npc_dota_broodmother_web")

	-- Remove oldest web
	if #webs >= web_count then
		local table_position = nil
		local oldest_web = nil

		for k, web in pairs(webs) do
			if table_position == nil then table_position = k end
			if oldest_web == nil then oldest_web = web end

			if web.spawn_time < oldest_web.spawn_time then
				oldest_web = web
				table_position = k
			end
		end

		if IsValidEntity(oldest_web) and oldest_web:IsAlive() then
			oldest_web:ForceKill(false)
		end
	end

	local web = CreateUnitByName("npc_dota_broodmother_web", target_point, false, caster, caster, caster:GetTeamNumber())
	web:AddNewModifier(caster, ability, modifier_aura_friendly, {})
	web:AddNewModifier(caster, ability, modifier_aura_enemy, {})
	web:SetOwner(caster)
	web:SetControllableByPlayer(caster:GetPlayerID(), false)
	web.spawn_time = math.floor(GameRules:GetDOTATime(false, false))

	for i = 0, web:GetAbilityCount() - 1 do
		local ability = web:GetAbilityByIndex(i)

		if ability then
			ability:SetLevel(1)
		end
	end

	caster:EmitSound("Hero_Broodmother.SpinWebCast")
end

-------------------------------------
-- SPIN WEB FRIENDLY AURA MODIFIER --
-------------------------------------

modifier_imba_broodmother_spin_web_aura = modifier_imba_broodmother_spin_web_aura or class({})

function modifier_imba_broodmother_spin_web_aura:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")

	if IsServer() then
		self:GetParent():EmitSound("Hero_Broodmother.WebLoop")
	end
end

function modifier_imba_broodmother_spin_web_aura:IsAura() return true end

function modifier_imba_broodmother_spin_web_aura:GetAuraDuration() return 0.2 end

function modifier_imba_broodmother_spin_web_aura:GetAuraRadius() return self.radius end

function modifier_imba_broodmother_spin_web_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED end

function modifier_imba_broodmother_spin_web_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_imba_broodmother_spin_web_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_imba_broodmother_spin_web_aura:GetModifierAura() return "modifier_imba_broodmother_spin_web" end

function modifier_imba_broodmother_spin_web_aura:IsHidden() return true end

function modifier_imba_broodmother_spin_web_aura:IsPurgable() return false end

function modifier_imba_broodmother_spin_web_aura:IsPurgeException() return false end

function modifier_imba_broodmother_spin_web_aura:RemoveOnDeath() return true end

function modifier_imba_broodmother_spin_web_aura:GetAuraEntityReject(hTarget)
	if not IsServer() then return end

	if hTarget == self:GetCaster() or IsSpiderling(hTarget) then
		return false
	end

	return true
end

function modifier_imba_broodmother_spin_web_aura:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end

function modifier_imba_broodmother_spin_web_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}
end

function modifier_imba_broodmother_spin_web_aura:GetModifierProvidesFOWVision()
	return 1
end

function modifier_imba_broodmother_spin_web_aura:OnDeath(params)
	if not IsServer() then return end

	if params.unit == self:GetParent() then
		self:GetParent():StopSound("Hero_Broodmother.WebLoop")
		UTIL_Remove(self:GetParent())
	end
end

--------------------------------
-- SPIN WEB FRIENDLY MODIFIER --
--------------------------------

modifier_imba_broodmother_spin_web = modifier_imba_broodmother_spin_web or class({})

function modifier_imba_broodmother_spin_web:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.health_regen = self.ability:GetSpecialValueFor("health_regen")
	self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
	self.web_menuever_dmg_pct = self.ability:GetSpecialValueFor("web_menuever_dmg_pct")

	-- Scepter specials
	self.bonus_movespeed_scepter = self.ability:GetSpecialValueFor("bonus_movespeed_scepter")
end

function modifier_imba_broodmother_spin_web:IsPurgable() return false end

function modifier_imba_broodmother_spin_web:IsPurgeException() return false end

function modifier_imba_broodmother_spin_web:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end

function modifier_imba_broodmother_spin_web:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}
end

function modifier_imba_broodmother_spin_web:GetModifierConstantHealthRegen()
	return self.health_regen
end

function modifier_imba_broodmother_spin_web:GetModifierMoveSpeedBonus_Percentage()
	if self.caster:HasScepter() then
		return self.bonus_movespeed_scepter
	end

	return self.bonus_movespeed
end

function modifier_imba_broodmother_spin_web:GetModifierIncomingDamage_Percentage()
	if IsSpiderling(self.parent) then
		return self.web_menuever_dmg_pct * (-1)
	end

	return 0
end

function modifier_imba_broodmother_spin_web:GetModifierIgnoreMovespeedLimit()
	if self.caster:HasScepter() then
		return 1
	end

	return 0
end

modifier_imba_broodmother_spin_web_aura_enemy = modifier_imba_broodmother_spin_web_aura_enemy or class({})

function modifier_imba_broodmother_spin_web_aura_enemy:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_imba_broodmother_spin_web_aura_enemy:IsAura() return true end

function modifier_imba_broodmother_spin_web_aura_enemy:GetAuraDuration() return 0.5 end

function modifier_imba_broodmother_spin_web_aura_enemy:GetAuraRadius() return self.radius end

function modifier_imba_broodmother_spin_web_aura_enemy:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_imba_broodmother_spin_web_aura_enemy:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_imba_broodmother_spin_web_aura_enemy:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_imba_broodmother_spin_web_aura_enemy:GetModifierAura() return "modifier_imba_broodmother_spin_web_enemy" end

function modifier_imba_broodmother_spin_web_aura_enemy:IsHidden() return true end

function modifier_imba_broodmother_spin_web_aura_enemy:IsPurgable() return false end

function modifier_imba_broodmother_spin_web_aura_enemy:IsPurgeException() return false end

function modifier_imba_broodmother_spin_web_aura_enemy:RemoveOnDeath() return true end

-----------------------------
-- SPIN WEB ENEMY MODIFIER --
-----------------------------

modifier_imba_broodmother_spin_web_enemy = modifier_imba_broodmother_spin_web_enemy or class({})

function modifier_imba_broodmother_spin_web_enemy:IsHidden() return true end

function modifier_imba_broodmother_spin_web_enemy:IsPurgable() return false end

function modifier_imba_broodmother_spin_web_enemy:IsDebuff() return true end

function modifier_imba_broodmother_spin_web_enemy:OnCreated()
	if IsServer() then
		if not self:GetAbility() then return end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.web_sense_modifier = "modifier_imba_broodmother_spin_web_sense"

	-- Ability specials
	self.web_sense_duration = self.ability:GetSpecialValueFor("web_sense_duration")

	if IsServer() then
		if not self.parent:HasModifier(self.web_sense_modifier) then
			self.parent:AddNewModifier(self.caster, self.ability, self.web_sense_modifier, { duration = self.web_sense_duration })
		end
	end
end

-- End Web Sense if prematurely if needed
function modifier_imba_broodmother_spin_web_enemy:OnDestroy()
	if IsServer() then
		if self.parent:HasModifier(self.web_sense_modifier) then
			self.parent:RemoveModifierByName(self.web_sense_modifier)
		end
	end
end

------------------------------
-- SPIN WEB ENEMY WEB SENSE --
------------------------------

modifier_imba_broodmother_spin_web_sense = modifier_imba_broodmother_spin_web_sense or class({})

function modifier_imba_broodmother_spin_web_sense:IsHidden() return true end

function modifier_imba_broodmother_spin_web_sense:IsPurgable() return false end

function modifier_imba_broodmother_spin_web_sense:IsDebuff() return true end

function modifier_imba_broodmother_spin_web_sense:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
end

function modifier_imba_broodmother_spin_web_sense:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_PROVIDES_FOW_POSITION }

	return funcs
end

function modifier_imba_broodmother_spin_web_sense:GetModifierProvidesFOWVision()
	return 1
end

-------------------------
-- INCAPACITATING BITE --
-------------------------


LinkLuaModifier("modifier_imba_broodmother_incapacitating_bite", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_incapacitating_bite_orb", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_incapacitating_bite_webbed_up_counter", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_incapacitating_bite_webbed_up_debuff", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)

imba_broodmother_incapacitating_bite = imba_broodmother_incapacitating_bite or class({})

function imba_broodmother_incapacitating_bite:GetIntrinsicModifierName()
	return "modifier_imba_broodmother_incapacitating_bite"
end

-----------------------------------------
-- INCAPACITATING BITE ATTACK MODIFIER --
-----------------------------------------

modifier_imba_broodmother_incapacitating_bite = modifier_imba_broodmother_incapacitating_bite or class({})

function modifier_imba_broodmother_incapacitating_bite:IsHidden() return true end

function modifier_imba_broodmother_incapacitating_bite:IsPurgable() return false end

function modifier_imba_broodmother_incapacitating_bite:IsDebuff() return false end

function modifier_imba_broodmother_incapacitating_bite:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_bite = "modifier_imba_broodmother_incapacitating_bite_orb"
	self.modifier_web = "modifier_imba_broodmother_spin_web_enemy"
	self.modifier_webbed_up = "modifier_imba_broodmother_incapacitating_bite_webbed_up_counter"

	-- Ability specials
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.web_up_counter_duration = self.ability:GetSpecialValueFor("web_up_counter_duration")
	self.web_up_stacks_hero = self.ability:GetSpecialValueFor("web_up_stacks_hero")
	self.web_up_stacks_spider = self.ability:GetSpecialValueFor("web_up_stacks_spider")
end

function modifier_imba_broodmother_incapacitating_bite:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_imba_broodmother_incapacitating_bite:OnAttackLanded(keys)
	if not IsServer() then return end

	local target = keys.target
	local attacker = keys.attacker

	-- Does not affect wards, buildings, or allied units
	if target:IsOther() or target:IsBuilding() or target:GetTeamNumber() == attacker:GetTeamNumber() then
		return nil
	end

	-- Apply incapacitating bite regular
	if self.caster == attacker then
		target:AddNewModifier(self.caster, self.ability, self.modifier_bite, { duration = self.duration * (1 - target:GetStatusResistance()) })
	end

	-- If the attacker is either Broodmother or Spiderling, and the target is standing on a web, apply Webbed Up modifier, or increment stack count according to unit type
	if target:HasModifier(self.modifier_web) then
		if attacker == self.caster or (IsSpiderling(attacker) and attacker:GetOwner() == self.caster) then
			-- Determine stack count increase (either Broodmother or her spiders)
			local stacks_increase
			if attacker == self.caster then
				stacks_increase = self.web_up_stacks_hero
			else
				stacks_increase = self.web_up_stacks_spider
			end

			-- Add modifier if it doesn't have it yet
			if not target:HasModifier(self.modifier_webbed_up) then
				target:AddNewModifier(self.caster, self.ability, self.modifier_webbed_up, { duration = self.web_up_counter_duration * (1 - target:GetStatusResistance()) })
			end

			-- Increment stacks
			local modifier = target:FindModifierByName(self.modifier_webbed_up)
			if modifier then
				modifier:SetStackCount(modifier:GetStackCount() + stacks_increase)
				modifier:ForceRefresh()
			end
		end
	end
end

-----------------------------------------
-- INCAPACITATING BITE DEBUFF MODIFIER --
-----------------------------------------

modifier_imba_broodmother_incapacitating_bite_orb = modifier_imba_broodmother_incapacitating_bite_orb or class({})

function modifier_imba_broodmother_incapacitating_bite_orb:IsDebuff() return true end

function modifier_imba_broodmother_incapacitating_bite_orb:IsHidden() return false end

function modifier_imba_broodmother_incapacitating_bite_orb:IsPurgable() return true end

function modifier_imba_broodmother_incapacitating_bite_orb:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
	self.miss_chance = self.ability:GetSpecialValueFor("miss_chance")
	self.cast_speed_slow_pct = self.ability:GetSpecialValueFor("cast_speed_slow_pct")
end

function modifier_imba_broodmother_incapacitating_bite_orb:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
	}
end

function modifier_imba_broodmother_incapacitating_bite_orb:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_movespeed * (-1)
end

function modifier_imba_broodmother_incapacitating_bite_orb:GetModifierMiss_Percentage()
	return self.miss_chance
end

function modifier_imba_broodmother_incapacitating_bite_orb:GetModifierPercentageCasttime()
	return self.cast_speed_slow_pct * (-1)
end

----------------------------------------------------
-- INCAPACITATING BITE WEBBED UP COUNTER MODIFIER --
----------------------------------------------------

modifier_imba_broodmother_incapacitating_bite_webbed_up_counter = modifier_imba_broodmother_incapacitating_bite_webbed_up_counter or class({})

function modifier_imba_broodmother_incapacitating_bite_webbed_up_counter:IsHidden() return false end

function modifier_imba_broodmother_incapacitating_bite_webbed_up_counter:IsPurgable() return false end

function modifier_imba_broodmother_incapacitating_bite_webbed_up_counter:IsDebuff() return true end

function modifier_imba_broodmother_incapacitating_bite_webbed_up_counter:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.modifier_webbed_up_debuff = "modifier_imba_broodmother_incapacitating_bite_webbed_up_debuff"

	-- Ability specials
	self.web_up_stacks_threshold = self.ability:GetSpecialValueFor("web_up_stacks_threshold")
	self.web_up_duration = self.ability:GetSpecialValueFor("web_up_duration")
end

function modifier_imba_broodmother_incapacitating_bite_webbed_up_counter:OnStackCountChanged()
	if not IsServer() then return end

	-- If the new stack count is equal or past the threshold, activate Webbed Up and destroy this modifier
	local stacks = self:GetStackCount()

	if stacks >= self.web_up_stacks_threshold then
		if not self.parent:HasModifier(self.modifier_webbed_up_debuff) then
			self.parent:AddNewModifier(self.caster, self.ability, self.modifier_webbed_up_debuff, { duration = self.web_up_duration * (1 - self.parent:GetStatusResistance()) })
		end

		self:Destroy()
	end
end

---------------------------------------------------
-- INCAPACITATING BITE WEBBED UP DEBUFF MODIFIER --
---------------------------------------------------

modifier_imba_broodmother_incapacitating_bite_webbed_up_debuff = modifier_imba_broodmother_incapacitating_bite_webbed_up_debuff or class({})

function modifier_imba_broodmother_incapacitating_bite_webbed_up_debuff:IsHidden() return false end

function modifier_imba_broodmother_incapacitating_bite_webbed_up_debuff:IsPurgable() return true end

function modifier_imba_broodmother_incapacitating_bite_webbed_up_debuff:IsDebuff() return true end

function modifier_imba_broodmother_incapacitating_bite_webbed_up_debuff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.web_up_miss_chance_pct = self.ability:GetSpecialValueFor("web_up_miss_chance_pct")
end

function modifier_imba_broodmother_incapacitating_bite_webbed_up_debuff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_MISS_PERCENTAGE }

	return decFuncs
end

function modifier_imba_broodmother_incapacitating_bite_webbed_up_debuff:GetModifierMiss_Percentage()
	return self.web_up_miss_chance_pct
end

function modifier_imba_broodmother_incapacitating_bite_webbed_up_debuff:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true
	}
end

-----------------------
-- INSATIABLE HUNGER --
-----------------------

LinkLuaModifier("modifier_imba_broodmother_insatiable_hunger", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_insatiable_hunger_satisfied", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_insatiable_hunger_spider", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)

imba_broodmother_insatiable_hunger = imba_broodmother_insatiable_hunger or class({})

function imba_broodmother_insatiable_hunger:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_buff = "modifier_imba_broodmother_insatiable_hunger"

	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")

	-- Grant the caster the buff
	caster:AddNewModifier(self:GetCaster(), ability, modifier_buff, { duration = duration })

	caster:EmitSound("Hero_Broodmother.InsatiableHunger")
end

-------------------------------------
-- INSATIABLE HUNGER BUFF MODIFIER --
-------------------------------------

modifier_imba_broodmother_insatiable_hunger = modifier_imba_broodmother_insatiable_hunger or class({})

function modifier_imba_broodmother_insatiable_hunger:IsHidden() return false end

function modifier_imba_broodmother_insatiable_hunger:IsPurgable() return false end

function modifier_imba_broodmother_insatiable_hunger:IsDebuff() return false end

function modifier_imba_broodmother_insatiable_hunger:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_satistied = "modifier_imba_broodmother_insatiable_hunger_satisfied"

	-- Ability specials
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.lifesteal_pct = self.ability:GetSpecialValueFor("lifesteal_pct")
	self.satisfied_duration = self.ability:GetSpecialValueFor("satisfied_duration")
	self.queen_brood_aura_radius = self.ability:GetSpecialValueFor("queen_brood_aura_radius")
	self.satisfy_trigger_duration_increase = self.ability:GetSpecialValueFor("satisfy_trigger_duration_increase")

	if not IsServer() then return end
	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_broodmother/broodmother_hunger_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_thorax", self:GetParent():GetAbsOrigin(), true)
end

function modifier_imba_broodmother_insatiable_hunger:IsAura() return true end

function modifier_imba_broodmother_insatiable_hunger:GetAuraDuration() return 0.5 end

function modifier_imba_broodmother_insatiable_hunger:GetAuraRadius() return self.queen_brood_aura_radius end

function modifier_imba_broodmother_insatiable_hunger:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED end

function modifier_imba_broodmother_insatiable_hunger:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_imba_broodmother_insatiable_hunger:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC end

function modifier_imba_broodmother_insatiable_hunger:GetModifierAura() return "modifier_imba_broodmother_insatiable_hunger_spider" end

function modifier_imba_broodmother_insatiable_hunger:GetAuraEntityReject(hTarget)
	if not IsServer() then return end

	if IsSpiderling(hTarget) then
		return false
	end

	return true
end

function modifier_imba_broodmother_insatiable_hunger:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_EVENT_ON_DEATH }

	return decFuncs
end

function modifier_imba_broodmother_insatiable_hunger:GetModifierBaseAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_broodmother_insatiable_hunger:GetModifierLifesteal()
	return self.lifesteal_pct
end

function modifier_imba_broodmother_insatiable_hunger:OnDestroy()
	if not IsServer() then return end

	self:GetCaster():StopSound("Hero_Broodmother.InsatiableHunger")

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

function modifier_imba_broodmother_insatiable_hunger:OnDeath(keys)
	if not IsServer() then return end

	local target = keys.unit
	local attacker = keys.attacker

	-- Only apply if the killer is Broodmother herself or her own spiders
	if attacker == self.caster or (IsSpiderling(attacker) and attacker:GetOwner() == self.caster) then
		-- And only apply if the target is a real hero, and Broodmother is actually alive
		if target:IsRealHero() and self.caster:IsAlive() then
			-- Give Broodmother the Not Yet Satisfied buff
			self.caster:AddNewModifier(self.caster, self.ability, self.modifier_satistied, { duration = self.satisfied_duration })

			-- Increase the duration of the Insatiable Hunger
			self:SetDuration(self:GetRemainingTime() + self.satisfy_trigger_duration_increase, true)
		end
	end
end

----------------------------------------
-- INSATIABLE HUNGER SPIDERLINGS BUFF --
----------------------------------------

modifier_imba_broodmother_insatiable_hunger_spider = modifier_imba_broodmother_insatiable_hunger_spider or class({})

function modifier_imba_broodmother_insatiable_hunger_spider:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.queen_brood_damage_bonus = self.ability:GetSpecialValueFor("queen_brood_damage_bonus")
	self.queen_brood_hp_regen = self.ability:GetSpecialValueFor("queen_brood_hp_regen")
end

function modifier_imba_broodmother_insatiable_hunger_spider:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT }

	return decFuncs
end

function modifier_imba_broodmother_insatiable_hunger_spider:GetModifierBaseAttack_BonusDamage()
	return self.queen_brood_damage_bonus
end

function modifier_imba_broodmother_insatiable_hunger_spider:GetModifierConstantHealthRegen()
	return self.queen_brood_hp_regen
end

-------------------------------------------------------
-- INSATIABLE HUNGER NOT YET SATISFIED BUFF MODIFIER --
-------------------------------------------------------

modifier_imba_broodmother_insatiable_hunger_satisfied = modifier_imba_broodmother_insatiable_hunger_satisfied or class({})

function modifier_imba_broodmother_insatiable_hunger_satisfied:IsHidden() return false end

function modifier_imba_broodmother_insatiable_hunger_satisfied:IsPurgable() return false end

function modifier_imba_broodmother_insatiable_hunger_satisfied:IsDebuff() return false end

function modifier_imba_broodmother_insatiable_hunger_satisfied:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.satisfied_status_resist_pct = self.ability:GetSpecialValueFor("satisfied_status_resist_pct")
	self.satisfied_movespeed_pct = self.ability:GetSpecialValueFor("satisfied_movespeed_pct")
end

function modifier_imba_broodmother_insatiable_hunger_satisfied:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }

	return decFuncs
end

function modifier_imba_broodmother_insatiable_hunger_satisfied:GetModifierStatusResistanceStacking()
	return self.satisfied_status_resist_pct
end

function modifier_imba_broodmother_insatiable_hunger_satisfied:GetModifierMoveSpeedBonus_Percentage()
	return self.satisfied_movespeed_pct
end

---
---
---



------------------------------------
-- BROODMOTHER'S SPAWN SPIDERKING --
------------------------------------

LinkLuaModifier("modifier_imba_broodmother_spawn_spiderking_hatch", "components/abilities/heroes/hero_broodmother", LUA_MODIFIER_MOTION_NONE)
imba_broodmother_spawn_spiderking = imba_broodmother_spawn_spiderking or class({})

function imba_broodmother_spawn_spiderking:GetAssociatedSecondaryAbilities()
	return "imba_broodmother_spawn_spiderlings"
end

function imba_broodmother_spawn_spiderking:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local modifier_hatch = "modifier_imba_broodmother_spawn_spiderking_hatch"

	-- Ability specials
	local cocoon_time = ability:GetSpecialValueFor("cocoon_time")

	-- Plant a cocoon at the target point!
	local cocoon = CreateUnitByName("npc_dota_broodmother_cocoon", target_point, false, caster, caster, caster:GetTeamNumber())
	cocoon:SetOwner(caster)
	cocoon:SetControllableByPlayer(caster:GetPlayerID(), false)
	cocoon:SetUnitOnClearGround()
	cocoon:AddNewModifier(caster, ability, modifier_hatch, { duration = cocoon_time })
end

-------------------------------------
-- SPAWN SPIDERKING HATCH MODIFIER --
-------------------------------------

modifier_imba_broodmother_spawn_spiderking_hatch = modifier_imba_broodmother_spawn_spiderking_hatch or class({})

function modifier_imba_broodmother_spawn_spiderking_hatch:IsHidden() return false end

function modifier_imba_broodmother_spawn_spiderking_hatch:IsPurgable() return false end

function modifier_imba_broodmother_spawn_spiderking_hatch:IsDebuff() return false end

function modifier_imba_broodmother_spawn_spiderking_hatch:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound = "Hero_Broodmother.SpawnSpiderlings"

	-- Ability specials
	self.max_spiderkings = self.ability:GetSpecialValueFor("max_spiderkings")
end

function modifier_imba_broodmother_spawn_spiderking_hatch:OnDestroy()
	if not IsServer() then return end

	-- Only apply if the cocoon is still alive at this point (modifier expired naturally)
	if not self.parent:IsAlive() then return nil end

	-- Play sound
	EmitSoundOn(self.sound, self.parent)

	-- Kill the cocoon
	self.parent:ForceKill(false)

	-- Hatch a new Spiderking!
	local spiderking = CreateUnitByName("npc_dota_broodmother_spiderking", self.parent:GetAbsOrigin(), false, self.caster, self.caster, self.caster:GetTeamNumber())
	spiderking:SetOwner(self.caster)
	spiderking:SetControllableByPlayer(self.caster:GetPlayerID(), false)
	spiderking:SetUnitOnClearGround()
	spiderking.spawn_time = spiderking:GetCreationTime()

	-- Give the Spiderking his skillzzzzz
	for i = 0, spiderking:GetAbilityCount() - 1 do
		local ability = spiderking:GetAbilityByIndex(i)
		if ability then
			ability:SetLevel(self.ability:GetLevel())
		end
	end

	-- Check if a Spiderking should die due to the maximum amount of allowed Spiderkings	
	local oldest_spawn_time = nil
	local oldest_spiderking = nil

	if self.ability.spiderking_table and #self.ability.spiderking_table >= self.max_spiderkings then
		for _, spiderking in pairs(self.ability.spiderking_table) do
			if not oldest_spawn_time or not oldest_spiderking then
				oldest_spawn_time = spiderking.spawn_time
				oldest_spiderking = spiderking
			else
				if spiderking.spawn_time < oldest_spawn_time then
					oldest_spawn_time = spiderking.spawn_time
					oldest_spiderking = spiderking
				end
			end
		end

		-- Cull the latest Spiderking and remove it from the table
		oldest_spiderking:ForceKill(false)
		table.remove(self.ability.spiderking_table, spiderking)
	end

	-- Insert new Spiderking to the table
	table.insert(self.ability.spiderking_table, spiderking)
end

-----------------------------------
-- IMBA_BROODMOTHER_POISON_STING --
-----------------------------------

LinkLuaModifier("modifier_imba_broodmother_poison_sting", "components/abilities/heroes/hero_broodmother", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_poison_sting_debuff", "components/abilities/heroes/hero_broodmother", LUA_MODIFIER_MOTION_NONE)

imba_broodmother_poison_sting                 = imba_broodmother_poison_sting or class({})
modifier_imba_broodmother_poison_sting        = modifier_imba_broodmother_poison_sting or class({})
modifier_imba_broodmother_poison_sting_debuff = modifier_imba_broodmother_poison_sting_debuff or class({})



function imba_broodmother_poison_sting:GetIntrinsicModifierName()
	return "modifier_imba_broodmother_poison_sting"
end

--------------------------------------------
-- MODIFIER_IMBA_BROODMOTHER_POISON_STING --
--------------------------------------------

function modifier_imba_broodmother_poison_sting:IsPurgable() return false end

function modifier_imba_broodmother_poison_sting:RemoveOnDeath() return false end

function modifier_imba_broodmother_poison_sting:OnCreated()
	self.damage_per_second     = self:GetAbility():GetSpecialValueFor("damage_per_second")
	self.movement_speed        = self:GetAbility():GetSpecialValueFor("movement_speed")
	self.duration_hero         = self:GetAbility():GetSpecialValueFor("duration_hero")
	self.duration              = self:GetAbility():GetSpecialValueFor("duration")
	self.cleave_starting_width = self:GetAbility():GetSpecialValueFor("cleave_starting_width")
	self.cleave_ending_width   = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
	self.cleave_distance       = self:GetAbility():GetSpecialValueFor("cleave_distance")
	self.cleave_damage         = self:GetAbility():GetSpecialValueFor("cleave_damage")
	self.scale                 = self:GetAbility():GetSpecialValueFor("scale")
end

function modifier_imba_broodmother_poison_sting:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end

function modifier_imba_broodmother_poison_sting:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() and not keys.target:IsBuilding() then
		if keys.target:IsHero() then
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_broodmother_poison_sting_debuff", { duration = self.duration_hero * (1 - keys.target:GetStatusResistance()) })
		else
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_broodmother_poison_sting_debuff", { duration = self.duration * (1 - keys.target:GetStatusResistance()) })
		end

		if not keys.target:IsOther() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			DoCleaveAttack(self:GetParent(), keys.target, self:GetAbility(), (keys.damage * self.cleave_damage / 100), self.cleave_starting_width, self.cleave_ending_width, self.cleave_distance, "particles/econ/items/faceless_void/faceless_void_weapon_bfury/faceless_void_weapon_bfury_cleave.vpcf")
		end
	end
end

-- The stuff of nightmares
function modifier_imba_broodmother_poison_sting:GetModifierModelScale()
	return self:GetStackCount() * 4
end

---------------------------------------------------
-- MODIFIER_IMBA_BROODMOTHER_POISON_STING_DEBUFF --
---------------------------------------------------

function modifier_imba_broodmother_poison_sting_debuff:IgnoreTenacity() return true end

function modifier_imba_broodmother_poison_sting_debuff:RemoveOnDeath() return false end

function modifier_imba_broodmother_poison_sting_debuff:OnCreated()
	self.damage_per_second                    = self:GetAbility():GetSpecialValueFor("damage_per_second") + self:GetCaster():GetModifierStackCount("modifier_imba_broodmother_poison_sting", self:GetCaster())
	self.movement_speed                       = self:GetAbility():GetSpecialValueFor("movement_speed") - self:GetCaster():GetModifierStackCount("modifier_imba_broodmother_poison_sting", self:GetCaster())
	self.scale                                = self:GetAbility():GetSpecialValueFor("scale")
	self.hero_scale                           = self:GetAbility():GetSpecialValueFor("hero_scale")

	-- Keep track of all the spiderlings that could have applied the debuff for minor stacking purposes (without making a million modifiers)
	self.spiders                              = {}
	self.spiders[self:GetCaster():entindex()] = true

	if not IsServer() then return end

	self.damage_type = self:GetAbility():GetAbilityDamageType()

	self:StartIntervalThink(1)
end

function modifier_imba_broodmother_poison_sting_debuff:OnRefresh()
	if not self.spiders[self:GetCaster():entindex()] then
		self.spiders[self:GetCaster():entindex()] = true
	end

	self.damage_per_second = math.max(self:GetAbility():GetSpecialValueFor("damage_per_second") + self:GetCaster():GetModifierStackCount("modifier_imba_broodmother_poison_sting", self:GetCaster()), self.damage_per_second)
	self.movement_speed    = math.min(self:GetAbility():GetSpecialValueFor("movement_speed") - self:GetCaster():GetModifierStackCount("modifier_imba_broodmother_poison_sting", self:GetCaster()), self.movement_speed)
end

function modifier_imba_broodmother_poison_sting_debuff:OnIntervalThink()
	ApplyDamage({
		victim       = self:GetParent(),
		damage       = self.damage_per_second,
		damage_type  = self.damage_type,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		attacker     = self:GetCaster(),
		ability      = self:GetAbility()
	})
end

function modifier_imba_broodmother_poison_sting_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,

		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_imba_broodmother_poison_sting_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_speed
end

function modifier_imba_broodmother_poison_sting_debuff:OnTooltip()
	return self.damage_per_second
end

function modifier_imba_broodmother_poison_sting_debuff:OnDeath(keys)
	if keys.unit == self:GetParent() and (not self:GetParent().IsReincarnating or not self:GetParent():IsReincarnating()) and self.spiders then
		for entindex, bool in pairs(self.spiders) do
			if EntIndexToHScript(entindex) and not EntIndexToHScript(entindex):IsNull() and EntIndexToHScript(entindex):IsAlive() and EntIndexToHScript(entindex):HasModifier("modifier_imba_broodmother_poison_sting") then
				if (keys.unit:IsRealHero() or keys.unit:IsClone()) then
					EntIndexToHScript(entindex):FindModifierByName("modifier_imba_broodmother_poison_sting"):SetStackCount(EntIndexToHScript(entindex):FindModifierByName("modifier_imba_broodmother_poison_sting"):GetStackCount() + self.hero_scale)
				else
					EntIndexToHScript(entindex):FindModifierByName("modifier_imba_broodmother_poison_sting"):SetStackCount(EntIndexToHScript(entindex):FindModifierByName("modifier_imba_broodmother_poison_sting"):GetStackCount() + self.scale)
				end
			end
		end

		self:Destroy()
	end
end

-------------------------
-- SPIDERLING VOLATILE --
-------------------------

LinkLuaModifier("modifier_imba_broodmother_spiderling_volatile", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_spiderling_volatile_debuff", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)

imba_broodmother_spiderling_volatile = imba_broodmother_spiderling_volatile or class({})

function imba_broodmother_spiderling_volatile:GetIntrinsicModifierName()
	return "modifier_imba_broodmother_spiderling_volatile"
end

----------------------------------
-- SPIDERLING VOLATILE MODIFIER --
----------------------------------

modifier_imba_broodmother_spiderling_volatile = modifier_imba_broodmother_spiderling_volatile or class({})

function modifier_imba_broodmother_spiderling_volatile:IsDebuff() return false end

function modifier_imba_broodmother_spiderling_volatile:IsHidden() return true end

function modifier_imba_broodmother_spiderling_volatile:IsPurgable() return false end

function modifier_imba_broodmother_spiderling_volatile:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_parasite = "modifier_imba_broodmother_spiderling_volatile_debuff"

	-- Ability specials
	self.explosion_damage = self.ability:GetSpecialValueFor("explosion_damage")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_imba_broodmother_spiderling_volatile:DeclareFunctions()
	local funcs = { MODIFIER_EVENT_ON_DEATH }

	return funcs
end

function modifier_imba_broodmother_spiderling_volatile:OnDeath(keys)
	if not IsServer() then return end

	local dead_unit = keys.unit

	-- Only apply if the dead unit is the spiderling itself, and only if it died from someone else (not expiring)
	if dead_unit == self.caster and keys.attacker ~= dead_unit then
		-- Does nothing if the spiderling is broken
		if self.caster:PassivesDisabled() then return nil end

		-- Blow up!
		-- TODO: Add explosion sound effect
		-- EmitSoundOn(explosion_sounds, self.caster)

		-- TODO: Add explosion particle effect
		-- local explosion_fx = ParticleManager:CreateParticle(particle_name, PATTACH_ORIGIN, self.caster)
		-- ParticleManager:SetParticleControl(explosion_fx, 0, self.caster:GetAbsOrigin())
		-- Any additional particle controls if needed here

		-- Find enemies and deal damage to them.
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self.caster:GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _, enemy in pairs(enemies) do
			-- Deal damage to nearby non-magic immune enemies			
			if not enemy:IsMagicImmune() then
				local damageTable = {
					victim = enemy,
					attacker = self.caster,
					damage = self.explosion_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self.ability
				}

				ApplyDamage(damageTable)

				-- Apply the Parasite debuff. If the enemy already has it, increment its stacks.
				if not enemy:HasModifier(self.modifier_parasite) then
					local modifier = enemy:AddNewModifier(self.caster, self.ability, self.modifier_parasite, { duration = self.duration })
					if modifier then
						modifier:IncrementStackCount()
					end
				else
					-- Increment by one stack and refresh.
					local modifier = enemy:FindModifierByName(self.modifier_parasite)
					if modifier then
						modifier:IncrementStackCount()
						modifier:ForceRefresh()
					end
				end
			end
		end
	end
end

-----------------------------------------
-- SPIDERLING VOLATILE DEBUFF MODIFIER --
-----------------------------------------

modifier_imba_broodmother_spiderling_volatile_debuff = modifier_imba_broodmother_spiderling_volatile_debuff or class({})

function modifier_imba_broodmother_spiderling_volatile_debuff:IsHidden() return false end

function modifier_imba_broodmother_spiderling_volatile_debuff:IsPurgable() return true end

function modifier_imba_broodmother_spiderling_volatile_debuff:IsDebuff() return true end

function modifier_imba_broodmother_spiderling_volatile_debuff:GetTexture()
	return "broodmother_spawn_spiderite"
end

function modifier_imba_broodmother_spiderling_volatile_debuff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.owner = self.caster:GetOwner()

	-- Ability specials
	self.damage_per_stack = self.ability:GetSpecialValueFor("damage_per_stack")
	self.slow_per_stack_pct = self.ability:GetSpecialValueFor("slow_per_stack_pct")
	self.damage_interval = self.ability:GetSpecialValueFor("damage_interval")

	-- Calculate damage
	self.damage = self.damage_per_stack * self.damage_interval

	-- Start thinking.
	if IsServer() then
		self:StartIntervalThink(self.damage_interval)
	end
end

function modifier_imba_broodmother_spiderling_volatile_debuff:OnIntervalThink()
	if not IsServer() then return end

	-- Must be linked to Broodmother, otherwise the damage table will not work without an attacker when the Spiderling is deleted.
	-- Instead we give her flags to make sure she doesn't get interacted with this
	local damageTable = {
		victim = self.parent,
		attacker = self.owner,
		damage = self.damage * self:GetStackCount(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self.ability,
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
	}

	ApplyDamage(damageTable)
end

function modifier_imba_broodmother_spiderling_volatile_debuff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }

	return decFuncs
end

function modifier_imba_broodmother_spiderling_volatile_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow_per_stack_pct * self:GetStackCount() * (-1)
end

-----------------------------
-- SPIDERKING POISON STING --
-----------------------------

LinkLuaModifier("modifier_imba_broodmother_spiderking_poison_sting", "components/abilities/heroes/hero_broodmother", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_spiderking_poison_sting_debuff", "components/abilities/heroes/hero_broodmother", LUA_MODIFIER_MOTION_NONE)

imba_broodmother_spiderking_poison_sting                 = imba_broodmother_spiderking_poison_sting or class({})
modifier_imba_broodmother_spiderking_poison_sting        = modifier_imba_broodmother_spiderking_poison_sting or class({})
modifier_imba_broodmother_spiderking_poison_sting_debuff = modifier_imba_broodmother_spiderking_poison_sting_debuff or class({})



function imba_broodmother_spiderking_poison_sting:GetIntrinsicModifierName()
	return "modifier_imba_broodmother_spiderking_poison_sting"
end

---------------------------------------------
-- SPIDERKING POISON STING ATTACK MODIFIER --
---------------------------------------------

function modifier_imba_broodmother_spiderking_poison_sting:IsPurgable() return false end

function modifier_imba_broodmother_spiderking_poison_sting:RemoveOnDeath() return false end

function modifier_imba_broodmother_spiderking_poison_sting:OnCreated()
	self.damage_per_second     = self:GetAbility():GetSpecialValueFor("damage_per_second")
	self.movement_speed        = self:GetAbility():GetSpecialValueFor("movement_speed")
	self.duration_hero         = self:GetAbility():GetSpecialValueFor("duration_hero")
	self.duration              = self:GetAbility():GetSpecialValueFor("duration")
	self.cleave_starting_width = self:GetAbility():GetSpecialValueFor("cleave_starting_width")
	self.cleave_ending_width   = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
	self.cleave_distance       = self:GetAbility():GetSpecialValueFor("cleave_distance")
	self.cleave_damage         = self:GetAbility():GetSpecialValueFor("cleave_damage")
	self.scale                 = self:GetAbility():GetSpecialValueFor("scale")
end

function modifier_imba_broodmother_spiderking_poison_sting:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end

function modifier_imba_broodmother_spiderking_poison_sting:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() and not keys.target:IsBuilding() then
		if keys.target:IsHero() then
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_broodmother_spiderking_poison_sting_debuff", { duration = self.duration_hero * (1 - keys.target:GetStatusResistance()) })
		else
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_broodmother_spiderking_poison_sting_debuff", { duration = self.duration * (1 - keys.target:GetStatusResistance()) })
		end

		if not keys.target:IsOther() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			DoCleaveAttack(self:GetParent(), keys.target, self:GetAbility(), (keys.damage * self.cleave_damage / 100), self.cleave_starting_width, self.cleave_ending_width, self.cleave_distance, "particles/econ/items/faceless_void/faceless_void_weapon_bfury/faceless_void_weapon_bfury_cleave.vpcf")
		end
	end
end

-- The stuff of nightmares
function modifier_imba_broodmother_spiderking_poison_sting:GetModifierModelScale()
	return self:GetStackCount() * 4
end

------------------------------------
-- SPIDERKING POISON STING DEBUFF --
------------------------------------

function modifier_imba_broodmother_spiderking_poison_sting_debuff:IgnoreTenacity() return true end

function modifier_imba_broodmother_spiderking_poison_sting_debuff:RemoveOnDeath() return false end

function modifier_imba_broodmother_spiderking_poison_sting_debuff:OnCreated()
	self.damage_per_second                    = self:GetAbility():GetSpecialValueFor("damage_per_second") + self:GetCaster():GetModifierStackCount("modifier_imba_broodmother_spiderking_poison_sting", self:GetCaster())
	self.movement_speed                       = self:GetAbility():GetSpecialValueFor("movement_speed") - self:GetCaster():GetModifierStackCount("modifier_imba_broodmother_spiderking_poison_sting", self:GetCaster())
	self.scale                                = self:GetAbility():GetSpecialValueFor("scale")
	self.hero_scale                           = self:GetAbility():GetSpecialValueFor("hero_scale")

	-- Keep track of all the spiderlings that could have applied the debuff for minor stacking purposes (without making a million modifiers)
	self.spiders                              = {}
	self.spiders[self:GetCaster():entindex()] = true

	if not IsServer() then return end

	self.damage_type = self:GetAbility():GetAbilityDamageType()

	self:StartIntervalThink(1)
end

function modifier_imba_broodmother_spiderking_poison_sting_debuff:OnRefresh()
	if not self.spiders[self:GetCaster():entindex()] then
		self.spiders[self:GetCaster():entindex()] = true
	end

	self.damage_per_second = math.max(self:GetAbility():GetSpecialValueFor("damage_per_second") + self:GetCaster():GetModifierStackCount("modifier_imba_broodmother_spiderking_poison_sting", self:GetCaster()), self.damage_per_second)
	self.movement_speed    = math.min(self:GetAbility():GetSpecialValueFor("movement_speed") - self:GetCaster():GetModifierStackCount("modifier_imba_broodmother_spiderking_poison_sting", self:GetCaster()), self.movement_speed)
end

function modifier_imba_broodmother_spiderking_poison_sting_debuff:OnIntervalThink()
	ApplyDamage({
		victim       = self:GetParent(),
		damage       = self.damage_per_second,
		damage_type  = self.damage_type,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		attacker     = self:GetCaster(),
		ability      = self:GetAbility()
	})
end

function modifier_imba_broodmother_spiderking_poison_sting_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_imba_broodmother_spiderking_poison_sting_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_speed
end

function modifier_imba_broodmother_spiderking_poison_sting_debuff:OnTooltip()
	return self.damage_per_second
end

function modifier_imba_broodmother_spiderking_poison_sting_debuff:OnDeath(keys)
	if keys.unit == self:GetParent() and (not self:GetParent().IsReincarnating or not self:GetParent():IsReincarnating()) and self.spiders then
		for entindex, bool in pairs(self.spiders) do
			if EntIndexToHScript(entindex) and not EntIndexToHScript(entindex):IsNull() and EntIndexToHScript(entindex):IsAlive() and EntIndexToHScript(entindex):HasModifier("modifier_imba_broodmother_spiderking_poison_sting") then
				if (keys.unit:IsRealHero() or keys.unit:IsClone()) then
					EntIndexToHScript(entindex):FindModifierByName("modifier_imba_broodmother_spiderking_poison_sting"):SetStackCount(EntIndexToHScript(entindex):FindModifierByName("modifier_imba_broodmother_spiderking_poison_sting"):GetStackCount() + self.hero_scale)
				else
					EntIndexToHScript(entindex):FindModifierByName("modifier_imba_broodmother_spiderking_poison_sting"):SetStackCount(EntIndexToHScript(entindex):FindModifierByName("modifier_imba_broodmother_spiderking_poison_sting"):GetStackCount() + self.scale)
				end
			end
		end

		self:Destroy()
	end
end

-------------------------
-- SPIDERKING VOLATILE --
-------------------------

LinkLuaModifier("modifier_imba_broodmother_spiderking_volatile", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_spiderking_volatile_debuff", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)

imba_broodmother_spiderking_volatile = imba_broodmother_spiderking_volatile or class({})

function imba_broodmother_spiderking_volatile:GetIntrinsicModifierName()
	return "modifier_imba_broodmother_spiderking_volatile"
end

----------------------------------
-- SPIDERKING VOLATILE MODIFIER --
----------------------------------

modifier_imba_broodmother_spiderking_volatile = modifier_imba_broodmother_spiderking_volatile or class({})

function modifier_imba_broodmother_spiderking_volatile:IsDebuff() return false end

function modifier_imba_broodmother_spiderking_volatile:IsHidden() return true end

function modifier_imba_broodmother_spiderking_volatile:IsPurgable() return false end

function modifier_imba_broodmother_spiderking_volatile:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_parasite = "modifier_imba_broodmother_spiderking_volatile_debuff"

	-- Ability specials
	self.explosion_damage = self.ability:GetSpecialValueFor("explosion_damage")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_imba_broodmother_spiderking_volatile:DeclareFunctions()
	local funcs = { MODIFIER_EVENT_ON_DEATH }

	return funcs
end

function modifier_imba_broodmother_spiderking_volatile:OnDeath(keys)
	if not IsServer() then return end

	local dead_unit = keys.unit

	-- Only apply if the dead unit is the Spiderking itself, and only if it died from someone else (not expiring)
	if dead_unit == self.caster and keys.attacker ~= dead_unit then
		-- Does nothing if the Spiderking is broken
		if self.caster:PassivesDisabled() then return nil end

		-- Blow up!
		-- TODO: Add explosion sound effect
		-- EmitSoundOn(explosion_sounds, self.caster)

		-- TODO: Add explosion particle effect
		-- local explosion_fx = ParticleManager:CreateParticle(particle_name, PATTACH_ORIGIN, self.caster)
		-- ParticleManager:SetParticleControl(explosion_fx, 0, self.caster:GetAbsOrigin())
		-- Any additional particle controls if needed here

		-- Find enemies and deal damage to them.
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self.caster:GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _, enemy in pairs(enemies) do
			-- Deal damage to nearby non-magic immune enemies
			if not enemy:IsMagicImmune() then
				local damageTable = {
					victim = enemy,
					attacker = self.caster,
					damage = self.explosion_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self.ability
				}

				ApplyDamage(damageTable)

				-- Apply the Parasite debuff. If the enemy already has it, increment its stacks.
				if not enemy:HasModifier(self.modifier_parasite) then
					local modifier = enemy:AddNewModifier(self.caster, self.ability, self.modifier_parasite, { duration = self.duration })
					if modifier then
						modifier:IncrementStackCount()
					end
				else
					-- Increment by one stack and refresh.
					local modifier = enemy:FindModifierByName(self.modifier_parasite)
					if modifier then
						modifier:IncrementStackCount()
						modifier:ForceRefresh()
					end
				end
			end
		end
	end
end

-----------------------------------------
-- SPIDERKING VOLATILE DEBUFF MODIFIER --
-----------------------------------------

modifier_imba_broodmother_spiderking_volatile_debuff = modifier_imba_broodmother_spiderking_volatile_debuff or class({})

function modifier_imba_broodmother_spiderking_volatile_debuff:IsHidden() return false end

function modifier_imba_broodmother_spiderking_volatile_debuff:IsPurgable() return true end

function modifier_imba_broodmother_spiderking_volatile_debuff:IsDebuff() return true end

function modifier_imba_broodmother_spiderking_volatile_debuff:GetTexture()
	return "broodmother_spawn_spiderite"
end

function modifier_imba_broodmother_spiderking_volatile_debuff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.owner = self.caster:GetOwner()

	-- Ability specials
	self.damage_per_stack = self.ability:GetSpecialValueFor("damage_per_stack")
	self.slow_per_stack_pct = self.ability:GetSpecialValueFor("slow_per_stack_pct")
	self.damage_interval = self.ability:GetSpecialValueFor("damage_interval")

	-- Calculate damage
	self.damage = self.damage_per_stack * self.damage_interval

	-- Start thinking.
	if IsServer() then
		self:StartIntervalThink(self.damage_interval)
	end
end

function modifier_imba_broodmother_spiderking_volatile_debuff:OnIntervalThink()
	if not IsServer() then return end

	-- Must be linked to Broodmother, otherwise the damage table will not work without an attacker when the Spiderking is deleted.
	-- Instead we give her flags to make sure she doesn't get interacted with this
	local damageTable = {
		victim = self.parent,
		attacker = self.owner,
		damage = self.damage * self:GetStackCount(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self.ability,
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
	}

	ApplyDamage(damageTable)
end

function modifier_imba_broodmother_spiderking_volatile_debuff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }

	return decFuncs
end

function modifier_imba_broodmother_spiderking_volatile_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow_per_stack_pct * self:GetStackCount() * (-1)
end

-------------------------
-- HARDENED BROOD AURA --
-------------------------

LinkLuaModifier("modifier_imba_broodmother_spiderking_hardened_brood_aura", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_spiderking_hardened_brood_buff", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)

imba_broodmother_spiderking_hardened_brood_aura = imba_broodmother_spiderking_hardened_brood_aura or class({})

function imba_broodmother_spiderking_hardened_brood_aura:GetIntrinsicModifierName()
	return "modifier_imba_broodmother_spiderking_hardened_brood_aura"
end

-----------------------------------
-- HARDEDNED BROOD AURA MODIFIER --
-----------------------------------

modifier_imba_broodmother_spiderking_hardened_brood_aura = modifier_imba_broodmother_spiderking_hardened_brood_aura or class({})

function modifier_imba_broodmother_spiderking_hardened_brood_aura:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_imba_broodmother_spiderking_hardened_brood_aura:IsAura() return true end

function modifier_imba_broodmother_spiderking_hardened_brood_aura:GetAuraDuration() return 0.1 end

function modifier_imba_broodmother_spiderking_hardened_brood_aura:GetAuraRadius() return self.radius end

function modifier_imba_broodmother_spiderking_hardened_brood_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED end

function modifier_imba_broodmother_spiderking_hardened_brood_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_imba_broodmother_spiderking_hardened_brood_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC end

function modifier_imba_broodmother_spiderking_hardened_brood_aura:GetModifierAura() return "modifier_imba_broodmother_spiderking_hardened_brood_buff" end

function modifier_imba_broodmother_spiderking_hardened_brood_aura:IsHidden() return true end

function modifier_imba_broodmother_spiderking_hardened_brood_aura:IsPurgable() return false end

function modifier_imba_broodmother_spiderking_hardened_brood_aura:IsDebuff() return false end

function modifier_imba_broodmother_spiderking_hardened_brood_aura:IsPurgeException() return false end

function modifier_imba_broodmother_spiderking_hardened_brood_aura:RemoveOnDeath() return true end

function modifier_imba_broodmother_spiderking_hardened_brood_aura:GetAuraEntityReject(hTarget)
	if not IsServer() then return end

	-- Aura only affects Spiderlings
	if hTarget:GetName() == "npc_dota_broodmother_spiderling" then
		return false
	end

	return true
end

-----------------------------------
-- HARDEDNED BROOD BUFF MODIFIER --
-----------------------------------

modifier_imba_broodmother_spiderking_hardened_brood_buff = modifier_imba_broodmother_spiderking_hardened_brood_buff or class({})

function modifier_imba_broodmother_spiderking_hardened_brood_buff:IsHidden() return false end

function modifier_imba_broodmother_spiderking_hardened_brood_buff:IsPurgable() return false end

function modifier_imba_broodmother_spiderking_hardened_brood_buff:IsDebuff() return false end

function modifier_imba_broodmother_spiderking_hardened_brood_buff:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_MIN_HEALTH }

	return decFuncs
end

function modifier_imba_broodmother_spiderking_hardened_brood_buff:GetMinHealth()
	return 1
end
