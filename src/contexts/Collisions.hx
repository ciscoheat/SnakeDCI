package contexts;

import phaser.Game;
import phaser.GameObjectFactory;
import phaser.Math;
import phaser.Keyboard;
import phaser.Group;
import phaser.Text;
import phaser.PhaserTextStyle;
import GameState.Coordinate;
import ds.ImmutableArray;

using Lambda;

class Collisions implements dci.Context {
    public function new(asset : GameState, game : Game) {
        this.SNAKE = asset.state.snake;
        this.FRUIT = asset.state.fruit;
        this.SCORE = asset;

        this._game = game;
        this._asset = asset;
    }

    ///// System operations  //////////////////////////////////////

    public function checkCollisions() {
        SNAKE.checkForFruitCollision();
        SNAKE.checkForCollisionWithItself();
    }

    ///// Context state ///////////////////////////////////////////

    final _game : Game;
    final _asset : GameState;

    ///// Helper methods //////////////////////////////////////////

    // Test collisions
    inline function collides(c1 : Coordinate, c2 : Coordinate) : Bool
        return c1.x == c2.x && c1.y == c2.y;

    /*
    // Add event for pressing space, then restart game
    function waitForGameRestart() {
        _game.game.input.keyboard.addKey(Keyboard.SPACEBAR)
            .onUp.addOnce(_game.game.state.restart);
    }
    */

    ///// Roles ///////////////////////////////////////////////////

    @role var SNAKE : {
        final segments : ImmutableArray<Coordinate>;

        public function checkForFruitCollision() {
            if(collides(SELF.segments[0], FRUIT))
                FRUIT.moveToRandomLocation();
        }

        public function checkForCollisionWithItself() {
            var head = SELF.segments[0];
            var body = SELF.segments.shift();

            if(Lambda.exists(body, s -> collides(s, head))) {
                trace("GAME OVER");
            }
        }

        public function collidesWith(c : Coordinate) {
            return Lambda.exists(SELF.segments, s -> collides(s, c));
        }

        public function addSegment() {
            //_movement.growOnNextMove();
        }
    }

    @role var FRUIT : {
        final x : Int;
        final y : Int;

        public function moveToRandomLocation() {
            var newPos : Coordinate;
            do {
                var newX = Std.random(_asset.state.playfield.width);
                var newY = Std.random(_asset.state.playfield.height);
                newPos = {x : newX, y : newY};
            } while(SNAKE.collidesWith(newPos));

            SCORE.increase(newPos);
        }
    }

    @role var SCORE : {
        function fruitEaten(newPos : Coordinate) : Void;

        public function increase(newPos : Coordinate) {
            _asset.fruitEaten(newPos);
        }
    }

    /*
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
    */
}
