--[[	Author: d2imba
		Date:	07.01.2015	]]

function DiffusalCast( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_target = keys.sound_target
	local particle_target = keys.particle_target
	local modifier_slow = keys.modifier_slow

	-- Parameters
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end
	
	-- Play hit sound
	target:EmitSound(sound_target)

	-- Play hit particle
	local diffusal_pfx = ParticleManager:CreateParticle(particle_target, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(diffusal_pfx, 0, target:GetAbsOrigin())

	-- Purge, removes positive buffs and slows
	target:Purge(true, false, false, false, false)

	-- Instantly kill illusions and summoned units
	if target:IsIllusion() or target:IsSummoned() then
		target:Kill(ability, caster)
	end

	-- Slow only if the target is not magic immune
	if not target:IsMagicImmune() then
		if target:HasModifier(modifier_slow) then
			ability:ApplyDataDrivenModifier(caster, target, modifier_slow, {})
			target:SetModifierStackCount(modifier_slow, caster, max_stacks)
		else
			AddStacks(ability, caster, target, modifier_slow, max_stacks, true)			
		end
	end

	-- Spend one charge
	ability:SetCurrentCharges(ability:GetCurrentCharges() - 1)
end

function DiffusalHit( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_hit = keys.particle_hit

	-- If a higher-level diffusal version is present, do nothing
	if caster:HasModifier("modifier_item_imba_diffusal_2_unique") or caster:HasModifier("modifier_item_imba_diffusal_3_unique") then
		return nil
	end

	-- Parameters
	local mana_burn = ability:GetLevelSpecialValueFor("mana_burn", ability_level)
	if attacker:IsIllusion() then
		mana_burn = ability:GetLevelSpecialValueFor("illusion_mana_burn", ability_level)
	end

	-- Burn mana if target is not magic immune
	if not target:IsMagicImmune() then

		-- Burn mana
		local target_mana = target:GetMana()
		target:ReduceMana(mana_burn)

		-- Deal bonus damage
		if target_mana > mana_burn then
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = mana_burn, damage_type = DAMAGE_TYPE_PHYSICAL})

			-- Play hit particle
			local manaburn_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControl(manaburn_pfx, 0, target:GetAbsOrigin())
		else
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = target_mana, damage_type = DAMAGE_TYPE_PHYSICAL})
		end
	end
end

function DiffusalSlowDecay( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_slow = keys.modifier_slow

	-- Reduce stack amount by one
	AddStacks(ability, caster, target, modifier_slow, -1, false)
end

function Diffusal2Hit( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_hit = keys.particle_hit

	-- If a higher-level diffusal version is present, do nothing
	if caster:HasModifier("modifier_item_imba_diffusal_3_unique") then
		return nil
	end

	-- Parameters
	local mana_burn = ability:GetLevelSpecialValueFor("mana_burn", ability_level)
	local proc_chance = ability:GetLevelSpecialValueFor("proc_chance", ability_level)
	if attacker:IsIllusion() then
		mana_burn = ability:GetLevelSpecialValueFor("illusion_mana_burn", ability_level)
	end

	-- Roll for a proc
	if caster:GetTeam() ~= target:GetTeam() and caster:IsRealHero() and RandomInt(1, 100) <= proc_chance then

		-- Purge a random positive modifier from the target
		local modifier_list = target:FindAllModifiers()
		local modifier_found = false
		for _,modifier in pairs(modifier_list) do
			local modifier_name = modifier:GetName()
			for _,modifier_name_compare in pairs(PURGE_BUFF_LIST) do
				if modifier_name == modifier_name_compare then
					target:RemoveModifierByName(modifier_name)
					modifier_found = true
					break
				end
			end
			if modifier_found then
				break
			end
		end
	end

	-- Burn mana if target is not magic immune
	if not target:IsMagicImmune() then

		-- Burn mana
		local target_mana = target:GetMana()
		target:ReduceMana(mana_burn)

		-- Deal bonus damage
		if target_mana > mana_burn then
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = mana_burn, damage_type = DAMAGE_TYPE_PHYSICAL})

			-- Play hit particle
			local manaburn_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControl(manaburn_pfx, 0, target:GetAbsOrigin())
		else
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = target_mana, damage_type = DAMAGE_TYPE_PHYSICAL})
		end
	end
end

function Diffusal3Hit( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_hit = keys.particle_hit

	-- Parameters
	local mana_burn = ability:GetLevelSpecialValueFor("mana_burn", ability_level)
	local proc_chance = ability:GetLevelSpecialValueFor("proc_chance", ability_level)
	if attacker:IsIllusion() then
		mana_burn = ability:GetLevelSpecialValueFor("illusion_mana_burn", ability_level)
	end

	-- Roll for a proc
	if caster:GetTeam() ~= target:GetTeam() and caster:IsRealHero() and RandomInt(1, 100) <= proc_chance then

		-- Purge a random positive modifier from the target
		local modifier_list = target:FindAllModifiers()
		local modifier_found = false
		for _,modifier in pairs(modifier_list) do
			local modifier_name = modifier:GetName()
			for _,modifier_name_compare in pairs(PURGE_BUFF_LIST) do
				if modifier_name == modifier_name_compare then
					target:RemoveModifierByName(modifier_name)
					local source_ability = modifier:GetAbility()
					local source_caster = modifier:GetCaster()
					local remaining_duration = modifier:GetRemainingTime()
					if string.find(modifier_name, "imba") then
						source_ability:ApplyDataDrivenModifier(source_caster, caster, modifier_name, {duration = remaining_duration})
					else
						if modifier_name ~= "modifier_dark_seer_ion_shell" then
							caster:AddNewModifier(source_caster, source_ability, modifier_name, {duration = remaining_duration})
						end
					end
					modifier_found = true
					break
				end
			end
			if modifier_found then
				break
			end
		end
	end

	-- Burn mana if target is not magic immune
	if not target:IsMagicImmune() then

		-- Burn mana
		local target_mana = target:GetMana()
		target:ReduceMana(mana_burn)

		-- Deal bonus damage
		if target_mana > mana_burn then
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = mana_burn, damage_type = DAMAGE_TYPE_PHYSICAL})

			-- Play hit particle
			local manaburn_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControl(manaburn_pfx, 0, target:GetAbsOrigin())
		else
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = target_mana, damage_type = DAMAGE_TYPE_PHYSICAL})
		end
	end
end