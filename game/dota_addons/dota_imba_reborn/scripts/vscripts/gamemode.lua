if GameMode == nil then
	_G.GameMode = class({})
end

-- clientside KV loading
require('addon_init')

require('components/api/init')
if IsInToolsMode() then -- might lag a bit and backend to get errors not working yet
	require('libraries/adv_log') -- be careful! this library can hide lua errors in rare cases
end

require('libraries/animations')
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
require('components/courier/init')
require("components/demo/init")
require("components/frantic/init")
require('components/gold')
require('components/hero_selection/init')
require('components/mutation/init')
require('components/respawn_timer') -- Respawn time system override
require('components/runes') -- Rune system override
require('components/settings/settings')
-- require('components/team_selection')

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
			if IMBA_DIRETIDE == true then
				ROSHAN_ENT = CreateUnitByName("npc_diretide_roshan", _G.ROSHAN_SPAWN_LOC, true, nil, nil, DOTA_TEAM_NEUTRALS)
			else
				if IMBA_DIRETIDE_EASTER_EGG == true then
					local easter_egg = CreateUnitByName("npc_dota_diretide_easter_egg", _G.ROSHAN_SPAWN_LOC, true, nil, nil, DOTA_TEAM_NEUTRALS)
					easter_egg:AddNewModifier(easter_egg, nil, "modifier_npc_dialog", {})
				else
					local roshan = CreateUnitByName("npc_dota_roshan", _G.ROSHAN_SPAWN_LOC, true, nil, nil, DOTA_TEAM_NEUTRALS)
					roshan:AddNewModifier(roshan, nil, "modifier_imba_roshan_ai", {})
				end
			end
		end
	end
end

function GameMode:OnAllPlayersLoaded()
	-- Setup filters
	--	GameRules:GetGameModeEntity():SetHealingFilter( Dynamic_Wrap(GameMode, "HealingFilter"), self )
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
end

-- CAREFUL, FOR REASONS THIS FUNCTION IS ALWAYS CALLED TWICE
function GameMode:InitGameMode()
	self:_InitGameMode()
end

function GameMode:DonatorCompanionJS(event)
	Battlepass:DonatorCompanion(event.ID, event.unit, event.js)
end

function GameMode:DonatorStatueJS(event)
	-- need to update the current statue with the new one
--	Battlepass:DonatorCompanion(event.ID, event.unit, event.js)
end

function GameMode:DonatorEmblemJS(event)
	print(event)
	local hero = PlayerResource:GetSelectedHeroEntity(event.ID)

	if hero:HasModifier("modifier_patreon_donator") then
		local modifier = hero:FindModifierByName("modifier_patreon_donator")

		modifier.effect_name = event.unit
	end
end

function GameMode:DonatorCompanionSkinJS(event)
	DonatorCompanionSkin(event.ID, event.unit, event.skin)
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

ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		-- If no one voted, default to IMBA 10v10 gamemode
		GameRules:SetCustomGameDifficulty(2)
		GameMode:SetCustomGamemode(1)

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

			-- Act on the winning vote
			if category == "gamemode" then
				GameMode:SetCustomGamemode(highest_key)
			end

			-- Act on the winning vote
			if category == "difficulty" then
				GameRules:SetCustomGameDifficulty(highest_key)
			end

--			print(category .. ": " .. highest_key)
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

	GameMode.VoteTable[keys.category][pid] = keys.vote

--	Say(nil, keys.category, false)
--	Say(nil, tostring(keys.vote), false)

	-- TODO: Finish votes show up
	CustomGameEventManager:Send_ServerToAllClients("send_votes", {category = keys.category, vote = keys.vote, table = GameMode.VoteTable[keys.category]})
end

function GameMode:SetCustomGamemode(iValue)
	CustomNetTables:SetTableValue("game_options", "gamemode", {iValue})
end

function GameMode:GetCustomGamemode()
--	print("Gamemode:", CustomNetTables:GetTableValue("game_options", "gamemode")["1"])
	return CustomNetTables:GetTableValue("game_options", "gamemode")["1"]
end
