if HeroSelection == nil then
	require('libraries/hero_selection/event')
	require('libraries/hero_selection/fun')()
	require('libraries/hero_selection/functional')
	require('components/hero_selection/cmpickorder')

	HeroSelection = class({})
end

-- available heroes
local herolist = {}
local imbalist = {}
local newlist = {}
local customlist = {}
local hotdisabledlist = {}
lockedHeroes = {} -- hotfix pick screen, format later
loadedHeroes = {}
local totalheroes = 0

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

-- list all available heroes and get their primary attrs, and send it to client
function HeroSelection:Init()
	self.spawnedHeroes = {}
	self.spawnedPlayers = {}
	self.attemptedSpawnPlayers = {}

	local herolistFile = "scripts/npc/herolist/"..GetMapName()..".txt"

	for key,value in pairs(LoadKeyValues(herolistFile)) do
		if KeyValues.HeroKV[key] == nil then -- Cookies: If the hero is not in custom file, load vanilla KV's
--			log.debug(key .. " is not in custom file!")
			local data = LoadKeyValues("scripts/npc/npc_heroes.txt")
			if data and data[key] then
				KeyValues.HeroKV[key] = data[key]
			end
		end

		herolist[key] = KeyValues.HeroKV[key].AttributePrimary

		if KeyValues.HeroKV[key].IsImba == 1 then
			imbalist[key] = KeyValues.HeroKV[key].IsImba
		elseif KeyValues.HeroKV[key].IsNew == 1 then
			newlist[key] = KeyValues.HeroKV[key].IsNew
		elseif KeyValues.HeroKV[key].IsCustom == 1 then
			customlist[key] = KeyValues.HeroKV[key].IsCustom
		end

		if api.imba.hero_is_disabled(key) then
			hotdisabledlist[key] = 1
		end

		if value == 0 then
			hotdisabledlist[key] = 1
		else
			totalheroes = totalheroes + 1
			assert(key ~= FORCE_PICKED_HERO, "FORCE_PICKED_HERO cannot be a pickable hero")
		end
	end

--	if IsMutationMap() then
--		if IMBA_MUTATION["positive"] == "killstreak_power" then
--			hotdisabledlist["npc_dota_hero_zuus"] = 1
--		end

--		if IMBA_MUTATION["terrain"] == "speed_freaks" then
--			hotdisabledlist["npc_dota_hero_bloodseeker"] = 1
--			hotdisabledlist["npc_dota_hero_spirit_breaker"] = 1
--		end
--	end

	CustomNetTables:SetTableValue("hero_selection", "herolist", {
		gametype = GetMapName(),
		herolist = herolist,
		imbalist = imbalist,
		newlist = newlist,
		customlist = customlist,
		hotdisabledlist = hotdisabledlist,
		mutation = IMBA_MUTATION,
	})

	-- lock down the "pick" hero so that they can't do anything
	--	GameEvents:OnHeroInGame(function (npc)
	--		local playerId = npc:GetPlayerID()
	--		print("An NPC spawned " .. npc:GetUnitName())
	--		if npc:GetUnitName() == FORCE_PICKED_HERO then
	--			npc:AddNewModifier(nil, nil, "modifier_out_of_duel", nil)
	--			npc:AddNoDraw()
	--
	--			if self.attemptedSpawnPlayers[playerId] then
	--				self:GiveStartingHero(playerId, self.attemptedSpawnPlayers[playerId])
	--			end
	--		end
	--	end)
end

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
--			log.debug(event)
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

--			log.info('Got a CM pick ' .. cmpickorder["order"][cmpickorder["currentstage"]].side)

			Timers:RemoveTimer(cmtimer)

			if cmpickorder["order"][cmpickorder["currentstage"]].type == "Pick" then
				table.insert(cmpickorder[cmpickorder["order"][cmpickorder["currentstage"]].side.."picks"], 1, event.hero)
			end
			cmpickorder["order"][cmpickorder["currentstage"]].hero = event.hero
			CustomNetTables:SetTableValue( 'hero_selection', 'CMdata', cmpickorder)
			cmpickorder["currentstage"] = cmpickorder["currentstage"] + 1

