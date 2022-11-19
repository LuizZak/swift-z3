import CZ3

public extension Z3Context {
    // MARK: - Polynomials

    /// Return the nonzero subresultants of `p` and `q` with respect to the
    /// "variable" `x`.
    /// 
    /// \pre `p`, `q` and `x` are Z3 expressions where `p` and `q` are arithmetic
    /// terms.
    /// Note that, any subterm that cannot be viewed as a polynomial is assumed
    /// to be a variable. Example: `f(a)` is a considered to be a variable in
    /// the polynomial `f(a)*f(a) + 2*f(a) + 1`
    func polynomialSubresultants<PSort: ArithmeticSort, QSort: ArithmeticSort>(
        _ p: Z3Ast<PSort>,
        _ q: Z3Ast<QSort>,
        _ x: AnyZ3Ast
    ) -> Z3AstVector? {

        guard let astVector = Z3_polynomial_subresultants(
            context,
            p.ast,
            q.ast,
            x.ast
        ) else {
            return nil
        }

        return Z3AstVector(
            context: self,
            astVector: astVector
        )
    }
}
