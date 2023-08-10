(function() {
	InitGlobalUtilFuncs();

	if (Game.IsInToolsMode() && Game.GameStateIsAfter(8)) {
		InitIngameGlobalUtils();
	}
}());

function InitGlobalUtilFuncs() {
	var Utils = {
		unitsByName: {},
		GetDotaHud: function () {
			var panel = $.GetContextPanel();
			while (panel && panel.id !== 'Hud') {
				panel = panel.GetParent();
			}

			if (!panel) {
				throw new Error('Could not find Hud root from panel with id: ' + $.GetContextPanel().id);
			}

			return panel;
		},

		FindDotaHudElement: function (id) {
			return Utils.GetDotaHud().FindChildTraverse(id);
		},

		RawTimetoGameTime: function (time, bMilliSecs) {
			var millisecs_decimals = 2;
			
			if (bMilliSecs) {
				time = time.toFixed(millisecs_decimals);
			}

			var millisecs = time.toString().slice(-millisecs_decimals);
			var sec = Math.floor(time % 60);
			var min = Math.floor(time / 60);

			var timerText = min + ':';

			if (sec < 10) {
				timerText += '0';
			}

			timerText += sec;

			if (bMilliSecs) {
				timerText += '.';

				if (millisecs < 10) {
					timerText += '0';
				}

				timerText += millisecs;
			}

			return timerText;
		},

		GetBuffIDByName: function (selectedEntityID, buff_name, ability_name) {
			var num_buffs = Entities.GetNumBuffs(selectedEntityID);
		
			if (num_buffs) {
				for (var i = 0; i <= num_buffs + 100; i++) {
					var buff = Buffs.GetName(selectedEntityID, i);
			
					if (buff && buff == buff_name) {
						if (ability_name) {
							if (Abilities.GetAbilityName(Buffs.GetAbility(selectedEntityID, i)) == ability_name) {
								return i;
							}
						} else {
							return i;
						}
					}
				}
			}

			return false;
		},

		isInt: function (n) {
			return n % 1 === 0;
		},

		isFloat: function (n) {
			return Number(n) === n && n % 1 !== 0;
		},

		bit_band: function (iBehavior, iBitCheck) {
			return iBehavior & iBitCheck;
		},

		setHTMLNewLine: function (text) {
			while (text.indexOf('\n') !== -1) {
				$.Msg(text);
				text = text.replace('\n', '<br>');
			}

			return text;
		},

		custom_Round: function (num, numDecimalPlaces) {
			var mult = Math.pow(10, numDecimalPlaces || 0);
			return Math.round(num * mult) / mult;
		},

		rnd: function (min, max) {
			return Math.floor(Math.random() * (max - min + 1)) + min;
		}
	}

	GameUI.Utils = Utils;
}

function InitIngameGlobalUtils() {
	FixIllusionRemainingTime();
	FixHTMLUnitName();
	
}

function FixIllusionRemainingTime() {
	const center_block = GameUI.Utils.FindDotaHudElement("center_block");

	if (center_block) {
		const xp = center_block.FindChildTraverse("xp");

		if (xp) {
			xp.style.marginLeft = "0px";
		} else {
			$.Schedule(1.0, FixIllusionRemainingTime);
		}
	} else {
		$.Schedule(1.0, FixIllusionRemainingTime);
	}
}

function FixHTMLUnitName() {
	$.Msg("FixHTMLUnitName");
	const center_block = GameUI.Utils.FindDotaHudElement("center_block");

	if (center_block) {
		const unitname = center_block.FindChildTraverse("UnitNameLabel");

		if (unitname) {
			unitname.html = true;
		} else {
			$.Schedule(1.0, FixHTMLUnitName);
		}
	} else {
		$.Schedule(1.0, FixHTMLUnitName);
	}
}

// function ColoredText(colorCode, text) {
// 	return '<font color="' + colorCode + '">' + text + '</font>';
// }

