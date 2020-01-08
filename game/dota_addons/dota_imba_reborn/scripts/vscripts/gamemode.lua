if GameMode == nil then
	_G.GameMode = class({})
end

-- clientside KV loading
require('addon_init')

require('components/api/init')
if IsInToolsMode() then -- might lag a bit and backend to get errors not working yet
	require('internal/eventtest')
end

require('libraries/adv_log') -- be careful! this library can hide lua errors in rare cases

require('libraries/animations')
require('libraries/disable_help')
require('libraries/keyvalues')
require('libraries/modifiers')
require('libraries/notifications')
require('libraries/player')
require('libraries/player_resource')
require('libraries/projectiles')
require('libraries/rgb_to_hex')
require('libraries/selection') -- For Turbo Couriers
require('libraries/timers')
require('libraries/wearables')
require('libraries/wearables_warmful_ancient')

require('internal/gamemode')
require('internal/events')

-- add components below the api
require('components/abandon')
require('components/battlepass/init')
require('components/chat_wheel/init')
require('components/courier/init')
require("components/demo/init")
require("components/frantic/init")
require("components/diretide/diretide")
require('components/gold')
require('components/hero_selection/init')
require('components/mutation/init')
require('components/respawn_timer') -- Respawn time system override
require('components/runes') -- Rune system override
require('components/settings/settings')
if GetMapName() == "imba_10v10" then
	require('components/team_selection')
end

require('events/events')
require('filters')

-- A*-Path-finding logic (RIKI NEEDS THIS FOR HIS BLINK STRIKE)
require('libraries/astar')

-- Use this function as much as possible over the regular Precache (this is Async Precache)
function GameMode:PostLoadPrecache()
	
end

function GameMode:OnFirstPlayerLoaded()
	if GetMapName() ~= Map1v1() and GetMapName() ~= MapOverthrow() and GetMapName() ~= "imba_demo" then
		_G.ROSHAN_SPAWN_LOC = Entities:FindByClassname(nil, "npc_dota_roshan_spawner"):GetAbsOrigin()
		Entities:FindByClassname(nil, "npc_dota_roshan_spawner"):RemoveSelf()

		if GetMapName() ~= Map1v1() then
			ROSHAN_ENT = CreateUnitByName("npc_dota_roshan", _G.ROSHAN_SPAWN_LOC, true, nil, nil, DOTA_TEAM_NEUTRALS)
			ROSHAN_ENT:AddNewModifier(roshan, nil, "modifier_imba_roshan_ai", {})
		end
	end
end

function GameMode:OnAllPlayersLoaded()
	-- Setup filters
	GameRules:GetGameModeEntity():SetHealingFilter( Dynamic_Wrap(GameMode, "HealingFilter"), self )
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, "OrderFilter"), self)
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, "DamageFilter"), self)
	GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(GameMode, "GoldFilter"), self)
	GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(GameMode, "ExperienceFilter"), self)
	GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(GameMode, "ModifierFilter"), self)
	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(Dynamic_Wrap(GameMode, "ItemAddedFilter"), self)
	GameRules:GetGameModeEntity():SetBountyRunePickupFilter(Dynamic_Wrap(GameMode, "BountyRuneFilter"), self)
	GameRules:GetGameModeEntity():SetThink("OnThink", self, 1)
	GameRules:GetGameModeEntity():SetPauseEnabled(not IMBA_PICK_SCREEN)
	
	GameRules:GetGameModeEntity():SetRuneSpawnFilter(Dynamic_Wrap(GameMode, "RuneSpawnFilter"), self)

	if IsInToolsMode() then
		Convars:RegisterCommand('events_test', function() GameMode:StartEventTest() end, "events test", FCVAR_CHEAT)
	end
end

-- CAREFUL, FOR REASONS THIS FUNCTION IS ALWAYS CALLED TWICE
function GameMode:InitGameMode()
	self:_InitGameMode()
end

function GameMode:SetupAncients()
	local forts = Entities:FindAllByClassname('npc_dota_fort')

	for _, ancient in pairs(forts) do
		if Is10v10Map() then
			ancient:AddAbility("imba_ancient_defense"):SetLevel(2)
		else
			ancient:AddAbility("imba_ancient_defense"):SetLevel(1)
		end

		-- ancient:AddAbility("imba_tower_regeneration"):SetLevel(4)
	end
end

-- Set up fountain regen
function GameMode:SetupFountains()

	local fountainEntities = Entities:FindAllByClassname("ent_dota_fountain")
	for _, fountainEnt in pairs(fountainEntities) do
		fountainEnt:AddNewModifier(fountainEnt, fountainEnt, "modifier_fountain_aura_lua", {})
		fountainEnt:AddAbility("imba_fountain_danger_zone"):SetLevel(1)

		-- remove vanilla fountain healing
		if fountainEnt:HasModifier("modifier_fountain_aura") then
			fountainEnt:RemoveModifierByName("modifier_fountain_aura")
			fountainEnt:AddNewModifier(fountainEnt, nil, "modifier_fountain_aura_lua", {})
		end
	end
