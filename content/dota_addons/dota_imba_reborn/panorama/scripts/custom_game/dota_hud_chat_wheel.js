var heronames = new Array(
	new Array("Abaddon","Alchemist","Ancient Apparition","Anti-Mage","Arc Warden","Axe","Bane","Batrider"),
	new Array("Beastmaster","Bloodseeker","Bounty Hunter","Brewmaster","Bristleback","Broodmother","Centaur Warrunner","Chaos Knight"),
	new Array("Chen","Clinkz","Clockwerk","Crystal Maiden","Dark Seer","Dark Willow","Dazzle","Death Prophet"),
	new Array("Disruptor","Doom","Dragon Knight","Drow Ranger","Earth Spirit","Earthshaker","Elder Titan","Ember Spirit"),
	new Array("Enchantress","Enigma","Faceless Void","Grimstroke","Gyrocopter","Huskar","Invoker","Io"),
	new Array("Jakiro","Juggernaut","Keeper of the Light","Kunkka","Legion Commander","Leshrac","Lich","Lifestealer"),
	new Array("Lina","Lion","Lone Druid","Luna","Lycan","Magnus","Mars","Medusa"),
	new Array("Meepo","Mirana","Monkey King","Morphling","Naga Siren","Nature's Prophet","Necrophos","Night Stalker"),
	new Array("Nyx Assassin","Ogre Magi","Omniknight","Oracle","Outworld Devourer","Pangolier","Phantom Assassin","Phantom Lancer"),
	new Array("Phoenix","Puck","Pudge","Pugna","Queen of Pain","Razor","Riki","Rubick"),
	new Array("Sand King","Shadow Demon","Shadow Fiend","Shadow Shaman","Silencer","Skywrath Mage","Slardar","Slark"),
	new Array("Sniper","Spectre","Spirit Breaker","Storm Spirit","Sven","Techies","Templar Assassin","Terrorblade"),
	new Array("Tidehunter","Timbersaw","Tinker","Tiny","Treant Protector","Troll Warlord","Tusk","Underlord"),
	new Array("Undying","Ursa","Vengeful Spirit","Venomancer","Viper","Visage","Warlock","Weaver"),
	new Array("Windranger","Winter Wyvern ","Witch Doctor","Wraith King","Zeus","","","")
);
var heronames2 = new Array(
	"abaddon",
	"alchemist",
	"ancient_apparition",
	"antimage",
	"arc_warden",
	"axe",
	"bane",
	"batrider",
	"beastmaster",
	"bloodseeker",
	"bounty_hunter",
	"brewmaster",
	"bristleback",
	"broodmother",
	"centaur",
	"chaos_knight",
	"chen",
	"clinkz",
	"rattletrap",
	"crystal_maiden",
	"dark_seer",
	"dark_willow",
	"dazzle",
	"death_prophet",
	"disruptor",
	"doom_bringer",
	"dragon_knight",
	"drow_ranger",
	"earth_spirit",
	"earthshaker",
	"elder_titan",
	"ember_spirit",
	"enchantress",
	"enigma",
	"faceless_void",
	"grimstroke",
	"gyrocopter",
	"huskar",
	"invoker",
	"wisp",
	"jakiro",
	"juggernaut",
	"keeper_of_the_light",
	"kunkka",
	"legion_commander",
	"leshrac",
	"lich",
	"life_stealer",
	"lina",
	"lion",
	"lone_druid",
	"luna",
	"lycan",
	"magnataur",
	"mars",
	"medusa",
	"meepo",
	"mirana",
	"monkey_king",
	"morphling",
	"naga_siren",
	"furion",
	"necrolyte",
	"night_stalker",
	"nyx_assassin",
	"ogre_magi",
	"omniknight",
	"oracle",
	"obsidian_destroyer",
	"pangolier",
	"phantom_assassin",
	"phantom_lancer",
	"phoenix",
	"puck",
	"pudge",
	"pugna",
	"queenofpain",
	"razor",
	"riki",
	"rubick",
	"sand_king",
	"shadow_demon",
	"nevermore",
	"shadow_shaman",
	"silencer",
	"skywrath_mage",
	"slardar",
	"slark",
	"sniper",
	"spectre",
	"spirit_breaker",
	"storm_spirit",
	"sven",
	"techies",
	"templar_assassin",
	"terrorblade",
	"tidehunter",
	"shredder",
	"tinker",
	"tiny",
	"treant",
	"troll_warlord",
	"tusk",
	"abyssal_underlord",
	"undying",
	"ursa",
	"vengefulspirit",
	"venomancer" ,
	"viper",
	"visage",
	"warlock",
	"weaver",
	"windrunner",
	"winter_wyvern",
	"witch_doctor",
	"skeleton_king",
	"zuus"
);
var mesarrs = new Array(
	"_laugh",
	"_thank",
	"_deny",
	"_1",
	"_2",
	"_3",
	"_4",
	"_5"
 );
