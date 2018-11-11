/* global Players $ GameEvents CustomNetTables FindDotaHudElement Game */

if (typeof module !== 'undefined' && module.exports) {
	module.exports = {
		SelectHero: SelectHero,
		CaptainSelectHero: CaptainSelectHero,
		BecomeCaptain: BecomeCaptain,
		RandomHero: RandomHero,
		PreviewHeroCM: PreviewHeroCM
	};
}

// for testing
var neverHideStrategy = false;

var currentMap = Game.GetMapInfo().map_display_name;
var hasGoneToStrategy = false;
var selectedhero = 'empty';
var disabledheroes = [];
var herolocked = false;
var panelscreated = 0;
var iscm = false;
var selectedherocm = 'empty';
var isPicking = true;
var currentHeroPreview = '';
var radiantPlayers = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_GOODGUYS );
var direPlayers = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_BADGUYS );
var radiant_imr = 0
var dire_imr = 0

var stepsCompleted = {
	2: 0,
	3: 0
};
var lastPickIndex = 0;
var hilariousLoadingPhrases = [
	'Precaching all heroes',
//	'Adding Mangonim Scepter',
//	'Nerfed [Most pick hero]',
//	'Subscribing your account to Dota Imba plus for 42 months',
//	'Tooltip Missing!',
	'Herding more llama',
//	// 'Developing Artifact Imba',
//	'Buffing Pudge',
	'Working around Valve Bugs',
	'REEEEEEEEEEEEEEEEEEE',
	'Loading heroes',
	'Opening wormholes',
	'Training Creeps',
	'Petting Roshan',
	'Infesting units',
	'Assembling runes'
];

var abilityPanels = [
	$('#PickedHeroAbility1'),
	$('#PickedHeroAbility2'),
	$('#PickedHeroAbility3'),
	$('#PickedHeroAbility4'),
	$('#PickedHeroAbility5'),
	$('#PickedHeroAbility6'),
	$('#PickedHeroAbility7'),
	$('#PickedHeroAbility8'),
	$('#PickedHeroAbility9')
]

var hiddenAbilities = [
	"imba_alchemist_mammonite",
	"imba_phoenix_icarus_dive_stop",
	"nyx_assassin_burrow",
	"nyx_assassin_unburrow",
	"imba_dazzle_ressurection",
	"imba_jakiro_ice_breath",
	"imba_empress_ambient_effects",
	"generic_hidden",
	"imba_troll_warlord_whirling_axes_melee",
	"abyssal_underlord_cancel_dark_rift",
	"earth_spirit_petrify",
	"imba_elder_titan_return_spirit",
	"life_stealer_assimilate",
	"life_stealer_control",
	"life_stealer_consume",
	"life_stealer_assimilate_eject",
	"imba_phoenix_sun_ray_toggle_move",
	"imba_phoenix_launch_fire_spirit",
	"imba_phoenix_sun_ray_stop",
	"shredder_chakram_2",
	"shredder_return_chakram",
	"shredder_return_chakram_2",
	"imba_slardar_rain_cloud",
	"treant_eyes_in_the_forest",
	"tusk_walrus_kick",
	"tusk_launch_snowball",
	"wisp_tether_break",
	"lone_druid_true_form_battle_cry",
	"lone_druid_true_form_druid",
	"monkey_king_primal_spring_early",
	"monkey_king_untransform",
	"morphling_morph_replicate",
	"morphling_morph",
	"naga_siren_song_of_the_siren_cancel",
	"pangolier_gyroshell_stop",
	"ancient_apparition_ice_blast_release",
	"invoker_cold_snap",
	"invoker_tornado",
	"invoker_ghost_walk",
	"keeper_of_the_light_illuminate_end",
	"keeper_of_the_light_spirit_form_illuminate",
	"keeper_of_the_light_spirit_form_illuminate_end",
	"ogre_magi_unrefined_fireblast",
	"rubick_telekinesis_land",
	"rubick_hidden1",
	"rubick_hidden2",
	"zuus_cloud",
	"imba_rubick_spell_steal_controller",
	"imba_tiny_tree_throw",
	"imba_wisp_tether_break",
	"imba_wisp_relocate_break",
	"imba_zuus_nimbus_zap",
	"imba_zuus_leave_nimbus",
	"" // Leave it alone, he's useful
]

var localTeam = Players.GetTeam(Players.GetLocalPlayer())
if (localTeam != 2 && localTeam != 3 && localTeam != 6 && localTeam != 7 && localTeam != 8 && localTeam != 9 && localTeam != 10 && localTeam != 11 && localTeam != 12 && localTeam != 13 || Game.GetPlayerInfo(Game.GetLocalPlayerID()).player_selected_hero != "npc_dota_hero_dummy_dummy") {
	HidePickingScreen()
} else {
	SetupBackgroundImage();
	CustomNetTables.SubscribeNetTableListener('hero_selection', onPlayerStatChange);

	GameEvents.Subscribe("pick_abilities", OnReceiveAbilities);

	onPlayerStatChange(null, 'herolist', CustomNetTables.GetTableValue('hero_selection', 'herolist'));
	onPlayerStatChange(null, 'APdata', CustomNetTables.GetTableValue('hero_selection', 'APdata'));
	onPlayerStatChange(null, 'CMdata', CustomNetTables.GetTableValue('hero_selection', 'CMdata'));
	onPlayerStatChange(null, 'time', CustomNetTables.GetTableValue('hero_selection', 'time'));
	onPlayerStatChange(null, 'preview_table', CustomNetTables.GetTableValue('hero_selection', 'preview_table'));
	ReloadCMStatus(CustomNetTables.GetTableValue('hero_selection', 'CMdata'));
	UpdatePreviews(CustomNetTables.GetTableValue('hero_selection', 'preview_table'));
	changeHilariousLoadingText();
}

