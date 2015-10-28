customSchema = class({})

function customSchema:init()
	-- Check the schema_examples folder for different implementations

	-- Tracks game version
	statCollection:setFlags({version = IMBA_VERSION})
	
	-- Listen for changes in the current state
	ListenToGameEvent('game_rules_state_change', function(keys)
		local state = GameRules:State_Get()

		-- Send custom stats when the game ends
		if state == DOTA_GAMERULES_STATE_POST_GAME then

			-- Build game array
			local game = BuildGameArray()

			-- Build players array
			local players = BuildPlayersArray()

			-- Print the schema data to the console
			if statCollection.TESTING then
				PrintSchema(game,players)
			end

			-- Send custom stats
			if statCollection.HAS_SCHEMA then
				statCollection:sendCustom({game=game, players=players})
			end
		end
	end, nil)
end

-------------------------------------

-- In the statcollection/lib/utilities.lua, you'll find many useful functions to build your schema.
-- You are also encouraged to call your custom mod-specific functions

-- Returns a table with our custom game tracking.
function BuildGameArray()

	local game = {}

	-- Tracks total game length, from the horn sound, in seconds
	game.len = GAME_TIME_ELAPSED

	-- Tracks which team won the game
	game.win = GAME_WINNER_TEAM

	-- Tracks the winning king
	local winner_king = "none"
	if GAME_WINNER_TEAM == "Radiant" then
		winner_king = "Skeleton King"
	elseif GAME_WINNER_TEAM == "Dire" then
		winner_king = "Wraith King"
	end
	game.kin = winner_king
	
	return game
end

-- Returns a table containing data for every player in the game
function BuildPlayersArray()
	local players = {}
	for playerID = 0, DOTA_MAX_PLAYERS do
		if PlayerResource:IsValidPlayerID(playerID) then
			if not PlayerResource:IsBroadcaster(playerID) then

				local hero = PlayerResource:GetSelectedHeroEntity(playerID)

				-- Team string logic
				local player_team = ""
				if hero:GetTeam() == DOTA_TEAM_GOODGUYS then
					player_team = "Radiant"
				else
					player_team = "Dire"
				end

				table.insert(players, {

					-- SteamID32 required in here
					steamID32 = PlayerResource:GetSteamAccountID(playerID),

					-- Example functions for generic stats are defined in statcollection/lib/utilities.lua
                    -- Add player values here as someValue = GetSomePlayerValue(),

					nam = GetHeroName(playerID),	-- Hero by its short name
					lvl = hero:GetLevel(),			-- Hero level at the end of the game
					pnw = GetNetworth(hero),		-- Sum of hero gold and item worth
					pbb = hero.buyback_count,		-- Amount of buybacks performed during the game
					pt = player_team,				-- Team this hero belongs to
					pk = hero:GetKills(),			-- Number of kills of this players hero
					pa = hero:GetAssists(),			-- Number of deaths of this players hero
					pd = hero:GetDeaths(),			-- Number of deaths of this players hero
					pil = GetItemListImba(hero)		-- Item list
				})
			end
		end
	end

	return players
end

-------------------------------------
--          Stat Functions         --
-------------------------------------

-- Prints the custom schema, required to get an schemaID
function PrintSchema( gameArray, playerArray )
	print("--------- GAME DATA ---------")
	DeepPrintTable(gameArray)
	print("\n-------- PLAYER DATA --------")
	DeepPrintTable(playerArray)
	print("-----------------------------")
end

-- Write 'test_schema' on the console to test your current functions instead of having to end the game
if Convars:GetBool('developer') then
	Convars:RegisterCommand("test_schema", function() PrintSchema(BuildGameArray(),BuildPlayersArray()) end, "Test the custom schema arrays", 0)
end

-------------------------------------

-- If your gamemode is round-based, you can use statCollection:submitRound(bLastRound) at any point of your main game logic code to send a round
-- If you intend to send rounds, make sure your settings.kv has the 'HAS_ROUNDS' set to true. Each round will send the game and player arrays defined earlier
-- The round number is incremented internally, lastRound can be marked to notify that the game ended properly
function customSchema:submitRound(isLastRound)
	local winners = BuildRoundWinnerArray()
	local game = BuildGameArray()
	local players = BuildPlayersArray()

	statCollection:sendCustom({game=game, players=players})

	isLastRound = isLastRound or false -- If the function is passed with no parameter, default to false.
	return {winners = winners, lastRound = isLastRound}
end

-- A list of players marking who won this round
function BuildRoundWinnerArray()
	local winners = {}
	local current_winner_team = GameRules.Winner or 0 -- You'll need to provide your own way of determining which team won the round
	for playerID = 0, DOTA_MAX_PLAYERS do
		if PlayerResource:IsValidPlayerID(playerID) then
			if not PlayerResource:IsBroadcaster(playerID) then
				winners[PlayerResource:GetSteamAccountID(playerID)] = (PlayerResource:GetTeam(playerID) == current_winner_team) and 1 or 0
			end
		end
	end
	return winners
end

-------------------------------------
-- MY CUSTOM FUNCTIONS
-------------------------------------

function GetItemListImba(hero)
	local itemTable = {}

	for i=0,5 do
		local item = hero:GetItemInSlot(i)
		if item then
			if string.find(item:GetAbilityName(), "imba") then
				local itemName = string.gsub(item:GetAbilityName(),"item_imba_","")
				table.insert(itemTable,itemName)
			else
				local itemName = string.gsub(item:GetAbilityName(),"item_","")
				table.insert(itemTable,itemName)
			end
		end
	end

	table.sort(itemTable)
	local itemList = table.concat(itemTable, ",")

	return itemList
end