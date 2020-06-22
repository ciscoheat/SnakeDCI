package contexts;

import phaser.Game;
import GameState.Coordinate;
import GameState.State;
import ds.ImmutableArray;

using Lambda;

class Collisions implements dci.Context {
    public function new(asset : DeepState<State>) {
        this.SNAKE = asset.state.snake;
        this.FRUIT = asset.state.fruit;
        this.GAME = asset.state;

        this._asset = asset;
    }

    ///// System operations  //////////////////////////////////////

    public function checkCollisions(game : Game) {
        return if(SNAKE.checkForFruitCollision())
            FRUIT.moveToRandomLocation();
        else if(SNAKE.checkForCollisionWithItself())
            new GameOver(_asset, game).start();
        else
            _asset;
    }

    ///// Context state ///////////////////////////////////////////

    final _asset : DeepState<State>;

    ///// Helper methods //////////////////////////////////////////

    // Test collisions
    inline function collides(c1 : Coordinate, c2 : Coordinate) : Bool
        return c1.x == c2.x && c1.y == c2.y;

    ///// Roles ///////////////////////////////////////////////////

    @role var SNAKE : {
        final segments : ImmutableArray<Coordinate>;

        public function checkForFruitCollision() {
            return SELF.collidesWith(FRUIT);
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

            // Calculate how many moves player have to move to the next fruit
            final moveTime = new Scoring(SNAKE.segments, SNAKE.segments[0], fruitPos, _asset.state.playfield).allowedMovesUntilScoreDecrease();

            return _asset.update(
                _asset.state.score = score,
                _asset.state.fruit = fruitPos,
                _asset.state.snake.segments = newSegments,
                _asset.state.snake.moveCounter = moveTime,
                "SNAKE.addSegment"
            );
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
