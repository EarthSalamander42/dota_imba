-- Editors:
--     MouJiaoZi, 15.12.2017

LinkLuaModifier("modifier_imba_enigma_generic_pull", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)

function CalculatePullLength(caster, target, length)
	if not IsServer() then return end
	local son = caster:FindAbilityByName("imba_enigma_demonic_conversion")
	iLenght = length
	if son then
		local debuff = target:FindModifierByName("modifier_imba_enigma_eidolon_attack_counter")
		if debuff then
			iLenght = iLenght * (1 + son:GetSpecialValueFor("increased_mass_pull_pct") / 100 * debuff:GetStackCount())
		end
	end
	return iLenght
end

function SearchForEngimaThinker(caster, victim, length, talent)
	if not IsServer() then return end
	talent = talent or false
	local Black_Hole = caster:FindAbilityByName("imba_enigma_black_hole")

	local hThinker = caster -- enigma self

	if talent then       -- talent
		local Thinkers = FindUnitsInRadius(victim:GetTeamNumber(),
			victim:GetAbsOrigin(),
			nil,
			9999999,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
			FIND_CLOSEST,
			false)
		for _, thinker in pairs(Thinkers) do
			if thinker:FindModifierByNameAndCaster("modifier_imba_enigma_malefice", caster) and thinker ~= victim then
				hThinker = thinker
				break
			end
		end
	end

	-- local Thinkers = FindUnitsInRadius(caster:GetTeamNumber(),
	-- victim:GetAbsOrigin(),
	-- nil,
	-- 9999999,
	-- DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	-- DOTA_UNIT_TARGET_ALL,
	-- DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
	-- FIND_CLOSEST,
	-- false)
	-- for _,thinker in pairs(Thinkers) do -- midnight
	-- if thinker:GetUnitName() == "npc_dummy_unit" and thinker.midnight == true then
	-- hThinker = thinker
	-- break
	-- end
	-- end

	for _, ent in pairs(Entities:FindAllByName("npc_dota_thinker")) do
		if ent.midnight then
			hThinker = ent
			break
		end
	end

	if Black_Hole.thinker and not Black_Hole.thinker:IsNull() then hThinker = Black_Hole.thinker end -- black hole

	iLenght = CalculatePullLength(caster, victim, length)
	victim:AddNewModifier(caster, nil, "modifier_imba_enigma_generic_pull", { duration = 1.0 * (1 - victim:GetStatusResistance()), target = hThinker:entindex(), length = iLenght })
end

modifier_imba_enigma_generic_pull = modifier_imba_enigma_generic_pull or class({})



function modifier_imba_enigma_generic_pull:IsDebuff() return false end

function modifier_imba_enigma_generic_pull:IsHidden() return true end

function modifier_imba_enigma_generic_pull:IsPurgable() return true end

function modifier_imba_enigma_generic_pull:IsStunDebuff() return false end

function modifier_imba_enigma_generic_pull:IsMotionController() return true end

function modifier_imba_enigma_generic_pull:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end

function modifier_imba_enigma_generic_pull:OnCreated(keys)
	if not IsServer() then return end
	if keys.target then self.target = EntIndexToHScript(keys.target) end
	self.target = self.target or self:GetCaster()
	self.length = keys.length
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_enigma_generic_pull:OnRefresh(keys)
	if not IsServer() then return end
	self:OnCreated(keys)
end

function modifier_imba_enigma_generic_pull:OnIntervalThink()
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_imba_enigma_generic_pull:HorizontalMotion(unit, time)
	local length = self.length / (1.0 / FrameTime())
	if not self.target or self.target:IsNull() then
		self.target = self:GetCaster()
	end
	local pos = self:GetParent():GetAbsOrigin()
	local tar_pos = self.target:GetAbsOrigin()
	local next_pos = GetGroundPosition((pos + (tar_pos - pos):Normalized() * length), unit)
	unit:SetAbsOrigin(next_pos)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_imba_enigma_generic_pull:OnDestroy()
	if not IsServer() then return end
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

LinkLuaModifier("modifier_enigma_magic_immunity", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)
modifier_enigma_magic_immunity = class({})

function modifier_enigma_magic_immunity:IsDebuff() return false end

function modifier_enigma_magic_immunity:IsHidden() return false end

function modifier_enigma_magic_immunity:GetTexture()
	return "enigma_malefice"
end

function modifier_enigma_magic_immunity:CheckState()
	return { [MODIFIER_STATE_MAGIC_IMMUNE] = true }
end

function modifier_enigma_magic_immunity:GetEffectName()
	return "particles/hero/enigma/enigma_magic_immunity.vpcf"
end

function modifier_enigma_magic_immunity:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function SetTalentSpellImmunity(caster)
	local modifier = caster:FindModifierByName("modifier_enigma_magic_immunity")
	if modifier then
		local time = modifier:GetRemainingTime() + caster:FindTalentValue("special_bonus_imba_enigma_7")
		modifier:SetDuration(time, true)
	else
		caster:AddNewModifier(caster, nil, "modifier_enigma_magic_immunity", { duration = caster:FindTalentValue("special_bonus_imba_enigma_7") })
	end
end

