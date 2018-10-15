"use strict";

(function() {
	if (Game.GetMapInfo().map_display_name == "mutation_5v5" || Game.GetMapInfo().map_display_name == "mutation_10v10") {

	} else {
		$.GetContextPanel().DeleteAsync(0)
	}
})();
