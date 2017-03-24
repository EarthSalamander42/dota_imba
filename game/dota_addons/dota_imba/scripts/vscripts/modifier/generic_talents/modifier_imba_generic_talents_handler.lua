--[[	Generic spell lifesteal talent (stack-based)
		Author: Firetoad
		Date:	13.03.2017	]]

if modifier_imba_generic_talents_handler == nil then modifier_imba_generic_talents_handler = class({}) end
function modifier_imba_generic_talents_handler:IsHidden() return true end
function modifier_imba_generic_talents_handler:IsDebuff() return false end
function modifier_imba_generic_talents_handler:IsPurgable() return false end
function modifier_imba_generic_talents_handler:IsHidden() return true end
function modifier_imba_generic_talents_handler:IsPermanent() return true end

function modifier_imba_generic_talents_handler:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

-- Damage block handler
function modifier_imba_generic_talents_handler:GetModifierPhysical_ConstantBlock()
	if IsServer() then
		return self:GetParent():GetDamageBlock()
	end
end

-- Damage amp/reduction handler
function modifier_imba_generic_talents_handler:GetModifierIncomingDamage_Percentage()
	if IsServer() then
		return self:GetParent():GetIncomingDamagePct()
	end
end

-- Spell lifesteal handler
function modifier_imba_generic_talents_handler:OnTakeDamage( keys )
	if IsServer() then
		local parent = self:GetParent()
		local caster = keys.attacker
		local target = keys.unit
		local damage = keys.damage
		local inflictor = keys.inflictor
		
		if caster == parent and inflictor then

			-- Calculate the amount of lifesteal
			local lifesteal_amount = parent:GetSpellLifesteal()

			-- Do nothing if the victim is not a valid target, or if the lifesteal amount is nonpositive
			if target:IsBuilding() or target:IsIllusion() or (target:GetTeam() == caster:GetTeam()) or (lifesteal_amount <= 0) then
				return end

			-- Also do nothing if the inflictor is forbidden
			local forbidden_inflictors = {
				"item_blade_mail",
				"luna_moon_glaive"
			}
			for _, forbidden_inflictor in pairs(forbidden_inflictors) do
				if inflictor:GetName() == forbidden_inflictor then return end
			end
			
			-- Particle effect
			local lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(lifesteal_pfx, 0, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
				
			-- If the target is a real hero, heal for the full value
			if target:IsRealHero() then
				caster:Heal(damage * lifesteal_amount * 0.01, caster)

			-- else, heal for half of it
			else
				caster:Heal(damage * lifesteal_amount * 0.005, caster)
			end
		end
	end
end

-- Regular lifesteal handler
function modifier_imba_generic_talents_handler:OnAttackLanded( keys )
	if IsServer() then
		local parent = self:GetParent()
		local attacker = keys.attacker

		-- If this attack was not performed by the modifier's parent, do nothing
		if parent ~= attacker then
			return end

		-- Else, keep going
		local target = keys.target
		local lifesteal_amount = parent:GetLifesteal()
		
		-- If there's no valid target, or lifesteal amount, do nothing
		if target:IsBuilding() or target:IsIllusion() or (target:GetTeam() == attacker:GetTeam()) or lifesteal_amount <= 0 then
			return end

		-- Calculate actual lifesteal amount
		local damage = keys.damage
		local target_armor = target:GetPhysicalArmorValue()
		local heal = damage * lifesteal_amount * 0.01 * (1 - 0.06 * (target_armor / (1 + 0.06 * target_armor)))

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