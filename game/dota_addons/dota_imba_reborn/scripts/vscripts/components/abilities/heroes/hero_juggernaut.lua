-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Editors:
--     Yahnich, 28.03.2017

-- BLADE FURY --
imba_juggernaut_blade_fury = imba_juggernaut_blade_fury or class({})
function imba_juggernaut_blade_fury:IsNetherWardStealable() return true end

function imba_juggernaut_blade_fury:OnSpellStart()
	self:GetCaster():Purge(false, true, false, false, false)

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_juggernaut_blade_fury", {duration = self:GetSpecialValueFor("duration")})

	-- Play cast lines
	local rand = RandomInt(2, 9)
	if (rand >= 2 and rand <= 3) or (rand >= 5 and rand <= 9) then
		self:GetCaster():EmitSound("juggernaut_jug_ability_bladefury_0"..rand)
	elseif rand >= 10 and rand <= 18 then
		self:GetCaster():EmitSound("Imba.JuggernautBladeFury"..rand)
	end
end

LinkLuaModifier("modifier_imba_juggernaut_blade_fury", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_juggernaut_blade_fury_debuff", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)

modifier_imba_juggernaut_blade_fury = modifier_imba_juggernaut_blade_fury or class({})

function modifier_imba_juggernaut_blade_fury:OnCreated()
	self.original_caster = self:GetCaster()
	self.dps = self:GetAbility():GetTalentSpecialValueFor("damage_per_sec")
	self.radius = self:GetAbility():GetTalentSpecialValueFor("effect_radius")
	self.tick = self:GetAbility():GetTalentSpecialValueFor("damage_tick")

	if IsServer() then
		if self:GetCaster():IsAlive() then
			local fury_particle = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf"

			if HasJuggernautArcana(self:GetCaster():GetPlayerID()) then
				fury_particle = "particles/econ/items/juggernaut/jugg_sword_dragon/juggernaut_blade_fury_dragon.vpcf"
				self.blade_fury_spin_pfx_2 = ParticleManager:CreateParticle(self:GetCaster().blade_fury_effect, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
				ParticleManager:SetParticleControl(self.blade_fury_spin_pfx_2, 5, Vector(self.radius * 1.2, 0, 0))
			end

			self.blade_fury_spin_pfx = ParticleManager:CreateParticle(fury_particle, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			ParticleManager:SetParticleControl(self.blade_fury_spin_pfx, 5, Vector(self.radius * 1.2, 0, 0))

			self:StartIntervalThink(self.tick)
			self:GetCaster():EmitSound("Hero_Juggernaut.BladeFuryStart")
			StartAnimation(self:GetCaster(), {activity = ACT_DOTA_OVERRIDE_ABILITY_1, rate = 1.0})
		end
	end
end

function modifier_imba_juggernaut_blade_fury:OnIntervalThink()
	local damage = self.dps * self.tick
	local caster_loc = self:GetCaster():GetAbsOrigin()
	-- Iterate through nearby enemies
	local furyEnemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), caster_loc, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _,enemy in pairs(furyEnemies) do
		-- Play hit sound
		enemy:EmitSound("Hero_Juggernaut.BladeFury.Impact")

		-- Play hit particle
		local slash_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(slash_pfx, 0, enemy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(slash_pfx)

		if not enemy:HasModifier("modifier_imba_juggernaut_blade_fury_debuff") then
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_juggernaut_blade_fury_debuff", {duration = self.tick})
		end

		-- Deal damage
		ApplyDamage({attacker = self:GetCaster(), victim = enemy, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end

function modifier_imba_juggernaut_blade_fury:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

function modifier_imba_juggernaut_blade_fury:OnRemoved()
	if IsServer() then
		self:GetCaster():StopSound("Hero_Juggernaut.BladeFuryStart")
		self:GetCaster():EmitSound("Hero_Juggernaut.BladeFuryStop")

		if self:GetCaster():HasModifier("modifier_imba_omni_slash_caster") then
			StartAnimation(self:GetCaster(), {activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.0})
		else
			EndAnimation(self:GetCaster())
		end

		if self.blade_fury_spin_pfx then
			ParticleManager:DestroyParticle(self.blade_fury_spin_pfx, false)
			ParticleManager:ReleaseParticleIndex(self.blade_fury_spin_pfx)
			self.blade_fury_spin_pfx = nil
		end

		if self.blade_fury_spin_pfx_2 then
			ParticleManager:DestroyParticle(self.blade_fury_spin_pfx_2, false)
			ParticleManager:ReleaseParticleIndex(self.blade_fury_spin_pfx_2)
			self.blade_fury_spin_pfx_2 = nil
		end
	end
end

modifier_imba_juggernaut_blade_fury_debuff = modifier_imba_juggernaut_blade_fury_debuff or class({})

function modifier_imba_juggernaut_blade_fury_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED,
	}

	return funcs
end

function modifier_imba_juggernaut_blade_fury_debuff:OnAttacked(keys)
	if IsServer() then
		if keys.attacker == self:GetCaster() and keys.target == self:GetParent() then
			-- make it so caster deals no damage
		end
	end
end

-- HEALING WARD --
imba_juggernaut_healing_ward = imba_juggernaut_healing_ward or class({})
function imba_juggernaut_healing_ward:IsNetherWardStealable() return false end

function imba_juggernaut_healing_ward:GetAbilityTextureName()
	return "juggernaut_healing_ward"
end

function imba_juggernaut_healing_ward:OnSpellStart()
	local caster = self:GetCaster()
	local targetPoint = self:GetCursorPosition()

	-- Play cast sound
	caster:EmitSound("Hero_Juggernaut.HealingWard.Cast")

	-- Spawn the Healing Ward
	local healing_ward = CreateUnitByName("npc_imba_juggernaut_healing_ward", targetPoint, true, caster, caster, caster:GetTeam())

	-- Make the ward immediately follow its caster
	healing_ward:SetControllableByPlayer(caster:GetPlayerID(), true)
	Timers:CreateTimer(0.1, function()
		healing_ward:MoveToNPC(caster)
	end)

	-- Increase the ward's health, if appropriate
	SetCreatureHealth(healing_ward, self:GetTalentSpecialValueFor("health"), true)

	-- Prevent nearby units from getting stuck
	ResolveNPCPositions(healing_ward:GetAbsOrigin(), healing_ward:GetHullRadius() + healing_ward:GetCollisionPadding())

	-- Apply the Healing Ward duration modifier
	healing_ward:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetTalentSpecialValueFor("duration")})
	-- Grant the Healing Ward its abilities
	healing_ward:AddAbility("imba_juggernaut_healing_ward_passive"):SetLevel( self:GetLevel() )
end

imba_juggernaut_healing_ward_passive = imba_juggernaut_healing_ward_passive or class({})

function imba_juggernaut_healing_ward_passive:GetAbilityTextureName()
	return "juggernaut_healing_ward"
end

function imba_juggernaut_healing_ward_passive:GetIntrinsicModifierName()
	return "modifier_imba_juggernaut_healing_ward_passive"
end

function imba_juggernaut_healing_ward_passive:OnSpellStart()
	local caster = self:GetCaster()
	local targetPoint = self:GetCursorPosition()
	-- Play cast sound
	caster:EmitSound("Hero_Juggernaut.HealingWard.Cast")

	-- Transform ward into totem
	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	caster:SetModel("models/items/juggernaut/ward/dc_wardupate/dc_wardupate.vmdl")
	SetCreatureHealth(caster, self:GetTalentSpecialValueFor("health_totem"), true)
	caster:FindModifierByName("modifier_imba_juggernaut_healing_ward_passive"):ForceRefresh()
end

LinkLuaModifier("modifier_imba_juggernaut_healing_ward_passive", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
modifier_imba_juggernaut_healing_ward_passive = modifier_imba_juggernaut_healing_ward_passive or class({})

function modifier_imba_juggernaut_healing_ward_passive:OnCreated()
	self.radius = self:GetAbility():GetTalentSpecialValueFor("heal_radius")

	if IsServer() then
		-- Play spawn particle
		local eruption_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_healing_ward_eruption.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(eruption_pfx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(eruption_pfx)

		-- Attach ambient particle
		self:GetCaster().healing_ward_ambient_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_healing_ward.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(self:GetCaster().healing_ward_ambient_pfx, 0, self:GetCaster():GetAbsOrigin() + Vector(0, 0, 100))
		ParticleManager:SetParticleControl(self:GetCaster().healing_ward_ambient_pfx, 1, Vector(self:GetAbility():GetTalentSpecialValueFor("heal_radius"), 1, 1))
		ParticleManager:SetParticleControlEnt(self:GetCaster().healing_ward_ambient_pfx, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)

		EmitSoundOn("Hero_Juggernaut.HealingWard.Loop", self:GetParent())
		self:StartIntervalThink(0.1) -- anti valve garbage measures
	end
end

function modifier_imba_juggernaut_healing_ward_passive:OnRefresh()	
	self.radius = self:GetAbility():GetTalentSpecialValueFor("heal_radius")

	if IsServer() then
		-- Play spawn particle
		local eruption_pfx = ParticleManager:CreateParticle("particles/econ/items/juggernaut/bladekeeper_healing_ward/juggernaut_healing_ward_eruption_dc.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(eruption_pfx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(eruption_pfx)

		-- Attach ambient particle
		ParticleManager:DestroyParticle(self:GetCaster().healing_ward_ambient_pfx, false)
		ParticleManager:ReleaseParticleIndex(self:GetCaster().healing_ward_ambient_pfx)
		self:GetCaster().healing_ward_ambient_pfx = nil
		self:GetCaster().healing_ward_ambient_pfx = ParticleManager:CreateParticle("particles/econ/items/juggernaut/bladekeeper_healing_ward/juggernaut_healing_ward_dc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(self:GetCaster().healing_ward_ambient_pfx, 0, self:GetCaster():GetAbsOrigin() + Vector(0, 0, 100))
		ParticleManager:SetParticleControl(self:GetCaster().healing_ward_ambient_pfx, 1, Vector(self:GetAbility():GetTalentSpecialValueFor("heal_radius_totem"), 1, 1))
		ParticleManager:SetParticleControlEnt(self:GetCaster().healing_ward_ambient_pfx, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	end
end

function modifier_imba_juggernaut_healing_ward_passive:OnIntervalThink()
	self:GetParent():SetModel("models/heroes/juggernaut/jugg_healing_ward.vmdl")
end

function modifier_imba_juggernaut_healing_ward_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_imba_juggernaut_healing_ward_passive:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_imba_juggernaut_healing_ward_passive:GetModifierAura()
	return "modifier_imba_juggernaut_healing_ward_aura"
end

function modifier_imba_juggernaut_healing_ward_passive:GetAuraEntityReject(target)
	if target:GetUnitName() == self:GetParent():GetUnitName() then return true end
	return false
end

--------------------------------------------------------------------------------

function modifier_imba_juggernaut_healing_ward_passive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_imba_juggernaut_healing_ward_passive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------

function modifier_imba_juggernaut_healing_ward_passive:GetAuraRadius()
	return self.radius
end

--------------------------------------------------------------------------------
function modifier_imba_juggernaut_healing_ward_passive:IsPurgable()
	return false
end

function modifier_imba_juggernaut_healing_ward_passive:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}
	return state
end

function modifier_imba_juggernaut_healing_ward_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_imba_juggernaut_healing_ward_passive:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_imba_juggernaut_healing_ward_passive:OnAttackLanded(params) -- health handling
	if params.target == self:GetParent() then
		local damage = 1
		if params.attacker:IsRealHero() or params.attacker:IsTower() then
			damage = 3
		end
		if self:GetParent():GetHealth() > damage then
			self:GetParent():SetHealth( self:GetParent():GetHealth() - damage)
		else
			self:GetParent():Kill(nil, params.attacker)
		end
	end
end

function modifier_imba_juggernaut_healing_ward_passive:OnDeath(params) -- modifier kill instadeletes thanks valve
	if params.unit == self:GetParent() then
		ParticleManager:DestroyParticle(self:GetCaster().healing_ward_ambient_pfx, false)
		ParticleManager:ReleaseParticleIndex(self:GetCaster().healing_ward_ambient_pfx)
		self:GetCaster().healing_ward_ambient_pfx = nil
		StopSoundOn("Hero_Juggernaut.HealingWard.Loop", self:GetParent())
	end
end

LinkLuaModifier("modifier_imba_juggernaut_healing_ward_aura", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
modifier_imba_juggernaut_healing_ward_aura = modifier_imba_juggernaut_healing_ward_aura or class({})

function modifier_imba_juggernaut_healing_ward_aura:OnCreated()
	if IsServer() then
		self.healing = self:GetAbility():GetTalentSpecialValueFor("heal_per_sec")
	end
end

function modifier_imba_juggernaut_healing_ward_aura:OnRefresh()
	if IsServer() then
		self.healing = self:GetAbility():GetTalentSpecialValueFor("heal_per_sec")
	end
end

function modifier_imba_juggernaut_healing_ward_aura:GetEffectName()
	return "particles/units/heroes/hero_juggernaut/juggernaut_ward_heal.vpcf"
end

function modifier_imba_juggernaut_healing_ward_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_imba_juggernaut_healing_ward_aura:GetModifierHealthRegenPercentage()
	return self.healing
end

function modifier_imba_juggernaut_healing_ward_aura:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end


-- BLADE DANCE --
imba_juggernaut_blade_dance = imba_juggernaut_blade_dance or class({})

function imba_juggernaut_blade_dance:GetIntrinsicModifierName()
	return "modifier_imba_juggernaut_blade_dance_passive"
end

LinkLuaModifier("modifier_imba_juggernaut_blade_dance_passive", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
modifier_imba_juggernaut_blade_dance_passive = modifier_imba_juggernaut_blade_dance_passive or class({})

function modifier_imba_juggernaut_blade_dance_passive:IsHidden()
	return true
end

function modifier_imba_juggernaut_blade_dance_passive:OnCreated()
	self.crit = self:GetAbility():GetTalentSpecialValueFor("crit_damage")
	self.chance = self:GetAbility():GetTalentSpecialValueFor("crit_chance")
	self.critProc = false
end

function modifier_imba_juggernaut_blade_dance_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

if IsServer() then
	function modifier_imba_juggernaut_blade_dance_passive:GetModifierPreAttack_CriticalStrike(params)
		if self:GetParent():PassivesDisabled() then return nil end
		if RollPseudoRandom(self.chance, self) then
			self.critProc = true
			return self.crit
		else
			self.critProc = false
			return nil
		end
	end

	function modifier_imba_juggernaut_blade_dance_passive:OnAttackLanded(params)
		if params.attacker == self:GetParent() and self.critProc == true then
			local crit_pfx = "particles/units/heroes/hero_juggernaut/jugg_crit_blur.vpcf"
			local crit_sound = "Hero_Juggernaut.BladeDance"

			-- particle not working for reasons
			if HasJuggernautArcana(self:GetCaster():GetPlayerID()) then
				if HasJuggernautArcana(self:GetCaster():GetPlayerID()) == 0 then
					crit_pfx = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_crit_tgt.vpcf"
				elseif HasJuggernautArcana(self:GetCaster():GetPlayerID()) == 1 then
					crit_pfx = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_crit_tgt.vpcf"
				end

				crit_sound = "Hero_Juggernaut.BladeDance.Arcana"
			end

			local particle = ParticleManager:CreateParticle(crit_pfx, PATTACH_ABSORIGIN, params.target)
			ParticleManager:SetParticleControl(particle, 0, params.target:GetAbsOrigin())

			if HasJuggernautArcana(self:GetCaster():GetPlayerID()) then
				ParticleManager:SetParticleControl(particle, 1, params.target:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle, 3, params.target:GetAbsOrigin())
			end

			ParticleManager:ReleaseParticleIndex(particle)

			-- Play crit sound
			self:GetParent():EmitSound(crit_sound)
			self.critProc = false
		end
	end
end

-- OMNI SLASH --
imba_juggernaut_omni_slash = imba_juggernaut_omni_slash or class({})
LinkLuaModifier("modifier_imba_omni_slash_caster", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_omni_slash_image", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_omni_slash_talent", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omnislash_image_afterimage_fade", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)

function imba_juggernaut_omni_slash:IsNetherWardStealable() return false end
function imba_juggernaut_omni_slash:GetIntrinsicModifierName()
	return	"modifier_imba_juggernaut_omni_slash_cdr"
end

function imba_juggernaut_omni_slash:IsHiddenWhenStolen()
	return false
end

function imba_juggernaut_omni_slash:GetAbilityTextureName()
	return "juggernaut_omni_slash"
end

function imba_juggernaut_omni_slash:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local rand = math.random
	local im_the_juggernaut_lich = 10
	local ryujinnokenwokurae = 10
	if RollPercentage(im_the_juggernaut_lich) then
		caster:EmitSound("juggernaut_jug_rare_17")
	elseif RollPercentage(im_the_juggernaut_lich) then
		caster:EmitSound("Imba.JuggernautGenji")
	else
		caster:EmitSound("juggernaut_jug_ability_omnislash_0"..rand(3))
	end

	return true
end

function imba_juggernaut_omni_slash:OnSpellStart()
	self.caster = self:GetCaster()
	self.target = self:GetCursorTarget()

	self.previous_position = self.caster:GetAbsOrigin()

	local omnislash_modifier_handler = self.caster:AddNewModifier(self.caster, self, "modifier_imba_omni_slash_caster", {duration = 15.0})

	if omnislash_modifier_handler then
		omnislash_modifier_handler.original_caster = self.caster
	end

	PlayerResource:SetCameraTarget(self.caster:GetPlayerID(), self.caster)

	FindClearSpaceForUnit(self.caster, self.target:GetAbsOrigin() + RandomVector(128), false)

	self.caster:EmitSound("Hero_Juggernaut.OmniSlash")

	StartAnimation(self.caster, {activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.0})

	if self.target:TriggerSpellAbsorb(self) then
		return nil
	end

	Timers:CreateTimer(FrameTime(), function()
		self.current_position = self.caster:GetAbsOrigin()

		PlayerResource:SetCameraTarget(self.caster:GetPlayerID(), nil)

		self.caster:PerformAttack(self.target, true, true, true, true, true, false, false)

		-- Play particle trail when moving
		local trail_pfx = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_dash.vpcf", PATTACH_ABSORIGIN, self.caster)
		ParticleManager:SetParticleControl(trail_pfx, 0, self.previous_position)
		ParticleManager:SetParticleControl(trail_pfx, 1, self.current_position)
		ParticleManager:ReleaseParticleIndex(trail_pfx)
	end)
end

modifier_imba_omni_slash_image = modifier_imba_omni_slash_image or class ({})

function modifier_imba_omni_slash_image:DeclareFunctions()
	return {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE}
end

function modifier_imba_omni_slash_image:CheckState()
	local state = {[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

function modifier_imba_omni_slash_image:OnCreated()
	if not IsServer() then
		return
	end
	self:StartIntervalThink(0.5)
end

function modifier_imba_omni_slash_image:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetParent()
	if not caster:HasModifier("modifier_imba_omni_slash_caster") then
		self:Destroy()
	end
end

function modifier_imba_omni_slash_image:GetModifierDamageOutgoing_Percentage()
	local image_outgoing_damage_percent = (100 - self:GetCaster():FindTalentValue("special_bonus_imba_juggernaut_7")) * (-1)
	return image_outgoing_damage_percent
end

function modifier_imba_omni_slash_image:IsHidden()
	return true
end

function modifier_imba_omni_slash_image:IsPurgable()
	return false
end

function modifier_imba_omni_slash_image:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

modifier_imba_omni_slash_talent = modifier_imba_omni_slash_talent or class ({})

function modifier_imba_omni_slash_talent:DeclareFunctions()
	return {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE}
end

function modifier_imba_omni_slash_talent:CheckState()
	local state = {[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

-- Bonus damage from Omnislash
function modifier_imba_omni_slash_talent:GetModifierBaseAttack_BonusDamage()
	self.caster = self:GetCaster()
	self.hero_agility = self.caster:GetAgility()
	self.base_bonus_damage = self:GetAbility():GetTalentSpecialValueFor("bonus_damage_att")

	if self.hero_agility then
		local bonus_damage = self.hero_agility * self.base_bonus_damage * 0.01

		return bonus_damage
	end
	return 0
end

-- Damage reduction from Omnislash Talent
function modifier_imba_omni_slash_talent:GetModifierDamageOutgoing_Percentage()
	local caster_outgoing_damage_percent = (100 - self:GetCaster():FindTalentValue("special_bonus_imba_juggernaut_7","caster_outgoing_damage")) * (-1)
	return caster_outgoing_damage_percent
end

function modifier_imba_omni_slash_talent:IsHidden()
	return true
end

function modifier_imba_omni_slash_talent:IsPurgable()
	return false
end

function modifier_imba_omni_slash_talent:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_omni_slash_talent:GetStatusEffectName()
	return "particles/status_fx/status_effect_omnislash.vpcf"
end

modifier_imba_omni_slash_caster = modifier_imba_omni_slash_caster or class({})

function modifier_imba_omni_slash_caster:OnCreated()
	self.caster = self:GetParent()
	self.parent = self:GetParent()
	self.base_bonus_damage = self:GetAbility():GetTalentSpecialValueFor("bonus_damage_att")
	self.minimum_damage = self:GetAbility():GetTalentSpecialValueFor("min_damage")
	self.last_enemy = nil

	if not self:GetAbility() then
		self:Destroy()
		return nil
	end

	-- Add the first instance of Omnislash to proc the minimum damage
	self.slash = true

	-- Seriously!? Took me 2 hours to fix this. >:(
	if IsServer() then
		Timers:CreateTimer(FrameTime(), function()
			if (not self.caster:IsNull()) then
				if not self.original_caster:HasScepter() then
					self.bounce_range = self:GetAbility():GetTalentSpecialValueFor("bounce_range")
					self.bounce_amt = self:GetAbility():GetTalentSpecialValueFor("jump_amount")
				else
					self.bounce_range = self:GetAbility():GetTalentSpecialValueFor("scepter_bounce_range")
					self.bounce_amt = self:GetAbility():GetTalentSpecialValueFor("scepter_jump_amt")
				end

				self.hero_agility = self.original_caster:GetAgility()
				self:GetAbility():SetRefCountsModifiers(false)
				self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("bounce_delay"))
			end
		end)
	end
end

function modifier_imba_omni_slash_caster:OnIntervalThink()
	-- Get the hero Agility while casting Omnislash
	self.hero_agility = self.original_caster:GetAgility()
	self:BounceAndSlaughter()
end

function modifier_imba_omni_slash_caster:BounceAndSlaughter()
	self.nearby_enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),
		self.caster:GetAbsOrigin(),
		nil,
		self.bounce_range,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		FIND_ANY_ORDER,
		false
	)

	if self.bounce_amt >= 1 and #self.nearby_enemies >= 1 then
		for _,enemy in pairs(self.nearby_enemies) do

			local previous_position = self.caster:GetAbsOrigin()
			FindClearSpaceForUnit(self.caster, enemy:GetAbsOrigin() + RandomVector(128), false)

			self.caster:MoveToTargetToAttack(enemy)

			local current_position = self.caster:GetAbsOrigin()

			-- Provide vision of the target for a short duration
			self:GetAbility():CreateVisibilityNode(current_position, 300, 1.0)

			-- Perform the slash
			self.slash = true

			self.caster:PerformAttack(enemy, true, true, true, true, true, false, false)

			-- If the target is not Roshan or a hero, instantly kill it
			if not ( enemy:IsHero() or IsRoshan(enemy) ) then
				enemy:Kill(self:GetAbility(), self.original_caster)
			end

			-- Count down amount of slashes
			self.bounce_amt = self.bounce_amt - 1

			-- Play hit sound
			enemy:EmitSound("Hero_Juggernaut.OmniSlash.Damage")

			-- Play hit particle on the current target
			local hit_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(hit_pfx, 0, current_position)
			ParticleManager:ReleaseParticleIndex(hit_pfx)

			-- Play particle trail when moving
			local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", PATTACH_ABSORIGIN, self.caster)
			ParticleManager:SetParticleControl(trail_pfx, 0, previous_position)
			ParticleManager:SetParticleControl(trail_pfx, 1, current_position)
			ParticleManager:ReleaseParticleIndex(trail_pfx)

			self.last_enemy = enemy

			if self.caster:HasModifier("modifier_imba_omni_slash_image") then
				if (not self.original_caster:HasModifier("modifier_imba_omni_slash_talent")) then
					self.original_caster:AddNewModifier(self.original_caster,self:GetAbility(),"modifier_imba_omni_slash_talent",{})
				end
				self.previous_pos = previous_position
				self.current_pos = current_position
			end

			break
		end
	else
		self:Destroy()
	end
end

function modifier_imba_omni_slash_caster:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}

	return decFuncs
end

-- Omnislash's minimum damage handler
function modifier_imba_omni_slash_caster:GetModifierProcAttack_BonusDamage_Physical(kv)
	if IsServer() then

		-- If the damage is not conducted by the ability itself, do nothing.
		if not self.slash then
			return nil
		end

		-- If Omnislash's slash damage is less than minimum damage according to the damage reduction from #7 Talent, add the bonus till minimum threshold
		if self.caster:HasModifier("modifier_imba_omni_slash_image") then
			if kv.attacker == self.caster and kv.damage <= (self.minimum_damage / (100 - self.original_caster:FindTalentValue("special_bonus_imba_juggernaut_7")) * 0.01) then
				-- Set the slash ability to false so it won't trigger for normal attacks
				self.slash = false
				return ((self.minimum_damage - kv.damage) / (100 - self.original_caster:FindTalentValue("special_bonus_imba_juggernaut_7")) * 0.01 )
			end
		end

		-- If Omnislash's slash damage is less than minimum damage, add the bonus till minimum threshold
		if kv.attacker == self.caster and kv.damage <= self.minimum_damage then
			-- Set the slash ability to false so it won't trigger for normal attacks
			self.slash = false
			return self.minimum_damage - kv.damage
		end
	end
end

function modifier_imba_omni_slash_caster:OnDestroy()
	if IsServer() then
		PlayerResource:SetCameraTarget(self.caster:GetPlayerID(), nil)

		if self.bounce_amt > 1 then
			local rand = RandomInt(1, 2)
			self.caster:EmitSound("juggernaut_jug_ability_waste_0"..rand)
		end

		-- If jugg has stopped bouncing, stop the animation.
		if self.bounce_amt == 0 or  #self.nearby_enemies == 0 then
			self.caster:FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
		end

		-- Create the delay effect before the image destroys itself.
		if self.caster:HasModifier("modifier_imba_omni_slash_image") then
			if self.caster:HasModifier("modifier_imba_juggernaut_blade_fury") then
				self.caster:RemoveModifierByName("modifier_imba_juggernaut_blade_fury")
			end

			if self.original_caster:HasModifier("modifier_imba_omni_slash_talent") then
				self.original_caster:RemoveModifierByName("modifier_imba_omni_slash_talent")
			end

			-- Create the after image before it fades
			if self.previous_pos then
				CreateModifierThinker(self.original_caster, self:GetAbility(), "modifier_omnislash_image_afterimage_fade" ,{duration = 1.0, previous_position_x = self.previous_pos.x, previous_position_y = self.previous_pos.y, previous_position_z = self.previous_pos.z}, self.current_pos, self.original_caster:GetTeamNumber(), false)
			else -- not a real fix, just unallow an uncontrollable jugg to spawn
				print("No previous pos!")
			end

			self:GetParent():MakeIllusion()
			self:GetParent():RemoveModifierByName("modifier_imba_omni_slash_image")

			for item_id=0, 5 do
				local item_in_caster = self.caster:GetItemInSlot(item_id)
				if item_in_caster ~= nil then
					UTIL_Remove(item_in_caster)
				end
			end

			-- Search for buffs and debuffs
			local caster_modifiers = self.caster:FindAllModifiers()
			for _,modifier in pairs(caster_modifiers) do
				if modifier then
					UTIL_Remove(modifier)
				end
			end

			if (not self:GetCaster():IsNull()) then
				self:GetCaster():SetAbsOrigin(Vector(0,0,99999))
				self:GetCaster():AddNoDraw()

				local icaster = self:GetCaster()
				UTIL_Remove(icaster)
			end
		end
	end
end

modifier_omnislash_image_afterimage_fade = modifier_omnislash_image_afterimage_fade or class({})

function modifier_omnislash_image_afterimage_fade:OnCreated(keys)
	if IsServer() then
		local caster = self:GetCaster()
		local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())

		ParticleManager:SetParticleControl(trail_pfx, 0, Vector(keys.previous_position_x, keys.previous_position_y, keys.previous_position_z))
		ParticleManager:SetParticleControl(trail_pfx, 1, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(trail_pfx)
	end
end

function modifier_imba_omni_slash_caster:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

function modifier_imba_omni_slash_caster:StatusEffectPriority()
	return 20
end

function modifier_imba_omni_slash_caster:GetStatusEffectName()
	return "particles/status_fx/status_effect_omnislash.vpcf"
end

function modifier_imba_omni_slash_caster:IsHidden() return false end
function modifier_imba_omni_slash_caster:IsPurgable() return false end
function modifier_imba_omni_slash_caster:IsDebuff() return false end

LinkLuaModifier("modifier_imba_juggernaut_omni_slash_cdr", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
modifier_imba_juggernaut_omni_slash_cdr = modifier_imba_juggernaut_omni_slash_cdr or class({})

function modifier_imba_juggernaut_omni_slash_cdr:IsHidden()
	return true
end

function modifier_imba_juggernaut_omni_slash_cdr:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_imba_juggernaut_omni_slash_cdr:OnAttackLanded(params) -- health handling
	if params.attacker == self:GetParent() and params.target:IsRealHero() and not self:GetAbility():IsCooldownReady() then
		local cd = self:GetAbility():GetCooldownTimeRemaining()
		self:GetAbility():EndCooldown()
		self:GetAbility():StartCooldown(cd)
	end
end
