-- Author: Shush
-- Date: 30/04/2017

-- Setting the two behavior changing talents to call for behavior again so the update works properly
LinkLuaModifier("modifier_special_bonus_imba_skeleton_king_2", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_skeleton_king_5", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_skeleton_king_2 = class({})
modifier_special_bonus_imba_skeleton_king_5 = class({})

function modifier_special_bonus_imba_skeleton_king_2:IsHidden() 		return true end
function modifier_special_bonus_imba_skeleton_king_2:IsPurgable() 		return false end
function modifier_special_bonus_imba_skeleton_king_2:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_skeleton_king_5:IsHidden() 		return true end
function modifier_special_bonus_imba_skeleton_king_5:IsPurgable() 		return false end
function modifier_special_bonus_imba_skeleton_king_5:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_skeleton_king_2:OnCreated()
	if not IsServer() then return end
	if self:GetParent():FindAbilityByName("imba_wraith_king_kingdom_come") then
		self:GetParent():FindAbilityByName("imba_wraith_king_kingdom_come"):GetBehavior()
	end
end

function modifier_special_bonus_imba_skeleton_king_5:OnCreated()
	if not IsServer() then return end
	if self:GetParent():FindAbilityByName("imba_wraith_king_reincarnation") then
		self:GetParent():FindAbilityByName("imba_wraith_king_reincarnation"):GetBehavior()
	end
end

--------------------------------
--      WRAITHFIRE BLAST      --
--------------------------------
imba_wraith_king_wraithfire_blast = class({})
LinkLuaModifier("modifier_imba_wraithfire_blast_stun", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wraithfire_blast_debuff", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wraithfire_blast_debuff_talent", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)

function imba_wraith_king_wraithfire_blast:IsHiddenWhenStolen()
	return false
end

function imba_wraith_king_wraithfire_blast:GetAOERadius()   return self:GetSpecialValueFor("secondary_targets_radius") end

function imba_wraith_king_wraithfire_blast:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local sound_cast = "Hero_SkeletonKing.Hellfire_Blast"
	local cast_response = {"skeleton_king_wraith_ability_hellfire_05", "skeleton_king_wraith_ability_hellfire_06", "skeleton_king_wraith_ability_hellfire_07"}
	local rare_cast_response = {"skeleton_king_wraith_ability_hellfire_03", "skeleton_king_wraith_ability_hellfire_04"}        
	local particle_warmup = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_warmup.vpcf"    

	-- Roll for rare cast response
	if RollPercentage(5) then
		EmitSoundOn(rare_cast_response[math.random(1,#rare_cast_response)], caster)

	-- If failed, roll for normal cast response
	elseif RollPercentage(75) then
		EmitSoundOn(cast_response[math.random(1,#cast_response)], caster)
	end        

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Add warmup particle
	local particle_warmup_fx = ParticleManager:CreateParticle(particle_warmup, PATTACH_CUSTOMORIGIN_FOLLOW, caster, caster)
	ParticleManager:SetParticleControlEnt(particle_warmup_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_warmup_fx)

	-- Launch projectile
	LaunchWraithblastProjectile(caster, ability, caster, target, true)
end

function LaunchWraithblastProjectile(caster, ability, source, target, main, bTalent)
	-- Ability properties
	local particle_projectile = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf"    

	-- Ability specials
	local projectile_speed = ability:GetSpecialValueFor("projectile_speed")

	-- Launch projectile on target    
	local wraithblast_projectile
	wraithblast_projectile = {Target = target,
							  Source = source,
							  Ability = ability,
							  EffectName = particle_projectile,
							  iMoveSpeed = projectile_speed,
							  bDodgeable = true, 
							  bVisibleToEnemies = true,
							  bReplaceExisting = false,
							  bProvidesVision = false,  
							  iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
							  ExtraData = {main_blast = main, bTalent = bTalent or false}
	}
	
	if bTalent then
		wraithblast_projectile.iMoveSpeed = 500
	end

	ProjectileManager:CreateTrackingProjectile(wraithblast_projectile)
end

function imba_wraith_king_wraithfire_blast:OnProjectileHit_ExtraData(target, location, extra_data)
	-- If there was no target, do nothing
	if not target then
		return nil
	end

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local kill_response = "skeleton_king_wraith_ability_hellfire_01"
	local sound_hit = "Hero_SkeletonKing.Hellfire_BlastImpact"    
	local modifier_stun = "modifier_imba_wraithfire_blast_stun"
	local modifier_debuff = "modifier_imba_wraithfire_blast_debuff"

	-- Ability specials
	local main_target_stun_duration = ability:GetSpecialValueFor("main_target_stun_duration")
	local damage = ability:GetSpecialValueFor("damage")
	local secondary_targets_radius = ability:GetSpecialValueFor("secondary_targets_radius")
	local secondary_target_stun_duration = ability:GetSpecialValueFor("secondary_target_stun_duration")
	local debuff_duration = ability:GetSpecialValueFor("debuff_duration")
	local projectile_speed = ability:GetSpecialValueFor("projectile_speed")    

	-- Play impact sound
	EmitSoundOn(sound_hit, caster)    

	-- If the target suddenly became magic immune, do nothing
	if target:IsMagicImmune() then
		return nil
	end

	if extra_data.main_blast == 1 then
		-- If target has Linken's Sphere off cooldown, do nothing
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(ability) then
				return nil
			end
		end

		if caster:HasTalent("special_bonus_imba_skeleton_king_3") then
			target:AddNewModifier(caster, ability, "modifier_imba_wraithfire_blast_debuff_talent", {duration = caster:FindTalentValue("special_bonus_imba_skeleton_king_3", "duration") * (1 - target:GetStatusResistance())})
		end

		-- If it was a main blast, deal damage
		local damageTable = {victim = target,
							 attacker = caster, 
							 damage = damage,
							 damage_type = DAMAGE_TYPE_MAGICAL,
							 ability = ability
							 }
		
		ApplyDamage(damageTable)

		-- Main stun the target
		target:AddNewModifier(caster, ability, modifier_stun, {duration = main_target_stun_duration * (1 - target:GetStatusResistance())})
		
		-- IMBAfication: Behond the Wraith!
		if extra_data.bTalent == 0 then
			-- Split to enemies around
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
											  target:GetAbsOrigin(),
											  nil,
											  secondary_targets_radius,
											  DOTA_UNIT_TARGET_TEAM_ENEMY,
											  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
											  DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
											  FIND_ANY_ORDER,
											  false)

			for _,enemy in pairs(enemies) do
				if enemy ~= target then
					LaunchWraithblastProjectile(caster, ability, target, enemy, false)
				end
			end
		end

	else
		-- Otherwise, stun for short duration
		target:AddNewModifier(caster, ability, modifier_stun, {duration = secondary_target_stun_duration * (1 - target:GetStatusResistance())})
	end

	-- If the enemy died, play the cast response
	Timers:CreateTimer(FrameTime(), function()
		if not target:IsAlive() then
			EmitSoundOn(kill_response, caster)
		end
	end)

	-- Apply the debuff on the enemy
	target:AddNewModifier(caster, ability, modifier_debuff, {duration = debuff_duration * (1 - target:GetStatusResistance())})

	-- #7 Talent: Wraithfire Blast now summons Wraiths on all targets hit
	if caster:HasTalent("special_bonus_imba_skeleton_king_7") and not bTalent then
		local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
		local distance = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
		local summon_point = caster:GetAbsOrigin() + direction * distance - 100
		local wraith = CreateUnitByName("npc_imba_wraith_king_wraith", summon_point, true, caster, caster, caster:GetTeamNumber())        

		-- Set the wraith as controllable by the player
		local playerid = caster:GetPlayerID()
		if playerid then
			wraith:SetControllableByPlayer(playerid, true)
		end

		-- Set the owner of the wraith as the caster
		wraith:SetOwner(caster)

		-- Set the Wraith to die after a small duration
		local duration = caster:FindAbilityByName("imba_wraith_king_kingdom_come"):GetSpecialValueFor("wraith_duration")
		wraith:AddNewModifier(wraith, nil, "modifier_kill", {duration = duration})

		-- Set the Wraith's health to be the same as its origin
		wraith:SetBaseMaxHealth(target:GetBaseMaxHealth())
		wraith:SetMaxHealth(target:GetMaxHealth())
		wraith:SetHealth(wraith:GetMaxHealth())

		ResolveNPCPositions(target:GetAbsOrigin(), 164)
	end
end


-- Stun modifier
modifier_imba_wraithfire_blast_stun = class({})

function modifier_imba_wraithfire_blast_stun:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state
end

function modifier_imba_wraithfire_blast_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_wraithfire_blast_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_wraithfire_blast_stun:IsHidden() return false end
function modifier_imba_wraithfire_blast_stun:IsPurgeException() return true end
function modifier_imba_wraithfire_blast_stun:IsStunDebuff() return true end




-- Debuff modifier
modifier_imba_wraithfire_blast_debuff = class({})

function modifier_imba_wraithfire_blast_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_debuff = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_debuff.vpcf"
	self.particle_lifesteal = "particles/hero/skeleton_king/wraithblast_lifesteal.vpcf"

	-- Ability specials
	self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
	self.damage_per_second = self.ability:GetSpecialValueFor("damage_per_second")
	self.attacker_lifesteal_pct = self.ability:GetSpecialValueFor("attacker_lifesteal_pct")
	self.damage_interval = self.ability:GetSpecialValueFor("damage_interval")

	-- Start thinking
	if IsServer() then
		-- Add debuff particle    
		self.particle_debuff_fx = ParticleManager:CreateParticle(self.particle_debuff, PATTACH_ABSORIGIN_FOLLOW, self.parent, self.caster)    
		ParticleManager:SetParticleControl(self.particle_debuff_fx, 0, self.parent:GetAbsOrigin())    
		self:AddParticle(self.particle_debuff_fx, false, false, -1, false, false)

		self:SetStackCount(self.ms_slow_pct * (1 - self.parent:GetStatusResistance()))
	
		self:StartIntervalThink(self.damage_interval)
	end
end

function modifier_imba_wraithfire_blast_debuff:IsHidden()		return false end
function modifier_imba_wraithfire_blast_debuff:IsPurgable()		return true end
function modifier_imba_wraithfire_blast_debuff:IsDebuff() 		return true end
function modifier_imba_wraithfire_blast_debuff:IgnoreTenacity()	return true end

function modifier_imba_wraithfire_blast_debuff:OnIntervalThink()
	if IsServer() then
		-- Calculate damage
		local damage = self.damage_per_second * self.damage_interval

		local damageTable = {victim = self.parent,
							 attacker = self.caster, 
							 damage = damage,
							 damage_type = DAMAGE_TYPE_MAGICAL,
							 ability = self.ability
							 }
		
		ApplyDamage(damageTable)
	end
end

function modifier_imba_wraithfire_blast_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_imba_wraithfire_blast_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount() * (-1)
end

function modifier_imba_wraithfire_blast_debuff:OnAttackLanded(keys)
	local attacker = keys.attacker
	local target = keys.target
	local damage = keys.damage

	-- Only apply if the target is the parent of the debuff
	if self.parent == target then

		-- If the attacker was on the same team, do nothing
		if attacker:GetTeamNumber() == target:GetTeamNumber() then
			return nil
		end

		-- If the attacker is a building, a ward or a courier, do nothing
		if attacker:IsBuilding() then
			return nil
		end

		-- Add lifesteal particle
		self.particle_lifesteal_fx = ParticleManager:CreateParticle(self.particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, attacker, self.caster)
		ParticleManager:SetParticleControl(self.particle_lifesteal_fx, 0, attacker:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_lifesteal_fx, 1, attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle_lifesteal_fx)

		-- If it's an illusion, it doesn't heal (just fakes it)
		if attacker:IsIllusion() then
			return nil
		end

		-- Calculate heal amount based on damage
		local heal_amount = damage * self.attacker_lifesteal_pct * 0.01

		-- Heal the attacker
		attacker:Heal(heal_amount, self.caster)
	end
end


modifier_imba_wraithfire_blast_debuff_talent = modifier_imba_wraithfire_blast_debuff_talent or class({})

function modifier_imba_wraithfire_blast_debuff_talent:IsDebuff()            return true end
function modifier_imba_wraithfire_blast_debuff_talent:IsHidden()            return false  end
function modifier_imba_wraithfire_blast_debuff_talent:IsPurgable()          return true end
function modifier_imba_wraithfire_blast_debuff_talent:IsPurgeException()    return true end
function modifier_imba_wraithfire_blast_debuff_talent:IsStunDebuff()        return false end
function modifier_imba_wraithfire_blast_debuff_talent:RemoveOnDeath()       return true  end

function modifier_imba_wraithfire_blast_debuff_talent:GetEffectName()       return "particles/hero/skeleton_king/skeleton_king_wraithblast_talent_debuff.vpcf" end

function modifier_imba_wraithfire_blast_debuff_talent:OnCreated()
	if not IsServer() then
		return
	end
	self:OnIntervalThink()
	self:StartIntervalThink(1.0)
end

function modifier_imba_wraithfire_blast_debuff_talent:OnIntervalThink()
	if not IsServer() or not self:GetParent():IsAlive() then
		return
	end

	local num = 0
	local caster = self:GetCaster()
	local target = self:GetParent()
	local radius = caster:FindTalentValue("special_bonus_imba_skeleton_king_3", "radius")
	local base_dmg = caster:FindTalentValue("special_bonus_imba_skeleton_king_3", "base_damge_per_sec")
	local additional_dmg = caster:FindTalentValue("special_bonus_imba_skeleton_king_3", "add_target_dmg")

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
							  target:GetAbsOrigin(),
							  nil,
							  radius,
							  DOTA_UNIT_TARGET_TEAM_ENEMY,
							  DOTA_UNIT_TARGET_HERO,
							  DOTA_UNIT_TARGET_FLAG_NONE,
							  FIND_ANY_ORDER,
							  false)
	for _, enemy in pairs(enemies) do
		local modifier = enemy:FindModifierByNameAndCaster("modifier_imba_wraithfire_blast_debuff", self:GetCaster())
		if modifier and enemy ~= target then
			num = num + 1
		end
	end

	local damage = base_dmg + num * additional_dmg

	local damage_targets = FindUnitsInRadius(caster:GetTeamNumber(),
							  target:GetAbsOrigin(),
							  nil,
							  radius,
							  DOTA_UNIT_TARGET_TEAM_ENEMY,
							  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
							  DOTA_UNIT_TARGET_FLAG_NONE,
							  FIND_ANY_ORDER,
							  false)
	for _, damage_target in pairs(damage_targets) do
		local damageTable = {
					victim = damage_target,
					attacker = caster,
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self:GetAbility(),
					}
		ApplyDamage(damageTable)
	end
end


--------------------------------
--      VAMPIRIC AURA      --
--------------------------------
imba_wraith_king_vampiric_aura = class({})
LinkLuaModifier("modifier_imba_vampiric_aura", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_vampiric_aura_buff", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)

function imba_wraith_king_vampiric_aura:OnToggle() return nil end
function imba_wraith_king_vampiric_aura:IsStealable() return false end

function imba_wraith_king_vampiric_aura:GetIntrinsicModifierName()
	return "modifier_imba_vampiric_aura"
end

function imba_wraith_king_vampiric_aura:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function imba_wraith_king_vampiric_aura:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

-- Aura modifier
modifier_imba_vampiric_aura = class({})

function modifier_imba_vampiric_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_imba_vampiric_aura:AllowIllusionDuplicate() return true end
function modifier_imba_vampiric_aura:IsHidden() return true end
function modifier_imba_vampiric_aura:IsPurgable() return false end
function modifier_imba_vampiric_aura:IsDebuff() return false end    

function modifier_imba_vampiric_aura:GetAuraRadius()
	return self.radius
end

function modifier_imba_vampiric_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_imba_vampiric_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_vampiric_aura:GetAuraSearchType()
	-- if self.ability:GetToggleState() then
		-- return DOTA_UNIT_TARGET_HERO 
	-- else
		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	-- end
end

function modifier_imba_vampiric_aura:GetAuraEntityReject(target)
	if (self.ability:GetToggleState() and not target:IsConsideredHero()) or target:IsRangedAttacker() then return true end
end

function modifier_imba_vampiric_aura:GetModifierAura()
	return "modifier_imba_vampiric_aura_buff"
end

function modifier_imba_vampiric_aura:IsAura()
	-- If caster is broken, no aura is emitted
	if not self.caster or self.caster:IsNull() or self.caster:PassivesDisabled() then
		return false
	end

	return true
end


-- Aura buff modifier
modifier_imba_vampiric_aura_buff = class({})

function modifier_imba_vampiric_aura_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_lifesteal = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	self.particle_spellsteal = "particles/hero/skeleton_king/skeleton_king_vampiric_aura_lifesteal.vpcf"

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.lifesteal_pct = self.ability:GetSpecialValueFor("lifesteal_pct")
	self.spellsteal_pct = self.ability:GetSpecialValueFor("spellsteal_pct")
	self.caster_heal = self.ability:GetSpecialValueFor("caster_heal")
	self.heal_delay = self.ability:GetSpecialValueFor("heal_delay")
	self.damage	= self.ability:GetSpecialValueFor("damage")
	self.self_bonus	= self.ability:GetSpecialValueFor("self_bonus")
end

function modifier_imba_vampiric_aura_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_vampiric_aura_buff:IsHidden() return false end
function modifier_imba_vampiric_aura_buff:IsPurgable() return false end
function modifier_imba_vampiric_aura_buff:IsDebuff() return false end

function modifier_imba_vampiric_aura_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_imba_vampiric_aura_buff:GetModifierPreAttack_BonusDamage()
	if not self:GetParent():HasModifier("modifier_imba_mortal_strike_skeleton") and not self:GetParent():HasModifier("modifier_mortal_strike_skeleton") then
		return self.damage
	else
		return self.damage * 0.5
	end
end

function modifier_imba_vampiric_aura_buff:OnTakeDamage(keys)
	if IsServer() then
		local attacker = keys.attacker
		local damage = keys.damage
		local damage_type = keys.damage_type
		local target = keys.unit

		-- Only apply on the parent attacks
		if self.parent == attacker then

			local heal_amount = 0

			-- If the target is on the same team, do nothing
			if attacker:GetTeamNumber() == target:GetTeamNumber() then
				return nil
			end

			-- If the target is a building, a courier or a ward, do nothing
			if target:IsBuilding() or target:IsOther() then
				return nil
			end

			-- Don't heal off of reflection damage
			if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
				return nil
			end

			-- If the damage was physical, use the lifesteal particle, and heal using the lifesteal values
			if damage_type == DAMAGE_TYPE_PHYSICAL then
				local particle_lifesteal_fx = ParticleManager:CreateParticle(self.particle_lifesteal, PATTACH_CUSTOMORIGIN_FOLLOW, attacker, self.caster)
				ParticleManager:SetParticleControlEnt(particle_lifesteal_fx, 0, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)                
				ParticleManager:SetParticleControlEnt(particle_lifesteal_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)                                
				ParticleManager:ReleaseParticleIndex(particle_lifesteal_fx)                

				-- If it was an illusion, no heal is done (fakes lifesteal)
				if attacker:IsIllusion() then
					return nil
				end

				-- #9 Talent: Vampiric Aura lifesteal increase
				local lifesteal_pct = self.lifesteal_pct + self.caster:FindTalentValue("special_bonus_imba_skeleton_king_9")

				-- Calculate lifesteal and heal the attacker
				heal_amount = damage * lifesteal_pct * 0.01
				
				if self.parent == self.caster then
					heal_amount = heal_amount * self.self_bonus
				end
				
				self.parent:Heal(heal_amount, self.caster)
			-- If the damage was magical or pure, use the skeletonking particle instead, and heal using the spellsteal values
			else
				if not self.delay_particle_time or (GameRules:GetGameTime() - self.delay_particle_time > 1) then
					local particle_spellsteal_fx = ParticleManager:CreateParticle(self.particle_spellsteal, PATTACH_CUSTOMORIGIN_FOLLOW, attacker, self.caster)
					ParticleManager:SetParticleControlEnt(particle_spellsteal_fx, 0, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)                
					ParticleManager:SetParticleControlEnt(particle_spellsteal_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)                
					ParticleManager:ReleaseParticleIndex(particle_spellsteal_fx)

					self.delay_particle_time = GameRules:GetGameTime()
				end

				-- If it was an illusion, no heal is done (fakes lifesteal)
				if attacker:IsIllusion() then
					return nil
				end

				-- Calculate lifesteal and heal the attacker
				heal_amount = damage * self.spellsteal_pct * 0.01
				
				if self.parent == self.caster then
					heal_amount = heal_amount * self.self_bonus
				end
				
				self.parent:Heal(heal_amount, self.caster)
			end

			-- After a small delay, find both illusions and the real aura bearer
			Timers:CreateTimer(self.heal_delay, function()
				local casters = FindUnitsInRadius(self.parent:GetTeamNumber(),
												  self.parent:GetAbsOrigin(),
												  nil,
												  self.radius,
												  DOTA_UNIT_TARGET_TEAM_FRIENDLY,
												  DOTA_UNIT_TARGET_HERO,
												  DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
												  FIND_ANY_ORDER,
												  false)

				for _,caster in pairs(casters) do
					-- Ignore everyone that are not the same name as the caster
					if caster:GetUnitName() == self.caster:GetUnitName() and attacker:GetUnitName() ~= self.caster:GetUnitName() then
						-- If any healing was done by anyone that is not the caster, show a transition to the aura bearer(s)            
						if heal_amount > 0 and caster ~= attacker then
							local particle_lifesteal_fx = ParticleManager:CreateParticle(self.particle_lifesteal, PATTACH_CUSTOMORIGIN_FOLLOW, caster, self.caster)
							ParticleManager:SetParticleControlEnt(particle_lifesteal_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)                
							ParticleManager:SetParticleControlEnt(particle_lifesteal_fx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)                                
							ParticleManager:ReleaseParticleIndex(particle_lifesteal_fx)                                        

							-- Heal the aura bearer, if it's a real hero
							if caster:IsRealHero() then
								local caster_heal = heal_amount * self.caster_heal * 0.01
								caster:Heal(caster_heal, caster)
							end
						end
					end
				end
			end)
		end

		if self.parent == target and target ~= self.caster and self:GetCaster():HasTalent("special_bonus_imba_skeleton_king_1") then
			local heal_amount = 0

			-- If the target is on the same team, do nothing
			if attacker:GetTeamNumber() == target:GetTeamNumber() then
				return nil
			end

			-- If the attacker is a building, a courier or a ward, do nothing
			if attacker:IsBuilding() or attacker:IsOther() then
				return nil
			end

			-- If it was an illusion, no heal is done (fakes lifesteal)
			if target:IsIllusion() then
				return nil
			end

			-- Calculate lifesteal and heal the attacker
			heal_amount = damage 

			-- After a small delay, find both illusions and the real aura bearer
			Timers:CreateTimer(self.heal_delay, function()
				if not self.caster:IsAlive() then
					return nil
				end
				local casters = FindUnitsInRadius(self.parent:GetTeamNumber(),
												  self.parent:GetAbsOrigin(),
												  nil,
												  self.radius,
												  DOTA_UNIT_TARGET_TEAM_FRIENDLY,
												  DOTA_UNIT_TARGET_HERO,
												  DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
												  FIND_ANY_ORDER,
												  false)

				for _,caster in pairs(casters) do

					-- Ignore everyone that are not the same name as the caster
					if caster:GetUnitName() == self.caster:GetUnitName() and attacker:GetUnitName() ~= self.caster:GetUnitName() then
						-- If any healing was done by anyone that is not the caster, show a transition to the aura bearer(s)            
						if heal_amount > 0 and caster ~= attacker then
							local particle_lifesteal_fx = ParticleManager:CreateParticle(self.particle_lifesteal, PATTACH_CUSTOMORIGIN_FOLLOW, caster, self.caster)
							ParticleManager:SetParticleControlEnt(particle_lifesteal_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)                
							ParticleManager:SetParticleControlEnt(particle_lifesteal_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)                                
							ParticleManager:ReleaseParticleIndex(particle_lifesteal_fx)                                        

							-- Heal the aura bearer, if it's a real hero
							if caster:IsRealHero() then
								local caster_heal = heal_amount * self.caster:FindTalentValue("special_bonus_imba_skeleton_king_1") * 0.01
								caster:Heal(caster_heal, caster)
							end
						end
					end
				end
			end)
		end
	end
end




--------------------------------
--       MORTAL STRIKE        --
--------------------------------
imba_wraith_king_mortal_strike = class({})
LinkLuaModifier("modifier_imba_mortal_strike", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mortal_strike_buff", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mortal_strike_buff_talent", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mortal_strike_skeleton", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)

function imba_wraith_king_mortal_strike:GetIntrinsicModifierName()
	return "modifier_imba_mortal_strike"
end

function imba_wraith_king_mortal_strike:OnSpellStart()
	self.caster	= self:GetCaster()
	
	-- AbilitySpecials
	self.skeleton_duration		=	self:GetSpecialValueFor("skeleton_duration")
	self.max_skeleton_charges	=	self:GetSpecialValueFor("max_skeleton_charges")
	self.spawn_interval			=	self:GetSpecialValueFor("spawn_interval")
	self.reincarnate_time		=	self:GetSpecialValueFor("reincarnate_time")
	self.skeletons_per_charge	=	self:GetSpecialValueFor("skeletons_per_charge")
	
	if self.caster:HasModifier("modifier_imba_mortal_strike") then
		local skeleton = nil
		local skeleton_modifier = self.caster:FindModifierByName("modifier_imba_mortal_strike")
		
		for unit = 0, skeleton_modifier:GetStackCount() - 1 do	
			self:GetCaster():SetContextThink(DoUniqueString(self:GetName()), function()	
				for units_per_charge = 1, self.skeletons_per_charge do
					skeleton = CreateUnitByName("npc_dota_wraith_king_skeleton_warrior", self.caster:GetAbsOrigin() + RandomVector(100), true, self.caster, self.caster, self.caster:GetTeamNumber()) -- IDK how accurate 100 is but w/e I don't want too much overlap
					skeleton:AddNewModifier(self.caster, self, "modifier_kill", {duration = self.skeleton_duration})
					skeleton:AddNewModifier(self.caster, self, "modifier_imba_mortal_strike_skeleton", {duration = self.skeleton_duration - FrameTime()})
					skeleton:SetControllableByPlayer( self.caster:GetPlayerID(),  true )
					skeleton:SetOwner(self.caster)
					
					-- Resolve NPC positions to try and make sure skeletons don't get stuck on each other
					ResolveNPCPositions(skeleton:GetAbsOrigin(), skeleton:GetHullRadius())
					
					-- No gold/exp on first death
					skeleton:SetMaximumGoldBounty(0)
					skeleton:SetMinimumGoldBounty(0)
					skeleton:SetDeathXP(0)
					
					-- First spawn, so it will reincarnate if it dies once
					skeleton.fresh	= true
					
					-- Issue one aggressive move command to the enemy's ancient and that's it					
					skeleton:SetContextThink(DoUniqueString(self:GetName()), function()
						if self.caster:GetTeam() == DOTA_TEAM_GOODGUYS then
							skeleton:MoveToPositionAggressive(Vector(5654, 4939, 0))
						elseif self.caster:GetTeam() == DOTA_TEAM_BADGUYS then
							skeleton:MoveToPositionAggressive(Vector(-5864, -5340, 0))
						end
						
						return nil
					end, FrameTime())
				end
				
				skeleton_modifier.skeleton_counter = skeleton_modifier.skeleton_counter - 1
				skeleton_modifier:DecrementStackCount()
				
				return nil
			end, unit * self.spawn_interval)
		end
	end
	
	self.caster:EmitSound("Hero_SkeletonKing.MortalStrike.Cast")
end

-- Skeleton Modifier (mostly handles reincarnation)
modifier_imba_mortal_strike_skeleton	= class ({})

function modifier_imba_mortal_strike_skeleton:RemoveOnDeath()	return end

function modifier_imba_mortal_strike_skeleton:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.skeleton_duration		=	self.ability:GetSpecialValueFor("skeleton_duration")
	self.max_skeleton_charges	=	self.ability:GetSpecialValueFor("max_skeleton_charges")
	self.spawn_interval			=	self.ability:GetSpecialValueFor("spawn_interval")
	self.reincarnate_time		=	self.ability:GetSpecialValueFor("reincarnate_time")
end

function modifier_imba_mortal_strike_skeleton:DeclareFunctions()
	return {MODIFIER_EVENT_ON_DEATH}
end

function modifier_imba_mortal_strike_skeleton:OnDeath(keys)
	if not IsServer() then return end
	
	if self.parent == keys.unit and self:GetParent().fresh and self.parent ~= keys.attacker then
		self.remaining_time = math.max(self.parent:FindModifierByName("modifier_kill"):GetRemainingTime() - self.reincarnate_time, 0)
		self:StartIntervalThink(self.reincarnate_time)
	end
end

function modifier_imba_mortal_strike_skeleton:OnIntervalThink()
	self.skeleton = CreateUnitByName("npc_dota_wraith_king_skeleton_warrior", self.parent:GetOrigin(), true, self.caster, self.caster, self.caster:GetTeamNumber())
	
	self.skeleton:AddNewModifier(self.caster, self.ability, "modifier_kill", {duration = self.remaining_time})
	self.skeleton:AddNewModifier(self.caster, self.ability, "modifier_imba_mortal_strike_skeleton", {duration = self.remaining_time - FrameTime()})
	self.skeleton:SetControllableByPlayer( self.caster:GetPlayerID(),  true)
	self.skeleton:SetOwner(self.caster)
	self.skeleton.fresh	= false

	self.skeleton:SetContextThink(DoUniqueString(self:GetName()), function()
		if self.caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			self.skeleton:MoveToPositionAggressive(Vector(5654, 4939, 0))
		elseif self.caster:GetTeamNumber() == DOTA_TEAM_BADGUYS then
			self.skeleton:MoveToPositionAggressive(Vector(-5864, -5340, 0))
		end
		
		return nil
	end, FrameTime())
	
	self:StartIntervalThink(-1)
end

function modifier_imba_mortal_strike_skeleton:OnRemoved()
	if not IsServer() then return end

	self.parent:ForceKill(false)
end

-- Critical strikes modifier
modifier_imba_mortal_strike = class({})

function modifier_imba_mortal_strike:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_health = "modifier_imba_mortal_strike_buff"
	self.modifier_strength = "modifier_imba_mortal_strike_buff_talent"

	-- Ability specials
	self.crit_chance = self.ability:GetSpecialValueFor("crit_chance")
	self.crit_damage_heroes = self.ability:GetSpecialValueFor("crit_damage_heroes")
	self.crit_damage_creeps = self.ability:GetSpecialValueFor("crit_damage_creeps")
	self.bonus_health_pct = self.ability:GetSpecialValueFor("bonus_health_pct")
	self.bonus_health_duration = self.ability:GetSpecialValueFor("bonus_health_duration")
	self.bonus_health_hero_mult = self.ability:GetSpecialValueFor("bonus_health_hero_mult")
	self.stack_value = self.ability:GetSpecialValueFor("stack_value")
	
	self.skeleton_duration		=	self.ability:GetSpecialValueFor("skeleton_duration")
	self.max_skeleton_charges	=	self.ability:GetSpecialValueFor("max_skeleton_charges")
	self.spawn_interval			=	self.ability:GetSpecialValueFor("spawn_interval")
	self.reincarnate_time		=	self.ability:GetSpecialValueFor("reincarnate_time")
	
	-- Initialize skeleton stacks
	self.skeleton_counter	= self.skeleton_counter or 0
end

function modifier_imba_mortal_strike:OnRefresh()
	self:OnCreated()
end

function modifier_imba_mortal_strike:IsHidden() return false end
function modifier_imba_mortal_strike:IsPurgable() return false end
function modifier_imba_mortal_strike:IsDebuff() return false end

function modifier_imba_mortal_strike:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH
	}

	return decFuncs
end

function modifier_imba_mortal_strike:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply on attacks of the caster
		if attacker == self.caster then
			-- If the caster is broken, do nothing
			if self.caster:PassivesDisabled() then
				return nil
			end

			-- If the target is on the friendly team, do nothing
			if target:GetTeamNumber() == self.caster:GetTeamNumber() then
				return nil
			end

			-- Psuedo Roll for a critical            
			if RollPseudoRandom(self.crit_chance, self) then
				-- Mark this attack as a critical for a small duration
				self.mortal_critical_strike = true

				Timers:CreateTimer(self.caster:GetAttackSpeed(), function()                    
					self.mortal_critical_strike = false
				end)    

				self.caster:EmitSound("Hero_SkeletonKing.CriticalStrike")

				-- Determine crit power, depending on the target type
				if target:IsHero() then
					return self.crit_damage_heroes
				else
					return self.crit_damage_creeps
				end
			end
		end
	end
end

function modifier_imba_mortal_strike:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target
		local damage = keys.damage

		-- Only apply on attacks of the caster
		if attacker == self.caster then            
			-- If this attack was not a crit, do nothing
			if not self.mortal_critical_strike then
				return nil
			end

			-- Remove crit mark
			self.mortal_critical_strike = false

			-- #5 Talent: Mortal Strike bonus health per damage
			local bonus_health_pct = self.bonus_health_pct

			-- Calculate stacks to add
			local new_stacks = damage * bonus_health_pct * 0.01

			-- If the target was a real hero, increase the bonus health gained from critting it
			if target:IsRealHero() then
				new_stacks = new_stacks * self.bonus_health_hero_mult
			end

			-- Each stack has its value, so the actual number of stacks is lower. Number is always rounded up 
			new_stacks = math.ceil(new_stacks / self.stack_value)

			-- Add (or refresh) the bonus health modifier
			local modifier_health_handler = self.caster:AddNewModifier(self.caster, self.ability, self.modifier_health, {duration = self.bonus_health_duration})
			if modifier_health_handler then
				for i = 1, new_stacks do
					modifier_health_handler:IncrementStackCount()
					modifier_health_handler:ForceRefresh()
				end                
			end

			if self.caster:HasTalent("special_bonus_imba_skeleton_king_8") then
				if target:IsRealHero() then
					if not self.caster:HasModifier(self.modifier_strength) then
						self.caster:AddNewModifier(self.caster, self.ability, self.modifier_strength, {duration = self.bonus_health_duration})
					end

					local modifier_strength_handler = self.caster:FindModifierByName(self.modifier_strength)
					if modifier_strength_handler then
						local strength_per_crit = self.caster:FindTalentValue("special_bonus_imba_skeleton_king_8")
						for i = 1, strength_per_crit do
							modifier_strength_handler:IncrementStackCount()
							modifier_strength_handler:ForceRefresh()
						end
					end
				end
			end
			-- Make sure Wraith King can't do this: https://gfycat.com/gifs/detail/HealthyHighlevelKusimanse
			if target:IsCreep() and not target:IsAncient() then
				local damageTable = {
					victim = target,
					attacker = attacker,
					damage = target:GetHealth() * (1 + 0.05 * math.abs(target:GetPhysicalArmorValue(false))) + 1,
					damage_type = DAMAGE_TYPE_PURE,
					ability = self:GetAbility()
				}

				ApplyDamage(damageTable)
			end
		end
	end
end

function modifier_imba_mortal_strike:OnDeath(keys)
	if not IsServer() then return end
	
	if self.caster == keys.attacker and (not keys.unit.WillReincarnate or keys.unit.WillReincarnate and not keys.unit:WillReincarnate()) then
		self.skeleton_counter = math.min(self.skeleton_counter + 0.5, self.max_skeleton_charges)
		self:SetStackCount(self.skeleton_counter)
	end
end

-- Bonus health modifier
modifier_imba_mortal_strike_buff = class({})

function modifier_imba_mortal_strike_buff:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()

		-- Ability specials
		self.bonus_health_duration = self.ability:GetSpecialValueFor("bonus_health_duration")
		self.stack_value = self.ability:GetSpecialValueFor("stack_value")

		-- Initialize table
		self.stacks_table = {}        

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_mortal_strike_buff:IsHidden() return false end
function modifier_imba_mortal_strike_buff:IsPurgable() return false end
function modifier_imba_mortal_strike_buff:IsDebuff() return false end

function modifier_imba_mortal_strike_buff:OnIntervalThink()
	if IsServer() then

		-- Check if there are any stacks left on the table
		if #self.stacks_table > 0 then

			-- For each stack, check if it is past its expiration time. If it is, remove it from the table
			for i = #self.stacks_table, 1, -1 do
				if self.stacks_table[i] + self.bonus_health_duration < GameRules:GetGameTime() then
					table.remove(self.stacks_table, i)             
				end
			end
			
			-- If after removing the stacks, the table is empty, remove the modifier.
			if #self.stacks_table == 0 then
				self:Destroy()

			-- Otherwise, set its stack count
			else
				self:SetStackCount(#self.stacks_table)
			end

			-- Recalculate health bonus based on new stack count
			self:GetParent():CalculateStatBonus(true)

		-- If there are no stacks on the table, just remove the modifier.
		else
			self:Destroy()
		end
	end
end

function modifier_imba_mortal_strike_buff:OnRefresh()
	if IsServer() then
		-- Insert new stack values
		table.insert(self.stacks_table, GameRules:GetGameTime())
	end
end

function modifier_imba_mortal_strike_buff:DeclareFunctions()
	return {MODIFIER_PROPERTY_HEALTH_BONUS}
end

function modifier_imba_mortal_strike_buff:GetModifierHealthBonus()
	if self == nil or self.caster == nil then return nil end

	if self.caster:IsIllusion() then
		return nil
	end
	
	return self:GetStackCount() * self.stack_value
end

-- Bonus strength modifier
modifier_imba_mortal_strike_buff_talent = class({})

function modifier_imba_mortal_strike_buff_talent:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()

		-- Ability specials
		self.bonus_health_duration = self.ability:GetSpecialValueFor("bonus_health_duration")
		self.stack_value = self.ability:GetSpecialValueFor("stack_value")

		-- Initialize table
		self.stacks_table = {}        

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_mortal_strike_buff_talent:IsHidden() return false end
function modifier_imba_mortal_strike_buff_talent:IsPurgable() return false end
function modifier_imba_mortal_strike_buff_talent:IsDebuff() return false end

function modifier_imba_mortal_strike_buff_talent:OnIntervalThink()
	if IsServer() then
		-- Check if there are any stacks left on the table
		if #self.stacks_table > 0 then

			-- For each stack, check if it is past its expiration time. If it is, remove it from the table
			for i = #self.stacks_table, 1, -1 do
				if self.stacks_table[i] + self.bonus_health_duration < GameRules:GetGameTime() then
					table.remove(self.stacks_table, i)             
				end
			end
			
			-- If after removing the stacks, the table is empty, remove the modifier.
			if #self.stacks_table == 0 then
				self:Destroy()

			-- Otherwise, set its stack count
			else
				self:SetStackCount(#self.stacks_table)
			end

			-- Recalculate health bonus based on new stack count
			self:GetParent():CalculateStatBonus(true)

		-- If there are no stacks on the table, just remove the modifier.
		else
			self:Destroy()
		end
	end
end

function modifier_imba_mortal_strike_buff_talent:OnRefresh()
	if IsServer() then
		-- Insert new stack values
		table.insert(self.stacks_table, GameRules:GetGameTime())
	end
end

function modifier_imba_mortal_strike_buff_talent:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}

	return decFuncs
end

function modifier_imba_mortal_strike_buff_talent:GetModifierBonusStats_Strength()
	if self.caster:IsIllusion() then
		return nil
	end

	-- #8 Talent: Mortal Strikes grants strength
	if self.caster:HasTalent("special_bonus_imba_skeleton_king_8") then
		local stacks = self:GetStackCount()
		return stacks
	end
end



--------------------------------
--       REINCARNATION        --
--------------------------------
imba_wraith_king_reincarnation = imba_wraith_king_reincarnation or class({})
LinkLuaModifier("modifier_imba_reincarnation", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_reincarnation_wraith_form_buff", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_reincarnation_wraith_form", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)

function imba_wraith_king_reincarnation:GetManaCost(level)
	if not self:GetCaster():HasTalent("special_bonus_imba_skeleton_king_6") then
		return self:GetSpecialValueFor("reincarnate_mana_cost")
	-- #6 Talent: Reincarnation no longer needs mana
	else
		return self:GetCaster():FindTalentValue("special_bonus_imba_skeleton_king_6")
	end
end

function imba_wraith_king_reincarnation:GetBehavior()
--	print("Reincarnation Behavior:", self:GetCaster():HasTalent("special_bonus_imba_skeleton_king_2"))

	if self:GetCaster():HasTalent("special_bonus_imba_skeleton_king_5") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end

	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

-- Should fully close out talent behavior change problems
function imba_wraith_king_reincarnation:OnOwnerSpawned()
	if not IsServer() then return end
	if self:GetCaster():HasAbility("special_bonus_imba_skeleton_king_5") and self:GetCaster():FindAbilityByName("special_bonus_imba_skeleton_king_5"):IsTrained() and not self:GetCaster():HasModifier("modifier_special_bonus_imba_skeleton_king_5") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_skeleton_king_5", {})
	end
	
	if self:GetCaster():HasTalent("special_bonus_imba_skeleton_king_6") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_skeleton_king_6") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_skeleton_king_6"), "modifier_special_bonus_imba_skeleton_king_6", {})
	end
end

function imba_wraith_king_reincarnation:GetIntrinsicModifierName()
	return "modifier_imba_reincarnation"
end

function imba_wraith_king_reincarnation:TheWillOfTheKing( OnDeathKeys, BuffInfo )
	local unit = OnDeathKeys.unit
	local reincarnate = OnDeathKeys.reincarnate

	-- Check if it was a reincarnation death
	if reincarnate and (not BuffInfo.caster:HasModifier("modifier_item_imba_aegis")) then
		BuffInfo.reincarnation_death = true

		-- Use the Reincarnation's ability cooldown
		BuffInfo.ability:UseResources(false, false, false, true)

		-- Play reincarnate sound
		if BuffInfo.caster == unit then
			local heroes = FindUnitsInRadius(
				BuffInfo.caster:GetTeamNumber(),
				BuffInfo.caster:GetAbsOrigin(),
				nil,
				BuffInfo.slow_radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
				FIND_ANY_ORDER,
				false
			)

			if USE_MEME_SOUNDS and #heroes >= PlayerResource:GetPlayerCount() * 0.35 then
				BuffInfo.caster:EmitSound(BuffInfo.sound_be_back)
			else
				BuffInfo.caster:EmitSound(BuffInfo.sound_death)
			end
		end

		-- Add particle effects
		local particle_death_fx = ParticleManager:CreateParticle(BuffInfo.particle_death, PATTACH_CUSTOMORIGIN, OnDeathKeys.unit, OnDeathKeys.unit)
		ParticleManager:SetParticleAlwaysSimulate(particle_death_fx)
		ParticleManager:SetParticleControl(particle_death_fx, 0, OnDeathKeys.unit:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_death_fx, 1, Vector(BuffInfo.reincarnate_delay, 0, 0))
		ParticleManager:SetParticleControl(particle_death_fx, 11, Vector(200, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle_death_fx)

		-- Add a FOW Viewer, depending on if it is a day or night
		if GameRules:IsDaytime() then
			AddFOWViewer(BuffInfo.caster:GetTeamNumber(), BuffInfo.caster:GetAbsOrigin(), BuffInfo.caster:GetDayTimeVisionRange(), BuffInfo.reincarnate_delay, true)
		else
			AddFOWViewer(BuffInfo.caster:GetTeamNumber(), BuffInfo.caster:GetAbsOrigin(), BuffInfo.caster:GetNightTimeVisionRange(), BuffInfo.reincarnate_delay, true)
		end

		if BuffInfo.caster:HasTalent("special_bonus_imba_skeleton_king_10") then
			local wraithfire_blast = BuffInfo.caster:FindAbilityByName("imba_wraith_king_wraithfire_blast")
			
			if wraithfire_blast and wraithfire_blast:IsTrained() then
		
				local enemies = FindUnitsInRadius(BuffInfo.caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				
				for _, enemy in pairs(enemies) do
					LaunchWraithblastProjectile(BuffInfo.caster, wraithfire_blast, unit, enemy, true, true)
				end
			end
		end

		-- Wait for the caster to reincarnate, then play its sound
		--Timers:CreateTimer(BuffInfo.reincarnate_delay, function()
		--    EmitSoundOn(BuffInfo.sound_reincarnation, BuffInfo.caster) 
		--end)                
	else
		BuffInfo.reincarnation_death = false     
	end
end

-- Reicarnation modifier
modifier_imba_reincarnation = modifier_imba_reincarnation or class({})

function modifier_imba_reincarnation:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()    
	self.particle_death = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
	self.sound_death = "Hero_SkeletonKing.Reincarnate"
	self.sound_reincarnation = "Hero_SkeletonKing.Reincarnate.Stinger"
	self.sound_be_back = "Hero_WraithKing.IllBeBack"
	self.modifier_wraith = "modifier_imba_reincarnation_wraith_form"

	-- Ability specials
	self.reincarnate_delay = self.ability:GetSpecialValueFor("reincarnate_delay")
	self.passive_respawn_haste = self.ability:GetSpecialValueFor("passive_respawn_haste")        
	self.slow_radius = self.ability:GetSpecialValueFor("slow_radius")
	self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")
	self.scepter_wraith_form_radius = self.ability:GetSpecialValueFor("scepter_wraith_form_radius")        

	if IsServer() then
		-- Set WK as immortal!
		self.can_die = false

		-- Start interval think
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_reincarnation:IsHidden() 
	if self:GetParent() == self.caster then
		return true
	else
		return false
	end
end
function modifier_imba_reincarnation:IsPurgable() return false end
function modifier_imba_reincarnation:IsDebuff() return false end

function modifier_imba_reincarnation:OnIntervalThink()
	if not self.ability or self.ability:IsNull() then self:Destroy() return end
	
	-- If caster has sufficent mana and the ability is ready, apply
	if (self.ability:IsOwnersManaEnough()) and (self.ability:IsCooldownReady()) and (not self.caster:HasModifier("modifier_item_imba_aegis")) then
--		print("WK IMMORTAL!")
		self.can_die = false
	else
--		print("OMG WK NOT IMMORTAL!")
		self.can_die = true
	end

	if self:GetCaster():HasTalent("special_bonus_imba_skeleton_king_5") and self:GetCaster():IsAlive() then
		if CalcDistanceBetweenEntityOBB(self:GetParent(), self.caster) > self.caster:FindTalentValue("special_bonus_imba_skeleton_king_5") or not self:GetCaster():IsAlive() or (self:GetCaster() ~= self:GetParent() and not self:GetAbility():GetAutoCastState()) or (self:GetCaster() ~= self:GetParent() and not self:GetAbility():IsCooldownReady()) then
			self:Destroy()
			return
		end

		if self:GetAbility():GetAutoCastState() and self:GetAbility():IsCooldownReady() then
			local units = FindUnitsInRadius(self.caster:GetTeamNumber(),
				self.caster:GetAbsOrigin(),
				nil,
				self.caster:FindTalentValue("special_bonus_imba_skeleton_king_5"),
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)

			for _,unit in pairs(units) do
				if unit ~= self.caster then
					unit:AddNewModifier(self.caster, self.ability, "modifier_imba_reincarnation", {})
				end
			end
		end
	end
end

function modifier_imba_reincarnation:OnRefresh()
	self:OnCreated()
end

function modifier_imba_reincarnation:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_REINCARNATION,                      
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_RESPAWNTIME_STACKING
	}
end

function modifier_imba_reincarnation:ReincarnateTime()
	if IsServer() then
		if not self.can_die and self.caster:IsRealHero() then
			return self.reincarnate_delay
		end

		return nil
	end
end

function modifier_imba_reincarnation:GetActivityTranslationModifiers()
	if self.reincarnation_death then
		return "reincarnate"
	end

	return nil
end

function modifier_imba_reincarnation:OnDeath(keys)
	if IsServer() then
		local unit = keys.unit
		local reincarnate = keys.reincarnate

		-- Only apply if the caster is the unit that died
		if self:GetParent() == unit then
			imba_wraith_king_reincarnation:TheWillOfTheKing( keys, self )
		end
	end
end


-- WRAITH FORM AURA FUNCTIONS
function modifier_imba_reincarnation:GetAuraRadius()
	return self.scepter_wraith_form_radius
end

function modifier_imba_reincarnation:GetAuraEntityReject(target)
	-- Aura ignores everyone that are already under the effects of Wraith Form (also edge case for Phoenix Scepter Supernova -_-)
	if target:HasModifier(self.modifier_wraith) or (target:HasModifier("modifier_imba_phoenix_supernova_scepter_passive") and target:HasScepter() and not target:HasModifier("modifier_imba_phoenix_supernova_scepter_passive_cooldown")) then
		return true 
	end

	return false    
end

function modifier_imba_reincarnation:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
end

function modifier_imba_reincarnation:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_reincarnation:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_reincarnation:GetModifierAura()
	return "modifier_imba_reincarnation_wraith_form_buff"
end

function modifier_imba_reincarnation:IsAura()
	if not self.caster:IsNull() and self.caster:IsRealHero() and self.caster:HasScepter() and self.caster == self:GetParent() then
		return true        
	end

	return false
end


-- Wraith Form modifier (given from aura, not yet Wraith Form)
modifier_imba_reincarnation_wraith_form_buff = modifier_imba_reincarnation_wraith_form_buff or class({})

function modifier_imba_reincarnation_wraith_form_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.modifier_wraith_form = "modifier_imba_reincarnation_wraith_form"

	-- Ability specials    
	self.scepter_wraith_form_duration = self.ability:GetSpecialValueFor("scepter_wraith_form_duration")
	self.max_wraith_form_heroes = self.ability:GetSpecialValueFor("max_wraith_form_heroes")
end

function modifier_imba_reincarnation_wraith_form_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MIN_HEALTH,
					  MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_imba_reincarnation_wraith_form_buff:GetMinHealth()
	return 1
end

function modifier_imba_reincarnation_wraith_form_buff:OnTakeDamage(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.unit 
		local damage = keys.damage

		-- Only apply if the unit taking damage is the parent
		if self.parent == target then
			
			-- Check if the damage is fatal 
			if damage >= self.parent:GetHealth() then

				-- Check for Shallow Grave: nothing happens
				if self.parent:HasModifier("modifier_imba_dazzle_shallow_grave") or self.parent:HasModifier("modifier_imba_dazzle_nothl_protection") then
					return nil
				end

				-- Check for Aegis: kill the unit normally
				if self.parent:HasModifier("modifier_item_imba_aegis") then
					self:Destroy()
					self.parent:Kill(self.ability, attacker)
					return nil
				end

				-- Check if this unit has Reincarnation and it is ready: if so, kill the unit normally
				if self.parent:HasAbility(self.ability:GetAbilityName()) then
					local reincarnation_ability = self.parent:FindAbilityByName(self.ability:GetAbilityName())
					if reincarnation_ability then
						if self.parent:GetMana() >= reincarnation_ability:GetManaCost(-1) and reincarnation_ability:IsCooldownReady() then
							self:Destroy()
							self.parent:Kill(self.ability, attacker)
							return nil
						end
					end
				end

				-- Assign the killer to the modifier, which would actually kill the hero later
				local wraith_form_modifier_handler = self.parent:AddNewModifier(self.caster, self.ability, self.modifier_wraith_form, {duration = self.scepter_wraith_form_duration})
				if wraith_form_modifier_handler then
					wraith_form_modifier_handler.original_killer = attacker
					wraith_form_modifier_handler.ability_killer = keys.inflictor
					if keys.inflictor then
						if keys.inflictor:GetName() == "imba_necrolyte_reapers_scythe" then
							keys.inflictor.ghost_death = true
						end
					end
				end                
			end
		end
	end
end


-- Wraith Form (actual Wraith Form)
modifier_imba_reincarnation_wraith_form = modifier_imba_reincarnation_wraith_form or class({})

function modifier_imba_reincarnation_wraith_form:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	if IsServer() then
		self.damage_pool = 0
		self.max_hp = self.parent:GetMaxHealth()
		self.threhold_hp = self.ability:GetSpecialValueFor("scepter_hp_pct_threhold") * 0.01 * self.max_hp
		self:StartIntervalThink(0.1)
	end
	self:SetStackCount(math.floor(self:GetDuration() + 0.5))
end

function modifier_imba_reincarnation_wraith_form:IsHidden() return false end
function modifier_imba_reincarnation_wraith_form:IsDebuff() return false end
function modifier_imba_reincarnation_wraith_form:IsPurgable() return false end

function modifier_imba_reincarnation_wraith_form:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
					  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
					  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
					  MODIFIER_PROPERTY_DISABLE_HEALING,
					  MODIFIER_PROPERTY_MODEL_SCALE,
					  MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_imba_reincarnation_wraith_form:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_imba_reincarnation_wraith_form:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_imba_reincarnation_wraith_form:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_imba_reincarnation_wraith_form:GetDisableHealing()
	return 1
end

function modifier_imba_reincarnation_wraith_form:GetModifierModelScale()
	return 105
end

function modifier_imba_reincarnation_wraith_form:OnIntervalThink()
	if not IsServer() then
		return
	end
	self:SetStackCount(math.floor(self:GetRemainingTime() + 0.5))
end

function modifier_imba_reincarnation_wraith_form:OnTakeDamage( keys )
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end

	if keys.damage_type == DAMAGE_TYPE_PHYSICAL then
		local source_dmg = keys.original_damage
		local armor = keys.unit:GetPhysicalArmorValue(false)
		local multiplier = 1 - (0.06 * armor) / (1 + 0.06 * math.abs(armor))
		local actually_dmg = source_dmg * multiplier
		self.damage_pool = self.damage_pool + actually_dmg
	elseif keys.damage_type == DAMAGE_TYPE_MAGICAL then
		local source_dmg = keys.original_damage
		local multiplier = 1 - self:GetParent():GetMagicalArmorValue()
		local actually_dmg = source_dmg * multiplier
		self.damage_pool = self.damage_pool + actually_dmg
	elseif keys.damage_type ~= DAMAGE_TYPE_PHYSICAL and keys.damage_type ~= DAMAGE_TYPE_MAGICAL then
		local actually_dmg = keys.original_damage
		self.damage_pool = self.damage_pool + actually_dmg
	end

	if self.damage_pool > self.threhold_hp then
		local duration_reduce = math.floor(self.damage_pool / self.threhold_hp)
		local duration_ori = self:GetRemainingTime()
		self.damage_pool = self.damage_pool - self.threhold_hp * duration_reduce
		if duration_ori > duration_reduce then
			self:SetDuration((duration_ori - duration_reduce), true)
			self:SetStackCount(math.floor(self:GetDuration() + 0.5))
		else
			self:Destroy()
		end
	end
end

function modifier_imba_reincarnation_wraith_form:CheckState()
	local state = {[MODIFIER_STATE_NO_HEALTH_BAR] = true,
				   [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
				   [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true}
	return state
end

function modifier_imba_reincarnation_wraith_form:OnDestroy()
	if IsServer() then
		-- Force kill the unit
		TrueKill(self.original_killer, self.parent, self.ability_killer)

		if self.parent:IsAlive() then
			self.parent:Kill(self.ability_killer, self.original_killer)
		end

		if self.parent:IsAlive() then
			local damageTable = {
			victim = self.parent,
			attacker = self.original_killer,
			damage = 100000000,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self.ability_killer,
			damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_REFLECTION,
			}
			ApplyDamage(damageTable)
		end

		self.damage_pool = nil
		self.max_hp = nil
		self.threhold_hp = nil
	end
	self.caster = nil
	self.ability = nil
	self.parent = nil
end

function modifier_imba_reincarnation_wraith_form:GetStatusEffectName()
	return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end





--------------------------------
--        KINGDOM COME        --
--------------------------------
imba_wraith_king_kingdom_come = imba_wraith_king_kingdom_come or class({})
LinkLuaModifier("modifier_imba_kingdom_come", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)    
LinkLuaModifier("modifier_imba_kingdom_come_slow", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_kingdom_come_stun", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)

function imba_wraith_king_kingdom_come:IsHiddenWhenStolen()        return true end
function imba_wraith_king_kingdom_come:IsRefreshable()             return true end
function imba_wraith_king_kingdom_come:IsStealable()               return true end

function imba_wraith_king_kingdom_come:GetCastAnimation()
	return ACT_DOTA_VICTORY
end

function imba_wraith_king_kingdom_come:IsNetherWardStealable() return false end
function imba_wraith_king_kingdom_come:IsInnateAbility()
	return true
end

function imba_wraith_king_kingdom_come:GetIntrinsicModifierName()
	return "modifier_imba_kingdom_come"
end

function imba_wraith_king_kingdom_come:GetBehavior()
--	print("Kingdom Come Behavior:", self:GetCaster():HasTalent("special_bonus_imba_skeleton_king_2"))

	if self:GetCaster():HasTalent("special_bonus_imba_skeleton_king_2") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end

	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

-- Should fully close out talent behavior change problems
function imba_wraith_king_kingdom_come:OnOwnerSpawned()
	if not IsServer() then return end
	if self:GetCaster():HasAbility("special_bonus_imba_skeleton_king_2") and self:GetCaster():FindAbilityByName("special_bonus_imba_skeleton_king_2"):IsTrained() and not self:GetCaster():HasModifier("modifier_special_bonus_imba_skeleton_king_2") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_skeleton_king_2", {})
	end
end

function imba_wraith_king_kingdom_come:GetCastPoint()
	if self:GetBehavior() ~= DOTA_ABILITY_BEHAVIOR_PASSIVE then
		return 1.0
	end

	return nil
end

function imba_wraith_king_kingdom_come:GetCooldown()
	if self:GetBehavior() ~= DOTA_ABILITY_BEHAVIOR_PASSIVE then
		return self:GetCaster():FindTalentValue("special_bonus_imba_skeleton_king_2")
	end

	return 0
end

function imba_wraith_king_kingdom_come:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_WraithKing.EruptionCast")

	return true
end

function imba_wraith_king_kingdom_come:OnAbilityPhaseInterrupted()
	self:GetCaster():StopSound("Hero_WraithKing.EruptionCast")
end

function imba_wraith_king_kingdom_come:OnSpellStart()    
	local keys = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_kingdom_come", self:GetCaster())
	-- Create Kingdom

	imba_wraith_king_create_kingdom(keys)
end

modifier_imba_kingdom_come = class({})

function modifier_imba_kingdom_come:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle_kingdom = "particles/hero/skeleton_king/wraith_king_hellfire_eruption_tell.vpcf"
	self.modifier_slow = "modifier_imba_kingdom_come_slow"

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")        
end

function modifier_imba_kingdom_come:IsHidden() return true end
function modifier_imba_kingdom_come:IsPurgable() return false end
function modifier_imba_kingdom_come:IsDebuff() return false end

function modifier_imba_kingdom_come:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_DEATH}

	return decFuncs
end

function modifier_imba_kingdom_come:OnDeath(keys)
	if IsServer() and not self:GetParent():PassivesDisabled() then
		local unit = keys.unit

		-- Only apply on the caster dying
		if self.caster == unit and self.caster:IsRealHero() then

			local info = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_kingdom_come", self:GetCaster())
			-- Create Kingdom
			imba_wraith_king_create_kingdom(info)
		end
	end
end

-- Kingdom Come slow
modifier_imba_kingdom_come_slow = class({})

function modifier_imba_kingdom_come_slow:OnCreated()    
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_slow = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate_slow_debuff.vpcf"
	self.modifier_stun = "modifier_imba_kingdom_come_stun"
	self.position = self:GetCaster():GetAbsOrigin()
	
	-- Ability specials
	self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
	self.as_slow = self.ability:GetSpecialValueFor("as_slow")
	self.stun_duration = self.ability:GetSpecialValueFor("stun_duration")
	self.damage = self.ability:GetSpecialValueFor("damage")        
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.wraith_duration = self.ability:GetSpecialValueFor("wraith_duration")

	if IsServer() then
		-- Add particle effect
		local particle_slow_fx = ParticleManager:CreateParticle(self.particle_slow, PATTACH_ABSORIGIN_FOLLOW, self.parent, self.caster)
		ParticleManager:SetParticleControl(particle_slow_fx, 0, self.parent:GetAbsOrigin())
		self:AddParticle(particle_slow_fx, false, false, -1, false, false)    
	end
end

function modifier_imba_kingdom_come_slow:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_imba_kingdom_come_slow:IsHidden() return false end
function modifier_imba_kingdom_come_slow:IsPurgable() return true end
function modifier_imba_kingdom_come_slow:IsDebuff() return true end

function modifier_imba_kingdom_come_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end

function modifier_imba_kingdom_come_slow:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow * (-1)
end

function modifier_imba_kingdom_come_slow:OnDestroy()    
	if IsServer() then
		-- Check the distance, see if it's still inside the ring AoE        
		local distance = (self.position - self.parent:GetAbsOrigin()):Length2D()

		-- if the parent is too far, do nothing
		if distance > self.radius then
			return nil
		end 

		-- If this is a real hero, stun and deal damage to it
		if self.parent:IsRealHero() then

			self.parent:AddNewModifier(self.caster, self.ability, self.modifier_stun, {duration = self.stun_duration * (1 - self.parent:GetStatusResistance())})

			local damageTable = {victim = self.parent,
								 attacker = self.caster, 
								 damage = self.damage,
								 damage_type = DAMAGE_TYPE_MAGICAL,
								 ability = self.ability
								 }
			
			ApplyDamage(damageTable)

			-- Summon a Wraith near it
			local direction = (self.parent:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()
			local distance = (self.parent:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D()
			local summon_point = self.caster:GetAbsOrigin() + direction * distance - 100
			local wraith = CreateUnitByName("npc_imba_wraith_king_wraith", summon_point, true, self.caster, self.caster, self.caster:GetTeamNumber())        

			-- Set the wraith as controllable by the player
			local playerid = self.caster:GetPlayerID()
			if playerid then
				wraith:SetControllableByPlayer(playerid, true)
			end

			-- Set the owner of the wraith as the caster
			wraith:SetOwner(self.caster)

			-- Set the Wraith's health to be the same as its origin
			wraith:SetBaseMaxHealth(self.parent:GetBaseMaxHealth())
			wraith:SetMaxHealth(self.parent:GetMaxHealth())
			wraith:SetHealth(wraith:GetMaxHealth())

			-- Set the Wraith to die after a small duration
			wraith:AddNewModifier(wraith, nil, "modifier_kill", {duration = self.wraith_duration})

			ResolveNPCPositions(self.parent:GetAbsOrigin(), 164)
		-- If it is a creep or an illusion, instantly kill it
		else
			if (self.parent:IsCreep() and not self.parent:IsAncient()) then
				self.parent:Kill(self.ability, self.caster)
			end
		end
	end
end


-- Kingdom Come stun modifier
modifier_imba_kingdom_come_stun = class({})

function modifier_imba_kingdom_come_stun:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state
end

function modifier_imba_kingdom_come_stun:IsHidden() return false end
function modifier_imba_kingdom_come_stun:IsPurgeException() return false end 
function modifier_imba_kingdom_come_stun:IsStunDebuff() return false end

function modifier_imba_kingdom_come_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_kingdom_come_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function imba_wraith_king_create_kingdom(keys)
	local enemy_units = FindUnitsInRadius(keys.caster:GetTeamNumber(),
									 keys.caster:GetAbsOrigin(),
									 nil,
									 keys.radius,
									 DOTA_UNIT_TARGET_TEAM_ENEMY,
									 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									 DOTA_UNIT_TARGET_FLAG_NONE,
									 FIND_ANY_ORDER,
									 false)

	for _,enemy_unit in pairs(enemy_units) do
		enemy_unit:AddNewModifier(keys.caster, keys.ability, keys.modifier_slow, {duration = keys.slow_duration * (1 - enemy_unit:GetStatusResistance())})
	end

	-- Play the Wraith Fire ring particle
	local particle_kingdom_fx = ParticleManager:CreateParticle(keys.particle_kingdom, PATTACH_ABSORIGIN, keys.caster, keys.caster)
	ParticleManager:SetParticleControl(particle_kingdom_fx, 0, keys.caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_kingdom_fx, 1, Vector(keys.radius, 1, 1))

	-- Add a FOW Viewer
	AddFOWViewer(keys.caster:GetTeamNumber(), keys.caster:GetAbsOrigin(), keys.radius, keys.slow_duration, false)

	Timers:CreateTimer(keys.slow_duration, function()
		ParticleManager:DestroyParticle(particle_kingdom_fx, false)
		ParticleManager:ReleaseParticleIndex(particle_kingdom_fx)
	end)
end


--------------------------------
--    WRAITH'S SOUL STRIKE    --
--------------------------------
imba_wraith_king_wraith_soul_strike = class({})
LinkLuaModifier("modifier_imba_wraith_soul_strike", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)    
LinkLuaModifier("modifier_imba_wraith_soul_strike_slow", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wraith_soul_strike_talent", "components/abilities/heroes/hero_skeleton_king.lua", LUA_MODIFIER_MOTION_NONE)

function imba_wraith_king_wraith_soul_strike:GetAbilityTextureName()
   return "ghost_frost_attack"
end

function imba_wraith_king_wraith_soul_strike:GetIntrinsicModifierName()
	return "modifier_imba_wraith_soul_strike"
end

modifier_imba_wraith_soul_strike = class({})

function modifier_imba_wraith_soul_strike:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()    
		self.ability = self:GetAbility()
		self.owner = self.caster:GetOwner()
		self.modifier_slow = "modifier_imba_wraith_soul_strike_slow"

		-- Ability specials
		self.wraiths_attacks = self.ability:GetSpecialValueFor("wraiths_attacks")
		self.max_hp_as_damage_pct = self.ability:GetSpecialValueFor("max_hp_as_damage_pct")

		-- Set starting stack count
		self:SetStackCount(self.wraiths_attacks)
		
		if self.owner:HasTalent("special_bonus_imba_skeleton_king_4") then
			self:GetParent():AddNewModifier(self.owner, self:GetAbility(), "modifier_imba_wraith_soul_strike_talent", {})
		end
	end
end

function modifier_imba_wraith_soul_strike:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_imba_wraith_soul_strike:OnAttack(keys)
	if IsServer() then
		local target = keys.target
		local attacker = keys.attacker

		-- Only apply on caster's attacks 
		if attacker == self.caster then

			-- Reduce a stack
			self:DecrementStackCount()     

			-- If there are no more stacks, kill the Wraith            
			local stacks = self:GetStackCount()
			if stacks == 0 then            
				Timers:CreateTimer(0.3, function()
					self.caster:Kill(self.ability, self.caster)
				end)
			end
		end
	end
end 

function modifier_imba_wraith_soul_strike:OnAttackLanded(keys)    
	local target = keys.target
	local attacker = keys.attacker

	-- Only apply on caster's attacks 
	if attacker == self.caster then

		-- If the target is a building, do nothing
		if target:IsBuilding() then
			return nil
		end

		-- Calculate damage based on Max HP
		local damage = self.caster:GetMaxHealth() * self.max_hp_as_damage_pct * 0.01

		-- Deal pure damage to enemy 
		local damageTable = {victim = target,
							 attacker = self.caster, 
							 damage = damage,
							 damage_type = DAMAGE_TYPE_MAGICAL,
							 ability = self.ability
							 }
		
		ApplyDamage(damageTable)

		-- #4 Talent: Kingdom Come Wraiths's attacks slow enemies
		if self.owner:HasTalent("special_bonus_imba_skeleton_king_4") then
			local duration = self.owner:FindTalentValue("special_bonus_imba_skeleton_king_4", "duration")

			target:AddNewModifier(self.caster, self.ability, self.modifier_slow, {duration = duration * (1 - target:GetStatusResistance())})
		end
	end
end


-- Soul Strike slow modifier - #4 Talent
modifier_imba_wraith_soul_strike_slow = class({})

function modifier_imba_wraith_soul_strike_slow:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.owner = self.caster:GetOwner()

		-- Talent properties
		self.ms_slow_pct = self.owner:FindTalentValue("special_bonus_imba_skeleton_king_4", "ms_slow_pct")

		-- Set server count
		self:SetStackCount(self.ms_slow_pct * (-1))

		self.ability:SetRefCountsModifiers(true)
	end
end

function modifier_imba_wraith_soul_strike_slow:IsHidden() return false end
function modifier_imba_wraith_soul_strike_slow:IsPurgable() return false end
function modifier_imba_wraith_soul_strike_slow:IsDebuff() return true end

function modifier_imba_wraith_soul_strike_slow:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_imba_wraith_soul_strike_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

---------------------------------------------
-- MODIFIER_IMBA_WRAITH_SOUL_STRIKE_TALENT --
---------------------------------------------

-- This is just to display the wraith has the slowing talent, as requested by Flat...

modifier_imba_wraith_soul_strike_talent	= modifier_imba_wraith_soul_strike_talent or class({})

function modifier_imba_wraith_soul_strike_talent:IsPurgable()	return false end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_skeleton_king_1", "components/abilities/heroes/hero_skeleton_king", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_skeleton_king_4", "components/abilities/heroes/hero_skeleton_king", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_skeleton_king_9", "components/abilities/heroes/hero_skeleton_king", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_skeleton_king_10", "components/abilities/heroes/hero_skeleton_king", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_skeleton_king_1		= modifier_special_bonus_imba_skeleton_king_1 or class({})
modifier_special_bonus_imba_skeleton_king_4		= modifier_special_bonus_imba_skeleton_king_4 or class({})
modifier_special_bonus_imba_skeleton_king_9		= modifier_special_bonus_imba_skeleton_king_9 or class({})
modifier_special_bonus_imba_skeleton_king_10	= modifier_special_bonus_imba_skeleton_king_10 or class({})

function modifier_special_bonus_imba_skeleton_king_1:IsHidden() 		return true end
function modifier_special_bonus_imba_skeleton_king_1:IsPurgable() 		return false end
function modifier_special_bonus_imba_skeleton_king_1:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_skeleton_king_4:IsHidden() 		return true end
function modifier_special_bonus_imba_skeleton_king_4:IsPurgable() 		return false end
function modifier_special_bonus_imba_skeleton_king_4:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_skeleton_king_9:IsHidden() 		return true end
function modifier_special_bonus_imba_skeleton_king_9:IsPurgable() 		return false end
function modifier_special_bonus_imba_skeleton_king_9:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_skeleton_king_10:IsHidden() 		return true end
function modifier_special_bonus_imba_skeleton_king_10:IsPurgable() 		return false end
function modifier_special_bonus_imba_skeleton_king_10:RemoveOnDeath() 	return false end

LinkLuaModifier("modifier_special_bonus_imba_skeleton_king_6", "components/abilities/heroes/hero_skeleton_king", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_skeleton_king_6	= modifier_special_bonus_imba_skeleton_king_6 or class({})

function modifier_special_bonus_imba_skeleton_king_6:IsHidden() 		return true end
function modifier_special_bonus_imba_skeleton_king_6:IsPurgable() 		return false end
function modifier_special_bonus_imba_skeleton_king_6:RemoveOnDeath() 	return false end

modifier_skeleton_king_ambient = modifier_skeleton_king_ambient or class({})

function modifier_skeleton_king_ambient:IsHidden() return true end
function modifier_skeleton_king_ambient:RemoveOnDeath() return false end
function modifier_skeleton_king_ambient:IsPurgable() return false end
function modifier_skeleton_king_ambient:IsPurgeException() return false end

function modifier_skeleton_king_ambient:GetTexture()
	return "phantom_assassin_arcana_coup_de_grace"
end

function modifier_skeleton_king_ambient:OnCreated()
	if not IsServer() then return end

	self.ambient_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_ambient_custom.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster(), self:GetCaster())
end

function modifier_skeleton_king_ambient:OnDestroy()
	if not IsServer() then return end

	if self.ambient_pfx then
		ParticleManager:DestroyParticle(self.ambient_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.ambient_pfx)
	end
end
