-- Creator:
--	   AltiV, Decemeber 28th, 2019

LinkLuaModifier("modifier_generic_orb_effect_lua", "components/modifiers/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_charges", "components/modifiers/generic/modifier_generic_charges", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_outworld_devourer_astral_imprisonment_prison", "components/abilities/heroes/hero_outworld_devourer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_outworld_devourer_essence_flux", "components/abilities/heroes/hero_outworld_devourer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_outworld_devourer_essence_flux_active", "components/abilities/heroes/hero_outworld_devourer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_outworld_devourer_essence_flux_debuff", "components/abilities/heroes/hero_outworld_devourer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_outworld_devourer_astral_imprisonment_movement", "components/abilities/heroes/hero_outworld_devourer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_outworld_devourer_sanity_eclipse_charge", "components/abilities/heroes/hero_outworld_devourer", LUA_MODIFIER_MOTION_NONE)

imba_outworld_devourer_arcane_orb                            = imba_outworld_devourer_arcane_orb or class({})

imba_outworld_devourer_astral_imprisonment                   = imba_outworld_devourer_astral_imprisonment or class({})
modifier_imba_outworld_devourer_astral_imprisonment_prison   = modifier_imba_outworld_devourer_astral_imprisonment_prison or class({})

imba_outworld_devourer_essence_flux                          = imba_outworld_devourer_essence_flux or class({})
modifier_imba_outworld_devourer_essence_flux                 = modifier_imba_outworld_devourer_essence_flux or class({})
modifier_imba_outworld_devourer_essence_flux_active          = modifier_imba_outworld_devourer_essence_flux_active or class({})
modifier_imba_outworld_devourer_essence_flux_debuff          = modifier_imba_outworld_devourer_essence_flux_debuff or class({})

imba_outworld_devourer_astral_imprisonment_movement          = imba_outworld_devourer_astral_imprisonment_movement or class({})
modifier_imba_outworld_devourer_astral_imprisonment_movement = modifier_imba_outworld_devourer_astral_imprisonment_movement or class({})

imba_outworld_devourer_sanity_eclipse                        = imba_outworld_devourer_sanity_eclipse or class({})
modifier_imba_outworld_devourer_sanity_eclipse_charge        = modifier_imba_outworld_devourer_sanity_eclipse_charge or class({})

---------------------------------------
-- IMBA_OUTWORLD_DEVOURER_ARCANE_ORB --
---------------------------------------

function imba_outworld_devourer_arcane_orb:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end

function imba_outworld_devourer_arcane_orb:GetProjectileName()
	return "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf"
end

function imba_outworld_devourer_arcane_orb:OnOrbFire()
	self:GetCaster():EmitSound("Hero_ObsidianDestroyer.ArcaneOrb")

	if self:GetCaster():HasModifier("modifier_imba_outworld_devourer_essence_flux") then
		self:GetCaster():FindModifierByName("modifier_imba_outworld_devourer_essence_flux"):RollForProc()
	end
end

function imba_outworld_devourer_arcane_orb:OnOrbImpact(keys)
	if not keys.target:IsMagicImmune() then
		local damage = self:GetCaster():GetMana() * self:GetTalentSpecialValueFor("mana_pool_damage_pct") / 100

		-- IMBAfication: Universe Unleashed
		if keys.target:IsIllusion() or keys.target:IsSummoned() then
			damage = damage + self:GetSpecialValueFor("universe_bonus_dmg")
		end

		self.damage_dealt = ApplyDamage({
			victim       = keys.target,
			damage       = damage,
			damage_type  = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self:GetCaster(),
			ability      = self
		})

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, damage, nil)

		-- IMBAfication: Universe Unleashed
		if (keys.target:IsIllusion() or keys.target:IsSummoned()) and self.damage_dealt > 0 and self.damage_dealt >= keys.target:GetHealth() then -- and not keys.target:IsAlive() then
			-- Add main particle
			self.particle_explosion_fx = ParticleManager:CreateParticle("particles/hero/outworld_devourer/arcane_orb_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
			ParticleManager:SetParticleControl(self.particle_explosion_fx, 1, keys.target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.particle_explosion_fx)

			-- Add unleashed energy particles
			self.particle_explosion_scatter_fx = ParticleManager:CreateParticle("particles/hero/outworld_devourer/arcane_orb_explosion_f.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
			ParticleManager:SetParticleControl(self.particle_explosion_scatter_fx, 0, keys.target:GetAbsOrigin())
			ParticleManager:SetParticleControl(self.particle_explosion_scatter_fx, 3, Vector(self:GetSpecialValueFor("universe_splash_radius"), 0, 0))
			ParticleManager:ReleaseParticleIndex(self.particle_explosion_scatter_fx)

			for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self:GetSpecialValueFor("universe_splash_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
				ApplyDamage({
					victim       = enemy,
					damage       = damage - self:GetSpecialValueFor("universe_bonus_dmg"),
					damage_type  = self:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					attacker     = self:GetCaster(),
					ability      = self
				})

				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage - self:GetSpecialValueFor("universe_bonus_dmg"), nil)
			end
		end

		if self:GetCaster():HasAbility("imba_outworld_devourer_sanity_eclipse") and self:GetCaster():FindAbilityByName("imba_outworld_devourer_sanity_eclipse"):IsTrained() and (keys.target:IsRealHero() or keys.target:IsIllusion()) and keys.target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("imba_outworld_devourer_sanity_eclipse"), "modifier_imba_outworld_devourer_sanity_eclipse_charge", { duration = self:GetSpecialValueFor("counter_duration"), charges = 1 })
		end
	end
end

------------------------------------------------
-- IMBA_OUTWORLD_DEVOURER_ASTRAL_IMPRISONMENT --
------------------------------------------------

function imba_outworld_devourer_astral_imprisonment:RequiresScepterForCharges() return true end

function imba_outworld_devourer_astral_imprisonment:GetAssociatedSecondaryAbilities()
	return "imba_outworld_devourer_astral_imprisonment_movement"
end

function imba_outworld_devourer_astral_imprisonment:GetCastRange(location, target)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCastRange(self, location, target)
	else
		return self.BaseClass.GetCastRange(self, location, target) + self:GetSpecialValueFor("scepter_range_bonus")
	end
end

function imba_outworld_devourer_astral_imprisonment:GetCooldown(level)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCooldown(self, level)
	else
		return 0
	end
end

function imba_outworld_devourer_astral_imprisonment:OnInventoryContentsChanged()
	-- Caster got scepter
	if self:GetCaster():HasScepter() and not self:GetCaster():HasModifier("modifier_generic_charges") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_charges", {})
	end
end

function imba_outworld_devourer_astral_imprisonment:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

function imba_outworld_devourer_astral_imprisonment:OnSpellStart()
	local target = self:GetCursorTarget()

	if not target:TriggerSpellAbsorb(self) then
		target:EmitSound("Hero_ObsidianDestroyer.AstralImprisonment")

		local prison_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_outworld_devourer_astral_imprisonment_prison", { duration = self:GetSpecialValueFor("prison_duration") })

		if prison_modifier and target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
			prison_modifier:SetDuration(self:GetSpecialValueFor("prison_duration") * (1 - target:GetStatusResistance()), true)
			self:GetCaster():AddNewModifier(target, self, "modifier_imba_outworld_devourer_astral_imprisonment_movement", { duration = self:GetSpecialValueFor("prison_duration") * (1 - target:GetStatusResistance()) })
		else
			self:GetCaster():AddNewModifier(target, self, "modifier_imba_outworld_devourer_astral_imprisonment_movement", { duration = self:GetSpecialValueFor("prison_duration") })
		end

		if self:GetCaster():HasAbility("imba_outworld_devourer_sanity_eclipse") and self:GetCaster():FindAbilityByName("imba_outworld_devourer_sanity_eclipse"):IsTrained() and (target:IsRealHero() or target:IsIllusion()) and target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("imba_outworld_devourer_sanity_eclipse"), "modifier_imba_outworld_devourer_sanity_eclipse_charge", { duration = self:GetSpecialValueFor("counter_duration"), charges = 3 })
		end
	end
