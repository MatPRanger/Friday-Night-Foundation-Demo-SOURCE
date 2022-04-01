package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.4.1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = ['story_mode', 'freeplay', 'credits','options'];
	
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;


	var cur2521:Int = 0;
	public static var scpword:String;


	override function create()
	{
		if(!FlxG.sound.music.playing)
			{
				switch(FlxG.random.int(0, 7)){
					case 1:
						scpword = "5167";
		
					case 2:
						scpword = "426";
					case 3:
						scpword = "087";
					case 4:
						scpword = "529";
					case 5:
						scpword = "079";
					case 6:
						scpword = "066";
					case 7:
						scpword = "096";
					case 0:
						scpword = "682";
		
				}
				FlxG.sound.playMusic(Paths.music("Menu_" + scpword));
			}
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;



		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0 - (0 * (optionShit.length - 4)), 0);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var offset:Float = 128 - (Math.max(optionShit.length, 4) - 4) * 150;
			var menuItem:FlxSprite = new FlxSprite(200, 150 +(i * 100)  + offset);
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 5) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var scp:FlxSprite = new FlxSprite(0, 0);
		scp.x = FlxG.width / 2;
		scp.y = 100;
		scp.setGraphicSize(Std.int(scp.width * 0.75));
		scp.updateHitbox();
		scp.scrollFactor.set(0, 0);
		scp.frames = Paths.getSparrowAtlas('mainmenu/SCPmenuart');
		scp.animation.addByPrefix('idle', scpword, 24);
		scp.animation.play('idle');
		
		add(scp);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (!Achievements.achievementsUnlocked[achievementID][1] && leDate.getDay() == 5 && leDate.getHours() >= 18) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
			Achievements.achievementsUnlocked[achievementID][1] = true;
			giveAchievement();
			ClientPrefs.saveSettings();
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	var achievementID:Int = 0;
	function giveAchievement() {
		add(new AchievementObject(achievementID, camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement ' + achievementID);
	}
	#end

	var selectedSomethin:Bool = false;
	public static function transitionshitlol():Void
		{
			switch(FlxG.random.int(0, 7)){
				case 1:
					scpword = "5167";
	
				case 2:
					scpword = "426";
				case 3:
					scpword = "087";
				case 4:
					scpword = "529";
				case 5:
					scpword = "079";
				case 6:
					scpword = "066";
				case 7:
					scpword = "096";
				case 0:
					scpword = "682";
	
			}
			if(!FlxG.sound.music.name.contains(scpword)){
			
			
			
				FlxG.sound.playMusic(Paths.music("Menu_" + scpword));
			}
			
		}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 5.6, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										MusicBeatState.switchState(new OptionsState());
								}
							});
						}
					});
				
			}
			#if desktop
			else if (FlxG.keys.justPressed.SEVEN)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}
	
		super.update(elapsed);
		var thefunnyArray:Array<Bool> = [FlxG.keys.justPressed.TWO, FlxG.keys.justPressed.FIVE, FlxG.keys.justPressed.TWO, FlxG.keys.justPressed.ONE];
		FlxG.watch.addQuick("2521", cur2521);
		if(thefunnyArray[cur2521] == true){
			cur2521 += 1;
		}
		if(cur2521 == thefunnyArray.length && !selectedSomethin){
			selectedSomethin = true;
			
			var scp:FlxSprite = new FlxSprite(0, 0);
			scp.scrollFactor.set(0, 0);
			scp.frames = Paths.getSparrowAtlas('yougottaken', 'shared');
			scp.animation.addByPrefix('idle', 'enter', 24, false);
			scp.animation.play('idle');
			
			add(scp);
			scp.animation.finishCallback = function(lmao:String) {
				PlayState.SONG = Song.loadFromJson('revenge-hard', 'revenge');
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = 2;
	
				PlayState.storyWeek = 0;
				
				LoadingState.loadAndSwitchState(new PlayState());
	
				FlxG.sound.music.volume = 0;
			};

		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.x = 150;
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.offset.y = 0;
			spr.updateHitbox();
			spr.x = 40;

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				spr.offset.x = 20;
				spr.offset.y = 0.27 * spr.frameHeight;
				FlxG.log.add(spr.frameWidth);
			}
		});
	}
}
