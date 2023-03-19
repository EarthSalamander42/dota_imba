-- Creator:
--	   AltiV, February 12th, 2020

LinkLuaModifier("modifier_imba_void_spirit_aether_remnant_pull", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_void_spirit_aether_remnant_target_vision", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_void_spirit_dissimilate", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_void_spirit_dissimilate_ally", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_void_spirit_resonant_pulse_ring", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_void_spirit_resonant_pulse_physical_buff", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_void_spirit_resonant_pulse_thinker_aura", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_void_spirit_resonant_pulse_thinker_buff", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_void_spirit_resonant_pulse_equal_exchange", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_void_spirit_astral_step_grace_time", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_void_spirit_astral_step_armor_pierce", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_void_spirit_aether_remnant_helper", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_void_spirit_aether_remnant_helper_buff", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_void_spirit_void_stasis", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_void_spirit_astral_step_debuff", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_void_spirit_astral_step_crit", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_void_spirit_astral_step_invis", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_generic_charges", "components/modifiers/generic/modifier_generic_charges", LUA_MODIFIER_MOTION_NONE)

imba_void_spirit_aether_remnant                         = imba_void_spirit_aether_remnant or class({})
modifier_imba_void_spirit_aether_remnant_pull           = modifier_imba_void_spirit_aether_remnant_pull or class({})
modifier_imba_void_spirit_aether_remnant_target_vision  = modifier_imba_void_spirit_aether_remnant_target_vision or class({})

imba_void_spirit_dissimilate                            = imba_void_spirit_dissimilate or class({})
modifier_imba_void_spirit_dissimilate                   = modifier_imba_void_spirit_dissimilate or class({})
modifier_imba_void_spirit_dissimilate_ally              = modifier_imba_void_spirit_dissimilate_ally or class({})

imba_void_spirit_resonant_pulse                         = imba_void_spirit_resonant_pulse or class({})
modifier_imba_void_spirit_resonant_pulse_ring           = modifier_imba_void_spirit_resonant_pulse_ring or class({})
modifier_imba_void_spirit_resonant_pulse_physical_buff  = modifier_imba_void_spirit_resonant_pulse_physical_buff or class({})
modifier_imba_void_spirit_resonant_pulse_thinker_aura   = modifier_imba_void_spirit_resonant_pulse_thinker_aura or class({})
modifier_imba_void_spirit_resonant_pulse_thinker_buff   = modifier_imba_void_spirit_resonant_pulse_thinker_buff or class({})
modifier_imba_void_spirit_resonant_pulse_equal_exchange = modifier_imba_void_spirit_resonant_pulse_equal_exchange or class({})

imba_void_spirit_astral_step_helper                     = imba_void_spirit_astral_step_helper or class({})
modifier_imba_void_spirit_astral_step_grace_time        = modifier_imba_void_spirit_astral_step_grace_time or class({})

imba_void_spirit_astral_step_helper_2                   = imba_void_spirit_astral_step_helper_2 or class({})
modifier_imba_void_spirit_astral_step_armor_pierce      = modifier_imba_void_spirit_astral_step_armor_pierce or class({})

imba_void_spirit_aether_remnant_helper                  = imba_void_spirit_aether_remnant_helper or class({})
modifier_imba_void_spirit_aether_remnant_helper         = modifier_imba_void_spirit_aether_remnant_helper or class({})
modifier_imba_void_spirit_aether_remnant_helper_buff    = modifier_imba_void_spirit_aether_remnant_helper_buff or class({})

imba_void_spirit_void_stasis                            = imba_void_spirit_void_stasis or class({})
modifier_imba_void_spirit_void_stasis                   = modifier_imba_void_spirit_void_stasis or class({})

imba_void_spirit_astral_step                            = imba_void_spirit_astral_step or class({})
modifier_imba_void_spirit_astral_step_debuff            = modifier_imba_void_spirit_astral_step_debuff or class({})
modifier_imba_void_spirit_astral_step_crit              = modifier_imba_void_spirit_astral_step_crit or class({})
modifier_imba_void_spirit_astral_step_invis             = modifier_imba_void_spirit_astral_step_invis or class({})

-------------------------------------
-- IMBA_VOID_SPIRIT_AETHER_REMNANT --
-------------------------------------

function imba_void_spirit_aether_remnant:OnSpellStart()

end

---------------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_AETHER_REMNANT_PULL --
---------------------------------------------------

function modifier_imba_void_spirit_aether_remnant_pull:OnCreated()

end

---------------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_AETHER_REMNANT_PULL --
---------------------------------------------------

function modifier_imba_void_spirit_aether_remnant_target_vision:CheckState()
	return { [MODIFIER_STATE_INVISIBLE] = false }
end

function modifier_imba_void_spirit_aether_remnant_target_vision:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

----------------------------------
-- IMBA_VOID_SPIRIT_DISSIMILATE --
----------------------------------

function imba_void_spirit_dissimilate:GetCastRange(location, target)
	return (self:GetSpecialValueFor("damage_radius") * (100 + self:GetSpecialValueFor("scepter_size_increase_pct")) / 100) - self:GetCaster():GetCastRangeBonus()
end

function imba_void_spirit_dissimilate:OnSpellStart()
	if not IsServer() then return end

	self:GetCaster():EmitSound("Hero_VoidSpirit.Dissimilate.Cast")

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_void_spirit_dissimilate", { duration = self:GetSpecialValueFor("phase_duration") })

	if self:GetAutoCastState() then
		local cosmic_particle = nil

		local damage_radius = self:GetSpecialValueFor("damage_radius")

		-- if self:GetCaster():HasScepter() then
		-- damage_radius	= damage_radius * (100 + self:GetSpecialValueFor("scepter_size_increase_pct") / 100)
		-- end

		for _, ally in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("damage_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP, FIND_ANY_ORDER, false)) do
			if ally ~= self:GetCaster() then
				cosmic_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/void_spirit_cosmic_assault.vpcf", PATTACH_WORLDORIGIN, ally)
				ParticleManager:SetParticleControl(cosmic_particle, 0, ally:GetAbsOrigin())
				ParticleManager:SetParticleControl(cosmic_particle, 1, Vector(100, 0, 0))
				ParticleManager:ReleaseParticleIndex(cosmic_particle)

				ally:AddNewModifier(self:GetCaster(), self, "modifier_imba_void_spirit_dissimilate_ally", { duration = self:GetSpecialValueFor("phase_duration") })
			end
		end
	end
end

-------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_DISSIMILATE --
-------------------------------------------

function modifier_imba_void_spirit_dissimilate:IsHidden() return true end

function modifier_imba_void_spirit_dissimilate:IsPurgable() return false end

function modifier_imba_void_spirit_dissimilate:OnCreated()
	self.destination_fx_radius      = self:GetAbility():GetSpecialValueFor("destination_fx_radius") -- What is this even used for?
	self.portals_per_ring           = self:GetAbility():GetSpecialValueFor("portals_per_ring")
	self.angle_per_ring_portal      = self:GetAbility():GetSpecialValueFor("angle_per_ring_portal")
	-- The portal particles are actually smaller than 275 radius if you feed it 275 so I feel like there's some messed up stuff going on
	self.first_ring_distance_offset = self:GetAbility():GetSpecialValueFor("first_ring_distance_offset")
	self.damage_radius              = self:GetAbility():GetSpecialValueFor("damage_radius")
	self.scepter_size_increase_pct  = self:GetAbility():GetSpecialValueFor("scepter_size_increase_pct")

	-- Yeah IDK
	self.particle_offset            = 25

	-- if self:GetCaster():HasScepter() then
	-- self.first_ring_distance_offset	= self.first_ring_distance_offset * (100 + self.scepter_size_increase_pct) / 100
	-- self.damage_radius 				= self.damage_radius * (100 + self.scepter_size_increase_pct) / 100
	-- self.particle_offset			= self.particle_offset * (100 + self.scepter_size_increase_pct) / 100
	-- end

	if not IsServer() then return end

	self.damage                  = self:GetAbility():GetAbilityDamage()
	self.damage_type             = self:GetAbility():GetAbilityDamageType()

	self.portal_selection_orders = {
		[DOTA_UNIT_ORDER_MOVE_TO_POSITION] = true,
		[DOTA_UNIT_ORDER_MOVE_TO_TARGET]   = true,
		[DOTA_UNIT_ORDER_ATTACK_MOVE]      = true,
		[DOTA_UNIT_ORDER_ATTACK_TARGET]    = true
	}

	-- Initialize portals
	self.portals                 = {}

	EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_VoidSpirit.Dissimilate.Portals", self:GetCaster())

	-- Create two sets of poratls; one for team and one for opposing team

	-- Center portal
	local portal = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate.vpcf", PATTACH_WORLDORIGIN, self:GetParent(), self:GetCaster():GetOpposingTeamNumber())
	ParticleManager:SetParticleControl(portal, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(portal, 1, Vector(self.damage_radius + self.particle_offset, 1, 1))
	self:AddParticle(portal, false, false, -1, false, false)

	portal = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate.vpcf", PATTACH_WORLDORIGIN, self:GetParent(), self:GetCaster():GetTeamNumber())
	ParticleManager:SetParticleControl(portal, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(portal, 1, Vector(self.damage_radius + self.particle_offset, 1, 1))
	ParticleManager:SetParticleControl(portal, 2, Vector(1, 0, 0))
	self:AddParticle(portal, false, false, -1, false, false)

	local portal_position = nil

	self.portals[portal] = self:GetCaster():GetAbsOrigin()

	-- Default to center portal if no orders are issued
	self.closest_particle = portal
	self.closest_position = self:GetCaster():GetAbsOrigin()

	-- Outer portals
	for outer_portals = 1, self.portals_per_ring do
		portal_position = GetGroundPosition(RotatePosition(self:GetCaster():GetAbsOrigin(), QAngle(0, self.angle_per_ring_portal * (outer_portals - 1), 0), self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * (self.first_ring_distance_offset))), nil)

		EmitSoundOnLocationWithCaster(portal_position, "Hero_VoidSpirit.Dissimilate.Portals", self:GetCaster())

		portal = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate.vpcf", PATTACH_WORLDORIGIN, self:GetParent(), self:GetCaster():GetOpposingTeamNumber())
		ParticleManager:SetParticleControl(portal, 0, portal_position)
		ParticleManager:SetParticleControl(portal, 1, Vector(self.damage_radius + self.particle_offset, 1, 1))
		self:AddParticle(portal, false, false, -1, false, false)

		portal = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate.vpcf", PATTACH_WORLDORIGIN, self:GetParent(), self:GetCaster():GetTeamNumber())
		ParticleManager:SetParticleControl(portal, 0, portal_position)
		ParticleManager:SetParticleControl(portal, 1, Vector(self.damage_radius + self.particle_offset, 1, 1))
		self:AddParticle(portal, false, false, -1, false, false)

		self.portals[portal] = portal_position
	end

	self:GetParent():AddNoDraw()
end

function modifier_imba_void_spirit_dissimilate:OnDestroy()
	if not IsServer() or not self:GetParent():IsAlive() then return end

	self:GetCaster():StopSound("Hero_VoidSpirit.Dissimilate.Portals")
	self:GetParent():EmitSound("Hero_VoidSpirit.Dissimilate.TeleportIn")

	local damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(damage_particle, 0, self.closest_position)
	ParticleManager:SetParticleControl(damage_particle, 1, Vector((self.damage_radius + self.particle_offset) / 2, 0, 1))
	ParticleManager:ReleaseParticleIndex(damage_particle)

	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3_END)

	FindClearSpaceForUnit(self:GetParent(), self.closest_position, false)
	self:GetParent():Interrupt()

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.closest_position, nil, self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		enemy:EmitSound("Hero_VoidSpirit.Dissimilate.Stun")

		ApplyDamage({
			victim       = enemy,
			damage       = self.damage,
			damage_type  = self.damage_type,
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self:GetCaster(),
			ability      = self:GetAbility()
		})

		-- "The level 25 talent also adds a stun to this. Applies the damage first, then the stun."
		if self:GetCaster():HasTalent("special_bonus_imba_void_spirit_dissimilate_stun") then
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self:GetCaster():FindTalentValue("special_bonus_imba_void_spirit_dissimilate_stun") * (1 - enemy:GetStatusResistance()) })
		end
	end

	self:GetParent():RemoveNoDraw()
