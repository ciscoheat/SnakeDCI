package contexts;

import phaser.Game;
import GameState.Coordinate;
import phaser.Timer;
import phaser.Phaser;
import ds.ImmutableArray;

class Movement implements dci.Context {
    public function new(asset : GameState) {
        this._asset = asset;

        this.PLAYFIELD = asset.state.playfield;
        this.SNAKE = asset.state.snake;
        this.HEAD = asset.state.snake.segments[0];
    }

    ///// System operations ///////////////////////////////////////

    public function move(msElapsed : Float) {
        var movementTime = SNAKE.nextMoveTime - msElapsed;

        if(movementTime <= 0)
            HEAD.moveOneStepAhead(movementTime);
        else
            _asset.updateMoveTimer(movementTime);
    }

    ///// Context state ///////////////////////////////////////////

    final _asset : GameState;

    ///// Helper methods //////////////////////////////////////////

    function dir2Text(dir : Float) return
        if(dir == Phaser.UP) "UP"
        else if(dir == Phaser.DOWN) "DOWN"
        else if(dir == Phaser.LEFT) "LEFT"
        else if(dir == Phaser.RIGHT) "RIGHT"
        else "<NOWHERE>";

    ///// Roles ///////////////////////////////////////////////////

    @role var PLAYFIELD : {
        public final width : Int;
        public final height : Int;    
    }

    @role var SNAKE : {
        public final currentDirection : Float;
        public final wantedDirection : Float;
        public final nextMoveTime : Float;

        final segments : ImmutableArray<Coordinate>;

        // Move all segments to a new position
        public function moveTo(x : Int, y : Int, newDir : Float, timerDelta : Float) {
            var newPos = SELF.segments.copy();
            newPos.unshift({x: x, y: y});
            newPos.pop();

            _asset.moveSnake(newPos, newDir, SELF.moveSpeed(newPos.length) + timerDelta);
        }

        // Snake movement speed, per ms
        function moveSpeed(numberOfSegments : Int) {
            return Math.max(150 - numberOfSegments * 3, 50);
        }
    }

    @role var HEAD : {
        final x : Int;
        final y : Int;

        // Moves the snake one step ahead based on the wanted movement direction.
        public function moveOneStepAhead(timerDelta : Float) {
            var nextX = x, nextY = y;

            // Change position of head
            var moveDir = SELF.disallowOppositeDirectionMove();

            if(moveDir == Phaser.UP) nextY = y - 1;
            else if(moveDir == Phaser.DOWN) nextY = y + 1;
            else if(moveDir == Phaser.LEFT) nextX = x - 1;
            else if(moveDir == Phaser.RIGHT) nextX = x + 1;

            // Wrap around playfield
            if(nextX >= PLAYFIELD.width) nextX = 0;
            else if(nextX < 0) nextX = PLAYFIELD.width - 1;
            
            if(nextY >= PLAYFIELD.height) nextY = 0;
            else if(nextY < 0) nextY = PLAYFIELD.height - 1;

            SNAKE.moveTo(nextX, nextY, moveDir, timerDelta);
        }

        // Disallow 180 degree turns
        function disallowOppositeDirectionMove() {
            return if(
                (SNAKE.wantedDirection == Phaser.RIGHT && SNAKE.currentDirection == Phaser.LEFT) ||
                (SNAKE.wantedDirection == Phaser.LEFT && SNAKE.currentDirection == Phaser.RIGHT) ||
                (SNAKE.wantedDirection == Phaser.UP && SNAKE.currentDirection == Phaser.DOWN) ||
                (SNAKE.wantedDirection == Phaser.DOWN && SNAKE.currentDirection == Phaser.UP)
            ) SNAKE.currentDirection else SNAKE.wantedDirection;
        }
    }
}
