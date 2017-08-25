"use strict";

function UpdateNetGraph()
{
	var units = CustomNetTables.GetTableValue("netgraph", "unit_number");
	var dummies = CustomNetTables.GetTableValue("netgraph", "dummy_number");
//	var wisps = CustomNetTables.GetTableValue("netgraph", "wisp_number");

//	$.Msg(units)
//	$.Msg(dummies)

	$("#Units").text = units.value;
//	$("#Dummies").text = dummies.value;
//	$("#Wisps").text = wisps.value;
}

function ShowNetgraph()
{
	$.Msg("Showing up NetGraph for developer!")

	$("#UnitPanel").style.visibility = "visible";
	$("#DummyPanel").style.visibility = "visible";
}

(function()
{
	CustomNetTables.SubscribeNetTableListener("netgraph", UpdateNetGraph);
	GameEvents.Subscribe("show_netgraph", ShowNetgraph);
})();
