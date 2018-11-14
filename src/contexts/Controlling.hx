package contexts;

import GameState.State;
import phaser.Phaser;

class Controlling implements dci.Context {
    public function new(SNAKE, CONTROLLER) {
        this.SNAKE = SNAKE;
        this.CONTROLLER = CONTROLLER;

        checkDirection();
    }

    ///// System Operations /////////////////////////////////////////

    function checkDirection() {
        SNAKE.checkDirection();
    }

    ///// Context state /////////////////////////////////////////////

    ///// Helper methods ////////////////////////////////////////////

    ///// Roles /////////////////////////////////////////////////////

    @role var SNAKE : {
        function updateDirection(wantedDirection : Float) : Void;

        public function checkDirection() {
            var dir = CONTROLLER.direction();
            if(dir != 0) updateDirection(dir);
        }
    }

    // TODO: A more precise input method with buffering
    @role var CONTROLLER : {
        var left(default, never) : {var isDown : Bool;};
        var right(default, never) : {var isDown : Bool;};
        var up(default, never) : {var isDown : Bool;};
        var down(default, never) : {var isDown : Bool;};

        public function direction() {
            return if(left.isDown) Phaser.LEFT
            else   if(right.isDown) Phaser.RIGHT
            else   if(up.isDown) Phaser.UP
            else   if(down.isDown) Phaser.DOWN
            else   0;
        }
    }
}