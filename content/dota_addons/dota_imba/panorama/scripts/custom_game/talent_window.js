/**
 * Many thanks to Arhowk for his original talent manager which was used as reference
 * https://github.com/Arhowk/TalentManager/blob/master/content/panorama/scripts/talent_manager/talent_manager.js
 */

//Timer for talent window to close when user selects another unit
var _current_show_all_text_timer = null;
//Integer to remove "selectable" class from talent choice panel
var _current_ability_points = 0;

var ATTRIBUTE_UNIT_ID = "open_unit_id";
var TALENT_TABLE_NAME = "imba_talent_manager";
var OPEN_TALENT_WINDOW_CLASS = "show_talent_window";

function GetHUDRootUI(){
    var rootUI = $.GetContextPanel();
    while(rootUI.id != "Hud" && rootUI.GetParent() != null){
        rootUI = rootUI.GetParent();
    }
    return rootUI;
}

function GetDefaultTalentWindowPanel(){
    return GetHUDRootUI().FindChildTraverse("statbranchdialog");
}

function GetDefaultTalentButton(){
    return GetHUDRootUI().FindChildTraverse("AbilitiesAndStatBranch").FindChildTraverse("StatBranch");
}

function GetDefaultTalentButtonExtFrame(){
    return GetHUDRootUI().FindChildTraverse("level_stats_frame");
}

function HidePanel(panel){
    panel.style.visibility = "collapse;";
    panel.hittest = false;
    panel.enabled = false;
}

function HideDefaultDotaTalentWidgets(){
    $.Msg("HideDefaultDotaTalentWidgets");
    HidePanel(GetDefaultTalentButton()); //Button on HUD
    HidePanel(GetDefaultTalentWindowPanel()); //Window that shows up when you click the button
    HidePanel(GetDefaultTalentButtonExtFrame()); //Frame that glows on the button when you level up
}

function ConvertRowToLevelRequirement(row){
    return (40-(row*5));
}

function InitializeIMBATalentWindow(){
    //Initialize panels for the talent window (without information)

    var talentPanel = $.GetContextPanel()
    //Clear existing children first
    talentPanel.RemoveAndDeleteChildren();

    var headerText = $.CreatePanel("Label", talentPanel, "");
    headerText.AddClass("header");
    headerText.text = $.Localize("talent_window_header");

    //Ignore if max_level for heroes are more than or less than 40, we will still show the full 8 rows
    for(var i=0; i<8; i++){
        var currentRowLevel = ConvertRowToLevelRequirement(i);
        var newTalentRowID = "Talent_Row_"+currentRowLevel;
        var newTalentRow = $.CreatePanel("Panel", talentPanel, newTalentRowID);
        newTalentRow.BLoadLayout("file://{resources}/layout/custom_game/talent_window_row.xml", false, false);

        var labelLevel = newTalentRow.FindChildTraverse("IMBA_Talent_Level");
        if(labelLevel){
            labelLevel.text = ""+currentRowLevel;
        }

        var panelSpecials = newTalentRow.FindChildTraverse("IMBA_Talent_Specials_Row");

        if(panelSpecials){
            var numOfChoices;
            var extraClass;
            if((i%2)==0){
                //Special talents
                numOfChoices = 2;
                extraClass = "two_choices";
            }else{
                //Stat talents
                numOfChoices = 6;
                extraClass = "six_choices";
            }

            newTalentRow.AddClass(extraClass);

            for(var k=0; k<numOfChoices; k++){
                var newTalentChoiceID = "Talent_Choice_"+currentRowLevel+"_"+k;
                var newTalentChoice = $.CreatePanel("Panel", panelSpecials, newTalentChoiceID);
                newTalentChoice.BLoadLayout("file://{resources}/layout/custom_game/talent_window_choice.xml", false, false);
                newTalentChoice.AddClass(extraClass);
            }
        }
    }

    var footerText = $.CreatePanel("Label", talentPanel, "");
    footerText.AddClass("footer");
    footerText.text = $.Localize("talent_window_footer");
}

