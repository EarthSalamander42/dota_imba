customSchema = class({})

function customSchema:init()
	ListenToGameEvent('game_rules_state_change', function(keys)
		local state = GameRules:State_Get()

		if state == DOTA_GAMERULES_STATE_POST_GAME then
			local game = BuildGameArray()
			local players = BuildPlayersArray()

			if statCollection.TESTING then
				PrintSchema(game, players)
			end
			if statCollection.HAS_SCHEMA then
				statCollection:sendCustom({ game = game, players = players })
			end
		end
	end, nil)

	if Convars:GetBool('developer') then
		Convars:RegisterCommand("test_schema", function() PrintSchema(BuildGameArray(), BuildPlayersArray()) end, "Test the custom schema arrays", 0)
		Convars:RegisterCommand("test_end_game", function() GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS) end, "Test the end game", 0)
	end
end

function BuildGameArray()
local game = {}

	game.mp = GetMapName()

	return game
end

function BuildPlayersArray()
local players = {}

	for playerID = 0, DOTA_MAX_PLAYERS do
		if PlayerResource:IsValidPlayerID(playerID) then
			if not PlayerResource:IsBroadcaster(playerID) then
				local hero = PlayerResource:GetSelectedHeroEntity(playerID)

				table.insert(players, {
					steamID32 = PlayerResource:GetSteamAccountID(playerID),

					hn = GetHeroName(playerID), -- Hero name
					wh = GetWinningHeroName(playerID)
				})
			end
		end
	end

	return players
end

function PrintSchema(gameArray, playerArray)
	print("-------- GAME DATA --------")
	DeepPrintTable(gameArray)
	print("\n-------- PLAYER DATA --------")
	DeepPrintTable(playerArray)
	print("-------------------------------------")
end

function customSchema:submitRound()

	local winners = BuildRoundWinnerArray()
	local game = BuildGameArray()
	local players = BuildPlayersArray()

	statCollection:sendCustom({ game = game, players = players })
end
