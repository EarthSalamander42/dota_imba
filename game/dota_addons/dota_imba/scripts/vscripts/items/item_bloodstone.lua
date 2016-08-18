--[[	Author: d2imba
		Date:	22.06.2015	]]

function Suicide( keys )
	local caster = keys.caster
	local item = keys.ability

	if caster:HasModifier("modifier_imba_reincarnation") then
		caster:Kill(item, caster)
	else
		TrueKill(caster, caster, item)
	end
end

function UpdateCharges( keys )
	local caster = keys.caster
	local item = keys.ability
	local charges_modifier = keys.charges_modifier

	-- Parameters
	local respawn_time_reduction = item:GetLevelSpecialValueFor("respawn_time_reduction", item:GetLevel() - 1)
	local current_charges = item:GetCurrentCharges()

	item:ApplyDataDrivenModifier(caster, caster, charges_modifier, {})
	caster:SetModifierStackCount(charges_modifier, caster, current_charges)
	
	-- Reduce respawn timer
	caster.bloodstone_respawn_reduction = current_charges * respawn_time_reduction
end

function GainChargesOnKill( keys )
	local caster = keys.caster
	local item = keys.ability
	local item_level = item:GetLevel() - 1
	local target = keys.target
	local assist_modifier = keys.assist_modifier

	-- Parameters
	local current_charges = item:GetCurrentCharges()

	if target:GetTeam() ~= caster:GetTeam() and not target:HasModifier(assist_modifier) and not target:IsIllusion() then
		item:SetCurrentCharges( current_charges + 1 )
	end
end

function GainChargesOnAssist( keys )
	local target = keys.unit
	local item = keys.ability
	local item_level = item:GetLevel() - 1

	-- Parameters
	local current_charges = item:GetCurrentCharges()

	if not target:IsIllusion() then
		item:SetCurrentCharges( current_charges + 1 )
	end
end

function LoseCharges( keys )
	local caster = keys.caster
	local item = keys.ability
	local item_level = item:GetLevel() - 1

	-- Parameters
	local on_death_charge_loss = item:GetLevelSpecialValueFor("on_death_loss", item_level)
	local effect_radius = item:GetLevelSpecialValueFor("effect_radius", item_level)
	local heal_on_death_base = item:GetLevelSpecialValueFor("heal_on_death_base", item_level)
	local heal_on_death_per_charge = item:GetLevelSpecialValueFor("heal_on_death_per_charge", item_level)

	-- Calculations
	local current_charges = item:GetCurrentCharges()
	local total_heal = heal_on_death_base + current_charges * heal_on_death_per_charge

	-- Lose charges
	item:SetCurrentCharges( math.floor(current_charges * on_death_charge_loss) )

	-- Heal nearby allies
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, effect_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _,ally in pairs(allies) do
		ally:Heal(total_heal, caster)
	end
end

function RespawnTimeReset( keys )
	local caster = keys.caster

	caster.bloodstone_respawn_reduction = nil
end
