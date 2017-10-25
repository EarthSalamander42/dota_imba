"use strict";

var dummy = "npc_dota_hero_wisp";

var availableHeroes = {};
var currentHero = null;
var abilityBar = null;
var buffBar = null;
var healthBar = null;
var chatLines = [];
var cosmeticAbilityBar = null;
var attacksRequested = 0;
var newPlayer = false;
var attackOff = false;

//GameUI.SetCameraPitchMin(0);
//GameUI.SetCameraPitchMax(0);
//GameUI.SetCameraLookAtPositionHeightOffset(0);
GameUI.GameChat = $("#GameChat");

function AddChatLine(hero, playerName, color, message, team, wasTopPlayer, hasPass, wheel) {
    var line = $.CreatePanel("Panel", $("#GameChatContent"), "");
    var last = $("#GameChatContent").GetChild(0);
    line.AddClass("GameChatLine");
    line.AddClass("GameChatLineAppear");

    if (last != null) {
        $("#GameChatContent").MoveChildBefore(line, last);
    }

    var img = $.CreatePanel("DOTAHeroImage", line, "");

    img.AddClass("GameChatImage");
    img.heroimagestyle = "icon";
    img.heroname = hero;

    if (wasTopPlayer) {
        var trophy = $.CreatePanel("Panel", line, "");

        trophy.AddClass("TopPlayerIcon");
        trophy.AddClass("GameChatImage");
    }

    var label = $.CreatePanel("Label", line, "");
    label.SetDialogVariable("name", playerName);
    label.SetDialogVariable("color", color);
    label.SetDialogVariable("message", InsertEmotes(message, wasTopPlayer, wheel));
    label.html = true;
    label.text = (team ? ($.Localize("#ChatTeam") + " ") : "") + $.Localize(hasPass ? "#ChatLinePass" : "#ChatLine", label);

    $("#GameChatContent").ScrollToBottom();

    $.Schedule(5, function(){
        line.AddClass("GameChatLineHidden");
    });
}

function OnCustomSystemMessage(args) {
    var line = $.CreatePanel("Panel", $("#GameChatContent"), "");
    var last = $("#GameChatContent").GetChild(0);
    line.AddClass("GameChatLine");
    line.AddClass("GameChatLineAppear");

    var label = $.CreatePanel("Label", line, "");

    for (var key in args.vars) {
        if (key === "player") {
            args.vars[key] = EscapeHtml(Players.GetPlayerName(args.vars[key]))
        }

        if (key === "color") {
            args.vars[key] = LuaColor(args.vars[key])
        }

        label.SetDialogVariable(key, args.vars[key]);
    }

    label.html = true;
    label.text = $.Localize("#System") + " " + $.Localize(args.token, label);

    $("#GameChatContent").ScrollToBottom();

    if (last != null) {
        $("#GameChatContent").MoveChildBefore(line, last);
    }

    $.Schedule(5, function(){
        line.AddClass("GameChatLineHidden");
    });
}

function OnKillMessage(args) {
    MessageQueue.QueueMessage(args.victim, args.token, args.sound);
}

function OnCustomChatSay(args) {
    var color = LuaColor(args.color);

    AddChatLine(args.hero, EscapeHtml(Players.GetPlayerName(args.player)), color, args.message, args.team, args.wasTopPlayer, args.hasPass);
}

function OnKillLogEntry(args) {
    var log = $("#KillLog");
    var last = log.GetChild(0);

    var entry = $.CreatePanel("Panel", log, "");
    entry.AddClass("KillLogEntry");
    entry.AddClass("KillLogEntryAppear");
    entry.style.backgroundColor = LuaColorA(args.color, 0.5);

    if (last != null) {
        log.MoveChildBefore(entry, last);
    }

    var img = $.CreatePanel("DOTAHeroImage", entry, "");
    img.heroimagestyle = "icon";
    img.heroname = args.killer;
    img.SetScaling("stretch-to-fit-y-preserve-aspect");

    img = $.CreatePanel("Image", entry, "");

    if (args.fell) {
        img.SetImage("file://{images}/custom_game/fall.png");
    } else {
        img.SetImage("file://{images}/custom_game/swords.png");
    }

    img.SetScaling("stretch-to-fit-y-preserve-aspect");

    img = $.CreatePanel("DOTAHeroImage", entry, "");
    img.heroimagestyle = "icon";
    img.heroname = args.victim;
    img.SetScaling("stretch-to-fit-y-preserve-aspect");
}

