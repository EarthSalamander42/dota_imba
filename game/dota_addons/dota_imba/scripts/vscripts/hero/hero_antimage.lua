--[[	Author: D2imba
		Date: 07.03.2015	]]

function ManaBreak( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target

	-- If the ability is disabled by Break, do nothing
	if caster:PassivesDisabled() then
		return nil
	end	

	-- If there isn't a valid target, do nothing
	if not ( target:IsHero() or target:IsCreep() or target:IsAncient() ) or target:GetMaxMana() == 0 or target:IsMagicImmune() then
		return nil
	end

	-- If this unit is an illusion, reduce the parameters by illusion_factor
	local illusion_factor = ability:GetLevelSpecialValueFor("illusion_factor", ability_level)
	if not caster:IsIllusion() then
		illusion_factor = 1
	end

	-- Parameters
	local base_mana_burn = ability:GetLevelSpecialValueFor("base_mana_burn", ability_level) * illusion_factor * FRANTIC_MULTIPLIER
	local bonus_mana_burn = ability:GetLevelSpecialValueFor('bonus_mana_burn', ability_level) * illusion_factor * 0.01
	local damage_ratio = ability:GetLevelSpecialValueFor('damage_per_burn', ability_level) / FRANTIC_MULTIPLIER

	-- Play sound
	caster:EmitSound("Hero_Antimage.ManaBreak")

	-- Play the particle
	local manaburn_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(manaburn_pfx, 0, target:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex(manaburn_pfx)

	-- Calculate and burn mana
	local target_max_mana = target:GetMaxMana()
	local mana_to_burn = base_mana_burn + target_max_mana * bonus_mana_burn
	target:ReduceMana(mana_to_burn)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, target, mana_to_burn, nil)

	-- Calculate and deal damage based on missing mana
	local target_current_mana = target:GetMana()
	local missing_mana = math.max(target_max_mana - target_current_mana, 0)
	local damage = missing_mana * damage_ratio
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
end

function Magehunter( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local cast_ability = keys.event_ability
	local modifier_stacks = keys.modifier_stacks

	-- If the ability is disabled by Break, do nothing
	if caster:PassivesDisabled() then
		return nil
	end	

	-- If there isn't a casted ability, do nothing
	if not cast_ability then
		return nil
	end

	-- If this ability is problematic, do nothing
	if not StickProcCheck(cast_ability) then
		return nil
	end

	-- Parameters
	local mana_per_stack = ability:GetLevelSpecialValueFor("mana_per_stack", ability_level)
	local mana_spent = cast_ability:GetManaCost( cast_ability:GetLevel() - 1 ) / FRANTIC_MULTIPLIER

	-- Add damage stacks
	local stacks_to_add = math.floor( mana_spent / mana_per_stack )
	if stacks_to_add > 0 then
		for i = 1, stacks_to_add do
			ability:ApplyDataDrivenModifier(caster, caster, modifier_stacks, {})
		end
	end
end

function MagehunterCreate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_counter = keys.modifier_counter

	-- Parameters
	local scale_up = ability:GetLevelSpecialValueFor("scale_up", ability_level)

	-- Add a stack of the counter modifier
	AddStacks(ability, caster, caster, modifier_counter, 1, true)
end

function MagehunterDestroy( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_counter = keys.modifier_counter

	-- Parameters
	local scale_up = ability:GetLevelSpecialValueFor("scale_up", ability_level)

	-- If this is the last stack, remove the counter modifier
	if caster:GetModifierStackCount(modifier_counter, caster) <= 1 then
		caster:RemoveModifierByName(modifier_counter)
	else
		AddStacks(ability, caster, caster, modifier_counter, -1, false)
	end
end

function ManaVoid( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() -1
	local scepter = HasScepter(caster)

	-- Parameters
	local damage_per_mana = ability:GetLevelSpecialValueFor('mana_void_damage_per_mana', ability_level) / FRANTIC_MULTIPLIER
	local radius = ability:GetLevelSpecialValueFor('mana_void_aoe_radius', ability_level)
	local mana_burn_pct = ability:GetLevelSpecialValueFor('mana_void_mana_burn_pct', ability_level)
	local secondary_mana_pct = 0
	local damage = 0

	-- If the caster has a scepter, add secondary targets' mana contribution
	if scepter then
		secondary_mana_pct = ability:GetLevelSpecialValueFor('secondary_mana_scepter', ability_level)
	end
	
	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end
	
	-- Burn main target's mana
	local target_mana_burn = target:GetMaxMana() * mana_burn_pct / 100
	target:ReduceMana(target_mana_burn)

	-- Find all enemies in the area of effect
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(nearby_enemies) do

		-- Calculate this enemy's damage contribution
		local this_enemy_damage = (enemy:GetMaxMana() - enemy:GetMana()) * damage_per_mana

		-- If this is not the main target, weight its damage contribution
		if enemy ~= target then
			this_enemy_damage = this_enemy_damage * secondary_mana_pct / 100
		end

		-- Add this enemy's contribution to the damage tally
		damage = damage + this_enemy_damage
	end

	-- Damage all enemies in the area for the total damage tally
	for _,enemy in pairs(nearby_enemies) do
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage, nil)
	end

	-- Shake screen due to excessive PURITY OF WILL
	ScreenShake(target:GetOrigin(), 10, 0.1, 1, 500, 0, true)
end