LinkLuaModifier("modifier_special_bonus_imba_enigma_7", "components/abilities/heroes/hero_enigma.lua", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_enigma_7 = modifier_special_bonus_imba_enigma_7 or class({})

function modifier_special_bonus_imba_enigma_7:IsPurgable() return false end

function modifier_special_bonus_imba_enigma_7:IsHidden() return true end

function modifier_special_bonus_imba_enigma_7:RemoveOnDeath() return false end

-- gain spell immune when casting
function modifier_special_bonus_imba_enigma_7:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
	return funcs
end

function modifier_special_bonus_imba_enigma_7:OnAbilityFullyCast(keys)
	if keys.unit == self:GetParent() and not keys.ability:IsItem() and not keys.ability:IsToggle() and keys.ability:GetName() ~= "ability_capture" then
		SetTalentSpellImmunity(self:GetParent())
	end
end

--=================================================================================================================
-- Enigma's Malefice
--=================================================================================================================

imba_enigma_malefice = imba_enigma_malefice or class(VANILLA_ABILITIES_BASECLASS)

LinkLuaModifier("modifier_imba_enigma_malefice", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_enigma_2", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)

function imba_enigma_malefice:IsHiddenWhenStolen() return false end

function imba_enigma_malefice:IsRefreshable() return true end

function imba_enigma_malefice:IsStealable() return true end

function imba_enigma_malefice:IsNetherWardStealable() return false end

function imba_enigma_malefice:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end

function imba_enigma_malefice:OnOwnerSpawned()
	if not IsServer() then return end
	-- Two ways to ensure talents get added properly I guess
	if self:GetCaster():HasAbility("special_bonus_imba_enigma_2") and self:GetCaster():FindAbilityByName("special_bonus_imba_enigma_2"):IsTrained() and not self:GetCaster():HasModifier("modifier_special_bonus_imba_enigma_2") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_enigma_2", {})
	end

	if self:GetCaster():HasTalent("special_bonus_imba_enigma_7") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_enigma_7") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_enigma_7", {})
	end
end

function imba_enigma_malefice:GetAOERadius()
	if self:GetCaster():HasTalent("special_bonus_imba_enigma_2") then
		return self:GetCaster():FindTalentValue("special_bonus_imba_enigma_2")
	else
		return 0
	end
end

function imba_enigma_malefice:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

function imba_enigma_malefice:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb(self) then return end
	local ability = self
	local base_duration = ability:GetVanillaAbilitySpecial("duration")
	local hp_extra_duration = ability:GetSpecialValueFor("health_bonus_duration")
	local pct_per_extra = ability:GetSpecialValueFor("health_bonus_duration_percent")

	local function CalculateDuration(unit)
		local hp_pct = unit:GetHealthPercent()
		local total_duration = base_duration
		total_duration = total_duration + hp_extra_duration * math.floor((100 - hp_pct) / pct_per_extra)
		return total_duration
	end

	if not caster:HasTalent("special_bonus_imba_enigma_2") then
		local final_duration = CalculateDuration(target)
		target:AddNewModifier(caster, ability, "modifier_imba_enigma_malefice", { duration = final_duration })
	else
		local talent_radius = caster:FindTalentValue("special_bonus_imba_enigma_2")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			target:GetAbsOrigin(),
			nil,
			talent_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)
		for _, enemy in pairs(enemies) do
			local final_duration = CalculateDuration(enemy)
			enemy:AddNewModifier(caster, ability, "modifier_imba_enigma_malefice", { duration = final_duration })
		end
	end
end

modifier_imba_enigma_malefice = modifier_imba_enigma_malefice or class({})

function modifier_imba_enigma_malefice:IsDebuff() return true end

function modifier_imba_enigma_malefice:IsHidden() return false end

function modifier_imba_enigma_malefice:IsPurgable() return true end

function modifier_imba_enigma_malefice:IsStunDebuff() return false end

function modifier_imba_enigma_malefice:IgnoreTenacity() return true end

function modifier_imba_enigma_malefice:GetEffectName() return "particles/units/heroes/hero_enigma/enigma_malefice.vpcf" end

function modifier_imba_enigma_malefice:OnCreated()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local target = self:GetParent()
	local ability = self:GetAbility()
	self.interval = ability:GetVanillaAbilitySpecial("tick_rate")
	self.dmg = ability:GetVanillaAbilitySpecial("damage") + caster:FindTalentValue("special_bonus_imba_enigma_malefice_damage")
	self.stun_duration = ability:GetVanillaAbilitySpecial("stun_duration")
	self:StartIntervalThink(self.interval)
	self:OnIntervalThink()
end

function modifier_imba_enigma_malefice:OnIntervalThink()
	local caster = self:GetCaster()
	local target = self:GetParent()
	local ability = self:GetAbility()
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.dmg,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability
	}
	ApplyDamage(damageTable)
	target:AddNewModifier(caster, ability, "modifier_stunned", { duration = self.stun_duration * (1 - target:GetStatusResistance()) })
	EmitSoundOn("Hero_Enigma.MaleficeTick", target)

	if ability:GetAutoCastState() then
		SearchForEngimaThinker(caster, self:GetParent(), ability:GetSpecialValueFor("pull_strength"))
	end
end

--=================================================================================================================
-- Enigma's Demonic Conversion
--=================================================================================================================

imba_enigma_demonic_conversion = imba_enigma_demonic_conversion or class(VANILLA_ABILITIES_BASECLASS)

LinkLuaModifier("modifier_imba_enigma_eidolon", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_eidolon_attack_counter", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_eidolon_attacks_debuff", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)

function imba_enigma_demonic_conversion:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		-- #8 Talent: Cast Eidolons on heroes
		if caster:HasTalent("special_bonus_imba_enigma_8") and target:IsRealHero() then
			return UF_SUCCESS
		end
		local nResult = UnitFilter(target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber())
		return nResult
	end
end

function imba_enigma_demonic_conversion:OnSpellStart()
	local ability = self
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		if target:TriggerSpellAbsorb(self) then return end
	end
	local location = target:GetAbsOrigin()
	EmitSoundOn("Hero_Enigma.Demonic_Conversion", target)
	if not target:IsHero() then
		target:Kill(ability, caster)
		target = nil
	end
	local eidolon_count = ability:GetVanillaAbilitySpecial("spawn_count") + caster:FindTalentValue("special_bonus_imba_enigma_6")
	if eidolon_count > 0 then
		for i = 1, eidolon_count do
			ability:CreateEidolon(target, location, 1, ability:GetVanillaKeyValue("AbilityDuration"))
		end
	end
