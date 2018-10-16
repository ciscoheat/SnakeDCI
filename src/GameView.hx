import phaser.Text;
import phaser.Graphics;
import phaser.CursorKeys;
import phaser.Sprite;
import phaser.Group;
import phaser.Phaser;
import phaser.Game;
import pixi.RenderTexture;
import pixi.DisplayObject;

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
        var playfield = {
            _game.add.tileSprite(0, 0, _game.width, _game.height, _textures.background);

            // Create the border before the playfield,
            // so it displays below the field.
            var playfieldBorder = {
                var border = _game.make.graphics();
                border.lineStyle(2, 0xCCCCCC, 1);
                border.beginFill(0x111111, 0.85);
                border.drawRect(0,0, playfieldWidth+2,playfieldWidth+2);
                border.endFill();
                _game.add.sprite(0, 0, border.generateTexture());
            }

            // Position playfield and its border on the screen
            var group = _game.add.group();

            group.x = (_game.world.width - playfieldWidth) / 2;
            group.y = (_game.world.height - playfieldWidth) / 2;

            playfieldBorder.x = group.x - 2;
            playfieldBorder.y = group.y - 2;

            // Bind role
            this.PLAYFIELD = group;

            // Return the full group object, so it can be used later to
            // add objects to it (snake and fruit).
            group;
        }

        ///// Score and keyboard /////
        {
            this.SCORE = _game.add.text(10, 10, "Score: " + _asset.state.score, cast {
                font: "20px Arial",
                fill: "#ffffff",
                align: "left",
                boundsAlignH: 'left',
                boundsAlignV: 'top',
            });

            var highScore = _asset.state.hiScore;
            this.HISCORE = _game.add.text(0, 0, "Hi-score: " + highScore, cast {
                font: "20px Arial",
                fill: "#ffffff",
                align: "right",
                boundsAlignH: 'right',
                boundsAlignV: 'top',
            }).setTextBounds(_game.world.width-150, 10, 150-10, 20);
        }

        ///// Create fruit and snake /////
        {
            this.SNAKE = playfield.add(_game.add.group());
            this.FRUIT = playfield.create(0, 0, _textures.fruit);
        }

        _asset.initializeGame();
    }

    function update() {
        SNAKE.display();
        FRUIT.display();
        SCORE.display();
    }

    ///// Context state /////////////////////////////////////////////

    final _asset : GameState;
    final _game : Game;
    var _textures : Textures;

    ///// Helper methods ////////////////////////////////////////////

    ///// Roles /////////////////////////////////////////////////////

    @role var FRUIT : {
        var x : Float;
        var y : Float;

        public function display() {
            var pos = _asset.state.fruit;
            var pixelX = pos.x * _asset.state.playfield.squareSize + 1;
            var pixelY = pos.y * _asset.state.playfield.squareSize + 1;

            SELF.x = pixelX; SELF.y = pixelY;
        }
    }

    @role var PLAYFIELD : {
        var x : Float;
        var y : Float;
    }

    @role var SNAKE : {
        function addChild(child : DisplayObject) : Void;
        function xy(index : Int, x : Float, y : Float) : Void;
        var length : Float;

        public function display() {
            var segments = _asset.state.snake.segments;
            var i = 0;

            for(segment in segments) {
                var pixelX = segment.x * _asset.state.playfield.squareSize;
                var pixelY = segment.y * _asset.state.playfield.squareSize;

                if(i >= SELF.length)
                    SELF.addChild(_game.add.sprite(
                        pixelX, pixelY, 
                        SELF.length == 0 ? _textures.head : _textures.segment)
                    )
                else
                    SELF.xy(i, pixelX, pixelY);

                i = i + 1;
            }
        }
    }

    @role var SCORE : {
        function setText(text : String, immediate : Bool) : Void;

        public function display() {
            var score = _asset.state.score;
            SELF.setText('Score: $score', false);
        }
    }

    @role var HISCORE : {
        function setText(text : String, immediate : Bool) : Void;

        public function display() {
            var hiscore = _asset.state.hiScore;
            SELF.setText('Hi-score: $hiscore', false);
        }
    }
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
