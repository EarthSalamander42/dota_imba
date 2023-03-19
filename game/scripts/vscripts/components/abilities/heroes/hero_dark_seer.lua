-- Creator:
--	   AltiV, April 18th, 2019

LinkLuaModifier("modifier_imba_dark_seer_vacuum", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_dark_seer_vacuum_wormhole", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dark_seer_vacuum_refresh_tracker", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_dark_seer_wormhole", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_HORIZONTAL)

LinkLuaModifier("modifier_imba_dark_seer_vacuum_entry_portal", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dark_seer_vacuum_exit_portal", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dark_seer_vacuum_camera_track", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_dark_seer_ion_shell", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dark_seer_ion_shell_negation", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_dark_seer_surge", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dark_seer_surge_slow", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_motion_controller", "components/modifiers/generic/modifier_generic_motion_controller", LUA_MODIFIER_MOTION_BOTH)

LinkLuaModifier("modifier_imba_dark_seer_close_portal", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_dark_seer_wall_of_replica", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dark_seer_wall_of_replica_slow", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)

imba_dark_seer_vacuum                          = class({})
modifier_imba_dark_seer_vacuum                 = class({})
modifier_imba_dark_seer_vacuum_wormhole        = class({})
modifier_imba_dark_seer_vacuum_refresh_tracker = class({})

imba_dark_seer_wormhole                        = class({})
modifier_imba_dark_seer_wormhole               = class({})

modifier_imba_dark_seer_vacuum_entry_portal    = modifier_imba_dark_seer_vacuum_entry_portal or class({})
modifier_imba_dark_seer_vacuum_exit_portal     = modifier_imba_dark_seer_vacuum_exit_portal or class({})
modifier_imba_dark_seer_vacuum_camera_track    = modifier_imba_dark_seer_vacuum_camera_track or class({})

imba_dark_seer_ion_shell                       = class({})
modifier_imba_dark_seer_ion_shell              = class({})
modifier_imba_dark_seer_ion_shell_negation     = modifier_imba_dark_seer_ion_shell_negation or class({})

imba_dark_seer_surge                           = class({})
modifier_imba_dark_seer_surge                  = class({})
modifier_imba_dark_seer_surge_slow             = modifier_imba_dark_seer_surge_slow or class({})

imba_dark_seer_close_portal                    = imba_dark_seer_close_portal or class({})
modifier_imba_dark_seer_close_portal           = modifier_imba_dark_seer_close_portal or class({})

imba_dark_seer_wall_of_replica                 = class({})
modifier_imba_dark_seer_wall_of_replica        = class({})
modifier_imba_dark_seer_wall_of_replica_slow   = class({})

------------
-- VACUUM --
------------

function imba_dark_seer_vacuum:GetAssociatedSecondaryAbilities()
	return "imba_dark_seer_wormhole"
end

function imba_dark_seer_vacuum:CastFilterResultLocation(vLocation)
	if not IsServer() then return end

	if IsNearFountain(vLocation, 1700 + self:GetSpecialValueFor("radius")) then
		return UF_FAIL_CUSTOM
	end
end

function imba_dark_seer_vacuum:GetCustomCastErrorLocation()
	return "#dota_hud_error_cant_cast_near_fountain"
end

-- Level up corresponding wormhole ability
function imba_dark_seer_vacuum:OnUpgrade()
	if not IsServer() then return end

	local wormhole_ability = self:GetCaster():FindAbilityByName("imba_dark_seer_wormhole")

	if wormhole_ability then
		wormhole_ability:SetLevel(self:GetLevel())
	end
end

function imba_dark_seer_vacuum:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_dark_seer_vacuum:GetCooldown(level)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCooldown(self, level)
	else
		return self:GetSpecialValueFor("scepter_cooldown")
	end
end

function imba_dark_seer_vacuum:OnSpellStart()
	if not IsServer() then return end

	self.cursor_position = self:GetCursorPosition()

	-- Check if this ability exists to do secondary logic
	local wormhole_ability = self:GetCaster():FindAbilityByName("imba_dark_seer_wormhole")

	EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "Hero_Dark_Seer.Vacuum", self:GetCaster())

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_vacuum.vpcf", PATTACH_POINT, self:GetCaster())
	ParticleManager:SetParticleControl(particle, 0, self:GetCursorPosition())
	ParticleManager:SetParticleControl(particle, 1, Vector(self:GetSpecialValueFor("radius"), 1, 1))
	ParticleManager:ReleaseParticleIndex(particle)

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

	for _, enemy in pairs(enemies) do
		if not enemy.IsCourier or not enemy:IsCourier() then
			-- Need some weird workaround for being able to affect invulnerable units
			if enemy:IsInvulnerable() and not enemy:HasModifier("modifier_eul_cyclone") then
				enemy:AddNewModifier(enemy, self, "modifier_imba_dark_seer_vacuum",
					{
						duration        = self:GetTalentSpecialValueFor("duration"),
						x               = self:GetCursorPosition().x,
						y               = self:GetCursorPosition().y,
						caster_entindex = self:GetCaster():entindex()
					})

				-- if wormhole_ability then
				-- enemy:AddNewModifier(enemy, self, "modifier_imba_dark_seer_vacuum_wormhole", {duration = self:GetSpecialValueFor("wormhole_duration")})
				-- end
			else
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_dark_seer_vacuum",
					{
						duration = self:GetTalentSpecialValueFor("duration"),
						x        = self:GetCursorPosition().x,
						y        = self:GetCursorPosition().y
					})

				-- if wormhole_ability then
				-- enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_dark_seer_vacuum_wormhole", {duration = self:GetSpecialValueFor("wormhole_duration")})
				-- end
			end

			if wormhole_ability then
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_dark_seer_vacuum_wormhole", { duration = self:GetSpecialValueFor("wormhole_duration") })

				-- This is redundant but was primarily for adding in the Vacuum ability without leveling it (through testing)
				wormhole_ability:SetLevel(self:GetLevel())

				if not wormhole_ability.enemy_tracker then
					wormhole_ability.enemy_tracker = {}
				end

				table.insert(wormhole_ability.enemy_tracker, enemy)
			end
		end
	end

	GridNav:DestroyTreesAroundPoint(self:GetCursorPosition(), self:GetSpecialValueFor("radius_tree"), true)

	-- Swap abilities if applicable
	if wormhole_ability then
		wormhole_ability:EndCooldown()
		self:GetCaster():SwapAbilities("imba_dark_seer_vacuum", "imba_dark_seer_wormhole", false, true)
		wormhole_ability:SetHidden(false)

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_dark_seer_vacuum_refresh_tracker", { duration = self:GetSpecialValueFor("wormhole_duration") })

		-- This is purely in the case of refreshing Vacuum/Wormhole, where the Wormhole timer to ability swap needs to be reset
		if self.swap_timer then Timers:RemoveTimer(self.swap_timer) end

		self.swap_timer = Timers:CreateTimer(self:GetSpecialValueFor("wormhole_duration"), function()
			if self and self:GetCaster() and self:IsHidden() then
				-- Swap abilities
				self:GetCaster():SwapAbilities("imba_dark_seer_vacuum", "imba_dark_seer_wormhole", true, false)
			end

			self.swap_timer = nil
		end)
	end
