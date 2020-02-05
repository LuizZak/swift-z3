public extension Z3Ast {
    static func == (lhs: Z3Ast, rhs: Z3Ast) -> Z3Bool {
        return lhs.context.makeEqual(lhs, rhs)
    }
    
    static func != (lhs: Z3Ast, rhs: Z3Ast) -> Z3Bool {
        return lhs.context.makeNot(lhs.context.makeEqual(lhs, rhs))
    }

    /// Array read.
    subscript<D, R>(index: Z3Ast<D>) -> Z3Ast<R> where T == ArraySort<D, R> {
        return context.makeSelect(self, index)
    }
}

public extension Z3Ast where T == Bool {
    static prefix func ! (rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeNot(rhs)
    }
    
    static func && (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeAnd([lhs, rhs])
    }
    
    static func || (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeOr([lhs, rhs])
    }
}

public extension Z3Ast where T: IntOrRealSort {
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
}

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

public extension Z3Ast where T: FloatingSort {
    var squareRoot: Z3Ast {
        return context.makeFpaSquareRoot(context.currentFpaRoundingMode, self)
    }
    var isNormal: Z3Bool {
        return context.makeFpaIsNormal(self)
    }
    var isSubnormal: Z3Bool {
        return context.makeFpaIsSubnormal(self)
    }
    var isNan: Z3Bool {
        return context.makeFpaIsNan(self)
    }
    var isZero: Z3Bool {
        return context.makeFpaIsZero(self)
    }
    var isInfinite: Z3Bool {
        return context.makeFpaIsInfinite(self)
    }
    var isPositive: Z3Bool {
        return context.makeFpaIsPositive(self)
    }
    var isNegative: Z3Bool {
        return context.makeFpaIsNegative(self)
    }
    
    static prefix func - (rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeFpaNeg(rhs)
    }
    
    static func >= (lhs: Z3Ast, rhs: Z3Ast) -> Z3Bool {
        return lhs.context.makeFpaGeq(lhs, rhs)
    }
    
    static func > (lhs: Z3Ast, rhs: Z3Ast) -> Z3Bool {
        return lhs.context.makeFpaGt(lhs, rhs)
    }
    
    static func <= (lhs: Z3Ast, rhs: Z3Ast) -> Z3Bool {
        return lhs.context.makeFpaLeq(lhs, rhs)
    }
    
    static func < (lhs: Z3Ast, rhs: Z3Ast) -> Z3Bool {
        return lhs.context.makeFpaLt(lhs, rhs)
    }
    
    static func + (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeFpaAdd(lhs.context.currentFpaRoundingMode, lhs, rhs)
    }
    
    static func - (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeFpaSubtract(lhs.context.currentFpaRoundingMode, lhs, rhs)
    }
    
    static func * (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeFpaMultiply(lhs.context.currentFpaRoundingMode, lhs, rhs)
    }
    
    static func / (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeFpaDivide(lhs.context.currentFpaRoundingMode, lhs, rhs)
    }
}

public extension Z3Ast where T: FloatingSort, T: BinaryFloatingPoint, T: LosslessStringConvertible {
    // MARK: - Constants Casting
    static func == (lhs: T, rhs: Z3Ast) -> Z3Bool {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat == rhs
    }
    static func == (lhs: Z3Ast, rhs: T) -> Z3Bool {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs == rhsFloat
    }

    static func != (lhs: T, rhs: Z3Ast) -> Z3Bool {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat != rhs
    }
    static func != (lhs: Z3Ast, rhs: T) -> Z3Bool {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs != rhsFloat
    }

    static func >= (lhs: T, rhs: Z3Ast) -> Z3Bool {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat >= rhs
    }
    static func >= (lhs: Z3Ast, rhs: T) -> Z3Bool {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs >= rhsFloat
    }

    static func > (lhs: T, rhs: Z3Ast) -> Z3Bool {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat > rhs
    }
    static func > (lhs: Z3Ast, rhs: T) -> Z3Bool {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs > rhsFloat
    }

    static func <= (lhs: T, rhs: Z3Ast) -> Z3Bool {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat <= rhs
    }
    static func <= (lhs: Z3Ast, rhs: T) -> Z3Bool {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs <= rhsFloat
    }

    static func < (lhs: T, rhs: Z3Ast) -> Z3Bool {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat < rhs
    }
    static func < (lhs: Z3Ast, rhs: T) -> Z3Bool {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs < rhsFloat
    }

    static func + (lhs: T, rhs: Z3Ast) -> Z3Ast {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return rhs.context.makeFpaAdd(rhs.context.currentFpaRoundingMode, lhsFloat, rhs)
    }
    static func + (lhs: Z3Ast, rhs: T) -> Z3Ast {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs.context.makeFpaAdd(lhs.context.currentFpaRoundingMode, lhs, rhsFloat)
    }
    
    static func - (lhs: T, rhs: Z3Ast) -> Z3Ast {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return rhs.context.makeFpaSubtract(rhs.context.currentFpaRoundingMode, lhsFloat, rhs)
    }
    static func - (lhs: Z3Ast, rhs: T) -> Z3Ast {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs.context.makeFpaSubtract(lhs.context.currentFpaRoundingMode, lhs, rhsFloat)
    }
    
    static func * (lhs: T, rhs: Z3Ast) -> Z3Ast {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return rhs.context.makeFpaMultiply(rhs.context.currentFpaRoundingMode, lhsFloat, rhs)
    }
    static func * (lhs: Z3Ast, rhs: T) -> Z3Ast {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs.context.makeFpaMultiply(lhs.context.currentFpaRoundingMode, lhs, rhsFloat)
    }
    
    static func / (lhs: T, rhs: Z3Ast) -> Z3Ast {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return rhs.context.makeFpaDivide(rhs.context.currentFpaRoundingMode, lhsFloat, rhs)
    }
    static func / (lhs: Z3Ast, rhs: T) -> Z3Ast {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs.context.makeFpaDivide(lhs.context.currentFpaRoundingMode, lhs, rhsFloat)
    }
}
