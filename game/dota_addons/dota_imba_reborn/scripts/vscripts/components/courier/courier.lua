if TurboCourier == nil then
	TurboCourier = class({})
	TurboCourier.COURIER_PLAYER = {}
end

TurboCourier.courier_counter = {}
TurboCourier.courier_counter[2] = 1
TurboCourier.courier_counter[3] = 1

IMBA_TURBO_COURIER_POSITION = {}

IMBA_TURBO_COURIER_POSITION[2] = {}
IMBA_TURBO_COURIER_POSITION[2][1] = Vector(-7450, -6550, 256)
IMBA_TURBO_COURIER_POSITION[2][2] = Vector(-7350, -6650, 256)
IMBA_TURBO_COURIER_POSITION[2][3] = Vector(-7250, -6750, 256)
IMBA_TURBO_COURIER_POSITION[2][4] = Vector(-7150, -6850, 256)
IMBA_TURBO_COURIER_POSITION[2][5] = Vector(-7050, -6950, 256)
IMBA_TURBO_COURIER_POSITION[2][6] = Vector(-7325, -6425, 256)
IMBA_TURBO_COURIER_POSITION[2][7] = Vector(-7225, -6525, 256)
IMBA_TURBO_COURIER_POSITION[2][8] = Vector(-7125, -6625, 256)
IMBA_TURBO_COURIER_POSITION[2][9] = Vector(-7025, -6725, 256)
IMBA_TURBO_COURIER_POSITION[2][10] = Vector(-6925, -6825, 256)

IMBA_TURBO_COURIER_POSITION[3] = {}
IMBA_TURBO_COURIER_POSITION[3][1] = Vector(7400, 6500, 256)
IMBA_TURBO_COURIER_POSITION[3][2] = Vector(7300, 6600, 256)
IMBA_TURBO_COURIER_POSITION[3][3] = Vector(7200, 6700, 256)
IMBA_TURBO_COURIER_POSITION[3][4] = Vector(7100, 6800, 256)
IMBA_TURBO_COURIER_POSITION[3][5] = Vector(7000, 6900, 256)
IMBA_TURBO_COURIER_POSITION[3][6] = Vector(7275, 6375, 256)
IMBA_TURBO_COURIER_POSITION[3][7] = Vector(7175, 6475, 256)
IMBA_TURBO_COURIER_POSITION[3][8] = Vector(7075, 6575, 256)
IMBA_TURBO_COURIER_POSITION[3][9] = Vector(6975, 6675, 256)
IMBA_TURBO_COURIER_POSITION[3][10] = Vector(6875, 6775, 256)

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
		if Entities:FindByClassname(nil, "info_courier_spawn_radiant") == nil then return end
		local pos = Entities:FindByClassname(nil, "info_courier_spawn_radiant"):GetAbsOrigin()

		if hero:GetTeamNumber() == 3 then
			pos = Entities:FindByClassname(nil, "info_courier_spawn_dire"):GetAbsOrigin()
		end

		TurboCourier:Spawn(hero, pos)
	end
end

function TurboCourier:Spawn(hero, pos)
	self.COURIER_PLAYER[hero:GetPlayerID()] = CreateUnitByName("npc_dota_courier", pos, true, nil, nil, hero:GetTeam())
	self.COURIER_PLAYER[hero:GetPlayerID()]:UpgradeToFlyingCourier()

	self.COURIER_PLAYER[hero:GetPlayerID()]:SetControllableByPlayer(hero:GetPlayerID(), true)
	self.COURIER_PLAYER[hero:GetPlayerID()]:SetOwner(hero)
	self.COURIER_PLAYER[hero:GetPlayerID()]:RemoveModifierByName("modifier_magic_immune")
	self.COURIER_PLAYER[hero:GetPlayerID()]:RemoveAbility("courier_morph")
	self.COURIER_PLAYER[hero:GetPlayerID()]:RemoveAbility("courier_shield")
	local autodeliver = self.COURIER_PLAYER[hero:GetPlayerID()]:AddAbility("imba_courier_autodeliver")
	autodeliver:SetLevel(1)
--	autodeliver:ToggleAbility()
	self.COURIER_PLAYER[hero:GetPlayerID()]:AddAbility("courier_movespeed"):SetLevel(1)
	self.COURIER_PLAYER[hero:GetPlayerID()]:AddNewModifier(self.COURIER_PLAYER[hero:GetPlayerID()], nil, "modifier_invulnerable", {})
	self.COURIER_PLAYER[hero:GetPlayerID()]:SetDayTimeVisionRange(0)
	self.COURIER_PLAYER[hero:GetPlayerID()]:SetNightTimeVisionRange(0)
	self.COURIER_PLAYER[hero:GetPlayerID()].courier_count = self.courier_counter[hero:GetTeamNumber()]
	self.courier_counter[hero:GetTeamNumber()] = self.courier_counter[hero:GetTeamNumber()] + 1
end
