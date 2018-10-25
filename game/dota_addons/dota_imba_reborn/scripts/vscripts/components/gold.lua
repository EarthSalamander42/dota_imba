if GoldSystem == nil then
	GoldSystem = class({})
end

function GoldSystem:OnHeroDeath(killer, victim)
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
	local base_gold_bounty = 250
	local level_difference = killer:GetLevel() - victim:GetLevel()
	local level_bonus = 100 * math.max(level_difference, 0) 
	local kill_streak_with_limit = math.min(victim.killstreak, 15)
	local streak_bonus = 100 * math.sqrt(kill_streak_with_limit) * kill_streak_with_limit
	local kill_gold = math.floor(base_gold_bounty + level_bonus + streak_bonus)

	print(base_gold_bounty, streak_value, streak_diff, formula)

	if not killer:IsRealHero() then killer = nil end

	if killer then
		if not killer.killstreak then killer.killstreak = 0 end
		killer.killstreak = killer.killstreak + 1

		if IMBA_FIRST_BLOOD == false then
			print("First Blood!")
			IMBA_FIRST_BLOOD = true
			kill_gold = kill_gold + 150
		end

		SendOverheadEventMessage(killer:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, victim, kill_gold, nil)
		killer:ModifyGold(kill_gold, true, DOTA_ModifyGold_HeroKill)

		local victim_team_networth = 0

		for _, hero in pairs(HeroList:GetAllHeroes()) do
			if hero:GetTeamNumber() == victim:GetTeamNumber() then
				victim_team_networth = victim_team_networth + hero:GetNetWorth()
			end
		end

		local average_victim_team_networth = victim_team_networth / PlayerResource:GetPlayerCountForTeam(victim:GetTeamNumber())

		local assisters = FindUnitsInRadius(killer:GetTeamNumber(), killer:GetAbsOrigin(), nil, 1300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		for _, assister in pairs(assisters) do
			local base_aoe_gold = 1000 / #assisters
			local networth_bonus = math.max(average_victim_team_networth - victim:GetNetWorth(), 0) * 0.05
			local aoe_gold_for_player = math.floor(base_aoe_gold + networth_bonus)
		end

		CombatEvents("kill", "hero_kill", victim, killer, kill_gold)
	else
		local victim_attacker_count = victim:GetNumAttackers()

		print("Attackers: "..victim_attacker_count)
		if victim_attacker_count == 0 then
			for _, hero in pairs(HeroList:GetAllHeroes()) do
				print(kill_gold / PlayerResource:GetPlayerCountForTeam(hero:GetTeamNumber()), kill_gold)
				SendOverheadEventMessage(hero:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, victim, kill_gold / PlayerResource:GetPlayerCountForTeam(hero:GetTeamNumber()), nil)
				hero:ModifyGold(kill_gold / PlayerResource:GetPlayerCountForTeam(hero:GetTeamNumber()), true, DOTA_ModifyGold_HeroKill)
			end
		else
			for _, attacker in pairs(HeroList:GetAllHeroes()) do
				for i = 0, victim_attacker_count -1 do
					if attacker:GetPlayerID() == victim:GetAttacker(i) then
						print("Attacker:", attacker:GetUnitName())
						print("Gold:", kill_gold / victim_attacker_count, kill_gold)
						SendOverheadEventMessage(attacker:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, victim, kill_gold / victim_attacker_count, nil)
						attacker:ModifyGold(kill_gold / victim_attacker_count, true, DOTA_ModifyGold_HeroKill)
					end
				end
			end
		end
	end

	victim.killstreak = 0
end
