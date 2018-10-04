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

    public function updateState(newState : T) : T {
        // TODO: Apply middleware
        return this.state = newState;
    }

    public function update<T2>(updatePath : String, newValue : T2) : T {
        if(updatePath.length == 0) throw "Use Store.updateState for updating the whole state.";
        // TODO: Handle Dataclass (instad of state.copy)
        var copy = Reflect.copy(state);
        deepStateCopy(cast copy, updatePath, newValue);
        return updateState(copy);
    }

    function deepStateCopy(newState : haxe.DynamicAccess<Dynamic>, updatePath : StateTreeNode, newValue : Dynamic) : Void {
        var nodeName = updatePath.name();
        if(!newState.exists(nodeName)) throw "Key not found in state: " + updatePath;
        //trace('Updating: $updatePath');
        if(!updatePath.hasNext()) {
            //trace('updating $nodeName and finishing.');
            newState.set(nodeName, newValue);
        } else {
            var copy = Reflect.copy(newState.get(nodeName));            
            newState.set(nodeName, copy);
            deepStateCopy(copy, updatePath.next(), newValue);
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
