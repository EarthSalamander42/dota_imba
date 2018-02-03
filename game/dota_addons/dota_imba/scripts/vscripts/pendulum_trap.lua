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


pendulum_trap = class({})
LinkLuaModifier( "modifier_pendulum_trap_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function pendulum_trap:CastFilterResultTarget( hTarget )
	--print("Cast Filter")
	if IsServer() then
		--print("Is Server")

		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function pendulum_trap:GetCastRange( vLocation, hTarget )
	--print("Getting Cast Range")
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

--------------------------------------------------------------------------------

function pendulum_trap:OnSpellStart()
	--print("Starting Spell")
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		--print("Target is valid")
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
			--print("Calling modifier")
			local damage_delay = self:GetSpecialValueFor( "damage_delay" )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_pendulum_trap_lua", { duration = damage_delay } )
			--EmitSoundOn( "Conquest.Pendulum.Target", hTarget )
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_blood01.vpcf", PATTACH_CUSTOMORIGIN, nil );
		--ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		--EmitSoundOn( "Conquest.Pendulum.Target", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
