import Z3

public extension Z3Context {
    /// Create a Z3 symbol using an integer.
    ///
    /// Symbols are used to name several term and type constructors.
    ///
    /// NB. Not all integers can be passed to this function.
    /// The legal range of unsigned integers is 0 to 2^30-1.
    ///
    /// - seealso: `getSymbolInt`
    /// - seealso: `makeStringSymbol`
    func makeIntSymbol(_ i: Int32) -> Z3Symbol {
        return Z3_mk_int_symbol(context, i)
    }
    
    /// Create a Z3 symbol using a C string.
    ///
    /// Symbols are used to name several term and type constructors.
    ///
    /// - seealso: `getSymbolString`
    /// - seealso: `makeIntSymbol`
    func makeStringSymbol(_ s: String) -> Z3Symbol {
        return s.withCString { cString -> Z3Symbol in
            return Z3Symbol(symbol: Z3_mk_string_symbol(context, cString))
        }
    }
}