var favourites = new Array();
var herostartnum = 110;
var nowrings = 18;
var herostartrings = nowrings + heronames.length + 1;
var rings = new Array(
	new Array(//0 start
		new Array("#"+Players.GetPlayerSelectedHero(Game.GetLocalPlayerID()),"#announcers","#favourites","#heroes","#misc","#battlepass2019","#dotaplus2","#dotaplus"),
		new Array(false,false,false,false,false,false,false,false),
		new Array(1,13,18,4,11,14,7,8)
	),
	new Array(//1 hero
		new Array("#dota_chatwheel_label_"+Players.GetPlayerSelectedHero(Game.GetLocalPlayerID()).substring(14)+"_laugh","#dota_chatwheel_label_"+Players.GetPlayerSelectedHero(Game.GetLocalPlayerID()).substring(14)+"_thank","#dota_chatwheel_label_"+Players.GetPlayerSelectedHero(Game.GetLocalPlayerID()).substring(14)+"_deny","#dota_chatwheel_label_"+Players.GetPlayerSelectedHero(Game.GetLocalPlayerID()).substring(14)+"_1","#dota_chatwheel_label_"+Players.GetPlayerSelectedHero(Game.GetLocalPlayerID()).substring(14)+"_2","#dota_chatwheel_label_"+Players.GetPlayerSelectedHero(Game.GetLocalPlayerID()).substring(14)+"_3","#dota_chatwheel_label_"+Players.GetPlayerSelectedHero(Game.GetLocalPlayerID()).substring(14)+"_4","#dota_chatwheel_label_"+Players.GetPlayerSelectedHero(Game.GetLocalPlayerID()).substring(14)+"_5"),
		new Array(true,true,true,true,true,true,true,true),
		new Array(herostartnum-8,herostartnum-7,herostartnum-6,herostartnum-5,herostartnum-4,herostartnum-3,herostartnum-2,herostartnum-1)
	),
	new Array(//2 chineseannouncer
		new Array("#chineseannouncer2","#duiyou_ne","#wan_bu_liao_la","#po_liang_lu","#tian_huo","#jia_you","#zou_hao_bu_song","#liu_liu_liu"),
		new Array(false,true,true,true,true,true,true,true),
		new Array(9,40,41,42,43,44,45,46)
	),
	new Array(//3 russianannouncer
		new Array("#russianannouncer2","#bozhe_ti_posmotri","#zhil_do_konsta","#ay_ay_ay","#ehto_g_g","#eto_prosto_netchto","#krasavchik","#bozhe_kak_eto_bolno"),
		new Array(false,true,true,true,true,true,true,true),
		new Array(10,55,56,57,58,59,60,61)
	),
	new Array(//4 more1
		new Array("#heros_a-b","#heros_b-c","#heros_c-d","#more","#heros_d-e","#heros_e-i","#heros_j-l","#heros_l-m"),
		new Array(false,false,false,false,false,false,false,false),
		new Array(nowrings+1,nowrings+2,nowrings+3,12,nowrings+4,nowrings+5,nowrings+6,nowrings+7)
	),
	new Array(//5 englishannouncer2
		new Array("#that_was_questionable","#playing_to_win","#what_just_happened","#looking_spicy","#no_chill","#ding_ding_ding","#absolutely_perfect","#lets_play"),
		new Array(true,true,true,true,true,true,true,true),
		new Array(32,33,34,35,36,37,38,39)
	),
	new Array(//6 englishannouncer
		new Array("#englishannouncer2","#patience","#wow","#all_dead","#brutal","#disastah","#oh_my_lord","#youre_a_hero"),
		new Array(false,true,true,true,true,true,true,true),
		new Array(5,25,26,27,28,29,30,31)
	),
	new Array(//7 dotaplus2
		new Array("#dota_chatwheel_label_Headshake","#dota_chatwheel_label_Kiss","#dota_chatwheel_label_Ow","#dota_chatwheel_label_Snore","#dota_chatwheel_label_Bockbock","#dota_chatwheel_label_Crybaby","#dota_chatwheel_label_Sad_Trombone","#dota_chatwheel_label_Yahoo"),
		new Array(true,true,true,true,true,true,true,true),
		new Array(9,10,11,12,13,14,15,16)
	),
	new Array(//8 dotaplus
		new Array("#dota_chatwheel_label_Applause","#dota_chatwheel_label_Crash_and_Burn","#dota_chatwheel_label_Crickets","#dota_chatwheel_label_Party_Horn","#dota_chatwheel_label_Rimshot","#dota_chatwheel_label_Charge","#dota_chatwheel_label_Drum_Roll","#dota_chatwheel_label_Frog"),
		new Array(true,true,true,true,true,true,true,true),
		new Array(1,2,3,4,5,6,7,8)
	),
	new Array(//9 chineseannouncer2
		new Array("#hu_lu_wa","#ni_qi_bu_qi","#gao_fu_shuai","#gan_ma_ne_xiong_di","#bai_tuo_shei_qu","#piao_liang","#lian_dou_xiu_wai_la","#zai_jian_le_bao_bei"),
		new Array(true,true,true,true,true,true,true,true),
		new Array(47,48,49,50,51,52,53,54)
	),
	new Array(//10 russianannouncer2
		new Array("#oy_oy_bezhat","#eto_nenormalno","#eto_sochno","#kreasa_kreasa","#kak_boyge_te_byechenya","#eto_ge_popayx_feeda","#da_da_da_nyet","#wot_eto_bru"),
		new Array(true,true,true,true,true,true,true,true),
		new Array(62,63,64,65,66,67,68,69)
	),
	new Array(//11 misc
		new Array("#dota_chatwheel_message_Celebratory_Gong","#dota_chatwheel_message_Sleighbells","#dota_chatwheel_message_Oink_Oink","#dota_chatwheel_message_Greevil_Laughter","#dota_chatwheel_message_Frostivus_Magic","#dota_chatwheel_message_Ceremonial_Drums","",""),//new Array("#","#dota_chatwheel_message_Sleighbells","#dota_chatwheel_message_Sparkling_Celebration","#dota_chatwheel_message_Greevil_Laughter","#dota_chatwheel_message_Frostivus_Magic","#dota_chatwheel_message_Ceremonial_Drums","#dota_chatwheel_message_Oink_Oink","#dota_chatwheel_message_Celebratory_Gong"),
		new Array(true,true,true,true,true,true,false,false),
		new Array(24,18,23,20,21,22,0,0)//new Array(17,18,19,20,21,22,23,24)
	),
	new Array(//12 more2
		new Array("#heros_m-n","#heros_n-p","#heros_p-r","#heros_s-s","#heros_s-t","#heros_t-u","#heros_u-w","#heros_w-z"),
		new Array(false,false,false,false,false,false,false,false),
		new Array(nowrings+8,nowrings+9,nowrings+10,nowrings+11,nowrings+12,nowrings+13,nowrings+14,nowrings+15)
	),
	new Array(//13 announcers
		new Array("#englishannouncer","#chineseannouncer","#russianannouncer","","","","#epiccaster","#koreancaster"),
		new Array(false,false,false,false,false,false,false,false),
		new Array(6,2,3,0,0,0,15,17)
	),
	new Array(//14 battlepass2019
		new Array("#kooka_laugh","#monkey_biz","#orangutan_kiss","#skeeter","#crowd_groan","#head_bonk","#record_scratch","#ta_da"),
		new Array(true,true,true,true,true,true,true,true),
		new Array(70,71,72,73,74,75,76,77)
	),
	new Array(//15 epiccaster
		new Array("#epiccaster2","#easiest_money","#echo_slama_jama","#next_level","#oy_oy_oy","#ta_daaaa","#ceeb","#goodness_gracious"),
		new Array(false,true,true,true,true,true,true,true),
		new Array(16,78,79,80,81,82,83,84)
	),
	new Array(//16 epiccaster2
		new Array("#nakupuuu","#whats_cooking","#eughahaha","#glados_chat_21","#glados_chat_01","#glados_chat_07","#glados_chat_04",""),
		new Array(true,true,true,true,true,true,true,false),
		new Array(85,86,87,88,89,90,91,92)
	),
	new Array(//17 koreancaster
		new Array("#kor_yes_no","#kor_scan","#kor_immortality","#kor_roshan","#kor_yolo","#kor_million_dollar_house","",""),
		new Array(true,true,true,true,true,true,false,false),
		new Array(93,94,95,96,97,98,99,100)
	),
	new Array(//18 Favourites
		new Array("#whtooltipff","","","","","","",""),
		new Array(false,false,false,false,false,false,false,false),
		new Array(0,0,0,0,0,0,0,0)
	)
);
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
	GetDonatorColor(1), // Misc (Donator)
	GetDonatorColor(6), // Battlepass 2019 (not working)
	GetDonatorColor(4), // Dota Plus 2 (Salamander Donator)
	GetDonatorColor(2), // Dota Plus 2 (Golden Donator)
]

