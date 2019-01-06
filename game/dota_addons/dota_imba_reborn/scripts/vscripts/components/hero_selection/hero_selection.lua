lockedHeroes = {} -- hotfix pick screen, format later
loadedHeroes = {}
local cmtimer = nil

-- storage for this game picks
local selectedtable = {}
-- force stop handle for timer, when all picked before time end
local forcestop = false
local LoadFinishEvent = Event()
local loadingHeroes = 1
local finishedLoading = false

LoadFinishEvent.listen(function()
	finishedLoading = true
end)

ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		HeroSelection:Init() -- init picking screen kv (this function is a bit heavy to run)
--		api.imba.event(api.events.entered_hero_selection)
		Timers:CreateTimer(0.5, function()
			HeroSelection:StartSelection()
		end)
	end
end, nil)

-- set "empty" hero for every player and start picking phase
function HeroSelection:StartSelection()
	ShowHUD(false)

	PlayerResource:GetAllTeamPlayerIDs():each(function(playerID)
		HeroSelection:UpdateTable(playerID, "empty")
	end)

	CustomGameEventManager:RegisterListener('cm_become_captain', Dynamic_Wrap(HeroSelection, 'CMBecomeCaptain'))
	CustomGameEventManager:RegisterListener('cm_hero_selected', Dynamic_Wrap(HeroSelection, 'CMManager'))
	CustomGameEventManager:RegisterListener('hero_selected', Dynamic_Wrap(HeroSelection, 'HeroSelected'))
	CustomGameEventManager:RegisterListener('preview_hero', Dynamic_Wrap(HeroSelection, 'HeroPreview'))
	CustomGameEventManager:RegisterListener("pick_abilities_requested", Dynamic_Wrap(HeroSelection, 'PickAbilitiesRequested'))
	
	if IsTournamentMap() then
		EmitAnnouncerSound("announcer_announcer_type_capt_mode")
		HeroSelection:CMManager(nil)
	else
		EmitAnnouncerSound("announcer_announcer_type_all_pick")
		HeroSelection:APTimer(AP_GAME_TIME, "ALL PICK")
	end
end

-- start heropick CM timer
function HeroSelection:CMManager(event)
	if forcestop == false then
		forcestop = true

		if event == nil then
			CustomNetTables:SetTableValue( 'hero_selection', 'CMdata', cmpickorder)
			HeroSelection:CMTimer(CAPTAINS_MODE_CAPTAIN_TIME, "CHOOSE CAPTAIN")

		elseif cmpickorder["currentstage"] == 0 then
			Timers:RemoveTimer(cmtimer)
			if cmpickorder["captainradiant"] == "empty" then
				--random captain
				local skipnext = false
				PlayerResource:GetAllTeamPlayerIDs():each(function(PlayerID)
					if skipnext == false and PlayerResource:GetTeam(PlayerID) == DOTA_TEAM_GOODGUYS then
						cmpickorder["captainradiant"] = PlayerID
						skipnext = true
					end
				end)
			end
			if cmpickorder["captaindire"] == "empty" then
				--random captain
				local skipnext = false
				PlayerResource:GetAllTeamPlayerIDs():each(function(PlayerID)
					if skipnext == false and PlayerResource:GetTeam(PlayerID) == DOTA_TEAM_BADGUYS then
						if PlayerResource:GetConnectionState(PlayerID) == 2 then
							cmpickorder["captaindire"] = PlayerID
							skipnext = true
						end
					end
				end)
			end
			cmpickorder["currentstage"] = cmpickorder["currentstage"] + 1
			CustomNetTables:SetTableValue( 'hero_selection', 'CMdata', cmpickorder)
			HeroSelection:CMTimer(CAPTAINS_MODE_PICK_BAN_TIME, "CAPTAINS MODE")
		elseif cmpickorder["currentstage"] <= cmpickorder["totalstages"] then
			--random if not selected
--			print(event)
			if event.hero == "random" then
				event.hero = HeroSelection:RandomHero()
			elseif HeroSelection:IsHeroDisabled(event.hero) then
				forcestop = false
				return
			end

			-- cmpickorder["order"][cmpickorder["currentstage"]].side
			if event.PlayerID then
				if PlayerResource:GetTeam(event.PlayerID) ~= cmpickorder["order"][cmpickorder["currentstage"]].side then
					forcestop = false
					return
				end
			end

