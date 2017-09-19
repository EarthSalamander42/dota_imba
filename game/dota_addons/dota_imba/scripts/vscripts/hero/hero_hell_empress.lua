-- Author: Firetoad
-- Date: 18/09/2017

--------------------------------------
--	ELEVEN CURSES
--------------------------------------
imba_empress_eleven_curses = class({})
LinkLuaModifier("modifier_imba_eleven_curses", "hero/hero_hell_empress.lua", LUA_MODIFIER_MOTION_NONE)

function imba_empress_eleven_curses:OnSpellStart(curse_target, curse_stacks)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local stacks_to_add = 1
	local modifier_curse = "modifier_imba_eleven_curses"

	-- Override curse parameters if they're passed in
	if curse_target then
		target = curse_target
	end

	if curse_stacks then
		stacks_to_add = curse_stacks
	end

	-- Ability parameters
	local stack_duration = self:GetSpecialValueFor("stack_duration")
	local max_stacks = self:GetSpecialValueFor("max_stacks")

	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- Play hit sound
	target:EmitSound("Hero_ShadowDemon.ShadowPoison.Release")

	-- Play target particle
	local hit_pfx = ParticleManager:CreateParticle("particles/econ/items/shadow_demon/sd_ti7_shadow_poison/sd_ti7_shadow_poison_release.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(hit_pfx, 2, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(hit_pfx, 3, Vector(100, 1, 1))
	ParticleManager:ReleaseParticleIndex(hit_pfx)

	-- Refresh the modifier's duration
	target:AddNewModifier(caster, self, modifier_curse, {duration = stack_duration})

	-- Increase the modifier's stack count
	local modifier_curse_instance = target:FindModifierByName(modifier_curse)
	modifier_curse_instance:SetStackCount(math.min(max_stacks, modifier_curse_instance:GetStackCount() + stacks_to_add))

end


------------------------------------
--	Eleven curses'  curse modifier
------------------------------------
modifier_imba_eleven_curses = class({})

function modifier_imba_eleven_curses:IsHidden() return false end
function modifier_imba_eleven_curses:IsPurgable() return true end
function modifier_imba_eleven_curses:IsDebuff() return true end

function modifier_imba_eleven_curses:OnCreated()
	self.amp_per_stack = self:GetAbility():GetSpecialValueFor("damage_amp")
end

function modifier_imba_eleven_curses:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end

function modifier_imba_eleven_curses:GetModifierIncomingDamage_Percentage()
	return self.amp_per_stack * self:GetStackCount()
end

--------------------------------------
--	HELLBOLT
--------------------------------------
imba_empress_hellbolt = class({})

function imba_empress_hellbolt:OnSpellStart()
	local caster = self:GetCaster()
	local modifier_curse = "modifier_imba_eleven_curses"    

	-- Ability parameters
	local target_radius = self:GetSpecialValueFor("target_radius") + GetCastRangeIncrease(caster)
	local bolt_speed = self:GetSpecialValueFor("bolt_speed")

	-- Play cast sound
	caster:EmitSound("Hero_SkywrathMage.ConcussiveShot.Cast")

	-- Iterate through nearby targets
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, target_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy:HasModifier(modifier_curse) then
			local projectile = {
				Target = enemy,
				Source = caster,
				Ability = self,
				EffectName = "particles/hero/hell_empress/empress_hellbolt.vpcf",
				bDodgable = true,
				bProvidesVision = false,
				iMoveSpeed = bolt_speed,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
			}
			ProjectileManager:CreateTrackingProjectile(projectile)
		end
	end
end

function imba_empress_hellbolt:OnProjectileHit(target, target_loc)
	local caster = self:GetCaster()
	local modifier_curse = "modifier_imba_eleven_curses"

	-- Ability parameters
	local base_damage = self:GetSpecialValueFor("base_damage")
	local bonus_damage = self:GetSpecialValueFor("bonus_damage")

	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- If the target is not spell immune, impact
	if not target:IsMagicImmune() then

		-- Play hit sound
		target:EmitSound("Hero_SkywrathMage.ConcussiveShot.Target")

		-- Calculate and deal damage
		if target:HasModifier(modifier_curse) then
			bonus_damage = target:FindModifierByName(modifier_curse):GetStackCount() * bonus_damage * 0.01 * target:GetHealth()
		else
			bonus_damage = 0
		end
		local damage = base_damage + bonus_damage
		ApplyDamage({victim = target, attacker = caster, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, damage, nil)
		target:RemoveModifierByName(modifier_curse)
	end
end

--------------------------------------
--	ROYAL WRATH
--------------------------------------
imba_empress_royal_wrath = class({})
LinkLuaModifier("modifier_imba_royal_wrath", "hero/hero_hell_empress.lua", LUA_MODIFIER_MOTION_NONE)

function imba_empress_royal_wrath:GetIntrinsicModifierName() 
	return "modifier_imba_royal_wrath"
end

------------------------------------
--	Royal Wrath's passive modifier
------------------------------------
modifier_imba_royal_wrath = class({})

function modifier_imba_royal_wrath:IsHidden() return true end
function modifier_imba_royal_wrath:IsPurgable() return false end
function modifier_imba_royal_wrath:IsDebuff() return false end
function modifier_imba_royal_wrath:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_imba_royal_wrath:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function modifier_imba_royal_wrath:OnTakeDamage( keys )
	if IsServer() then

		-- Check if the damaged unit is the modifier owner
		if keys.unit == self:GetParent() then

			-- Do all the other checks
			local parent = self:GetParent()
			local attacker = keys.attacker
			local ability = self:GetAbility()
			local ability_curse = parent:FindAbilityByName("imba_empress_eleven_curses")
			if attacker:IsRealHero() and ability:IsCooldownReady() and ability_curse and ability_curse:GetLevel() > 0 and not parent:PassivesDisabled() and not attacker:IsMagicImmune() then
				
				-- Trigger the curse ability
				ability_curse:OnSpellStart(attacker)
				local cooldown_reduction = parent:GetCooldownReduction() * 0.01
				
				-- Trigger the passive's cooldown
				ability:StartCooldown(ability:GetCooldown(ability:GetLevel()) * (1 - cooldown_reduction))
			end
		end
	end
end

--------------------------------------
--	HURL THROUGH HELL
--------------------------------------
imba_empress_hurl_through_hell = class({})
LinkLuaModifier("modifier_imba_hurl_through_hell", "hero/hero_hell_empress.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hurl_through_hell_slow", "hero/hero_hell_empress.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hurl_through_hell_root", "hero/hero_hell_empress.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hurl_through_hell_disarm", "hero/hero_hell_empress.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hurl_through_hell_silence", "hero/hero_hell_empress.lua", LUA_MODIFIER_MOTION_NONE)

function imba_empress_hurl_through_hell:OnSpellStart()
	local caster = self:GetCaster()
	local target_loc = self:GetCursorPosition()

	-- Parameters
	local hurl_radius = self:GetSpecialValueFor("hurl_radius")
	local hurl_duration = self:GetSpecialValueFor("hurl_duration")

	-- Play cast sound
	caster:EmitSound("Hero_ObsidianDestroyer.SanityEclipse.Cast")

	-- Play hit sound
	EmitSoundOnLocationWithCaster(target_loc, "Hero_ObsidianDestroyer.SanityEclipse", caster)

	-- Play cast particle
	local cast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_area.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(cast_pfx, 0, target_loc)
	ParticleManager:SetParticleControl(cast_pfx, 1, Vector(hurl_radius, 1, 1))
	ParticleManager:SetParticleControl(cast_pfx, 2, Vector(hurl_radius, 1, 1))
	ParticleManager:SetParticleControl(cast_pfx, 3, target_loc)
	ParticleManager:ReleaseParticleIndex(cast_pfx)

	-- Iterate through caught enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, hurl_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do

		-- Apply banishment modifier
		enemy:AddNewModifier(caster, self, "modifier_imba_hurl_through_hell", {duration = hurl_duration})
	end
end


------------------------------------
--	Hurl through hell's banishment modifier
------------------------------------
modifier_imba_hurl_through_hell = class({})

function modifier_imba_hurl_through_hell:IsHidden() return false end
function modifier_imba_hurl_through_hell:IsPurgable() return false end
function modifier_imba_hurl_through_hell:IsDebuff() return true end

function modifier_imba_hurl_through_hell:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_STUNNED] = true
	}

	return state
