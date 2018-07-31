var mutation = [];

function Mutation(args) {
	mutation[0] = "imba"
	mutation[1] = args["positive"]
	mutation[2] = args["negative"]
	mutation[3] = args["terrain"]

	$("#Mutations").style.visibility = "visible";

	for (var j = 0; j <= 3; j++) {
		SetMutationTooltip(j)
	}
}

function SetMutationTooltip(j) {
	var panel = $("#Mutation" + j)

	$("#Mutation" + j + "Label").text = $.Localize("mutation_" + mutation[j]);

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