end

---------------------
-- VACUUM MODIFIER --
---------------------

function modifier_imba_dark_seer_vacuum:IsDebuff() return true end

function modifier_imba_dark_seer_vacuum:IgnoreTenacity() return true end

function modifier_imba_dark_seer_vacuum:OnCreated(params)
	self.damage = self:GetAbility():GetSpecialValueFor("damage")

	if not IsServer() then return end

	if params.caster_entindex then
		self.caster = EntIndexToHScript(params.caster_entindex)
	else
		self.caster = self:GetCaster()
	end

	-- Get coordinates of where the Vacuum was cast
	self.duration   = params.duration
	self.x          = params.x
	self.y          = params.y
	self.vacuum_pos = GetGroundPosition(Vector(self.x, self.y, 0), nil)

	self.distance   = self:GetParent():GetAbsOrigin() - self.vacuum_pos

	-- Calculate initial speed (this will continue to be used even if the victim is at the vacuum center and the duration is still going
	self.speed      = self.distance:Length2D() / self.duration

	-- Begin the motion controller
	if self:ApplyHorizontalMotionController() == false then
		self:Destroy()
	end
end

function modifier_imba_dark_seer_vacuum:OnRefresh()
	self:OnCreated(params)
end

function modifier_imba_dark_seer_vacuum:UpdateHorizontalMotion(me, dt)
	if not IsServer() then return end

	local distance = (self.vacuum_pos - me:GetAbsOrigin()):Normalized()
	me:SetOrigin(me:GetAbsOrigin() + distance * self.speed * dt)
end

function modifier_imba_dark_seer_vacuum:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_imba_dark_seer_vacuum:OnDestroy()
	if not IsServer() then return end

	self:GetParent():RemoveHorizontalMotionController(self)

	-- These two lines are literally just to let people stack a billion creeps onto a cliff for...reasons -_-
	self:GetParent():SetAbsOrigin(self.vacuum_pos)
	ResolveNPCPositions(self.vacuum_pos, 128)

	-- Apply vacuum damage
	local damageTable = {
		victim       = self:GetParent(),
		damage       = self.damage,
		damage_type  = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY,
		attacker     = self.caster,
		ability      = self:GetAbility()
	}

	ApplyDamage(damageTable)
end

function modifier_imba_dark_seer_vacuum:CheckState()
	return { [MODIFIER_STATE_STUNNED] = true }
end

function modifier_imba_dark_seer_vacuum:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_imba_dark_seer_vacuum:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

------------------------------
-- VACUUM WORMHOLE MODIFIER --
------------------------------

function modifier_imba_dark_seer_vacuum_wormhole:IgnoreTenacity() return true end

function modifier_imba_dark_seer_vacuum_wormhole:IsDebuff() return true end

function modifier_imba_dark_seer_vacuum_wormhole:IsPurgable() return false end

-------------------------------------
-- VACUUM REFRESH TRACKER MODIFIER --
-------------------------------------

-- This is purely just for people who might complain that the ability is ruined because they can't immediately get Vacuum back if refreshed (since otherwise Wormhole would persist for that short period of time)

function modifier_imba_dark_seer_vacuum_refresh_tracker:IsHidden() return true end

function modifier_imba_dark_seer_vacuum_refresh_tracker:IsPurgable() return false end

function modifier_imba_dark_seer_vacuum_refresh_tracker:RemoveOnDeath() return false end

function modifier_imba_dark_seer_vacuum_refresh_tracker:OnCreated()
	if not IsServer() then return end

	self.vacuum_ability   = self:GetCaster():FindAbilityByName("imba_dark_seer_vacuum")
	self.wormhole_ability = self:GetCaster():FindAbilityByName("imba_dark_seer_wormhole")

	if self.vacuum_ability and self.wormhole_ability and self.vacuum_ability:GetCooldownTimeRemaining() > 0 then
		self:StartIntervalThink(0.1)
	else
		self:Destroy()
	end
end

function modifier_imba_dark_seer_vacuum_refresh_tracker:OnIntervalThink()
	if not IsServer() then return end

	if self.vacuum_ability:GetCooldownTimeRemaining() == 0 and self.vacuum_ability and self.wormhole_ability and self.vacuum_ability:IsHidden() then
		self:GetCaster():SwapAbilities("imba_dark_seer_vacuum", "imba_dark_seer_wormhole", true, false)
		self:Destroy()
	end
end

--------------
-- WORMHOLE --
--------------

function imba_dark_seer_wormhole:OnUpgrade()
	if not IsServer() then return end

	-- Morphling exception
	if self:GetCaster():GetName() ~= "npc_dota_hero_dark_seer" then
		self:SetHidden(true)
	end
end

function imba_dark_seer_wormhole:GetAssociatedPrimaryAbilities()
	return "imba_dark_seer_vacuum"
end

function imba_dark_seer_wormhole:CastFilterResultLocation(vLocation)
	if not IsServer() then return end

	if IsNearFountain(vLocation, 1700 + self:GetSpecialValueFor("radius")) then
		return UF_FAIL_CUSTOM
	end
end

function imba_dark_seer_wormhole:GetCustomCastErrorLocation()
	return "#dota_hud_error_cant_cast_near_fountain"
end

function imba_dark_seer_wormhole:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_dark_seer_wormhole:OnSpellStart()
	if not IsServer() then return end

	if not self.enemy_tracker then self.enemy_tracker = {} end

	-- Check if this ability exists to do secondary logic
	local vacuum_ability = self:GetCaster():FindAbilityByName("imba_dark_seer_vacuum")

	EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "Hero_Dark_Seer.Wormhole", self:GetCaster())

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_vacuum.vpcf", PATTACH_POINT, self:GetCaster())
	ParticleManager:SetParticleControl(particle, 0, self:GetCursorPosition())
	ParticleManager:SetParticleControl(particle, 1, Vector(self:GetSpecialValueFor("radius"), 1, 1))
	ParticleManager:ReleaseParticleIndex(particle)

	-- for _, enemy in pairs(self.enemy_tracker) do
	-- if not enemy:IsNull() and enemy:HasModifier("modifier_imba_dark_seer_vacuum_wormhole") and not enemy:HasModifier("modifier_imba_dark_seer_wormhole") and not IsNearFountain(enemy:GetAbsOrigin(), 1700) then
	-- -- Need some weird workaround for being able to affect invulnerable units
	-- if enemy:IsInvulnerable() and not enemy:HasModifier("modifier_eul_cyclone") then
	-- enemy:AddNewModifier(enemy, self, "modifier_imba_dark_seer_wormhole",
	-- {
	-- duration		= self:GetTalentSpecialValueFor("duration"),
	-- x				= self:GetCursorPosition().x,
	-- y				= self:GetCursorPosition().y,
	-- caster_entindex	= self:GetCaster():entindex()
	-- })
	-- else
	-- enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_dark_seer_wormhole",
	-- {
	-- duration	= self:GetTalentSpecialValueFor("duration"),
	-- x			= self:GetCursorPosition().x,
	-- y			= self:GetCursorPosition().y
	-- })
	-- end
	-- end
	-- end

	GridNav:DestroyTreesAroundPoint(self:GetCursorPosition(), self:GetSpecialValueFor("radius_tree"), true)

	-- if vacuum_ability and vacuum_ability:GetAutoCastState() and vacuum_ability:GetCursorPosition() then
	local exit_portal = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_dark_seer_vacuum_exit_portal", {
		duration = vacuum_ability:GetSpecialValueFor("teleport_duration")
	}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)

	local entry_portal = CreateModifierThinker(self:GetCaster(), vacuum_ability, "modifier_imba_dark_seer_vacuum_entry_portal", {
		duration             = vacuum_ability:GetSpecialValueFor("teleport_duration"),
		exit_portal_entindex = exit_portal:entindex(),
		enemy_tracker        = self.enemy_tracker
	}, vacuum_ability.cursor_position, self:GetCaster():GetTeamNumber(), false)

	if self:GetCaster():HasAbility("imba_dark_seer_close_portal") then
		self:GetCaster():FindAbilityByName("imba_dark_seer_close_portal").exit_portal = exit_portal
		self:GetCaster():FindAbilityByName("imba_dark_seer_close_portal").entry_portal = entry_portal

		self:GetCaster():FindAbilityByName("imba_dark_seer_close_portal"):SetActivated(true)
	end
	-- end

	-- Swap abilities if applicable
	if vacuum_ability and vacuum_ability:IsHidden() then
		self:GetCaster():SwapAbilities("imba_dark_seer_vacuum", "imba_dark_seer_wormhole", true, false)
	end

	-- Clear the tracker table
	self.enemy_tracker = {}
