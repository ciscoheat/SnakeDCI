package contexts;

import GameState.State;

class Scoring implements dci.Context {
    public function new(snake, head, fruit, playfield) {
        this.SNAKE = snake;
        this.HEAD = head;
        this.FRUIT = fruit;
        this.PLAYFIELD = playfield;
    }

    ///// System Operations /////////////////////////////////////////

    public function allowedMovesUntilScoreDecrease() {
        final xDist = Math.abs(FRUIT.x - HEAD.x);
        final yDist = Math.abs(FRUIT.y - HEAD.y);

        final xDistWrapped = Math.abs((FRUIT.x - PLAYFIELD.width) - HEAD.x);
        final yDistWrapped = Math.abs((FRUIT.y - PLAYFIELD.height) - HEAD.y);

        trace('$xDist,$yDist - $xDistWrapped,$yDistWrapped');

        return Std.int(Math.min(xDist + yDist, xDistWrapped + yDistWrapped) * 1.5 + SNAKE.segmentLength());
    }

    public function scoreDecrease(exceededMoves : Int, currentScore) {
        return currentScore == 0 ? 0 : exceededMoves % 2 == 0 ? 1 : 0;
    }

    ///// Roles /////////////////////////////////////////////////////

    @role var HEAD : {
        public final x : Int;
        public final y : Int;
    }

    @role var FRUIT : {
        public final x : Int;
        public final y : Int;
    }

    @role var SNAKE : {
        public var length(default, null) : Int;

        public function segmentLength() return length;
    }

    @role var PLAYFIELD : {
        public final width : Int;
        public final height : Int;    
    }
}