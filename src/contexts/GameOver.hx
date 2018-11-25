package contexts;

import phaser.Game;
import phaser.GameObjectFactory;
import phaser.Keyboard;

/**
 * Called from Collisions.
 */
class GameOver implements dci.Context {
    public function new(asset : GameState, game : Game) {
        this.SCREEN = game;
        this.GAME = asset.state;
        this.CONTROLLER = game.input;
        
        this._game = game;
        this._asset = asset;
    }

    ///// System operations  //////////////////////////////////////

    public function start() {
        SCREEN.displayGameOver();
        return _asset.update(_asset.state.active, false);
    }

    ///// Context state ///////////////////////////////////////////

    final _game : Game;
    final _asset : GameState;

    ///// Helper methods //////////////////////////////////////////

    ///// Roles ///////////////////////////////////////////////////

    @role var CONTROLLER : {
        var keyboard : Keyboard;

        public function waitForRestart() {
            // TODO: More generic restart method, for other input methods.
            SELF.keyboard.addKey(Keyboard.SPACEBAR)
            .onUp.addOnce(_game.state.restart);            
        }
    }

    @role var GAME : {
        final score : Int;
        final hiScore : Int;

        public function submitHiscore() {
            if(SELF.score > SELF.hiScore) {
                // Save score to browser before displaying it,
                // so the player can compare scores.
                js.Browser.window.localStorage
                .setItem("hiScore", Std.string(SELF.score));
            }

            CONTROLLER.waitForRestart();
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

            GAME.submitHiscore();
        }
    }
}
