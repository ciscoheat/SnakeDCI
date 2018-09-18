package data;

import phaser.Group;

class Snake extends Group {
    var _textures : SnakeGame.Textures;

    public function new(game, textures) {
        super(game);
        this._textures = textures;
    }

    public function addSegment(x, y) {
        this.create(x, y, this.length == 0 ? _textures.head : _textures.segment);
    }
}