end

----------------------------------------------------------------
-- MODIFIER_IMBA_OUTWORLD_DEVOURER_ASTRAL_IMPRISONMENT_PRISON --
----------------------------------------------------------------

function modifier_imba_outworld_devourer_astral_imprisonment_prison:IsPurgable() return false end

function modifier_imba_outworld_devourer_astral_imprisonment_prison:GetEffectName()
	return "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf"
end

function modifier_imba_outworld_devourer_astral_imprisonment_prison:OnCreated()
	if not IsServer() then return end

	self.damage              = self:GetAbility():GetTalentSpecialValueFor("damage")
	self.radius              = self:GetAbility():GetSpecialValueFor("radius")
	self.universal_movespeed = self:GetAbility():GetSpecialValueFor("universal_movespeed")

	if self:GetParent() ~= self:GetCaster() and self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		self.universal_movespeed = self.universal_movespeed * 2
	end

	self.damage_type = self:GetAbility():GetAbilityDamageType()

	local ring_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber())
	-- ParticleManager:SetParticleControlEnt(ring_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true) -- Doesn't seem like this works
	self:AddParticle(ring_particle, false, false, -1, false, false)

	-- self:GetParent():AddNoDraw()
end

function modifier_imba_outworld_devourer_astral_imprisonment_prison:OnIntervalThink()
	if self.movement_position and self:GetAbility() then
		if self:GetParent():GetAbsOrigin() ~= self.movement_position then
			self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin() + ((self.movement_position - self:GetParent():GetAbsOrigin()):Normalized() * math.min(FrameTime() * self.universal_movespeed, (self.movement_position - self:GetParent():GetAbsOrigin()):Length2D())))
			-- self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin() + ((self.movement_position - self:GetParent():GetAbsOrigin()):Normalized()))
		else
			self.movement_position = nil
			self:StartIntervalThink(-1)
		end
	else
		self:StartIntervalThink(-1)
	end
