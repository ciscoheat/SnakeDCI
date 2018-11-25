package contexts;

import GameState.State;
import phaser.Phaser;

class Controlling implements dci.Context {
    public function new(asset : GameState, CONTROLLER) {
        this.SNAKE = asset.state.snake;
        this.CONTROLLER = CONTROLLER;
        this._asset = asset;
    }

    ///// System Operations /////////////////////////////////////////

    public function checkDirection() {
        return SNAKE.checkDirection();
    }

    ///// Context state /////////////////////////////////////////////

    final _asset : GameState;

    ///// Helper methods ////////////////////////////////////////////

    ///// Roles /////////////////////////////////////////////////////

    @role var SNAKE : {
        public function checkDirection() {
            var wantedDirection = CONTROLLER.direction();
            return wantedDirection == 0 
                ? _asset
                : _asset.update(_asset.state.snake.wantedDirection, wantedDirection);
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