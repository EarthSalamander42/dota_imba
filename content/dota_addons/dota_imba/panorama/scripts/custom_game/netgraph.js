"use strict";

var player_name = 0

function ShowNetgraph() /*Show NetGraph for devs only*/ {
	$("#Buttons").style.visibility = "visible";
}

var toggle_graph = false

function ToggleNetGraph() {
	if (toggle_graph == false) {
		toggle_graph = true
		$("#GlobalStats").style.visibility = "visible";
	} else {
		toggle_graph = false
		$("#GlobalStats").style.visibility = "collapse";
	}
}

var toggle_stats = false

function ToggleUniqueStats() {
	if (toggle_stats == false) {
		toggle_stats = true
		$("#UniqueStats").style.visibility = "visible";
	} else {
		toggle_stats = false
		$("#UniqueStats").style.visibility = "collapse";
	}
}

function RemoveUnits() {
	$.Msg("Removing units...")
	GameEvents.SendCustomGameEventToServer("remove_units", {});
}

//	function RemoveParticles()
//	{
//		$.Msg("Removing particles...")
//		GameEvents.SendCustomGameEventToServer( "remove_particles", {} );
//	}

function UpdateNetGraph() {
	var hero_number = CustomNetTables.GetTableValue("netgraph", "hero_number");
	var good_units = CustomNetTables.GetTableValue("netgraph", "good_unit_number");
	var bad_units = CustomNetTables.GetTableValue("netgraph", "bad_unit_number");
	var good_build = CustomNetTables.GetTableValue("netgraph", "good_build_number");
	var bad_build = CustomNetTables.GetTableValue("netgraph", "bad_build_number");
	var total_units = CustomNetTables.GetTableValue("netgraph", "total_unit_number");
	var total_dummies = CustomNetTables.GetTableValue("netgraph", "total_dummy_number");
	var total_dummies_created = CustomNetTables.GetTableValue("netgraph", "total_dummy_created_number");
	//	var total_particles = CustomNetTables.GetTableValue("netgraph", "total_particle_number");
	//	var total_particles_created = CustomNetTables.GetTableValue("netgraph", "total_particle_created_number");

	if (good_units && bad_units && total_units && total_dummies && total_dummies_created) {
		$("#GoodUnits").text = good_build.value + "/" + good_units.value;
		$("#BadUnits").text = bad_build.value + "/" + bad_units.value;
		$("#TotalUnits").text = total_units.value;
		$("#TotalDummies").text = total_dummies.value;
		$("#TotalDummiesCreated").text = total_dummies_created.value;
		//		$("#TotalParticles").text = total_particles.value;
		//		$("#TotalParticlesCreated").text = total_particles_created.value;
	}
	/*
		for (var i = 0; i < hero_number.value; i++)
		{
			var particle = CustomNetTables.GetTableValue("netgraph", "hero_particle_"+i).particle;
			var particle_total = CustomNetTables.GetTableValue("netgraph", "hero_total_particle_"+i).particle;
	//		var ID = CustomNetTables.GetTableValue("netgraph", "hero_particle_"+i).pID;

			var playerInfo = Game.GetPlayerInfo( i );
			var heroPanel = $("#Hero"+i+"Particles")

			if (particle)
			{			
				heroPanel.text = particle_total;
				heroPanel.text = particle + "/" + particle_total;
			}
		}
		*/
}

function UpdateNetGraphHeroNames() {
	var hero_number = CustomNetTables.GetTableValue("netgraph", "hero_number");

	for (var i = 0; i < hero_number.value; i++) {
		var playerInfo = Game.GetPlayerInfo(i);
		var heroMainPanel = $("#Hero" + i + "ParticlesPanel")
		if (player_name == 0) {
			player_name = 1
			$.Msg(playerInfo.player_selected_hero)
			heroMainPanel.style.visibility = "visible";
			$("#HeroName" + i).text = playerInfo.player_selected_hero;
			if (playerInfo.player_team_id == 2) {
				$("#HeroName" + i).style.color = "#08640Eda";
			} else if (playerInfo.player_team_id == 3) {
				$("#HeroName" + i).style.color = "#640808da";
			}
		}
	}
}

(function () {
	CustomNetTables.SubscribeNetTableListener("netgraph", UpdateNetGraph);
	GameEvents.Subscribe("show_netgraph", ShowNetgraph);
	GameEvents.Subscribe("show_netgraph_heronames", UpdateNetGraphHeroNames);
})();