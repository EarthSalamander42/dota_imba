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

modifier_spike_trap_thinker_lua = class({})

--------------------------------------------------------------------------------

function modifier_spike_trap_thinker_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_spike_trap_thinker_lua:OnCreated( kv )
	self.light_strike_array_aoe = self:GetAbility():GetSpecialValueFor( "light_strike_array_aoe" )
	self.light_strike_array_damage = self:GetAbility():GetSpecialValueFor( "light_strike_array_damage" )
	self.light_strike_array_stun_duration = self:GetAbility():GetSpecialValueFor( "light_strike_array_stun_duration" )
	self.light_strike_array_delay_time = self:GetAbility():GetSpecialValueFor( "light_strike_array_delay_time" )
	if IsServer() then
		self:StartIntervalThink( self.light_strike_array_delay_time )

		EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), "Ability.PreLightStrikeArray", self:GetCaster() )
		
		--local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
		--ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		--ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.light_strike_array_aoe, 1, 1 ) )
		--ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

--------------------------------------------------------------------------------

function modifier_spike_trap_thinker_lua:OnIntervalThink()
	if IsServer() then
		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.light_strike_array_aoe, false )
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.light_strike_array_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then

					local damage = {
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.light_strike_array_damage,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self:GetAbility()
					}

					ApplyDamage( damage )
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_spike_trap_lua", { duration = self.light_strike_array_stun_duration } )
				end
			end
		end

		--local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_axe/axe_culling_blade.vpcf", PATTACH_WORLDORIGIN, nil )
		--ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		--ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.light_strike_array_aoe, 1, 1 ) )
		--ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Conquest.SpikeTrap.Activate.Generic", self:GetCaster() )

		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------