/// A typealias for a `Z3BitVector` with `BitVectorSortUnsigned64` sort.
public typealias Z3BitVectorU64 = Z3BitVector<BitVectorSortUnsigned64>

public extension Z3BitVectorU64 {
    // MARK: - Unsigned division
    
    static func / (lhs: Z3BitVectorU64, rhs: Z3BitVectorU64) -> Z3BitVectorU64 {
        return lhs.context.makeBvDiv(lhs, rhs)
    }
    
    // MARK: - Constants Casting

    static func & (lhs: Z3BitVectorU64, rhs: UInt64) -> Z3BitVectorU64 {
        return lhs.context.makeBvAnd(lhs, lhs.context.makeUnsignedInteger64Bv(rhs))
    }
    static func & (lhs: UInt64, rhs: Z3BitVectorU64) -> Z3BitVectorU64 {
        return rhs.context.makeBvAnd(rhs.context.makeUnsignedInteger64Bv(lhs), rhs)
    }
    
    static func | (lhs: Z3BitVectorU64, rhs: UInt64) -> Z3BitVectorU64 {
        return lhs.context.makeBvOr(lhs, lhs.context.makeUnsignedInteger64Bv(rhs))
    }
    static func | (lhs: UInt64, rhs: Z3BitVectorU64) -> Z3BitVectorU64 {
        return rhs.context.makeBvOr(rhs.context.makeUnsignedInteger64Bv(lhs), rhs)
    }
    
    static func ^ (lhs: Z3BitVectorU64, rhs: UInt64) -> Z3BitVectorU64 {
        return lhs.context.makeBvXor(lhs, lhs.context.makeUnsignedInteger64Bv(rhs))
    }
    static func ^ (lhs: UInt64, rhs: Z3BitVectorU64) -> Z3BitVectorU64 {
        return rhs.context.makeBvXor(rhs.context.makeUnsignedInteger64Bv(lhs), rhs)
    }
    
    static func + (lhs: Z3BitVectorU64, rhs: UInt64) -> Z3BitVectorU64 {
        return lhs.context.makeBvAdd(lhs, lhs.context.makeUnsignedInteger64Bv(rhs))
    }
    static func + (lhs: UInt64, rhs: Z3BitVectorU64) -> Z3BitVectorU64 {
        return rhs.context.makeBvAdd(rhs.context.makeUnsignedInteger64Bv(lhs), rhs)
    }
    
    static func - (lhs: Z3BitVectorU64, rhs: UInt64) -> Z3BitVectorU64 {
        return lhs.context.makeBvSub(lhs, lhs.context.makeUnsignedInteger64Bv(rhs))
    }
    static func - (lhs: UInt64, rhs: Z3BitVectorU64) -> Z3BitVectorU64 {
        return rhs.context.makeBvSub(rhs.context.makeUnsignedInteger64Bv(lhs), rhs)
    }
    
    static func * (lhs: Z3BitVectorU64, rhs: UInt64) -> Z3BitVectorU64 {
        return lhs.context.makeBvMul(lhs, lhs.context.makeUnsignedInteger64Bv(rhs))
    }
    static func * (lhs: UInt64, rhs: Z3BitVectorU64) -> Z3BitVectorU64 {
        return rhs.context.makeBvMul(rhs.context.makeUnsignedInteger64Bv(lhs), rhs)
    }
    
    static func / (lhs: Z3BitVectorU64, rhs: UInt64) -> Z3BitVectorU64 {
        return lhs.context.makeBvDiv(lhs, lhs.context.makeUnsignedInteger64Bv(rhs))
    }
    static func / (lhs: UInt64, rhs: Z3BitVectorU64) -> Z3BitVectorU64 {
        return rhs.context.makeBvDiv(rhs.context.makeUnsignedInteger64Bv(lhs), rhs)
    }
    
    static func == (lhs: UInt64, rhs: Z3BitVectorU64) -> Z3Bool {
        let lhsInt = rhs.context.makeUnsignedInteger64Bv(lhs)
        return lhsInt == rhs
    }
    static func == (lhs: Z3BitVectorU64, rhs: UInt64) -> Z3Bool {
        let rhsInt = lhs.context.makeUnsignedInteger64Bv(rhs)
        return lhs == rhsInt
    }

    static func != (lhs: UInt64, rhs: Z3BitVectorU64) -> Z3Bool {
        let lhsInt = rhs.context.makeUnsignedInteger64Bv(lhs)
        return lhsInt != rhs
    }
    static func != (lhs: Z3BitVectorU64, rhs: UInt64) -> Z3Bool {
        let rhsInt = lhs.context.makeUnsignedInteger64Bv(rhs)
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
    static func < (lhs: Z3BitVectorU64, rhs: UInt64) -> Z3BitVectorU64 {
        return lhs.context.makeBvSlt(lhs, lhs.context.makeUnsignedInteger64Bv(rhs))
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
    static func < (lhs: UInt64, rhs: Z3BitVectorU64) -> Z3BitVectorU64 {
        return rhs.context.makeBvSlt(rhs.context.makeUnsignedInteger64Bv(lhs), rhs)
    }
    
    /// Two's complement signed less than or equal to.
    static func <= (lhs: Z3BitVectorU64, rhs: UInt64) -> Z3BitVectorU64 {
        return lhs.context.makeBvSle(lhs, lhs.context.makeUnsignedInteger64Bv(rhs))
    }
    /// Two's complement signed greater than or equal to.
    static func <= (lhs: UInt64, rhs: Z3BitVectorU64) -> Z3BitVectorU64 {
        return rhs.context.makeBvSle(rhs.context.makeUnsignedInteger64Bv(lhs), rhs)
    }
    
    /// Two's complement signed greater than.
    static func > (lhs: Z3BitVectorU64, rhs: UInt64) -> Z3BitVectorU64 {
        return lhs.context.makeBvSgt(lhs, lhs.context.makeUnsignedInteger64Bv(rhs))
    }
    /// Two's complement signed greater than or equal to.
    static func > (lhs: UInt64, rhs: Z3BitVectorU64) -> Z3BitVectorU64 {
        return rhs.context.makeBvSgt(rhs.context.makeUnsignedInteger64Bv(lhs), rhs)
    }
    
    /// Two's complement signed greater than or equal to.
    static func >= (lhs: Z3BitVectorU64, rhs: UInt64) -> Z3BitVectorU64 {
        return lhs.context.makeBvSge(lhs, lhs.context.makeUnsignedInteger64Bv(rhs))
    }
    /// Two's complement signed greater than or equal to.
    static func >= (lhs: UInt64, rhs: Z3BitVectorU64) -> Z3BitVectorU64 {
        return rhs.context.makeBvSge(rhs.context.makeUnsignedInteger64Bv(lhs), rhs)
    }
}
