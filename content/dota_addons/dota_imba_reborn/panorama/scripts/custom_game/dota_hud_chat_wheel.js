let favourites = [];

heronames.forEach((msg, index) => {
	rings[rings.length] = [
		msg,
		[false, false, false, false, false, false, false, false],
		[
			herostartrings + index * 8,
			herostartrings + index * 8 + 1,
			herostartrings + index * 8 + 2,
			herostartrings + index * 8 + 3,
			herostartrings + index * 8 + 4,
			herostartrings + index * 8 + 5,
			herostartrings + index * 8 + 6,
			herostartrings + index * 8 + 7,
		],
	];
});
heronames2.forEach((basicMessage, index) => {
	let msg = [];
	let numsb = [true, true, true, true, true, true, true, true];
	let numsi = [];

	for (let x = 0; x < 8; x++) {
		msg[x] = "#dota_chatwheel_label_" + basicMessage + mesarrs[x];
		numsi[x] = herostartnum + index * 8 + x;
	}
	rings[herostartrings + index] = [msg, numsb, numsi];
});

let nowselect = 0;

function StartWheel() {
	if ($("#Wheel").visible == false) {
//		$.Msg("Open Chat Wheel!")
//		$.Msg($("#Wheel").visible)
		$("#Wheel").visible = true;
		$("#Bubble").visible = true;
		$("#PhrasesContainer").visible = true;
	} else if ($("#Wheel").visible == true) {
		StopWheel()
	}
}

function StopWheel() {
	$("#Wheel").visible = false;
	$("#Bubble").visible = false;
	$("#PhrasesContainer").visible = false;
	$("#WHTooltip").visible = false;
	if (nowselect != 0) {
		$("#PhrasesContainer").RemoveAndDeleteChildren();
		for (let i = 0; i < 8; i++) {
			if (rings[0][0][i] != "#dota_chatwheel_label_skywrath_mage_4") {
				$.CreatePanelWithProperties(`Button`, $("#PhrasesContainer"), `Phrase${i}`, {
					class: `MyPhrases`,
					onmouseactivate: `OnSelect(${i})`,
					onmouseover: `OnMouseOver(${i})`,
					onmouseout: `OnMouseOut(${i})`,
				});

				$("#Phrase" + i).BLoadLayoutSnippet("Phrase");
				$("#Phrase" + i)
					.GetChild(0)
					.GetChild(0).visible = rings[0][1][i];
				$("#Phrase" + i)
					.GetChild(0)
					.GetChild(1).text = $.Localize(rings[0][0][i]);
			}
		}
		nowselect = 0;
	}
}

function OnSelect(num) {
	let newnum = rings[nowselect][2][num];
	if (rings[nowselect][1][num]) {
		GameEvents.SendCustomGameEventToServer("SelectVO", { num: newnum });
		StopWheel();
	} else {
		$("#PhrasesContainer").RemoveAndDeleteChildren();
		for (let i = 0; i < 8; i++) {
			if (rings[newnum][0][i] != "#dota_chatwheel_label_skywrath_mage_4") {
				let properities_for_panel = {
					class: `MyPhrases`,
					onmouseactivate: `OnSelect(${i})`,
					onmouseover: `OnMouseOver(${i})`,
					onmouseout: `OnMouseOut(${i})`,
				};

				if (rings[newnum][1][i]) {
					properities_for_panel.oncontextmenu = `AddOnFavourites(${i})`;
				}

				$.CreatePanelWithProperties(`Button`, $("#PhrasesContainer"), `Phrase${i}`, properities_for_panel);

				$("#Phrase" + i).BLoadLayoutSnippet("Phrase");
				$("#Phrase" + i)
					.GetChild(0)
					.GetChild(0).visible = rings[newnum][1][i];
				$("#Phrase" + i)
					.GetChild(0)
					.GetChild(1).text = $.Localize(rings[newnum][0][i]);
			}
		}
		nowselect = newnum;
	}
}

