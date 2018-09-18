package data;

import phaser.Group;
import phaser.Sprite;
import phaser.Game;

class Playfield extends Group {
    public final snake : Snake;
    public final fruit : Sprite;

    public function new(game : Game, snake, fruit, playfieldSize) {
        super(game);

        // Create bounds for the playfield, which will set the width
        // and height of the Playfield itself.
        var bounds : Sprite = this.create(0,0);
        bounds.width = playfieldSize;
        bounds.height = playfieldSize;

        this.snake = snake;
        this.fruit = fruit;

        this.add(fruit);
        this.add(snake);
    }
}
