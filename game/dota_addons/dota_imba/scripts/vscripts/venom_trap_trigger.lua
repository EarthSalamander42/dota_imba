-- Copyright (C) 2018  The Dota IMBA Development Team
-- Copyright (C) 2015  bmddota
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
--     Firetoad
--     MouJiaoZi
--     Hewdraw
--     zimberzimer
--     Shush
--     Lindbrum
--     Earth Salamander #42
--     suthernfriend

--[[ venom_trap_trigger.lua ]]

local triggerActive = true

function OnStartTouch(trigger)
	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	local level = trigger.activator:GetLevel()
	--print("Trap Button Trigger Entered")
	if not triggerActive then
		print( "Trap Skip" )
		return
	end
	triggerActive = false
	local button = triggerName .. "_button"

	local model = triggerName .. "_model"
	local npc = Entities:FindByName( nil, triggerName .. "_npc" )
	local target = Entities:FindByName( nil, triggerName .. "_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison")
		npc:SetContextThink( "ResetButtonModel", function() ResetButtonModel() end, 4 )
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "fang_attack", .4, self, self )
	end

	local model1 = triggerName .. "_model1"
	local npc1 = Entities:FindByName( nil, triggerName .. "_npc1" )
	local target1 = Entities:FindByName( nil, triggerName .. "_target1" )
	if npc1 ~= nil then
		local venomTrap = npc1:FindAbilityByName("breathe_poison")
		--npc:SetContextThink( "ResetButtonModel", function() ResetButtonModel() end, 4 )
		npc1:CastAbilityOnPosition(target1:GetOrigin(), venomTrap, -1 )
		DoEntFire( model1, "SetAnimation", "fang_attack", .4, self, self )
	end

	local model2 = triggerName .. "_model2"
	local npc2 = Entities:FindByName( nil, triggerName .. "_npc2" )
	local target2 = Entities:FindByName( nil, triggerName .. "_target2" )
	if npc2 ~= nil then
		local venomTrap = npc2:FindAbilityByName("breathe_poison")
		--npc2:SetContextThink( "ResetButtonModel", function() ResetButtonModel() end, 4 )
		npc2:CastAbilityOnPosition(target2:GetOrigin(), venomTrap, -1 )
		DoEntFire( model2, "SetAnimation", "fang_attack", .4, self, self )
	end

	DoEntFire( button, "SetAnimation", "ancient_trigger001_down", 0, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_up", 4, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_idle", 4.5, self, self )

	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
	npc.KillerToCredit = heroHandle
end

function OnEndTouch(trigger)
	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	--print("Trap Button Trigger Exited")
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
end

function ResetButtonModel()
	print( "Trap RESET" )
	triggerActive = true
end

