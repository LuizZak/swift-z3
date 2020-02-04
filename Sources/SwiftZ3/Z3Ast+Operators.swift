public extension Z3Ast {
    static func == (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast<BoolSort> {
        return lhs.context.makeEqual(lhs, rhs)
    }
    
    static func != (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast<BoolSort> {
        return lhs.context.makeNot(lhs.context.makeEqual(lhs, rhs))
    }
}

public extension Z3Ast where T == BoolSort {
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

public extension Z3Ast where T: FloatingSort {
    var squareRoot: Z3Ast {
        return context.makeFpaSquareRoot(context.currentFpaRoundingMode, self)
    }
    var isNormal: Z3Ast<BoolSort> {
        return context.makeFpaIsNormal(self)
    }
    var isSubnormal: Z3Ast<BoolSort> {
        return context.makeFpaIsSubnormal(self)
    }
    var isNan: Z3Ast<BoolSort> {
        return context.makeFpaIsNan(self)
    }
    var isZero: Z3Ast<BoolSort> {
        return context.makeFpaIsZero(self)
    }
    var isInfinite: Z3Ast<BoolSort> {
        return context.makeFpaIsInfinite(self)
    }
    var isPositive: Z3Ast<BoolSort> {
        return context.makeFpaIsPositive(self)
    }
    var isNegative: Z3Ast<BoolSort> {
        return context.makeFpaIsNegative(self)
    }
    
    static prefix func - (rhs: Z3Ast) -> Z3Ast {
        return rhs.context.makeFpaNeg(rhs)
    }
    
    static func >= (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast<BoolSort> {
        return lhs.context.makeFpaGeq(lhs, rhs)
    }
    
    static func > (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast<BoolSort> {
        return lhs.context.makeFpaGt(lhs, rhs)
    }
    
    static func <= (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast<BoolSort> {
        return lhs.context.makeFpaLeq(lhs, rhs)
    }
    
    static func < (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast<BoolSort> {
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

// MARK: - Constants Casting
extension Z3Ast where T == FP32Sort {
    static func + (lhs: Float, rhs: Z3Ast) -> Z3Ast {
        let lhsFloat = rhs.context.makeFpaNumeralFloat(lhs, sort: T.self)
        return rhs.context.makeFpaAdd(rhs.context.currentFpaRoundingMode, lhsFloat, rhs)
    }
    static func + (lhs: Z3Ast, rhs: Float) -> Z3Ast {
        let rhsFloat = lhs.context.makeFpaNumeralFloat(rhs, sort: T.self)
        return lhs.context.makeFpaAdd(lhs.context.currentFpaRoundingMode, lhs, rhsFloat)
    }
    
    static func - (lhs: Float, rhs: Z3Ast) -> Z3Ast {
        let lhsFloat = rhs.context.makeFpaNumeralFloat(lhs, sort: T.self)
        return rhs.context.makeFpaSubtract(rhs.context.currentFpaRoundingMode, lhsFloat, rhs)
    }
    static func - (lhs: Z3Ast, rhs: Float) -> Z3Ast {
        let rhsFloat = lhs.context.makeFpaNumeralFloat(rhs, sort: T.self)
        return lhs.context.makeFpaSubtract(lhs.context.currentFpaRoundingMode, lhs, rhsFloat)
    }
    
    static func * (lhs: Float, rhs: Z3Ast) -> Z3Ast {
        let lhsFloat = rhs.context.makeFpaNumeralFloat(lhs, sort: T.self)
        return rhs.context.makeFpaMultiply(rhs.context.currentFpaRoundingMode, lhsFloat, rhs)
    }
    static func * (lhs: Z3Ast, rhs: Float) -> Z3Ast {
        let rhsFloat = lhs.context.makeFpaNumeralFloat(rhs, sort: T.self)
        return lhs.context.makeFpaMultiply(lhs.context.currentFpaRoundingMode, lhs, rhsFloat)
    }
    
    static func / (lhs: Float, rhs: Z3Ast) -> Z3Ast {
        let lhsFloat = rhs.context.makeFpaNumeralFloat(lhs, sort: T.self)
        return rhs.context.makeFpaDivide(rhs.context.currentFpaRoundingMode, lhsFloat, rhs)
    }
    static func / (lhs: Z3Ast, rhs: Float) -> Z3Ast {
        let rhsFloat = lhs.context.makeFpaNumeralFloat(rhs, sort: T.self)
        return lhs.context.makeFpaDivide(lhs.context.currentFpaRoundingMode, lhs, rhsFloat)
    }
}

extension Z3Ast where T == FP64Sort {
    static func + (lhs: Double, rhs: Z3Ast) -> Z3Ast {
        let lhsFloat = rhs.context.makeFpaNumeralDouble(lhs, sort: T.self)
        return rhs.context.makeFpaAdd(rhs.context.currentFpaRoundingMode, lhsFloat, rhs)
    }
    static func + (lhs: Z3Ast, rhs: Double) -> Z3Ast {
        let rhsFloat = lhs.context.makeFpaNumeralDouble(rhs, sort: T.self)
        return lhs.context.makeFpaAdd(lhs.context.currentFpaRoundingMode, lhs, rhsFloat)
    }
    
    static func - (lhs: Double, rhs: Z3Ast) -> Z3Ast {
        let lhsFloat = rhs.context.makeFpaNumeralDouble(lhs, sort: T.self)
        return rhs.context.makeFpaSubtract(rhs.context.currentFpaRoundingMode, lhsFloat, rhs)
    }
    static func - (lhs: Z3Ast, rhs: Double) -> Z3Ast {
        let rhsFloat = lhs.context.makeFpaNumeralDouble(rhs, sort: T.self)
        return lhs.context.makeFpaSubtract(lhs.context.currentFpaRoundingMode, lhs, rhsFloat)
    }
    
    static func * (lhs: Double, rhs: Z3Ast) -> Z3Ast {
        let lhsFloat = rhs.context.makeFpaNumeralDouble(lhs, sort: T.self)
        return rhs.context.makeFpaMultiply(rhs.context.currentFpaRoundingMode, lhsFloat, rhs)
    }
    static func * (lhs: Z3Ast, rhs: Double) -> Z3Ast {
        let rhsFloat = lhs.context.makeFpaNumeralDouble(rhs, sort: T.self)
        return lhs.context.makeFpaMultiply(lhs.context.currentFpaRoundingMode, lhs, rhsFloat)
    }
    
    static func / (lhs: Double, rhs: Z3Ast) -> Z3Ast {
        let lhsFloat = rhs.context.makeFpaNumeralDouble(lhs, sort: T.self)
        return rhs.context.makeFpaDivide(rhs.context.currentFpaRoundingMode, lhsFloat, rhs)
    }
    static func / (lhs: Z3Ast, rhs: Double) -> Z3Ast {
        let rhsFloat = lhs.context.makeFpaNumeralDouble(rhs, sort: T.self)
        return lhs.context.makeFpaDivide(lhs.context.currentFpaRoundingMode, lhs, rhsFloat)
    }
}
