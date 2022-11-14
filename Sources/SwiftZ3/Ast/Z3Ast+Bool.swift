/// A Boolean AST type.
public typealias Z3Bool = Z3Ast<Bool>

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
