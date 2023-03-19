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
	-- Custom buyback cost is currently disabled so everything concerning that should be doing nothing...emphasis on SHOULD
	local buyback_cost = BUYBACK_BASE_COST + level_based_cost + game_time * BUYBACK_COST_PER_SECOND
	local custom_gold_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "bounty_multiplier")["1"])

	buyback_cost = buyback_cost * (custom_gold_bonus / 100)

	-- #7 Talent Vengeful Spirit - Decreased respawn time & cost
	if victim:HasTalent("special_bonus_imba_vengefulspirit_7") then
		buyback_cost = buyback_cost * (1 - (victim:FindTalentValue("special_bonus_imba_vengefulspirit_7", "buyback_cost_pct") / 100))
		buyback_cooldown = buyback_cooldown * (1 - (victim:FindTalentValue("special_bonus_imba_vengefulspirit_7", "buyback_cooldown_pct") / 100))
	end

	-- Update buyback cost
	PlayerResource:SetCustomBuybackCost(player_id, buyback_cost)
	PlayerResource:SetCustomBuybackCooldown(player_id, buyback_cooldown)

	if killer:IsBuilding() then
		if victim:IsRealHero() then
			CombatEvents("generic", "tower_kill_hero", victim, killer)
		end
	end

	local hero = victim
	if victim:IsClone() then
		hero = victim:GetCloneSource()
	end

	-------------------------------------------------------------------------------------------------
	-- Arc Warden Tempest Double keeping Duel Damage
	-------------------------------------------------------------------------------------------------
	if killer:HasModifier("modifier_legion_commander_duel") or victim:HasModifier("modifier_legion_commander_duel") then
		for _, ent in pairs(Entities:FindAllByName("npc_dota_hero_arc_warden")) do
			if ent:IsTempestDouble() then
				Timers:CreateTimer(FrameTime(), function()
					if ent:HasModifier("modifier_legion_commander_duel_damage_boost") then
						ent.duel_damage = ent:FindModifierByName("modifier_legion_commander_duel_damage_boost"):GetStackCount()
						ent.duel_ability = ent:FindModifierByName("modifier_legion_commander_duel_damage_boost"):GetAbility()
					end
				end)
			end
		end
	end

	-- Tell me why this is required, i'll wait
	if killer:GetTeam() == DOTA_TEAM_BADGUYS then
		GameRules:GetGameModeEntity():SetCustomDireScore(GetTeamHeroKills(DOTA_TEAM_BADGUYS))
	end
end
