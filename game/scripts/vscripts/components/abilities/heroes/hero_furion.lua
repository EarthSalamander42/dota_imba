-- Editors:
--    AltiV, January 17th, 2020

LinkLuaModifier("modifier_imba_furion_wrath_of_nature", "components/abilities/heroes/hero_furion", LUA_MODIFIER_MOTION_NONE)      -- This is used as intrinsic modifier for variant / IMBAfication
LinkLuaModifier("modifier_imba_furion_wrath_of_nature_aura", "components/abilities/heroes/hero_furion", LUA_MODIFIER_MOTION_NONE) -- As is this
LinkLuaModifier("modifier_imba_furion_wrath_of_nature_thinker", "components/abilities/heroes/hero_furion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_furion_wrath_of_nature_spawn", "components/abilities/heroes/hero_furion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_furion_wrath_of_nature_damage_stack", "components/abilities/heroes/hero_furion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_furion_wrath_of_nature_damage_counter", "components/abilities/heroes/hero_furion", LUA_MODIFIER_MOTION_NONE)

imba_furion_wrath_of_nature                         = imba_furion_wrath_of_nature_spawn or class({})
modifier_imba_furion_wrath_of_nature                = modifier_imba_furion_wrath_of_nature or class({})
modifier_imba_furion_wrath_of_nature_aura           = modifier_imba_furion_wrath_of_nature_aura or class({})
modifier_imba_furion_wrath_of_nature_thinker        = modifier_imba_furion_wrath_of_nature_thinker or class({})
modifier_imba_furion_wrath_of_nature_spawn          = modifier_imba_furion_wrath_of_nature_spawn or class({})
modifier_imba_furion_wrath_of_nature_damage_stack   = modifier_imba_furion_wrath_of_nature_damage_stack or class({})
modifier_imba_furion_wrath_of_nature_damage_counter = modifier_imba_furion_wrath_of_nature_damage_counter or class({})

---------------------------------
-- IMBA_FURION_WRATH_OF_NATURE --
---------------------------------

function imba_furion_wrath_of_nature:GetIntrinsicModifierName()
	return "modifier_imba_furion_wrath_of_nature"
end

function imba_furion_wrath_of_nature:OnAbilityPhaseStart()
	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_wrath_of_nature_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(cast_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)

	return true
end

function imba_furion_wrath_of_nature:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Furion.WrathOfNature_Cast.Self")
	EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "Hero_Furion.WrathOfNature_Cast", self:GetCaster())

	-- Going to use a thinker to keep track of the bounced targets and general logic
	CreateModifierThinker(self:GetCaster(), self, "modifier_imba_furion_wrath_of_nature_thinker", {}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
end

------------------------------------------
-- MODIFIER_IMBA_FURION_WRATH_OF_NATURE --
------------------------------------------

function modifier_imba_furion_wrath_of_nature:IsHidden() return not self:GetCaster():HasScepter() and not self:GetCaster():HasTalent("special_bonus_imba_furion_wrath_of_nature_boost") end

function modifier_imba_furion_wrath_of_nature:IsPurgable() return false end

function modifier_imba_furion_wrath_of_nature:RemoveOnDeath() return false end

function modifier_imba_furion_wrath_of_nature:IsAura() return true end

function modifier_imba_furion_wrath_of_nature:IsAuraActiveOnDeath() return false end

function modifier_imba_furion_wrath_of_nature:GetAuraRadius() return FIND_UNITS_EVERYWHERE end

function modifier_imba_furion_wrath_of_nature:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end

function modifier_imba_furion_wrath_of_nature:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_imba_furion_wrath_of_nature:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC end

function modifier_imba_furion_wrath_of_nature:GetModifierAura() return "modifier_imba_furion_wrath_of_nature_aura" end

-- Normally I would use GetName() here (or maybe just directly apply the bonus damage onto the proper units) but Name/Classname/Debugname are all "npc_dota_creep" so I'll check with weird model filtering
function modifier_imba_furion_wrath_of_nature:GetAuraEntityReject(hTarget) return (not self:GetCaster():HasScepter() and not self:GetCaster():HasTalent("special_bonus_imba_furion_wrath_of_nature_boost")) or not self:GetAbility():IsTrained() or self:GetParent() ~= hTarget:GetOwner() or not string.find(hTarget:GetModelName(), "furion") or not string.find(hTarget:GetModelName(), "treant") end

-----------------------------------------------
-- MODIFIER_IMBA_FURION_WRATH_OF_NATURE_AURA --
-----------------------------------------------

function modifier_imba_furion_wrath_of_nature_aura:OnCreated()
	self.treant_damage_per_stack = self:GetAbility():GetSpecialValueFor("treant_damage_per_stack")
	self.treant_health_per_stack = self:GetAbility():GetSpecialValueFor("treant_health_per_stack")

	if not IsServer() then return end

	if self:GetCaster():HasModifier("modifier_imba_furion_wrath_of_nature") then
		self:SetStackCount(self:GetCaster():FindModifierByName("modifier_imba_furion_wrath_of_nature"):GetStackCount())
	end
end

function modifier_imba_furion_wrath_of_nature_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS
	}
