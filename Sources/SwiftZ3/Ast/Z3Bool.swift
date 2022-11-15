/// A Boolean AST type.
public typealias Z3Bool = Z3Ast<Bool>

public extension Z3Bool {
    /// Gets the statically-typed array Z3Sort associated with `Bool` from
    /// this `Z3Bool`.
    static func getSort(_ context: Z3Context) -> Z3Sort {
        T.getSort(context)
    }
}

public extension Z3Bool {
    static prefix func ! (rhs: Z3Bool) -> Z3Bool {
        return rhs.context.makeNot(rhs)
    }
    
    static func && (lhs: Z3Bool, rhs: Z3Bool) -> Z3Bool {
        return rhs.context.makeAnd([lhs, rhs])
    }
    
    static func || (lhs: Z3Bool, rhs: Z3Bool) -> Z3Bool {
        return rhs.context.makeOr([lhs, rhs])
    }
}