if (currentMap == "ranked_1v1") {
	Setup1v1();
} else if (currentMap == 'imba_10v10' || currentMap == 'ranked_10v10' ||  currentMap == 'super_frantic_10v10' || currentMap == 'mutation_10v10') {
	SetupTopBar();
} else if (currentMap == 'cavern') {
	$.GetContextPanel().SetHasClass('Cavern', true);
}

if (currentMap == "ranked_5v5" || currentMap == "ranked_10v10") {
	SetupIMRAverage()
}

$('#ARDMLoading').style.opacity = 0;

function HidePickingScreen() {
	$.GetContextPanel().DeleteAsync(0)
	ReturnChatWindow()
}

function changeHilariousLoadingText () {
	var incredibleWit = hilariousLoadingPhrases[~~(Math.random() * hilariousLoadingPhrases.length)];

	noDots();
	$.Schedule(1, oneDots);
	$.Schedule(2, twoDots);
	$.Schedule(3, threeDots);
	$.Schedule(6, noDots);
	$.Schedule(7, oneDots);
	$.Schedule(8, twoDots);
	$.Schedule(9, threeDots);

	$.Schedule(12, changeHilariousLoadingText);

	function noDots () {
		$('#ARDMLoading').text = incredibleWit;
	}
	function oneDots () {
		$('#ARDMLoading').text = incredibleWit + '.';
	}
	function twoDots () {
		$('#ARDMLoading').text = incredibleWit + '..';
	}
	function threeDots () {
		$('#ARDMLoading').text = incredibleWit + '...';
	}
}

