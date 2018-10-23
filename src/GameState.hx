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
}

class GameState extends DeepState<State> {
    public function new(playfieldSize : Int, segmentSize : Int) {
        // Initial state
        super({
            snake: {
                segments: [],
                nextMoveTime: 0.0,
                currentDirection: Phaser.RIGHT,
                wantedDirection: Phaser.RIGHT
            },
            fruit: {x: 0, y: 0},
            score: 0,
            // TODO: Load highscore from browser
            hiScore: 0,
            playfield: {
                width: playfieldSize,
                height: playfieldSize,
                squareSize: segmentSize
            }
        });
    }

    ///// Actions ///////////////////////////////////////////////////

    public function initializeGame() {
        var X = Std.int(state.playfield.width / 2);
        var Y = Std.int(state.playfield.height / 2);

        var segments = [{x: X, y: Y}, {x: X-1, y: Y}, {x: X-2, y: Y}];

        return updateMap([
            state.snake => {
                segments: segments,
                nextMoveTime: 0.0,
                currentDirection: Phaser.RIGHT,
                wantedDirection: Phaser.RIGHT
            },
            state.score => 0,
            state.fruit => {
                x: Std.int(Std.random(state.playfield.width)), 
                y: Std.int(Std.random(state.playfield.height))
            }
        ]);
    }

    public function fruitEaten(newFruitPos : Coordinate) {
        return updateMap([
            state.score => s -> s + 10,
            state.fruit => newFruitPos,
            state.snake.segments => s -> s.push(s[s.length-1])
        ]);
    }

    public function updateMoveTimer(nextMoveTime : Float) {
        return updateIn(state.snake.nextMoveTime, nextMoveTime);
    }

    public function updateDirection(wantedDirection : Float) {
        return updateIn(state.snake.wantedDirection, wantedDirection);
    }

    public function gameOver() {
        // A simplified way of preventing the snake from moving.
        return updateIn(state.snake.nextMoveTime, 2147483647);
    }

    public function newHiscore(score : Int) {
        // TODO: Save highscore to browser
        return updateIn(state.hiScore, score);
    }

    public function moveSnake(segments : ImmutableArray<Coordinate>, newDir : Float, speed : Float) {
        return updateIn(state.snake, {
            segments: segments,
            nextMoveTime: speed,
            currentDirection: newDir,
            wantedDirection: newDir
        });
    }
}
