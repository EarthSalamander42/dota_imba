
item_big_cheese_cavern = class({})

--[[
LinkLuaModifier( "modifier_item_big_cheese_cavern", "components/cavern/modifiers/modifier_item_big_cheese_cavern", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_big_cheese_cavern_effect", "components/cavern/modifiers/modifier_item_big_cheese_cavern_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_big_cheese_cavern:GetIntrinsicModifierName()
	return "modifier_item_big_cheese_cavern"
end
]]
