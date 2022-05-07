-- Editors:
--     EarthSalamander #42, 04.09.2017

LinkLuaModifier("modifier_reality_rift_armor_reduction_debuff", "components/abilities/heroes/hero_chaos_knight", LUA_MODIFIER_MOTION_NONE)

imba_chaos_knight_reality_rift = class({})

function imba_chaos_knight_reality_rift:CastFilterResultTarget(target)
	local caster = self:GetCaster()

	if target:IsMagicImmune() then
		local ability = caster:FindAbilityByName("special_bonus_unique_chaos_knight")
		if ability and ability:GetLevel() > 0 then
			return UF_SUCCESS
		else
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end
	elseif target:IsBuilding() then
		return UF_FAIL_BUILDING
	elseif target:GetTeamNumber() == caster:GetTeamNumber() then
		return UF_FAIL_FRIENDLY
	elseif target:IsAncient() then
		return UF_FAIL_ANCIENT
	end
end

function imba_chaos_knight_reality_rift:OnAbilityPhaseStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local ability = self

		local caster_location = caster:GetAbsOrigin()
		local target_location = target:GetAbsOrigin()

		-- Ability variables
		local min_range = 0.25
		local max_range = 0.75

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
			hTarget:AddNewModifier(caster, self, "modifier_reality_rift_armor_reduction_debuff", {duration = duration * (1 - hTarget:GetStatusResistance())})
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

function modifier_reality_rift_armor_reduction_debuff:OnCreated()
	local parent = self:GetParent()

	parent.ArmorDebuff = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_focal/templar_meld_focal_overhead_model.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
end

function modifier_reality_rift_armor_reduction_debuff:OnDestroy()
	local parent = self:GetParent()

	ParticleManager:DestroyParticle(parent.ArmorDebuff, false)
	ParticleManager:ReleaseParticleIndex(parent.ArmorDebuff)
end

function modifier_reality_rift_armor_reduction_debuff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_reduction") + self:GetCaster():FindTalentValue("special_bonus_unique_chaos_knight_2")
end

function modifier_reality_rift_armor_reduction_debuff:IsDebuff()
	return true
end

function modifier_reality_rift_armor_reduction_debuff:IsPurgable()
	return true
end

--------------------------
--		PHANTASM		--
--------------------------

