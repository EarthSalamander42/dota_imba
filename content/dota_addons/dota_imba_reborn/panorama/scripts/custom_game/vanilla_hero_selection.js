var total;
var current = 0;
var herolist = CustomNetTables.GetTableValue('hero_selection', 'herolist')
var herocard = FindDotaHudElement('GridCore');

function FindDotaHudElement(sElement)
{
	var BaseHud = $.GetContextPanel().GetParent().GetParent().GetParent();
	return BaseHud.FindChildTraverse(sElement);
}

function FillTopBarPlayer() 
{
	total = herocard.GetChildCount();
	for(var i=0; i < total; i++)
	{
		$.Schedule((0.03 * i), UpdateHeroCard);
	}
}

function UpdateHeroCard()
{
	var heroIMG = herocard.GetChild(current).FindChildTraverse("HeroImage");

	if (heroIMG != undefined) {
		for (hero in herolist.imbalist) {
			if (hero == "npc_dota_hero_" + heroIMG.heroname) {
				heroIMG.GetParent().AddClass("IMBA_HeroCard");
				heroIMG.GetParent().style.boxShadow = "inset #FF7800aa 0 0 30px 0";
				break;
			}
		}

		for (hero in herolist.customlist) {
			if (hero == "npc_dota_hero_" + heroIMG.heroname) {
				heroIMG.GetParent().AddClass("IMBA_HeroCard");
				heroIMG.GetParent().style.boxShadow = "inset purple 0 0 30px 0";
				break;
			}
		}

		for (hero in herolist.hotdisabledlist) {
			if (hero == "npc_dota_hero_" + heroIMG.heroname) {
				$.Msg(heroIMG.GetParent())
				heroIMG.GetParent().style.opacity = "0";
				break;
			}
		}
	}

	current++;
}

FillTopBarPlayer() ;
