imba_spectre_haunt = imba_spectre_haunt or class({})
LinkLuaModifier("modifier_imba_spectre_haunt_illusion", "hero/hero_spectre", LUA_MODIFIER_MOTION_NONE)

function imba_spectre_haunt:IsNetherWardStealable() return false end
function imba_spectre_haunt:GetAbilityTextureName() return "spectre_haunt" end
function imba_spectre_haunt:GetCastPoint() return 0.3 end
function imba_spectre_haunt:GetBackswingTime() return 0.5 end
function imba_spectre_haunt:GetAssociatedPrimaryAbilities() return "imba_spectre_reality" end

function imba_spectre_haunt:OnUpgrade()
	local reality_ability = self:GetCaster():FindAbilityByName("imba_spectre_reality")
	if reality_ability and reality_ability:GetLevel() < 1 then
		reality_ability:SetLevel(1)
	end
end

function imba_spectre_haunt:OnSpellStart()
	if not IsServer() then
		return
	end

	if not self.spawned_illusion then
		self.spawned_illusions = {}
	end
	self.expire_time = GameRules:GetGameTime() + self:GetSpecialValueFor("duration")

	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

	for _, enemy in pairs(enemies) do
		if enemy:IsRealHero() and enemy:IsAlive() then
			local enemy_position = enemy:GetAbsOrigin()
			local spawn_distance = 58 -- Vanilla Dota 2
			
			local spawn_angle = RandomInt(0, 90)
			local spawn_dx = spawn_distance * math.sin(spawn_angle)
			local spawn_dy = spawn_distance * math.cos(spawn_angle)
			-- Make 2 rolls to randomize the spawn position in a "good enough" way
			if RandomInt(0, 1) == 1 then
				spawn_dx = -spawn_dx
			end
			if RandomInt(0, 1) == 1 then
				spawn_dy = -spawn_dy
			end
			local spawn_pos = Vector(spawn_dx, spawn_dy, enemy_position.z)

			IllusionManager:CreateIllusion(caster, self, spawn_pos, caster, {additional_modifiers={"modifier_imba_spectre_haunt_illusion"}, controllable = 0}, enemy)

			EmitSoundOn("Hero_Spectre.Haunt", enemy)
		end
	end

	EmitSoundOn("Hero_Spectre.HauntCast", caster)
end

-- Spectre Illusion modifier (set absolute speed + command restrict + flying pathing)
modifier_imba_spectre_haunt_illusion = modifier_imba_spectre_haunt_illusion or class({})
function modifier_imba_spectre_haunt_illusion:IsPurgable() return false end
function modifier_imba_spectre_haunt_illusion:IsHidden() return true end

function modifier_imba_spectre_haunt_illusion:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	-- Target is initialized before modifiers are added/reset
	self.target = self.parent:GetAttackTarget()

	-- illusion index, since illusions aren't deleted - this is for Reality ability
	if self.ability.spawned_illusions then
		self.ability.spawned_illusions[#self.spawned_illusions] = self.parent
	end

	self.first_activation = true
	self.absolute_min_speed = 400 -- Vanilla Dota 2 has this as absolute speed (cannot be increased), but this is IMBA, so buff
	self.activation_delay = 1.0 -- Vanilla Doto again
	self.tick_rate = 1.0 -- ordering unit to attack/move-to once a second seems fair enough
	self.expire_time = GameRules:GetGameTime() + self:GetDuration()

	if IsServer() then
		self:StartIntervalThink(self.activation_delay)
	end
end

function modifier_imba_spectre_haunt_illusion:OnRefresh( kv )
	if IsServer() then
		-- If the cast happened before the previous one expired, don't delay the illusion activation (Refresher Orb shenanigans)
		-- Technically, this buffs dead illusions, because, if they are respawned via Refresher Orb, they won't have the delay
		if GameRules:GetGameTime() < self.expire_time then
			self.expire_time = GameRules:GetGameTime() + self:GetDuration()
			self:OnIntervalThink()
		else
			self.expire_time = GameRules:GetGameTime() + self:GetDuration()
			self:StartIntervalThink(-1)
			self:StartIntervalThink(self.activation_delay)
			self.first_activation = true
		end
	end
end

function modifier_imba_spectre_haunt_illusion:OnIntervalThink()
	print("modifier_imba_spectre_haunt_illusion:OnIntervalThink() called")

	if IsServer() then
		-- Just in case something weird happens, I'm not sure if modifiers stop intervalthinking if their duration expires, but they have DestroyOnExpire = false
		if self.expire_time < GameRules:GetGameTime() then
			self:StartIntervalThink(-1)
			return
		end

		if self.target and self.target:IsAlive() then
			if self.target:IsInvisible() then
				self.parent:MoveToNPC(self.target)
			else
				self.parent:MoveToTargetToAttack(self.target)
			end
		else
			self.parent:Stop()
		end
		--[[
		self.CheckState = function(self)
			return { [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
					 [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
					 [MODIFIER_STATE_UNSELECTABLE] = true}
		end
		]]

		-- If we were activated due to delay (rather than tickrate), set our interval to the tick rate
		if self.first_activation then
			self.first_activation = false
			self:StartIntervalThink(-1)
			self:StartIntervalThink(self.tick_rate)
		end
	end
end

function modifier_imba_spectre_haunt_illusion:CheckState()
	return { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true }
end

function modifier_imba_spectre_haunt_illusion:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN }
end

function modifier_imba_spectre_haunt_illusion:GetModifierMoveSpeed_AbsoluteMin()
	return self.absolute_min_speed
end

-----------------------------------------------------------------
-- Spectre's Reality
-----------------------------------------------------------------
imba_spectre_reality = imba_spectre_reality or class({})
function imba_spectre_reality:IsStealable() return false end
function imba_spectre_reality:IsNetherWardStealable() return false end
function imba_spectre_reality:GetCastPoint() return 0 end
function imba_spectre_reality:GetBackswingTime() return 0.7 end
function imba_spectre_reality:GetAbilityTextureName() return "spectre_reality" end

function imba_spectre_reality:OnSpellStart()
	if not IsServer() then
		return
	end

	local caster = self:GetCaster()

	local haunt_ability = caster:FindAbilityByName("imba_spectre_haunt")
	-- if we don't have the haunt ability (somehow), or the ability isn't currently active, don't do anything
	if not haunt_ability or haunt_ability.self.expire_time < GameRules:GetGameTime() then
		return
	end

	-- if haunt has spawned illusions, we loop through them to find active ones and check their distance to us
	-- to find the closest one
	if haunt_ability.spawned_illusions and #haunt_ability.spawned_illusions > 0 then
		local cursor_pos = self:GetCursorPosition()
		local closest_illusion
		for illusion in haunt_ability.spawned_illusions do
			if illusion.active == 1 then
				local distance = (cursor_pos - illusion:GetAbsOrigin()):Length2D()
				if ( not closest_illusion ) or distance < (cursor_pos - closest_illusion:GetAbsOrigin()):Length2D() then
					closest_illusion = illusion
				end
			end
		end

		-- If we found a closest illusion, swap our positions
		if closest_illusion then
			caster:SetAbsOrigin(closest_illusion:GetAbsOrigin())
			closest_illusion:SetAbsOrigin(cursor_pos)
			-- ...also set our attack target to the illusions target, for Quality of Life and less clicking
			caster:MoveToTargetToAttack(closest_illusion:GetAttackTarget())
		end	
	end
end