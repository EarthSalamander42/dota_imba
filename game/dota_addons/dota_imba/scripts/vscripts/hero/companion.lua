-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Editors:
--     Cookies, 01.2016
--     suthernfriend, 03.02.2018

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
