-- Creator:
--		EarthSalamander, October 3rd, 2019

LinkLuaModifier("modifier_imba_broodmother_spawn_spiderlings", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)

imba_broodmother_spawn_spiderlings = imba_broodmother_spawn_spiderlings or class({})

function imba_broodmother_spawn_spiderlings:OnSpellStart()
	if not IsServer() then return end

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
	if hTarget then
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_imba_broodmother_spawn_spiderlings", {duration = self:GetSpecialValueFor("buff_duration")})

		ApplyDamage({
			attacker = self:GetCaster(),
			victim = hTarget,
			damage = self:GetSpecialValueFor("damage"),
			damage_type = self:GetAbilityDamageType(),
			damage_flags = self:GetAbilityTargetFlags()
		})

		hTarget:EmitSound("Hero_Broodmother.SpawnSpiderlingsImpact")
	end
end

modifier_imba_broodmother_spawn_spiderlings = modifier_imba_broodmother_spawn_spiderlings or class({})

function modifier_imba_broodmother_spawn_spiderlings:IsDebuff() return true end
function modifier_imba_broodmother_spawn_spiderlings:GetEffectName() return "particles/units/heroes/hero_broodmother/broodmother_spiderlings_debuff.vpcf" end
function modifier_imba_broodmother_spawn_spiderlings:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_broodmother_spawn_spiderlings:OnDestroy()
	if not IsServer() then return end

	if not self:GetParent():IsAlive() then
		for i = 1, self:GetAbility():GetSpecialValueFor("count") do
			local spiderling = CreateUnitByName("npc_dota_broodmother_spiderling", self:GetParent():GetAbsOrigin(), false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
			spiderling:SetOwner(self:GetCaster())
			spiderling:SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)
			spiderling:SetUnitOnClearGround()
			spiderling:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kill", {duration = self:GetAbility():GetSpecialValueFor("spiderling_duration")})
--			ResolveNPCPositions(spiderling:GetAbsOrigin(), 50)
			self:GetParent():EmitSound("Hero_Broodmother.SpawnSpiderlings")

			for i = 0, 24 do
				local ability = spiderling:GetAbilityByIndex(i)

				if ability then
					ability:SetLevel(1)
				end
			end
		end
	end
end

LinkLuaModifier("modifier_imba_broodmother_spin_web_aura", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_spin_web", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)

imba_broodmother_spin_web = imba_broodmother_spin_web or class({})

function imba_broodmother_spin_web:OnUpgrade()
	if not IsServer() then return end

	if self:GetLevel() == 1 then
		LinkLuaModifier("modifier_charges", "components/modifiers/modifier_charges.lua", LUA_MODIFIER_MOTION_NONE)

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_charges", {
			start_count = self:GetSpecialValueFor("max_charges"),
			max_count = self:GetSpecialValueFor("max_charges"),
			replenish_time = self:GetSpecialValueFor("charge_restore_time"),
		})
	else
		charges_modifier = self:GetCaster():FindModifierByName("modifier_charges")

		if charges_modifier then
			local kv = {}
			kv.max_count = self:GetSpecialValueFor("max_charges")
			kv.replenish_time = self:GetSpecialValueFor("charge_restore_time")
			charges_modifier:OnRefresh(kv)
		end
	end
end

function imba_broodmother_spin_web:OnSpellStart()
	if not IsServer() then return end

	-- todo: allow web to be cast out of cast range if overlapping onto an existing web


	local webs = Entities:FindAllByClassname("npc_dota_broodmother_web")

	-- remove oldest web
	if #webs >= self:GetSpecialValueFor("count") then
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

	local web = CreateUnitByName("npc_dota_broodmother_web", self:GetCursorPosition(), false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	web:AddNewModifier(self:GetCaster(), self, "modifier_imba_broodmother_spin_web_aura", {})
	web:SetOwner(self:GetCaster())
	web:SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)
	web.spawn_time = math.floor(GameRules:GetDOTATime(false, false))

	for i = 0, 24 do
		local ability = web:GetAbilityByIndex(i)

		if ability then
			ability:SetLevel(1)
		end
	end

	self:GetCaster():EmitSound("Hero_Broodmother.SpinWebCast")
end

modifier_imba_broodmother_spin_web_aura = modifier_imba_broodmother_spin_web_aura or class({})

function modifier_imba_broodmother_spin_web_aura:IsAura() return true end
function modifier_imba_broodmother_spin_web_aura:GetAuraDuration() return 0.2 end
function modifier_imba_broodmother_spin_web_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_imba_broodmother_spin_web_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED end
function modifier_imba_broodmother_spin_web_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_broodmother_spin_web_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_broodmother_spin_web_aura:GetModifierAura() return "modifier_imba_broodmother_spin_web" end