end

function modifier_imba_furion_wrath_of_nature_aura:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount() * self.treant_damage_per_stack
end

function modifier_imba_furion_wrath_of_nature_aura:GetModifierExtraHealthBonus()
	return self:GetStackCount() * self.treant_health_per_stack
end

function modifier_imba_furion_wrath_of_nature_aura:GetModifierHealthBonus()
	return self:GetStackCount() * self.treant_health_per_stack
end

--------------------------------------------------
-- MODIFIER_IMBA_FURION_WRATH_OF_NATURE_THINKER --
--------------------------------------------------

function modifier_imba_furion_wrath_of_nature_thinker:IsHidden() return true end

function modifier_imba_furion_wrath_of_nature_thinker:IsPurgable() return false end

function modifier_imba_furion_wrath_of_nature_thinker:RemoveOnDeath() return false end

function modifier_imba_furion_wrath_of_nature_thinker:OnCreated()
	self.max_targets                       = self:GetAbility():GetSpecialValueFor("max_targets")
	self.damage                            = self:GetAbility():GetSpecialValueFor("damage")
	self.damage_percent_add                = self:GetAbility():GetSpecialValueFor("damage_percent_add")
	self.jump_delay                        = self:GetAbility():GetSpecialValueFor("jump_delay")
	self.kill_damage                       = self:GetAbility():GetSpecialValueFor("kill_damage")
	self.kill_damage_duration              = self:GetAbility():GetSpecialValueFor("kill_damage_duration")
	self.damage_scepter                    = self:GetAbility():GetSpecialValueFor("damage_scepter")
	self.scepter_buffer                    = self:GetAbility():GetSpecialValueFor("scepter_buffer")
	self.treant_large_hp_bonus_tooltip     = self:GetAbility():GetSpecialValueFor("treant_large_hp_bonus_tooltip")
	self.treant_large_damage_bonus_tooltip = self:GetAbility():GetSpecialValueFor("treant_large_damage_bonus_tooltip")
	self.treant_bonus_damage               = self:GetAbility():GetSpecialValueFor("treant_bonus_damage")
	self.treant_bonus_damage_hero          = self:GetAbility():GetSpecialValueFor("treant_bonus_damage_hero")

	if not IsServer() then return end

	self.damage_type = self:GetAbility():GetAbilityDamageType()
	self.hit_enemies = {}
	self.counter     = 0
	self.position    = self:GetParent():GetAbsOrigin()
	self.target      = self:GetParent()

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.position, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)) do
		-- First enemy that is directly targeted will trigger spell absorb if applicable
		if not self:GetAbility():GetCursorTarget() or enemy == self:GetAbility():GetCursorTarget() and not self:GetAbility():GetCursorTarget():TriggerSpellAbsorb(self:GetAbility()) then
			self.counter        = self.counter + 1

			-- This particle is kinda complicated...
			-- This is 100% wrong but IDK the exact CPs to use
			self.wrath_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_wrath_of_nature.vpcf", PATTACH_POINT_FOLLOW, enemy)
			ParticleManager:SetParticleControl(self.wrath_particle, 0, enemy:GetAbsOrigin() + ((self.position - enemy:GetAbsOrigin()):Normalized() * 200))
			ParticleManager:SetParticleControlEnt(self.wrath_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.wrath_particle, 2, enemy:GetAbsOrigin() + ((self.position - enemy:GetAbsOrigin()):Normalized() * 200))
			ParticleManager:SetParticleControlEnt(self.wrath_particle, 3, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.wrath_particle, 4, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(self.wrath_particle)

			self.position = enemy:GetAbsOrigin()

			if enemy:IsCreep() then
				enemy:EmitSound("Hero_Furion.WrathOfNature_Damage.Creep")
			else
				enemy:EmitSound("Hero_Furion.WrathOfNature_Damage")
			end

			if self:GetCaster():HasScepter() or self:GetCaster():HasTalent("special_bonus_imba_furion_wrath_of_nature_boost") then
				enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_furion_wrath_of_nature_spawn", {
					duration                 = self.scepter_buffer * (1 - enemy:GetStatusResistance()),
					treant_bonus_damage      = self.treant_bonus_damage,
					treant_bonus_damage_hero = self.treant_bonus_damage_hero
				})
			end

			if self:GetCaster():HasScepter() then
				ApplyDamage({
					victim       = enemy,
					damage       = self.damage_scepter * ((1 + (self.damage_percent_add / 100)) ^ self.counter),
					damage_type  = self.damage_type,
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					attacker     = self:GetCaster(),
					ability      = self:GetAbility()
				})
			else
				ApplyDamage({
					victim       = enemy,
					damage       = self.damage * ((1 + (self.damage_percent_add / 100)) ^ self.counter),
					damage_type  = self.damage_type,
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					attacker     = self:GetCaster(),
					ability      = self:GetAbility()
				})
			end

			self.hit_enemies[enemy:entindex()] = true
		end

		break
	end

	self:StartIntervalThink(self.jump_delay)
