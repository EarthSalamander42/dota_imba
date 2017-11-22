-- Author: Shush
-- Date: 05.03.2017

CreateEmptyTalents("elder_titan")

-- Echo Stomp
imba_elder_titan_echo_stomp = class({})

function imba_elder_titan_echo_stomp:GetAbilityTextureName()
	return "custom/imba_elder_titan_echo_stomp"
end

function imba_elder_titan_echo_stomp:IsHiddenWhenStolen()
	return false
end

function imba_elder_titan_echo_stomp:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target)
end

function imba_elder_titan_echo_stomp:OnAbilityPhaseStart()
	if astral_spirit and astral_spirit:FindAbilityByName("imba_elder_titan_echo_stomp_spirit") then
		astral_spirit:CastAbilityNoTarget(astral_spirit:FindAbilityByName("imba_elder_titan_echo_stomp_spirit"), astral_spirit:GetPlayerOwnerID())
	end

	EmitSoundOn("Hero_ElderTitan.EchoStomp.Channel.ti7_layer", self:GetCaster())
	return true
end

function imba_elder_titan_echo_stomp:OnAbilityPhaseInterrupted()
	if astral_spirit then
		astral_spirit:Interrupt()
	end
	StopSoundOn("Hero_ElderTitan.EchoStomp.Channel.ti7_layer", self:GetCaster())
end

