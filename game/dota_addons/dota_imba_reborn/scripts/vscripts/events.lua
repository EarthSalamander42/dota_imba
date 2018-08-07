function GameMode:OnDisconnect(keys)
	local name = keys.name
	local networkid = keys.networkid
	local reason = keys.reason
	local userid = keys.userid
end

function GameMode:OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		HeroSelection:Init() -- init picking screen kv (this function is a bit heavy to run)
		OnSetGameMode() -- setup gamemode rules
		TeamSelection:InitializeTeamSelection()
		GetPlayerInfoIXP() -- Add a class later
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		api.imba.event(api.events.entered_hero_selection)
		HeroSelection:StartSelection()
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
		api.imba.event(api.events.entered_pre_game)
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		api.imba.event(api.events.started_game)
	elseif newState == DOTA_GAMERULES_STATE_POST_GAME then
		api.imba.event(api.events.entered_post_game)
	end
end

function GameMode:OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)
end

function GameMode:OnItemPickedUp(keys)
	local unitEntity = nil
	if keys.UnitEntitIndex then
		unitEntity = EntIndexToHScript(keys.UnitEntitIndex)
	elseif keys.HeroEntityIndex then
		unitEntity = EntIndexToHScript(keys.HeroEntityIndex)
	end

	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local itemname = keys.itemname
end

function GameMode:OnPlayerReconnect(keys)
	
end

function GameMode:OnAbilityUsed(keys)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local abilityname = keys.abilityname
end

function GameMode:OnPlayerLevelUp(keys)
	local player = EntIndexToHScript(keys.player)
	local level = keys.level
end

function GameMode:OnEntityKilled( keys )
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local killerEntity = nil

	if keys.entindex_attacker ~= nil then
		killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end

	local killerAbility = nil

	if keys.entindex_inflictor ~= nil then
		killerAbility = EntIndexToHScript( keys.entindex_inflictor )
	end

	-- Put code here to handle when an entity gets killed
end

function GameMode:PlayerConnect(keys)

end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
	local entIndex = keys.index + 1
	local ply = EntIndexToHScript(entIndex)
	local playerID = ply:GetPlayerID()
end

-- This function is called whenever any player sends a chat message to team or All
function GameMode:OnPlayerChat(keys)
	local teamonly = keys.teamonly
	local userID = keys.userid
	local playerID = self.vUserIds[userID]:GetPlayerID()

	local text = keys.text
end
