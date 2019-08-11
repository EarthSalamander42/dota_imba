"use strict";

CustomNetTables.SubscribeNetTableListener( "artifact_currency", UpdateArtifactCurrencyBalance )
CustomNetTables.SubscribeNetTableListener( "relics", UpdateRelicInventory )


function UpdateRelicInventory()
{
	var RelicsContainer = $("#RelicsContainer" );
	var RelicsViolater = $("#RelicCountViolator" );
	var RelicsCourier = $( "#RelicCourier" );
	
	
	var RelicData = CustomNetTables.GetTableValue( "relics", Players.GetLocalPlayer().toString() );
	
	if ( typeof( RelicData != "undefined" ) )
	{
		for ( var i in RelicData )	
		{	
			var Relic = RelicData[i];
			if ( Relic === null )
				continue;

			var RelicName = Relic["RelicName"]
			if ( RelicName === null )
				continue;

			var RelicCost = Relic["DungeonCurrencyCost"];
			if ( RelicCost === null )
				continue;

			var bPurchased = Relic["Purchased"];
			var RelicPanel = RelicsContainer.FindChild( RelicName );
			if ( RelicPanel !== null )
			{
				if ( bPurchased === 1 )
				{
					RelicPanel.DeleteAsync( 0.0 );
				}
				
				continue;
			}

			if ( bPurchased === 1 )
				continue;
			
		//	$.Msg( "Creating new relic panel: " + RelicName );
			var newRelic = $.CreatePanel( "Panel", RelicsContainer, RelicName );
			newRelic.BLoadLayout( "file://{resources}/layout/custom_game/siltbreaker/relic_item.xml", false, false );
			newRelic.FindChildInLayoutFile( "ItemImage" ).itemname = RelicName;
			newRelic.SetHasClass( "RelicIcon", true );
			newRelic.SetDraggable( true );
			var newRelicCoinCost = newRelic.FindChildInLayoutFile( "ArtifactCoinCost" );
			newRelicCoinCost.text = RelicCost;
		}

		var nRelicCount = RelicsContainer.GetChildCount();
		RelicsViolater.text = nRelicCount;
		
		$.Msg( "count: " + nRelicCount );
		if ( nRelicCount < 1 )
		{
			RelicsCourier.SetHasClass( "NoItems" , true );
			RelicsCourier.RemoveClass( "Expanded" ); 
		}			
	}
	
	
}

function OnRelicButtonClicked()
{
	var RelicsContainer = $( "#RelicsContainer" );
	var RelicsCourier = $( "#RelicCourier" );
	var nRelicCount = RelicsContainer.GetChildCount();

	UpdateRelicInventory();
	
	if ( nRelicCount > 0 )
	{
		RelicsCourier.ToggleClass( "Expanded" );
	}
}


function UpdateArtifactCurrencyBalance()
{
	var CurrencyData = CustomNetTables.GetTableValue( "artifact_currency", Players.GetLocalPlayer().toString() );
	if ( typeof( CurrencyData != "undefined" ) )
	{
		var CurrencyCounter = $("#ArtifactCurrency" );
		CurrencyCounter.text = CurrencyData["Balance"];
		var RelicsContainer = $( "#RelicsContainer" );
		var RelicsCourier = $( "#RelicCourier" );
		var nRelicCount = RelicsContainer.GetChildCount();
		for(var i = 0; i < nRelicCount; i++ )
		{
			var Relic = RelicsContainer.GetChild( i );
			if ( Relic === null )
				continue; 

			var RelicCoinCost = Relic.FindChildInLayoutFile( "ArtifactCoinCost" );
			if ( RelicCoinCost === null )
				continue;

			Relic.SetHasClass( "CanAffordArtifact", CurrencyData["Balance"] >= parseInt( RelicCoinCost.text ) );
		}
	}
}
