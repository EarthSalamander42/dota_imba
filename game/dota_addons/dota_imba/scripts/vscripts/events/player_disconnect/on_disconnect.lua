-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

function GameMode:OnDisconnect(keys)
	-- GetConnectionState values:
	-- 0 - no connection
	-- 1 - bot connected
	-- 2 - player connected
	-- 3 - bot/player disconnected.

	-- Typical keys:
	-- PlayerID: 2
	-- name: Zimberzimber
	-- networkid: [U:1:95496383]
	-- reason: 2
	-- splitscreenplayer: -1
	-- userid: 7
	-- xuid: 76561198055762111

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player disconnect/abandon logic
	-------------------------------------------------------------------------------------------------

	-- If the game hasn't started, or has already ended, do nothing
	if (GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME) or (GameRules:State_Get() < DOTA_GAMERULES_STATE_PRE_GAME) then
		return nil
			-- Else, start tracking player's reconnect/abandon state
	else
		-- Fetch player's player and hero information
		local player_id = keys.PlayerID
		local player_name = keys.name
		local hero = PlayerResource:GetPickedHero(player_id)
		local hero_name = PlayerResource:GetPickedHeroName(player_id)
		local line_duration = 7

		-- Start tracking
		log.info("started keeping track of player "..player_id.."'s connection state")
		api.imba.event(api.events.player_disconnected, { tostring(PlayerResource:GetSteamID(player_id)) })

		local disconnect_time = 0
		Timers:CreateTimer(1, function()
			-- Keep track of time disconnected
			disconnect_time = disconnect_time + 1

			-- If the player has abandoned the game, set his gold to zero and distribute passive gold towards its allies
			if disconnect_time >= ABANDON_TIME then
				-- Abandon message
				Notifications:BottomToAll({hero = hero_name, duration = line_duration})
				Notifications:BottomToAll({text = player_name.." ", duration = line_duration, continue = true})
				Notifications:BottomToAll({text = "#imba_player_abandon_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})
				PlayerResource:SetHasAbandonedDueToLongDisconnect(player_id, true)
				log.info("player "..player_id.." has abandoned the game.")

				api.imba.event(api.events.player_abandoned, { tostring(PlayerResource:GetSteamID(player_id)) })

				-- Start redistributing this player's gold to its allies
				PlayerResource:StartAbandonGoldRedistribution(player_id)
				-- If the player has reconnected, stop tracking connection state every second
			elseif PlayerResource:GetConnectionState(player_id) == 2 then

			-- Else, keep tracking connection state
			else
				log.info("tracking player "..player_id.."'s connection state, disconnected for "..disconnect_time.." seconds.")
				return 1
			end
		end)

		print("Increase GG amount!")
		local table = {
			ID = player_id,
			team = PlayerResource:GetTeam(player_id),
			disconnect = 1
		}
		GameMode:GG(table)
	end
end