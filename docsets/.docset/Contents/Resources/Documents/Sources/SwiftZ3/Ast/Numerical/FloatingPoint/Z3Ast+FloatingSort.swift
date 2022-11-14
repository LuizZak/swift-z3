/// A typealias for general Floating Point-sort ASTs
public typealias Z3FloatingPoint<T> = Z3Ast<T> where T: FloatingSort

/// A 32-bit precision floating-point AST type.
public typealias Z3Float = Z3FloatingPoint<Float>

/// A 64-bit precision floating-point AST type.
public typealias Z3Double = Z3FloatingPoint<Double>

public extension Z3FloatingPoint {
    /// Floating-point square root.
    var squareRoot: Z3Ast {
        return context.makeFpaSquareRoot(context.currentFpaRoundingMode, self)
    }
    
    /// Predicate indicating whether `t` is a normal floating-point number.
    var isNormal: Z3Bool {
        return context.makeFpaIsNormal(self)
    }

    /// Predicate indicating whether `t` is a subnormal floating-point number.
    var isSubnormal: Z3Bool {
        return context.makeFpaIsSubnormal(self)
    }

    /// Predicate indicating whether `t` is a NaN.
    var isNan: Z3Bool {
        return context.makeFpaIsNan(self)
    }
    
    /// Predicate indicating whether `t` is a floating-point number with zero
    /// value, i.e., +zero or -zero.
    var isZero: Z3Bool {
        return context.makeFpaIsZero(self)
    }

    /// Predicate indicating whether `t` is a floating-point number representing
    /// +oo or -oo.
    var isInfinite: Z3Bool {
        return context.makeFpaIsInfinite(self)
    }

    /// Predicate indicating whether `t` is a positive floating-point number.
    var isPositive: Z3Bool {
        return context.makeFpaIsPositive(self)
    }

    /// Predicate indicating whether `t` is a negative floating-point number.
    var isNegative: Z3Bool {
        return context.makeFpaIsNegative(self)
    }

    /// Checks whether this floating-point numeral is a NaN.
    var isNumeralNormal: Bool {
        return context.fpaIsNumeralNormal(self)
    }

    /// Checks whether this floating-point numeral is a +oo or -oo.
    var isNumeralSubnormal: Bool {
        return context.fpaIsNumeralSubnormal(self)
    }

    /// Checks whether this floating-point numeral is +zero or -zero.
    var isNumeralNan: Bool {
        return context.fpaIsNumeralNan(self)
    }
    
    /// Checks whether this floating-point numeral is normal.
    var isNumeralZero: Bool {
        return context.fpaIsNumeralZero(self)
    }

    /// Checks whether this floating-point numeral is subnormal.
    var isNumeralInfinite: Bool {
        return context.fpaIsNumeralInfinite(self)
    }

    /// Checks whether this floating-point numeral is positive.
    var isNumeralPositive: Bool {
        return context.fpaIsNumeralPositive(self)
    }

    /// Checks whether this floating-point numeral is negative.
    var isNumeralNegative: Bool {
        return context.fpaIsNumeralNegative(self)
    }

    /// Conversion of a FloatingPoint term into another term of different
    /// FloatingPoint sort.
    ///
    /// Produces a term that represents the conversion of this floating-point term 
    /// to a floating-point term of sort `sort`. If necessary, the result will
    /// be rounded according to rounding mode `roundingMode`.
    func convertTo<U: FloatingSort>(roundingMode: Z3Ast<RoundingModeSort>, sort: U.Type) -> Z3FloatingPoint<U> {
        context.makeFpaToFPFloat(roundingMode, self, sort: sort)
    }

    /// Conversion of a FloatingPoint term into another term of different
    /// FloatingPoint sort.
    ///
    /// Produces a term that represents the conversion of this floating-point term 
    /// to a floating-point term of sort `sort`. If necessary, the result will
    /// be rounded according to rounding mode `roundingMode`.
    ///
    /// Type-erased version.
    func convertToAny(roundingMode: Z3Ast<RoundingModeSort>, sort: Z3Sort) -> AnyZ3Ast {
        context.makeFpaToFPFloatAny(roundingMode, self, sort: sort)
    }

    /// Conversion of a floating-point term into a real-numbered term.
    ///
    /// Produces a term that represents the conversion of this floating-point term
    /// into a real number. Note that this type of conversion will often result
    /// in non-linear constraints over real terms.
    func convertToReal() -> Z3Real {
        context.makeFpaToReal(self)
    }

    /// Produces a term that represents the conversion of this floating-point term
    /// into a bit-vector term of bitWidth `T.bitWidth` in 2's complement
    /// format (signed when signed==true). If necessary, the result will be
    /// rounded according to rounding mode `roundingMode`.
    func convertToBitVector<BV: BitVectorSort>(roundingMode: Z3Ast<RoundingModeSort>, sort: BV.Type = BV.self, signed: Bool) -> Z3BitVector<BV> {
        context.makeFpaToBv(roundingMode, self, sort, signed: signed)
    }

    /// Produces a term that represents the conversion of this floating-point term
    /// into a bit-vector term of bitWidth `T.bitWidth` into a bit-vector term
    /// of size `sz` in 2's complement format (signed when signed==true). If
    /// necessary, the result will be rounded according to rounding mode rm.
    func convertToBitVectorAny(roundingMode: Z3Ast<RoundingModeSort>, _ sz: UInt32, signed: Bool) -> AnyZ3Ast {
        context.makeFpaToBvAny(roundingMode, self, sz, signed: signed)
    }
    
    static prefix func - (rhs: Z3FloatingPoint) -> Z3FloatingPoint {
        return rhs.context.makeFpaNeg(rhs)
    }
    
