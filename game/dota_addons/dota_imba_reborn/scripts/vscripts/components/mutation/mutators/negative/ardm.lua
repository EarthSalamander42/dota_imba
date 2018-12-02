local i = 0 -- hero count
local ardm_heroes = {}

function Mutation:ARDM()
	for hero, keys in pairs(KeyValues.HeroKV) do
		if hero ~= "Version" and hero ~= FORCE_PICKED_HERO and hero ~= "npc_dota_hero_arc_warden" and hero ~= "npc_dota_hero_lone_druid" and hero ~= "npc_dota_hero_meepo" and hero ~= "npc_dota_hero_monkey_king" then
--			if api.imba.hero_is_disabled(hero) == false then
--				table.insert(ardm_heroes, hero)
--				i = i + 1
--			end
		end
	end

	Timers:CreateTimer(2.0, function()
		GameRules:GetGameModeEntity():SetHUDVisible(0, true)
		GameRules:GetGameModeEntity():SetHUDVisible(1, true)
		CustomGameEventManager:Send_ServerToAllClients("ardm_ui", {visibility = "visible"})
		CustomGameEventManager:Send_ServerToAllClients("send_mutations", IMBA_MUTATION)
		CustomGameEventManager:Send_ServerToAllClients("update_mutations", {})
	end)

	local precache_counter = 0
	Timers:CreateTimer(3.0, function()
		for _, hero in pairs(ardm_heroes) do
			PrecacheUnitByNameAsync(hero, function()
				precache_counter = precache_counter + 1
				CustomGameEventManager:Send_ServerToAllClients("hero_selection_precache", {count = precache_counter, max_count = i})
			end)
		end
	end)
end

function Mutation:ARDMReplacehero(old_hero)
	local change_companion = false

	if old_hero.companion then
		old_hero.companion:ForceKill(false)
		change_companion = true
	end

	local random_int = RandomInt(1, #ardm_heroes)
	local random_hero = ardm_heroes[random_int]
	local old_gold = old_hero:GetGold()
	local hero = PlayerResource:ReplaceHeroWith(old_hero:GetPlayerID(), random_hero, 0, 0)
	Mutation:ARDMRemoveHeroFromTable(hero:GetUnitName())
	Mutation:OnHeroFirstSpawn(hero)

	if change_companion == true then
		local steam_id = tostring(PlayerResource:GetSteamID(hero:GetPlayerID()))
		DonatorCompanion(hero:GetPlayerID(), api.imba.get_player_info(steam_id).companion_file)
	end

	if old_hero:HasModifier("modifier_item_imba_moon_shard_active") then
		hero:AddNewModifier(hero, nil, "modifier_item_imba_moon_shard_active", {}):SetStackCount(old_hero:FindModifierByName("modifier_item_imba_moon_shard_active"):GetStackCount())
	end

	if old_hero:HasModifier("modifier_item_ultimate_scepter_consumed") then
		hero:AddNewModifier(hero, nil, "modifier_item_ultimate_scepter_consumed", {})
	end

	for itemSlot = 0, 15 do
		local item = old_hero:GetItemInSlot(itemSlot)
		if item then
			local newItem = CreateItem(item:GetName(), hero, hero)
			newItem:SetCurrentCharges(item:GetCurrentCharges())
			newItem:StartCooldown(item:GetCooldownTimeRemaining())
			hero:AddItem(newItem)
		end
	end

	hero:ModifyGold(old_gold, true, DOTA_ModifyGold_Unspecified)
	hero:AddExperience(old_hero:GetCurrentXP(), false, false)
	hero.killstreak = 0
	hero:AddNewModifier(hero, nil, "modifier_custom_mechanics", {})
--	PlayerResource:SetCustomPlayerColor(old_hero:GetPlayerID(), PLAYER_COLORS[old_hero:GetPlayerID()][1], PLAYER_COLORS[old_hero:GetPlayerID()][2], PLAYER_COLORS[old_hero:GetPlayerID()][3])
	hero:InitializeInnateAbilities()
	hero:SetupHealthBarLabel()
	hero.first_spawn = true

	-- Initialize Invoker's innate invoke buff
	-- TODO: This should be removed when another solution is found, like giving Invoker a hidden passive ability to apply the modifier
	if hero:HasAbility("invoker_invoke") then
		LinkLuaModifier("modifier_imba_invoke_buff", "components/modifiers/modifier_imba_invoke_buff.lua", LUA_MODIFIER_MOTION_NONE)
		hero:AddNewModifier(hero, hero:FindAbilityByName("invoker_invoke"), "modifier_imba_invoke_buff", {})
	end

	Timers:CreateTimer(1.0, function()
		if old_hero then
			UTIL_Remove(old_hero)
		end
	end)
end

function Mutation:ARDMRemoveHeroFromTable(hero_name)
	for key, value in pairs(ardm_heroes) do
		if hero_name == value then
			table.remove(ardm_heroes, key)
			print("Removed "..hero_name.." from ARDM table!")
			break
		end
	end

	PrintTable(ardm_heroes)
end
