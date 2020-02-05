import CZ3

public extension Z3Context {
    // MARK: - Qualifiers
    
    /// Create a pattern for quantifier instantiation.
    ///
    /// Z3 uses pattern matching to instantiate quantifiers. If a pattern is not
    /// provided for a quantifier, then Z3 will automatically compute a set of
    /// patterns for it. However, for optimal performance, the user should
    /// provide the patterns.
    ///
    /// Patterns comprise a list of terms. The list should be non-empty. If the
    /// list comprises of more than one term, it is a called a multi-pattern.
    ///
    /// In general, one can pass in a list of (multi-)patterns in the quantifier
    /// constructor.
    ///
    /// - seealso: `makeForAll`
    /// - seealso: `makeExists`
    func makePattern(_ terms: [AnyZ3Ast]) -> Z3Pattern {
        let terms = terms.toZ3_astPointerArray()
        
        let pattern = Z3_mk_pattern(context, UInt32(terms.count), terms)
        
        return Z3Pattern(context: self, pattern: pattern!)
    }
    
    /// Create a bound variable.
    ///
    /// Bound variables are indexed by de-Bruijn indices. It is perhaps easiest
    /// to explain the meaning of de-Bruijn indices by indicating the compilation
    /// process from non-de-Bruijn formulas to de-Bruijn format.
    ///
    /// ```
    /// abs(forall (x1) phi) = forall (x1) abs1(phi, x1, 0)
    /// abs(forall (x1, x2) phi) = abs(forall (x1) abs(forall (x2) phi))
    /// abs1(x, x, n) = b_n
    /// abs1(y, x, n) = y
    /// abs1(f(t1,...,tn), x, n) = f(abs1(t1,x,n), ..., abs1(tn,x,n))
    /// abs1(forall (x1) phi, x, n) = forall (x1) (abs1(phi, x, n+1))
    /// ```
    ///
    /// The last line is significant: the index of a bound variable is different
    /// depending on the scope in which it appears. The deeper x appears, the
    /// higher is its index.
    ///
    /// - Parameters:
    ///   - index: de-Bruijn index
    ///   - ty: sort of the bound variable
    /// - seealso: `makeForAll`
    /// - seealso: `makeExists`
    func makeBounds(_ index: UInt32, _ ty: Z3Sort) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_bound(context, index, ty.sort))
    }
}
