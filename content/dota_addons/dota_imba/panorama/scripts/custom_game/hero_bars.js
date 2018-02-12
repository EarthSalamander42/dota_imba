var heroPanels = {};
var heroBars = {};
var mainPanel = $("#HeroBarsContainer");

function darken(color, percent) {
	return [ color[0] * percent, color[1] * percent, color[2] * percent ];
}

function clr(color) {
	return "rgb(" + color[0] + "," + color[1] + "," + color[2]+ ")";
}

$("#HeroBarsContainer").RemoveAndDeleteChildren();

function UpdateBar(entity, spawn) {
	var panel = heroBars[entity.id];
	var w = 100;

	var hidden = false;
	var ethereal = false;
	var statusEffect;
	var statusEffectPriority = 0;
	var statusEffectTime = 0;
	var statusEffectProgress;
	var statusEffectRecast = false;
	var statusEffectAbility;

	var attackSpeedProgress;
	var attackSpeedStacks;

	if (panel.cached && panel.cached.attackTimer) {
		panel.cached.attackTimer.SetHasClass("TimerHidden", !attackSpeedProgress);

		if (attackSpeedProgress) {
			var pg = -Math.round(attackSpeedProgress * 360);
			panel.cached.attackTimer.style.clip = "radial(50% 50%, 0deg, " + pg + "deg)";
			panel.cached.attackTimer.SetHasClass("DangerZone", attackSpeedStacks == 3);
			panel.cached.attackTimer.SetHasClass("MaxReached", attackSpeedStacks == 4);
		}
	}

	var screenHR = Game.GetScreenHeight() / 1080;

	entity.x /= screenHR;
	entity.y /= screenHR;

	panel.style.x = (Math.floor(entity.x) - 50) + "px";
	panel.style.y = (Math.floor(entity.y) - 50) + "px";

	var callback = specialLayoutCallbacks[Entities.GetUnitName(entity.id)];

	if (callback) {
		callback(entity, panel);
	}
}