end

function GameMode:SetupShrines()
	local good_fillers = {
		"good_filler_1",
		"good_filler_3",
		"good_filler_5",
	}

	local bad_fillers = {
		"bad_filler_1",
		"bad_filler_3",
		"bad_filler_5",
	}

	for _, ent_name in pairs(good_fillers) do
		if Entities:FindByName(nil, ent_name) then
			local filler = Entities:FindByName(nil, ent_name)
			local abs = filler:GetAbsOrigin()
			filler:RemoveSelf()
			local shrine = CreateUnitByName("npc_dota_goodguys_healers", abs, true, nil, nil, 2)
			shrine:SetAbsOrigin(abs)
		end
	end

	for _, ent_name in pairs(bad_fillers) do
		if Entities:FindByName(nil, ent_name) then
			local filler = Entities:FindByName(nil, ent_name)
			local abs = filler:GetAbsOrigin()
			filler:RemoveSelf()
			local shrine = CreateUnitByName("npc_dota_badguys_healers", abs, true, nil, nil, 3)
			shrine:SetAbsOrigin(abs)
		end
	end

	LinkLuaModifier("modifier_imba_shrine_passive_aura", "components/modifiers/modifier_imba_shrine_passive.lua", LUA_MODIFIER_MOTION_NONE)

	for _, shrine in pairs(Entities:FindAllByClassname("npc_dota_filler")) do
		shrine:AddNewModifier(shrine, shrine:FindAbilityByName("filler_ability"), "modifier_imba_shrine_passive_aura", {})
	end
end

function GameMode:SetupContributors()
	local i = 0
	local j = 0
	local team
	local distance_between = 100

	local contributor_position_radiant_x = Vector(-6300, -6450, 256)
	local contributor_position_radiant_y = Vector(-6950, -5650, 256)
	local contributor_position_dire_x = Vector(6200, 6300, 256)
	local contributor_position_dire_y = Vector(6950, 5500, 256)