function AddOnFavourites(num) {
	if (nowselect != 18) {
		favourites.unshift(rings[nowselect][2][num]);
		if (favourites.length > 8) favourites[8] = null;
		favourites = favourites.filter(function (el) {
			return el != null;
		});
		Game.EmitSound("ui.crafting_gem_create");
		UpdateFavourites();
	} else {
		favourites[num] = null;
		favourites = favourites.filter(function (el) {
			return el != null;
		});
		UpdateFavourites();
		nowselect = 0;
		OnSelect(2);
	}
	GameEvents.SendCustomGameEventToServer("patreon_update_chat_wheel_favorites", { favourites: favourites });
}

function UpdateFavourites() {
	let msg = [];
	let numsb = [];
	let numsi = [];
	for (let i = 0; i < 8; i++) {
		if (favourites[i]) {
			msg[i] = FindLabelByNum(favourites[i]);
			numsi[i] = favourites[i];
			numsb[i] = true;
		} else {
			msg[i] = "";
			numsi[i] = 0;
			numsb[i] = false;
		}
	}
	rings[18] = [msg, numsb, numsi];
}

function FindLabelByNum(num) {
	for (let key in rings) {
		let element = rings[key];
		for (let i = 0; i < 8; i++) {
			if (element[1][i] == true && element[2][i] == num) {
				return element[0][i];
			}
		}
	}
}

function OnMouseOver(num) {
	$("#WheelPointer").RemoveClass("Hidden");
	$("#Arrow").RemoveClass("Hidden");
	for (let i = 0; i < 8; i++) {
		if ($("#Wheel").BHasClass("ForWheel" + i)) $("#Wheel").RemoveClass("ForWheel" + i);
	}
	$("#Wheel").AddClass("ForWheel" + num);
	$("#WHTooltip").visible = rings[nowselect][1][num];
	$("#WHTooltip").SetDialogVariableInt("num", rings[nowselect][2][num]);
}

function OnMouseOut() {
	$("#WheelPointer").AddClass("Hidden");
	$("#Arrow").AddClass("Hidden");
	$("#WHTooltip").visible = false;
}
function EmitSoundFromServer(data) {
	const sound_name = data.sound;
	if (sound_name == undefined) return;
	Game.EmitSound(sound_name);
}
(function () {
	GameUI.CustomUIConfig().chatWheelLoaded = true;

/*
	SubscribeToNetTableKey("player_settings", Game.GetLocalPlayerID().toString(), (settings) => {
		if (settings.chatWheelFavourites) {
			favourites = Object.values(settings.chatWheelFavourites || {});
			UpdateFavourites();
		}
	});
*/

	for (let i = 0; i < 8; i++) {
		$.CreatePanelWithProperties(`Button`, $("#PhrasesContainer"), `Phrase${i}`, {
			class: `MyPhrases`,
			onmouseactivate: `OnSelect(${i})`,
			onmouseover: `OnMouseOver(${i})`,
			onmouseout: `OnMouseOut(${i})`,
		});

		$("#Phrase" + i).BLoadLayoutSnippet("Phrase");
		$("#Phrase" + i)
			.GetChild(0)
			.GetChild(0).visible = rings[0][1][i];
		$("#Phrase" + i)
			.GetChild(0)
			.GetChild(1).text = $.Localize(rings[0][0][i]);
	}

	// press once to open, once again to close
	GameUI.SetupVanillaKeyBinding("HeroChatWheel", StartWheel);

	// hold key to open, release it to close. not working, no idea why
//	GameUI.SetupVanillaKeyBinding("HeroChatWheel", StartWheel, true, StopWheel);

//	Game.AddCommand("+WheelButton", StartWheel, "", 0);
//	Game.AddCommand("-WheelButton", StopWheel, "", 0);

	$("#Wheel").visible = false;
	$("#Bubble").visible = false;
	$("#PhrasesContainer").visible = false;
	$("#WHTooltip").visible = false;
	GameEvents.Subscribe("chat_wheel:emit_sound", EmitSoundFromServer);
})();