function onPlayerStatChange(table, key, data) {
	var teamID = Players.GetTeam(Game.GetLocalPlayerID());
	var newimage = null;

	if (key === 'herolist' && data != null) {
		// do not move chat for ardm
		if (currentMap !== 'ardm') {
			MoveChatWindow();
		}

		var strengthholder = FindDotaHudElement('StrengthHeroes');
		var agilityholder = FindDotaHudElement('AgilityHeroes');
		var intelligenceholder = FindDotaHudElement('IntelligenceHeroes');

		var ply_battlepass = CustomNetTables.GetTableValue("battlepass", Game.GetLocalPlayerID());

		if (Game.GetMapInfo().map_display_name == "mutation_5v5" || Game.GetMapInfo().map_display_name == "mutation_10v10") {
			if (data.mutation["negative"] == "all_random_deathmatch") {
				HidePickingScreen()
				return;
			}
			Mutation(data.mutation)
		} else
			FindDotaHudElement('MainContent').AddClass("Ranked")

		Object.keys(data.herolist).sort().forEach(function (heroName) {
			var currentstat = null;
			switch (data.herolist[heroName]) {
				case 'DOTA_ATTRIBUTE_STRENGTH':
					currentstat = strengthholder;
					break;
				case 'DOTA_ATTRIBUTE_AGILITY':
					currentstat = agilityholder;
					break;
				case 'DOTA_ATTRIBUTE_INTELLECT':
					currentstat = intelligenceholder;
					break;
			}

			var newhero = $.CreatePanel('RadioButton', currentstat, heroName);
			newhero.group = 'HeroChoises';
			newhero.SetPanelEvent('onactivate', function () { PreviewHero(heroName); });

			var newheroimage = $.CreatePanel('DOTAHeroImage', newhero, '');
			newheroimage.hittest = false;
			newheroimage.heroname = heroName;

			var image_name = heroName

			if (ply_battlepass) {
				if (ply_battlepass.arcana[heroName]) {
					image_name = heroName.replace("npc_dota_hero_", "");
					$.Msg(image_name)
					OverrideHeroImage(ply_battlepass.arcana[heroName] + 1, newheroimage, image_name)
				}
			}

			switch (data.herolist[heroName]) {
				case 1:
					newhero.AddClass("HeroCard")
					break;
			}

			switch (data.imbalist[heroName]) {
				case 1:
					newhero.AddClass("ImbaCard")
					break;
			}

			switch (data.newlist[heroName]) {
				case 1:
					newhero.AddClass("NewCard")
					break;
			}

			switch (data.customlist[heroName]) {
				case 1:
					newhero.AddClass("CustomCard")
					break;
			}

			switch (data.hotdisabledlist[heroName]) {
				case 1:
					DisableHero(heroName)
					break;
			}
		});
	} else if (key === 'preview_table' && data != null) {
		UpdatePreviews(data);
	} else if (key === 'APdata' && data != null) {
		var length = Object.keys(data).length;
		if (panelscreated !== length) {
			var teamdire = FindDotaHudElement('TeamDire');
			var teamradiant = FindDotaHudElement('TeamRadiant');
			var dummyClock = FindDotaHudElement('DummyClock');
			panelscreated = length;
			teamdire.RemoveAndDeleteChildren();
			teamradiant.RemoveAndDeleteChildren();

			Object.keys(data).forEach(function (nkey) {
				var currentteam = null;
				switch (data[nkey].team) {
					case 2:
						currentteam = teamradiant;
						break;
					case 3:
						currentteam = teamdire;
						break;
				}
				var newelement = $.CreatePanel('Panel', currentteam, '');
				newelement.AddClass('Player');
				newimage = $.CreatePanel('DOTAHeroImage', newelement, data[nkey].steamid);
				newimage.hittest = false;
				newimage.AddClass('PlayerImage');
				newimage.heroname = data[nkey].selectedhero;

				var newinfo = $.CreatePanel('Label', newelement, '');
				newinfo.AddClass('PlayerInfo');

				var player_color = "#DDDDDD";
				if (typeof data[nkey].id != 'undefined') {
					// $('#MyEntry').SetFocus();
					var player_table = CustomNetTables.GetTableValue("player_table", data[nkey].id.toString());
					if (player_table) {
						if (currentMap == "ranked_5v5") {
							if (player_table.IMR_5v5_calibrating) {
								newinfo.text = "IMR: TBD";
							} else if (player_table.IMR_5v5) {
								newinfo.text = "IMR: " + Math.floor(player_table.IMR_5v5);
							}
						} else if (currentMap == "ranked_10v10") {
							if (player_table.IMR_10v10_calibrating) {
								newinfo.text = "IMR: TBD";
							} else if (player_table.IMR_10v10) {
								newinfo.text = "IMR: " + Math.floor(player_table.IMR_10v10);
							}
						} else {
							newinfo.text = "Lvl: " + Math.floor(player_table.Lvl);
						}
						player_color = player_table.ply_color;
					}
				}

				var newlabel = $.CreatePanel('DOTAUserName', newelement, '');
				newlabel.AddClass('PlayerLabel');
				newlabel.steamid = data[nkey].steamid;

				var newcolorbar = $.CreatePanel('Panel', newelement, 'PlayerColorBar' + data[nkey].id);
				newcolorbar.AddClass('PlayerColorBar');
				if (player_color != undefined)
					newcolorbar.style.backgroundColor = player_color;

				var newcolorbaroverlay = $.CreatePanel('Panel', newcolorbar, '');
				newcolorbaroverlay.AddClass('PlayerColorBarOverlay');

				var newoverlay = $.CreatePanel('Panel', newelement, '');
				newoverlay.AddClass('PlayerOverlay');

				DisableHero(data[nkey].selectedhero);

				if (iscm) {
					if (data[nkey].selectedhero !== 'empty') {
						FindDotaHudElement('CMStep' + nkey).heroname = data[nkey].selectedhero;
						var label = FindDotaHudElement('CMHeroPickLabel_' + data[nkey].selectedhero);

						label.style.visibility = 'collapse';
						label.steamid = null;
						FindDotaHudElement('CMHeroPickLabel_' + data[nkey].selectedhero).steamid = data[nkey].steamid;
						FindDotaHudElement('CMHeroPickLabel_' + data[nkey].selectedhero).style.visibility = 'visible';
					} else {
						FindDotaHudElement('CMHeroPickLabel_' + data[nkey].selectedhero).steamid = data[nkey].steamid;
						FindDotaHudElement('CMHeroPickLabel_' + data[nkey].selectedhero).style.visibility = 'collapse';
					}
				}
			});
		} else {
			if (iscm) {
				var cmData = CustomNetTables.GetTableValue('hero_selection', 'CMdata');
				Object.keys(cmData['order']).forEach(function (nkey) {
					var obj = cmData['order'][nkey];
					FindDotaHudElement('CMStep' + nkey).heroname = obj.hero;
					FindDotaHudElement('CMStep' + nkey).RemoveClass('active');
					if (obj.side === teamID && obj.type === 'Pick' && obj.hero !== 'empty') {
						var label = FindDotaHudElement('CMHeroPickLabel_' + obj.hero);

						label.style.visibility = 'collapse';
						label.steamid = null;
					}
				});
			}
			Object.keys(data).forEach(function (nkey) {
				var currentplayer = FindDotaHudElement(data[nkey].steamid);
				currentplayer.heroname = data[nkey].selectedhero;
				currentplayer.RemoveClass('PreviewHero');

				if (currentMap != "ranked_1v1") {
					DisableHero(data[nkey].selectedhero);
				}

				if (iscm && FindDotaHudElement('CMHeroPickLabel_' + data[nkey].selectedhero)) {
					if (data[nkey].steamid) {
						FindDotaHudElement('CMHeroPickLabel_' + data[nkey].selectedhero).steamid = data[nkey].steamid;
						FindDotaHudElement('CMHeroPickLabel_' + data[nkey].selectedhero).style.visibility = 'visible';
						// FindDotaHudElement('CMHeroPick_' + data[nkey].selectedhero).style.brightness = 0.2;
					} else {
						FindDotaHudElement('CMHeroPickLabel_' + data[nkey].selectedhero).steamid = data[nkey].steamid;
						FindDotaHudElement('CMHeroPickLabel_' + data[nkey].selectedhero).style.visibility = 'collapse';
						// FindDotaHudElement('CMHeroPick_' + data[nkey].selectedhero).style.brightness = 1;
					}
				}
			});
		}
	} else if (key === 'CMdata' && data != null) {
		iscm = true;
		var teamName = teamID === 2 ? 'radiant' : 'dire';
		if (data['captain' + teamName] === 'empty') {
			isPicking = false;
			// "BECOME CAPTAIN" button
			FindDotaHudElement('CMPanel').style.visibility = 'visible';
			FindDotaHudElement('CMHeroPreview').style.visibility = 'collapse';
			// FindDotaHudElement('HeroPreview').style.visibility = 'collapse';
			FindDotaHudElement('HeroLockIn').style.visibility = 'collapse';
			FindDotaHudElement('HeroRandom').style.visibility = 'collapse';
			FindDotaHudElement('HeroImbaRandom').style.visibility = 'collapse';
			FindDotaHudElement('BecomeCaptain').style.visibility = 'visible';
			return;
		} else {
			FindDotaHudElement('CMPanel').style.visibility = 'visible';
			FindDotaHudElement('CMProgress').style.visibility = 'visible';
			FindDotaHudElement('CMHeroPreview').style.visibility = 'collapse';
			FindDotaHudElement('HeroLockIn').style.visibility = 'collapse';
			FindDotaHudElement('HeroRandom').style.visibility = 'collapse';
			FindDotaHudElement('HeroImbaRandom').style.visibility = 'collapse';
			FindDotaHudElement('BecomeCaptain').style.visibility = 'collapse';
		}
		FindDotaHudElement('RadiantReserve').text = data['reserveradiant'];
		FindDotaHudElement('DireReserve').text = data['reservedire'];

		if (data['currentstage'] < data['totalstages'] || (data['order'][data['currentstage']] && data['order'][data['currentstage']].hero === 'empty')) {
			if (!data['order'][data['currentstage']]) {
				return;
			}
			FindDotaHudElement('CMPanel').style.visibility = 'visible';
			FindDotaHudElement('CMHeroPreview').style.visibility = 'collapse';
			FindDotaHudElement('HeroLockIn').style.visibility = 'collapse';
			FindDotaHudElement('HeroRandom').style.visibility = 'collapse';
			FindDotaHudElement('HeroImbaRandom').style.visibility = 'collapse';
			FindDotaHudElement('BecomeCaptain').style.visibility = 'collapse';
			var currentPick = null;
			var currentPickIndex = 0;
			if (data['order'][data['currentstage']].hero === 'empty') {
				currentPickIndex = data['currentstage'];
				currentPick = data['order'][currentPickIndex];
			} else {
				currentPickIndex = data['currentstage'] + 1;
				currentPick = data['order'][currentPickIndex];
			}
			if (currentPickIndex > lastPickIndex) {
				stepsCompleted[currentPick.side]++;
				lastPickIndex = currentPickIndex;
			}
			$.Msg(currentPick);
			$.Msg(stepsCompleted);

			FindDotaHudElement('CMRadiantProgress').style.width = ~~(stepsCompleted[2] / (data['totalstages'] / 2) * 100) + '%';
			FindDotaHudElement('CMDireProgress').style.width = ~~(stepsCompleted[3] / (data['totalstages'] / 2) * 100) + '%';
			FindDotaHudElement('CMStep' + currentPickIndex).AddClass('active');

			FindDotaHudElement('CMRadiant').RemoveClass('Pick');
			FindDotaHudElement('CMRadiant').RemoveClass('Ban');
			FindDotaHudElement('CMDire').RemoveClass('Pick');
			FindDotaHudElement('CMDire').RemoveClass('Ban');

			if (currentPick.side === 2) {
				FindDotaHudElement('CMRadiant').AddClass(currentPick.type);
			} else {
				FindDotaHudElement('CMDire').AddClass(currentPick.type);
			}

			FindDotaHudElement('CaptainLockIn').RemoveClass('PickHero');
			FindDotaHudElement('CaptainLockIn').RemoveClass('BanHero');
			FindDotaHudElement('CaptainLockIn').AddClass(currentPick.type + 'Hero');

			if (data['order'][data['currentstage']] && data['order'][data['currentstage']].hero && data['order'][data['currentstage']].hero !== 'empty') {
				FindDotaHudElement('CMStep' + data['currentstage']).heroname = data['order'][data['currentstage']].hero;
				FindDotaHudElement('CMStep' + data['currentstage']).RemoveClass('active');
				DisableHero(data['order'][data['currentstage']].hero);
			}
			$.Msg(data['currentstage'] + ', ' + currentPick.side);
			if (Game.GetLocalPlayerID() === data['captain' + teamName] && teamID === currentPick.side) {
				// FindDotaHudElement('CaptainLockIn').style.visibility = 'visible';
				isPicking = true;
				PreviewHero();
			} else {
				isPicking = false;
				PreviewHero();
			}
		} else if (data['currentstage'] === data['totalstages']) {
			FindDotaHudElement('CMStep' + data['currentstage']).heroname = data['order'][data['currentstage']].hero;
			DisableHero(data['order'][data['currentstage']].hero);
			FindDotaHudElement('CMPanel').style.visibility = 'visible';
			FindDotaHudElement('HeroLockIn').style.visibility = 'collapse';
			FindDotaHudElement('HeroRandom').style.visibility = 'collapse';
			FindDotaHudElement('HeroImbaRandom').style.visibility = 'collapse';
			// FindDotaHudElement('HeroPreview').style.visibility = 'collapse';
			FindDotaHudElement('BecomeCaptain').style.visibility = 'collapse';
			FindDotaHudElement('CaptainLockIn').style.visibility = 'collapse';
			DisableHero(data['order'][data['currentstage']].hero);

			ReloadCMStatus(data);
			disabledheroes = [];
			FindDotaHudElement('SectionTitle').style.visibility = 'collapse';
			FindDotaHudElement('CMHeroPreview').style.visibility = 'visible';
		}
	} else if (key === 'time' && data != null) {
		// $.Msg(data);
		if (data.mode === 'STRATEGY') {
			FindDotaHudElement('TimeLeft').text = 'VS';
			FindDotaHudElement('GameMode').text = $.Localize(data['mode']);
			GoToStrategy();
		} else if (data['time'] > -1) {
			FindDotaHudElement('TimeLeft').text = data['time'];
			FindDotaHudElement('GameMode').text = $.Localize(data['mode']);
//			if (data['time'] == 10 || data['time'] == 30) {
			if (data['time'] == 10) {
				Game.EmitSound("announcer_ann_custom_countdown_" + data['time']);
			} else if (data['time'] < 10 && data['time'] > 0) {
				Game.EmitSound("announcer_ann_custom_countdown_0" + data['time']);
			}
		} else {
			// CM Hides the chat on last pick, before selecting plyer hero
			// ARDM don't have pick screen chat
//			if (currentMap === 'ranked_5v5' || currentMap === 'ranked_10v10') {
				ReturnChatWindow();
//			}

			HideStrategy();
		}
	}
}

