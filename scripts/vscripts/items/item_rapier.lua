--[[	Author: d2imba
		Date:	16.05.2015	]]

function RapierPickUp( keys )
	local caster = keys.caster
	local ability = keys.ability
	local rapier_level = keys.rapier_level
	
	-- If a rapier was already picked up, do nothing
	if caster.rapier_picked_up then
		return nil
	end

	-- Double pick-up safety variable
	caster.rapier_picked_up = true
	Timers:CreateTimer(0.01, function()
		caster.rapier_picked_up = nil
	end)
	
	-- Calculate total rapier level carried by the owner
	for i = 0, 5 do
		local item = caster:GetItemInSlot(i)

		for j = 1, 10 do
			if item and item:GetAbilityName() == ( "item_imba_rapier_"..j ) then
				caster:RemoveItem(item)
				item = nil
				rapier_level = rapier_level + j
			end
		end
	end

	-- Cap rapier level at 10
	rapier_level = math.min(rapier_level, 10)

	-- Remove this item
	caster:RemoveItem(ability)

	-- Create appropriate level rapier
	if caster:HasAnyAvailableInventorySpace() then
		caster:AddItem(CreateItem("item_imba_rapier_"..rapier_level, caster, caster))

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
		Notifications:BottomToAll({text = "#imba_player_rapier_pickup_01", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})
		Notifications:BottomToAll({text = rapier_level.." ", duration = line_duration, style = {color = level_color[rapier_level]}, continue = true})
		Notifications:BottomToAll({text = "#imba_player_rapier_pickup_02", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})

		-- Ping the location for both teams
		MinimapEvent(DOTA_TEAM_GOODGUYS, caster, caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, vision_duration)
		MinimapEvent(DOTA_TEAM_BADGUYS, caster, caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, vision_duration)
	else
		local drop = CreateItem("item_imba_rapier_"..rapier_level.."_dummy", nil, nil)
		CreateItemOnPositionSync(caster:GetAbsOrigin(), drop)
		drop:LaunchLoot(false, 250, 0.5, caster:GetAbsOrigin())
	end
end

function RapierDamage( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = keys.damage

	-- If the target is Roshan, a building, or an ally, or if the caster is an invulnerable storm spirit, do nothing
	if target:IsBuilding() or IsRoshan(target) or target:GetTeam() == caster:GetTeam() or (caster:IsInvulnerable() and caster:GetName() == "npc_dota_hero_storm_spirit") then
		return nil
	end

	-- Parameters
	local damage_amplify = ability:GetLevelSpecialValueFor("damage_amplify", ability_level) / 100
	local distance_taper_start = ability:GetLevelSpecialValueFor("distance_taper_start", ability_level)
	local distance_taper_end = ability:GetLevelSpecialValueFor("distance_taper_end", ability_level)

	-- Scale damage bonus according to distance
	local distance = ( target:GetAbsOrigin() - caster:GetAbsOrigin() ):Length2D()
	local distance_taper = 1
	if distance > distance_taper_start and distance < distance_taper_end then
		distance_taper = distance_taper * ( 0.3 + ( distance_taper_end - distance ) / ( distance_taper_end - distance_taper_start ) * 0.7 )
	elseif distance >= distance_taper_end then
		distance_taper = 0.3
	end
	damage_amplify = damage_amplify * distance_taper

	-- Deal extra damage
	caster:RemoveModifierByName("modifier_item_imba_rapier_damage")
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage * damage_amplify, damage_type = DAMAGE_TYPE_PURE})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_imba_rapier_damage", {})
end

function RapierDrop( keys )
	local caster = keys.caster
	local ability = keys.ability
	local rapier_name = keys.rapier_name
	local caster_pos = caster:GetAbsOrigin()

	-- Remove the rapiers from the player's inventory
	for i = 0, 5 do
		local item = caster:GetItemInSlot(i)

		for j = 1, 10 do
			if item and item:GetAbilityName() == ( "item_imba_rapier_"..j ) then
				caster:RemoveItem(item)
				item = nil
				local drop = CreateItem("item_imba_rapier_"..j.."_dummy", nil, nil)
				CreateItemOnPositionSync(caster:GetAbsOrigin(), drop)
				drop:LaunchLoot(false, 250, 0.5, caster:GetAbsOrigin())

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