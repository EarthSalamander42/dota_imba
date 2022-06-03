var favourites = new Array();

for ( var i = 0; i < heronames.length; i++ )
{
	var msg = heronames[i];
	var numsb = new Array(false,false,false,false,false,false,false,false);
	var numsi = new Array(herostartrings+i*8,herostartrings+i*8+1,herostartrings+i*8+2,herostartrings+i*8+3,herostartrings+i*8+4,herostartrings+i*8+5,herostartrings+i*8+6,herostartrings+i*8+7);
	rings[rings.length] = new Array(msg,numsb,numsi);
}
for ( var i = 0; i < heronames2.length; i++ )
{
	var msg = new Array();
	var numsb = new Array(true,true,true,true,true,true,true,true);
	var numsi = new Array();
	for ( var x = 0; x < 8; x++ )
	{
		msg[x] = "#dota_chatwheel_label_"+heronames2[i]+mesarrs[x];
		numsi[x] = herostartnum+(i*8)+x;
	}
	rings[herostartrings+i] = new Array(msg,numsb,numsi);
}
var nowselect = 0;

var phrase_color = [
	GetDonatorColor(1), // Hero picked (Donator)
	GetDonatorColor(3), // Announcers (Ember Donator)
	GetDonatorColor(6), // Favourites (not working)
	GetDonatorColor(5), // Any hero (Icefrog Donator)
	"white", // Misc (Available to everyone)
	GetDonatorColor(6), // Battlepass 2019 (not working)
	GetDonatorColor(4), // Dota Plus 2 (Salamander Donator)
	GetDonatorColor(2), // Dota Plus 2 (Golden Donator)
]

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

//	$.Msg("Close Chat Wheel!")
	$("#Wheel").visible = false;
	$("#Bubble").visible = false;
	$("#PhrasesContainer").visible = false;
	$("#WHTooltip").visible = false;
	if (nowselect != 0)
	{
		$("#PhrasesContainer").RemoveAndDeleteChildren();
		for ( var i = 0; i < 8; i++ )
		{
			$.CreatePanelWithProperties(`Button`, $("#PhrasesContainer"), `Phrase${i}`, {
				class: `MyPhrases`,
				onmouseactivate: `OnSelect(${i})`,
				onmouseover: `OnMouseOver(${i})`,
				onmouseout: `OnMouseOut(${i})`,
			});

			$("#Phrase"+i).BLoadLayoutSnippet("Phrase");
			$("#Phrase"+i).GetChild(0).GetChild(0).visible = rings[0][1][i];
			$("#Phrase"+i).GetChild(0).GetChild(1).text = $.Localize(rings[0][0][i]);
			$("#Phrase"+i).GetChild(0).GetChild(1).style.color = phrase_color[i];
		}
		nowselect = 0;
	}
}

function OnSelect(num) {
	var newnum = rings[nowselect][2][num];
//	$.Msg(newnum)

	var ply_bp = CustomNetTables.GetTableValue("battlepass_player", Players.GetLocalPlayer().toString());
//	$.Msg(ply_bp);

	if (Game.IsInToolsMode())
		$.Msg($.Localize("#hero_chat_wheel_donator"))

	// misc, available to everyone
	if (newnum != 0 && newnum != 11 && newnum != 18 && newnum != 20 && newnum != 21 && newnum != 22 && newnum != 23 && newnum != 24) {
		if (ply_bp) {
			if (ply_bp.donator_level) {

			} else {
//				$.Msg("Not a donator!")
				$("#WHTooltip").style.visibility = "visible";
				$("#WHTooltip").text = "Available to donators only!";
				return;
			}
		} else {
//			$.Msg("Not a donator! (2)")
			$("#WHTooltip").style.visibility = "visible";
			$("#WHTooltip").text = "Available to donators only!";
			return;
		}
	}

	if (rings[nowselect][1][num])
	{
		GameEvents.SendCustomGameEventToServer("SelectVO", {num: newnum});
		StopWheel()
	}
	else
	{
		$("#PhrasesContainer").RemoveAndDeleteChildren();
		for ( var i = 0; i < 8; i++ )
		{
			if (rings[newnum][1][i])
			{
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
				$("#Phrase"+i).BLoadLayoutSnippet("Phrase");
				$("#Phrase"+i).GetChild(0).GetChild(0).visible = rings[newnum][1][i];
				$("#Phrase"+i).GetChild(0).GetChild(1).text = $.Localize(rings[newnum][0][i]);
			}
		}
		nowselect = newnum;
	}
}

