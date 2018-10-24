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

	local assist_gold = {}
	assist_gold[1] = {126, 4.5}
	assist_gold[2] = {63, 3.6}
	assist_gold[3] = {31.5, 2.7}
	assist_gold[4] = {22.5, 1.8}
	assist_gold[5] = {18, 0.9}

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

		-- comeback factor is defined to the team wich has the less net worth
		-- set default comeback factor on dire
		local comeback_factor = 3
		local team_networth = {}
		team_networth[2] = 0
		team_networth[3] = 0

		-- poor factor (amount of gold multiplied based on victim networth rank in it's team. poorest to richest)
		local networth_poor_factor = {0.6, 0.7, 0.9, 1.05, 1.2}

		-- rank factor (amount of gold multiplied based on killer networth rank in it's team. poorest to richest. args means number of assisters to share with)
		local networth_rank_factor = {}
		networth_rank_factor[1] = {1}
		networth_rank_factor[2] = {1.3, 0.7}
		networth_rank_factor[3] = {1.3, 1, 0.7}
		networth_rank_factor[4] = {1.3, 1.1, 0.9, 0.7}
		networth_rank_factor[5] = {1.3, 1.15, 1, 0.85, 0.7}

		-- player networth rank in radiant/dire teams
		local networth_rank[2] = {}
		local networth_rank[3] = {}

		-- save player's networth
		for _, hero in pairs(HeroList:GetAllHeroes()) do
			team_networth[hero:GetTeamNumber()] = team_networth[hero:GetTeamNumber()] + hero:GetNetWorth()
			table.insert(networth_rank[hero:GetTeamNumber()], hero:GetPlayerID(), hero:GetNetWorth())
		end

		-- sort player's networth by team
		bubbleSort(networth_rank[2])
		bubbleSort(networth_rank[3])

		for i, lul in ipairs(networth_rank[2]) do
			print(i, lul)
		end

		for i, lul in ipairs(networth_rank[3]) do
			print(i, lul)
		end

		if team_networth[2] < team_networth[3] then
			comeback_factor = 2
		end

		if victim:GetTeamNumber() == comeback_factor then
			comeback_factor = 1
		end

		print("Team networth:", team_networth[2], team_networth[3])

		local assisters = FindUnitsInRadius(killer:GetTeamNumber(), killer:GetAbsOrigin(), nil, 1300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local assist_formula = (assist_gold[1][math.min(#assisters, 5)] + assist_gold[2][math.min(#assisters, 5)] * victim:GetLevel() + comeback_factor * (victim:GetNetWorth() * 0.026 + 70) / #assisters) * math.min(networth_poor_factor[math.min(networth_rank[victim:GetTeamNumber()], 5)], 5) * 

		for _, assister in pairs(assisters) do

		end
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
