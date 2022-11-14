public extension Z3BitVector where T == BitVectorSortUnsigned32 {
    // MARK: - Unsigned division
    
    static func / (lhs: Z3BitVector, rhs: Z3BitVector) -> Z3BitVector {
        return lhs.context.makeBvDiv(lhs, rhs)
    }

    // MARK: - Constants Casting

    static func & (lhs: Z3BitVector, rhs: UInt32) -> Z3BitVector {
        return lhs.context.makeBvAnd(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    static func & (lhs: UInt32, rhs: Z3BitVector) -> Z3BitVector {
        return rhs.context.makeBvAnd(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    static func | (lhs: Z3BitVector, rhs: UInt32) -> Z3BitVector {
        return lhs.context.makeBvOr(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    static func | (lhs: UInt32, rhs: Z3BitVector) -> Z3BitVector {
        return rhs.context.makeBvOr(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    static func ^ (lhs: Z3BitVector, rhs: UInt32) -> Z3BitVector {
        return lhs.context.makeBvXor(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    static func ^ (lhs: UInt32, rhs: Z3BitVector) -> Z3BitVector {
        return rhs.context.makeBvXor(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    static func + (lhs: Z3BitVector, rhs: UInt32) -> Z3BitVector {
        return lhs.context.makeBvAdd(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    static func + (lhs: UInt32, rhs: Z3BitVector) -> Z3BitVector {
        return rhs.context.makeBvAdd(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    static func - (lhs: Z3BitVector, rhs: UInt32) -> Z3BitVector {
        return lhs.context.makeBvSub(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    static func - (lhs: UInt32, rhs: Z3BitVector) -> Z3BitVector {
        return rhs.context.makeBvSub(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    static func * (lhs: Z3BitVector, rhs: UInt32) -> Z3BitVector {
        return lhs.context.makeBvMul(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    static func * (lhs: UInt32, rhs: Z3BitVector) -> Z3BitVector {
        return rhs.context.makeBvMul(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    static func / (lhs: Z3BitVector, rhs: UInt32) -> Z3BitVector {
        return lhs.context.makeBvDiv(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    static func / (lhs: UInt32, rhs: Z3BitVector) -> Z3BitVector {
        return rhs.context.makeBvDiv(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    static func == (lhs: UInt32, rhs: Z3BitVector) -> Z3Bool {
        let lhsInt = rhs.context.makeUnsignedIntegerBv(lhs)
        return lhsInt == rhs
    }
    static func == (lhs: Z3BitVector, rhs: UInt32) -> Z3Bool {
        let rhsInt = lhs.context.makeUnsignedIntegerBv(rhs)
        return lhs == rhsInt
    }

    static func != (lhs: UInt32, rhs: Z3BitVector) -> Z3Bool {
        let lhsInt = rhs.context.makeUnsignedIntegerBv(lhs)
        return lhsInt != rhs
    }
    static func != (lhs: Z3BitVector, rhs: UInt32) -> Z3Bool {
        let rhsInt = lhs.context.makeUnsignedIntegerBv(rhs)
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
    static func < (lhs: Z3BitVector, rhs: UInt32) -> Z3BitVector {
        return lhs.context.makeBvSlt(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
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
    static func < (lhs: UInt32, rhs: Z3BitVector) -> Z3BitVector {
        return rhs.context.makeBvSlt(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    /// Two's complement signed less than or equal to.
    static func <= (lhs: Z3BitVector, rhs: UInt32) -> Z3BitVector {
        return lhs.context.makeBvSle(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    /// Two's complement signed greater than or equal to.
    static func <= (lhs: UInt32, rhs: Z3BitVector) -> Z3BitVector {
        return rhs.context.makeBvSle(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    /// Two's complement signed greater than.
    static func > (lhs: Z3BitVector, rhs: UInt32) -> Z3BitVector {
        return lhs.context.makeBvSgt(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    /// Two's complement signed greater than or equal to.
    static func > (lhs: UInt32, rhs: Z3BitVector) -> Z3BitVector {
        return rhs.context.makeBvSgt(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    /// Two's complement signed greater than or equal to.
    static func >= (lhs: Z3BitVector, rhs: UInt32) -> Z3BitVector {
        return lhs.context.makeBvSge(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    /// Two's complement signed greater than or equal to.
    static func >= (lhs: UInt32, rhs: Z3BitVector) -> Z3BitVector {
        return rhs.context.makeBvSge(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
}
