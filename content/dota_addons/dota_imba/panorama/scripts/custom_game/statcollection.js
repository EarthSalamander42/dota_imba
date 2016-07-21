"use strict";

function OnClientCheckIn(args) {

    var payload = {
        modIdentifier: args.modID,
        steamID32: GetSteamID32(),
        matchID: args.matchID,
        schemaVersion: args.schemaVersion
    };

    $.Msg('Sending: ', payload);

    $.AsyncWebRequest('http://getdotastats.com/s2/api/s2_check_in.php',
        {
            type: 'POST',
            data: {payload: JSON.stringify(payload)},
            success: function (data) {
                $.Msg('GDS Reply: ', data)
            }
        });
}

function GetSteamID32() {
    var playerInfo = Game.GetPlayerInfo(Game.GetLocalPlayerID());

    var steamID64 = playerInfo.player_steamid,
        steamIDPart = Number(steamID64.substring(3)),
        steamID32 = String(steamIDPart - 61197960265728);

    return steamID32;
}

(function () {
    $.Msg("StatCollection Client Loaded");

    GameEvents.Subscribe("statcollection_client", OnClientCheckIn);

})();