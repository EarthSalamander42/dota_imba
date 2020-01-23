print("ITEMS GAME: INIT")

ItemsGame = ItemsGame or class({})

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

function ItemsGame:Init()
	print("ITEMS GAME: INIT 2")
	ItemsGame.kv = LoadKeyValues("scripts/items/items_game.txt")
	ItemsGame.custom_kv = LoadKeyValues("scripts/vscripts/components/battlepass/keyvalues/items.txt")

	for k, v in pairs(ItemsGame.custom_kv) do
		print(k, v)
	end
end

function ItemsGame:GetItemKV(item_id)
	return ItemsGame.kv["items"][item_id]
end

function ItemsGame:GetItemVisuals(item_id)
	return ItemsGame.kv["items"][item_id]["visuals"]
end

function ItemsGame:GetItemName(item_id)
	if ItemsGame.custom_kv[item_id] and ItemsGame.custom_kv[item_id]["item_name"] then
		return ItemsGame.custom_kv[item_id]["item_name"]
	end

	return ItemsGame.kv[item_id]["item_name"]
end

function ItemsGame:GetItemRarity(item_id)
	if ItemsGame.custom_kv[item_id] and ItemsGame.custom_kv[item_id]["item_rarity"] then
		return ItemsGame.custom_kv[item_id]["item_rarity"]
	end

	return ItemsGame.kv[item_id]["item_rarity"]
end

function ItemsGame:GetItemType(item_id)
	if ItemsGame.custom_kv[item_id] and ItemsGame.custom_kv[item_id]["item_type"] then
		return ItemsGame.custom_kv[item_id]["item_type"]
	end

	return nil
end

function ItemsGame:GetItemTeam(item_id)
	if ItemsGame.custom_kv[item_id] and ItemsGame.custom_kv[item_id]["item_team"] then
		return ItemsGame.custom_kv[item_id]["item_team"]
	end

	return "radiant" -- let's default to radiant for now
end

function ItemsGame:GetItemModel(item_id)
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

--[[
function GetItemInfo(item_id)
	local info = {}
	info.rarity = ItemsGame:GetItemRarity()

	return info
end
--]]

ItemsGame:Init()

-- print("Antipode Couriers KV:")
-- PrintTable(ItemsGame:GetItemKV("10888"))
-- print(ItemsGame:GetItemModel("10888"))