function GetGenericTalentInfoTable(){
    return CustomNetTables.GetTableValue(TALENT_TABLE_NAME, "imba_generic_talent_info");
}

function GetHeroTalentChoicesTable(hero_id){
    return CustomNetTables.GetTableValue(TALENT_TABLE_NAME, "hero_talent_choice_"+hero_id );
}

function GetImbaTalentButtonOverlayPanel(){
    var baseUI = GetHUDRootUI();
    baseUI = baseUI.FindChildTraverse("AbilitiesAndStatBranch");
    return baseUI.FindChildTraverse("IMBA_Talent_HUD_Button_Overlay");
}

function IsImbaTalentWindowVisible(){
    var talentWindow = $.GetContextPanel();
    return talentWindow.BHasClass("preview") || talentWindow.BHasClass("show_talent_window");
}

function CanHeroUpgradeAnyTalents(hero_id){
    if(Entities.GetAbilityPoints(hero_id) > 0){
        //Check if there are talents left to upgrade
        var heroTalentChoices = GetHeroTalentChoicesTable(hero_id);

        if(heroTalentChoices){
            var currentHeroLevel = Entities.GetLevel(hero_id);

            for(var i=0; i<8; i++){
                var currentRowLevel = ConvertRowToLevelRequirement(i);
                if(currentRowLevel <= currentHeroLevel && heroTalentChoices[currentRowLevel] < 0){
                    return true;
                }
            }
        }
    }

    return false;
}

function OnTalentChoiceUpdated(table_name, key, value){
    if(key.indexOf("hero_talent_choice_") == 0){

        var bol_to_animate_btn = true;
        if(IsImbaTalentWindowVisible()){
            //Update UI
            PopulateIMBATalentWindow();

            //Ensure that player is still selecting the same unit that was updated
            var currentShownUnitID = Players.GetLocalPlayerPortraitUnit();
            var talentWindow = $.GetContextPanel();
            if(currentShownUnitID == talentWindow.GetAttributeInt(ATTRIBUTE_UNIT_ID, -1)){
                if(Entities.GetAbilityPoints(currentShownUnitID) <= 1 || //Note that this is <= 1 because it takes time for server to update the abilityPoints
                    !CanHeroUpgradeAnyTalents(currentShownUnitID)){
                    //Close window if hero no longer has ability points
                    OpenImbaTalentWindow(false);

                    //Force remove .upgrade class
                    var imbaBtnOverlay = GetImbaTalentButtonOverlayPanel();
                    //Should not be null as you need it to open talent window
                    imbaBtnOverlay.RemoveClass("upgrade");
                    bol_to_animate_btn = false;
                }
            }
        }

        if(bol_to_animate_btn){
            AnimateImbaTalentButton();
        }
    }
}

function CloseIMBATalentWindowWhenDeselectUnit(){
    var talentWindow = $.GetContextPanel();

    var currentShownUnitID = Players.GetLocalPlayerPortraitUnit();

    if(currentShownUnitID != talentWindow.GetAttributeInt(ATTRIBUTE_UNIT_ID, -1)){
        //Force close window if player selects another unit
        _current_ability_points = 0;
        OpenImbaTalentWindow(false);
    }
}

function RepopulateImbaTalentWindowOnAbilityPointsChanged(){
    var talentWindow = $.GetContextPanel();
    var currentShownUnitID = Players.GetLocalPlayerPortraitUnit();
    if(currentShownUnitID == talentWindow.GetAttributeInt(ATTRIBUTE_UNIT_ID, -1)){
        //Update talent window when user spends/gains ability points
        if(Entities.IsValidEntity(currentShownUnitID) && Entities.IsRealHero(currentShownUnitID)){
            if(_current_ability_points != Entities.GetAbilityPoints(currentShownUnitID)){
                PopulateIMBATalentWindow();
            }
        }
    }
}

