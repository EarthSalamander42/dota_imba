var parties;

function SubscribeToNetTableKey(tableName, key, callback) {
	var immediateValue = CustomNetTables.GetTableValue(tableName, key) || {};
	if (immediateValue != null) callback(immediateValue);
	CustomNetTables.SubscribeNetTableListener(tableName, function (_tableName, currentKey, value) {
		if (currentKey === key && value != null) callback(value);
	});
}

function HighlightByParty(player_id, label) {
	let party_id = parties[player_id];

	if (party_id != undefined) {
		label.SetHasClass("Party_" + party_id, true);
	} else {
		label.SetHasClass("NoParty", true);
	}
}

SubscribeToNetTableKey("game_options", "parties", (value) => {
	// $.Msg("Received party data: ", value);
	parties = value;
});
