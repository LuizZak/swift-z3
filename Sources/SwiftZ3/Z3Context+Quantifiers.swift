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
    func makeBound(_ index: UInt32, _ ty: Z3Sort) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_bound(context, index, ty.sort))
    }
    
    /// Create a forall formula. It takes an expression `body` that contains
    /// bound variables of the same sorts as the sorts listed in the array
    /// `declarations`.
    /// The bound variables are de-Bruijn indices created using `makeBound`.
    /// The array `declarations` contains the names that the quantified formula
    /// uses for the bound variables. Z3 applies the convention that the last
    /// element in the `declarations` array refers to the variable with index 0,
    /// the second to last element of `declarations` refers to the variable with
    /// index 1, etc.
    ///
    /// - Parameters:
    ///   - weight: quantifiers are associated with weights indicating the
    ///   importance of using the quantifier during instantiation. By default,
    ///   pass the weight 0.
    ///   - patterns: array containing the patterns created using `makePattern`
    ///   - declarations: an array of declarations containing the sorts and names
    ///   of the bound variables.
    ///   - body: the body of the quantifier.
    ///
    /// - seealso: `makePattern`
    /// - seealso: `makeBound`
    /// - seealso: `makeExists`
    func makeForall(weight: UInt32,
                    patterns: [Z3Pattern],
                    declarations: [(Z3Sort, Z3Symbol)],
                    body: AnyZ3Ast) -> AnyZ3Ast {
        
        let patterns = patterns.toZ3_patternPointerArray()
        let sorts = declarations.map(\.0).toZ3_sortPointerArray()
        let symbols = declarations.map(\.1).toZ3_symbolPointerArray()
        
        let ast = Z3_mk_forall(context,
                               weight,
                               UInt32(patterns.count), patterns,
                               UInt32(declarations.count), sorts, symbols,
                               body.ast)
        
        return AnyZ3Ast(context: self, ast: ast!)
    }
    
    /// Create an exists formula. Similar to `makeForall`.
    ///
    /// - Parameters:
    ///   - weight: quantifiers are associated with weights indicating the
    ///   importance of using the quantifier during instantiation. By default,
    ///   pass the weight 0.
    ///   - patterns: array containing the patterns created using `makePattern`
    ///   - declarations: an array of declarations containing the sorts and names
    ///   of the bound variables.
    ///   - body: the body of the quantifier.
    ///
    /// - seealso: `makePattern`
    /// - seealso: `makeBound`
    /// - seealso: `makeForall`
    /// - seealso: `makeQuantifier`
    func makeExists(weight: UInt32,
                    patterns: [Z3Pattern],
                    declarations: [(Z3Sort, Z3Symbol)],
                    body: AnyZ3Ast) -> AnyZ3Ast {
        
        let patterns = patterns.toZ3_patternPointerArray()
        let sorts = declarations.map(\.0).toZ3_sortPointerArray()
        let symbols = declarations.map(\.1).toZ3_symbolPointerArray()
        
        let ast = Z3_mk_exists(context,
                               weight,
                               UInt32(patterns.count), patterns,
                               UInt32(declarations.count), sorts, symbols,
                               body.ast)
        
        return AnyZ3Ast(context: self, ast: ast!)
    }
    
    /// Create a quantifier - universal or existential, with pattern hints.
    ///
    /// - Parameters:
    ///   - isForall: flag to indicate if this is a universal or existential
    ///   quantifier.
    ///   - weight: quantifiers are associated with weights indicating the
    ///   importance of using the quantifier during instantiation. By default,
    ///   pass the weight 0.
    ///   - patterns: array containing the patterns created using `makePattern`
    ///   - declarations: an array of declarations containing the sorts and names
    ///   of the bound variables.
    ///   - body: the body of the quantifier.
    ///
    /// - seealso: `makePattern`
    /// - seealso: `makeBound`
    /// - seealso: `makeForall`
    /// - seealso: `makeExists`
    func makeQuantifier(isForall: Bool,
                        weight: UInt32,
                        patterns: [Z3Pattern],
                        declarations: [(Z3Sort, Z3Symbol)],
                        body: AnyZ3Ast) -> AnyZ3Ast {
        
        let patterns = patterns.toZ3_patternPointerArray()
        let sorts = declarations.map(\.0).toZ3_sortPointerArray()
        let symbols = declarations.map(\.1).toZ3_symbolPointerArray()
        
        let ast = Z3_mk_quantifier(context,
                                   isForall,
                                   weight,
                                   UInt32(patterns.count), patterns,
                                   UInt32(declarations.count), sorts, symbols,
                                   body.ast)
        
        return AnyZ3Ast(context: self, ast: ast!)
    }
}