end

-- "Fully disables, silences, mutes, and disarms Void Spirit, making him unable to do anything."
-- I think if you make him stunned then it won't properly register move orders, so let's not do that
function modifier_imba_void_spirit_dissimilate:CheckState()
	return {
		[MODIFIER_STATE_SILENCED]     = true,
		[MODIFIER_STATE_MUTED]        = true,
		[MODIFIER_STATE_DISARMED]     = true,
		[MODIFIER_STATE_ROOTED]       = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME]  = true
	}
end

function modifier_imba_void_spirit_dissimilate:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER
	}
end

-- Non-vanilla interaction; displays the "Can't Attack" error if you try to issue an attack command, whereas this doesn't appear for vanilla
function modifier_imba_void_spirit_dissimilate:OnOrder(keys)
	-- Don't check for orders that were issued before the buff was created, with some offset
	if keys.unit == self:GetParent() and self.portal_selection_orders[keys.order_type] and self.portals and GameRules:GetGameTime() >= self:GetCreationTime() + 0.11 then
		self.shortest_distance = nil
		self.closest_particle = nil
		self.closest_position = nil

		self.selected_pos = keys.new_pos

		if keys.target then
			self.selected_pos = keys.target:GetAbsOrigin()
		end

		for particle, position in pairs(self.portals) do
			ParticleManager:SetParticleControl(particle, 2, Vector(0, 0, 0))

			if not self.shortest_distance or (self.selected_pos - position):Length2D() < self.shortest_distance then
				self.shortest_distance = (self.selected_pos - position):Length2D()
				self.closest_particle = particle
				self.closest_position = position
			end
		end

		if self.closest_particle then
			ParticleManager:SetParticleControl(self.closest_particle, 2, Vector(1, 0, 0))
		end
	end
