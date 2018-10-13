modifier_mutation_super_fervor = class({})

function modifier_mutation_super_fervor:IsHidden() return true end
function modifier_mutation_super_fervor:RemoveOnDeath() return false end
function modifier_mutation_super_fervor:IsPurgable() return false end

function modifier_mutation_super_fervor:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_mutation_super_fervor:OnDeath(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			if keys.unit:IsRealHero() then
				self:GetParent():EmitSound("Hero_TrollWarlord.BattleTrance.Cast")
				self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_mutation_super_fervor_strong_buff", {duration = 5})
				for i = 0, 23 do
					local ability = self:GetParent():GetAbilityByIndex(i)
					if ability then
						local remaining_cooldown = ability:GetCooldownTimeRemaining()
						ability:EndCooldown()
						if remaining_cooldown > 10 then
							ability:StartCooldown(remaining_cooldown - 10)
						end
					end
				end
			else
				self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_mutation_super_fervor_weak_buff", {duration = 3})
				for i = 0, 23 do
					local ability = self:GetParent():GetAbilityByIndex(i)
					if ability then
						local remaining_cooldown = ability:GetCooldownTimeRemaining()
						ability:EndCooldown()
						if remaining_cooldown > 1 then
							ability:StartCooldown(remaining_cooldown - 1)
						end
					end
				end
			end
		end
	end
end

-----

LinkLuaModifier("modifier_mutation_super_fervor_strong_buff", "components/modifiers/mutation/modifier_mutation_super_fervor.lua", LUA_MODIFIER_MOTION_NONE )
modifier_mutation_super_fervor_strong_buff = class({})

function modifier_mutation_super_fervor_strong_buff:IsHidden() return true end
function modifier_mutation_super_fervor_strong_buff:RemoveOnDeath() return false end

function modifier_mutation_super_fervor_strong_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_mutation_super_fervor_strong_buff:GetModifierAttackSpeedBonus_Constant()
	return 200
end

-----

LinkLuaModifier("modifier_mutation_super_fervor_weak_buff", "components/modifiers/mutation/modifier_mutation_super_fervor.lua", LUA_MODIFIER_MOTION_NONE )
modifier_mutation_super_fervor_weak_buff = class({})

function modifier_mutation_super_fervor_weak_buff:IsHidden() return true end
function modifier_mutation_super_fervor_weak_buff:RemoveOnDeath() return false end

function modifier_mutation_super_fervor_weak_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_mutation_super_fervor_weak_buff:GetModifierAttackSpeedBonus_Constant()
	return 100
end