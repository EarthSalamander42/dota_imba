-- Coded by AltiV
-- 02.07.2018

-- This Periodic Spellcast version of Aphotic Shield has HP and damage scaling with game time.

--[[Aphotic Shield Buff]]--

modifier_mutation_aphotic_shield = class({})

-- Add proper buff icon on toolbar
function modifier_mutation_aphotic_shield:GetTexture()  return "abaddon_aphotic_shield" end
function modifier_mutation_aphotic_shield:IsDebuff() 	return false end

-- Add particle effects to heroes affected (not needed?)
--[[
function modifier_mutation_aphotic_shield:GetEffectName()
	return "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf"
end
--]]

function modifier_mutation_aphotic_shield:OnCreated()
	if not IsServer() then return end
	
	-- Ability values
	local game_time = GameRules:GetDOTATime(false, false) / 60 -- Number of minutes that have passed in game
	
	self.shield_base = 250 -- Minimum value of shield HP
	self.shield_mult = game_time * 30 -- Scaling value of shield HP
	self.shield_full = self.shield_base + self.shield_mult -- Total HP of shield
	self.shield_remain = self.shield_full -- Current HP of shield
	self.radius = 675 -- Damage radius of shield upon destruction
	
	self:SetStackCount(self.shield_full) -- Put a visible number on modifier to track shield HP
	
	-- Strong dispel on target
	self:GetParent():Purge(false, true, false, true, true)
	
	-- Play shield creation and shield looping sounds
	EmitSoundOn("Hero_Abaddon.AphoticShield.Cast", self:GetParent())
	EmitSoundOn("Hero_Abaddon.AphoticShield.Loop", self:GetParent())
	
	--Copied from hero_abbadon.lua with appropriately changed parameters
	local shield_size = self:GetParent():GetModelRadius() * 0.7
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	local common_vector = Vector(shield_size,0,shield_size)
	ParticleManager:SetParticleControl(particle, 1, common_vector)
	ParticleManager:SetParticleControl(particle, 2, common_vector)
	ParticleManager:SetParticleControl(particle, 4, common_vector)
	ParticleManager:SetParticleControl(particle, 5, Vector(shield_size,0,0))

	-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
	ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(particle, false, false, -1, false, false)
	--
end

-- Only called if buff overlaps with itself (which is probably never)
function modifier_mutation_aphotic_shield:OnRefresh()
	if IsServer() then
		-- This is just a carbon copy of the OnDestroy code; can probably be simplified into a function but I'm bad with linking all the variables together
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
	
		EmitSoundOn("Hero_Abaddon.AphoticShield.Destroy", self:GetParent())
		
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	
		-- Explode on the enemies
		for _,enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = self.shield_full, damage_type = DAMAGE_TYPE_MAGICAL})
		end
		
		-- Refresh stacks / shield HP
		self.shield_remain = self.shield_full 
		self:SetStackCount(self.shield_full)
		
		self:GetParent():Purge(false, true, false, true, true)
		
		EmitSoundOn("Hero_Abaddon.AphoticShield.Cast", self:GetParent())
		EmitSoundOn("Hero_Abaddon.AphoticShield.Loop", self:GetParent())
	end
end

function modifier_mutation_aphotic_shield:OnDestroy()
	if IsServer() then
		-- This block specifically for illusions...apparently
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
	
		EmitSoundOn("Hero_Abaddon.AphoticShield.Destroy", self:GetParent())
		
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	
		-- Explode on the enemies
		for _,enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = self.shield_full, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end
end

function modifier_mutation_aphotic_shield:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_AVOID_DAMAGE 
	}

	return decFuncs
end

function modifier_mutation_aphotic_shield:GetModifierAvoidDamage(traits)
	local blocked = 0
		
	-- Reduce shield stacks / HP based on damage taken
	self.shield_remain = self.shield_remain - traits.damage
	self:SetStackCount(self.shield_remain)
	
	-- Explode shield upon hitting 0 (or less) HP
	if self.shield_remain <= 0 then
		blocked = self.shield_remain
		self:Destroy()
	else
		blocked = traits.damage
	end
	
	return blocked
end