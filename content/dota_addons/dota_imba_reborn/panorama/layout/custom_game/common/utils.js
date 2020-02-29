Object.values = function(object) {
	return Object.keys(object).map(function(key) { return object[key] });
}

Array.prototype.includes = function(searchElement, fromIndex) {
	return this.indexOf(searchElement, fromIndex) !== -1;
}

String.prototype.includes = function(searchString, position) {
	return this.indexOf(searchString, position) !== -1
}

function setInterval(callback, interval) {
	interval = interval / 1000;
	$.Schedule(interval, function reschedule() {
		$.Schedule(interval, reschedule);
		callback();
	});
}

function createEventRequestCreator(eventName) {
	var idCounter = 0;
	return function(data, callback) {
		var id = ++idCounter;
		data.id = id;
		GameEvents.SendCustomGameEventToServer(eventName, data);
		var listener = GameEvents.Subscribe(eventName, function(data) {
			if (data.id !== id) return;
			GameEvents.Unsubscribe(listener);
			callback(data)
		});

		return listener;
	}
}

function SubscribeToNetTableKey(tableName, key, callback) {
    var immediateValue = CustomNetTables.GetTableValue(tableName, key) || {};
    if (immediateValue != null) callback(immediateValue);
    CustomNetTables.SubscribeNetTableListener(tableName, function (_tableName, currentKey, value) {
        if (currentKey === key && value != null) callback(value);
    });
}

function GetDotaHud() {
    var panel = $.GetContextPanel();
    while (panel && panel.id !== 'Hud') {
        panel = panel.GetParent();
	}

    if (!panel) {
        throw new Error('Could not find Hud root from panel with id: ' + $.GetContextPanel().id);
	}

	return panel;
}

function FindDotaHudElement(id) {
	return GetDotaHud().FindChildTraverse(id);
}

var useChineseDateFormat = $.Language() === 'schinese' || $.Language() === 'tchinese';
/** @param {Date} date */
function formatDate(date) {
	return useChineseDateFormat
		? date.getFullYear() + '-' + date.getMonth() + '-' + date.getDate()
		: date.getMonth() + '/' + date.getDate() + '/' + date.getFullYear();
}