end

-----------------------
-- WORMHOLE MODIFIER --
-----------------------

function modifier_imba_dark_seer_wormhole:IsDebuff() return true end

function modifier_imba_dark_seer_wormhole:IgnoreTenacity() return true end

function modifier_imba_dark_seer_wormhole:OnCreated(params)
	self.damage = self:GetAbility():GetSpecialValueFor("damage")

	if not IsServer() then return end

	-- Get coordinates of where the Vacuum was cast
	self.duration   = params.duration
	self.x          = params.x
	self.y          = params.y
	self.vacuum_pos = GetGroundPosition(Vector(self.x, self.y, 0), nil)

	if params.caster_entindex then
		self.caster = EntIndexToHScript(params.caster_entindex)
	else
		self.caster = self:GetCaster()
	end

	-- Get WARPED
	self:GetParent():SetAbsOrigin(self.vacuum_pos)

	-- Choose a random point radius distance away from the wormhole to push the affected enemy to
	self.distance = self:GetParent():GetAbsOrigin() + RandomVector(self:GetAbility():GetSpecialValueFor("radius"))

	-- Calculate initial speed (this will continue to be used even if the victim is at the vacuum center and the duration is still going
	self.speed    = self:GetAbility():GetSpecialValueFor("radius") / self.duration

	-- Begin the motion controller
	if self:ApplyHorizontalMotionController() == false then
		self:Destroy()
	end
end

function modifier_imba_dark_seer_wormhole:OnRefresh()
	self:OnCreated(params)
end

function modifier_imba_dark_seer_wormhole:UpdateHorizontalMotion(me, dt)
	if not IsServer() then return end

	-- Remember that this is essentially the reverse of Vacuum
	local distance = (me:GetAbsOrigin() - self.distance):Normalized()
	me:SetOrigin(me:GetAbsOrigin() + distance * self.speed * dt)
end

function modifier_imba_dark_seer_wormhole:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_imba_dark_seer_wormhole:OnDestroy()
	if not IsServer() then return end

	self:GetParent():RemoveHorizontalMotionController(self)

	-- Apply vacuum damage
	local damageTable = {
		victim       = self:GetParent(),
		damage       = self.damage,
		damage_type  = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY,
		attacker     = self.caster,
		ability      = self:GetAbility()
	}

	ApplyDamage(damageTable)
end

function modifier_imba_dark_seer_wormhole:CheckState()
	return { [MODIFIER_STATE_STUNNED] = true }
end

function modifier_imba_dark_seer_wormhole:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_imba_dark_seer_wormhole:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

-------------------------------------------------
-- MODIFIER_IMBA_DARK_SEER_VACUUM_ENTRY_PORTAL --
-------------------------------------------------

function modifier_imba_dark_seer_vacuum_entry_portal:OnCreated(keys)
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	if not IsServer() then return end

	self.teleport_radius = self:GetAbility():GetSpecialValueFor("teleport_radius")

	self.entry_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/void_spirit_entryportal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(self.entry_particle, false, false, -1, false, false)

	self.exit_portal = EntIndexToHScript(keys.exit_portal_entindex)
	self.ported_units = {}
	self.enemy_tracker = {}
	self.camera_tracker = {}

	if self:GetCaster():HasAbility("imba_dark_seer_wormhole") and self:GetCaster():FindAbilityByName("imba_dark_seer_wormhole").enemy_tracker then
		for _, enemy in pairs(self:GetCaster():FindAbilityByName("imba_dark_seer_wormhole").enemy_tracker) do
			self.enemy_tracker[enemy:entindex()] = true
		end
	end
end

function modifier_imba_dark_seer_vacuum_entry_portal:CheckState()
	if not IsServer() then return end

	for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.teleport_radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)) do
		-- Once again, do not allow porting into fountain
		if self:GetElapsedTime() >= 0.1 and not self.ported_units[unit:entindex()] and not unit:HasModifier("modifier_imba_dark_seer_wormhole") and (unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() or not IsNearFountain(self.exit_portal:GetAbsOrigin(), 1700)) then
			if unit:IsHero() then
				EmitSoundOnLocationWithCaster(unit:GetAbsOrigin(), "Wormhole.Disappear", self:GetCaster())
			else
				EmitSoundOnLocationWithCaster(unit:GetAbsOrigin(), "Wormhole.CreepDisappear", self:GetCaster())
			end

			FindClearSpaceForUnit(unit, self.exit_portal:GetAbsOrigin(), true)

			-- This is to re-orient the camera so people will have a slightly better idea of where they are being ported around
			if unit.GetPlayerID then
				PlayerResource:SetCameraTarget(unit:GetPlayerID(), unit)
				unit:AddNewModifier(unit, self:GetAbility(), "modifier_imba_dark_seer_vacuum_camera_track", { duration = FrameTime() })
			end

			if unit:IsHero() then
				EmitSoundOnLocationWithCaster(unit:GetAbsOrigin(), "Wormhole.Appear", self:GetCaster())
			else
				EmitSoundOnLocationWithCaster(unit:GetAbsOrigin(), "Wormhole.CreepAppear", self:GetCaster())
			end

			self.ported_units[unit:entindex()] = true
		end
	end
