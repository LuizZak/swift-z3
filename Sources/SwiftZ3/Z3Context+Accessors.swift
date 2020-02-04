import Z3

public extension Z3Context {
    /// Return `Z3_INT_SYMBOL` if the symbol was constructed using `makeIntSymbol`,
    /// and `Z3_STRING_SYMBOL` if the symbol was constructed using `makeStringSymbol`.
    func getSymbolKind(_ symbol: Z3Symbol) -> Z3_symbol_kind {
        return Z3_get_symbol_kind(context, symbol.symbol)
    }

    /// Return the symbol int value.
    ///
    /// - precondition: `getSymbolKind(s) == Z3_INT_SYMBOL`
    func getSymbolInt(_ symbol: Z3Symbol) -> Int32 {
        return Z3_get_symbol_int(context, symbol.symbol)
    }

    /// Return the symbol name.
    ///
    /// - precondition: `getSymbolKind(s) == Z3_STRING_SYMBOL`
    /// - warning: The returned buffer is statically allocated by Z3. It will
    /// be automatically deallocated when `Z3Context.deinit` is invoked.
    /// So, the buffer is invalidated in the next call to `getSymbolString`.
    ///
    /// - seealso: `makeStringSymbol`
    func getSymbolString(_ symbol: Z3Symbol) -> String {
        return String(cString: Z3_get_symbol_string(context, symbol.symbol))
    }

    /// Return the sort name as a symbol.
    func getSortName(_ sort: Z3Sort) -> Z3Symbol {
        return Z3Symbol(symbol: Z3_get_sort_name(context, sort.sort))
    }

    /// Return the sort kind (e.g., array, tuple, int, bool, etc).
    ///
    /// - seealso: `Z3_sort_kind`
    func getSortKind(_ sort: Z3Sort) -> Z3_sort_kind {
        return Z3_get_sort_kind(context, sort.sort)
    }

    /// Return the size of the given bit-vector sort.
    ///
    /// - precondition: `getSortKind(t) == Z3_BV_SORT`
    /// - seealso: `makeBvSort`
    /// - seealso: `getSortKind`
    func getBvSortSize(_ sort: Z3Sort) -> UInt32 {
        return Z3_get_bv_sort_size(context, sort.sort)
    }
}
