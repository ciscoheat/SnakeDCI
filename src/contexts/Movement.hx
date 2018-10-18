package contexts;

import phaser.Game;
import GameState.Coordinate;
import phaser.Timer;
import phaser.Phaser;
import ds.ImmutableArray;

private typedef Segment = {
    var x : Float;
    var y : Float;
}

class Movement implements dci.Context {
    public function new(game : Game, asset : GameState) {
        this._game = game;
        this._asset = asset;

        this.PLAYFIELD = asset.state.playfield;
        this.SNAKE = asset.state.snake;
        this.HEAD = asset.state.snake.segments[0];
        this.SEGMENTS = asset.state.snake.segments;

        // Calculate movement direction based on first two segments.
        // Can't be easily done anywhere else but in the constructor
        // because of screen wrapping.
        /*
        this._wantedDirection = this._currentDirection = {
            var head : Segment = cast segments.getAt(0);
            var body : Segment = cast segments.getAt(1);

            var diffY = Math.abs(body.y - head.y);
            var diffX = Math.abs(body.x - head.x);

            if(diffY < diffX) {
                if(body.x > head.x) Phaser.LEFT
                else Phaser.RIGHT;
            } else {
                if(body.y > head.y) Phaser.UP
                else Phaser.DOWN;
            }
        }
        */
    }

    ///// System operations ///////////////////////////////////////

    public function move() {
        var movementTime = SNAKE.nextMoveTime - _game.time.physicsElapsedMS;
        if(movementTime <= 0)
            HEAD.moveOneStepAhead(movementTime);
        else
            _asset.updateMoveTimer(movementTime);
    }

    // Signal that the snake should grow on its next movement.
    public function growOnNextMove() {
        _growOnNextMove = true;
    }

    ///// Context state ///////////////////////////////////////////

    final _asset : GameState;
    final _game : Game;

    var _growOnNextMove : Bool = false;

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

            SEGMENTS.moveTo(nextX, nextY, moveDir, timerDelta);
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

    @role var SEGMENTS : {
        function iterator() : Iterator<Coordinate>;

        // Move all segments to a new position
        public function moveTo(x : Int, y : Int, newDir : Float, timerDelta : Float) {
            // TODO: Possibly change this Role to an array, to avoid copy by looping
            var newPos = [for(segment in SELF) segment];
            newPos.unshift({x: x, y: y});
            newPos.pop();

            /*
            if(_growOnNextMove) {
                SELF.addSegment(x, y);
                _growOnNextMove = false;
            }
            */

            _asset.moveSnake(newPos, newDir, SELF.moveSpeed(newPos.length) + timerDelta);
        }

        // Snake movement speed, per ms
        function moveSpeed(numberOfSegments : Int) {
            return Math.max(150 - numberOfSegments * 3, 50);
        }
    }

    // Move to Controlling Context
    /*
    @role var CONTROLLER : {
        var left : {var isDown : Bool;};
        var right : {var isDown : Bool;};
        var up : {var isDown : Bool;};
        var down : {var isDown : Bool;};

        function direction() {
            return if(left.isDown) Phaser.LEFT
            else   if(right.isDown) Phaser.RIGHT
            else   if(up.isDown) Phaser.UP
            else   if(down.isDown) Phaser.DOWN
            else   0;
        }

        public function updateDirection() {
            var keyboardDir = SELF.direction();
            if(keyboardDir != 0) _wantedDirection = keyboardDir;
        }
    }
    */
}
