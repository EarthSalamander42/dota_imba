-- Editors:
--     Seinken, 05.03.2017
--	   AltiV, 17.03.2020, and many times before that

---------------------------------
-- 		   Thick Hide          --
---------------------------------

imba_centaur_thick_hide = class({})
LinkLuaModifier("modifier_imba_thick_hide", "components/abilities/heroes/hero_centaur.lua", LUA_MODIFIER_MOTION_NONE)

function imba_centaur_thick_hide:GetIntrinsicModifierName()
	return "modifier_imba_thick_hide"
end

function imba_centaur_thick_hide:IsInnateAbility()
	return true
end

-- Thick hide modifier
modifier_imba_thick_hide = class({})

function modifier_imba_thick_hide:IsHidden() return true end

function modifier_imba_thick_hide:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
end

function modifier_imba_thick_hide:GetModifierIncomingDamage_Percentage()
	if self:GetAbility() and not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("damage_reduction_pct") * (-1)
	end
end

function modifier_imba_thick_hide:GetModifierStatusResistanceStacking()
	if self:GetAbility() and not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("debuff_duration_red_pct")
	end
end

---------------------------------
-- 		   Hoof Stomp          --
---------------------------------

imba_centaur_hoof_stomp = class({})

LinkLuaModifier("modifier_imba_hoof_stomp_arena_thinker_buff", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoof_stomp_arena_thinker_debuff", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoof_stomp_arena_debuff", "components/abilities/heroes/hero_centaur.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoof_stomp_arena_buff", "components/abilities/heroes/hero_centaur.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoof_stomp_arena_debuff", "components/abilities/heroes/hero_centaur.lua", LUA_MODIFIER_MOTION_NONE)

modifier_imba_hoof_stomp_arena_thinker_buff   = modifier_imba_hoof_stomp_arena_thinker_buff or class({})
modifier_imba_hoof_stomp_arena_thinker_debuff = modifier_imba_hoof_stomp_arena_thinker_debuff or class({})

function imba_centaur_hoof_stomp:IsHiddenWhenStolen()
	return false
end

function imba_centaur_hoof_stomp:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) - self:GetCaster():GetCastRangeBonus()
end

function imba_centaur_hoof_stomp:OnSpellStart()
	-- Play cast sound
	self:GetCaster():EmitSound("Hero_Centaur.HoofStomp")

	-- Roll for cast response
	if self:GetCaster():GetName() == "npc_dota_hero_centaur" and RandomInt(1, 100) <= 50 then
		EmitSoundOn("centaur_cent_hoof_stomp_0" .. RandomInt(1, 2), self:GetCaster())
	end

	-- Add stomp particle
	local particle_stomp_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_stomp_fx, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_stomp_fx, 1, Vector(self:GetSpecialValueFor("radius"), 1, 1))
	ParticleManager:SetParticleControl(particle_stomp_fx, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_stomp_fx)

	self.enemy_entindex_table = {}

	-- Find all nearby enemies
	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)) do
		self.enemy_entindex_table[enemy:entindex()] = true

		if not enemy:IsMagicImmune() then
			-- "The stomp first applies the debuff, then the damage."

			-- Stun them
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("stun_duration") * (1 - enemy:GetStatusResistance()) })

			-- Deal damage to nearby non-magic immune enemies
			ApplyDamage({
				victim       = enemy,
				damage       = self:GetSpecialValueFor("stomp_damage"),
				damage_type  = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = self:GetCaster(),
				ability      = self
			})

			-- Check if the damage killed enemy
			if enemy:IsRealHero() and not enemy:IsAlive() and self:GetCaster():GetName() == "npc_dota_hero_centaur" and RollPercentage(25) then
				EmitSoundOn("centaur_cent_hoof_stomp_0" .. RandomInt(4, 5), self:GetCaster())
			end
		end
	end

	-- IMBAfication: Gladiator's Pit
	local buff_thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_hoof_stomp_arena_thinker_buff", { duration = self:GetSpecialValueFor("pit_duration") }, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	local debuff_thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_hoof_stomp_arena_thinker_debuff", { duration = self:GetSpecialValueFor("pit_duration") }, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
end

