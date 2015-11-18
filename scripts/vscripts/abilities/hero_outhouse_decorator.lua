--[[ Author: Hewdraw ]]

function ArcaneOrb( keys )
	local ability = keys.ability
	local caster = keys.caster
	local mana = caster:GetMaxMana()
	local target = keys.target
	local summon_damage = ability:GetLevelSpecialValueFor("illusion_damage", (ability:GetLevel() -1))
	local extra_damage = ability:GetLevelSpecialValueFor("mana_pool_damage_pct", (ability:GetLevel() -1)) / 100
	local int_steal = ability:GetLevelSpecialValueFor("int_gain", (ability:GetLevel() -1))
	local int_steal_pct = ability:GetLevelSpecialValueFor("int_steal_pct", (ability:GetLevel() -1))
	local int_steal_duration = ability:GetLevelSpecialValueFor("int_steal_duration", (ability:GetLevel() -1))
	local int_gain_modifier = "modifier_arcane_orb_int_gain"
	local int_loss_modifier = "modifier_arcane_orb_int_steal"
	local intellect = caster:GetIntellect()

	if target:IsRealHero() then
		local target_int = target:GetIntellect()
		local target_int_pct = target_int * (int_steal_pct / 100)

		local stack_count = caster:GetModifierStackCount(int_gain_modifier, caster)
		local stack_count_target = target:GetModifierStackCount(int_loss_modifier, caster)

		if target_int_pct > int_steal then
			stack_count = stack_count + target_int_pct
			stack_count_target = stack_count_target + target_int_pct
		else
			stack_count = stack_count + int_steal
			stack_count_target = stack_count_target + int_steal
		end

		ability:ApplyDataDrivenModifier(caster, target, int_loss_modifier, {})
		ability:ApplyDataDrivenModifier(caster, caster, int_gain_modifier, {})
		caster:SetModifierStackCount(int_gain_modifier, caster, stack_count)
		target:SetModifierStackCount(int_loss_modifier, caster, stack_count_target)
	end

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.victim = target


	if not target:IsRealHero() or target:IsSummoned() then
		damage_table.damage = mana * extra_damage + summon_damage
	else
		damage_table.damage = mana * extra_damage
	end 

	ApplyDamage(damage_table)
end

function ArcaneOrbMana( keys )
	local caster = keys.caster
	local ability_essence_aura = caster:FindAbilityByName("imba_obsidian_destroyer_essence_aura")
	local restore_amount = ability_essence_aura:GetLevelSpecialValueFor("restore_amount", (ability_essence_aura:GetLevel() -1))
	local max_mana = caster:GetMaxMana() * restore_amount / 100 
	local new_mana = caster:GetMana() + max_mana

	--caster:GiveMana(max_mana)
	--caster:RestoreMana(max_mana)

	if new_mana > caster:GetMaxMana() then
		caster:SetMana(caster:GetMaxMana())
	else
		caster:SetMana(new_mana)
	end
end

function AstralImprisonmentEnd( keys )

	local sound_name = "Hero_ObsidianDestroyer.AstralImprisonment"
	local target = keys.target

	--Stops the loop sound when the modifier ends

	StopSoundEvent(sound_name, target)

	target:RemoveNoDraw()
end

