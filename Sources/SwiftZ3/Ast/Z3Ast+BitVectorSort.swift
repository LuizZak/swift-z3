public extension Z3Ast where T: BitVectorSort {
    static func & (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeBvAnd(lhs, rhs)
    }
    
    static func | (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeBvOr(lhs, rhs)
    }
    
    static func ^ (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeBvXor(lhs, rhs)
    }
    
    static func + (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeBvAdd(lhs, rhs)
    }
    
    static func - (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeBvSub(lhs, rhs)
    }
    
    static func * (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeBvMul(lhs, rhs)
    }
    
    static func / (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeBvSDiv(lhs, rhs)
    }
    
    /// Two's complement signed less than.
    ///
    /// It abbreviates:
    ///
    /// ```
    /// (or (and (= (extract[|m-1|:|m-1|] t1) bit1)
    ///         (= (extract[|m-1|:|m-1|] t2) bit0))
    ///     (and (= (extract[|m-1|:|m-1|] t1) (extract[|m-1|:|m-1|] t2))
    ///         (bvult t1 t2)))
    /// ```
    static func < (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeBvSlt(lhs, rhs)
    }
    
    /// Two's complement signed less than or equal to.
    static func <= (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeBvSle(lhs, rhs)
    }
    
    /// Two's complement signed greater than.
    static func > (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeBvSgt(lhs, rhs)
    }
    
    /// Two's complement signed greater than or equal to.
    static func >= (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeBvSge(lhs, rhs)
    }
    
    static prefix func - (rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvNeg(rhs)
    }
    
    static prefix func ! (rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvNot(rhs)
    }
}
