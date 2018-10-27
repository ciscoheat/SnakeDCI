import ds.ImmutableArray;
import phaser.Phaser;

typedef Coordinate = {
    final x : Int;
    final y : Int;
}

typedef State = {
    final snake : {
        final segments : ImmutableArray<Coordinate>;
        final nextMoveTime : Float;
        final currentDirection : Float;
        final wantedDirection : Float;
    };
    final fruit : Coordinate;
    final score : Int;
    final hiScore : Int;
    final playfield : {
        final width : Int;
        final height : Int;
        final squareSize : Int;
    }
    final active : Bool;
}

class GameState extends DeepState<State> {
    public function new(playfieldSize : Int, segmentSize : Int) {
        // Initial state
        super({
            snake: {
                segments: [],
                nextMoveTime: 0.0,
                currentDirection: 0,
                wantedDirection: 0
            },
            fruit: {x: 0, y: 0},
            score: 0,
            hiScore: 0,
            playfield: {
                width: playfieldSize,
                height: playfieldSize,
                squareSize: segmentSize
            },
            active: false
        });
    }

    ///// Actions ///////////////////////////////////////////////////

    public function fruitEaten(score : Int, newFruitPos : Coordinate) {
        return updateMap([
            state.score => s -> s + score,
            state.fruit => newFruitPos,
            state.snake.segments => s -> s.push(s[s.length-1])
        ]);
    }

    public function gameOver() {
        return updateIn(state.active, false);
    }

    public function moveSnake(
        newSegments : ImmutableArray<Coordinate>, 
        newDir : Float, speed : Float) 
    {
        return updateIn(state.snake, {
            segments: newSegments,
            nextMoveTime: speed,
            currentDirection: newDir,
            wantedDirection: newDir
        });
    }

    public function initializeGame(
        startSegments : ImmutableArray<Coordinate>, 
        fruitPos : Coordinate, 
        hiScore : Int) 
    {
        return updateMap([
            state.snake => {
                segments: startSegments,
                nextMoveTime: 0.0,
                currentDirection: Phaser.RIGHT,
                wantedDirection: Phaser.RIGHT
            },
            state.score => 0,
            state.hiScore => hiScore,
            state.fruit => fruitPos,
            state.active => true
        ]);
    }

    public function updateMoveTimer(nextMoveTime : Float) {
        return updateIn(state.snake.nextMoveTime, nextMoveTime);
    }

    public function updateDirection(wantedDirection : Float) {
        return updateIn(state.snake.wantedDirection, wantedDirection);
    }
}
