if CDungeon == nil then
	print("Create CDungeon class")
	CDungeon = class({})
	_G.CDungeon = CDungeon
	GameRules.Dungeon = CDungeon()
end

require('components/siltbreaker/constants')
require('components/siltbreaker/utility_functions')
require('components/siltbreaker/precache')
require('components/siltbreaker/events')
require('components/siltbreaker/filters')
-- require('triggers')
require('components/siltbreaker/voice_lines')
require('components/siltbreaker/units/ai/ai_chaser')
require('components/siltbreaker/zones/zones')
require('components/siltbreaker/units/breakable_container_surprises')
require('components/siltbreaker/units/treasure_chest_surprises')

require('components/siltbreaker/zones/dialog_'..GetMapName())

LinkLuaModifier( "modifier_boss_intro", "components/siltbreaker/modifiers/modifier_boss_intro", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_inactive", "components/siltbreaker/modifiers/modifier_boss_inactive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pre_teleport", "components/siltbreaker/modifiers/modifier_pre_teleport", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dialog", "components/siltbreaker/modifiers/modifier_npc_dialog", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dialog_notify", "components/siltbreaker/modifiers/modifier_npc_dialog_notify", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_stack_count_animation_controller", "components/siltbreaker/modifiers/modifier_stack_count_animation_controller", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_techies_land_mine", "components/siltbreaker/modifiers/modifier_creature_techies_land_mine", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_temple_guardian_statue", "components/siltbreaker/modifiers/modifier_temple_guardian_statue", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_tank_melee_smash_thinker", "components/siltbreaker/modifiers/modifier_ogre_tank_melee_smash_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sand_king_boss_caustic_finale", "components/siltbreaker/modifiers/modifier_sand_king_boss_caustic_finale", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_juggle", "components/siltbreaker/modifiers/modifier_invoker_juggle", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_player_light", "components/siltbreaker/modifiers/modifier_player_light", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_provides_fow_position", "components/siltbreaker/modifiers/modifier_provides_fow_position", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_undead_skeleton", "components/siltbreaker/modifiers/modifier_undead_skeleton", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_breakable_container", "components/siltbreaker/modifiers/modifier_breakable_container", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_campfire_hide", "components/siltbreaker/modifiers/modifier_invoker_campfire_hide", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_explorer_mode", "components/siltbreaker/modifiers/modifier_explorer_mode", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_siltbreaker_phase_one", "components/siltbreaker/modifiers/modifier_siltbreaker_phase_one", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_siltbreaker_phase_two", "components/siltbreaker/modifiers/modifier_siltbreaker_phase_two", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_siltbreaker_phase_three", "components/siltbreaker/modifiers/modifier_siltbreaker_phase_three", LUA_MODIFIER_MOTION_NONE )

function CDungeon:InitSiltbreaker()
	CDungeon.flItemExpireTime = 60.0
	CDungeon.bPlayerHasSpawned = false
	CDungeon.PrecachedEnemies = {}
	CDungeon.PrecachedVIPs = {}
	CDungeon.CheckpointsActivated = {}
	CDungeon.Zones = {}
	CDungeon.nUndergroundGateActivators = 0
	CDungeon.nTempleExitActivators = 0
	CDungeon.bTempleExitThinking = false
	CDungeon.nFortressExitActivators = 0
	CDungeon.bFortressExitThinking = false
	CDungeon.nSiltArenaPlatformActivators = 0
	CDungeon.bSiltArenaPlatformsThinking = false
	CDungeon.flVictoryTime = nil
	CDungeon.bConfirmPending = false
	CDungeon.bUseArtifactCurrency = false
	CDungeon.bExplorerMode = GameRules:GetCustomGameDifficulty() == 1
	if CDungeon.bExplorerMode == true then
		print( "CDungeon:InitGameMode() - Game starting in Explorer Mode." )
		CustomGameEventManager:Send_ServerToAllClients( "easy_mode", {} )
	end

	CDungeon.RelicsFound = {}
	CDungeon.RelicsDefinition = {}
--	CDungeon:LoadRelics()

	CDungeon.ArtifactCurrency = {}
	CDungeon.ChefNotesFound = {}
	CDungeon.WardenNotesFound = {}
	CDungeon.InvokerFound = {}
	CDungeon.PenguinRideTimes = {}
	CDungeon.ArtifactsPurchased = {}

	GameRules:SetPreGameTime(0.0)
	GameRules:SetStrategyTime(0.0)

	ListenToGameEvent( "dota_player_reconnected", Dynamic_Wrap( CDungeon, 'OnPlayerReconnected' ), CDungeon )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CDungeon, "OnNPCSpawned" ), CDungeon )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CDungeon, 'OnEntityKilled' ), CDungeon )
	ListenToGameEvent( "dota_player_gained_level", Dynamic_Wrap( CDungeon, "OnPlayerGainedLevel" ), CDungeon )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( CDungeon, "OnItemPickedUp" ), CDungeon )
	ListenToGameEvent( "dota_holdout_revive_complete", Dynamic_Wrap( CDungeon, "OnPlayerRevived" ), CDungeon )
	ListenToGameEvent( "dota_buyback", Dynamic_Wrap( CDungeon, "OnPlayerBuyback" ), CDungeon )
	ListenToGameEvent( "dota_item_spawned", Dynamic_Wrap( CDungeon, "OnItemSpawned" ), CDungeon )
	ListenToGameEvent( "dota_non_player_used_ability", Dynamic_Wrap( CDungeon, "OnNonPlayerUsedAbility" ), CDungeon )

	CustomGameEventManager:RegisterListener( "dialog_complete", function(...) return self:OnDialogEnded( ... ) end )
	CustomGameEventManager:RegisterListener( "boss_fight_start", function(...) return self:OnBossFightBegin( ... ) end )
	CustomGameEventManager:RegisterListener( "scroll_clicked", function(...) return self:OnScrollClicked( ... ) end )
	CustomGameEventManager:RegisterListener( "dialog_confirm", function(...) return self:OnDialogConfirm( ... ) end )
	CustomGameEventManager:RegisterListener( "dialog_confirm_expire", function(...) return self:OnDialogConfirmExpired( ... ) end )
	CustomGameEventManager:RegisterListener( "relic_claimed", function(...) return self:OnRelicClaimed( ... ) end )

	-- Filter Registration: Functions are found in filters.lua
	GameRules:GetGameModeEntity():SetHealingFilter( Dynamic_Wrap( CDungeon, "HealingFilter" ), CDungeon )
	GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap( CDungeon, "DamageFilter" ), CDungeon )
	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter( Dynamic_Wrap( CDungeon, "ItemAddedToInventoryFilter" ), CDungeon )
	GameRules:GetGameModeEntity():SetModifierGainedFilter( Dynamic_Wrap( CDungeon, "ModifierGainedFilter" ), CDungeon )
	GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled(true)

	Convars:RegisterCommand( "dungeon_test_zone", function(...) return CDungeon:TestZone( ... ) end, "Test a zone.", FCVAR_CHEAT )

	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		PlayerResource:SetCustomTeamAssignment( nPlayerID, DOTA_TEAM_GOODGUYS )
	end

	CDungeon:SetupZones()

	GameRules:GetGameModeEntity():SetThink( "OnThink", CDungeon, "GlobalThink", 0.5 )
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CDungeon:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if self.flVictoryTime ~= nil and GameRules:GetGameTime() > self.flVictoryTime then
			GameRules.Dungeon:OnGameFinished()
			GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
		end

		for _,Zone in pairs( self.Zones ) do
			if Zone ~= nil then
				Zone:OnThink()
			end
		end

		for i,Zone in pairs( self.Zones ) do
			if not Zone.bNoLeaderboard then
				local netTable = {}
				netTable["ZoneName"] = Zone.szName
				CustomNetTables:SetTableValue( "zone_names", string.format( "%d", i ), netTable )
			end
		end

		for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
				local Hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if Hero ~= nil then
					for _,Zone in pairs( self.Zones ) do
						if Zone ~= nil and Zone:ContainsUnit( Hero ) then
							local netTable = {}
							netTable["ZoneName"] = Zone.szName
							CustomNetTables:SetTableValue( "player_zone_locations", string.format( "%d", nPlayerID ), netTable )
						end
					end
				end
			end
		end


		self:CheckForDefeat()
		self:ThinkLootExpire()
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 0.5
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CDungeon:ForceAssignHeroes()
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local hPlayer = PlayerResource:GetPlayer( nPlayerID )
			if hPlayer and not PlayerResource:HasSelectedHero( nPlayerID ) then
				hPlayer:MakeRandomHeroSelection()
			end
		end
	end
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CDungeon:SetupZones()
	self.Zones = {}
	--PrintTable( ZonesDefinition, "  " )
	for _,zone in pairs( ZonesDefinition ) do
		if zone ~= nil then
			print( "CDungeon:SetupZones() - Setting up zone " .. zone.szName .. " from definition." )
			local newZone = CDungeonZone()
			newZone:Init( zone )
			table.insert( self.Zones, newZone )
		end
	end
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CDungeon:GetZoneByName( szZoneName )
	for _,zone in pairs( self.Zones ) do
		if zone ~= nil and zone.szName == szZoneName then
			return zone
		end
	end
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

