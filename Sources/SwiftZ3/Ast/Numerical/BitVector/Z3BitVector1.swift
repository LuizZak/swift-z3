/// A typealias for a `Z3BitVector` with `BitVectorSort1` sort.
public typealias Z3BitVector1 = Z3BitVector<BitVectorSort1>

public extension Z3BitVector1 {
    // MARK: - Constants Casting

    static func & (lhs: Z3BitVector1, rhs: UInt32) -> Z3BitVector1 {
        return lhs.context.makeBvAnd(lhs, lhs.context.makeInteger1Bv(rhs))
    }
    static func & (lhs: UInt32, rhs: Z3BitVector1) -> Z3BitVector1 {
        return rhs.context.makeBvAnd(rhs.context.makeInteger1Bv(lhs), rhs)
    }
    
    static func | (lhs: Z3BitVector1, rhs: UInt32) -> Z3BitVector1 {
        return lhs.context.makeBvOr(lhs, lhs.context.makeInteger1Bv(rhs))
    }
    static func | (lhs: UInt32, rhs: Z3BitVector1) -> Z3BitVector1 {
        return rhs.context.makeBvOr(rhs.context.makeInteger1Bv(lhs), rhs)
    }
    
    static func ^ (lhs: Z3BitVector1, rhs: UInt32) -> Z3BitVector1 {
        return lhs.context.makeBvXor(lhs, lhs.context.makeInteger1Bv(rhs))
    }
    static func ^ (lhs: UInt32, rhs: Z3BitVector1) -> Z3BitVector1 {
        return rhs.context.makeBvXor(rhs.context.makeInteger1Bv(lhs), rhs)
    }
    
    static func + (lhs: Z3BitVector1, rhs: UInt32) -> Z3BitVector1 {
        return lhs.context.makeBvAdd(lhs, lhs.context.makeInteger1Bv(rhs))
    }
    static func + (lhs: UInt32, rhs: Z3BitVector1) -> Z3BitVector1 {
        return rhs.context.makeBvAdd(rhs.context.makeInteger1Bv(lhs), rhs)
    }
    
    static func - (lhs: Z3BitVector1, rhs: UInt32) -> Z3BitVector1 {
        return lhs.context.makeBvSub(lhs, lhs.context.makeInteger1Bv(rhs))
    }
    static func - (lhs: UInt32, rhs: Z3BitVector1) -> Z3BitVector1 {
        return rhs.context.makeBvSub(rhs.context.makeInteger1Bv(lhs), rhs)
    }
    
    static func * (lhs: Z3BitVector1, rhs: UInt32) -> Z3BitVector1 {
        return lhs.context.makeBvMul(lhs, lhs.context.makeInteger1Bv(rhs))
    }
    static func * (lhs: UInt32, rhs: Z3BitVector1) -> Z3BitVector1 {
        return rhs.context.makeBvMul(rhs.context.makeInteger1Bv(lhs), rhs)
    }
    
    static func / (lhs: Z3BitVector1, rhs: UInt32) -> Z3BitVector1 {
        return lhs.context.makeBvSDiv(lhs, lhs.context.makeInteger1Bv(rhs))
    }
    static func / (lhs: UInt32, rhs: Z3BitVector1) -> Z3BitVector1 {
        return rhs.context.makeBvSDiv(rhs.context.makeInteger1Bv(lhs), rhs)
    }
    
    static func == (lhs: UInt32, rhs: Z3BitVector1) -> Z3Bool {
        let lhsInt = rhs.context.makeInteger1Bv(lhs)
        return lhsInt == rhs
    }
    static func == (lhs: Z3BitVector1, rhs: UInt32) -> Z3Bool {
        let rhsInt = lhs.context.makeInteger1Bv(rhs)
        return lhs == rhsInt
    }

    static func != (lhs: UInt32, rhs: Z3BitVector1) -> Z3Bool {
        let lhsInt = rhs.context.makeInteger1Bv(lhs)
        return lhsInt != rhs
    }
    static func != (lhs: Z3BitVector1, rhs: UInt32) -> Z3Bool {
        let rhsInt = lhs.context.makeInteger1Bv(rhs)
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
    static func < (lhs: Z3BitVector1, rhs: UInt32) -> Z3BitVector1 {
        return lhs.context.makeBvSlt(lhs, lhs.context.makeInteger1Bv(rhs))
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
    static func < (lhs: UInt32, rhs: Z3BitVector1) -> Z3BitVector1 {
        return rhs.context.makeBvSlt(rhs.context.makeInteger1Bv(lhs), rhs)
    }
    
    /// Two's complement signed less than or equal to.
    static func <= (lhs: Z3BitVector1, rhs: UInt32) -> Z3BitVector1 {
        return lhs.context.makeBvSle(lhs, lhs.context.makeInteger1Bv(rhs))
    }
    /// Two's complement signed greater than or equal to.
    static func <= (lhs: UInt32, rhs: Z3BitVector1) -> Z3BitVector1 {
        return rhs.context.makeBvSle(rhs.context.makeInteger1Bv(lhs), rhs)
    }
    
    /// Two's complement signed greater than.
    static func > (lhs: Z3BitVector1, rhs: UInt32) -> Z3BitVector1 {
        return lhs.context.makeBvSgt(lhs, lhs.context.makeInteger1Bv(rhs))
    }
    /// Two's complement signed greater than or equal to.
    static func > (lhs: UInt32, rhs: Z3BitVector1) -> Z3BitVector1 {
        return rhs.context.makeBvSgt(rhs.context.makeInteger1Bv(lhs), rhs)
    }
    
    /// Two's complement signed greater than or equal to.
    static func >= (lhs: Z3BitVector1, rhs: UInt32) -> Z3BitVector1 {
        return lhs.context.makeBvSge(lhs, lhs.context.makeInteger1Bv(rhs))
    }
    /// Two's complement signed greater than or equal to.
    static func >= (lhs: UInt32, rhs: Z3BitVector1) -> Z3BitVector1 {
        return rhs.context.makeBvSge(rhs.context.makeInteger1Bv(lhs), rhs)
    }
}
