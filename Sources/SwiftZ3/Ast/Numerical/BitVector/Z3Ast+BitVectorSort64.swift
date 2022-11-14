public extension Z3Ast where T == BitVectorSort64 {
    // MARK: - Constants Casting

    static func & (lhs: Z3Ast, rhs: Int64) -> Z3Ast {
        return lhs.context.makeBvAnd(lhs, lhs.context.makeInteger64Bv(rhs))
    }
    static func & (lhs: Int64, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvAnd(rhs.context.makeInteger64Bv(lhs), rhs)
    }
    
    static func | (lhs: Z3Ast, rhs: Int64) -> Z3Ast {
        return lhs.context.makeBvOr(lhs, lhs.context.makeInteger64Bv(rhs))
    }
    static func | (lhs: Int64, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvOr(rhs.context.makeInteger64Bv(lhs), rhs)
    }
    
    static func ^ (lhs: Z3Ast, rhs: Int64) -> Z3Ast {
        return lhs.context.makeBvXor(lhs, lhs.context.makeInteger64Bv(rhs))
    }
    static func ^ (lhs: Int64, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvXor(rhs.context.makeInteger64Bv(lhs), rhs)
    }
    
    static func + (lhs: Z3Ast, rhs: Int64) -> Z3Ast {
        return lhs.context.makeBvAdd(lhs, lhs.context.makeInteger64Bv(rhs))
    }
    static func + (lhs: Int64, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvAdd(rhs.context.makeInteger64Bv(lhs), rhs)
    }
    
    static func - (lhs: Z3Ast, rhs: Int64) -> Z3Ast {
        return lhs.context.makeBvSub(lhs, lhs.context.makeInteger64Bv(rhs))
    }
    static func - (lhs: Int64, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvSub(rhs.context.makeInteger64Bv(lhs), rhs)
    }
    
    static func * (lhs: Z3Ast, rhs: Int64) -> Z3Ast {
        return lhs.context.makeBvMul(lhs, lhs.context.makeInteger64Bv(rhs))
    }
    static func * (lhs: Int64, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvMul(rhs.context.makeInteger64Bv(lhs), rhs)
    }
    
    static func / (lhs: Z3Ast, rhs: Int64) -> Z3Ast {
        return lhs.context.makeBvSDiv(lhs, lhs.context.makeInteger64Bv(rhs))
    }
    static func / (lhs: Int64, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvSDiv(rhs.context.makeInteger64Bv(lhs), rhs)
    }
    
    static func == (lhs: Int64, rhs: Z3Ast) -> Z3Bool {
        let lhsInt = rhs.context.makeInteger64Bv(lhs)
        return lhsInt == rhs
    }
    static func == (lhs: Z3Ast, rhs: Int64) -> Z3Bool {
        let rhsInt = lhs.context.makeInteger64Bv(rhs)
        return lhs == rhsInt
    }

    static func != (lhs: Int64, rhs: Z3Ast) -> Z3Bool {
        let lhsInt = rhs.context.makeInteger64Bv(lhs)
        return lhsInt != rhs
    }
    static func != (lhs: Z3Ast, rhs: Int64) -> Z3Bool {
        let rhsInt = lhs.context.makeInteger64Bv(rhs)
        return lhs != rhsInt
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
    static func < (lhs: Z3Ast, rhs: Int64) -> Z3Ast {
        return lhs.context.makeBvSlt(lhs, lhs.context.makeInteger64Bv(rhs))
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
    static func < (lhs: Int64, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvSlt(rhs.context.makeInteger64Bv(lhs), rhs)
    }
    
    /// Two's complement signed less than or equal to.
    static func <= (lhs: Z3Ast, rhs: Int64) -> Z3Ast {
        return lhs.context.makeBvSle(lhs, lhs.context.makeInteger64Bv(rhs))
    }
    /// Two's complement signed greater than or equal to.
    static func <= (lhs: Int64, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvSle(rhs.context.makeInteger64Bv(lhs), rhs)
    }
    
    /// Two's complement signed greater than.
    static func > (lhs: Z3Ast, rhs: Int64) -> Z3Ast {
        return lhs.context.makeBvSgt(lhs, lhs.context.makeInteger64Bv(rhs))
    }
    /// Two's complement signed greater than or equal to.
    static func > (lhs: Int64, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvSgt(rhs.context.makeInteger64Bv(lhs), rhs)
    }
    
    /// Two's complement signed greater than or equal to.
    static func >= (lhs: Z3Ast, rhs: Int64) -> Z3Ast {
        return lhs.context.makeBvSge(lhs, lhs.context.makeInteger64Bv(rhs))
    }
    /// Two's complement signed greater than or equal to.
    static func >= (lhs: Int64, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvSge(rhs.context.makeInteger64Bv(lhs), rhs)
    }
}
