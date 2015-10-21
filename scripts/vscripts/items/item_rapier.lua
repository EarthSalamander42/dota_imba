--[[	Author: d2imba
		Date:	16.05.2015	]]

function RapierCombine( keys )
	local caster = keys.caster
	local this_rapier = keys.ability

	-- Search for rapiers in this unit's inventory
	for i = 0, 5 do
		local item = caster:GetItemInSlot(i)
		for j = 1, 9 do
			if item and item:GetAbilityName() == ( "item_imba_rapier_"..j ) then
				caster:RemoveItem(this_rapier)
				caster:RemoveItem(item)
				this_rapier = nil
				item = nil
				caster:AddItem(CreateItem("item_imba_rapier_"..(j+1), caster, caster))
				return nil
			end
		end
	end
end

function RapierDrop( keys )
	local caster = keys.caster
	local caster_pos = caster:GetAbsOrigin()

	-- Remove the rapiers from the player's inventory
	for i = 0, 5 do
		local item = caster:GetItemInSlot(i)

		for j = 1, 10 do
			if item and item:GetAbilityName() == ( "item_imba_rapier_"..j ) then
				caster:RemoveItem(item)
				item = nil

				-- Drop the necessary amount of Rapiers
				for k = 1, j do
					local drop = CreateItem("item_imba_rapier_1", nil, nil)
					CreateItemOnPositionSync(caster_pos, drop)
					drop:LaunchLoot(false, 250, 0.5, caster_pos + RandomVector(50))
				end

				-- Global message parameters
				local line_duration = 7
				local vision_duration = 5
				local level_color = {
					"#FFE5E5",
					"#FFCCCC",
					"#FFB2B2",
					"#FF9999",
					"#FF7F7F",
					"#FF6666",
					"#FF4C4C",
					"#FF3333",
					"#FF1A1A",
					"#FF0000"
				}

				-- Show global message
				Notifications:BottomToAll({hero = caster:GetName(), duration = line_duration})
				Notifications:BottomToAll({text = PlayerResource:GetPlayerName(caster:GetPlayerID()).." ", duration = line_duration, continue = true})
				Notifications:BottomToAll({text = "#imba_player_rapier_drop_01", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})
				Notifications:BottomToAll({text = j.." ", duration = line_duration, style = {color = level_color[j]}, continue = true})
				Notifications:BottomToAll({text = "#imba_player_rapier_drop_02", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})

				-- Ping and grant vision of the location for both teams
				caster:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, vision_duration)
				caster:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, vision_duration)
				MinimapEvent(DOTA_TEAM_GOODGUYS, caster, caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, vision_duration)
				MinimapEvent(DOTA_TEAM_BADGUYS, caster, caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, vision_duration)
			end
		end
	end
end