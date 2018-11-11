require("components/overthrow/items")

-- Set up fountain regen
function GameMode:SetUpFountains()

	local fountainEntities = Entities:FindAllByClassname( "ent_dota_fountain")
	for _,fountainEnt in pairs( fountainEntities ) do
		fountainEnt:AddNewModifier( fountainEnt, fountainEnt, "modifier_fountain_aura_lua", {} )
		fountainEnt:AddAbility("imba_fountain_danger_zone"):SetLevel(1)

		-- remove vanilla fountain healing
		if fountainEnt:HasModifier("modifier_fountain_aura") then
			fountainEnt:RemoveModifierByName("modifier_fountain_aura")
			fountainEnt:AddNewModifier(fountainEnt, nil, "modifier_fountain_aura_lua", {})
		end
	end
end
