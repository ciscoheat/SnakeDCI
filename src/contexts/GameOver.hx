package contexts;

import phaser.Game;
import phaser.GameObjectFactory;
import phaser.Math;
import phaser.Keyboard;
import phaser.Group;
import phaser.Text;
import phaser.PhaserTextStyle;
import GameState.Coordinate;
import ds.ImmutableArray;

using Lambda;

class GameOver implements dci.Context {
    public function new(asset : GameState, game : Game) {
        this.SCREEN = game;
        this.GAME = asset.state;

        this._game = game;
        this._asset = asset;
    }

    ///// System operations  //////////////////////////////////////

    public function start() {
        SCREEN.displayGameOver();
    }

    ///// Context state ///////////////////////////////////////////

    final _game : Game;
    final _asset : GameState;

    ///// Helper methods //////////////////////////////////////////

    ///// Roles ///////////////////////////////////////////////////

    @role var GAME : {
        final score : Int;
        final hiScore : Int;

        public function waitForRestart() {
            _asset.gameOver();

            function restart() {
                SELF.submitHiscore();
                _game.state.restart();
            }

            // TODO: More generic restart method, if other input methods exist.
            _game.input.keyboard.addKey(Keyboard.SPACEBAR).onUp.addOnce(restart);
        }

        public function submitHiscore() {
            if(SELF.score > SELF.hiScore)
                _asset.newHiscore(SELF.score);
        }
    }

    @role var SCREEN : {
        var height : Float;
        var width : Float;
        var add : GameObjectFactory;

        public function displayGameOver() {
            SELF.add.text(0,0, "GAME OVER", cast {
                font: "50px Arial",
                fill: "#ffffff",
                stroke: "#000000",
                strokeThickness: 3,
                align: "center",
                boundsAlignH: 'center',
                boundsAlignV: 'middle',
            }).setTextBounds(0, -20, SELF.width, SELF.height);

            SELF.add.text(0,0, "Press space to restart", cast {
                font: "20px Arial",
                fill: "#ffffff",
                stroke: "#000000",
                strokeThickness: 2,
                align: "center",
                boundsAlignH: 'center',
                boundsAlignV: 'middle',
            }).setTextBounds(0, 30, SELF.width, SELF.height);

            GAME.waitForRestart();
        }
    }
}