function SetupUI(){
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_HEROES, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_MINIMAP, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_PANEL, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PANEL, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_SHOP, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_ITEMS, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_QUICKBUY, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_COURIER, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PROTECT, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_GOLD, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_TEAMS, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_GAME_NAME, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_CLOCK, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_BAR_BACKGROUND, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_MENU_BUTTONS, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ENDGAME, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ENDGAME_CHAT, false);
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_QUICK_STATS, false);
}

function GetLocalHero(){
    return Players.GetLocalPlayerPortraitUnit();
}

function GetLocalPlayedHero(){
    return _
        .chain(Entities.GetAllHeroEntities())
        .filter(function(entity) {
            return !Entities.IsUnselectable(entity) && Entities.IsControllableByPlayer(entity, Players.GetLocalPlayer());
        })
        .first()
        .value();
}

function LoadHeroUI(heroId){
    $("#HeroPortrait").heroname = Entities.GetUnitName(heroId);
    $("#HeroNameLabel").text = $.Localize("#HeroName_" + Entities.GetUnitName(heroId));

    if (abilityBar == null) {
        abilityBar = new AbilityBar("#AbilityPanel");
    }

    if (cosmeticAbilityBar == null) {
        cosmeticAbilityBar = new AbilityBar("#HeroCosmeticAbilities");
    }

    if (healthBar == null) {
        healthBar = new HealthBar("#HealthPanel", heroId);
    }

    if (buffBar == null) {
        buffBar = new BuffBar("#BuffPanel");
    }

    LoadCustomIcons();

    abilityBar.SetProvider(new EntityAbilityDataProvider(heroId));
    abilityBar.RegisterEvents(true);

    var cosmeticProvider = new EntityAbilityDataProvider(heroId);
    cosmeticProvider.SetOnlyCosmetic(true);

    cosmeticAbilityBar.SetProvider(cosmeticProvider);
    cosmeticAbilityBar.RegisterEvents(true);
    cosmeticAbilityBar.AddCustomClass("taunt_static", "AbilityTaunt");
    cosmeticAbilityBar.AddCustomClass("taunt_moving", "AbilityTaunt");
    cosmeticAbilityBar.AddCustomClass("emote", "AbilityEmote");

    healthBar.SetEntity(heroId);
    buffBar.SetEntity(heroId);
}

function LoadCustomIcons(){
    for (var key in availableHeroes) {
        var hero = availableHeroes[key];

        if (hero.customIcons) {
            for (var iconKey in hero.customIcons) {
                abilityBar.AddCustomIcon(iconKey, hero.customIcons[iconKey]);
                buffBar.AddCustomIcon(iconKey, hero.customIcons[iconKey]);

                customIcons[iconKey] = hero.customIcons[iconKey];
            }
        }
    }
}

function UpdateUI(){
    $.Schedule(1 / 144, UpdateUI);

    var localHero = GetLocalHero();

    if (localHero != currentHero && Entities.GetUnitName(localHero) != dummy) {
        currentHero = localHero;
        LoadHeroUI(localHero);
    }

    if (healthBar != null) {
        healthBar.Update();
    }

    if (abilityBar != null) {
        abilityBar.Update();
    }

    if (cosmeticAbilityBar != null) {
        cosmeticAbilityBar.Update();
    }

    if (buffBar != null) {
        buffBar.Update();
    }

    if (GetPlayerOwnerID(localHero) == Game.GetLocalPlayerID()) {
        UpdateGuidedAndCastedAbilities(localHero);
    }
}

function UpdateGuidedAndCastedAbilities(localHero) {
    var count = Entities.GetAbilityCount(localHero);
    var guided = -1;
    var casted = -1;

    for (var i = 0; i < count; i++) {
        var ability = Entities.GetAbility(localHero, i);

        if (Abilities.IsInAbilityPhase(ability)) {
            casted = ability;
        }

        var p = DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT;
        var pointTarget = (Abilities.GetBehavior(ability) & p) == p;

        if (pointTarget && Abilities.GetChannelStartTime(ability) > 0) {
            var cursor = GameUI.GetCursorPosition();
            var position = GameUI.GetScreenWorldPosition(cursor);

            GameEvents.SendCustomGameEventToServer("guided_ability_cursor", { pos: position, ability: ability })
            guided = ability;
        }
    }

    SetGuidedAbility(guided);
    SetCastedAbility(casted);
}

function CenterCamera(on){
    GameUI.SetCameraTargetPosition(Entities.GetAbsOrigin(on || GetLocalHero()), 1.0);
}

