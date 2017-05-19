--[[
		By: AtroCty
		Date: 17.05.2017
		Updated:  18.05.2017
	]]
-------------------------------------------
--			NETHER WAND
-------------------------------------------
LinkLuaModifier("modifier_imba_nether_wand", "items/item_nether_wand.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_elder_staff", "items/item_nether_wand.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_elder_nether_burn", "items/item_nether_wand.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------

item_imba_nether_wand = item_imba_nether_wand or class({})
-------------------------------------------
function item_imba_nether_wand:GetIntrinsicModifierName()
    return "modifier_imba_nether_wand"
end
-------------------------------------------
modifier_imba_nether_wand = modifier_imba_nether_wand or class({})
function modifier_imba_nether_wand:IsDebuff() return false end
function modifier_imba_nether_wand:IsHidden() return true end
function modifier_imba_nether_wand:IsPermanent() return true end
function modifier_imba_nether_wand:IsPurgable() return false end
function modifier_imba_nether_wand:IsPurgeException() return false end
function modifier_imba_nether_wand:IsStunDebuff() return false end
function modifier_imba_nether_wand:RemoveOnDeath() return false end
function modifier_imba_nether_wand:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_nether_wand:OnDestroy()
	self:CheckUnique(false)
end

function modifier_imba_nether_wand:OnCreated()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and self.item then
		self.bonus_damage = self.item:GetSpecialValueFor("bonus_damage")
		self.bonus_as = self.item:GetSpecialValueFor("bonus_as")
		self.bonus_intellect = self.item:GetSpecialValueFor("bonus_intellect")
		self.burn_duration = self.item:GetSpecialValueFor("burn_duration")
		self.burn_amount = self.item:GetSpecialValueFor("burn_amount")
		self.spell_power = self.item:GetSpecialValueFor("spell_power")
		self.burn_tick = self.item:GetSpecialValueFor("burn_tick")
		self:CheckUnique(true)
	end
end

function modifier_imba_nether_wand:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }
    return decFuns
end

function modifier_imba_nether_wand:GetModifierSpellAmplify_Percentage()
	return self:CheckUniqueValue(self.spell_power,{"modifier_imba_elder_staff"})
end

function modifier_imba_nether_wand:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_nether_wand:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_imba_nether_wand:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_imba_nether_wand:OnTakeDamage(params)
	if IsServer() then
		if (self.parent == params.attacker) and (params.inflictor ~= self.item) and (params.unit:GetTeam() ~= self.parent:GetTeam()) and (not self.parent:IsIllusion()) and (self:GetStackCount() == 1) and (not (self.parent:HasModifier("modifier_imba_elder_staff") or params.unit:IsBuilding() or params.unit:IsOther())) then
			if (self.parent:GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() <= IMBA_DAMAGE_EFFECTS_DISTANCE_CUTOFF then
				params.unit:AddNewModifier(self.parent, self:GetAbility(), "modifier_imba_elder_nether_burn", {duration = self.burn_duration})
			end
		end
	end
end
-------------------------------------------
--			ELDER STAFF
-------------------------------------------
item_imba_elder_staff = item_imba_elder_staff or class({})
-------------------------------------------
function item_imba_elder_staff:GetIntrinsicModifierName()
    return "modifier_imba_elder_staff"
end
-------------------------------------------
modifier_imba_elder_staff = modifier_imba_elder_staff or class({})
function modifier_imba_elder_staff:IsDebuff() return false end
function modifier_imba_elder_staff:IsHidden() return true end
function modifier_imba_elder_staff:IsPermanent() return true end
function modifier_imba_elder_staff:IsPurgable() return false end
function modifier_imba_elder_staff:IsPurgeException() return false end
function modifier_imba_elder_staff:IsStunDebuff() return false end
function modifier_imba_elder_staff:RemoveOnDeath() return false end
function modifier_imba_elder_staff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_elder_staff:OnDestroy()
	self:CheckUnique(false)
end

function modifier_imba_elder_staff:OnCreated()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and self.item then
		self.bonus_damage = self.item:GetSpecialValueFor("bonus_damage")
		self.bonus_as = self.item:GetSpecialValueFor("bonus_as")
		self.bonus_intellect = self.item:GetSpecialValueFor("bonus_intellect")
		self.bonus_mana = self.item:GetSpecialValueFor("bonus_mana")
		self.bonus_health_regen = self.item:GetSpecialValueFor("bonus_health_regen")
		self.cast_range_bonus = self.item:GetSpecialValueFor("cast_range_bonus")
		self.spell_power = self.item:GetSpecialValueFor("spell_power")
		self.burn_duration = self.item:GetSpecialValueFor("burn_duration")
		self:CheckUnique(true)
	end
end

function modifier_imba_elder_staff:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
    return decFuns
end

function modifier_imba_elder_staff:GetModifierSpellAmplify_Percentage()
	return self:CheckUniqueValue(self.spell_power,nil)
end

function modifier_imba_elder_staff:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_elder_staff:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_imba_elder_staff:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_imba_elder_staff:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_imba_elder_staff:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_imba_elder_staff:GetModifierCastRangeBonus()
	return self:CheckUniqueValue(self.cast_range_bonus,nil)
end

function modifier_imba_elder_staff:OnTakeDamage(params)
	if IsServer() then
		if (self.parent == params.attacker) and (params.inflictor ~= self.item) and (params.unit:GetTeam() ~= self.parent:GetTeam()) and (not self.parent:IsIllusion()) and (self:GetStackCount() == 1) and (not (params.unit:IsBuilding() or params.unit:IsOther())) then
			if (self.parent:GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() <= IMBA_DAMAGE_EFFECTS_DISTANCE_CUTOFF then
				params.unit:AddNewModifier(self.parent, self:GetAbility(), "modifier_imba_elder_nether_burn", {duration = self.burn_duration})
			end
		end
	end
end
-------------------------------------------
modifier_imba_elder_nether_burn = modifier_imba_elder_nether_burn or class({})
function modifier_imba_elder_nether_burn:IsDebuff() return true end
function modifier_imba_elder_nether_burn:IsHidden() return false end
function modifier_imba_elder_nether_burn:IsPurgable() return true end
function modifier_imba_elder_nether_burn:IsStunDebuff() return false end
function modifier_imba_elder_nether_burn:RemoveOnDeath() return true end
-------------------------------------------

function modifier_imba_elder_nether_burn:OnDestroy()
	self:StartIntervalThink(-1)
end

function modifier_imba_elder_nether_burn:OnCreated()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	if self.item then
		self.duration = self:GetDuration()
		self.burn_amount = self.item:GetSpecialValueFor("burn_amount")
		self.burn_tick = self.item:GetSpecialValueFor("burn_tick")
		if IsServer() then
			self:StartIntervalThink(self.burn_tick)
		end
	else
		self:Destroy()
	end
end

function modifier_imba_elder_nether_burn:OnRefresh()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	if self.item then
		self.duration = self:GetDuration()
		self.burn_amount = self.item:GetSpecialValueFor("burn_amount")
	else
		self:Destroy()
	end
end

function modifier_imba_elder_nether_burn:GetEffectName()
	return "particles/item/nether_wand/nether_burn_debuff.vpcf"
end

function modifier_imba_elder_nether_burn:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_elder_nether_burn:OnIntervalThink()
	local damage = self.burn_amount * self.burn_tick / self.duration * self.parent:GetHealth() * 0.01
	ApplyDamage({attacker = self:GetCaster(), victim = self.parent, ability = self.item, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end