function AstralImprisonmentStart( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local int_steal = ability:GetLevelSpecialValueFor("int_gain", (ability:GetLevel() -1))
	local int_steal_pct = ability:GetLevelSpecialValueFor("int_steal_pct", (ability:GetLevel() -1))
	local dummy_modifier = "modifier_astral_imprisonment_dummy"
	local dummy_gain_modifier = "modifier_astral_imprisonment_int_gain"
	local dummy_loss_modifier = "modifier_astral_imprisonment_int_loss"
	local intellect = caster:GetIntellect()

	local stack_count = caster:GetModifierStackCount(dummy_gain_modifier, caster)
	local stack_count_target = target:GetModifierStackCount(dummy_gain_modifier, caster)

	if target ~= caster then
		local target_int = target:GetIntellect()
		local target_int_pct = target_int * (int_steal_pct / 100)

		if target_int_pct > int_steal then
			stack_count = stack_count + target_int_pct
			stack_count_target = stack_count_target + target_int_pct
		else
			stack_count = stack_count + int_steal
			stack_count_target = stack_count_target + int_steal
		end

		ability:ApplyDataDrivenModifier(caster, target, dummy_modifier, {})

		ability:ApplyDataDrivenModifier(caster, target, dummy_loss_modifier, {})
		ability:ApplyDataDrivenModifier(caster, caster, dummy_gain_modifier, {})
		caster:SetModifierStackCount(dummy_gain_modifier, caster, stack_count)
		target:SetModifierStackCount(dummy_loss_modifier, caster, stack_count_target)
	end

	target:AddNoDraw()
end

function RestoreMana( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local restore_amount = ability:GetLevelSpecialValueFor("restore_amount", (ability:GetLevel() -1))
	local max_mana = target:GetMaxMana() * restore_amount / 100 
	local new_mana = target:GetMana() + max_mana

	--target:GiveMana(max_mana)
	--target:RestoreMana(max_mana)

	if new_mana > target:GetMaxMana() then
		target:SetMana(target:GetMaxMana())
	else
		target:SetMana(new_mana)
	end
end

function EssenceAuraMana( keys )
	local caster = keys.caster
	local ability = keys.ability
	local intellect = caster:GetIntellect()
	local modifier = "modifier_essence_aura_mana"
	local modifier_dummy = "modifier_essence_aura_mana_dummy"

	caster:SetModifierStackCount(modifier, caster, intellect)

	caster:RemoveModifierByName(modifier_dummy)
	ability:ApplyDataDrivenModifier(caster, caster, modifier_dummy, {})
end

function SanityEclipse( keys )
	local caster = keys.caster
	local target = keys.target_points[ 1 ]
	local ability = keys.ability
	local od_int = caster:GetIntellect()
	local radius = 	ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() -1))
	local dmg_multiplier = ability:GetLevelSpecialValueFor("damage_multiplier", (ability:GetLevel() -1))
	local threshold = ability:GetLevelSpecialValueFor("int_threshold", (ability:GetLevel() -1))
	local dummy_modifier = "modifier_sanity_eclipse_dummy"
	local tick = 0
	local tick_interval = 0.02
	local ability_astral_imprisoment = caster:FindAbilityByName("imba_obsidian_destroyer_astral_imprisonment")
	local duration = ability_astral_imprisoment:GetLevelSpecialValueFor("prison_duration", (ability_astral_imprisoment:GetLevel() -1))
	local scepter = caster:HasScepter()
	local max_ticks = 0
	if duration ~= nil then
		max_ticks = duration / tick_interval + 1
	end

	local damage_table = {}
	local hit_table = {}

	damage_table.attacker = caster
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability

	if scepter == true then
		local enemies = FindUnitsInRadius(caster.GetTeam(caster), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		for _,enemy in pairs(enemies) do
			local caster = keys.caster
			local target = enemy
			local ability = ability_astral_imprisoment
			local int_steal = ability:GetLevelSpecialValueFor("int_gain", (ability:GetLevel() -1))
			local int_steal_pct = ability:GetLevelSpecialValueFor("int_steal_pct", (ability:GetLevel() -1))
			local dummy_modifier = "modifier_astral_imprisonment_dummy"
			local dummy_gain_modifier = "modifier_astral_imprisonment_int_gain"
			local dummy_loss_modifier = "modifier_astral_imprisonment_int_loss"
			local intellect = caster:GetIntellect()

			local stack_count = caster:GetModifierStackCount(dummy_gain_modifier, caster)
			local stack_count_target = target:GetModifierStackCount(dummy_gain_modifier, caster)

			local target_int = target:GetIntellect()
			local target_int_pct = target_int * (int_steal_pct / 100)

			if target_int_pct > int_steal then
				stack_count = stack_count + target_int_pct
				stack_count_target = stack_count_target + target_int_pct
			else
				stack_count = stack_count + int_steal
				stack_count_target = stack_count_target + int_steal
			end

			ability:ApplyDataDrivenModifier(caster, target, dummy_modifier, {})

			ability:ApplyDataDrivenModifier(caster, target, dummy_loss_modifier, {})
			ability:ApplyDataDrivenModifier(caster, caster, dummy_gain_modifier, {})
			caster:SetModifierStackCount(dummy_gain_modifier, caster, stack_count)
			target:SetModifierStackCount(dummy_loss_modifier, caster, stack_count_target)

			target:AddNoDraw()
			ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_imprisonment", {})
		end
	else
		local enemies = FindUnitsInRadius(caster.GetTeam(caster), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		for _,enemy in pairs(enemies) do
			damage_table.victim = enemy
			local target_int = enemy:GetIntellect()
			local mana = enemy:GetMana()
			enemy:SetMana(mana*0.25)
			if od_int > target_int then
				damage_table.damage = (od_int - target_int) * dmg_multiplier
				ApplyDamage(damage_table)
			end
			ability:ApplyDataDrivenModifier(caster, enemy, dummy_modifier, {})
			table.insert(hit_table, enemy)
		end
	end

	

	Timers:CreateTimer(0.1, function()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_sanity_eclipse_dummy", {})
		local enemies = FindUnitsInRadius(caster.GetTeam(caster), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			local check_unit = 0

			for c = 0, #hit_table do
				if hit_table[c] == enemy then
					check_unit = 1
				end
			end

			if check_unit == 0 then
				if enemy:HasModifier("modifier_astral_imprisonment_dummy") then
					damage_table.victim = enemy
					local target_int = enemy:GetIntellect()
					local mana = enemy:GetMana()
					enemy:SetMana(mana*0.25)
					if od_int > target_int then
						damage_table.damage = (od_int - target_int) * dmg_multiplier
						ApplyDamage(damage_table)
					end
					ability:ApplyDataDrivenModifier(caster, enemy, dummy_modifier, {})
					table.insert(hit_table, enemy)
				end
			end
		end
		if tick > max_ticks then
			return nil
		else
			tick = tick + 1
			return tick_interval
		end
	end)
end