LinkLuaModifier("modifier_imba_chaos_knight_phantasm_cast", "components/abilities/heroes/hero_chaos_knight", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_chaos_knight_phantasm_illusion", "components/abilities/heroes/hero_chaos_knight", LUA_MODIFIER_MOTION_NONE)

imba_chaos_knight_phantasm						= imba_chaos_knight_phantasm or class({})
modifier_imba_chaos_knight_phantasm_cast		= modifier_imba_chaos_knight_phantasm_cast or class({})
modifier_imba_chaos_knight_phantasm_illusion	= modifier_imba_chaos_knight_phantasm_illusion or class({})

--------------------------------
-- IMBA_CHAOS_KNIGHT_PHANTASM --
--------------------------------

--	function imba_chaos_knight_phantasm:GetCastRange(location, target)
--		local caster = self:GetCaster()
--		local base_range = self.BaseClass.GetCastRange(self, location, target)

--		return base_range
--	end

-- TODO: Think of a scepter effect (might consider ally W but then I'll need to make that custom too so hmm)

function imba_chaos_knight_phantasm:OnSpellStart()
	local extra_illusion_sound = "Hero_ChaosKnight.Phantasm.Plus"

	local unit = self:GetCursorTarget() or self:GetCaster()
	
	unit:EmitSound("Hero_ChaosKnight.Phantasm")
	unit:Purge(false, true, false, false, false)
	ProjectileManager:ProjectileDodge(unit)
	
	unit:AddNewModifier(self:GetCaster(), self, "modifier_imba_chaos_knight_phantasm_cast", {duration = self:GetSpecialValueFor("invuln_duration")})
end

----------------------------------------------
-- MODIFIER_IMBA_CHAOS_KNIGHT_PHANTASM_CAST --
----------------------------------------------

function modifier_imba_chaos_knight_phantasm_cast:IsHidden()		return true end
function modifier_imba_chaos_knight_phantasm_cast:IsPurgable()	return false end

function modifier_imba_chaos_knight_phantasm_cast:GetEffectName()
	return "particles/units/heroes/hero_chaos_knight/chaos_knight_phantasm.vpcf"
end

function modifier_imba_chaos_knight_phantasm_cast:OnCreated()
	self.images_count				= self:GetAbility():GetSpecialValueFor("images_count")
	self.illusion_duration			= self:GetAbility():GetSpecialValueFor("illusion_duration")
	self.outgoing_damage			= self:GetAbility():GetSpecialValueFor("outgoing_damage")
	self.outgoing_damage_tooltip	= self:GetAbility():GetSpecialValueFor("outgoing_damage_tooltip")
	self.incoming_damage			= self:GetAbility():GetSpecialValueFor("incoming_damage")
	self.incoming_damage_tooltip	= self:GetAbility():GetSpecialValueFor("incoming_damage_tooltip")
	self.invuln_duration			= self:GetAbility():GetSpecialValueFor("invuln_duration")
	self.vision_radius				= self:GetAbility():GetSpecialValueFor("vision_radius")
	self.magic_resistance			= self:GetAbility():GetSpecialValueFor("magic_resistance")
	self.images_count				= self:GetAbility():GetSpecialValueFor("images_count")
	self.scepter_images_count_extra	= self:GetAbility():GetSpecialValueFor("scepter_images_count_extra")
	
	if self:GetCaster():HasScepter() then
		self.images_count = self.images_count + self.scepter_images_count_extra
	end
end

function modifier_imba_chaos_knight_phantasm_cast:OnDestroy()
	if not IsServer() or not self:GetParent():IsAlive() or not self:GetAbility() then return end

	-- "Orders the user to stop after the split time, canceling all queued orders, and orders given during the split time."
	if self:GetParent() == self:GetCaster() then
		self:GetParent():Stop()
	end
	
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.vision_radius, 1, false)

	if self:GetAbility().phantasm_illusions then
		for _, illusion in pairs(self:GetAbility().phantasm_illusions) do
			if illusion and not illusion:IsNull() then
				illusion:ForceKill(false)
			end
		end
	end
	
	self:GetAbility().phantasm_illusions = {}
	
	-- "The distance in between each is 135 range."
	self.phantasm_illusions = CreateIllusions(self:GetCaster(), self:GetParent(), 
	{
		outgoing_damage 			= self.outgoing_damage,
		incoming_damage				= self.incoming_damage,
		bounty_base					= self:GetParent():GetLevel() * 2,
		bounty_growth				= nil,
		outgoing_damage_structure	= nil,
		outgoing_damage_roshan		= nil,
		duration					= self.illusion_duration
	}
	, self.images_count, 135, true, true)

	for _, illusion in pairs(self.phantasm_illusions) do
		illusion:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_chaos_knight_phantasm_illusion", {})
		-- illusion:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_chaos_knight_phantasm_illusion", {magic_resistance = self.magic_resistance}) -- Feels like GetModifierMagicalResistanceBonus doesn't work on illusions or something
		table.insert(self:GetAbility().phantasm_illusions, illusion)
	end
end

-- "Chaos Knight is invulnerable, hidden and spell immune during the split time."
function modifier_imba_chaos_knight_phantasm_cast:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE]	= true,
		[MODIFIER_STATE_OUT_OF_GAME]	= true,
		
		[MODIFIER_STATE_MAGIC_IMMUNE]	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR]	= true,
		[MODIFIER_STATE_STUNNED]		= true,
	}
end

--------------------------------------------------
-- MODIFIER_IMBA_CHAOS_KNIGHT_PHANTASM_ILLUSION --
--------------------------------------------------

-- function modifier_imba_chaos_knight_phantasm_illusion:IsHidden()		return true end
function modifier_imba_chaos_knight_phantasm_illusion:IsPurgable()	return false end

function modifier_imba_chaos_knight_phantasm_illusion:OnCreated(keys)
	if self:GetAbility() then
		self.magic_resistance	= self:GetAbility():GetSpecialValueFor("magic_resistance")
	elseif keys then
		self.magic_resistance	= keys.magic_resistance
	else
		self.magic_resistance	= 0
	end
end

function modifier_imba_chaos_knight_phantasm_illusion:DeclareFunctions()
	return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end

function modifier_imba_chaos_knight_phantasm_illusion:GetModifierMagicalResistanceBonus()
	return self.magic_resistance
end