function StartWheel() {
	if ($("#Wheel").visible == false) {
		$.Msg("Open Chat Wheel!")
		$.Msg($("#Wheel").visible)
		$("#Wheel").visible = true;
		$("#Bubble").visible = true;
		$("#PhrasesContainer").visible = true;
	} else if ($("#Wheel").visible == true) {
		StopWheel()
	}
}

function StopWheel() {
	$("#Wheel").visible = false;

	$.Msg("Close Chat Wheel!")
	$("#Wheel").visible = false;
	$("#Bubble").visible = false;
	$("#PhrasesContainer").visible = false;
	$("#WHTooltip").visible = false;
	if (nowselect != 0)
	{
		$("#PhrasesContainer").RemoveAndDeleteChildren();
		for ( var i = 0; i < 8; i++ )
		{
			$("#PhrasesContainer").BCreateChildren("<Button id='Phrase"+i+"' class='MyPhrases' onmouseactivate='OnSelect("+i+")' onmouseover='OnMouseOver("+i+")' onmouseout='OnMouseOut("+i+")' />");//class='Phrase HasSound RequiresHeroBadgeTier BronzeTier'
			$("#Phrase"+i).BLoadLayoutSnippet("Phrase");
			$("#Phrase"+i).GetChild(0).GetChild(0).visible = rings[0][1][i];
			$("#Phrase"+i).GetChild(0).GetChild(1).text = $.Localize(rings[0][0][i]);
			$("#Phrase"+i).GetChild(0).GetChild(1).style.color = phrase_color[i];
		}
		nowselect = 0;
	}
}