end

function modifier_imba_dark_seer_vacuum_entry_portal:OnDestroy()
	if not IsServer() then return end

	if self:GetCaster():HasAbility("imba_dark_seer_close_portal") then
		self:GetCaster():FindAbilityByName("imba_dark_seer_close_portal"):SetActivated(false)
	end
end

------------------------------------------------
-- MODIFIER_IMBA_DARK_SEER_VACUUM_EXIT_PORTAL --
------------------------------------------------

function modifier_imba_dark_seer_vacuum_exit_portal:OnCreated()
	if not IsServer() then return end

	self.exit_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/void_spirit_exitportal_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(self.exit_particle, false, false, -1, false, false)
end

-------------------------------------------------
-- MODIFIER_IMBA_DARK_SEER_VACUUM_CAMERA_TRACK --
-------------------------------------------------

function modifier_imba_dark_seer_vacuum_camera_track:IsHidden() return true end

function modifier_imba_dark_seer_vacuum_camera_track:IsPurgable() return false end

function modifier_imba_dark_seer_vacuum_camera_track:RemoveOnDeath() return false end

function modifier_imba_dark_seer_vacuum_camera_track:IgnoreTenacity() return true end

function modifier_imba_dark_seer_vacuum_camera_track:OnDestroy()
	if not IsServer() then return end

	PlayerResource:SetCameraTarget(self:GetParent():GetPlayerID(), nil)
end

---------------
-- ION SHELL --
---------------

function imba_dark_seer_ion_shell:OnSpellStart()
	if not IsServer() then return end

	self:GetCursorTarget():EmitSound("Hero_Dark_Seer.Ion_Shield_Start")

	if self:GetCaster():GetName() == "npc_dota_hero_dark_seer" and RollPercentage(50) then
		self:GetCaster():EmitSound("dark_seer_dkseer_ability_surge_0" .. math.random(1, 2))
	end

	if self:GetAutoCastState() and self:GetCursorTarget():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_dark_seer_ion_shell_negation", { duration = self:GetSpecialValueFor("duration") * (1 - self:GetCursorTarget():GetStatusResistance()) })
	else
		self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_dark_seer_ion_shell", { duration = self:GetSpecialValueFor("duration") })
	end
end

------------------------
-- ION SHELL MODIFIER --
------------------------

function modifier_imba_dark_seer_ion_shell:OnCreated()
	self.damage_per_second       = self:GetAbility():GetTalentSpecialValueFor("damage_per_second")
	self.proton_explosion_radius = self:GetAbility():GetSpecialValueFor("proton_explosion_radius")
	self.proton_damage_pct       = self:GetAbility():GetSpecialValueFor("proton_damage_pct")

	self.interval                = 0.1

	if not IsServer() then return end

	self.radius = self:GetAbility():GetTalentSpecialValueFor("radius")

	self:GetParent():EmitSound("Hero_Dark_Seer.Ion_Shield_lp")

	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_ion_shell.vpcf", PATTACH_POINT_FOLLOW, self:GetParent(), self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle, 1, Vector(50, 50, 50)) -- Arbitrary
	self:AddParticle(self.particle, false, false, -1, false, false)

	self:SetStackCount(0)

	self:StartIntervalThink(self.interval)
