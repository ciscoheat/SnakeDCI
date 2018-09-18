package contexts;

import phaser.GameObjectFactory;
import phaser.Math;
import phaser.Keyboard;
import phaser.Group;
import phaser.Text;
import phaser.PhaserTextStyle;

using Lambda;

private typedef Segment = {
    var x : Float;
    var y : Float;
}

class Collisions implements dci.Context {
    public function new(game : SnakeGame, movement : Movement) {
        this.SNAKE = game.playfield.snake;
        this.FRUIT = game.playfield.fruit;
        this.SCORE = game.score;
        this.SCREEN = game.game;
        this.HISCORE = game.hiscore;

        this._game = game;
        this._movement = movement;
        this._segmentSize = game.segmentSize;
    }

    ///// System operations  //////////////////////////////////////

    public function checkCollisions() {
        SNAKE.checkForFruitCollision(_game.playfield.width);
        SNAKE.checkForCollisionWithItself();
    }

    ///// Context state ///////////////////////////////////////////

    final _game : SnakeGame;
    final _movement : Movement;
    final _segmentSize : Float;

    ///// Helper methods //////////////////////////////////////////

    // Test collisions
    function collides(o1 : Segment, o2 : Segment) : Bool {
        var x1 = Math.snapToFloor(o1.x, _segmentSize);
        var y1 = Math.snapToFloor(o1.y, _segmentSize);
        var x2 = Math.snapToFloor(o2.x, _segmentSize);
        var y2 = Math.snapToFloor(o2.y, _segmentSize);

        return x1 == x2 && y1 == y2;
    }

    // Add event for pressing space, then restart game
    function waitForGameRestart() {
        _game.game.input.keyboard.addKey(Keyboard.SPACEBAR)
            .onUp.addOnce(_game.game.state.restart);
    }

    ///// Roles ///////////////////////////////////////////////////

    @role var SNAKE : {
        function getAt(index : Float) : haxe.extern.EitherType<pixi.DisplayObject, Float>;
        var length(default, null) : Float;

        public function segments() : Array<Segment> return cast [
            for(i in 0...Std.int(SELF.length)) SELF.getAt(i)
        ];

        public function checkForFruitCollision(playfieldWidth : Float) {
            if(collides(cast SELF.getAt(0), FRUIT))
                FRUIT.moveToRandomLocation(playfieldWidth);
        }

        public function checkForCollisionWithItself() {
            var snakeSegments = SELF.segments();
            var head = snakeSegments.shift();

            if(snakeSegments.exists(s -> collides(s, head))) {
                _movement.stop();
                SCREEN.showGameOver();
            }
        }

        public function addSegment() {
            _movement.growOnNextMove();
        }
    }

    @role var FRUIT : {
        var x : Float;
        var y : Float;

        public function moveToRandomLocation(playfieldWidth : Float) {
            do {
                var max = Std.int(playfieldWidth / _segmentSize);
                SELF.x = Std.random(max) * _segmentSize + 1;
                SELF.y = Std.random(max) * _segmentSize + 1;
            } while(SNAKE.segments().exists(s -> collides(s, SELF)));

            SCORE.increase();
        }
    }

    @role var SCORE : {
        function setText(text : String, ?immediate : Bool) : Void;
        var health : Float;
    
        public function increase() {
            SELF.health += 10;
            SELF.setText('Score: ' + SELF.health);
            SNAKE.addSegment();
        }

        public function submitHiscore() {
            HISCORE.update(SELF.health);
        }
    }

    @role var HISCORE : {
        var health : Float;
    
        public function update(currentScore) {
            // TODO: Save hiscore in browser
            SELF.health = Math.max(SELF.health, currentScore);

            waitForGameRestart();
        }
    }
    
    @role var SCREEN : {
        var height : Float;
        var width : Float;
        var add : GameObjectFactory;

        public function showGameOver() {
            SELF.add.text(0,0, "GAME OVER", cast {
                font: "50px Arial",
                fill: "#ffffff",
                stroke: "#000000",
                strokeThickness: 3,
                align: "center",
                boundsAlignH: 'center',
                boundsAlignV: 'middle',
            }).setTextBounds(0, -20, SELF.width, SELF.height);

            SELF.add.text(0,0, "Press space to restart", cast {
                font: "20px Arial",
                fill: "#ffffff",
                stroke: "#000000",
                strokeThickness: 2,
                align: "center",
                boundsAlignH: 'center',
                boundsAlignV: 'middle',
            }).setTextBounds(0, 30, SELF.width, SELF.height);

            SCORE.submitHiscore();
        }
    }
}