end

-- Astral Imprisonment fully disables the target and turns it invulnerable and hidden for its duration.
function modifier_imba_outworld_devourer_astral_imprisonment_prison:CheckState()
	if self:GetParent() ~= self:GetCaster() then
		return {
			[MODIFIER_STATE_STUNNED]       = true,
			[MODIFIER_STATE_INVULNERABLE]  = true,
			[MODIFIER_STATE_OUT_OF_GAME]   = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		}
	else
		return {
			[MODIFIER_STATE_MUTED]         = true,
			[MODIFIER_STATE_ROOTED]        = true,
			[MODIFIER_STATE_DISARMED]      = true,
			[MODIFIER_STATE_INVULNERABLE]  = true,
			[MODIFIER_STATE_OUT_OF_GAME]   = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		}
	end
end

function modifier_imba_outworld_devourer_astral_imprisonment_prison:OnDestroy()
	if not IsServer() then return end

	-- self:GetParent():RemoveNoDraw()
	self:GetParent():StopSound("Hero_ObsidianDestroyer.AstralImprisonment")
	self:GetParent():EmitSound("Hero_ObsidianDestroyer.AstralImprisonment.End")

	local end_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_end_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(end_particle, 1, Vector(self.radius, self.radius, self.radius))
	ParticleManager:ReleaseParticleIndex(end_particle)

	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		ApplyDamage({
			victim       = enemy,
			damage       = self.damage,
			damage_type  = self.damage_type,
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self:GetCaster(),
			ability      = self:GetAbility()
		})

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, self.damage, nil)
	end
end

-----------------------------------------
-- IMBA_OUTWORLD_DEVOURER_ESSENCE_FLUX --
-----------------------------------------

function imba_outworld_devourer_essence_flux:GetIntrinsicModifierName()
	return "modifier_imba_outworld_devourer_essence_flux"
end