end

function modifier_imba_furion_wrath_of_nature_thinker:OnIntervalThink()
	self.bFoundTarget = false

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.position, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)) do
		-- First enemy that is directly targeted will trigger spell absorb if applicable
		if not self.hit_enemies[enemy:entindex()] then
			self.bFoundTarget   = true
			self.counter        = self.counter + 1

			self.wrath_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_wrath_of_nature.vpcf", PATTACH_POINT_FOLLOW, enemy)
			ParticleManager:SetParticleControl(self.wrath_particle, 0, enemy:GetAbsOrigin() + ((self.position - enemy:GetAbsOrigin()):Normalized() * 200))
			ParticleManager:SetParticleControlEnt(self.wrath_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.wrath_particle, 2, enemy:GetAbsOrigin() + ((self.position - enemy:GetAbsOrigin()):Normalized() * 200))
			ParticleManager:SetParticleControlEnt(self.wrath_particle, 3, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.wrath_particle, 4, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(self.wrath_particle)

			self.position = enemy:GetAbsOrigin()

			if enemy:IsCreep() then
				enemy:EmitSound("Hero_Furion.WrathOfNature_Damage.Creep")
			else
				enemy:EmitSound("Hero_Furion.WrathOfNature_Damage")
			end

			if self:GetCaster():HasScepter() or self:GetCaster():HasTalent("special_bonus_imba_furion_wrath_of_nature_boost") then
				enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_furion_wrath_of_nature_spawn", {
					duration                 = self.scepter_buffer * (1 - enemy:GetStatusResistance()),
					treant_bonus_damage      = self.treant_bonus_damage,
					treant_bonus_damage_hero = self.treant_bonus_damage_hero
				})
			end

			if self:GetCaster():HasScepter() then
				ApplyDamage({
					victim       = enemy,
					damage       = self.damage_scepter * ((1 + (self.damage_percent_add / 100)) ^ self.counter),
					damage_type  = self.damage_type,
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					attacker     = self:GetCaster(),
					ability      = self:GetAbility()
				})
			else
				ApplyDamage({
					victim       = enemy,
					damage       = self.damage * ((1 + (self.damage_percent_add / 100)) ^ self.counter),
					damage_type  = self.damage_type,
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					attacker     = self:GetCaster(),
					ability      = self:GetAbility()
				})
			end

			self.hit_enemies[enemy:entindex()] = true

			if not enemy:IsAlive() then
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_furion_wrath_of_nature_damage_counter", { duration = self.kill_damage_duration })
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_furion_wrath_of_nature_damage_stack", {
					duration = self.kill_damage_duration,
					kill_damage = self.kill_damage
				})
			end

			break
		end
	end

	-- No more valid targets
	if not self.bFoundTarget or self.counter >= self.max_targets then
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end

------------------------------------------------
-- MODIFIER_IMBA_FURION_WRATH_OF_NATURE_SPAWN --
------------------------------------------------

function modifier_imba_furion_wrath_of_nature_spawn:RemoveOnDeath() return false end

function modifier_imba_furion_wrath_of_nature_spawn:OnCreated(keys)
	if not IsServer() then return end

	self.treant_bonus_damage      = keys.treant_bonus_damage
	self.treant_bonus_damage_hero = keys.treant_bonus_damage_hero
end

