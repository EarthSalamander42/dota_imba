"use strict";

(function() {
	if (Game.GetMapInfo().map_display_name == "imba_mutation_5v5" || Game.GetMapInfo().map_display_name == "imba_mutation_10v10") {

	} else {
		$.GetContextPanel().DeleteAsync(0)
	}
})();