function AnimateImbaTalentButton(){
    var imbaBtnOverlay = GetImbaTalentButtonOverlayPanel();

    //Might not be created yet
    if(imbaBtnOverlay){
        var currentShownUnitID = Players.GetLocalPlayerPortraitUnit();

        if(Entities.IsValidEntity(currentShownUnitID) &&
            Entities.IsRealHero(currentShownUnitID) &&
            Entities.IsControllableByPlayer(currentShownUnitID, Players.GetLocalPlayer())){

            imbaBtnOverlay.SetHasClass("upgrade", CanHeroUpgradeAnyTalents(currentShownUnitID));
        }else{
            imbaBtnOverlay.RemoveClass("upgrade");
        }
    }
}

function HandleShowAllTextTimer(){
    var talentWindow = $.GetContextPanel();
    talentWindow.SetHasClass("show_all_text", GameUI.IsAltDown());

    if(talentWindow.BHasClass("preview") || talentWindow.BHasClass("show_talent_window")){
        _current_show_all_text_timer = $.Schedule(0.1, HandleShowAllTextTimer);
    }else{
        _current_show_all_text_timer = null;
    }
}

function ShowAllTextWhenTalentWindowVisibleAndAltIsDown(){
    if(_current_show_all_text_timer == null){
        HandleShowAllTextTimer();
    }
}

function FormatGenericTalentValue(talent_name, talent_value){
    switch(talent_name){
        case "imba_generic_talent_magic_resistance":
        case "imba_generic_talent_evasion":
        case "imba_generic_talent_attack_life_steal":
        case "imba_generic_talent_spell_life_steal":
        case "imba_generic_talent_spell_power":
        case "imba_generic_talent_cd_reduction":
        case "imba_generic_talent_bonus_xp":
            return "+"+talent_value+"%";
        case "imba_generic_talent_respawn_reduction":
            return talent_value;
        default:
            return "+"+talent_value;
    }
}

function GetTalentLabelText(talent_name, rowLevelIndex){

    //Add more label text if it is a generic imba talent
    var generic_talent_table = GetGenericTalentInfoTable();
    var talent_data = generic_talent_table[talent_name];

    if(talent_data && talent_data.value){
        //Generic Talent
        return $.Localize(talent_name)+"\n"+FormatGenericTalentValue(talent_name, talent_data.value.split(" ")[rowLevelIndex]);
    }else{
        //Ability talent
        return $.Localize("DOTA_Tooltip_ability_" + talent_name); //This is consistent with default dota talent localization
    }
}

function CreateImagePanelForTalent(talent_name, parent_panel, hero_id){
    if(parent_panel != null){

        //Check using generic talent table first
        var generic_talent_table = GetGenericTalentInfoTable();
        var generic_talent_image_path = null;
        if(generic_talent_table != null){
            if(generic_talent_table[talent_name] != null){
                generic_talent_image_path = generic_talent_table[talent_name].icon
            }
        }

        if(generic_talent_image_path != null){
            //Create panel with icon
            var imagePanel = $.CreatePanel('Image', parent_panel, '');
            imagePanel.SetImage(generic_talent_image_path);
        }else{
            //Search for linked ability
            var linked_ability_table = CustomNetTables.GetTableValue(TALENT_TABLE_NAME, "talent_linked_abilities")
            var linked_abilities_list = linked_ability_table[talent_name]
            if(linked_abilities_list){

                var numOfLinkedAbilities = Object.keys(linked_abilities_list).length;
                if(numOfLinkedAbilities == 1){
                    var imagePanel = $.CreatePanel('DOTAAbilityImage', parent_panel, '');
                    imagePanel.abilityname = linked_abilities_list[1]; //Lua starts at 1
                }else{
                    var abilityContainerPanel = $.CreatePanel('Panel', parent_panel, '');

                    for(var index in linked_abilities_list){
                        var imagePanel = $.CreatePanel('DOTAAbilityImage', abilityContainerPanel, '');
                        imagePanel.abilityname = linked_abilities_list[index];

                        //3 abilites is the max that can fit into the box, hence we will be doing some css hack to 
                        if(index == 2 && numOfLinkedAbilities == 3){
                            imagePanel.AddClass("fix_cluster");
                        }
                    }
                }
            }else{
                //Set default image as hero protrait
                var heroPanel = $.CreatePanel('DOTAHeroImage', parent_panel, '');
                heroPanel.heroimagestyle = "landscape";
                heroPanel.heroname = Entities.GetUnitName(hero_id);
            }
        }
    }
}

