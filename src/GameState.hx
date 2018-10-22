import ds.ImmutableArray;
import phaser.Phaser;
import haxe.ds.Option;

typedef Coordinate = {
    final x : Int;
    final y : Int;
}

typedef State = {
    final snake : {
        final segments : ImmutableArray<Coordinate>;
        final nextMoveTime : Float;
        final currentDirection : Float;
    };
    final controller : {
        final buffer : {
            final directions : ImmutableArray<Float>;
            final position : Coordinate;
        }
    }
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
        super({
            snake: {
                segments: [],
                nextMoveTime: 0.0,
                currentDirection: Phaser.RIGHT
            },
            controller : {
                buffer: {
                    directions: [],
                    position: {x: 0, y: 0}
                }
            },
            fruit: {x: 0, y: 0},
            score: 0,
            hiScore: 0,
            playfield: {
                width: playfieldSize,
                height: playfieldSize,
                squareSize: segmentSize
            }
        });
    }

    public function initializeGame() {
        var X = Std.int(state.playfield.width / 2);
        var Y = Std.int(state.playfield.height / 2);

        var segments = [{x: X, y: Y}, {x: X-1, y: Y}, {x: X-2, y: Y}];

        // TODO: Random fruit placement
        return updateMap([
            state.snake => {
                segments: segments,
                nextMoveTime: 0.0,
                currentDirection: Phaser.RIGHT
            },
            state.score => 0,
            state.fruit => {x: X+3, y: Y+5},
            state.controller => {
                buffer: {
                    directions: [],
                    position: {x: 0, y: 0}
                }
            },
        ]);
    }

    public function fruitEaten(newFruitPos : Coordinate) {
        return updateMap([
            state.score => s -> s + 10,
            state.fruit => newFruitPos,
            state.snake.segments => function(s) {
                var last = s[s.length-1];
                var nextLast = s[s.length-2];
                return s.push({
                    x : last.x + (last.x-nextLast.x), 
                    y : last.y - (last.y-nextLast.y)
                });
            }
        ]);
    }

    public function updateMoveTimer(nextMoveTime : Float) {
        return updateIn(state.snake.nextMoveTime, nextMoveTime);
    }

    public function updateDirection(direction : Float, position : Option<Coordinate>) {
        /*
        TODO: Should work
        return updateIn(state.controller.buffer, function(b) return {
            directions: b.directions.push(newDir),
            position : currentPos
        });
        */
        //if(directions.length > 0) trace(directions + " " + position);

        return switch position {
            case None:
                updateIn(state.controller.buffer.directions, d -> d.push(direction));
            case Some(p):
                updateIn(state.controller.buffer, {
                    directions: [direction],
                    position: p
                });
        }
    }

    public function gameOver() {
        // Prevent the snake from moving
        return updateIn(state.snake.nextMoveTime, 1000000000);
    }

    public function newHiscore(score : Int) {
        return updateIn(state.hiScore, score);
    }

    public function moveSnake(segments : ImmutableArray<Coordinate>, newDir : Float, speed : Float) {
        return updateMap([
            state.snake => {
                segments: segments,
                nextMoveTime: speed,
                currentDirection: newDir
            },
            state.controller.buffer.directions => d -> d.shift()
        ]);
    }
}
