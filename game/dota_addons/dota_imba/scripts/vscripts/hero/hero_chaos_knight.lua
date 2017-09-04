-- Author: Cookies
-- Date: 04/09/2017

--  CreateEmptyTalents("chaos_knight")

LinkLuaModifier("modifier_reality_rift_armor_reduction_debuff", "hero/hero_chaos_knight", LUA_MODIFIER_MOTION_NONE)

imba_chaos_knight_reality_rift = class({})

function imba_chaos_knight_reality_rift:CastFilterResultTarget( hTarget )
	if IsServer() then
	local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function imba_chaos_knight_reality_rift:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function imba_chaos_knight_reality_rift:OnAbilityPhaseStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local ability = self

		local caster_location = caster:GetAbsOrigin()
		local target_location = target:GetAbsOrigin()

		-- Ability variables
		local min_range = 0.2
		local max_range = 0.8

		-- Position calculation
		local distance = (target_location - caster_location):Length2D()
		local direction = (target_location - caster_location):Normalized()
		local target_point = RandomFloat(min_range, max_range) * distance
		local target_point_vector = caster_location + direction * target_point
		ability.random_point = target_point_vector
		ability.fw = direction

		StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_OVERRIDE_ABILITY_2, rate=1.0})
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_reality_rift.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster_location, true)
		ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControl(particle, 2, target_point_vector)
		ParticleManager:SetParticleControlOrientation(particle, 2, direction, Vector(0,1,0), Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex(particle)

		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_CLOSEST, false)
		for _,unit in pairs(units) do
			if unit:GetPlayerOwnerID() == caster:GetPlayerID() then
				StartAnimation(unit, {duration=0.4, activity=ACT_DOTA_OVERRIDE_ABILITY_2, rate=1.0})
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_reality_rift.vpcf", PATTACH_CUSTOMORIGIN, target)
				ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
				ParticleManager:SetParticleControl(particle, 2, target_point_vector)
				ParticleManager:SetParticleControlOrientation(particle, 2, direction, Vector(0,1,0), Vector(1,0,0))
				ParticleManager:ReleaseParticleIndex(particle)
			end
		end

		EmitSoundOn("Hero_ChaosKnight.RealityRift", caster)
	end
   return true
end

function imba_chaos_knight_reality_rift:OnSpellStart()
local caster = self:GetCaster()
local hTarget = self:GetCursorTarget()
local ability = self
local duration = self:GetSpecialValueFor("armor_duration")

	if hTarget then
		if (not hTarget:TriggerSpellAbsorb(self)) then
			hTarget:SetAbsOrigin(ability.random_point)
			FindClearSpaceForUnit(caster, ability.random_point, true)
			FindClearSpaceForUnit(hTarget, ability.random_point, true)
			EmitSoundOn("Hero_ChaosKnight.RealityRift.Target", caster)
			hTarget:AddNewModifier(caster, self, "modifier_reality_rift_armor_reduction_debuff", {duration=duration})
			hTarget:SetForwardVector(ability.fw)
			caster:Stop()
			caster:SetForwardVector(ability.fw * -1)

			local order = {UnitIndex = caster:entindex(), OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET, TargetIndex = hTarget:entindex(), Queue = true}
			ExecuteOrderFromTable(order)

			local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_CLOSEST, false)
			for _,unit in pairs(units) do
				if unit:GetPlayerOwnerID() == caster:GetPlayerID() then
					FindClearSpaceForUnit(unit, ability.random_point, true)
					unit:Stop() 
					unit:SetForwardVector(ability.fw * -1)
					local order = {UnitIndex = unit:entindex(), OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET, TargetIndex = hTarget:entindex(), Queue = true}
					ExecuteOrderFromTable(order)
				end
			end

		end
	end
end

function imba_chaos_knight_reality_rift:DeclareFunctions()	
	local decFuncs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return decFuncs
end

--------------------------------------------------------------------------------

-- Armor reduction debuff
modifier_reality_rift_armor_reduction_debuff = class({})

function modifier_reality_rift_armor_reduction_debuff:DeclareFunctions()	
	local decFuncs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return decFuncs
end

function modifier_reality_rift_armor_reduction_debuff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_reduction")
end

--	function modifier_reality_rift_armor_reduction_debuff:GetStatusEffectName()
--		return "particles/status_fx/status_effect_slardar_amp_damage.vpcf"
--	end

function modifier_reality_rift_armor_reduction_debuff:IsDebuff()
	return true
end