--			log.info('--')
--			log.debug(event)

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
--	log.debug("Selecting captain")
--	log.debug(event)
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

			if BOTS_ENABLED == true then
				SendToServerConsole('sm_gmode 1')
				SendToServerConsole('dota_bot_populate')
			end

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
--		log.debug('Giving player ' .. playerId .. ' ' .. hero)
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

	HeroSelection:Attachments(hero)

	-- Initializes player data if this is a bot
	if PlayerResource:GetConnectionState(playerId) == 1 then
		PlayerResource:InitPlayerData(playerId)
	end

	-- Make heroes briefly visible on spawn (to prevent bad fog interactions)
	Timers:CreateTimer(0.5, function()
		hero:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, 0.5)
		hero:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, 0.5)
	end)

	-- Set up initial level 1 experience bounty
	hero:SetCustomDeathXP(HERO_XP_BOUNTY_PER_LEVEL[1])

	-- Set killstreak hero value
	hero.killstreak = 0

	-- Set up initial level
	local starting_level = tonumber(CustomNetTables:GetTableValue("game_options", "initial_level")["1"])
	if starting_level == nil then starting_level = 1 end
	if starting_level and starting_level > 1 then
		hero:AddExperience(XP_PER_LEVEL_TABLE[starting_level], DOTA_ModifyXP_CreepKill, false, true)
	end

	-- Set up initial gold
	-- local has_randomed = PlayerResource:HasRandomed(playerId)
	--	local has_randomed = HeroSelection.playerPickState[playerId].random_state
	local initial_gold = tonumber(CustomNetTables:GetTableValue("game_options", "initial_gold")["1"]) or 1200

	if has_randomed or IMBA_PICK_MODE_ALL_RANDOM or IMBA_PICK_MODE_ALL_RANDOM_SAME_HERO then
		PlayerResource:SetGold(playerId, initial_gold + 200, false)
	else
		PlayerResource:SetGold(playerId, initial_gold, false)
	end

	-- add modifier for custom mechanics handling
	hero:AddNewModifier(hero, nil, "modifier_custom_mechanics", {})

	-- set player colors (literally the same code i use in XHS, but it doesn't work in imba? in chat)
	PlayerResource:SetCustomPlayerColor(playerId, PLAYER_COLORS[playerId][1], PLAYER_COLORS[playerId][2], PLAYER_COLORS[playerId][3])

	-- Initialize innate hero abilities
	hero:InitializeInnateAbilities()

	-- Initialize Invoker's innate invoke buff
	-- TODO: This should be removed when another solution is found, like giving Invoker a hidden passive ability to apply the modifier
	if hero:HasAbility("invoker_invoke") then
		LinkLuaModifier("modifier_imba_invoke_buff", "components/modifiers/modifier_imba_invoke_buff.lua", LUA_MODIFIER_MOTION_NONE)
		hero:AddNewModifier(hero, hero:FindAbilityByName("invoker_invoke"), "modifier_imba_invoke_buff", {})
	end

	Imbattlepass:AddItemEffects(hero)

	if USE_TEAM_COURIER == false then
		TurboCourier:Init(hero)
	end

	Timers:CreateTimer(1.0, function()
		if wisp then
			UTIL_Remove(wisp)
		end
	end)
end

function HeroSelection:IsHeroDisabled(hero)
	if hero then
		if api.imba.hero_is_disabled(hero) then
			return true
		end
	end

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

function HeroSelection:RandomImbaHero()
	while true do
		local choice = HeroSelection:UnsafeRandomHero()

		for key, value in pairs(imbalist) do
--			log.debug(key, choice, self:IsHeroDisabled(choice))
			if key == choice and not self:IsHeroDisabled(choice) then
				return choice
			end
		end
	end
end

function HeroSelection:UnsafeRandomHero()
	local curstate = 0
	local rndhero = RandomInt(0, totalheroes)

	for name, _ in pairs(herolist) do
--		print(curstate, rndhero, name)
		if curstate == rndhero then
			for k, v in pairs(hotdisabledlist) do
				if k == name then
--					log.info("Hero disabled! Try again!")
					return HeroSelection:UnsafeRandomHero()
				end
			end

			return name
		end

		curstate = curstate + 1
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
--			log.debug("PICK SCREEN IS OVER!")
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
--		log.info('Player re-selected their hero again ' .. hero)
		return
	end

	if self:IsHeroChosen(hero) then
--		log.info('That hero is already disabled ' .. hero)
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
--				log.info('Couldnt find that hero in the CM pool ' .. tostring(hero))
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

local load_attachment_modifier = false
function HeroSelection:Attachments(hero)
	if load_attachment_modifier == false then
		load_attachment_modifier = true
		LinkLuaModifier( "modifier_animation_translate_permanent_string", "libraries/modifiers/modifier_animation_translate_permanent_string.lua", LUA_MODIFIER_MOTION_NONE )
	end

	hero_name = string.gsub(hero:GetUnitName(), "npc_dota_hero_", "")

	if hero_name == "sohei" then
		-- hero.hand = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/sohei/so_weapon.vmdl"})
		hero.hand = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/sohei/weapon/immortal/thunderlord.vmdl"})

		-- lock to bone
		hero.hand:FollowEntity(hero, true)

		-- hero:AddNewModifier(hero, nil, 'modifier_animation_translate_permanent_string', {translate = 'walk'})
		-- hero:AddNewModifier(hero, nil, 'modifier_animation_translate_permanent_string', {translate = 'odachi'})
		-- hero:AddNewModifier(hero, nil, 'modifier_animation_translate_permanent_string', {translate = 'aggressive'})
	end
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
