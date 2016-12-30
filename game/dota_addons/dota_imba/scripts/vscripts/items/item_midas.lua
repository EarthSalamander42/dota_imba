--[[	Author: d2imba
		Date:	24.03.2015	]]

function Midas( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sound_cast = keys.sound_cast

	-- If this unit is not a real hero, do nothing
	if not caster:IsRealHero() then
		ability:RefundManaCost()
		ability:EndCooldown()
		return nil
	end

	-- Parameters and calculations
	local bonus_gold = ability:GetSpecialValueFor("bonus_gold")
	local xp_multiplier = ability:GetSpecialValueFor("xp_multiplier")
	local passive_gold_bonus = ability:GetSpecialValueFor("passive_gold_bonus")
	local bonus_xp = target:GetDeathXP()
	local game_time = math.max(GameRules:GetDOTATime(false, false), 0)

	-- Adjust for the lobby settings and for midas' own bonuses
	bonus_xp = bonus_xp * xp_multiplier * (1 + CUSTOM_XP_BONUS * 0.01) * (1 + game_time * BOUNTY_RAMP_PER_SECOND * 0.01)
	bonus_gold = bonus_gold * (1 + CUSTOM_GOLD_BONUS * 0.01) * (1 + game_time * BOUNTY_RAMP_PER_SECOND * 0.01) * (1 + passive_gold_bonus * 0.01)

	-- Play sound and show gold gain message to the owner
	target:EmitSound(sound_cast)
	SendOverheadEventMessage(PlayerResource:GetPlayer(caster:GetPlayerID()), OVERHEAD_ALERT_GOLD, target, bonus_gold, nil)

	-- Draw the midas gold conversion particle
	local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)	
	ParticleManager:SetParticleControlEnt(midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)

	-- Grant gold and XP only to the caster
	target:SetDeathXP(0)
	target:SetMinimumGoldBounty(0)
	target:SetMaximumGoldBounty(0)
	target:Kill(ability, caster)
	caster:AddExperience(bonus_xp, false, false)
	caster:ModifyGold(bonus_gold, true, 0)
end
