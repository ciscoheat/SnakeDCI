import phaser.Phaser;
import phaser.Game;
import ds.Action;

class Main implements dci.Context {
    public function new(width = 600, height = 600, playfieldSize = 20, segmentSize = 20) {
        var logger = new MiddlewareLog<GameState.State>();
        var asset = new GameState({
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
                height: playfieldSize
            },
            active: false
        }, [logger.log]);
        var game = new Game(width, height, Phaser.AUTO, 'snakedci');
        
        this._gameView = new GameView(game, asset, segmentSize);
    }

    ///// System Operations /////////////////////////////////////////

    // Program entrypoint
    static function main() 
        new Main().start();

    public function start()
        _gameView.start();

    ///// Context state /////////////////////////////////////////////

    final _gameView : GameView;

    ///// Helper methods ////////////////////////////////////////////

    ///// Roles /////////////////////////////////////////////////////
}

class MiddlewareLog<T> {
    public function new() {}

    public final logs = new Array<{state: T, type: String, timestamp: Date}>();

    public function log(state: T, next : Action -> T, action : Action) : T {
        // Get the next state
        var newState = next(action);

        // Log it and return it unchanged
        logs.push({state: newState, type: action.type, timestamp: Date.now()});
        return newState;
    }
}