function ConfigureTalentClick(panel, heroID, level, luaIndex){
    //This simple function is made into a function as it is located in a 'for' loop which will overwrite the referenced values unless placed in a function

    //Create data outside of event
    panel.SetPanelEvent("onactivate", function(){
        GameEvents.SendCustomGameEventToServer("upgrade_imba_talent", {
            "heroID" : heroID,
            "level" : level,
            "index" : luaIndex
        });
    });

    panel.hittest = true;
}

function AttachToolTip(ability_panel, talent_name, rowLevelIndex){
    ability_panel.ClearPanelEvent("onmouseover");
    ability_panel.ClearPanelEvent("onmouseout");

    var title;
    var description;

    var generic_talent_table = GetGenericTalentInfoTable();
    var talent_data = generic_talent_table[talent_name];

    if(talent_data){
        title = $.Localize(talent_name);
        if(talent_data.value){
            description = FormatGenericTalentValue(talent_name, talent_data.value.split(" ")[rowLevelIndex]);
        }
    }else{
        //Note that the localized strings are to be located in /game/dota_addons/dota_imba/panorama/localization, this is different from localization of abilities
        var prefix = "Dota_Tooltip_talent_" + talent_name;
        var title_key = prefix + "_title";
        title = $.Localize(title_key);
        if(title != title_key){
            //Localization exist
            description = $.Localize(prefix + "_Description");
        }else{
            //Fallback to the default text
            title = "";
            description = $.Localize("DOTA_Tooltip_ability_" + talent_name);
        }
    }

    if(title){
        ability_panel.SetPanelEvent("onmouseover", function(){
            $.DispatchEvent("DOTAShowTitleTextTooltip", ability_panel, title, description);
        });
        ability_panel.SetPanelEvent("onmouseout", function(){
            $.DispatchEvent("DOTAHideTitleTextTooltip");
        });
    }else{
        //Fall back display
        ability_panel.SetPanelEvent("onmouseover", function(){
            $.DispatchEvent("DOTAShowTextTooltip", ability_panel, description);
        });
        ability_panel.SetPanelEvent("onmouseout", function(){
            $.DispatchEvent("DOTAHideTextTooltip");
        });
    }
}