end

function imba_enigma_demonic_conversion:CreateEidolon(hParent, vLocation, iWave, fDuration)
	local caster = self:GetCaster()
	hParent = hParent or caster
	local eidolon = CreateUnitByName("npc_imba_enigma_eidolon_" .. math.min(4, self:GetLevel()), vLocation, true, caster, caster, caster:GetTeamNumber())
	eidolon:AddNewModifier(caster, self, "modifier_kill", { duration = fDuration })
	eidolon:SetOwner(caster)
	eidolon:SetControllableByPlayer(caster:GetPlayerID(), true)
	eidolon:SetUnitOnClearGround()

	local attacks_needed = self:GetVanillaAbilitySpecial("split_attack_count") + self:GetSpecialValueFor("additional_attacks_split") * (iWave - 1)
	eidolon:AddNewModifier(caster, self, "modifier_imba_enigma_eidolon", { duration = fDuration, wave = iWave, parent = hParent:entindex(), stack = attacks_needed })
end

modifier_imba_enigma_eidolon = modifier_imba_enigma_eidolon or class({})

function modifier_imba_enigma_eidolon:IsDebuff() return true end

function modifier_imba_enigma_eidolon:IsHidden() return true end

function modifier_imba_enigma_eidolon:IsPurgable() return false end

function modifier_imba_enigma_eidolon:IsPurgeException() return false end

function modifier_imba_enigma_eidolon:IsStunDebuff() return false end

function modifier_imba_enigma_eidolon:RemoveOnDeath() return true end

function modifier_imba_enigma_eidolon:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,

		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end

function modifier_imba_enigma_eidolon:OnCreated(keys)
	self.attacks = keys.stack
	self.last_target = self:GetParent()
	local ability = self:GetAbility()
	if keys.parent then self.parent = EntIndexToHScript(keys.parent) end
	self.parent             = self.parent or self:GetCaster()
	self.trans_pct          = ability:GetSpecialValueFor("shard_percentage")
	self.wave               = keys.wave

	self.armor_bonus        = self.parent:GetPhysicalArmorValue(false) * self.trans_pct / 100
	self.movespeed_bonus    = self.parent:GetIdealSpeed() * self.trans_pct / 100
	self.attack_speed_bonus = (self.parent:GetAttacksPerSecond() * self.parent:GetBaseAttackTime() * 100) * self.trans_pct / 100

	if not IsServer() then return end

	self.health_bonus = self.parent:GetMaxHealth() * self.trans_pct / 100

	if self.parent:HasModifier("modifier_imba_echo_rapier_haste") then
		local echo_buf = self.parent:FindModifierByName("modifier_imba_echo_rapier_haste")
		self.attack_speed_bonus = ((self.parent:GetAttacksPerSecond() * self.parent:GetBaseAttackTime() * 100) - echo_buf.attack_speed_buff) * self.trans_pct / 100
	end

	self.damage_bonus = self.trans_pct * self.parent:GetAverageTrueAttackDamage(self.parent) / 100
	self:SetStackCount(self.damage_bonus)
end

function modifier_imba_enigma_eidolon:GetModifierExtraHealthBonus() if IsServer() then return self.health_bonus end end

function modifier_imba_enigma_eidolon:GetModifierPhysicalArmorBonus() return self.armor_bonus end

function modifier_imba_enigma_eidolon:GetModifierMoveSpeedBonus_Constant() return self.movespeed_bonus end

function modifier_imba_enigma_eidolon:GetModifierAttackSpeedBonus_Constant() return self.attack_speed_bonus end

function modifier_imba_enigma_eidolon:GetModifierPreAttack_BonusDamage() return self:GetStackCount() end

function modifier_imba_enigma_eidolon:GetModifierAttackRangeBonus()
	if self:GetCaster() and not self:GetCaster():IsNull() and self:GetCaster():HasTalent("special_bonus_imba_enigma_demonic_conversion_attack_range") then
		return self:GetCaster():FindTalentValue("special_bonus_imba_enigma_demonic_conversion_attack_range")
	end
end

function modifier_imba_enigma_eidolon:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker == self:GetParent() and not keys.target:IsBuilding() and self:GetParent():GetOwner() == self:GetCaster() then
		if self:GetParent():GetTeamNumber() ~= keys.target:GetTeamNumber() then
			local target = keys.target
			if not target:HasModifier("modifier_imba_enigma_eidolon_attack_counter") then
				target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_enigma_eidolon_attack_counter", {})
			end
			if not self:GetParent():IsNull() and not self.last_target:IsNull() and self.last_target:FindModifierByNameAndCaster("modifier_imba_enigma_eidolon_attacks_debuff", self:GetParent()) then
				self.last_target:FindModifierByNameAndCaster("modifier_imba_enigma_eidolon_attacks_debuff", self:GetParent()):Destroy()
			end
			self.last_target = target
			target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_enigma_eidolon_attacks_debuff", { duration = self:GetAbility():GetSpecialValueFor("increased_mass_duration") * (1 - target:GetStatusResistance()) })
		end

		if self.attacks > 1 then
			self.attacks = self.attacks - 1
		else
			self:GetAbility():CreateEidolon(self.parent, self:GetParent():GetAbsOrigin(), self.wave + 1, self:GetRemainingTime() + self:GetAbility():GetVanillaAbilitySpecial("life_extension"))
			self:GetAbility():CreateEidolon(self.parent, self:GetParent():GetAbsOrigin(), self.wave + 1, self:GetRemainingTime() + self:GetAbility():GetVanillaAbilitySpecial("life_extension"))
			self:GetParent():ForceKill(false)
		end
	end
