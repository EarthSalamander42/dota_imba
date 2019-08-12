Imbathrow.USE_RUNES_IN_KOBOLD_THROW = true
Imbathrow.RUNES_SPAWN_CHANCE = 10
Imbathrow.RUNES_LIST = {
--	"item_imba_rune_bounty",
	"item_imba_rune_haste",
	"item_imba_rune_doubledamage",
	"item_imba_rune_regen",
	"item_imba_rune_arcane",
	"item_imba_rune_invis",
--	"item_imba_rune_illusion",
--	"item_imba_rune_frost",
--	"item_imba_rune_ember",
--	"item_imba_rune_stone",
}

	Imbathrow.m_TeamColors = {}
	Imbathrow.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	--		Teal
	Imbathrow.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }		--		Yellow
	Imbathrow.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }	--      Pink
	Imbathrow.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }		--		Orange
	Imbathrow.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }		--		Blue
	Imbathrow.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }	--		Green
	Imbathrow.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }		--		Brown
	Imbathrow.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }	--		Cyan
	Imbathrow.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }	--		Olive
	Imbathrow.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }	--		Purple

	for team = 0, (DOTA_TEAM_COUNT-1) do
		color = Imbathrow.m_TeamColors[ team ]
		if color then
			SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
		end
	end

	Imbathrow.m_VictoryMessages = {}
	Imbathrow.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
	Imbathrow.m_VictoryMessages[DOTA_TEAM_BADGUYS]  = "#VictoryMessage_BadGuys"
	Imbathrow.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
	Imbathrow.m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2"
	Imbathrow.m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3"
	Imbathrow.m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4"
	Imbathrow.m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#VictoryMessage_Custom5"
	Imbathrow.m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#VictoryMessage_Custom6"
	Imbathrow.m_VictoryMessages[DOTA_TEAM_CUSTOM_7] = "#VictoryMessage_Custom7"
	Imbathrow.m_VictoryMessages[DOTA_TEAM_CUSTOM_8] = "#VictoryMessage_Custom8"

	Imbathrow.m_GatheredShuffledTeams = {}
	Imbathrow.numSpawnCamps = 5
	Imbathrow.specialItem = ""
	Imbathrow.spawnTime = 120
	Imbathrow.nNextSpawnItemNumber = 1
	Imbathrow.hasWarnedSpawn = false
	Imbathrow.allSpawned = false
	Imbathrow.leadingTeam = -1
	Imbathrow.runnerupTeam = -1
	Imbathrow.leadingTeamScore = 0
	Imbathrow.runnerupTeamScore = 0
	Imbathrow.isGameTied = true
	Imbathrow.countdownEnabled = false
	Imbathrow.itemSpawnIndex = 1
	Imbathrow.itemSpawnLocation = Entities:FindByName( nil, "greevil" )
	Imbathrow.tier1ItemBucket = {}
	Imbathrow.tier2ItemBucket = {}
	Imbathrow.tier3ItemBucket = {}
	Imbathrow.tier4ItemBucket = {}
	Imbathrow.tier5ItemBucket = {}

	Imbathrow.TEAM_KILLS_TO_WIN = 25
	Imbathrow.CLOSE_TO_VICTORY_THRESHOLD = 5

	---------------------------------------------------------------------------

	-- Adding Many Players
	if GetMapName() == "imbathrow_mines_3v3v3" then
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 3 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 3 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 3 )
		Imbathrow.m_GoldRadiusMin = 300
		Imbathrow.m_GoldRadiusMax = 900
		Imbathrow.m_GoldDropPercent = 8
	elseif GetMapName() == "imbathrow_3v3v3v3" then
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 3 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 3 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 3 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 3 )
		Imbathrow.m_GoldRadiusMin = 300
		Imbathrow.m_GoldRadiusMax = 1400
		Imbathrow.m_GoldDropPercent = 10
	else
		Imbathrow.m_GoldRadiusMin = 250
		Imbathrow.m_GoldRadiusMax = 550
		Imbathrow.m_GoldDropPercent = 4
	end

	-- Show the ending scoreboard immediately
	GameRules:SetCustomGameEndDelay( 0 )
	GameRules:SetCustomVictoryMessageDuration( 10 )
	GameRules:SetPreGameTime( 10 )
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetShowcaseTime( 0.0 )
	GameRules:SetHideKillMessageHeaders( true )
	GameRules:SetUseUniversalShopMode( true )
--	GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen( 0 )
--	GameRules:GetGameModeEntity():SetFountainPercentageManaRegen( 0 )
--	GameRules:GetGameModeEntity():SetFountainConstantManaRegen( 0 )

-- Spawning monsters
spawncamps = {}
for i = 1, Imbathrow.numSpawnCamps do
	local campname = "camp"..i.."_path_customspawn"
	spawncamps[campname] =
	{
		NumberToSpawn = RandomInt(3,5),
		WaypointName = "camp"..i.."_path_wp1"
	}
end