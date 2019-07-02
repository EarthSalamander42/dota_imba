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
		self:StartIntervalThink(0.25)
	end
end

function modifier_custom_mechanics:OnIntervalThink()
	if IsServer() then
		-- Calculate current regen before this modifier
		local parent = self:GetParent()

		CustomNetTables:SetTableValue( "status_resistance", string.format("%d", self:GetParent():GetEntityIndex()) , { status_resistance = self:GetParent():GetStatusResistance() } )
		
		-- Rough Out of Bounds warp back logic
		if parent:GetAbsOrigin().x >= 8000 then
			FindClearSpaceForUnit(parent, GetGroundPosition(Vector(7500, parent:GetAbsOrigin().y, parent:GetAbsOrigin().z), nil), true)
		elseif parent:GetAbsOrigin().x <= -8000 then
			FindClearSpaceForUnit(parent, GetGroundPosition(Vector(-7500, parent:GetAbsOrigin().y, parent:GetAbsOrigin().z), nil), true)
		end
	end
end


-- Damage block handler
function modifier_custom_mechanics:GetModifierPhysical_ConstantBlock()
	if IsServer() then
		return self:GetParent():GetDamageBlock()
	end
end

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
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
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
	if IsServer() then
		local parent = self:GetParent()
		local caster = keys.attacker
		local target = keys.unit
		local damage = math.max(keys.damage, 0) -- IDK if this will fix it but there's reports of health randomly getting deleted and I assume it has to do with the custom lifesteal
		local damage_flags = keys.damage_flags
		local inflictor = keys.inflictor
		
		if caster == parent and inflictor then

			-- Calculate the amount of lifesteal
			local lifesteal_amount = parent:GetSpellLifesteal()

			-- Do nothing if the victim is not a valid target, or if the lifesteal amount is nonpositive
			if target:IsBuilding() or target:IsOther() or (target:GetTeam() == caster:GetTeam()) or (lifesteal_amount <= 0) or bit.band(damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
				return end

			-- Also do nothing if the inflictor is forbidden
			local forbidden_inflictors = {
				"item_imba_blade_mail",
				"luna_moon_glaive"
			}
			for _, forbidden_inflictor in pairs(forbidden_inflictors) do
				if inflictor:GetName() == forbidden_inflictor then return end
			end
			
			-- Particle effect
			local lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(lifesteal_pfx, 0, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
			
			-- if caster:IsIllusion() or target:IsIllusion() then
				-- return
			-- end
			
			-- If the target is a real hero, heal for the full value
			--if target:IsRealHero() then
				caster:Heal(damage * lifesteal_amount * 0.01, caster)

			-- else, heal for half of it
			--else
			--	caster:Heal(damage * lifesteal_amount * 0.005, caster)
			--end
		end
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
	if IsServer() then
		local parent = self:GetParent()
		local attacker = keys.attacker

		-- If this attack was not performed by the modifier's parent, do nothing
		if parent ~= attacker then
			return end

		-- Attempted fixing of invulnerable 0 hp illusions...again
		if not attacker:IsRealHero() and (attacker:GetMaxHealth() <= 0 or attacker:GetHealth() <= 0) then
			attacker:SetMaxHealth(attacker:GetBaseMaxHealth())
			attacker:SetHealth(1)
		end
		
		-- Else, keep going
		local target = keys.target
		local lifesteal_amount = parent:GetLifesteal()
		
		-- If there's no valid target, or lifesteal amount, do nothing
		if target:IsBuilding() or target:IsOther() or (target:GetTeam() == attacker:GetTeam()) or lifesteal_amount <= 0 then
			return
		end

		-- Calculate actual lifesteal amount
		local damage = math.max(parent:GetRealDamageDone(target), 0)
		local heal = damage * lifesteal_amount / 100


		-- Choose the particle to draw
		local lifesteal_particle = "particles/generic_gameplay/generic_lifesteal.vpcf"
		if parent:HasModifier("modifier_item_imba_vladmir_blood_aura") then
			lifesteal_particle = "particles/item/vladmir/vladmir_blood_lifesteal.vpcf"
		end

		-- Heal and fire the particle
		attacker:Heal(heal, attacker)
		local lifesteal_pfx = ParticleManager:CreateParticle(lifesteal_particle, PATTACH_ABSORIGIN_FOLLOW, attacker)
		ParticleManager:SetParticleControl(lifesteal_pfx, 0, attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
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