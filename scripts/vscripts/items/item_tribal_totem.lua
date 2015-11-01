--[[ ============================================================================================================
	Author: Penguinwizzard
	Date: November 1, 2015
	Called when Tribal Totem is cast to create the totem.
================================================================================================================= ]]

function create_totem(keys)
	if keys.caster.totem ~= nil then
		return
	end
	local myteam = keys.caster:GetTeam()
	local candidate = nil
	candidate = Entities:FindByClassname(nil,"ent_dota_fountain")
	while candidate ~= nil and candidate:GetTeam() ~= myteam do
		candidate = Entities:FindByClassname(candidate,"ent_dota_fountain")
		print("iterated candidate")
	end
	-- Spawn the totem next to the fountain if possible, if not then spawn at the caster
	local location
	if candidate == nil then
		location = keys.caster:GetAbsOrigin()
	else
		location = candidate:GetAbsOrigin()
	end
	local unit = CreateUnitByName("npc_imba_tribal_totem", location, true, keys.caster, keys.caster, myteam)
	unit:SetControllableByPlayer(keys.caster:GetPlayerID(),true)
	keys.caster.totem = unit
	keys.caster:RemoveItemByName("item_imba_tribal_totem")
end

--[[ ============================================================================================================
	Author: Penguinwizzard
	Date: November 1, 2015
	Called when the creator of the Tribal Totem does stuff - then itemizes their summons.
================================================================================================================= ]]

function trigger_totem(keys)
	if keys.caster.totem == nil then
		return
	end
	local units = FindUnitsInRadius(keys.caster:GetTeam(),
					Vector(0,0,0),
					nil,
					FIND_UNITS_EVERYWHERE,
					DOTA_UNIT_TARGET_TEAM_FRIENDLY,
					DOTA_UNIT_TARGET_ALL,
					DOTA_UNIT_TARGET_FLAG_NONE,
					FIND_ANY_ORDER,
					false)
	local ourownerid = keys.caster:GetPlayerOwnerID()
	local ouritems = {}
	for i=0,5 do
		local item = keys.caster.totem:GetItemInSlot(i)
		if item ~= nil then
			local itemname = item:GetAbilityName()
			if itemname ~= "item_rapier" or itemname ~= "item_gem" then
				-- potentially need to add a few more to check here
				table.insert(ouritems,itemname)
			end
		end
	end
	for _,unit in pairs(units) do
		if unit.checked_totem == nil then
			unit.checked_totem = true
			if unit:IsSummoned() and unit:GetPlayerOwnerID() == ourownerid and not unit:HasInventory() then
				-- now to mirror items properly
				unit.shouldnotitem = true
				unit:SetCanSellItems(false)
				unit:SetHasInventory(true)
				for _,itemname in pairs(ouritems) do
					-- it'd be much better if we were able to actually use the same item instance on multiple units;
					-- unfortunately, that causes several issues
					-- they're not necessarily unfixable though
					unit:AddItemByName(itemname)
				end
			end
		end
	end
end