--			print('Got a CM pick ' .. cmpickorder["order"][cmpickorder["currentstage"]].side)

			Timers:RemoveTimer(cmtimer)

			if cmpickorder["order"][cmpickorder["currentstage"]].type == "Pick" then
				table.insert(cmpickorder[cmpickorder["order"][cmpickorder["currentstage"]].side.."picks"], 1, event.hero)
			end
			cmpickorder["order"][cmpickorder["currentstage"]].hero = event.hero
			CustomNetTables:SetTableValue( 'hero_selection', 'CMdata', cmpickorder)
			cmpickorder["currentstage"] = cmpickorder["currentstage"] + 1

--			print('--')
--			print(event)

			if cmpickorder["currentstage"] <= cmpickorder["totalstages"] then
				HeroSelection:CMTimer(CAPTAINS_MODE_PICK_BAN_TIME, "CAPTAINS MODE")
			else
				forcestop = false
				HeroSelection:APTimer(CAPTAINS_MODE_HERO_PICK_TIME, "CHOOSE HERO")
			end
		end

		forcestop = false
	end
end

-- manage cm timer
function HeroSelection:CMTimer (time, message, isReserveTime)
	CustomNetTables:SetTableValue( 'hero_selection', 'time', {time = time, mode = message, isReserveTime = isReserveTime})

	if cmpickorder["currentstage"] > 0 and forcestop == false then
		if cmpickorder["order"][cmpickorder["currentstage"]].side == DOTA_TEAM_GOODGUYS and cmpickorder["captainradiant"] == "empty" then
			HeroSelection:CMManager({hero = "random"})
			return
		end

		if cmpickorder["order"][cmpickorder["currentstage"]].side == DOTA_TEAM_BADGUYS and cmpickorder["captaindire"] == "empty" then
			HeroSelection:CMManager({hero = "random"})
			return
		end
	end

	if isReserveTime then
		if cmpickorder["order"][cmpickorder["currentstage"]].side == DOTA_TEAM_BADGUYS then
			cmpickorder["reservedire"] = time
		elseif cmpickorder["order"][cmpickorder["currentstage"]].side == DOTA_TEAM_GOODGUYS then
			cmpickorder["reserveradiant"] = time
		end
		CustomNetTables:SetTableValue( 'hero_selection', 'CMdata', cmpickorder)
	end

	if time <= 0 then
		if cmpickorder["currentstage"] > 0 then
			if cmpickorder["order"][cmpickorder["currentstage"]].side == DOTA_TEAM_BADGUYS and cmpickorder["reservedire"] > 0 then
				-- start using reserve time
				time = cmpickorder["reservedire"]
				isReserveTime = true
			elseif cmpickorder["order"][cmpickorder["currentstage"]].side == DOTA_TEAM_GOODGUYS and cmpickorder["reserveradiant"] > 0 then
				-- start using reserve time
				time = cmpickorder["reserveradiant"]
				isReserveTime = true
			end
		end
		if time <= 0 then
			HeroSelection:CMManager({hero = "random"})
			return
		end
	end

	cmtimer = Timers:CreateTimer({
		endTime = 1,
		callback = function()
			HeroSelection:CMTimer(time -1, message, isReserveTime)
		end
	})
end

-- become a captain, go to next stage, if both captains are selected
function HeroSelection:CMBecomeCaptain (event)
--	print("Selecting captain")
--	print(event)
	if PlayerResource:GetTeam(event.PlayerID) == 2 then
		cmpickorder["captainradiant"] = event.PlayerID
		CustomNetTables:SetTableValue( 'hero_selection', 'CMdata', cmpickorder)
		if not cmpickorder["captaindire"] == "empty" then
			HeroSelection:CMManager({dummy = "dummy"})
		end
	elseif PlayerResource:GetTeam(event.PlayerID) == 3 then
		cmpickorder["captaindire"] = event.PlayerID
		CustomNetTables:SetTableValue( 'hero_selection', 'CMdata', cmpickorder)
		if not cmpickorder["captainradiant"] == "empty" then
			HeroSelection:CMManager({dummy = "dummy"})
		end
	end
end

