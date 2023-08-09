HeroSelection = HeroSelection or class({})

CustomGameEventManager:RegisterListener("imba_random", Dynamic_Wrap(GameMode, "PreventBannedHeroToBeRandomed"))

-- available heroes
local herolist = {}
HeroSelection.imbalist = {}
local newlist = {}
local customlist = {}
local totalheroes = 0

-- list all available heroes and get their primary attrs, and send it to client
HeroSelection.spawnedHeroes = {}
HeroSelection.spawnedPlayers = {}
HeroSelection.attemptedSpawnPlayers = {}

local herolistFile = "scripts/npc/herolist.txt"

for key, value in pairs(LoadKeyValues(herolistFile)) do
	if KeyValues.HeroKV[key] == nil then -- Cookies: If the hero is not in custom file, load vanilla KV's
		-- print(key .. " is not in custom file!")
		local data = LoadKeyValues("scripts/npc/npc_heroes.txt")

		if data and data[key] then
			KeyValues.HeroKV[key] = data[key]
		end
	end

	herolist[key] = KeyValues.HeroKV[key].AttributePrimary

	if KeyValues.HeroKV[key].IsImba == 1 then
		HeroSelection.imbalist[key] = KeyValues.HeroKV[key].IsImba
	elseif KeyValues.HeroKV[key].IsNew == 1 then
		newlist[key] = KeyValues.HeroKV[key].IsNew
	elseif KeyValues.HeroKV[key].IsCustom == 1 then
		customlist[key] = KeyValues.HeroKV[key].IsCustom
	end

	totalheroes = totalheroes + 1
	assert(key ~= FORCE_PICKED_HERO, "FORCE_PICKED_HERO cannot be a pickable hero")
end

CustomNetTables:SetTableValue("hero_selection", "herolist", {
	gametype = GetMapName(),
	herolist = herolist,
	imbalist = HeroSelection.imbalist,
	newlist = newlist,
	customlist = customlist,
	hotdisabledlist = api:GetDisabledHeroes(),
})

-- utils
--[[
function HeroSelection:RandomImbaHero()
	local choice = HeroSelection:UnsafeRandomHero()

	for key, value in pairs(HeroSelection.imbalist) do
--		print(key, choice, self:IsHeroDisabled(choice))
		if key == choice and not self:IsHeroDisabled(choice) then
			return choice
		end
	end
end
--]]

function HeroSelection:UnsafeRandomHero()
	local curstate = 0
	local rndhero = RandomInt(0, totalheroes)

	for name, _ in pairs(herolist) do
		-- print(curstate, rndhero, name)
		if curstate == rndhero then
			for k, v in pairs(hotdisabledlist) do
				if k == name then
					-- print("Hero disabled! Try again!")
					return HeroSelection:UnsafeRandomHero()
				end
			end

			return name
		end

		curstate = curstate + 1
	end
end
