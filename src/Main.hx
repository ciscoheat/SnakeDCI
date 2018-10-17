import phaser.Phaser;
import phaser.Game;

/////////////////////////////////////////////////////////////////////

class Main implements dci.Context {
    public function new(width = 600, height = 600, playfieldSize = 20, segmentSize = 20) {
        this.asset = new GameState(playfieldSize, segmentSize);
        this.game = new Game(width, height, Phaser.AUTO, 'snakedci');
        this.gameView = new GameView(game, asset);
    }

    ///// System Operations /////////////////////////////////////////

    public function start() {
        gameView.start();
    }

    ///// Context state /////////////////////////////////////////////

    final asset : GameState;
    final game : Game;
    final gameView : GameView;

    ///// Helper methods ////////////////////////////////////////////

    ///// Roles /////////////////////////////////////////////////////

    ///// Program entrypoint /////
    static function main() new Main().start();
}
