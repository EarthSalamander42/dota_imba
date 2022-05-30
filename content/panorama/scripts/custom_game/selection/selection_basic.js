// Super barebones version of Noya's selection library, because I don't really need all that nettables stuff right now (also crashes the game cause you can't go past twelve of them or something)

"use strict";

var skip = false

// Recieves a list of entities to replace the current selection
function Selection_Basic_New(msg)
{
	var entities = msg.entities
	//$.Msg("Selection_New ", entities)
	for (var i in entities) {
		if (i==1)
			GameUI.SelectUnit(entities[i], false) //New
		else
			GameUI.SelectUnit(entities[i], true) //Add
	};
}

(function () {
	// Custom event listeners
	GameEvents.Subscribe( "selection_new", Selection_Basic_New);
})();