"use strict";

function ShowNetgraph()
{
	$.Msg("Showing up NetGraph for developer!")

	$("#GlobalStats").style.visibility = "visible";
	$("#ToggleUniqueStats").style.visibility = "visible";
	$("#UniqueStats").style.visibility = "visible";
}

var toggle = false
function ToggleUniqueStats()
{
	$.Msg("Toggling Unique Stats...")
	if (toggle == false)
	{
		$.Msg("True")
		toggle = true
		$("#UniqueStats").style.visibility = "visible";
	}
	else
	{
		$.Msg("False")
		toggle = false
		$("#UniqueStats").style.visibility = "collapse";
	}
}

function UpdateNetGraph()
{
	var good_units = CustomNetTables.GetTableValue("netgraph", "good_unit_number");
	var bad_units = CustomNetTables.GetTableValue("netgraph", "bad_unit_number");
	var total_units = CustomNetTables.GetTableValue("netgraph", "total_unit_number");
	var total_dummies = CustomNetTables.GetTableValue("netgraph", "total_dummy_number");
	var total_dummies_created = CustomNetTables.GetTableValue("netgraph", "total_dummy_created_number");
	var total_particles = CustomNetTables.GetTableValue("netgraph", "total_particle_number");
	var total_particles_created = CustomNetTables.GetTableValue("netgraph", "total_particle_created_number");

//	$.Msg("#Hero" + i + "Particles")
//	$.Msg(CustomNetTables.GetTableValue("netgraph", "hero_particle_0").value)
//	$("#Hero" + i + "Particles").text = CustomNetTables.GetTableValue("netgraph", "hero_particle_" + i).value;

	if (good_units && bad_units && total_units && total_dummies && total_dummies_created && total_particles_created) {
		$("#GoodUnits").text = good_units.value;
		$("#BadUnits").text = bad_units.value;
		$("#TotalUnits").text = total_units.value;
		$("#TotalDummies").text = total_dummies.value;
		$("#TotalDummiesCreated").text = total_dummies_created.value;
		$("#TotalParticles").text = total_particles.value;
		$("#TotalParticlesCreated").text = total_particles_created.value;
	}

	for (var i = 0; i < 19; i++)
	{
		var heroPanel = $("#Hero"+i+"Particles")
		if (heroPanel)
		{
			heroPanel.text = CustomNetTables.GetTableValue("netgraph", "hero_particle_"+i).value;
		}
		else
		{
			$.Msg("Invalid value.")
		}
	}
}

(function()
{
	CustomNetTables.SubscribeNetTableListener("netgraph", UpdateNetGraph);
	GameEvents.Subscribe("show_netgraph", ShowNetgraph);
})();