end

modifier_imba_enigma_eidolon_attack_counter = modifier_imba_enigma_eidolon_attack_counter or class({})
modifier_imba_enigma_eidolon_attacks_debuff = modifier_imba_enigma_eidolon_attacks_debuff or class({})

function modifier_imba_enigma_eidolon_attack_counter:IsDebuff() return true end

function modifier_imba_enigma_eidolon_attack_counter:IsHidden() return false end

function modifier_imba_enigma_eidolon_attack_counter:IsPurgable() return true end

function modifier_imba_enigma_eidolon_attack_counter:IsPurgeException() return true end

function modifier_imba_enigma_eidolon_attack_counter:IsStunDebuff() return false end

function modifier_imba_enigma_eidolon_attack_counter:RemoveOnDeath() return true end

function modifier_imba_enigma_eidolon_attack_counter:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(0.1)
end

function modifier_imba_enigma_eidolon_attack_counter:OnIntervalThink()
	local debuffs = self:GetParent():FindAllModifiersByName("modifier_imba_enigma_eidolon_attacks_debuff")
	if #debuffs > 0 then
		self:SetStackCount(#debuffs)
	else
		self:Destroy()
	end
end

function modifier_imba_enigma_eidolon_attacks_debuff:IsDebuff() return true end

function modifier_imba_enigma_eidolon_attacks_debuff:IsHidden() return true end

function modifier_imba_enigma_eidolon_attacks_debuff:IsPurgable() return true end

function modifier_imba_enigma_eidolon_attacks_debuff:IsPurgeException() return true end

function modifier_imba_enigma_eidolon_attacks_debuff:IsStunDebuff() return false end

function modifier_imba_enigma_eidolon_attacks_debuff:RemoveOnDeath() return true end

function modifier_imba_enigma_eidolon_attacks_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

--=================================================================================================================
-- Enigma's Midnight Pulse
--=================================================================================================================

imba_enigma_midnight_pulse = imba_enigma_midnight_pulse or class(VANILLA_ABILITIES_BASECLASS)

LinkLuaModifier("modifier_imba_enigma_midnight_pulse_thinker", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_midnight_pulse_aura", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)

function imba_enigma_midnight_pulse:GetAOERadius() return self:GetVanillaAbilitySpecial("radius") end

function imba_enigma_midnight_pulse:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetVanillaAbilitySpecial("duration")
	local radius = self:GetVanillaAbilitySpecial("radius")
	EmitSoundOnLocationWithCaster(point, "Hero_Enigma.Midnight_Pulse", caster)
	GridNav:DestroyTreesAroundPoint(point, radius, false)
	CreateModifierThinker(caster, self, "modifier_imba_enigma_midnight_pulse_thinker", { duration = duration }, point, caster:GetTeamNumber(), false)
end

modifier_imba_enigma_midnight_pulse_thinker = modifier_imba_enigma_midnight_pulse_thinker or class({})

function modifier_imba_enigma_midnight_pulse_thinker:IsAura() return true end

function modifier_imba_enigma_midnight_pulse_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_imba_enigma_midnight_pulse_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end

function modifier_imba_enigma_midnight_pulse_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end

function modifier_imba_enigma_midnight_pulse_thinker:GetAuraRadius() return self.radius end

function modifier_imba_enigma_midnight_pulse_thinker:GetModifierAura() return "modifier_imba_enigma_midnight_pulse_aura" end

function modifier_imba_enigma_midnight_pulse_thinker:OnCreated(keys)
	if not IsServer() then return end
	local caster = self:GetCaster()

	-- local findDummy = CreateUnitByName("npc_dummy_unit", self:GetParent():GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
	-- findDummy.midnight = true
	-- findDummy:AddNewModifier(caster, nil, "modifier_kill", {duration = self:GetDuration()})

	self:GetParent().midnight = true

	self.radius = self:GetAbility():GetVanillaAbilitySpecial("radius")
	self.pull_length = self:GetAbility():GetSpecialValueFor("pull_strength")
	self:StartIntervalThink(1.0)
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius, 0, 0))
end

function modifier_imba_enigma_midnight_pulse_thinker:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	GridNav:DestroyTreesAroundPoint(parent:GetAbsOrigin(), self.radius, false)
	local dmg_pct = ability:GetVanillaAbilitySpecial("damage_percent") / 100
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		parent:GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)
	for _, enemy in pairs(enemies) do
		if not enemy:IsRoshan() then
			local dmg = enemy:GetMaxHealth() * dmg_pct
			local damageTable = {
				victim = enemy,
				attacker = caster,
				damage = dmg,
				damage_type = ability:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				ability = ability
			}
			ApplyDamage(damageTable)
			SearchForEngimaThinker(caster, enemy, self.pull_length)
		end
	end
	local eidolons = FindUnitsInRadius(caster:GetTeamNumber(),
		parent:GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	for _, eidolon in pairs(eidolons) do
		if eidolon:HasModifier("modifier_imba_enigma_eidolon") then
			eidolon:Heal(ability:GetSpecialValueFor("eidolon_hp_regen"), nil)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, eidolon, ability:GetSpecialValueFor("eidolon_hp_regen"), nil)
		end
	end

	-- growable radius talent
	if caster:HasTalent("special_bonus_imba_enigma_3") then
		self.radius = self.radius + ability:GetVanillaAbilitySpecial("radius") / ability:GetVanillaAbilitySpecial("duration")
		ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius, 0, 0))
	end
end

function modifier_imba_enigma_midnight_pulse_thinker:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
end

modifier_imba_enigma_midnight_pulse_aura = modifier_imba_enigma_midnight_pulse_aura or class({})

