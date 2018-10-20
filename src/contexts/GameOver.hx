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
        this.SCORE = asset.state;
        //this.HISCORE = asset;

        this._game = game;
        this._asset = asset;
    }

    ///// System operations  //////////////////////////////////////

    public function start() {
        SCREEN.displayGameOver();

        _game.input.keyboard.addKey(Keyboard.SPACEBAR)
            .onUp.addOnce(_game.state.restart);
    }

    ///// Context state ///////////////////////////////////////////

    final _game : Game;
    final _asset : GameState;

    ///// Helper methods //////////////////////////////////////////

    ///// Roles ///////////////////////////////////////////////////

    @role var SCORE : {
        final score : Int;

        public function submitHiscore() {
            _asset.gameOver(score);
            //HISCORE.update(score);
        }
    }

    /*
    @role var HISCORE : {
        function newHiscore(hiscore : Int) : GameState.State;

        public function update(currentScore) {
            // TODO: Save hiscore in browser
            newHiscore(currentScore);
                
            waitForGameRestart();
        }
    }
    */

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

            SCORE.submitHiscore();
        }
    }
}
