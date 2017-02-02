/*
 * Library for organizing Panorama components into reusable modules.
 * Usage examples at the end of this file.
 *
 * Place the module file in layout/custom_game/modules/, the file name (minus .xml)
 * acts as the module's name. Inside the module define its functionality with
 *     Modular.DefineThis( someObjWithFunctionality ).
 *
 * In files where you want to use this module use:
 *    Modular.Spawn( moduleName, parentPanel ) 
 *
 * By: Perry, July 2015
 */

 /* The path of the directory containing all modules */
var MODULE_BASE_PATH = "file://{resources}/layout/custom_game/modules/";

/* Create the object */
var Modular = {};

/* MakeModule
 * Add core module functionality to a panel.
 *
 * Params:
 *	- panel {object} - The panel to make into a module.
 * Returns:
 *	The input panel with added functionality.
 */
Modular.MakeModule = function( panel ) {

	//Extend function - shorthand for Modular.Extend
	panel.extend = function( extension ) {
		Modular.Extend( panel, extension );
	}

	return panel;
}

/* Extend
 * Extend a panel by copying functionality onto it. New functionality is
 * defined by supplying an object with these fields/methods, which will
 * then be copied onto the panel.
 *
 * Params:
 *	- panel {object} - The panel to extend.
 *	- extension {object} - An object containing fields to be copied.
 * Returns:
 *	The extended panel.
 */
Modular.Extend = function( panel, extension ) {
	for (var key in extension) {
		panel[key] = extension[key];
	}

	return panel;
}

/* Spawn
 * Create a new instance of a certain module specified by name. Modules are
 * identified by their file name and located at MODULE_BASE_PATH.
 *
 * Params:
 *	- name {string} - The (file)name of the module. (excluding .xml)
 *	- parent {object} - The object that this module instance will be appended to.
 * Returns:
 *	The created module instance.
 */
Modular.Spawn = function( name, parent ) {
	var newPanel = $.CreatePanel( "Panel", parent, "player_root" );
	newPanel.BLoadLayout( MODULE_BASE_PATH + name + ".xml", false, false );

	//Wrap into module functionality before returning
	return Modular.MakeModule( newPanel );
}

/* DefineThis
 * Define the current xml file/scope as a module for future reference and add
 * functionality by extending the module (see Modular.Extend).
 *
 * Params:
 *	- functionality {object} - An object containing extra functionality like for Extend.
 * Returns:
 *	The module that was just created.
 */
Modular.DefineThis = function( functionality ) {
	var panel = $.GetContextPanel();
	Modular.Extend( panel, functionality );

	return panel;
}

//USAGE EXAMPLES
//===============================================================================
/*
	Example module file:
	layout/custom_game/modules/player_avatar.xml:

		<root>
			<scripts>
				<include src="file://{resources}/scripts/custom_game/Modular.js" />
			</scripts>

			<script>
				//Module definition
				Modular.DefineThis({

					//Set the player for this avatar
					SetPlayer : function( playerID ) {
						var pID = playerID;
						var playerInfo = Game.GetPlayerInfo( playerID );
						$('#PlayerAvatar').steamid = playerInfo.player_steamid;
						$('#PlayerName').text = playerInfo.player_name;
					},

					//Set the width of this panel
					SetWidth : function( width ) {
						var panel = $.GetContextPanel();
						panel.style.width = width + 'px';
					},
				});

			</script>

			<Panel class="TeamSelectPlayer">
				<DOTAAvatarImage id="PlayerAvatar" />
				<Label id="PlayerName" text="PLAYER_NAME" />
			</Panel>
		</root>

	To use this module in any other file, include the Modular.js script like so:
		<scripts>
			<include src="file://{resources}/scripts/custom_game/Modular.js" />
		</scripts>

	Next to spawn a module from javascript you can just use:
		var avatarPanel = Modular.Spawn( "player_avatar", $('#examplePanel') );

	This will add an instance of the player_avatar module to the panel with
	id='examplePanel'.

	After this the defined functionality can be used like any object's methods:
		var avatarPanel = Modular.Spawn( "player_avatar", $('#examplePanel') );
		avatarPanel.SetPlayer( 0 );
		avatarPanel.SetWidth( 200 );
*/