function AddDebugButton(text, eventName){
    var panel = $("#DebugPanel");
    var button = $.CreatePanel("Button", panel, "");
    button.SetPanelEvent("onactivate", function(){
        GameEvents.SendCustomGameEventToServer(eventName, {});
    });

    $.CreatePanel("Label", button, "").text = text;

    return button;
}

function FillDebugPanel(){
    var heroText = $.CreatePanel("TextEntry", $("#DebugPanel"), "");
    heroText.multiline = false;
    heroText.textmode = "normal";
    heroText.text = "sven";

    AddDebugButton("Add Test Hero", null).SetPanelEvent("onactivate", function(){
        GameEvents.SendCustomGameEventToServer("debug_create_test_hero", {
            name: "npc_dota_hero_" + heroText.text.trim()
        });
    });

    AddDebugButton("Take 1 damage", "debug_take_damage");
    AddDebugButton("Heal 1 health", "debug_heal_health");
    AddDebugButton("Heal debug hero", "debug_heal_debug_hero");
    AddDebugButton("Check round end", "debug_check_end");
    AddDebugButton("Switch end check", "debug_switch_end_check");
    AddDebugButton("Switch debug display", "debug_switch_debug_display");
    AddDebugButton("Reset level", "debug_reset_level");
    AddDebugButton("Toggle attack", null).SetPanelEvent("onactivate", function(){
        attackOff = !attackOff;
    });
    AddDebugButton("ALL HEROES", "debug_test_everything");
}

function DebugUpdate(data){
    if (data.enabled){
        FillDebugPanel();
    }
}

function GameStateChanged(data){
    var animations = {
        "HeroPanel": "AnimationHeroHudHidden",
        "DeathMatchContainer": "AnimationHeroHudHidden",
        "HeroDetails": "AnimationHeroDetailsHidden",
        "ScoreboardContainer": "AnimationScoreboardHidden",
        "KillLog": "AnimationKillLogHidden",
        "KillMessageContainer": "Hidden"
    };

    for (var panel in animations) {
        var animation = animations[panel];

        $("#" + panel).SetHasClass(animation, data.state != GAME_STATE_ROUND_IN_PROGRESS);
    }

    if (data.state == GAME_STATE_ROUND_IN_PROGRESS){
        $("#KillLog").RemoveAndDeleteChildren();
        $("#RoundMessageTop").AddClass("RoundMessageTopAnimation");
        $("#RoundMessageBottom").AddClass("RoundMessageBottomAnimation");

        $.Schedule(3, function() {
            $("#RoundMessageTop").RemoveClass("RoundMessageTopAnimation");
            $("#RoundMessageBottom").RemoveClass("RoundMessageBottomAnimation");
        });

        Game.EmitSound("UI.RoundStart");

        $.Schedule(0.2, function() {
            CenterCamera(GetLocalPlayedHero());
        });
    } else {
        $("#RoundMessageTop").RemoveClass("RoundMessageTopAnimation");
        $("#RoundMessageBottom").RemoveClass("RoundMessageBottomAnimation");
    }

    UpdateAttackTip();
}

function GameInfoChanged(data){
    if (data && data.roundNumber) {
        $("#RoundMessageBottom").text = (data.roundNumber - 1).toString();
    }
}

