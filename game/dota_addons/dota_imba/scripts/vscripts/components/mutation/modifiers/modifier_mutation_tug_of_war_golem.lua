modifier_mutation_tug_of_war_golem = class({})

function modifier_mutation_tug_of_war_golem:IsHidden() return false end
function modifier_mutation_tug_of_war_golem:RemoveOnDeath() return false end
function modifier_mutation_tug_of_war_golem:IsPurgable() return false end

function modifier_mutation_tug_of_war_golem:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.1, function()
			SetCreatureHealth(self:GetParent(), 300 * (1 + self:GetStackCount()), true)
		end)
	end
end

function modifier_mutation_tug_of_war_golem:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
	return funcs
end

function modifier_mutation_tug_of_war_golem:GetModifierPreAttack_BonusDamage()
	return 40 * self:GetStackCount()
end

function modifier_mutation_tug_of_war_golem:GetModifierMoveSpeedBonus_Constant()
	return 10 * self:GetStackCount()
end

function modifier_mutation_tug_of_war_golem:GetModifierAttackSpeedBonus_Constant()
	return 10 * self:GetStackCount()
end

function modifier_mutation_tug_of_war_golem:GetModifierPhysicalArmorBonus()
	return 2 * self:GetStackCount()
end

function modifier_mutation_tug_of_war_golem:GetModifierMagicalResistanceBonus()
	return 2 * self:GetStackCount()
end

function modifier_mutation_tug_of_war_golem:GetModifierConstantHealthRegen()
	return 2.5 * self:GetStackCount()
end

function modifier_mutation_tug_of_war_golem:GetModifierAttackRangeBonus()
	return math.min(10 * self:GetStackCount(), 190)
end

function modifier_mutation_tug_of_war_golem:GetCustomTenacity()
	return math.min(7.5 * self:GetStackCount(), 75)
end

function modifier_mutation_tug_of_war_golem:GetModifierPhysical_ConstantBlock()
	return math.min(3 * self:GetStackCount(), 60)
end

function modifier_mutation_tug_of_war_golem:GetModifierIncomingDamage_Percentage()
	return (-1) * math.min(2.5 * self:GetStackCount(), 40)
end

function modifier_mutation_tug_of_war_golem:GetModifierModelScale()
	return math.min(10 * self:GetStackCount(), 150)
end

function modifier_mutation_tug_of_war_golem:OnDeath(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			local old_golem = self:GetParent()
			local original_team = old_golem:GetTeam()
			local death_position = old_golem:GetAbsOrigin()
			local previous_stacks = self:GetStackCount()
			local golem

			-- Sound
			old_golem:EmitSound("TugOfWar.Death")
			Timers:CreateTimer(3, function()
				old_golem:EmitSound("TugOfWar.Revive")
			end)

			-- Kill old particle
			if old_golem.ambient_pfx then
				ParticleManager:DestroyParticle(old_golem.ambient_pfx, true)
				ParticleManager:ReleaseParticleIndex(old_golem.ambient_pfx)
			end

			-- New golem
			Timers:CreateTimer(4.5, function()
				if original_team == DOTA_TEAM_GOODGUYS then
					golem = CreateUnitByName("npc_dota_mutation_golem", death_position, false, nil, nil, DOTA_TEAM_BADGUYS)
					golem.ambient_pfx = ParticleManager:CreateParticle("particles/ambient/tug_of_war_team_dire.vpcf", PATTACH_ABSORIGIN_FOLLOW, golem)
					ParticleManager:SetParticleControl(golem.ambient_pfx, 0, golem:GetAbsOrigin())
					Timers:CreateTimer(0.1, function()
						golem:MoveToPositionAggressive(IMBA_MUTATION_TUG_OF_WAR_TARGET[DOTA_TEAM_BADGUYS])
					end)
				elseif original_team == DOTA_TEAM_BADGUYS then
					golem = CreateUnitByName("npc_dota_mutation_golem", death_position, false, nil, nil, DOTA_TEAM_GOODGUYS)
					golem.ambient_pfx = ParticleManager:CreateParticle("particles/ambient/tug_of_war_team_radiant.vpcf", PATTACH_ABSORIGIN_FOLLOW, golem)
					ParticleManager:SetParticleControl(golem.ambient_pfx, 0, golem:GetAbsOrigin())
					Timers:CreateTimer(0.1, function()
						golem:MoveToPositionAggressive(IMBA_MUTATION_TUG_OF_WAR_TARGET[DOTA_TEAM_GOODGUYS])
					end)
				end

				-- Spawn logic
				golem:AddNewModifier(golem, nil, "modifier_mutation_tug_of_war_golem", {}):SetStackCount(previous_stacks + 1)
				FindClearSpaceForUnit(golem, golem:GetAbsOrigin(), true)
				golem:SetDeathXP(50 * (1 + previous_stacks))
				golem:SetMinimumGoldBounty(50 * (1 + previous_stacks))
				golem:SetMaximumGoldBounty(50 * (1 + previous_stacks))
			end)
		end
	end
end