function modifier_imba_broodmother_spin_web_aura:IsHidden() return true end
function modifier_imba_broodmother_spin_web_aura:IsPurgable() return false end
function modifier_imba_broodmother_spin_web_aura:IsPurgeException() return false end
function modifier_imba_broodmother_spin_web_aura:RemoveOnDeath() return false end

function modifier_imba_broodmother_spin_web_aura:GetAuraEntityReject(hTarget)
	if not IsServer() then return end

	if hTarget == self:GetCaster() or hTarget:GetUnitName() == "npc_dota_broodmother_spiderling" or hTarget:GetUnitName() == "npc_dota_broodmother_spiderite" then
		return false
	end

	return true
end

function modifier_imba_broodmother_spin_web_aura:CheckState() return {
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
} end

function modifier_imba_broodmother_spin_web_aura:DeclareFunctions() return {
	MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	MODIFIER_EVENT_ON_DEATH,
	MODIFIER_EVENT_ON_ABILITY_EXECUTED,
} end

function modifier_imba_broodmother_spin_web_aura:GetModifierProvidesFOWVision()
	return 1
end

function modifier_imba_broodmother_spin_web_aura:OnCreated()
	if not IsServer() then return end

	self:GetParent():EmitSound("Hero_Broodmother.WebLoop")
end

function modifier_imba_broodmother_spin_web_aura:OnDeath(params)
	if not IsServer() then return end

	if params.unit == self:GetParent() then
		self:GetParent():StopSound("Hero_Broodmother.WebLoop")
		UTIL_Remove(self:GetParent())
	end
end

modifier_imba_broodmother_spin_web = modifier_imba_broodmother_spin_web or class({})

function modifier_imba_broodmother_spin_web:IsPurgable() return false end
function modifier_imba_broodmother_spin_web:IsPurgeException() return false end

function modifier_imba_broodmother_spin_web:CheckState() return {
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
} end

function modifier_imba_broodmother_spin_web:DeclareFunctions() return {
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
} end

function modifier_imba_broodmother_spin_web:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("heath_regen")
end

function modifier_imba_broodmother_spin_web:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_movespeed")
end

LinkLuaModifier("modifier_imba_broodmother_incapacitating_bite", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_incapacitating_bite_orb", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)

imba_broodmother_incapacitating_bite = imba_broodmother_incapacitating_bite or class({})

function imba_broodmother_incapacitating_bite:GetIntrinsicModifierName()
	return "modifier_imba_broodmother_incapacitating_bite"
end

modifier_imba_broodmother_incapacitating_bite = modifier_imba_broodmother_incapacitating_bite or class({})

function modifier_imba_broodmother_incapacitating_bite:IsHidden() return true end

function modifier_imba_broodmother_incapacitating_bite:DeclareFunctions() return {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
} end

function modifier_imba_broodmother_incapacitating_bite:OnAttackLanded(params)
	if not IsServer() then return end

	if self:GetParent() == params.attacker then
		params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_broodmother_incapacitating_bite_orb", {duration = self:GetAbility():GetSpecialValueFor("duration")})
	end
end

modifier_imba_broodmother_incapacitating_bite_orb = modifier_imba_broodmother_incapacitating_bite_orb or class({})

function modifier_imba_broodmother_incapacitating_bite_orb:IsDebuff() return true end

function modifier_imba_broodmother_incapacitating_bite_orb:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_MISS_PERCENTAGE,
} end

function modifier_imba_broodmother_incapacitating_bite_orb:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_movespeed")
end

function modifier_imba_broodmother_incapacitating_bite_orb:GetModifierMiss_Percentage()
	return self:GetAbility():GetSpecialValueFor("miss_chance")
end

