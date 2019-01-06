function GameMode:OnHeroDeath(killer, victim)
	-- Buyback parameters
	local player_id = victim:GetPlayerID()
	local hero_level = victim:GetLevel()
	local game_time = GameRules:GetDOTATime(false, true)

	-- Calculate buyback cost
	local level_based_cost = math.min(hero_level * hero_level, 625) * BUYBACK_COST_PER_LEVEL
	if hero_level > 25 then
		level_based_cost = level_based_cost + BUYBACK_COST_PER_LEVEL_AFTER_25 * (hero_level - 25)
	end

	local buyback_cooldown = BUYBACK_COOLDOWN_MAXIMUM
	local buyback_cost = BUYBACK_BASE_COST + level_based_cost + game_time * BUYBACK_COST_PER_SECOND
	local custom_gold_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "bounty_multiplier")["1"])

	buyback_cost = buyback_cost * (custom_gold_bonus / 100)

	-- #7 Talent Vengeful Spirit - Decreased respawn time & cost
	if victim:HasTalent("special_bonus_imba_vengefulspirit_7") then
		buyback_cost = buyback_cost * (1 - (victim:FindTalentValue("special_bonus_imba_vengefulspirit_7", "buyback_cost_pct") * 0.01))
		buyback_cooldown = buyback_cooldown * (1 - (victim:FindTalentValue("special_bonus_imba_vengefulspirit_7", "buyback_cooldown_pct") * 0.01))
	end

	-- Update buyback cost
	PlayerResource:SetCustomBuybackCost(player_id, buyback_cost)
	PlayerResource:SetCustomBuybackCooldown(player_id, buyback_cooldown)

	if killer:IsBuilding() then
		if victim:IsRealHero() then
			CombatEvents("generic", "tower_kill_hero", victim, killer)
		end
	end

	-- undying reincarnation talent fix
	if victim:HasModifier("modifier_special_bonus_reincarnation") then
		if not victim.undying_respawn_timer or victim.undying_respawn_timer == 0 then
--			print(victim:FindModifierByName("modifier_special_bonus_reincarnation"):GetDuration())
			victim:SetTimeUntilRespawn(IMBA_REINCARNATION_TIME)
			victim.undying_respawn_timer = 200
			return
		end
	end

	local hero = victim
	if victim:IsClone() then
		hero = victim:GetCloneSource()
	end

	local respawn_time = 0
	if hero:IsImbaReincarnating() then
		hero:SetTimeUntilRespawn(IMBA_REINCARNATION_TIME)
		return
	else
		-- Calculate base respawn timer, capped at 60 seconds
		local hero_level = math.min(hero:GetLevel(), #_G.HERO_RESPAWN_TIME_PER_LEVEL)
		respawn_time = _G.HERO_RESPAWN_TIME_PER_LEVEL[hero_level]

		-- Adjust respawn time for Wraith King's Reincarnation Passive Respawn Reduction
		if hero:HasModifier("modifier_imba_reincarnation") then
			respawn_time = respawn_time - hero:FindModifierByName("modifier_imba_reincarnation").passive_respawn_haste
		end
		
		-- Fetch decreased respawn timer due to Bloodstone charges
		if hero.bloodstone_respawn_reduction and (respawn_time > 0) then
			respawn_time = math.max( respawn_time - hero.bloodstone_respawn_reduction, 1)
		elseif hero.plancks_artifact_respawn_reduction and respawn_time > 0 then
			respawn_time = math.max(respawn_time - hero.plancks_artifact_respawn_reduction, 1)
		end

		if hero:HasModifier("modifier_imba_reapers_scythe_respawn") then
			if killer:HasAbility("imba_necrolyte_reapers_scythe") then
				local reaper_scythe = killer:FindAbilityByName("imba_necrolyte_reapers_scythe"):GetSpecialValueFor("respawn_increase")
				-- Sometimes the killer is not actually Necrophos due to the respawn modifier lingering on a target, which makes reaper_scythe nil and causes massive problems
	--			print("Killed by Reaper Scythe!", reaper_scythe, _G.HERO_RESPAWN_TIME_PER_LEVEL[hero_level] + reaper_scythe)
				if not reaper_scythe then
					reaper_scythe = 0
				end
				respawn_time = respawn_time + reaper_scythe
				hero:SetTimeUntilRespawn(math.min(respawn_time, 60 + reaper_scythe))
				return
			end
		end

		if respawn_time == nil or not respawn_time then
--			print("Something terrible has happened...set respawn timer to something reasonable.")
			respawn_time = _G.HERO_RESPAWN_TIME_PER_LEVEL[hero_level]
		end

--		print("Set time until respawn for unit " .. tostring(hero:GetUnitName()) .. " to " .. tostring(respawn_time) .. " seconds")
		hero:SetTimeUntilRespawn(math.min(respawn_time, 60))

		-- 50% of vanilla respawn time
--		hero:SetTimeUntilRespawn(hero:GetRespawnTime() / 100 * 50)
		return
	end
end
