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

spike_trap = class({})
LinkLuaModifier( "modifier_spike_trap_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spike_trap_thinker_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function spike_trap:GetAOERadius()
	return self:GetSpecialValueFor( "light_strike_array_aoe" )
end

--------------------------------------------------------------------------------

function spike_trap:OnSpellStart()
	self.light_strike_array_aoe = self:GetSpecialValueFor( "light_strike_array_aoe" )
	self.light_strike_array_delay_time = self:GetSpecialValueFor( "light_strike_array_delay_time" )

	local kv = {}
	CreateModifierThinker( self:GetCaster(), self, "modifier_spike_trap_thinker_lua", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------