-- start heropick AP timer
function HeroSelection:APTimer(time, message)
	if forcestop == true or time < 0 then
		for key, value in pairs(selectedtable) do
			if value.selectedhero == "empty" then
				-- if someone hasnt selected until time end, random for him
				if IsTournamentMap() then
					HeroSelection:UpdateTable(key, cmpickorder[value.team.."picks"][1])
				else
					HeroSelection:UpdateTable(key, HeroSelection:RandomHero())
				end
			end

			HeroSelection:SelectHero(key, selectedtable[key].selectedhero)
			CustomGameEventManager:Send_ServerToAllClients("hide_pause", {show = false})			
			PauseGame(true)

			Timers:CreateTimer({
				useGameTime = false,
				endTime = 20, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
				callback = function()
					if GameRules:IsGamePaused() then
						print("Force unpause, loading is too long!")
						PauseGame(false)
					end
				end
			})
		end

		PlayerResource:GetAllTeamPlayerIDs():each(function (playerId)
			if not lockedHeroes[playerId] then
				if IsTournamentMap() then
					HeroSelection:UpdateTable(playerId, cmpickorder[PlayerResource:GetTeam(playerId).."picks"][1])
				else
					HeroSelection:UpdateTable(playerId, HeroSelection:RandomHero())
				end
			end
		end)

		loadingHeroes = loadingHeroes - 1
		-- just incase all the heroes load syncronously
		if loadingHeroes == 0 then
			LoadFinishEvent.broadcast()
		end
		HeroSelection:StrategyTimer(3)
	else
		CustomNetTables:SetTableValue( 'hero_selection', 'time', {time = time, mode = message})
		Timers:CreateTimer({
			useGameTime = not HERO_SELECTION_WHILE_PAUSED,
			endTime = 1,
			callback = function()
				HeroSelection:APTimer(time - 1, message)
			end
		})
	end
end

function HeroSelection:SelectHero(playerId, hero)
	lockedHeroes[playerId] = hero
	loadingHeroes = loadingHeroes + 1
	-- LoadFinishEvent
	PrecacheUnitByNameAsync(hero, function()
		loadedHeroes[hero] = true
		loadingHeroes = loadingHeroes - 1
		if loadingHeroes == 0 then
			LoadFinishEvent.broadcast()
			PauseGame(false)
			ShowHUD(true)

			GameRules:GetGameModeEntity():SetPauseEnabled(true)
			CustomGameEventManager:Send_ServerToAllClients("hide_pause", {show = true})
			GameRules:GetGameModeEntity():SetCameraDistanceOverride(1134) -- default: 1134

			if IsRankedMap() then
				Timers:CreateTimer(3.0, function()
					for i = 1, 25 do
						local top_imr = nil
						if GetMapName() == MapRanked5v5() then
							top_imr = CustomNetTables:GetTableValue("top_imr5v5", tostring(i))
						elseif GetMapName() == MapRanked10v10() then
							top_imr = CustomNetTables:GetTableValue("top_imr10v10", tostring(i))
						end

						if top_imr then
							if tostring(PlayerResource:GetSteamID(playerId)) == top_imr.SteamID64 then
								if GetMapName() == MapRanked5v5() then
									Say(nil, PlayerResource:GetPlayerName(playerId).." is top "..i.." IMR! ("..math.floor(top_imr.IMR_5v5)..")", false)
								elseif GetMapName() == MapRanked10v10() then
									Say(nil, PlayerResource:GetPlayerName(playerId).." is top "..i.." IMR! ("..math.floor(top_imr.IMR_10v10)..")", false)
								end
							end
						end
					end
				end)
			elseif IsMutationMap() then
--				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerId), "send_mutations", IMBA_MUTATION) -- WHY THE FUCK IT DOESN'T WORK FOR EVERY PLAYERS
				CustomGameEventManager:Send_ServerToAllClients("send_mutations", IMBA_MUTATION)
				CustomGameEventManager:Send_ServerToAllClients("update_mutations", {})
			end
		end

		local player = PlayerResource:GetPlayer(playerId)

		if player == nil then -- disconnected! don't give em a hero yet...
			return
		end

		self:GiveStartingHero(playerId, hero)
--		print('Giving player ' .. playerId .. ' ' .. hero)
	end)
end

