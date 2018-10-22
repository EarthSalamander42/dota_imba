if GoldSystem == nil then
	GoldSystem = class({})
end

function GoldSystem:OnHeroDeath(killer, victim)
	local gold_bounty = 0

	-- insert algorythm here

	SendOverheadEventMessage(killer:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, victim, gold_bounty, nil)
	killer:ModifyGold(gold_bounty, true, DOTA_ModifyGold_HeroKill)

--		for _, attacker in pairs(HeroList:GetAllHeroes()) do
--			for i = 0, victim:GetNumAttackers() -1 do
--				if attacker == victim:GetAttacker(i) then
--					print("Attacker:", attacker:GetUnitName())
--				end
--			end
--		end
end