function CDungeon:CheckForDefeat()
	if self.bPlayerHasSpawned == false then
		return
	end

	local bAnyHeroesAlive = false
	local Heroes = HeroList:GetAllHeroes()
	for _,Hero in pairs ( Heroes ) do
		if Hero ~= nil and Hero:HasOwnerAbandoned() == false and Hero:IsRealHero() and Hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS and ( Hero:IsAlive() or Hero:IsReincarnating() or Hero.nRespawnsRemaining >= nBUYBACK_COST )  then
			bAnyHeroesAlive = true
		end
	end

	if bAnyHeroesAlive == false then
		GameRules.Dungeon:OnGameFinished()
		GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
	end
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CDungeon:ThinkLootExpire()
	if self.flItemExpireTime <= 0.0 then
		return
	end

	local flCutoffTime = GameRules:GetGameTime() - self.flItemExpireTime

	for _,item in pairs( Entities:FindAllByClassname( "dota_item_drop" ) ) do
		local containedItem = item:GetContainedItem()
		if containedItem ~= nil and not CDungeon:IsKeyItem(containedItem) and containedItem:GetAbilityName() ~= "item_life_rune" and containedItem.bIsRelic ~= true then
			self:ProcessItemForLootExpire( item, flCutoffTime )
		end
	end
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CDungeon:ProcessItemForLootExpire( item, flCutoffTime )
	if item:IsNull() then
		return false
	end
	if item:GetCreationTime() >= flCutoffTime then
		return true
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, item )
	ParticleManager:SetParticleControl( nFXIndex, 0, item:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	local inventoryItem = item:GetContainedItem()
	if inventoryItem then
		UTIL_RemoveImmediate( inventoryItem )
	end
	UTIL_RemoveImmediate( item )
	return false
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CDungeon:HasDialog( hDialogEnt )
	if hDialogEnt == nil or hDialogEnt:IsNull() then
		return false
	end
	
	for k,v in pairs ( DialogDefinition ) do
		if k == hDialogEnt:GetUnitName() then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CDungeon:GetDialog( hDialogEnt )
	if self:HasDialog( hDialogEnt ) == false then
		return nil
	end

	local Dialog = DialogDefinition[hDialogEnt:GetUnitName()]
	if Dialog == nil then
		return nil
	end

	if hDialogEnt.nCurrentLine == nil then
		hDialogEnt.nCurrentLine = 1
	end

 	if Dialog[hDialogEnt.nCurrentLine] ~= nil and Dialog[hDialogEnt.nCurrentLine].szAdvanceQuestActive ~= nil then
 		if self:IsQuestActive( Dialog[hDialogEnt.nCurrentLine].szAdvanceQuestActive ) then
			hDialogEnt.nCurrentLine = hDialogEnt.nCurrentLine + 1
		end
	end

	return Dialog[hDialogEnt.nCurrentLine]
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

function CDungeon:GetDialogLine( hDialogEnt, nLineNumber )
	if self:HasDialog( hDialogEnt ) == false then
		return nil
	end

	local Dialog = DialogDefinition[hDialogEnt:GetUnitName()]
	if Dialog == nil then
		return nil
	end

	return Dialog[nLineNumber]
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

function CDungeon:IsQuestActive( szQuestName )
	for _,zone in pairs( self.Zones ) do
		if zone ~= nil and zone:IsQuestActive( szQuestName ) == true then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

function CDungeon:IsQuestComplete( szQuestName )
	for _,zone in pairs( self.Zones ) do
		if zone ~= nil and zone:IsQuestComplete( szQuestName ) == true then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

function CDungeon:TestZone( cmdName, szZoneName )
	local szTeleportEntityName = nil
	local vTeleportPos = nil
	local nZoneIndex = 0

	if szZoneName == nil then return end

	for i = 1, #self.Zones do
		if self.Zones[i].szName == szZoneName then
			nZoneIndex = i
			szTeleportEntityName = self.Zones[i].szTeleportEntityName
			vTeleportPos = self.Zones[i].vTeleportPos
		end
	end

	local hTeleportEntity = Entities:FindByName( nil, szTeleportEntityName )
	if szTeleportEntityName == nil and vTeleportPos == nil then
		print( "CDungeon:TestZone - ERROR - No teleport position or entity defined for zone " .. szZoneName )
		return
	end

	if hTeleportEntity ~= nil then
		vTeleportPos = hTeleportEntity:GetOrigin()
	end

	local nGold = 0
	local nXP = 0
	local bCaptainSpawned = false

	for j = 1, nZoneIndex - 1 do
		local Zone = self.Zones[j]
		if Zone ~= nil then
			local nQuestRewardGold = 0
			local nQuestRewardXP = 0
			for _,Quest in pairs( Zone.Quests ) do
				if Quest.RewardGold ~= nil then
					nQuestRewardGold = nQuestRewardGold + ( Quest.RewardGold )
					print( "CDungeon:TestZone - Awarding " .. Quest.RewardGold  .. " gold from quest " .. Quest.szQuestName )
				end
				if Quest.RewardXP ~= nil then
					nQuestRewardXP = nQuestRewardXP + ( Quest.RewardXP )
					print( "CDungeon:TestZone - Awarding " .. Quest.RewardXP .. " XP from quest " .. Quest.szQuestName )
				end

			end

			if Zone.nGoldRemaining ~= nil then
				nGold = nGold + ( Zone.nGoldRemaining * 0.40 ) + nQuestRewardGold
				print( "CDungeon:TestZone - Awarding " .. ( Zone.nGoldRemaining * 0.40 ) .. " gold from zone " .. Zone.szName )
			end
			if Zone.nXPRemaining ~= nil then
				nXP = nXP + ( Zone.nXPRemaining * 0.25 ) + nQuestRewardXP
				print( "CDungeon:TestZone - Awarding " .. ( Zone.nXPRemaining * 0.25 ) .. " gold from zone " .. Zone.szName )
			end

			-- For assault tests
			if Zone.szName == "darkforest_pass" and bCaptainSpawned == false then
				bCaptainSpawned = true
				local hSpawner = Entities:FindByNameNearest( "desert_outpost_teleport", Vector( 0, 0, 0 ), 99999 )
				local hUnit = CreateUnitByName( "npc_dota_radiant_captain", hSpawner:GetOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
				if hUnit ~= nil then
					hUnit.zone = self
					hUnit:RemoveAbility( "imprisoned_soldier" )
					hUnit:RemoveModifierByName( "modifier_imprisoned_soldier" )
					hUnit:RemoveModifierByName( "modifier_imprisoned_soldier_animation" )
					hUnit:AddNewModifier( hUnit, nil, "modifier_npc_dialog", { duration = -1 } )
					hUnit:Interrupt()
				end

				for i=1,10 do
					local hCreep = CreateUnitByName( "npc_dota_radiant_soldier", hSpawner:GetOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
					if hCreep ~= nil then
						hCreep.zone = self
						hCreep:RemoveAbility( "imprisoned_soldier" )
						hCreep:RemoveModifierByName( "modifier_imprisoned_soldier" )
						hCreep:RemoveModifierByName( "modifier_imprisoned_soldier_animation" )
						hCreep:Interrupt()
					end
				end
			end
		end
	end

	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		if PlayerResource:IsValidPlayer( nPlayerID ) then
			local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hHero ~= nil then
				local nXPToGive = nXP - PlayerResource:GetTotalEarnedXP( nPlayerID )
				local nGoldToGive = nGold - PlayerResource:GetTotalEarnedGold( nPlayerID )
				hHero:AddExperience( nXPToGive, DOTA_ModifyXP_Unspecified, false, false )
				PlayerResource:ModifyGold( nPlayerID, nGoldToGive, true, DOTA_ModifyGold_Unspecified )
				if szZoneName ~= "desert_outpost" then
					FindClearSpaceForUnit( hHero, vTeleportPos, true )
				end
				PlayerResource:SetBuybackCooldownTime( nPlayerID, 0 )
				PlayerResource:SetBuybackGoldLimitTime( nPlayerID, 0 )
				PlayerResource:ResetBuybackCostTime( nPlayerID )
			end
		end
	end

	GameRules:SetUseUniversalShopMode( true )
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

function CDungeon:LoadRelics()
	local ItemData = LoadKeyValues( "scripts/npc/npc_items_custom.txt" )
	if ItemData ~= nil then
		for k,v in pairs( ItemData ) do
			local nDungeonItemDef = v["DungeonItemDef"] or nil
			if nDungeonItemDef ~= nil then
				local szDungeonAction = v["DungeonAction"]
				if szDungeonAction == nil then
					print( "CDungeon:LoadRelics() - WARNING: RELIC " .. k .. " DEFINED WITHOUT CORRESPONDING EVENT ACTION" )
					szDungeonAction = szDungeonAction * szDungeonAction
				else
					
					local Relic = {}
					Relic["RelicName"] = k
					Relic["DungeonItemDef"] = nDungeonItemDef
					Relic["DungeonAction"] = szDungeonAction
					Relic["Purchased"] = 0
					if self.bUseArtifactCurrency == true then
						Relic["DungeonCurrencyCost"] = v["DungeonCurrencyCost"] or 1
						print( "CDungeon:LoadRelics() - Adding Relic " .. k .. " with item def " .. nDungeonItemDef .. " and cost of " .. Relic["DungeonCurrencyCost"] )
					else
						print( "CDungeon:LoadRelics() - Adding Relic " .. k .. " with item def " .. nDungeonItemDef )
					end

					table.insert( self.RelicsDefinition, Relic )
				end
			end
		end
	end	
end

---------------------------------------------------------------------------
--  IsKeyItem - returns true if item is a key item for queusts
---------------------------------------------------------------------------
function CDungeon:IsKeyItem( hItem )
	return hItem:GetAbilityName() == "item_orb_of_passage" or hItem:GetAbilityName() == "item_prison_cell_key"
end

-- Not working while in components/vote.lua path for reasons
ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		-- If no one voted, default to normal difficulty
		SetCustomGamemode(1)
		GameRules:SetCustomGameDifficulty(2)

		if CDungeon.VoteTable == nil then return end
		local votes = CDungeon.VoteTable

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
				GameRules:SetCustomGamemode(highest_key)
			end

			if category == "difficulty" then
				GameRules:SetCustomGameDifficulty(highest_key)
			end

			if IsInToolsMode() then
				print(category .. ": " .. highest_key)
			end
		end
	end
end, nil)

function CDungeon:OnSettingVote(keys)
	local pid = keys.PlayerID

	if not CDungeon.VoteTable then
		CDungeon.VoteTable = {}
	end

	if not CDungeon.VoteTable[keys.category] then
		CDungeon.VoteTable[keys.category] = {}
	end

	CDungeon.VoteTable[keys.category][pid] = keys.vote

--	Say(nil, keys.category, false)
--	Say(nil, tostring(keys.vote), false)

	-- TODO: Finish votes show up
	CustomGameEventManager:Send_ServerToAllClients("send_votes", {category = keys.category, vote = keys.vote, table = CDungeon.VoteTable[keys.category]})
end