function SetupIMRAverage() {
	var radiant_count = 0
	var dire_count = 0

	$.Each( radiantPlayers, function( player ) {
		var plyData = CustomNetTables.GetTableValue("player_table", player)
		if (currentMap == "ranked_5v5") {
			radiant_imr = radiant_imr + plyData.IMR_5v5
			radiant_count = radiant_count + 1
		} else {
			radiant_imr = radiant_imr + plyData.IMR_10v10
			radiant_count = radiant_count + 1
		}
	})

	$.Each( direPlayers, function( player ) {
		var plyData = CustomNetTables.GetTableValue("player_table", player)
		if (currentMap == "ranked_5v5") {
			dire_imr = dire_imr + plyData.IMR_5v5
			dire_count = dire_count + 1
		} else {
			dire_imr = dire_imr + plyData.IMR_10v10
			dire_count = dire_count + 1
		}
	})

	$("#RadiantIMR").style.visibility = "visible";
	$("#DireIMR").style.visibility = "visible";
	$("#RadiantIMR_label").text = "Average IMR: " + radiant_imr.toFixed(0) / radiant_count;
	$("#DireIMR_label").text = "Average IMR: " + dire_imr.toFixed(0) / dire_count;
}

function Setup1v1() {
	if (Players.GetTeam(Game.GetLocalPlayerID()) == 2) {
		$("#TeamDire").style.visibility = "collapse"
	} else if (Players.GetTeam(Game.GetLocalPlayerID()) == 3) {
		$("#TeamRadiant").style.visibility = "collapse"
	}
}

