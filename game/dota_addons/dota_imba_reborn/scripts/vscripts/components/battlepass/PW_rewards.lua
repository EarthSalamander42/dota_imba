BATTLEPASS_LEVEL_REWARD = {}
BATTLEPASS_LEVEL_REWARD[5]		= {"hook", "rare"} -- Broilers Hook
BATTLEPASS_LEVEL_REWARD[10]		= {"streak_counter", "arcana"}
BATTLEPASS_LEVEL_REWARD[15]		= {"hook2", "mythical"} -- Blood Drainer Hook
BATTLEPASS_LEVEL_REWARD[25]		= {"hook3", "mythical"} -- Sorrowful Prey Hook
BATTLEPASS_LEVEL_REWARD[35]		= {"hook4", "rare"} -- Ol'Choppers Hook
BATTLEPASS_LEVEL_REWARD[45]		= {"hook5", "uncommon"} -- Force Hook
BATTLEPASS_LEVEL_REWARD[50]		= {"pudge_arcana", "arcana"} -- (Red)
BATTLEPASS_LEVEL_REWARD[55]		= {"hook6", "immortal"} -- Ripper's Reel
BATTLEPASS_LEVEL_REWARD[65]		= {"hook7", "mythical"} -- Whale Hook
BATTLEPASS_LEVEL_REWARD[75]		= {"hook8", "immortal"} -- Dragonclaw Hook
BATTLEPASS_LEVEL_REWARD[100]	= {"pudge_arcana2", "arcana"} -- (Green)

CustomNetTables:SetTableValue("game_options", "battlepass", {battlepass = BATTLEPASS_LEVEL_REWARD})

function Battlepass:Init()
	BATTLEPASS_HOOK = {}
	BATTLEPASS_STREAK_COUNTER = {}

	for k, v in pairs(BATTLEPASS_LEVEL_REWARD) do
		if string.find(v[1], "hook") then
			BATTLEPASS_HOOK[v[1]] = k
		elseif string.find(v[1], "streak_counter") then
			BATTLEPASS_STREAK_COUNTER[v[1]] = k
		end
	end

	BattlepassHeroes = {}
	BattlepassHeroes["pudge"] = {}

	BattlepassItems = {}
--	BattlepassItems["blink"] = {}

	for k, v in pairs(BATTLEPASS_LEVEL_REWARD) do
		local required_level = k
		local reward_name = v[1]
		local category = string.gsub(reward_name, "%d", "")
		local reward_level = string.gsub(reward_name, "%D", "")

		for i, j in pairs(BattlepassHeroes) do
			local hero_name = i

			if string.find(reward_name, hero_name) then
				BattlepassHeroes[hero_name][reward_name] = required_level
				break
			end
		end

--		print(required_level, category, reward_level)
		if BattlepassItems[category] then
			if reward_level == "" then reward_level = 1 end
			table.insert(BattlepassItems[category], tonumber(reward_level), required_level)
		end
	end

end

--[[ -- instead of a flat BattlepassHeroes[hero_name] value, generate it by finding if there's a hero name in all reward names
function Battlepass:IsHeroName(hero_name)
	local herolist = LoadKeyValues("scripts/npc/herolist.txt")

	print(herolist[hero_name])
	if herolist[hero_name] then
		return true
	end

	return false
end
--]]

function Battlepass:SetItemEffects(hero)
	Battlepass:GetPudgeHook(hero)
	Battlepass:GetPudgeArcanaEffect(hero)
end

function Battlepass:GetPudgeHook(hero)
	local hook_model = "models/heroes/pudge/righthook.vmdl"
	local hook_pfx = "particles/pw/ref_pudge_meathook_chain.vpcf"

	-- List of Hooks upgrades
	--[[
		"models/items/pudge/harpoon_hook/mesh/harpoon_hook.vmdl" (default, witness, gold)
	--]]

	-- List of Hooks Effects
	--[[
		"particles/econ/items/pudge/pudge_arcana/pudge_arcana_back_ambient_hook_fire.vpcf"
	--]]

	if Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_HOOK["hook8"] then
		hook_model = "models/items/pudge/pudge_skeleton_hook_body.vmdl"
		hook_pfx = "particles/pw/ref_pudge_meathook_chain_skeleton.vpcf"
	elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_HOOK["hook7"] then
		hook_model = "models/items/pudge/whale_hook.vmdl"
