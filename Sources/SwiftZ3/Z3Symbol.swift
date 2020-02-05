import CZ3

public class Z3Symbol {
    var context: Z3Context
    var symbol: Z3_symbol

    /// Return `Z3_INT_SYMBOL` if the symbol was constructed using `makeIntSymbol`,
    /// and `Z3_STRING_SYMBOL` if the symbol was constructed using `makeStringSymbol`.
    public var symbolKind: Z3SymbolKind {
        return Z3SymbolKind.fromZ3_symbol_kind(Z3_get_symbol_kind(context.context, symbol))
    }

    /// Return the symbol int value.
    ///
    /// - precondition: `symbolKind == Z3SymbolKind.intSymbol`
    public var symbolInt: Int32 {
        return Z3_get_symbol_int(context.context, symbol)
    }

    /// Return the symbol name.
    ///
    /// - precondition: `symbolKind == Z3SymbolKind.stringSymbol`
    /// - seealso: `makeStringSymbol`
    public var symbolString: String {
        return String(cString: Z3_get_symbol_string(context.context, symbol))
    }

    init(context: Z3Context, symbol: Z3_symbol) {
        self.context = context
        self.symbol = symbol
    }
}

internal extension Sequence where Element == Z3Symbol {
    func toZ3_symbolPointerArray() -> [Z3_symbol?] {
        return map { $0.symbol }
    }
}
