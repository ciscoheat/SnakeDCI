import data.Playfield;
import data.Snake;
import phaser.Text;
import phaser.Graphics;
import phaser.CursorKeys;
import phaser.Sprite;
import phaser.Group;
import phaser.Phaser;
import phaser.Game;
import pixi.RenderTexture;

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

////////////////////////////////////////////////////////////////////

/*
private class OldSnakeGame {
    var _textures(default, null) : Textures;

    final game : Game;
    final asset : GameState;

    public var playfield(default, null) : Playfield;
    public var score(default, null) : Text;
    public var hiscore(default, null) : Text;

    var controller : CursorKeys;

    function create() {

        ///// Score and keyboard /////

        this.keyboard = game.input.keyboard.createCursorKeys();

        this.score = game.add.text(10, 10, "Score: 0", cast {
			font: "20px Arial",
			fill: "#ffffff",
			align: "left",
            boundsAlignH: 'left',
            boundsAlignV: 'top',
        });
        this.score.health = 0;

        // If hi-score exists since previous round, use it.
        var highScore = asset.state.hiScore;
        this.hiscore = game.add.text(0, 0, "Hi-score: " + highScore, cast {
			font: "20px Arial",
			fill: "#ffffff",
			align: "right",
            boundsAlignH: 'right',
            boundsAlignV: 'top',
        }).setTextBounds(game.world.width-150, 10, 150-10, 20);

        ///// Start movment /////

        this.movement = new Movement(this, snake, cast keyboard, {
            width: playfield.width, height: playfield.height
        });

        this.movement.start();
    }
}
*/
