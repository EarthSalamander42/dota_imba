-- Credits: KIT
-- Date 14/01/2021

if not TeamOrdering then
	TeamOrdering = class({})
end

-- events
ListenToGameEvent('game_rules_state_change', function()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("anti_stacks_fucker"), function()
			TeamOrdering:ComputeTeamSelection()

			return nil
		end, 1.0)
	end
end, nil)

-- core
function TeamOrdering:ComputeTeamSelection()
	local steamids = {1234, 3123, 1231, 1232, 1241, 1235, 4121, 1231, 1233, 1211}
	local winrates = {81.0, 77.0, 74.2, 65.1, 54.2, 53.2, 49.9, 43.3, 41.2, 32.8}

	-- not tested yet
	if not IsInToolsMode() then
		for i = 0, PlayerResource:GetPlayerCount() - 1 do
			if PlayerResource:IsValidPlayer(i) then
				steamids[i + 1] = PlayerResource:GetSteamID(i)
				winrates[i + 1] = api:GetPlayerWinrate(i)
			end
		end
	end

	local n = 10
	local k = 5
	local halfCombinationsNumber = 126 -- generations number is n!/((n-k)!*k!) 

	local combination = {}

	for i = 0, k - 1 do
		combination[i] = i
	end

	combination[k] = n

	for i = 0, halfCombinationsNumber - 1 do
		PrintArray(combination)

		local oppositeCombination = {}

		for j = 0, 9 do
			oppositeCombination[j] = j
		end

		ArraySubtract(oppositeCombination, combination)
		PrintArray(oppositeCombination)

		--teamA = {}
		--for i = 0, k - 1 do
		--    teamA[i] = steamids[combination[i]]

		local jKeeper = 0

		for j = 0, k do
			jKeeper = j

			if combination[j] + 1 and combination[j + 1] and combination[j] + 1 == combination[j + 1] then
				combination[j] = j
			else
				break
			end
		end

		if jKeeper < k then
			combination[jKeeper] = combination[jKeeper] + 1
		else
			break
		end
	end
end

function TeamOrdering:CalculateWinrateDifference(teamAwinrates, teamBWinrates)
	local winrateTeamA = 0
	local winrateTeamB = 0
	
	for _, playerAWinrate in pairs(teamAWinrates) do
		winrateTeamA = winrateTeamA + playerAWinrate
	end

	for _, playerBWinrate in pairs(teamBWinrates) do
		winrateTeamB = winrateTeamB + playerBWinrate
	end

	return math.abs(winrateTeamA-winrateTeamB)
end

-- utils
function PrintArray(array)
	local text = ""

	for i = 0, #array do
		text = text..array[i].." | "
	end

	print(text)
end

function ArraySubtract(t2, t1)
	local set = {}
	for i = 0, #t1-1 do
		set[t1[i]] = true;
	end
	difference = t2
	for i = #difference-1, 0, -1 do
		if set[difference[i+1]] then
			table.remove(difference, i+1)
		end
	end
	return difference
end
