--[[	Author: X-TheDark
		Date: 10.12.2016	]]

function ArcaneCurseCast( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local curse_debuff = keys.curse_debuff

	target:AddNewModifier(caster, ability, curse_debuff, nil)
end

function IntToDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local caster_int = caster:GetIntellect()
	local glaive_damage = ability:GetLevelSpecialValueFor("intellect_damage_pct", ( ability:GetLevel() - 1 ))

	local damage_table = {
		victim = target,
		attacker = caster,
		damage = caster_int * glaive_damage / 100,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability
	}

	ApplyDamage( damage_table )
end

function LastWordCast( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_debuff = keys.modifier_debuff
	local sound_cast = keys.sound_cast

	-- If target has Linken's Sphere off cooldown, do nothing else
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Apply the debuff
	ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})
end

function LastWordDamage( keys )
	local caster = keys.caster
	local target = keys.unit
	local event_ability = keys.event_ability
	local modifier = keys.modifier
	local ability = keys.ability

	local target_modifier = target:FindModifierByName(modifier)
	if target_modifier and ( not event_ability:IsItem() ) then
		if target_modifier.damage_applied == nil then
			-- Need to check if we are using an autoattack ability (orbs)
			-- ...this is going to be ugly
			local exceptions = {
				["imba_drow_ranger_frost_arrows"] = true,
				["imba_drow_ranger_frost_arrows_mark1"] = true,
				["imba_drow_ranger_frost_arrows_mark2"] = true,
				["imba_drow_ranger_frost_arrows_mark3"] = true,
				["imba_silencer_glaives_of_wisdom"] = true, --hoist with his own petard
				["imba_obsidian_destroyer_arcane_orb"] = true,
				["imba_clinkz_searing_arrows"] = true, --doesn't cost mana, but I want to be safe
				--These will need to be removed when they are imbafied
				["viper_poison_attack"] = true,
				["doom_bringer_infernal_blade"] = true,
				["tusk_walrus_punch"] = true,
				--Future imbafied autoattacks, based on name conventions
				["imba_viper_poison_attack"] = true,
				["imba_doom_bringer_infernal_blade"] = true,
				["imba_tusk_walrus_punch"] = true
			}

			if not exceptions[event_ability:GetAbilityName()] then
				--Toggle abilities activated when turned on
				--[[
					Due being triggered on mana spent, this doesn't work properly with "lingering toggles",
					like WD's Voodoo Restoration, that spend mana for a short while after being turned off.
					For these, Damage will be applied if you toggle it OFF (silence will apply properly on
					toggled ON only), only the damage is bugged.
				--]]
				if event_ability:IsToggle() and event_ability:GetToggleState() then
					return nil
				end

				local damage_table = {
					victim = target,
					attacker = caster,
					damage = ability:GetSpecialValueFor("damage"),
					damage_type = ability:GetAbilityDamageType(),
					ability = ability
				}

				ApplyDamage( damage_table )
				target_modifier.damage_applied = true
			end
		end
	end
end

-- Special case for damage applied if nothing is cast
-- This is basically specifically to fix buggy interaction with WD's Voodoo Restoration, so damage isn't applied twice
-- when you toggle the ability off (since it won't trigger the silence in that case)
function LastWordDamageNoCast( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier

	local target_modifier = target:FindModifierByName(modifier)
	
	if target_modifier and target_modifier.damage_applied == nil then
		local damage_table = {
			victim = target,
			attacker = caster,
			damage = ability:GetSpecialValueFor("damage"),
			damage_type = ability:GetAbilityDamageType(),
			ability = ability
		}

		ApplyDamage( damage_table )
		target_modifier.damage_applied = true
	end
end

function LastWordDebuff( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local event_ability = keys.event_ability
	local modifier = keys.modifier
	local silence_modifier = keys.silence_modifier

	local target_modifier = target:FindModifierByName(modifier)

	if target_modifier and ( not event_ability:IsItem() ) then
		-- Only extend duration of Toggle abilities when they are turned on
		-- OnAbilityExecuted is ran before the toggle completes, so 'true' = we are about to turn it off
		if event_ability:IsToggle() and event_ability:GetToggleState() then
			return nil
		end

		local sound = keys.sound
		local damage_sound = keys.damage_sound

		StopSoundEvent(sound, target)
		target_modifier:Destroy()

		ability:ApplyDataDrivenModifier(caster, target, silence_modifier, nil)
		target:EmitSound(damage_sound)
	end
end

function GlobalSilenceCast( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local curse_name = keys.curse_name
	local curse_modifier = keys.curse_modifier
	local silence_modifier = keys.silence_modifier

	-- Needs to be applied via lua because if modifier IsPurgable in data-driven definition,
	-- it won't be applied through "ApplyModifier"
	ability:ApplyDataDrivenModifier(caster, target, silence_modifier, nil)

	if caster:HasScepter() then
		local curse_ability = caster:FindAbilityByName(curse_name)
		if curse_ability and curse_ability:GetLevel() > 0 then
			target:AddNewModifier(caster, curse_ability, curse_modifier, nil)
		end
	end
end