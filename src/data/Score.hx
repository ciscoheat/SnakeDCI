package data;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

class Score extends FlxText
{
	public var score(default, null) : Int;
	
	public function new() 
	{
		super(0, 0, 200);
	}
	
	public function set(score : Int)
	{
		this.score = score;
		this.text = "Score: " + score;
		
		// Fading effect
		this.alpha = 0;		
		FlxTimer.start(1 / FlxG.updateFramerate, function(t) {
			this.alpha += 0.1;
		}, 10);
	}
		
	public function add(points : Int)
	{
		set(score + points);
	}
}