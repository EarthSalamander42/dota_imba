const assert = require("assert");
const fs = require("fs-extra");
const path = require("path");
const { getAddonName, getDotaPath } = require("./utils");

(async () => {
	const dotaPath = await getDotaPath();
	if (dotaPath === undefined) {
		console.log("No Dota 2 installation found. Addon linking is skipped.");
		return;
	}

	for (const directoryName of ["game", "content"]) {
		const sourcePath = path.resolve(__dirname, "..", directoryName);
		assert(fs.existsSync(sourcePath), `Could not find '${sourcePath}'`);

		const targetRoot = path.join(dotaPath, directoryName, "dota_addons");
		assert(fs.existsSync(targetRoot), `Could not find '${targetRoot}'`);

		const targetPath = path.join(dotaPath, directoryName, "dota_addons", getAddonName());
		if (fs.existsSync(targetPath)) {
			const isCorrect = fs.lstatSync(sourcePath).isSymbolicLink() && fs.realpathSync(sourcePath) === targetPath;
			if (isCorrect) {
				console.log(`Skipping '${sourcePath}' since it is already linked`);
				continue;
			} else {
				throw new Error(`'${targetPath}' is already linked to another directory`);
			}
		}

		fs.moveSync(sourcePath, targetPath);
		fs.symlinkSync(targetPath, sourcePath, "junction");
		console.log(`Linked ${sourcePath} <==> ${targetPath}`);
	}
})().catch((error) => {
	console.error(error);
	process.exit(1);
});
