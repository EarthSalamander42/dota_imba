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
	"AbilityModifierSupportBonus",
	"AbilityModifierSupportValue",
];
let separateFiles = [];

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

async function GetParsedData(sFileName) {
    return new Promise(async (resolve, reject) => {
        try {
            const data = await fs.promises.readFile(sFileName, 'utf8');
            const cleanedData = data.replace(/\/\/.*/g, '').replace(/"Version".*?\n/g, '');

            const lines = cleanedData.split('\n');
            let abilities = {};

            for (let i = 0; i < lines.length; i++) {
                let line = lines[i].trim();

                if (line.startsWith('#base')) {
                    const filePath = "../" + line.split(' ')[1];
					console.log('Found base file: ' + filePath);
					separateFiles.push(filePath);
                    // const separatedData = await fs.promises.readFile(`${inputFilePath2}/${filePath}`, 'utf8');
                    // const separatedLines = separatedData.split('\n');

                    // abilities = { ...abilities, ...parseAbilityData(separatedLines.join('\n')) };
                }
            }

            abilities = { ...abilities, ...parseAbilityData(cleanedData) };

            resolve(abilities);
        } catch (err) {
            console.error('Error reading the file:', err);
            reject(err);
        }
    });
}


async function FindValueByName(sFileName, ability_name, value_name) {
	return new Promise(async (resolve, reject) => {
		try {
			const data = await fs.promises.readFile(sFileName, 'utf8');
			const cleanedData = data.replace(/\/\/.*/g, '').replace(/"Version".*?\n/g, '');

			const lines = cleanedData.split('\n');
			let line_counter = 0;
			let bracketCounter = -1;
			let currentAbility = false;

			for (let line of lines) {
				line = line.trim();

				if (line.startsWith("{") || line.indexOf('{', 1) > -1) {
					bracketCounter++;

					if (bracketCounter > 0) {
						// console.log('bracket opened');
					}
				}

				if (line.startsWith("}") || line.indexOf('}') > -1) {
					// console.log('bracket closed');
					bracketCounter--;

					if (currentAbility && bracketCounter == 0) {
						console.log('ability object finished, no value found');
						resolve();
					}
				}

				if (line.startsWith('"')) {
					const key = line.substring(1, line.indexOf('"', 1));
					const value = line.substring(line.indexOf('"', 1) + 1).trim();

					if (currentAbility && key == value_name) {
						let openBracketFound = false;
						let closeBracketFound = false;

						for (let i = line_counter; i >= 0; i--) {
							let previous_line = lines[i].trim();

							if (previous_line.startsWith("{") || previous_line.indexOf('{', 1) > -1) {
								openBracketFound = i - 1;
								break;
							}
						}

						for (let i = line_counter; i < lines.length; i++) {
							let next_line = lines[i].trim();

							if (next_line.startsWith("}") || next_line.indexOf('}') > -1) {
								closeBracketFound = i;
								break;
							}
						}

						if (openBracketFound && closeBracketFound) {
							// console.log("Found ability values object, starting at line: " + openBracketFound + " and ending at line: " + closeBracketFound);
						}

						// Log the ability value here, after confirming the currentAbility is true
						// if (currentAbility) {
						// 	console.log("Ability Value: " + value);
						// }

						return resolve({ openBracketFound, closeBracketFound });
					}

					if (key == "imba_" + ability_name) {
						// console.log("Found ability: " + key);
						currentAbility = true;
					}
				}

				line_counter++;

				if (line_counter == lines.length) {
					// console.log('Reached end of file, no value found');
					resolve();
				}
			}
		} catch (err) {
			console.error('Error reading the file:', err);
			reject(err);
		}
	});
}

// A function to read a file, delete all tabs and spaces if there is nothing else on the line and write the result to the same file
function DeleteTabsAndSpaces(sFileName) {
	fs.readFile(sFileName, 'utf8', (err, data) => {
		if (err) {
			console.error('Error reading the file:', err);
			return;
		}

		const lines = data.split('\n');
		let cleanedData = '';

		for (let line of lines) {
			if (!/^[ \t]*$/.test(line)) {
				cleanedData += line + '\n';
			}
		}

		// Remove the trailing newline added during the loop
		cleanedData = cleanedData.trim();

		fs.writeFile(sFileName, cleanedData, (err) => {
			if (err) {
				console.error('Error writing the file:', err);
				return;
			}

			// get the file name
			const fileName = sFileName.split('\\').pop().split('/').pop();

			console.log('File \x1b[34m' + fileName + '\x1b[0m cleaned successfully!');
		});
	});
}

