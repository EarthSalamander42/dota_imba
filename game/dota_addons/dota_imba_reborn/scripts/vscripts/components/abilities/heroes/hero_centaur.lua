-- Editors:
--     Seinken, 05.03.2017

---------------------------------
-- 		   Thick Hide          --
---------------------------------

imba_centaur_thick_hide = class({})
LinkLuaModifier("modifier_imba_thick_hide", "components/abilities/heroes/hero_centaur.lua", LUA_MODIFIER_MOTION_NONE)

function imba_centaur_thick_hide:GetAbilityTextureName()
	return "custom/centaur_thick_hide"
end

function imba_centaur_thick_hide:GetIntrinsicModifierName()
	return "modifier_imba_thick_hide"
end

function imba_centaur_thick_hide:IsInnateAbility()
	return true
end

-- Thick hide modifier
modifier_imba_thick_hide = class({})

function modifier_imba_thick_hide:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.damage_reduction_pct = self.ability:GetSpecialValueFor("damage_reduction_pct")
	self.debuff_duration_red_pct = self.ability:GetSpecialValueFor("debuff_duration_red_pct")
end

function modifier_imba_thick_hide:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return decFuncs
end

function modifier_imba_thick_hide:GetModifierIncomingDamage_Percentage()
	-- Does nothing if hero has break
	if self.caster:PassivesDisabled() then
		return nil
	end

	return self.damage_reduction_pct * (-1)
end

function modifier_imba_thick_hide:GetModifierStatusResistanceStacking()
	return self.debuff_duration_red_pct
end

---------------------------------
-- 		   Hoof Stomp          --
---------------------------------


imba_centaur_hoof_stomp = class({})
LinkLuaModifier("modifier_imba_hoof_stomp_stun", "components/abilities/heroes/hero_centaur.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoof_stomp_arena_debuff", "components/abilities/heroes/hero_centaur.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoof_stomp_arena_buff", "components/abilities/heroes/hero_centaur.lua", LUA_MODIFIER_MOTION_NONE)

function imba_centaur_hoof_stomp:GetAbilityTextureName()
	return "centaur_hoof_stomp"
end

function imba_centaur_hoof_stomp:IsHiddenWhenStolen()
	return false
end

function imba_centaur_hoof_stomp:GetCastRange(location, target)
	local caster = self:GetCaster()
	local base_range = self.BaseClass.GetCastRange(self, location, target)

	return base_range
end

