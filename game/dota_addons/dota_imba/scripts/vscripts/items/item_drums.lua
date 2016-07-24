--[[	Author: Firetoad
		Date:	24.07.2016	]]

function Drums( keys )
	local caster = keys.caster
	local ability = keys.ability
	local sound_cast = keys.sound_cast
	local modifier_buff_hero = keys.modifier_buff_hero
	local modifier_buff_creep = keys.modifier_buff_creep
	local modifier_particle = keys.modifier_particle

	-- Parameters
	local radius = ability:GetSpecialValueFor("radius")
	local caster_loc = caster:GetAbsOrigin()

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Count nearby allies
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	local total_heroes = #heroes
	local total_creeps = #creeps

	-- Iterate through nearby heroes
	local max = math.max
	for _,ally in pairs(heroes) do
		
		-- Add the particle modifier
		ability:ApplyDataDrivenModifier(caster, ally, modifier_particle, {})

		-- Check for existing hero-based buffs and apply/extend them
		local current_hero_stacks = 0
		if ally:HasModifier("modifier_item_imba_siege_cuirass_buff_hero") then
			current_hero_stacks = max(current_hero_stacks, ally:GetModifierStackCount("modifier_item_imba_siege_cuirass_buff_hero", nil))
			ally:RemoveModifierByName("modifier_item_imba_siege_cuirass_buff_hero")
		end
		if ally:HasModifier("modifier_item_imba_drums_buff_hero") then
			current_hero_stacks = max(current_hero_stacks, ally:GetModifierStackCount("modifier_item_imba_drums_buff_hero", nil))
			ally:RemoveModifierByName("modifier_item_imba_drums_buff_hero")
		end
		AddStacks(ability, caster, ally, modifier_buff_hero, max(total_heroes, current_hero_stacks), true)

		-- Check for existing creep-based buffs and apply/extend them
		if total_creeps > 0 then
			local current_creep_stacks = 0
			if ally:HasModifier("modifier_item_imba_siege_cuirass_buff_creep") then
				current_creep_stacks = max(current_hero_stacks, ally:GetModifierStackCount("modifier_item_imba_siege_cuirass_buff_creep", nil))
				ally:RemoveModifierByName("modifier_item_imba_siege_cuirass_buff_creep")
			end
			if ally:HasModifier("modifier_item_imba_drums_buff_creep") then
				current_creep_stacks = max(current_hero_stacks, ally:GetModifierStackCount("modifier_item_imba_drums_buff_creep", nil))
				ally:RemoveModifierByName("modifier_item_imba_drums_buff_creep")
			end
			AddStacks(ability, caster, ally, modifier_buff_creep, max(total_creeps, current_creep_stacks), true)
		end
	end

	-- Iterate through nearby creeps
	for _,ally in pairs(creeps) do
		
		-- Add the particle modifier
		ability:ApplyDataDrivenModifier(caster, ally, modifier_particle, {})

		-- Check for existing hero-based buffs and apply/extend them
		local current_hero_stacks = 0
		if ally:HasModifier("modifier_item_imba_siege_cuirass_buff_hero") then
			current_hero_stacks = max(current_hero_stacks, ally:GetModifierStackCount("modifier_item_imba_siege_cuirass_buff_hero", nil))
			ally:RemoveModifierByName("modifier_item_imba_siege_cuirass_buff_hero")
		end
		if ally:HasModifier("modifier_item_imba_drums_buff_hero") then
			current_hero_stacks = max(current_hero_stacks, ally:GetModifierStackCount("modifier_item_imba_drums_buff_hero", nil))
			ally:RemoveModifierByName("modifier_item_imba_drums_buff_hero")
		end
		AddStacks(ability, caster, ally, modifier_buff_hero, max(total_heroes, current_hero_stacks), true)

		-- Check for existing creep-based buffs and apply/extend them
		if total_creeps > 0 then
			local current_creep_stacks = 0
			if ally:HasModifier("modifier_item_imba_siege_cuirass_buff_creep") then
				current_creep_stacks = max(current_hero_stacks, ally:GetModifierStackCount("modifier_item_imba_siege_cuirass_buff_creep", nil))
				ally:RemoveModifierByName("modifier_item_imba_siege_cuirass_buff_creep")
			end
			if ally:HasModifier("modifier_item_imba_drums_buff_creep") then
				current_creep_stacks = max(current_hero_stacks, ally:GetModifierStackCount("modifier_item_imba_drums_buff_creep", nil))
				ally:RemoveModifierByName("modifier_item_imba_drums_buff_creep")
			end
			AddStacks(ability, caster, ally, modifier_buff_creep, max(total_creeps, current_creep_stacks), true)
		end
	end
