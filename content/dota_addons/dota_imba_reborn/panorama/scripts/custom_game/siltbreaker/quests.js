"use strict";

function OnQuestActivated( data )
{
	$.Msg( "OnQuestActivated" );

	var QuestsContainerPanel = $( "#QuestsContainer" );
	if ( QuestsContainerPanel === null ) 
		return;

	var szZoneName = data["ZoneName"];
	var szQuestName = data["QuestName"];
	var szQuestType = data["QuestType"];
	if ( szZoneName === null || szQuestName === null )
		return;

	var ZonePanel = QuestsContainerPanel.FindChild( szZoneName );
	if ( ZonePanel === null )
	{
		ZonePanel = $.CreatePanel( "Panel", QuestsContainerPanel, szZoneName );
		ZonePanel.BLoadLayout( "file://{resources}/layout/custom_game/siltbreaker/quest_zone.xml", false, false );
		ZonePanel.FindChildInLayoutFile( "ZoneName" ).text = $.Localize( szZoneName );
	}

	var ZoneQuestsContainer = ZonePanel.FindChildInLayoutFile( "ZoneQuestsContainer" );
	if ( ZoneQuestsContainer === null )
		return;

	var QuestPanel = ZoneQuestsContainer.FindChild( szQuestName );
	if ( QuestPanel === null )
	{
		QuestPanel = $.CreatePanel( "Panel", ZoneQuestsContainer, szQuestName );
		QuestPanel.BLoadLayout( "file://{resources}/layout/custom_game/siltbreaker/quest.xml", false, false );
		QuestPanel.FindChildInLayoutFile( "QuestIcon" ).SetHasClass( szQuestType, true );
		QuestPanel.FindChildInLayoutFile( "QuestText" ).text =  $.Localize( szQuestName );

		QuestPanel.SetDialogVariableInt( "completed", data["Completed"] );
		QuestPanel.SetDialogVariableInt( "complete_limit", data["CompleteLimit"] );
		QuestPanel.SetHasClass( "ShowNumbers", data["CompleteLimit"] !== 1 );
		QuestPanel.SetHasClass( "Completed", false );
		QuestPanel.SetHasClass( "Optional", data["Optional"] );
	}

	ZonePanel.SetHasClass( "Completed", false );
}


GameEvents.Subscribe( "quest_activated", OnQuestActivated );


function HideQuestCompletePopup( )
{
	var DungeonQuestCompleteRoot = $( "#DungeonQuestCompleteRoot" );
	if(DungeonQuestCompleteRoot == null)
	{
		$.Msg( "Can't find quest complete root");
		return;
	}

	DungeonQuestCompleteRoot.SetHasClass( $("#DungeonQuestCompleteZoneName").text, false );
	DungeonQuestCompleteRoot.SetHasClass( "Stars1", false );
	DungeonQuestCompleteRoot.SetHasClass( "Stars2", false );
	DungeonQuestCompleteRoot.SetHasClass( "Stars3", false );

	DungeonQuestCompleteRoot.SetHasClass("PopupDisplayed", false);
	DungeonQuestCompleteRoot.SetHasClass("PopupDismissed", true);
}

function ShowQuestCompletePopup( data )
{
	$.Msg( "ShowQuestCompletePopup");

	var DungeonQuestCompleteRoot = $( "#DungeonQuestCompleteRoot" );
	if(DungeonQuestCompleteRoot == null)
	{
		$.Msg( "Can't find quest complete root");
		return;
	}

	if ( data["ZoneCompleted"] )
	{
		DungeonQuestCompleteRoot.SetHasClass( data["ZoneName"], true );
		DungeonQuestCompleteRoot.SetHasClass( "Stars" + data["ZoneStars"].toString(), true );
	}

	DungeonQuestCompleteRoot.SetDialogVariableInt( "completed", data["Completed"] );
	DungeonQuestCompleteRoot.SetDialogVariableInt( "complete_limit", data["CompleteLimit"] );
	DungeonQuestCompleteRoot.SetHasClass( "ShowNumbers", data["CompleteLimit"] !== 1 );
	DungeonQuestCompleteRoot.SetHasClass( "Completed", data["Completed"] >= data["CompleteLimit"] );

	DungeonQuestCompleteRoot.SetDialogVariableInt( "xp_reward", data["XPReward"] );
	DungeonQuestCompleteRoot.SetHasClass( "XPReward", data["XPReward"] > 0 );
	DungeonQuestCompleteRoot.SetDialogVariableInt( "gold_reward", data["GoldReward"] );
	DungeonQuestCompleteRoot.SetHasClass( "GoldReward", data["GoldReward"] > 0 );

	if( !(data["ZoneName"] === null) )
	{
		DungeonQuestCompleteRoot.SetDialogVariable( "zone_name", $.Localize( data["ZoneName"] ) );
	}
	else
	{
		DungeonQuestCompleteRoot.SetDialogVariable( "zone_name", "" );
	}

	if( !(data["QuestName"] === null) )
	{
		DungeonQuestCompleteRoot.SetDialogVariable( "quest_name", $.Localize( data["QuestName"] ) );
	}
	else
	{
		DungeonQuestCompleteRoot.SetDialogVariable( "quest_name", "" );
	}
	DungeonQuestCompleteRoot.SetHasClass("PopupDisplayed", true);
	DungeonQuestCompleteRoot.SetHasClass("PopupDismissed", false);

	$.Schedule( 10.0, HideQuestCompletePopup );
}