-------------------------------------------------
-- MODIFIER_IMBA_HOOF_STOMP_ARENA_THINKER_BUFF --
-------------------------------------------------

function modifier_imba_hoof_stomp_arena_thinker_buff:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_imba_hoof_stomp_arena_thinker_buff:IsAura() return true end

function modifier_imba_hoof_stomp_arena_thinker_buff:IsAuraActiveOnDeath() return false end

function modifier_imba_hoof_stomp_arena_thinker_buff:GetAuraDuration() return 0.25 end

function modifier_imba_hoof_stomp_arena_thinker_buff:GetAuraRadius() return self.radius end

function modifier_imba_hoof_stomp_arena_thinker_buff:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_imba_hoof_stomp_arena_thinker_buff:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_imba_hoof_stomp_arena_thinker_buff:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_imba_hoof_stomp_arena_thinker_buff:GetModifierAura() return "modifier_imba_hoof_stomp_arena_buff" end

function modifier_imba_hoof_stomp_arena_thinker_buff:GetAuraEntityReject(target) return target ~= self:GetCaster() and not self:GetCaster():HasTalent("special_bonus_imba_centaur_2") end

---------------------------------------------------
-- MODIFIER_IMBA_HOOF_STOMP_ARENA_THINKER_DEBUFF --
---------------------------------------------------

function modifier_imba_hoof_stomp_arena_thinker_debuff:OnCreated(keys)
	self.radius = self:GetAbility():GetSpecialValueFor("radius")

	if not IsServer() then return end

	self.particle_arena_fx = ParticleManager:CreateParticle("particles/hero/centaur/centaur_hoof_stomp_arena.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(self.particle_arena_fx, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_arena_fx, 1, Vector(self.radius + 45, 1, 1))
	self:AddParticle(self.particle_arena_fx, false, false, -1, false, false)

	self.enemy_entindex_table = keys.enemy_entindex_table

	if self:GetAbility().enemy_entindex_table then
		self.enemy_entindex_table = self:GetAbility().enemy_entindex_table
		self:GetAbility().enemy_entindex_table = nil
	end
end

function modifier_imba_hoof_stomp_arena_thinker_debuff:IsAura() return true end

function modifier_imba_hoof_stomp_arena_thinker_debuff:IsAuraActiveOnDeath() return false end

function modifier_imba_hoof_stomp_arena_thinker_debuff:GetAuraDuration() return 0.25 end

function modifier_imba_hoof_stomp_arena_thinker_debuff:GetAuraRadius() return self.radius end

function modifier_imba_hoof_stomp_arena_thinker_debuff:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end

function modifier_imba_hoof_stomp_arena_thinker_debuff:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_imba_hoof_stomp_arena_thinker_debuff:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_imba_hoof_stomp_arena_thinker_debuff:GetModifierAura() return "modifier_imba_hoof_stomp_arena_debuff" end

function modifier_imba_hoof_stomp_arena_thinker_debuff:GetAuraEntityReject(target) return self.enemy_entindex_table and not self.enemy_entindex_table[target:entindex()] and target:IsMagicImmune() end

-- Arena buff
modifier_imba_hoof_stomp_arena_buff = class({})

function modifier_imba_hoof_stomp_arena_buff:OnCreated()
	if self:GetAbility() then
		self.radius            = self:GetAbility():GetSpecialValueFor("radius")
		self.pit_dmg_reduction = self:GetAbility():GetSpecialValueFor("pit_dmg_reduction") * (-1)
	else
		self.radius            = 350
		self.pit_dmg_reduction = -10
	end
end

function modifier_imba_hoof_stomp_arena_buff:DeclareFunctions()
	return { MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE }
end

function modifier_imba_hoof_stomp_arena_buff:GetModifierIncomingDamage_Percentage()
	return self.pit_dmg_reduction
end

-- Using this as an interval thinker
function modifier_imba_hoof_stomp_arena_buff:CheckState()
	if not IsServer() then return end

	if not self:GetAuraOwner() or (self:GetParent():GetAbsOrigin() - self:GetAuraOwner():GetAbsOrigin()):Length2D() > self.radius then
		self:Destroy()
	end
end

-- Arena debuff (enemies)
modifier_imba_hoof_stomp_arena_debuff = class({})

function modifier_imba_hoof_stomp_arena_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_hoof_stomp_arena_debuff:OnCreated()
	if self:GetAbility() then
		self.radius           = self:GetAbility():GetSpecialValueFor("radius")
		self.maximum_distance = self:GetAbility():GetSpecialValueFor("maximum_distance")
	else
		self.radius           = 350
		self.maximum_distance = 400
	end

	self.position = self:GetParent():GetAbsOrigin()

	-- Seems like CheckState() interavls aren't fast enough to prevent a sort of "glitchy" effect
	self:OnIntervalThink()
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_hoof_stomp_arena_debuff:OnIntervalThink()
	if self:GetAuraOwner() then
		if (self:GetParent():GetAbsOrigin() - self:GetAuraOwner():GetAbsOrigin()):Length2D() > self.radius and (self.position - self:GetParent():GetAbsOrigin()):Length2D() < self.maximum_distance then
			FindClearSpaceForUnit(self:GetParent(), self:GetAuraOwner():GetAbsOrigin() + ((self:GetParent():GetAbsOrigin() - self:GetAuraOwner():GetAbsOrigin()):Normalized() * self.radius), false)
		end

		if (self:GetParent():GetAbsOrigin() - self:GetAuraOwner():GetAbsOrigin()):Length2D() <= self.radius then
			self.position = self:GetParent():GetAbsOrigin()
		end
	end
end

---------------------------------
-- 		   Double Edge         --
---------------------------------


imba_centaur_double_edge = class({})

function imba_centaur_double_edge:IsHiddenWhenStolen()
	return false
end

function imba_centaur_double_edge:OnAbilityPhaseStart()
	if IsServer() then
		self.phase_double_edge_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_double_edge_phase.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster(), self:GetCaster())
		ParticleManager:SetParticleControl(self.phase_double_edge_pfx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.phase_double_edge_pfx, 3, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.phase_double_edge_pfx, 9, self:GetCaster():GetAbsOrigin())
	end

	return true
