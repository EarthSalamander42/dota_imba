LinkLuaModifier("modifier_miniboss_unyielding_shield_custom", "components/tormentor/abilities/miniboss_unyielding_shield.lua", LUA_MODIFIER_MOTION_NONE)

miniboss_unyielding_shield_custom = miniboss_unyielding_shield_custom or class({})

function miniboss_unyielding_shield_custom:IsInnateAbility() return true end

function miniboss_unyielding_shield_custom:GetIntrinsicModifierName()
	return "modifier_miniboss_unyielding_shield_custom"
end

modifier_miniboss_unyielding_shield_custom = modifier_miniboss_unyielding_shield_custom or class({})

-- function modifier_miniboss_unyielding_shield_custom:IsHidden() return true end

function modifier_miniboss_unyielding_shield_custom:IsPurgable() return false end

function modifier_miniboss_unyielding_shield_custom:IsPurgeException() return false end

function modifier_miniboss_unyielding_shield_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
end

function modifier_miniboss_unyielding_shield_custom:OnCreated()
	if not IsServer() then return end

	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.parent:EmitSound("Miniboss.Tormenter.Spawn")

	-- This delay is required because the tormentor team is not set yet when the modifier is created
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("delay"), function()
		local deaths = Tormentors:GetDeaths(self.parent.tormentorTeam)

		self.bonusShieldPerDeath = self.ability:GetSpecialValueFor("absorb_bonus_per_death") * deaths
		self.bonusRegenPerDeath = self.ability:GetSpecialValueFor("regen_bonus_per_death") * deaths

		self.maxShield = self.ability:GetSpecialValueFor("damage_absorb") + self.bonusShieldPerDeath
		self.shield = self.maxShield
		self.regenPerSecond = self.ability:GetSpecialValueFor("regen_per_second") + self.bonusRegenPerDeath
		self.regenPerSecondThink = self.regenPerSecond * FrameTime()

		self:SetHasCustomTransmitterData(true)
		self:StartIntervalThink(FrameTime())
	end, FrameTime())
end

function modifier_miniboss_unyielding_shield_custom:AddCustomTransmitterData()
	return {
		shield = self.shield,
		regenPerSecond = self.regenPerSecond,
	}
end

function modifier_miniboss_unyielding_shield_custom:HandleCustomTransmitterData(data)
	self.shield = data.shield
	self.regenPerSecond = data.regenPerSecond
end

function modifier_miniboss_unyielding_shield_custom:OnIntervalThink()
	self.shield = math.min(self.shield + self.regenPerSecondThink, self.maxShield)
	self:SendBuffRefreshToClients()
end

function modifier_miniboss_unyielding_shield_custom:GetModifierIncomingDamageConstant(event)
	if not IsServer() then
		return self.shield
	end

	-- block damage
	local damage = event.damage

	if damage <= 0 then
		return 0
	end

	-- EmitSoundOnClient("Miniboss.Tormenter.Target", event.attacker)
	event.attacker:EmitSound("Miniboss.Tormenter.Target")

	if damage > self.shield then
		self.shield = 0
		self:SendBuffRefreshToClients()
		return -self.shield
	else
		self.shield = self.shield - damage
		self:SendBuffRefreshToClients()
		return -damage
	end
end

function modifier_miniboss_unyielding_shield_custom:OnTooltip()
	return self.shield
end

function modifier_miniboss_unyielding_shield_custom:OnTooltip2()
	return self.regenPerSecond
end
