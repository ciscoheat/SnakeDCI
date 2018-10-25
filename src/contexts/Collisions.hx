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

        if(SNAKE.checkForCollisionWithItself())
            new GameOver(_asset, _game).start();
    }

    ///// Context state ///////////////////////////////////////////

    final _game : Game;
    final _asset : GameState;

    ///// Helper methods //////////////////////////////////////////

    // Test collisions
    inline function collides(c1 : Coordinate, c2 : Coordinate) : Bool
        return c1.x == c2.x && c1.y == c2.y;

    ///// Roles ///////////////////////////////////////////////////

    @role var SNAKE : {
        final segments : ImmutableArray<Coordinate>;

        public function checkForFruitCollision() {
            if(SELF.collidesWith(FRUIT))
                FRUIT.moveToRandomLocation();
        }

        public function checkForCollisionWithItself() : Bool {
            var head = SELF.segments[0];
            var body = SELF.segments.shift();

            return body.exists(seg -> collides(seg, head));
        }

        public function collidesWith(coord : Coordinate) {
            return SELF.segments.exists(seg -> collides(seg, coord));
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
        function fruitEaten(score : Int, newPos : Coordinate) : Void;

        public function increase(newPos : Coordinate) {
            _asset.fruitEaten(10, newPos);
        }
    }
}