function AddOnFavourites(num) {
	if (nowselect != 18)
	{
		favourites.unshift(rings[nowselect][2][num]);
		if (favourites.length > 8)
			favourites[8] = null;
		favourites = favourites.filter(function (el) {
			return el != null;
		});
		Game.EmitSound( "ui.crafting_gem_create" )
		UpdateFavourites();
	}
	else
	{
		favourites[num] = null;
		favourites = favourites.filter(function (el) {
			return el != null;
		});
		UpdateFavourites();
		nowselect = 0;
		OnSelect(2);
	}

	GameEvents.SendCustomGameEventToServer("patreon_update_chat_wheel_favorites", { favorites: favourites });
}

function UpdateFavourites() {
	var msg = new Array();
	var numsb = new Array();
	var numsi = new Array();
	for ( var i = 0; i < 8; i++ )
	{
		if (favourites[i])
		{
			msg[i] = FindLabelByNum(favourites[i]);
			numsi[i] = favourites[i];
			numsb[i] = true;
		}
		else
		{
			msg[i] = "";
			numsi[i] = 0;
			numsb[i] = false;
		}
	}
	rings[18] = new Array(msg,numsb,numsi);
}

function FindLabelByNum(num) {
	for (var key in rings) {
		var element = rings[key];
		for ( var i = 0; i < 8; i++ )
		{
			if (element[1][i] == true && element[2][i] == num)
			{
				return element[0][i];
			}
		}
	}
}

function OnMouseOver(num) {
	//$.Msg(num);
	$( "#WheelPointer" ).RemoveClass( "Hidden" );
	$( "#Arrow" ).RemoveClass( "Hidden" );
	for ( var i = 0; i < 8; i++ )
	{
		if ($("#Wheel").BHasClass("ForWheel"+i))
			$( "#Wheel" ).RemoveClass( "ForWheel"+i );
	}
	$( "#Wheel" ).AddClass( "ForWheel"+num );
	$("#WHTooltip").visible = rings[nowselect][1][num];
	$("#WHTooltip").SetDialogVariableInt( "num", rings[nowselect][2][num]);
}

function OnMouseOut(num) {
	//$.Msg(num);
	$( "#WheelPointer" ).AddClass( "Hidden" );
	$( "#Arrow" ).AddClass( "Hidden" );
	$("#WHTooltip").visible = false;
}

(function() {
	GameUI.CustomUIConfig().chatWheelLoaded = true;
/*
	SubscribeToNetTableKey('game_state', 'patreon_bonuses', function(patreonBonuses) {
		var localStats = patreonBonuses[Game.GetLocalPlayerID()];
		if (!localStats) return;

		favourites = Object.values(localStats.chatWheelFavorites || {});
		UpdateFavourites();
	});
*/
	//var hero = Players.GetPlayerSelectedHero(Game.GetLocalPlayerID());
	//$("#HeroImage").heroname = hero;
	for ( var i = 0; i < 8; i++ )
	{
//		$.Msg(phrase_color[i])
		$.CreatePanelWithProperties(`Button`, $("#PhrasesContainer"), `Phrase${i}`, {
			class: `MyPhrases`,
			onmouseactivate: `OnSelect(${i})`,
			onmouseover: `OnMouseOver(${i})`,
			onmouseout: `OnMouseOut(${i})`,
		});

		$("#Phrase"+i).BLoadLayoutSnippet("Phrase");
		$("#Phrase"+i).GetChild(0).GetChild(0).visible = rings[0][1][i];
		$("#Phrase"+i).GetChild(0).GetChild(1).text = $.Localize(rings[0][0][i]);
		$("#Phrase"+i).GetChild(0).GetChild(1).style.color = phrase_color[i];
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
})();
