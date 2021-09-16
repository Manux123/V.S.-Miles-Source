package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.input.gamepad.FlxGamepad;
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

	private static var creditsStuff:Array<Dynamic> = [ //Nombre - Icono - Descripcion - Link - Color del fondo

		['Team Miles'],
		['David Miles',		'nothing',		'Creator and composer',	'https://www.youtube.com/channel/UCxhqynEbpxX6EPg5k9-141w',	0xFF228b22],
		['Manux12',		'nothing',		'Programmer',	'https://www.youtube.com/channel/UCU6W57DZXG4mSc6GPPOIoRg',	0xFF67ce8e],
		['Zeta4',		'nothing',		'Cartoonist',	'nothing',	0xFFd9fa42],
		['LeCherlok',		'nothing',		'Animator',	'https://gamebanana.com/members/1909579',	0xFFbdb76b],
		[''],
		["Gracias Especiales"],
		['MDC',			'nothing',	'Por la ayuda en su server\nDe discord',			'https://www.youtube.com/channel/UCFYmRctVlFLZWOXhqq7L9Sg',	0xFF67ce8e],
		['SHRUKEN6057',			'nothing',	'Por sus tutoriales\nDe Youtube',			'https://www.youtube.com/channel/UCSglueqfzKFFat7T7PPHfDw',	0xFF4166f5],
		['Juanen 100',			'nothing',	'No hizo nada\nSolo lo queria agregar XD ',			'https://www.tiktok.com/@juanen100',	0xFFd9fa42],
		['PABLOELPROXD210',		'nothing',		'Por agregar nuevas opciones y el menu de los creditos',	'https://www.tiktok.com/@furrosdemoniofreefire',	0xFF228b22],
		[''],
		["Cosas que Robe XD"], //te aconsejo dejar estos creditos ._. hablo enserio
		['Castle Crashers Boss Rush REVIVED',			'nothing',	'Hitsounds\nJuega su mod esta bueno', 'https://gamebanana.com/mods/308936',	0xFFbdb76b],
		[''],
		['Special thanks'], //Este te obligo que lo dejes borra los demas si quieres pero este no. 
		['KadeDeveloper',		'nothing',		'Creator of the Kade Engine',	'https://www.youtube.com/channel/UCoYksltIxNuSHz_ERzoRP6g',	0xFF226A0D],
		['Shadow Mario',		'nothing',		'Some functions of your engine',	'https://gamebanana.com/mods/309789',	0xFFE5E20E],
		[''],
	];

	//toma una pagina para los colores https://html-color.codes/  solo se necesita el codigo hex
	//Lo de nothing dejalo es importante XD
	//Puedes poner tu icono alado de tu nombre (esta bug)
	//siempre ponle un color, si no le pones color al seleccionar el nombre se vera todo negro XD
	var bg:FlxSprite;
	var descText:FlxText;
	private var intendedColor:Int;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In The Credits", null);
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
			optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

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

		var upP = FlxG.keys.justPressed.UP;
		var downP = FlxG.keys.justPressed.DOWN;
		var accepted = controls.ACCEPT;
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

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
			FlxTween.cancelTweensOf(bg);
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			fancyOpenURL(creditsStuff[curSelected][3]);
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
			FlxTween.cancelTweensOf(bg);
			intendedColor = newColor;
			FlxTween.color(bg, 1, bg.color, intendedColor);
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

				for (j in 0...iconArray.length) {
					var tracker:FlxSprite = iconArray[j].sprTracker;
					if(tracker == item) {
						iconArray[j].alpha = item.alpha;
						break;
					}
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
