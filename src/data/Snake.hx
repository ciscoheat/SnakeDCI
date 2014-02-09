package data;
import data.Screen;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.util.FlxColor;

class Snake extends FlxTypedGroup<FlxSprite>
{
	public var segmentSize(default, default) : Int;
	public var facing(get, set) : Int;
	public var speed(default, default) : Float;
	
	public function new(x, y, segmentSize : Int)
	{
		super();
		this.segmentSize = segmentSize;
		this.speed = 7; // move every frames
		
		// Add head
		this.add(makeSegmentSprite(x, y, FlxColor.OLIVE));
	}
	
	public function setPosition(x : Float, y : Float)
	{
		head().setPosition(x, y);
	}
	
	public function grow(dirFromTail = 0)
	{
		var tail = this.members[this.members.length - 1];
		var x = tail.x;
		var y = tail.y;
		
		if (dirFromTail == 0)
		{
			var beforeTail = this.members[this.members.length - 2];
			
			if (beforeTail.x < tail.x) dirFromTail = FlxObject.RIGHT;
			else if (beforeTail.x > tail.x) dirFromTail = FlxObject.LEFT;
			else if (beforeTail.y > tail.y) dirFromTail = FlxObject.UP;
			else dirFromTail = FlxObject.DOWN;
		}
		
		switch(dirFromTail)
		{
			case FlxObject.LEFT:  x -= segmentSize;
			case FlxObject.RIGHT: x += segmentSize;			
			case FlxObject.UP:    y -= segmentSize;
			case FlxObject.DOWN:  y += segmentSize;
		}
		
		this.add(makeSegmentSprite(x, y, FlxColor.GREEN));
	}
	
	private function head() return members[0];	
	
	private function get_facing() return head().facing;
	private function set_facing(v : Int) return head().facing = v;

	private function makeSegmentSprite(x : Float, y : Float, color : Int) : FlxSprite
	{
		var spriteSize = Std.int(segmentSize * 0.8);
		var segment = new FlxSprite(x, y);
		
		segment.makeGraphic(spriteSize, spriteSize, color);
		segment.offset.set(1, 1);
		segment.centerOffsets();
		
		return segment;
	}
}