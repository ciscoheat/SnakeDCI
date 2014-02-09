package contexts;
import data.Screen;
import data.Snake;
import dci.Context;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

class Movement implements Context
{
	@role var snake = 
	{
		var roleInterface : Snake;
	}
	
	@role var head = 
	{
		var roleInterface : FlxSprite;
		
		function moveInFacingDirection() : Void
		{
			var x = self.x;
			var y = self.y;
			var oldX = x;
			var oldY = y;
			
			switch(self.facing)
			{
				case FlxObject.LEFT:  x -= snake.segmentSize;
				case FlxObject.RIGHT: x += snake.segmentSize;				
				case FlxObject.UP:    y -= snake.segmentSize;
				case FlxObject.DOWN:  y += snake.segmentSize;
			}
			
			self.setPosition(x, y);
			
			// Adjust if Head moves out of screen.
			FlxSpriteUtil.screenWrap(self);
			
			body.moveToFrontPosition(oldX, oldY);			
		}
	}
	
	@role var body =
	{
		var roleInterface : Array<FlxSprite>;
		
		function moveToFrontPosition(x : Float, y : Float) : Void
		{
			for (segment in body)
			{
				var oldX = segment.x;
				var oldY = segment.y;
				
				segment.setPosition(x, y);
				
				x = oldX;
				y = oldY;
			}
			
			screen.testCollisionsOnNextFrame();
		}
	}
	
	@role var tail : FlxSprite;
	
	@role var screen = 
	{ 
		var roleInterface : Screen;
		
		function testCollisionsOnNextFrame() : Void
		{
			// Wait 1 frame to allow sprites to change position
			FlxTimer.start(1 / FlxG.framerate, function(t) {
				new Collisions(screen).test();
			});
		}
	}
	
	public function new(screen : Screen) 
	{
		var snake = screen.snake;
		
		this.screen = screen;
		this.snake = snake;
		this.head = snake.members[0];
		this.body = snake.members.slice(1);
		this.tail = this.body[this.body.length - 1];
	}
	
	public function move()
	{
		head.moveInFacingDirection();
	}
	
	public function testMovement()
	{
		if (!snake.alive)
		{
			if (FlxG.keyboard.anyJustReleased(["SPACE", "R"]))
				FlxG.resetState();

			return;
		}
		
		// Determine illegal backward move direction
		// cannot use facing since it is possible to switch facing multiple times 
		// between movement frames.
		var firstBody = body[0];		
		var backwardDir = 0;
		
		if (head.x > firstBody.x)      backwardDir = FlxObject.LEFT;
		else if (head.x < firstBody.x) backwardDir = FlxObject.RIGHT;
		else if (head.y > firstBody.y) backwardDir = FlxObject.UP;
		else if (head.y < firstBody.y) backwardDir = FlxObject.DOWN;
		
		// WASD / arrow keys to control the snake
		if (FlxG.keyboard.anyPressed(["UP", "W"]) && backwardDir != FlxObject.UP)
		{
			snake.facing = FlxObject.UP;
		}
		else if (FlxG.keyboard.anyPressed(["DOWN", "S"]) && backwardDir != FlxObject.DOWN)
		{
			snake.facing = FlxObject.DOWN;
		}
		else if (FlxG.keyboard.anyPressed(["LEFT", "A"]) && backwardDir != FlxObject.LEFT)
		{
			snake.facing = FlxObject.LEFT;
		}
		else if (FlxG.keyboard.anyPressed(["RIGHT", "D"]) && backwardDir != FlxObject.RIGHT)
		{
			snake.facing = FlxObject.RIGHT;
		}		
	}
}