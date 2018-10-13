-- Sloppily compiled by AltiV
-- 28.06.2018

-- This Periodic Spellcast version of Stampede allows terrain bypass, destroys trees, and gives damage reduction and tenacity.

LinkLuaModifier("modifier_mutation_stampede_slow", "components/modifiers/mutation/periodic_spellcast/modifier_mutation_stampede.lua", LUA_MODIFIER_MOTION_NONE )

--[[Stampede Buff]]--

modifier_mutation_stampede = class({})

function modifier_mutation_stampede:IsPurgable() return false end
function modifier_mutation_stampede:GetTexture() return "centaur_stampede" end

function modifier_mutation_stampede:OnCreated()
	-- Ability properties (particles)
	self.particle = "particles/units/heroes/hero_centaur/centaur_stampede_overhead.vpcf"
	self.particle2 = "particles/units/heroes/hero_centaur/centaur_stampede.vpcf"

	-- Ability values
	self.strength_damage = 250 -- % of strength as damage stampede will do on impact
	self.radius = 105 -- area of stampede effect around unit
	self.damage_reduction = 40 -- % of damage received reduced during effect
	self.absolute_move_speed = 550 -- minimum / fixed move speed during stampede
	self.slow_duration = 1.5 -- duration of movement speed slow if trampled (for creeps)
	self.tree_radius = 200 -- area of tree destruction effect around unit
	self.modifier_trample_slow = "modifier_mutation_stampede_slow" -- Modifier added to enemies when trampled
	self.tenacity = 75 -- % of status resistance

	if IsServer() then
		self.trample_damage = self:GetParent():GetStrength() * (self.strength_damage * 0.01)

		EmitSoundOn("Hero_Centaur.Stampede.Cast", self:GetParent())
		EmitSoundOn("Hero_Centaur.Stampede.Movement", self:GetParent())

		self.particle_stampede_fx = ParticleManager:CreateParticle(self.particle, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.particle_stampede_fx, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(self.particle_stampede_fx, false, false, -1, false, true)

		self.particle_stampede_fx2 = ParticleManager:CreateParticle(self.particle2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.particle_stampede_fx2, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(self.particle_stampede_fx2, false, false, -1, false, false)

		-- Find all enemies and clear trample marks from them
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			nil,
			25000, -- global
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _,enemy in pairs(enemies) do
			enemy.trampled_in_stampede = nil
		end

		self:StartIntervalThink(0.1)
	end
end

function modifier_mutation_stampede:OnIntervalThink()
	if IsServer() then
	--[[
	table FindUnitsInRadius(int teamNumber,
	Vector position,
	handle cacheUnit,
	float radius,
	int teamFilter,
	int typeFilter,
	int flagFilter,
	int order,
	bool canGrowCache)
	]]--
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

		-- Destroy trees around stampeding unit
		GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self.tree_radius, true)
		
		for _,enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() and not enemy.trampled_in_stampede then
				enemy.trampled_in_stampede = true
				
				local damageTable = {victim = enemy,
				attacker = self:GetParent(),
				damage = self.trample_damage,
				damage_type = DAMAGE_TYPE_MAGICAL} -- no ability parameter
				
				ApplyDamage(damageTable)
				--[[
				 	handle AddNewModifier(handle caster,
					handle optionalSourceAbility,
					string modifierName,
					handle modifierData) 
				]]--
				enemy:AddNewModifier(self:GetParent(), self:GetAbility(), self.modifier_trample_slow, {duration = self.slow_duration})
			end
		end
	end
end

function modifier_mutation_stampede:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return decFuncs
end

function modifier_mutation_stampede:GetModifierMoveSpeed_AbsoluteMin()
	return self.absolute_move_speed
end

function modifier_mutation_stampede:GetModifierIncomingDamage_Percentage()
	return self.damage_reduction * (-1)
end

function modifier_mutation_stampede:CheckState()
	return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true}
end

function modifier_mutation_stampede:GetModifierStatusResistanceStacking()
	return self.tenacity
end

--[[Stampede Slow Debuff]]--

modifier_mutation_stampede_slow = class({})

function modifier_mutation_stampede_slow:GetTexture() return "centaur_stampede" end

function modifier_mutation_stampede_slow:OnCreated()
	self.slow_pct = 80 -- % of movement speed slow if trampled (more for creeps)
end

function modifier_mutation_stampede_slow:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_mutation_stampede_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow_pct * (-1)
end