function imba_elder_titan_echo_stomp:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self

		-- Ability specials
		local radius = ability:GetSpecialValueFor("radius")
		local stun_duration = ability:GetSpecialValueFor("sleep_duration")
		local stomp_damage = ability:GetSpecialValueFor("stomp_damage")

		-- Play cast sound
		EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7", caster)
		EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7_layer", caster)

		-- Add stomp particle
		local particle_stomp_fx = ParticleManager:CreateParticle("particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_physical.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_stomp_fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_stomp_fx, 1, Vector(radius, 1, 1))
		ParticleManager:SetParticleControl(particle_stomp_fx, 2, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_stomp_fx)

		-- Find all nearby enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

		for _, enemy in pairs(enemies) do
			-- Deal damage to nearby non-magic immune enemies
			if not enemy:IsMagicImmune() then			
				local damageTable = {victim = enemy, attacker = caster, damage = stomp_damage, damage_type = ability:GetAbilityDamageType(), ability = ability}
										
				ApplyDamage(damageTable)	

				-- Stun them
				enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
			end
		end
	end
end

-- Astral Spirit
imba_elder_titan_ancestral_spirit = class({})
LinkLuaModifier("modifier_imba_elder_titan_ancestral_spirit_aura", "hero/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_elder_titan_ancestral_spirit_self", "hero/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_elder_titan_ancestral_spirit", "hero/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)

function imba_elder_titan_ancestral_spirit:GetAbilityTextureName()
	return "elder_titan_ancestral_spirit"
end

function imba_elder_titan_ancestral_spirit:GetIntrinsicModifierName()	
	return "modifier_imba_elder_titan_ancestral_spirit_aura"
end

function imba_elder_titan_ancestral_spirit:IsNetherWardStealable() return false end

function imba_elder_titan_ancestral_spirit:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("spirit_duration")

	EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Cast", caster)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, target_point)
	ParticleManager:ReleaseParticleIndex(particle)

	astral_spirit = CreateUnitByName("npc_dota_elder_titan_ancestral_spirit", target_point, true, caster, caster, caster:GetTeamNumber())
	astral_spirit:SetControllableByPlayer(caster:GetPlayerID(), true)
	astral_spirit:AddNewModifier(astral_spirit, nil, "modifier_imba_elder_titan_ancestral_spirit_self", {})
	astral_spirit:SetBaseMoveSpeed(self:GetSpecialValueFor("speed")) -- TODO: doesn't show on hud the right move speed

	astral_spirit:FindAbilityByName("imba_elder_titan_echo_stomp_spirit"):SetLevel(caster:FindAbilityByName("imba_elder_titan_echo_stomp"):GetLevel())
	astral_spirit:FindAbilityByName("imba_elder_titan_natural_order"):SetLevel(caster:FindAbilityByName("imba_elder_titan_natural_order"):GetLevel())

	Timers:CreateTimer(duration, function()
		print("Return spirit.")
		astral_spirit:RemoveSelf()
		astral_spirit = nil
	end)
end

modifier_imba_elder_titan_ancestral_spirit_aura = modifier_imba_elder_titan_ancestral_spirit_aura or class({})

function modifier_imba_elder_titan_ancestral_spirit_aura:IsAura() return true end
function modifier_imba_elder_titan_ancestral_spirit_aura:IsAuraActiveOnDeath() return false end
function modifier_imba_elder_titan_ancestral_spirit_aura:IsDebuff() return false end
function modifier_imba_elder_titan_ancestral_spirit_aura:IsHidden() return true end
function modifier_imba_elder_titan_ancestral_spirit_aura:IsPermanent() return true end
function modifier_imba_elder_titan_ancestral_spirit_aura:IsPurgable() return false end

function modifier_imba_elder_titan_ancestral_spirit_aura:OnCreated()

end

-- Aura properties
function modifier_imba_elder_titan_ancestral_spirit_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_imba_elder_titan_ancestral_spirit_aura:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_imba_elder_titan_ancestral_spirit_aura:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_imba_elder_titan_ancestral_spirit_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_imba_elder_titan_ancestral_spirit_aura:GetModifierAura()
	return "modifier_imba_elder_titan_ancestral_spirit"
end

modifier_imba_elder_titan_ancestral_spirit = modifier_imba_elder_titan_ancestral_spirit or class({})

-- Modifier properties
function modifier_imba_elder_titan_ancestral_spirit:IsDebuff() return true end
function modifier_imba_elder_titan_ancestral_spirit:IsHidden() return false end
function modifier_imba_elder_titan_ancestral_spirit:IsPurgable() return false end

function modifier_imba_elder_titan_ancestral_spirit:OnCreated()
	print(self:GetAbility():GetSpecialValueFor("pass_damage"))
	local damageTable = {victim = self:GetParent(), attacker = self:GetCaster(), damage = self:GetAbility():GetSpecialValueFor("pass_damage"), damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()}
										
	ApplyDamage(damageTable)	
end

modifier_imba_elder_titan_ancestral_spirit_self = modifier_imba_elder_titan_ancestral_spirit_self or class({})

-- Modifier properties
function modifier_imba_elder_titan_ancestral_spirit_self:IsHidden() return false end
function modifier_imba_elder_titan_ancestral_spirit_self:IsPurgable() return false end

function modifier_imba_elder_titan_ancestral_spirit_self:OnCreated() 
	
end

function modifier_imba_elder_titan_ancestral_spirit_self:CheckState()
	if IsServer() then
		local state = {}

--		if self:GetStackCount() == 1 then
--			print("Stack Count = 1")
--			state[MODIFIER_STATE_UNSELECTABLE]	= true,
--		end

		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_FLYING] = true
		state[MODIFIER_STATE_INVULNERABLE] = true
		return state
	end
end

--	function modifier_imba_elder_titan_ancestral_spirit_self:DeclareFunctions()
--		local funcs ={
--			MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
--		}
--		return funcs 
--	end

--	function modifier_imba_elder_titan_ancestral_spirit_self:GetModifierMoveSpeedOverride()
--		print(self:GetAbility())
--		return self:GetAbility():GetSpecialValueFor("speed")
--	end

modifier_imba_elder_titan_natural_order = modifier_imba_elder_titan_natural_order or class({})

-- Modifier properties
function modifier_imba_elder_titan_natural_order:IsDebuff() return true end
function modifier_imba_elder_titan_natural_order:IsHidden() return false end
function modifier_imba_elder_titan_natural_order:IsPurgable() return false end
function modifier_imba_elder_titan_natural_order:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_elder_titan_natural_order:OnCreated() 
	local ability = self:GetAbility()
	self.base_armor_reduction = ability:GetSpecialValueFor("armor_reduction_pct")
	self.magic_resist_reduction = ability:GetSpecialValueFor("magic_resistance_pct")
end

-- Natural Order
imba_elder_titan_natural_order = imba_elder_titan_natural_order or class({})
LinkLuaModifier("modifier_imba_elder_titan_natural_order_aura", "hero/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_elder_titan_natural_order", "hero/hero_elder_titan", LUA_MODIFIER_MOTION_NONE)

function imba_elder_titan_natural_order:GetAbilityTextureName()
	return "elder_titan_natural_order"
end

function imba_elder_titan_natural_order:GetIntrinsicModifierName()	
	return "modifier_imba_elder_titan_natural_order_aura"
end

modifier_imba_elder_titan_natural_order_aura = modifier_imba_elder_titan_natural_order_aura or class({})

-- Modifier properties
function modifier_imba_elder_titan_natural_order_aura:IsAura() return true end
function modifier_imba_elder_titan_natural_order_aura:IsAuraActiveOnDeath() return false end
function modifier_imba_elder_titan_natural_order_aura:IsDebuff() return false end
function modifier_imba_elder_titan_natural_order_aura:IsHidden() return true end
function modifier_imba_elder_titan_natural_order_aura:IsPermanent() return true end
function modifier_imba_elder_titan_natural_order_aura:IsPurgable() return false end

function modifier_imba_elder_titan_natural_order_aura:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

-- Aura properties
function modifier_imba_elder_titan_natural_order_aura:GetAuraRadius()
	return self.radius 
end

function modifier_imba_elder_titan_natural_order_aura:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_imba_elder_titan_natural_order_aura:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_imba_elder_titan_natural_order_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_imba_elder_titan_natural_order_aura:GetModifierAura()
	return "modifier_imba_elder_titan_natural_order"
end

modifier_imba_elder_titan_natural_order = modifier_imba_elder_titan_natural_order or class({})

-- Modifier properties
function modifier_imba_elder_titan_natural_order:IsDebuff() return true end
function modifier_imba_elder_titan_natural_order:IsHidden() return false end
function modifier_imba_elder_titan_natural_order:IsPurgable() return false end

function modifier_imba_elder_titan_natural_order:OnCreated() 
	local ability = self:GetAbility()
	self.base_armor_reduction = ability:GetSpecialValueFor("armor_reduction_pct")
	self.magic_resist_reduction = ability:GetSpecialValueFor("magic_resistance_pct")
end

function modifier_imba_elder_titan_natural_order:DeclareFunctions()
	local funcs ={
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
--		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
--		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs 
end

function modifier_imba_elder_titan_natural_order:GetModifierPhysicalArmorBonus()
	if self:GetCaster() and self:GetCaster():GetUnitName() == "npc_dota_elder_titan_ancestral_spirit" then
		print("Spirit don't reduce armor")
		return 0
	else
		print("Elder Titan reducing armor!")
		return self.base_armor_reduction * 0.01 * self:GetParent():GetPhysicalArmorBaseValue()
	end
end

function modifier_imba_elder_titan_natural_order:GetModifierMagicalResistanceBonus()
	if self:GetCaster() and self:GetCaster():GetUnitName() == "npc_dota_hero_elder_titan" then
		print("Hero don't reduce magic resist")
		return 0
	else
		return self.magic_resist_reduction
	end
end

--[[
function modifier_imba_elder_titan_natural_order:GetModifierIncomingDamage_Percentage()
	return self.bonusSpellAmp * self:GetStackCount()
end

function modifier_imba_elder_titan_natural_order:GetModifierSpellAmplify_Percentage()
	return self.bonusSpellAmp * self:GetStackCount()
end
--]]

-- talent
--[[
function modifier_imba_elder_titan_natural_order:GetCustomTenacityUnique()
	return self.bonusTenacity * self:GetStackCount()
end
--]]



---------------
--	SPIRIT	--
---------------

imba_elder_titan_echo_stomp_spirit = class({})

function imba_elder_titan_echo_stomp_spirit:GetAbilityTextureName()
	return "custom/imba_elder_titan_echo_stomp"
end

function imba_elder_titan_echo_stomp_spirit:IsHiddenWhenStolen()
	return false
end

function imba_elder_titan_echo_stomp_spirit:GetCastRange(location, target)
	local caster = self:GetCaster()
	local base_range = self.BaseClass.GetCastRange(self, location, target)

	return base_range
end

function imba_elder_titan_echo_stomp_spirit:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self

		-- Ability specials
		local radius = ability:GetSpecialValueFor("radius")
		local stun_duration = ability:GetSpecialValueFor("sleep_duration")
		local stomp_damage = ability:GetSpecialValueFor("stomp_damage")

		-- Play cast sound
		EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7", caster)
		EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7_layer", caster)

		-- Add stomp particle
		local particle_stomp_fx = ParticleManager:CreateParticle("particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_stomp_fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_stomp_fx, 1, Vector(radius, 1, 1))
		ParticleManager:SetParticleControl(particle_stomp_fx, 2, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_stomp_fx)

		-- Find all nearby enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

		for _, enemy in pairs(enemies) do
			-- Deal damage to nearby non-magic immune enemies
			if not enemy:IsMagicImmune() then			
				local damageTable = {victim = enemy, attacker = caster, damage = stomp_damage, damage_type = ability:GetAbilityDamageType(), ability = ability}
										
				ApplyDamage(damageTable)	

				-- Stun them
				enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
			end
		end
	end
end

	-- TODO: Make elder titan cast too if order came from astral spirit
--	function imba_elder_titan_echo_stomp_spirit:OnAbilityPhaseStart()
--		if astral_spirit:GetOwnerEntity():FindAbilityByName("imba_elder_titan_echo_stomp") then
--			astral_spirit:GetOwnerEntity():CastAbilityNoTarget(astral_spirit:GetOwnerEntity():FindAbilityByName("imba_elder_titan_echo_stomp"), astral_spirit:GetOwnerEntity():GetPlayerID())
--		end

--		EmitSoundOn("Hero_ElderTitan.EchoStomp.Channel.ti7_layer", self:GetCaster())
--		return true
--	end

--	function imba_elder_titan_echo_stomp_spirit:OnAbilityPhaseInterrupted()
--		if astral_spirit:GetOwnerEntity() then
--			astral_spirit:GetOwnerEntity():Interrupt()
--		end

--		StopSoundOn("Hero_ElderTitan.EchoStomp.Channel.ti7_layer", self:GetCaster())
--	end