end

------------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_DISSIMILATE_ALLY --
------------------------------------------------

function modifier_imba_void_spirit_dissimilate_ally:IsPurgable() return false end

function modifier_imba_void_spirit_dissimilate_ally:OnCreated()
	if not IsServer() then return end

	self.closest_position          = self:GetParent():GetAbsOrigin()
	self.offset                    = self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()
	self.main_dissimilate_modifier = self:GetCaster():FindModifierByName("modifier_imba_void_spirit_dissimilate")

	self:GetParent():AddNoDraw()

	if not self.main_dissimilate_modifier then self:Destroy() end
end

function modifier_imba_void_spirit_dissimilate_ally:OnDestroy()
	if not IsServer() then return end

	FindClearSpaceForUnit(self:GetParent(), self.main_dissimilate_modifier.closest_position + self.offset, false)

	self:GetParent():RemoveNoDraw()
end

function modifier_imba_void_spirit_dissimilate_ally:CheckState()
	return {
		[MODIFIER_STATE_SILENCED]     = true,
		[MODIFIER_STATE_MUTED]        = true,
		[MODIFIER_STATE_DISARMED]     = true,
		[MODIFIER_STATE_ROOTED]       = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME]  = true
	}
end

-------------------------------------
-- IMBA_VOID_SPIRIT_RESONANT_PULSE --
-------------------------------------

function imba_void_spirit_resonant_pulse:RequiresScepterForCharges() return true end

function imba_void_spirit_resonant_pulse:GetCooldown(level)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCooldown(self, level)
	else
		return 0
	end
end

function imba_void_spirit_resonant_pulse:OnInventoryContentsChanged()
	-- Caster got scepter
	if self:GetCaster():HasScepter() then
		if self:GetCaster():HasModifier("modifier_generic_charges") then
			local has_rightful_modifier = false

			for _, mod in pairs(self:GetCaster():FindAllModifiersByName("modifier_generic_charges")) do
				if mod:GetAbility():GetAbilityName() == self:GetAbilityName() then
					has_rightful_modifier = true
					break
				end
			end

			if has_rightful_modifier == false then
				self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_charges", {})
			end
		else
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_charges", {})
		end
	end
end

function imba_void_spirit_resonant_pulse:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

function imba_void_spirit_resonant_pulse:OnSpellStart()
	if not IsServer() then return end

	self:GetCaster():EmitSound("Hero_VoidSpirit.Pulse.Cast")
	self:GetCaster():EmitSound("Hero_VoidSpirit.Pulse")

	local pulse_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(pulse_particle, 1, Vector(self:GetSpecialValueFor("speed"), 1, 0))
	ParticleManager:ReleaseParticleIndex(pulse_particle)

	self:GetCaster():RemoveModifierByName("modifier_imba_void_spirit_resonant_pulse_physical_buff")

	self.pulse_thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_void_spirit_resonant_pulse_thinker_aura", { duration = self:GetSpecialValueFor("buff_duration") }, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_void_spirit_resonant_pulse_ring", {
		duration         = self:GetSpecialValueFor("radius") / self:GetSpecialValueFor("speed"),
		thinker_entindex = self.pulse_thinker:entindex()
	})
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_void_spirit_resonant_pulse_physical_buff", { duration = self:GetSpecialValueFor("buff_duration") })
end

function imba_void_spirit_resonant_pulse:OnProjectileHit(target, location)
	if target then
		if target == self:GetCaster() then
			if target:HasModifier("modifier_imba_void_spirit_resonant_pulse_physical_buff") then
				target:FindModifierByName("modifier_imba_void_spirit_resonant_pulse_physical_buff"):SetStackCount(target:FindModifierByName("modifier_imba_void_spirit_resonant_pulse_physical_buff"):GetStackCount() + self:GetSpecialValueFor("absorb_per_hero_hit"))
			else
				target:AddNewModifier(self:GetCaster(), self, "modifier_imba_void_spirit_resonant_pulse_physical_buff", { duration = self:GetSpecialValueFor("buff_duration") })
			end
		else
			if target:HasModifier("modifier_imba_void_spirit_resonant_pulse_thinker_aura") then
				target:FindModifierByName("modifier_imba_void_spirit_resonant_pulse_thinker_aura"):SetStackCount(target:FindModifierByName("modifier_imba_void_spirit_resonant_pulse_thinker_aura"):GetStackCount() + self:GetSpecialValueFor("absorb_per_hero_hit"))
			end
		end
	end
end

---------------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_RESONANT_PULSE_RING --
---------------------------------------------------

function modifier_imba_void_spirit_resonant_pulse_ring:IsHidden() return true end

function modifier_imba_void_spirit_resonant_pulse_ring:IsPurgable() return false end

function modifier_imba_void_spirit_resonant_pulse_ring:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_void_spirit_resonant_pulse_ring:GetEffectName()
	return "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_buff.vpcf"
end

