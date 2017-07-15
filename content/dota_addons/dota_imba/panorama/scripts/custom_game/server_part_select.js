

function ShowPartPage()
{
	
	ShowTooltip()
}

function ShowTooltip()
{
    $.DispatchEvent("DOTAShowTitleTextTooltip",$("#part_select_button"), "this is title", "this is msg");
}

function HideTooltip()
{
    $.DispatchEvent( "DOTAHideTitleTextTooltip",$("#part_select_button") );
}

