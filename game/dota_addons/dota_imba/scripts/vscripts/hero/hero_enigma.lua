--[[
		Author: MouJiaoZi
		Date: 2017/12/15

]]

CreateEmptyTalents("enigma")

--=================================================================================================================
-- Enigma's Malefice
--=================================================================================================================

imba_enigma_malefice = imba_enigma_malefice or class({})

LinkLuaModifier("modifier_imba_enigma_malefice","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)

function imba_enigma_malefice:IsHiddenWhenStolen() 		return false end
function imba_enigma_malefice:IsRefreshable() 			return true  end
function imba_enigma_malefice:IsStealable() 			return true  end
function imba_enigma_malefice:IsNetherWardStealable() 	return false end

function imba_enigma_malefice:GetAOERadius()
	if self:GetCaster():HasTalent("special_bonus_imba_enigma_2") then
		return self:GetCaster():FindTalentValue("special_bonus_imba_enigma_2")
	else
		return 0
	end
end

function imba_enigma_malefice:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb(self) then return end
	local ability = self
	local base_duration = ability:GetSpecialValueFor("total_duration")
	local hp_extra_duration = ability:GetSpecialValueFor("health_bonus_duration")
	local pct_per_extra = ability:GetSpecialValueFor("health_bonus_duration_percent")

	local function CalculateDuration(unit)
		local hp_pct = unit:GetHealthPercent()
		local total_duration = base_duration
		total_duration = total_duration + hp_extra_duration * math.floor((100-hp_pct)/pct_per_extra)
		return total_duration
	end

	if not caster:HasTalent("special_bonus_imba_enigma_2") then
		local final_duration = CalculateDuration(target)
		target:AddNewModifier(caster, ability, "modifier_imba_enigma_malefice", {duration = final_duration})
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
			enemy:AddNewModifier(caster, ability, "modifier_imba_enigma_malefice", {duration = final_duration})
		end
	end
end

modifier_imba_enigma_malefice = modifier_imba_enigma_malefice or class({})

function modifier_imba_enigma_malefice:IsDebuff() return true end
function modifier_imba_enigma_malefice:IsHidden() return false end
function modifier_imba_enigma_malefice:IsPurgable() return true end
function modifier_imba_enigma_malefice:IsStunDebuff() return false end

function modifier_imba_enigma_malefice:GetEffectName() return "particles/units/heroes/hero_enigma/enigma_malefice.vpcf" end

function modifier_imba_enigma_malefice:OnCreated()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local target = self:GetParent()
	local ability = self:GetAbility()
	self.interval = ability:GetSpecialValueFor("tick_interval")
	self.dmg = ability:GetSpecialValueFor("tick_damage")
	self.stun_duration = ability:GetSpecialValueFor("stun_duration")
	self:StartIntervalThink(self.interval)
	self:OnIntervalThink()
end

function modifier_imba_enigma_malefice:OnIntervalThink()
	local caster = self:GetCaster()
	local target = self:GetParent()
	local ability = self:GetAbility()
	local damageTable = {victim = self:GetParent(),
						attacker = self:GetCaster(),
						damage = self.dmg,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = ability}
	ApplyDamage(damageTable)
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = self.stun_duration})
	EmitSoundOn("Hero_Enigma.MaleficeTick", target)
end

--=================================================================================================================
-- Enigma's Demonic Conversion
--=================================================================================================================

imba_enigma_demonic_conversion = imba_enigma_demonic_conversion or class({})

LinkLuaModifier("modifier_imba_enigma_eidolon","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("DOTA_Tooltip_modifier_imba_enigma_eidolon_attack_counter","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_eidolon_attacks_debuff","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)

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
	EmitSoundOn("Hero_Enigma.Demonic_Conversion",target)
	if not target:IsHero() then
		target:Kill(ability, caster)
		target = nil
	end
	local eidolon_count = ability:GetSpecialValueFor("eidolon_count")
	if eidolon_count > 0 then
		for i=1,eidolon_count do
			ability:CreateEidolon(target, location, 1, ability:GetSpecialValueFor("duration"))
		end
	end

end

function imba_enigma_demonic_conversion:CreateEidolon(hParent, vLocation, iWave, fDuration)
	local caster = self:GetCaster()
	hParent = hParent or caster
	local eidolon = CreateUnitByName("npc_imba_enigma_eidolon_"..math.min(4,self:GetLevel()), vLocation, true, caster, caster, caster:GetTeamNumber())
	eidolon:AddNewModifier(caster, self, "modifier_kill", {duration = fDuration})
	eidolon:SetOwner(caster)
	eidolon:SetControllableByPlayer(caster:GetPlayerID(), true)
	eidolon:SetUnitOnClearGround()

	local attacks_needed = self:GetSpecialValueFor("attacks_to_split") + self:GetSpecialValueFor("additional_attacks_split") * (iWave - 1)
	eidolon:AddNewModifier(caster, self, "modifier_imba_enigma_eidolon", {duration = fDuration, wave = iWave, parent = hParent:entindex(), stack = attacks_needed})
