var dummy = "npc_dota_hero_wisp";
var heroPanels = {};

function UpdateHeroDetector(){
    $.Schedule(1 / 120, UpdateHeroDetector);

    var mainPanel = $("#MainPanel");
    var all = Entities.GetAllHeroEntities();
    var special = {};

    // Special handing of jugg swords
    var h = Players.GetLocalPlayerPortraitUnit();
    if (Entities.GetUnitName(h) == "npc_dota_hero_juggernaut") {
        var owner = GetPlayerOwnerID(h);

        for (var ent of Entities.GetAllEntitiesByClassname("npc_dota_creep_neutral")) {
            if (Entities.GetUnitName(ent) == "jugg_sword" && GetPlayerOwnerID(ent) == owner) {
                all.push(ent);

                var count = GetStackCount(h, "modifier_jugger_sword");
                var level = 1;

                if (count >= 500) level++;
                if (count >= 800) level++;
                if (count >= 1300) level++;

                special[ent] = level;
                ent.isSpecial = true;
                break;
            }
        }
    }

    var notOnScreen = _
        .chain(all)
        .reject(function(entity) {
            return Entities.IsUnselectable(entity) && !special[entity];
        })
        .filter(function(entity) {
            return Entities.IsAlive(entity);
        })
        .map(function(entity) {
            var abs = Entities.GetAbsOrigin(entity);
            var x = Game.WorldToScreenX(abs[0], abs[1], abs[2]);
            var y = Game.WorldToScreenY(abs[0], abs[1], abs[2]);

            return { id: entity, x: x, y: y };
        })
        .reject(function(mapped) {
            return mapped.x == -1 || mapped.y == -1;
        })
        .filter(function(mapped) {
            return GameUI.GetScreenWorldPosition(mapped.x, mapped.y) == null;
        })
        .each(function(entity) {
            if (_.has(heroPanels, entity.id)) {
                var panel = heroPanels[entity.id]
                var screenWidth = Game.GetScreenWidth();
                var screenHeight = Game.GetScreenHeight();
                var realW = Clamp(entity.x, 0, screenWidth - panel.actuallayoutwidth) / screenWidth;
                var realH = Clamp(entity.y, 0, screenHeight - panel.actuallayoutwidth) / screenHeight;

                if (isNaN(realW) || isNaN(realH)) {
                    return;
                }

                panel.style.position = parseInt(realW * 100) + "% " + parseInt(realH * 100) + "% 0px";

                if (!panel.BHasClass("HeroMarkerTransition")) {
                    panel.AddClass("HeroMarkerTransition");
                }
            } else {
                var panel;

                if (special[entity.id]) {
                    panel = $.CreatePanel("Panel", mainPanel, "");
                    panel.AddClass("HeroMarkerJuggSwordContainer");

                    var bg = $.CreatePanel("Panel", panel, "");
                    bg.AddClass("HeroMarkerJuggSwordBG");

                    var sw = $.CreatePanel("Panel", panel, "");
                    sw.AddClass("HeroMarkerJuggSword");
                    sw.AddClass("T" + special[entity.id]);

                } else {
                    panel = $.CreatePanel("DOTAHeroImage", mainPanel, "");
                    panel.heroname = Entities.GetUnitName(entity.id);
                    panel.heroimagestyle = "icon";
                }

                panel.hittest = false;

                heroPanels[entity.id] = panel;
            }
        })
        .value();

    var oldEntities = _.omit(heroPanels, function(value, key) {
        return _.some(notOnScreen, function(entity) { return entity.id == key });
    });

    _.each(oldEntities, function(panel, key) {
        panel.DeleteAsync(0);
        delete heroPanels[key];
    });
}

DelayStateInit(GAME_STATE_ROUND_IN_PROGRESS, function () {
    UpdateHeroDetector();
});