end

function modifier_imba_dark_seer_ion_shell:OnRefresh()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.damage_per_second = self:GetAbility():GetTalentSpecialValueFor("damage_per_second")

	if not IsServer() then return end

	self.radius = self:GetAbility():GetSpecialValueFor("radius")

	self:SetStackCount(0)
end

function modifier_imba_dark_seer_ion_shell:OnIntervalThink()
	if not IsServer() then return end

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, enemy in pairs(enemies) do
		if enemy ~= self:GetParent() then
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_ion_shell_damage.vpcf", PATTACH_POINT, self:GetParent(), self:GetCaster())
			ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle)

			-- This is to retroactively upgrade any existing Ion Shells with talent acquisition
			if self:GetAbility() then
				self.damage_per_second = self:GetAbility():GetTalentSpecialValueFor("damage_per_second")
			end

			local damageTable = {
				victim       = enemy,
				damage       = self.damage_per_second * self.interval,
				damage_type  = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = self:GetCaster(),
				ability      = self:GetAbility()
			}

			local damage_dealt = ApplyDamage(damageTable) * self.proton_damage_pct / 100

			--IMBAfication: Proton Explosion
			self:SetStackCount(self:GetStackCount() + math.floor(damage_dealt))
		end
	end
end

function modifier_imba_dark_seer_ion_shell:OnDestroy()
	if not IsServer() then return end

	self:GetParent():EmitSound("Hero_Dark_Seer.Ion_Shield_end")

	if self:GetRemainingTime() <= 0 then
		self:GetParent():EmitSound("Hero_Abaddon.AphoticShield.Destroy")

		local particle = ParticleManager:CreateParticle("particles/econ/items/abaddon/abaddon_alliance/abaddon_aphotic_shield_alliance_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(particle)

		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.proton_explosion_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		for _, enemy in pairs(enemies) do
			if enemy ~= self:GetParent() then
				local damageTable = {
					victim       = enemy,
					damage       = self:GetStackCount(),
					damage_type  = DAMAGE_TYPE_MAGICAL,
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					attacker     = self:GetCaster(),
					ability      = self:GetAbility()
				}

				ApplyDamage(damageTable)

				-- Only reapply the ability if it exists and they don't already have a shield
				if self:GetCaster() and self:GetAbility() and not enemy:FindModifierByNameAndCaster("modifier_imba_dark_seer_ion_shell", self:GetCaster()) then
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_dark_seer_ion_shell", { duration = self:GetAbility():GetSpecialValueFor("duration") * (1 - enemy:GetStatusResistance()) })
				end
			end
		end
	end
end

-- function modifier_imba_dark_seer_ion_shell:CheckState()
-- if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
-- return {[MODIFIER_STATE_INVISIBLE] = false}
-- end
-- end

function modifier_imba_dark_seer_ion_shell:DeclareFunctions()
	return { MODIFIER_PROPERTY_PROVIDES_FOW_POSITION }
end

function modifier_imba_dark_seer_ion_shell:GetModifierProvidesFOWVision()
	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		return 1
	else
		return 0
	end
end

------------------------------------------------
-- MODIFIER_IMBA_DARK_SEER_ION_SHELL_NEGATION --
------------------------------------------------

function modifier_imba_dark_seer_ion_shell_negation:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.damage_per_second       = self:GetAbility():GetTalentSpecialValueFor("damage_per_second")
	self.proton_explosion_radius = self:GetAbility():GetSpecialValueFor("proton_explosion_radius")
	self.proton_damage_pct       = self:GetAbility():GetSpecialValueFor("proton_damage_pct")

	self.interval                = 0.1

	if not IsServer() then return end

	self.radius       = self:GetAbility():GetTalentSpecialValueFor("radius")
	self.damage_table = {
		victim       = self:GetParent(),
		damage       = self.damage_per_second * self.interval,
		damage_type  = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		attacker     = self:GetCaster(),
		ability      = self:GetAbility()
	}

	self:GetParent():EmitSound("Hero_Dark_Seer.Ion_Shield_lp")

	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_ion_shell.vpcf", PATTACH_POINT_FOLLOW, self:GetParent(), self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius, self.radius, self.radius))
	self:AddParticle(self.particle, false, false, -1, false, false)

	self:SetStackCount(0)

	self:StartIntervalThink(self.interval)
end

function modifier_imba_dark_seer_ion_shell_negation:OnRefresh()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.damage_per_second = self:GetAbility():GetTalentSpecialValueFor("damage_per_second")

	if not IsServer() then return end

	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius, self.radius, self.radius))

	self:SetStackCount(0)
end

function modifier_imba_dark_seer_ion_shell_negation:OnIntervalThink()
	if not IsServer() then return end

	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, unit in pairs(units) do
		if unit ~= self:GetParent() then
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_ion_shell_damage.vpcf", PATTACH_POINT, self:GetParent(), self:GetCaster())
			ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle)

			-- This is to retroactively upgrade any existing Ion Shells with talent acquisition
			if self:GetAbility() then
				self.damage_per_second = self:GetAbility():GetTalentSpecialValueFor("damage_per_second")
			end

			if unit:GetTeamNumber() == self:GetParent():GetTeamNumber() then
				self.damage_table.damage = self.damage_per_second * self.interval
			else
				self.damage_table.damage = self.damage_per_second * self.interval * 0.5
			end

			--IMBAfication: Proton Explosion
			self:SetStackCount(self:GetStackCount() + math.floor(ApplyDamage(self.damage_table) * self.proton_damage_pct / 100))
		end
	end
end