function HeroSelection:GiveStartingHero(playerId, heroName, dev)
	if not dev then
		if self.spawnedPlayers[playerId] then
			return
		end
	end

	--	local startingGold = 0
	--	if self.hasGivenStartingGold then
	--		startingGold = tonumber(CustomNetTables:GetTableValue("game_options", "initial_gold")["1"]) or 1200
	--	end

	local wisp = PlayerResource:GetSelectedHeroEntity(playerId)
	local hero = PlayerResource:ReplaceHeroWith(playerId, heroName, 0, 0)

	if IMBA_MUTATION and IMBA_MUTATION["negative"] == "all_random_deathmatch" then
		Mutation:ARDMRemoveHeroFromTable(hero:GetUnitName())
	end

	if hero and hero:GetUnitName() ~= FORCE_PICKED_HERO then
		table.insert(self.spawnedHeroes, hero)
		self.spawnedPlayers[playerId] = true
	elseif hero and hero:GetUnitName() == FORCE_PICKED_HERO then
		hero:AddNewModifier(hero, nil, "modifier_dummy_dummy", {})
		self.attemptedSpawnPlayers[playerId] = heroName
		Timers:CreateTimer(5, function ()
			self:GiveStartingHero(playerId, heroName)
		end)
	else
		self.attemptedSpawnPlayers[playerId] = heroName
		Timers:CreateTimer(2, function ()
			self:GiveStartingHero(playerId, heroName)
		end)
	end

	-- temporary fix
	if not hero:GetUnitName() == "npc_dota_hero_monkey_king" then
		HeroSelection:Attachments(hero)
	end

	-- Initializes player data if this is not a bot
	if PlayerResource:GetConnectionState(playerId) == 2 then
		PlayerResource:InitPlayerData(playerId)
	end

	-- Make heroes briefly visible on spawn (to prevent bad fog interactions)
--	Timers:CreateTimer(0.5, function()
--		hero:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, 0.5)
--		hero:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, 0.5)
--	end)

	Timers:CreateTimer(1.0, function()
		if wisp then
			UTIL_Remove(wisp)
		end
	end)

	Timers:CreateTimer(5.0, function()
		if IMBA_DIRETIDE == true then
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerId), "diretide_phase", {Phase = Diretide.DIRETIDE_PHASE})
		end
	end)
end

function HeroSelection:IsHeroDisabled(hero)
--	if hero then
--		if api.imba.hero_is_disabled(hero) then
--			return true
--		end
--	end

	if IsTournamentMap() then
		for _,data in ipairs(cmpickorder["order"]) do
			if hero == data.hero then
				return true
			end
		end
	else
		for _,data in pairs(selectedtable) do
			if hero == data.selectedhero then
				return true
			end
		end
	end

	return false
end

function HeroSelection:IsHeroChosen(hero)
	for _,data in pairs(selectedtable) do
		if hero == data.selectedhero then
			return true
		end
	end

	return false
end

function HeroSelection:RandomHero()
	while true do
		local choice = HeroSelection:UnsafeRandomHero()
		if not self:IsHeroDisabled(choice) then
			return choice
		end
	end
end

-- start strategy timer
function HeroSelection:EndStrategyTime()
	GameRules:SetTimeOfDay(0.25)

--	if self.isCM then
--		PauseGame(true)
--	end

	--	OnGameInProgressEvent() -- ENABLE BEFORE 7.05

	--	self.hasGivenStartingGold = true
	--	for _,hero in ipairs(self.spawnedHeroes) do
	--		PlayerResource:ModifyGold( hero:GetPlayerID(), tonumber(CustomNetTables:GetTableValue("game_options", "initial_gold")["1"]) or 1200, true, 0 )
	--	end

	CustomNetTables:SetTableValue( 'hero_selection', 'time', {time = -1, mode = ""})
end

function HeroSelection:StrategyTimer(time)
	if time < 0 then
		if finishedLoading then
--			print("PICK SCREEN IS OVER!")
			PICKING_SCREEN_OVER = true
			HeroSelection:EndStrategyTime()
		else
			LoadFinishEvent.listen(function()
				HeroSelection:EndStrategyTime()
			end)
		end
	else
		CustomNetTables:SetTableValue( 'hero_selection', 'time', {time = time, mode = "STRATEGY"})
		Timers:CreateTimer({
--			useGameTime = not HERO_SELECTION_WHILE_PAUSED,
			endTime = 1,
			callback = function()
				HeroSelection:StrategyTimer(time -1)
			end
		})
	end
end

