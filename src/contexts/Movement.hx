package contexts;

import GameState.Coordinate;
import phaser.Phaser;
import ds.ImmutableArray;

class Movement implements dci.Context {
    public function new(asset : GameState, msElapsed : Float) {
        this._asset = asset;

        this.PLAYFIELD = asset.state.playfield;
        this.SNAKE = asset.state.snake;
        this.HEAD = asset.state.snake.segments[0];

        move(msElapsed);
    }

    ///// System operations ///////////////////////////////////////

    function move(msElapsed : Float) {
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
        public final nextMoveTime : Float;
        final currentDirection : Float;
        final wantedDirection : Float;
        final segments : ImmutableArray<Coordinate>;

        // Move all segments to a new position
        public function moveTo(x : Int, y : Int, newDir : Float, timerDelta : Float) {

            // Remove last segment and add a new one in the front position.
            var newPos = SELF.segments.pop().unshift({x: x, y: y});

            _asset.moveSnake(newPos, newDir, SELF.moveSpeed(newPos.length) + timerDelta);
        }

        public function moveDirection() : Float {
            // Disallow 180 degree turns
            return if(
                (SELF.wantedDirection == Phaser.RIGHT && SELF.currentDirection == Phaser.LEFT) ||
                (SELF.wantedDirection == Phaser.LEFT && SELF.currentDirection == Phaser.RIGHT) ||
                (SELF.wantedDirection == Phaser.UP && SELF.currentDirection == Phaser.DOWN) ||
                (SELF.wantedDirection == Phaser.DOWN && SELF.currentDirection == Phaser.UP)
            ) SELF.currentDirection else SELF.wantedDirection;
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
            var moveDir = SNAKE.moveDirection();

                 if(moveDir == Phaser.UP)    nextY = y - 1;
            else if(moveDir == Phaser.DOWN)  nextY = y + 1;
            else if(moveDir == Phaser.LEFT)  nextX = x - 1;
            else if(moveDir == Phaser.RIGHT) nextX = x + 1;

            // Wrap around playfield
            if(nextX >= PLAYFIELD.width) nextX = 0;
            else if(nextX < 0) nextX = PLAYFIELD.width - 1;
            
            if(nextY >= PLAYFIELD.height) nextY = 0;
            else if(nextY < 0) nextY = PLAYFIELD.height - 1;

            SNAKE.moveTo(nextX, nextY, moveDir, timerDelta);
        }
    }
}