function imba_centaur_hoof_stomp:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self
		local particle_stomp = "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf"
		local particle_arena = "particles/hero/centaur/centaur_hoof_stomp_arena.vpcf"
		local sound_cast = "Hero_Centaur.HoofStomp"
		local cast_response = "centaur_cent_hoof_stomp_0"..RandomInt(1, 2)
		local kill_response = "centaur_cent_hoof_stomp_0"..RandomInt(4, 5)
		local modifier_arena_debuff = "modifier_imba_hoof_stomp_arena_debuff"
		local modifier_arena_buff = "modifier_imba_hoof_stomp_arena_buff"
		local modifier_stun = "modifier_imba_hoof_stomp_stun"
		local arena_center = caster:GetAbsOrigin()
		self.lastCasterLocation = nil

		caster:RemoveModifierByName("modifier_imba_return_passive")
		caster:AddNewModifier(caster,caster:FindAbilityByName("imba_centaur_return"),"modifier_imba_return_passive",{})

		-- Ability specials
		local radius = ability:GetSpecialValueFor("radius")
		local stun_duration = ability:GetSpecialValueFor("stun_duration")
		local stomp_damage = ability:GetSpecialValueFor("stomp_damage")
		local pit_duration = ability:GetSpecialValueFor("pit_duration")


		-- Roll for cast response
		local cast_response_chance = 50
		local cast_response_roll = RandomInt(1, 100)
		if cast_response_roll <= cast_response_chance then
			EmitSoundOn(cast_response, caster)
		end

		-- Play cast sound
		EmitSoundOn(sound_cast, caster)

		-- Add stomp particle
		local particle_stomp_fx = ParticleManager:CreateParticle(particle_stomp, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_stomp_fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_stomp_fx, 1, Vector(radius, 1, 1))
		ParticleManager:SetParticleControl(particle_stomp_fx, 2, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_stomp_fx)

		-- Find all nearby enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			arena_center,
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false)

		for _, enemy in pairs(enemies) do
			-- Deal damage to nearby non-magic immune enemies
			if not enemy:IsMagicImmune() then
				local damageTable = {victim = enemy,
					attacker = caster,
					damage = stomp_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = ability}

				ApplyDamage(damageTable)

				-- Stun them
				enemy:AddNewModifier(caster, ability, modifier_stun, {duration = stun_duration})

				-- Check if the damage killed enemy
				if enemy:IsRealHero() and not enemy:IsAlive() then
					kill_response_chance = 25
					kill_response_roll = RandomInt(1, 100)

					if kill_response_roll <= kill_response_chance then
						EmitSoundOn(kill_response, caster)
					end
				end
			end
		end
	
		-- Prevents overlapping permanent particle effects from Hoof Stomp spam
		if self.particle_arena_fx then
			ParticleManager:DestroyParticle(self.particle_arena_fx, false)
			ParticleManager:ReleaseParticleIndex(self.particle_arena_fx)
		end
		
		-- Add arena particles for the duration
		self.particle_arena_fx = ParticleManager:CreateParticle(particle_arena, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(self.particle_arena_fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_arena_fx, 1, Vector(radius+45, 1, 1))
		Timers:CreateTimer(pit_duration, function()
			ParticleManager:DestroyParticle(self.particle_arena_fx, false)
			ParticleManager:ReleaseParticleIndex(self.particle_arena_fx)
		end)

		-- Index a modifier to send the modifier the arena center variable.
		local modifier

		-- Give buff to the caster
		modifier = caster:AddNewModifier(caster, ability, modifier_arena_buff, {duration = pit_duration})
		if modifier then
			modifier.arena_center = arena_center
		end

		-- #2 Talent: Arena buff to allies as well
		if caster:HasTalent("special_bonus_imba_centaur_2") then
			-- Mark caster
			caster.has_arena_talent2 = true

			-- Find all nearby allies
			local allies = FindUnitsInRadius(caster:GetTeamNumber(),
				arena_center,
				nil,
				radius,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
				FIND_ANY_ORDER,
				false
			)

			for _,ally in pairs(allies) do
				modifier = ally:AddNewModifier(caster, ability, modifier_arena_buff, {duration = pit_duration})
				if modifier then
					modifier.arena_center = arena_center
				end
			end
		end

		-- Give debuff to the enemies in the area
		for _,enemy in pairs(enemies) do
			modifier = enemy:AddNewModifier(caster, ability, modifier_arena_debuff, {duration = pit_duration})
			if modifier then
				modifier.arena_center = arena_center
			end
		end

		-- Elapsed time
		local elapsed_time = 0

		-- Keep checking if the caster or new enemies came inside the arena
		Timers:CreateTimer(FrameTime(), function()
			-- Increase the elapsed time
			elapsed_time = elapsed_time + FrameTime()

			-- Resolve NPCs stuck into one another
			ResolveNPCPositions(arena_center, radius)

			if caster:HasTalent("special_bonus_imba_centaur_3") then
				local arena_center = caster:GetAbsOrigin()
				for _,enemy in pairs(enemies) do
					modifier = enemy:FindModifierByName(modifier_arena_debuff)
					if modifier then
						modifier.arena_center = arena_center
					end
				end

				-- Check if caster moved more then the allowed units in one frame, if he does stop this effect.
				if self.lastCasterLocation then
					local distance = (caster:GetAbsOrigin() - self.lastCasterLocation):Length2D()
					if distance > caster:FindTalentValue("special_bonus_imba_centaur_3") then
						caster:RemoveModifierByName(modifier_arena_buff)
						ParticleManager:DestroyParticle(self.particle_arena_fx,true)
						ParticleManager:ReleaseParticleIndex(self.particle_arena_fx)
						return nil
					end
				end
				self.lastCasterLocation = caster:GetAbsOrigin()

				ParticleManager:SetParticleControl(self.particle_arena_fx, 0, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(self.particle_arena_fx, 1, Vector(radius+45, 1, 1))
				ParticleManager:SetParticleControl(self.particle_arena_fx, 5, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(self.particle_arena_fx, 6, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(self.particle_arena_fx, 7, caster:GetAbsOrigin())
			end

			-- Check caster, if he doesn't have the arena modifier and he's in the arena, give it to him again
			if not caster:HasModifier(modifier_arena_buff) then
				local distance = (caster:GetAbsOrigin() - arena_center):Length2D()
				if distance <= radius then
					modifier = caster:AddNewModifier(caster, ability, modifier_arena_buff, {duration = pit_duration - elapsed_time})
					if modifier then
						modifier.arena_center = arena_center
					end
				end
			end

			-- #2 Talent: Arena buff to allies as well (extend)
			-- Check allies, same as caster
			if caster.has_arena_talent2 then
				-- Find all nearby allies
				local allies = FindUnitsInRadius(caster:GetTeamNumber(),
					arena_center,
					nil,
					radius,
					DOTA_UNIT_TARGET_TEAM_FRIENDLY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
					FIND_ANY_ORDER,
					false)

				for _,ally in pairs(allies) do
					if not ally:HasModifier(modifier_arena_buff) then
						local distance = (ally:GetAbsOrigin() - arena_center):Length2D()
						if distance <= radius then
							modifier = ally:AddNewModifier(caster, ability, modifier_arena_buff, {duration = pit_duration - elapsed_time})
							if modifier then
								modifier.arena_center = arena_center
							end
						end
					end
				end
			end

			-- Check for new enemies
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
				arena_center,
				nil,
				radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
				FIND_ANY_ORDER,
				false)

			for _,enemy in pairs(enemies) do
				if not enemy:HasModifier(modifier_arena_debuff) then
					modifier = enemy:AddNewModifier(caster, ability, modifier_arena_debuff, {duration = pit_duration - elapsed_time})
					if modifier then
						modifier.arena_center = arena_center
					end
				end
			end

			-- Check if the timer should repeat
			if elapsed_time >= pit_duration then
				return nil
			else
				return FrameTime()
			end
		end)
	end
end

-- Stun modifier
modifier_imba_hoof_stomp_stun = class({})

function modifier_imba_hoof_stomp_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_hoof_stomp_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_hoof_stomp_stun:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state
end

function modifier_imba_hoof_stomp_stun:IsDebuff()
	return true
end

function modifier_imba_hoof_stomp_stun:IsStunDebuff()
	return true
end

function modifier_imba_hoof_stomp_stun:IsHidden()
	return false
end



-- Arena debuff (enemies)
modifier_imba_hoof_stomp_arena_debuff = class({})

function modifier_imba_hoof_stomp_arena_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.pit_dmg_reduction = self.ability:GetSpecialValueFor("pit_dmg_reduction")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.maximum_distance = self.ability:GetSpecialValueFor("maximum_distance")


	-- Wait a game tick so indexing the arena center would complete, then start thinking.
	if IsServer() then
		Timers:CreateTimer(FrameTime(), function()
			-- Start thinker
			if not self:IsNull() then
				self:StartIntervalThink(0)
			end
		end)
	end
end

function modifier_imba_hoof_stomp_arena_debuff:OnIntervalThink()
	if IsServer() then
		if not self:GetCaster():HasModifier("modifier_imba_hoof_stomp_arena_buff") then self:Destroy() return end
		-- Calculate distance
		local distance = (self.parent:GetAbsOrigin() - self.arena_center):Length2D()

		-- If the parent is trying to leave the arena, teleport it back to the edge of it, unless it blinked far away (TP)
		if distance-1 > self.radius and distance < self.maximum_distance then
			-- Decide the location of the edge
			local direction = (self.parent:GetAbsOrigin() - self.arena_center):Normalized()
			local edge_point = self.arena_center + direction * self.radius

			-- Set the enemy at the edge of the arena
			self.parent:SetAbsOrigin(edge_point)
		end
	end
end

function modifier_imba_hoof_stomp_arena_debuff:IsPurgable()
	return false
end

function modifier_imba_hoof_stomp_arena_debuff:IsDebuff()
	return true
end

-- Arena buff
modifier_imba_hoof_stomp_arena_buff = class({})

function modifier_imba_hoof_stomp_arena_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.pit_dmg_reduction = self.ability:GetSpecialValueFor("pit_dmg_reduction")
	self.radius = self.ability:GetSpecialValueFor("radius")

	-- Wait a game tick so indexing the arena center would complete, then start thinking.
	if IsServer() then
		Timers:CreateTimer(FrameTime(), function()
			-- Start thinker
			if not self:IsNull() then
				self:StartIntervalThink(0)
			end
		end)
	end

end

function modifier_imba_hoof_stomp_arena_buff:OnIntervalThink()
	if IsServer() then
		-- Calculate distance
		local distance = (self.parent:GetAbsOrigin() - self.arena_center):Length2D()

		-- Check if the caster left the arena, if so, remove the modifier from it
		if distance-100 > self.radius then
			self:Destroy()
		end
	end
end

function modifier_imba_hoof_stomp_arena_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}

	return decFuncs
end

function modifier_imba_hoof_stomp_arena_buff:GetModifierIncomingDamage_Percentage()
	return self.pit_dmg_reduction * (-1)
end

function modifier_imba_hoof_stomp_arena_buff:IsPurgable()
	return false
end

function modifier_imba_hoof_stomp_arena_buff:IsDebuff()
	return false
end



---------------------------------
-- 		   Double Edge         --
---------------------------------


imba_centaur_double_edge = class({})
LinkLuaModifier("modifier_imba_double_edge_death_prevent", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)

function imba_centaur_double_edge:GetAbilityTextureName()
	return "centaur_double_edge"
end

function imba_centaur_double_edge:IsHiddenWhenStolen()
	return false
end

function imba_centaur_double_edge:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self
		local target = self:GetCursorTarget()
		local sound_cast = "Hero_Centaur.DoubleEdge"
		local cast_response
		local kill_response = "centaur_cent_doub_edge_0"..RandomInt(5, 6)
		local particle_edge = "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf"
		local modifier_prevent = "modifier_imba_double_edge_death_prevent"

		-- Ability specials
		-- #4 Talent: Damage increased by 2*strength
		local damage = ability:GetSpecialValueFor("damage") + (caster:FindTalentValue("special_bonus_imba_centaur_4") * caster:GetStrength())
		local radius = ability:GetSpecialValueFor("radius")
		local str_damage_reduction = ability:GetSpecialValueFor("str_damage_reduction")


		-- Cast responses are troublesome for this spell so they get their own section
		-- Roll for a cast response
		if RollPercentage(75) then
			-- Roll a response number
			local cast_response_number = RandomInt(1, 11)

			-- Check if number represents a cast response (5 and 6 aren't). If it isn't, roll again
			while cast_response_number == 5 or cast_response_number == 6 do
				cast_response_number = RandomInt(1, 11)
			end

			-- Assign correct file format
			if cast_response_number < 10 then
				cast_response = "centaur_cent_doub_edge_0"
			else
				cast_response = "centaur_cent_doub_edge_"
			end

			-- Build full path
			local cast_response = cast_response..cast_response_number

			-- Play cast response
			EmitSoundOn(cast_response, caster)
		end

		-- Play cast sound
		EmitSoundOn(sound_cast, caster)

		-- If target has Linken's sphere ready, do nothing
		if caster:GetTeamNumber() ~= target:GetTeamNumber() then
			if target:TriggerSpellAbsorb(ability) then
				return nil
			end
		end

		-- Add double edge particle
		local particle_edge_fx = ParticleManager:CreateParticle(particle_edge, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_edge_fx, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_edge_fx, 1, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_edge_fx, 2, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_edge_fx, 4, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_edge_fx, 5, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_edge_fx)

		-- Apply death prevention modifier to caster
		caster:AddNewModifier(caster, ability, modifier_prevent, {})

		-- Calculate self damage, using Centaur's Strength
		local strength = caster:GetStrength() * (str_damage_reduction/100)
		local self_damage = damage - strength

		-- Damage caster
		local damageTable = {victim = caster,
			attacker = caster,
			damage = self_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability}

		ApplyDamage(damageTable)

		-- Remove death prevention modifier
		if caster:HasModifier(modifier_prevent) then
			caster:RemoveModifierByName(modifier_prevent)
		end

		-- Find all enemies in the target's radius
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			target:GetAbsOrigin(),
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		-- Damage each non-magic immune target
		for _,enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() then
				local damageTable = {victim = enemy,
					attacker = caster,
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = ability}

				ApplyDamage(damageTable)

				-- Check if an enemy died from the damage, and check if it should play a kill response
				if not enemy:IsIllusion() and not enemy:IsAlive() then
					if RollPercentage(15) then
						EmitSoundOn(kill_response, caster)
					end
				end
			end
		end

	end

end


-- Death prevention modifier for the caster
modifier_imba_double_edge_death_prevent = class({})

function modifier_imba_double_edge_death_prevent:IsHidden()
	return true
end

function modifier_imba_double_edge_death_prevent:IsPurgable()
	return false
end

function modifier_imba_double_edge_death_prevent:IsDebuff()
	return false
end

function modifier_imba_double_edge_death_prevent:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MIN_HEALTH}

	return decFuncs
end

function modifier_imba_double_edge_death_prevent:GetMinHealth()
	return 1
end



---------------------------------
-- 		   Return 		       --
---------------------------------

imba_centaur_return = class({})
LinkLuaModifier("modifier_imba_return_aura", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_return_passive", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_return_damage_block", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_return_damage_block_buff", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_return_bonus_damage", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)

function imba_centaur_return:GetAbilityTextureName()
	return "centaur_return"
end

function imba_centaur_return:GetIntrinsicModifierName()
	return "modifier_imba_return_aura"
end

function imba_centaur_return:OnAbilityPhaseStart()
	if self:GetCaster():FindModifierByName("modifier_imba_return_passive"):GetStackCount() == 0 then
		return false
	end

	return true
end

function imba_centaur_return:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_return_bonus_damage", {duration=self:GetSpecialValueFor("duration")}):SetStackCount(self:GetCaster():FindModifierByName("modifier_imba_return_passive"):GetStackCount())
		self:GetCaster():FindModifierByName("modifier_imba_return_passive"):SetStackCount(0)
		self:GetCaster():EmitSound("Hero_Centaur.Retaliate.Cast")
	end
end

-- Return Aura
modifier_imba_return_aura = class({})

function modifier_imba_return_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
end

function modifier_imba_return_aura:GetAuraEntityReject(target)
	-- Check the target for aura validity
	if self.caster == target then
		return false -- allow aura on caster
	else
		-- #6 Talent: Return becomes an aura
		if self.caster:HasTalent("special_bonus_imba_centaur_6") then
			return false
		end
	end

	return true
end

function modifier_imba_return_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_return_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_return_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_return_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_return_aura:GetModifierAura()
	return "modifier_imba_return_passive"
end

function modifier_imba_return_aura:IsAura()
	return true
end

function modifier_imba_return_aura:IsDebuff()
	return false
end

function modifier_imba_return_aura:IsHidden()
	return true
end

function modifier_imba_return_aura:IsPurgable()
	return false
end

function modifier_imba_return_aura:IsPermanent()
	return true
end

-- Return modifier
modifier_imba_return_passive = class({})

function modifier_imba_return_passive:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_imba_return_passive:OnTakeDamage(keys)
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local attacker = keys.attacker
		local target = keys.unit
		local particle_return = "particles/units/heroes/hero_centaur/centaur_return.vpcf"
		local modifier_damage_block = "modifier_imba_return_damage_block"
		local particle_block_msg = "particles/msg_fx/msg_block.vpcf"
		-- Ability specials
		local damage = ability:GetSpecialValueFor("damage")
		local str_pct_as_damage = ability:GetSpecialValueFor("str_pct_as_damage")
		local damage_block = ability:GetSpecialValueFor("damage_block")
		local block_duration = ability:GetSpecialValueFor("block_duration")

		-- #1 Talent:Reduced self damage_block
		str_pct_as_damage = str_pct_as_damage + caster:FindTalentValue("special_bonus_imba_centaur_1")

		-- Not inherited by illusions
		if not target:IsRealHero() then
			return nil
		end

		-- Disabled by break
		if parent:PassivesDisabled() then
			return nil
		end

		if attacker:IsBuilding() then
			return nil
		end

		-- Only commence on enemies attacking Centaur
		if attacker:GetTeamNumber() ~= parent:GetTeamNumber() and parent == target
			-- Don't affect wards.
			and not attacker:IsOther() then
			-- #7 Talent:Return's Bulging Hide gains stacks from all auto attacks, or any kind of damage above 100.
			if not caster:HasTalent("special_bonus_imba_centaur_7") then
				if keys.inflictor then
					return
				end
			else
				if keys.inflictor and keys.damage < caster:FindTalentValue("special_bonus_imba_centaur_7") then
					return
				end
			end

			-- Centaur-Nyx Carcapace handler
			if self.reflect_handler then return end
			-- Note: Might remove this `if` this happens again
			if attacker:FindModifierByName("modifier_imba_spiked_carapace") then
				self.reflect_handler = true
				Timers:CreateTimer(FrameTime(),function()
					self.reflect_handler = false
				end)
			end

			-- Add return particle
			local particle_return_fx = ParticleManager:CreateParticle(particle_return, PATTACH_ABSORIGIN, parent)
			ParticleManager:SetParticleControlEnt(particle_return_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle_return_fx, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle_return_fx)

			-- Calculate damage using Centaur's strength
			local final_damage = damage + caster:GetStrength() * (str_pct_as_damage/100)

			-- Apply damage on attacker
			local damageTable = {victim = attacker,
				attacker = parent,
				damage = final_damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				ability = ability}

			ApplyDamage(damageTable)

			-- Add damage block modifier if parent doesn't have one
			if not parent:HasModifier(modifier_damage_block) then
				parent:AddNewModifier(parent, ability, modifier_damage_block, {})
			end

			parent:AddNewModifier(parent, ability, "modifier_imba_return_damage_block_buff", {duration = block_duration})
		end
	end
end

function modifier_imba_return_passive:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		if self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("max_stacks") then
			return nil
		end

		-- Only apply if the parent is the victim and the attacker is on the opposite team
		if self:GetParent() == target and attacker:GetTeamNumber() ~= target:GetTeamNumber() then
			if attacker:IsHero() or attacker:IsTower() then
				self:SetStackCount(self:GetStackCount() + 1)
			end
		end
	end
end

function modifier_imba_return_passive:IsHidden()
	return false
end

function modifier_imba_return_passive:IsPurgable()
	return false
end

function modifier_imba_return_passive:IsDebuff()
	return false
end

-- Damage block modifier
modifier_imba_return_damage_block = class({})
modifier_imba_return_damage_block_buff =({})


function modifier_imba_return_damage_block:IsHidden() return false end
function modifier_imba_return_damage_block:IsPurgable()	return false end
function modifier_imba_return_damage_block:IsDebuff() return false end

function modifier_imba_return_damage_block:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.damage_block = self.ability:GetSpecialValueFor("damage_block")

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_return_damage_block:OnIntervalThink()
	local buffs = self:GetParent():FindAllModifiersByName("modifier_imba_return_damage_block_buff")
	if #buffs > 0 then
		self:SetStackCount(#buffs)
	else
		self:Destroy()
	end
end

function modifier_imba_return_damage_block:GetCustomDamageBlock()
	return self.damage_block * self:GetStackCount()
end

function modifier_imba_return_damage_block_buff:IsDebuff()			return true end
function modifier_imba_return_damage_block_buff:IsHidden() 			return true end
function modifier_imba_return_damage_block_buff:IsPurgable() 		return true end
function modifier_imba_return_damage_block_buff:IsPurgeException() 	return true end
function modifier_imba_return_damage_block_buff:IsStunDebuff() 		return false end
function modifier_imba_return_damage_block_buff:RemoveOnDeath() 	return true end
function modifier_imba_return_damage_block_buff:GetAttributes() 	return MODIFIER_ATTRIBUTE_MULTIPLE end

modifier_imba_return_bonus_damage = class({})

function modifier_imba_return_bonus_damage:GetEffectName()
	return "particles/units/heroes/hero_centaur/centaur_return_buff.vpcf"
end

function modifier_imba_return_bonus_damage:GetEffectAttachType()
	return "attach_attack1"
end

function modifier_imba_return_bonus_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_imba_return_bonus_damage:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage") * self:GetStackCount()
end

---------------------------------
-- 		   Stampede            --
---------------------------------

imba_centaur_stampede = class({})
LinkLuaModifier("modifier_imba_stampede_haste", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_stampede_trample_stun", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_stampede_trample_slow", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)

function imba_centaur_stampede:GetAbilityTextureName()
	return "centaur_stampede"
end

function imba_centaur_stampede:IsHiddenWhenStolen()
	return false
end

function imba_centaur_stampede:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self
		local sound_cast = "Hero_Centaur.Stampede.Cast"
		local cast_animation = ACT_DOTA_CENTAUR_STAMPEDE
		local modifier_haste = "modifier_imba_stampede_haste"

		-- Ability specials
		local duration = ability:GetSpecialValueFor("duration")

		-- Play cast sound
		EmitSoundOn(sound_cast, caster)

		-- Play cast animation
		caster:StartGesture(cast_animation)

		-- Should we inform the bitches they need to move?
		local bitch_be_gone = 15
		if RollPercentage(bitch_be_gone) then
			EmitSoundOn("Imba.CentaurMoveBitch", caster)
		end

		-- Find all enemies and clear trample marks from them
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
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

		-- Find all allied heroes and player controlled creeps
		local allies = FindUnitsInRadius(caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			25000, -- global
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
			FIND_ANY_ORDER,
			false)

		-- Give them haste buff
		for _,ally in pairs (allies) do
			ally:AddNewModifier(caster, ability, modifier_haste, {duration = duration})
		end
	end
end

-- Haste modifier
modifier_imba_stampede_haste = class({})

function modifier_imba_stampede_haste:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_stampede = "particles/units/heroes/hero_centaur/centaur_stampede.vpcf"
	self.scepter = self.caster:HasScepter()
	self.modifier_trample_stun = "modifier_imba_stampede_trample_stun"
	self.modifier_trample_slow = "modifier_imba_stampede_trample_slow"

	-- Ability specials
	self.strength_damage = self.ability:GetSpecialValueFor("strength_damage")
	self.stun_duration = self.ability:GetSpecialValueFor("stun_duration")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.damage_reduction_scepter = self.ability:GetSpecialValueFor("damage_reduction_scepter")
	self.absolute_move_speed = self.ability:GetSpecialValueFor("absolute_move_speed")
	self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")
	self.tree_destruction_radius = self.ability:GetSpecialValueFor("tree_destruction_radius")
	self.nether_ward_damage = self.ability:GetSpecialValueFor("nether_ward_damage")

	if IsServer() then
		-- Nether ward interaction
		if self.caster:IsHero() then
			-- Generate caster's strength, calculate damage
			self.trample_damage = self.caster:GetStrength() * (self.strength_damage * 0.01)
		else
			self.trample_damage = self.nether_ward_damage
		end

		-- Add stampede particles
		self.particle_stampede_fx = ParticleManager:CreateParticle(self.particle_stampede, PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.particle_stampede_fx, 0, self.parent:GetAbsOrigin())
		self:AddParticle(self.particle_stampede_fx, false, false, -1, false, false)

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_stampede_haste:OnIntervalThink()
	if IsServer() then
		-- Look for nearby enemies
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self.parent:GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		-- If enemy wasn't trampled before, trample it now
		for _,enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() and not enemy.trampled_in_stampede then
				-- Mark it as trampled
				enemy.trampled_in_stampede = true

				-- Deal damage
				local damageTable = {victim = enemy,
					attacker = self.parent,
					damage = self.trample_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self.ability}

				ApplyDamage(damageTable)

				-- Add stun and slow modifiers to the enemy
				enemy:AddNewModifier(self.caster, self.ability, self.modifier_trample_stun, {duration = self.stun_duration})
				enemy:AddNewModifier(self.caster, self.ability, self.modifier_trample_slow, {duration = self.stun_duration + self.slow_duration})

				-- #8 Talent: Stampede duration increase per trampled enemy
				if self.caster:HasTalent("special_bonus_imba_centaur_8") and enemy:IsRealHero() then
					-- Get bonus duration per trample
					local bonus_stampede_duration = self.caster:FindTalentValue("special_bonus_imba_centaur_8")

					-- Find all allies
					local allies = FindUnitsInRadius(self.caster:GetTeamNumber(),
						self.parent:GetAbsOrigin(),
						nil,
						50000, -- global
						DOTA_UNIT_TARGET_TEAM_FRIENDLY,
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
						FIND_ANY_ORDER,
						false)

					-- Find their Stampede modifier and increase its duration
					for _,ally in pairs(allies) do
						if ally:HasModifier("modifier_imba_stampede_haste") then
							local modifier_haste_handler = ally:FindModifierByName("modifier_imba_stampede_haste")
							modifier_haste_handler:SetDuration(modifier_haste_handler:GetRemainingTime() + bonus_stampede_duration, true)
						end
					end
				end
			end
		end

		-- If caster has scepter, search for and destroy nearby trees
		if self.scepter then
			GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), self.tree_destruction_radius, true)
		end
	end
end

function modifier_imba_stampede_haste:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}

	return decFuncs
