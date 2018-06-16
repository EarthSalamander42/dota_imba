var mutation = [];

function Mutation(args) {
	$("#Mutations").style.visibility = "visible";

//	$.Msg("Mutation JS:")
//	$.Msg(args["positive"])
//	$.Msg(args["negative"])
//	$.Msg(args["terrain"])

	mutation[1] = args["positive"]
	mutation[2] = args["negative"]
	mutation[3] = args["terrain"]

	$("#Mutation1Label").text = $.Localize("mutation_" + mutation[1]);
	$("#Mutation2Label").text = $.Localize("mutation_" + mutation[2]);
	$("#Mutation3Label").text = $.Localize("mutation_" + mutation[3]);

	for (var j = 1; j <= 3; j++) {
		SetMutationTooltip(j)
	}
}

function SetMutationTooltip(j) {
	var panel = $("#Mutation" + j)

	panel.SetPanelEvent("onmouseover", function () {
		$.DispatchEvent("UIShowTextTooltip", panel, $.Localize("mutation_" + mutation[j] + "_Description"));
	})

	panel.SetPanelEvent("onmouseout", function () {
		$.DispatchEvent("UIHideTextTooltip", panel);
	})
}

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

(function () {
	GameEvents.Subscribe("item_will_spawn", OnItemWillSpawn);
	GameEvents.Subscribe("send_mutations", Mutation);
})();