end

function imba_centaur_double_edge:OnAbilityPhaseInterrupted()
	if self.phase_double_edge_pfx then
		ParticleManager:DestroyParticle(self.phase_double_edge_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.phase_double_edge_pfx)
	end
end

function imba_centaur_double_edge:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self
		local target = self:GetCursorTarget()
		local sound_cast = "Hero_Centaur.DoubleEdge"
		local cast_response
		local kill_response = "centaur_cent_doub_edge_0" .. RandomInt(5, 6)

		-- Ability specials
		-- #4 Talent: Damage increased by 2*strength
		local damage = ability:GetSpecialValueFor("damage") + (caster:GetStrength() * caster:FindTalentValue("special_bonus_imba_centaur_4") / 100)
		local radius = ability:GetSpecialValueFor("radius")

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
			local cast_response = cast_response .. cast_response_number

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
		local particle_edge_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", PATTACH_ABSORIGIN, caster, caster)
		ParticleManager:SetParticleControl(particle_edge_fx, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_edge_fx, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_edge_fx, 2, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_edge_fx, 3, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_edge_fx, 4, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_edge_fx, 5, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_edge_fx, 9, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_edge_fx)

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
		for _, enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() then
				local damageTable = {
					victim = enemy,
					attacker = caster,
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = ability
				}

				ApplyDamage(damageTable)

				local particle_edge_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_double_edge_body.vpcf", PATTACH_ABSORIGIN, caster, caster)
				ParticleManager:SetParticleControl(particle_edge_fx, 2, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_edge_fx, 4, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_edge_fx, 5, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_edge_fx, 9, enemy:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle_edge_fx)

				-- Check if an enemy died from the damage, and check if it should play a kill response
				if not enemy:IsIllusion() and not enemy:IsAlive() then
					if RollPercentage(15) then
						EmitSoundOn(kill_response, caster)
					end
				end
			end
		end

		-- Calculate self damage, using Centaur's Strength
		local self_damage = math.max(damage - (self:GetCaster():GetStrength() * self:GetTalentSpecialValueFor("str_damage_reduction") / 100), 0)

		-- Damage caster
		ApplyDamage({
			victim = caster,
			attacker = caster,
			damage = self_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL,
			ability = ability
		})
	end
