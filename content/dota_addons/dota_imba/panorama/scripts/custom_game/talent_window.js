/**
 * Many thanks to Arhowk for his original talent manager which was used as reference
 * https://github.com/Arhowk/TalentManager/blob/master/content/panorama/scripts/talent_manager/talent_manager.js
 */

//Timer for talent window to close when user selects another unit
var _current_show_all_text_timer = null;
var _current_hover_preview_timer = null;
//Integer to remove "selectable" class from talent choice panel
var _current_ability_points = 0;

var ATTRIBUTE_UNIT_ID = "open_unit_id";
var TALENT_TABLE_NAME = "imba_talent_manager";
var OPEN_TALENT_WINDOW_CLASS = "show_talent_window";
var IMBA_TALENT_BTN_ID = "ImbaTalentBtn";
var MAX_TALENT_ROW_NUM_OF_CHOICES = 8;
var MAX_TALENT_ROWS = 8;
var MAX_NUM_OF_GENERIC_TALENTS = 6;

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
    for(var i=0; i<MAX_TALENT_ROWS; i++){
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
            if((i%2)==0){
                //Imba Special talents = 2, non-imba Special talents = 8
                //Hence first 6 talents on this row will always be generic talents
                numOfChoices = MAX_TALENT_ROW_NUM_OF_CHOICES;
            }else{
                //Generic talents only
                numOfChoices = MAX_NUM_OF_GENERIC_TALENTS;
            }

            for(var k=0; k<numOfChoices; k++){
                var newTalentChoiceID = "Talent_Choice_"+currentRowLevel+"_"+k;
                var newTalentChoice = $.CreatePanel("Panel", panelSpecials, newTalentChoiceID);
                newTalentChoice.BLoadLayout("file://{resources}/layout/custom_game/talent_window_choice.xml", false, false);
            }
        }
    }

    var footerText = $.CreatePanel("Label", talentPanel, "");
    footerText.AddClass("footer");
    footerText.text = $.Localize("talent_window_footer");

    GameEvents.Subscribe("dota_player_gained_level", OnPlayerGainedLevel);
    GameEvents.Subscribe("dota_player_learned_ability", OnPlayerLearnedAbility);
    GameEvents.Subscribe("dota_player_update_query_unit", OnPlayerUpdateQueryUnit);
    GameEvents.Subscribe("dota_player_update_selected_unit", OnPlayerUpdateSelectedUnit);

    GameUI.SetMouseCallback( function( eventName, arg ) {

        var talentWindow = $.GetContextPanel();
        if(talentWindow.BHasClass("show_talent_window") && GameUI.GetClickBehaviors() == CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE){

            if ( eventName == "pressed" ){
                //No matter what button is pressed, if it is outside the bounds of talent window, close the window
                var cursorPos = GameUI.GetCursorPosition();
                if(cursorPos[0] < talentWindow.actualxoffset ||
                    (talentWindow.actualxoffset + talentWindow.contentwidth) < cursorPos[0] ||
                    cursorPos[1] < talentWindow.actualyoffset ||
                    (talentWindow.actualyoffset + talentWindow.contentheight) < cursorPos[1]){

                    OpenImbaTalentWindow(false);
                }
            }
        }

        //Do not consume event
        return false;
    });

    //Enable focus for talent window children (this is to allow catching of Escape button)
    RecurseEnableFocus(talentPanel);

    $.RegisterKeyBind(talentPanel, "key_escape", function(){
        if(talentPanel.BHasClass("show_talent_window")){
            OpenImbaTalentWindow(false);
        }
    });
}

function RecurseEnableFocus(panel){
    panel.SetAcceptsFocus(true);
    var children = panel.Children();
    $.Each(children, function(child){
        RecurseEnableFocus(child);
    });
}

function GetGenericTalentInfoTable(){
    return CustomNetTables.GetTableValue(TALENT_TABLE_NAME, "imba_generic_talent_info");
}

function GetHeroTalentChoicesTable(hero_id){
    return CustomNetTables.GetTableValue(TALENT_TABLE_NAME, "hero_talent_choice_"+hero_id );
}

