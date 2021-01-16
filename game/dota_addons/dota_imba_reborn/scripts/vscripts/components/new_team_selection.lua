-- Credits: KIT
-- Date 14/01/2021

if not TeamOrdering then
	TeamOrdering = class({})
	TeamOrdering.winrates = {}
end

-- events

ListenToGameEvent('game_rules_state_change', function()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		if GetMapName() == "imba_5v5" or GetMapName() == "imba_10v10" and IsInToolsMode() then
			GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("anti_stacks_fucker"), function()
				-- This function is called when connection to backend is successful if not in tools mode, let's call it in tools mode when bots are added in for testing purpose
				TeamOrdering:ComputeTeamSelection()

				return nil
			end, 3.0)
		end
	end
end, nil)


-- core
function TeamOrdering:ComputeTeamSelection()
	local n = PlayerResource:GetPlayerCount()
	local k = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
	local acceptableWinratesDifference = 1 -- for 10v10 only

	local halfCombinationsNumber = 126 -- generations number is n!/((n-k)!*k!)
	local winratesBaseArray = {81.0, 77.0, 74.2, 65.1, 54.2, 53.2, 49.9, 43.3, 41.2, 32.8, 41.0, 71.0, 72.2, 62.1, 24.2, 33.2, 19.9, 63.3, 71.2, 92.8}

	if GetMapName() == "imba_10v10" then
		halfCombinationsNumber = 92378
	end

	-- not tested yet
	if IsInToolsMode() then
		for i = 0, n - 1 do
			self.winrates[i] = winratesBaseArray[i + 1]
		end
	else
		for i = 0, PlayerResource:GetPlayerCount() - 1 do
			if PlayerResource:IsValidPlayer(i) then
				self.winrates[i] = api:GetPlayerWinrate(i)
				print("Player ID:", i, PlayerResource:GetPlayerName(i))
			end
		end
	end

	local combination = {}

	for i = 0, k - 1 do
		combination[i] = i
	end

	combination[k] = n

	local winratesDifference = nil
	local smallestWinratesDifference = 100 * k -- highest winrates difference possible

	local bestTeamAOrdering = {}
	local bestTeamBOrdering = {}

	for i = 0, halfCombinationsNumber - 1 do
		-- start of operations with combination

		local oppositeCombination = {}

		for j = 0, n - 1 do
		 	oppositeCombination[j] = j
		end

		oppositeCombination = TableSubtract(oppositeCombination, combination)

		local teamA = CopyArray(combination, k)
		local teamB = CopyArray(oppositeCombination, k)

		winratesDifference = self:CalculateWinratesDifference(teamA, teamB)

		if GetMapName() == "imba_10v10" and winratesDifference < acceptableWinratesDifference then
	        smallestWinratesDifference = winratesDifference
	        bestTeamAOrdering = CopyArray(teamA, k)
	        bestTeamBOrdering = CopyArray(teamB, k)
	        break
    	end

		if winratesDifference then
			print("Winrate Diffs:", winratesDifference, smallestWinratesDifference)
			if winratesDifference < smallestWinratesDifference then
				smallestWinratesDifference = winratesDifference
				bestTeamAOrdering = CopyArray(teamA, k)
				bestTeamBOrdering = CopyArray(teamB, k)
			end
		end

		-- end of operations with combination
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

	print("Radiant comp:", bestTeamAOrdering)
	print("Dire comp:", bestTeamBOrdering)
	self:SetTeams_PostCompute(bestTeamAOrdering, bestTeamBOrdering)
end

function TeamOrdering:CalculateWinratesDifference(teamA, teamB)
	local winrateTeamA = 0
	local winrateTeamB = 0
	
	for _, playerAIndex in pairs(teamA) do
		winrateTeamA = winrateTeamA + self.winrates[playerAIndex]
	end

	for _, playerBIndex in pairs(teamB) do
		winrateTeamB = winrateTeamB + self.winrates[playerBIndex]
	end

	return math.abs(winrateTeamA - winrateTeamB)
end


-- hRadiant and hDire should return both an array of player id's
function TeamOrdering:SetTeams_PostCompute(hRadiant, hDire)
	-- unassign players
	for i = 0, PlayerResource:GetPlayerCount() - 1 do
		local player = PlayerResource:GetPlayer(i)

		player:SetTeam(DOTA_TEAM_NOTEAM)
	end

	for k, v in pairs(hRadiant or {}) do
		local player = PlayerResource:GetPlayer(v)

		player:SetTeam(DOTA_TEAM_GOODGUYS)
	end

	for k, v in pairs(hDire or {}) do
		local player = PlayerResource:GetPlayer(v)

		player:SetTeam(DOTA_TEAM_BADGUYS)
	end

	GameRules:SetCustomGameSetupRemainingTime(10.0)
end

-- utils
function PrintArray(array)
    local text = ""
    for i = 0, #array do
        text = text..array[i].."|"
    end
    print(text)
end

function CopyArray(array, length)
	local newArray = {}
	for i = 0, length - 1 do
		newArray[i] = array[i]
	end
	return newArray
end


function tableRemoveAtIndexZero(table)
    local newTable = {}
    for i = 0, #table - 1 do
        newTable[i] = table[i+1]
    end

    return newTable
end

function TableSubtract(greaterTable, smallerTable)
    local set = {}
    for i = 0, #smallerTable do
        set[smallerTable[i]] = true;
    end

    local difference = {}
    for i = 0, #greaterTable do
        difference[i] = greaterTable[i]
    end

    for i = #difference, 0, -1 do
        if set[difference[i]] then
            if i == 0 then
                difference = tableRemoveAtIndexZero(difference)
            else
                table.remove(difference, i)
            end
        end
    end

    return difference
end