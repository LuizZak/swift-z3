/// A typealias for general Floating Point-sort ASTs
public typealias Z3FloatingPoint<T> = Z3Ast<T> where T: FloatingSort

/// A 32-bit precision floating-point AST type.
public typealias Z3Float = Z3FloatingPoint<Float>

/// A 64-bit precision floating-point AST type.
public typealias Z3Double = Z3FloatingPoint<Double>

public extension Z3FloatingPoint {
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
}