end

modifier_imba_enigma_eidolon = modifier_imba_enigma_eidolon or class({})

function modifier_imba_enigma_eidolon:IsDebuff() return false end
function modifier_imba_enigma_eidolon:IsHidden() return true end
function modifier_imba_enigma_eidolon:IsPurgable() return false end

function modifier_imba_enigma_eidolon:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_imba_enigma_eidolon:OnCreated( keys )
	self.attacks = keys.stack
	self.last_target = self:GetParent()
	local ability = self:GetAbility()
	if keys.parent then self.parent = EntIndexToHScript(keys.parent) end
	self.parent = self.parent or self:GetCaster()
	self.trans_pct = ability:GetSpecialValueFor("shard_percentage")
	self.wave = keys.wave
end

function modifier_imba_enigma_eidolon:GetModifierExtraHealthBonus() if IsServer() then return self.parent:GetMaxHealth() * self.trans_pct * 0.01 end end
function modifier_imba_enigma_eidolon:GetModifierPhysicalArmorBonus() return self.parent:GetPhysicalArmorValue() * self.trans_pct * 0.01 end
function modifier_imba_enigma_eidolon:GetModifierMoveSpeedBonus_Constant() return self.parent:GetIdealSpeed() * self.trans_pct * 0.01 end
function modifier_imba_enigma_eidolon:GetModifierAttackSpeedBonus_Constant() return self.parent:GetAttackSpeed() * self.trans_pct * 0.01 end
function modifier_imba_enigma_eidolon:GetModifierPreAttack_BonusDamage()
	if IsServer() then
		local attack = self.trans_pct * self.parent:GetAverageTrueAttackDamage(self.parent)
		self:SetStackCount(attack)
	end
	local number = self:GetStackCount() * 0.01
	return number
end

function modifier_imba_enigma_eidolon:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker == self:GetParent() and not keys.target:IsBuilding() then
		if self:GetParent():GetTeamNumber() ~= keys.target:GetTeamNumber() then
			local target = keys.target
			if not target:HasModifier("DOTA_Tooltip_modifier_imba_enigma_eidolon_attack_counter") then
				target:AddNewModifier(self:GetParent(), self:GetAbility(), "DOTA_Tooltip_modifier_imba_enigma_eidolon_attack_counter", {})
			end
			if self.last_target ~= target and self.last_target:FindModifierByNameAndCaster("modifier_imba_enigma_eidolon_attacks_debuff", self:GetParent()) then
				self.last_target:FindModifierByNameAndCaster("modifier_imba_enigma_eidolon_attacks_debuff", self:GetParent()):Destroy()
			end
			self.last_target = target
			target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_enigma_eidolon_attacks_debuff", {duration = self:GetAbility():GetSpecialValueFor("increased_mass_duration")})
		end

		if self.attacks > 1 then
			self.attacks = self.attacks - 1
		else
			self:GetAbility():CreateEidolon(self.parent, self:GetParent():GetAbsOrigin(), self.wave + 1, self:GetRemainingTime() + self:GetAbility():GetSpecialValueFor("child_duration"))
			self:GetAbility():CreateEidolon(self.parent, self:GetParent():GetAbsOrigin(), self.wave + 1, self:GetRemainingTime() + self:GetAbility():GetSpecialValueFor("child_duration"))
			self:GetParent():ForceKill(false)
		end
	end
end

DOTA_Tooltip_modifier_imba_enigma_eidolon_attack_counter = DOTA_Tooltip_modifier_imba_enigma_eidolon_attack_counter or class({})
modifier_imba_enigma_eidolon_attacks_debuff = modifier_imba_enigma_eidolon_attacks_debuff or class({})

function DOTA_Tooltip_modifier_imba_enigma_eidolon_attack_counter:IsDebuff()			return true end
function DOTA_Tooltip_modifier_imba_enigma_eidolon_attack_counter:IsHidden() 			return false end
function DOTA_Tooltip_modifier_imba_enigma_eidolon_attack_counter:IsPurgable() 		return true end
function DOTA_Tooltip_modifier_imba_enigma_eidolon_attack_counter:IsPurgeException() 	return true end
function DOTA_Tooltip_modifier_imba_enigma_eidolon_attack_counter:IsStunDebuff() 		return false end
function DOTA_Tooltip_modifier_imba_enigma_eidolon_attack_counter:RemoveOnDeath() 	return true  end

