LinkLuaModifier("modifier_roshan_inherent_buffs_custom", "components/roshan/abilities/roshan_inherent_buffs.lua", LUA_MODIFIER_MOTION_NONE)

roshan_inherent_buffs_custom = roshan_inherent_buffs_custom or class({})

function roshan_inherent_buffs_custom:IsInnateAbility() return true end

function roshan_inherent_buffs_custom:OnUpgrade()
	if not IsServer() then return end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_roshan_inherent_buffs_custom", {})
end

modifier_roshan_inherent_buffs_custom = modifier_roshan_inherent_buffs_custom or class({})

function modifier_roshan_inherent_buffs_custom:IsHidden() return true end

function modifier_roshan_inherent_buffs_custom:IsPurgable() return false end

function modifier_roshan_inherent_buffs_custom:IsPurgeException() return false end

function modifier_roshan_inherent_buffs_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_roshan_inherent_buffs_custom:OnCreated()
	self.bonusDamage = 0
	self.bonusArmor = 0

	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.interval = self.ability:GetSpecialValueFor("interval")
	self.bonusDamage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonusArmor = self.ability:GetSpecialValueFor("bonus_armor")

	if not IsServer() then return end

	self.previousStack = 0
	self.baseMaxHealth = self.parent:GetMaxHealth()
	self.bonusHealth = self.ability:GetSpecialValueFor("bonus_health") or 130

	self:SetStackCount(0)
	self:StartIntervalThink(1.0)
end

function modifier_roshan_inherent_buffs_custom:OnIntervalThink()
	local additional_minutes = Roshan:GetBuffTime() / self.interval
	local game_time = math.floor(GameRules:GetDOTATime(false, false))
	local minutes = math.floor(game_time / self.interval) + additional_minutes
	if minutes <= 0 then return end

	self:SetStackCount(minutes)
end

function modifier_roshan_inherent_buffs_custom:OnStackCountChanged()
	if not IsServer() then return end

	local stack_count = self:GetStackCount()

	if stack_count ~= self.previousStack then
		self.previousStack = stack_count

		local bonus_health = self.bonusHealth * stack_count
		local new_health = self.baseMaxHealth + bonus_health

		self.parent:SetMaxHealth(new_health)
		self.parent:SetBaseMaxHealth(new_health)

		if not self.initialHeal then
			self.parent:Heal(bonus_health, self.parent)
		else
			self.parent:Heal(self.bonusHealth, self.parent)
		end
	end
end

function modifier_roshan_inherent_buffs_custom:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage * self:GetStackCount()
end

function modifier_roshan_inherent_buffs_custom:GetModifierPhysicalArmorBonus()
	return self.bonusArmor * self:GetStackCount()
end

-- Not sure why Valve did this in ability instead of unit file, but it's here so we have to do it too
function modifier_roshan_inherent_buffs_custom:GetModifierAttackSpeedBonus_Constant()
	return 100
end
