--[[	Author: Firetoad
		Date: 06.09.2015	]]

function HexAura( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_slow = keys.modifier_slow

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local hex_aoe = ability:GetLevelSpecialValueFor("hex_aoe", ability_level)
	local hex_duration = ability:GetLevelSpecialValueFor("hex_duration", ability_level)
	local min_creeps = ability:GetLevelSpecialValueFor("min_creeps", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, hex_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, hex_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #creeps >= min_creeps or #heroes >= 1 then

		-- Choose a random hero to be the modifier owner (having a non-hero hex modifier owner crashes the game)
		local hero_owner = HeroList:GetHero(0)

		-- Hex enemies
		for _,enemy in pairs(creeps) do
			if enemy:IsIllusion() then
				enemy:ForceKill(true)
			else
				enemy:AddNewModifier(hero_owner, ability, "modifier_sheepstick_debuff", {duration = hex_duration})
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
			end
		end
		for _,enemy in pairs(heroes) do
			if enemy:IsIllusion() then
				enemy:ForceKill(true)
			else
				enemy:AddNewModifier(hero_owner, ability, "modifier_sheepstick_debuff", {duration = hex_duration})
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
			end
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end

function ManaFlare( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_burn = keys.particle_burn
	local sound_burn = keys.sound_burn

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local burn_aoe = ability:GetLevelSpecialValueFor("burn_aoe", ability_level)
	local burn_pct = ability:GetLevelSpecialValueFor("burn_pct", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, burn_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #heroes >= 1 then

		-- Play sound
		caster:EmitSound(sound_burn)

		-- Iterate through enemies
		for _,enemy in pairs(heroes) do
			
			-- Burn mana
			local mana_to_burn = enemy:GetMaxMana() * burn_pct / 100
			enemy:ReduceMana(mana_to_burn)

			-- Play mana burn particle
			local mana_burn_pfx = ParticleManager:CreateParticle(particle_burn, PATTACH_ABSORIGIN, enemy)
			ParticleManager:SetParticleControl(mana_burn_pfx, 0, enemy:GetAbsOrigin())
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end

function Chronotower( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_stun = keys.sound_stun
	local modifier_stun = keys.modifier_stun

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local stun_radius = ability:GetLevelSpecialValueFor("stun_radius", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local min_creeps = ability:GetLevelSpecialValueFor("min_creeps", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #creeps >= min_creeps or #heroes >= 1 then

		-- Play sound
		caster:EmitSound(sound_stun)

		-- Stun enemies
		for _,enemy in pairs(creeps) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_stun, {})
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		end
		for _,enemy in pairs(heroes) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_stun, {})
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end


function Reality( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_reality = keys.sound_reality

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local reality_aoe = ability:GetLevelSpecialValueFor("reality_aoe", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, reality_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Kill any existing illusions
	local ability_used = false
	for _,enemy in pairs(heroes) do
		if enemy:IsIllusion() then
			enemy:ForceKill(true)
			ability_used = true
		end
	end

	-- If the ability was used, play the sound and put it on cooldown
	if ability_used then

		-- Play sound
		caster:EmitSound(sound_reality)

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end

function Force( keys )
	local caster = keys.caster
	local ability = keys.ability		
	local sound_force = keys.sound_force

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local force_aoe = ability:GetSpecialValueFor("force_aoe")
	local force_distance = ability:GetSpecialValueFor("force_distance")
	local force_duration = ability:GetSpecialValueFor("force_duration")
	local min_creeps = ability:GetSpecialValueFor("min_creeps")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local tower_loc = caster:GetAbsOrigin()
	local knockback_param
	
	-- Find nearby enemies
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, force_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, force_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #creeps >= min_creeps or #heroes >= 1 then

		-- Play sound
		caster:EmitSound(sound_force)			
		
		-- Knockback enemies
		for _,enemy in pairs(creeps) do
			-- Set up knockback parameters
			knockback_param =
			{	should_stun = 1,
				knockback_duration = force_duration,
				duration = force_duration,
				knockback_distance = force_distance,
				knockback_height = 0,
				center_x = tower_loc.x,
				center_y = tower_loc.y,
				center_z = tower_loc.z
			}
			enemy:RemoveModifierByName("modifier_knockback")
			enemy:AddNewModifier(caster, nil, "modifier_knockback", knockback_param)
			
			
			end
			
		for _,enemy in pairs(heroes) do
			-- Calculate distance from tower
			local distance = (enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()				
		
			-- Create dummy that knockbacks toward the tower
			local direction = (enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
			local knockback_dummy_loc = enemy:GetAbsOrigin() + direction * 150
			local knockback_dummy = CreateUnitByName("npc_dummy_unit", knockback_dummy_loc, false, caster, caster, caster:GetTeamNumber())				
			
			-- Set up knockback parameters
			knockback_param =
			{	should_stun = 1,
				knockback_duration = force_duration,
				duration = force_duration,
				knockback_distance = distance-180,
				knockback_height = 0,
				center_x = knockback_dummy:GetAbsOrigin().x,
				center_y = knockback_dummy:GetAbsOrigin().y,
				center_z = knockback_dummy:GetAbsOrigin().z
			}
			
			enemy:RemoveModifierByName("modifier_knockback")
			enemy:AddNewModifier(caster, nil, "modifier_knockback", knockback_param)
			
			knockback_dummy:Destroy()	
			
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown())
	end
end

function Nature( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_root = keys.sound_root
	local modifier_root = keys.modifier_root

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local root_radius = ability:GetLevelSpecialValueFor("root_radius", ability_level)
	local min_creeps = ability:GetLevelSpecialValueFor("min_creeps", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, root_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, root_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #creeps >= min_creeps or #heroes >= 1 then

		-- Play sound
		caster:EmitSound(sound_root)

		-- Root enemies
		for _,enemy in pairs(creeps) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_root, {})
		end
		for _,enemy in pairs(heroes) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_root, {})
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end

function Mindblast( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_silence = keys.sound_silence
	local modifier_silence = keys.modifier_silence

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local silence_radius = ability:GetLevelSpecialValueFor("silence_radius", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, silence_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #heroes >= 1 then

		-- Play sound
		caster:EmitSound(sound_silence)

		-- Silence enemies
		for _,enemy in pairs(heroes) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_silence, {})
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end

-- Tier 1 to 3 tower aura abilities
-- Author: Shush
-- Date: 8/2/2017

---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--		  Tower's Protective Instincts
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_tower_protective_instinct = class({})
LinkLuaModifier("modifier_imba_tower_protective_instinct", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_protective_instinct:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local modifier = "modifier_imba_tower_protective_instinct"
	
	if not caster:HasModifier(modifier) then
		caster:AddNewModifier(caster, ability, modifier, {})
	end
end

-- protective instinct ability (counts heroes in a 1200 radius every 0.1 seconds, sets nettable value accordingly)
modifier_imba_tower_protective_instinct = class({})

function modifier_imba_tower_protective_instinct:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_tower_protective_instinct:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		CustomNetTables:SetTableValue("towers", tostring(caster:GetName()), { protective_instinct_stacks = 0})	
		self:StartIntervalThink(0.1)
	end	
end

function modifier_imba_tower_protective_instinct:OnIntervalThink()
	if IsServer() then		
		local caster = self:GetCaster()
				
		local ability = self:GetAbility()	
		--local radius = ability:GetSpecialValueFor("radius") //crashes the game for some weird reason
		
		local heroes = FindUnitsInRadius(caster:GetTeamNumber(),
										caster:GetAbsOrigin(),
										nil,
										1200,
										DOTA_UNIT_TARGET_TEAM_FRIENDLY,
										DOTA_UNIT_TARGET_HERO,
										DOTA_UNIT_TARGET_FLAG_NONE,
										FIND_ANY_ORDER,
										false)
										
		CustomNetTables:SetTableValue("towers", tostring(caster:GetName()), { protective_instinct_stacks = #heroes})	
	end
end

function modifier_imba_tower_protective_instinct:IsHidden()
	return true
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Machinegun Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_machinegun = class({})
LinkLuaModifier("modifier_imba_tower_machinegun_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_machinegun_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_machinegun:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_machinegun_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_machinegun_aura = class({})

function modifier_imba_tower_machinegun_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_machinegun_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_machinegun_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_machinegun_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_machinegun_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_machinegun_aura:GetModifierAura()
	return "modifier_imba_tower_machinegun_aura_buff"
end

function modifier_imba_tower_machinegun_aura:IsAura()
	return true
end

function modifier_imba_tower_machinegun_aura:IsDebuff()
	return false
end

function modifier_imba_tower_machinegun_aura:IsHidden()
	return true
end

function modifier_imba_tower_machinegun_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Attack Speed Modifier
modifier_imba_tower_machinegun_aura_buff = class({})

function modifier_imba_tower_machinegun_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_machinegun_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
		
		return decFuncs	
end

function modifier_imba_tower_machinegun_aura_buff:GetModifierAttackSpeedBonus_Constant()	
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()		
	local parent = self:GetParent()
	
	-- Ability specials
	local bonus_as = ability:GetSpecialValueFor("bonus_as")
	local as_per_protective_instinct = ability:GetSpecialValueFor("as_per_protective_instinct")	
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	local extra_as = bonus_as + as_per_protective_instinct * protective_instinct_stacks	
	return extra_as
end



---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Thorns Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_thorns = class({})
LinkLuaModifier("modifier_imba_tower_thorns_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_thorns_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_thorns:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_thorns_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_thorns_aura = class({})

function modifier_imba_tower_thorns_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_thorns_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_thorns_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_thorns_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_thorns_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_thorns_aura:GetModifierAura()
	return "modifier_imba_tower_thorns_aura_buff"
end

function modifier_imba_tower_thorns_aura:IsAura()
	return true
end

function modifier_imba_tower_thorns_aura:IsDebuff()
	return false
end

function modifier_imba_tower_thorns_aura:IsHidden()
	return true
end

function modifier_imba_tower_thorns_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Return damage Modifier
modifier_imba_tower_thorns_aura_buff = class({})

function modifier_imba_tower_thorns_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_thorns_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}
		
		return decFuncs	
end

function modifier_imba_tower_thorns_aura_buff:OnAttackLanded( keys )	
	-- Ability properties
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()		
		local particle_return = "particles/units/heroes/hero_centaur/centaur_return.vpcf"
		local attacker = keys.attacker
		local target = keys.target		
		
		-- Ability specials
		local return_damage_pct = ability:GetSpecialValueFor("return_damage_pct")
		local return_damage_per_stack = ability:GetSpecialValueFor("return_damage_per_stack")	
		local minimum_damage = ability:GetSpecialValueFor("minimum_damage")
		local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks				
			
		-- Only apply if the parent is the victim and the attacker is on the opposite team
		if parent == target and attacker:GetTeamNumber() ~= parent:GetTeamNumber() then
		
			-- Create return effect
			local return_pfx = ParticleManager:CreateParticle(particle_return, PATTACH_ABSORIGIN, parent)
			ParticleManager:SetParticleControlEnt(return_pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(return_pfx, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
			
			-- Get the hero's main attribute value
			local main_attribute_value = parent:GetPrimaryStatValue()
			
			-- Calculate damage based on percentage of main stat
			local return_damage_pct_final = return_damage_pct + return_damage_per_stack * protective_instinct_stacks	
			local return_damage = main_attribute_value * (return_damage_pct_final/100)
			
			-- Increase damage to the minimum if it's not sufficient
			if minimum_damage > return_damage then
				return_damage = minimum_damage
			end
			
			-- Apply damage
			local damageTable = {victim = attacker,
								 attacker = parent,
								 damage = return_damage,
								 damage_type = DAMAGE_TYPE_PHYSICAL}
									
			ApplyDamage(damageTable)				
		end
	end	
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Aegis Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_tower_aegis = class({})
LinkLuaModifier("modifier_imba_tower_aegis_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_aegis_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_aegis:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_aegis_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_aegis_aura = class({})

function modifier_imba_tower_aegis_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_aegis_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_aegis_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_aegis_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_aegis_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_aegis_aura:GetModifierAura()
	return "modifier_imba_tower_aegis_aura_buff"
end

function modifier_imba_tower_aegis_aura:IsAura()
	return true
end

function modifier_imba_tower_aegis_aura:IsDebuff()
	return false
end

function modifier_imba_tower_aegis_aura:IsHidden()
	return true
end

function modifier_imba_tower_aegis_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Armor increase Modifier
modifier_imba_tower_aegis_aura_buff = class({})

function modifier_imba_tower_aegis_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_aegis_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
		
		return decFuncs	
end

function modifier_imba_tower_aegis_aura_buff:GetModifierPhysicalArmorBonus()	
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()		
	
	-- Ability specials
	local bonus_armor = ability:GetSpecialValueFor("bonus_armor")
	local armor_per_protective = ability:GetSpecialValueFor("armor_per_protective")	
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	return bonus_armor + armor_per_protective * protective_instinct_stacks	
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Toughness Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_tower_toughness = class({})
LinkLuaModifier("modifier_imba_tower_toughness_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_toughness_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_toughness:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_toughness_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_toughness_aura = class({})

function modifier_imba_tower_toughness_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_toughness_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_toughness_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_toughness_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_toughness_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_toughness_aura:GetModifierAura()
	return "modifier_imba_tower_toughness_aura_buff"
end

function modifier_imba_tower_toughness_aura:IsAura()
	return true
end

function modifier_imba_tower_toughness_aura:IsDebuff()
	return false
end

function modifier_imba_tower_toughness_aura:IsHidden()
	return true
end

function modifier_imba_tower_toughness_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Health increase Modifier
modifier_imba_tower_toughness_aura_buff = class({})

function modifier_imba_tower_toughness_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_toughness_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_HEALTH_BONUS}
		
		return decFuncs	
end

function modifier_imba_tower_toughness_aura_buff:GetModifierHealthBonus()	
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()		
	
	-- Ability specials
	local bonus_health = ability:GetSpecialValueFor("bonus_health")
	local health_per_protective = ability:GetSpecialValueFor("health_per_protective")	
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	return bonus_health + health_per_protective * protective_instinct_stacks	
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Sniper Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_tower_sniper = class({})
LinkLuaModifier("modifier_imba_tower_sniper_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_sniper_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_sniper:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_sniper_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_sniper_aura = class({})

function modifier_imba_tower_sniper_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_sniper_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_sniper_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_sniper_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_sniper_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_sniper_aura:GetModifierAura()
	return "modifier_imba_tower_sniper_aura_buff"
end

function modifier_imba_tower_sniper_aura:IsAura()
	return true
end

function modifier_imba_tower_sniper_aura:IsDebuff()
	return false
end

function modifier_imba_tower_sniper_aura:IsHidden()
	return true
end

function modifier_imba_tower_sniper_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Attack range Modifier
modifier_imba_tower_sniper_aura_buff = class({})

function modifier_imba_tower_sniper_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_sniper_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS}
		
		return decFuncs	
end

function modifier_imba_tower_sniper_aura_buff:GetModifierAttackRangeBonus()	
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()		
	
	-- Ability specials
	local bonus_range = ability:GetSpecialValueFor("bonus_range")
	local range_per_protective = ability:GetSpecialValueFor("range_per_protective")	
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	return bonus_range + range_per_protective * protective_instinct_stacks	
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Splash Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_tower_splash_fire = class({})
LinkLuaModifier("modifier_imba_tower_splash_fire_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_splash_fire_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_splash_fire:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_splash_fire_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_splash_fire_aura = class({})

function modifier_imba_tower_splash_fire_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_splash_fire_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_splash_fire_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_splash_fire_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_splash_fire_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_splash_fire_aura:GetModifierAura()
	return "modifier_imba_tower_splash_fire_aura_buff"
end

function modifier_imba_tower_splash_fire_aura:IsAura()
	return true
end

function modifier_imba_tower_splash_fire_aura:IsDebuff()
	return false
end

function modifier_imba_tower_splash_fire_aura:IsHidden()
	return true
end

function modifier_imba_tower_splash_fire_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Splash attack Modifier
modifier_imba_tower_splash_fire_aura_buff = class({})

function modifier_imba_tower_splash_fire_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_splash_fire_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}
		
		return decFuncs	
end

function modifier_imba_tower_splash_fire_aura_buff:OnAttackLanded( keys )	
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()		
		local parent = self:GetParent()
		local target = keys.target --victim
		local attacker = keys.attacker --attacker
		local damage = keys.damage
		local particle_explosion = "particles/ambient/tower_salvo_explosion.vpcf"
		
		-- Ability specials
		local splash_damage_pct = ability:GetSpecialValueFor("splash_damage_pct")
		local bonus_splash_per_protective = ability:GetSpecialValueFor("bonus_splash_per_protective")
		local splash_radius = ability:GetSpecialValueFor("splash_radius")
		
		-- Only apply if the attacker is the parent of the buff, and the victim is on the opposing team.
		if parent == attacker and parent:GetTeamNumber() ~= target:GetTeamNumber() then
			-- Add explosion particle
			local explosion_pfx = ParticleManager:CreateParticle(particle_explosion, PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControl(explosion_pfx, 0, target:GetAbsOrigin())
			ParticleManager:SetParticleControl(explosion_pfx, 3, target:GetAbsOrigin())
			
			-- Calculate bonus damage
			local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
			local splash_damage = damage * ((splash_damage_pct + bonus_splash_per_protective)/100)
			
			-- Apply bonus damage on every enemy EXCEPT the main target			
			local enemy_units = FindUnitsInRadius(parent:GetTeamNumber(),
												  target:GetAbsOrigin(),
												  nil,
												  splash_radius,
												  DOTA_UNIT_TARGET_TEAM_ENEMY,
												  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
												  DOTA_UNIT_TARGET_FLAG_NONE,
												  FIND_ANY_ORDER,
												  false)
											  
			for _,enemy in pairs(enemy_units) do
				if enemy ~= target then
					local damageTable = {victim = enemy,
										attacker = parent,
										damage = splash_damage,
										damage_type = DAMAGE_TYPE_PHYSICAL}
										
					ApplyDamage(damageTable)				
				end					
			end						
		end
	end
end



---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Replenishment Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_tower_replenishment = class({})
LinkLuaModifier("modifier_imba_tower_replenishment_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_replenishment_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_replenishment:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_replenishment_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_replenishment_aura = class({})

function modifier_imba_tower_replenishment_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_replenishment_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_replenishment_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_replenishment_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_replenishment_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_replenishment_aura:GetModifierAura()
	return "modifier_imba_tower_replenishment_aura_buff"
end

function modifier_imba_tower_replenishment_aura:IsAura()
	return true
end

function modifier_imba_tower_replenishment_aura:IsDebuff()
	return false
end

function modifier_imba_tower_replenishment_aura:IsHidden()
	return true
end

function modifier_imba_tower_replenishment_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Cooldown reduction Modifier
modifier_imba_tower_replenishment_aura_buff = class({})

function modifier_imba_tower_replenishment_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_replenishment_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING}
		
		return decFuncs	
end

function modifier_imba_tower_replenishment_aura_buff:GetModifierPercentageCooldownStacking()	
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()		
	
	-- Ability specials
	local cooldown_reduction_pct = ability:GetSpecialValueFor("cooldown_reduction_pct")
	local bonus_cooldown_reduction = ability:GetSpecialValueFor("bonus_cooldown_reduction")	
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	return cooldown_reduction_pct + bonus_cooldown_reduction * protective_instinct_stacks	
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Observatory Vision
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_tower_observatory = class({})
LinkLuaModifier("modifier_imba_tower_observatory_vision", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_observatory:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local modifier = "modifier_imba_tower_observatory_vision"
	
	if not caster:HasModifier(modifier) then
		caster:AddNewModifier(caster, ability, modifier, {})
	end	
end

-- unobstructed vision modifier
modifier_imba_tower_observatory_vision = class({})

function modifier_imba_tower_observatory_vision:IsHidden()
	return false	
end

function modifier_imba_tower_observatory_vision:CheckState()
	local state = {[MODIFIER_STATE_FLYING] = true,
				   [MODIFIER_STATE_ROOTED] = true}
			
	return state
end

function modifier_imba_tower_observatory_vision:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_BONUS_DAY_VISION,
					  MODIFIER_PROPERTY_BONUS_NIGHT_VISION}
		
	return decFuncs	
end
  

function modifier_imba_tower_observatory_vision:GetBonusDayVision()	
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	
	-- Ability specials
	local additional_vision_per_hero = ability:GetSpecialValueFor("additional_vision_per_hero")
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	local bonus_vision = additional_vision_per_hero * protective_instinct_stacks
	
	return bonus_vision
end

function modifier_imba_tower_observatory_vision:GetBonusNightVision()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	
	-- Ability specials
	local additional_vision_per_hero = ability:GetSpecialValueFor("additional_vision_per_hero")
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	local bonus_vision = additional_vision_per_hero * protective_instinct_stacks
	
	return bonus_vision
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Spell Shield Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_tower_spell_shield = class({})
LinkLuaModifier("modifier_imba_tower_spell_shield_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_spell_shield_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_spell_shield:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_spell_shield_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_spell_shield_aura = class({})

function modifier_imba_tower_spell_shield_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_spell_shield_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_spell_shield_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_spell_shield_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_spell_shield_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_spell_shield_aura:GetModifierAura()
	return "modifier_imba_tower_spell_shield_aura_buff"
end

function modifier_imba_tower_spell_shield_aura:IsAura()
	return true
end

function modifier_imba_tower_spell_shield_aura:IsDebuff()
	return false
end

function modifier_imba_tower_spell_shield_aura:IsHidden()
	return true
end

function modifier_imba_tower_spell_shield_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Attack range Modifier
modifier_imba_tower_spell_shield_aura_buff = class({})

function modifier_imba_tower_spell_shield_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_spell_shield_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
		
		return decFuncs	
end

function modifier_imba_tower_spell_shield_aura_buff:GetModifierMagicalResistanceBonus()	
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()		
	
	-- Ability specials
	local magic_resistance = ability:GetSpecialValueFor("magic_resistance")
	local bonus_mr_per_protective = ability:GetSpecialValueFor("bonus_mr_per_protective")	
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	return magic_resistance + bonus_mr_per_protective * protective_instinct_stacks	
end



---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Mana Burn Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_mana_burn = class({})
LinkLuaModifier("modifier_imba_tower_mana_burn_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_mana_burn_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_mana_burn:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_mana_burn_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_mana_burn_aura = class({})

function modifier_imba_tower_mana_burn_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_mana_burn_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_mana_burn_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_mana_burn_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_mana_burn_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_mana_burn_aura:GetModifierAura()
	return "modifier_imba_tower_mana_burn_aura_buff"
end

function modifier_imba_tower_mana_burn_aura:IsAura()
	return true
end

function modifier_imba_tower_mana_burn_aura:IsDebuff()
	return false
end

function modifier_imba_tower_mana_burn_aura:IsHidden()
	return true
end

function modifier_imba_tower_mana_burn_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Mana Burn damage Modifier
modifier_imba_tower_mana_burn_aura_buff = class({})

function modifier_imba_tower_mana_burn_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_mana_burn_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}
		
		return decFuncs	
end

function modifier_imba_tower_mana_burn_aura_buff:OnAttackLanded( keys )	
	-- Ability properties
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()		
		local particle_mana_burn = "particles/generic_gameplay/generic_manaburn.vpcf"
		local attacker = keys.attacker
		local target = keys.target		
		
		-- Ability specials
		local mana_burn = ability:GetSpecialValueFor("mana_burn")
		local additional_burn_per_hero = ability:GetSpecialValueFor("additional_burn_per_hero")	
		local mana_burn_damage_pct = ability:GetSpecialValueFor("mana_burn_damage_pct")
		local illusion_mana_burn_pct = ability:GetSpecialValueFor("illusion_mana_burn_pct")
		local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks				
			
		-- Only apply if the parent is the attacker and the victim is on the opposite team
		if parent == attacker and attacker:GetTeamNumber() ~= target:GetTeamNumber() then
			
			-- Only applies on non spell immune enemies
			if not target:IsMagicImmune() then
			
				-- Create mana burn effect
				local particle_mana_burn_fx = ParticleManager:CreateParticle(particle_mana_burn, PATTACH_ABSORIGIN, target)
				ParticleManager:SetParticleControl(particle_mana_burn_fx, 0, target:GetAbsOrigin())			
				
				-- Calculate mana burn efficiency 
				local target_current_mana = target:GetMana()
				local mana_burn_total = mana_burn + additional_burn_per_hero * protective_instinct_stacks
								
				-- Reduce mana burn and damage to the target's mana if it goes over his current mana
				if target:GetMana() < mana_burn_total then
					mana_burn_total = target_current_mana					
				end
				
				-- Illusions burn mana on a much lower value
				if attacker:IsIllusion() then
					mana_burn_total = mana_burn_total * (illusion_mana_burn_pct/100)
				end
				
				-- Calculate damage based on taget's current mana
				local mana_burn_damage = mana_burn_total * (mana_burn_damage_pct/100)
				
				-- Burn target's mana
				target:ReduceMana(mana_burn_total)
							
				-- Apply damage
				local damageTable = {victim = target,
									 attacker = parent,
									 damage = mana_burn_damage,
									 damage_type = DAMAGE_TYPE_MAGICAL}
										
				ApplyDamage(damageTable)				
			end
		end
	end	
end




---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Bash Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_permabash = class({})
LinkLuaModifier("modifier_imba_tower_permabash_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_permabash_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_permabash:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_permabash_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_permabash_aura = class({})

function modifier_imba_tower_permabash_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_permabash_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_permabash_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_permabash_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_permabash_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_permabash_aura:GetModifierAura()
	return "modifier_imba_tower_permabash_aura_buff"
end

function modifier_imba_tower_permabash_aura:IsAura()
	return true
end

function modifier_imba_tower_permabash_aura:IsDebuff()
	return false
end

function modifier_imba_tower_permabash_aura:IsHidden()
	return true
end

function modifier_imba_tower_permabash_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Bash Modifier
modifier_imba_tower_permabash_aura_buff = class({})

function modifier_imba_tower_permabash_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_permabash_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}
		
		return decFuncs	
end

function modifier_imba_tower_permabash_aura_buff:OnAttackLanded( keys )	
	-- Ability properties
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local bash_modifier = "modifier_stunned"		
		local ability = self:GetAbility()				
		local attacker = keys.attacker
		local target = keys.target		
			
		-- Ability specials
		local bash_damage = ability:GetSpecialValueFor("bash_damage")
		local bash_duration = ability:GetSpecialValueFor("bash_duration")	
		local bash_damage_per_protective = ability:GetSpecialValueFor("bash_damage_per_protective")
		local bash_chance = ability:GetSpecialValueFor("bash_chance")
		local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks				
			
		-- Only apply if the parent is the victim and the attacker is on the opposite team
		if parent == attacker and attacker:GetTeamNumber() ~= target:GetTeamNumber() then
			local roll_chance = RandomInt(1,100)			
			
			if roll_chance <= bash_chance then
				target:AddNewModifier(caster, ability, "modifier_stunned", {duration = bash_duration})
				
				-- Calculate damage
				local bash_damage_total = bash_damage + bash_damage_per_protective * protective_instinct_stacks
				
				-- Apply damage
				local damageTable = {victim = target,
									attacker = attacker,
									damage = bash_damage_total,
									damage_type = DAMAGE_TYPE_PHYSICAL}
									
				ApplyDamage(damageTable)		
			end
		end
	end	
end




---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Vicious Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_vicious = class({})
LinkLuaModifier("modifier_imba_tower_vicious_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_vicious_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_vicious:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_vicious_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_vicious_aura = class({})

function modifier_imba_tower_vicious_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_vicious_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_vicious_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_vicious_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_vicious_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_vicious_aura:GetModifierAura()
	return "modifier_imba_tower_vicious_aura_buff"
end

function modifier_imba_tower_vicious_aura:IsAura()
	return true
end

function modifier_imba_tower_vicious_aura:IsDebuff()
	return false
end

function modifier_imba_tower_vicious_aura:IsHidden()
	return true
end

function modifier_imba_tower_vicious_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Critical Modifier
modifier_imba_tower_vicious_aura_buff = class({})

function modifier_imba_tower_vicious_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_vicious_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE}
		
		return decFuncs	
end

function modifier_imba_tower_vicious_aura_buff:GetModifierPreAttack_CriticalStrike()	
	-- Ability properties
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()		
		local ability = self:GetAbility()										
		
		-- Ability specials
		local crit_damage = ability:GetSpecialValueFor("crit_damage")		
		local crit_chance_per_protective = ability:GetSpecialValueFor("crit_chance_per_protective")
		local crit_chance = ability:GetSpecialValueFor("crit_chance")
		local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks				
				
		-- Calculate crit chance
		local true_crit_chance = crit_chance + crit_chance_per_protective * protective_instinct_stacks
		
		local roll_chance = RandomInt(1,100)
					
		if roll_chance <= true_crit_chance then												
			return crit_damage					
		else
			return nil
		end
	end
end	




---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Spellmastery Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_spellmastery = class({})
LinkLuaModifier("modifier_imba_tower_spellmastery_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_spellmastery_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_spellmastery:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_spellmastery_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_spellmastery_aura = class({})

function modifier_imba_tower_spellmastery_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_spellmastery_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_spellmastery_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_spellmastery_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_spellmastery_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_spellmastery_aura:GetModifierAura()
	return "modifier_imba_tower_spellmastery_aura_buff"
end

function modifier_imba_tower_spellmastery_aura:IsAura()
	return true
end

function modifier_imba_tower_spellmastery_aura:IsDebuff()
	return false
end

function modifier_imba_tower_spellmastery_aura:IsHidden()
	return true
end

function modifier_imba_tower_spellmastery_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Spell amp/cast range Modifier
modifier_imba_tower_spellmastery_aura_buff = class({})

function modifier_imba_tower_spellmastery_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_spellmastery_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
						 MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING}
		
		return decFuncs	
end

function modifier_imba_tower_spellmastery_aura_buff:GetModifierSpellAmplify_Percentage()	
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()		
	local parent = self:GetParent()
	
	-- Ability specials
	local spellamp_bonus = ability:GetSpecialValueFor("spellamp_bonus")
	local spellamp_per_protective = ability:GetSpecialValueFor("spellamp_per_protective")	
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	local spellamp = spellamp_bonus + spellamp_per_protective * protective_instinct_stacks	
	return spellamp
end

function modifier_imba_tower_spellmastery_aura_buff:GetModifierCastRangeBonusStacking()
	-- Ability properties
	local ability = self:GetAbility()	
	
	-- Ability specials
	local cast_range_bonus = ability:GetSpecialValueFor("cast_range_bonus")
	
	return cast_range_bonus
end




---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Plague Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_plague = class({})
LinkLuaModifier("modifier_imba_tower_plague_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_plague_aura_debuff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_plague:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_plague_aura"
	local particle_rot = "particles/units/heroes/hero_pudge/pudge_rot_radius.vpcf"
	
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
	
	local particle_rot_fx = ParticleManager:CreateParticle(particle_rot, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_rot_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_rot_fx, 1, Vector(aura_radius, 1, 1))	
end

-- Tower Aura
modifier_imba_tower_plague_aura = class({})

function modifier_imba_tower_plague_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_plague_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_tower_plague_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_tower_plague_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_plague_aura:GetModifierAura()
	return "modifier_imba_tower_plague_aura_debuff"
end

function modifier_imba_tower_plague_aura:IsAura()
	return true
end

function modifier_imba_tower_plague_aura:IsDebuff()
	return false
end

function modifier_imba_tower_plague_aura:IsHidden()
	return true
end

function modifier_imba_tower_plague_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Attack Speed/Move speed Modifier
modifier_imba_tower_plague_aura_debuff = class({})

function modifier_imba_tower_plague_aura_debuff:IsHidden()
	return false
end

function modifier_imba_tower_plague_aura_debuff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
						 MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
		
		return decFuncs	
end

function modifier_imba_tower_plague_aura_debuff:GetModifierMoveSpeedBonus_Percentage()	
	-- Ability properties	
	local caster = self:GetCaster()
	local ability = self:GetAbility()			
	
	-- Ability specials
	local ms_slow = ability:GetSpecialValueFor("ms_slow")
	local additional_slow_per_protective = ability:GetSpecialValueFor("additional_slow_per_protective")	
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	local ms_slow_total = ms_slow + additional_slow_per_protective * protective_instinct_stacks	
	return ms_slow_total
end

function modifier_imba_tower_plague_aura_debuff:GetModifierAttackSpeedBonus_Constant()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()	
	
	-- Ability specials
	local as_slow = ability:GetSpecialValueFor("as_slow")
	local additional_slow_per_protective = ability:GetSpecialValueFor("additional_slow_per_protective")	
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	local as_slow_total = as_slow + additional_slow_per_protective * protective_instinct_stacks	
	return as_slow_total
end



---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Atrophy Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_atrophy = class({})
LinkLuaModifier("modifier_imba_tower_atrophy_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_atrophy_aura_debuff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_atrophy:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_atrophy_aura"
	local particle_rot = "particles/units/heroes/hero_pudge/pudge_rot_radius.vpcf"
	
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end	
end

-- Tower Aura
modifier_imba_tower_atrophy_aura = class({})

function modifier_imba_tower_atrophy_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_atrophy_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_tower_atrophy_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_tower_atrophy_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_atrophy_aura:GetModifierAura()
	return "modifier_imba_tower_atrophy_aura_debuff"
end

function modifier_imba_tower_atrophy_aura:IsAura()
	return true
end

function modifier_imba_tower_atrophy_aura:IsDebuff()
	return false
end

function modifier_imba_tower_atrophy_aura:IsHidden()
	return true
end

function modifier_imba_tower_atrophy_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Attack damage reduction Modifier
modifier_imba_tower_atrophy_aura_debuff = class({})

function modifier_imba_tower_atrophy_aura_debuff:IsHidden()
	return false
end

function modifier_imba_tower_atrophy_aura_debuff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE}
		
		return decFuncs	
end

function modifier_imba_tower_atrophy_aura_debuff:GetModifierBaseDamageOutgoing_Percentage()	
	-- Ability properties	
	local caster = self:GetCaster()
	local ability = self:GetAbility()			
	
	-- Ability specials
	local damage_reduction = ability:GetSpecialValueFor("damage_reduction")
	local additional_dr_per_protective = ability:GetSpecialValueFor("additional_dr_per_protective")	
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	local total_damage_reduction = damage_reduction + additional_dr_per_protective * protective_instinct_stacks	
	return total_damage_reduction
end



---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Regeneration Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_regeneration = class({})
LinkLuaModifier("modifier_imba_tower_regeneration_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_regeneration_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_regeneration:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_regeneration_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_regeneration_aura = class({})

function modifier_imba_tower_regeneration_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_regeneration_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_regeneration_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_regeneration_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_regeneration_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_regeneration_aura:GetModifierAura()
	return "modifier_imba_tower_regeneration_aura_buff"
end

function modifier_imba_tower_regeneration_aura:IsAura()
	return true
end

function modifier_imba_tower_regeneration_aura:IsDebuff()
	return false
end

function modifier_imba_tower_regeneration_aura:IsHidden()
	return true
end

function modifier_imba_tower_regeneration_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- HP Regen Modifier
modifier_imba_tower_regeneration_aura_buff = class({})

function modifier_imba_tower_regeneration_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_regeneration_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE}
		
		return decFuncs	
end

function modifier_imba_tower_regeneration_aura_buff:GetModifierHealthRegenPercentage()	
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()		
	local parent = self:GetParent()
	
	-- Ability specials
	local hp_regen = ability:GetSpecialValueFor("hp_regen")
	local bonus_hp_regen_per_protective = ability:GetSpecialValueFor("bonus_hp_regen_per_protective")	
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	local hp_regen_total = hp_regen + bonus_hp_regen_per_protective * protective_instinct_stacks	
	return hp_regen_total
end



---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Starlight Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_starlight = class({})
LinkLuaModifier("modifier_imba_tower_starlight_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_starlight_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_starlight_debuff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_starlight:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_starlight_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_starlight_aura = class({})

function modifier_imba_tower_starlight_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_starlight_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_starlight_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_starlight_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_starlight_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_starlight_aura:GetModifierAura()
	return "modifier_imba_tower_starlight_aura_buff"
end

function modifier_imba_tower_starlight_aura:IsAura()
	return true
end

function modifier_imba_tower_starlight_aura:IsDebuff()
	return false
end

function modifier_imba_tower_starlight_aura:IsHidden()
	return true
end

function modifier_imba_tower_starlight_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Blind infliction Modifier
modifier_imba_tower_starlight_aura_buff = class({})

function modifier_imba_tower_starlight_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_starlight_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}
		
		return decFuncs	
end

function modifier_imba_tower_starlight_aura_buff:OnAttackLanded( keys )	
	-- Ability properties
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()				
		local attacker = keys.attacker
		local target = keys.target	
		local blind_debuff = "modifier_imba_tower_starlight_debuff"
		local particle_beam = "particles/econ/items/luna/luna_lucent_ti5/luna_lucent_beam_impact_bits_ti_5.vpcf"
			
		-- Ability specials		
		local blind_duration = ability:GetSpecialValueFor("blind_duration")			
		local blind_chance = ability:GetSpecialValueFor("blind_chance")		
			
		-- Only apply if the parent is the victim and the attacker is on the opposite team
		if parent == attacker and attacker:GetTeamNumber() ~= target:GetTeamNumber() then
			local roll_chance = RandomInt(1,100)			
			
			if roll_chance <= blind_chance then
				-- Apply effect
				local particle_beam_fx = ParticleManager:CreateParticle(particle_beam, PATTACH_ABSORIGIN_FOLLOW, target)
				ParticleManager:SetParticleControl(particle_beam_fx, 0, target:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_beam_fx, 1, target:GetAbsOrigin())
				
				-- Add blindness modifier
				target:AddNewModifier(caster, ability, blind_debuff, {duration = blind_duration})
			end
		end
	end	
end


-- Blind debuff
modifier_imba_tower_starlight_debuff = class({})

function modifier_imba_tower_starlight_debuff:IsHidden()
	return false
end

function modifier_imba_tower_starlight_debuff:IsPurgable()
	return true
end

function modifier_imba_tower_starlight_debuff:IsDebuff()
	return true
end

function modifier_imba_tower_starlight_debuff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_MISS_PERCENTAGE}
		
		return decFuncs	
end
		 
function modifier_imba_tower_starlight_debuff:GetModifierMiss_Percentage()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()	
	
	-- Ability specials
	local miss_chance = ability:GetSpecialValueFor("miss_chance") 
	local additional_miss_per_protective = ability:GetSpecialValueFor("additional_miss_per_protective")
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks				
	
	-- Calculate miss chance
	local total_miss_chance = miss_chance + additional_miss_per_protective * protective_instinct_stacks
	
	return total_miss_chance	
end

function modifier_imba_tower_starlight_debuff:GetEffectName()
	return "particles/ambient/tower_laser_blind.vpcf"
end

function modifier_imba_tower_starlight_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end



---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Grievous Wounds Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_grievous_wounds = class({})
LinkLuaModifier("modifier_imba_tower_grievous_wounds_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_grievous_wounds_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_grievous_wounds_debuff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_grievous_wounds:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_grievous_wounds_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_grievous_wounds_aura = class({})

function modifier_imba_tower_grievous_wounds_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_grievous_wounds_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_grievous_wounds_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_imba_tower_grievous_wounds_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_grievous_wounds_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_tower_grievous_wounds_aura:GetModifierAura()
	return "modifier_imba_tower_grievous_wounds_aura_buff"
end

function modifier_imba_tower_grievous_wounds_aura:IsAura()
	return true
end

function modifier_imba_tower_grievous_wounds_aura:IsDebuff()
	return false
end

function modifier_imba_tower_grievous_wounds_aura:IsHidden()
	return true
end

function modifier_imba_tower_grievous_wounds_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Grievous infliction Modifier
modifier_imba_tower_grievous_wounds_aura_buff = class({})

function modifier_imba_tower_grievous_wounds_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_grievous_wounds_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}
		
		return decFuncs	
end

function modifier_imba_tower_grievous_wounds_aura_buff:OnAttackLanded( keys )	
	-- Ability properties
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()				
		local attacker = keys.attacker
		local target = keys.target	
		local grievous_debuff = "modifier_imba_tower_grievous_wounds_debuff"		
			
		-- Ability specials		
		local damage_increase = ability:GetSpecialValueFor("damage_increase")			
		local damage_increase_per_hero = ability:GetSpecialValueFor("damage_increase_per_hero")		
		local debuff_duration = ability:GetSpecialValueFor("debuff_duration")
		local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks				
			
		-- Only apply if the parent is the victim and the attacker is on the opposite team
		if parent == attacker and attacker:GetTeamNumber() ~= target:GetTeamNumber() then
		
			-- Add debuff modifier. Increment stack count and refresh
			if not target:HasModifier(grievous_debuff) then
				target:AddNewModifier(caster, ability, grievous_debuff, {duration = debuff_duration})
			end
			
			local grievous_debuff_handler = target:FindModifierByName(grievous_debuff)
			
			grievous_debuff_handler:IncrementStackCount()
			grievous_debuff_handler:ForceRefresh()

			-- Calculate damage based on stacks
			local grievous_stacks = grievous_debuff_handler:GetStackCount()
			local damage = (damage_increase + damage_increase_per_hero * protective_instinct_stacks) * grievous_stacks			
			
			-- Apply damage
			local damageTable = {victim = target,
								 attacker = parent,
								 damage = damage,
								 damage_type = DAMAGE_TYPE_PHYSICAL}
									
			ApplyDamage(damageTable)				
		end
	end	
end


-- Fury Swipes debuff
modifier_imba_tower_grievous_wounds_debuff = class({})

function modifier_imba_tower_grievous_wounds_debuff:IsHidden()
	return false
end

function modifier_imba_tower_grievous_wounds_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_tower_grievous_wounds_debuff:IsPurgable()
	return true
end

function modifier_imba_tower_grievous_wounds_debuff:IsDebuff()
	return true
end

function modifier_imba_tower_grievous_wounds_debuff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end

function modifier_imba_tower_grievous_wounds_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end








---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--		   Tower's Essence Drain Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_essence_drain = class({})
LinkLuaModifier("modifier_imba_tower_essence_drain_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_essence_drain_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_essence_drain_debuff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_essence_drain_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_essence_drain:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_essence_drain_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_essence_drain_aura = class({})

function modifier_imba_tower_essence_drain_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_essence_drain_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_essence_drain_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_imba_tower_essence_drain_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_essence_drain_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_tower_essence_drain_aura:GetModifierAura()
	return "modifier_imba_tower_essence_drain_aura_buff"
end

function modifier_imba_tower_essence_drain_aura:IsAura()
	return true
end

function modifier_imba_tower_essence_drain_aura:IsDebuff()
	return false
end

function modifier_imba_tower_essence_drain_aura:IsHidden()
	return true
end

function modifier_imba_tower_essence_drain_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Essence Drain infliction Modifier
modifier_imba_tower_essence_drain_aura_buff = class({})

function modifier_imba_tower_essence_drain_aura_buff:OnCreated()
	if IsServer() then
		-- Set the hero's main attribute in custom nettable for client use
		local parent = self:GetParent()
		local primary_attribute = parent:GetPrimaryAttribute()
	
		CustomNetTables:SetTableValue( "player_table", tostring(parent:GetPlayerOwnerID()).."tower_essence_drain", { primary_attribute = primary_attribute})			
	end	
end


function modifier_imba_tower_essence_drain_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_essence_drain_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}
		
		return decFuncs	
end

function modifier_imba_tower_essence_drain_aura_buff:OnAttackLanded( keys )	
	-- Ability properties
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()				
		local attacker = keys.attacker
		local target = keys.target	
		local drain_debuff = "modifier_imba_tower_essence_drain_debuff"		
		local drain_buff = "modifier_imba_tower_essence_drain_buff"
		local particle_drain = "particles/econ/items/slark/slark_ti6_blade/slark_ti6_blade_essence_shift.vpcf"
		
		-- Ability specials		
		local duration = ability:GetSpecialValueFor("duration")
		local duration_per_protective = ability:GetSpecialValueFor("duration_per_protective")
		local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks				
			
		-- Only apply if the parent is the attacker and the victim is on the opposite team
		if parent == attacker and attacker:GetTeamNumber() ~= target:GetTeamNumber() then
			-- Apply effect
			local particle_drain_fx = ParticleManager:CreateParticle(particle_drain, PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControl(particle_drain_fx, 0, target:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_drain_fx, 1, parent:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_drain_fx, 2, parent:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_drain_fx, 3, parent:GetAbsOrigin())
		
			-- Calculate duration
			local total_duration = duration + duration_per_protective * protective_instinct_stacks
		
			-- Add debuff modifier to the enemy Increment stack count and refresh
			if not target:HasModifier(drain_debuff) then
				target:AddNewModifier(caster, ability, drain_debuff, {duration = total_duration})
			end
			
			local drain_debuff_handler = target:FindModifierByName(drain_debuff)
			
			drain_debuff_handler:IncrementStackCount()
			drain_debuff_handler:ForceRefresh()						
			
			-- Add buff modifier to the attacker.
			if not parent:HasModifier(drain_buff) then
				parent:AddNewModifier(caster, ability, drain_buff, {duration = total_duration})
			end
			
			local drain_buff_handler = parent:FindModifierByName(drain_buff)
			
			drain_buff_handler:IncrementStackCount()
			drain_buff_handler:ForceRefresh()
		end
	end	
end


-- Essence Drain debuff (enemy)
modifier_imba_tower_essence_drain_debuff = class({})

function modifier_imba_tower_essence_drain_debuff:OnStackCountChanged()
	if IsServer() then
		-- Set a timer for each separate instance of the debuff	
		local duration = self:GetDuration()
		
		Timers:CreateTimer(duration-0.01, function()
			if not self:IsNull() then
				local stacks = self:GetStackCount()
				
				if stacks > 1 then
					self:DecrementStackCount()
				else	
					self:Destroy()
				end	

			end
		end)
	end	
end
	
function modifier_imba_tower_essence_drain_debuff:IsHidden()
	return false
end

function modifier_imba_tower_essence_drain_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_tower_essence_drain_debuff:IsPurgable()
	return true
end

function modifier_imba_tower_essence_drain_debuff:IsDebuff()
	return true
end

function modifier_imba_tower_essence_drain_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					  MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}
		
	return decFuncs	
end

function modifier_imba_tower_essence_drain_debuff:GetModifierBonusStats_Agility()
	local ability = self:GetAbility()
	local stat_drain_amount_enemy = ability:GetSpecialValueFor("stat_drain_amount_enemy")
	local stacks = self:GetStackCount()
	
	local stats_drain = stat_drain_amount_enemy * stacks
	return stats_drain
end

function modifier_imba_tower_essence_drain_debuff:GetModifierBonusStats_Intellect()
	local ability = self:GetAbility()
	local stat_drain_amount_enemy = ability:GetSpecialValueFor("stat_drain_amount_enemy")
	local stacks = self:GetStackCount()
	
	local stats_drain = stat_drain_amount_enemy * stacks
	return stats_drain
end

function modifier_imba_tower_essence_drain_debuff:GetModifierBonusStats_Strength()
	local ability = self:GetAbility()
	local stat_drain_amount_enemy = ability:GetSpecialValueFor("stat_drain_amount_enemy")
	local stacks = self:GetStackCount()
	
	local stats_drain = stat_drain_amount_enemy * stacks
	return stats_drain
end

-- Essence Drain buff (ally)
modifier_imba_tower_essence_drain_buff = class({})

function modifier_imba_tower_essence_drain_buff:OnStackCountChanged()
	if IsServer() then
		-- Set a timer for each separate instance of the debuff	
		local duration = self:GetDuration()
		
		Timers:CreateTimer(duration-0.01, function()
			if not self:IsNull() then
				local stacks = self:GetStackCount()
				
				if stacks > 1 then
					self:DecrementStackCount()
				else	
					self:Destroy()
				end	
			end
		end)
	end
end

function modifier_imba_tower_essence_drain_buff:IsHidden()
	return false
end

function modifier_imba_tower_essence_drain_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_tower_essence_drain_buff:IsPurgable()
	return true
end

function modifier_imba_tower_essence_drain_buff:IsDebuff()
	return false
end

function modifier_imba_tower_essence_drain_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					  MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}
		
	return decFuncs	
end

function modifier_imba_tower_essence_drain_buff:GetModifierBonusStats_Agility()
	-- Fetch the hero's main attribute and grant bonuses if appropriate
	local primary_attribute = CustomNetTables:GetTableValue("player_table", tostring(self:GetParent():GetPlayerOwnerID()).."tower_essence_drain").primary_attribute
	
	if primary_attribute == 1 then -- agility
		local ability = self:GetAbility()
		local stat_drain_amount_ally = ability:GetSpecialValueFor("stat_drain_amount_ally")
		local stacks = self:GetStackCount()
		
		local stats_drain = stat_drain_amount_ally * stacks
		return stats_drain
	end
	
	return nil
end

function modifier_imba_tower_essence_drain_buff:GetModifierBonusStats_Intellect()
	-- Fetch the hero's main attribute and grant bonuses if appropriate
	local primary_attribute = CustomNetTables:GetTableValue("player_table", tostring(self:GetParent():GetPlayerOwnerID()).."tower_essence_drain").primary_attribute
	
	if primary_attribute == 2 then -- intelligence
		local ability = self:GetAbility()
		local stat_drain_amount_ally = ability:GetSpecialValueFor("stat_drain_amount_ally")
		local stacks = self:GetStackCount()
		
		local stats_drain = stat_drain_amount_ally * stacks
		return stats_drain
	end
	
	return nil
end

function modifier_imba_tower_essence_drain_buff:GetModifierBonusStats_Strength()
	-- Fetch the hero's main attribute and grant bonuses if appropriate	
	local primary_attribute = CustomNetTables:GetTableValue("player_table", tostring(self:GetParent():GetPlayerOwnerID()).."tower_essence_drain").primary_attribute
	
	if primary_attribute == 0 then -- strength
		local ability = self:GetAbility()
		local stat_drain_amount_ally = ability:GetSpecialValueFor("stat_drain_amount_ally")
		local stacks = self:GetStackCount()
		
		local stats_drain = stat_drain_amount_ally * stacks
		return stats_drain
	end
	
	return nil
end



---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--		   Tower's Protection Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------



imba_tower_protection = class({})
LinkLuaModifier("modifier_imba_tower_protection_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_protection_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_protection:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_protection_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_protection_aura = class({})

function modifier_imba_tower_protection_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_protection_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_protection_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_protection_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_protection_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_protection_aura:GetModifierAura()
	return "modifier_imba_tower_protection_aura_buff"
end

function modifier_imba_tower_protection_aura:IsAura()
	return true
end

function modifier_imba_tower_protection_aura:IsDebuff()
	return false
end

function modifier_imba_tower_protection_aura:IsHidden()
	return true
end

function modifier_imba_tower_protection_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Protection Modifier
modifier_imba_tower_protection_aura_buff = class({})

function modifier_imba_tower_protection_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_protection_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
		
		return decFuncs	
end

function modifier_imba_tower_protection_aura_buff:GetModifierIncomingDamage_Percentage()	
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()		
	local parent = self:GetParent()
	
	-- Ability specials
	local damage_reduction = ability:GetSpecialValueFor("damage_reduction")
	local additional_dr_per_protective = ability:GetSpecialValueFor("additional_dr_per_protective")	
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	local damage_reduction_total = damage_reduction + additional_dr_per_protective * protective_instinct_stacks	
	return damage_reduction_total
end






---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Disease Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_disease = class({})
LinkLuaModifier("modifier_imba_tower_disease_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_disease_aura_debuff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_disease:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_disease_aura"
	local particle_rot = "particles/units/heroes/hero_pudge/pudge_rot_radius.vpcf"
	
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end	
end

-- Tower Aura
modifier_imba_tower_disease_aura = class({})

function modifier_imba_tower_disease_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_disease_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_tower_disease_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_tower_disease_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_disease_aura:GetModifierAura()
	return "modifier_imba_tower_disease_aura_debuff"
end

function modifier_imba_tower_disease_aura:IsAura()
	return true
end

function modifier_imba_tower_disease_aura:IsDebuff()
	return false
end

function modifier_imba_tower_disease_aura:IsHidden()
	return true
end

function modifier_imba_tower_disease_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Attack damage reduction Modifier
modifier_imba_tower_disease_aura_debuff = class({})

function modifier_imba_tower_disease_aura_debuff:IsHidden()
	return false
end

function modifier_imba_tower_disease_aura_debuff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
						  MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
						  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}
		
		return decFuncs	
end

function modifier_imba_tower_disease_aura_debuff:GetModifierBonusStats_Agility()	
	-- Ability properties	
	local caster = self:GetCaster()
	local ability = self:GetAbility()			
	
	-- Ability specials
	local stat_reduction = ability:GetSpecialValueFor("stat_reduction")
	local additional_sr_per_protective = ability:GetSpecialValueFor("additional_sr_per_protective")	
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	local total_stat_reduction = stat_reduction + additional_sr_per_protective * protective_instinct_stacks	
	return total_stat_reduction
end

function modifier_imba_tower_disease_aura_debuff:GetModifierBonusStats_Intellect()	
	-- Ability properties	
	local caster = self:GetCaster()
	local ability = self:GetAbility()			
	
	-- Ability specials
	local stat_reduction = ability:GetSpecialValueFor("stat_reduction")
	local additional_sr_per_protective = ability:GetSpecialValueFor("additional_sr_per_protective")	
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	local total_stat_reduction = stat_reduction + additional_sr_per_protective * protective_instinct_stacks	
	return total_stat_reduction
end

function modifier_imba_tower_disease_aura_debuff:GetModifierBonusStats_Strength()	
	-- Ability properties	
	local caster = self:GetCaster()
	local ability = self:GetAbility()			
	
	-- Ability specials
	local stat_reduction = ability:GetSpecialValueFor("stat_reduction")
	local additional_sr_per_protective = ability:GetSpecialValueFor("additional_sr_per_protective")	
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	local total_stat_reduction = stat_reduction + additional_sr_per_protective * protective_instinct_stacks	
	return total_stat_reduction
end




---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Doppleganger Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_doppleganger = class({})
LinkLuaModifier("modifier_imba_tower_doppleganger_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_doppleganger_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_doppleganger_cooldown", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_doppleganger:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_doppleganger_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_doppleganger_aura = class({})

function modifier_imba_tower_doppleganger_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_doppleganger_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_doppleganger_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_SUMMONED
end

function modifier_imba_tower_doppleganger_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_doppleganger_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_tower_doppleganger_aura:GetModifierAura()
	return "modifier_imba_tower_doppleganger_aura_buff"
end

function modifier_imba_tower_doppleganger_aura:IsAura()
	return true
end

function modifier_imba_tower_doppleganger_aura:IsDebuff()
	return false
end

function modifier_imba_tower_doppleganger_aura:IsHidden()
	return true
end

function modifier_imba_tower_doppleganger_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Doppleganger Modifier
modifier_imba_tower_doppleganger_aura_buff = class({})

function modifier_imba_tower_doppleganger_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_doppleganger_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}
		
		return decFuncs	
end

function modifier_imba_tower_doppleganger_aura_buff:OnAttackLanded( keys )	
		-- Ability properties
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()		
		local particle_doppleganger = "particles/econ/items/phantom_lancer/phantom_lancer_immortal_ti6/phantom_lancer_immortal_ti6_spiritlance_cast.vpcf"
		local attacker = keys.attacker
		local target = keys.target		
		local prevention_modifier = "modifier_imba_tower_doppleganger_cooldown"
		
		-- Ability specials
		local incoming_damage = ability:GetSpecialValueFor("incoming_damage")
		local outgoing_damage = ability:GetSpecialValueFor("outgoing_damage")	
		local doppleganger_duration = ability:GetSpecialValueFor("doppleganger_duration")
		local doppleganger_cooldown = ability:GetSpecialValueFor("doppleganger_cooldown")
		local cd_reduction_per_protective = ability:GetSpecialValueFor("cd_reduction_per_protective")
		local summon_distance = ability:GetSpecialValueFor("summon_distance")
		local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks				
			
		-- If the parent is an illusion, do nothing
		if parent:IsIllusion() then
			return nil
		end
		
		-- Only apply if the parent is the victim and the attacker is on the opposite team and is not prevented
		if parent == target and attacker:GetTeamNumber() ~= parent:GetTeamNumber() and not parent:HasModifier(prevention_modifier) then		
			
			-- Create effect
			local particle_doppleganger_fx = ParticleManager:CreateParticle(particle_doppleganger, PATTACH_ABSORIGIN, parent)
			ParticleManager:SetParticleControl(particle_doppleganger_fx, 0, parent:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_doppleganger_fx, 1, parent:GetAbsOrigin())
			
			-- Calculate doppleganger origin and create it
			local rand_distance = math.random(0,summon_distance)			
			local summon_origin = parent:GetAbsOrigin() + RandomVector(rand_distance)			
			local doppleganger = CreateUnitByName(parent:GetUnitName(), summon_origin, true, parent, nil, parent:GetTeamNumber()) 			
			
			-- Set the doppleganger's level to the parent's
			local parent_level = parent:GetLevel()
			for i=1, parent_level-1 do				
				doppleganger:HeroLevelUp(false)
			end	
			
			-- Set the skill points to 0 and learn the skills of the caster
			doppleganger:SetAbilityPoints(0)
			for abilitySlot=0,15 do
				local ability = parent:GetAbilityByIndex(abilitySlot)
				if ability ~= nil then 
					local abilityLevel = ability:GetLevel()
					local abilityName = ability:GetAbilityName()
					local illusionAbility = doppleganger:FindAbilityByName(abilityName)
					illusionAbility:SetLevel(abilityLevel)
				end
			end

			 -- Recreate the items of the caster
			for itemSlot=0,5 do
				local item = parent:GetItemInSlot(itemSlot)
				if item ~= nil then
					local itemName = item:GetName()
					local newItem = CreateItem(itemName, doppleganger, doppleganger)
					doppleganger:AddItem(newItem)
				end
			end
			
			-- Set the doppleganger as controllable by the player
			doppleganger:SetControllableByPlayer(parent:GetPlayerID(), false)
			doppleganger:SetPlayerID(parent:GetPlayerID())
			
			-- Set Forward Vector the same as the player
			doppleganger:SetForwardVector(parent:GetForwardVector())
			
			-- Calculate cooldown and add a prevention modifier to the parent
			local cooldown_doppleganger = doppleganger_cooldown - cd_reduction_per_protective * protective_instinct_stacks
			parent:AddNewModifier(caster, ability, prevention_modifier, {duration = cooldown_doppleganger})
							
			-- Roll a chance to swap positions with the doppleganger
			local swap_change = RandomInt(1,2)
			if swap_change == 2 then				
				local parent_loc = parent:GetAbsOrigin()
				local doppleganger_loc = doppleganger:GetAbsOrigin()
				parent:SetAbsOrigin(doppleganger_loc)
				doppleganger:SetAbsOrigin(parent_loc)
			end
			
			-- Turn doppleganger into an illusion with the correct properties			
			doppleganger:AddNewModifier(caster, ability, "modifier_illusion", {duration = doppleganger_duration, outgoing_damage = outgoing_damage, incoming_damage = incoming_damage})			
			doppleganger:MakeIllusion()		
			
			-- Stop the attacker, since it still auto attacks the original (will force it to reaquire the closest target)
			attacker:Stop()
							
			-- Stop the illusion, since it automatically attacks everything, then decide the next step
			doppleganger:Stop()							
			
			-- Imitate target attack location
			if parent:IsAttacking() then
				local attack_target = parent:GetAttackTarget()				
				doppleganger:MoveToTargetToAttack(attack_target)
			end
			
			if parent:IsChanneling() then
				local current_ability = parent:GetCurrentActiveAbility()								
				local ability_name = current_ability:GetName()
				StartChannelingAnimation(parent, doppleganger, ability_name) -- custom function
			end
		end
	end
end

-- Doppleganger cooldown modifier
modifier_imba_tower_doppleganger_cooldown = class({})

function modifier_imba_tower_doppleganger_cooldown:IsHidden()
	return false
end

function modifier_imba_tower_doppleganger_cooldown:IsPurgable()
	return false
end

function modifier_imba_tower_doppleganger_cooldown:IsDebuff()
	return false
end

-- Custom function responsible for stopping the illusion, making it look like it's casting the 
-- same channeling spell as its original. Assigns the corrects gesture depending on the ability.
function StartChannelingAnimation (parent, doppleganger, ability_name)
	local ability_gesture
	
	local channel_4    = {"imba_bane_fiends_grip", "imba_pudge_dismember",}
    local cast_4    = {"imba_crystal_maiden_freezing_field", "imba_enigma_black_hole", "imba_sandking_epicenter", "witch_doctor_death_ward",}
    local cast_1    = {"elder_titan_echo_stomp", "keeper_of_the_light_illuminate", "oracle_fortunes_end",}
    local cast_3    = {"lion_mana_drain",} -- Should be changed in the next update to "imba_lion_mana_drain"
    
    for _,v in ipairs(channel_4) do
        if ability_name == v then
            ability_gesture = ACT_DOTA_CHANNEL_ABILITY_4
            break
        end
    end
    
    for _,v in ipairs(cast_4) do
        if ability_name == v then
            ability_gesture = ACT_DOTA_CAST_ABILITY_4
            break
        end
    end
    
    for _,v in ipairs(cast_1) do
        if ability_name == v then
            ability_gesture = ACT_DOTA_CAST_ABILITY_1
            break
        end
    end
    
    for _,v in ipairs(cast_3) do
        if ability_name == v then
            ability_gesture = ACT_DOTA_CAST_ABILITY_3 
            break
        end
    end    
		
	-- If a target is channeling a spell that doesn't really have an animation, ignore it.
	if ability_gesture == nil then
		return nil
	end
	
	-- Start animation, stop movement, and stop attacking
	doppleganger:StartGesture(ability_gesture)
	doppleganger:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
	doppleganger:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
		-- Check if parent is still casting, otherwise stop the gesture and return the attack capability
	Timers:CreateTimer(0.1, function()
		if not parent:IsChanneling() then			
			doppleganger:FadeGesture(ability_gesture)
			doppleganger:SetAttackCapability(parent:GetAttackCapability())
			doppleganger:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
			return nil
		end					
		return 0.1						
	end)
end








---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--		   Tower's Barrier Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------



imba_tower_barrier = class({})
LinkLuaModifier("modifier_imba_tower_barrier_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_barrier_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_barrier_aura_cooldown", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_barrier:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_barrier_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_barrier_aura = class({})

function modifier_imba_tower_barrier_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_barrier_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_barrier_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_barrier_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_barrier_aura:GetAuraEntityReject( target )
	local prevention_modifier = "modifier_imba_tower_barrier_aura_cooldown"
	if target:HasModifier(prevention_modifier) then
		return true -- reject
	end
	
	return false
end

function modifier_imba_tower_barrier_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_barrier_aura:GetModifierAura()
	return "modifier_imba_tower_barrier_aura_buff"
end

function modifier_imba_tower_barrier_aura:IsAura()
	return true
end

function modifier_imba_tower_barrier_aura:IsDebuff()
	return false
end

function modifier_imba_tower_barrier_aura:IsHidden()
	return true
end

function modifier_imba_tower_barrier_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Barrier Modifier
modifier_imba_tower_barrier_aura_buff = class({})

function modifier_imba_tower_barrier_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_barrier_aura_buff:GetEffectName()
	return "particles/hero/tower/barrier_aura_shell.vpcf"
end

function modifier_imba_tower_barrier_aura_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_tower_barrier_aura_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_tower_barrier_aura_buff:OnCreated()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local parent = self:GetParent()	
	
	-- Ability specials
	local base_maxdamage = ability:GetSpecialValueFor("base_maxdamage")	
	local maxdamage_per_protective = ability:GetSpecialValueFor("maxdamage_per_protective")
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	parent.tower_barrier_damage = 0
	parent.tower_barrier_max = base_maxdamage
	
	-- Calculate max damage to show on modifier creation
	local show_stacks = base_maxdamage + maxdamage_per_protective * protective_instinct_stacks
	self:SetStackCount(show_stacks)
	
	self:StartIntervalThink(0.1)
end

function modifier_imba_tower_barrier_aura_buff:OnIntervalThink()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local parent = self:GetParent()	
		
		-- Ability specials
		local base_maxdamage = ability:GetSpecialValueFor("base_maxdamage")
		local maxdamage_per_protective = ability:GetSpecialValueFor("maxdamage_per_protective")
		local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
		
		parent.tower_barrier_max = base_maxdamage + maxdamage_per_protective * protective_instinct_stacks			
		
		self:SetStackCount(parent.tower_barrier_max - parent.tower_barrier_damage)	
	end
end

-- Barrier cooldown modifier
modifier_imba_tower_barrier_aura_cooldown = class({})

function modifier_imba_tower_barrier_aura_cooldown:IsHidden()
	return false
end

function modifier_imba_tower_barrier_aura_cooldown:IsPurgable()
	return false
end

function modifier_imba_tower_barrier_aura_cooldown:IsDebuff()
	return false
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Tower's Soul Leech Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_soul_leech = class({})
LinkLuaModifier("modifier_imba_tower_soul_leech_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_soul_leech_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)


function imba_tower_soul_leech:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_soul_leech_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_soul_leech_aura = class({})

function modifier_imba_tower_soul_leech_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_soul_leech_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_soul_leech_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_tower_soul_leech_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_soul_leech_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_tower_soul_leech_aura:GetModifierAura()
	return "modifier_imba_tower_soul_leech_aura_buff"
end

function modifier_imba_tower_soul_leech_aura:IsAura()
	return true
end

function modifier_imba_tower_soul_leech_aura:IsDebuff()
	return false
end

function modifier_imba_tower_soul_leech_aura:IsHidden()
	return true
end

function modifier_imba_tower_soul_leech_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Leech Modifier
modifier_imba_tower_soul_leech_aura_buff = class({})

function modifier_imba_tower_soul_leech_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_soul_leech_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_TAKEDAMAGE}
		
		return decFuncs	
end

function modifier_imba_tower_soul_leech_aura_buff:OnTakeDamage( keys )
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	local particle_lifesteal = "particles/generic_gameplay/generic_lifesteal.vpcf"
	local particle_spellsteal = "particles/items3_fx/octarine_core_lifesteal.vpcf"	
	local attacker = keys.attacker
	local target = keys.unit
	local damage = keys.damage
	local damage_type = keys.damage_type
	
	-- Ability specials
	local soul_leech_pct = ability:GetSpecialValueFor("soul_leech_pct")
	local leech_per_protective = ability:GetSpecialValueFor("leech_per_protective")
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	local creep_lifesteal_pct = ability:GetSpecialValueFor("creep_lifesteal_pct")
		
	
	-- Only apply if the parent of this buff attacked an enemy
	if attacker == parent and parent:GetTeamNumber() ~= target:GetTeamNumber() then			
		
		-- Play appropriate effect depending on damage type
		if damage_type == DAMAGE_TYPE_MAGICAL or damage_type == DAMAGE_TYPE_PURE then			
			local particle_spellsteal_fx = ParticleManager:CreateParticle(particle_spellsteal, PATTACH_ABSORIGIN, attacker)
			ParticleManager:SetParticleControl(particle_spellsteal_fx, 0, attacker:GetAbsOrigin())
		end
		
		if damage_type == DAMAGE_TYPE_PHYSICAL then			
			local particle_lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN, attacker)
			ParticleManager:SetParticleControl(particle_lifesteal_fx, 0, attacker:GetAbsOrigin())
		end
		
		-- Calculate life/spell steal
		soul_leech_total = soul_leech_pct + leech_per_protective * protective_instinct_stacks
		
		-- Decrease heal if the target is a creep
		if target:IsCreep() then
			soul_leech_total = soul_leech_total * (creep_lifesteal_pct/100)
		end
				
		-- Heal caster by damage, only if damage isn't negative (to prevent negative heal)
		if damage > 0 then
			local heal_amount = damage * (soul_leech_total/100)
			parent:Heal(heal_amount, parent)
		end
	end
end








---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--		   Tower's Frost Shroud Aura
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_tower_frost_shroud = class({})
LinkLuaModifier("modifier_imba_tower_frost_shroud_aura", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_frost_shroud_aura_buff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tower_frost_shroud_debuff", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_frost_shroud:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_tower_frost_shroud_aura"
		
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end
end

-- Tower Aura
modifier_imba_tower_frost_shroud_aura = class({})

function modifier_imba_tower_frost_shroud_aura:GetAuraDuration()
	local ability = self:GetAbility()
	local aura_stickyness = ability:GetSpecialValueFor("aura_stickyness")
	
	return aura_stickyness
end

function modifier_imba_tower_frost_shroud_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius
end

function modifier_imba_tower_frost_shroud_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_imba_tower_frost_shroud_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_tower_frost_shroud_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_tower_frost_shroud_aura:GetModifierAura()
	return "modifier_imba_tower_frost_shroud_aura_buff"
end

function modifier_imba_tower_frost_shroud_aura:IsAura()
	return true
end

function modifier_imba_tower_frost_shroud_aura:IsDebuff()
	return false
end

function modifier_imba_tower_frost_shroud_aura:IsHidden()
	return true
end

function modifier_imba_tower_frost_shroud_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

-- Frost Shroud trigger Modifier
modifier_imba_tower_frost_shroud_aura_buff = class({})

function modifier_imba_tower_frost_shroud_aura_buff:OnCreated()
	if IsServer() then
		-- Set the hero's main attribute in custom nettable for client use
		local parent = self:GetParent()
		local primary_attribute = parent:GetPrimaryAttribute()
	
		CustomNetTables:SetTableValue( "player_table", tostring(parent:GetPlayerOwnerID()).."tower_essence_drain", { primary_attribute = primary_attribute})			
	end	
end


function modifier_imba_tower_frost_shroud_aura_buff:IsHidden()
	return false
end

function modifier_imba_tower_frost_shroud_aura_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_TAKEDAMAGE}
		
		return decFuncs	
end

function modifier_imba_tower_frost_shroud_aura_buff:OnTakeDamage( keys )	
	-- Ability properties
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()				
		local attacker = keys.attacker
		local target = keys.unit
		local frost_debuff = "modifier_imba_tower_frost_shroud_debuff"				
		local frost_drain = "particles/hero/tower/tower_frost_shroud.vpcf"
		
		-- Ability specials		
		local frost_shroud_chance = ability:GetSpecialValueFor("frost_shroud_chance")
		local frost_shroud_duration = ability:GetSpecialValueFor("frost_shroud_duration")
		local aoe_radius = ability:GetSpecialValueFor("aoe_radius")				
			
		-- Only apply if the parent is the victim and the attacker is on the opposite team
		if parent == target and attacker:GetTeamNumber() ~= target:GetTeamNumber() then
						
			-- Roll for a proc
			local rand = RandomInt(1,100)
			if rand <= frost_shroud_chance then
				-- Apply effect
				local particle_frost_fx = ParticleManager:CreateParticle(frost_drain, PATTACH_ABSORIGIN, target)
				ParticleManager:SetParticleControl(particle_frost_fx, 0, parent:GetAbsOrigin())			
				ParticleManager:SetParticleControl(particle_frost_fx, 1, Vector(1, 1, 1))
			
				-- Find all enemies in the aoe radius of the blast
				local enemies = FindUnitsInRadius(parent:GetTeamNumber(),
  												  parent:GetAbsOrigin(),
												  nil,
												  aoe_radius,
												  DOTA_UNIT_TARGET_TEAM_ENEMY,
												  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
												  DOTA_UNIT_TARGET_FLAG_NONE,
												  FIND_ANY_ORDER,
												  false)
												  
				for _, enemy in pairs(enemies) do
					-- Add debuff modifier to the enemy Increment stack count and refresh
					if not enemy:HasModifier(frost_debuff) then
						enemy:AddNewModifier(caster, ability, frost_debuff, {duration = frost_shroud_duration})
					end
					
					local frost_debuff_handler = enemy:FindModifierByName(frost_debuff)					
					frost_debuff_handler:IncrementStackCount()
					frost_debuff_handler:ForceRefresh()						
				end
			end
		end
	end	
end


-- Frost Shroud debuff (enemy)
modifier_imba_tower_frost_shroud_debuff = class({})

function modifier_imba_tower_frost_shroud_debuff:OnStackCountChanged()
	if IsServer() then
		-- Set a timer for each separate instance of the debuff	
		local duration = self:GetDuration()
		
		Timers:CreateTimer(duration-0.01, function()
			if not self:IsNull() then
				local stacks = self:GetStackCount()
				
				if stacks > 1 then
					self:DecrementStackCount()
				else	
					self:Destroy()
				end	

			end
		end)
	end	
end
	
function modifier_imba_tower_frost_shroud_debuff:IsHidden()
	return false
end

function modifier_imba_tower_frost_shroud_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_tower_frost_shroud_debuff:IsPurgable()
	return true
end

function modifier_imba_tower_frost_shroud_debuff:IsDebuff()
	return true
end

function modifier_imba_tower_frost_shroud_debuff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
						 MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
		
		return decFuncs	
end

function modifier_imba_tower_frost_shroud_debuff:GetModifierMoveSpeedBonus_Percentage()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	
	-- Ability specials
	local ms_slow = ability:GetSpecialValueFor("ms_slow")
	local slow_per_protective = ability:GetSpecialValueFor("slow_per_protective")
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	-- Calculate slow percentage, based on stack count
	local movespeed_slow = (ms_slow + slow_per_protective * protective_instinct_stacks) * self:GetStackCount()
	
	return movespeed_slow
end

function modifier_imba_tower_frost_shroud_debuff:GetModifierAttackSpeedBonus_Constant()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	
	-- Ability specials
	local as_slow = ability:GetSpecialValueFor("as_slow")
	local slow_per_protective = ability:GetSpecialValueFor("slow_per_protective")
	local protective_instinct_stacks = CustomNetTables:GetTableValue("towers", tostring(caster:GetName())).protective_instinct_stacks	
	
	-- Calculate slow percentage, based on stack count
	local attackspeed_slow = (as_slow + slow_per_protective * protective_instinct_stacks) * self:GetStackCount()
	
	return attackspeed_slow
end




imba_tower_healing_tower = class({})
LinkLuaModifier("modifier_tower_healing_think", "hero/tower_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_tower_healing_tower:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local thinker_modifier = "modifier_tower_healing_think"
		
	if not caster:HasModifier(thinker_modifier) then
		caster:AddNewModifier(caster, ability, thinker_modifier, {})
	end
end

modifier_tower_healing_think = class({})

function modifier_tower_healing_think:OnCreated()
	if IsServer() then		
		self:StartIntervalThink(0.2)
	end
end

function modifier_tower_healing_think:OnIntervalThink()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local ability_level = ability:GetLevel() - 1
		local particle_heal = "particles/hero/tower/tower_healing_wave.vpcf"		
		
		-- Ability specials
		local search_radius = ability:GetSpecialValueFor("search_radius")
		local bounce_delay = ability:GetSpecialValueFor("bounce_delay")		
		local hp_threshold = ability:GetSpecialValueFor("hp_threshold")
		local bounce_radius = ability:GetSpecialValueFor("bounce_radius")
		
		-- If ability is on cooldown, do nothing		
		if not ability:IsCooldownReady() then
			return nil
		end
		
		-- Set variables
		local healing_in_process = false
		local current_healed_hero
		local heroes
		
		-- Clear heroes healed marker
		heroes = FindUnitsInRadius(caster:GetTeamNumber(),
										  caster:GetAbsOrigin(),
										  nil,
										  50000,
										  DOTA_UNIT_TARGET_TEAM_FRIENDLY,
										  DOTA_UNIT_TARGET_HERO,
										  DOTA_UNIT_TARGET_FLAG_NONE,
										  FIND_ANY_ORDER,
										  false)
		for _, hero in pairs(heroes) do
			hero.healed_by_healing_wave = false
		end
		
		-- Look for heroes that need healing		
		heroes = FindUnitsInRadius(caster:GetTeamNumber(),
										  caster:GetAbsOrigin(),
										  nil,
										  search_radius,
										  DOTA_UNIT_TARGET_TEAM_FRIENDLY,
										  DOTA_UNIT_TARGET_HERO,
										  DOTA_UNIT_TARGET_FLAG_NONE,
										  FIND_ANY_ORDER,
										  false)
		
		-- Find at least one hero that needs healing, and heal him
		for _, hero in pairs(heroes) do
		
			local hero_hp_percent = hero:GetHealthPercent()
			if hero_hp_percent <= hp_threshold then
				current_healed_hero = hero
				HealingWaveBounce(caster, caster, ability, hero)				
				ability:StartCooldown(ability:GetCooldown(ability_level))
				break
			end
		end
		
		-- No hero was found that needed healing
		if not current_healed_hero then
			return nil
		end
		
		-- Start bouncing with bounce delay		
		Timers:CreateTimer(bounce_delay, function()			
			-- Still don't know if other heroes need healing, assumes doesn't unless found
			local heroes_need_healing = false
			
			-- Look for other heroes nearby, regardless of if they need healing
			heroes = FindUnitsInRadius(caster:GetTeamNumber(),
											current_healed_hero:GetAbsOrigin(),
    										nil,
	   									    bounce_radius,
											DOTA_UNIT_TARGET_TEAM_FRIENDLY,
											DOTA_UNIT_TARGET_HERO,
											DOTA_UNIT_TARGET_FLAG_NONE,
											FIND_ANY_ORDER,
											false)
											
			-- Search for a hero
			for _, hero in pairs(heroes) do				
				if not hero.healed_by_healing_wave then
					heroes_need_healing = true
					HealingWaveBounce(caster, current_healed_hero, ability, hero)
					current_healed_hero = hero
					break
				end	
			end
			
			-- If a hero was found, there might be more: repeat operation
			if heroes_need_healing then
				return bounce_delay
			else
				return nil
			end		
		end)		
	end
end

function HealingWaveBounce (caster, source, ability, hero)
	local sound_cast = "Greevil.Shadow_Wave"
	local particle_heal = "particles/hero/tower/tower_healing_wave.vpcf"
	local heal_amount = ability:GetSpecialValueFor("heal_amount")
	
	-- Mark hero as healed
	hero.healed_by_healing_wave = true	
	
	-- Apply particle effect
	local particle_heal_fx = ParticleManager:CreateParticle(particle_heal, PATTACH_ABSORIGIN, source)
	ParticleManager:SetParticleControl(particle_heal_fx, 0, source:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_heal_fx, 1, hero:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_heal_fx, 3, source:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_heal_fx, 4, source:GetAbsOrigin())
	
	-- Play cast sound
	EmitSoundOn(sound_cast, caster)
	
	-- Heal target
	hero:Heal(heal_amount, caster)
end


function modifier_tower_healing_think:IsHidden()
	return true
end

function modifier_tower_healing_think:IsPurgable()
	return false
end