function SetupBackgroundImage() {

	if (Players.GetTeam(Game.GetLocalPlayerID()) == 2) {
		var background_image = [
			"radiant",
			"radiant2",
		]
	} else if (Players.GetTeam(Game.GetLocalPlayerID()) == 3) {
		var background_image = [
			"dire",
			"dire2",
		]
	} else {
		var background_image = [
			"clash_ancients",
			"clash_heroes",
		]
	}

	var random_int = Math.floor(Math.random() * (background_image.length - 0) ) + 0;
	var image = background_image[random_int]

	var background = $("#ImageBG");
	// background.style.backgroundImage = 'url("file://{images}/custom_game/picking_screen/' + image + '.png")';
	background.style.backgroundImage = 'url("file://{images}/custom_game/pick_bg.png")';
	background.style.backgroundSize = 'cover';
}

function SetupTopBar() {
	$.GetContextPanel().SetHasClass('TenVTen', true);
	var topbar = FindDotaHudElement('topbar');
	topbar.style.width = '1550px';

	// Top Bar Radiant
	var TopBarRadiantTeam = FindDotaHudElement('TopBarRadiantTeam');
	TopBarRadiantTeam.style.width = '690px';

	var topbarRadiantPlayers = FindDotaHudElement('TopBarRadiantPlayers');
	topbarRadiantPlayers.style.width = '690px';

	var topbarRadiantPlayersContainer = FindDotaHudElement('TopBarRadiantPlayersContainer');
	topbarRadiantPlayersContainer.style.width = '630px';
	FillTopBarPlayer(topbarRadiantPlayersContainer);

	var RadiantTeamContainer = FindDotaHudElement('RadiantTeamContainer');
	RadiantTeamContainer.style.height = '737px';

	// Top Bar Dire
	var TopBarDireTeam = FindDotaHudElement('TopBarDireTeam');
	TopBarDireTeam.style.width = '690px';

	var topbarDirePlayers = FindDotaHudElement('TopBarDirePlayers');
	topbarDirePlayers.style.width = '690px';

	var topbarDirePlayersContainer = FindDotaHudElement('TopBarDirePlayersContainer');
	topbarDirePlayersContainer.style.width = '630px';
	FillTopBarPlayer(topbarDirePlayersContainer);

	var DireTeamContainer = FindDotaHudElement('DireTeamContainer');
	DireTeamContainer.style.height = '737px';
}

function FillTopBarPlayer(TeamContainer) {
	// Fill players top bar in case on partial lobbies
	var playerCount = TeamContainer.GetChildCount();
	for (var i = playerCount + 1; i <= 10; i++) {
		var newPlayer = $.CreatePanel('DOTATopBarPlayer', TeamContainer, 'RadiantPlayer-1');
		if (newPlayer) {
			newPlayer.FindChildTraverse('PlayerColor').style.backgroundColor = '#FFFFFFFF';
		}
		newPlayer.SetHasClass('EnemyTeam', true);
	}
}

function MoveChatWindow() {
	var vanillaChat = FindDotaHudElement('HudChat');
	vanillaChat.SetHasClass('ChatExpanded', true);
	vanillaChat.SetHasClass('Active', true);
	vanillaChat.style.y = '0px';
	vanillaChat.hittest = true;
//	vanillaChat.style.width = "700px";
	vanillaChat.SetParent(FindDotaHudElement('ChatPlaceholder'));
}

function ReturnChatWindow() {
	var vanillaChat = FindDotaHudElement('HudChat');
	var vanillaChatParent = FindDotaHudElement('HUDElements');

	if (vanillaChat.GetParent() !== vanillaChatParent) {
		// Remove focus before change parent
		vanillaChatParent.SetFocus();
		vanillaChat.SetParent(vanillaChatParent);
		vanillaChat.style.y = '-240px';
		vanillaChat.hittest = false;
		vanillaChat.style.visibility = "visible";
//		vanillaChat.style.width = "700px";
		vanillaChat.SetHasClass('ChatExpanded', false);
		vanillaChat.SetHasClass('Active', false);
	}
}