function modifier_imba_dark_seer_ion_shell_negation:OnDestroy()
	if not IsServer() then return end

	self:GetParent():EmitSound("Hero_Dark_Seer.Ion_Shield_end")

	if self:GetRemainingTime() <= 0 then
		self:GetParent():EmitSound("Hero_Abaddon.AphoticShield.Destroy")

		local particle = ParticleManager:CreateParticle("particles/econ/items/abaddon/abaddon_alliance/abaddon_aphotic_shield_alliance_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(particle)

		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.proton_explosion_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		for _, enemy in pairs(enemies) do
			if enemy ~= self:GetParent() then
				ApplyDamage({
					victim       = enemy,
					damage       = self:GetStackCount(),
					damage_type  = DAMAGE_TYPE_MAGICAL,
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					attacker     = self:GetCaster(),
					ability      = self:GetAbility()
				})

				-- Only reapply the ability if it exists and they don't already have a shield
				if self:GetCaster() and self:GetAbility() and not enemy:FindModifierByNameAndCaster("modifier_imba_dark_seer_ion_shell_negation", self:GetCaster()) then
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_dark_seer_ion_shell_negation", { duration = self:GetAbility():GetSpecialValueFor("duration") * (1 - enemy:GetStatusResistance()) })
				end
			end
		end
	end
end

function modifier_imba_dark_seer_ion_shell_negation:DeclareFunctions()
	return { MODIFIER_PROPERTY_PROVIDES_FOW_POSITION }
end

function modifier_imba_dark_seer_ion_shell_negation:GetModifierProvidesFOWVision()
	return 1
end

-----------
-- SURGE --
-----------

function imba_dark_seer_surge:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():FindTalentValue("special_bonus_imba_dark_seer_surge_cast_range")
end

function imba_dark_seer_surge:GetAOERadius()
	return self:GetSpecialValueFor("surge_radius")
end

function imba_dark_seer_surge:OnSpellStart()
	if not IsServer() then return end

	local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("surge_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	if #allies > 0 then
		EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "Hero_Dark_Seer.Surge", self:GetCaster())
	end

	-- IMBAfication: Group Advancement
	for _, ally in pairs(allies) do
		ally:AddNewModifier(self:GetCaster(), self, "modifier_imba_dark_seer_surge", { duration = self:GetSpecialValueFor("duration") })
	end

	-- IMBAfication: Sonic Boom
	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("surge_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		enemy:EmitSound("Hero_Dark_Seer.Surge_Sonic_Boom")

		enemy:AddNewModifier(self:GetCaster(), self, "modifier_generic_motion_controller",
			{
				distance               = self:GetSpecialValueFor("sonic_boom_knockback_speed") * self:GetSpecialValueFor("sonic_boom_knockback_duration"),
				direction_x            = (enemy:GetAbsOrigin() - self:GetCursorPosition()):Normalized().x,
				direction_y            = (enemy:GetAbsOrigin() - self:GetCursorPosition()):Normalized().y,
				direction_z            = (enemy:GetAbsOrigin() - self:GetCursorPosition()):Normalized().z,
				duration               = self:GetSpecialValueFor("sonic_boom_knockback_duration"),
				height                 = 0,
				bGroundStop            = false,
				bDecelerate            = false,
				bInterruptible         = false,
				bIgnoreTenacity        = true,
				bTreeRadius            = enemy:GetHullRadius(),
				bStun                  = false,
				bDestroyTreesAlongPath = true
			})

		enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_dark_seer_surge_slow", { duration = self:GetSpecialValueFor("sonic_boom_move_speed_duration") * (1 - enemy:GetStatusResistance()) })

		ApplyDamage({
			victim       = enemy,
			damage       = self:GetSpecialValueFor("sonic_boom_damage"),
			damage_type  = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self:GetCaster(),
			ability      = self
		})
	end
end

--------------------
-- SURGE MODIFIER --
--------------------

function modifier_imba_dark_seer_surge:GetEffectName()
	return "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf"
end

function modifier_imba_dark_seer_surge:OnCreated()
	self.speed_boost = self:GetAbility():GetSpecialValueFor("speed_boost")

	self.speed       = self:GetParent():GetIdealSpeedNoSlows()
end

function modifier_imba_dark_seer_surge:OnRefresh()
	self:OnCreated()
end

function modifier_imba_dark_seer_surge:CheckState()
	return {
		[MODIFIER_STATE_UNSLOWABLE]        = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end

function modifier_imba_dark_seer_surge:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}
end

function modifier_imba_dark_seer_surge:GetModifierMoveSpeedBonus_Constant()
	return self.speed_boost
end

function modifier_imba_dark_seer_surge:GetModifierIgnoreMovespeedLimit()
	return 1
end

----------------------------------------
-- MODIFIER_IMBA_DARK_SEER_SURGE_SLOW --
----------------------------------------

function modifier_imba_dark_seer_surge_slow:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf"
end

function modifier_imba_dark_seer_surge_slow:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.sonic_boom_move_speed_slow = self:GetAbility():GetSpecialValueFor("sonic_boom_move_speed_slow") * (-1)
	self.sonic_boom_miss_percentage = self:GetAbility():GetSpecialValueFor("sonic_boom_miss_percentage")
end

function modifier_imba_dark_seer_surge_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MISS_PERCENTAGE
	}
end

function modifier_imba_dark_seer_surge_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.sonic_boom_move_speed_slow
end

function modifier_imba_dark_seer_surge_slow:GetModifierMiss_Percentage()
	return self.sonic_boom_miss_percentage
end

---------------------------------
-- IMBA_DARK_SEER_CLOSE_PORTAL --
---------------------------------

function imba_dark_seer_close_portal:IsInnateAbility() return true end

function imba_dark_seer_close_portal:IsStealable() return false end

function imba_dark_seer_close_portal:GetIntrinsicModifierName()
	return "modifier_imba_dark_seer_close_portal"
end

function imba_dark_seer_close_portal:OnSpellStart()
	if self.entry_portal and not self.entry_portal:IsNull() then
		self.entry_portal:Destroy()
		self.entry_portal = nil
	end

	if self.exit_portal and not self.exit_portal:IsNull() then
		self.exit_portal:Destroy()
		self.exit_portal = nil
	end

	self:SetActivated(false)
end

------------------------------------------
-- MODIFIER_IMBA_DARK_SEER_CLOSE_PORTAL --
------------------------------------------

function modifier_imba_dark_seer_close_portal:IsHidden() return true end

function modifier_imba_dark_seer_close_portal:IsPurgable() return false end

function modifier_imba_dark_seer_close_portal:RemoveOnDeath() return false end

function modifier_imba_dark_seer_close_portal:OnCreated()
	if not IsServer() then return end

	if self:GetAbility() then
		self:GetAbility():SetActivated(false)
	end
end

---------------------
-- WALL OF REPLICA --
---------------------

function imba_dark_seer_wall_of_replica:OnSpellStart()
	if not IsServer() then return end

	local duration = self:GetSpecialValueFor("duration")

	--	if self:GetCaster():HasScepter() then
	--		duration = self:GetSpecialValueFor("scepter_duration")
	--	end

	EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "Hero_Dark_Seer.Wall_of_Replica_Start", self:GetCaster())

	-- Create the dual walls
	CreateModifierThinker(self:GetCaster(), self, "modifier_imba_dark_seer_wall_of_replica", {
			duration = duration,
			x        = self:GetCursorPosition().x,
			y        = self:GetCursorPosition().y,
			rotation = 45
		},
		self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)

	CreateModifierThinker(self:GetCaster(), self, "modifier_imba_dark_seer_wall_of_replica", {
			duration = duration,
			x        = self:GetCursorPosition().x,
			y        = self:GetCursorPosition().y,
			rotation = -45
		},
		self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
end

------------------------------
-- WALL OF REPLICA MODIFIER --
------------------------------

function modifier_imba_dark_seer_wall_of_replica:OnCreated(params)
	self.width                  = self:GetAbility():GetSpecialValueFor("width")
	self.thickness              = 50 -- Why is this not in vanilla AbilitySpecials?
	self.slow_duration          = self:GetAbility():GetTalentSpecialValueFor("slow_duration")
	self.movement_slow          = self:GetAbility():GetSpecialValueFor("movement_slow")
	self.scepter_rotation_speed = self:GetAbility():GetSpecialValueFor("scepter_rotation_speed")
	self.minimum_interval       = self:GetAbility():GetSpecialValueFor("minimum_interval")

	self.scepter                = self:GetCaster():HasScepter()

	if self.scepter then
		self.width = self:GetAbility():GetSpecialValueFor("scepter_width")
	end

	if not IsServer() then return end

	self:GetParent():EmitSound("Hero_Dark_Seer.Wall_of_Replica_lp")

	self.rotation        = params.rotation

	-- Calculate wall start and end positions
	self.cursor_position = GetGroundPosition(Vector(params.x, params.y, 0), nil)

	self.distance_vector = self.cursor_position - self:GetCaster():GetAbsOrigin()

	self.wall_vector     = RotatePosition(Vector(0, 0, 0), QAngle(0, params.rotation, 0), self.distance_vector:Normalized())

	self.wall_start      = self.cursor_position + self.wall_vector * self.width * 0.5
	self.wall_end        = self.cursor_position - self.wall_vector * self.width * 0.5

	self.particle        = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_wall_of_replica.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(self.particle, 0, self.wall_start)
	ParticleManager:SetParticleControl(self.particle, 1, self.wall_end)

	-- Weird colours because it's fun?
	self.random_int_1 = RandomInt(0, 255)
	self.random_int_2 = RandomInt(0, 255)
	self.random_int_3 = RandomInt(0, 255)

	self.scale_1      = RandomInt(3, 6)
	self.scale_2      = RandomInt(3, 6)
	self.scale_3      = RandomInt(3, 6)

	ParticleManager:SetParticleControl(self.particle, 60, Vector(self.random_int_1, self.random_int_2, self.random_int_3))
	ParticleManager:SetParticleControl(self.particle, 61, Vector(1, 0, 0))

	self:AddParticle(self.particle, false, false, -1, false, false)

	self:StartIntervalThink(0.1)
end

function modifier_imba_dark_seer_wall_of_replica:OnIntervalThink()
	if not IsServer() then return end

	-- Too laggy I guess, with all the particle creation/re-creation...
	-- if self.scepter then
	-- self.rotation			= self.rotation + self.scepter_rotation_speed * 0.1

	-- self.wall_vector		= RotatePosition(Vector(0, 0, 0), QAngle(0, self.rotation, 0), self.distance_vector:Normalized())

	-- self.wall_start 		= self.cursor_position + self.wall_vector * self.width * 0.5
	-- self.wall_end			= self.cursor_position - self.wall_vector * self.width * 0.5

	-- -- This is probably hyper-inefficient to constantly destroy and recreate the particle, but quick test of entity attachment didn't work
	-- -- Also this might require a epileptic warning
	-- ParticleManager:DestroyParticle(self.particle, false)
	-- ParticleManager:ReleaseParticleIndex(self.particle)

	-- self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_wall_of_replica.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	-- ParticleManager:SetParticleControl(self.particle, 0, self.wall_start)
	-- ParticleManager:SetParticleControl(self.particle, 1, self.wall_end)
	-- ParticleManager:SetParticleControl(self.particle, 61, Vector(1, 0, 0))
	-- self:AddParticle(self.particle, false, false, -1, false, false)
	-- end

	-- -- All of this code text is just to mess around with colours
	-- self.random_int_1		= self.random_int_1 + self.scale_1
	-- self.random_int_2		= self.random_int_2 + self.scale_2
	-- self.random_int_3		= self.random_int_3 + self.scale_3

	-- if self.random_int_1 >= 255 then
	-- self.random_int_1 = 255
	-- self.scale_1 = RandomInt(-3, -6)
	-- elseif self.random_int_1 <= 0 then
	-- self.random_int_1 = 0
	-- self.scale_1 = RandomInt(3, 6)
	-- end

	-- if self.random_int_2 >= 255 then
	-- self.random_int_2 = 255
	-- self.scale_2 = RandomInt(-3, -6)
	-- elseif self.random_int_1 <= 0 then
	-- self.random_int_2 = 0
	-- self.scale_2 = RandomInt(3, 6)
	-- end

	-- if self.random_int_3 >= 255 then
	-- self.random_int_3 = 255
	-- self.scale_3 = RandomInt(-3, -6)
	-- elseif self.random_int_3 <= 0 then
	-- self.random_int_3 = 0
	-- self.scale_3 = RandomInt(3, 6)
	-- end

	-- ParticleManager:SetParticleControl(self.particle, 60, Vector(self.random_int_1, self.random_int_2, self.random_int_3))

	-- Okay now for actual logic
	-- This is to retroactively upgrade any existing walls with talent acquisition
	if self:GetAbility() then
		self.slow_duration = self:GetAbility():GetTalentSpecialValueFor("slow_duration")
	end

	for _, enemy in pairs(FindUnitsInLine(self:GetCaster():GetTeamNumber(), self.wall_start, self.wall_end, nil, self.thickness, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)) do
		self.wall_slow_modifier = enemy:FindModifierByNameAndCaster("modifier_imba_dark_seer_wall_of_replica_slow", self:GetParent())

		if self.wall_slow_modifier then
			self.wall_slow_modifier:SetDuration(self.slow_duration * (1 - enemy:GetStatusResistance()), true)
		else
			enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_dark_seer_wall_of_replica_slow", {
				duration         = self.slow_duration * (1 - enemy:GetStatusResistance()),
				movement_slow    = self.movement_slow,
				minimum_interval = self.minimum_interval
			})
		end
	end
