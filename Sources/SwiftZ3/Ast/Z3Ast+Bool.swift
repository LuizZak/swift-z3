public extension Z3Ast where T == Bool {
    static prefix func ! (rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeNot(rhs)
    }
    
    static func && (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeAnd([lhs, rhs])
    }
    
    static func || (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeOr([lhs, rhs])
    }
}
