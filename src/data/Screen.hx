package data;
import contexts.Movement;
import contexts.StartGame;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxObject;

import haxe.macro.Expr;

class Screen extends FlxState
{
	public var blockSize(default, null) : Int;
	
	public var snake(default, null) : Snake;
	public var fruit(default, null) : Fruit;
	public var score(default, null) : Score;
	
	public function new(blockSize = 8) 
	{
		super();
		this.blockSize = blockSize;
	}
	
	public function middleX() return FlxG.width / 2;
	public function middleY() return FlxG.height / 2;

	override public function create()
	{
		super.create();
		
		snake = new Snake(0, 0, blockSize);
		fruit = new Fruit(0, 0, blockSize);
		score = new Score();
		
		new StartGame(this).start();
	}
	
	override public function update()
	{
		super.update();
		new Movement(this).testMovement();
	}
}