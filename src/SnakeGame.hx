import contexts.Movement;
import data.Playfield;
import data.Snake;
import phaser.Text;
import phaser.Graphics;
import phaser.CursorKeys;
import phaser.Sprite;
import phaser.Group;
import phaser.Phaser;
import phaser.Game;
import pixi.RenderTexture;

/**
 * Graphical resources
 */
class Textures {
    public final head : RenderTexture;
    public final segment : RenderTexture;
    public final fruit : RenderTexture;

    public function new(head, segment, fruit) {
        this.head = head;
        this.segment = segment;
        this.fruit = fruit;
    }
}

class SnakeGame {
    public var _textures(default, null) : Textures;

    public final game : Game;
    public final segmentSize : Float;

    public var playfield(default, null) : Playfield;
    public var score(default, null) : Text;
    public var hiscore(default, null) : Text;

    var keyboard : CursorKeys;
    var movement : Movement;

    public function new(width = 600, height = 600, segmentSize = 20, playfieldSize = 20) {
        this.segmentSize = segmentSize;
        this.game = new Game(width, height, Phaser.AUTO, 'snakedci', {
            preload: this.preload,
            create: this.create.bind(playfieldSize),
            update: this.update
        });
    }

    function preload() {
        game.load.image('background', 'assets/connectwork.png');

        ///// Create graphics /////

        var head : Graphics = game.make.graphics();
        head.lineStyle(1, 0xFFFFFF, 1);
        head.beginFill(0xCF500B, 1);
        head.drawRect(0,0, segmentSize-1,segmentSize-1);
        head.endFill();

        var segment : Graphics = game.make.graphics();
        segment.lineStyle(1, 0xFFFFFF, 1);
        segment.beginFill(0xFF700B, 1);
        segment.drawRect(0,0, segmentSize-1,segmentSize-1);
        segment.endFill();

        var fruit : Graphics = game.make.graphics();
        fruit.lineStyle(1, 0xFF2233, 1);
        fruit.beginFill(0xFF3344, 1);
        fruit.drawRect(0,0, segmentSize-2,segmentSize-2);
        fruit.endFill();

        this._textures = new Textures(
            head.generateTexture(), 
            segment.generateTexture(), 
            fruit.generateTexture()
        );
    }

    function create(playfieldSize) {

        ///// Create playfield /////

        var playfieldWidth = segmentSize * playfieldSize;

        game.add.tileSprite(0,0, game.width,game.height, 'background');

        var playfieldBorder = {
            var border = game.make.graphics();
            border.lineStyle(2, 0xCCCCCC, 1);
            border.beginFill(0x111111, 0.85);
            border.drawRect(0,0, playfieldWidth+2,playfieldWidth+2);
            border.endFill();
            game.add.sprite(0, 0, border.generateTexture());
        }

        // Create snake and fruit, add them to the playfield
        var snake = new Snake(game, this._textures);
        var fruit : Sprite = game.add.sprite(0,0,_textures.fruit);        

        // Position playfield and its border on the screen
        this.playfield = new Playfield(game, snake, fruit, playfieldWidth);
        this.playfield.x = (game.world.width - playfieldWidth) / 2;
        this.playfield.y = (game.world.height - playfieldWidth) / 2;

        playfieldBorder.x = this.playfield.x - 2;
        playfieldBorder.y = this.playfield.y - 2;

        // Create segments for the snake
        var start = Std.int((playfieldWidth / 2));
        for(i in 0...4)
            snake.addSegment(start - i*segmentSize, start);

        // TODO: Prevent initial collision with snake and fruit
        fruit.x = Std.random(playfieldSize) * segmentSize + 1;
        fruit.y = Std.random(playfieldSize) * segmentSize + 1;

        ///// Score and keyboard /////

        this.keyboard = game.input.keyboard.createCursorKeys();

        this.score = game.add.text(10, 10, "Score: 0", cast {
			font: "20px Arial",
			fill: "#ffffff",
			align: "left",
            boundsAlignH: 'left',
            boundsAlignV: 'top',
        });
        this.score.health = 0;

        // If hi-score exists since previous round, use it.
        var highScore = this.hiscore == null ? 0 : this.hiscore.health;
        this.hiscore = game.add.text(0, 0, "Hi-score: " + highScore, cast {
			font: "20px Arial",
			fill: "#ffffff",
			align: "right",
            boundsAlignH: 'right',
            boundsAlignV: 'top',
        }).setTextBounds(game.world.width-150, 10, 150-10, 20);
        this.hiscore.health = highScore;

        ///// Start movment /////

        this.movement = new Movement(this, snake, cast keyboard, {
            width: playfield.width, height: playfield.height
        });

        this.movement.start();
    }

    function update() {
        movement.checkDirectionChange();
    }

    // Program entrypoint
    static function main() new SnakeGame();
}
