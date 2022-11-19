import CZ3

/// An algebraic number that can be used in the Z3 real algebraic number package.
public class Z3Algebraic: AnyZ3Ast {
    /// Returns `true` if `self` is positive, `false` otherwise.
    public var isPositive: Bool {
        context.algebraicIsPos(self)
    }

    /// Returns `true` if `self` is negative, `false` otherwise.
    public var isNegative: Bool {
        context.algebraicIsNeg(self)
    }

    /// Returns `true` if `self` is zero, `false` otherwise.
    public var isZero: Bool {
        context.algebraicIsZero(self)
    }

    /// Returns `1` if `self` is positive, `0` if `self` is zero, and `-1` if it
    /// is negative.
    public var sign: Int {
        context.algebraicSign(self)
    }

    /// Return the `self^(1/k)`
    public func root(_ k: UInt32) -> Z3Algebraic {
        context.algebraicRoot(self, k)
    }

    /// Return the `self^k`
    public func power(_ k: UInt32) -> Z3Algebraic {
        context.algebraicPower(self, k)
    }

    /// Given a multivariate polynomial `self(x_0, ..., x_{n-1}, x_n)`, returns
    /// the roots of the univariate polynomial `self(a[0], ..., a[n-1], x_n)`.
    ///
    /// - precondition: `self` is a Z3 expression that contains only arithmetic
    /// terms and free variables.
    public func roots(_ a: [Z3Algebraic]) -> Z3AstVector {
        context.algebraicRoots(self, a)
    }

    /// Given a multivariate polynomial `self(x_0, ..., x_{n-1})`, return the
    /// sign of `self(a[0], ..., a[n-1])`.
    ///
    /// - precondition: `self`  is a Z3 expression that contains only arithmetic
    /// terms and free variables.
    public func eval(_ a: [Z3Algebraic]) -> Int {
        context.algebraicEval(self, a)
    }

    /// Return the coefficients of this polynomial.
    public func coefficients() -> Z3AstVector {
        context.algebraicGetPoly(self)
    }

    /// Return which root of a polynomial the algebraic number represents.
    public func polynomialRootIndex() -> UInt32 {
        context.algebraicGetI(self)
    }
}

public extension AnyZ3Ast {
    /// An unsafe cast from a generic `AnyZ3Ast` to a `Z3Algebraic` type.
    func unsafeCastToAlgebraic() -> Z3Algebraic {
        Z3Algebraic(context: context, ast: ast)
    }

    /// A runtime type-checked cast from a generic `AnyZ3Ast` to a `Z3Algebraic`
    /// type.
    ///
    /// The underlying value is checked against `Z3Context.algebraicIsValue(_:)`,
    /// and if it succeeds, the return is a `Z3Algebraic` instance.
    func castToAlgebraic() -> Z3Algebraic? {
        if context.algebraicIsValue(self) {
            return Z3Algebraic(context: context, ast: ast)
        }

        return nil
    }
}

public extension Z3Algebraic {
    /// Return the value a + b.
    static func + (lhs: Z3Algebraic, rhs: Z3Algebraic) -> Z3Algebraic {
        lhs.context.algebraicAdd(lhs, rhs)
    }

    /// Return the value a - b.
    static func - (lhs: Z3Algebraic, rhs: Z3Algebraic) -> Z3Algebraic {
        lhs.context.algebraicSub(lhs, rhs)
    }

    /// Return the value a * b.
    static func * (lhs: Z3Algebraic, rhs: Z3Algebraic) -> Z3Algebraic {
        lhs.context.algebraicMul(lhs, rhs)
    }

    /// Return the value a / b.
    static func / (lhs: Z3Algebraic, rhs: Z3Algebraic) -> Z3Algebraic {
        lhs.context.algebraicDiv(lhs, rhs)
    }

    /// Return `true` if `lhs < rhs`, `false` otherwise.
    static func < (lhs: Z3Algebraic, rhs: Z3Algebraic) -> Bool {
        lhs.context.algebraicLt(lhs, rhs)
    }

    /// Return `true` if `lhs <= rhs`, `false` otherwise.
    static func <= (lhs: Z3Algebraic, rhs: Z3Algebraic) -> Bool {
        lhs.context.algebraicLe(lhs, rhs)
    }

    /// Return `true` if `lhs > rhs`, `false` otherwise.
    static func > (lhs: Z3Algebraic, rhs: Z3Algebraic) -> Bool {
        lhs.context.algebraicGt(lhs, rhs)
    }

    /// Return `true` if `lhs >= rhs`, `false` otherwise.
    static func >= (lhs: Z3Algebraic, rhs: Z3Algebraic) -> Bool {
        lhs.context.algebraicGe(lhs, rhs)
    }

    /// Return `true` if `lhs == rhs`, `false` otherwise.
    static func == (lhs: Z3Algebraic, rhs: Z3Algebraic) -> Bool {
        lhs.context.algebraicEq(lhs, rhs)
    }

    /// Return `true` if `lhs != rhs`, `false` otherwise.
    static func != (lhs: Z3Algebraic, rhs: Z3Algebraic) -> Bool {
        lhs.context.algebraicNeq(lhs, rhs)
    }
}
