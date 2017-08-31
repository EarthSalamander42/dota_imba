--[[
		By: AtroCty
		Date: 25.05.2017
		Updated:  25.05.2017
	]]
	
-- Shared visible modifiers
LinkLuaModifier("modifier_imba_echo_rapier_haste", "items/item_echo_sabre.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_echo_rapier_debuff_slow", "items/item_echo_sabre.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------
--				ECHO SABRE
-------------------------------------------
LinkLuaModifier("modifier_imba_echo_sabre_passive", "items/item_echo_sabre.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------
item_imba_echo_sabre = item_imba_echo_sabre or class({})
-------------------------------------------
function item_imba_echo_sabre:GetIntrinsicModifierName()
    return "modifier_imba_echo_sabre_passive"
end

function item_imba_echo_sabre:GetAbilityTextureName()
   return "custom/imba_echo_sabre"
end

function item_imba_echo_sabre:GetCooldown( nLevel )
	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
	if self:GetCaster():IsRangedAttacker() then
		cooldown = self:GetSpecialValueFor("ranged_cooldown")
	end
	return cooldown
end
-------------------------------------------
modifier_imba_echo_sabre_passive = modifier_imba_echo_sabre_passive or class({})
function modifier_imba_echo_sabre_passive:IsDebuff() return false end
function modifier_imba_echo_sabre_passive:IsHidden() return true end
function modifier_imba_echo_sabre_passive:IsPermanent() return true end
function modifier_imba_echo_sabre_passive:IsPurgable() return false end
function modifier_imba_echo_sabre_passive:IsPurgeException() return false end
function modifier_imba_echo_sabre_passive:IsStunDebuff() return false end
function modifier_imba_echo_sabre_passive:RemoveOnDeath() return false end
function modifier_imba_echo_sabre_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_echo_sabre_passive:OnDestroy()
	self:CheckUnique(false)
end

function modifier_imba_echo_sabre_passive:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_START
	}
    return decFuns
end

function modifier_imba_echo_sabre_passive:OnCreated()
	local item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and item then
		self.bonus_intellect = item:GetSpecialValueFor("bonus_intellect")
		self.bonus_strength = item:GetSpecialValueFor("bonus_strength")
		self.bonus_attack_speed = item:GetSpecialValueFor("bonus_attack_speed")
		self.bonus_damage = item:GetSpecialValueFor("bonus_damage")
		self.bonus_mana_regen = item:GetSpecialValueFor("bonus_mana_regen")		
		self:CheckUnique(true)
	end
end

function modifier_imba_echo_sabre_passive:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_imba_echo_sabre_passive:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_imba_echo_sabre_passive:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_imba_echo_sabre_passive:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_echo_sabre_passive:GetModifierPercentageManaRegen()
	return self.bonus_mana_regen
end

function modifier_imba_echo_sabre_passive:OnAttackStart(keys)
	local item = self:GetAbility()
	local parent = self:GetParent()
	if item then
		if (keys.attacker == parent) and (parent:IsRealHero() or parent:IsClone()) then
			if item:IsCooldownReady() then
				if self:CheckUniqueValue(1,{"modifier_imba_reverb_rapier_passive"}) == 1 then
					
					parent:AddNewModifier(parent, item, "modifier_imba_echo_rapier_haste", {})
					item:UseResources(false,false,true)
				end
			end
		end
	end
end
-------------------------------------------
--				REVERB RAPIER
-------------------------------------------
LinkLuaModifier("modifier_imba_reverb_rapier_passive", "items/item_echo_sabre.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------
item_imba_reverb_rapier = item_imba_reverb_rapier or class({})
-------------------------------------------
function item_imba_reverb_rapier:GetIntrinsicModifierName()
    return "modifier_imba_reverb_rapier_passive"
end

function item_imba_reverb_rapier:GetAbilityTextureName()
   return "custom/imba_reverb_rapier"
end

function item_imba_reverb_rapier:GetCooldown( nLevel )
	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
	if self:GetCaster():IsRangedAttacker() then
		cooldown = self:GetSpecialValueFor("ranged_cooldown")
	end
	return cooldown
end
-------------------------------------------
modifier_imba_reverb_rapier_passive = modifier_imba_reverb_rapier_passive or class({})
function modifier_imba_reverb_rapier_passive:IsDebuff() return false end
function modifier_imba_reverb_rapier_passive:IsHidden() return true end
function modifier_imba_reverb_rapier_passive:IsPermanent() return true end
function modifier_imba_reverb_rapier_passive:IsPurgable() return false end
function modifier_imba_reverb_rapier_passive:IsPurgeException() return false end
function modifier_imba_reverb_rapier_passive:IsStunDebuff() return false end
function modifier_imba_reverb_rapier_passive:RemoveOnDeath() return false end
function modifier_imba_reverb_rapier_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_reverb_rapier_passive:OnDestroy()
	self:CheckUnique(false)
end

function modifier_imba_reverb_rapier_passive:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_START
	}
    return decFuns
end

function modifier_imba_reverb_rapier_passive:OnCreated()
	local item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and item then
		self.bonus_intellect = item:GetSpecialValueFor("bonus_intellect")
		self.bonus_strength = item:GetSpecialValueFor("bonus_strength")
		self.bonus_attack_speed = item:GetSpecialValueFor("bonus_attack_speed")
		self.bonus_damage = item:GetSpecialValueFor("bonus_damage")
		self.bonus_mana_regen = item:GetSpecialValueFor("bonus_mana_regen")		
		self:CheckUnique(true)
	end
end

function modifier_imba_reverb_rapier_passive:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_imba_reverb_rapier_passive:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_imba_reverb_rapier_passive:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_imba_reverb_rapier_passive:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_reverb_rapier_passive:GetModifierPercentageManaRegen()
	return self.bonus_mana_regen
end

function modifier_imba_reverb_rapier_passive:OnAttackStart(keys)
	local item = self:GetAbility()
	local parent = self:GetParent()
	if item then
		if (keys.attacker == parent) and (parent:IsRealHero() or parent:IsClone()) then
			if item:IsCooldownReady() then
				if self:CheckUniqueValue(1,nil) == 1 then
					parent:AddNewModifier(parent, item, "modifier_imba_echo_rapier_haste", {})
					item:UseResources(false,false,true)
				end
			end
		end
	end
end
-------------------------------------------
modifier_imba_echo_rapier_haste = modifier_imba_echo_rapier_haste or class({})
function modifier_imba_echo_rapier_haste:IsDebuff() return false end
function modifier_imba_echo_rapier_haste:IsHidden() return true end
function modifier_imba_echo_rapier_haste:IsPurgable() return false end
function modifier_imba_echo_rapier_haste:IsPurgeException() return false end
function modifier_imba_echo_rapier_haste:IsStunDebuff() return false end
function modifier_imba_echo_rapier_haste:RemoveOnDeath() return true end
-------------------------------------------
function modifier_imba_echo_rapier_haste:OnCreated()
	local item = self:GetAbility()
	self.parent = self:GetParent()
	if item then
		self.slow_duration = item:GetSpecialValueFor("slow_duration")
		local current_speed = self.parent:GetIncreasedAttackSpeed()
		if item:GetName() == "item_imba_reverb_rapier" then
			current_speed = current_speed * 3
		else
			current_speed = current_speed * 2
		end
		local max_hits = item:GetSpecialValueFor("max_hits")
		self:SetStackCount(max_hits)
		self.attack_speed_buff = math.max(item:GetSpecialValueFor("attack_speed_buff"), current_speed)
	end
end

function modifier_imba_echo_rapier_haste:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK
    }
    return decFuns
