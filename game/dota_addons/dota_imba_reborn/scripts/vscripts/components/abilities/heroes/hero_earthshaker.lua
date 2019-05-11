-- Credits: Elfansoer.
-- https://github.com/Elfansoer/dota-2-lua-abilities/blob/master/scripts/vscripts/lua_abilities/earthshaker_fissure_lua/earthshaker_fissure_lua.lua
-- https://github.com/Elfansoer/dota-2-lua-abilities/blob/master/scripts/vscripts/lua_abilities/earthshaker_fissure_lua/modifier_earthshaker_fissure_lua_thinker.lua

earthshaker_fissure_lua = class({})
LinkLuaModifier( "modifier_earthshaker_fissure_lua_thinker", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earthshaker_fissure_lua_prevent_movement", "components/abilities/heroes/hero_earthshaker", LUA_MODIFIER_MOTION_NONE )

function earthshaker_fissure_lua:GetAbilityTextureName()
	if not IsClient() then return end
	if not self:GetCaster().arcana_style then return "earthshaker_fissure" end
	return "earthshaker_fissure_ti9"
end

--------------------------------------------------------------------------------
-- Ability Start
function earthshaker_fissure_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local damage = self:GetAbilityDamage()
	local distance = self:GetCastRange( point, caster ) + GetCastRangeIncrease(caster)
	local duration = self:GetSpecialValueFor("fissure_duration")
	local radius = self:GetSpecialValueFor("fissure_radius")
	local stun_duration = self:GetSpecialValueFor("stun_duration")

	-- generate data
	local block_width = 24
	local block_delta = 8.25

	if caster:HasTalent("special_bonus_unique_earthshaker_3") then
		distance = distance + caster:FindTalentValue("special_bonus_unique_earthshaker_3")
	end

	-- get wall vector
	local direction = point-caster:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	local wall_vector = direction * distance

	-- Create blocker along path
	local block_spacing = (block_delta+2*block_width)
	local blocks = distance/block_spacing
	local block_pos = caster:GetHullRadius() + block_delta + block_width
	local start_pos = caster:GetOrigin() + direction*block_pos

	for i=1,blocks do
		local block_vec = caster:GetOrigin() + direction*block_pos
		local blocker = CreateModifierThinker(
			caster, -- player source
			self, -- ability source
			"modifier_earthshaker_fissure_lua_thinker", -- modifier name
			{ duration = duration }, -- kv
			block_vec,
			caster:GetTeamNumber(),
			true
		)
		blocker:SetHullRadius( block_width )
		block_pos = block_pos + block_spacing
	end

	-- find units in line
	local end_pos = start_pos + wall_vector
	local units = FindUnitsInLine(
		caster:GetTeamNumber(),
		start_pos,
		end_pos,
		-- caster:GetOrigin() + direction*caster:GetHullRadius(),
		-- caster:GetOrigin() + direction*caster:GetHullRadius() + wall_vector,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}

	-- apply damage, shove and stun
	for _,unit in pairs(units) do
		-- shove
		FindClearSpaceForUnit( unit, unit:GetOrigin(), true )

		if unit:GetTeamNumber()~=caster:GetTeamNumber() then
			-- damage
			damageTable.victim = unit
			ApplyDamage(damageTable)

			-- stun
			unit:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_stunned", -- modifier name
				{ duration = stun_duration } -- kv
			)
		end
	end

	-- Effects
	self:PlayEffects( start_pos, end_pos, duration )
end

--------------------------------------------------------------------------------
function earthshaker_fissure_lua:PlayEffects( start_pos, end_pos, duration )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_earthshaker/earthshaker_fissure.vpcf"
	local sound_cast = "Hero_EarthShaker.Fissure"

	-- generate data
	local caster = self:GetCaster()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( caster.fissure_pfx, PATTACH_WORLDORIGIN, caster )
--	local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, caster )
	ParticleManager:SetParticleControl( effect_cast, 0, start_pos )
	ParticleManager:SetParticleControl( effect_cast, 1, end_pos )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( duration, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( start_pos, sound_cast, caster )
	EmitSoundOnLocationWithCaster( end_pos, sound_cast, caster )
end

modifier_earthshaker_fissure_lua_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_earthshaker_fissure_lua_thinker:IsHidden()
	return true
end

function modifier_earthshaker_fissure_lua_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_earthshaker_fissure_lua_thinker:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_earthshaker_fissure_lua_thinker:OnIntervalThink()
	-- find units in line
	local units = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),
		nil,
		200,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false
	)

	-- Prevent units from moving if near fissure
	for _,unit in pairs(units) do
		unit:AddNewModifier(unit, self:GetAbility(), "modifier_earthshaker_fissure_lua_prevent_movement", {duration=0.1})
	end
end
--[[
function modifier_earthshaker_fissure_lua_thinker:OnRefresh( kv )
	
end
--]]
function modifier_earthshaker_fissure_lua_thinker:OnDestroy( kv )
	if IsServer() then
		-- Effects
		local sound_cast = "Hero_EarthShaker.FissureDestroy"
		EmitSoundOnLocationWithCaster(self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
		UTIL_Remove(self:GetParent())
	end
end


modifier_earthshaker_fissure_lua_prevent_movement = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_earthshaker_fissure_lua_prevent_movement:IsHidden()
	return true
end

function modifier_earthshaker_fissure_lua_prevent_movement:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_earthshaker_fissure_lua_prevent_movement:OnCreated()
	if IsServer() then
		self.movement_capability = 0

		if self:GetParent():HasGroundMovementCapability() then
			self.movement_capability = 1
		elseif self:GetParent():HasFlyMovementCapability() then
			self.movement_capability = 2
		end

		self:GetParent():SetMoveCapability(0)
	end
end

function modifier_earthshaker_fissure_lua_prevent_movement:OnDestroy( kv )
	if IsServer() then
		self:GetParent():SetMoveCapability(self.movement_capability)
	end
end