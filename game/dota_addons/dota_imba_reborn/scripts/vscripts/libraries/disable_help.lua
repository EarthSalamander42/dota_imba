-- Credits: Darklord (Dota 12v12)

DisableHelp = DisableHelp or {}

RegisterCustomEventListener("set_disable_help", function(data)
	local to = data.to;
	if PlayerResource:IsValidPlayerID(to) then
		local playerId = data.PlayerID;
		local disable = data.disable == 1
		PlayerResource:SetUnitShareMaskForPlayer(playerId, to, 4, disable)

		local disableHelp = CustomNetTables:GetTableValue("disable_help", tostring(playerId)) or {}
		disableHelp[tostring(to)] = disable
		CustomNetTables:SetTableValue("disable_help", tostring(playerId), disableHelp)
	end
end)

local disabledModifiers = {
	modifier_imba_keeper_of_the_light_recall = true,
	modifier_imba_rattletrap_hookshot = true,
	modifier_imba_tidehunter_gush_surf = true,
}

function DisableHelp.ModifierGainedFilter(filterTable)
	if disabledModifiers[filterTable.name_const] then
		local parent = EntIndexToHScript(filterTable.entindex_parent_const)
		local caster = EntIndexToHScript(filterTable.entindex_caster_const)
		local ability = EntIndexToHScript(filterTable.entindex_ability_const)

		if PlayerResource:IsDisableHelpSetForPlayerID(parent:GetPlayerOwnerID(), caster:GetPlayerOwnerID()) then
			ability:EndCooldown()
			ability:RefundManaCost()
			DisplayError(caster:GetPlayerOwnerID(), "dota_hud_error_target_has_disable_help")
			return false
		end
	end
end

local disabledAbilities = {
	imba_bane_nightmare = true,
	imba_bloodseeker_bloodrage = true,
	imba_crystal_maiden_frostbite = true,
	imba_chen_holy_persuasion = true,
	imba_earth_spirit_boulder_smash = true,
	imba_earth_spirit_geomagnetic_grip = true,
	imba_earth_spirit_petrify = true,
	imba_keeper_of_the_light_recall = true,
	imba_kunkka_x_marks_the_spot = true,
	imba_obsidian_destroyer_astral_imprisonment = true,	-- form change
	imba_outworld_devourer_astral_imprisonment = true,	-- form change
	imba_oracle_fates_edict = true,
	imba_oracle_purifying_flames = true,
	imba_puck_phase_shift = true,
	imba_pugna_decrepify = true,
	imba_rubick_telekinesis = true,
	imba_vengefulspirit_nether_swap = true,
	imba_winter_wyvern_cold_embrace = true,
	imba_weaver_time_lapse = true,
	imba_wisp_tether = true,
	imba_pudge_dismember = true,
	imba_brewmaster_primal_split = true,

	-- items
	item_imba_force_staff = true,
	item_imba_hurricane_pike = true,
	item_imba_lance_of_longinus = true,
	item_imba_wand_of_the_brine = true,
}

function DisableHelp.ExecuteOrderFilter(orderType, ability, target, unit)
	if (
		orderType == DOTA_UNIT_ORDER_CAST_TARGET and
		ability and
		target and
		unit and
		disabledAbilities[ability:GetAbilityName()] and
		PlayerResource:IsDisableHelpSetForPlayerID(target:GetPlayerOwnerID(), unit:GetPlayerOwnerID())
	) then
		DisplayError(unit:GetPlayerOwnerID(), "dota_hud_error_target_has_disable_help")
		return false
	end
end
