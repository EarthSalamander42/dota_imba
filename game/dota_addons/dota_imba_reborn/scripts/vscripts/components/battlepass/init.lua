if Battlepass == nil then Battlepass = class({}) end

require('components/battlepass/constants')
require('components/battlepass/util')
require('components/battlepass/battlepass')
require('components/battlepass/donator')
require('components/battlepass/experience')

ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		Battlepass:Init()
		Battlepass:GetPlayerInfoXP()
	end
end, nil)

ListenToGameEvent('npc_spawned', function(event)
	local npc = EntIndexToHScript(event.entindex)

	if npc:IsIllusion() or string.find(npc:GetUnitName(), "npc_dota_lone_druid_bear") then
		npc:SetupHealthBarLabel()
		return
	elseif npc:IsRealHero() then
		Battlepass:AddItemEffects(npc)

		local ply_table = CustomNetTables:GetTableValue("battlepass", tostring(npc:GetPlayerID()))

		if ply_table and ply_table.bp_rewards == 0 then
			return
		end

		if api:IsDonator(npc:GetPlayerID()) and PlayerResource:GetConnectionState(npc:GetPlayerID()) ~= 1 then
			npc:SetupHealthBarLabel()

			if api:GetDonatorStatus(npc:GetPlayerID()) == 10 or (IMBA_PUNISHED and npc.GetPlayerID and IMBA_PUNISHED[PlayerResource:GetSteamAccountID(npc:GetPlayerID())]) then
				npc:SetOriginalModel("models/items/courier/kanyu_shark/kanyu_shark.vmdl")
				npc:CenterCameraOnEntity(npc, -1)
			else
				npc:AddNewModifier(npc, nil, "modifier_patreon_donator", {})

				if GetMapName() == "imba_demo" then return end
				if api:GetDonatorStatus(npc:GetPlayerID()) ~= 6 then
					Timers:CreateTimer(1.5, function()
						Battlepass:DonatorCompanion(npc:GetPlayerID(), api:GetPlayerCompanion(npc:GetPlayerID()))
					end)
				end
			end
		end

		CustomGameEventManager:Send_ServerToAllClients("override_hero_image", {
			hero_name = string.gsub(npc:GetUnitName(), "npc_dota_hero_", ""),
		})
	end
end, nil)