function UpdatePreviews (data) {
	if (!data) {
		return;
	}
	var apData = CustomNetTables.GetTableValue('hero_selection', 'APdata');
	var heroesBySteamid = {};
	Object.keys(apData).forEach(function (playerId) {
		if (apData[playerId].selectedhero && apData[playerId].selectedhero !== 'empty' && apData[playerId].selectedhero !== 'random') {
			heroesBySteamid[apData[playerId].steamid] = apData[playerId].selectedhero;
		}
	});
	var teamID = Players.GetTeam(Game.GetLocalPlayerID());
	Object.keys(data[teamID] || {}).forEach(function (steamid) {
		if (heroesBySteamid[steamid]) {
			return;
		}
		var player = FindDotaHudElement(steamid);
		if (player) {
			player.heroname = data[teamID][steamid];
			player.AddClass('PreviewHero');
		}
	});
	Object.keys(heroesBySteamid).forEach(function (steamid) {
		var player = FindDotaHudElement(steamid);
		player.heroname = heroesBySteamid[steamid];
	});
}

function ReloadCMStatus(data) {
	if (!data) {
		return;
	}
	// reset all data for people, who lost it
	var teamID = Players.GetTeam(Game.GetLocalPlayerID());
	stepsCompleted = {
		2: 0,
		3: 0
	};

	var currentPick = null;
	if (data['order'][data['currentstage']].hero === 'empty') {
		currentPick = data['currentstage'];
	} else {
		currentPick = data['currentstage'] + 1;
	}
	var currentPickData = data['order'][currentPick];

	FindDotaHudElement('CMHeroPreview').RemoveAndDeleteChildren();
	Object.keys(data['order']).forEach(function (nkey) {
		var obj = data['order'][nkey];
		// FindDotaHudElement('CMStep' + nkey).heroname = obj.hero;
		if (obj.hero !== 'empty') {
			DisableHero(obj.hero);
		}

		// the "select your hero at the end" thing
		if (obj.side === teamID && obj.type === 'Pick' && obj.hero !== 'empty') {
			ReturnChatWindow();
			var newbutton = $.CreatePanel('RadioButton', FindDotaHudElement('CMHeroPreview'), '');
			newbutton.group = 'CMHeroChoises';
			newbutton.AddClass('CMHeroPreviewItem');
			newbutton.SetPanelEvent('onactivate', function () { SelectHero(obj.hero); });
			newbutton.BCreateChildren('<Label class="HeroPickLabel" text="#' + obj.hero + '" />');

			CreateHeroPanel(newbutton, obj.hero);
			var newlabel = $.CreatePanel('DOTAUserName', newbutton, 'CMHeroPickLabel_' + obj.hero);
			newlabel.style.visibility = 'collapse';
			newlabel.steamid = null;
		}

		// the CM picking order phase thingy
		if (obj.hero && obj.hero !== 'empty') {
			FindDotaHudElement('CMStep' + nkey).heroname = obj.hero;
			FindDotaHudElement('CMStep' + nkey).RemoveClass('active');

			FindDotaHudElement('CMRadiant').RemoveClass('Pick');
			FindDotaHudElement('CMRadiant').RemoveClass('Ban');
			FindDotaHudElement('CMDire').RemoveClass('Pick');
			FindDotaHudElement('CMDire').RemoveClass('Ban');
		}

		if (currentPick >= nkey) {
			stepsCompleted[obj.side]++;
			lastPickIndex = nkey;
		}
	});
	$.Msg(stepsCompleted);
	FindDotaHudElement('CMRadiantProgress').style.width = ~~(stepsCompleted[2] / (data['totalstages'] / 2) * 100) + '%';
	FindDotaHudElement('CMDireProgress').style.width = ~~(stepsCompleted[3] / (data['totalstages'] / 2) * 100) + '%';
	if (currentPick < data['totalstages']) {
		FindDotaHudElement('CMStep' + currentPick).AddClass('active');

		if (currentPickData.side === 2) {
			FindDotaHudElement('CMRadiant').AddClass(currentPickData.type);
		} else {
			FindDotaHudElement('CMDire').AddClass(currentPickData.type);
		}
	}
}

function DisableHero(name) {
	if (FindDotaHudElement(name) != null) {
		FindDotaHudElement(name).AddClass('Disabled');
		disabledheroes.push(name);
	}
}

function IsHeroDisabled(name) {
	if (disabledheroes.indexOf(name) !== -1) {
		return true;
	}

	return false;
}

function PreviewHero(name) {
	var lockButton = null;
	if (iscm) {
		lockButton = FindDotaHudElement('CaptainLockIn');
	} else {
		lockButton = FindDotaHudElement('HeroLockIn');
	}

	if (!name) {
		if (selectedhero === 'empty') {
			lockButton.style.visibility = 'collapse';
			return;
		}
		name = selectedhero;
	}

	if (!herolocked || iscm) {
		// var preview = FindDotaHudElement('HeroPreview');
		if (name !== 'random' && currentHeroPreview !== name) {
			currentHeroPreview = name;
			// preview.RemoveAndDeleteChildren();
			// CreateHeroPanel(preview, name);
			$('#SectionTitle').text = $.Localize('#' + name, $('#SectionTitle'));
			$('#SectionTitle').text = $('#SectionTitle').text.toUpperCase();
			var current_hero_image = $('#CurrentHero');
			var ply_battlepass = CustomNetTables.GetTableValue("battlepass", Game.GetLocalPlayerID());
			var newheroimage = $.CreatePanel('DOTAHeroImage', current_hero_image, '');
			newheroimage.hittest = false;
			newheroimage.heroname = name;

			var image_name = name

			if (ply_battlepass) {
				if (ply_battlepass.arcana[name]) {
					image_name = name.replace("npc_dota_hero_", "");
					$.Msg(image_name)
					OverrideHeroImage(ply_battlepass.arcana[name] + 1, newheroimage, image_name)
				}
			}
		}
		selectedhero = name;
		selectedherocm = name;

		lockButton.style.visibility = (!isPicking || IsHeroDisabled(currentHeroPreview)) ? 'collapse' : 'visible';
		$('#HeroRandom').style.visibility = !isPicking ? 'collapse' : 'visible';

		GameEvents.SendCustomGameEventToServer('preview_hero', {
			hero: name
		});
	}

	// Request the hero's abilities table to the server 
	GameEvents.SendCustomGameEventToServer("pick_abilities_requested", {
		PlayerID: Game.GetLocalPlayerID(),
		HeroName: name
	});
}