end

function modifier_imba_echo_rapier_haste:OnAttack(keys)
	if self.parent == keys.attacker then
		
		-- If the target is a deflector, do nothing
		if keys.target:HasModifier("modifier_imba_juggernaut_blade_fury") and self.parent:IsRangedAttacker() then
		else
		keys.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_imba_echo_rapier_debuff_slow", {duration = self.slow_duration})
		end
		
		if self:GetStackCount() == 1 then
			self:Destroy()
			return nil
		end

		self:DecrementStackCount()
	end
end



function modifier_imba_echo_rapier_haste:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_buff
end
-------------------------------------------
modifier_imba_echo_rapier_debuff_slow = modifier_imba_echo_rapier_debuff_slow or class({})
function modifier_imba_echo_rapier_debuff_slow:IsDebuff() return true end
function modifier_imba_echo_rapier_debuff_slow:IsHidden() return false end
function modifier_imba_echo_rapier_debuff_slow:IsPurgable() return true end
function modifier_imba_echo_rapier_debuff_slow:IsStunDebuff() return false end
function modifier_imba_echo_rapier_debuff_slow:RemoveOnDeath() return true end
-------------------------------------------

function modifier_imba_echo_rapier_debuff_slow:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
    return decFuns
end

function modifier_imba_echo_rapier_debuff_slow:OnCreated()
	local item = self:GetAbility()
	if item then
		self.movement_slow = item:GetSpecialValueFor("movement_slow") * (-1)
		self.attack_speed_slow = item:GetSpecialValueFor("attack_speed_slow") * (-1)
	end
end

function modifier_imba_echo_rapier_debuff_slow:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_slow
end

function modifier_imba_echo_rapier_debuff_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow
end

function modifier_imba_echo_rapier_debuff_slow:GetTexture()	
	if self:GetAbility():GetName() == "item_imba_reverb_rapier" then
		return "custom/imba_reverb_rapier"	
	else
		return "custom/imba_echo_sabre"
	end
end