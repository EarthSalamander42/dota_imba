-- Author:
--		X-TheDark

-- Editors:
--     Fudge
--     naowin, 10.07.2018

--------------------------------
------ MASS SERPENT WARD -------
--------------------------------
imba_shadow_shaman_mass_serpent_ward = imba_shadow_shaman_mass_serpent_ward or class({})

LinkLuaModifier("modifier_imba_mass_serpent_ward",  "components/abilities/heroes/hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)

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

	local base_hp 	= self:GetSpecialValueFor("ward_hp")
	local bonus_hp	= 0
	local bonus_dmg = 0

	if caster:HasTalent("special_bonus_imba_shadow_shaman_2") then
		bonus_hp = caster:FindTalentValue("special_bonus_imba_shadow_shaman_2")
	end

	if caster:HasTalent("special_bonus_imba_shadow_shaman_3") then
		bonus_dmg = caster:FindTalentValue("special_bonus_imba_shadow_shaman_3")
	end
	
	-- Emit cast sound
	caster:EmitSound("Hero_ShadowShaman.SerpentWard")
	-- Emit cast response
	caster:EmitSound(response..RandomInt(4,7))

	-- Emit spawn particle
	local spawn_particle_fx = ParticleManager:CreateParticle(spawn_particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( spawn_particle_fx, 0, target_point )

	--[[
	-- #1 TALENT: More Serpent Wards 
	if caster:HasTalent("special_bonus_imba_shadow_shaman_1") then
		ward_count = ward_count + caster:FindTalentValue("special_bonus_imba_shadow_shaman_1")
		print("has talent 1", ward_count)
	end
	]]

	-- Create 8 wards in a box formation (note the vectors) + more wards near them
	local formation_vectors = {
		Vector(-128 , 64 ,0), 	Vector(-64, 64, 0), 	Vector(0, 64 ,0), 		
		Vector(64, 64 ,0), 		Vector(128 , 64 ,0),	Vector(-64, 0, 0),   	
		Vector(64, 0 ,0),		Vector(-64, -64, 0), 	Vector(0, -64 ,0), 		
		Vector(64, -64 ,0), 	Vector(-192, 64 ,0),	Vector(192, 64 ,0),
		Vector(-128, -64 ,0),	Vector(128, -64 ,0),
	}

	local find_clear_space 	= true
	local npc_owner 		= caster
	local unit_owner 		= caster

	for i = 1, ward_count do
		local ward = CreateUnitByName(ward_name..ward_level, target_point + formation_vectors[i], find_clear_space, npc_owner, unit_owner, caster:GetTeamNumber())
		ward:SetForwardVector(caster:GetForwardVector())
		ward:AddNewModifier(caster, self, "modifier_imba_mass_serpent_ward", {})
		ward:AddNewModifier(caster, self, "modifier_kill", {duration = ward_duration})
		ward:SetControllableByPlayer(caster:GetPlayerID(), true)
		-- Update Health
		local new_hp = base_hp + bonus_hp
		ward:SetBaseMaxHealth(new_hp)
		-- Update Damage
		if bonus_dmg > 0 then
			ward:SetBaseDamageMin(ward:GetBaseDamageMin() + bonus_dmg)
			ward:SetBaseDamageMax(ward:GetBaseDamageMax() + bonus_dmg)
		end
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

function modifier_imba_mass_serpent_ward:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
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
					parent:Script_GetAttackRange(),
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