function modifier_imba_enigma_midnight_pulse_aura:IsDebuff() return true end

function modifier_imba_enigma_midnight_pulse_aura:IsHidden() return false end

function modifier_imba_enigma_midnight_pulse_aura:IsPurgable() return false end

function modifier_imba_enigma_midnight_pulse_aura:IsPurgeException() return false end

function modifier_imba_enigma_midnight_pulse_aura:GetTexture() return "enigma_midnight_pulse" end

--=================================================================================================================
-- Enigma's Black Hole
--=================================================================================================================

imba_enigma_black_hole = imba_enigma_black_hole or class(VANILLA_ABILITIES_BASECLASS)
LinkLuaModifier("modifier_imba_enigma_black_hole_thinker", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_black_hole", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE) --Auctually enemies' buff
LinkLuaModifier("modifier_imba_enigma_black_hole_pull", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_singularity", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_enigma_1", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_enigma_5", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)

function imba_enigma_black_hole:IsHiddenWhenStolen() return false end

function imba_enigma_black_hole:IsRefreshable() return true end

function imba_enigma_black_hole:IsStealable() return true end

function imba_enigma_black_hole:IsNetherWardStealable() return true end

function imba_enigma_black_hole:OnOwnerSpawned()
	if not IsServer() then return end
	if self:GetCaster():HasAbility("special_bonus_imba_enigma_1") and self:GetCaster():FindAbilityByName("special_bonus_imba_enigma_1"):IsTrained() and not self:GetCaster():HasModifier("modifier_special_bonus_imba_enigma_1") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_enigma_1", {})
	end
	if self:GetCaster():HasAbility("special_bonus_imba_enigma_5") and self:GetCaster():FindAbilityByName("special_bonus_imba_enigma_5"):IsTrained() and not self:GetCaster():HasModifier("modifier_special_bonus_imba_enigma_5") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_enigma_5", {})
	end
end

function imba_enigma_black_hole:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("cast_range") + self:GetCaster():FindTalentValue("special_bonus_imba_enigma_5")
end

--[[
function imba_enigma_black_hole:GetCooldown(nLevel)
	local charges = self:GetCaster():GetModifierStackCount("modifier_imba_singularity", self:GetCaster())
	--return math.max(30, self.BaseClass.GetCooldown( self, nLevel ) - charges * self:GetCaster():FindTalentValue("special_bonus_imba_enigma_1"))
	
	return math.max(self.BaseClass.GetCooldown( self, nLevel ) * (1 - charges * self:GetSpecialValueFor("cdr_pct_per_stack") / 100), 0)
end
--]]
function imba_enigma_black_hole:GetIntrinsicModifierName()
	return "modifier_imba_singularity"
end

function imba_enigma_black_hole:GetAOERadius()
	return self:GetVanillaAbilitySpecial("radius") + self:GetCaster():GetModifierStackCount("modifier_imba_singularity", self:GetCaster()) * self:GetSpecialValueFor("singularity_stun_radius_increment_per_stack")
end

function imba_enigma_black_hole:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local ability = self
	local base_radius = self:GetVanillaAbilitySpecial("radius")
	local extra_radius = self:GetSpecialValueFor("singularity_stun_radius_increment_per_stack")
	local base_pull_radius = self:GetVanillaAbilitySpecial("scepter_radius")
	local extra_pull_radius = self:GetSpecialValueFor("singularity_pull_radius_increment_per_stack")
	self.radius = base_radius + extra_radius * caster:FindModifierByName("modifier_imba_singularity"):GetStackCount()
	self.pull_radius = base_pull_radius + extra_pull_radius * caster:FindModifierByName("modifier_imba_singularity"):GetStackCount()
	local duration = self:GetVanillaAbilitySpecial("duration")
	self.thinker = CreateModifierThinker(caster, self, "modifier_imba_enigma_black_hole_thinker", { duration = duration }, pos, caster:GetTeamNumber(), false)

	--[[
	-- Force a minimum CD for sanity
	if not GameRules:IsCheatMode() and self:GetCooldownTimeRemaining() <= self:GetSpecialValueFor("min_cd_cap") then
		self:EndCooldown()
		self:StartCooldown(self:GetSpecialValueFor("min_cd_cap"))
	end
--]]
end

function imba_enigma_black_hole:OnChannelFinish(bInterrupted)
	StopSoundOn("Hero_Enigma.Black_Hole", self.thinker)
	StopSoundOn("Hero_Enigma.BlackHole.Cast", self.thinker)
	if bInterrupted then
		self.thinker:FindModifierByName("modifier_imba_enigma_black_hole_thinker"):Destroy()

		local singularity = self:GetCaster():FindModifierByName("modifier_imba_singularity")
		if not singularity then return end

		local caster = self:GetCaster()
		local d_pct  = self:GetSpecialValueFor("interrupt_disable_loss_pct")
		local m_pct  = self:GetSpecialValueFor("interrupt_manual_loss_pct")

		-- Wait a frame to check for any disables that have been added on I guess...
		Timers:CreateTimer(FrameTime(), function()
			if caster:IsRooted() or caster:IsSilenced() or caster:IsStunned() or caster:IsHexed() or caster:IsCommandRestricted() or not caster:IsAlive() then
				singularity:SetStackCount(math.floor(singularity:GetStackCount() * (100 - d_pct) / 100))
			else
				singularity:SetStackCount(math.floor(singularity:GetStackCount() * (100 - m_pct) / 100))
			end
		end)
	end
end

function imba_enigma_black_hole:OnOwnerDied()
	local singularity = self:GetCaster():FindModifierByName("modifier_imba_singularity")
	if singularity then
		singularity:SetStackCount(math.floor(singularity:GetStackCount() * (100 - self:GetSpecialValueFor("death_loss_pct")) / 100))
	end
end

modifier_imba_enigma_black_hole_thinker = modifier_imba_enigma_black_hole_thinker or class({})
modifier_imba_enigma_black_hole = modifier_imba_enigma_black_hole or class({})
modifier_imba_enigma_black_hole_pull = modifier_imba_enigma_black_hole_pull or class({})

function modifier_imba_enigma_black_hole_thinker:IsAura() return true end

function modifier_imba_enigma_black_hole_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_imba_enigma_black_hole_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end

function modifier_imba_enigma_black_hole_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end

function modifier_imba_enigma_black_hole_thinker:GetAuraRadius() return self.radius end

function modifier_imba_enigma_black_hole_thinker:GetModifierAura() return "modifier_imba_enigma_black_hole" end

function modifier_imba_enigma_black_hole_thinker:OnCreated(keys)
	--	self.singularity_cap = self:GetAbility():GetSpecialValueFor("singularity_cap")
	self.radius = self:GetAbility().radius
	self.pull_radius = self:GetAbility().pull_radius
	if not IsServer() then return end

	if self:GetCaster().black_hole_effect then
		self.pfx_ulti = ParticleManager:CreateParticle("particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_leash_gold_body_energy_pull.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.pfx_ulti, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(self.pfx_ulti, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(self.pfx_ulti, 3, self:GetParent():GetAbsOrigin())
	end

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
		FIND_ANY_ORDER,
		false
	)

	if #enemies >= PlayerResource:GetPlayerCountForTeam(self:GetParent():GetOpposingTeamNumber()) then
		EmitSoundOn("Imba.EnigmaBlackHoleTobi0" .. math.random(1, 5), self:GetParent())
	end

	local buff = self:GetCaster():FindModifierByName("modifier_imba_singularity")
	local stacks = buff:GetStackCount()

	--Add singularity stacks (no more cap)
	if not keys.talent then
		--if stacks + #enemies < self.singularity_cap then
		buff:SetStackCount(stacks + #enemies)
		--else
		--	buff:SetStackCount(self.singularity_cap)
		--end
	end

	EmitSoundOn("Hero_Enigma.Black_Hole", self:GetParent())
	EmitSoundOn("Hero_Enigma.BlackHole.Cast", self:GetParent())

	local dummy = self:GetParent()

	self:GetParent():SetContextThink(DoUniqueString("StopBHsound"), function()
		StopSoundOn("Hero_Enigma.Black_Hole", dummy)
		StopSoundOn("Hero_Enigma.BlackHole.Cast", dummy)
		return nil
	end, 4.0)

	local actual_vision = self.radius

	if self:GetCaster():HasShard() then
		actual_vision = self.pull_radius
	end

	self.particle = ParticleManager:CreateParticle("particles/hero/enigma/enigma_blackhole_scaleable.vpcf", PATTACH_WORLDORIGIN, nil, self:GetCaster())
	ParticleManager:SetParticleControl(self.particle, 0, Vector(self:GetParent():GetAbsOrigin().x, self:GetParent():GetAbsOrigin().y, self:GetParent():GetAbsOrigin().z + 64))
	ParticleManager:SetParticleControl(self.particle, 10, Vector(self.radius, actual_vision, 0))

	-- Create an FoW viewer for all teams so everyone sees it
	for i = DOTA_TEAM_FIRST, DOTA_TEAM_CUSTOM_MAX do
		if i == self:GetParent():GetTeamNumber() then
			AddFOWViewer(i, self:GetParent():GetAbsOrigin(), actual_vision, FrameTime() * 2, false)
		else
			AddFOWViewer(i, self:GetParent():GetAbsOrigin(), 10, FrameTime() * 2, false)
		end
	end

	-- Break trees. Because fuck trees.
	GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), actual_vision, false)

	self.think_time = 0
	self.dmg = self:GetAbility():GetVanillaAbilitySpecial("damage")
	self:StartIntervalThink(FrameTime())

	--Scepter stuff
	if self:GetCaster():HasScepter() then
		self.scepter = true
	end
end

function modifier_imba_enigma_black_hole_thinker:OnIntervalThink()
	if not IsServer() then return end
	self.think_time = self.think_time + FrameTime()

	-- Create an FoW viewer for all teams so everyone sees it
	for i = DOTA_TEAM_FIRST, DOTA_TEAM_CUSTOM_MAX do
		if i == self:GetParent():GetTeamNumber() then
			AddFOWViewer(i, self:GetParent():GetAbsOrigin(), self.pull_radius, FrameTime() * 2, false)
		else
			AddFOWViewer(i, self:GetParent():GetAbsOrigin(), 10, FrameTime() * 2, false)
		end
	end

	-- Pull effect
	if self:GetCaster():HasShard() then
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.pull_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		for _, enemy in pairs(enemies) do
			if not enemy:IsRoshan() then
				enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_enigma_black_hole_pull", {})
			end
		end
	end

	-- Damage
	if self.think_time >= 1.0 then
		self.think_time = self.think_time - 1.0
		local midnightDamagePcnt = 0
		if self.scepter then
			local midnight = self:GetCaster():FindAbilityByName("imba_enigma_midnight_pulse")
			if midnight and midnight:GetLevel() > 0 then
				midnightDamagePcnt = midnight:GetVanillaAbilitySpecial("damage_percent") / 100
			end
		end

		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if not enemy:IsRoshan() then
				ApplyDamage({ victim = enemy, attacker = self:GetCaster(), damage = self.dmg, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility() })

				if self.scepter then
					ApplyDamage({ victim = enemy, attacker = self:GetCaster(), damage = enemy:GetMaxHealth() * midnightDamagePcnt, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility() })
				end
			end
		end

		-- Here's a big one
		local singularity = self:GetCaster():FindModifierByName("modifier_imba_singularity")
		if singularity and singularity:GetStackCount() >= self:GetAbility():GetSpecialValueFor("singularity_cap") and not IsNearFountain(self:GetCaster():GetAbsOrigin(), 2500) then
			local buildings = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

			for _, building in pairs(buildings) do
				ApplyDamage({ victim = building, attacker = self:GetCaster(), damage = self.dmg, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility() })

				building:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = 1.0 * (1 - building:GetStatusResistance()) })
			end
		end
	end
