import Main.MiddlewareLog;
import GameState.Coordinate;
import GameState.State;
import phaser.Graphics;
import phaser.Game;
import phaser.Sprite;
import phaser.Tween;
import phaser.Phaser;
import pixi.RenderTexture;
import contexts.*;

class GameView implements dci.Context {
    public function new(game : Game, asset : DeepState<State>, segmentPixelSize : Float, logger : MiddlewareLog<State>) {
        this._game = game;
        this._asset = asset;
        this._tweens = [];
        this._segmentPixelSize = segmentPixelSize;
        this._logger = logger;

        var playfield = _asset.state.playfield;

        _game.state.add('Game', {
            preload: this.preload,
            create: this.create.bind(
                playfield.width * segmentPixelSize, 
                playfield.height * segmentPixelSize,
                segmentPixelSize
            ),
            update: this.update
        });
    }

    ///// System Operations /////////////////////////////////////////

    public function start() {
        if(_game.state.current == "Game") throw "Game already started.";
        _game.state.start('Game');
    }

    // Create and load graphics
    function preload() {
        this._textures = new Textures(_game, _segmentPixelSize);
    }

    // Instantiate graphics and bind Roles
    function create(playfieldWidth, playfieldHeight, segmentSize) {
        
        ///// Playfield /////
        var playfield = {
            _game.add.tileSprite(0, 0, 
                Math.max(playfieldWidth, _game.width), 
                Math.max(playfieldHeight, _game.height), 
                _textures.background
            );

            var scrollWidth = playfieldWidth > _game.width;
            var scrollHeight = playfieldHeight > _game.height;

            // Create the border before the playfield,
            // so it displays below the field.
            var playfieldBorder = {
                var widthOffset = scrollWidth ? -2 : 2;
                var heightOffset = scrollHeight ? -2 : 2;
                var border = _game.make.graphics();
                border.lineStyle(2, 0xCCCCCC, 1);
                border.beginFill(0x111111, 0.85);
                border.drawRect(0,0, playfieldWidth+widthOffset,playfieldHeight+heightOffset);
                border.endFill();
                _game.add.sprite(0, 0, border.generateTexture());
            }

            // Position playfield and its border on the screen
            var group = _game.add.group();

            group.x = scrollWidth ? 0 : (_game.world.width - playfieldWidth) / 2;
            group.y = scrollHeight ? 0 : (_game.world.height - playfieldWidth) / 2;

            _game.world.setBounds(0, 0, Math.max(_game.width, playfieldWidth), Math.max(_game.height, playfieldHeight));

            playfieldBorder.x = scrollWidth ? 0 : group.x - 2;
            playfieldBorder.y = scrollHeight ? 0 : group.y - 2;

            // Return the group object, so it can be used later to
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

        ///// Fruit and snake /////
        var fruit : Sprite = playfield.create(0, 0, _textures.fruit);

        // Create fruit spinning effect
        fruit.anchor = new pixi.Point(0.5, 0.5);
        var tween = _game.add.tween(fruit).to({angle: 360}, 550, "Linear", true, 1000).repeat(-1, 1000);
        _tweens.push(tween);

        // Bind roles
        this.FRUIT = fruit;
        this.SNAKE = playfield.add(_game.add.group());

        // Create initial segments of snake
        var startSegments = {
            var X = Std.int(_asset.state.playfield.width / 2);
            var Y = Std.int(_asset.state.playfield.height / 2);

            [{x: X, y: Y}, {x: X-1, y: Y}, {x: X-2, y: Y}];
        }

        var fruitStartPos : Coordinate = {
            x: Std.int(Std.random(_asset.state.playfield.width)), 
            y: Std.int(Std.random(_asset.state.playfield.height))
        };

        // Load hi-score (saved in GameOver)
        var hi = js.Browser.window.localStorage.getItem("hiScore");
        var hiScore = if(hi == null) 0 else Std.parseInt(hi);

        _asset = _asset.update(
            _asset.state.snake = {
                segments: startSegments,
                nextMoveTime: 0.0,
                currentDirection: Phaser.RIGHT,
                wantedDirection: Phaser.RIGHT
            },
            _asset.state.score = 0,
            _asset.state.hiScore = hiScore,
            _asset.state.fruit = fruitStartPos,
            _asset.state.active = true
        );
    }

      //////////////////////////\
     ///// Main game loop /////\ \
    //////////////////////////\ \ \

    function update() {
        var state = _asset.state;

        SNAKE.display(state.snake.segments);
        FRUIT.display(state.fruit);
        SCORE.display(state.score);
        HISCORE.display(state.hiScore);

        //_game.debug.start(20, 45, 'white'); for(line in Std.string(state).split("\n")) _game.debug.line(line);

        // If Game Over, disable all contexts.
        if(state.active) {
            var next = new Movement(_asset).move(_game.time.physicsElapsedMS);
            next = new Controlling(next, _game.input.keyboard.createCursorKeys()).checkDirection();
            next = new Collisions(next).checkCollisions(_game);
            _asset = next;
        } else {
            for(t in _tweens) t.stop();
        }
    }

    ///// Context state /////////////////////////////////////////////

    final _game : Game;
    final _logger : MiddlewareLog<GameState.State>;
    final _tweens : Array<Tween>;
    final _segmentPixelSize : Float;

    var _asset : DeepState<State>;
    var _textures : Textures;

    ///// Helper methods ////////////////////////////////////////////

    ///// Roles /////////////////////////////////////////////////////

    @role var FRUIT : {
        var x : Float;
        var y : Float;

        public function display(coord : Coordinate) {
            // Move to center because of fruit tween
            var pixelX = coord.x * _segmentPixelSize + _segmentPixelSize / 2;
            var pixelY = coord.y * _segmentPixelSize + _segmentPixelSize / 2;

            SELF.x = pixelX; SELF.y = pixelY;
        }
    }

    @role var SNAKE : {
        function addChild(child : pixi.DisplayObject) : Void;
        function removeChildAt(index : Int) : Void;
        function xy(index : Int, x : Float, y : Float) : Void;
        var length : Float;

        public function display(segments : ds.ImmutableArray<Coordinate>) {
            var i = 0;
            for(segment in segments) {
                var pixelX = segment.x * _segmentPixelSize;
                var pixelY = segment.y * _segmentPixelSize;

                if(i >= SELF.length) {
                    var newSprite = _game.add.sprite(
                        pixelX, pixelY, 
                        SELF.length == 0 ? _textures.head : _textures.segment
                    );
                    SELF.addChild(newSprite);
                    if(i == 0) _game.camera.follow(newSprite);
                }
                else
                    SELF.xy(i, pixelX, pixelY);

                i = i + 1;
            }

            while(i < SELF.length)
                removeChildAt(Std.int(SELF.length-1));
        }
    }

    @role var SCORE : {
        function setText(text : String, immediate : Bool) : Void;

        public function display(score : Int) {
            SELF.setText('Score: $score', false);
        }
    }

    @role var HISCORE : {
        function setText(text : String, immediate : Bool) : Void;

        public function display(hiscore : Int) {
            SELF.setText('Hi-score: $hiscore', false);
        }
    }
}

/////////////////////////////////////////////////////////////////////

/**
 * Graphical resources
 */
private class Textures {
    public final head : RenderTexture;
    public final segment : RenderTexture;
    public final fruit : RenderTexture;
    public final background : String;

    public function new(game : Game, segmentSize : Float) {

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
        fruit.drawRect(0,0, segmentSize-4,segmentSize-4);
        fruit.endFill();

        var background = 'background';
        game.load.image(background, 'assets/connectwork.png');

        this.head = head.generateTexture();
        this.segment = segment.generateTexture(); 
        this.fruit = fruit.generateTexture();
        this.background = background;
    }
}
