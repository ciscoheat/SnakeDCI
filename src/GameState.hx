import haxecontracts.*;
import ds.ImmutableArray;
import phaser.Phaser;

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

class GameState extends DeepState<GameState, State> implements HaxeContracts {
    public function new(initialState, middleware = null)
        super(initialState, middleware);

    ///// Actions ///////////////////////////////////////////////////

    public function revert(previous : State)
        return update(state, previous);

    ///// Contract invariants ///////////////////////////////////////

    @invariants function invariants() {
        Contract.invariant(
            state.fruit.x >= 0 && state.fruit.x < state.playfield.width &&
            state.fruit.y >= 0 && state.fruit.y < state.playfield.height
        , "Fruit outside playfield.");

        Contract.invariant(!state.snake.segments.exists(s ->
            (s.x < 0 || s.x >= state.playfield.width) ||
            (s.y < 0 || s.y >= state.playfield.height)
        ), "Snake segment outside playfield.");

        Contract.invariant(state.snake.currentDirection > 0);
        Contract.invariant(state.snake.wantedDirection > 0);
        Contract.invariant(state.snake.nextMoveTime >= 0);

        Contract.invariant(state.score >= 0);
        Contract.invariant(state.hiScore >= 0);

        Contract.invariant(state.playfield.width > 0);
        Contract.invariant(state.playfield.height > 0);
    }
}
