package data;

class Snake implements dci.Context {
    public function new(SEGMENTS, CURRENT_DIRECTION) {
        this.SEGMENTS = SEGMENTS;
        this.CURRENT_DIRECTION = CURRENT_DIRECTION;
    }

    ///// System Operations /////////////////////////////////////////

    public function start() {
        SEGMENTS.interact();
    }

    ///// Context state /////////////////////////////////////////////

    ///// Helper methods ////////////////////////////////////////////

    ///// Roles /////////////////////////////////////////////////////

    @role var SEGMENTS : {
        var x : Float;
        function doSomething() : Void;

        public function interact() {
            CURRENT_DIRECTION.test();
        }
    }

    @role var CURRENT_DIRECTION : {
        var x : Float;
        function doSomething() : Void;

        public function test() {
            SELF.doSomething();
        }
    }



}

/*
class Snake {
    var _textures : SnakeGame.Textures;

    public function new(game, textures) {
        super(game);
        this._textures = textures;
    }

    public function addSegment(x, y) {
        this.create(x, y, this.length == 0 ? _textures.head : _textures.segment);
    }
}
*/
