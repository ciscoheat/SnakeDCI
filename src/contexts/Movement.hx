package contexts;

import phaser.Timer;
import phaser.Phaser;

private typedef Segment = {
    var x : Float;
    var y : Float;
}

class Movement implements dci.Context {
    public function new(game : SnakeGame, segments, keyboard, fieldSize) {
        this.SEGMENTS = segments;
        this.HEAD = cast segments.getAt(0);
        this.KEYBOARD = keyboard;

        if(segments.length < 2) throw "SEGMENTS length must be more than 1.";

        this._fieldSize = fieldSize;
        this._game = game;
        this._movementTimer = game.game.time.create(false);

        // Calculate movement direction based on first two segments.
        // Can't be easily done anywhere else but in the constructor
        // because of screen wrapping.
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
    }

    ///// System operations ///////////////////////////////////////

    // Updates the wanted movement direction.
    public function checkDirectionChange() {
        KEYBOARD.updateDirection();
    }

    public function start() {
        _movementTimer.start();

        (function moveEvent() {            
            HEAD.move();
            new Collisions(_game, this).checkCollisions();
            _movementTimer.add(SEGMENTS.moveSpeed(), moveEvent);
        })();
    }

    public function stop() {
        _movementTimer.stop();
    }

    // Signal that the snake should grow on its next movement.
    public function growOnNextMove() {
        _growOnNextMove = true;
    }

    ///// Context state ///////////////////////////////////////////

    final _fieldSize : {width: Float, height: Float};
    final _game : SnakeGame;
    final _movementTimer : Timer;

    var _wantedDirection : Float;
    var _currentDirection : Float;
    var _growOnNextMove : Bool = false;

    ///// Helper methods //////////////////////////////////////////

    function dir2Text(dir : Float) return
        if(dir == Phaser.UP) "UP"
        else if(dir == Phaser.DOWN) "DOWN"
        else if(dir == Phaser.LEFT) "LEFT"
        else if(dir == Phaser.RIGHT) "RIGHT"
        else "<NOWHERE>";

    ///// Roles ///////////////////////////////////////////////////

    @role var HEAD : {
        var x : Float;
        var y : Float;
        var width : Float;
        var height : Float;

        // Moves the snake one step ahead based on the wanted movement direction.
        public function move() {
            // Save current position, the next segment will move there.
            var prevX = x, prevY = y;

            // Change position of head
            var moveDir = SELF.disallowOppositeDir();

            if(moveDir == Phaser.UP) y -= height;
            else if(moveDir == Phaser.DOWN) y += height;
            else if(moveDir == Phaser.LEFT) x -= width;
            else if(moveDir == Phaser.RIGHT) x += width;

            _currentDirection = moveDir;

            // Wrap around playfield
            if(x >= _fieldSize.width) x = 0;
            else if(x < 0) x = _fieldSize.width - width;
            
            if(y >= _fieldSize.height) y = 0;
            else if(y < 0) y = _fieldSize.height - height;

            SEGMENTS.moveTo(prevX, prevY);
        }

        // Disallow 180 degree turns
        function disallowOppositeDir() {
            return if(
                (_wantedDirection == Phaser.RIGHT && _currentDirection == Phaser.LEFT) ||
                (_wantedDirection == Phaser.LEFT && _currentDirection == Phaser.RIGHT) ||
                (_wantedDirection == Phaser.UP && _currentDirection == Phaser.DOWN) ||
                (_wantedDirection == Phaser.DOWN && _currentDirection == Phaser.UP)
            ) _currentDirection else _wantedDirection;
        }
    }

    @role var SEGMENTS : {
        function getAt(index : Float) : haxe.extern.EitherType<pixi.DisplayObject, Float>;
        function addSegment(x : Float, y : Float) : Void;
        var length(default, null) : Float;

        // Move all segments to the position in front, starting with x,y
        public function moveTo(x : Float, y : Float) {
            for(i in 1...Std.int(SELF.length)) {
                var segment : Segment = cast SELF.getAt(i);
                var prevX = segment.x, prevY = segment.y;

                segment.x = x; segment.y = y;
                x = prevX; y = prevY;
            }

            if(_growOnNextMove) {
                SELF.addSegment(x, y);
                _growOnNextMove = false;
            }
        }

        // Snake movement speed, per ms
        public function moveSpeed() {
            return Math.max(150 - SELF.length * 3, 50);
        }
    }

    @role var KEYBOARD : {
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
}
