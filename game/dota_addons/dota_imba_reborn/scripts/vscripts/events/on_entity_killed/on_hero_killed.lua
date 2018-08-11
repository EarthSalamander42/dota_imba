function GameMode:OnHeroKilled(killer, killed_unit)
	-- Buyback parameters
	local player_id = killed_unit:GetPlayerID()
	local hero_level = killed_unit:GetLevel()
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
	if killed_unit:HasTalent("special_bonus_imba_vengefulspirit_7") then
		buyback_cost = buyback_cost * (1 - (killed_unit:FindTalentValue("special_bonus_imba_vengefulspirit_7", "buyback_cost_pct") * 0.01))
		buyback_cooldown = buyback_cooldown * (1 - (killed_unit:FindTalentValue("special_bonus_imba_vengefulspirit_7", "buyback_cooldown_pct") * 0.01))
	end

	-- Update buyback cost
	PlayerResource:SetCustomBuybackCost(player_id, buyback_cost)
	PlayerResource:SetCustomBuybackCooldown(player_id, buyback_cooldown)

	-- undying reincarnation talent fix
	if killed_unit:HasModifier("modifier_special_bonus_reincarnation") then
		if not killed_unit.undying_respawn_timer or killed_unit.undying_respawn_timer == 0 then
			log.info(killed_unit:FindModifierByName("modifier_special_bonus_reincarnation"):GetDuration())
			killed_unit:SetTimeUntilRespawn(IMBA_REINCARNATION_TIME)
			killed_unit.undying_respawn_timer = 200
			return
		end
	end

	-- meepo fix
	if killed_unit:GetUnitName() == "npc_dota_hero_meepo" then
		if killed_unit:GetCloneSource() then
			if killed_unit:GetCloneSource():HasModifier("modifier_item_imba_aegis") then
				local meepo_table = Entities:FindAllByName("npc_dota_hero_meepo")
				if meepo_table then
					for i = 1, #meepo_table do
						if meepo_table[i]:IsClone() then
							meepo_table[i]:SetRespawnsDisabled(true)
							meepo_table[i]:GetCloneSource():SetTimeUntilRespawn(killed_unit:GetCloneSource():FindModifierByName("modifier_item_imba_aegis").reincarnate_time)
							meepo_table[i]:GetCloneSource():RemoveModifierByName("modifier_item_imba_aegis")
						else
							meepo_table[i]:SetTimeUntilRespawn(killed_unit:FindModifierByName("modifier_item_imba_aegis").reincarnate_time)
							return
						end
					end
				end
			end
		end
	end

	local respawn_time = 0
	if killed_unit:IsImbaReincarnating() then
		killed_unit:SetTimeUntilRespawn(IMBA_REINCARNATION_TIME)
		return
	elseif killed_unit:IsRealHero() and killed_unit:GetPlayerID() and (PlayerResource:IsImbaPlayer(killed_unit:GetPlayerID()) or (GameRules:IsCheatMode() == true)) then
		-- Calculate base respawn timer, capped at 60 seconds
		local hero_level = math.min(killed_unit:GetLevel(), #HERO_RESPAWN_TIME_PER_LEVEL)
		respawn_time = HERO_RESPAWN_TIME_PER_LEVEL[hero_level]

		-- Fetch decreased respawn timer due to Bloodstone charges
		if killed_unit.bloodstone_respawn_reduction and (respawn_time > 0) then
			respawn_time = math.max( respawn_time - killed_unit.bloodstone_respawn_reduction, 1)
			-- 1 sec minimum respawn time
		elseif killed_unit.plancks_artifact_respawn_reduction and respawn_time > 0 then
			respawn_time = math.max(respawn_time - killed_unit.plancks_artifact_respawn_reduction, 1)
		end

		-- Set up the respawn timer, include meepo fix
		if killed_unit:GetUnitName() == "npc_dota_hero_meepo" then
			KillMeepos()
		else
			if killed_unit:HasModifier("modifier_imba_reapers_scythe_respawn") then
				local reaper_scythe = killer:FindAbilityByName("imba_necrolyte_reapers_scythe"):GetSpecialValueFor("respawn_increase")
				-- Sometimes the killer is not actually Necrophos due to the respawn modifier lingering on a target, which makes reaper_scythe nil and causes massive problems
				if not reaper_scythe then
					reaper_scythe = 0
				end
				respawn_time = HERO_RESPAWN_TIME_PER_LEVEL[hero_level] + reaper_scythe
			elseif respawn_time > HERO_RESPAWN_TIME_PER_LEVEL[#HERO_RESPAWN_TIME_PER_LEVEL] then
				log.warn("Respawn Time too high: "..tostring(respawn_time)..". New Respawn Time:"..tostring(HERO_RESPAWN_TIME_PER_LEVEL[#HERO_RESPAWN_TIME_PER_LEVEL]))
				respawn_time = HERO_RESPAWN_TIME_PER_LEVEL[#HERO_RESPAWN_TIME_PER_LEVEL]
			end

            -- Another check to try and catch any unknown exceptions
            if respawn_time == nil then
                -- Set it back to something normal...
				log.warn("Respawn Time nil...New Respawn Time: "..tostring(HERO_RESPAWN_TIME_PER_LEVEL[#HERO_RESPAWN_TIME_PER_LEVEL]))
                respawn_time = HERO_RESPAWN_TIME_PER_LEVEL[#HERO_RESPAWN_TIME_PER_LEVEL]
            end

			-- divide the respawn time by 2 for frantic mode
			if killed_unit:HasModifier("modifier_frantic") then
				respawn_time = respawn_time - respawn_time / (100 / _G.IMBA_FRANTIC_VALUE)
			end

            -- Finally, cap respawn time to a maximum of 100 seconds in case all the checks above failed
			log.info("Set time until respawn for unit " .. tostring(killed_unit:GetUnitName()) .. " to " .. tostring(min(respawn_time, 100)) .. " seconds")
			killed_unit:SetTimeUntilRespawn(min(respawn_time, 100))
		end
	end
end
