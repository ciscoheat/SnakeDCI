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

class GameView implements dci.Context {
    public function new(game, asset : GameState) {
        this._game = game;
        this._asset = asset;

        var playfield = _asset.state.playfield;

        _game.state.add('Game', {
            preload: this.preload,
            create: this.create.bind(
                playfield.width * playfield.squareSize, 
                playfield.height * playfield.squareSize,
                playfield.squareSize
            ),
            update: this.update
        });
    }

    ///// System Operations /////////////////////////////////////////

    public function start() {
        if(_game.state.current == "Game") throw "Game already started.";
        _game.state.start('Game');
    }

    function preload() {
        this._textures = new Textures(_game, _asset.state.playfield.squareSize);
    }

    function create(playfieldWidth, playfieldHeight, segmentSize) {
        
        ///// Create playfield /////
        {
            _game.add.tileSprite(0, 0, _game.width, _game.height, _textures.background);

            this.playfield = _game.add.group();

            var playfieldBorder = {
                var border = _game.make.graphics();
                border.lineStyle(2, 0xCCCCCC, 1);
                border.beginFill(0x111111, 0.85);
                border.drawRect(0,0, playfieldWidth+2,playfieldWidth+2);
                border.endFill();
                _game.add.sprite(0, 0, border.generateTexture());
            }

            // Position playfield and its border on the screen
            this.playfield.x = (_game.world.width - playfieldWidth) / 2;
            this.playfield.y = (_game.world.height - playfieldWidth) / 2;

            playfieldBorder.x = this.playfield.x - 2;
            playfieldBorder.y = this.playfield.y - 2;
        }

        ///// Score and keyboard /////
        {
            this.score = _game.add.text(10, 10, "Score: " + _asset.state.score, cast {
                font: "20px Arial",
                fill: "#ffffff",
                align: "left",
                boundsAlignH: 'left',
                boundsAlignV: 'top',
            });

            // If hi-score exists since previous round, use it.
            var highScore = _asset.state.hiScore;
            this.hiscore = _game.add.text(0, 0, "Hi-score: " + highScore, cast {
                font: "20px Arial",
                fill: "#ffffff",
                align: "right",
                boundsAlignH: 'right',
                boundsAlignV: 'top',
            }).setTextBounds(_game.world.width-150, 10, 150-10, 20);
        }

        ///// Create fruit and snake /////

        // Create snake and fruit, add them to the playfield
        /*
        var snake = new Snake(game, this._textures);
        var fruit : Sprite = _game.add.sprite(0,0,_textures.fruit);
        */

        /*
        // Create segments for the snake
        var start = Std.int((playfieldWidth / 2));
        for(i in 0...4)
            snake.addSegment(start - i*segmentSize, start);

        // TODO: Prevent initial collision with snake and fruit
        fruit.x = Std.random(playfieldSize) * segmentSize + 1;
        fruit.y = Std.random(playfieldSize) * segmentSize + 1;
        */        
    }

    function update() {

    }

    ///// Context state /////////////////////////////////////////////

    var _textures : Textures;
    var _asset : GameState;
    var _game : Game;

    var playfield : Group;
    var score : Text;
    var hiscore : Text;


    ///// Helper methods ////////////////////////////////////////////

    ///// Roles /////////////////////////////////////////////////////

    /*
    @role var PLAYFIELD : {
        var x : Float;
        function doSomething() : Void;

        public function interact() {
            SCORE.test();
        }
    }

    @role var SCORE : {
        var x : Float;
        function doSomething() : Void;

        public function test() {
            SELF.doSomething();
        }
    }
    */
}

/**
 * Graphical resources
 */
private class Textures {
    public final head : RenderTexture;
    public final segment : RenderTexture;
    public final fruit : RenderTexture;
    public final background : String;

    public function new(game : Game, segmentSize : Int) {

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

        var background = 'background';
        game.load.image(background, 'assets/connectwork.png');

        this.head = head.generateTexture();
        this.segment = segment.generateTexture(); 
        this.fruit = fruit.generateTexture();
        this.background = background;
    }
}
