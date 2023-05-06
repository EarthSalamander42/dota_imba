if GameMode == nil then
	_G.GameMode = class({})
end

-- clientside KV loading
require('addon_init')

require('components/api/init')
if IsInToolsMode() then       -- might lag a bit and backend to get errors not working yet
	--	require('internal/eventtest')
	require('libraries/adv_log') -- be careful! this library can hide lua errors in rare cases
end

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
-- require('libraries/wearables')
-- require('libraries/wearables_warmful_ancient')

require('internal/gamemode')
require('internal/events')

-- add components below the api
VANILLA_ABILITIES_BASECLASS = require('components/abilities/vanilla_baseclass')
-- require('components/abandon')
require('components/courier/init')
if GetMapName() == "imba_demo" or IsInToolsMode() then
	require("components/demo/init")
end
require('components/gold')
require('components/hero_selection/init')
require('components/mutation/init')
require('components/neutral_creeps/init')
require('components/respawn_timer') -- Respawn time system override
require('components/runes')         -- Rune system override
require('components/settings/settings')
-- require('components/new_team_selection')
require('components/tooltips/init')

require('events/events')
require('filters')

-- A*-Path-finding logic (RIKI NEEDS THIS FOR HIS BLINK STRIKE)
require('libraries/astar')

-- Use this function as much as possible over the regular Precache (this is Async Precache)
function GameMode:PostLoadPrecache()

end

function GameMode:OnFirstPlayerLoaded()
	local roshan_spawner = Entities:FindByClassname(nil, "npc_dota_roshan_spawner")

	if roshan_spawner then
		_G.ROSHAN_SPAWN_LOC = roshan_spawner:GetAbsOrigin()
		roshan_spawner:RemoveSelf()

		if GetMapName() ~= Map1v1() then
			ROSHAN_ENT = CreateUnitByName("npc_dota_roshan", _G.ROSHAN_SPAWN_LOC, true, nil, nil, DOTA_TEAM_NEUTRALS)
			ROSHAN_ENT:AddNewModifier(ROSHAN_ENT, nil, "modifier_imba_roshan_ai", {})
		end
	end
end