function imba_outworld_devourer_essence_flux:OnSpellStart()
	self:GetCaster():EmitSound("Hero_ObsidianDestroyer.Equilibrium.Cast")

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_outworld_devourer_essence_flux_active", { duration = self:GetSpecialValueFor("duration") })
end

--------------------------------------------------
-- MODIFIER_IMBA_OUTWORLD_DEVOURER_ESSENCE_FLUX --
--------------------------------------------------

function modifier_imba_outworld_devourer_essence_flux:IsHidden() return true end

function modifier_imba_outworld_devourer_essence_flux:IsPurgable() return false end

function modifier_imba_outworld_devourer_essence_flux:RemoveOnDeath() return false end

function modifier_imba_outworld_devourer_essence_flux:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ABILITY_FULLY_CAST }
end

function modifier_imba_outworld_devourer_essence_flux:OnAbilityFullyCast(keys)
	if keys.unit == self:GetParent() and not keys.ability:IsToggle() and not keys.ability:IsItem() and not keys.ability:GetName() == "imba_outworld_devourer_astral_imprisonment_movement" and self:GetParent().GetMaxMana then
		self:RollForProc()
	end
end

-- Custom function for the mana gain since Arcane Orb (which is not a traditionally castable ability) can proc this as well
function modifier_imba_outworld_devourer_essence_flux:RollForProc()
	if RollPseudoRandom(self:GetAbility():GetSpecialValueFor("proc_chance"), self) then
		self.proc_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.proc_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(self.proc_particle)

		self:GetParent():GiveMana(self:GetParent():GetMaxMana() * self:GetAbility():GetSpecialValueFor("mana_restore") / 100)
	end
end

---------------------------------------------------------
-- MODIFIER_IMBA_OUTWORLD_DEVOURER_ESSENCE_FLUX_ACTIVE --
---------------------------------------------------------

function modifier_imba_outworld_devourer_essence_flux_active:GetEffectName()
	return "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_matter_buff.vpcf"
end

function modifier_imba_outworld_devourer_essence_flux_active:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_outworld_devourer_essence_flux_active:GetStatusEffectName()
	return "particles/status_fx/status_effect_obsidian_matter.vpcf"
end

function modifier_imba_outworld_devourer_essence_flux_active:OnCreated()
	-- AbilitySpecials
	-- self.mana_steal			= self:GetAbility():GetSpecialValueFor("mana_steal")
	self.mana_steal_active    = self:GetAbility():GetSpecialValueFor("mana_steal_active")
	self.movement_slow        = self:GetAbility():GetSpecialValueFor("movement_slow")
	self.slow_duration        = self:GetAbility():GetSpecialValueFor("slow_duration")
	self.duration             = self:GetAbility():GetSpecialValueFor("duration")
	self.equal_atk_speed_diff = self:GetAbility():GetSpecialValueFor("equal_atk_speed_diff")
end

function modifier_imba_outworld_devourer_essence_flux_active:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_imba_outworld_devourer_essence_flux_active:GetModifierAttackSpeedBonus_Constant()
	return self.equal_atk_speed_diff * self:GetStackCount()
end