function OnQuestCompleted( data )
{
	$.Msg( "OnQuestCompleted" );

	if ( data["Completed"] === data["CompleteLimit"] && ( data["Optional"] || data["ZoneCompleted"] ) )
	{
		if ( data["ZoneCompleted"] )
		{
			Game.EmitSound( "Dungeon.Stinger01" );
		}
		else
		{
			Game.EmitSound( "Dungeon.Stinger03" );
		}
		ShowQuestCompletePopup( data );
	}

	var QuestsContainerPanel = $( "#QuestsContainer" );
	if ( QuestsContainerPanel === null ) 
		return;

	var szZoneName = data["ZoneName"];
	var szQuestName = data["QuestName"];
	if ( szZoneName === null || szQuestName === null )
		return;

	var ZonePanel = QuestsContainerPanel.FindChild( szZoneName );
	if ( ZonePanel === null )
		return;

	var ZoneQuestsContainer = ZonePanel.FindChildInLayoutFile( "ZoneQuestsContainer" );
	if ( ZoneQuestsContainer === null )
		return;

	var QuestPanel = ZoneQuestsContainer.FindChild( szQuestName );
	if ( QuestPanel === null )
		return;

	QuestPanel.SetDialogVariableInt( "completed", data["Completed"] );
	QuestPanel.SetDialogVariableInt( "complete_limit", data["CompleteLimit"] );
	QuestPanel.SetHasClass( "ShowNumbers", data["CompleteLimit"] !== 1 );
	QuestPanel.SetHasClass( "Completed", data["Completed"] >= data["CompleteLimit"] );

	QuestPanel.SetDialogVariableInt( "xp_reward", data["XPReward"] );
	QuestPanel.SetHasClass( "XPReward", data["XPReward"] > 0 );
	QuestPanel.SetDialogVariableInt( "gold_reward", data["GoldReward"] );
	QuestPanel.SetHasClass( "GoldReward", data["GoldReward"] > 0 );

	var QuestsInZone = ZoneQuestsContainer.FindChildrenWithClassTraverse( "Quest" );
	var bAllComplete = true;
	var i = 0;
	for ( i = 0; i < QuestsInZone.length; i++ )
	{
		var Quest = QuestsInZone[i];
		if ( Quest !== null && Quest.BHasClass( "Completed" ) === false )
		{
			bAllComplete = false;
			break;
		}
	}

	//$.Msg( "Zone " + szZoneName + " is " + ( bAllComplete || data["ZoneCompleted"] ) );
	ZonePanel.SetHasClass( "Completed", bAllComplete || data["ZoneCompleted"] );
}


GameEvents.Subscribe( "quest_completed", OnQuestCompleted );

function OnPlayerEnteredZone( data )
{
	var QuestsContainerPanel = $( "#QuestsContainer" );
	if ( QuestsContainerPanel === null ) 
		return;

	var Zones = QuestsContainerPanel.FindChildrenWithClassTraverse( "Zone" );
	for( var i in Zones )
	{
		var Zone = Zones[i];
		if ( Zone === null )
			continue;

		var bAllHidden = true;
		var ZoneQuestsContainer = Zone.FindChildInLayoutFile( "ZoneQuestsContainer" );
		if ( ZoneQuestsContainer === null )
			continue; 

		var Quests = ZoneQuestsContainer.FindChildrenWithClassTraverse( "Quest" );
		for ( var j in Quests )
		{
			var Quest = Quests[j];
			if ( Quest === null )
				return;

			var bIsCurrentZone = Zone.id === data["ZoneName"];
			var bIsOptional = Quest.BHasClass( "Optional" );
			var bHideOutOfZone = !bIsCurrentZone && bIsOptional;
			Quest.SetHasClass( "HideOutOfZone", bHideOutOfZone );

			var bQuestCompleted = Quest.BHasClass( "Completed" );
			if ( !bHideOutOfZone || ( !bQuestCompleted && !bIsOptional ) )
			{
				bAllHidden = false;
			}
		}

		Zone.SetHasClass( "NotInZone", bAllHidden );
	}
}

GameEvents.Subscribe( "zone_enter", OnPlayerEnteredZone );

