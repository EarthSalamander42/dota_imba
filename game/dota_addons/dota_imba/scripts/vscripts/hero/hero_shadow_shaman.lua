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
--     Fudge
--     suthernfriend, 03.02.2018

CreateEmptyTalents("shadow_shaman")

--------------------------------
------ MASS SERPENT WARD -------
--------------------------------
imba_shadow_shaman_mass_serpent_ward = imba_shadow_shaman_mass_serpent_ward or class({})

LinkLuaModifier("modifier_imba_mass_serpent_ward",  "hero/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)

function imba_shadow_shaman_mass_serpent_ward:OnSpellStart()
	-- Ability properties
	local caster            =   self:GetCaster()
	local target_point      =   self:GetCursorPosition()
	local ward_level        =   self:GetLevel()
	local ward_name         =   "npc_imba_dota_shadow_shaman_ward_"
	local response          =   "shadowshaman_shad_ability_ward_"
	local spawn_particle    =   "particles/units/heroes/hero_shadowshaman/shadowshaman_ward_spawn.vpcf"
	-- Ability parameters
	local ward_count    =   self:GetSpecialValueFor("ward_count")
	local ward_duration =   self:GetSpecialValueFor("duration")

	-- Emit cast sound
	caster:EmitSound("Hero_ShadowShaman.SerpentWard")
	-- Emit cast response
	caster:EmitSound(response..RandomInt(4,7))

	-- Emit spawn particle
	local spawn_particle_fx = ParticleManager:CreateParticle(spawn_particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( spawn_particle_fx, 0, target_point )

	-- #1 TALENT: More Serpent Wards
	if caster:HasTalent("special_bonus_imba_shadow_shaman_1") then
		ward_count = ward_count + caster:FindTalentValue("special_bonus_imba_shadow_shaman_1")
	end

	-- Create 8 wards in a box formation (note the vectors) + more wards near them
	local formation_vectors = {
		Vector(-128 , 64 ,0), Vector(-64, 64, 0) ,  Vector(0, 64 ,0), Vector(64, 64 ,0) , Vector(128 , 64 ,0),
		Vector(-64, 0, 0)  ,				      Vector(64, 0 ,0)  ,
		Vector(-64, -64, 0), Vector(0, -64 ,0), Vector(64, -64 ,0),
		-- Talent vectors
		Vector(-192, 64 ,0),																										Vector(192, 64 ,0),
		Vector(-128, -64 ,0),															 Vector(128, -64 ,0),
	}

	local find_clear_space = true
	local npc_owner = caster
	local unit_owner = caster

	for i = 1, ward_count do
		local ward = CreateUnitByName(ward_name..ward_level, target_point + formation_vectors[i], find_clear_space, npc_owner, unit_owner, caster:GetTeamNumber())
		ward:SetForwardVector(caster:GetForwardVector())
		ward:AddNewModifier(caster, self, "modifier_imba_mass_serpent_ward", {})
		ward:AddNewModifier(caster, self, "modifier_kill", {duration = ward_duration})
		ward:SetControllableByPlayer(caster:GetPlayerID(), true)
	end

end

--- SERPENT WARD MODIFIER
modifier_imba_mass_serpent_ward = modifier_imba_mass_serpent_ward or class({})

function modifier_imba_mass_serpent_ward:IsDebuff() return false end
function modifier_imba_mass_serpent_ward:IsHidden() return true end
function modifier_imba_mass_serpent_ward:IsPurgable() return false end

function modifier_imba_mass_serpent_ward:OnCreated()
	local caster    =   self:GetCaster()
	local ability   =   self:GetAbility()
	local parent    =   self:GetParent()

	-- AGHANIM'S SCEPTER: Wards have more attack range
	if caster:HasScepter() then
		self.bonus_range    =   ability:GetSpecialValueFor("scepter_bonus_range")
	end

	-- #2 TALENT: Serpent Wards gain more hp
	if caster:HasTalent("special_bonus_imba_shadow_shaman_2") then
		local bonus_hp = caster:FindTalentValue("special_bonus_imba_shadow_shaman_2")
		if parent ~= nil and parent:IsAlive() then 
			local new_hp   = parent:GetHealth() + bonus_hp
			parent:SetBaseMaxHealth(new_hp)
			parent:SetMaxHealth(new_hp)
			parent:SetHealth(new_hp)
		end
	end

	-- Prevent some recursion with the scepter effect
	self.main_attack    =   true
end

function modifier_imba_mass_serpent_ward:DeclareFunctions()
	funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
	return funcs
end

-- Set all damage taken to 1
function modifier_imba_mass_serpent_ward:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_imba_mass_serpent_ward:OnAttackLanded(params) -- health handling
	if IsServer() then
		if params.target == self:GetParent() then
			local damage = 1
			if params.attacker:IsRealHero() then
				damage = 2
			end

			if self:GetParent():GetHealth() > damage then
				self:GetParent():SetHealth( self:GetParent():GetHealth() - damage)
			else
				self:GetParent():Kill(nil, params.attacker)
			end
		end
	end
end

function modifier_imba_mass_serpent_ward:OnAttack(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			-- Ability properties
			local parent    =   self:GetParent()
			local caster    =   self:GetCaster()
			local ability   =   self:GetAbility()
			-- Ability parameters
			local max_targets   =  ability:GetSpecialValueFor("scepter_additional_targets")

			-- AGHANIM'S SCEPTER: Ward's attacks split shot
			if caster:HasScepter() and self.main_attack then
				self.main_attack = false

				-- Look for a target in the attack range of the ward
				local enemies = FindUnitsInRadius(parent:GetTeamNumber(),
					parent:GetAbsOrigin(),
					nil,
					parent:GetAttackRange(),
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
					DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE +DOTA_UNIT_TARGET_FLAG_NO_INVIS,
					FIND_ANY_ORDER,
					false)

				-- "skip" the iteration if the main target was chosen
				if CheckIfInTable(enemies, params.target, max_targets) then
					max_targets = max_targets + 1
				end

				-- Send a attack projectile to the chosen enemies
				for i=1, max_targets do
					if enemies[i] ~= params.target and i <= #enemies then
						parent:PerformAttack(enemies[i], false, true, true, true, true, false, false)

						-- Recursion handling
						Timers:CreateTimer(FrameTime(), function()
							self.main_attack = true
						end)
					end
				end
			end
		end
	end
end

-- AGHANIM'S SCEPTER: wards have bonus attack range
function modifier_imba_mass_serpent_ward:GetModifierAttackRangeBonus()
	return self.bonus_range
end

-- Hero-based damage handling
function modifier_imba_mass_serpent_ward:OnTakeDamage(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			if params.damage > 0 then
				local damageTable = {victim = params.unit,
					damage = 1,
					damage_type = DAMAGE_TYPE_PURE,
					attacker = self:GetCaster(),
					ability = self:GetAbility()
				}

				ApplyDamage(damageTable)
			end
		end
	end
end

function modifier_imba_mass_serpent_ward:OnDestroy()
	if IsServer() then
		local particle  =   "particles/units/heroes/hero_shadowshaman/shadowshaman_ward_death.vpcf"

		-- Emit ward death particle
		local spawn_particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl( spawn_particle_fx, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(spawn_particle_fx)
	end
end