function modifier_reality_rift_armor_reduction_debuff:IsPurgable()
	return true
end

--------------------------
--		PHANTASM		--
--------------------------

imba_chaos_knight_phantasm = class({})
LinkLuaModifier("modifier_chaos_knight_phantasm_cast", "hero/hero_chaos_knight", LUA_MODIFIER_MOTION_NONE)

function imba_chaos_knight_phantasm:GetAbilityTextureName()
	return "chaos_knight_phantasm"
end

function imba_chaos_knight_phantasm:IsHiddenWhenStolen()
	return false
end

--	function imba_chaos_knight_phantasm:GetCastRange(location, target)
--		local caster = self:GetCaster()
--		local base_range = self.BaseClass.GetCastRange(self, location, target)

--		return base_range
--	end

function imba_chaos_knight_phantasm:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self

		-- Ability variables
		local unit_name = caster:GetUnitName()
		local images_count = ability:GetSpecialValueFor("images_count")
		local duration = ability:GetSpecialValueFor("illusion_duration")
		local outgoingDamage = ability:GetSpecialValueFor("outgoing_damage")
		local incomingDamage = ability:GetSpecialValueFor("incoming_damage")
		local invulnerability_duration = ability:GetSpecialValueFor("invuln_duration")
		local extra_illusion_chance = ability:GetSpecialValueFor("extra_phantasm_chance_pct_tooltip")
		local extra_illusion_sound = "Hero_ChaosKnight.Phantasm.Plus"

		local chance = RandomInt(1, 100)
		local casterOrigin = caster:GetAbsOrigin()
		local casterAngles = caster:GetAngles()

		-- Stop any actions of the caster otherwise its obvious which unit is real
		local phantasm_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_phantasm.vpcf", PATTACH_ABSORIGIN, caster)
		caster:AddNewModifier(caster, nil, "modifier_chaos_knight_phantasm_cast", {duration=invulnerability_duration})
		caster:Stop()
		EmitSoundOn("Hero_ChaosKnight.Phantasm", caster)

		-- Initialize the illusion table to keep track of the units created by the spell
		if not caster.phantasm_illusions then
			caster.phantasm_illusions = {}
		end

		-- Kill the old images
		for k,v in pairs(caster.phantasm_illusions) do
			if v and IsValidEntity(v) then 
				v:ForceKill(false)
			end
		end

		-- Start a clean illusion table
		caster.phantasm_illusions = {}

		-- Setup a table of potential spawn positions
		local vRandomSpawnPos = {
			Vector( 72, 0, 0 ),		-- North
			Vector( 0, 72, 0 ),		-- East
			Vector( -72, 0, 0 ),	-- South
			Vector( 0, -72, 0 ),	-- West
		}

		for i=#vRandomSpawnPos, 2, -1 do	-- Simply shuffle them
			local j = RandomInt( 1, i )
			vRandomSpawnPos[i], vRandomSpawnPos[j] = vRandomSpawnPos[j], vRandomSpawnPos[i]
		end

		-- Insert the center position and make sure that at least one of the units will be spawned on there.
		table.insert( vRandomSpawnPos, RandomInt( 1, images_count+1 ), Vector( 0, 0, 0 ) )

		Timers:CreateTimer(invulnerability_duration, function()
			-- At first, move the main hero to one of the random spawn positions.
			FindClearSpaceForUnit( caster, casterOrigin + table.remove( vRandomSpawnPos, 1 ), true )

			-- Spawn illusions
			if chance <= extra_illusion_chance then
				images_count = images_count +1
				EmitSoundOn("Hero_ChaosKnight.Phantasm.Plus", caster)
			end

			for i=1, images_count do
				local origin = casterOrigin + table.remove( vRandomSpawnPos, 1 )
				local illusion = IllusionManager:CreateIllusion(caster, ability, origin, caster, {damagein=incomingDamage, damageout=outcomingDamage, unique="phantasm_"..i, duration=duration})
--				illusion:SetAngles(casterAngles.x, casterAngles.y, casterAngles.z)
				table.insert(caster.phantasm_illusions, illusion)
			end
			ParticleManager:DestroyParticle(phantasm_particle, false)
			ParticleManager:ReleaseParticleIndex(phantasm_particle)
		end)
	end
end

modifier_chaos_knight_phantasm_cast = class({})

--------------------------------------------------------------------------------

function modifier_chaos_knight_phantasm_cast:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_chaos_knight_phantasm_cast:CheckState()
	local state = 
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
	
	return state
end


