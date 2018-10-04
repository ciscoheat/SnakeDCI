#if !macro
using buddy.Should;

typedef TestState = {
    final score : Int;
    final person : {
        final name : {
            final firstName : String;
            final lastName : String;
        }
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
            var initialState : TestState = {
                score: 0,
                person: {
                    name: { firstName: "Wall", lastName: "Enberg"}
                }
            };

            beforeEach({
                store = new TestStateStore(initialState);
            });

            it("should replace the previous state when calling updateState", {
                var nextState : TestState = {
                    score: 1, 
                    person: {
                        name: {
                            firstName: "Allan", lastName: "Benberg"
                        }
                    }
                };
 
                var newState = store.updateState(nextState);

                newState.should.not.be(null);
                //newState.should.not.be(nextState);
                newState.score.should.be(1);
                newState.person.name.firstName.should.be("Allan");
                newState.person.name.lastName.should.be("Benberg");
            });

            it("should update fields in the middle of the state tree", {
                var newState = store.update("person.name", {
                    firstName: "Allan", lastName: "Benberg"
                });

                newState.should.not.be(null);
                newState.should.not.be(initialState);
                newState.score.should.be(0);
                newState.person.name.firstName.should.be("Allan");
                newState.person.name.lastName.should.be("Benberg");
            });

            it("should update fields at the end of the state tree", {
                var newState = store.update("person.name.firstName", "Wallan");

                newState.should.not.be(null);
                newState.should.not.be(initialState);
                newState.score.should.be(0);
                newState.person.name.firstName.should.be("Wallan");
                newState.person.name.lastName.should.be("Enberg");
            });

            it("should update fields at the end of the state tree", {
                var newState = store.update("score", 10);

                newState.should.not.be(null);
                newState.should.not.be(initialState);
                newState.score.should.be(10);
                newState.person.name.firstName.should.be("Wall");
                newState.person.name.lastName.should.be("Enberg");
            });


                /*
                store.update(store.state, {
                    score: 1, 
                    name: {
                        firstName: "Wall", lastName: "Enberg"
                    }
                });

                store.update(store.state.score, 1);
                
                store.update(store.state.person.name, {
                    firstName: "Wall", lastName: "Enberg"
                });
                
                store.update(store.state.person.name.firstName, "Allan");
                */
        });
    }
}
#end