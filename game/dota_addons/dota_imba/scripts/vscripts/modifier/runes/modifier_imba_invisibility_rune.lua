--[[
	Invisibility rune

	Contributors:
		- Lindbrum (Author): 15/03/2018

]]

-----------------------------------------------------------------
-- Rune buff
-----------------------------------------------------------------
modifier_imba_invisibility_rune = modifier_imba_invisibility_rune or class({})

function modifier_imba_invisibility_rune:IsHidden() return false end
function modifier_imba_invisibility_rune:IsDebuff() return false end
function modifier_imba_invisibility_rune:IsPurgable() return true end

function modifier_imba_invisibility_rune:GetTexture()
	return ""
end

function modifier_imba_invisibility_rune:CheckState()
	local state = {[MODIFIER_STATE_INVISIBILE] = true,
					[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	return state
end

function modifier_imba_invisibility_rune:OnCreated()
	if not IsServer() then return end
	self.parent = self:GetParent()
	self.critical_mul = 200
	self.movespeed_bonus = 20
end

function modifier_imba_invisibility_rune:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
					MODIFIER_PROPERTY_MOVESPEED_ BONUS_PERCENTAGE,
					MODIFIER_EVENT_ON_ATTACK_LANDED,
					MODIFIER_EVENT_ON_ABILITY_START}

	return funcs
end

function modifier_imba_invisibility_rune:GetModifierPreAttack_CriticalStrike(kv)
	--Doesn't work on buildings
	if kv.target:IsBuilding() then return 0 end

	return self.critical_mul
end

function modifier_imba_invisibility_rune:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_bonus

end

function modifier_imba_invisibility_rune:OnAttackLanded(kv)
	if not IsServer() then return end
	--Proceed only if the attacker is the parent
	if not self.parent == kv.attacker then return end

	--remove modifier
	self:Destroy()
end

function modifier_imba_invisibility_rune:OnAbilityStart(kv)
	if not IsServer() then return end
	--proceed only if the caster is the parent
	if not self.parent == kv.attacker then return end

	--remove modifier
	self:Destroy()
end