end

---------------------------------
-- 		   Return 		       --
---------------------------------

imba_centaur_return = imba_centaur_return or class({})
LinkLuaModifier("modifier_imba_return_aura", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_return_passive", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_return_damage_block", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_return_damage_block_buff", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_return_bonus_damage", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)

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
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_return_bonus_damage", { duration = self:GetSpecialValueFor("duration") }):SetStackCount(self:GetCaster():FindModifierByName("modifier_imba_return_passive"):GetStackCount())
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

function modifier_imba_return_aura:IsHidden()
	return true
end

function modifier_imba_return_aura:IsPurgable()
	return false
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
	if IsServer() and self:GetAbility() then
		-- Ability properties
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local attacker = keys.attacker
		local target = keys.unit
		local particle_return = "particles/units/heroes/hero_centaur/centaur_return.vpcf"
		local particle_block_msg = "particles/msg_fx/msg_block.vpcf"
		-- Ability specials
		local damage = ability:GetTalentSpecialValueFor("damage")
		local str_pct_as_damage = ability:GetSpecialValueFor("str_pct_as_damage")
		local damage_block = ability:GetSpecialValueFor("damage_block")

		-- Not inherited by illusions
		if not target:IsRealHero() then
			return nil
		end

		-- Disabled by break
		if parent:PassivesDisabled() then
			return nil
		end

		-- Only commence on enemies attacking Centaur
		-- Don't affect wards.
		if attacker:GetTeamNumber() ~= parent:GetTeamNumber() and parent == target and not attacker:IsOther() and attacker:GetName() ~= "npc_dota_unit_undying_zombie" then
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

			-- Add return particle
			local particle_return_fx = ParticleManager:CreateParticle(particle_return, PATTACH_ABSORIGIN, parent)
			ParticleManager:SetParticleControlEnt(particle_return_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle_return_fx, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle_return_fx)

			-- Calculate damage using owner's strength
			if self:GetParent().GetStrength then
				damage = damage + (self:GetParent():GetStrength() * self:GetAbility():GetSpecialValueFor("str_pct_as_damage") / 100)
			end

			-- Apply damage on attacker
			ApplyDamage({
				victim = attacker,
				attacker = parent,
				damage = damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
				ability = ability
			})

			if self:GetParent() == self:GetCaster() then
				self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_return_damage_block", { duration = self:GetAbility():GetSpecialValueFor("block_duration") })
				self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_return_damage_block_buff", {
					duration     = self:GetAbility():GetSpecialValueFor("block_duration"),
					damage_block = self:GetAbility():GetSpecialValueFor("damage_block")
				})
			end
		end
	end
end

function modifier_imba_return_passive:OnAttackLanded(keys)
	if self:GetParent() == keys.target and self:GetParent() == self:GetCaster() and self:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_stacks") and not self:GetParent():HasModifier("modifier_imba_return_bonus_damage") then
		if keys.attacker:IsHero() or keys.attacker:IsTower() then
			self:IncrementStackCount()
		end
	end
end

function modifier_imba_return_passive:IsHidden()
	return self:GetStackCount() <= 0 and self:GetParent() == self:GetCaster()
end

function modifier_imba_return_passive:IsPurgable()
	return false
end

-- Damage block modifier
modifier_imba_return_damage_block      = modifier_imba_return_damage_block or class({})
modifier_imba_return_damage_block_buff = modifier_imba_return_damage_block_buff or class({})

function modifier_imba_return_damage_block:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.damage_block = self:GetAbility():GetSpecialValueFor("damage_block")
end

function modifier_imba_return_damage_block:OnRefresh()
	self:OnCreated()
end

function modifier_imba_return_damage_block:DeclareFunctions()
	return { MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK }
end

function modifier_imba_return_damage_block:GetModifierPhysical_ConstantBlock()
	return self:GetStackCount()
end

function modifier_imba_return_damage_block_buff:IsHidden() return true end

