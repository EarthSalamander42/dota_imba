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

	game.md = GetMode()
	game.gl = GetGameLength()
	game.tp = GetTowerUpgrades()
	game.wt = GetWinningTeam()
--	game.wh = GetWinningHeroName(playerID)
	game.wh = ""

	return game
end

function BuildPlayersArray()
local players = {}

	for playerID = 0, DOTA_MAX_PLAYERS do
		if PlayerResource:IsValidPlayerID(playerID) then
			if not PlayerResource:IsBroadcaster(playerID) then
				local hero = PlayerResource:GetSelectedHeroEntity(playerID)
				local player_team = ""
				if hero:GetTeam() == DOTA_TEAM_GOODGUYS then
					player_team = "Radiant"
				else
					player_team = "Dire"
				end

				table.insert(players, {
					steamID32 = PlayerResource:GetSteamAccountID(playerID),

					hn = GetHeroName(playerID), -- Hero name
					pt = player_team, -- Team this hero belongs to
					pb = hero.buyback_count, -- Amount of buybacks performed during the game
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

	statCollection:sendCustom({game = game, players = players})
end

-- A list of players marking who won this round
function BuildRoundWinnerArray()
local winners = {}
local current_winner_team = GameRules.Winner or 0 --You'll need to provide your own way of determining which team won the round

	for playerID = 0, DOTA_MAX_PLAYERS do
		if PlayerResource:IsValidPlayerID(playerID) then
			if not PlayerResource:IsBroadcaster(playerID) then
				winners[PlayerResource:GetSteamAccountID(playerID)] = (PlayerResource:GetTeam(playerID) == current_winner_team) and 1 or 0
			end
		end
	end
	return winners
end