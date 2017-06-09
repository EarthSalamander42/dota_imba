--	Author: Firetoad
--	Date: 			19.07.2016
--	Last Update:	26.03.2017
--	Maelstrom and Mjollnir

-----------------------------------------------------------------------------------------------------------
--	Maelstrom definition
-----------------------------------------------------------------------------------------------------------

if item_imba_maelstrom == nil then item_imba_maelstrom = class({}) end
LinkLuaModifier( "modifier_item_imba_maelstrom", "items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable

function item_imba_maelstrom:GetIntrinsicModifierName()
	return "modifier_item_imba_maelstrom" end

function item_imba_maelstrom:GetAbilityTextureName()
   return "custom/imba_maelstrom"
end

-----------------------------------------------------------------------------------------------------------
--	Maelstrom passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_maelstrom == nil then modifier_item_imba_maelstrom = class({}) end
function modifier_item_imba_maelstrom:IsHidden() return true end
function modifier_item_imba_maelstrom:IsDebuff() return false end
function modifier_item_imba_maelstrom:IsPurgable() return false end
function modifier_item_imba_maelstrom:IsPermanent() return true end
function modifier_item_imba_maelstrom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Declare modifier events/properties
function modifier_item_imba_maelstrom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_maelstrom:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

function modifier_item_imba_maelstrom:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_as") end

-- On attack landed, roll for proc and apply stacks
function modifier_item_imba_maelstrom:OnAttackLanded( keys )
	if IsServer() then
		local attacker = self:GetParent()

		-- If this attack is irrelevant, do nothing
		if attacker ~= keys.attacker then
			return end

		-- If this is an illusion, do nothing either
		if attacker:IsIllusion() then
			return end

		-- If the target is invalid, still do nothing
		local target = keys.target
		if (not IsHeroOrCreep(target)) or attacker:GetTeam() == target:GetTeam() then
			return end

		-- All conditions met, stack the proc counter up
		local ability = self:GetAbility()		

		-- zap the target's ass
		local proc_chance = ability:GetSpecialValueFor("proc_chance")
		if RollPseudoRandom(proc_chance, ability) then
			LaunchLightning(attacker, target, ability, ability:GetSpecialValueFor("bounce_damage"), ability:GetSpecialValueFor("bounce_radius"))
		end
	end
end


-----------------------------------------------------------------------------------------------------------
--	Mjollnir definition
-----------------------------------------------------------------------------------------------------------

if item_imba_mjollnir == nil then item_imba_mjollnir = class({}) end
LinkLuaModifier( "modifier_item_imba_mjollnir", "items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )					-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_mjollnir_counter", "items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )			-- Attack proc counter
LinkLuaModifier( "modifier_item_imba_mjollnir_static", "items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )			-- Static shield
LinkLuaModifier( "modifier_item_imba_mjollnir_static_counter", "items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )	-- Shield proc counter
LinkLuaModifier( "modifier_item_imba_mjollnir_slow", "items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )				-- Shield slow

function item_imba_mjollnir:GetIntrinsicModifierName()
	return "modifier_item_imba_mjollnir" end

function item_imba_mjollnir:OnSpellStart()
	if IsServer() then

		-- Apply the modifier to the target
		local target = self:GetCursorTarget()
		target:AddNewModifier(target, self, "modifier_item_imba_mjollnir_static", {duration = self:GetSpecialValueFor("static_duration")})

		-- Play cast sound
		target:EmitSound("DOTA_Item.Mjollnir.Activate")
	end
end

-----------------------------------------------------------------------------------------------------------
--	Mjollnir passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_mjollnir == nil then modifier_item_imba_mjollnir = class({}) end
function modifier_item_imba_mjollnir:IsHidden() return true end
function modifier_item_imba_mjollnir:IsDebuff() return false end
function modifier_item_imba_mjollnir:IsPurgable() return false end
function modifier_item_imba_mjollnir:IsPermanent() return true end
function modifier_item_imba_mjollnir:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Declare modifier events/properties
function modifier_item_imba_mjollnir:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_mjollnir:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

function modifier_item_imba_mjollnir:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_as") end

-- On attack landed, roll for proc and apply stacks
function modifier_item_imba_mjollnir:OnAttackLanded( keys )
	if IsServer() then
		local attacker = self:GetParent()

		-- If this attack is irrelevant, do nothing
		if attacker ~= keys.attacker then
			return end

		-- If this is an illusion, do nothing either
		if attacker:IsIllusion() then
			return end

		-- If the target is invalid, still do nothing
		local target = keys.target
		if (not IsHeroOrCreep(target)) or attacker:GetTeam() == target:GetTeam() then
			return end

		-- All conditions met, stack the proc counter up
		local ability = self:GetAbility()
		
		-- zap the target's ass
		local proc_chance = ability:GetSpecialValueFor("proc_chance")
		if RollPseudoRandom(proc_chance, ability) then
			LaunchLightning(attacker, target, ability, ability:GetSpecialValueFor("bounce_damage"), ability:GetSpecialValueFor("bounce_radius"))
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Mjollnir static shield
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_mjollnir_static == nil then modifier_item_imba_mjollnir_static = class({}) end
function modifier_item_imba_mjollnir_static:IsHidden() return false end
function modifier_item_imba_mjollnir_static:IsDebuff() return false end
function modifier_item_imba_mjollnir_static:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_mjollnir_static:GetEffectName()
	return "particles/items2_fx/mjollnir_shield.vpcf" end

function modifier_item_imba_mjollnir_static:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

-- Start playing sound and store ability parameters
function modifier_item_imba_mjollnir_static:OnCreated()
	if IsServer() then
		self:GetParent():EmitSound("DOTA_Item.Mjollnir.Loop")
	end
end

-- Stop playing sound and destroy the proc counter
function modifier_item_imba_mjollnir_static:OnDestroy()
	if IsServer() then
		StopSoundEvent("DOTA_Item.Mjollnir.Loop", self:GetParent())
		self:GetParent():RemoveModifierByName("modifier_item_imba_mjollnir_static_counter")
	end
end

-- Declare modifier events/properties
function modifier_item_imba_mjollnir_static:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

-- On damage taken, count stacks and proc the static shield
function modifier_item_imba_mjollnir_static:OnTakeDamage( keys )
	if IsServer() then
		local shield_owner = self:GetParent()

		-- If this damage event is irrelevant, do nothing
		if shield_owner ~= keys.unit then
			return end

		-- If the attacker is invalid, do nothing either
		if keys.attacker:GetTeam() == shield_owner:GetTeam() then
			return end

		-- All conditions met, stack the proc counter up
		local ability = self:GetAbility()
		-- If enough stacks accumulated, reset them and zap nearby enemies
		local static_proc_chance = ability:GetSpecialValueFor("static_proc_chance")
		local static_damage = ability:GetSpecialValueFor("static_damage")
		local static_radius = ability:GetSpecialValueFor("static_radius")
		local static_slow_duration = ability:GetSpecialValueFor("static_slow_duration")
		if RollPseudoRandom(static_proc_chance, ability) then

			-- Iterate through nearby enemies
			local static_origin = shield_owner:GetAbsOrigin() + Vector(0, 0, 100)
			local nearby_enemies = FindUnitsInRadius(shield_owner:GetTeamNumber(), shield_owner:GetAbsOrigin(), nil, static_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(nearby_enemies) do

				-- Play particle
				local static_pfx = ParticleManager:CreateParticle("particles/item/mjollnir/static_lightning_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, shield_owner)
				ParticleManager:SetParticleControlEnt(static_pfx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(static_pfx, 1, static_origin)
				ParticleManager:ReleaseParticleIndex(static_pfx)

				-- Apply damage
				ApplyDamage({attacker = shield_owner, victim = enemy, ability = ability, damage = static_damage, damage_type = DAMAGE_TYPE_MAGICAL})

				-- Apply slow modifier
				enemy:AddNewModifier(shield_owner, ability, "modifier_item_imba_mjollnir_slow", {duration = static_slow_duration})
			end

			-- Play hit sound if at least one enemy was hit
			if #nearby_enemies > 0 then
				shield_owner:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Mjollnir passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_mjollnir_slow == nil then modifier_item_imba_mjollnir_slow = class({}) end
function modifier_item_imba_mjollnir_slow:IsHidden() return false end
function modifier_item_imba_mjollnir_slow:IsDebuff() return true end
function modifier_item_imba_mjollnir_slow:IsPurgable() return true end

-- Declare modifier events/properties
function modifier_item_imba_mjollnir_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_item_imba_mjollnir_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("static_slow") end

function modifier_item_imba_mjollnir_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("static_slow") end



-----------------------------------------------------------------------------------------------------------
--	Lightning proc functions
-----------------------------------------------------------------------------------------------------------

-- Initial launch + main loop
function LaunchLightning(caster, target, ability, damage, bounce_radius)

	-- Parameters
	local targets_hit = { target }
	local search_sources = { target	}

	-- Play initial sound
	caster:EmitSound("Item.Maelstrom.Chain_Lightning")

	-- Play first bounce sound
	target:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")

	-- Zap initial target
	ZapThem(caster, ability, caster, target, damage)

	-- While there are potential sources, keep looping
	while #search_sources > 0 do

		-- Loop through every potential source this iteration
		for potential_source_index, potential_source in pairs(search_sources) do

			-- Iterate through potential targets near this source
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), potential_source:GetAbsOrigin(), nil, bounce_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
			for _, potential_target in pairs(nearby_enemies) do
				
				-- Check if this target was already hit
				local already_hit = false
				for _, hit_target in pairs(targets_hit) do
					if potential_target == hit_target then
						already_hit = true
						break
					end
				end

				-- If not, zap it from this source, and mark it as a hit target and potential future source
				if not already_hit then
					ZapThem(caster, ability, potential_source, potential_target, damage)
					targets_hit[#targets_hit+1] = potential_target
					search_sources[#search_sources+1] = potential_target
				end
			end

			-- Remove this potential source
			table.remove(search_sources, potential_source_index)
		end
	end
end

-- One bounce. Particle + damage
function ZapThem(caster, ability, source, target, damage)

	-- Draw particle
	local bounce_pfx = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, source)
	ParticleManager:SetParticleControlEnt(bounce_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(bounce_pfx, 1, source, PATTACH_POINT_FOLLOW, "attach_hitloc", source:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(bounce_pfx, 2, Vector(1, 1, 1))
	ParticleManager:ReleaseParticleIndex(bounce_pfx)

	-- Damage target
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end