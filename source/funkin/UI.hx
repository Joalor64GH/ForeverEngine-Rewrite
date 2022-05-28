package funkin;

import lime.app.Application;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import states.PlayState;

class UI extends FlxSpriteGroup
{
	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	public var scoreBar:FlxText;

	// in the future, this should be an option
	var downscroll:Bool = false;

	public function new()
	{
		super();

		var barY = FlxG.height * 0.875;
		if (downscroll)
			barY = 69; // funny number huh?

		healthBarBG = new FlxSprite(0, barY).loadGraphic(AssetManager.getAsset('healthBar', IMAGE, 'UI'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8));
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);

		scoreBar = new FlxText(FlxG.width / 2, healthBarBG.y + 40, 0, "", 20);
		scoreBar.setFormat(AssetManager.getAsset('vcr', FONT, 'fonts'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreBar.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		scoreBar.scrollFactor.set();
		add(scoreBar);

		// ui stuffs!
		var cornerMark:FlxText = new FlxText(0, 0, 0, 'FOREVER ENGINE v' + Application.current.meta.get('version') + '\n');
		cornerMark.setFormat(AssetManager.getAsset('vcr', FONT, 'fonts'), 18, FlxColor.WHITE);
		cornerMark.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		add(cornerMark);
		cornerMark.setPosition(FlxG.width - (cornerMark.width + 5), 5);
		cornerMark.antialiasing = true;

		if (PlayState.song != null)
		{
			var centerMark:FlxText = new FlxText(0, 0, 0, '- ${PlayState.song.name.toUpperCase()} -\n');
			centerMark.setFormat(AssetManager.getAsset('vcr', FONT, 'fonts'), 24, FlxColor.WHITE);
			centerMark.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
			add(centerMark);
			centerMark.y = FlxG.height / 24;
			centerMark.screenCenter(X);
			centerMark.antialiasing = true;
		}
	}

	override public function update(elapsed:Float)
	{
		scoreBar.text = 'Score: ' + PlayState.songScore;
	}
}