function PreviewHeroCM (name) {
	return PreviewHero(name);
}

function SelectHero(hero) {
	var player_table = CustomNetTables.GetTableValue("player_table", Game.GetLocalPlayerID().toString());
	if (player_table)
		if (player_table.donator_level == 10)
			return;

	if (hero) {
		if (iscm) {
			selectedherocm = hero;
		} else {
			selectedhero = hero;
		}
	}

	if (!herolocked) {
		var newhero = 'empty';
		if (iscm && selectedherocm !== 'empty') {
			newhero = selectedherocm;
			FindDotaHudElement('HeroLockIn').style.saturation = 0;
			FindDotaHudElement('HeroRandom').style.saturation = 0;
			FindDotaHudElement('HeroImbaRandom').style.saturation = 0;
		} else if (!iscm && selectedhero !== 'empty' && !IsHeroDisabled(selectedhero)) {
			herolocked = true;
			isPicking = false;
			newhero = selectedhero;
			FindDotaHudElement('HeroLockIn').style.saturation = 0;
			FindDotaHudElement('HeroRandom').style.saturation = 0;
			FindDotaHudElement('HeroImbaRandom').style.saturation = 0;
		}
//		$.Msg('Selecting ' + newhero);
		GameEvents.SendCustomGameEventToServer('hero_selected', {
			PlayerID: Game.GetLocalPlayerID(),
			hero: newhero
		});
	}
}

function BecomeCaptain () {
	GameEvents.SendCustomGameEventToServer('cm_become_captain', {
		test: '1'
	});
}

function CaptainSelectHero () {
	if (selectedherocm !== 'empty') {
		GameEvents.SendCustomGameEventToServer('cm_hero_selected', {
			hero: selectedherocm
		});
	}
}

function HideStrategy () {
	// var bossMarkers = ['Boss1r', 'Boss1d', 'Boss2r', 'Boss2d', 'Boss3r', 'Boss3d', 'Boss4r', 'Boss4d', 'Boss5r', 'Boss5d', 'Duel1', 'Duel2', 'Cave1r', 'Cave1d', 'Cave2r', 'Cave2d', 'Cave3r', 'Cave3d'];

	// bossMarkers.forEach(function (element) {
	//   FindDotaHudElement(element).style.transform = 'translateY(0)';
	//   FindDotaHudElement(element).style.opacity = '1';
	// });
	if (neverHideStrategy) {
		return;
	}

	FindDotaHudElement('MainContent').GetParent().style.opacity = '0';
	FindDotaHudElement('MainContent').GetParent().style.transform = 'scaleX(3) scaleY(3) translateY(25%)';
}

function GoToStrategy () {
	FindDotaHudElement('MainContent').style.transform = 'translateX(0) translateY(100%)';
	FindDotaHudElement('MainContent').style.opacity = '0';
	FindDotaHudElement('StrategyContent').style.transform = 'scaleX(1) scaleY(1)';
	FindDotaHudElement('StrategyContent').style.opacity = '1';
	// FindDotaHudElement('PregameBG').style.opacity = '0.15';
	FindDotaHudElement('PregameBG').RemoveClass('BluredAndDark');

	if (!hasGoneToStrategy) {
		hasGoneToStrategy = true;
		$.Schedule(6, function () {
			$('#ARDMLoading').style.opacity = 1;
		});
	}
}

function RandomHero(random) {
	selectedhero = random;
	selectedherocm = random;

	if (iscm) {
		CaptainSelectHero();
	} else {
		SelectHero();
	}
}

function CreateHeroPanel(parent, hero) {
	var id = 'Scene' + ~~(Math.random() * 100);
	var scene = parent.BCreateChildren('<DOTAScenePanel hittest="false" id="' + id + '" style="opacity-mask: url(\'s2r://panorama/images/masks/softedge_box_png.vtex\');" drawbackground="0" renderdeferred="false" particleonly="false" unit="' + hero + '" rotateonhover="true" yawmin="-10" yawmax="10" pitchmin="-10" pitchmax="10" />');
	$.DispatchEvent('DOTAGlobalSceneSetCameraEntity', id, 'camera_end_top', 1.0);

	return scene;
}

function OnReceiveAbilities(data) {
	UpdateAbilities(data.heroAbilities);
}

