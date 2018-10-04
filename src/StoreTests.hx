#if !macro
using buddy.Should;

typedef TestState = {
    final score : Int;
    final name : {
        final firstName : String;
        final lastName : String;
    }
}

typedef TestState_Mutable = {
    var score : Int;
    var name : {
        var firstName : String;
        var lastName : String;
    }
}

class StoreTests extends buddy.SingleSuite {
    public function new() {
        describe("The Store", {
            var store : Store<TestState>;

            beforeEach({
                var initialState : TestState = {
                    score: 0,
                    name: { firstName: "Wall", lastName: "Enberg"}
                };
                store = new Store(initialState);
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