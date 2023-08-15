const fs = require('fs');

const inputFilePath1 = '../../dota_vpk_updates/scripts/npc/npc_abilities.txt';
const inputFilePath2 = 'C:/Program Files (x86)/Steam/steamapps/common/dota 2 beta/game/dota_addons/dota_imba/scripts/npc/npc_abilities_custom.txt';
const excludedKeys = [
    "var_type",
    "LinkedSpecialBonus",
    "LinkedSpecialBonusOperation",
    "LinkedSpecialBonusTooltip",
    "LinkedSpecialBonusRegen",
    "ad_linked_abilities",
    "RequiresScepter",
	"CalculateSpellDamageTooltip",
];
const excludedAbilityKeys = [
	"model",
	"AbilityCastAnimation",
	"FightRecapLevel",
	"AbilityType",
	"AbilityBehavior",
	"AbilityUnitDamageType",
	"AbilityUnitTargetTeam",
	"AbilityUnitTargetType",
	"AbilityUnitTargetFlags",
	"AbilitySound",
	"HasScepterUpgrade",
	"AbilityCastGestureSlot",
];

function parseAbilityData(data) {
	const abilities = {};
	let currentAbility = undefined;
	let currentAbilityValue = false;
	const lines = data.split('\n');
	let line_counter = 0;
	let bracketCounter = -1;

	for (let line of lines) {
		line = line.trim();
		// console.log(line + ' - line: ' + line_counter);

		// detect when brackets are opened and closed
		if (line.startsWith("{") || line.indexOf('{', 1) > -1) {
			bracketCounter++;

			if (bracketCounter > 0) {
				// console.log('bracket opened');
			}

			const previous_key = FindPreviousLine(lines, line_counter);

			// when a bracket is opened, create a new ability object until bracketCounter is 0
			if (!currentAbility && bracketCounter > 0) {
				// console.log('creating new ability object: ' + previous_key);
				currentAbility = {
					'ability_name': previous_key.replace("imba_", ""),
				};
			}
		}

		if (line.startsWith("}") || line.indexOf('}') > -1) {
			// console.log('bracket closed');
			bracketCounter--;

			if (currentAbilityValue && bracketCounter == 1) {
				currentAbilityValue = false;
			}

			if (bracketCounter == 0) {
				// console.log('ability object finished');
				abilities[currentAbility.ability_name] = currentAbility;
				currentAbility = undefined;
			}
		}

		if (line.startsWith('"')) {
			const key = line.substring(1, line.indexOf('"', 1));
			const value = line.substring(line.indexOf('"', 1) + 1).trim();
			let key_check = parseInt(key);

			if (key_check) {
				key_check = false;
			} else {
				key_check = true;
			}

			// Register all ability keys outside of AbilityValues
			if (currentAbility && !currentAbilityValue && key_check && !excludedAbilityKeys.includes(key)) {
				// console.log('ability key found: ' + key + ' - ' + value);
				currentAbility[key] = value;
			}

			// console.log('key: ' + key + ' - value: ' + value);
			if (currentAbility && currentAbilityValue && key_check && !excludedKeys.includes(key)) {
				// console.log('ability value found: ' + key + ' - ' + value);
				currentAbility["AbilityValues"][key] = value;
			}

			// console.log(key);
			if (currentAbilityValue == false && currentAbility && key == "AbilitySpecial" || key == "AbilityValues") {
				// console.log('Creating ability values object for ' + currentAbility.ability_name + '...');
				currentAbilityValue = true;
				currentAbility["AbilityValues"] = {};
			}
		}

		line_counter++;
	}

	// Delete every ability that doesn't have an AbilityValues object
	for (let ability in abilities) {
		if (!abilities[ability].AbilityValues) {
			delete abilities[ability];
		}
	}

	return abilities;
}

function FindPreviousLine(lines, index) {
	let previous_line = lines[index - 1];

	if (previous_line != undefined) {
		previous_line = previous_line.trim();
	} else {
		FindPreviousLine(lines, index - 1);
		return;
	}

	return previous_line;
}

function GetParsedData(sFileName) {
    return new Promise((resolve, reject) => {
        fs.readFile(sFileName, 'utf8', (err, data) => {
            if (err) {
                console.error('Error reading the file:', err);
                reject(err);
                return;
            }

            const cleanedData = data.replace(/\/\/.*/g, '').replace(/"Version".*?\n/g, '');
            const abilities = parseAbilityData(cleanedData);
            resolve(abilities);
        });
    });
}

async function FindDuplicates() {
	try {
		let dota_abilities = await GetParsedData(inputFilePath1);
		let imba_abilities = await GetParsedData(inputFilePath2);
		let counter = 0;

		console.log('Find duplicates...');

		// Find duplicates in imba_abilities AbilityValues if they exist in dota_abilities
		for (let ability in dota_abilities) {
			if (imba_abilities[ability]) {
				for (let value in dota_abilities[ability]) {
					if (value != "AbilitySpecial" && value != "AbilityValues" && value != "ability_name" && imba_abilities[ability][value]) {
						console.log('Found duplicate value in \x1b[32m' + ability + '\x1b[0m: \x1b[34m' + value + '\x1b[0m - ' + dota_abilities[ability][value] + ' / ' + imba_abilities[ability][value]);
						counter++;
					}
				}
				
				for (let value in dota_abilities[ability].AbilityValues) {
					if (imba_abilities[ability].AbilityValues[value]) {
						console.log('Found duplicate value in \x1b[32m' + ability + '\x1b[0m: \x1b[34m' + value + '\x1b[0m - ' + dota_abilities[ability].AbilityValues[value] + ' / ' + imba_abilities[ability].AbilityValues[value]);
						counter++;
					}
				}
			}
		}

		console.log('Found ' + counter + ' duplicates.');
	} catch (err) {
		console.error('Error:', err);
	}
}

FindDuplicates();
