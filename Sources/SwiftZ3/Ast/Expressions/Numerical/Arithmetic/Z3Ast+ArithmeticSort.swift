public extension Z3Ast where T: ArithmeticSort {
    static func < (lhs: Z3Ast, rhs: Z3Ast) -> Z3Bool {
        return lhs.context.makeLessThan(lhs, rhs)
    }

    static func <= (lhs: Z3Ast, rhs: Z3Ast) -> Z3Bool {
        return lhs.context.makeLessThanOrEqualTo(lhs, rhs)
    }

    static func > (lhs: Z3Ast, rhs: Z3Ast) -> Z3Bool {
        return lhs.context.makeGreaterThan(lhs, rhs)
    }

    static func >= (lhs: Z3Ast, rhs: Z3Ast) -> Z3Bool {
        return lhs.context.makeGreaterThanOrEqualTo(lhs, rhs)
    }
    
    static func + (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeAdd([lhs, rhs])
    }
    
    static func - (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeSub([lhs, rhs])
    }
    
    static func * (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeMul([lhs, rhs])
    }
    
    static func / (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeDiv(lhs, rhs)
    }
}