/* Updates the selected hero abilities panel */
function UpdateAbilities(abilityList) {
	var talents = []
	var ability_count = 0
	var talent_count = 0

	$("#AghanimPreview").style.visibility = "collapse";
	$("#TalentPreview").style.visibility = "visible";
	$("#AghanimPreviewText").text = ""
	$("#AghanimPreviewText_Description").text = ""

	for (var i = 1; i <= 24; i++) {
		var abilityPanel = abilityPanels[i - 1]
		var ability = abilityList[i]
		if (ability != null) {
			if (i <= 8) {
				ability_count = ability_count + 1
				abilityPanel.abilityname = ability;
				abilityPanel.style.visibility = 'visible';

				for (var j = 0; j <= hiddenAbilities.length - 1; j++) {
					var ability_hidden = hiddenAbilities[j]
					if (ability_hidden != null) {
						if (ability == ability_hidden) {
							abilityPanel.style.visibility = 'collapse';
						}
					}
				}

				(function (abilityPanel, ability) {
					abilityPanel.SetPanelEvent("onmouseover", function () {
						$.DispatchEvent("DOTAShowAbilityTooltip", abilityPanel, ability);
					})
					abilityPanel.SetPanelEvent("onmouseout", function () {
						$.DispatchEvent("DOTAHideAbilityTooltip", abilityPanel);
					})
				})(abilityPanel, ability);
			} else if (i == 9) {
				if (ability) {
					$("#AghanimPreview").style.visibility = "visible";
					$("#AghanimPreview").style.visibility = "visible";
					$("#AghanimPreviewText").text = $.Localize("dota_tooltip_ability_" + ability)
					$("#AghanimPreviewText_Description").html = true
					$("#AghanimPreviewText_Description").text = $.Localize("dota_tooltip_ability_" + ability + "_aghanim_Description")
				}
			} else if (i >= 10) {
				if (ability.search("special") != -1) {
					talents[talent_count] = ability
					talent_count = talent_count + 1
				}
			}
		} else {
			if (i < 10) {
				abilityPanel.abilityname = null;
				abilityPanel.style.visibility = 'collapse';
				abilityPanel.onmouseover = null;
			}
		}
	}

	SetupTalentTooltips(talents)

	var abilityParentPanel = $("#AbilitiesPreview");
	abilityParentPanel.SetHasClass("six_abilities", ability_count >= 6);
	abilityParentPanel.SetHasClass("five_abilities", ability_count == 5);
	abilityParentPanel.SetHasClass("four_abilities", ability_count == 4);

	// Credits panel

	if ($("#credits_coder_panel"))
		$("#credits_coder_panel").DeleteAsync(0)

	var coder_steamid = $.Localize("#code_credits_" + abilityList[0])

	if (coder_steamid.search("7") != -1) {

		var coder_panel = $.CreatePanel("Panel", $("#HeroPreviewCredits"), "credits_coder_panel");

		var coder_label = $.CreatePanel('Label', coder_panel, 'credits_coder_label');
		coder_label.text = "Author: "

		// Show coder steam profile
		var steam_id = $.CreatePanel("DOTAAvatarImage", coder_panel, "credits_coder");
		steam_id.steamid = coder_steamid;
		steam_id.style.width = "38px";
		steam_id.style.height = "38px";
		steam_id.style.marginLeft = "20px";
		steam_id.style.marginRight = "20px";
		steam_id.style.align = "left center";
		steam_id.style.border = "2px solid darkred";
	}

	if ($("#credits_editors_panel"))
		$("#credits_editors_panel").DeleteAsync(0)

	var i = 1;
	var editor_steamid = $.Localize("#code_credits_" + abilityList[0] + "_editor_" + i)
	while (editor_steamid.search("7") != -1) {

		if (i == 1) {
			var editor_label = $.CreatePanel('Label', coder_panel, "credits_editor_label");
			editor_label.text = "Contributors: "
		}

		// Show coder steam profile
		var steam_id = $.CreatePanel("DOTAAvatarImage", coder_panel, "credits_editor_" + i);
		steam_id.steamid = editor_steamid;
		steam_id.style.width = "38px";
		steam_id.style.height = "38px";
		steam_id.style.marginLeft = "5px";
		steam_id.style.marginRight = "5px";
		steam_id.style.align = "left center";
		steam_id.style.border = "2px solid gold";

		i++;

		editor_steamid = $.Localize("#code_credits_" + abilityList[0] + "_editor_" + i)
	}
}

function CustomTooltip(type, boolean){
	var tooltip_panel = "";
	var show = "";

	if (type == "aghanim") {
		tooltip_panel = $("#AghanimPreviewTooltip")
	} else if (type == "talent") {
		tooltip_panel = $("#TalentPreviewWindow")
	}

	if (boolean == true) {
		show = "visible";
	} else {
		show = "collapse";
	}

	tooltip_panel.style.visibility = show
}

function SetupTalentTooltips(talents) {
	for (i in talents) {
		if (talents[i] != null) {
			var number = Number(i) + 1
			var talent_name = $.Localize("dota_tooltip_ability_" + talents[i])
			var talent_description = $.Localize("dota_tooltip_ability_" + talents[i] + "_Description");

			$("#Talent" + number + "_Name").style.visibility = "collapse";
			$("#Talent" + number + "_Description").style.visibility = "collapse";

			if (talent_description.search("dota") == -1) {
				$("#Talent" + number + "_Description").html = true
				$("#Talent" + number + "_Description").text = talent_description
				$("#Talent" + number + "_Description").style.visibility = "visible";
			} else {
				$("#Talent" + number + "_Name").html = true
				$("#Talent" + number + "_Name").style.visibility = "visible";
				$("#Talent" + number + "_Name").text = talent_name
			}
		}
	}
}

function TopBarColor(args) {
	$.Msg('event_called');
	$.GetContextPanel().FindChildTraverse('PlayerColorBar' + args.id).style.backgroundColor = "#FFF";
}

GameEvents.Subscribe("top_bar_colors", TopBarColor);

function HidePause(args) {
	FindDotaHudElement("PausedInfo").style.opacity = args.show;
}

GameEvents.Subscribe("hide_pause", HidePause);
