-- This file contains all barebones-registered events and has already set up the passed-in parameters for your use.

-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_INIT then
		--Timers:RemoveTimer("alljointimer")
	elseif newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		self.bSeenWaitForPlayers = true
	elseif newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		CustomNetTables:SetTableValue("game_options", "bounty_multiplier", {CUSTOM_GOLD_BONUS[GetMapName()]})
		CustomNetTables:SetTableValue("game_options", "exp_multiplier", {CUSTOM_XP_BONUS[GetMapName()]})

		GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(self, "GoldFilter"), self)
		GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(self, "ExperienceFilter"), self)

		-- setup Player colors into hex for panorama
		local hex_colors = {}

		for i = 0, 23 do
			if PLAYER_COLORS and PLAYER_COLORS[i] then
				table.insert(hex_colors, i, rgbToHex(PLAYER_COLORS[i]))
			end
		end

		CustomNetTables:SetTableValue("game_options", "player_colors", hex_colors)
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		self:PostLoadPrecache()
	elseif newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		for i = 0, PlayerResource:GetPlayerCount() - 1 do
			if not PlayerResource:HasSelectedHero(i) then
				PlayerResource:GetPlayer(i):MakeRandomHeroSelection()
			end
		end

		SendToServerConsole('dota_bot_populate')

		for i = 0, PlayerResource:GetPlayerCount() - 1 do
			PlayerResource:SetGold(i, HERO_INITIAL_GOLD - VANILA_HERO_INITIAL_GOLD, true)

			if PlayerResource:HasSelectedHero(i) then
				PrecacheUnitByNameAsync(PlayerResource:GetSelectedHeroName(i), function(...) end)
			end
		end
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		if PlayerResource:GetPlayerCount() > 5 then
			GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("delay_init_top_bar_colors"), function()
				CustomGameEventManager:Send_ServerToAllClients("override_top_bar_colors", {})
			end, 1.0)
		end

		GameMode:SetupPostTurboRules()
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

	end
end

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)

	if npc then
		-- act on heroes only
		if npc:IsRealHero() then
			if npc.first_spawn == nil then
				GameMode:OnHeroFirstSpawn(npc)
				npc.first_spawn = true
			end

			GameMode:OnHeroSpawn(npc)

			return
		-- act on couriers only
		elseif npc:IsCourier() then
			if npc.first_spawn == nil then
				npc:AddNewModifier(npc, nil, "modifier_imba_turbo_courier", {})
				npc.first_spawn = true
			end
		-- act on everything else
		else
			if npc.first_spawn == nil then
				npc:AddNewModifier(npc, nil, "modifier_custom_mechanics", {})

				npc.first_spawn = true
			end
		end
	end
end

-- An entity died
function GameMode:OnEntityKilled( keys )
	-- The Unit that was Killed
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	-- The Killing entity
	local killerEntity = nil

	if keys.entindex_attacker ~= nil then
		killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end

	-- The ability/item used to kill, or nil if not killed by an item/ability
	local killerAbility = nil

	if keys.entindex_inflictor ~= nil then
		killerAbility = EntIndexToHScript( keys.entindex_inflictor )
	end

	local damagebits = keys.damagebits -- This might always be 0 and therefore useless

	-- Put code here to handle when an entity gets killed
	if killedUnit:IsRealHero() then
		self:OnHeroDeath(killedUnit)
		return
	end
end

function GameMode:OnHeroFirstSpawn(hero)
	-- Check if we can add modifiers to hero
	if not hero:IsEligibleHero() then return end

--	print("GameMode: On Hero First Spawn")

	if HERO_STARTING_LEVEL and HERO_STARTING_LEVEL[GetMapName()] and type(HERO_STARTING_LEVEL[GetMapName()]) == "number" and HERO_STARTING_LEVEL[GetMapName()] > 1 then
		for i = 1, HERO_STARTING_LEVEL[GetMapName()] - 1 do
			hero:HeroLevelUp(false)
		end
	end

	hero:InitializeAbilities()

	hero:AddNewModifier(hero, nil, "modifier_frantic", {})
	hero:AddNewModifier(hero, nil, "modifier_custom_mechanics", {})

	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("delay_init_tooltips"), function()
		-- init tooltips
		local player = PlayerResource:GetPlayer(hero:GetPlayerID())

		CustomGameEventManager:Send_ServerToPlayer(player, "vanillafier_init_tooltips_first_spawn", {})
	end, 1.0)

--	PlayerResource:SetCustomPlayerColor(hero:GetPlayerID(), PLAYER_COLORS[hero:GetPlayerID()][1], PLAYER_COLORS[hero:GetPlayerID()][2], PLAYER_COLORS[hero:GetPlayerID()][3])
end

function GameMode:OnHeroSpawn(hero)
--	print("GameMode: On Hero Spawn")

	
end

function GameMode:OnHeroDeath(hero)
	-- This is a fix for crazy respawn time cooldowns, happens commonly if max level > vanilla max level, but other rare cases may cause it
--[[
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("frame_delay"), function()
		if hero:GetRespawnTime() > 150 and not hero:IsReincarnating() then
			hero:SetTimeUntilRespawn(150)
		end
	end, FrameTime())
--]]
end
