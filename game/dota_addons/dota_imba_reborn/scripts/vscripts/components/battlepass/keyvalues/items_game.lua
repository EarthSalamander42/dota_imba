ItemsGame = ItemsGame or class({})

function ItemsGame:Init()
	ItemsGame.kv = LoadKeyValues("scripts/items/items_game.txt")

--	for k, v in pairs(ItemsGame.kv) do
--		print(k, v)
--	end
end

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
"asset_modifier" // FInd a way to replace voicelines? new custom hero with a voicelines lib?
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

function ItemsGame:GetItemKV(item_id)
	return ItemsGame.kv["items"][item_id]
end

ItemsGame:Init()

print("Axe Unleashed KV:")
PrintTable(ItemsGame:GetItemKV("12964"))
