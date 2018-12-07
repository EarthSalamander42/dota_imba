if GoodGame == nil then
	GoodGame = class({})
end

local init = false

function GoodGame:Call(event)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then return end
	if PlayerResource:GetPlayerCountForTeam(2) == 0 or PlayerResource:GetPlayerCountForTeam(3) == 0 then return end

	if init == false then
		GG_TABLE = {}

		-- if IsInToolsMode() then PlayerResource:GetPlayerCount() = 20 end

		-- temporary
		for i = 0, 24 - 1 do
		--for i = 0, count - 1 do
			GG_TABLE[i] = {false, false, PlayerResource:GetTeam(i)}
		end

		init = true
	end

	if event.disconnect == 1 then -- disconnect
		GG_TABLE[event.ID][2] = true
	elseif event.disconnect == 2 then -- reconnect
		GG_TABLE[event.ID][2] = false
	elseif event.vote == 1 then -- call '-gg' chat command
		if GG_TABLE[event.ID][1] == false then
			Notifications:BottomToTeam(PlayerResource:GetTeam(event.ID), {text = PlayerResource:GetPlayerName(event.ID).." called GG through the -gg chat command!", duration = 4.0, style = {color = "DodgerBlue"} })
			GG_TABLE[event.ID][1] = true
		end
	end

	CustomGameEventManager:Send_ServerToAllClients("gg_called", {ID = event.ID, team = event.team, has_gg = GG_TABLE[event.ID]})

	local abandon_team = nil
	local team_counter = 0

	for i = 0, PlayerResource:GetPlayerCount() - 1 do
		local team_gg = true

		if GG_TABLE[i][3] == event.team then
			if GG_TABLE[i][1] == true or GG_TABLE[i][2] == true then
				team_counter = team_counter + 1
			elseif GG_TABLE[i][1] == false and GG_TABLE[i][2] == false then
--				print("team has not gg:", event.team)
				break
			end

--			print("Team left counter: "..team_counter)
--			print("Team left max counter: "..PlayerResource:GetPlayerCountForTeam(event.team))
			-- GG end activates when at least 80% of the team GGs
			if team_counter / PlayerResource:GetPlayerCountForTeam(event.team) >= 0.8 then
--				print("Full team has gg: "..event.team)
				abandon_team = event.team
			end
		end
	end

	if abandon_team and abandon_team ~= true then
		local text = {}
		text[2] = "#imba_team_good_gg_message"
		text[3] = "#imba_team_bad_gg_message"
		
		local winner
		
		-- The team that DIDN'T call GG is the winner...obviously
		if abandon_team == 2 then
			winner = 3
		elseif abandon_team == 3 then
			winner = 2
		end
		
		Notifications:BottomToAll({text = text[abandon_team], duration = 5.0, style = {color = "DodgerBlue"}})

		Timers:CreateTimer(5.0, function()
			GAME_WINNER_TEAM = winner
			GameRules:SetGameWinner(winner)
		end)

		abandon_team = true
	end
end