--- Enum DamageCategory_t
-- DOTA_DAMAGE_CATEGORY_ATTACK = 1
-- DOTA_DAMAGE_CATEGORY_SPELL = 0
function modifier_imba_outworld_devourer_essence_flux_active:OnTakeDamage(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetCaster() then --and keys.damage_category == 0 then
		keys.unit:EmitSound("Hero_ObsidianDestroyer.Equilibrium.Damage")

		keys.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_outworld_devourer_essence_flux_debuff", { duration = self.slow_duration * (1 - keys.unit:GetStatusResistance()) })

		self:IncrementStackCount()
	end
end

------------------------------------------------------
-- MODIFIER_IMBA_OUTWORLD_DEVOURER_ESSENCE_FLUX_DEBUFF --
------------------------------------------------------

function modifier_imba_outworld_devourer_essence_flux_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_obsidian_matter_debuff.vpcf"
end

function modifier_imba_outworld_devourer_essence_flux_debuff:OnCreated()
	self.movement_slow        = self:GetAbility():GetTalentSpecialValueFor("movement_slow") * (-1)
	self.slow_duration        = self:GetAbility():GetSpecialValueFor("slow_duration")
	self.equal_atk_speed_diff = self:GetAbility():GetSpecialValueFor("equal_atk_speed_diff") * (-1)

	if not IsServer() then return end

	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_matter_debuff.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle, 2, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_imba_outworld_devourer_essence_flux_debuff:OnRefresh()
	if not IsServer() then return end

	self:SetDuration(self.slow_duration * (1 - self:GetParent():GetStatusResistance()), true)

	self:IncrementStackCount()
end

function modifier_imba_outworld_devourer_essence_flux_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_imba_outworld_devourer_essence_flux_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow
end

function modifier_imba_outworld_devourer_essence_flux_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.equal_atk_speed_diff * self:GetStackCount()
end

---------------------------------------------------------
-- IMBA_OUTWORLD_DEVOURER_ASTRAL_IMPRISONMENT_MOVEMENT --
---------------------------------------------------------

function imba_outworld_devourer_astral_imprisonment_movement:IsInnateAbility() return true end

function imba_outworld_devourer_astral_imprisonment_movement:IsStealable() return false end

function imba_outworld_devourer_astral_imprisonment_movement:CastFilterResultLocation(location)
	if self:GetCaster():HasModifier("modifier_imba_outworld_devourer_astral_imprisonment_movement") then
		return UF_SUCCESS
	else
		return UF_FAIL_CUSTOM
	end
end

function imba_outworld_devourer_astral_imprisonment_movement:GetCustomCastErrorLocation(location)
	if not self:GetCaster():HasModifier("modifier_imba_outworld_devourer_astral_imprisonment_movement") then
		return "#dota_hud_error_no_astral_imprisonments_active"
	end
end

function imba_outworld_devourer_astral_imprisonment_movement:OnSpellStart()
	for _, astral_mod in pairs(self:GetCaster():FindAllModifiersByName("modifier_imba_outworld_devourer_astral_imprisonment_movement")) do
		if astral_mod:GetCaster():HasModifier("modifier_imba_outworld_devourer_astral_imprisonment_prison") then
			local prison_modifier = astral_mod:GetCaster():FindModifierByName("modifier_imba_outworld_devourer_astral_imprisonment_prison")

			prison_modifier.movement_position = self:GetCursorPosition()
			prison_modifier:OnIntervalThink()
			prison_modifier:StartIntervalThink(FrameTime())
		end
	end
end

------------------------------------------------------------------
-- MODIFIER_IMBA_OUTWORLD_DEVOURER_ASTRAL_IMPRISONMENT_MOVEMENT --
------------------------------------------------------------------

function modifier_imba_outworld_devourer_astral_imprisonment_movement:IsDebuff() return false end

function modifier_imba_outworld_devourer_astral_imprisonment_movement:IsPurgable() return false end

function modifier_imba_outworld_devourer_astral_imprisonment_movement:IsHidden() return true end

function modifier_imba_outworld_devourer_astral_imprisonment_movement:RemoveOnDeath() return false end

function modifier_imba_outworld_devourer_astral_imprisonment_movement:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-------------------------------------------
-- IMBA_OUTWORLD_DEVOURER_SANITY_ECLIPSE --
-------------------------------------------

function imba_outworld_devourer_sanity_eclipse:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_outworld_devourer_sanity_eclipse:OnSpellStart()
	self:GetCaster():EmitSound("Hero_ObsidianDestroyer.SanityEclipse.Cast")

	EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "Hero_ObsidianDestroyer.SanityEclipse", self:GetCaster())

	self.eclipse_cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_area.vpcf", PATTACH_POINT, self:GetCaster())
	ParticleManager:SetParticleControl(self.eclipse_cast_particle, 0, self:GetCursorPosition())
	ParticleManager:SetParticleControl(self.eclipse_cast_particle, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), 1))
	ParticleManager:SetParticleControl(self.eclipse_cast_particle, 2, Vector(1, 1, self:GetSpecialValueFor("radius")))
	ParticleManager:ReleaseParticleIndex(self.eclipse_cast_particle)

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)) do
		if ((not enemy:IsInvulnerable() and not enemy:IsOutOfGame()) or enemy:HasModifier("modifier_imba_outworld_devourer_astral_imprisonment_prison")) and enemy.GetMaxMana then
			self.eclipse_damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:ReleaseParticleIndex(self.eclipse_damage_particle)

			if not enemy:IsIllusion() and (not enemy.Custom_IsStrongIllusion or (enemy.Custom_IsStrongIllusion and enemy:Custom_IsStrongIllusion())) then
				ApplyDamage({
					victim       = enemy,
					damage       = self:GetSpecialValueFor("base_damage") + ((self:GetCaster():GetMaxMana() - enemy:GetMaxMana()) * self:GetTalentSpecialValueFor("damage_multiplier")),
					damage_type  = self:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY,
					attacker     = self:GetCaster(),
					ability      = self
				})
			elseif enemy:IsIllusion() and (not enemy.Custom_IsStrongIllusion or (enemy.Custom_IsStrongIllusion and not enemy:Custom_IsStrongIllusion())) then
				-- IMBAfication: Occam's Bazooka
				enemy:Kill(self, self:GetCaster())
			end

			-- IMBAfication: Remnants of Sanity's Eclipse
			if enemy:IsAlive() and enemy.GetMaxMana then
				self.eclipse_mana_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_mana_loss.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:ReleaseParticleIndex(self.eclipse_mana_particle)

				enemy:ReduceMana(enemy:GetMaxMana() * self:GetSpecialValueFor("max_mana_burn_pct") / 100)
			end
		end
	end
