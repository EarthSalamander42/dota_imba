// TODO: add game phase through a custom net table listener and move every vanilla hud overrides in here

(function () {
	GameEvents.Subscribe("override_top_bar_colors", OverrideTopBarColor);
})();

function OverrideTopBarColor() {
	const colors = CustomNetTables.GetTableValue("game_options", "player_colors");
	const team_name = {};
	team_name[DOTATeam_t.DOTA_TEAM_GOODGUYS] = "Radiant";
	team_name[DOTATeam_t.DOTA_TEAM_BADGUYS] = "Dire";
	const team_parent = {};
	team_parent[DOTATeam_t.DOTA_TEAM_GOODGUYS] = "TopBarRadiantPlayersContainer";
	team_parent[DOTATeam_t.DOTA_TEAM_BADGUYS] = "TopBarDirePlayersContainer";

	for (var team in colors) {
		for (var id in colors[team]) {
			const parent = GameUI.Utils.FindDotaHudElement(team_parent[team]);

			if (parent) {
				const panel = parent.GetChild(parseInt(id));

				if (panel) {
					panel.FindChildTraverse('PlayerColor').style.backgroundColor = colors[team][id];
				}
			}
		}
	}
}