function GetImbaTalentButtonPanel(){
    var baseUI = GetHUDRootUI();
    baseUI = baseUI.FindChildTraverse("AbilitiesAndStatBranch");
    return baseUI.FindChildTraverse(IMBA_TALENT_BTN_ID);
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

            for(var i=0; i<MAX_TALENT_ROWS; i++){
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

            //Ensure that player is still selecting the same unit that was updated
            var currentShownUnitID = Players.GetLocalPlayerPortraitUnit();
            var talentWindow = $.GetContextPanel();
            if(currentShownUnitID == talentWindow.GetAttributeInt(ATTRIBUTE_UNIT_ID, -1)){

                //Update UI only if it is the currently shown unit
                if(key == "hero_talent_choice_"+currentShownUnitID){
                    //Update UI
                    PopulateIMBATalentWindow();

                    if(Entities.GetAbilityPoints(currentShownUnitID) <= 1 || //Note that this is <= 1 because it takes time for server to update the abilityPoints
                        !CanHeroUpgradeAnyTalents(currentShownUnitID)){
                        //Close window if hero no longer has ability points
                        OpenImbaTalentWindow(false);

                        //Force remove .upgrade class
                        var imbaBtnPanel = GetImbaTalentButtonPanel();
                        //Should not be null as you need it to open talent window
                        imbaBtnPanel.RemoveClass("upgrade");
                        bol_to_animate_btn = false;
                    }
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
    var imbaBtnPanel = GetImbaTalentButtonPanel();

    //Might not be created yet
    if(imbaBtnPanel){
        var currentShownUnitID = Players.GetLocalPlayerPortraitUnit();

        if(Entities.IsValidEntity(currentShownUnitID) &&
            Entities.IsRealHero(currentShownUnitID) &&
            Entities.IsControllableByPlayer(currentShownUnitID, Players.GetLocalPlayer())){

            imbaBtnPanel.SetHasClass("upgrade", CanHeroUpgradeAnyTalents(currentShownUnitID));
        }else{
            imbaBtnPanel.RemoveClass("upgrade");
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

function GetTalentLabelText(talent_name, row_level){

    //Add more label text if it is a generic imba talent
    var talent_value = GetTalentValue(talent_name, row_level);

    if(talent_value){
        //Generic Talent
        return $.Localize(talent_name)+"\n"+FormatGenericTalentValue(talent_name, talent_value);
    }else{
        //Ability talent
        return $.Localize("DOTA_Tooltip_ability_" + talent_name); //This is consistent with default dota talent localization
    }
}

function GetTalentValue(talent_name, row_level){
    var generic_talent_table = GetGenericTalentInfoTable();
    var talent_data = generic_talent_table[talent_name];
    if(talent_data && talent_data.value){
        var rowLevelIndex = (row_level-5)/5;
        return talent_data.value.split(" ")[rowLevelIndex];
    }
    return null;
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


function WhiteWashTalentChoice(rowLevel, columnIndex, bol_enable){
    var talentPanel = $.GetContextPanel();
    var TalentChoiceID = "Talent_Choice_"+rowLevel+"_"+columnIndex;
    var TalentChoicePanel = talentPanel.FindChildTraverse(TalentChoiceID);
    if(TalentChoicePanel){
        var imageChoiceContainer = TalentChoicePanel.FindChild("IMBA_Talent_Choice_Image_Container");
        if(imageChoiceContainer){
            imageChoiceContainer.SetHasClass("white_wash", bol_enable &&
            !imageChoiceContainer.GetParent().BHasClass("upgraded") &&
            !imageChoiceContainer.GetParent().BHasClass("disabled"));
        }
    }
}

function WhiteWashOtherGenericTalent(currentRowLevel, columnIndex, bol_enable){

    for(var i=0; i<MAX_TALENT_ROWS; i++){
        var otherRowLevel = ConvertRowToLevelRequirement(i);
        if(otherRowLevel != currentRowLevel){
            //Only white wash for stat talents
            WhiteWashTalentChoice(otherRowLevel, columnIndex, bol_enable);
        }
    }
}

function WhiteWashOtherCurrentRowChoices(currentRowLevel, columnIndex, bol_enable){
    var talentPanel = $.GetContextPanel();
    //Maximum of 8 columns
    for(var i=0; i<MAX_TALENT_ROW_NUM_OF_CHOICES; i++){
        if(i != columnIndex){
            WhiteWashTalentChoice(currentRowLevel, i, bol_enable);
        }
    }
}

function AttachToolTip(image_container_panel, talent_name, currentRowLevel, columnIndex){

    //Attach tooltip to first direct child
    var ability_panel = image_container_panel.GetChild(0);
    if(ability_panel != null){

        ability_panel.ClearPanelEvent("onmouseover");
        ability_panel.ClearPanelEvent("onmouseout");

        var title;
        var description;

        var talent_value = GetTalentValue(talent_name, currentRowLevel);

        if(talent_value){
            title = $.Localize(talent_name);
            description = FormatGenericTalentValue(talent_name, talent_value);
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

        var isTalent = talent_value != null;
        var shouldShowWhiteWash = image_container_panel.GetParent().BHasClass("selectable");

        ability_panel.SetPanelEvent("onmouseover", function(){
            if(title){
                $.DispatchEvent("DOTAShowTitleTextTooltip", ability_panel, title, description);
            }else{
                $.DispatchEvent("DOTAShowTextTooltip", ability_panel, description);
            }
            if(shouldShowWhiteWash){
                if(isTalent){
                    WhiteWashOtherGenericTalent(currentRowLevel, columnIndex, true);
                }
                WhiteWashOtherCurrentRowChoices(currentRowLevel, columnIndex, true);
            }
        });
        ability_panel.SetPanelEvent("onmouseout", function(){
            if(title){
                $.DispatchEvent("DOTAHideTitleTextTooltip");
            }else{
                $.DispatchEvent("DOTAHideTextTooltip");
            }
            if(isTalent){
                WhiteWashOtherGenericTalent(currentRowLevel, columnIndex, false);
            }
            WhiteWashOtherCurrentRowChoices(currentRowLevel, columnIndex, false);
        });
    }
}

function HasGenericTalentBeenUpgraded(unit_id, column_index){
    var heroTalentChoices = GetHeroTalentChoicesTable(unit_id);
    for(var i=0; i<8; i++){
        var currentRowLevel = ConvertRowToLevelRequirement(i);
        if((column_index+1) == heroTalentChoices[currentRowLevel]){
            return true;
        }
    }
    return false;
}

function PopulateIMBATalentWindow(){
    var talentPanel = $.GetContextPanel();

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
            for(var i=0; i<MAX_TALENT_ROWS; i++){
                var currentRowLevel = ConvertRowToLevelRequirement(i);

                if(heroTalentList[currentRowLevel]){
                    var numOfChoicesToProcess;
                    if((i%2)==0){
                        //Special talents
                        numOfChoicesToProcess = MAX_TALENT_ROW_NUM_OF_CHOICES;
                    }else{
                        //Stat talents
                        numOfChoicesToProcess = MAX_NUM_OF_GENERIC_TALENTS;
                    }

                    var TalentRow = talentPanel.FindChildTraverse("Talent_Row_"+currentRowLevel);
                    if(TalentRow){
                        var numOfTalentsInThisRow = Object.keys(heroTalentList[currentRowLevel]).length;
                        TalentRow.SetHasClass("six_choices", numOfTalentsInThisRow == 6);
                        TalentRow.SetHasClass("two_choices", numOfTalentsInThisRow == 2);
                        TalentRow.SetHasClass("eight_choices", numOfTalentsInThisRow > 6);
                    }

                    for(var k=0; k<numOfChoicesToProcess; k++){
                        var luaIndex = k+1; //Lua tables start at index 1
                        var TalentChoiceID = "Talent_Choice_"+currentRowLevel+"_"+k;
                        var TalentChoicePanel = talentPanel.FindChildTraverse(TalentChoiceID);
                        var TalentChoiceData = heroTalentList[currentRowLevel][luaIndex];
                        if(TalentChoicePanel){
                            if(TalentChoiceData == null){
                                //Hide choices for imba heroes (only allow 2 choices for non-generic talents, first 6 panels will be hidden)
                                TalentChoicePanel.style.visibility = "collapse";
                            }else{
                                TalentChoicePanel.style.visibility = "visible";
                                var labelChoiceText = TalentChoicePanel.FindChildTraverse("IMBA_Talent_Choice_Text");
                                if(labelChoiceText){
                                    labelChoiceText.text = GetTalentLabelText(TalentChoiceData, currentRowLevel);
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

                                    }else if(k >= MAX_NUM_OF_GENERIC_TALENTS || !HasGenericTalentBeenUpgraded(currentShownUnitID, k)){
                                        //Only selectable if entity has the right level and has an ability point to spend
                                        if(currentUnitLevel >= currentRowLevel &&
                                            currentAbilityPoints > 0 &&
                                            isControllableByPlayer){
                                            //Add .selectable class to TalentChoicePanel if user has not upgraded the row of talents
                                            TalentChoicePanel.AddClass("selectable");
                                            ConfigureTalentClick(TalentChoicePanel, currentShownUnitID, currentRowLevel, luaIndex);
                                        }
                                    }else{
                                        //Not possible to upgrade the same tree
                                        TalentChoicePanel.AddClass("disabled");
                                    }

                                    //Remove old images
                                    imageChoiceContainer.RemoveAndDeleteChildren();
                                    //Special talents will be abilities
                                    //Generic stat talents will be modifiers
                                    CreateImagePanelForTalent(TalentChoiceData, imageChoiceContainer, currentShownUnitID);

                                    AttachToolTip(imageChoiceContainer, TalentChoiceData, currentRowLevel, k);
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
            Entities.IsRealHero(currentShownUnitID))){

        var talentWindow = $.GetContextPanel();

        var imbaBtnPanel = GetImbaTalentButtonPanel();

        if(bol_open){
            talentWindow.SetAttributeInt(ATTRIBUTE_UNIT_ID, currentShownUnitID);
            PopulateIMBATalentWindow();
            talentWindow.AddClass(OPEN_TALENT_WINDOW_CLASS);
            CloseIMBATalentWindowWhenDeselectUnit();
            imbaBtnPanel.AddClass("selected");
            talentWindow.SetFocus();
        }else{
            talentWindow.SetAttributeInt(ATTRIBUTE_UNIT_ID, -1);
            talentWindow.RemoveClass(OPEN_TALENT_WINDOW_CLASS);
            imbaBtnPanel.RemoveClass("selected");

            //Unfocus talentWindow
            $.DispatchEvent("DropInputFocus", talentWindow);
        }

        PreviewImbaTalentWindow(false);

        ShowAllTextWhenTalentWindowVisibleAndAltIsDown();
    }
}

function ToggleIMBATalentWindow(){
    var talentWindow = $.GetContextPanel();
    OpenImbaTalentWindow(!talentWindow.BHasClass(OPEN_TALENT_WINDOW_CLASS));
}

function PreviewImbaTalentWindow(bol_preview){
    if(_current_hover_preview_timer != null){
        $.CancelScheduled(_current_hover_preview_timer);
        _current_hover_preview_timer = null;
    }

    var PREVIEW_TALENT_WINDOW_CLASS = "preview";
    var talentWindow = $.GetContextPanel();
    if(bol_preview){
        talentWindow.AddClass(PREVIEW_TALENT_WINDOW_CLASS);
        ShowAllTextWhenTalentWindowVisibleAndAltIsDown();
    }else{
        talentWindow.RemoveClass(PREVIEW_TALENT_WINDOW_CLASS);
    }
}

function DelayedPreviewImbaTalentWindow(){
    //Set to null as timer has fired
    _current_hover_preview_timer = null;
    PreviewImbaTalentWindow(true);
}

function GetHUDRootUI_Server()
{
    var rootUI = $.GetContextPanel();
    while(rootUI.id != "Hud" && rootUI.GetParent() != null){
        rootUI = rootUI.GetParent();
    }
    return rootUI;
}

function GetUI_Server()
{
	return GetHUDRootUI_Server().FindChildTraverse("ButtonBar");
}

function GetLastButton_Server()
{
	return GetHUDRootUI_Server().FindChildTraverse("ButtonBar").FindChildTraverse("ToggleScoreboardButton");
}

function InsertPartSelectButton()
{
	var targetButton = GetLastButton_Server();
	var baseUI = GetUI_Server();
	var newButton = $.CreatePanel("Panel", baseUI, "hahaha");
    newButton.BLoadLayout("file://{resources}/layout/custom_game/server_part_select.xml", false, false);
    baseUI.MoveChildAfter(newButton, targetButton);

	
}

function UpdateTooltipUI()
{
    var tooltips = GetHUDRootUI_Server().FindChildTraverse("DOTAAbilityTooltip")
    if(tooltips != null){
        tooltips.FindChildTraverse("AbilityCosts").style.flowChildren = "down";
    }
}

function InsertIMBATalentButton(){
    $.Msg("InsertIMBATalentButton");
	InsertPartSelectButton();
	$.RegisterEventHandler( 'DOTAShowAbilityTooltip', $.GetContextPanel(), UpdateTooltipUI );
    var baseUI = GetHUDRootUI();
    baseUI = baseUI.FindChildTraverse("AbilitiesAndStatBranch");
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

    newButton.SetPanelEvent("onmouseover", function(){
        //Populate before preview
        PopulateIMBATalentWindow();
        //Allow preview even if it is an illusion/clone
        _current_hover_preview_timer = $.Schedule(0.3, DelayedPreviewImbaTalentWindow);
    });

    newButton.SetPanelEvent("onmouseout", function(){
        //Remove preview talent window
        //Allow preview even if it is an illusion/clone
        PreviewImbaTalentWindow(false);
    });

    newButton.SetPanelEvent("onactivate", ToggleIMBATalentWindow);

    AnimateImbaTalentButton();
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
    //Data given is the legacy data 'splitscreenplayer' only
    AnimateImbaTalentButton();
    CloseIMBATalentWindowWhenDeselectUnit();
}


