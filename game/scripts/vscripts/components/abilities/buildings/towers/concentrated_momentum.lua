LinkLuaModifier('modifier_imba_tower_concentrated_momentum', "components/abilities/buildings/towers/concentrated_momentum.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_imba_tower_concentrated_momentum_stacks', "components/abilities/buildings/towers/concentrated_momentum.lua", LUA_MODIFIER_MOTION_NONE)

imba_tower_concentrated_momentum = imba_tower_concentrated_momentum or class({})

function imba_tower_concentrated_momentum:GetIntrinsicModifierName()
	return "modifier_imba_tower_concentrated_momentum"
end

modifier_imba_tower_concentrated_momentum = modifier_imba_tower_concentrated_momentum or class({})

function modifier_imba_tower_concentrated_momentum:IsDebuff() return false end
function modifier_imba_tower_concentrated_momentum:IsHidden() return true end
function modifier_imba_tower_concentrated_momentum:IsPurgable() return false end
function modifier_imba_tower_concentrated_momentum:IsPurgeException() return false end
function modifier_imba_tower_concentrated_momentum:IsStunDebuff() return false end
function modifier_imba_tower_concentrated_momentum:RemoveOnDeath() return false end
-------------------------------------------

function modifier_imba_tower_concentrated_momentum:DeclareFunctions() return {
	MODIFIER_EVENT_ON_ATTACK_START,
} end

function modifier_imba_tower_concentrated_momentum:OnAttackStart(params)
	if params.attacker == self:GetParent() then		
		local modifier = params.attacker:FindModifierByNameAndCaster("modifier_imba_tower_concentrated_momentum_stacks", self:GetParent())

		if modifier then
			if modifier.last_target == params.target then
				if modifier:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_stacks") then
					modifier:IncrementStackCount()
				end
			else
				modifier:SetStackCount(1)
				modifier.last_target = params.target
			end
		else
			modifier = params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_tower_concentrated_momentum_stacks", {})
			modifier.last_target = params.target
		end
	end
end

-------------------------------------------
modifier_imba_tower_concentrated_momentum_stacks = modifier_imba_tower_concentrated_momentum_stacks or class({})
function modifier_imba_tower_concentrated_momentum_stacks:IsDebuff() return false end
function modifier_imba_tower_concentrated_momentum_stacks:IsHidden() return false end
function modifier_imba_tower_concentrated_momentum_stacks:IsPurgable() return false end
function modifier_imba_tower_concentrated_momentum_stacks:IsPurgeException() return false end
function modifier_imba_tower_concentrated_momentum_stacks:IsStunDebuff() return false end
function modifier_imba_tower_concentrated_momentum_stacks:RemoveOnDeath() return false end
-------------------------------------------

function modifier_imba_tower_concentrated_momentum_stacks:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_imba_tower_concentrated_momentum_stacks:OnCreated()
	if IsServer() then
		self:SetStackCount(1)
	end
end

function modifier_imba_tower_concentrated_momentum_stacks:GetModifierAttackSpeedBonus_Constant()
	if not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("bonus_as") * self:GetStackCount()
	end
	return 0
end