/// A specialized BitVector AST type.
public typealias Z3BitVector<T> = Z3Ast<T> where T: BitVectorSort

public extension Z3BitVector {
    /// Gets the statically-typed Z3Sort associated with `T` from this
    /// `Z3BitVector<T>`.
    static func getSort(_ context: Z3Context) -> Z3Sort {
        T.getSort(context)
    }
}

public extension Z3BitVector {
    /// Create an integer from this bit-vector.
    ///
    /// If `isSigned` is false, then this bit-vector is treated as unsigned.
    /// So the result is non-negative and in the range `[0..2^N-1]`, where N are
    /// the number of bits in this bit-vector.
    /// If `isSigned` is true, this bit-vector is treated as a signed bit-vector.
    func toInt(isSigned: Bool) -> Z3Int {
        context.makeBvToInt(self, isSigned: isSigned)
    }

    static func & (lhs: Z3BitVector, rhs: Z3BitVector) -> Z3BitVector {
        return lhs.context.makeBvAnd(lhs, rhs)
    }
    
    static func | (lhs: Z3BitVector, rhs: Z3BitVector) -> Z3BitVector {
        return lhs.context.makeBvOr(lhs, rhs)
    }
    
    static func ^ (lhs: Z3BitVector, rhs: Z3BitVector) -> Z3BitVector {
        return lhs.context.makeBvXor(lhs, rhs)
    }
    
    static func + (lhs: Z3BitVector, rhs: Z3BitVector) -> Z3BitVector {
        return lhs.context.makeBvAdd(lhs, rhs)
    }
    
    static func - (lhs: Z3BitVector, rhs: Z3BitVector) -> Z3BitVector {
        return lhs.context.makeBvSub(lhs, rhs)
    }
    
    static func * (lhs: Z3BitVector, rhs: Z3BitVector) -> Z3BitVector {
        return lhs.context.makeBvMul(lhs, rhs)
    }
    
    static func / (lhs: Z3BitVector, rhs: Z3BitVector) -> Z3BitVector {
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
    static func < (lhs: Z3BitVector, rhs: Z3BitVector) -> Z3BitVector {
        return lhs.context.makeBvSlt(lhs, rhs)
    }
    
    /// Two's complement signed less than or equal to.
    static func <= (lhs: Z3BitVector, rhs: Z3BitVector) -> Z3BitVector {
        return lhs.context.makeBvSle(lhs, rhs)
    }
    
    /// Two's complement signed greater than.
    static func > (lhs: Z3BitVector, rhs: Z3BitVector) -> Z3BitVector {
        return lhs.context.makeBvSgt(lhs, rhs)
    }
    
    /// Two's complement signed greater than or equal to.
    static func >= (lhs: Z3BitVector, rhs: Z3BitVector) -> Z3BitVector {
        return lhs.context.makeBvSge(lhs, rhs)
    }
    
    static prefix func - (rhs: Z3BitVector) -> Z3BitVector {
        return rhs.context.makeBvNeg(rhs)
    }
    
    static prefix func ! (rhs: Z3BitVector) -> Z3BitVector {
        return rhs.context.makeBvNot(rhs)
    }
}