--		hook_pfx = ""
	elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_HOOK["hook6"] then
		hook_model = "models/items/pudge/harpoon_hook/mesh/harpoon_hook.vmdl"
--		hook_pfx = ""
	elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_HOOK["hook5"] then
		hook_model = "models/items/pudge/force_hook/force_hook.vmdl"
--		hook_pfx = ""
	elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_HOOK["hook4"] then
		hook_model = "models/items/pudge/the_ol_choppers_hook/the_ol_choppers_hook.vmdl"
--		hook_pfx = ""
	elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_HOOK["hook3"] then
		hook_model = "models/items/pudge/hook_of_the_sorrowful_prey/hook_of_the_sorrowful_prey.vmdl"
--		hook_pfx = ""
	elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_HOOK["hook2"] then
		hook_model = "models/items/pudge/blood_drainer_hook/blood_drainer_hook.vmdl"
--		hook_pfx = ""
	elseif Battlepass:GetRewardUnlocked(hero:GetPlayerID()) >= BATTLEPASS_HOOK["hook"] then
		hook_model = "models/items/pudge/butchersbroilers_hook/butchersbroilers_hook.vmdl"
--		hook_pfx = ""
	end

	if hero.hook == nil then
		hero.hook = SpawnEntityFromTableSynchronous("prop_dynamic", {model = hook_model})
		hero.hook:FollowEntity(hero, true)
	end

	hero.hook_model = hook_model
end

function Battlepass:GetPudgeArcanaEffect(hero)
	local has_arcana = Battlepass:HasArcana(hero:GetPlayerID(), "pudge")

	if has_arcana then
		if has_arcana == true then has_arcana = 1 end
--		hero:SetModel("models/items/pudge/arcana/pudge_arcana_base.vmdl")
--		hero:SetOriginalModel("models/items/pudge/arcana/pudge_arcana_base.vmdl")
--		hero:SetMaterialGroup(tostring(has_arcana))
		hero.pudge_arcana = has_arcana

--		local wearable = hero:GetTogglableWearable(DOTA_LOADOUT_TYPE_BACK)

--		if wearable then
--			wearable:AddEffects(EF_NODRAW)
--		end

--		hero.back = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/pudge/arcana/pudge_arcana_back.vmdl"})
--		hero.back:FollowEntity(hero, true)
--		hero.back:SetMaterialGroup(tostring(has_arcana))

--		local particle = "particles/econ/items/pudge/pudge_arcana/pudge_arcana_red_back_ambient.vpcf"	
--		local particle2 = "particles/econ/items/pudge/pudge_arcana/pudge_arcana_red_back_ambient_beam.vpcf"
--		if has_arcana >= 1 then
--			particle = "particles/econ/items/pudge/pudge_arcana/pudge_arcana_back_ambient.vpcf"
--			particle2 = "particles/econ/items/pudge/pudge_arcana/pudge_arcana_back_ambient_beam.vpcf"
--		end

--		ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, hero.back)
--		ParticleManager:CreateParticle(particle2, PATTACH_ABSORIGIN_FOLLOW, hero.back)
--		ParticleManager:CreateParticle("particles/econ/items/pudge/pudge_arcana/pudge_arcana_ambient_flies.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)

		Wearable:_WearProp(hero, "7756", "back", has_arcana)

		-- custom icons
--		hero:AddNewModifier(hero, nil, "modifier_battlepass_wearable_spellicons", {style = has_arcana})
	end
end

function Battlepass:HasPudgeHookStreakCounter(ID)
	if Battlepass:GetRewardUnlocked(ID) >= BATTLEPASS_STREAK_COUNTER["streak_counter"] then
		return true
	end

	return false
end
