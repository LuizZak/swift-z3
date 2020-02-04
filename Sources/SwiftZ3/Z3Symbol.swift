import CZ3

public class Z3Symbol {
    var symbol: Z3_symbol

    init(symbol: Z3_symbol) {
        self.symbol = symbol
    }
}

internal extension Sequence where Element == Z3Symbol {
    func toZ3_symbolPointerArray() -> [Z3_symbol?] {
        return map { $0.symbol }
    }
}