    static func >= (lhs: Z3FloatingPoint, rhs: Z3FloatingPoint) -> Z3Bool {
        return lhs.context.makeFpaGeq(lhs, rhs)
    }
    
    static func > (lhs: Z3FloatingPoint, rhs: Z3FloatingPoint) -> Z3Bool {
        return lhs.context.makeFpaGt(lhs, rhs)
    }
    
    static func <= (lhs: Z3FloatingPoint, rhs: Z3FloatingPoint) -> Z3Bool {
        return lhs.context.makeFpaLeq(lhs, rhs)
    }
    
    static func < (lhs: Z3FloatingPoint, rhs: Z3FloatingPoint) -> Z3Bool {
        return lhs.context.makeFpaLt(lhs, rhs)
    }
    
    static func + (lhs: Z3FloatingPoint, rhs: Z3FloatingPoint) -> Z3FloatingPoint {
        return lhs.context.makeFpaAdd(lhs.context.currentFpaRoundingMode, lhs, rhs)
    }
    
    static func - (lhs: Z3FloatingPoint, rhs: Z3FloatingPoint) -> Z3FloatingPoint {
        return lhs.context.makeFpaSubtract(lhs.context.currentFpaRoundingMode, lhs, rhs)
    }
    
    static func * (lhs: Z3FloatingPoint, rhs: Z3FloatingPoint) -> Z3FloatingPoint {
        return lhs.context.makeFpaMultiply(lhs.context.currentFpaRoundingMode, lhs, rhs)
    }
    
    static func / (lhs: Z3FloatingPoint, rhs: Z3FloatingPoint) -> Z3FloatingPoint {
        return lhs.context.makeFpaDivide(lhs.context.currentFpaRoundingMode, lhs, rhs)
    }

    static func % (lhs: Z3FloatingPoint, rhs: Z3FloatingPoint) -> Z3FloatingPoint {
        return lhs.context.makeFpaRemainder(lhs, rhs)
    }
}

public extension Z3FloatingPoint where T: FloatingSort, T: BinaryFloatingPoint, T: LosslessStringConvertible {
    // MARK: - Constants Casting
    static func == (lhs: T, rhs: Z3FloatingPoint) -> Z3Bool {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat == rhs
    }
    static func == (lhs: Z3FloatingPoint, rhs: T) -> Z3Bool {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs == rhsFloat
    }

    static func != (lhs: T, rhs: Z3FloatingPoint) -> Z3Bool {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat != rhs
    }
    static func != (lhs: Z3FloatingPoint, rhs: T) -> Z3Bool {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs != rhsFloat
    }

    static func >= (lhs: T, rhs: Z3FloatingPoint) -> Z3Bool {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat >= rhs
    }
    static func >= (lhs: Z3FloatingPoint, rhs: T) -> Z3Bool {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs >= rhsFloat
    }

    static func > (lhs: T, rhs: Z3FloatingPoint) -> Z3Bool {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat > rhs
    }
    static func > (lhs: Z3FloatingPoint, rhs: T) -> Z3Bool {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs > rhsFloat
    }

    static func <= (lhs: T, rhs: Z3FloatingPoint) -> Z3Bool {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat <= rhs
    }
    static func <= (lhs: Z3FloatingPoint, rhs: T) -> Z3Bool {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs <= rhsFloat
    }

    static func < (lhs: T, rhs: Z3FloatingPoint) -> Z3Bool {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat < rhs
    }
    static func < (lhs: Z3FloatingPoint, rhs: T) -> Z3Bool {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs < rhsFloat
    }

    static func + (lhs: T, rhs: Z3FloatingPoint) -> Z3FloatingPoint {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat + rhs
    }
    static func + (lhs: Z3FloatingPoint, rhs: T) -> Z3FloatingPoint {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs + rhsFloat
    }
    
    static func - (lhs: T, rhs: Z3FloatingPoint) -> Z3FloatingPoint {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat - rhs
    }
    static func - (lhs: Z3FloatingPoint, rhs: T) -> Z3FloatingPoint {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs - rhsFloat
    }
    
    static func * (lhs: T, rhs: Z3FloatingPoint) -> Z3FloatingPoint {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat * rhs
    }
    static func * (lhs: Z3FloatingPoint, rhs: T) -> Z3FloatingPoint {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs * rhsFloat
    }
    
    static func / (lhs: T, rhs: Z3FloatingPoint) -> Z3FloatingPoint {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat / rhs
    }
    static func / (lhs: Z3Ast, rhs: T) -> Z3Ast {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs / rhsFloat
    }

    static func % (lhs: Z3FloatingPoint, rhs: T) -> Z3FloatingPoint {
        let rhsFloat = lhs.context.makeFpaNumeral(rhs)
        return lhs % rhsFloat
    }
    static func % (lhs: T, rhs: Z3FloatingPoint) -> Z3FloatingPoint {
        let lhsFloat = rhs.context.makeFpaNumeral(lhs)
        return lhsFloat % rhs
    }
}

/// Creates a floating-point absolute value AST for a given floating point.
public func abs<T: FloatingSort>(_ ast: Z3FloatingPoint<T>) -> Z3FloatingPoint<T> {
    ast.context.makeFpaAbs(ast)
}

/// Creates an AST for the minimum of two floating-point numbers.
public func min<T: FloatingSort>(_ v1: Z3FloatingPoint<T>, _ v2: Z3FloatingPoint<T>) -> Z3FloatingPoint<T> {
    v1.context.makeFpaMin(v1, v2)
}

/// Creates an AST for the maximum of two floating-point numbers.
public func max<T: FloatingSort>(_ v1: Z3FloatingPoint<T>, _ v2: Z3FloatingPoint<T>) -> Z3FloatingPoint<T> {
    v1.context.makeFpaMax(v1, v2)
}
