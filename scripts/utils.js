const {
	findSteamAppByName,
	SteamNotFoundError,
} = require("@moddota/find-steam-app");
const packageJson = require("../package.json");

module.exports.getAddonName = () => {
	if (!/^[a-z][\d_a-z]+$/.test(packageJson.name)) {
		throw new Error(
			"Addon name may consist only of lowercase characters, digits, and underscores " +
				"and should start with a letter. Edit `name` field in `package.json` file."
		);
	}

	return packageJson.name;
};

module.exports.getDotaPath = async () => {
	try {
		return await findSteamAppByName("dota 2 beta");
	} catch (error) {
		if (!(error instanceof SteamNotFoundError)) {
			throw error;
		}
	}
};
