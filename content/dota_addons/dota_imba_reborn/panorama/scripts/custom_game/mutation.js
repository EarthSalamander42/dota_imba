function OnItemWillSpawn( msg )
{
//	$.Msg( "OnItemWillSpawn: ", msg );
	$.GetContextPanel().SetHasClass( "item_will_spawn", true );
	$.GetContextPanel().SetHasClass( "item_has_spawned", false );
	GameUI.PingMinimapAtLocation( msg.spawn_location );

//	$( "#AlertMessage_Chest" ).html = true;
//	$( "#AlertMessage_Delivery" ).html = true;
//	$( "#AlertMessage_Chest" ).text = $.Localize( "#Chest" );
//	$( "#AlertMessage_Delivery" ).text = $.Localize( "#ItemWillSpawn" );

	$.Schedule( 3, ClearItemSpawnMessage );
}

function ClearItemSpawnMessage()
{
	$.GetContextPanel().SetHasClass( "item_will_spawn", false );
	$.GetContextPanel().SetHasClass( "item_has_spawned", false );

//	$( "#AlertMessage" ).text = "";
}

var mutation = []

function OnMutationUpdated()
{
	var mutations = CustomNetTables.GetTableValue("mutations", "mutation")["1"]
	mutation[0] = mutations["imba"]
	mutation[1] = mutations["positive"]
	mutation[2] = mutations["negative"]
	mutation[3] = mutations["terrain"]

	var mutation_info = {}

	for (var j = 0; j <= 3; j++) {
		mutation_info[j] = CustomNetTables.GetTableValue("mutation_info", mutation[j])
		if (mutation_info[j] != undefined) {
//			if (mutation[j] == "periodic_spellcast")
//				PeriodicSpellcast(mutation_info[j], $("#Mutation2Label"))
			if (mutation[j] == "airdrop" || mutation[j] == "danger_zone") {
				MutationTimer(mutation_info[j], $("#Mutation3Label"))
				break; // Don't need to setup anything after this, better end the script
			}
			if (mutation_info[j]["2"]) {
				if (mutation_info[j]["2"] == "%")
					$("#Mutation" + j + "Label").text = $.Localize("mutation_" + mutation[j]) + ": " + mutation_info[j]["1"].toFixed(0) + "%";
				else if (mutation_info[j]["2"] == "s")
					$("#Mutation" + j + "Label").text = $.Localize("mutation_" + mutation[j]) + ": " + mutation_info[j]["1"].toFixed(0) + " seconds";
				else
					$("#Mutation" + j + "Label").text = $.Localize("mutation_" + mutation[j]) + ": " + mutation_info[j]["1"].toFixed(0) + " / " + mutation_info[j]["2"].toFixed(0);
			}
			else if (mutation_info[j]["1"] && !mutation_info[j]["2"]) {
				if (mutation_info[j]["1"])
					$("#Mutation" + j + "Label").text = $.Localize("mutation_" + mutation[j]) + ": " + mutation_info[j]["1"].toFixed(0);
			}
		}
	}

//	$.Msg(mutations);
//	$.Msg(mutation_info);
}

function PeriodicSpellcast(data, panel) {
	var spellcast_text = "Negative";

	$.Msg(data["1"])

	if (data["1"] == "1")
		spellcast_text = "Positive";

	$.Msg(spellcast_text)

	panel.text = $.Localize("mutation_" + mutation[2]) + ": " + spellcast_text;
}

var alert = 0
function TimerAlert(data) {
	alert = data["1"]
}

function MutationTimer(data, panel)
{
	var timerText = "";
	timerText += data.timer_minute_10;
	timerText += data.timer_minute_01;
	timerText += ":";
	timerText += data.timer_second_10;
	timerText += data.timer_second_01;

	panel.text = $.Localize("mutation_" + mutation[3]) + ": " + timerText;

	if (alert == 1) {
		if (!panel.BHasClass("alert"))
			panel.AddClass("alert")
	} else {
		if (panel.BHasClass("alert"))
			panel.RemoveClass("alert")
	}
}

(function () {
	GameEvents.Subscribe("update_mutations", OnMutationUpdated);
	GameEvents.Subscribe("timer_alert", TimerAlert);
	GameEvents.Subscribe("item_will_spawn", OnItemWillSpawn);
})();
