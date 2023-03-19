--[[	Generic talent multihandler (uses stacks to communicate CDR to client)
		Author: Firetoad
		Date:	13.03.2017	]]
if modifier_custom_mechanics == nil then modifier_custom_mechanics = class({}) end
function modifier_custom_mechanics:IsHidden() return true end

function modifier_custom_mechanics:IsPurgable() return false end

function modifier_custom_mechanics:RemoveOnDeath() return false end

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

--- Enum DamageCategory_t
-- DOTA_DAMAGE_CATEGORY_ATTACK = 1
-- DOTA_DAMAGE_CATEGORY_SPELL = 0
function modifier_custom_mechanics:OnTakeDamage(keys)
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		-- Spell lifesteal handler
		if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.inflictor and self:GetParent():GetSpellLifesteal() > 0 and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			-- Also do nothing if the inflictor is forbidden
			for _, forbidden_inflictor in pairs(self.forbidden_inflictors) do
				if keys.inflictor:GetName() == forbidden_inflictor then return end
			end

			-- Particle effect
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)

			-- "However, when attacking illusions, the heal is not affected by the illusion's changed incoming damage values."
			-- This is EXTREMELY rough because I am not aware of any functions that can explicitly give you the incoming/outgoing damage of an illusion, or to give you the "displayed" damage when you're hitting illusions, which show numbers as if you were hitting a non-illusion.
			if keys.unit:IsIllusion() then
				if keys.damage_type == DAMAGE_TYPE_PHYSICAL and keys.unit.GetPhysicalArmorValue and GetReductionFromArmor then
					keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetPhysicalArmorValue(false)))
				elseif keys.damage_type == DAMAGE_TYPE_MAGICAL and keys.unit.GetMagicalArmorValue then
					keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetMagicalArmorValue()))
				elseif keys.damage_type == DAMAGE_TYPE_PURE then
					keys.damage = keys.original_damage
				end
			end

			keys.attacker:Heal(math.max(keys.damage, 0) * self:GetParent():GetSpellLifesteal() / 100, keys.attacker) -- IDK if this will fix it but there's reports of health randomly getting deleted and I assume it has to do with the custom lifesteal
			-- Attack lifesteal handler
		elseif keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK and self:GetParent():GetLifesteal() > 0 then
			-- Attempted fixing of invulnerable 0 hp illusions...again
			if not keys.attacker:IsRealHero() and (keys.attacker:GetMaxHealth() <= 0 or keys.attacker:GetHealth() <= 0) then
				keys.attacker:SetMaxHealth(keys.attacker:GetBaseMaxHealth())
				keys.attacker:SetHealth(1)
			end

			-- Choose the particle to draw
			local lifesteal_particle = "particles/generic_gameplay/generic_lifesteal.vpcf"
			if self:GetParent():HasModifier("modifier_item_imba_vladmir_blood_aura") then
				lifesteal_particle = "particles/item/vladmir/vladmir_blood_lifesteal.vpcf"
			end

			-- Heal and fire the particle
			-- Calculate actual lifesteal amount

			-- This is a weird custom function...causes issues with Slardar's Rain Cloud among other things
			-- keys.attacker:Heal(math.max(self:GetParent():GetRealDamageDone(keys.target), 0) * self:GetParent():GetLifesteal() / 100, keys.attacker)

			self.lifesteal_pfx = ParticleManager:CreateParticle(lifesteal_particle, PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)

			-- "However, when attacking illusions, the heal is not affected by the illusion's changed incoming damage values."
			if keys.unit:IsIllusion() and keys.unit.GetPhysicalArmorValue and GetReductionFromArmor then
				keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetPhysicalArmorValue(false)))
			end

			keys.attacker:Heal(keys.damage * self:GetParent():GetLifesteal() / 100, keys.attacker)
		end
	end
end

-- Test fix for invincible 0 HP illusions
function modifier_custom_mechanics:OnAttackStart(keys)
	if not IsServer() then return end

	-- Don't know if this is going to work but might as well try something to remedy the illusion issue
	if keys.attacker == self:GetParent() and (self:GetParent():IsIllusion() and self:GetParent():GetHealth() <= 0) or (self:GetParent().GetPlayerID and self:GetParent():GetPlayerID() == -1 and not self:GetParent():GetName() == "npc_dota_target_dummy") then
		self:GetParent():ForceKill(false)
		self:GetParent():RemoveSelf()
	end
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