function GameMode:OnAllPlayersLoaded()
	-- Setup filters
	GameRules:GetGameModeEntity():SetHealingFilter(Dynamic_Wrap(GameMode, "HealingFilter"), self)
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, "OrderFilter"), self)
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, "DamageFilter"), self)
	GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(GameMode, "GoldFilter"), self)
	GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(GameMode, "ExperienceFilter"), self)
	GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(GameMode, "ModifierFilter"), self)
	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(Dynamic_Wrap(GameMode, "ItemAddedFilter"), self)
	GameRules:GetGameModeEntity():SetBountyRunePickupFilter(Dynamic_Wrap(GameMode, "BountyRuneFilter"), self)
	GameRules:GetGameModeEntity():SetThink("OnThink", self, 1)
	-- GameRules:GetGameModeEntity():SetPauseEnabled(not IMBA_PICK_SCREEN)

	GameRules:GetGameModeEntity():SetRuneSpawnFilter(Dynamic_Wrap(GameMode, "RuneSpawnFilter"), self)

	GameRules:GetGameModeEntity():SetPauseEnabled(IsInToolsMode())

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

		local danger_zone_pfx = ParticleManager:CreateParticle("particles/ambient/fountain_danger_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(danger_zone_pfx, 0, fountainEnt:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(danger_zone_pfx)

		local fountain_aura_pfx = ParticleManager:CreateParticle("particles/range_indicator.vpcf", PATTACH_ABSORIGIN_FOLLOW, fountainEnt)
		ParticleManager:SetParticleControl(fountain_aura_pfx, 1, Vector(255, 255, 0))
		ParticleManager:SetParticleControl(fountain_aura_pfx, 3, Vector(1200, 0, 0))
		ParticleManager:ReleaseParticleIndex(fountain_aura_pfx)
	end
end

function GameMode:SetupShrines()
	--	LinkLuaModifier("modifier_imba_shrine_passive_aura", "components/modifiers/modifier_imba_shrine_passive.lua", LUA_MODIFIER_MOTION_NONE)

	-- replace 3 base fillers with shrines
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
			local abs = GetGroundPosition(filler:GetAbsOrigin(), nil)
			filler:RemoveSelf()
			local shrine = CreateUnitByName("npc_dota_goodguys_healers", abs, true, nil, nil, 2)
			shrine:SetAbsOrigin(abs)
			--			shrine:AddNewModifier(shrine, shrine:FindAbilityByName("filler_ability"), "modifier_imba_shrine_passive_aura", {})
		end
	end

	for _, ent_name in pairs(bad_fillers) do
		if Entities:FindByName(nil, ent_name) then
			local filler = Entities:FindByName(nil, ent_name)
			local abs = GetGroundPosition(filler:GetAbsOrigin(), nil)
			filler:RemoveSelf()
			local shrine = CreateUnitByName("npc_dota_badguys_healers", abs, true, nil, nil, 3)
			shrine:SetAbsOrigin(abs)
			--			shrine:AddNewModifier(shrine, shrine:FindAbilityByName("filler_ability"), "modifier_imba_shrine_passive_aura", {})
		end
	end

	-- jungle shrines
	local good_shrine_position = {
		Vector(-3700, 400, 240),
	}

	local bad_shrine_position = {
		Vector(3200, -840, 240),
	}

	for _, pos in pairs(good_shrine_position) do
		local shrine = CreateUnitByName("npc_dota_goodguys_healers", pos, true, nil, nil, 2)
		shrine:SetAbsOrigin(pos)
		--		shrine:AddNewModifier(shrine, shrine:FindAbilityByName("filler_ability"), "modifier_imba_shrine_passive_aura", {})

		-- Removing the backdoor protection ability makes the Sancturary ability hidden for some reason -_-
		-- -- Don't give jungle shrines backdoor protection
		-- if shrine:HasAbility("backdoor_protection_in_base") then
		-- shrine:RemoveAbility("backdoor_protection_in_base")
		-- end

		local find_trees = GridNav:GetAllTreesAroundPoint(pos, 100, true)

		for _, tree in pairs(find_trees) do
			tree:CutDownRegrowAfter(99999, -1)
		end

		-- Briefly adds vision to tell player trees got cut down
		AddFOWViewer(2, pos, 300, 1.0, false)
		AddFOWViewer(3, pos, 300, 1.0, false)
	end

	for _, pos in pairs(bad_shrine_position) do
		local shrine = CreateUnitByName("npc_dota_badguys_healers", pos, true, nil, nil, 3)
		shrine:SetAbsOrigin(pos)
		--		shrine:AddNewModifier(shrine, shrine:FindAbilityByName("filler_ability"), "modifier_imba_shrine_passive_aura", {})

		-- Removing the backdoor protection ability makes the Sancturary ability hidden for some reason -_-
		-- -- Don't give jungle shrines backdoor protection
		-- if shrine:HasAbility("backdoor_protection_in_base") then
		-- shrine:RemoveAbility("backdoor_protection_in_base")
		-- end

		local find_trees = GridNav:GetAllTreesAroundPoint(pos, 100, true)

		for _, tree in pairs(find_trees) do
			tree:CutDownRegrowAfter(99999, -1)
		end

		-- Briefly adds vision to tell player trees got cut down
		AddFOWViewer(2, pos, 300, 1.0, false)
		AddFOWViewer(3, pos, 300, 1.0, false)
	end
end

function GameMode:SetupContributors()
	if not GameMode.contributors then
		GameMode.contributors = LoadKeyValues("scripts/npc/units/contributors.txt")
	end

	local contributors = {}
	local contributors_count = 0
	local fillers = {
		"good_filler_2",
		"good_filler_4",
		"good_filler_6",
		"good_filler_7",
		"bad_filler_2",
		"bad_filler_4",
		"bad_filler_6",
		"bad_filler_7",
	}
	local max_contributors = #fillers

	for k, v in pairs(GameMode.contributors) do
		if k ~= "Version" then
			contributors_count = contributors_count + 1
			if not contributors[contributors_count] then contributors[contributors_count] = {} end
			contributors[contributors_count]["name"] = k
			contributors[contributors_count]["model"] = GameMode.contributors[k]["Model"]
		end
	end

	local pedestal_name = "npc_donator_pedestal"

	for _, ent_name in pairs(fillers) do
		local random_int = RandomInt(1, max_contributors)
		local contributor = contributors[random_int]
		if contributor == nil then
			print("Error: nil contributor name!")
			return
		end
		table.remove(contributors, random_int)

		local filler = Entities:FindByName(nil, ent_name)

		if filler then
			local abs = filler:GetAbsOrigin()
			local team = 2
			if string.find(ent_name, "bad") then team = 3 end

			filler:SetUnitName(contributor["name"])
			filler:SetModel(contributor["model"])
			filler:SetOriginalModel(contributor["model"])
			filler:AddNewModifier(filler, nil, "modifier_contributor_filler", {})
			filler:StartGesture(ACT_DOTA_IDLE)
			filler:SetAbsOrigin(abs + Vector(0, 0, 45))

			local pedestal = CreateUnitByName(pedestal_name, abs, true, nil, nil, team)
			pedestal:AddNewModifier(pedestal, nil, "modifier_contributor_statue", {})
			--			if not string.find(filler:GetName(), "6") or not string.find(filler:GetName(), "7") then
			pedestal:SetAbsOrigin(abs + Vector(0, 0, 45))
			filler.pedestal = pedestal
			--			end
		end
	end
end

--[[
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
--]]
function GameMode:SetupFrostivus()
	if Entities:FindByName(nil, "radiant_greevil") then
		local greevil = CreateUnitByName("npc_imba_greevil_radiant", Entities:FindByName(nil, "radiant_greevil"):GetAbsOrigin(), true, nil, nil, 2)
	end

	if Entities:FindByName(nil, "dire_greevil") then
		local greevil = CreateUnitByName("npc_imba_greevil_dire", Entities:FindByName(nil, "dire_greevil"):GetAbsOrigin(), true, nil, nil, 3)
	end
end

-- new system, double votes for donators
ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		-- If no one voted, default to IMBA 10v10 gamemode
		api:SetCustomGamemode(1)

		if GameMode.VoteTable == nil then return end
		local votes = GameMode.VoteTable

		for category, pidVoteTable in pairs(votes) do
			-- Tally the votes into a new table
			local voteCounts = {}
			for pid, vote in pairs(pidVoteTable) do
				local gamemode = vote[1]
				local vote_count = vote[2]
				if not voteCounts[vote[1]] then voteCounts[vote[1]] = 0 end
				--				print(pid, vote[1], vote[2])
				voteCounts[vote[1]] = voteCounts[vote[1]] + vote[2]
			end

			-- Find the key that has the highest value (key=vote value, value=number of votes)
			local highest_vote = 0
			local highest_key = ""
			for k, v in pairs(voteCounts) do
				--				print(k, v)
				if v > highest_vote then
					highest_key = k
					highest_vote = v
				end
			end

			-- Check for a tie by counting how many values have the highest number of votes
			local tieTable = {}
			for k, v in pairs(voteCounts) do
				print(k, v)
				if v == highest_vote then
					table.insert(tieTable, tonumber(k))
				end
			end

			-- Resolve a tie by selecting a random value from those with the highest votes
			if table.getn(tieTable) > 1 then
				--				print("Vote System: TIE!")
				highest_key = tieTable[math.random(table.getn(tieTable))]
			end

			-- Act on the winning vote
			if category == "gamemode" then
				api:SetCustomGamemode(highest_key)
			end

			--			print(category .. ": " .. highest_key)
		end
	end
end, nil)

