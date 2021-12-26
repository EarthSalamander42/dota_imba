const FIX_CG_ROOT = $.GetContextPanel();

function OpenFixGame() {
	FIX_CG_ROOT.SetHasClass("show", true);
}
function CloseFixGame() {
	FIX_CG_ROOT.SetHasClass("show", false);
}

(function () {
	OpenFixGame();
})();