-- Do I just assume this ring has a thickness of 1 or something
-- I guess make it 50 to be reasonable
function modifier_imba_void_spirit_resonant_pulse_ring:OnCreated(keys)
	self.speed                    = self:GetAbility():GetSpecialValueFor("speed")
	self.silence_duration_scepter = self:GetAbility():GetSpecialValueFor("silence_duration_scepter")
	self.return_projectile_speed  = self:GetAbility():GetSpecialValueFor("return_projectile_speed")
	self.equal_exchange_duration  = self:GetAbility():GetSpecialValueFor("equal_exchange_duration")

	if not IsServer() then return end

	self.damage           = self:GetAbility():GetTalentSpecialValueFor("damage")
	self.radius           = self:GetAbility():GetSpecialValueFor("radius")
	self.thickness        = 120

	self.damage_type      = self:GetAbility():GetAbilityDamageType()

	self.hit_enemies      = {}
	self.ring_size        = 0
	self.center           = self:GetParent():GetAbsOrigin()

	self.thinker_entindex = keys.thinker_entindex

	self:OnIntervalThink()
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_void_spirit_resonant_pulse_ring:OnIntervalThink()
	self.ring_size = self:GetElapsedTime() * self.speed

	if self.ring_size > self.radius then
		self.ring_size = self.radius
	end

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.center, nil, self.ring_size, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		local distance = CalculateDistance(enemy, self.center)
		if not self.hit_enemies[enemy:entindex()] and distance < self.ring_size + self.thickness and distance > self.ring_size - self.thickness then
			enemy:EmitSound("Hero_VoidSpirit.Pulse.Target")

			self.impact_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControlEnt(self.impact_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(self.impact_particle)

			if self:GetCaster():HasScepter() then
				enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_silence", { duration = self.silence_duration_scepter * (1 - enemy:GetStatusResistance()) })
			end

			ApplyDamage({
				victim       = enemy,
				damage       = self.damage,
				damage_type  = self.damage_type,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = self:GetCaster(),
				ability      = self:GetAbility()
			})

			if enemy:IsRealHero() or enemy:IsClone() or enemy:IsTempestDouble() then
				ProjectileManager:CreateTrackingProjectile({
					EffectName        = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_absorb.vpcf",
					Ability           = self:GetAbility(),
					Source            = enemy:GetAbsOrigin(),
					vSourceLoc        = enemy:GetAbsOrigin(),
					Target            = self:GetParent(),
					iMoveSpeed        = self.return_projectile_speed,
					-- flExpireTime		= nil,
					bDodgeable        = false,
					bIsAttack         = false,
					bReplaceExisting  = false,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
					bDrawsOnMinimap   = nil,
					bVisibleToEnemies = true,
					bProvidesVision   = false,
					iVisionRadius     = nil,
					iVisionTeamNumber = nil,
					ExtraData         = {}
				})

				-- IMBAfication: Expansion Dome
				ProjectileManager:CreateTrackingProjectile({
					EffectName        = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_absorb.vpcf",
					Ability           = self:GetAbility(),
					Source            = enemy:GetAbsOrigin(),
					vSourceLoc        = enemy:GetAbsOrigin(),
					Target            = EntIndexToHScript(self.thinker_entindex),
					iMoveSpeed        = self.return_projectile_speed,
					-- flExpireTime		= nil,
					bDodgeable        = false,
					bIsAttack         = false,
					bReplaceExisting  = false,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
					bDrawsOnMinimap   = nil,
					bVisibleToEnemies = true,
					bProvidesVision   = false,
					iVisionRadius     = nil,
					iVisionTeamNumber = nil,
					ExtraData         = {}
				})
			end

			self.hit_enemies[enemy:entindex()] = true

			-- IMBAfication: Equal Exchange
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_void_spirit_resonant_pulse_equal_exchange", { duration = self.equal_exchange_duration * (1 - enemy:GetStatusResistance()) })
		end
	end
end

------------------------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_RESONANT_PULSE_PHYSICAL_BUFF --
------------------------------------------------------------

function modifier_imba_void_spirit_resonant_pulse_physical_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_void_spirit_pulse_buff.vpcf"
end

function modifier_imba_void_spirit_resonant_pulse_physical_buff:OnCreated()
	self.base_absorb_amount = self:GetAbility():GetSpecialValueFor("base_absorb_amount")

	if not IsServer() then return end

	-- Arbitrary side-by-side testing
	self.radius          = 130

	self.shield_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.shield_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.shield_particle, 1, Vector(self.radius, 1, 1))
	self:AddParticle(self.shield_particle, false, false, -1, false, false)

	self:SetStackCount(self.base_absorb_amount)
end

function modifier_imba_void_spirit_resonant_pulse_physical_buff:OnDestroy()
	if not IsServer() then return end

	self:GetParent():EmitSound("Hero_VoidSpirit.Pulse.Destroy")
end

function modifier_imba_void_spirit_resonant_pulse_physical_buff:DeclareFunctions()
	return { MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT }
end

