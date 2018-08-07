--[[
	Invisibility rune

	Contributors:
		- Lindbrum (Author): 15/03/2018

]]

-----------------------------------------------------------------
-- Rune buff
-----------------------------------------------------------------
modifier_imba_invisibility_rune_handler = modifier_imba_invisibility_rune_handler or class({})

LinkLuaModifier("modifier_imba_invisibility_rune", "modifier/runes/modifier_imba_invisibility_rune", LUA_MODIFIER_MOTION_NONE)

function modifier_imba_invisibility_rune_handler:IsHidden() return true end
function modifier_imba_invisibility_rune_handler:IsDebuff() return false end
function modifier_imba_invisibility_rune_handler:IsHidden() return false  end
function modifier_imba_invisibility_rune_handler:IsPurgable() return false end
function modifier_imba_invisibility_rune_handler:IsPurgeException() return false end

function modifier_imba_invisibility_rune_handler:OnCreated(keys)
	if IsServer() then
		self.rune_duration = keys.rune_duration
	end
end

function modifier_imba_invisibility_rune_handler:OnDestroy()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_imba_invisibility_rune", {duration=self.rune_duration})
	end
end

modifier_imba_invisibility_rune = modifier_imba_invisibility_rune or class({})

function modifier_imba_invisibility_rune:IsHidden() return false end
function modifier_imba_invisibility_rune:IsDebuff() return false end
function modifier_imba_invisibility_rune:IsPurgable() return true end

function modifier_imba_invisibility_rune:GetTexture()
	return "custom/imba_rune_invisibility"
end

function modifier_imba_invisibility_rune:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}

	return state
end

function modifier_imba_invisibility_rune:OnCreated()
	if not IsServer() then return end
	self.critical_mult = 200
	self.movespeed_bonus = 20

	local particle = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:ReleaseParticleIndex(particle)
end

function modifier_imba_invisibility_rune:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_START,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}

	return funcs
end

function modifier_imba_invisibility_rune:GetModifierInvisibilityLevel()
	if IsClient() then
		return 1
	end
end

function modifier_imba_invisibility_rune:GetModifierPreAttack_CriticalStrike(kv)
	--Doesn't work on buildings
	if kv.target:IsBuilding() then return 0 end

	return self.critical_mult
end

function modifier_imba_invisibility_rune:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_bonus

end

function modifier_imba_invisibility_rune:OnAttackLanded(kv)
	if not IsServer() then return end
	--Proceed only if the attacker is the parent
	if self:GetParent() == kv.attacker then
		print("Attack Landed!")
		self:Destroy()
		return
	end
end

function modifier_imba_invisibility_rune:OnAbilityStart(kv)
	if not IsServer() then return end
	--proceed only if the caster is the parent
	if self:GetParent() == kv.attacker then
		print("Ability Start!")
		self:Destroy()
		return
	end
end
