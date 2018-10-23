import phaser.Phaser;
import phaser.Game;

class Main implements dci.Context {
    public function new(width = 600, height = 600, playfieldSize = 20, segmentSize = 20) {
        var asset = new GameState(playfieldSize, segmentSize);
        var game = new Game(width, height, Phaser.AUTO, 'snakedci');
        
        this._gameView = new GameView(game, asset);
    }

    ///// System Operations /////////////////////////////////////////

    // Program entrypoint
    static function main() 
        new Main().start();

    public function start() {
        _gameView.start();
    }

    ///// Context state /////////////////////////////////////////////

    final _gameView : GameView;

    ///// Helper methods ////////////////////////////////////////////

    ///// Roles /////////////////////////////////////////////////////
}