function modifier_imba_void_spirit_resonant_pulse_physical_buff:GetModifierIncomingPhysicalDamageConstant(keys)
	self.deflect_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield_deflect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.deflect_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.deflect_particle, 1, Vector(self.radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(self.deflect_particle)

	if keys.damage >= self:GetStackCount() then
		self:Destroy()
		return self:GetStackCount() * (-1)
	else
		self:SetStackCount(self:GetStackCount() - keys.damage)
		return keys.damage * (-1)
	end
end

-----------------------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_RESONANT_PULSE_THINKER_AURA --
-----------------------------------------------------------

function modifier_imba_void_spirit_resonant_pulse_thinker_aura:OnCreated()
	self.radius             = self:GetAbility():GetSpecialValueFor("radius")
	self.base_absorb_amount = self:GetAbility():GetSpecialValueFor("base_absorb_amount")

	self.shield_particle    = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	-- ParticleManager:SetParticleControlEnt(self.shield_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.shield_particle, 1, Vector(self.radius, 1, 1))
	self:AddParticle(self.shield_particle, false, false, -1, false, false)

	self:SetStackCount(self.base_absorb_amount)
end

function modifier_imba_void_spirit_resonant_pulse_thinker_aura:IsHidden() return true end

function modifier_imba_void_spirit_resonant_pulse_thinker_aura:IsAura() return true end

function modifier_imba_void_spirit_resonant_pulse_thinker_aura:IsAuraActiveOnDeath() return false end

function modifier_imba_void_spirit_resonant_pulse_thinker_aura:GetAuraRadius() return self.radius end

function modifier_imba_void_spirit_resonant_pulse_thinker_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end

function modifier_imba_void_spirit_resonant_pulse_thinker_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_imba_void_spirit_resonant_pulse_thinker_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end

function modifier_imba_void_spirit_resonant_pulse_thinker_aura:GetModifierAura() return "modifier_imba_void_spirit_resonant_pulse_thinker_buff" end

function modifier_imba_void_spirit_resonant_pulse_thinker_aura:GetAuraDuration() return 0.1 end

function modifier_imba_void_spirit_resonant_pulse_thinker_aura:GetAuraEntityReject(target) return target == self:GetCaster() end

-----------------------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_RESONANT_PULSE_THINKER_BUFF --
-----------------------------------------------------------

function modifier_imba_void_spirit_resonant_pulse_thinker_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_void_spirit_pulse_buff.vpcf"
end

function modifier_imba_void_spirit_resonant_pulse_thinker_buff:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_imba_void_spirit_resonant_pulse_thinker_buff:DeclareFunctions()
	return { MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT }
end

function modifier_imba_void_spirit_resonant_pulse_thinker_buff:GetModifierIncomingPhysicalDamageConstant(keys)
	if not self:GetAuraOwner() then return end

	self.deflect_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield_deflect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetAuraOwner())
	-- ParticleManager:SetParticleControlEnt(self.deflect_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetAuraOwner():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.deflect_particle, 1, Vector(self.radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(self.deflect_particle)

	if keys.damage >= self:GetAuraOwner():FindModifierByName("modifier_imba_void_spirit_resonant_pulse_thinker_aura"):GetStackCount() then
		self:GetAuraOwner():Destroy()
		self:Destroy()
		return self:GetAuraOwner():FindModifierByName("modifier_imba_void_spirit_resonant_pulse_thinker_aura"):GetStackCount() * (-1)
	else
		self:GetAuraOwner():FindModifierByName("modifier_imba_void_spirit_resonant_pulse_thinker_aura"):SetStackCount(self:GetAuraOwner():FindModifierByName("modifier_imba_void_spirit_resonant_pulse_thinker_aura"):GetStackCount() - keys.damage)
		return keys.damage * (-1)
	end
end

-------------------------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_RESONANT_PULSE_EQUAL_EXCHANGE --
-------------------------------------------------------------

function modifier_imba_void_spirit_resonant_pulse_equal_exchange:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.equal_exchange_attacks = self:GetAbility():GetSpecialValueFor("equal_exchange_attacks")

	self:SetStackCount(self.equal_exchange_attacks)
end

function modifier_imba_void_spirit_resonant_pulse_equal_exchange:CheckState()
	return { [MODIFIER_STATE_BLOCK_DISABLED] = true }
end

function modifier_imba_void_spirit_resonant_pulse_equal_exchange:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_imba_void_spirit_resonant_pulse_equal_exchange:OnAttackLanded(keys)
	if keys.target == self:GetParent() then
		self:DecrementStackCount()

		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
	end
end

function modifier_imba_void_spirit_resonant_pulse_equal_exchange:OnTooltip()
	return self:GetStackCount()
end

-----------------------------------------
-- IMBA_VOID_SPIRIT_ASTRAL_STEP_HELPER --
-----------------------------------------

-- Echo Slash: Scrapping this IMBAfication due to the sheer amount of anime

function imba_void_spirit_astral_step_helper:IsStealable() return false end

function imba_void_spirit_astral_step_helper:GetManaCost(level)
	return self.BaseClass.GetManaCost(self, level) + (self:GetCaster():GetMaxMana() * self:GetSpecialValueFor("max_mana_pct") / 100)
end

function imba_void_spirit_astral_step_helper:OnAbilityPhaseStart()
	if self:GetCaster():HasModifier("modifier_imba_void_spirit_astral_step_grace_time") and self:GetCaster():FindModifierByName("modifier_imba_void_spirit_astral_step_grace_time"):GetElapsedTime() >= self:GetSpecialValueFor("grace_time_start") then
		return true
	end
end

function imba_void_spirit_astral_step_helper:OnSpellStart()
	if self:GetCaster():HasAbility("imba_void_spirit_astral_step") and self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step").original_vector then
		self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step"):OnSpellStart(self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step").original_vector * (-1))
	end
end

-------------------------------------------
-- IMBA_VOID_SPIRIT_ASTRAL_STEP_HELPER_2 --
-------------------------------------------

function imba_void_spirit_astral_step_helper_2:GetAssociatedSecondaryAbilities()
	return "imba_void_spirit_astral_step"
end

function imba_void_spirit_astral_step_helper_2:OnAbilityPhaseStart()
	if self.charge_modifier and self.charge_modifier:GetStackCount() > 0 then
		self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2_END, 0.2)
		return true
	else
		DisplayError(self:GetCaster():GetPlayerOwnerID(), "#dota_hud_error_astral_step_no_charges")
		return false
	end
end

function imba_void_spirit_astral_step_helper_2:OnAbilityPhaseInterrupted()
	self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_2_END)
end

function imba_void_spirit_astral_step_helper_2:OnChannelFinish(bInterrupted)
	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_2_END)

	if self.charge_modifier and self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step_helper_2").charge_modifier:GetStackCount() >= 1 then
		-- All this garbage is just to try and check for WTF mode to not expend charges and yet it's still bypassable
		local wtf_mode = true

		if not GameRules:IsCheatMode() then
			wtf_mode = false
		else
			for ability = 0, 24 - 1 do
				if self:GetCaster():GetAbilityByIndex(ability) and self:GetCaster():GetAbilityByIndex(ability):GetCooldownTimeRemaining() > 0 then
					wtf_mode = false
					break
				end
			end

			if wtf_mode == false then
				for item = 0, 15 do
					if self:GetCaster():GetItemInSlot(item) and self:GetCaster():GetItemInSlot(item):GetCooldownTimeRemaining() > 0 then
						wtf_mode = false
						break
					end
				end
			end
		end

		if wtf_mode == false then
			self.charge_modifier:DecrementStackCount()
			self.charge_modifier:CalculateCharge()
		end
	end

	if self:GetCaster():HasAbility("imba_void_spirit_astral_step") then
		self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step"):OnSpellStart(nil, (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * (self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step"):GetSpecialValueFor("max_travel_distance") * (1 + (self:GetSpecialValueFor("bonus_range_pct") / 100)) + self:GetCaster():GetCastRangeBonus()) * Vector(1, 1, 0), bInterrupted)
	end
end

--------------------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_ASTRAL_STEP_ARMOR_PIERCE --
--------------------------------------------------------

function modifier_imba_void_spirit_astral_step_armor_pierce:IsHidden() return true end

function modifier_imba_void_spirit_astral_step_armor_pierce:IsPurgable() return false end

