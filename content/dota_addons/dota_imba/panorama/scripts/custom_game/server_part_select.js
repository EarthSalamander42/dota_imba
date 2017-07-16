


function GetHUDRootUI_Server()
{
    var rootUI = $.GetContextPanel();
    while(rootUI.id != "Hud" && rootUI.GetParent() != null){
        rootUI = rootUI.GetParent();
    }
    return rootUI;
}

function GetUI_Server()
{
	return GetHUDRootUI_Server().FindChildTraverse("CustomUIRoot");
}


var PartSelectPage= null;

function Server_Show_Select_Page()
{
	if(!PartSelectPage)
	{
		var parentPanel = GetUI_Server(); // the root panel of the current XML context
		PartSelectPage = $.CreatePanel( "Panel", parentPanel, "ChildPanelID" );
		PartSelectPage.BLoadLayout( "file://{resources}/layout/custom_game/server_select_page.xml", false, false );
	}
	else
	{
		if( PartSelectPage.invisible )
		{
			$.Msg("unhide ");
			PartSelectPage.invisible=false;
			PartSelectPage.SetHasClass("Hidden", false);
		}
		else
		{
			$.Msg("to hide");
			PartSelectPage.invisible=true;
			PartSelectPage.SetHasClass("Hidden", true);
		}
	}
}


function Server_Part_Select_Show_Tooltip()
{
    $.DispatchEvent("DOTAShowTextTooltip",$("#select_button"), ":DDDD");
}

function Server_Part_Select_Hide_Tooltip()
{
    $.DispatchEvent( "DOTAHideTextTooltip",$("#select_button") );
}
