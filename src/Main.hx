import phaser.Phaser;
import phaser.Game;
import ds.Action;
import GameState.State;

class Main implements dci.Context {
    public function new(width = 600, height = 600, playfieldSize = 20, segmentSize = 20) {
        var logger = new MiddlewareLog<State>();
        var asset = new DeepState<State>({
            snake: {
                segments: [],
                nextMoveTime: 0,
                currentDirection: Phaser.RIGHT,
                wantedDirection: Phaser.RIGHT,
                moveCounter: 10000
            },
            fruit: {x: 0, y: 0},
            score: 0,
            hiScore: 0,
            playfield: {                
                width: playfieldSize,
                height: playfieldSize
            },
            active: false
        }, [logger.log, (_, next, action) -> GameState.validate(cast next(action))]);
        var game = new Game(width, height, Phaser.AUTO, 'snakedci');
        
        this._gameView = new GameView(game, asset, segmentSize, logger);
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

    public function log(asset: ds.gen.DeepState<T>, next : Action -> ds.gen.DeepState<T>, action : Action) : ds.gen.DeepState<T> {
        // Get the next state
        var newState = next(action);

        // Log it and return it unchanged
        logs.push({state: newState.state, type: action.type, timestamp: Date.now()});
        //if(action.type.indexOf("updateMoveTimer") == -1) trace(action.type);
        return newState;
    }
}