"use strict";

function UpdateNetGraph()
{
	var good_units = CustomNetTables.GetTableValue("netgraph", "good_unit_number");
	var bad_units = CustomNetTables.GetTableValue("netgraph", "bad_unit_number");
	var total_units = CustomNetTables.GetTableValue("netgraph", "total_unit_number");
	var total_dummies = CustomNetTables.GetTableValue("netgraph", "total_dummy_number");
	var total_dummies_created = CustomNetTables.GetTableValue("netgraph", "total_dummy_created_number");
	var total_particles_created = CustomNetTables.GetTableValue("netgraph", "total_particle_created_number");

//	$.Msg("Goodguys Units: ", good_units)
//	$.Msg("Badguys Units: ", bad_units)
//	$.Msg("Total Units: ", total_units)
//	$.Msg("Dummy Units: ", total_dummies)
//	$.Msg("Total Dummy Units: ", total_dummies_created)

	if (good_units && bad_units && total_units && total_dummies && total_dummies_created && total_particles_created) {
		$("#GoodUnits").text = good_units.value;
		$("#BadUnits").text = bad_units.value;
		$("#TotalUnits").text = total_units.value;
		$("#TotalDummies").text = total_dummies.value;
		$("#TotalDummiesCreated").text = total_dummies_created.value;
		$("#TotalParticlesCreated").text = total_particles_created.value;
	}
}

function ShowNetgraph()
{
	$.Msg("Showing up NetGraph for developer!")

	$("#GoodUnitPanel").style.visibility = "visible";
	$("#BadUnitPanel").style.visibility = "visible";
	$("#TotalUnitPanel").style.visibility = "visible";
	$("#TotalDummyPanel").style.visibility = "visible";
	$("#TotalDummyCreatedPanel").style.visibility = "visible";
	$("#TotalParticlesCreatedPanel").style.visibility = "visible";
}

(function()
{
	CustomNetTables.SubscribeNetTableListener("netgraph", UpdateNetGraph);
	GameEvents.Subscribe("show_netgraph", ShowNetgraph);
})();
