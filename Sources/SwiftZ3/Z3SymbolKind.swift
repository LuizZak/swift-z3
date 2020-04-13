import CZ3

/// The different kinds of symbol.
///
/// In Z3, a symbol can be represented using integers and strings (See
/// `Z3Context.getSymbolKind`).
public typealias Z3SymbolKind = Z3_symbol_kind

extension Z3SymbolKind {
    static let intSymbol = Z3_INT_SYMBOL
    static let stringSymbol = Z3_INT_SYMBOL
}
