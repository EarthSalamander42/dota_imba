--[[	Author: d2imba
		Date:	22.06.2015	]]

function Suicide( keys )
	local caster = keys.caster
	local item = keys.ability

	TrueKill(caster, caster, item)
end

function UpdateCharges( keys )
	local caster = keys.caster
	local item = keys.ability
	local charges_modifier = keys.charges_modifier
	local dummy_modifier = keys.dummy_modifier

	local current_charges = item:GetCurrentCharges()

	item:ApplyDataDrivenModifier(caster, caster, charges_modifier, {})
	caster:SetModifierStackCount(charges_modifier, caster, current_charges)

	-- Apply a dummy modifier to keep the mana value updated
	caster:RemoveModifierByName(dummy_modifier)
	item:ApplyDataDrivenModifier(caster, caster, dummy_modifier, {})
end

function GainChargesOnKill( keys )
	local caster = keys.caster
	local item = keys.ability
	local target = keys.target
	local assist_modifier = keys.assist_modifier

	if target:GetTeam() ~= caster:GetTeam() and not target:HasModifier(assist_modifier) then
		local current_charges = item:GetCurrentCharges()
		item:SetCurrentCharges( current_charges + 1 )
	end
end

function GainChargesOnAssist( keys )
	local item = keys.ability

	local current_charges = item:GetCurrentCharges()
	item:SetCurrentCharges( current_charges + 1 )
end

function LoseCharges( keys )
	local caster = keys.caster
	local item = keys.ability
	local item_level = item:GetLevel() - 1

	-- Parameters
	local exp_modifier = keys.exp_modifier
	local on_death_charge_loss = item:GetLevelSpecialValueFor("on_death_loss", item_level)
	local respawn_time_reduction = item:GetLevelSpecialValueFor("respawn_time_reduction", item_level)
	local effect_radius = item:GetLevelSpecialValueFor("effect_radius", item_level)
	local heal_on_death_base = item:GetLevelSpecialValueFor("heal_on_death_base", item_level)
	local heal_on_death_per_charge = item:GetLevelSpecialValueFor("heal_on_death_per_charge", item_level)

	-- Calculations
	local current_charges = item:GetCurrentCharges()
	local total_heal = heal_on_death_base + current_charges * heal_on_death_per_charge
	local respawn_time_reduction = respawn_time_reduction * current_charges

	-- Lose charges
	item:SetCurrentCharges( math.floor(current_charges * on_death_charge_loss) )

	-- Heal nearby allies
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, effect_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _,ally in pairs(allies) do
		ally:Heal(total_heal, caster)
	end

	-- Reduce respawn timer
	if caster:GetRespawnTime() < respawn_time_reduction then
		caster:SetTimeUntilRespawn(0)
	else
		caster:SetTimeUntilRespawn( caster:GetRespawnTime() - respawn_time_reduction )
	end

	-- Vision
	item:CreateVisibilityNode(caster:GetAbsOrigin(), effect_radius, caster:GetRespawnTime())

	-- Gain experience and grant vision on the area while dead
	local bloodstone_exp_dummy = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber() )
	item:ApplyDataDrivenModifier(caster, bloodstone_exp_dummy, exp_modifier, {})
	Timers:CreateTimer(0.1, function()
		if not caster:IsAlive() then
			return 0.1
		else
			bloodstone_exp_dummy:Destroy()
		end
	end)
end

function GainExp( keys )
	local caster = keys.caster
	local unit = keys.unit

	caster:AddExperience(unit:GetDeathXP(), 0, false, true)
end