-- receive choise from players about their selection
function HeroSelection:HeroSelected(event)
	HeroSelection:UpdateTable(event.PlayerID, event.hero)
	PrecacheUnitByNameAsync(event.hero, function(...) end)
end

function HeroSelection:HeroPreview(event)
	local previewTable = CustomNetTables:GetTableValue('hero_selection', 'preview_table') or {}
	local teamID = tostring(PlayerResource:GetTeam(event.PlayerID))
	if not previewTable[teamID] then
		previewTable[teamID] = {}
	end
	previewTable[teamID][HeroSelection:GetSteamAccountID(event.PlayerID)] = event.hero
	CustomNetTables:SetTableValue('hero_selection', 'preview_table', previewTable)
end

-- write new values to table
function HeroSelection:UpdateTable(playerID, hero)
-- function HeroSelection:UpdateTable(playerID, hero, force)
	local teamID = PlayerResource:GetTeam(playerID)
	if hero == "random" then
		hero = self:RandomHero()
	elseif hero == "imbarandom" then
		hero = self:RandomImbaHero()
	end

	if lockedHeroes[playerID] then
		hero = lockedHeroes[playerID]
	end

	if selectedtable[playerID] and selectedtable[playerID].selectedhero == hero then
--		print('Player re-selected their hero again ' .. hero)
		return
	end

	if self:IsHeroChosen(hero) then
--		print('That hero is already disabled ' .. hero)
		hero = "empty"
	end

	if IsTournamentMap() then
		if hero ~= "empty" then
			local cmFound = false
			for k,v in pairs(cmpickorder[teamID.."picks"])do
				if v == hero then
					table.remove(cmpickorder[teamID.."picks"], k)
					cmFound = true
				end
			end
			if not cmFound then
--				print('Couldnt find that hero in the CM pool ' .. tostring(hero))
				hero = "empty"
			end
		end
		-- if they've already selected a hero then unselect it
		if selectedtable[playerID] and selectedtable[playerID].selectedhero ~= "empty" then
			table.insert(cmpickorder[teamID.."picks"], selectedtable[playerID].selectedhero)
		end
	end

	selectedtable[playerID] = {id = playerID, selectedhero = hero, team = teamID, steamid = HeroSelection:GetSteamAccountID(playerID)}

	-- PrintTable(selectedtable)
	-- if everyone has picked, stop
	local isanyempty = false
	for key, value in pairs(selectedtable) do --pseudocode
		if GetMapName() ~= MapTournament() and value.steamid == "0" then
			value.selectedhero = HeroSelection:RandomHero()
		end

		if value.selectedhero == "empty" then
			isanyempty = true
		end
	end

	CustomNetTables:SetTableValue('hero_selection', 'APdata', selectedtable)

	if isanyempty == false then
		forcestop = true
	end
end

local playerToSteamMap = {}
function HeroSelection:GetSteamAccountID(playerID)
	local steamid = PlayerResource:GetSteamAccountID(playerID)
	if steamid == 0 then
		if playerToSteamMap[playerID] then
			return playerToSteamMap[playerID]
		else
			steamid = #playerToSteamMap + 1
			playerToSteamMap[playerID] = tostring(steamid)
		end
	end
	return tostring(steamid)
end

-- Sends this hero's nonhidden abilities to the client
function HeroSelection:PickAbilitiesRequested(event)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(event.PlayerID), "pick_abilities", { heroAbilities = HeroSelection:GetPickScreenAbilities(event.HeroName) })
end

-- Returns an array with the hero's non-hidden abilities
function HeroSelection:GetPickScreenAbilities(hero_name)
	local hero_abilities = {}
	local custom_hero = false
	local ability

	for key, value in pairs(customlist) do
		if key == hero_name then
			custom_hero = true
			break
		end
	end

	-- send the hero name at index 0
	hero_abilities[0] = hero_name

	for i = 1, 24 do
		if custom_hero == true then
			ability = GetKeyValue(hero_name, "Ability"..i)
		else
			ability = GetKeyValueByHeroName(hero_name, "Ability"..i)
		end

		if ability then
			if i ~= 9 then
				hero_abilities[i] = GetKeyValueByHeroName(hero_name, "Ability"..i)
			end

			if GetAbilityKV(ability, "HasScepterUpgrade") then
				hero_abilities[9] = GetKeyValueByHeroName(hero_name, "Ability"..i)
			end
		end
	end

	return hero_abilities
end
