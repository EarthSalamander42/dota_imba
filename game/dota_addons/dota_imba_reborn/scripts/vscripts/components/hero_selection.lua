if not HeroSelection then
	HeroSelection = class({})
	HeroSelection.herolist = {}
	HeroSelection.imbalist = {}
end

ListenToGameEvent('game_rules_state_change', function()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		HeroSelection:Init()
	end
end, nil)

function HeroSelection:Init()
	local herolistFile = "scripts/npc/activelist.txt"

	for key,value in pairs(LoadKeyValues(herolistFile)) do
		if KeyValues.HeroKV[key] == nil then -- Cookies: If the hero is not in custom file, load vanilla KV's
--			print(key .. " is not in custom file!")
			local data = LoadKeyValues("scripts/npc/npc_heroes.txt")

			if data and data[key] then
				KeyValues.HeroKV[key] = data[key]
			end
		end

		HeroSelection.herolist[key] = KeyValues.HeroKV[key].AttributePrimary

		if KeyValues.HeroKV[key].IsImba == 1 then
			HeroSelection.imbalist[key] = 1
		end

		assert(key ~= FORCE_PICKED_HERO, "FORCE_PICKED_HERO cannot be a pickable hero")
	end

	CustomNetTables:SetTableValue("game_options", "herolist", {
		herolist = HeroSelection.herolist,
		imbalist = HeroSelection.imbalist,
	})
end