end

function modifier_imba_stampede_haste:GetModifierMoveSpeed_Absolute()
	return self.absolute_move_speed
end

function modifier_imba_stampede_haste:GetModifierIncomingDamage_Percentage()
	-- Reduce incoming damage if caster has scepter
	if self.scepter then
		return self.damage_reduction_scepter * (-1)
	end

	return nil
end

function modifier_imba_stampede_haste:GetModifierStatusResistanceStacking()
	return self:GetCaster():FindTalentValue("special_bonus_imba_centaur_5")
end

function modifier_imba_stampede_haste:CheckState()
	local state

	-- Gain cliffwalk if the caster has scepter
	if self.scepter then
		state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true}
	else
		state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	end

	return state
end

function modifier_imba_stampede_haste:GetEffectName()
	return "particles/units/heroes/hero_centaur/centaur_stampede_overhead.vpcf"
end

function modifier_imba_stampede_haste:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_stampede_haste:IsPurgable()
	return false
end

function modifier_imba_stampede_haste:IsHidden()
	return false
end

function modifier_imba_stampede_haste:IsDebuff()
	return false
end

-- Trample stun modifier
modifier_imba_stampede_trample_stun = class({})

function modifier_imba_stampede_trample_stun:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}

	return state
end

-- After-trample slow modifier
modifier_imba_stampede_trample_slow = class({})

function modifier_imba_stampede_trample_slow:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
end

function modifier_imba_stampede_trample_slow:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_imba_stampede_trample_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end