function modifier_imba_return_damage_block_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_return_damage_block_buff:OnCreated(keys)
	if not IsServer() then return end

	self:SetStackCount(keys.damage_block)

	if self:GetParent():HasModifier("modifier_imba_return_damage_block") then
		self:GetParent():FindModifierByName("modifier_imba_return_damage_block"):SetStackCount(self:GetParent():FindModifierByName("modifier_imba_return_damage_block"):GetStackCount() + self:GetStackCount())
	end
end

function modifier_imba_return_damage_block_buff:OnDestroy()
	if not IsServer() then return end

	if self:GetParent():HasModifier("modifier_imba_return_damage_block") then
		self:GetParent():FindModifierByName("modifier_imba_return_damage_block"):SetStackCount(self:GetParent():FindModifierByName("modifier_imba_return_damage_block"):GetStackCount() - self:GetStackCount())
	end
end

modifier_imba_return_bonus_damage = class({})

function modifier_imba_return_bonus_damage:GetEffectName()
	return "particles/units/heroes/hero_centaur/centaur_return_buff.vpcf"
end

function modifier_imba_return_bonus_damage:GetEffectAttachType()
	return "attach_attack1"
end

function modifier_imba_return_bonus_damage:OnCreated()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_imba_return_bonus_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_imba_return_bonus_damage:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_damage * self:GetStackCount()
end

---------------------------------
-- 		   Stampede            --
---------------------------------

imba_centaur_stampede = class({})
LinkLuaModifier("modifier_imba_stampede_haste", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_centaur_stampede_scepter", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_stampede_trample_slow", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)

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
			FIND_UNITS_EVERYWHERE, -- global
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _, enemy in pairs(enemies) do
			enemy.trampled_in_stampede = nil
		end

		-- Find all allied heroes and player controlled creeps
		local allies = FindUnitsInRadius(caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			FIND_UNITS_EVERYWHERE, -- global
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
			FIND_ANY_ORDER,
			false)

		-- Give them haste buff
		for _, ally in pairs(allies) do
			ally:AddNewModifier(caster, ability, modifier_haste, { duration = duration })

			if self:GetCaster():HasScepter() then
				ally:AddNewModifier(self:GetCaster(), self, "modifier_imba_centaur_stampede_scepter", { duration = self:GetSpecialValueFor("duration") })
			end
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
			self.trample_damage = self.caster:GetStrength() * (self.strength_damage / 100)
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
		for _, enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() and not enemy.trampled_in_stampede then
				-- Mark it as trampled
				enemy.trampled_in_stampede = true

				-- Deal damage
				local damageTable = {
					victim = enemy,
					attacker = self.parent,
					damage = self.trample_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self.ability
				}

				ApplyDamage(damageTable)

				-- Add stun and slow modifiers to the enemy
				enemy:AddNewModifier(self.caster, self.ability, "modifier_stunned", { duration = self.stun_duration * (1 - enemy:GetStatusResistance()) })
				enemy:AddNewModifier(self.caster, self.ability, self.modifier_trample_slow, { duration = (self.stun_duration + self.slow_duration) * (1 - enemy:GetStatusResistance()) })

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
					for _, ally in pairs(allies) do
						if ally:HasModifier("modifier_imba_stampede_haste") then
							local modifier_haste_handler = ally:FindModifierByName("modifier_imba_stampede_haste")
							modifier_haste_handler:SetDuration(modifier_haste_handler:GetRemainingTime() + bonus_stampede_duration, true)

							if ally:HasModifier("modifier_imba_centaur_stampede_scepter") then
								ally:FindModifierByName("modifier_imba_centaur_stampede_scepter"):SetDuration(ally:FindModifierByName("modifier_imba_centaur_stampede_scepter"):GetRemainingTime() + bonus_stampede_duration, true)
							end
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
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_imba_stampede_haste:GetModifierMoveSpeed_AbsoluteMin()
	return self.absolute_move_speed
end

function modifier_imba_stampede_haste:GetModifierStatusResistanceStacking()
	return self:GetCaster():FindTalentValue("special_bonus_imba_centaur_5")
end

function modifier_imba_stampede_haste:CheckState()
	return { [MODIFIER_STATE_NO_UNIT_COLLISION] = true }
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

--------------------------------------------
-- MODIFIER_IMBA_CENTAUR_STAMPEDE_SCEPTER --
--------------------------------------------

