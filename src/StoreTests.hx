#if !macro
using buddy.Should;

typedef TestState = {
    final score : Int;
    final name : {
        final firstName : String;
        final lastName : String;
    }
}

class TestStateStore extends Store<TestState> {
    public function new(initialState) super(initialState);
}

/*
typedef TestState_Mutable = {
    var score : Int;
    var name : {
        var firstName : String;
        var lastName : String;
    }
}
*/

class StoreTests extends buddy.SingleSuite {
    public function new() {
        describe("The Store", {
            var store : TestStateStore;

            beforeEach({
                var initialState : TestState = {
                    score: 0,
                    name: { firstName: "Wall", lastName: "Enberg"}
                };
                store = new TestStateStore(initialState);
            });

            it("should never return the previous state after a change", {
                /*
                var nextState : TestState = {
                    score: 1, 
                    name: {
                        firstName: "Wall", lastName: "Enberg"
                    }
                };
 
                store.update(store.state, nextState);

                store.update(store.state, {
                    score: 1, 
                    name: {
                        firstName: "Wall", lastName: "Enberg"
                    }
                });

                store.update(store.state.score, 1);
                
                store.update(store.state.name, {
                    firstName: "Wall", lastName: "Enberg"
                });
                
                store.update(store.state.name.firstName, "Allan");
                */
            });
        });
    }
}
#end