var DeathMatch = new (function() {
    this.ShowHeroAbilities = function(hero) {
        var customIcons = {};

        if (hero.customIcons) {
            for (ability in hero.customIcons) {
                customIcons[ability] = hero.customIcons[ability];
            }
        }

        var abilitiesToShow = ["Q", "W", "E", "R"];

        for (var ability of abilitiesToShow) {
            var found =
                _(hero.abilities)
                    .chain()
                    .filter(function(a) {
                        return EndsWith(a.name, ability.toLowerCase());
                    })
                    .first()
                    .value();

            var row = $("#AbilityRow" + ability);

            if (row && found) {
                var image = row.Children()[0];
                var label = row.Children()[1];

                var icon = GetTexture(found, hero.customIcons);
                image.SetImage(icon);

                label.text = $.Localize(hero.name.substring("npc_dota_hero_".length) + "_Desc" + ability);
            }
        }
    }

    this.FilterDifficulty = function(difficulty) {
        return _.filter(Object.keys(this.heroes), function(hero) {
            return DeathMatch.heroes[hero].difficulty == difficulty;
        });
    }

    this.FillHeroList = function(parent, difficulty) {
        var heroes = this.FilterDifficulty(difficulty);

        heroes = _(heroes).reject(function(hero) {
            return DeathMatch.heroes[hero].disabled;
        });

        heroes = _(heroes).sortBy(function(hero) {
            return DeathMatch.heroes[hero].order
        });

        heroes = _(heroes).sortBy(function(hero) {
            return DeathMatch.heroes[hero].difficulty
        });

        var currentRow = null;

        for (var index in heroes) {
            if (index % 4 == 0) {
                currentRow = $.CreatePanel("Panel", parent, "");
                currentRow.AddClass("DeathMatchHeroRow");
            }

            var hero = heroes[index];
            var heroData = this.heroes[hero];
            var heroButton = $.CreatePanel("DOTAHeroImage", currentRow, "");
            heroButton.SetScaling("stretch-to-fit-x-preserve-aspect");

            heroButton.heroimagestyle = "landscape";
            heroButton.heroname = hero;

            this.AddButtonEvents(heroButton, hero);
        }
    }

    this.HeroesUpdated = function(data) {
        this.heroes = data;
        this.FillHeroList($("#DeathMatchHeroesContentEasy"), "easy");
        this.FillHeroList($("#DeathMatchHeroesContentHard"), "hard");
    }

    this.ShowHeroDetails = function(hero){
        this.ShowHeroAbilities(this.heroes[hero]);

        $("#DeathMatchHeroMovie").heroname = hero;
        $("#DeathMatchHeroName").text = $.Localize("HeroName_" + hero).toUpperCase();
    }

    this.PlayersUpdated = function(data) {
        if (data.isDeathMatch) {
            var player = _(data.players).findWhere({ id: Game.GetLocalPlayerID() });

            $("#DeathMatchContainer").SetHasClass("Hidden", player == null || !player.isDead);

            if (player != null) {
                $("#DeathMatchRespawnButtonIcon").heroname = player.hero;
            }
        }
    }

    this.InstantRespawn = function() {
        this.Respawn("npc_dota_hero_" + $("#DeathMatchRespawnButtonIcon").heroname);
    }

    this.Respawn = function(hero) {
        GameEvents.SendCustomGameEventToServer("dm_respawn", { "hero": hero });
        this.HideHeroes();
    }

    this.Random = function() {
        GameEvents.SendCustomGameEventToServer("dm_random", {});
        this.HideHeroes();
    }

    this.AddButtonEvents = function(button, name) {
        button.SetPanelEvent("onactivate", function() {
            DeathMatch.Respawn(name);
        });

        button.SetPanelEvent("onmouseover", function() {
            DeathMatch.ShowHeroDetails(name);
        });
    }

    this.HideHeroes = function() {
        $("#DeathMatchHeroes").SetHasClass("Hidden", true);
    }

    this.OnRespawn = function(args) {
        GameUI.SetCameraTargetPosition([ args.x, args.y, 0 ], 1.0);
        Game.EmitSound("UI.Respawn");

        if (this.deathMusic) {
            Game.StopSound(this.deathMusic);
        }
    }

    this.OnDeath = function(args) {
        Game.EmitSound("UI.YouDied");
        this.deathMusic = Game.EmitSound("UI.YouDiedMusic");
    }

})();

function HeroesUpdate(data){
    availableHeroes = data;

    DeathMatch.HeroesUpdated(data);
}

function GetMouseCastTarget() {
    var mouseEntities = GameUI.FindScreenEntities(GameUI.GetCursorPosition());
    var localHeroIndex = GetLocalHero();

    mouseEntities = mouseEntities.filter(function (e) {
        return e.entityIndex !== localHeroIndex;
    });

    for (var e of mouseEntities) {
        if (!e.accurateCollision)
            continue;
        return e.entityIndex;
    }

    for (var e of mouseEntities) {
        return e.entityIndex;
    }

    return -1;
}

