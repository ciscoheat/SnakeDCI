package contexts;
import data.Fruit;
import data.Score;
import data.Screen;
import data.Snake;
import haxedci.Context;
import flixel.FlxG;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

class Collisions implements Context
{
	public function new(screen : Screen)
	{
		this.screen = screen;
		this.snake = screen.snake;
		this.fruit = screen.fruit;
		this.score = screen.score;
	}

	public function test() : Void
	{
		if (snake.collidedWithItself())
			screen.displayGameOver();
		else if (snake.movedToFruit())
			fruit.disappear();
		else
			screen.executeMovement();
	}

	///// Roles /////

	@role var snake : Snake =
	{
		function movedToFruit() return FlxG.overlap(snake, fruit);
		function collidedWithItself() return FlxG.overlap(self);
		function movingEvery2ndFrame() return self.speed == 2;

		function addSegment() : Void
		{
			self.grow();
			fruit.add();
		}

		function increaseSpeed() : Void
		{
			if (!self.movingEvery2ndFrame())
				self.speed -= 0.25;

			screen.executeMovement();
		}
	}

	@role var fruit : Fruit =
	{
		function disappear() : Void
		{
			self.kill();
			score.increase();
		}

		function add() : Void
		{
			self.reset(0, 0);

			do {
				// Pick a random place to put the fruit down
				self.x = FlxRandom.intRanged(0, Math.floor(FlxG.width / screen.blockSize) - 1) * screen.blockSize;
				self.y = FlxRandom.intRanged(0, Math.floor(FlxG.height / screen.blockSize) - 1) * screen.blockSize;
			} while (FlxG.overlap(self, snake));

			snake.increaseSpeed();
		}
	}

	@role var screen : Screen =
	{
		function executeMovement() : Void
		{
			new FlxTimer(snake.speed / FlxG.updateFramerate, function(_) {
				new Movement(self).move();
			});
		}

		function displayGameOver() : Void
		{
			score.text = "Game Over - Space to restart!";
			snake.alive = false;
		}
	}

	@role var score : Score =
	{
		function increase() : Void
		{
			self.add(10);
			snake.addSegment();
		}
	}
}