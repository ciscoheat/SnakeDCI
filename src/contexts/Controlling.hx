package contexts;

import ds.ImmutableArray;
import GameState.Coordinate;
import GameState.State;
import phaser.Phaser;

class Controlling implements dci.Context {
    public function new(SNAKE, CONTROLLER, BUFFER, asset) {
        this.SNAKE = SNAKE;
        this.CONTROLLER = CONTROLLER;
        this.BUFFER = BUFFER;

        this._asset = asset;
    }

    ///// System Operations /////////////////////////////////////////

    public function start() {
        BUFFER.addControllerDirection();
    }

    ///// Context state /////////////////////////////////////////////

    final _asset : GameState;

    ///// Helper methods ////////////////////////////////////////////

    ///// Roles /////////////////////////////////////////////////////

    @role var SNAKE : {
        final segments : ImmutableArray<Coordinate>;

        public function isAt(pos : Coordinate) 
            return segments[0].x == pos.x && segments[0].y == pos.y;

        public function position() return segments[0];
    }

    @role var BUFFER : {
        final directions : ImmutableArray<Float>;
        final position : Coordinate;

        public function addControllerDirection() {
            var dir = CONTROLLER.currentDirection();
            if(dir == 0) return;

            if(SNAKE.isAt(SELF.position)) {
                if(!SELF.directions.last().equals(Some(dir)))
                    _asset.updateDirection(dir, None);
            }
            else
                _asset.updateDirection(dir, Some(SNAKE.position()));
        }
    }

    @role var CONTROLLER : {
        var left(default, never) : {var isDown : Bool;};
        var right(default, never) : {var isDown : Bool;};
        var up(default, never) : {var isDown : Bool;};
        var down(default, never) : {var isDown : Bool;};

        public function currentDirection() {
            return if(left.isDown) Phaser.LEFT
            else   if(right.isDown) Phaser.RIGHT
            else   if(up.isDown) Phaser.UP
            else   if(down.isDown) Phaser.DOWN
            else   0;
        }
    }
}