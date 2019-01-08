modifier_mutation_torrent = class({})

function modifier_mutation_torrent:IsHidden() return true end
function modifier_mutation_torrent:IsDebuff() return true end
function modifier_mutation_torrent:IsPurgable() return false end
function modifier_mutation_torrent:RemoveOnDeath() return false end

function modifier_mutation_torrent:OnCreated()
	if IsClient() then return end
	self.delay = 1.6
	self.radius = 225
	local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, 30)
	self.damage = 250 + (50 * game_time)
	self.tick_damage = 250 + (25 * game_time)
	self.pos = self:GetParent():GetAbsOrigin()
	self.tick_count = 10
	self.height = 400
	self.stun_duration = 1.6

	EmitSoundOn("Ability.pre.Torrent", self:GetParent())

	self.team_pfx = ParticleManager:CreateParticle("particles/hero/kunkka/torrent_bubbles.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(self.team_pfx, 0, self.pos)
	ParticleManager:SetParticleControl(self.team_pfx, 1, Vector(self.radius, 0, 0))

	Timers:CreateTimer(self.delay, function()
		-- Finds affected enemies
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		-- Iterate through affected enemies
		for _,enemy in pairs(enemies) do
			local current_ticks = 1
			local randomness_x = 0
			local randomness_y = 0

			-- Calculates the knockback position (for Tsunami)
			local torrent_border = ( enemy:GetAbsOrigin() - self.pos ):Normalized() * ( self.radius + 100 )
			local distance_from_center = ( enemy:GetAbsOrigin() - self.pos ):Length2D()

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
            if not enemy:IsMagicImmune() then
    			-- Apply knockback on enemies hit
    			enemy:RemoveModifierByName("modifier_knockback")
    			enemy:AddNewModifier(self:GetCaster(), self, "modifier_knockback", knockback)
    			enemy:AddNewModifier(self:GetCaster(), self, "modifier_phased", {duration = self.stun_duration})
    
    			-- Add dot dealing damage every sec for 10 sec (if target is alive)
    			enemy:AddNewModifier(self:GetCaster(), self, "modifier_mutation_torrent_dot", {duration = 3, damage = (self.tick_damage / 10), damage_interval = (self.stun_duration / 10)})
    			enemy:AddNewModifier(self:GetCaster(), self, "modifier_mutation_torrent_slow", {duration = 8.0})
    
    			-- Lastly deal initial hit damage
    			ApplyDamage({victim = enemy, attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
    		end
		end

		-- Creates the post-ability sound effect
		EmitSoundOnLocationWithCaster(self.pos, "Ability.Torrent", self:GetCaster())

		-- Draws the particle
		local particle = "particles/hero/kunkka/torrent_splash.vpcf"
		self.particle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(self.particle, 0, self.pos)
		ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(self.particle)
	end)
end

function modifier_mutation_torrent:OnRemoved()
	if IsServer() then
		if self.particle then
			ParticleManager:DestroyParticle(self.particle, true)
		end

		if self.team_pfx then
			ParticleManager:DestroyParticle(self.team_pfx, true)
		end
	end
end

LinkLuaModifier("modifier_mutation_torrent_slow", "components/modifiers/mutation/periodic_spellcast/modifier_mutation_torrent.lua", LUA_MODIFIER_MOTION_NONE )

modifier_mutation_torrent_slow = class({})
function modifier_mutation_torrent_slow:GetTexture()
	return "kunkka_torrent"
end

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

function modifier_mutation_torrent_slow:OnRemoved()
	if IsServer() then
		if self:GetParent():HasModifier("modifier_mutation_torrent") then
			self:GetParent():RemoveModifierByName("modifier_mutation_torrent")
		end
	end
end

function modifier_mutation_torrent_slow:GetModifierMoveSpeedBonus_Percentage( )
	return self.slow * (-1)
end

LinkLuaModifier("modifier_mutation_torrent_dot", "components/modifiers/mutation/periodic_spellcast/modifier_mutation_torrent.lua", LUA_MODIFIER_MOTION_NONE )

modifier_mutation_torrent_dot = class({})
function modifier_mutation_torrent_dot:IsDebuff() return true end
function modifier_mutation_torrent_dot:IsHidden() return true end
function modifier_mutation_torrent_dot:OnCreated(kv) 
	if IsServer() then
		self.damage = kv.damage

		-- dmg loop, trigger each second
		self:StartIntervalThink(kv.damage_interval)
	end
end

function modifier_mutation_torrent_dot:OnIntervalThink()
	if self:GetParent():IsAlive() and self:GetCaster() ~= nil then
		ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end