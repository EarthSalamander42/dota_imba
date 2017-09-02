"use strict";

function ShowNetgraph() /*Show NetGraph for devs only*/
{
	$("#GlobalStats").style.visibility = "visible";
	$("#Buttons").style.visibility = "visible";
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

function RemoveUnits()
{
	$.Msg("Removing units...")
	GameEvents.SendCustomGameEventToServer("remove_units", {});
}

function RemoveParticles()
{
	$.Msg("Removing particles...")
	GameEvents.SendCustomGameEventToServer("remove_particles", {});
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

	for (var i = 0; i < 20; i++)
	{
		var particle = CustomNetTables.GetTableValue("netgraph", "hero_particle_"+i).particle;
		var particle_total = CustomNetTables.GetTableValue("netgraph", "hero_total_particle_"+i).particle;
		var ID = CustomNetTables.GetTableValue("netgraph", "hero_particle_"+i).pID;

		var playerInfo = Game.GetPlayerInfo( i );
		var heroMainPanel = $("#Hero"+i+"ParticlesPanel")
		var heroPanel = $("#Hero"+i+"Particles")
		var player_name = 0

		if (particle)
		{
			heroMainPanel.style.visibility = "visible";
			heroPanel.text = particle_total;
			heroPanel.text = particle + "/" + particle_total;
		}
		/*
		else if (heroPanel == null)
		{
			$.Msg("Invalid Hero.")
		}
		else if (particle == null)
		{
			$.Msg("Invalid Particle.")
		}
		else if (ID == null)
		{
			$.Msg("Invalid ID.")
		}	*/

		if (playerInfo != null && player_name == 0)
		{
			player_name = 1
			$("#HeroName"+i).text = playerInfo.player_selected_hero;
			if (playerInfo.player_team_id == 2)
			{
				$("#HeroName"+i).style.color = "#08640Eda";
			}
			else if (playerInfo.player_team_id == 3)
			{
				$("#HeroName"+i).style.color = "#640808da";
			}

		}
	}
}

(function()
{
	CustomNetTables.SubscribeNetTableListener("netgraph", UpdateNetGraph);
	GameEvents.Subscribe("show_netgraph", ShowNetgraph);
})();