end

function DrumsAuraThink( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_aura = keys.modifier_aura

	-- If a higher-level aura is present, remove this one
	if target:HasModifier("modifier_item_imba_siege_cuirass_positive_aura") then
		if target:HasModifier(modifier_aura) then
			target:RemoveModifierByName(modifier_aura)
		end
	elseif not target:HasModifier(modifier_aura) then
		ability:ApplyDataDrivenModifier(caster, target, modifier_aura, {})
	end
end

function DrumsAuraDestroy( keys )
	local target = keys.target
	local modifier_aura = keys.modifier_aura

	-- Remove aura modifier
	target:RemoveModifierByName(modifier_aura)
end

function AssaultAllyAuraThink( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_aura = keys.modifier_aura

	-- If a higher-level aura is present, remove this one
	if target:HasModifier("modifier_item_imba_siege_cuirass_positive_aura") then
		if target:HasModifier(modifier_aura) then
			target:RemoveModifierByName(modifier_aura)
		end
	elseif not target:HasModifier(modifier_aura) then
		ability:ApplyDataDrivenModifier(caster, target, modifier_aura, {})
	end
end

function AssaultAllyAuraDestroy( keys )
	local target = keys.target
	local modifier_aura = keys.modifier_aura

	-- Remove aura modifier
	target:RemoveModifierByName(modifier_aura)
end

function AssaultEnemyAuraThink( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_aura = keys.modifier_aura

	-- If a higher-level aura is present, remove this one
	if target:HasModifier("modifier_item_imba_siege_cuirass_negative_aura") then
		if target:HasModifier(modifier_aura) then
			target:RemoveModifierByName(modifier_aura)
		end
	elseif not target:HasModifier(modifier_aura) then
		ability:ApplyDataDrivenModifier(caster, target, modifier_aura, {})
	end
end

function AssaultEnemyAuraDestroy( keys )
	local target = keys.target
	local modifier_aura = keys.modifier_aura

	-- Remove aura modifier
	target:RemoveModifierByName(modifier_aura)
end

function DrumsParticleStart( keys )
	local target = keys.target
	local particle_buff = keys.particle_buff

	-- Create particle
	target.drums_active_buff_pfx = ParticleManager:CreateParticle(particle_buff, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(target.drums_active_buff_pfx, 0, target:GetAbsOrigin())
end

function DrumsParticleEnd( keys )
	local target = keys.target
	local particle_buff = keys.particle_buff

	-- Create particle
	ParticleManager:DestroyParticle(target.drums_active_buff_pfx, true)
	ParticleManager:ReleaseParticleIndex(target.drums_active_buff_pfx)
end

function SiegeCuirassParticleStart( keys )
	local target = keys.target
	local particle_buff = keys.particle_buff

	-- Create particle
	target.siege_cuirass_active_buff_pfx = ParticleManager:CreateParticle(particle_buff, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(target.siege_cuirass_active_buff_pfx, 0, target:GetAbsOrigin())
end

function SiegeCuirassParticleEnd( keys )
	local target = keys.target
	local particle_buff = keys.particle_buff

	-- Create particle
	ParticleManager:DestroyParticle(target.siege_cuirass_active_buff_pfx, true)
	ParticleManager:ReleaseParticleIndex(target.siege_cuirass_active_buff_pfx)
end