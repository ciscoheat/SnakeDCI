import phaser.Phaser;

typedef Coordinate = {
    final x : Int;
    final y : Int;
}

typedef State = {
    final snake : {
        final segments : ds.ImmutableArray<Coordinate>;
        final nextMoveTime : Int;
        final currentDirection : Float;
    };
    final fruit : Coordinate;
    final score : Int;
    final hiScore : Int;
    final keyboard : {
        final wantedDirection : Float;
    };
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
                nextMoveTime: 0,
                currentDirection: Phaser.RIGHT
            },
            fruit: {x: 0, y: 0},
            score: 0,
            hiScore: 0,
            keyboard: {
                wantedDirection: Phaser.RIGHT
            },
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
        updateMap([
            state.snake.segments => segments,
            state.fruit => {x: X+3, y: Y+5}
        ]);
    }

    public function addScore(add : Int)
        updateIn(state.score, s -> s + add);
}
