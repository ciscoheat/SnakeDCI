package data;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Fruit extends FlxSprite
{
	public function new(x, y, size)
	{
		super(x, y);
		
		var spriteSize = Std.int(size * 0.8);
		
		makeGraphic(spriteSize, spriteSize, FlxColor.RED);
		this.offset.set(1, 1);
		this.centerOffsets();
	}	
}