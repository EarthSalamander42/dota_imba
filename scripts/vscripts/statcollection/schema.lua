customSchema = class({})

function customSchema:init()

	-- Check the schema_examples folder for different implementations

	-- Tracks game version
	statCollection:setFlags({version = IMBA_VERSION})
	print("sent version flag")
	
	-- Listen for changes in the current state
	ListenToGameEvent('game_rules_state_change', function(keys)
		local state = GameRules:State_Get()

		-- Send custom stats when the game ends
		if state == DOTA_GAMERULES_STATE_POST_GAME then
			print("got to post game stage")

			-- Build game array
			local game = BuildGameArray()
			print("built game array")

			-- Build players array
			local players = BuildPlayersArray()
			print("built players array")

			-- Print the schema data to the console
			if statCollection.TESTING then
				PrintSchema(game,players)
				print("printed schema")
			end

			-- Send custom stats
			if statCollection.HAS_SCHEMA then
				statCollection:sendCustom({game=game, players=players})
				print("sent stats")
			end
		end
	end, nil)
end

-------------------------------------

function customSchema:submitRound(args)
	winners = BuildRoundWinnerArray()
	game = BuildGameArray()
	players = BuildPlayersArray()

	statCollection:sendCustom({game=game, players=players})

	return {winners = winners, lastRound = false}
end

-------------------------------------

function BuildRoundWinnerArray()
	local winners = {}
	return winners
end

-- Returns a table with our custom game tracking.
function BuildGameArray()

	local game = {}

	-- Tracks total game length, from the horn sound, in seconds
	game.len = GAME_TIME_ELAPSED

	-- Tracks which team won the game
	game.win = GAME_WINNER_TEAM
	
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

					nam = GetHeroName(playerID),	-- Hero by its short name
					lvl = hero:GetLevel(),			-- Hero level at the end of the game
					pnw = GetNetworth(hero),		-- Sum of hero gold and item worth
					pbb = hero.buyback_count,		-- Amount of buybacks performed during the game
					pt = player_team,				-- Team this hero belongs to
					pk = hero:GetKills(),			-- Number of kills of this players hero
					pa = hero:GetAssists(),			-- Number of deaths of this players hero
					pd = hero:GetDeaths(),			-- Number of deaths of this players hero
					pil = GetItemList(hero)			-- Item list
				})
			end
		end
	end

	return players
end

-------------------------------------
--          Stat Functions         --
-------------------------------------

if Convars:GetBool('developer') then
	Convars:RegisterCommand("test_schema", function() PrintSchema(BuildGameArray(),BuildPlayersArray()) end, "Test the custom schema arrays", 0)
end

function PrintSchema( gameArray, playerArray )
	print("--------- GAME DATA ---------")
	DeepPrintTable(gameArray)
	print("\n-------- PLAYER DATA --------")
	DeepPrintTable(playerArray)
	print("-----------------------------")
end

function GetHeroName( playerID )
	local heroName = PlayerResource:GetSelectedHeroName( playerID )
	heroName = string.gsub(heroName,"npc_dota_hero_","")
	return heroName
end

function GetNetworth( hero )
	local gold = hero:GetGold()

	-- Iterate over item slots adding up its gold cost
	for i = 0,15 do
		local item = hero:GetItemInSlot(i)
		if item then
			gold = gold + item:GetCost()
		end
	end

	return gold
end

function GetItemName(hero, slot)
	local item = hero:GetItemInSlot(slot)
	if item then
		local itemName = item:GetAbilityName()
		itemName = string.gsub(itemName,"item_","") --Cuts the item_ prefix
		return itemName
	else
		return ""
	end
end

function GetItemList(hero)
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