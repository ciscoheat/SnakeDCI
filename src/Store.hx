import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.ExprTools;
using Reflect;
using Lambda;

private abstract StateTreeNode(Array<String>) from Array<String> {
    public inline function new(a : Array<String>) {
        if(a.length == 0) throw "StateTreeNode: Empty node list";
        this = a;
    }

    @:from
    public static function fromString(s : String) {
        return new StateTreeNode(s.split("."));
    }

    @:to
    public function toString() return this.join(".");

    public function hasNext() return this.length > 1;

    public function name() return this[0];

    public function next() : StateTreeNode
        if(!hasNext()) throw "StateTreeNode: No more nodes."
        else return this.slice(1);

    public function isNextLeaf()
        if(!hasNext()) throw "StateTreeNode: No more nodes."
        else return this.length == 2;
}

@:autoBuild(StoreBuilder.build())
class Store<T> {
    #if !macro
    public var state(default, null) : T;

    function new(initialState : T) {
        this.state = initialState;
    }

    /*
    static function main() {
        var theStore = new Store({
            score: 0,
            name: { firstName: "Wall", lastName: "Enberg"}
        });
        //theStore.update(theStore.state.name);
    }
    */

    public function updateState(newState : T) : T {
        // TODO: Apply middleware
        return this.state = newState;
    }

    public function update<T2>(updatePath : String, newValue : T2) : T {
        var trimRef = updatePath.indexOf(".state.");
        if(trimRef > 0) updatePath = updatePath.substr(trimRef + 7);
        // TODO: Disallow "state" path value
        if(updatePath == "") throw "Use Store.updateState for updating the whole state.";
        // TODO: Handle Dataclass (instad of state.copy)
        var copy = state.copy();
        deepCopyCurrentState(cast copy, updatePath, newValue);
        return copy;
    }

    function deepCopyCurrentState(newState : haxe.DynamicAccess<Dynamic>, updatePath : StateTreeNode, newValue : Dynamic) : Void {
        var nodeName = updatePath.name();
        trace('Updating: $updatePath');
        if(!updatePath.hasNext()) {
            trace('updating $nodeName and finishing.');
            newState.set(nodeName, newValue);
        } else if(updatePath.isNextLeaf()) {
            trace('Next path is a leaf. Copy, set and finish $nodeName');
            var copy : haxe.DynamicAccess<Dynamic> = Reflect.copy(newState.get(nodeName));
            var nextName = updatePath.next().name();
            trace('Setting $nextName in $nodeName');
            copy.set(nextName, newValue);
            newState.set(nodeName, copy);
        } else {
            var copy = Reflect.copy(newState.get(nodeName));            
            newState.set(nodeName, copy);
            deepCopyCurrentState(copy, updatePath.next(), newValue);
        }
    }
    #end

    /*
    macro public function update(store : ExprOf<Store<Dynamic>>, path : Expr, newValues : Expr) {
        var t1 = Context.typeof(path);
        var t2 = Context.typeof(newValues);

        trace("=== " + path.toString());

        if(Context.unify(t1, t2)) {
            trace("Types unifies.");
            return path;
        }

        switch t1 {
            case TAnonymous(a):
                trace("Anonymous with fields [" + a.get().fields.map(f -> f.name).join(", ") + "]");
                var t3 = Context.getType("Store.TestState_Vars_name");
                trace("Unifies with var version: " + Context.unify(t3, t2));
            case _:
                trace("Unknown: " + t1);
        }

        return path;
    }
    */
}
