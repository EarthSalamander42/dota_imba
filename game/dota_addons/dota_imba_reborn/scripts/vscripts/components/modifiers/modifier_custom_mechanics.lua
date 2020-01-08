--[[	Generic talent multihandler (uses stacks to communicate CDR to client)
		Author: Firetoad
		Date:	13.03.2017	]]

if modifier_custom_mechanics == nil then modifier_custom_mechanics = class({}) end
function modifier_custom_mechanics:IsHidden() return true end
function modifier_custom_mechanics:IsDebuff() return false end
function modifier_custom_mechanics:IsPurgable() return false end
function modifier_custom_mechanics:IsPermanent() return true end

function modifier_custom_mechanics:OnCreated()
	if IsServer() then
		self.health_regen_amp = 0
		
		self.forbidden_inflictors = {
			"item_imba_blade_mail",
			"luna_moon_glaive"
		}
		
		self:StartIntervalThink(1)
	end
end

function modifier_custom_mechanics:OnIntervalThink()
	-- Rough Out of Bounds warp back logic
	if self:GetParent():GetAbsOrigin().x >= 8000 then
		FindClearSpaceForUnit(self:GetParent(), GetGroundPosition(Vector(7500, self:GetParent():GetAbsOrigin().y, self:GetParent():GetAbsOrigin().z), nil), true)
	elseif self:GetParent():GetAbsOrigin().x <= -8000 then
		FindClearSpaceForUnit(self:GetParent(), GetGroundPosition(Vector(-7500, self:GetParent():GetAbsOrigin().y, self:GetParent():GetAbsOrigin().z), nil), true)
	elseif self:GetParent():GetAbsOrigin().y >= 8000 then
		FindClearSpaceForUnit(self:GetParent(), GetGroundPosition(Vector(self:GetParent():GetAbsOrigin().x, 7500, self:GetParent():GetAbsOrigin().z), nil), true)
	elseif self:GetParent():GetAbsOrigin().y <= -8000 then
		FindClearSpaceForUnit(self:GetParent(), GetGroundPosition(Vector(self:GetParent():GetAbsOrigin().x, -7500, self:GetParent():GetAbsOrigin().z), nil), true)
	end
end


-- Damage block handler
-- function modifier_custom_mechanics:GetModifierPhysical_ConstantBlock()
	-- if IsServer() then
		-- return self:GetParent():GetDamageBlock()
	-- end
-- end

-- Damage amp/reduction handler
function modifier_custom_mechanics:GetModifierIncomingDamage_Percentage()
	if IsServer() then
		return self:GetParent():GetIncomingDamagePct()
	end
end

function modifier_custom_mechanics:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
	
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		-- MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
--		MODIFIER_PROPERTY_RESPAWNTIME,
--		MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE,
	}
	return funcs
end

function modifier_custom_mechanics:GetModifierHealthBonus()
	return 300
end

-- Spell lifesteal handler
function modifier_custom_mechanics:OnTakeDamage( keys )
	if keys.attacker == self:GetParent() and keys.inflictor then

		-- -- Calculate the amount of lifesteal
		-- local lifesteal_amount = self:GetParent():GetSpellLifesteal()

		-- Do nothing if the victim is not a valid keys.unit, or if the lifesteal amount is nonpositive
		if keys.unit:IsBuilding() or keys.unit:IsOther() or (keys.unit:GetTeam() == keys.attacker:GetTeam()) or (self:GetParent():GetSpellLifesteal() <= 0) or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return end

		-- Also do nothing if the inflictor is forbidden
		for _, forbidden_inflictor in pairs(self.forbidden_inflictors) do
			if keys.inflictor:GetName() == forbidden_inflictor then return end
		end
		
		-- Particle effect
		self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
		ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
		
		-- if keys.attacker:IsIllusion() or keys.unit:IsIllusion() then
			-- return
		-- end
		
		-- If the keys.unit is a real hero, heal for the full value
		--if keys.unit:IsRealHero() then
			keys.attacker:Heal(math.max(keys.damage, 0) * self:GetParent():GetSpellLifesteal() * 0.01, keys.attacker) -- IDK if this will fix it but there's reports of health randomly getting deleted and I assume it has to do with the custom lifesteal

		-- else, heal for half of it
		--else
		--	keys.attacker:Heal(math.max(keys.damage, 0) * self:GetParent():GetSpellLifesteal() * 0.005, keys.attacker)
		--end
	end
end

-- Test fix for invincible 0 HP illusions
-- function modifier_custom_mechanics:OnAttackStart( keys )
	-- if not IsServer() then return end
	
	-- -- Don't know if this is going to work but might as well try something to remedy the illusion issue
	-- if self:GetParent() == keys.attacker and not self:GetParent():IsRealHero() and self:GetParent():GetHealth() <= 0 then
		-- UTIL_Remove(self:GetParent())
	-- end
-- end

-- Regular lifesteal handler
function modifier_custom_mechanics:OnAttackLanded( keys )
	-- If this attack was not performed by the modifier's self:GetParent(), do nothing
	if self:GetParent() ~= keys.attacker then
		return end

	-- Attempted fixing of invulnerable 0 hp illusions...again
	if not keys.attacker:IsRealHero() and (keys.attacker:GetMaxHealth() <= 0 or keys.attacker:GetHealth() <= 0) then
		keys.attacker:SetMaxHealth(keys.attacker:GetBaseMaxHealth())
		keys.attacker:SetHealth(1)
	end
	
	-- Else, keep going
	
	-- If there's no valid keys.target, or lifesteal amount, do nothing
	if keys.target:IsBuilding() or keys.target:IsOther() or (keys.target:GetTeam() == keys.attacker:GetTeam()) or self:GetParent():GetLifesteal() <= 0 then
		return
	end

	-- Choose the particle to draw
	local lifesteal_particle = "particles/generic_gameplay/generic_lifesteal.vpcf"
	if self:GetParent():HasModifier("modifier_item_imba_vladmir_blood_aura") then
		lifesteal_particle = "particles/item/vladmir/vladmir_blood_lifesteal.vpcf"
	end

	-- Heal and fire the particle
	-- Calculate actual lifesteal amount
	keys.attacker:Heal(math.max(self:GetParent():GetRealDamageDone(keys.target), 0) * self:GetParent():GetLifesteal() / 100, keys.attacker)
	self.lifesteal_pfx = ParticleManager:CreateParticle(lifesteal_particle, PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
	ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
end

--[[
-- this function stack with actual respawn time, and when trying to call GetRespawnTime() or GetTimeUntilRespawn() game crash
function modifier_custom_mechanics:GetModifierConstantRespawnTime()
--	local respawn_time = self:GetParent():GetTimeUntilRespawn() / 2
	local respawn_time = _G.HERO_RESPAWN_TIME_PER_LEVEL[self:GetParent():GetLevel()]
	print("Respawn Time:", respawn_time)

	return respawn_time
end
--]]

--[[ Respawn time is always 1 second...
function modifier_custom_mechanics:GetModifierPercentageRespawnTime()
	return 50
end
--]]