function MouseCallback(event, button) {
    var debug = (CustomNetTables.GetTableValue("main", "debug") || {}).enabled;

    if (debug && attackOff) {
        return false;
    }

    if (GameUI.GetClickBehaviors() !== CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE) {
        return false;
    }

    var position = GameUI.GetScreenWorldPosition(GameUI.GetCursorPosition());

    if (GameUI.IsAltDown() && position && button == 0) {
        GameEvents.SendCustomGameEventToServer("custom_ping", { position: position, danger: GameUI.IsControlDown() });
        return true;
    }

    if (event === "pressed" || (event === "doublepressed" && !debug)) {
        var localHero = GetLocalHero();
        var target = GetMouseCastTarget();

        if (!position || !localHero) {
            return false;
        }

        // TODO check if hero is dead
        if (button === 0) {
            var count = Entities.GetAbilityCount(localHero);
            var castAbilityIndex = -1;

            for (var i = 0; i < count; i++) {
                var ability = Entities.GetAbility(localHero, i);

                if (EndsWith(Abilities.GetAbilityName(ability), "_a")) {
                    castAbilityIndex = ability;
                }
            }

            if (castAbilityIndex == -1) {
                return false;
            }

            var order = {
                AbilityIndex: castAbilityIndex,
                QueueBehavior: OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
                ShowEffects: Entities.IsDisarmed(localHero),
                OrderType: dotaunitorder_t.DOTA_UNIT_ORDER_CAST_POSITION,
                Position: position
            };

            (function tick() {
                if (GameUI.IsMouseDown(button)) {
                    if (!Entities.IsDisarmed(localHero)) {
                        $.Schedule(1 / 60.0, tick);
                    }

                    order.Position = GameUI.GetScreenWorldPosition(GameUI.GetCursorPosition());

                    if (Abilities.IsCooldownReady(order.AbilityIndex) &&
                        !Abilities.IsInAbilityPhase(order.AbilityIndex) &&
                         Abilities.IsActivated(order.AbilityIndex)
                    ) {
                        Game.PrepareUnitOrders(order);

                        attacksRequested++;
                        UpdateAttackTip();
                    }
                }
            })();

            return true;
        }

        /*if (button === 1) {
            var order = {
                QueueBehavior: OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
                ShowEffects: false,
                OrderType: dotaunitorder_t.DOTA_UNIT_ORDER_MOVE_TO_POSITION,
                Position: position
            };

            var first = true;

            (function tick() {
                if (GameUI.IsMouseDown(button)) {
                    $.Schedule(1 / 60.0, tick);

                    var newPos = GameUI.GetScreenWorldPosition(GameUI.GetCursorPosition());

                    if (newPos && order.Position) {
                        var len = Vector.FromArray(order.Position).minus(Vector.FromArray(newPos)).length();

                        if (len >= 64 || first) {
                            order.Position = newPos;

                            Game.PrepareUnitOrders(order);
                        }

                        first = false;
                    }
                }
            })();

            return true;
        }*/
    }

    return false;
}

function UpdateAttackTip() {
    var state = CustomNetTables.GetTableValue("main", "gameState").state;

    $("#AttackTipContainer").SetHasClass("Hidden", !newPlayer || attacksRequested > 200 || state != GAME_STATE_ROUND_IN_PROGRESS);
}

function UpdateLocalNewPlayer(data) {
    var players = data.players || {};
    var localPlayer = {};

    for (var key in players) {
        var player = players[key];

        if (player.id == Game.GetLocalPlayerID()) {
            localPlayer = player;
            break;
        }
    }

    newPlayer = ((localPlayer.gamesPlayed || 6) <= 5);

    UpdateAttackTip();
}

