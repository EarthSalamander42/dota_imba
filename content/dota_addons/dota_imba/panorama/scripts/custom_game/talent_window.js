/**
 * Many thanks to Arhowk for his original talent manager which was used as reference
 * https://github.com/Arhowk/TalentManager/blob/master/content/panorama/scripts/talent_manager/talent_manager.js
 */

//Timer for talent window to close when user selects another unit
var _current_window_check_timer = null;
//Integer to remove "selectable" class from talent choice panel
var _current_ability_points = 0;

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

function InitializeIMBATalentWindow(){
    //Initialize panels for the talent window (without information)

    var talentPanel = $.GetContextPanel()
    //Clear existing children first
    talentPanel.RemoveAndDeleteChildren();

    //Ignore if max_level for heroes are more than or less than 40, we will still show the full 8 rows
    for(var i=0; i<8; i++){
        var currentRowLevel = (40-(i*5));
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
}

function OnTalentChoiceUpdated(table_name, key, value){
    if(key.indexOf("hero_talent_choice_") == 0){
        var talentWindow = $.GetContextPanel();
        if(talentWindow.BHasClass("preview") || talentWindow.BHasClass("show_talent_window")){
            //Update UI
            PopulateIMBATalentWindow();
        }
    }
}

function CloseIMBATalentWindowWhenDeselectUnit(){
    var talentWindow = $.GetContextPanel();
    var ATTRIBUTE_UNIT_ID = "open_unit_id";

    //Remove schedule reference
    _current_window_check_timer = null;
    var currentShownUnitID = Players.GetLocalPlayerPortraitUnit()

    if(currentShownUnitID != talentWindow.GetAttributeInt(ATTRIBUTE_UNIT_ID, -1)){
        //Force close window if player selects another unit
        _current_ability_points = 0;
        ToggleIMBATalentWindow();
    }else{
        //Update talent window when user spends/gains ability points
        if(Entities.IsValidEntity(currentShownUnitID) && Entities.IsRealHero(currentShownUnitID)){
            if(_current_ability_points != Entities.GetAbilityPoints(currentShownUnitID)){
                PopulateIMBATalentWindow();
            }
        }

        //Rerun this check until window is force closed or stopped by the other function
        _current_window_check_timer = $.Schedule(0.1, CloseIMBATalentWindowWhenDeselectUnit);
    }
}

function LocalizeTalentName(talent_name){
    var prefix = "DOTA_Tooltip_ability_";
    var localized_name = $.Localize(prefix + talent_name);

    if(localized_name !== prefix + talent_name){
        //For ability names
		return localized_name;
	}else{
        //For generic talent names
		return $.Localize(talent_name);
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

function CreateImagePanelForTalent(talent_name, parent_panel, hero_id){
    if(parent_panel != null){

        //Check using generic talent table first
        var generic_talent_table = CustomNetTables.GetTableValue("imba_talent_manager", "imba_generic_talent_info");
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
            var linked_ability_table = CustomNetTables.GetTableValue("imba_talent_manager", "talent_linked_abilities")
            var linked_abilities_list = linked_ability_table[talent_name]
            if(linked_abilities_list){

                if(Object.keys(linked_abilities_list).length == 1){
                    var imagePanel = $.CreatePanel('DOTAAbilityImage', parent_panel, '');
                    imagePanel.abilityname = linked_abilities_list[1]; //Lua starts at 1
                    imagePanel.style.align = "center center";
                }else{
                    var abilityContainerPanel = $.CreatePanel('Panel', parent_panel, '');
                    abilityContainerPanel.style.align = "center center";
                    abilityContainerPanel.style.flowChildren = "right";

                    for(var index in linked_abilities_list){
                        var imagePanel = $.CreatePanel('DOTAAbilityImage', abilityContainerPanel, '');
                        imagePanel.abilityname = linked_abilities_list[index];
                    }
                }
            }else{
                //Set default image as hero protrait
                var heroPanel = $.CreatePanel('DOTAHeroImage', parent_panel, '');
                heroPanel.heroimagestyle = "landscape";
                heroPanel.heroname = Entities.GetUnitName(hero_id);
                heroPanel.style.align = "center center";
                //128x72 landscape default size
                heroPanel.style.height = "100px"; //height will be 100px for the image
                heroPanel.style.width = "177px"; //128 * (100/72)
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

//TODO remove if no longer needed
function AttachToolTip(ability_panel, ability_text){
    ability_panel.ClearPanelEvent("onmouseover");
    ability_panel.ClearPanelEvent("onmouseout");

    ability_panel.SetPanelEvent("onmouseover", function(){
         $.DispatchEvent("DOTAShowTitleTextTooltip", ability_panel, "title test", ability_text);
    });
    ability_panel.SetPanelEvent("onmouseout", function(){
        $.DispatchEvent("DOTAHideTitleTextTooltip");
    });
}

function PopulateIMBATalentWindow(){
    var talentPanel = $.GetContextPanel()

    //Do for selected hero, not hero that player owns
    var currentShownUnitID = Players.GetLocalPlayerPortraitUnit()
    if(Entities.IsValidEntity(currentShownUnitID) && Entities.IsRealHero(currentShownUnitID)){
        //Keep reference of the current ability points
        _current_ability_points = Entities.GetAbilityPoints(currentShownUnitID);

        //Note that hero_talent_list only populates for heroes picked by players (will not work for -createhero)
        var heroTalentList = CustomNetTables.GetTableValue("imba_talent_manager", "hero_talent_list_"+currentShownUnitID );
        var heroTalentChoices = CustomNetTables.GetTableValue("imba_talent_manager", "hero_talent_choice_"+currentShownUnitID );
        var generic_talent_table = CustomNetTables.GetTableValue("imba_talent_manager", "imba_generic_talent_info");

        if(heroTalentList){
            for(var i=0; i<8; i++){
                var currentRowLevel = (40-(i*5));

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
                                    var displayText = LocalizeTalentName(TalentChoiceData)
                                    if(generic_talent_table[TalentChoiceData] && generic_talent_table[TalentChoiceData].value){
                                        displayText += "\n"+FormatGenericTalentValue(TalentChoiceData, generic_talent_table[TalentChoiceData].value.split(" ")[rowLevelIndex]);
                                    }
                                    labelChoiceText.text = displayText;
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

                                }else if(Entities.GetLevel(currentShownUnitID) >= currentRowLevel && Entities.GetAbilityPoints(currentShownUnitID) > 0){
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
                            }
                        }
                    }
                }
            }
        }
    }
}

function ToggleIMBATalentWindow(){
    var talentWindow = $.GetContextPanel();
    var OPEN_TALENT_WINDOW_CLASS = "show_talent_window";
    var ATTRIBUTE_UNIT_ID = "open_unit_id";

    //Toggle open/close of talent window
    var currentShownUnitID = Players.GetLocalPlayerPortraitUnit();
    var localPlayerID = Players.GetLocalPlayer();

    var bol_open_window = false;

    if(!talentWindow.BHasClass(OPEN_TALENT_WINDOW_CLASS)){
        if(Entities.IsValidEntity(currentShownUnitID) &&
            Entities.IsRealHero(currentShownUnitID) && 
            Entities.IsControllableByPlayer(currentShownUnitID, localPlayerID)){
            bol_open_window = true;
        }
    }

    if(_current_window_check_timer){
        $.CancelScheduled(_current_window_check_timer);
        _current_window_check_timer = null;
    }

    if(bol_open_window){
        talentWindow.SetAttributeInt(ATTRIBUTE_UNIT_ID, currentShownUnitID);
        PopulateIMBATalentWindow();
        talentWindow.AddClass(OPEN_TALENT_WINDOW_CLASS);
        CloseIMBATalentWindowWhenDeselectUnit();
    }else{
        talentWindow.RemoveClass(OPEN_TALENT_WINDOW_CLASS);
        talentWindow.SetAttributeInt(ATTRIBUTE_UNIT_ID, -1);
    }

    talentWindow.RemoveClass("preview");
}



function InsertIMBATalentButton(){
    $.Msg("InsertIMBATalentButton");
    var baseUI = GetHUDRootUI();
    baseUI = baseUI.FindChildTraverse("AbilitiesAndStatBranch");
    var IMBA_TALENT_BTN_ID = "ImbaTalentBtn"
    var newButton = baseUI.FindChildTraverse(IMBA_TALENT_BTN_ID)
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
    });

    newButton.SetPanelEvent("onmouseout", function(){
        //Close talent window
        //Allow preview even if it is an illusion/clone
        talentWindow.RemoveClass(PREVIEW_CLASS)
    });

    newButton.SetPanelEvent("onactivate", ToggleIMBATalentWindow);
}

//Perform overriding after delay to avoid modifying/populating paranoma at the same time as the custom pick screen
$.Schedule(1, HideDefaultDotaTalentWidgets);
$.Schedule(2, InsertIMBATalentButton);
$.Schedule(2, InitializeIMBATalentWindow);
//Listen to talent choice updates
//WARNING: This will allow cheating where clients can actually know what talents the other team has picked
CustomNetTables.SubscribeNetTableListener( "imba_talent_manager", OnTalentChoiceUpdated );

//TODO check if using hotkey could level up the talents of the hidden default talent UI
//TODO when user click on talent, inform server which will inform client of what was successfully learnt
//TODO animate imba talent button

