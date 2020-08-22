if not TurboCourier then
	TurboCourier = class({})
end

TurboCourier.COURIER_PLAYER = {}
TurboCourier.courier_counter = {}
TurboCourier.courier_counter[2] = 1
TurboCourier.courier_counter[3] = 1

TURBO_COURIER_POSITION = {}

TURBO_COURIER_POSITION[2] = {}
TURBO_COURIER_POSITION[3] = {}

TURBO_COURIER_POSITION[2][1] = Vector(-7450, -6550, 256)
TURBO_COURIER_POSITION[2][2] = Vector(-7350, -6650, 256)
TURBO_COURIER_POSITION[2][3] = Vector(-7250, -6750, 256)
TURBO_COURIER_POSITION[2][4] = Vector(-7150, -6850, 256)
TURBO_COURIER_POSITION[2][5] = Vector(-7050, -6950, 256)
TURBO_COURIER_POSITION[2][6] = Vector(-7450, -6450, 256)
TURBO_COURIER_POSITION[2][7] = Vector(-7350, -6550, 256)
TURBO_COURIER_POSITION[2][8] = Vector(-7250, -6650, 256)
TURBO_COURIER_POSITION[2][9] = Vector(-7150, -6750, 256)
TURBO_COURIER_POSITION[2][10] = Vector(-7050, -6850, 256)

TURBO_COURIER_POSITION[3][1] = Vector(7400, 6500, 256)
TURBO_COURIER_POSITION[3][2] = Vector(7300, 6600, 256)
TURBO_COURIER_POSITION[3][3] = Vector(7200, 6700, 256)
TURBO_COURIER_POSITION[3][4] = Vector(7100, 6800, 256)
TURBO_COURIER_POSITION[3][5] = Vector(7000, 6900, 256)
TURBO_COURIER_POSITION[3][6] = Vector(7400, 6400, 256)
TURBO_COURIER_POSITION[3][7] = Vector(7300, 6500, 256)
TURBO_COURIER_POSITION[3][8] = Vector(7200, 6600, 256)
TURBO_COURIER_POSITION[3][9] = Vector(7100, 6700, 256)
TURBO_COURIER_POSITION[3][10] = Vector(7000, 6800, 256)

ListenToGameEvent("npc_spawned", function(keys)
	if USE_TEAM_COURIER == true or USE_TEAM_COURIER == nil then return end

	local hero = EntIndexToHScript(keys.entindex)
	
	if hero.GetPlayerID and not TurboCourier.COURIER_PLAYER[hero:GetPlayerID()] then
		Timers:CreateTimer(0.1, function()
			if hero:IsRealHero() and not hero:IsIllusion() then
				TurboCourier:SpawnTurboCourier(hero, TURBO_COURIER_POSITION[hero:GetTeamNumber()][TurboCourier.courier_counter[hero:GetTeamNumber()]])
			end
		end)
	end
end, nil)

function TurboCourier:SpawnTurboCourier(hero, pos)
	local heroID = hero:GetPlayerID()

	-- if not heroID or not self.COURIER_PLAYER[heroID] then return end

	self.COURIER_PLAYER[heroID] = CreateUnitByName("npc_dota_courier", pos, true, nil, nil, hero:GetTeam())
	self.COURIER_PLAYER[heroID].courier_count = self.courier_counter[hero:GetTeamNumber()]
	self.courier_counter[hero:GetTeamNumber()] = self.courier_counter[hero:GetTeamNumber()] + 1
	self.COURIER_PLAYER[heroID].return_position = pos

	-- Let's give 'em different colours...
	if PLAYER_COLORS and PLAYER_COLORS[heroID] then
		self.COURIER_PLAYER[heroID]:SetRenderColor(PLAYER_COLORS[heroID][1], PLAYER_COLORS[heroID][2], PLAYER_COLORS[heroID][3])
		-- This spams the hell out of CLocalize console which makes it hard to debug
		-- self.COURIER_PLAYER[heroID]:SetCustomHealthLabel(PlayerResource:GetPlayerName(heroID), PLAYER_COLORS[heroID][1], PLAYER_COLORS[heroID][2], PLAYER_COLORS[heroID][3])
	end

	self.COURIER_PLAYER[heroID]:SetOwner(hero)
	self.COURIER_PLAYER[heroID]:SetControllableByPlayer(hero:GetPlayerID(), true)
	self.COURIER_PLAYER[heroID]:RemoveModifierByName("modifier_magic_immune")
	self.COURIER_PLAYER[heroID]:AddAbility("courier_movespeed")

	if self.COURIER_PLAYER[heroID]:HasAbility("courier_shield") then
		self.COURIER_PLAYER[heroID]:RemoveAbility("courier_shield")
		-- self.COURIER_PLAYER[heroID]:AddAbility("courier_autodeliver_override")
	end

	for i = 0, 24 do
		local ability = self.COURIER_PLAYER[heroID]:GetAbilityByIndex(i)

		if ability and ability:GetLevel() == 0 then
			ability:SetLevel(1)
		end
	end

	self.COURIER_PLAYER[heroID]:SetDayTimeVisionRange(0)
	self.COURIER_PLAYER[heroID]:SetNightTimeVisionRange(0)
end
