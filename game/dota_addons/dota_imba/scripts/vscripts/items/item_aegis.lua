--[[	Author: d2imba
		Date:	13.08.2015	]]

function AegisPickup( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_aegis = keys.modifier_aegis

	-- If an aegis was already picked up, do nothing
	if caster.aegis_picked_up then
		return nil
	end

	-- Double pick-up safety variable
	caster.aegis_picked_up = true
	Timers:CreateTimer(0.01, function()
		caster.aegis_picked_up = nil
	end)

	-- If this is not a real hero, drop another Aegis and exit
	if not caster:IsRealHero() then
		local drop = CreateItem("item_imba_aegis", nil, nil)
		CreateItemOnPositionSync(caster:GetAbsOrigin(), drop)
		drop:LaunchLoot(false, 250, 0.5, caster:GetAbsOrigin() + RandomVector(100))
		return nil
	end

	-- Display aegis pickup message for all players
	if not caster.has_aegis then
		Timers:CreateTimer(0.1, function()
			local line_duration = 7
			if caster.is_skeleton_king then
				Notifications:BottomToAll({image = "file://{images}/custom_game/skeleton_king_mini.png", duration = line_duration})
			else
				Notifications:BottomToAll({hero = caster:GetName(), duration = line_duration})
			end
			Notifications:BottomToAll({text = PlayerResource:GetPlayerName(caster:GetPlayerID()).." ", duration = line_duration, continue = true})
			Notifications:BottomToAll({text = "#imba_player_aegis_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})
		end)
	end

	-- Flag caster as an aegis holder
	caster.has_aegis = true

	-- Apply the Aegis holder modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_aegis, {})
end

function AegisHeal( keys )
	local caster = keys.caster
	local sound_heal = keys.sound_heal

	-- Play sound
	caster:EmitSound(sound_heal)

	-- Heal
	caster:Heal(caster:GetMaxHealth(), caster)
	caster:GiveMana(caster:GetMaxMana())

	-- Remove this item
	caster:RemoveItem(ability)

	-- Refresh all your abilities
	for i = 0, 15 do
		local current_ability = caster:GetAbilityByIndex(i)

		-- Refresh
		if current_ability then
			current_ability:EndCooldown()
		end
	end

	-- Flag caster as no longer having aegis
	caster.has_aegis = false
end