end

function modifier_imba_dark_seer_wall_of_replica:OnDestroy()
	if not IsServer() then return end

	self:GetParent():StopSound("Hero_Dark_Seer.Wall_of_Replica_lp")

	-- Seems like the walls are STILL making people lag? I don't know if this will solve anything anymore.
	self:GetParent():RemoveSelf()
end

-----------------------------------
-- WALL OF REPLICA SLOW MODIFIER --
-----------------------------------

function modifier_imba_dark_seer_wall_of_replica_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_seer_illusion.vpcf"
end

function modifier_imba_dark_seer_wall_of_replica_slow:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_dark_seer_wall_of_replica_slow:OnCreated(params)
	if not IsServer() then return end

	self.minimum_interval = params.minimum_interval

	self:SetStackCount(params.movement_slow * (-1))

	self:StartIntervalThink(math.max(self:GetParent():GetSecondsPerAttack(), self.minimum_interval))
end

function modifier_imba_dark_seer_wall_of_replica_slow:OnIntervalThink()
	if not IsServer() then return end

	if not self:GetParent():IsInvulnerable() then
		self:GetParent():PerformAttack(self:GetParent(), true, true, true, true, true, false, false)
	end

	self:StartIntervalThink(math.max(self:GetParent():GetSecondsPerAttack(), self.minimum_interval))
