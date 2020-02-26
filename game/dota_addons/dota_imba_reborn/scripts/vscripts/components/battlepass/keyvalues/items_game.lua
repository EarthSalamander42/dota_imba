--[[
todo: create a kv file with every heroes basic particles that needs to be replaced.
then create a table of required particles, update entry for a required spell particle,
if BP level is enough to have the new reward!
--]]

--[[ useful variables:

"name"				"Fists of Axe Unleashed" // static english name
"image_inventory"	"image_path"
"item_description"	"desc_tooltip"
"item_name"			"name_tooltip"
"item_rarity"		"immortal"
"model_player"		"item_model_path.vmdl" // cosmetic model

"used_by_heroes"
{
	"npc_dota_hero_axe"			"1"
}

"asset_modifier" // New model for hero
{
	"type"		"entity_model"
	"asset"		"npc_dota_hero_axe"
	"modifier"		"models/items/axe/ti9_jungle_axe/axe_bare.vmdl"
}
"asset_modifier" // ModelScale
{
	"type"		"entity_scale"
	"asset"		"npc_dota_hero_axe"
	"scale_size"		"1.030000"
}
"asset_modifier" // Animation activity translations
{
	"type"		"activity"
	"asset"		"ALL"
	"modifier"		"ti9"
}
"asset_modifier" // Hero ambient particle to add
{
	"type"		"particle_create"
	"modifier"		"particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_misc_ambient.vpcf"
	"style"		"0"
}
"asset_modifier" // Base ability particle vs new particle to replace with
{
	"type"		"particle"
	"asset"		"particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
	"modifier"		"particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_kill.vpcf"
	"style"		"0"
}
"asset_modifier" // GetAttackSound replacement
{
	"type"		"sound"
	"asset"		"Hero_Axe.Attack"
	"modifier"		"Hero_Axe.Attack.Jungle"
	"style"		"0"
}
"asset_modifier" // Find a way to replace voicelines? new custom hero with a voicelines lib?
{
	"type"		"response_criteria"
	"asset"		"jungle_axe"
}
"asset_modifier" // Minimap icon (can't be replaced dynamically afaik)
{
	"type"		"icon_replacement_hero"
	"asset"		"npc_dota_hero_axe"
	"modifier"		"npc_dota_hero_axe_alt"
	"force_display"		"1"
	"style"		"0"
}
"asset_modifier"
{
	"type"		"ability_icon"
	"asset"		"axe_counter_helix"
	"modifier"		"axe_counter_helix_unleashed"
	"style"		"0"
}
--]]

ItemsGame = ItemsGame or class({})

function ItemsGame:Init()
	ItemsGame.kv = LoadKeyValues("scripts/items/items_game.txt")
	ItemsGame.custom_kv = LoadKeyValues("scripts/vscripts/components/battlepass/keyvalues/items.txt")
	ItemsGame.battlepass = {}
	ItemsGame.companions = {}

	local count = 1
	local bp_reward_table = {}

	while ItemsGame.custom_kv[tostring(count)] do
		local itemKV = ItemsGame.custom_kv[tostring(count)]

		if itemKV.item_type == "courier" then
			if not itemKV.item_name then
				itemKV.item_name = ItemsGame:GetItemName(count)
			end

			table.insert(ItemsGame.companions, itemKV)
		else
			local reward_table = {}
			reward_table.image = ItemsGame:GetItemImage(count)
			reward_table.level = ItemsGame:GetItemUnlockLevel(count)
			reward_table.name = ItemsGame:GetItemName(count)
			reward_table.rarity = ItemsGame:GetItemRarity(count)
			reward_table.type = ItemsGame:GetItemType(count)
			reward_table.item_id = tostring(count)
			reward_table.slot_id = ItemsGame:GetItemSlot(count)
			reward_table.hero = ItemsGame:GetItemHero(count)

			table.insert(bp_reward_table, count, reward_table)
		end

		count = count + 1
	end

	-- bubble sort by level
	ItemsGame.battlepass = BubbleSortByElement(bp_reward_table, "level")

	CustomNetTables:SetTableValue("battlepass", "rewards", {ItemsGame.battlepass})
	CustomNetTables:SetTableValue("battlepass", "companions", {ItemsGame.companions})