modifier_imba_centaur_stampede_scepter = modifier_imba_centaur_stampede_scepter or class({})

-- Just because Shush wants some sort of visible indicator for when it's an Aghanim's Scepter Stampede...
function modifier_imba_centaur_stampede_scepter:IsPurgable() return false end

function modifier_imba_centaur_stampede_scepter:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.damage_reduction_scepter = self:GetAbility():GetSpecialValueFor("damage_reduction_scepter") * (-1)
end

function modifier_imba_centaur_stampede_scepter:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_imba_centaur_stampede_scepter:GetModifierIncomingDamage_Percentage()
	return self.damage_reduction_scepter
end

function modifier_imba_centaur_stampede_scepter:CheckState()
	return { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true }
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
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_imba_stampede_trample_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_centaur_1", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_centaur_2", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_centaur_3", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_centaur_4", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_centaur_5", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_centaur_6", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_centaur_7", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_centaur_8", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_centaur_9", "components/abilities/heroes/hero_centaur", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_centaur_1 = modifier_special_bonus_imba_centaur_1 or class({})
modifier_special_bonus_imba_centaur_2 = modifier_special_bonus_imba_centaur_2 or class({})
modifier_special_bonus_imba_centaur_3 = modifier_special_bonus_imba_centaur_3 or class({})
modifier_special_bonus_imba_centaur_4 = modifier_special_bonus_imba_centaur_4 or class({})
modifier_special_bonus_imba_centaur_5 = modifier_special_bonus_imba_centaur_5 or class({})
modifier_special_bonus_imba_centaur_6 = modifier_special_bonus_imba_centaur_6 or class({})
modifier_special_bonus_imba_centaur_7 = modifier_special_bonus_imba_centaur_7 or class({})
modifier_special_bonus_imba_centaur_8 = modifier_special_bonus_imba_centaur_8 or class({})
modifier_special_bonus_imba_centaur_9 = modifier_special_bonus_imba_centaur_9 or class({})

function modifier_special_bonus_imba_centaur_1:IsHidden() return true end

function modifier_special_bonus_imba_centaur_1:IsPurgable() return false end

function modifier_special_bonus_imba_centaur_1:RemoveOnDeath() return false end

function modifier_special_bonus_imba_centaur_2:IsHidden() return true end

function modifier_special_bonus_imba_centaur_2:IsPurgable() return false end

function modifier_special_bonus_imba_centaur_2:RemoveOnDeath() return false end

function modifier_special_bonus_imba_centaur_3:IsHidden() return true end

function modifier_special_bonus_imba_centaur_3:IsPurgable() return false end

function modifier_special_bonus_imba_centaur_3:RemoveOnDeath() return false end

function modifier_special_bonus_imba_centaur_4:IsHidden() return true end

function modifier_special_bonus_imba_centaur_4:IsPurgable() return false end

function modifier_special_bonus_imba_centaur_4:RemoveOnDeath() return false end

function modifier_special_bonus_imba_centaur_5:IsHidden() return true end

function modifier_special_bonus_imba_centaur_5:IsPurgable() return false end

function modifier_special_bonus_imba_centaur_5:RemoveOnDeath() return false end

function modifier_special_bonus_imba_centaur_6:IsHidden() return true end

function modifier_special_bonus_imba_centaur_6:IsPurgable() return false end

function modifier_special_bonus_imba_centaur_6:RemoveOnDeath() return false end

function modifier_special_bonus_imba_centaur_7:IsHidden() return true end

function modifier_special_bonus_imba_centaur_7:IsPurgable() return false end

function modifier_special_bonus_imba_centaur_7:RemoveOnDeath() return false end

function modifier_special_bonus_imba_centaur_8:IsHidden() return true end

function modifier_special_bonus_imba_centaur_8:IsPurgable() return false end

function modifier_special_bonus_imba_centaur_8:RemoveOnDeath() return false end

function modifier_special_bonus_imba_centaur_9:IsHidden() return true end

function modifier_special_bonus_imba_centaur_9:IsPurgable() return false end

function modifier_special_bonus_imba_centaur_9:RemoveOnDeath() return false end
