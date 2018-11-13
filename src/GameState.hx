import haxecontracts.*;
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

class GameState extends DeepState<State> implements HaxeContracts {
    public function new(playfieldSize : Int, segmentSize : Int) {
        // Initial state
        super({
            snake: {
                segments: [],
                nextMoveTime: 0,
                currentDirection: Phaser.RIGHT,
                wantedDirection: Phaser.RIGHT
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

    public function fruitEaten(
        newScore : Int, 
        newFruitPos : Coordinate, 
        newSegments : ImmutableArray<Coordinate>
    ) {
        Contract.ensures(Contract.result.score >= Contract.old(newScore), "Score decreased.");

        return updateMap([
            state.score => newScore,
            state.fruit => newFruitPos,
            state.snake.segments => newSegments
        ]);
    }

    public function gameOver() {
        return updateIn(state.active, false);
    }

    public function moveSnake(
        newSegments : ImmutableArray<Coordinate>, 
        newDir : Float, speedMs : Float) 
    {
        return updateIn(state.snake, {
            segments: newSegments,
            nextMoveTime: speedMs,
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

    ///// Contract invariants ///////////////////////////////////////

    @invariants function invariants() {
        Contract.invariant(
            state.fruit.x >= 0 && state.fruit.x < state.playfield.width &&
            state.fruit.y >= 0 && state.fruit.y < state.playfield.height
        , "Fruit outside playfield.");

        Contract.invariant(!state.snake.segments.exists(s ->
            (s.x < 0 || s.x >= state.playfield.width) ||
            (s.y < 0 || s.y >= state.playfield.height)
        ), "Snake segment outside playfield.");

        Contract.invariant(state.snake.currentDirection > 0);
        Contract.invariant(state.snake.wantedDirection > 0);
        Contract.invariant(state.snake.nextMoveTime >= 0);

        Contract.invariant(state.score >= 0);
        Contract.invariant(state.hiScore >= 0);

        Contract.invariant(state.playfield.width > 0);
        Contract.invariant(state.playfield.height > 0);
    }
}
