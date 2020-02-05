import CZ3

public enum Z3SymbolKind: UInt32 {
    case intSymbol
    case stringSymbol
}

public extension Z3SymbolKind {
    var toZ3_symbol_kind: Z3_symbol_kind {
        return Z3_symbol_kind(rawValue)
    }

    static func fromZ3_symbol_kind(_ value: Z3_symbol_kind) -> Z3SymbolKind {
        return Z3SymbolKind(rawValue: value.rawValue) ?? .intSymbol
    }
}