function modifier_imba_furion_wrath_of_nature_spawn:OnRefresh(keys)
	self:OnCreated(keys)
end

function modifier_imba_furion_wrath_of_nature_spawn:DeclareFunctions()
	return { MODIFIER_EVENT_ON_DEATH }
end

function modifier_imba_furion_wrath_of_nature_spawn:OnDeath(keys)
	if keys.unit == self:GetParent() and (not self:GetParent().IsReincarnating or not self:GetParent():IsReincarnating()) then
		if self:GetCaster():HasModifier("modifier_imba_furion_wrath_of_nature") then
			if self:GetCaster():HasScepter() then
				if (self:GetParent():IsRealHero() or self:GetParent():IsClone()) and self.treant_bonus_damage_hero then
					self:GetCaster():FindModifierByName("modifier_imba_furion_wrath_of_nature"):SetStackCount(self:GetCaster():FindModifierByName("modifier_imba_furion_wrath_of_nature"):GetStackCount() + self.treant_bonus_damage_hero)
				elseif self.treant_bonus_damage then
					self:GetCaster():FindModifierByName("modifier_imba_furion_wrath_of_nature"):SetStackCount(self:GetCaster():FindModifierByName("modifier_imba_furion_wrath_of_nature"):GetStackCount() + self.treant_bonus_damage)
				end
			end

			if self:GetCaster():HasTalent("special_bonus_imba_furion_wrath_of_nature_boost") then
				self:GetCaster():FindModifierByName("modifier_imba_furion_wrath_of_nature"):SetStackCount(self:GetCaster():FindModifierByName("modifier_imba_furion_wrath_of_nature"):GetStackCount() + self:GetCaster():FindTalentValue("special_bonus_imba_furion_wrath_of_nature_boost"))
			end

			self:Destroy()
		end
	end
end

-------------------------------------------------------
-- MODIFIER_IMBA_FURION_WRATH_OF_NATURE_DAMAGE_STACK --
-------------------------------------------------------

function modifier_imba_furion_wrath_of_nature_damage_stack:IsHidden() return true end

function modifier_imba_furion_wrath_of_nature_damage_stack:IsPurgable() return false end

function modifier_imba_furion_wrath_of_nature_damage_stack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_furion_wrath_of_nature_damage_stack:OnCreated(keys)
	if not IsServer() then return end

	if self:GetParent():HasModifier("modifier_imba_furion_wrath_of_nature_damage_counter") then
		self:SetStackCount(keys.kill_damage)

		self:GetParent():FindModifierByName("modifier_imba_furion_wrath_of_nature_damage_counter"):SetStackCount(self:GetParent():FindModifierByName("modifier_imba_furion_wrath_of_nature_damage_counter"):GetStackCount() + self:GetStackCount())
	end
end

function modifier_imba_furion_wrath_of_nature_damage_stack:OnDestroy()
	if not IsServer() then return end

	if self:GetParent():HasModifier("modifier_imba_furion_wrath_of_nature_damage_counter") then
		self:GetParent():FindModifierByName("modifier_imba_furion_wrath_of_nature_damage_counter"):SetStackCount(self:GetParent():FindModifierByName("modifier_imba_furion_wrath_of_nature_damage_counter"):GetStackCount() - self:GetStackCount())
	end
end

---------------------------------------------------------
-- MODIFIER_IMBA_FURION_WRATH_OF_NATURE_DAMAGE_COUNTER --
---------------------------------------------------------

function modifier_imba_furion_wrath_of_nature_damage_counter:IsPurgable() return false end

function modifier_imba_furion_wrath_of_nature_damage_counter:DeclareFunctions()
	return { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }
end

function modifier_imba_furion_wrath_of_nature_damage_counter:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_furion_wrath_of_nature_boost", "components/abilities/heroes/hero_furion", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_furion_wrath_of_nature_boost = modifier_special_bonus_imba_furion_wrath_of_nature_boost or class({})

function modifier_special_bonus_imba_furion_wrath_of_nature_boost:IsHidden() return true end

function modifier_special_bonus_imba_furion_wrath_of_nature_boost:IsPurgable() return false end

function modifier_special_bonus_imba_furion_wrath_of_nature_boost:RemoveOnDeath() return false end

function imba_furion_wrath_of_nature:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_furion_wrath_of_nature_boost") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_furion_wrath_of_nature_boost") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_furion_wrath_of_nature_boost"), "modifier_special_bonus_imba_furion_wrath_of_nature_boost", {})
	end
end
