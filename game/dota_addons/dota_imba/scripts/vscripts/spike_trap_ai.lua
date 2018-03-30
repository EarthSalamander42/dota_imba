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
--     EarthSalamander #42
--

--[[ spike_trap_ai.lua ]]

---------------------------------------------------------------------------
-- AI for the Spike Trap
---------------------------------------------------------------------------

local triggerActive = true

function Fire(trigger)
	local triggerName = thisEntity:GetName()
	--log.debug(tostring(triggerName))
	local level = trigger.activator:GetLevel()
	local target = Entities:FindByName( nil, triggerName .. "_target" )
	local spikes = triggerName .. "_model"
	local dust = triggerName .. "_particle"
	local fx = triggerName .. "_fx"
	--log.debug(spikes)
	if target ~= nil and triggerActive == true then
		local spikeTrap = thisEntity:FindAbilityByName("spike_trap")
		thisEntity:CastAbilityOnPosition(target:GetOrigin(), spikeTrap, -1 )
		EmitSoundOn( "Conquest.SpikeTrap.Plate" , spikeTrap)
		DoEntFire( spikes, "SetAnimation", "spiketrap_activate", 0, self, self )
		DoEntFire( dust, "Start", "", 0, self, self )
		DoEntFire( dust, "Stop", "", 2, self, self )
		DoEntFire( fx, "Start", "", 0, self, self )
		DoEntFire( fx, "Stop", "", 2, self, self )
		
		--thisEntity:SetContextThink( "ResetTrapModel", function() ResetTrapModel( spikes ) end, 3 )
		triggerActive = false
		thisEntity:SetContextThink( "ResetTrapModel", function() ResetTrapModel() end, 4 )
	end
end

function ResetTrapModel()
	--DoEntFire( spikes, "SetAnimation", "spiketrap_idle", 0, self, self )
	triggerActive = true
end

