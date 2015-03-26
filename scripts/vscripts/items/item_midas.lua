--[[	Author: d2imba
		Date:	24.03.2015	]]

function MidasPassiveGold( keys )
	local passive_gold = keys.ability:GetLevelSpecialValueFor("passive_gold", keys.ability:GetLevel() - 1)
	keys.caster:ModifyGold(passive_gold, true, 0)
end

function Midas( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local creep_XP = target:GetDeathXP()
	local bonus_gold = ability:GetLevelSpecialValueFor("bonus_gold", ability:GetLevel() - 1)
	local xp_multiplier = ability:GetLevelSpecialValueFor("xp_multiplier", ability:GetLevel() - 1)

	local bonus_xp = creep_XP * xp_multiplier

	target:EmitSound("DOTA_Item.Hand_Of_Midas")

	local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)	
	ParticleManager:SetParticleControlEnt(midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)

	target:SetDeathXP(0)
	target:SetMinimumGoldBounty(0)
	target:SetMaximumGoldBounty(0)
	target:Kill(ability, caster)
	caster:AddExperience(bonus_xp, false, false)
	caster:ModifyGold(bonus_gold, true, 0)
end
