import Z3

public class Z3Context {
    internal var context: Z3_context

    public init(configuration: Z3Config? = nil) {
        context = Z3_mk_context(configuration?.config)
    }

    deinit {
        Z3_del_context(context)
    }

    public func makeVariable(name: String, sort: Z3Sort) -> Z3Ast {
        let symbol = Z3_mk_string_symbol(context, name)

        return Z3Ast(ast: Z3_mk_const(context, symbol, sort.sort))
    }

    public func makeInteger(value: Int32) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_int(context, value, intSort().sort))
    }

    public func intSort() -> Z3Sort {
        return Z3Sort(sort: Z3_mk_int_sort(context))
    }

    public func boolSort() -> Z3Sort {
        return Z3Sort(sort: Z3_mk_bool_sort(context))
    }

    public func realSort() -> Z3Sort {
        return Z3Sort(sort: Z3_mk_real_sort(context))
    }
}
