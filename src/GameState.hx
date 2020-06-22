import haxecontracts.*;
import ds.ImmutableArray;

typedef Coordinate = {
    final x : Int;
    final y : Int;
}

typedef State = {
    final snake : {
        final segments : ImmutableArray<Coordinate>;
        final nextMoveTime : Float;
        final currentDirection : Float;
        final wantedDirection : Float;
        final moveCounter : Int;
    };
    final fruit : Coordinate;
    final score : Int;
    final hiScore : Int;
    final playfield : {
        final width : Int;
        final height : Int;
    }
    final active : Bool;
}

class GameState implements HaxeContracts {

    public static function validate(asset : DeepState<State>) {
        final state = asset.state;

        Contract.requires(
            state.fruit.x >= 0 && state.fruit.x < state.playfield.width &&
            state.fruit.y >= 0 && state.fruit.y < state.playfield.height
        , "Fruit outside playfield.");

        Contract.requires(!state.snake.segments.exists(s ->
            (s.x < 0 || s.x >= state.playfield.width) ||
            (s.y < 0 || s.y >= state.playfield.height)
        ), "Snake segment outside playfield.");

        Contract.requires(state.snake.currentDirection > 0);
        Contract.requires(state.snake.wantedDirection > 0);
        Contract.requires(state.snake.nextMoveTime >= 0);

        Contract.requires(state.score >= 0);
        Contract.requires(state.hiScore >= 0);

        Contract.requires(state.playfield.width > 0);
        Contract.requires(state.playfield.height > 0);

        return asset;
    }
}
