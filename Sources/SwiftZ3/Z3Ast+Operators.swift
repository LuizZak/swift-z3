public extension Z3Ast {
    static func == (lhs: Z3Ast, rhs: Z3Ast) -> Z3Bool {
        return lhs.context.makeEqual(lhs, rhs)
    }
    
    static func != (lhs: Z3Ast, rhs: Z3Ast) -> Z3Bool {
        return lhs.context.makeNot(lhs == rhs)
    }
}