// function IsDeveloper(ID) {
// 	if (CustomNetTables.GetTableValue("game_options", "donators") == undefined) {
// 		return false;
// 	}

// 	var local_steamid = Game.GetPlayerInfo(ID).player_steamid;
// 	var developers = CustomNetTables.GetTableValue("game_options", "donators");
		
// 	for (var key in developers) {
// 		var steamid = developers[key].steamid;
// 		var status = developers[key].status;
// 		if (local_steamid === steamid && status == 1 || status == 2)
// 			return true;
// 	}

// 	return false;
// }

// Somehow called multiple times, creating many panels for nothing
function OverrideTopBarHeroImage(args) {
	var team = "Radiant"

	if (Players.GetTeam(args.player_id) == 3) {
		team = "Dire"
	}

	var panel = GameUI.Utils.FindDotaHudElement(team + "Player" + args.player_id).FindChildTraverse("HeroImage")
	var newheroimage = $.CreatePanel('Panel', panel, '');
	newheroimage.style.width = "100%";
	newheroimage.style.height = "100%";
	newheroimage.style.backgroundImage = 'url("file://{images}/heroes/' + args.icon_path + '.png")';
	newheroimage.style.backgroundSize = "cover";
}

GameEvents.Subscribe("override_hero_image", OverrideTopBarHeroImage);

/*
if (GameUI.Utils.FindDotaHudElement("RadiantPlayer" + Players.GetLocalPlayer()).FindChildTraverse("HeroImage")) {
	var panel =  GameUI.Utils.FindDotaHudElement("RadiantPlayer" + Players.GetLocalPlayer()).FindChildTraverse("HeroImage")
	$.Msg(panel)
	OverrideHeroImage("0", panel, "lina")
}
*/

function OverrideTopBarColor() {
	var colors = CustomNetTables.GetTableValue("game_options", "player_colors");

	for (var id in colors) {
		if (Players.GetTeam(parseInt(id)) && Players.GetTeam(parseInt(id)) && Players.GetTeam(parseInt(id)) != 1) {
			var team = "Radiant"

			if (Players.GetTeam(parseInt(id)) == 3) {
				team = "Dire"
			}

			var panel = GameUI.Utils.FindDotaHudElement(team + "Player" + id)

			if (panel)
				panel.FindChildTraverse('PlayerColor').style.backgroundColor = colors[id];
		}
	}
}

GameEvents.Subscribe("override_top_bar_colors", OverrideTopBarColor);

var toggle_ui = true;

function ToggleUI() {
	if (toggle_ui == true) {
		GameUI.Utils.FindDotaHudElement("HUDElements").style.visibility = "collapse";
		GameUI.Utils.FindDotaHudElement("CustomUIRoot").style.visibility = "collapse";
		toggle_ui = false;
	} else {
		GameUI.Utils.FindDotaHudElement("HUDElements").style.visibility = "visible";
		GameUI.Utils.FindDotaHudElement("CustomUIRoot").style.visibility = "visible";
		toggle_ui = true;
	}
}

GameEvents.Subscribe("toggle_ui", ToggleUI);