function OnSelect(num) {
	$.Msg(num)
	var newnum = rings[nowselect][2][num];
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
			var dopstr = "";
			if (rings[newnum][1][i])
			{
				dopstr = " oncontextmenu='AddOnFavourites("+i+")'"
			}
			$("#PhrasesContainer").BCreateChildren("<Button id='Phrase"+i+"' class='MyPhrases' onmouseactivate='OnSelect("+i+")' onmouseover='OnMouseOver("+i+")' onmouseout='OnMouseOut("+i+")'"+dopstr+" />");//class='Phrase HasSound RequiresHeroBadgeTier BronzeTier'
			$("#Phrase"+i).BLoadLayoutSnippet("Phrase");
			$("#Phrase"+i).GetChild(0).GetChild(0).visible = rings[newnum][1][i];
			$("#Phrase"+i).GetChild(0).GetChild(1).text = $.Localize(rings[newnum][0][i]);
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

	SubscribeToNetTableKey('game_state', 'patreon_bonuses', function(patreonBonuses) {
		var localStats = patreonBonuses[Game.GetLocalPlayerID()];
		if (!localStats) return;

		favourites = Object.values(localStats.chatWheelFavorites || {});
		UpdateFavourites();
	});

	//var hero = Players.GetPlayerSelectedHero(Game.GetLocalPlayerID());
	//$("#HeroImage").heroname = hero;
	for ( var i = 0; i < 8; i++ )
	{
		$.Msg(phrase_color[i])
		$("#PhrasesContainer").BCreateChildren("<Button id='Phrase"+i+"' class='MyPhrases' onmouseactivate='OnSelect("+i+")' onmouseover='OnMouseOver("+i+")' onmouseout='OnMouseOut("+i+")' />");//class='Phrase HasSound RequiresHeroBadgeTier BronzeTier'
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