function modifier_imba_void_spirit_astral_step_armor_pierce:DeclareFunctions()
	return { MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR }
end

function modifier_imba_void_spirit_astral_step_armor_pierce:GetModifierIgnorePhysicalArmor()
	return 1
end

--------------------------------------------
-- IMBA_VOID_SPIRIT_AETHER_REMNANT_HELPER --
--------------------------------------------

function imba_void_spirit_aether_remnant_helper:IsInnateAbility() return true end

function imba_void_spirit_aether_remnant_helper:GetIntrinsicModifierName()
	return "modifier_imba_void_spirit_aether_remnant_helper"
end

-----------------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_AETHER_REMNANT_HELPER --
-----------------------------------------------------

function modifier_imba_void_spirit_aether_remnant_helper:IsHidden() return true end

function modifier_imba_void_spirit_aether_remnant_helper:IsPurgable() return false end

function modifier_imba_void_spirit_aether_remnant_helper:RemoveOnDeath() return false end

function modifier_imba_void_spirit_aether_remnant_helper:DeclareFunctions()
	return { MODIFIER_EVENT_ON_TAKEDAMAGE }
end

function modifier_imba_void_spirit_aether_remnant_helper:OnTakeDamage(keys)
	if keys.inflictor and keys.inflictor:GetName() == "void_spirit_aether_remnant" and keys.attacker == self:GetParent() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and keys.unit:IsHero() then
		self:GetParent():AddNewModifier(self:GetCaster(), keys.inflictor, "modifier_imba_void_spirit_aether_remnant_helper_buff", { duration = self:GetAbility():GetSpecialValueFor("swiftness_duration") })

		keys.unit:AddNewModifier(self:GetCaster(), keys.inflictor, "modifier_imba_void_spirit_aether_remnant_target_vision", { duration = self:GetAbility():GetSpecialValueFor("vision_duration") * (1 - keys.unit:GetStatusResistance()) })
	end
end

----------------------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_AETHER_REMNANT_HELPER_BUFF --
----------------------------------------------------------

function modifier_imba_void_spirit_aether_remnant_helper_buff:GetEffectName()
	return "particles/status_fx/status_effect_void_spirit_aether_remnant.vpcf"
end

function modifier_imba_void_spirit_aether_remnant_helper_buff:OnCreated()
	self.damage_bonus       = self:GetAbility():GetSpecialValueFor("damage_bonus")
	self.move_speed_bonus   = self:GetAbility():GetSpecialValueFor("move_speed_bonus")
	self.evasion_bonus      = self:GetAbility():GetSpecialValueFor("evasion_bonus")
	self.swiftness_duration = self:GetAbility():GetSpecialValueFor("swiftness_duration")

	if not IsServer() then return end

	self.stack_table = {}

	table.insert(self.stack_table, GameRules:GetDOTATime(true, true))

	self:IncrementStackCount()

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_void_spirit_aether_remnant_helper_buff:OnRefresh()
	if not IsServer() then return end

	table.insert(self.stack_table, GameRules:GetDOTATime(true, true))

	self:IncrementStackCount()
end

function modifier_imba_void_spirit_aether_remnant_helper_buff:OnIntervalThink()
	Custom_ArrayRemove(self.stack_table, function(i, j)
		-- Remember that you return what you want to KEEP, which is kinda contradictory to the function name...
		return GameRules:GetDOTATime(true, true) - self.stack_table[i] <= self.swiftness_duration
	end)

	if #self.stack_table ~= self:GetStackCount() then
		self:SetStackCount(#self.stack_table)
	end
end

function modifier_imba_void_spirit_aether_remnant_helper_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
end

function modifier_imba_void_spirit_aether_remnant_helper_buff:GetModifierPreAttack_BonusDamage()
	return self.damage_bonus * self:GetStackCount()
end

function modifier_imba_void_spirit_aether_remnant_helper_buff:GetModifierMoveSpeedBonus_Constant()
	return self.move_speed_bonus * self:GetStackCount()
end

function modifier_imba_void_spirit_aether_remnant_helper_buff:GetModifierEvasion_Constant()
	return self.evasion_bonus * self:GetStackCount()
end

------------------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_ASTRAL_STEP_GRACE_TIME --
------------------------------------------------------

function modifier_imba_void_spirit_astral_step_grace_time:IsHidden() return true end

function modifier_imba_void_spirit_astral_step_grace_time:IsPurgable() return false end

function modifier_imba_void_spirit_astral_step_grace_time:RemoveOnDeath() return false end

function modifier_imba_void_spirit_astral_step_grace_time:OnCreated()
	if not IsServer() then return end

	self.grace_time_start = self:GetAbility():GetSpecialValueFor("grace_time_start")

	self:GetAbility():SetActivated(true)

	-- self:StartIntervalThink(self.grace_time_start)
end

-- function modifier_imba_void_spirit_astral_step_grace_time:OnIntervalThink()
-- self:GetAbility():SetActivated(true)
-- self:StartIntervalThink(-1)
-- end

function modifier_imba_void_spirit_astral_step_grace_time:OnDestroy()
	if not IsServer() then return end

	self:GetAbility():SetActivated(false)
end

----------------------------------
-- IMBA_VOID_SPIRIT_VOID_STASIS --
----------------------------------

function imba_void_spirit_void_stasis:IsInnateAbility() return true end

function imba_void_spirit_void_stasis:OnInventoryContentsChanged()
	if self:GetCaster():HasScepter() then
		self:SetHidden(false)
	else
		self:SetHidden(true)
	end
end

function imba_void_spirit_void_stasis:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

function imba_void_spirit_void_stasis:GetChannelAnimation()
	return ACT_DOTA_GENERIC_CHANNEL_1
end

function imba_void_spirit_void_stasis:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_void_spirit_void_stasis:OnSpellStart()
	-- self:GetCaster():EmitSound("Imba.Hellblade")

	self.aoe_particle_1 = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/planeshift_outer_ring.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(self.aoe_particle_1, 0, self:GetCursorPosition())
	ParticleManager:SetParticleControl(self.aoe_particle_1, 1, Vector(self:GetSpecialValueFor("radius"), 0, 0))

	self:GetCaster():StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
end

function imba_void_spirit_void_stasis:OnChannelFinish(bInterrupted)
	-- self:GetCaster():StopSound("Imba.Hellblade")

	ParticleManager:DestroyParticle(self.aoe_particle_1, true)
	ParticleManager:ReleaseParticleIndex(self.aoe_particle_1)

	self:GetCaster():FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1)

	if not bInterrupted then
		EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "Hero_VoidSpirit.AstralStep.Target", self:GetCaster())

		self.aoe_particle_impact = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/planeshift/planeshift_aether_start.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(self.aoe_particle_impact, 0, self:GetCursorPosition())
		ParticleManager:ReleaseParticleIndex(self.aoe_particle_impact)

		for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP, FIND_ANY_ORDER, false)) do
			unit:AddNewModifier(self:GetCaster(), self, "modifier_imba_void_spirit_void_stasis", { duration = self:GetSpecialValueFor("duration") })

			unit:Interrupt()
		end
	end
