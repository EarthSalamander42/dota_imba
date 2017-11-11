if companion_morph == nil then companion_morph = class({}) end

function companion_morph:OnSpellStart()
local companion = self:GetCaster()
local model = companion:GetModelName()

	if not string.find(model, "courier") then
		Notifications:Bottom(companion:GetPlayerOwnerID(), {text="Can't Morph with this companion!", duration=5, style={color="red"}})
		return
	end

	if string.find(model, "flying") then
		companion:SetModel(companion.base_model)
		companion:SetOriginalModel(companion.base_model)
		companion:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
		return
	else
		model = string.gsub(model, ".vmdl", "_flying.vmdl")
		companion:SetModel(model)
		companion:SetOriginalModel(model)
		companion:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
--		companion:AddNewModifier(companion, nil, "modifier_winter_wyvern_arctic_burn_flight", {}) -- CRASH LOL SO MUCH FUN FUCK YOU VOLVO BLYAT
	end
end
