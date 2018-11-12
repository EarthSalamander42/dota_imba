modifier_mutation_tug_of_war_golem = class({})

function modifier_mutation_tug_of_war_golem:IsHidden() return false end
function modifier_mutation_tug_of_war_golem:RemoveOnDeath() return false end
function modifier_mutation_tug_of_war_golem:IsPurgable() return false end

-- Golem Parameters (per stack, unless variable ends in Max)
local healthBonus = 300
local attackBonus = 50
local moveSpeedBonus = 5
local aspdBonus = 10
local pArmorBonus = 5
local mResistBonus = 2
local healthRegen = 2.5
local rangeBonus = 10
local rangeBonusMax = 190
local tenacity = 7.5
local tenacityMax = 75
local pBlock = 3
local pBlockMax = 60
local mitigation = 2.5
local mitigationMax = 40
local modelScaleMax = 150
local modelScale = 10
local expBonus = 50
local goldBonus = 50

function modifier_mutation_tug_of_war_golem:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.1, function()
			SetCreatureHealth(self:GetParent(), healthBonus * (1 + self:GetStackCount()), true)
		end)
	end
end

function modifier_mutation_tug_of_war_golem:GetTexture()
	return "warlock_rain_of_chaos"
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
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
	return funcs
end

function modifier_mutation_tug_of_war_golem:GetModifierPreAttack_BonusDamage()
	return attackBonus * self:GetStackCount()
end

function modifier_mutation_tug_of_war_golem:GetModifierMoveSpeedBonus_Constant()
	return moveSpeedBonus * self:GetStackCount()
end

function modifier_mutation_tug_of_war_golem:GetModifierAttackSpeedBonus_Constant()
	return aspdBonus * self:GetStackCount()
end

function modifier_mutation_tug_of_war_golem:GetModifierPhysicalArmorBonus()
	return pArmorBonus * self:GetStackCount()
end

function modifier_mutation_tug_of_war_golem:GetModifierMagicalResistanceBonus()
	return mResistBonus * self:GetStackCount()
end

function modifier_mutation_tug_of_war_golem:GetModifierConstantHealthRegen()
	return healthRegen * self:GetStackCount()
end

function modifier_mutation_tug_of_war_golem:GetModifierAttackRangeBonus()
	return math.min(rangeBonus * self:GetStackCount(), rangeBonusMax)
end

function modifier_mutation_tug_of_war_golem:GetModifierStatusResistanceStacking()
	return self:GetStackCount()
end

function modifier_mutation_tug_of_war_golem:GetModifierPhysical_ConstantBlock()
	return math.min(pBlock * self:GetStackCount(), pBlockMax)
end

function modifier_mutation_tug_of_war_golem:GetModifierIncomingDamage_Percentage()
	return (-1) * math.min(mitigation * self:GetStackCount(), mitigationMax)
end

function modifier_mutation_tug_of_war_golem:GetModifierModelScale()
	return math.min(modelScale * self:GetStackCount(), modelScaleMax)
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

			for _, hero in pairs(HeroList:GetAllHeroes()) do
				if keys.attacker:GetTeam() == hero:GetTeam() then
					if hero:IsRealHero() then
						hero:ModifyGold(goldBonus * (1 + previous_stacks), false, DOTA_ModifyGold_Unspecified)
						hero:AddExperience(expBonus * (1 + previous_stacks), DOTA_ModifyXP_CreepKill, false, true)
						SendOverheadEventMessage(PlayerResource:GetPlayer(hero:GetPlayerOwnerID()), OVERHEAD_ALERT_GOLD, hero, goldBonus * (1 + previous_stacks), nil)
						SendOverheadEventMessage(PlayerResource:GetPlayer(hero:GetPlayerOwnerID()), OVERHEAD_ALERT_MANA_ADD, hero, expBonus * (1 + previous_stacks), nil)
					end
				end
			end

			-- New golem
			Timers:CreateTimer(4.5, function()
				if original_team == DOTA_TEAM_GOODGUYS then
					golem = CreateUnitByName("npc_dota_mutation_golem", death_position, false, nil, nil, DOTA_TEAM_BADGUYS)
					golem.ambient_pfx = ParticleManager:CreateParticle("particles/ambient/tug_of_war_team_dire.vpcf", PATTACH_ABSORIGIN_FOLLOW, golem)

					ParticleManager:SetParticleControl(golem.ambient_pfx, 0, golem:GetAbsOrigin())
					Timers:CreateTimer(0.1, function()
						if not golem:IsNull() then
							golem:MoveToPositionAggressive(IMBA_MUTATION_TUG_OF_WAR_TARGET[DOTA_TEAM_BADGUYS])
						end

						return 2
					end) -- Recall the command every 2 seconds so AI doesn't get bricked
				elseif original_team == DOTA_TEAM_BADGUYS then
					golem = CreateUnitByName("npc_dota_mutation_golem", death_position, false, nil, nil, DOTA_TEAM_GOODGUYS)
					golem.ambient_pfx = ParticleManager:CreateParticle("particles/ambient/tug_of_war_team_radiant.vpcf", PATTACH_ABSORIGIN_FOLLOW, golem)
					ParticleManager:SetParticleControl(golem.ambient_pfx, 0, golem:GetAbsOrigin())
					Timers:CreateTimer(0.1, function()
						if not golem:IsNull() then
							golem:MoveToPositionAggressive(IMBA_MUTATION_TUG_OF_WAR_TARGET[DOTA_TEAM_GOODGUYS])
						end

						return 2
					end) -- Recall the command every 2 seconds so AI doesn't get bricked
				end

				local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_greevil_orange/courier_greevil_orange_ambient_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, golem)
				ParticleManager:ReleaseParticleIndex(particle)

				-- Spawn logic
				golem:AddNewModifier(golem, nil, "modifier_mutation_tug_of_war_golem", {}):SetStackCount(previous_stacks + 1)
				FindClearSpaceForUnit(golem, golem:GetAbsOrigin(), true)
			end)
		end
	end
end