function PopulateIMBATalentWindow(){
    var talentPanel = $.GetContextPanel()

    talentPanel.SetHasClass("show_all_text", GameUI.IsAltDown());

    //Do for selected hero, not hero that player owns
    var currentShownUnitID = Players.GetLocalPlayerPortraitUnit()
    if(Entities.IsValidEntity(currentShownUnitID) && Entities.IsRealHero(currentShownUnitID)){

        var currentAbilityPoints = Entities.GetAbilityPoints(currentShownUnitID);
        var currentUnitLevel = Entities.GetLevel(currentShownUnitID);
        var isControllableByPlayer = Entities.IsControllableByPlayer(currentShownUnitID, Players.GetLocalPlayer());

        //Keep reference of the current ability points
        _current_ability_points = currentAbilityPoints;

        //Note that hero_talent_list only populates for heroes picked by players (will not work for -createhero)
        var heroTalentList = CustomNetTables.GetTableValue(TALENT_TABLE_NAME, "hero_talent_list_"+currentShownUnitID );
        var heroTalentChoices = GetHeroTalentChoicesTable(currentShownUnitID);
        var generic_talent_table = GetGenericTalentInfoTable();

        if(heroTalentList){
            for(var i=0; i<8; i++){
                var currentRowLevel = ConvertRowToLevelRequirement(i);

                if(heroTalentList[currentRowLevel]){
                    var numOfChoices;
                    if((i%2)==0){
                        //Special talents
                        numOfChoices = 2;
                    }else{
                        //Stat talents
                        numOfChoices = 6;
                    }

                    var rowLevelIndex = (currentRowLevel-5)/10;

                    for(var k=0; k<numOfChoices; k++){
                        var luaIndex = k+1; //Lua tables start at index 1
                        var TalentChoiceID = "Talent_Choice_"+currentRowLevel+"_"+k;
                        var TalentChoicePanel = talentPanel.FindChildTraverse(TalentChoiceID);
                        var TalentChoiceData = heroTalentList[currentRowLevel][luaIndex];
                        if(TalentChoicePanel){
                            var labelChoiceText = TalentChoicePanel.FindChildTraverse("IMBA_Talent_Choice_Text");
                            if(labelChoiceText){
                                if(TalentChoiceData){
                                    labelChoiceText.text = GetTalentLabelText(TalentChoiceData, rowLevelIndex);
                                }else{
                                    labelChoiceText.text = "ERR";
                                }
                            }

                            var imageChoiceContainer = TalentChoicePanel.FindChild("IMBA_Talent_Choice_Image_Container");
                            if(imageChoiceContainer){
                                var currentRowChoiceIndex = heroTalentChoices[currentRowLevel];

                                TalentChoicePanel.RemoveClass("selectable");
                                TalentChoicePanel.RemoveClass("upgraded");
                                TalentChoicePanel.RemoveClass("disabled");
                                //Remove onClick event
                                TalentChoicePanel.hittest = false;
                                TalentChoicePanel.ClearPanelEvent("onactivate");

                                if(currentRowChoiceIndex >= 0){

                                    if(currentRowChoiceIndex == luaIndex){
                                        //Add .upgraded class to TalentChoicePanel if user has upgraded the index
                                        TalentChoicePanel.AddClass("upgraded");
                                    }else{
                                        //Add .disabled class to TalentChoicePanel if user has already upgraded the row but not the index
                                        TalentChoicePanel.AddClass("disabled");
                                    }

                                }else if(currentUnitLevel >= currentRowLevel &&
                                        currentAbilityPoints > 0 &&
                                        isControllableByPlayer){
                                    //Only selectable if entity has the right level and has an ability point to spend

                                    //Add .selectable class to TalentChoicePanel if user has not upgraded the row of talents
                                    TalentChoicePanel.AddClass("selectable");
                                    ConfigureTalentClick(TalentChoicePanel, currentShownUnitID, currentRowLevel, luaIndex);
                                }

                                //Remove old images
                                imageChoiceContainer.RemoveAndDeleteChildren();
                                //Special talents will be abilities
                                //Generic stat talents will be modifiers
                                CreateImagePanelForTalent(TalentChoiceData, imageChoiceContainer, currentShownUnitID);

                                var firstChild = imageChoiceContainer.GetChild(0);
                                if(firstChild){
                                    //Attach tooltip to first direct child
                                    AttachToolTip(firstChild, TalentChoiceData, rowLevelIndex);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

function OpenImbaTalentWindow(bol_open){

    var currentShownUnitID = Players.GetLocalPlayerPortraitUnit();
    var localPlayerID = Players.GetLocalPlayer();

    //check if valid
    if(!bol_open || (Entities.IsValidEntity(currentShownUnitID) &&
            Entities.IsRealHero(currentShownUnitID) &&
            Entities.IsControllableByPlayer(currentShownUnitID, localPlayerID))){

        var talentWindow = $.GetContextPanel();

        var btnOverlay = GetImbaTalentButtonOverlayPanel();

        if(bol_open){
            talentWindow.SetAttributeInt(ATTRIBUTE_UNIT_ID, currentShownUnitID);
            PopulateIMBATalentWindow();
            talentWindow.AddClass(OPEN_TALENT_WINDOW_CLASS);
            CloseIMBATalentWindowWhenDeselectUnit();
            btnOverlay.AddClass("selected");
        }else{
            talentWindow.SetAttributeInt(ATTRIBUTE_UNIT_ID, -1);
            talentWindow.RemoveClass(OPEN_TALENT_WINDOW_CLASS);
            btnOverlay.RemoveClass("selected");
        }

        talentWindow.RemoveClass("preview");

        ShowAllTextWhenTalentWindowVisibleAndAltIsDown();
    }
}

function ToggleIMBATalentWindow(){
    var talentWindow = $.GetContextPanel();
    OpenImbaTalentWindow(!talentWindow.BHasClass(OPEN_TALENT_WINDOW_CLASS));
}

function InsertIMBATalentButton(){
    $.Msg("InsertIMBATalentButton");
    var baseUI = GetHUDRootUI();
    baseUI = baseUI.FindChildTraverse("AbilitiesAndStatBranch");
    var IMBA_TALENT_BTN_ID = "ImbaTalentBtn";
    var newButton = baseUI.FindChildTraverse(IMBA_TALENT_BTN_ID);
    if(newButton){
        //Remove existing button
        newButton.DeleteAsync(0);
    }
    var oldButton = baseUI.FindChildTraverse("StatBranch");
    var newButton = $.CreatePanel("Panel", baseUI, IMBA_TALENT_BTN_ID);
    newButton.BLoadLayout("file://{resources}/layout/custom_game/talent_hud_panel.xml", false, false);
    baseUI.MoveChildAfter(newButton, oldButton);

    var talentWindow = $.GetContextPanel();

    var PREVIEW_CLASS = "preview";

    newButton.SetPanelEvent("onmouseover", function(){
        //Show talent window
        //Allow preview even if it is an illusion/clone
        PopulateIMBATalentWindow();
        talentWindow.AddClass(PREVIEW_CLASS)
        ShowAllTextWhenTalentWindowVisibleAndAltIsDown();
    });

    newButton.SetPanelEvent("onmouseout", function(){
        //Close talent window
        //Allow preview even if it is an illusion/clone
        talentWindow.RemoveClass(PREVIEW_CLASS)
    });

    newButton.SetPanelEvent("onactivate", ToggleIMBATalentWindow);
}

//////////////////////////////
//      Initialization      //
//////////////////////////////

//Perform overriding after delay to avoid modifying/populating paranoma at the same time as the custom pick screen
$.Schedule(1, HideDefaultDotaTalentWidgets);
$.Schedule(2, InsertIMBATalentButton);
$.Schedule(2, InitializeIMBATalentWindow);
//Listen to talent choice updates
//WARNING: This will allow cheating where clients can actually know what talents the other team has picked
CustomNetTables.SubscribeNetTableListener( TALENT_TABLE_NAME, OnTalentChoiceUpdated );

//////////////////////////////
//      Event handling      //
//////////////////////////////

function OnPlayerGainedLevel(data){
    //data contains PlayerID, level
    RepopulateImbaTalentWindowOnAbilityPointsChanged();
    AnimateImbaTalentButton();
}

function OnPlayerLearnedAbility(data){
    //data contains PlayerID, abilityname
    RepopulateImbaTalentWindowOnAbilityPointsChanged();
    AnimateImbaTalentButton();
}

function OnPlayerUpdateQueryUnit(){
    //Data given is the legacy data 'splitscreenplayer' only
    AnimateImbaTalentButton();
    CloseIMBATalentWindowWhenDeselectUnit();
}

function OnPlayerUpdateSelectedUnit(){
    AnimateImbaTalentButton();
    CloseIMBATalentWindowWhenDeselectUnit();
}

GameEvents.Subscribe("dota_player_gained_level", OnPlayerGainedLevel);
GameEvents.Subscribe("dota_player_learned_ability", OnPlayerLearnedAbility);
GameEvents.Subscribe("dota_player_update_query_unit", OnPlayerUpdateQueryUnit);
GameEvents.Subscribe("dota_player_update_selected_unit", OnPlayerUpdateSelectedUnit);

//TODO check if using hotkey could level up the talents of the hidden default talent UI


