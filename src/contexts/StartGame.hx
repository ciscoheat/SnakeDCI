package contexts;
import data.Score;
import data.Screen;
import data.Snake;
import data.Fruit;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

class StartGame implements haxedci.Context
{
	@role var screen = 
	{
		var roleInterface : Screen;
		
		function clearScreen()
		{
			self.clear();
			score.clear();
		}
		
		function executeMovement()
		{
			FlxTimer.start(snake.speed / FlxG.updateFramerate, function(t) {
				new Movement(self).move();
			});
		}
	}
	
	@role var snake =
	{
		var roleInterface : Snake;
		
		function create() : Void
		{
			screen.add(self);
			
			self.setPosition(screen.middleX(), screen.middleY());			
			self.facing = FlxObject.LEFT;
			self.grow(FlxObject.RIGHT);
			self.grow(FlxObject.RIGHT);
			
			fruit.create();
		}
	}
	
	@role var fruit =
	{
		var roleInterface : Fruit;
		
		function create() : Void
		{			
			screen.add(self);
			
			do {
				// Pick a random place to put the fruit down
				self.x = FlxRandom.intRanged(0, Math.floor(FlxG.width / screen.blockSize) - 1) * screen.blockSize;
				self.y = FlxRandom.intRanged(0, Math.floor(FlxG.height / screen.blockSize) - 1) * screen.blockSize;
			} while (FlxG.overlap(self, snake));
			
			screen.executeMovement();
		}
	}
	
	@role var score = 
	{
		var roleInterface : Score;
		
		function clear()
		{
			screen.add(self);			
			self.set(0);
			
			snake.create();
		}
	}
	
	public function new(screen : Screen) 
	{		
		this.screen = screen;
		this.snake = screen.snake;
		this.fruit = screen.fruit;
		this.score = screen.score;
	}	
		
	public function start()
	{
		screen.clearScreen();
	}
}