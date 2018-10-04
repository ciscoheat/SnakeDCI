#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using Lambda;

class StoreBuilder {
    static public function build() {
        function testFinalType(name : String, type : Type) : Void switch type {
            case TAnonymous(a):
                // Check if all fields are final
                for(f in a.get().fields) switch f.kind {
                    case FVar(read, write) if(read == AccNormal && write == AccNever):
                        testFinalType(name + "." + f.name, f.type);
                    case _:
                        Context.error(name + "." + f.name + " is not final, type cannot be used in Store.", f.pos);
                }
            case TInst(t, _):
                var type = t.get();
                if(type.name == "String" && type.pack.length == 0) return;
                else Context.error("$name field is not final, cannot be used in Store.", type.pos);
            
            case TAbstract(t, _):
                var abstractType = t.get();
                if(abstractType.pack.length == 0 && 
                    (abstractType.name == "Int" || abstractType.name == "Bool" || abstractType.name == "Float")
                ) return
                else testFinalType(name + "." + abstractType.name, Context.followWithAbstracts(abstractType.type));

            case x:
                Context.error("Unsupported final type check: " + x, Context.currentPos());
        }

        function buildStateType(type : Type) switch type {
            case TInst(t, _): 
                return try {
                    Context.warning("Building Store from instance", t.get().pos);
                    trace(Context.getCallArguments());
                    var arg = Context.getCallArguments()[0];
                    var type = Context.typeof(arg);
                    buildStateType(type);
                } catch(e : Dynamic) {
                    // TODO: Build type from argument
                    Context.error("Inferred typing not supported at the moment.", Context.currentPos());
                }
                /*
                case TType(t2, _): 
                    testFinalType("", t2.get().type);
                    return null;
                    //return Context.error("Type is not final, cannot use in Store", Context.currentPos());

                case x:
                    return Context.error("Unsupported type: " + x, Context.currentPos());
                */

            case TType(t, params):
                if(params.length > 0) Context.error("Typedefs with parameters are not supported.", t.get().pos);
                var realType : DefType = t.get();
                var storeType = realType.type;
                var complexType = Context.toComplexType(storeType);
                trace(complexType);
                testFinalType("", storeType);
                return null;
                //Context.warning(t.get().name + " passed through test.", t.get().pos);

            case t:
                trace(t);
                return Context.error("Class expected", Context.currentPos());
        }

        return buildStateType(Context.getLocalType());
    }
}
#end