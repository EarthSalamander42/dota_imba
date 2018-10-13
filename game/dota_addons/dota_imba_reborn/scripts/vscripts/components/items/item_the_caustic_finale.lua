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
--

item_the_caustic_finale = class({})
LinkLuaModifier("modifier_item_the_caustic_finale", "components/items/item_the_caustic_finale", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sand_king_boss_caustic_finale", "components/items/item_the_caustic_finale", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function item_the_caustic_finale:GetIntrinsicModifierName()
	return "modifier_item_the_caustic_finale"
end

function item_the_caustic_finale:OnOwnerDied(params)
	local hOwner = self:GetOwner()
	if hOwner.IsImbaReincarnating and hOwner:IsImbaReincarnating() then
		return nil
	end
	hOwner:DropItemAtPositionImmediate(self, hOwner:GetAbsOrigin())
	hOwner:LaunchLoot(false, 250, 0.5, hOwner:GetAbsOrigin() + RandomVector(RandomInt(50, 200)))
end

modifier_item_the_caustic_finale = class({})

--------------------------------------------------------------------------------

function modifier_item_the_caustic_finale:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_the_caustic_finale:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_the_caustic_finale:OnCreated( kv )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.caustic_duration = self:GetAbility():GetSpecialValueFor( "caustic_duration" )
	self.max_stack_count = self:GetAbility():GetSpecialValueFor( "max_stack_count" )
end

--------------------------------------------------------------------------------

function modifier_item_the_caustic_finale:DeclareFunctions()
	local funcs =
		{
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_item_the_caustic_finale:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent():IsIllusion() then return end
		if self:GetParent() == params.attacker then
			local Target = params.target
			if Target ~= nil and Target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				local hCausticBuff = Target:FindModifierByName( "modifier_sand_king_boss_caustic_finale" )
				if hCausticBuff == nil then
					hCausticBuff = Target:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_sand_king_boss_caustic_finale", { duration = self.caustic_duration } )
					if hCausticBuff ~= nil then
						hCausticBuff:SetStackCount( 0 )
					end
				end
				if hCausticBuff ~= nil then
					hCausticBuff:SetStackCount( math.min( hCausticBuff:GetStackCount() + 1, self.max_stack_count ) )
					hCausticBuff:SetDuration( self.caustic_duration, true )
				end
			end
		end
	end
	return 0
end

-----------------------------------------------------------------------------------------

function modifier_item_the_caustic_finale:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end

--------------------------------------------------------------------------------

function modifier_item_the_caustic_finale:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

function modifier_item_the_caustic_finale:GetEffectName()
	return "particles/item/rapier/rapier_trail_arcane.vpcf"
end

function modifier_item_the_caustic_finale:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_the_caustic_finale:GetModifierProvidesFOWVision()
	return 1
end

function modifier_item_the_caustic_finale:GetForceDrawOnMinimap()
	return 1
end

modifier_sand_king_boss_caustic_finale = class({})

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_caustic_finale:GetTexture()
	return "custom/the_caustic_finale"
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_caustic_finale:OnCreated( kv )
	self.caustic_radius = self:GetAbility():GetSpecialValueFor( "caustic_radius" )
	self.caustic_damage = self:GetAbility():GetSpecialValueFor( "caustic_damage" )
	self.nArmorReductionPerStack = math.max( math.floor( self:GetAbility():GetSpecialValueFor( "caustic_armor_reduction_pct" ) * self:GetParent():GetPhysicalArmorValue() / 100 ), 1 )
	if IsServer() then
		ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_caustic_finale_debuff.vpcf", PATTACH_ABSORIGIN, self:GetParent() ) )
	end
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_caustic_finale:DeclareFunctions()
	local funcs =
		{
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_EVENT_ON_DEATH,
		}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_caustic_finale:GetModifierPhysicalArmorBonus()
	if self.nArmorReductionPerStack == nil then
		return 0
	end
	return self.nArmorReductionPerStack * self:GetStackCount() * -1
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_caustic_finale:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			EmitSoundOn( "Ability.SandKing_CausticFinale", self:GetParent() )
			ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", PATTACH_ABSORIGIN, self:GetParent() ) )
			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.caustic_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
			for _,hEnemy in pairs( enemies ) do
				if hEnemy ~= nil and hEnemy:IsAlive() and hEnemy:IsInvulnerable() == false then
					local damageInfo =
					{
						victim = hEnemy,
						attacker = self:GetCaster(),
						damage = self.caustic_damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self,
					}

					ApplyDamage( damageInfo )
				end
			end
		end
	end
	return 0
end
