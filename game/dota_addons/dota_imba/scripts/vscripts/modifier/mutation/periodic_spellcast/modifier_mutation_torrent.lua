modifier_mutation_torrent = class({})

function modifier_mutation_torrent:IsHidden() return true end
function modifier_mutation_torrent:IsDebuff() return true end
function modifier_mutation_torrent:IsPurgable() return false end

function modifier_mutation_torrent:OnCreated()
	if IsClient() then return end
	self.delay = 1.6
	self.radius = 225
	local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, 30)
	self.damage = 250 + (50 * game_time)
	self.pos = self:GetParent():GetAbsOrigin()
	self.tick_count = 10
	self.height = 400
	self.stun_duration = 1.6

	EmitSoundOn("Ability.pre.Torrent", self:GetParent())

	local particle = ParticleManager:CreateParticleForTeam("particles/hero/kunkka/torrent_bubbles.vpcf", PATTACH_ABSORIGIN, self:GetParent(), self:GetParent():GetTeamNumber())
	ParticleManager:SetParticleControl(particle, 0, self.pos)
	ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle)

	Timers:CreateTimer(self.delay, function()
		ParticleManager:DestroyParticle(particle, false)
		ParticleManager:ReleaseParticleIndex(particle)

		-- Finds affected enemies
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		-- Iterate through affected enemies
		for _,enemy in pairs(enemies) do
			-- Deals the initial damage
			ApplyDamage({victim = enemy, attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})

			local current_ticks = 0
			local randomness_x = 0
			local randomness_y = 0

			-- Calculates the knockback position (for Tsunami)
			local torrent_border = ( enemy:GetAbsOrigin() - self.pos ):Normalized() * ( self.radius + 100 )
			local distance_from_center = ( enemy:GetAbsOrigin() - self.pos ):Length2D()
--			distance_from_center = 0

			-- Some randomness to tsunami-torrent for smoother animation
			randomness_x = math.random() * math.random(-30,30)
			randomness_y = math.random() * math.random(-30,30)

			-- Knocks the target up
			local knockback =
			{
				should_stun = 1,
				knockback_duration = self.stun_duration,
				duration = self.stun_duration,
				knockback_distance = distance_from_center,
				knockback_height = self.height,
				center_x = (self.pos + torrent_border).x + randomness_x,
				center_y = (self.pos + torrent_border).y + randomness_y,
				center_z = (self.pos + torrent_border).z
			}

			-- Apply knockback on enemies hit
			enemy:RemoveModifierByName("modifier_knockback")
			enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
			enemy:AddNewModifier(caster, self, "modifier_phased", {duration = self.stun_duration})

			-- Deals tick damage tick_count times
			Timers:CreateTimer(function()
				if current_ticks < self.tick_count then
					ApplyDamage({victim = enemy, attacker = self:GetCaster(), damage = self.damage / self.tick_count, damage_type = DAMAGE_TYPE_MAGICAL})
					current_ticks = current_ticks + 1
					return 1.0
				end
			end)

			enemy:AddNewModifier(caster, self, "modifier_mutation_torrent_slow", {duration = 5.0})
		end

		-- Creates the post-ability sound effect
		EmitSoundOnLocationWithCaster(self.pos, "Ability.Torrent", caster)

		-- Draws the particle
		local particle = "particles/hero/kunkka/torrent_splash.vpcf"
		local torrent_fx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(torrent_fx, 0, self.pos)
		ParticleManager:SetParticleControl(torrent_fx, 1, Vector(self.radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(torrent_fx)

		-- SUPER DUPER HYPER torrent animation if tsunami
--		if torrent_count == 0 and tsunami then
--			local torrent_tsunami_fx = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_whaleblade/kunkka_spell_torrent_whaleblade_tail.vpcf", PATTACH_CUSTOMORIGIN, caster)
--			ParticleManager:SetParticleControl(torrent_tsunami_fx, 0, self.pos)
--			ParticleManager:ReleaseParticleIndex(torrent_tsunami_fx)

--			local count_mini = math.floor(radius / 35)
--			for i = 0, count_mini, 1
--			do
--				Timers:CreateTimer(math.random(80)*0.01, function()
--					local radius_mini = math.random(50)+15
--					local angle = (360 / count_mini) * i
--					local border = radius - radius_mini
--					local mini_target = self.pos + Vector( math.cos(angle) * border , math.sin(angle) * border , 0 )
--					local torrent_fx_mini = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
--					ParticleManager:SetParticleControl(torrent_fx_mini, 0, mini_target)
--					ParticleManager:SetParticleControl(torrent_fx_mini, 1, Vector(radius_mini,0,0))
--					ParticleManager:ReleaseParticleIndex(torrent_fx_mini)
--				end)
--			end
--		end
	end)
end

LinkLuaModifier("modifier_mutation_torrent_slow", "modifier/mutation/periodic_spellcast/modifier_mutation_torrent.lua", LUA_MODIFIER_MOTION_NONE )

modifier_mutation_torrent_slow = class({})

function modifier_mutation_torrent_slow:IsHidden() return false end
function modifier_mutation_torrent_slow:IsDebuff() return true end
function modifier_mutation_torrent_slow:IsPurgable() return false end

function modifier_mutation_torrent_slow:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return decFuncs
end

function modifier_mutation_torrent_slow:OnCreated()
	self.slow = 20
end

function modifier_mutation_torrent_slow:GetModifierMoveSpeedBonus_Percentage( )
	return self.slow * (-1)
end
