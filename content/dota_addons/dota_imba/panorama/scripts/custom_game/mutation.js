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
})();