end

-----------------------------------------------------------
-- MODIFIER_IMBA_OUTWORLD_DEVOURER_SANITY_ECLIPSE_CHARGE --
-----------------------------------------------------------

function modifier_imba_outworld_devourer_sanity_eclipse_charge:OnCreated(keys)
	if keys and keys.charges then
		self:SetStackCount(self:GetStackCount() + keys.charges)
	end

	self.stack_mana = self:GetAbility():GetSpecialValueFor("stack_mana")

	if not IsServer() then return end

	self:GetParent():CalculateStatBonus(true)
end

function modifier_imba_outworld_devourer_sanity_eclipse_charge:OnRefresh(keys)
	self:OnCreated(keys)
end

function modifier_imba_outworld_devourer_sanity_eclipse_charge:DeclareFunctions()
	return { MODIFIER_PROPERTY_MANA_BONUS }
end

function modifier_imba_outworld_devourer_sanity_eclipse_charge:GetModifierManaBonus()
	return self:GetStackCount() * self.stack_mana
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_outworld_devourer_sanity_eclipse_multiplier", "components/abilities/heroes/hero_outworld_devourer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_outworld_devourer_arcane_orb_damage", "components/abilities/heroes/hero_outworld_devourer", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_outworld_devourer_sanity_eclipse_multiplier = modifier_special_bonus_imba_outworld_devourer_sanity_eclipse_multiplier or class({})
modifier_special_bonus_imba_outworld_devourer_arcane_orb_damage         = modifier_special_bonus_imba_outworld_devourer_arcane_orb_damage or class({})

function modifier_special_bonus_imba_outworld_devourer_sanity_eclipse_multiplier:IsHidden() return true end

function modifier_special_bonus_imba_outworld_devourer_sanity_eclipse_multiplier:IsPurgable() return false end

function modifier_special_bonus_imba_outworld_devourer_sanity_eclipse_multiplier:RemoveOnDeath() return false end

function modifier_special_bonus_imba_outworld_devourer_arcane_orb_damage:IsHidden() return true end

function modifier_special_bonus_imba_outworld_devourer_arcane_orb_damage:IsPurgable() return false end

function modifier_special_bonus_imba_outworld_devourer_arcane_orb_damage:RemoveOnDeath() return false end
