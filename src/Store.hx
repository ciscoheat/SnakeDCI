import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.ExprTools;

@:autoBuild(StoreBuilder.build())
class Store<T> {
    #if !macro
    public var state(default, null) : T;

    public function new(initialState : T) {
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

    public function update<T2, T3 : T2>(path : T2, newValue : T3) : T {
        return null;
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