end

function modifier_imba_enigma_black_hole_thinker:OnDestroy()
	if not IsServer() then return end
	StopSoundOn("Hero_Enigma.Black_Hole", self:GetParent())
	StopSoundOn("Hero_Enigma.BlackHole.Cast", self:GetParent())
	StopSoundOn("Hero_Enigma.BlackHole.Cast.Chasm", self:GetParent())
	EmitSoundOn("Hero_Enigma.Black_Hole.Stop", self:GetParent())
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
	if self.pfx_ulti then
		ParticleManager:DestroyParticle(self.pfx_ulti, false)
		ParticleManager:ReleaseParticleIndex(self.pfx_ulti)
	end
	self:GetParent():ForceKill(false)
end

function modifier_imba_enigma_black_hole:IsDebuff() return true end

function modifier_imba_enigma_black_hole:IsHidden() return false end

function modifier_imba_enigma_black_hole:IsPurgable() return false end

function modifier_imba_enigma_black_hole:IsPurgeException() return false end

function modifier_imba_enigma_black_hole:RemoveOnDeath() return false end

function modifier_imba_enigma_black_hole:IsStunDebuff() return true end

function modifier_imba_enigma_black_hole:IsMotionController() return true end

function modifier_imba_enigma_black_hole:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end

function modifier_imba_enigma_black_hole:CheckState()
	if not IsServer() then return end
	local state = {}
	--Does not affect Roshan
	if not self:GetParent():IsRoshan() then
		state =
		{
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_MUTED] = true,
			[MODIFIER_STATE_STUNNED] = true,
		}
	end
	return state