end

function modifier_imba_dark_seer_wall_of_replica_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT
	}
end

function modifier_imba_dark_seer_wall_of_replica_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

-- Is this how you use the function?
function modifier_imba_dark_seer_wall_of_replica_slow:OnTakeDamageKillCredit(keys)
	if keys.target == self:GetParent() and self:GetParent():GetHealth() <= keys.damage then
		if keys.attacker == self:GetParent() then
			self:GetParent():Kill(self:GetAbility(), self:GetCaster())
		else
			self:GetParent():Kill(self:GetAbility(), keys.attacker)
		end
	end
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_dark_seer_ion_shell_radius", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_dark_seer_vacuum_increased_duration", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_dark_seer_wall_of_replica_increased_slow_duration", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_dark_seer_ion_shell_damage", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_dark_seer_ion_shell_radius = modifier_special_bonus_imba_dark_seer_ion_shell_radius or class({})
modifier_special_bonus_imba_dark_seer_vacuum_increased_duration = modifier_special_bonus_imba_dark_seer_vacuum_increased_duration or class({})
modifier_special_bonus_imba_dark_seer_wall_of_replica_increased_slow_duration = modifier_special_bonus_imba_dark_seer_wall_of_replica_increased_slow_duration or class({})
modifier_special_bonus_imba_dark_seer_ion_shell_damage = modifier_special_bonus_imba_dark_seer_ion_shell_damage or class({})

function modifier_special_bonus_imba_dark_seer_ion_shell_radius:IsHidden() return true end

function modifier_special_bonus_imba_dark_seer_ion_shell_radius:IsPurgable() return false end

function modifier_special_bonus_imba_dark_seer_ion_shell_radius:RemoveOnDeath() return false end

function modifier_special_bonus_imba_dark_seer_vacuum_increased_duration:IsHidden() return true end

function modifier_special_bonus_imba_dark_seer_vacuum_increased_duration:IsPurgable() return false end

function modifier_special_bonus_imba_dark_seer_vacuum_increased_duration:RemoveOnDeath() return false end

function modifier_special_bonus_imba_dark_seer_wall_of_replica_increased_slow_duration:IsHidden() return true end

function modifier_special_bonus_imba_dark_seer_wall_of_replica_increased_slow_duration:IsPurgable() return false end

function modifier_special_bonus_imba_dark_seer_wall_of_replica_increased_slow_duration:RemoveOnDeath() return false end

function modifier_special_bonus_imba_dark_seer_ion_shell_damage:IsHidden() return true end

function modifier_special_bonus_imba_dark_seer_ion_shell_damage:IsPurgable() return false end

function modifier_special_bonus_imba_dark_seer_ion_shell_damage:RemoveOnDeath() return false end

LinkLuaModifier("modifier_special_bonus_imba_dark_seer_surge_cast_range", "components/abilities/heroes/hero_dark_seer", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_dark_seer_surge_cast_range = modifier_special_bonus_imba_dark_seer_surge_cast_range or class({})

function modifier_special_bonus_imba_dark_seer_surge_cast_range:IsHidden() return true end

function modifier_special_bonus_imba_dark_seer_surge_cast_range:IsPurgable() return false end

function modifier_special_bonus_imba_dark_seer_surge_cast_range:RemoveOnDeath() return false end

function imba_dark_seer_surge:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_dark_seer_surge_cast_range") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_dark_seer_surge_cast_range") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_dark_seer_surge_cast_range"), "modifier_special_bonus_imba_dark_seer_surge_cast_range", {})
	end
end