function SetupLoadingScreen(args) {
//	$.Msg("Setup loading screen!");
	var value = "collapse";
	if (args && args.value)
		value = args.value;

	var Parent = $.GetContextPanel().GetParent().GetParent().GetParent();

	if (Parent.FindChildTraverse("GameAndPlayersRoot") == undefined || Parent.FindChildTraverse("TeamsList") == undefined || Parent.FindChildTraverse("TeamsListGroup") == undefined || Parent.FindChildTraverse("CancelAndUnlockButton") == undefined || Parent.FindChildTraverse("UnassignedPlayerPanel") == undefined || Parent.FindChildTraverse("ShuffleTeamAssignmentButton") == undefined)
		$.Schedule(0.25, SetupLoadingScreen);
	else {
		Parent.FindChildTraverse("GameAndPlayersRoot").style.visibility = value;
		var cancel = Parent.FindChildTraverse("CancelAndUnlockButton");
		var lock = Parent.FindChildTraverse("LockAndStartButton");
		var shuffle = Parent.FindChildTraverse("ShuffleTeamAssignmentButton");

//		if (Game.IsInToolsMode() == false) {
//			Parent.FindChildTraverse("ShuffleTeamAssignmentButton").style.visibility = value;
//			cancel.style.visibility = value;
//			lock.style.visibility = value;
//		} else {
			var parent = Parent.FindChildTraverse("TeamsList");
			var header = Parent.FindChildTraverse("TeamsListGroup");

			var game_info = Parent.FindChildTraverse("GameAndPlayersRoot").FindChildTraverse("GameInfoPanel");
			var map_label = Parent.FindChildTraverse("MapInfoLabel");
//			var text = "Re-ordering teams based on seasonal winrate, please wait";

//			map_label.text = text;
//			SetTeamOrderingText(map_label);

			if (game_info) {
				game_info.SetParent(parent);
				parent.MoveChildBefore(game_info, header);
			}

			if (parent.FindChildTraverse("GameInfoPanel"))
				parent.MoveChildBefore(parent.FindChildTraverse("GameInfoPanel"), header);

//			if (Game.IsInToolsMode() == false) {
				if (cancel)
					cancel.style.visibility = value;

				if (lock)
					lock.style.visibility = value;

				if (shuffle)
					shuffle.style.visibility = value;
//			} else {
//				if (cancel)
//					cancel.SetParent(parent);

//				if (lock)
//					lock.SetParent(parent);
//			}

//			Parent.FindChildTraverse("TeamsListGroup").SetParent(Parent.FindChildTraverse("GameAndPlayersRoot"))
//			Parent.FindChildTraverse("TeamsListGroup").style.verticalAlign = "top";
//			Parent.FindChildTraverse("TeamsListGroup").style.width = "99%";
//		}
	}
}

// function GetDonatorColor(status) {
// 	// lua donator status are still using old numbers
// 	//	var donator_colors = CustomNetTables.GetTableValue("game_options", "donator_colors")
// 	//	$.Msg("Donator colors:")
// 	//	$.Msg(donator_colors)

// 	// Placeholder
// 	var donator_colors = [];
// 	donator_colors[1] = "#00CC00";
// 	donator_colors[2] = "#DAA520";
// 	donator_colors[3] = "#DC2828";
// 	donator_colors[4] = "#993399";
// 	donator_colors[5] = "#2F5B97";
// 	donator_colors[6] = "#BB4B0A";
// 	donator_colors[7] = "#871414";
// 	donator_colors[100] = "#0066FF";
// 	donator_colors[101] = "#641414";
// 	donator_colors[102] = "#871414";

// 	return donator_colors[status];
// }

function LightenDarkenColor(col, amt) {
	var usePound = false;
  
	if (col[0] == "#") {
		col = col.slice(1);
		usePound = true;
	}
 
	var num = parseInt(col,16);
 
	var r = (num >> 16) + amt;
 
	if (r > 255) r = 255;
	else if  (r < 0) r = 0;
 
	var b = ((num >> 8) & 0x00FF) + amt;
 
	if (b > 255) b = 255;
	else if  (b < 0) b = 0;
 
	var g = (num & 0x0000FF) + amt;
 
	if (g > 255) g = 255;
	else if (g < 0) g = 0;
	
	var color = ("") + (g | (b << 8) | (r << 16)).toString(16);

	var length = color.length;

	if ( length < 6 ) {
		for (var i = 0; i < (6-length); i++) {
			color = "0" + color;
		}
	}

	return (usePound?"#":"") + color;
}

(function () {
	GameEvents.Subscribe("setup_loading_screen", SetupLoadingScreen);
})();
