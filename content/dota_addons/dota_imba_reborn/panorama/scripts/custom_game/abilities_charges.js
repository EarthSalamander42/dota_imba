'use strict';

var show_charge_for_hero = [];

function GetDotaHud() {
	var p = $.GetContextPanel();
	try {
		while (true) {
			if (p.id === "Hud")
				return p;
			else
				p = p.GetParent();
		}
	} catch (e) {}
}

function InitChargeUI(args) {
//	$.Msg(args)

	// Toggle Visibility for ability charge UI
	GetDotaHud().FindChildTraverse("Ability" + args.ability_index).FindChildTraverse("AbilityCharges").style.visibility = "visible";
	GetDotaHud().FindChildTraverse("Ability" + args.ability_index).FindChildTraverse("AbilityCharges").GetChild(1).text = 0;

	// store ability index
//	$.Msg("Store hero index " + args.unit_index + " with ability index: " + args.ability_index)
	show_charge_for_hero[args.unit_index] = [];
	show_charge_for_hero[args.unit_index][args.ability_index] = [args.charge_duration, args.scepter_duration, args.ability_name];
}

function UpdateCharges(args) {
//	$.Msg("Update charges!")
	var ability_name = show_charge_for_hero[args.unit_index][args.ability_index][2];
	var buff_id = GetBuffIDByName(args.unit_index, "modifier_generic_charges", ability_name);

	if (buff_id)
		GetDotaHud().FindChildTraverse("Ability" + args.ability_index).FindChildTraverse("AbilityCharges").GetChild(1).text = Buffs.GetStackCount(args.unit_index, buff_id);
}

function UpdateLoadingCharge(args) {
//	$.Msg("Update loading charges!")

	if (show_charge_for_hero[args.unit_index] == undefined) {
		$.Msg("No abilities to track!")
		return;
	}

	var run_loop = true;
	var ability_name = show_charge_for_hero[args.unit_index][args.ability_index][2];
	var buff_id = GetBuffIDByName(args.unit_index, "modifier_generic_charges", ability_name);

	var charge_duration = show_charge_for_hero[args.unit_index][args.ability_index][0];

	if (Entities.HasScepter(args.unit_index) && show_charge_for_hero[args.unit_index][args.ability_index][1] != 0) {
		charge_duration = show_charge_for_hero[args.unit_index][args.ability_index][1];
	}

	var fun = function(){
		var Duration = Buffs.GetDuration(args.unit_index, buff_id);
		var stringStart = "radial(50% 50%, 0.0deg, ";
		var stringEnd = "deg)";
		var degreesCooldownRemaining = 360;
		var timeElapsed = Buffs.GetElapsedTime(args.unit_index, buff_id);

//		$.Msg(Duration)

//		if (Duration != -1 || charge_duration > timeElapsed - 0.1) {
			var timeRemaining = Buffs.GetRemainingTime(args.unit_index, buff_id);
			degreesCooldownRemaining = ((timeRemaining / charge_duration) * 360) * -1;
//			$.Msg(timeRemaining)
//			$.Msg(timeElapsed)
//			$.Msg(degreesCooldownRemaining)

			$.Schedule(1 / 10, fun);
//		} else {
//			run_loop = false; // gotta find the right condition to prevent running timer if charges are fullfilled
//		}

		var clipString = stringStart + degreesCooldownRemaining + stringEnd;
//		$.Msg(clipString)

		GetDotaHud().FindChildTraverse("Ability" + args.ability_index).FindChildTraverse("AbilityCharges").GetChild(0).style.clip = clipString;
	};

	if (run_loop) {
		fun();
	}
}

function GetBuffIDByName(selectedEntityID, buff_name, ability_name) {
	var num_buffs = Entities.GetNumBuffs(selectedEntityID);

	if (num_buffs) {
		for (var i = 0; i <= num_buffs + 100; i++) {
			var buff = Buffs.GetName(selectedEntityID, i);

			if (buff && buff == buff_name) {
				if (ability_name) {
					if (Abilities.GetAbilityName(Buffs.GetAbility(selectedEntityID, i)) == ability_name)
						return i;
				} else {
					return i;
				}
			}
		}
	}

	return false;
}

function RefreshUI() {
//	$.Msg( "OnUpdateSelectedUnit ", Entities.GetClassname(Players.GetLocalPlayerPortraitUnit()), " / ", Players.GetLocalPlayerPortraitUnit() );

	for (var i = 0; i < 6; i++) {
		var panel = GetDotaHud().FindChildTraverse("Ability" + i);

//		$.Msg(panel)

		if (panel && panel.FindChildTraverse("AbilityCharges"))
			panel.FindChildTraverse("AbilityCharges").style.visibility = "collapse";
	}

	if (show_charge_for_hero[Players.GetLocalPlayerPortraitUnit()]) {
		for (var i in show_charge_for_hero[Players.GetLocalPlayerPortraitUnit()]) {
			var panel = GetDotaHud().FindChildTraverse("Ability" + i);

			if (panel && panel.FindChildTraverse("AbilityCharges")) {
				panel.FindChildTraverse("AbilityCharges").style.visibility = "visible";
				UpdateCharges({unit_index: Players.GetLocalPlayerPortraitUnit(), ability_index: i})
				UpdateLoadingCharge({unit_index: Players.GetLocalPlayerPortraitUnit(), ability_index: i})
			}
		}
	}
}

/*
if (Game.IsInToolsMode()) {
//	show_charge_for_hero["1143"] = [];
//	show_charge_for_hero["1143"][1] = [45, 45];

	GetDotaHud().FindChildTraverse("Ability4").FindChildTraverse("AbilityCharges").style.visibility = "visible";
	GetDotaHud().FindChildTraverse("Ability4").FindChildTraverse("AbilityCharges").GetChild(1).text = 0;

	show_charge_for_hero["443"] = [];
	show_charge_for_hero["443"][5] = [60, 60];
}
*/

GameEvents.Subscribe("init_charge_ui", InitChargeUI);
GameEvents.Subscribe("update_charge_count", UpdateCharges);
GameEvents.Subscribe("update_charge_loading", UpdateLoadingCharge);
GameEvents.Subscribe( "dota_player_update_selected_unit", RefreshUI );