LinkLuaModifier("modifier_imba_broodmother_insatiable_hunger", "components/abilities/heroes/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)

imba_broodmother_insatiable_hunger = imba_broodmother_insatiable_hunger or class({})

function imba_broodmother_insatiable_hunger:OnSpellStart()
	if not IsServer() then return end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_broodmother_insatiable_hunger", {duration = self:GetSpecialValueFor("duration")})

	self:GetCaster():EmitSound("Hero_Broodmother.InsatiableHunger")
end

modifier_imba_broodmother_insatiable_hunger = modifier_imba_broodmother_insatiable_hunger or class({})

function modifier_imba_broodmother_insatiable_hunger:DeclareFunctions() return {
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
} end

function modifier_imba_broodmother_insatiable_hunger:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_imba_broodmother_insatiable_hunger:GetModifierLifesteal()
	return self:GetAbility():GetSpecialValueFor("lifesteal_pct")
end

function modifier_imba_broodmother_insatiable_hunger:OnDestroy()
	if not IsServer() then return end

	self:GetCaster():StopSound("Hero_Broodmother.InsatiableHunger")
end

---
---
---

-- AltiV, January 18th, 2020

LinkLuaModifier("modifier_imba_broodmother_poison_sting", "components/abilities/heroes/hero_broodmother", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_broodmother_poison_sting_debuff", "components/abilities/heroes/hero_broodmother", LUA_MODIFIER_MOTION_NONE)

imba_broodmother_poison_sting					= imba_broodmother_poison_sting or class({})
modifier_imba_broodmother_poison_sting			= modifier_imba_broodmother_poison_sting or class({})
modifier_imba_broodmother_poison_sting_debuff	= modifier_imba_broodmother_poison_sting_debuff or class({})

-----------------------------------
-- IMBA_BROODMOTHER_POISON_STING --
-----------------------------------

function imba_broodmother_poison_sting:GetIntrinsicModifierName()
	return "modifier_imba_broodmother_poison_sting"
end

--------------------------------------------
-- MODIFIER_IMBA_BROODMOTHER_POISON_STING --
--------------------------------------------

function modifier_imba_broodmother_poison_sting:IsPurgable()	return false end
function modifier_imba_broodmother_poison_sting:RemoveOnDeath()	return false end

function modifier_imba_broodmother_poison_sting:OnCreated()
	self.damage_per_second		= self:GetAbility():GetSpecialValueFor("damage_per_second")
	self.movement_speed			= self:GetAbility():GetSpecialValueFor("movement_speed")
	self.duration_hero			= self:GetAbility():GetSpecialValueFor("duration_hero")
	self.duration				= self:GetAbility():GetSpecialValueFor("duration")
	self.cleave_starting_width	= self:GetAbility():GetSpecialValueFor("cleave_starting_width")
	self.cleave_ending_width	= self:GetAbility():GetSpecialValueFor("cleave_ending_width")
	self.cleave_distance		= self:GetAbility():GetSpecialValueFor("cleave_distance")
	self.cleave_damage			= self:GetAbility():GetSpecialValueFor("cleave_damage")
	self.scale					= self:GetAbility():GetSpecialValueFor("scale")
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
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_broodmother_poison_sting_debuff", {duration = self.duration_hero})
		else
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_broodmother_poison_sting_debuff", {duration = self.duration})
		end
	
		if not keys.target:IsOther() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			DoCleaveAttack(self:GetParent(), keys.target, self:GetAbility(), (keys.damage * self.cleave_damage * 0.01), self.cleave_starting_width, self.cleave_ending_width, self.cleave_distance, "particles/econ/items/faceless_void/faceless_void_weapon_bfury/faceless_void_weapon_bfury_cleave.vpcf")
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

function modifier_imba_broodmother_poison_sting_debuff:IgnoreTenacity()	return true end
function modifier_imba_broodmother_poison_sting_debuff:RemoveOnDeath()	return false end

function modifier_imba_broodmother_poison_sting_debuff:OnCreated()
	self.damage_per_second		= self:GetAbility():GetSpecialValueFor("damage_per_second") + self:GetCaster():GetModifierStackCount("modifier_imba_broodmother_poison_sting", self:GetCaster())
	self.movement_speed			= self:GetAbility():GetSpecialValueFor("movement_speed") - self:GetCaster():GetModifierStackCount("modifier_imba_broodmother_poison_sting", self:GetCaster())
	self.scale					= self:GetAbility():GetSpecialValueFor("scale")
	self.hero_scale				= self:GetAbility():GetSpecialValueFor("hero_scale")
	
	-- Keep track of all the spiderlings that could have applied the debuff for minor stacking purposes (without making a million modifiers)
	self.spiders = {}
	self.spiders[self:GetCaster():entindex()] = true
	
	if not IsServer() then return end
	
	self.damage_type			= self:GetAbility():GetAbilityDamageType()
	
	self:StartIntervalThink(1)
end

function modifier_imba_broodmother_poison_sting_debuff:OnRefresh()
	if not self.spiders[self:GetCaster():entindex()] then
		self.spiders[self:GetCaster():entindex()] = true
	end
	
	self.damage_per_second		= math.max(self:GetAbility():GetSpecialValueFor("damage_per_second") + self:GetCaster():GetModifierStackCount("modifier_imba_broodmother_poison_sting", self:GetCaster()), self.damage_per_second)
	self.movement_speed			= math.min(self:GetAbility():GetSpecialValueFor("movement_speed") - self:GetCaster():GetModifierStackCount("modifier_imba_broodmother_poison_sting", self:GetCaster()), self.movement_speed)
end

function modifier_imba_broodmother_poison_sting_debuff:OnIntervalThink()
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self.damage_per_second,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
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