--	local contributor_position_radiant_x = Vector(0, 0, 256)
--	local contributor_position_radiant_y = Vector(0, 0, 256)
--	local contributor_position_dire_x = Vector(0, 0, 256)
--	local contributor_position_dire_y = Vector(0, 0, 256)

	for key, value in pairs(LoadKeyValues("scripts/npc/units/contributors.txt")) do
		if string.find(key, "npc_imba_contributor_") or string.find(key, "npc_imba_developer_") then
			local ang = {}
			local pos

			if i % 2 == 0 then
				j = j + 1
				if j % 2 == 0 then
					ang = {0, 90, 0}
					pos = contributor_position_radiant_x + (Vector(distance_between * j, 0, 0))
				else
					ang = {0, 0, 0}
					pos = contributor_position_radiant_y + (Vector(0, distance_between * j, 0))
				end
				team = 2
			else
				if j % 2 == 0 then
					ang = {0, 270, 0}
					pos = contributor_position_dire_x + (Vector(-distance_between * j, 0, 0))
				else
					ang = {0, 180, 0}
					pos = contributor_position_dire_y + (Vector(0, -distance_between * j, 0))
				end
				team = 3
			end

			local contributor = CreateUnitByName(key, pos, true, nil, nil, team)
			contributor:SetAngles(ang[1], ang[2], ang[3])
			contributor:AddAbility("contributor_dummy_unit_state"):SetLevel(1)
			if string.find(key, "npc_imba_developer_") then
				local pfx = ParticleManager:CreateParticle("particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_hatchling_fire.vpcf", PATTACH_ABSORIGIN, contributor)
				ParticleManager:SetParticleControl(pfx, 0, contributor:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(pfx)
			end

			i = i + 1
		end
	end
end

function GameMode:SetupFrostivus()
	if Entities:FindByName(nil, "radiant_greevil") then
		local greevil = CreateUnitByName("npc_imba_greevil_radiant", Entities:FindByName(nil, "radiant_greevil"):GetAbsOrigin(), true, nil, nil, 2)
	end

	if Entities:FindByName(nil, "dire_greevil") then
		local greevil = CreateUnitByName("npc_imba_greevil_dire", Entities:FindByName(nil, "dire_greevil"):GetAbsOrigin(), true, nil, nil, 3)
	end
end
--[[ new system, double votes for donators
ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		-- If no one voted, default to IMBA 10v10 gamemode
		GameRules:SetCustomGameDifficulty(2)
		api:SetCustomGamemode(1)

		if GameMode.VoteTable == nil then return end
		local votes = GameMode.VoteTable

		for category, pidVoteTable in pairs(votes) do
			-- Tally the votes into a new table
			local voteCounts = {}
			for pid, vote in pairs(pidVoteTable) do
				if not voteCounts[vote] then voteCounts[vote] = 0 end
				print(pid, vote)
				voteCounts[vote] = voteCounts[vote] + 1
			end

			-- Find the key that has the highest value (key=vote value, value=number of votes)
			local highest_vote = 0
			local highest_key = ""
			for k, v in pairs(voteCounts) do
				print(k, v)
				if v > highest_vote then
					highest_key = k[1]
					highest_vote = k[2]
				end
			end

			-- Check for a tie by counting how many values have the highest number of votes
			local tieTable = {}
			for k, v in pairs(voteCounts) do
				print(k, v)
				if v == highest_vote then
					table.insert(tieTable, k[1])
				end
			end

			-- Resolve a tie by selecting a random value from those with the highest votes
			if table.getn(tieTable) > 1 then
				--print("TIE!")
				highest_key = tieTable[math.random(table.getn(tieTable))]
			end

			-- Act on the winning vote
			if category == "gamemode" then
				api:SetCustomGamemode(highest_key)
			end

			-- Act on the winning vote
			if category == "difficulty" then
				GameRules:SetCustomGameDifficulty(highest_key)
			end

			print(category .. ": " .. highest_key)
		end
	end
end, nil)

local donator_list = {}
donator_list[1] = true -- Lead-Dev
donator_list[2] = true -- Dev
-- donator_list[3] = true -- Administrator
donator_list[4] = true -- Ember Donator
donator_list[7] = true -- Salamander Donator
donator_list[8] = true -- Icefrog Donator
donator_list[9] = true -- Gaben Donator

function GameMode:OnSettingVote(keys)
	local pid = keys.PlayerID

	if not GameMode.VoteTable then GameMode.VoteTable = {} end
	if not GameMode.VoteTable[keys.category] then GameMode.VoteTable[keys.category] = {} end

	if pid >= 0 then
		if not GameMode.VoteTable[keys.category][pid] then GameMode.VoteTable[keys.category][pid] = {} end

		GameMode.VoteTable[keys.category][pid][1] = keys.vote

		if donator_list[api:GetDonatorStatus(pid)] == true then
			GameMode.VoteTable[keys.category][pid][2] = 2
		else
			GameMode.VoteTable[keys.category][pid][2] = 1
		end
	end

--	Say(nil, keys.category, false)
--	Say(nil, tostring(keys.vote), false)

	-- TODO: Finish votes show up
	CustomGameEventManager:Send_ServerToAllClients("send_votes", {category = keys.category, vote = keys.vote, table = GameMode.VoteTable[keys.category]})
end
--]]

ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		-- If no one voted, default to IMBA 10v10 gamemode
		GameRules:SetCustomGameDifficulty(2)
		api:SetCustomGamemode(1)

		if GameMode.VoteTable == nil then return end
		local votes = GameMode.VoteTable

		for category, pidVoteTable in pairs(votes) do
			-- Tally the votes into a new table
			local voteCounts = {}
			for pid, vote in pairs(pidVoteTable) do
				if not voteCounts[vote] then voteCounts[vote] = 0 end
				voteCounts[vote] = voteCounts[vote] + 1
			end

			-- Find the key that has the highest value (key=vote value, value=number of votes)
			local highest_vote = 0
			local highest_key = ""
			for k, v in pairs(voteCounts) do
				if v > highest_vote then
					highest_key = k
					highest_vote = v
				end
			end

			-- if vote count is lower than player count / 4, default to standard
			if highest_vote < 5 then
				highest_key = 1
			else
				-- Check for a tie by counting how many values have the highest number of votes
				local tieTable = {}
				for k, v in pairs(voteCounts) do
					if v == highest_vote then
						table.insert(tieTable, k)
					end
				end

				-- Resolve a tie by selecting a random value from those with the highest votes
				if table.getn(tieTable) > 1 then
					--print("TIE!")
					highest_key = tieTable[math.random(table.getn(tieTable))]
				end
			end

			-- Act on the winning vote
			if category == "gamemode" then
				api:SetCustomGamemode(highest_key)
			end

			-- Act on the winning vote
--			if category == "difficulty" then
--				GameRules:SetCustomGameDifficulty(highest_key)
--			end

			print(category .. ": " .. highest_key)
		end
	end
end, nil)

function GameMode:OnSettingVote(keys)
	local pid = keys.PlayerID

	if not GameMode.VoteTable then
		GameMode.VoteTable = {}
	end

	if not GameMode.VoteTable[keys.category] then
		GameMode.VoteTable[keys.category] = {}
	end

	if pid >= 0 then
		GameMode.VoteTable[keys.category][pid] = keys.vote
	end

--	Say(nil, keys.category, false)
--	Say(nil, tostring(keys.vote), false)

	-- TODO: Finish votes show up
	CustomGameEventManager:Send_ServerToAllClients("send_votes", {category = keys.category, vote = keys.vote, table = GameMode.VoteTable[keys.category]})
end

function GameMode:SetSameHeroSelection(bEnabled)
	GameRules:SetSameHeroSelectionEnabled(bEnabled)
	CustomNetTables:SetTableValue("game_options", "same_hero_pick", {value = bEnabled})
end
