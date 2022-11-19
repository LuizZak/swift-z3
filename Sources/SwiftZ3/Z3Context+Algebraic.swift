import CZ3

public extension Z3Context {
    // MARK: - Algebraic Numbers

    /// Returns `true` if `ast` can be used as value in the Z3 real algebraic
    /// number package.
    func algebraicIsValue(_ ast: Z3AstBase) -> Bool {
        Z3_algebraic_is_value(context, ast.ast)
    }

    /// Returns `true` if `ast` is positive, `false` otherwise.
    func algebraicIsPos(_ ast: Z3Algebraic) -> Bool {
        Z3_algebraic_is_pos(context, ast.ast)
    }

    /// Returns `true` if `ast` is negative, `false` otherwise.
    func algebraicIsNeg(_ ast: Z3Algebraic) -> Bool {
        Z3_algebraic_is_neg(context, ast.ast)
    }

    /// Returns `true` if `ast` is zero, `false` otherwise.
    func algebraicIsZero(_ ast: Z3Algebraic) -> Bool {
        Z3_algebraic_is_zero(context, ast.ast)
    }

    /// Returns `1` if `ast` is positive, `0` if `ast` is zero, and `-1` if it
    /// is negative.
    func algebraicSign(_ ast: Z3Algebraic) -> Int {
        Int(Z3_algebraic_sign(context, ast.ast))
    }

    /// Return the value lhs + rhs.
    func algebraicAdd(_ lhs: Z3Algebraic, _ rhs: Z3Algebraic) -> Z3Algebraic {
        Z3Algebraic(
            context: self,
            ast: Z3_algebraic_add(context, lhs.ast, rhs.ast)
        )
    }

    /// Return the value lhs - rhs.
    func algebraicSub(_ lhs: Z3Algebraic, _ rhs: Z3Algebraic) -> Z3Algebraic {
        Z3Algebraic(
            context: self,
            ast: Z3_algebraic_sub(context, lhs.ast, rhs.ast)
        )
    }

    /// Return the value lhs * rhs.
    func algebraicMul(_ lhs: Z3Algebraic, _ rhs: Z3Algebraic) -> Z3Algebraic {
        Z3Algebraic(
            context: self,
            ast: Z3_algebraic_mul(context, lhs.ast, rhs.ast)
        )
    }

    /// Return the value lhs / rhs.
    func algebraicDiv(_ lhs: Z3Algebraic, _ rhs: Z3Algebraic) -> Z3Algebraic {
        Z3Algebraic(
            context: self,
            ast: Z3_algebraic_div(context, lhs.ast, rhs.ast)
        )
    }

    /// Return the ast^(1/k)
    func algebraicRoot(_ ast: Z3Algebraic, _ k: UInt32) -> Z3Algebraic {
        Z3Algebraic(
            context: self,
            ast: Z3_algebraic_root(context, ast.ast, k)
        )
    }

    /// Return the ast^k
    func algebraicPower(_ ast: Z3Algebraic, _ k: UInt32) -> Z3Algebraic {
        Z3Algebraic(
            context: self,
            ast: Z3_algebraic_power(context, ast.ast, k)
        )
    }

    /// Return `true` if `lhs < rhs`, `false` otherwise.
    func algebraicLt(_ lhs: Z3Algebraic, _ rhs: Z3Algebraic) -> Bool {
        Z3_algebraic_lt(context, lhs.ast, rhs.ast)
    }

    /// Return `true` if `lhs > rhs`, `false` otherwise.
    func algebraicGt(_ lhs: Z3Algebraic, _ rhs: Z3Algebraic) -> Bool {
        Z3_algebraic_gt(context, lhs.ast, rhs.ast)
    }

    /// Return `true` if `lhs <= rhs`, `false` otherwise.
    func algebraicLe(_ lhs: Z3Algebraic, _ rhs: Z3Algebraic) -> Bool {
        Z3_algebraic_le(context, lhs.ast, rhs.ast)
    }

    /// Return `true` if `lhs >= rhs`, `false` otherwise.
    func algebraicGe(_ lhs: Z3Algebraic, _ rhs: Z3Algebraic) -> Bool {
        Z3_algebraic_ge(context, lhs.ast, rhs.ast)
    }

    /// Return `true` if `lhs == rhs`, `false` otherwise.
    func algebraicEq(_ lhs: Z3Algebraic, _ rhs: Z3Algebraic) -> Bool {
        Z3_algebraic_eq(context, lhs.ast, rhs.ast)
    }

    /// Return `true` if `lhs != rhs`, `false` otherwise.
    func algebraicNeq(_ lhs: Z3Algebraic, _ rhs: Z3Algebraic) -> Bool {
        Z3_algebraic_neq(context, lhs.ast, rhs.ast)
    }

    /// Given a multivariate polynomial `polynomial(x_0, ..., x_{n-1}, x_n)`, returns the
    /// roots of the univariate polynomial `polynomial(a[0], ..., a[n-1], x_n)`.
    ///
    /// - precondition: `polynomial`  is a Z3 expression that contains only
    /// arithmetic terms and free variables.
    func algebraicRoots(_ polynomial: Z3Algebraic, _ a: [Z3Algebraic]) -> Z3AstVector {
        var a = a.toZ3_astPointerArray()

        return Z3AstVector(
            context: self,
            astVector: Z3_algebraic_roots(
                context,
                polynomial.ast,
                UInt32(a.count),
                &a
            )
        )
    }

    /// Given a multivariate polynomial `polynomial(x_0, ..., x_{n-1})`, return
    /// the sign of `polynomial(a[0], ..., a[n-1])`.
    ///
    /// - precondition: `polynomial`  is a Z3 expression that contains only
    /// arithmetic terms and free variables.
    func algebraicEval(_ polynomial: Z3Algebraic, _ a: [Z3Algebraic]) -> Int {
        var a = a.toZ3_astPointerArray()

        return Int(
            Z3_algebraic_eval(
                context,
                polynomial.ast,
                UInt32(a.count),
                &a
            )
        )
    }

    /// Return the coefficients of the defining polynomial.
    func algebraicGetPoly(_ polynomial: Z3Algebraic) -> Z3AstVector {
        Z3AstVector(
            context: self,
            astVector: Z3_algebraic_get_poly(
                context,
                polynomial.ast
            )
        )
    }

    /// Return which root of the polynomial the algebraic number represents.
    func algebraicGetI(_ polynomial: Z3Algebraic) -> UInt32 {
        Z3_algebraic_get_i(
            context,
            polynomial.ast
        )
    }
}
