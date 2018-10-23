if GoldSystem == nil then
	GoldSystem = class({})
end

function GoldSystem:OnHeroDeath(killer, victim)
	local streak_table = {}
	streak_table[0] = 0
	streak_table[1] = 0
	streak_table[2] = 0
	streak_table[3] = 60
	streak_table[4] = 120
	streak_table[5] = 180
	streak_table[6] = 240
	streak_table[7] = 300
	streak_table[8] = 360
	streak_table[9] = 420
	streak_table[10] = 480

	-- TODO list:
	-- split formula gold between all enemy heroes if the victim was not hit by any enemy hero in the last 20 seconds

	local base_gold_bounty = 110
	if not victim.killstreak then victim.killstreak = 0 end
	local streak_value = streak_table[math.min(victim.killstreak, 10)]
	local formula = base_gold_bounty + streak_value + (math.min(victim:GetLevel(), 25) * 8)
	local victim_attacker_count = victim:GetNumAttackers()

	print(base_gold_bounty, streak_value, math.min(victim:GetLevel(), 25) * 8, formula)

	if not killer:IsRealHero() then killer = nil end

	if killer then
		if not killer.killstreak then killer.killstreak = 0 end
		killer.killstreak = killer.killstreak + 1

		if IMBA_FIRST_BLOOD == false then
			print("First Blood!")
			IMBA_FIRST_BLOOD = true
			formula = formula + 150
		end

		SendOverheadEventMessage(killer:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, victim, formula, nil)
		killer:ModifyGold(formula, true, DOTA_ModifyGold_HeroKill)
		CombatEvents("kill", "hero_kill", victim, killer, formula)
	else
		print("Attackers: "..victim_attacker_count)
		if victim_attacker_count == 0 then
			for _, hero in pairs(HeroList:GetAllHeroes()) do
				if hero:GetTeam() ~= victim:GetTeam() then
					print(formula / PlayerResource:GetPlayerCountForTeam(hero:GetTeamNumber()), formula)
					SendOverheadEventMessage(hero:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, victim, formula / PlayerResource:GetPlayerCountForTeam(hero:GetTeamNumber()), nil)
					hero:ModifyGold(formula / PlayerResource:GetPlayerCountForTeam(hero:GetTeamNumber()), true, DOTA_ModifyGold_HeroKill)
				end
			end
		else
			for _, attacker in pairs(HeroList:GetAllHeroes()) do
				for i = 0, victim_attacker_count -1 do
					if attacker:GetPlayerID() == victim:GetAttacker(i) then
						print("Attacker:", attacker:GetUnitName())
						print("Gold:", formula / victim_attacker_count, formula)
						SendOverheadEventMessage(attacker:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, victim, formula / victim_attacker_count, nil)
						attacker:ModifyGold(formula / victim_attacker_count, true, DOTA_ModifyGold_HeroKill)
					end
				end
			end
		end
	end

	victim.killstreak = 0
end
