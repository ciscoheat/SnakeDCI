package contexts;

import phaser.Game;
import GameState.Coordinate;
import ds.ImmutableArray;

using Lambda;

class Collisions implements dci.Context {
    public function new(asset : GameState) {
        this.SNAKE = asset.state.snake;
        this.FRUIT = asset.state.fruit;
        this.GAME = asset.state;

        this._asset = asset;
    }

    ///// System operations  //////////////////////////////////////

    public function checkCollisions(game : Game) {
        var next = SNAKE.checkForFruitCollision(_asset);

        return if(SNAKE.checkForCollisionWithItself())
            new GameOver(next, game).start();
        else
            next;
    }

    ///// Context state ///////////////////////////////////////////

    final _asset : GameState;

    ///// Helper methods //////////////////////////////////////////

    // Test collisions
    inline function collides(c1 : Coordinate, c2 : Coordinate) : Bool
        return c1.x == c2.x && c1.y == c2.y;

    ///// Roles ///////////////////////////////////////////////////

    @role var SNAKE : {
        final segments : ImmutableArray<Coordinate>;

        public function checkForFruitCollision(state) {
            return if(SELF.collidesWith(FRUIT))
                FRUIT.moveToRandomLocation();
            else
                state;
        }

        public function checkForCollisionWithItself() : Bool {
            var head = SELF.segments[0];
            var body = SELF.segments.shift();

            return body.exists(seg -> collides(seg, head));
        }

        public function collidesWith(coord : Coordinate) {
            return SELF.segments.exists(seg -> collides(seg, coord));
        }

        public function addSegment(fruitPos : Coordinate, score : Int) {
            // Append a copy of the last segment to the segments
            var newSegments = SELF.segments.push(SELF.segments[SELF.segments.length-1]);
            return _asset.fruitEaten(score, fruitPos, newSegments);
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

            return GAME.increaseScore(newPos);
        }
    }

    @role var GAME : {
        final score : Int;

        public function increaseScore(newFruitPos : Coordinate) {
            return SNAKE.addSegment(newFruitPos, SELF.score + 10);
        }
    }
}