end

function modifier_imba_enigma_black_hole:OnCreated()
	if not IsServer() then return end
	if self:GetParent() and self:GetParent():IsRoshan() then self:Destroy() end --Roshan is immune to Black Hole
	self:StartIntervalThink(FrameTime())
	local ability = self:GetAbility()
	self.radius = self:GetAbility().radius
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
end

function modifier_imba_enigma_black_hole:OnIntervalThink()
	local enigma = self:GetCaster()
	local ability = self:GetAbility()
	if not ability:IsChanneling() then
		self:Destroy()
	end
	if ability.thinker then
		local distance = CalcDistanceBetweenEntityOBB(ability.thinker, self:GetParent())
		if distance > self.radius then
			self:Destroy()
		end
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_imba_enigma_black_hole:HorizontalMotion(unit, time)
	local thinker = self:GetAbility().thinker
	local pos = unit:GetAbsOrigin()
	if thinker and not thinker:IsNull() and self:GetAbility():IsChanneling() then
		local thinker_pos = thinker:GetAbsOrigin()
		local next_pos = GetGroundPosition(RotatePosition(thinker_pos, QAngle(0, 0.5, 0), pos), unit)
		local distance = CalcDistanceBetweenEntityOBB(unit, thinker)
		if distance > 20 then
			next_pos = GetGroundPosition((next_pos + (thinker_pos - next_pos):Normalized() * 1), unit)
		end
		unit:SetAbsOrigin(next_pos)
	end
end

function modifier_imba_enigma_black_hole:OnDestroy()
	if not IsServer() then return end
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_imba_enigma_black_hole_pull:IsDebuff() return true end

function modifier_imba_enigma_black_hole_pull:IsHidden() return true end

function modifier_imba_enigma_black_hole_pull:IsPurgable() return false end

function modifier_imba_enigma_black_hole_pull:IsPurgeException() return false end

function modifier_imba_enigma_black_hole_pull:RemoveOnDeath() return false end

function modifier_imba_enigma_black_hole_pull:IsStunDebuff() return true end

function modifier_imba_enigma_black_hole_pull:IsMotionController() return true end

function modifier_imba_enigma_black_hole_pull:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end

function modifier_imba_enigma_black_hole_pull:OnCreated()
	--	self.ms_reduction	= self:GetAbility():GetSpecialValueFor("ms_reduction")

	if not IsServer() then return end
	if self:GetParent():IsRoshan() then self:Destroy() end --Roshan is immune to Black Hole
	self:StartIntervalThink(FrameTime())
	local ability = self:GetAbility()
	self.pull_radius = self:GetAbility().pull_radius
	self.base_pull_distance = ability:GetVanillaAbilitySpecial("scepter_drag_speed")
end

function modifier_imba_enigma_black_hole_pull:OnIntervalThink()
	local enigma = self:GetCaster()
	local ability = self:GetAbility()

	if not ability:IsChanneling() then
		self:Destroy()
	end

	if ability.thinker then
		local distance = CalcDistanceBetweenEntityOBB(ability.thinker, self:GetParent())
		if distance > self.pull_radius then
			self:Destroy()
		end
	end

	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_imba_enigma_black_hole_pull:HorizontalMotion(unit, time)
	self.pull_distance = CalculatePullLength(self:GetCaster(), self:GetParent(), self.base_pull_distance) / (1.0 / FrameTime())
	local thinker = self:GetAbility().thinker
	local pos = unit:GetAbsOrigin()

	if thinker and not thinker:IsNull() and self:GetAbility():IsChanneling() and not self:GetParent():HasModifier("modifier_imba_enigma_black_hole") then
		local thinker_pos = thinker:GetAbsOrigin()
		local next_pos = GetGroundPosition((pos + (thinker_pos - pos):Normalized() * self.pull_distance), unit)

		unit:SetAbsOrigin(next_pos)
	end