end

function ItemsGame:GetItemKV(item_id)
	if type(item_id) ~= "string" then item_id = tostring(item_id) end

	if ItemsGame.custom_kv[tostring(item_id)] then
		return ItemsGame.custom_kv[tostring(item_id)]
	end
end

-- Item ID (custom id, not items_game.txt id), string / table name to return, return override
function ItemsGame:GetItemInfo(item_id, category, return_override)
	if type(item_id) ~= "string" then item_id = tostring(item_id) end

	if ItemsGame:GetItemKV(item_id)[category] then
		return ItemsGame:GetItemKV(item_id)[category]
	end

	if return_override then
		if return_override == "nope" then
			return nil
		else
			return return_override
		end
	else
		local vanilla_item_id = tostring(ItemsGame:GetItemKV(item_id).item_id)

		if ItemsGame.kv["items"][vanilla_item_id] and ItemsGame.kv["items"][vanilla_item_id][category] then
			return ItemsGame.kv["items"][vanilla_item_id][category]
		else
			return nil
		end
	end
end

function ItemsGame:GetItemID(item_id)
	return self:GetItemInfo(item_id, "item_id")
end

function ItemsGame:GetItemTeam(item_id)
	return self:GetItemInfo(item_id, "item_team", "radiant")
end

function ItemsGame:GetItemImage(item_id)
	return self:GetItemInfo(item_id, "image_inventory")
end

function ItemsGame:GetItemUnlockLevel(item_id)
	return self:GetItemInfo(item_id, "item_unlock_level", 1)
end

function ItemsGame:GetItemName(item_id)
	return self:GetItemInfo(item_id, "item_name")
end

function ItemsGame:GetItemVisuals(item_id)
	return self:GetItemInfo(item_id, "visuals")
end

function ItemsGame:GetItemName(item_id)
	return self:GetItemInfo(item_id, "item_name")
end

function ItemsGame:GetItemRarity(item_id)
	return self:GetItemInfo(item_id, "item_rarity")
end

function ItemsGame:GetItemType(item_id)
	return self:GetItemInfo(item_id, "item_type", "nope")
end

function ItemsGame:GetItemModifier(item_id)
	return self:GetItemInfo(item_id, "modifier")
end

function ItemsGame:GetItemWearables(item_id)
	if self:GetItemType(item_id) == "bundle" then
		return self:GetItemInfo(item_id, "wearables", {})
	elseif self:GetItemType(item_id) == "wearable" then
		local callback = {}
		callback[self:GetItemID(item_id)] = self:GetItemSlot(item_id)
		return callback
	end
end

function ItemsGame:GetItemSlot(item_id)
	return self:GetItemInfo(item_id, "item_slot")
end

function ItemsGame:GetItemHero(item_id)
	local item_info = self:GetItemInfo(item_id, "used_by_heroes")

	if item_info then
		if type(item_info) == "table" then
			for k, v in pairs(item_info) do
				return k
			end
		else
			return item_info
		end
	end
end

function ItemsGame:GetItemModel(item_id)
	if type(item_id) ~= "string" then item_id = tostring(item_id) end

	local item_team = ItemsGame:GetItemTeam(item_id)
	local item_type = ItemsGame:GetItemType(item_id)
	local item_visuals = ItemsGame:GetItemVisuals(item_id)

	if item_visuals then
		for k, v in pairs(item_visuals) do
			print(v["asset"], item_team)
			print(v["type"], item_type)
			if v["asset"] and v["asset"] == item_team then
				if v["type"] and v["type"] == item_type then
					print("FOUND MODEL:", v["modifier"])
					return v["modifier"]
				end
			end
		end
	end

	return nil
end

ItemsGame:Init()
