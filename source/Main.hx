package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import states.PlayState;
import utils.Config;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(
			Math.floor(FlxG.stage.stageWidth / Config.SCREEN_SCALE),
			Math.floor(FlxG.stage.stageHeight / Config.SCREEN_SCALE),
			PlayState
		));
	}
}