local donator_list = {}
donator_list[1] = 5 -- Lead-Dev
donator_list[2] = 5 -- Dev
-- donator_list[3] = 5 -- Administrator
donator_list[4] = 1 -- Ember Donator
donator_list[7] = 2 -- Salamander Donator
donator_list[8] = 3 -- Icefrog Donator
donator_list[9] = 3 -- Gaben Donator

function GameMode:OnSettingVote(keys)
	local pid = keys.PlayerID

	--	print(keys)

	if not GameMode.VoteTable then GameMode.VoteTable = {} end
	if not GameMode.VoteTable[keys.category] then GameMode.VoteTable[keys.category] = {} end

	if pid >= 0 then
		if not GameMode.VoteTable[keys.category][pid] then GameMode.VoteTable[keys.category][pid] = {} end

		GameMode.VoteTable[keys.category][pid][1] = keys.vote

		if donator_list[api:GetDonatorStatus(pid)] then
			GameMode.VoteTable[keys.category][pid][2] = donator_list[api:GetDonatorStatus(pid)]
		else
			GameMode.VoteTable[keys.category][pid][2] = 1
		end
	end

	--	Say(nil, keys.category, false)
	--	Say(nil, tostring(keys.vote), false)

	-- TODO: Finish votes show up
	CustomGameEventManager:Send_ServerToAllClients("send_votes", { category = keys.category, vote = keys.vote, table = GameMode.VoteTable[keys.category] })
