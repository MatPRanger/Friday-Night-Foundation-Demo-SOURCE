package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];

	private static var creditsStuff:Array<Dynamic> = [ //Name - Icon name - Description - Link - BG Color
		['People'],
		["Bean", "Bean", "Forklift Certified", 'https://twitter.com/beanbruh3?s=21', 0xFFFF8282],
		['Guardian',		'Guardian', 		'Guardian of Deez Nuts',					'https://twitter.com/guardian_xml?s=21',	0xFF918E8E],
		['Mat',		'Mat', 		'Red like in Among Us, Press Enter for secret',					'https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstley',	0xFFFF8282],		
		['Veri',		'Veri',			'La creatura', 'https://twitter.com/veriepic?s=21', 0xFFD932CE],	
		[""],
		['Type and hope it works'],
		['Jack.exe',		'Jack.exe', 		'Main Coder',					'https://twitter.com/jack_exe_lol?s=21',	0xFFBFBFBF],
		['SeanBruh',		'SeanBruh', 		'Gigabrain coder lmao',					'https://twitter.com/BruhSupah',	0xFF611616],		
		['Wassabi',		'Wassabi', 		'Coderrrrrrr',					'https://twitter.com/wassabisoja?s=21',	0xFFFF4545],
		[""],
		['Party Rockers in the house tonight'],
		['Tsu',		'Tsu', 		'Tsu',					'https://twitter.com/_tsuraran?s=21',	0xFFC4BDC9],
		['LuvSeals',		'LuvSeals', 		'Loves Seals',					'https://m.youtube.com/channel/UCuNezmtQuCi11IHqpMfEfvw',	0xFF8FD9D9],
		['Bubbly',		'Bubbly', 		'BUBBY BUBS BUB BUBBLY',					'https://twitter.com/Senpoii1',	0xFFCCCBCA],
		[""],
		['Note placers'],
		['Clockwerk',		'Clockwerk', 		'Charter, Artist',					'https://twitter.com/clockwerksmurf?s=21',	0xFFCC622D],
		['Endercreep',		'EnderCreep', 		'Absolute Gamer',					'https://mobile.twitter.com/EnderCreep2709',	0xFF23FF0A],
		['Buck',		'Buck', 		'B3 GF Simp, B3 GF Simp',					'https://twitter.com/b3gf_simp?s=21',	0xFFD932CE],
		[""],
		['Fartists'],
		['Choco',		'Choco', 		'UI Artist',					'https://twitter.com/Chcocacola?s=21',	0xFFFF0505],
		['Omega', 'Omega', 'Built a big fucking reptile', 'https://twitter.com/anomegaguy?s=21', 0xFF00B377],
		['Ket', 'Ket', 'Creator of Tyler', 'https://twitter.com/lenzie_ket?s=21', 0xFF4D0000],
		['DammaRamma', 'DammaRamma', 'Fartist', 'https://www.instagram.com/dooodletones/?hl=en', 0xFFD932CE],
		['NETHERloid', 'NETHERloid', 'Fartist', 'https://nethersonq.tumblr.com/', 0xFF000033],
		['Wyvern', 'Wyvern', 'Fartist, Animes', 'https://mobile.twitter.com/wyvernnnnnnnn', 0xFF4DFFFF],
		['Radpas', 'Radpas', 'anem8ts', 'https://twitter.com/radpas12131?s=21', 0xFFFFB84D],
		['Arm4GeDon', 'Arm4GeDon', 'anumretr', 'https://twitter.com/arm4gedon_?s=21', 0xFFE68A00],
		[""],
		['XDDDD'],
		['Maple ', 'Maple', 'Epicness Incarnate', 'https://discord.gg/FunkSL', 0xFF995C00],
		[""],
		["Funkin' Crew"],
		['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",				'https://twitter.com/ninja_muffin99',	0xFFF73838],
		['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",					'https://twitter.com/PhantomArcade3K',	0xFFFFBB1B],
		['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",					'https://twitter.com/evilsk8r',			0xFF53E52C],
		['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",					'https://twitter.com/kawaisprite',		0xFF6475F3]
	];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Looking at credits", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		bg.color = creditsStuff[curSelected][4];
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int = creditsStuff[curSelected][4];
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