function DetectAndPushSpecialEntities(all) {
	var special = {};

	// Special handing of jugg swords
	var h = Players.GetLocalPlayerPortraitUnit();
	if (Entities.GetUnitName(h) == "npc_dota_hero_juggernaut") {
		var owner = Players.GetLocalPlayer();

		for (var ent of Entities.GetAllEntitiesByClassname("npc_dota_creep_neutral")) {
			if (Entities.GetUnitName(ent) == "jugg_sword" && Players.GetLocalPlayer() == owner) {
				all.push({
					id: ent,
					isRealHero: false
				});

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

	return special;
}

function CreateBar(entityId, lightBar) {
	var panel = $.CreatePanel("Panel", mainPanel, "");
	var special = specialLayouts[Entities.GetUnitName(entityId)];

	panel.BLoadLayoutSnippet(lightBar ? "HealthBarLight" : "HealthBar");

	panel.light = !!lightBar;

	if (!lightBar) {
		panel.cached = {};

//		var teamColor = colors[Entities.GetTeamNumber(entityId)];
		var teamColor = [26, 215, 56];
		var name = panel.FindChildTraverse("PlayerName");
		name.text = "DONATOR"
		name.style.color = clr(teamColor);

		name.style.marginLeft = "13px";

		panel.cached.attackTimer = panel.FindChildTraverse("AttackTimer");
	}

	return panel;
}

function ValidateAndUpdateOnScreenEntity(entityId, screenX, screenY, lightBar) {
	var changedBarTypeAndNeedsRecreation = _.has(heroBars, entityId) && heroBars[entityId].light !== !!lightBar;

	if (changedBarTypeAndNeedsRecreation) {
		return false;
	}

	if (_.has(heroBars, entityId)) {
		UpdateBar({ id: entityId, x: screenX, y: screenY, light: lightBar });
	} else {
		heroBars[entityId] = CreateBar(entityId, lightBar);

		UpdateBar({ id: entityId, x: screenX, y: screenY, light: lightBar });
	}

	return true;
}

function UpdateHeroDetectorPanel(entityId, screenX, screenY) {
	var panel = heroPanels[entityId];
	var screenWidth = Game.GetScreenWidth();
	var screenHeight = Game.GetScreenHeight();
	var realW = Clamp(screenX, 0, screenWidth - panel.actuallayoutwidth) / screenWidth;
	var realH = Clamp(screenY, 0, screenHeight - panel.actuallayoutwidth) / screenHeight;

	if (isNaN(realW) || isNaN(realH)) {
		return;
	}

	panel.style.position = parseInt(realW * 100) + "% " + parseInt(realH * 100) + "% 0px";

	if (!panel.BHasClass("HeroMarkerTransition")) {
		panel.AddClass("HeroMarkerTransition");
	}
}

function CreateHeroDetectorPanel(entityId, specialLevel) {
	var panel;

	if (specialLevel) {
		panel = $.CreatePanel("Panel", mainPanel, "");
		panel.AddClass("HeroMarkerJuggSwordContainer");

		var bg = $.CreatePanel("Panel", panel, "");
		bg.AddClass("HeroMarkerJuggSwordBG");

		var sw = $.CreatePanel("Panel", panel, "");
		sw.AddClass("HeroMarkerJuggSword");
		sw.AddClass("T" + specialLevel);
	} else {
		panel = $.CreatePanel("DOTAHeroImage", mainPanel, "");
		panel.heroname = Entities.GetUnitName(entityId);
		panel.heroimagestyle = "icon";
	}

	panel.hittest = false;

	return panel;
}

function ValidateAndUpdateOffScreenEntity(entityId, screenX, screenY, isRealHero, specialLevel) {
	if (!isRealHero && !specialLevel) {
		return false;
	}

	if (_.has(heroPanels, entityId)) {
		UpdateHeroDetectorPanel(entityId, screenX, screenY);
	} else {
		heroPanels[entityId] = CreateHeroDetectorPanel(entityId, specialLevel);

		UpdateHeroDetectorPanel(entityId, screenX, screenY);
	}

	return true;
}

function DetermineOffsetAndLightBarData(entityId) {
	var lightBar = HasModifier(entityId, "modifier_custom_healthbar");
	var offset;

	if (lightBar) {
		offset = 150;

		lightBar = {
			rem: GetRemainingModifierTime(entityId, "modifier_custom_healthbar"),
			dur: GetModifierDuration(entityId, "modifier_custom_healthbar")
		}
	} else {
		var nm = Entities.GetUnitName(entityId);
		offset = Entities.GetHealthBarOffset(entityId);
	}

	return {
		offset: offset,
		lightBar: lightBar
	}
}

function UpdateHeroBars(){
	$.Schedule(1 / 120, UpdateHeroBars);

	var classes = [ "npc_dota_creep_neutral", "npc_dota_creature" ];
	var all = [];

	for (var heroEntity of Entities.GetAllHeroEntities()) {
		var isSelectable = !Entities.IsUnselectable(heroEntity);
		var hasCustomHealthbar = HasModifier(heroEntity, "modifier_custom_healthbar");

		if (isSelectable || hasCustomHealthbar) {
			all.push({
				id: heroEntity,
				isRealHero: isSelectable
			})
		}
	}

	for (var cl of classes) {
		var dataArray = Entities.GetAllEntitiesByClassname(cl)
			.filter(function(entity) {
				return HasModifier(entity, "modifier_custom_healthbar");
			})
			.map(function(id) {
				return {
					id: id,
					isRealHero: false
				}
			});

		all = all.concat(dataArray);
	}

//	mainPanel.SetHasClass("AltPressed", GameUI.IsAltDown());

	var special = DetectAndPushSpecialEntities(all);
	var trulyOnScreen = [];
	var trulyNotOnScreen = [];

	for (var entityData of all) {
		var entityId = entityData.id;

		if (Entities.IsOutOfGame(entityId) || !Entities.IsAlive(entityId)) {
			continue;
		}

		var abs = Entities.GetAbsOrigin(entityId);
		var offsetAndLightBarData = DetermineOffsetAndLightBarData(entityId);

		var offset = offsetAndLightBarData.offset;
		var lightBar = offsetAndLightBarData.lightBar;

		var screenX = Game.WorldToScreenX(abs[0], abs[1], abs[2] + offset);
		var screenY = Game.WorldToScreenY(abs[0], abs[1], abs[2] + offset);

		if (screenX == -1 || screenY == -1) {
			continue
		}

		var isOnScreen = GameUI.GetScreenWorldPosition(screenX, screenY) != null;

		if (isOnScreen) {
			if (!special[entityId] && ValidateAndUpdateOnScreenEntity(entityId, screenX, screenY, lightBar)) {
				trulyOnScreen.push(entityId);
			}
		} else {
			if (ValidateAndUpdateOffScreenEntity(entityId, screenX, screenY, entityData.isRealHero, special[entityId])) {
				trulyNotOnScreen.push(entityId);
			}
		}
	}

	// Everything around there is crap code, but this is extra crap, unreadable!
	{
		var oldEntities = _.omit(heroBars, function(value, key) {
			return _.some(trulyOnScreen, function(entityId) { return entityId == key });
		});

		_.each(oldEntities, function(panel, key) {
			panel.DeleteAsync(0);
			delete heroBars[key];
		});
	}

	{
		var oldEntities = _.omit(heroPanels, function(value, key) {
			return _.some(trulyNotOnScreen, function(entityId) { return entityId == key });
		});

		_.each(oldEntities, function(panel, key) {
			panel.DeleteAsync(0);
			delete heroPanels[key];
		});
	}
}

(function() {
//	var steamId = Game.GetLocalPlayerInfo().player_steamid;
//	var url = 'http://api.dota2imba.org/meta/set-companion';
//	var data = {
//		steam_id: steamId
//	};
//
//	var i = 0
//	var donator = CustomNetTables.GetTableValue("game_options", "donators").donators;
//
//	for (i in donator) {
//		if (donator[i] != undefined) {
//			if (donator[i] == steamId) {
//				is_donator = true
//				$.Msg("Donator Bar Good");
//				UpdateHeroBars();
//				return;
//			}
//		}
//	}
})();

// UTIL FUNCTIONS
function FindModifier(unit, modifier) {
    for (var i = 0; i < Entities.GetNumBuffs(unit); i++) {
        if (Buffs.GetName(unit, Entities.GetBuff(unit, i)) == modifier){
            return Entities.GetBuff(unit, i);
        }
    }
}

function HasModifier(unit, modifier) {
	return !!FindModifier(unit, modifier);
}

function Clamp(num, min, max) {
	return num < min ? min : num > max ? max : num;
}
