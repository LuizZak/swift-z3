/// A typealias for a `Z3BitVector` with `BitVectorSortUnsigned32` sort.
public typealias Z3BitVectorU32 = Z3BitVector<BitVectorSortUnsigned32>

public extension Z3BitVectorU32 {
    // MARK: - Unsigned division
    
    static func / (lhs: Z3BitVectorU32, rhs: Z3BitVectorU32) -> Z3BitVectorU32 {
        return lhs.context.makeBvDiv(lhs, rhs)
    }

    // MARK: - Constants Casting

    static func & (lhs: Z3BitVectorU32, rhs: UInt32) -> Z3BitVectorU32 {
        return lhs.context.makeBvAnd(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    static func & (lhs: UInt32, rhs: Z3BitVectorU32) -> Z3BitVectorU32 {
        return rhs.context.makeBvAnd(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    static func | (lhs: Z3BitVectorU32, rhs: UInt32) -> Z3BitVectorU32 {
        return lhs.context.makeBvOr(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    static func | (lhs: UInt32, rhs: Z3BitVectorU32) -> Z3BitVectorU32 {
        return rhs.context.makeBvOr(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    static func ^ (lhs: Z3BitVectorU32, rhs: UInt32) -> Z3BitVectorU32 {
        return lhs.context.makeBvXor(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    static func ^ (lhs: UInt32, rhs: Z3BitVectorU32) -> Z3BitVectorU32 {
        return rhs.context.makeBvXor(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    static func + (lhs: Z3BitVectorU32, rhs: UInt32) -> Z3BitVectorU32 {
        return lhs.context.makeBvAdd(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    static func + (lhs: UInt32, rhs: Z3BitVectorU32) -> Z3BitVectorU32 {
        return rhs.context.makeBvAdd(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    static func - (lhs: Z3BitVectorU32, rhs: UInt32) -> Z3BitVectorU32 {
        return lhs.context.makeBvSub(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    static func - (lhs: UInt32, rhs: Z3BitVectorU32) -> Z3BitVectorU32 {
        return rhs.context.makeBvSub(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    static func * (lhs: Z3BitVectorU32, rhs: UInt32) -> Z3BitVectorU32 {
        return lhs.context.makeBvMul(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    static func * (lhs: UInt32, rhs: Z3BitVectorU32) -> Z3BitVectorU32 {
        return rhs.context.makeBvMul(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    static func / (lhs: Z3BitVectorU32, rhs: UInt32) -> Z3BitVectorU32 {
        return lhs.context.makeBvDiv(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    static func / (lhs: UInt32, rhs: Z3BitVectorU32) -> Z3BitVectorU32 {
        return rhs.context.makeBvDiv(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    static func == (lhs: UInt32, rhs: Z3BitVectorU32) -> Z3Bool {
        let lhsInt = rhs.context.makeUnsignedIntegerBv(lhs)
        return lhsInt == rhs
    }
    static func == (lhs: Z3BitVectorU32, rhs: UInt32) -> Z3Bool {
        let rhsInt = lhs.context.makeUnsignedIntegerBv(rhs)
        return lhs == rhsInt
    }

    static func != (lhs: UInt32, rhs: Z3BitVectorU32) -> Z3Bool {
        let lhsInt = rhs.context.makeUnsignedIntegerBv(lhs)
        return lhsInt != rhs
    }
    static func != (lhs: Z3BitVectorU32, rhs: UInt32) -> Z3Bool {
        let rhsInt = lhs.context.makeUnsignedIntegerBv(rhs)
        return lhs != rhsInt
    }

    /// Unsigned less than.
    ///
    /// It abbreviates:
    ///
    /// ```
    /// (or (and (= (extract[|m-1|:|m-1|] t1) bit1)
    ///         (= (extract[|m-1|:|m-1|] t2) bit0))
    ///     (and (= (extract[|m-1|:|m-1|] t1) (extract[|m-1|:|m-1|] t2))
    ///         (bvult t1 t2)))
    /// ```
    static func < (lhs: Z3BitVectorU32, rhs: UInt32) -> Z3Bool {
        return lhs.context.makeBvUlt(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    /// Unsigned less than.
    ///
    /// It abbreviates:
    ///
    /// ```
    /// (or (and (= (extract[|m-1|:|m-1|] t1) bit1)
    ///         (= (extract[|m-1|:|m-1|] t2) bit0))
    ///     (and (= (extract[|m-1|:|m-1|] t1) (extract[|m-1|:|m-1|] t2))
    ///         (bvult t1 t2)))
    /// ```
    static func < (lhs: UInt32, rhs: Z3BitVectorU32) -> Z3Bool {
        return rhs.context.makeBvUlt(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    /// Unsigned less than or equal to.
    static func <= (lhs: Z3BitVectorU32, rhs: UInt32) -> Z3Bool {
        return lhs.context.makeBvUle(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    /// Unsigned greater than or equal to.
    static func <= (lhs: UInt32, rhs: Z3BitVectorU32) -> Z3Bool {
        return rhs.context.makeBvUle(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    /// Unsigned greater than.
    static func > (lhs: Z3BitVectorU32, rhs: UInt32) -> Z3Bool {
        return lhs.context.makeBvUgt(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    /// Unsigned greater than or equal to.
    static func > (lhs: UInt32, rhs: Z3BitVectorU32) -> Z3Bool {
        return rhs.context.makeBvUgt(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
    
    /// Unsigned greater than or equal to.
    static func >= (lhs: Z3BitVectorU32, rhs: UInt32) -> Z3Bool {
        return lhs.context.makeBvUge(lhs, lhs.context.makeUnsignedIntegerBv(rhs))
    }
    /// Unsigned greater than or equal to.
    static func >= (lhs: UInt32, rhs: Z3BitVectorU32) -> Z3Bool {
        return rhs.context.makeBvUge(rhs.context.makeUnsignedIntegerBv(lhs), rhs)
    }
}
