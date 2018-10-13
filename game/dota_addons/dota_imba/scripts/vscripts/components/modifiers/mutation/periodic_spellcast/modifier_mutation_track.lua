LinkLuaModifier("modifier_mutation_track_buff_ms", "components/modifiers/mutation/periodic_spellcast/modifier_mutation_track.lua", LUA_MODIFIER_MOTION_NONE )

modifier_mutation_track = class({})

function modifier_mutation_track:IsPurgable() return false end

function modifier_mutation_track:OnCreated()
	-- Ability properties
	self.particle_shield = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf"
	self.particle_trail = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_trail.vpcf"

	-- Ability specials
	self.bonus_gold_allies = 300
	self.haste_radius = 900

	if IsServer() then
		-- Adjust custom lobby gold settings to the gold
		self.bonus_gold_allies = self.bonus_gold_allies

		-- Add overhead particle only for the caster's team
		self.particle_shield_fx = ParticleManager:CreateParticle(self.particle_shield, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.particle_shield_fx, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(self.particle_shield_fx, false, false, -1, false, true)

		-- Add the track particle only for the caster's team
		self.particle_trail_fx = ParticleManager:CreateParticle(self.particle_trail, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.particle_trail_fx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.particle_trail_fx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle_trail_fx, 8, Vector(1,0,0))
		self:AddParticle(self.particle_trail_fx, false, false, -1, false, false)

		-- Play cast sound for the player's team only
		EmitSoundOnLocationForAllies(self:GetParent():GetAbsOrigin(), "Hero_BountyHunter.Target", self:GetParent())

		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_mutation_track_buff_ms", {})
	end
end

function modifier_mutation_track:GetTexture()
	return "bounty_hunter_track"
end

function modifier_mutation_track:OnRefresh()
	self:OnCreated()
end

function modifier_mutation_track:OnRemoved()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_mutation_track_buff_ms")
	end
end

function modifier_mutation_track:CheckState()
	if self:GetParent():HasModifier("modifier_slark_shadow_dance") then
		return nil
	end

	local state = {[MODIFIER_STATE_INVISIBLE] = false}
	return state
end

function modifier_mutation_track:IsDebuff()
	return true
end

function modifier_mutation_track:IsPurgable()
	return false
end

function modifier_mutation_track:RemoveOnDeath()
	return false
end

function modifier_mutation_track:IsHidden()
	return false
end

function modifier_mutation_track:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_EVENT_ON_HERO_KILLED,
		}

	return decFuncs
end

function modifier_mutation_track:OnHeroKilled(keys)
	if IsServer() then
		local target = keys.target
		local reincarnate = keys.reincarnate

		-- Only apply if the target of the track debuff is the one who just died
		if target == self:GetParent() then

			-- If the target was an illusion, do nothing
			if not target:IsRealHero() then
				return nil
			end

			-- If the target is reincarnating, do nothing
			if reincarnate then
				return nil
			end

			-- Find caster's allies nearby
			local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
				self:GetParent():GetAbsOrigin(),
				nil,
				self.haste_radius,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
				FIND_ANY_ORDER,
				false
			)

			for _,ally in pairs(allies) do
				-- Give allies bonus allied gold, except caster
				if ally ~= self:GetCaster() then
					ally:ModifyGold(self.bonus_gold_allies, true, 0)
					SendOverheadEventMessage(ally, OVERHEAD_ALERT_GOLD, ally, self.bonus_gold_allies, nil)
				end
			end

			-- Remove the debuff modifier from the enemy that just died
			self:Destroy()
		end
	end
end

function modifier_mutation_track:GetModifierProvidesFOWVision()
	return 1
end

function modifier_mutation_track:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_mutation_track:IsPermanent()
	return false
end


modifier_mutation_track_buff_ms = modifier_mutation_track_buff_ms or class({})

function modifier_mutation_track_buff_ms:OnCreated()
	-- Ability properties
	self.particle_haste = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_haste.vpcf"

	-- Ability specials
	self.ms_bonus_allies_pct = 20

	if IsServer() then
		-- Create haste particle
		self.particle_haste_fx = ParticleManager:CreateParticle(self.particle_haste, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.particle_haste_fx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_haste_fx, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_haste_fx, 2, self:GetParent():GetAbsOrigin())

		self:AddParticle(self.particle_haste_fx, false, false, -1, false, false)
	end
end

function modifier_mutation_track_buff_ms:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_mutation_track_buff_ms:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus_allies_pct
end