end

-------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_VOID_STASIS --
-------------------------------------------

function modifier_imba_void_spirit_void_stasis:IsPurgable() return false end

function modifier_imba_void_spirit_void_stasis:IgnoreTenacity() return true end

function modifier_imba_void_spirit_void_stasis:GetStatusEffectName()
	return "particles/status_fx/status_effect_faceless_chronosphere.vpcf"
end

function modifier_imba_void_spirit_void_stasis:CheckState()
	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		return {
			[MODIFIER_STATE_STUNNED]       = true,
			[MODIFIER_STATE_FROZEN]        = true,
			[MODIFIER_STATE_MAGIC_IMMUNE]  = true,
			[MODIFIER_STATE_INVULNERABLE]  = true,
			[MODIFIER_STATE_OUT_OF_GAME]   = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true
		}
	else
		return {
			[MODIFIER_STATE_DISARMED]      = true,
			[MODIFIER_STATE_MUTED]         = true,
			[MODIFIER_STATE_SILENCED]      = true,
			[MODIFIER_STATE_MAGIC_IMMUNE]  = true,
			[MODIFIER_STATE_INVULNERABLE]  = true,
			[MODIFIER_STATE_OUT_OF_GAME]   = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true
		}
	end
end

----------------------------------
-- IMBA_VOID_SPIRIT_ASTRAL_STEP --
----------------------------------

function imba_void_spirit_astral_step:GetAssociatedPrimaryAbilities()
	return "imba_void_spirit_astral_step_helper_2"
end

function imba_void_spirit_astral_step:GetIntrinsicModifierName()
	return "modifier_generic_charges"
end

function imba_void_spirit_astral_step:OnUpgrade()
	if self:IsTrained() and self:GetCaster():HasAbility("imba_void_spirit_astral_step_helper") and not self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step_helper"):IsTrained() then
		self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step_helper"):SetLevel(1)
		self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step_helper"):SetActivated(false)
	end

	if self:IsTrained() and self:GetCaster():HasAbility("imba_void_spirit_astral_step_helper_2") then
		self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step_helper_2"):SetLevel(self:GetLevel())
	end

	if self:GetLevel() == 1 then
		for _, mod in pairs(self:GetCaster():FindAllModifiersByName("modifier_generic_charges")) do
			if mod:GetAbility() == self then
				mod:OnCreated()

				if self:GetCaster():HasAbility("imba_void_spirit_astral_step_helper_2") then
					self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step_helper_2").charge_modifier = mod
				end

				break
			end
		end
	end
end

function imba_void_spirit_astral_step:GetCastRange(location, target)
	if IsClient() then
		return self:GetSpecialValueFor("max_travel_distance")
	end
end

-- recastVector is for Echo Slash (disabled)
-- warpVector is for Warp Slash (enabled)
function imba_void_spirit_astral_step:OnSpellStart(recastVector, warpVector, bInterrupted)
	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	-- Just in case the helper ability never gets skilled somehow
	if self:GetCaster():HasAbility("imba_void_spirit_astral_step_helper") and not self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step_helper"):IsTrained() then
		self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step_helper"):SetLevel(1)
	end

	local original_position = self:GetCaster():GetAbsOrigin()

	local final_position = self:GetCaster():GetAbsOrigin() + ((self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * math.max(math.min(((self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()) * Vector(1, 1, 0)):Length2D(), self:GetSpecialValueFor("max_travel_distance") + self:GetCaster():GetCastRangeBonus()), self:GetSpecialValueFor("min_travel_distance")))

	if recastVector then
		final_position = self:GetCaster():GetAbsOrigin() + recastVector
	end

	if warpVector then
		final_position = GetGroundPosition(self:GetCaster():GetAbsOrigin() + warpVector, nil)
	end

	self.original_vector = (final_position - self:GetCaster():GetAbsOrigin()):Normalized() * (self:GetSpecialValueFor("max_travel_distance") + self:GetCaster():GetCastRangeBonus())

	self:GetCaster():SetForwardVector(self.original_vector:Normalized())

	self:GetCaster():EmitSound("Hero_VoidSpirit.AstralStep.Start")

	local step_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(step_particle, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(step_particle, 1, final_position)
	ParticleManager:ReleaseParticleIndex(step_particle)

	local bHeroHit = false

	-- Logically speaking it doesn't make sense for it to check for enemies hit before Void Spirit actually moves, but it makes more sense without creating more variables
	for _, enemy in pairs(FindUnitsInLine(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), final_position, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)) do
		-- enemy:EmitSound("Hero_VoidSpirit.AstralStep.MarkExplosionAOE")
		-- enemy:EmitSound("Hero_VoidSpirit.AstralStep.Target")

		self.impact_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControlEnt(self.impact_particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(self.impact_particle)

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_void_spirit_astral_step_crit", {})
		self:GetCaster():SetAbsOrigin(enemy:GetAbsOrigin() - self:GetCaster():GetForwardVector())

		if warpVector and not bInterrupted then
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_void_spirit_astral_step_armor_pierce", {})
		end

		self:GetCaster():PerformAttack(enemy, false, true, true, false, false, false, true)
		self:GetCaster():RemoveModifierByName("modifier_imba_void_spirit_astral_step_crit")

		enemy:RemoveModifierByName("modifier_imba_void_spirit_astral_step_armor_pierce")

		enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_void_spirit_astral_step_debuff", { duration = self:GetSpecialValueFor("pop_damage_delay") * (1 - enemy:GetStatusResistance()) })

		if enemy:IsHero() and not bHeroHit then
			bHeroHit = true
		end
	end

	self.impact_particle = nil

	if not warpVector then
		FindClearSpaceForUnit(self:GetCaster(), final_position, false)
	else
		FindClearSpaceForUnit(self:GetCaster(), original_position, false)
	end

	self:GetCaster():EmitSound("Hero_VoidSpirit.AstralStep.End")

	-- IMBAfication: Echo Slash (disabled)
	if self:GetCaster():HasAbility("imba_void_spirit_astral_step_helper") and self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step_helper"):IsTrained() then
		self:GetCaster():RemoveModifierByName("modifier_imba_void_spirit_astral_step_grace_time")
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step_helper"), "modifier_imba_void_spirit_astral_step_grace_time", { duration = self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step_helper"):GetSpecialValueFor("grace_time_end") })
	end

	-- IMBAfication: Warp Slash
	if self:GetCaster():HasAbility("imba_void_spirit_astral_step_helper_2") then
		if self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step_helper_2").charge_modifier and ((not warpVector and self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step_helper_2").charge_modifier:GetStackCount() <= 1) or (warpVector and self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step_helper_2").charge_modifier:GetStackCount() <= 0)) then
			self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step_helper_2"):StartCooldown(self:GetCaster():FindAbilityByName("imba_void_spirit_astral_step_helper_2").charge_modifier:GetRemainingTime())
		end
	end

	-- IMBAfication: I am ALL The Hidden Ones
	if bHeroHit and not recastVector then
		if not self:GetCaster():HasModifier("modifier_imba_void_spirit_astral_step_invis") then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_void_spirit_astral_step_invis", { duration = self:GetSpecialValueFor("hidden_ones_duration") })
		else
			self:GetCaster():FindModifierByName("modifier_imba_void_spirit_astral_step_invis"):SetDuration(self:GetCaster():FindModifierByName("modifier_imba_void_spirit_astral_step_invis"):GetRemainingTime() + self:GetSpecialValueFor("hidden_ones_duration"), true)
		end
	end
end

--------------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_ASTRAL_STEP_DEBUFF --
--------------------------------------------------

function modifier_imba_void_spirit_astral_step_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_void_spirit_astral_step_debuff:GetEffectName()
	return "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_debuff.vpcf"
end

function modifier_imba_void_spirit_astral_step_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_void_spirit_astral_step_debuff.vpcf"
end

function modifier_imba_void_spirit_astral_step_debuff:OnCreated()
	self.pop_damage        = self:GetAbility():GetSpecialValueFor("pop_damage")
	self.movement_slow_pct = self:GetAbility():GetSpecialValueFor("movement_slow_pct") * (-1)
end

function modifier_imba_void_spirit_astral_step_debuff:OnDestroy()
	if not IsServer() then return end

	self.damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(self.damage_particle)

	ApplyDamage({
		victim       = self:GetParent(),
		damage       = self.pop_damage,
		damage_type  = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		attacker     = self:GetCaster(),
		ability      = self:GetAbility()
	})

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.pop_damage, nil)
end

