/**
 * Many thanks to Arhowk for his original talent manager which was used as reference
 * https://github.com/Arhowk/TalentManager/blob/master/content/panorama/scripts/talent_manager/talent_manager.js
 */

//Timer for talent window to close when user selects another unit
var _current_window_check_timer = null;

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

function CloseIMBATalentWindowWhenDeselectUnit(){
    var talentWindow = $.GetContextPanel();
    var ATTRIBUTE_UNIT_ID = "open_unit_id";

    //Remove schedule reference
    _current_window_check_timer = null;

    if(Players.GetLocalPlayerPortraitUnit() != talentWindow.GetAttributeInt(ATTRIBUTE_UNIT_ID, -1)){
        //Force close window if player selects another unit
        ToggleIMBATalentWindow();
    }else{
        //Rerun this check until window is force closed or stopped by the other function
        _current_window_check_timer = $.Schedule(0.1, CloseIMBATalentWindowWhenDeselectUnit);
    }
}

function LocalizeTalentName(talent_name){
    var prefix = "DOTA_Tooltip_ability_";
    var localized_name = $.Localize(prefix + talent_name);

    if(localized_name !== prefix + talent_name){
		return localized_name;
	}else{
		return $.Localize(talent_name);
    }
}

function PopulateIMBATalentWindow(){
    var talentPanel = $.GetContextPanel()

    //Do for selected hero, not hero that player owns
    var currentShownUnitID = Players.GetLocalPlayerPortraitUnit()
    if(Entities.IsValidEntity(currentShownUnitID) && Entities.IsRealHero(currentShownUnitID)){

        //Note that hero_talent_list only populates for heroes picked by players (will not work for -createhero)
        var heroTalentList = CustomNetTables.GetTableValue("imba_talent_manager", "hero_talent_list_"+currentShownUnitID )

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

                    for(var k=0; k<numOfChoices; k++){
                        var TalentChoiceID = "Talent_Choice_"+currentRowLevel+"_"+k;
                        var TalentChoicePanel = talentPanel.FindChildTraverse(TalentChoiceID);
                        var TalentChoiceData = heroTalentList[currentRowLevel][k+1]; //Lua tables start at index 1
                        if(TalentChoicePanel){
                            var labelChoiceText = TalentChoicePanel.FindChild("IMBA_Talent_Choice_Text");
                            if(labelChoiceText){
                                if(TalentChoiceData){
                                    labelChoiceText.text = LocalizeTalentName(TalentChoiceData);
                                }else{
                                    labelChoiceText.text = "ERR";
                                }
                            }

                            var imageChoiceContainer = TalentChoicePanel.FindChild("IMBA_Talent_Choice_Image_Container");
                            if(imageChoiceContainer){
                                //Remove old data
                                imageChoiceContainer.RemoveAndDeleteChildren();
                                //Special talents will be abilities
                                //Generic stat talents will be modifiers

                                //TODO populate images of generic talent
                                //TODO populate linked ability of special talent
                            }

                            //TODO add tooltip
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

//TODO check if using hotkey could level up the talents of the hidden default talent UI
//TODO when user click on talent, inform server which will inform client of what was successfully learnt
//TODO animate imba talent button