async function FindDuplicates() {
	try {
		let dota_abilities = await GetParsedData(inputFilePath1);
		let imba_abilities = await GetParsedData(inputFilePath2);
		let counter = 0;
		let duplicates = {};

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
						if (!duplicates[ability]) { duplicates[ability] = {}; }
						duplicates[ability][value] = true;
						counter++;
					}
				}
			}
		}

		// Find duplicates in separate files AbilityValues if they exist in dota_abilities
		for (let file of separateFiles) {
			let separate_abilities = await GetParsedData(inputFilePath2 + "/" + file);

			for (let ability in dota_abilities) {
				if (separate_abilities[ability]) {
					for (let value in dota_abilities[ability]) {
						if (value != "AbilitySpecial" && value != "AbilityValues" && value != "ability_name" && separate_abilities[ability][value]) {
							// console.log('Found duplicate value in \x1b[32m' + ability + '\x1b[0m: \x1b[34m' + value + '\x1b[0m - ' + dota_abilities[ability][value] + ' / ' + separate_abilities[ability][value]);
							counter++;
						}
					}

					for (let value in dota_abilities[ability].AbilityValues) {
						if (separate_abilities[ability].AbilityValues[value]) {
							// console.log('Found duplicate value in \x1b[32m' + ability + '\x1b[0m: \x1b[34m' + value + '\x1b[0m - ' + dota_abilities[ability].AbilityValues[value] + ' / ' + separate_abilities[ability].AbilityValues[value]);
							if (!duplicates[ability]) { duplicates[ability] = {}; }
							duplicates[ability][value] = true;
							counter++;
						}
					}
				}
			}
		}

		console.log('Found ' + counter + ' duplicates.');
		return duplicates;
	} catch (err) {
		console.error('Error:', err);
	}
}

async function RemoveDuplicates(sFileName) {
	try {
		await DeleteTabsAndSpaces(inputFilePath2);

		let duplicates = await FindDuplicates();
		let counter = 0;

		// Remove duplicates from imba_abilities AbilityValues
		console.log('Checking file: ' + sFileName);
		for (let ability in duplicates) {
			for (let value in duplicates[ability]) {
				// console.log('Found duplicate value in \x1b[32m' + ability + '\x1b[0m: \x1b[34m' + value + '\x1b[0m');
				let ability_value = await FindValueByName(sFileName, ability.replace(/"/g, ''), value);

				if (ability_value) {
					console.log("Ability value: " + JSON.stringify(ability_value));
					await RemoveDuplicateByName(sFileName, ability_value);
				}

				counter++;
			}
		}
		console.log('Removed ' + counter + ' duplicates.');

		// Remove duplicates from separate files AbilityValues
		for (let file of separateFiles) {
			console.log('Checking file: ' + file);
			for (let ability in duplicates) {
				for (let value in duplicates[ability]) {
					// console.log('Found duplicate value in \x1b[32m' + ability + '\x1b[0m: \x1b[34m' + value + '\x1b[0m');
					let ability_value = await FindValueByName(sFileName + "/" + file, ability.replace(/"/g, ''), value);

					if (ability_value) {
						console.log("Separate ability value: " + JSON.stringify(ability_value));
						await RemoveDuplicateByName(sFileName + "/" + file, ability_value);
					}

					counter++;
				}
			}
		}
		

		console.log('Removed ' + counter + ' duplicates.');
	} catch (err) {
		console.error('Error:', err);
	}
}

function RemoveDuplicateByName(sFileName, value) {
	try {
		// read data from the file synchronously
		const data = fs.readFileSync(sFileName, 'utf8');
		const lines = data.split('\n');
		let cleanedData = '';

		// delete the lines between the open bracket ability_value[0] and close bracket ability_value[1]
		for (let i = 0; i < lines.length; i++) {
			if (i < value.openBracketFound || i > value.closeBracketFound) {
				cleanedData += lines[i] + '\n';
			}
		}

		// Many newlines are added during the loop, remove them
		cleanedData = cleanedData.trim() + '\n';

		// write cleaned data back to the file synchronously
		fs.writeFileSync(sFileName, cleanedData);

		// get the file name
		const fileName = sFileName.split('\\').pop().split('/').pop();

		console.log('File \x1b[34m' + fileName + '\x1b[0m cleaned successfully!');

		return true;
	} catch (err) {
		console.error('Error:', err);
	}
}

RemoveDuplicates(inputFilePath2);