function modifier_imba_void_spirit_astral_step_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_imba_void_spirit_astral_step_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow_pct
end

------------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_ASTRAL_STEP_CRIT --
------------------------------------------------

function modifier_imba_void_spirit_astral_step_crit:IsPurgable() return false end

-- This CheckState is basically only for allowing cleave to properly function (since Void Spirit will warp to in front of the target before performing the attack)
function modifier_imba_void_spirit_astral_step_crit:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION]                = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_INVULNERABLE]                     = true -- Just in case?
	}
end

function modifier_imba_void_spirit_astral_step_crit:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_imba_void_spirit_astral_step_crit:GetModifierPreAttack_CriticalStrike()
	if self:GetCaster():HasTalent("special_bonus_imba_void_spirit_astral_step_crit") then
		return self:GetCaster():FindTalentValue("special_bonus_imba_void_spirit_astral_step_crit")
	end
end

-- Hopefully this is enough random information to only suppress cleaves?...
function modifier_imba_void_spirit_astral_step_crit:GetModifierTotalDamageOutgoing_Percentage(keys)
	if not keys.no_attack_cooldown and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.damage_flags == DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION then
		return -100
	end
end

-------------------------------------------------
-- MODIFIER_IMBA_VOID_SPIRIT_ASTRAL_STEP_INVIS --
-------------------------------------------------

function modifier_imba_void_spirit_astral_step_invis:CheckState()
	return { [MODIFIER_STATE_INVISIBLE] = true }
end

function modifier_imba_void_spirit_astral_step_invis:DeclareFunctions()
	return { MODIFIER_PROPERTY_INVISIBILITY_LEVEL }
end

function modifier_imba_void_spirit_astral_step_invis:GetModifierInvisibilityLevel()
	return 1
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_void_spirit_resonant_pulse_damage", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_void_spirit_astral_step_charge_cooldown", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_void_spirit_astral_step_crit", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_void_spirit_dissimilate_stun", "components/abilities/heroes/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_void_spirit_resonant_pulse_damage = modifier_special_bonus_imba_void_spirit_resonant_pulse_damage or class({})
modifier_special_bonus_imba_void_spirit_astral_step_charge_cooldown = modifier_special_bonus_imba_void_spirit_astral_step_charge_cooldown or class({})
modifier_special_bonus_imba_void_spirit_astral_step_crit = modifier_special_bonus_imba_void_spirit_astral_step_crit or class({})
modifier_special_bonus_imba_void_spirit_dissimilate_stun = modifier_special_bonus_imba_void_spirit_dissimilate_stun or class({})

function modifier_special_bonus_imba_void_spirit_resonant_pulse_damage:IsHidden() return true end

function modifier_special_bonus_imba_void_spirit_resonant_pulse_damage:IsPurgable() return false end

function modifier_special_bonus_imba_void_spirit_resonant_pulse_damage:RemoveOnDeath() return false end

function modifier_special_bonus_imba_void_spirit_astral_step_charge_cooldown:IsHidden() return true end

function modifier_special_bonus_imba_void_spirit_astral_step_charge_cooldown:IsPurgable() return false end

function modifier_special_bonus_imba_void_spirit_astral_step_charge_cooldown:RemoveOnDeath() return false end

function modifier_special_bonus_imba_void_spirit_astral_step_crit:IsHidden() return true end

function modifier_special_bonus_imba_void_spirit_astral_step_crit:IsPurgable() return false end

function modifier_special_bonus_imba_void_spirit_astral_step_crit:RemoveOnDeath() return false end

function modifier_special_bonus_imba_void_spirit_dissimilate_stun:IsHidden() return true end

function modifier_special_bonus_imba_void_spirit_dissimilate_stun:IsPurgable() return false end

function modifier_special_bonus_imba_void_spirit_dissimilate_stun:RemoveOnDeath() return false end
