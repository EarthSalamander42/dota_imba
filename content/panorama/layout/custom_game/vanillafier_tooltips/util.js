function GetDotaHud() {
	var p = $.GetContextPanel();
	try {
		while (true) {
			if (p.id === "Hud")
				return p;
			else
				p = p.GetParent();
		}
	} catch (e) {}
}

function isFloat(n){
	return Number(n) === n && n % 1 !== 0;
}

function SetHTMLNewLine(text) {
	while (text.indexOf("\n") !== -1) {
		text = text.replace("\n", "<br>");
	}

	return text;
}

function bit_band(iBehavior, iBitCheck) {
	return iBehavior & iBitCheck;
}