end

-- Custom game-modes as per api:GetCustomGamemode():
-- 1: Standard
-- 2: Mutation
-- 3: Super Frantic
-- 4: Diretide
-- 5: Same Hero Selection

function GameMode:SetSameHeroSelection(bEnabled)
	GameRules:SetSameHeroSelectionEnabled(bEnabled)
	CustomNetTables:SetTableValue("game_options", "same_hero_pick", { value = bEnabled })
end

function GameMode:PreventBannedHeroToBeRandomed(keys)
	--	print(keys)
	local hero_name = PlayerResource:GetSelectedHeroName(keys.iPlayerID)

	if hero_name and api:IsHeroDisabled(hero_name) or keys.bIMBA == 1 then
		local old_hero = PlayerResource:GetSelectedHeroEntity(keys.iPlayerID)
		local herolist = LoadKeyValues("scripts/npc/npc_heroes.txt")
		local hero_table = {}

		-- old hero stay because GetSelectedHeroEntity is invalid in hero selection phase
		if old_hero then
			print("old hero:", old_hero:GetUnitName())
		end

		local picked_heroes = {}

		for i = 0, PlayerResource:GetPlayerCount() - 1 do
			if PlayerResource:GetPlayer(i) and PlayerResource:GetSelectedHeroName(i) then
				picked_heroes[PlayerResource:GetSelectedHeroName(i)] = true
			end
		end

		for k, v in pairs(herolist) do
			-- only add non-picked heroes
			if string.find(k, "npc_dota_hero_") and not picked_heroes[k] and not api:IsHeroDisabled(k) then
				if keys.bIMBA == 1 then
					if HeroSelection.imbalist[k] and HeroSelection.imbalist[k] == 1 then
						table.insert(hero_table, k)
					end
				else
					table.insert(hero_table, k)
				end
			end
		end

		--		print(hero_table)

		local new_hero = hero_table[RandomInt(1, #hero_table)]

		PlayerResource:GetPlayer(keys.iPlayerID):SetSelectedHero(new_hero)

		PrecacheUnitByNameAsync(new_hero, function()
			PlayerResource:ReplaceHeroWith(keys.iPlayerID, new_hero, 0, 0)

			Timers:CreateTimer(1.0, function()
				if old_hero then
					UTIL_Remove(old_hero)
				end

				for _, hero in pairs(HeroList:GetAllHeroes()) do
					if hero.GetPlayerOwnerID and hero:GetPlayerOwnerID() == -1 then
						print("No hero owner, remove!", hero:GetUnitName())
						UTIL_Remove(hero)
					end
				end
			end)
		end)

		print("banned hero randomed, re-random:", new_hero)
	end
end

local party_votes = {}

function GameMode:OnPartyVote(keys)
	local votes_count = 0

	if not party_votes[keys.PlayerID] then
		party_votes[keys.PlayerID] = true
	end

	for k, v in pairs(party_votes) do
		if v == true then
			votes_count = votes_count + 1
		end
	end

	if votes_count >= PlayerResource:GetPlayerCount() or IsInToolsMode() and PARTIES_ALLOWED == false then
		CustomGameEventManager:Send_ServerToAllClients("setup_loading_screen", { value = "visible" })
		PARTIES_ALLOWED = true
	end

	CustomGameEventManager:Send_ServerToAllClients("send_party_votes", {
		vote_count = votes_count,
		max_votes = PlayerResource:GetPlayerCount(),
	})
end
