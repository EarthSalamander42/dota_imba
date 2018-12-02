if IMBA_PICK_SCREEN == true then
	require('components/hero_selection/hero_selection')
	require('libraries/hero_selection/event')
	require('libraries/hero_selection/fun')()
	require('libraries/hero_selection/functional')
	require('components/hero_selection/cmpickorder')
end

HeroSelection = class({})

-- available heroes
local herolist = {}
local imbalist = {}
local newlist = {}
local customlist = {}
local hotdisabledlist = {}
local totalheroes = 0

-- list all available heroes and get their primary attrs, and send it to client
function HeroSelection:Init()
	self.spawnedHeroes = {}
	self.spawnedPlayers = {}
	self.attemptedSpawnPlayers = {}

	local herolistFile = "scripts/npc/herolist/"..GetMapName()..".txt"

	for key,value in pairs(LoadKeyValues(herolistFile)) do
		if KeyValues.HeroKV[key] == nil then -- Cookies: If the hero is not in custom file, load vanilla KV's
--			print(key .. " is not in custom file!")
			local data = LoadKeyValues("scripts/npc/npc_heroes.txt")
			if data and data[key] then
				KeyValues.HeroKV[key] = data[key]
			end
		end

		herolist[key] = KeyValues.HeroKV[key].AttributePrimary

		if KeyValues.HeroKV[key].IsImba == 1 then
			imbalist[key] = KeyValues.HeroKV[key].IsImba
		elseif KeyValues.HeroKV[key].IsNew == 1 then
			newlist[key] = KeyValues.HeroKV[key].IsNew
		elseif KeyValues.HeroKV[key].IsCustom == 1 then
			customlist[key] = KeyValues.HeroKV[key].IsCustom
		end

--		if api.imba.hero_is_disabled(key) then
--			hotdisabledlist[key] = 1
--		end

		if value == 0 then
			hotdisabledlist[key] = 1
		else
			totalheroes = totalheroes + 1
			assert(key ~= FORCE_PICKED_HERO, "FORCE_PICKED_HERO cannot be a pickable hero")
		end
	end

--	if IsMutationMap() then
--		if IMBA_MUTATION["positive"] == "killstreak_power" then
--			hotdisabledlist["npc_dota_hero_zuus"] = 1
--		end

--		if IMBA_MUTATION["terrain"] == "speed_freaks" then
--			hotdisabledlist["npc_dota_hero_bloodseeker"] = 1
--			hotdisabledlist["npc_dota_hero_spirit_breaker"] = 1
--		end
--	end

	CustomNetTables:SetTableValue("hero_selection", "herolist", {
		gametype = GetMapName(),
		herolist = herolist,
		imbalist = imbalist,
		newlist = newlist,
		customlist = customlist,
		hotdisabledlist = hotdisabledlist,
		mutation = IMBA_MUTATION,
	})

	-- lock down the "pick" hero so that they can't do anything
	--	GameEvents:OnHeroInGame(function (npc)
	--		local playerId = npc:GetPlayerID()
	--		print("An NPC spawned " .. npc:GetUnitName())
	--		if npc:GetUnitName() == FORCE_PICKED_HERO then
	--			npc:AddNewModifier(nil, nil, "modifier_out_of_duel", nil)
	--			npc:AddNoDraw()
	--
	--			if self.attemptedSpawnPlayers[playerId] then
	--				self:GiveStartingHero(playerId, self.attemptedSpawnPlayers[playerId])
	--			end
	--		end
	--	end)
end

-- utils
function HeroSelection:RandomImbaHero()
	while true do
		local choice = HeroSelection:UnsafeRandomHero()

		for key, value in pairs(imbalist) do
--			print(key, choice, self:IsHeroDisabled(choice))
			if key == choice and not self:IsHeroDisabled(choice) then
				return choice
			end
		end
	end
end

function HeroSelection:UnsafeRandomHero()
	local curstate = 0
	local rndhero = RandomInt(0, totalheroes)

	for name, _ in pairs(herolist) do
--		print(curstate, rndhero, name)
		if curstate == rndhero then
			for k, v in pairs(hotdisabledlist) do
				if k == name then
--					print("Hero disabled! Try again!")
					return HeroSelection:UnsafeRandomHero()
				end
			end

			return name
		end

		curstate = curstate + 1
	end
end

local load_attachment_modifier = false
function HeroSelection:Attachments(hero)
	if load_attachment_modifier == false then
		load_attachment_modifier = true
		LinkLuaModifier( "modifier_animation_translate_permanent_string", "libraries/modifiers/modifier_animation_translate_permanent_string.lua", LUA_MODIFIER_MOTION_NONE )
	end

	hero_name = string.gsub(hero:GetUnitName(), "npc_dota_hero_", "")

	if hero_name == "sohei" then
		-- hero.hand = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/sohei/so_weapon.vmdl"})
		hero.hand = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/sohei/weapon/immortal/thunderlord.vmdl"})

		-- lock to bone
		hero.hand:FollowEntity(hero, true)

		-- hero:AddNewModifier(hero, nil, 'modifier_animation_translate_permanent_string', {translate = 'walk'})
		-- hero:AddNewModifier(hero, nil, 'modifier_animation_translate_permanent_string', {translate = 'odachi'})
		-- hero:AddNewModifier(hero, nil, 'modifier_animation_translate_permanent_string', {translate = 'aggressive'})
	end
end