function SetupChat() {
    var top = $.GetContextPanel().GetParent().GetParent().GetParent();
    var hud = top.FindChild("HUDElements");
    hud.style.zIndex = 10;

    hud.FindChild("topbar").FindChild("DayGlow").style.visibility = "collapse";

    var hudChat = hud.FindChild("HudChat");
    var controls = hudChat.FindChildTraverse("ChatControls");
    var chat = hudChat.FindChildTraverse("ChatInput");
    var linesContainer = hudChat.FindChildTraverse("ChatLinesPanel");
    var lastChatWheelElement = null;

    hudChat.style.width = "25%";

    for (var child of hudChat.FindChildTraverse("ChatMainPanel").Children()) {
        if (child != controls) {
            child.style.visibility = "collapse";
        }
    }

    hudChat.style.height = "fit-children";
    hudChat.style.y = "-350px";

    controls.style.border = "0";

    var chatVisible = false;
    var chatVisibleAt = undefined;

    for (var child of controls.Children()) {
        if (child.id == "ChatTargetLabel" || child == chat) {
            continue;
        }

        child.style.visibility = "collapse";
    }

    function UpdateChatState() {
        var nowVisible = hudChat.BHasClass("Active");

        if (!chatVisible && nowVisible) {
            chatVisibleAt = Game.Time();
        }

        if (chatVisible && !nowVisible) {
            chatVisibleAt = undefined;
        }

        if (chatVisible != nowVisible) {
            $("#GameChat").SetHasClass("ChatVisible", nowVisible);
        }

        chatVisible = nowVisible;

        $.Schedule(0, UpdateChatState);

        for (var child of linesContainer.Children().reverse()) {
            if (child.FindChildrenWithClassTraverse("ChatWheelIcon").length > 0) {
                if (child != lastChatWheelElement) {
                    lastChatWheelElement = child;

                    var allyPattern = /\[.*]\s(.*):\s\s(.*)/g;
                    var allPattern = /\s\s(.*):\s\s(.*)/g;

                    var team = false;
                    var data = allyPattern.exec(child.text);

                    if (data != null) {
                        team = true;
                    } else {
                        data = allPattern.exec(child.text);
                    }

                    var playerName = data[1];
                    var message = data[2];
                    var color = null;
                    var hero = "";

                    var players = (CustomNetTables.GetTableValue("main", "players") || {}).players;

                    for (var i in players) {
                        var player = players[i];
                        if (Players.GetPlayerName(player.id) == playerName) {
                            color = LuaColor(player.color);
                            hero = player.hero;

                            break;
                        }
                    }

                    GameEvents.SendEventClientSide("custom_chat_wheel", {
                        hero: hero,
                        playerName: EscapeHtml(playerName),
                        color: color,
                        message: message,
                        team: team
                    });
                }

                break;
            }
        }
    }

    UpdateChatState();

    chat.SetPanelEvent("oninputsubmit", function() {
        if (chat.text === "-ping") {
            Game.ServerCmd("dota_ping");
        } else {
            GameEvents.SendCustomGameEventToServer("custom_chat_say", {
                message: chat.text,
                team: !chat.BHasClass("GameAllChat")
            });
        }

        chat.text = "";

        var time = Game.Time();
        if (Game.Time() - (chatVisibleAt || time) > 0.1) {
            $.DispatchEvent("DropInputFocus", chat);
            chatVisibleAt = undefined;
            return;
        }
    });

    SubscribeToNetTableKey("main", "gameState", true, function(data) {
        if (data.state == GAME_STATE_HERO_SELECTION) {
            hudChat.style.y = "0px";
        } else {
            hudChat.style.y = "-350px";
        }
    });
}

SetupUI();
SetupChat();

DelayStateInit(GAME_STATE_ROUND_IN_PROGRESS, function () {
    SubscribeToNetTableKey("main", "debug", true, DebugUpdate);
    SubscribeToNetTableKey("static", "heroes", true, HeroesUpdate);
    SubscribeToNetTableKey("main", "gameState", true, GameStateChanged);
    SubscribeToNetTableKey("main", "gameInfo", true, GameInfoChanged);
    SubscribeToNetTableKey("main", "players", true, DeathMatch.PlayersUpdated);
    SubscribeToNetTableKey("main", "players", true, UpdateLocalNewPlayer);

    UpdateUI();

    GameEvents.Subscribe("cooldown_error", function(data) {
        var eventData = { reason: 15, message: "dota_hud_error_ability_in_cooldown" };
        GameEvents.SendEventClientSide("dota_hud_error_message", eventData);
    });

    GameEvents.Subscribe("custom_chat_wheel", function(data) {
        AddChatLine(data.hero, data.playerName, data.color, data.message, data.team, false, false, true);
    });

    GameEvents.Subscribe("custom_chat_say", OnCustomChatSay);
    GameEvents.Subscribe("custom_system_message", OnCustomSystemMessage);
    GameEvents.Subscribe("kill_log_entry", OnKillLogEntry);
    GameEvents.Subscribe("kill_message", OnKillMessage);
    GameEvents.Subscribe("dm_respawn_event", DeathMatch.OnRespawn);
    GameEvents.Subscribe("dm_death_event", DeathMatch.OnDeath);

    var localInfo = Game.GetPlayerInfo(Game.GetLocalPlayerID()) || {};
    var localTeam = localInfo.player_team_id || -1;
    var spectator = localTeam == -1;

    if (!spectator) {
        GameUI.SetMouseCallback(MouseCallback);
    }

    // HAX
    var top = $.GetContextPanel().GetParent().GetParent().GetParent();
    var channel = top.FindChild("ChannelBar");

    channel.FindChildTraverse("BuffIcon").style.visibility = "collapse";
    channel.FindChildTraverse("IconBorder").style.visibility = "collapse";
    channel.FindChildTraverse("ChannelBarChannel").style.marginLeft = "0px";
});