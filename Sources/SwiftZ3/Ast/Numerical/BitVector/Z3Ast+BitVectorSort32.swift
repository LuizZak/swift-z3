public extension Z3Ast where T == BitVectorSort32 {
    // MARK: - Constants Casting

    static func & (lhs: Z3Ast, rhs: Int32) -> Z3Ast {
        return lhs.context.makeBvAnd(lhs, lhs.context.makeIntegerBv(rhs))
    }
    static func & (lhs: Int32, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvAnd(rhs.context.makeIntegerBv(lhs), rhs)
    }
    
    static func | (lhs: Z3Ast, rhs: Int32) -> Z3Ast {
        return lhs.context.makeBvOr(lhs, lhs.context.makeIntegerBv(rhs))
    }
    static func | (lhs: Int32, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvOr(rhs.context.makeIntegerBv(lhs), rhs)
    }
    
    static func ^ (lhs: Z3Ast, rhs: Int32) -> Z3Ast {
        return lhs.context.makeBvXor(lhs, lhs.context.makeIntegerBv(rhs))
    }
    static func ^ (lhs: Int32, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvXor(rhs.context.makeIntegerBv(lhs), rhs)
    }
    
    static func + (lhs: Z3Ast, rhs: Int32) -> Z3Ast {
        return lhs.context.makeBvAdd(lhs, lhs.context.makeIntegerBv(rhs))
    }
    static func + (lhs: Int32, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvAdd(rhs.context.makeIntegerBv(lhs), rhs)
    }
    
    static func - (lhs: Z3Ast, rhs: Int32) -> Z3Ast {
        return lhs.context.makeBvSub(lhs, lhs.context.makeIntegerBv(rhs))
    }
    static func - (lhs: Int32, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvSub(rhs.context.makeIntegerBv(lhs), rhs)
    }
    
    static func * (lhs: Z3Ast, rhs: Int32) -> Z3Ast {
        return lhs.context.makeBvMul(lhs, lhs.context.makeIntegerBv(rhs))
    }
    static func * (lhs: Int32, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvMul(rhs.context.makeIntegerBv(lhs), rhs)
    }
    
    static func / (lhs: Z3Ast, rhs: Int32) -> Z3Ast {
        return lhs.context.makeBvSDiv(lhs, lhs.context.makeIntegerBv(rhs))
    }
    static func / (lhs: Int32, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvSDiv(rhs.context.makeIntegerBv(lhs), rhs)
    }
    
    static func == (lhs: Int32, rhs: Z3Ast) -> Z3Bool {
        let lhsInt = rhs.context.makeIntegerBv(lhs)
        return lhsInt == rhs
    }
    static func == (lhs: Z3Ast, rhs: Int32) -> Z3Bool {
        let rhsInt = lhs.context.makeIntegerBv(rhs)
        return lhs == rhsInt
    }

    static func != (lhs: Int32, rhs: Z3Ast) -> Z3Bool {
        let lhsInt = rhs.context.makeIntegerBv(lhs)
        return lhsInt != rhs
    }
    static func != (lhs: Z3Ast, rhs: Int32) -> Z3Bool {
        let rhsInt = lhs.context.makeIntegerBv(rhs)
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
    static func < (lhs: Z3Ast, rhs: Int32) -> Z3Ast {
        return lhs.context.makeBvSlt(lhs, lhs.context.makeIntegerBv(rhs))
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
    static func < (lhs: Int32, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvSlt(rhs.context.makeIntegerBv(lhs), rhs)
    }
    
    /// Two's complement signed less than or equal to.
    static func <= (lhs: Z3Ast, rhs: Int32) -> Z3Ast {
        return lhs.context.makeBvSle(lhs, lhs.context.makeIntegerBv(rhs))
    }
    /// Two's complement signed greater than or equal to.
    static func <= (lhs: Int32, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvSle(rhs.context.makeIntegerBv(lhs), rhs)
    }
    
    /// Two's complement signed greater than.
    static func > (lhs: Z3Ast, rhs: Int32) -> Z3Ast {
        return lhs.context.makeBvSgt(lhs, lhs.context.makeIntegerBv(rhs))
    }
    /// Two's complement signed greater than or equal to.
    static func > (lhs: Int32, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvSgt(rhs.context.makeIntegerBv(lhs), rhs)
    }
    
    /// Two's complement signed greater than or equal to.
    static func >= (lhs: Z3Ast, rhs: Int32) -> Z3Ast {
        return lhs.context.makeBvSge(lhs, lhs.context.makeIntegerBv(rhs))
    }
    /// Two's complement signed greater than or equal to.
    static func >= (lhs: Int32, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeBvSge(rhs.context.makeIntegerBv(lhs), rhs)
    }
}