end

function modifier_imba_hurl_through_hell:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local parent_loc = parent:GetAbsOrigin()
		local ability = self:GetAbility()
		self.hurl_damage = ability:GetSpecialValueFor("hurl_damage")
		self.curse_stacks = ability:GetSpecialValueFor("curse_stacks")
		self.debuff_duration = ability:GetSpecialValueFor("debuff_duration")
		if self:GetCaster():HasScepter() then
			self.debuff_duration = ability:GetSpecialValueFor("debuff_duration_scepter")
		end

		-- Play astral prison loop sound
		EmitSoundOn("Hero_ObsidianDestroyer.AstralImprisonment", parent)

		-- Remove the model
		parent:AddNoDraw()

		-- Draw particle
		self.hurl_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf", PATTACH_WORLDORIGIN, parent)
		ParticleManager:SetParticleControl(self.hurl_pfx, 0, parent_loc)
		ParticleManager:SetParticleControl(self.hurl_pfx, 2, parent_loc)
		ParticleManager:SetParticleControl(self.hurl_pfx, 3, parent_loc)
		self:AddParticle(self.hurl_pfx, false, false, -1, false, false)
	end
end

function modifier_imba_hurl_through_hell:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local parent_loc = parent:GetAbsOrigin()
		local ability = self:GetAbility()
		
		-- Stop sound loop and play end sound
		parent:StopSound("Hero_ObsidianDestroyer.AstralImprisonment")
		EmitSoundOn("Hero_ObsidianDestroyer.AstralImprisonment.End", parent)

		-- Bring the model back
		parent:RemoveNoDraw()

		-- Destroy particle
		ParticleManager:DestroyParticle(self.hurl_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.hurl_pfx)
		
		-- Apply curse to the target
		local ability_curse = caster:FindAbilityByName("imba_empress_eleven_curses")
		if ability_curse and ability_curse:GetLevel() > 0 then
			ability_curse:OnSpellStart(parent, self.curse_stacks)
		end

		-- Deal damage
		ApplyDamage({victim = parent, attacker = caster, ability = ability, damage = self.hurl_damage, damage_type = DAMAGE_TYPE_MAGICAL})

		-- Pick a random debuff to apply
		local debuff_table = {
			"modifier_imba_hurl_through_hell_slow",
			"modifier_imba_hurl_through_hell_root",
			"modifier_imba_hurl_through_hell_disarm",
			"modifier_imba_hurl_through_hell_silence"
		}
		parent:AddNewModifier(caster, ability, table.remove(debuff_table, RandomInt(1, #debuff_table)), {duration = self.debuff_duration})

		-- If the caster has a scepter, apply another debuff
		if caster:HasScepter() then
			parent:AddNewModifier(caster, ability, debuff_table[RandomInt(1, #debuff_table)], {duration = self.debuff_duration})
		end

		-- Resolve position to prevent being stuck
		ResolveNPCPositions(parent_loc, 128)
	end
end

------------------------------------
--	Hurl through hell's slow modifier
------------------------------------
modifier_imba_hurl_through_hell_slow = class({})

function modifier_imba_hurl_through_hell_slow:IsHidden() return false end
function modifier_imba_hurl_through_hell_slow:IsPurgable() return false end
function modifier_imba_hurl_through_hell_slow:IsDebuff() return true end

function modifier_imba_hurl_through_hell_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_imba_hurl_through_hell_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow_pct")
end

function modifier_imba_hurl_through_hell_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("slow_pct")
end

------------------------------------
--	Hurl through hell's root modifier
------------------------------------
modifier_imba_hurl_through_hell_root = class({})

function modifier_imba_hurl_through_hell_root:IsHidden() return false end
function modifier_imba_hurl_through_hell_root:IsPurgable() return false end
function modifier_imba_hurl_through_hell_root:IsDebuff() return true end

function modifier_imba_hurl_through_hell_root:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true
	}

	return state
end

------------------------------------
--	Hurl through hell's disarm modifier
------------------------------------
modifier_imba_hurl_through_hell_disarm = class({})

function modifier_imba_hurl_through_hell_disarm:IsHidden() return false end
function modifier_imba_hurl_through_hell_disarm:IsPurgable() return false end
function modifier_imba_hurl_through_hell_disarm:IsDebuff() return true end

function modifier_imba_hurl_through_hell_disarm:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true
	}

	return state
end

------------------------------------
--	Hurl through hell's silence modifier
------------------------------------
modifier_imba_hurl_through_hell_silence = class({})

function modifier_imba_hurl_through_hell_silence:IsHidden() return false end
function modifier_imba_hurl_through_hell_silence:IsPurgable() return false end
function modifier_imba_hurl_through_hell_silence:IsDebuff() return true end

function modifier_imba_hurl_through_hell_silence:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true
	}

	return state
end