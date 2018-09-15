if TurboCourier == nil then
	TurboCourier = class({})
	TurboCourier.COURIER_PLAYER = {}
end

function TurboCourier:Init(hero)
	if GetMapName() == MapOverthrow() then
		local pos = nil
		for _, playerStart in pairs(Entities:FindAllByClassname("info_courier_spawn")) do
			if playerStart:GetTeam() == hero:GetTeam() then
				pos = playerStart:GetAbsOrigin()
				break
			end
		end

		if pos then
			TurboCourier:Spawn(hero, pos)
		end
	else
		local pos = Entities:FindByClassname(nil, "info_courier_spawn_radiant"):GetAbsOrigin()
		if hero:GetTeamNumber() == 3 then
			pos = Entities:FindByClassname(nil, "info_courier_spawn_dire"):GetAbsOrigin()
		end
		TurboCourier:Spawn(hero, pos)
--[[
		local courier = CreateItem("item_courier", hero, hero)
		courier:SetPurchaseTime( 0 )
		courier:SetPurchaser(hero)
		hero:AddItem(courier)

		for i = 0, DOTA_ITEM_MAX - 1 do
			local item = hero:GetItemInSlot(i)
			if item then
				if item:GetAbilityName() == "item_courier" then
					ExecuteOrderFromTable({
						UnitIndex = hero:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
						AbilityIndex = item:entindex(),
					})
					break
				end
			end
		end
--]]		
	end
end

function TurboCourier:Spawn(hero, pos)
	self.COURIER_PLAYER[hero:GetPlayerID()] = CreateUnitByName("npc_dota_courier", pos, true, nil, nil, hero:GetTeam())
	self.COURIER_PLAYER[hero:GetPlayerID()]:SetControllableByPlayer(hero:GetPlayerID(), true)
	self.COURIER_PLAYER[hero:GetPlayerID()]:RemoveAbility("courier_morph")
	self.COURIER_PLAYER[hero:GetPlayerID()]:RemoveAbility("courier_shield")
	self.COURIER_PLAYER[hero:GetPlayerID()]:AddAbility("courier_movespeed"):SetLevel(1)
end