function DOTA_Tooltip_modifier_imba_enigma_eidolon_attack_counter:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(0.1)
end

function DOTA_Tooltip_modifier_imba_enigma_eidolon_attack_counter:OnIntervalThink()
	local debuffs = self:GetParent():FindAllModifiersByName("modifier_imba_enigma_eidolon_attacks_debuff")
	if #debuffs > 0 then
		self:SetStackCount(#debuffs)
	else
		self:Destroy()
	end
end

function modifier_imba_enigma_eidolon_attacks_debuff:IsDebuff()			return true end
function modifier_imba_enigma_eidolon_attacks_debuff:IsHidden() 		return true end
function modifier_imba_enigma_eidolon_attacks_debuff:IsPurgable() 		return true end
function modifier_imba_enigma_eidolon_attacks_debuff:IsPurgeException() return true end
function modifier_imba_enigma_eidolon_attacks_debuff:IsStunDebuff() 	return false end
function modifier_imba_enigma_eidolon_attacks_debuff:RemoveOnDeath() 	return true end
function modifier_imba_enigma_eidolon_attacks_debuff:GetAttributes() 	return MODIFIER_ATTRIBUTE_MULTIPLE end

--=================================================================================================================
-- Enigma's Midnight Pulse
--=================================================================================================================

imba_enigma_midnight_pulse = imba_enigma_midnight_pulse or class({})

LinkLuaModifier("modifier_imba_enigma_midnight_pulse_thinker","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_midnight_pulse_aura","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)

function imba_enigma_midnight_pulse:GetAOERadius()	 return self:GetSpecialValueFor("radius") end

function imba_enigma_midnight_pulse:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local damage_per_tick = self:GetSpecialValueFor("damage_per_tick")
	local radius = self:GetSpecialValueFor("radius")
	EmitSoundOnLocationWithCaster(point,"Hero_Enigma.Midnight_Pulse",caster)
	GridNav:DestroyTreesAroundPoint(point, radius, false)
	CreateModifierThinker(caster, self, "modifier_imba_enigma_midnight_pulse_thinker", {duration = duration}, point, caster:GetTeamNumber(), false)
end

modifier_imba_enigma_midnight_pulse_thinker = modifier_imba_enigma_midnight_pulse_thinker or class({})

function modifier_imba_enigma_midnight_pulse_thinker:IsAura() 					return true end
function modifier_imba_enigma_midnight_pulse_thinker:GetAuraSearchTeam() 		return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_enigma_midnight_pulse_thinker:GetAuraSearchType() 		return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_imba_enigma_midnight_pulse_thinker:GetAuraRadius() 			return self.radius end
function modifier_imba_enigma_midnight_pulse_thinker:GetModifierAura()			return "modifier_imba_enigma_midnight_pulse_aura" end

function modifier_imba_enigma_midnight_pulse_thinker:OnCreated()
	if not IsServer() then return end
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self:StartIntervalThink(1.0)
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
	ParticleManager:SetParticleControl(self.particle,0,self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle,1,Vector(self.radius,0,0))
end

function modifier_imba_enigma_midnight_pulse_thinker:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	GridNav:DestroyTreesAroundPoint(parent:GetAbsOrigin(), self.radius, false)
	local dmg_pct = ability:GetSpecialValueFor("damage_per_tick") * 0.01
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
		local dmg = enemy:GetMaxHealth() * dmg_pct
		local damageTable = {victim = enemy,
							attacker = caster,
							damage = dmg,
							damage_type = DAMAGE_TYPE_PURE,
							damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
							ability = ability}
		ApplyDamage(damageTable)
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
		self.radius = self.radius + ability:GetSpecialValueFor("radius") / ability:GetSpecialValueFor("duration")
		ParticleManager:SetParticleControl(self.particle,1,Vector(self.radius,0,0))
	end
end

function modifier_imba_enigma_midnight_pulse_thinker:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.particle,false)
	ParticleManager:ReleaseParticleIndex(self.particle)
end

modifier_imba_enigma_midnight_pulse_aura = modifier_imba_enigma_midnight_pulse_aura or class({})

function modifier_imba_enigma_midnight_pulse_aura:IsDebuff()			return true end
function modifier_imba_enigma_midnight_pulse_aura:IsHidden() 			return false end
function modifier_imba_enigma_midnight_pulse_aura:IsPurgable() 			return false end
function modifier_imba_enigma_midnight_pulse_aura:IsPurgeException() 	return false end