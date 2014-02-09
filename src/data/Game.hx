package data;
import flash.Lib;
import flixel.FlxGame;

class Game extends FlxGame
{
	public function new() 
	{		
		var stageWidth = Lib.current.stage.stageWidth;
		var stageHeight = Lib.current.stage.stageHeight;
		
		var ratioX = stageWidth / 320;
		var ratioY = stageHeight / 240;
		var ratio = Math.min(ratioX, ratioY);		
		var fps = 60;
		
		super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), Screen, ratio, fps, fps);
	}	
}