end

function modifier_imba_enigma_black_hole_pull:OnDestroy()
	if not IsServer() then return end

	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

--[[
function modifier_imba_enigma_black_hole_pull:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_imba_enigma_black_hole_pull:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_reduction * (-1)
end
--]]
modifier_imba_singularity = modifier_imba_singularity or class({})

function modifier_imba_singularity:IsDebuff() return false end

function modifier_imba_singularity:IsHidden() return false end

function modifier_imba_singularity:IsPurgable() return false end

function modifier_imba_singularity:IsPurgeException() return false end

function modifier_imba_singularity:RemoveOnDeath() return false end

function modifier_imba_singularity:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_imba_singularity:OnDeath(keys)
	if IsServer() and keys.unit == self:GetParent() and self:GetParent():HasTalent("special_bonus_imba_enigma_4") and self:GetParent():IsRealHero() then
		local ability = self:GetAbility()
		local duration = ability:GetVanillaAbilitySpecial("duration") / self:GetParent():FindTalentValue("special_bonus_imba_enigma_4")
		local base_radius = ability:GetVanillaAbilitySpecial("radius")
		local extra_radius = ability:GetSpecialValueFor("singularity_stun_radius_increment_per_stack")
		local base_pull_radius = ability:GetSpecialValueFor("pull_radius")
		local extra_pull_radius = ability:GetSpecialValueFor("singularity_pull_radius_increment_per_stack")
		ability.radius = base_radius + extra_radius * keys.unit:FindModifierByName("modifier_imba_singularity"):GetStackCount()
		ability.pull_radius = base_pull_radius + extra_pull_radius * keys.unit:FindModifierByName("modifier_imba_singularity"):GetStackCount()

		Timers:CreateTimer(FrameTime(), function()
			ability.thinker = CreateModifierThinker(keys.unit, ability, "modifier_imba_enigma_black_hole_thinker", { duration = duration, talent = 1 }, keys.unit:GetAbsOrigin(), keys.unit:GetTeamNumber(), false)
		end)
	end
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_enigma_8", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_enigma_malefice_damage", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_enigma_3", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_enigma_4", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_enigma_8 = modifier_special_bonus_imba_enigma_8 or class({})
modifier_special_bonus_imba_enigma_malefice_damage = modifier_special_bonus_imba_enigma_malefice_damage or class({})
modifier_special_bonus_imba_enigma_3 = modifier_special_bonus_imba_enigma_3 or class({})
modifier_special_bonus_imba_enigma_4 = modifier_special_bonus_imba_enigma_4 or class({})

function modifier_special_bonus_imba_enigma_8:IsHidden() return true end

function modifier_special_bonus_imba_enigma_8:IsPurgable() return false end

function modifier_special_bonus_imba_enigma_8:RemoveOnDeath() return false end

function modifier_special_bonus_imba_enigma_malefice_damage:IsHidden() return true end

function modifier_special_bonus_imba_enigma_malefice_damage:IsPurgable() return false end

function modifier_special_bonus_imba_enigma_malefice_damage:RemoveOnDeath() return false end

function modifier_special_bonus_imba_enigma_3:IsHidden() return true end

function modifier_special_bonus_imba_enigma_3:IsPurgable() return false end

function modifier_special_bonus_imba_enigma_3:RemoveOnDeath() return false end

function modifier_special_bonus_imba_enigma_4:IsHidden() return true end

function modifier_special_bonus_imba_enigma_4:IsPurgable() return false end

function modifier_special_bonus_imba_enigma_4:RemoveOnDeath() return false end

---------------------------------------------------------------------------------------------------------
-- Adding separate modifier initializations here for talents that need client-side interaction as well --
---------------------------------------------------------------------------------------------------------

modifier_special_bonus_imba_enigma_1 = class({})

function modifier_special_bonus_imba_enigma_1:IsHidden() return true end

function modifier_special_bonus_imba_enigma_1:IsPurgable() return false end

function modifier_special_bonus_imba_enigma_1:RemoveOnDeath() return false end

modifier_special_bonus_imba_enigma_2 = class({})

function modifier_special_bonus_imba_enigma_2:IsHidden() return true end

function modifier_special_bonus_imba_enigma_2:IsPurgable() return false end

function modifier_special_bonus_imba_enigma_2:RemoveOnDeath() return false end

modifier_special_bonus_imba_enigma_5 = class({})

function modifier_special_bonus_imba_enigma_5:IsHidden() return true end

function modifier_special_bonus_imba_enigma_5:IsPurgable() return false end

function modifier_special_bonus_imba_enigma_5:RemoveOnDeath() return false end

LinkLuaModifier("modifier_special_bonus_imba_enigma_demonic_conversion_attack_range", "components/abilities/heroes/hero_enigma", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_enigma_demonic_conversion_attack_range = modifier_special_bonus_imba_enigma_demonic_conversion_attack_range or class({})

function modifier_special_bonus_imba_enigma_demonic_conversion_attack_range:IsHidden() return true end

function modifier_special_bonus_imba_enigma_demonic_conversion_attack_range:IsPurgable() return false end

function modifier_special_bonus_imba_enigma_demonic_conversion_attack_range:RemoveOnDeath() return false end

function imba_enigma_demonic_conversion:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_enigma_demonic_conversion_attack_range") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_enigma_demonic_conversion_attack_range") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_enigma_demonic_conversion_attack_range"), "modifier_special_bonus_imba_enigma_demonic_conversion_attack_range", {})
	end
end
